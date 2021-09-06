Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A444018A0
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 11:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240816AbhIFJMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 05:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhIFJMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 05:12:10 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEF2C061575
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 02:11:06 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id n11so8593973edv.11
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 02:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Hi4k8mC8CL14+JpmMfxB3pX6Pa/j8Ek3zliWtRdRWbY=;
        b=WCBQOTgYvEvslSxbmTiQOgaY221XzlEViOHuyzF74lJGYlkYxi1f+t89NdCBKt6RD5
         b7udVVd6fRYmnrHGu2kFYGQSIvMD45sbaFWsgY4NYL78O7tnR1s1I8VbPZgCwqJwyRDT
         77y6/CAgFt9lDmZCUH1eDppvCUiKtqMwlh+1rio3DvBhArlukQBeB5RAbDFrOvBsaLuv
         Ory1+YLwUaTtsVUuO8wFcr64gieCfI0N6WNkXWMIFmpziHdbjjV7BdQjQccKPsL2D0Ys
         w/3WdrL58bnqGYJvkMwSCm+ZIpSJkgRLRUylihcYL26i6dZvHvE9dMi8wkommjQLCBmp
         3nBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Hi4k8mC8CL14+JpmMfxB3pX6Pa/j8Ek3zliWtRdRWbY=;
        b=U3KARyqbPMuUKIstf7tTc6mZUltoqj9Vx+LUIuIVRB7vzA48shBLEepv4myfyvBy41
         UxGIhs1noBCYYNMo4S85wrnSbvML9dI3wW9RuLVmZ/2gu/9cVZzjGjH4t13sgGh36jas
         SCB+BxIyFBazy9We4TKPTDgLWdeFqdswBqgN9yE0cXx+ed7hxjK9nnvakEFHNgZFOJgC
         RXYCjR9SZMHJ6VHfFxjyU4FtV269fyIP4bfonXzYS8Au5b8gHCFqA+eVHHjH5hXuEceM
         5DOjXh8loXdznMpEpS4fbEh1s6gRTKKkmxIHw/NSGxUjBxZD7cKuMQVoPNxc0HfOhw0H
         Osxw==
X-Gm-Message-State: AOAM532J/Wx99auZjfLS29L+ZPLDdkQp+P+ZrxIuAaL4dVnt3NOaJgSG
        5Da4cQh76W7tXrMDNxK4ot3jp7cAUQKK98Le0bBeKw==
X-Google-Smtp-Source: ABdhPJwJqiChATE9J/d95eknVM/yvgSZBffBpXx5PCp5StDfuK8SSo6BS4yEg5S1g0GL6P8BxQcEKItCtyGaEk4AyXg=
X-Received: by 2002:aa7:db10:: with SMTP id t16mr12313802eds.357.1630919464755;
 Mon, 06 Sep 2021 02:11:04 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 6 Sep 2021 14:40:53 +0530
Message-ID: <CA+G9fYsV7sTfaefGj3bpkvVdRQUeiWCVRiu6ovjtM=qri-HJ8g@mail.gmail.com>
Subject: bridge.c:157:11: error: variable 'err' is used uninitialized whenever
 'if' condition is false
To:     open list <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        lkft-triage@lists.linaro.org, Netdev <netdev@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Please ignore if it is already reported]

Following build warnings/ errors noticed while building linux mainline
master branch
with clang-nightly, clang-13, clang-12, clang-11 and clang-10 for
arm64 architecture.
Whereas gcc-11 build pass.

