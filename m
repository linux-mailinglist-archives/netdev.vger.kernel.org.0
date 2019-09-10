Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E27AE878
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 12:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393852AbfIJKim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 06:38:42 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39188 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392623AbfIJKil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 06:38:41 -0400
Received: by mail-lf1-f67.google.com with SMTP id l11so13021506lfk.6
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 03:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=lE9SLT+Epa1yWUlST5UPew6aiB+QEt/X8AxyplMCiDk=;
        b=XbS41MO2It/+s08Mt+jg4mQofYHABfBh/17XT+H25A67nYUI3NKRzMxlcR8o0XsMui
         yhmYJBLbMYziu4MNSkOyMf5ynB9Tls558FwISlsty5eqg/PQmDV6o6ciRjgOiiJVS2cx
         YunZEd6zgyRA7XSJ50pC+vnel2C+l0FGcLij20AIKDOEsEkGaamaLJCjqD9QQ0hctJ3Z
         mL6w40PkgQPp1J+zCrdkABkhaWkm+RzMngHJCcBEt0MVpcGpSd2q0RaTiE8dzOCtt9pO
         mSWyhQTu4IN7vV9MxrbOq2FX1e/vHa3m3c5kj/bckNfJHv3uPOwkBegR+bla/eg+WxIf
         dOlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lE9SLT+Epa1yWUlST5UPew6aiB+QEt/X8AxyplMCiDk=;
        b=P+Z92KFivQ0tEdp8lEavpVDUo7nYRWk9tLtKa4jozAB1fbH9uVNjobB/UGL4Mx5XUo
         aktIdN2NMpbb1Ene9baQaj5XLndMnu48vGgVAqbGcS/sMtMFQ7Sy7luglE5nvaTR3YLh
         k7CMWR9KB7LlpZr0WUV3QZXW8xn5fmA2XEe5TJjgd2BNQcS1+njQ2R5BGWimxtgj7qLN
         kxHRfJ6rkfDqXVcVc1o3mkfKOGoli61TVhuq9RCe+JoZZY7NipRa6kAep5zakxsfcgUq
         XyRwDw/T7h9ik+H1turIkqCsLk5g2pK5wzAOvh8RitjM/J9aIsxEmW3kdY+61OIUt1b6
         MjSw==
X-Gm-Message-State: APjAAAW8VOexdGXhV0YDaATwfQXnFVgXpF2yvsS/nq9vMIAh5o5fsyTH
        lH6d49FjZHxFcJwljVQiLjLXkg==
X-Google-Smtp-Source: APXvYqwri8jWHj8TfOmjvtA+O/2LoyqOPeA9w/OG+vHxJsQBjvSGXd2iswRslc5Fh2ZGjfK2p7c07g==
X-Received: by 2002:a19:48c3:: with SMTP id v186mr19952832lfa.141.1568111917725;
        Tue, 10 Sep 2019 03:38:37 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id g5sm4005563lfh.2.2019.09.10.03.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 03:38:36 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf-next 00/11] samples: bpf: improve/fix cross-compilation
Date:   Tue, 10 Sep 2019 13:38:19 +0300
Message-Id: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains mainly fixes/improvements for cross-compilation
but not only, tested for arm, arm64, but intended for any arch.
Also verified on native build (not cross compilation) for x86_64
and arm.

Initial RFC link:
https://lkml.org/lkml/2019/8/29/1665

Prev. version:
https://www.spinics.net/lists/netdev/msg597823.html

Besides the patches given here, the RFC also contains couple patches
related to llvm clang
  arm: include: asm: swab: mask rev16 instruction for clang
  arm: include: asm: unified: mask .syntax unified for clang
They are necessarily to verify arm build.

The change touches not only cross-compilation and can have impact on
other archs and build environments, so might be good idea to verify
it in order to add appropriate changes, some warn options could be
tuned also.

