Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA6147A981
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 13:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbhLTMZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 07:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbhLTMZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 07:25:25 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED3FC061401
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 04:25:24 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id z29so37460482edl.7
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 04:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RLoaJ3N8Xq0PfED/81k7x9QvjcAx1z3or5WiHD5qoGU=;
        b=y8baxxmuqjKIXbqN86OhPF+S2MhjmaEOZscIgtYz9r+iVI0UqnN2fYZTIW7DbmZx0/
         Z7vx3CanCsPx5hZsAkQEkuwKi+zvuDISga/emKfC9CogogIge7Vu/35fCrYjrEdtzwxS
         5WOiAZxhQi+C+TrVO7DH5/KASdldXWoWGlU09dcareQux7aJ9ZzvdJUPfNJzKhkUn17r
         sohnDc7Ojr/c5sigCRM1ulYHzkgZrR9kWME6Rjqc6xSPqhmcEHe8u+zuKI01gVvKsrCu
         TkajWUhxSIl8dYayjKojAFYFxd6PqDNvL2EiWkXGnRE4f2txcyPWYMSXdR3PBzg62LSX
         uniA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RLoaJ3N8Xq0PfED/81k7x9QvjcAx1z3or5WiHD5qoGU=;
        b=GILYfmpYlye/pih+uh3O45IwwMfZ3QyrqIWYcelJZxYBtBs3U7taf+6HJXecel5WX+
         0gQORi8fa8VRDXz8pPmaA2PCPk3xXYlI1yh+edgBqTMMWq3C/+IQXJ/mejefV8z0vhNe
         3yH62HZFK6WakoO1+rQp3LL6CDuijm2Q5ggKCXCzwXN6j9d9fpCtsITxmW07Hnz2tdTp
         CVmLgsog7XfeWZ/paBVKsWKBMeyuxmXQyUzQc/wPdgbhtsljsXcftBr4w4Lbv6gragpX
         rSf0kxVtv//NM9LTGS2XChOR45y0BsgTqm9wrrQSGAkZ/p+rCMfOmOPkTuV0LG7VyNME
         LJ/w==
X-Gm-Message-State: AOAM531373Jl3BCmLZpe3C4q7dp/NX0CQYl6htwp+m92Fkct0qPEizJx
        FYJKlCYX9rJkkXEgivjUzKtupg==
X-Google-Smtp-Source: ABdhPJy3+8r/F7Hrarvc9fPePV2rXtFAokSQvQS2uiZSiLE/YpkmMcgerR8vyD0cfodgTNRIbvcrFA==
X-Received: by 2002:a05:6402:1702:: with SMTP id y2mr4583607edu.372.1640003123217;
        Mon, 20 Dec 2021 04:25:23 -0800 (PST)
Received: from localhost (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id i13sm4927823eds.72.2021.12.20.04.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 04:25:22 -0800 (PST)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        clang-built-linux@googlegroups.com, ulli.kroll@googlemail.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxinming820@gmail.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, dmitry.torokhov@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org,
        linux-input@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 4.14 0/6] fix warning and errors on arm built with clang
Date:   Mon, 20 Dec 2021 13:25:00 +0100
Message-Id: <20211220122506.3631672-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Can this patchset be applied to linux-4.14.y. I've tried to build an arm
kernel for these defconfigs:

mini2440_defconfig, mxs_defconfig, imx_v4_v5_defconfig,
integrator_defconfig, lpc32xx_defconfig, s3c2410_defconfig,
nhk8815_defconfig, imx_v6_v7_defconfig, at91_dt_defconfig,
shmobile_defconfig, omap1_defconfig, multi_v5_defconfig,
orion5x_defconfig, footbridge_defconfig, davinci_all_defconfig

Without this patchset these configs faild to build.
Also I fixed a few warnings.

There are still a few more warnings to fix.
But this is a start.

I built the kernel with tuxmake and this is the command:
tuxmake --runtime podman --target-arch arm --toolchain clang-nightly --kconfig tinyconfig LLVM=1 LLVM_IAS=0

Similar results with clang-13.


Patch "net: lan78xx: Avoid unnecessary self assignment" fixes:

