#!/bin/bash

set -e

unset CFLAGS
unset CXXFLAGS

export PREFIX=/project/crosstools/armv6
export PREFIX_SYSTEM=${PREFIX}
export PREFIX_CROSSTOOLS=${PREFIX}/cross-tools

export CLFS_HOST=$(echo ${MACHTYPE} | sed -e 's/-[^-]*/-cross/')
export CLFS_TARGET="armv6-bcm2835-linux-gnueabi"
export CLFS_ABI="aapcs-linux"
export CLFS_ARCH="arm"
export CLFS_ENDIAN="little"
export CLFS_ARM_ARCH="armv6"
export CLFS_ARM_MODE="arm"
export CLFS_FLOAT="hard"
export CLFS_FPU="vfp"

export PATH=${PREFIX_CROSSTOOLS}/bin:/bin:/usr/bin:/usr/local/bin
export LC_ALL=POSIX

for p in \
    cross-pi-linux-headers_raspberrypi-3.6.y-0.bee \
    cross-pi-gmp-5.1.1-0.bee \
    cross-pi-mpfr-3.1.2-0.bee \
    cross-pi-mpc-1.0.1-0.bee \
    cross-pi-binutils-2.23.2-0.bee \
    cross-pi-gcc_prereq-1-0.bee \
    cross-pi-gcc_static-4.8.0-0.bee \
    cross-pi-glibc-2.17-0.bee \
    cross-pi-gcc-4.8.0-0.bee
    do

    if [ -z "${stop_skipping}" ] && bee list ${p%.bee} >/dev/null ; then
        echo "skipping ${p}"
        continue
    fi
    
    ./${p} -c --no-archive-build --install

    stop_skipping=1;
done

for p in \
    cross-pi-gcc_static-4.8.0-0.bee
    do

    package=${p%.bee}.$(arch)
    
    if [ $(bee list ${package} | wc -l) -eq 1 ] ; then
        bee remove ${package}
    fi
done
