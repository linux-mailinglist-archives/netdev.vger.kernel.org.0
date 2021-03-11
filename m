Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1AD337724
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbhCKPZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:25:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33791 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbhCKPZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 10:25:53 -0500
Received: from mail-ed1-f71.google.com ([209.85.208.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lKNCB-0004jP-Fv
        for netdev@vger.kernel.org; Thu, 11 Mar 2021 15:25:51 +0000
Received: by mail-ed1-f71.google.com with SMTP id v27so10048877edx.1
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:25:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HH1upFGS1oxbv+vQ09D6VKarsXku0IAuIjEmvH7R4Kk=;
        b=QWe1ur3FKvZZwZjKMLnXm2KwO8TcRZh/bqNNhBhQea+9oTJfnpdas2CJa1h/5BxLdO
         SQYf+B1rBTT6kUP2/V9NZuwWIrh77qfxX/vyQHK6UjbyxJTiCLmmq/xlvPsPw6GXhyw1
         FVY+jHyA+xj9XHhrm3RMVY4Vy1bDTlpycCq2XQHtvKdJoY8SYxappxG7BjdTPOzQE3aM
         /02LKq/okzFi+SrRQnq0we83uWIoaeMunF6qWPkr274VnN+DCX+ZVmlqEJGr6P5pPtcW
         qK6Y9bPsBiPJRsPs1VOipYEFV2NX1v4bk2KgEUIxRJjklEO9SP7HOLJevJpOYBptgeZ5
         Cn8w==
X-Gm-Message-State: AOAM5302uGhTZdRhRVwLCzPB9nMReUaF2FBel4qvvNKb2PXug7gnXF/l
        kSgxoFY+0o3BQXUHcvGeMdalY8OHaYANYvuJcwNwRGgdxt962KpD8vKouvYmg/A9jvhq2HTsPZc
        zSM69XnyB22gldY950mFdu7/j+BCBsTLJyg==
X-Received: by 2002:a17:906:4f8a:: with SMTP id o10mr3653357eju.484.1615476351084;
        Thu, 11 Mar 2021 07:25:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwl4COb3xR5+Ql8luerMFoHdUQmjQDr8WhPDVtBN8ZjQzZ5RdBWXObNPvxwoLN6Q/QH+U5+ow==
X-Received: by 2002:a17:906:4f8a:: with SMTP id o10mr3653311eju.484.1615476350782;
        Thu, 11 Mar 2021 07:25:50 -0800 (PST)
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id v25sm1517826edr.18.2021.03.11.07.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 07:25:50 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Moritz Fischer <mdf@kernel.org>, Tom Rix <trix@redhat.com>,
        Lee Jones <lee.jones@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-fpga@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v3 00/15] arm64 / clk: socfpga: simplifying, cleanups and compile testing
Date:   Thu, 11 Mar 2021 16:25:30 +0100
Message-Id: <20210311152545.1317581-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

All three Intel arm64 SoCFPGA architectures (Agilex, N5X and Stratix 10)
are basically flavors/platforms of the same architecture.  At least from
the Linux point of view.  Up to a point that N5X and Agilex share DTSI.
Having three top-level architectures for the same one barely makes
sense and complicates driver selection.

Additionally it was pointed out that ARCH_SOCFPGA name is too generic.
There are other vendors making SoC+FPGA designs, so the name should be
changed to have real vendor (currently: Intel).


Dependencies / merging
======================
1. Patch 1 is used as base, so other changes depend on its hunks.
   I put it at beginning as it is something close to a fix, so candidate
   for stable (even though I did not mark it like that).
2. Patch 2: everything depends on it.

3. 64-bit path:
3a. Patches 3-7: depend on patch 2, from 64-bit point of view.
3b. Patch 8: depends on 2-7 as it finally removes 64-bit ARCH_XXX
    symbols.

4. 32-bit path:
4a. Patches 9-14: depend on 2, from 32-bit point of view.
4b. Patch 15: depends on 9-14 as it finally removes 32-bit ARCH_SOCFPGA
    symbol.

If the patches look good, proposed merging is via SoC tree (after
getting acks from everyone). Sharing immutable branches is also a way.


Changes since v2
================
1. Several new patches and changes.
2. Rename ARCH_SOCFPGA to ARCH_INTEL_SOCFPGA on 32-bit and 64-bit.
3. Enable compile testing of 32-bit socfpga clock drivers.
4. Split changes per subsystems for easier review.
5. I already received an ack from Lee Jones, but I did not add it as
   there was big refactoring.  Please kindly ack one more time if it
   looks good.

Changes since v1
================
1. New patch 3: arm64: socfpga: rename ARCH_STRATIX10 to ARCH_SOCFPGA64.
2. New patch 4: arm64: intel: merge Agilex and N5X into ARCH_SOCFPGA64.
3. Fix build is.sue reported by kernel test robot (with ARCH_STRATIX10
   and COMPILE_TEST but without selecting some of the clocks).


RFT
===
I tested compile builds on few configurations, so I hope kbuild 0-day
will check more options (please give it few days on the lists).
I compare the generated autoconf.h and found no issues.  Testing on real
hardware would be appreciated.

Best regards,
Krzysztof

Krzysztof Kozlowski (15):
  clk: socfpga: allow building N5X clocks with ARCH_N5X
  ARM: socfpga: introduce common ARCH_INTEL_SOCFPGA
  mfd: altera: merge ARCH_SOCFPGA and ARCH_STRATIX10
  net: stmmac: merge ARCH_SOCFPGA and ARCH_STRATIX10
  clk: socfpga: build together Stratix 10, Agilex and N5X clock drivers
  clk: socfpga: merge ARCH_SOCFPGA and ARCH_STRATIX10
  EDAC: altera: merge ARCH_SOCFPGA and ARCH_STRATIX10
  arm64: socfpga: merge Agilex and N5X into ARCH_INTEL_SOCFPGA
  clk: socfpga: allow compile testing of Stratix 10 / Agilex clocks
  clk: socfpga: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs (and
    compile test)
  dmaengine: socfpga: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs
  fpga: altera: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs
  i2c: altera: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs
  reset: socfpga: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs
  ARM: socfpga: drop ARCH_SOCFPGA

 arch/arm/Kconfig                            |  2 +-
 arch/arm/Kconfig.debug                      |  6 +++---
 arch/arm/Makefile                           |  2 +-
 arch/arm/boot/dts/Makefile                  |  2 +-
 arch/arm/configs/multi_v7_defconfig         |  2 +-
 arch/arm/configs/socfpga_defconfig          |  2 +-
 arch/arm/mach-socfpga/Kconfig               |  4 ++--
 arch/arm64/Kconfig.platforms                | 17 ++++-------------
 arch/arm64/boot/dts/altera/Makefile         |  2 +-
 arch/arm64/boot/dts/intel/Makefile          |  6 +++---
 arch/arm64/configs/defconfig                |  3 +--
 drivers/clk/Kconfig                         |  1 +
 drivers/clk/Makefile                        |  4 +---
 drivers/clk/socfpga/Kconfig                 | 19 +++++++++++++++++++
 drivers/clk/socfpga/Makefile                | 11 +++++------
 drivers/dma/Kconfig                         |  2 +-
 drivers/edac/Kconfig                        |  2 +-
 drivers/edac/altera_edac.c                  | 17 +++++++++++------
 drivers/firmware/Kconfig                    |  2 +-
 drivers/fpga/Kconfig                        |  8 ++++----
 drivers/i2c/busses/Kconfig                  |  2 +-
 drivers/mfd/Kconfig                         |  4 ++--
 drivers/net/ethernet/stmicro/stmmac/Kconfig |  4 ++--
 drivers/reset/Kconfig                       |  6 +++---
 24 files changed, 71 insertions(+), 59 deletions(-)
 create mode 100644 drivers/clk/socfpga/Kconfig

-- 
2.25.1