# to reproduce this build locally: tuxmake --target-arch=arm64
--kconfig=defconfig --toolchain=clang-nightly --wrapper=none
--environment=KBUILD_BUILD_TIMESTAMP=@1630870764
--environment=KBUILD_BUILD_USER=tuxmake
--environment=KBUILD_BUILD_HOST=tuxmake --runtime=podman
--image=855116176053.dkr.ecr.us-east-1.amazonaws.com/tuxmake/arm64_clang-nightly
config default kernel xipkernel modules dtbs dtbs-legacy debugkernel
headers
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- HOSTCC=clang CC=clang defconfig
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- HOSTCC=clang CC=clang
scripts/dtc/include-prefixes/arm/bcm2711-rpi-4-b.dts:220.10-231.4:
Warning (pci_device_reg): /scb/pcie@7d500000/pci@1,0: PCI unit address
format error, expected 0,0
scripts/dtc/include-prefixes/arm/bcm2711-rpi-4-b.dts:220.10-231.4:
Warning (pci_device_reg): /scb/pcie@7d500000/pci@1,0: PCI unit address
format error, expected 0,0
arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:464.3-52: Warning
(pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
configuration space
arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:464.3-52: Warning
(pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
configuration space
arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:464.3-52: Warning
(pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
configuration space
arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:464.3-52: Warning
(pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
configuration space
arch/arm64/kvm/hyp/nvhe/Makefile:58: FORCE prerequisite is missing
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:157:11: error:
variable 'err' is used uninitialized whenever 'if' condition is false
[-Werror,-Wsometimes-uninitialized]
        else if (mlx5_esw_bridge_dev_same_hw(rep, esw))
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:164:9: note:
uninitialized use occurs here
        return err;
               ^~~
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:157:7: note:
remove the 'if' if its condition is always true
        else if (mlx5_esw_bridge_dev_same_hw(rep, esw))
             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:140:9: note:
initialize the variable 'err' to silence this warning
        int err;
               ^
                = 0
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:262:7: error:
variable 'err' is used uninitialized whenever switch case is taken
[-Werror,-Wsometimes-uninitialized]
        case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:276:9: note:
uninitialized use occurs here
        return err;
               ^~~
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:257:7: error:
variable 'err' is used uninitialized whenever 'if' condition is false
[-Werror,-Wsometimes-uninitialized]
                if (attr->u.brport_flags.mask & ~(BR_LEARNING |
BR_FLOOD | BR_MCAST_FLOOD)) {

^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:276:9: note:
uninitialized use occurs here
        return err;
               ^~~
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:257:3: note:
remove the 'if' if its condition is always true
                if (attr->u.brport_flags.mask & ~(BR_LEARNING |
BR_FLOOD | BR_MCAST_FLOOD)) {

^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:247:9: note:
initialize the variable 'err' to silence this warning
        int err;
               ^
                = 0
3 errors generated.
make[6]: *** [scripts/Makefile.build:277:
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.o] Error 1
make[6]: Target '__build' not remade because of errors.
make[5]: *** [scripts/Makefile.build:540:
drivers/net/ethernet/mellanox/mlx5/core] Error 2
make[5]: Target '__build' not remade because of errors.
make[4]: *** [scripts/Makefile.build:540: drivers/net/ethernet/mellanox] Error 2
make[4]: Target '__build' not remade because of errors.
make[3]: *** [scripts/Makefile.build:540: drivers/net/ethernet] Error 2
make[3]: Target '__build' not remade because of errors.
make[2]: *** [scripts/Makefile.build:540: drivers/net] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [Makefile:1872: drivers] Error 2
make[1]: Target '__all' not remade because of errors.
make: *** [Makefile:219: __sub-make] Error 2
make: Target '__all' not remade because of errors.

Build config:
https://builds.tuxbuild.com/1xjZrnXEZfc3qYzziclNRaugAaN/config

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

meta data:
-----------
    git_describe: v5.14-9687-g27151f177827
    git_repo: https://gitlab.com/Linaro/lkft/mirrors/torvalds/linux-mainline
    git_sha: 27151f177827d478508e756c7657273261aaf8a9
    git_short_log: 27151f177827 (\Merge tag
'perf-tools-for-v5.15-2021-09-04' of
git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux\)
    kconfig: [
        defconfig
    ],
    kernel_version: 5.14.0
    status_message: failure while building tuxmake target(s): default
    target_arch: arm64
    toolchain: clang-nightly, clang-13, clang-12, clang-11 and clang-10

steps to reproduce:
https://builds.tuxbuild.com/1xjZrnXEZfc3qYzziclNRaugAaN/tuxmake_reproducer.sh

--
Linaro LKFT
https://lkft.linaro.org
