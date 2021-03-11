Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DE133775B
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbhCKP0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:26:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33926 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbhCKP0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 10:26:01 -0500
Received: from mail-ej1-f70.google.com ([209.85.218.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lKNCK-0004uN-IO
        for netdev@vger.kernel.org; Thu, 11 Mar 2021 15:26:00 +0000
Received: by mail-ej1-f70.google.com with SMTP id kx22so768686ejc.17
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:26:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=64x8YpaZ8HtZHSdGhulwSXZBkEtDNxGWQlJcY2WZReQ=;
        b=rn/N/umvHVDVvHhBNBl9KberIhBNnf/GQ3xl0dZEky9zEEI6Xbp46xMjvmWxowVUgQ
         98HQK19vUoH9vsDTbuC3h0uooYvn/YgiN/c+5sVKikux79D1+1IYvHoyDZrrcsdeQabp
         JlM5HRPWumvLzlXA8YDitUDnm+XTC0oHx0qlpOp+9nNcRJa37bxRDqcRxrWegfVF7NbP
         4IZ4Dv+NClpNIpP90ROUetDblZoFY2KOLUf85XOlRqFXA27Gzmy7OgAeltWYkclQrqK1
         MSZjA9/SAxB11+o4mD/NdGKKWG29Hp8t54bdlqlQyLZPokKE5BL0UALkVPjhwbhnfew5
         XxsQ==
X-Gm-Message-State: AOAM533MJQ6KoIT3RCGzJw7lPc1fI5Ct8LjgYwfWXnLABHPd2Ap3tIie
        VWZ9J7+fFUVVc7SUVvDJP9UauDAGvEkfwzAXReEXRQmPMEGtzVHF7dePOLc02CFNq7HdbYZKmAO
        wtSG3rq0/EvHoDQoDPjVaTLWywMk7kkIEfA==
X-Received: by 2002:a05:6402:1393:: with SMTP id b19mr9029429edv.333.1615476360053;
        Thu, 11 Mar 2021 07:26:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyK46E5y/32Jy/9Voo0TUZtd7fHKBU61YwAFS87oJZxm94dz2uI8Cz0UtNhcGCnNvg52FFB5Q==
X-Received: by 2002:a05:6402:1393:: with SMTP id b19mr9029395edv.333.1615476359877;
        Thu, 11 Mar 2021 07:25:59 -0800 (PST)
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id v25sm1517826edr.18.2021.03.11.07.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 07:25:59 -0800 (PST)
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
Subject: [PATCH v3 08/15] arm64: socfpga: merge Agilex and N5X into ARCH_INTEL_SOCFPGA
Date:   Thu, 11 Mar 2021 16:25:38 +0100
Message-Id: <20210311152545.1317581-9-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210311152545.1317581-1-krzysztof.kozlowski@canonical.com>
References: <20210311152545.1317581-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Agilex, N5X and Stratix 10 share all quite similar arm64 hard cores and
SoC-part.  Up to a point that N5X uses the same DTSI as Agilex.  From
the Linux kernel point of view these are flavors of the same
architecture so there is no need for three top-level arm64
architectures.  Simplify this by merging all three architectures into
ARCH_INTEL_SOCFPGA and dropping the other ARCH* arm64 Kconfig entries.

The side effect is that the INTEL_STRATIX10_SERVICE will now be
available for both 32-bit and 64-bit Intel SoCFPGA, even though it is
used only for 64-bit.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/arm64/Kconfig.platforms       | 21 ++++-----------------
 arch/arm64/boot/dts/intel/Makefile |  6 +++---
 arch/arm64/configs/defconfig       |  3 +--
 drivers/clk/Makefile               |  2 --
 drivers/clk/socfpga/Kconfig        |  4 ++--
 drivers/firmware/Kconfig           |  2 +-
 drivers/fpga/Kconfig               |  2 +-
 drivers/reset/Kconfig              |  2 +-
 8 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platforms
index ecab67a1afb8..ce50dd129eec 100644
--- a/arch/arm64/Kconfig.platforms
+++ b/arch/arm64/Kconfig.platforms
@@ -8,16 +8,6 @@ config ARCH_ACTIONS
 	help
 	  This enables support for the Actions Semiconductor S900 SoC family.
 
-config ARCH_AGILEX
-	bool "Intel's Agilex SoCFPGA Family"
-	help
-	  This enables support for Intel's Agilex SoCFPGA Family.
-
-config ARCH_N5X
-	bool "Intel's eASIC N5X SoCFPGA Family"
-	help
-	  This enables support for Intel's eASIC N5X SoCFPGA Family.
-
 config ARCH_SUNXI
 	bool "Allwinner sunxi 64-bit SoC Family"
 	select ARCH_HAS_RESET_CONTROLLER
@@ -254,14 +244,11 @@ config ARCH_SEATTLE
 	help
 	  This enables support for AMD Seattle SOC Family
 
-config ARCH_STRATIX10
-	bool "Altera's Stratix 10 SoCFPGA Family"
-	select ARCH_INTEL_SOCFPGA
-	help
-	  This enables support for Altera's Stratix 10 SoCFPGA Family.
-
 config ARCH_INTEL_SOCFPGA
-	bool
+	bool "Intel's SoCFPGA ARMv8 Families"
+	help
+	  This enables support for Intel's SoCFPGA ARMv8 families:
+	  Stratix 10 (ex. Altera), Agilex and eASIC N5X.
 
 config ARCH_SYNQUACER
 	bool "Socionext SynQuacer SoC Family"
diff --git a/arch/arm64/boot/dts/intel/Makefile b/arch/arm64/boot/dts/intel/Makefile
index 3a052540605b..0b5477442263 100644
--- a/arch/arm64/boot/dts/intel/Makefile
+++ b/arch/arm64/boot/dts/intel/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-dtb-$(CONFIG_ARCH_AGILEX) += socfpga_agilex_socdk.dtb \
-			     socfpga_agilex_socdk_nand.dtb
+dtb-$(CONFIG_ARCH_INTEL_SOCFPGA) += socfpga_agilex_socdk.dtb \
+				socfpga_agilex_socdk_nand.dtb \
+				socfpga_n5x_socdk.dtb
 dtb-$(CONFIG_ARCH_KEEMBAY) += keembay-evm.dtb
-dtb-$(CONFIG_ARCH_N5X) += socfpga_n5x_socdk.dtb
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index d612f633b771..cf8a3009b858 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -28,7 +28,6 @@ CONFIG_KALLSYMS_ALL=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_PROFILING=y
 CONFIG_ARCH_ACTIONS=y
-CONFIG_ARCH_AGILEX=y
 CONFIG_ARCH_SUNXI=y
 CONFIG_ARCH_ALPINE=y
 CONFIG_ARCH_BCM2835=y
@@ -50,7 +49,7 @@ CONFIG_ARCH_RENESAS=y
 CONFIG_ARCH_ROCKCHIP=y
 CONFIG_ARCH_S32=y
 CONFIG_ARCH_SEATTLE=y
-CONFIG_ARCH_STRATIX10=y
+CONFIG_ARCH_INTEL_SOCFPGA=y
 CONFIG_ARCH_SYNQUACER=y
 CONFIG_ARCH_TEGRA=y
 CONFIG_ARCH_SPRD=y
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 1e29e5ad107a..96802294d35a 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -105,8 +105,6 @@ obj-$(CONFIG_ARCH_ROCKCHIP)		+= rockchip/
 obj-$(CONFIG_COMMON_CLK_SAMSUNG)	+= samsung/
 obj-$(CONFIG_CLK_SIFIVE)		+= sifive/
 obj-$(CONFIG_ARCH_INTEL_SOCFPGA)	+= socfpga/
-obj-$(CONFIG_ARCH_AGILEX)		+= socfpga/
-obj-$(CONFIG_ARCH_N5X)			+= socfpga/
 obj-$(CONFIG_PLAT_SPEAR)		+= spear/
 obj-y					+= sprd/
 obj-$(CONFIG_ARCH_STI)			+= st/
diff --git a/drivers/clk/socfpga/Kconfig b/drivers/clk/socfpga/Kconfig
index bc102e0f0be0..b6c5b9737174 100644
--- a/drivers/clk/socfpga/Kconfig
+++ b/drivers/clk/socfpga/Kconfig
@@ -2,5 +2,5 @@
 config CLK_INTEL_SOCFPGA64
 	bool
 	# Intel Stratix / Agilex / N5X clock controller support
-	default (ARCH_AGILEX || ARCH_N5X || ARCH_STRATIX10)
-	depends on ARCH_AGILEX || ARCH_N5X || ARCH_STRATIX10
+	default ARM64 && ARCH_INTEL_SOCFPGA
+	depends on ARM64 && ARCH_INTEL_SOCFPGA
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 3f14dffb9669..6a4e882e448d 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -206,7 +206,7 @@ config FW_CFG_SYSFS_CMDLINE
 
 config INTEL_STRATIX10_SERVICE
 	tristate "Intel Stratix10 Service Layer"
-	depends on (ARCH_STRATIX10 || ARCH_AGILEX) && HAVE_ARM_SMCCC
+	depends on ARCH_INTEL_SOCFPGA && HAVE_ARM_SMCCC
 	default n
 	help
 	  Intel Stratix10 service layer runs at privileged exception level,
diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index 5ff9438b7b46..fd325e9c5ce6 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -60,7 +60,7 @@ config FPGA_MGR_ZYNQ_FPGA
 
 config FPGA_MGR_STRATIX10_SOC
 	tristate "Intel Stratix10 SoC FPGA Manager"
-	depends on (ARCH_STRATIX10 && INTEL_STRATIX10_SERVICE)
+	depends on (ARCH_INTEL_SOCFPGA && INTEL_STRATIX10_SERVICE)
 	help
 	  FPGA manager driver support for the Intel Stratix10 SoC.
 
diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index 4171c6f76385..b1e8efa16166 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -183,7 +183,7 @@ config RESET_SCMI
 
 config RESET_SIMPLE
 	bool "Simple Reset Controller Driver" if COMPILE_TEST
-	default ARCH_AGILEX || ARCH_ASPEED || ARCH_BCM4908 || ARCH_BITMAIN || ARCH_REALTEK || ARCH_STM32 || ARCH_STRATIX10 || ARCH_SUNXI || ARC
+	default ARCH_ASPEED || ARCH_BCM4908 || ARCH_BITMAIN || ARCH_REALTEK || ARCH_STM32 || (ARCH_INTEL_SOCFPGA && ARM64) || ARCH_SUNXI || ARC
 	help
 	  This enables a simple reset controller driver for reset lines that
 	  that can be asserted and deasserted by toggling bits in a contiguous,
-- 
2.25.1