All is tasted on x86-64 with clang installed (has to be built containing
targets for arm, arm64..., see llvm -v, usually it's present already)

Instructions to test native on x86_64
=================================================
Native build on x86_64 is done in usual way and shouldn't have difference
except HOSTCC is now printed as CC wile building the samples.

Instructions to test cross compilation on arm64
=================================================
#Toolchain used for test:
gcc version 8.3.0
(GNU Toolchain for the A-profile Architecture 8.3-2019.03 (arm-rel-8.36))

# Get some arm64 FS, containing at least libelf
I've used sdk for TI am65x got here:
http://downloads.ti.com/processor-sdk-linux/esd/AM65X/latest/exports/\
ti-processor-sdk-linux-am65xx-evm-06.00.00.07-Linux-x86-Install.bin

# Install this binary to some dir, say "sdk".
# Configure kernel (use defconfig as no matter), but clean everything
# before.
make ARCH=arm64 -C tools/ clean
make ARCH=arm64 -C samples/bpf clean
make ARCH=arm64 clean
make ARCH=arm64 defconfig

# The kernel version used in sdk doesn't correspond to checked one,
# but for this verification only headers need to be syched,
# so install them:
make ARCH=arm64 headers_install

# or on SDK if need keep them in sync (not necessarily to verify):

make ARCH=arm64 INSTALL_HDR_PATH=/../sdk/\
ti-processor-sdk-linux-am65xx-evm-06.00.00.07/linux-devkit/sysroots/\
aarch64-linux/usr headers_install

# Build samples
make samples/bpf/ ARCH=arm64 CROSS_COMPILE="aarch64-linux-gnu-"\
SYSROOT="/../sdk/ti-processor-sdk-linux-am65xx-evm-06.00.00.07/\
linux-devkit/sysroots/aarch64-linux"

Instructions to test cross compilation on arm
=================================================
#Toolchains used for test:
arm-linux-gnueabihf-gcc (Linaro GCC 7.2-2017.11) 7.2.1 20171011
or
arm-linux-gnueabihf-gcc
(GNU Toolchain for the A-profile Architecture 8.3-2019.03 \
(arm-rel-8.36)) 8.3.0

# Get some FS, I've used sdk for TI am52xx got here:
http://downloads.ti.com/processor-sdk-linux/esd/AM57X/05_03_00_07/exports/\
ti-processor-sdk-linux-am57xx-evm-05.03.00.07-Linux-x86-Install.bin

# Install this binary to some dir, say "sdk".
# Configure kernel, but clean everything before.
make ARCH=arm -C tools/ clean
make ARCH=arm -C samples/bpf clean
make ARCH=arm clean
make ARCH=arm omap2plus_defconfig

# The kernel version used in sdk doesn't correspond to checked one, but
headers only should be synched, so install them:

make ARCH=arm64 headers_install

# or on SDK if need keep them in sync (not necessarily):

make ARCH=arm INSTALL_HDR_PATH=/../sdk/\
ti-processor-sdk-linux-am57xx-evm-05.03.00.07/linux-devkit/sysroots/\
armv7ahf-neon-linux-gnueabi/usr headers_install

# Build samples
make samples/bpf/ ARCH=arm CROSS_COMPILE="arm-linux-gnueabihf-"\
SYSROOT="/../sdk/ti-processor-sdk-linux-am57xx-evm-05.03\
.00.07/linux-devkit/sysroots/armv7ahf-neon-linux-gnueabi"


Based on bpf-next/master

v2..v1:
- restructured patches order
- split "samples: bpf: Makefile: base progs build on Makefile.progs"
  to make change more readable. It added couple nice extra patches.
- removed redundant patch:
  "samples: bpf: Makefile: remove target for native build"
- added fix:
  "samples: bpf: makefile: fix cookie_uid_helper_example obj build"
- limited -D option filter only for arm
- improved comments
- added couple instructions to verify cross compilation for arm and
  arm64 arches based on TI am57xx and am65xx sdks.
- corrected include a little order

Ivan Khoronzhuk (11):
  samples: bpf: makefile: fix HDR_PROBE "echo"
  samples: bpf: makefile: fix cookie_uid_helper_example obj build
  samples: bpf: makefile: use --target from cross-compile
  samples: bpf: use own EXTRA_CFLAGS for clang commands
  samples: bpf: makefile: use D vars from KBUILD_CFLAGS to handle
    headers
  samples: bpf: makefile: drop unnecessarily inclusion for bpf_load
  samples: bpf: add makefile.prog for separate CC build
  samples: bpf: makefile: base progs build on makefile.progs
  samples: bpf: makefile: use CC environment for HDR_PROBE
  libbpf: makefile: add C/CXX/LDFLAGS to libbpf.so and test_libpf
    targets
  samples: bpf: makefile: add sysroot support

 samples/bpf/Makefile      | 172 ++++++++++++++++++++++----------------
 samples/bpf/Makefile.prog |  77 +++++++++++++++++
 samples/bpf/README.rst    |  10 +++
 tools/lib/bpf/Makefile    |  11 ++-
 4 files changed, 194 insertions(+), 76 deletions(-)
 create mode 100644 samples/bpf/Makefile.prog

-- 
2.17.1