drivers/net/usb/lan78xx.c:949:11: warning: explicitly assigning value of variable of type 'u32' (aka 'unsigned int') to itself [-Wself-assign]
                        offset = offset;
                        ~~~~~~ ^ ~~~~~~
1 warning generated.


Patch "ARM: 8805/2: remove unneeded naked function usage" fixes:

arch/arm/mm/copypage-v4wb.c:47:9: error: parameter references not allowed in naked functions
        : "r" (kto), "r" (kfrom), "I" (PAGE_SIZE / 64));
               ^
/builds/linux/arch/arm/mm/copypage-v4wb.c:25:13: note: attribute is here
static void __naked
            ^
/builds/linux/include/linux/compiler_types.h:249:34: note: expanded from macro '__naked'
#define __naked                 __attribute__((naked)) notrace
                                               ^
1 error generated.


Patch "mwifiex: Remove unnecessary braces from HostCmd_SET_SEQ_NO_BSS_INFO" fixes:

drivers/net/wireless/marvell/mwifiex/cmdevt.c:219:22: warning: '(' and '{' tokens introducing statement expression appear in different macro expansion contexts [-Wcompound-token-split-by-macro]
        host_cmd->seq_num = cpu_to_le16(HostCmd_SET_SEQ_NO_BSS_INFO
                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/builds/linux/include/linux/byteorder/generic.h:90:21: note: expanded from macro 'cpu_to_le16'
#define cpu_to_le16 __cpu_to_le16
                    ^


Patch "Input: touchscreen - avoid bitwise vs logical OR warning" fixes:

drivers/input/touchscreen/of_touchscreen.c:80:17: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
        data_present = touchscreen_get_prop_u32(dev, "touchscreen-size-x",
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Patch "ARM: 8788/1: ftrace: remove old mcount support" fixes:

arch/arm/kernel/entry-ftrace.S:56:2: error: Ftrace requires CONFIG_FRAME_POINTER=y with GCC older than 4.4.0.
#error Ftrace requires CONFIG_FRAME_POINTER=y with GCC older than 4.4.0.
 ^
1 error generated.


Patch "ARM: 8800/1: use choice for kernel unwinders" fixes the build
error:

clang: error: unknown argument: '-mapcs'
clang: error: unknown argument: '-mno-sched-prolog'


Cheers,
Anders

Nathan Chancellor (3):
  net: lan78xx: Avoid unnecessary self assignment
  mwifiex: Remove unnecessary braces from HostCmd_SET_SEQ_NO_BSS_INFO
  Input: touchscreen - avoid bitwise vs logical OR warning

Nicolas Pitre (1):
  ARM: 8805/2: remove unneeded naked function usage

Stefan Agner (2):
  ARM: 8800/1: use choice for kernel unwinders
  ARM: 8788/1: ftrace: remove old mcount support

 arch/arm/Kconfig.debug                        | 45 +++++----
 arch/arm/include/asm/ftrace.h                 |  3 -
 arch/arm/kernel/armksyms.c                    |  3 -
 arch/arm/kernel/entry-ftrace.S                | 75 +-------------
 arch/arm/kernel/ftrace.c                      | 51 ----------
 arch/arm/mm/copypage-fa.c                     | 35 ++++---
 arch/arm/mm/copypage-feroceon.c               | 98 +++++++++----------
 arch/arm/mm/copypage-v4mc.c                   | 19 ++--
 arch/arm/mm/copypage-v4wb.c                   | 41 ++++----
 arch/arm/mm/copypage-v4wt.c                   | 37 ++++---
 arch/arm/mm/copypage-xsc3.c                   | 71 ++++++--------
 arch/arm/mm/copypage-xscale.c                 | 71 +++++++-------
 drivers/input/touchscreen/of_touchscreen.c    | 18 ++--
 drivers/net/usb/lan78xx.c                     |  6 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c |  4 +-
 drivers/net/wireless/marvell/mwifiex/fw.h     |  8 +-
 lib/Kconfig.debug                             |  6 +-
 17 files changed, 228 insertions(+), 363 deletions(-)

-- 
2.34.1

