# Use a base image with Python and Jupyter
FROM jupyter/scipy-notebook:latest

# Maintainer info
LABEL maintainer="walkerjian@walkerjian.com"

USER root

# Update and install required system packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    gcc \
    g++ \
    git \
    wget \
    libx11-dev \
    libxt-dev \
    libxext-dev \
    libsm-dev \
    x11proto-core-dev \
    libncurses5-dev \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for IRAF
ENV IRAF=/iraf/iraf/
ENV home=/home/jovyan/
ENV PATH=$IRAF/bin.linux:$PATH

# Install IRAF
RUN mkdir /iraf && cd /iraf && wget http://iraf.noao.edu/iraf/v216/PCIX/iraf.lnux.x86_64.tar.gz && tar -xzvf iraf.lnux.x86_64.tar.gz && rm iraf.lnux.x86_64.tar.gz
RUN cd $IRAF && ./install <<EOF
/iraf/iraf/
y
EOF

# Install PyRAF and other necessary astronomical packages
RUN pip install pyraf astropy

# Expose port for Jupyter
EXPOSE 8888

# Command to run Jupyter Notebook on container start
CMD ["start-notebook.sh", "--NotebookApp.token=''"]
