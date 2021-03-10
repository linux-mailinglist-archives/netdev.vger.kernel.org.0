Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC8933378B
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 09:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhCJIja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 03:39:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41224 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbhCJIjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 03:39:13 -0500
Received: from mail-wm1-f71.google.com ([209.85.128.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lJuMm-0003j6-2U
        for netdev@vger.kernel.org; Wed, 10 Mar 2021 08:38:52 +0000
Received: by mail-wm1-f71.google.com with SMTP id a63so859695wmd.8
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 00:38:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aXnbdve+zJOcbawv0EbHEJ5Jfc5lGWVMModTUJmANNk=;
        b=k/LHvCezGGA30oHvVMqKSfvmGCDttFXmKe3uvXO3U9SXjd/1D+qRYQIBDK+Iff/LH1
         lw0eVHvKuRIDZu26Zv9P2NzGpMKeyNtii4rAdKth8Onu86V0k/+DhKX39/Avfiwqy4si
         uI4Kwe3GfLAowsPv0JH66co3JkR1CDS40MQ3ZuPuhIMMQbOs8nj85a8KRFUVfUNhkUtT
         LA92xNuHYabSfne1BxPGmepsJCZCMzzoFYCPXk7As6TsEZYIYyjBpvK/Wg8U3MoXnGe6
         m0/l1WAllDxkB4m3aVPgdqe2OfzjZCxLgFt/nDriLTRSo8WwNqyPImVG1YNFBfizWBK/
         x17w==
X-Gm-Message-State: AOAM531x4bWrVVEh1ecjk9TtcjwZYXmpB+IGKEW/al2m35r0R69sAvFX
        M/3vqMUchczIJnH9Pi1Twz3e8clFAIYdXv3w+QOwyfgZdRenNtNIzUVSIgBndeU0AO0nwXYisS6
        Zi2g+JqJGbpPgDANm5pOFJprEJyG0DEEE9Q==
X-Received: by 2002:adf:e34f:: with SMTP id n15mr2291941wrj.224.1615365531629;
        Wed, 10 Mar 2021 00:38:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzSnw2dWyhCg8S1XsnqpMXZq1fKjQTwwKkJAQ63GButlbWJPKDpMI8YiY40X10GBbtFiL7M/A==
X-Received: by 2002:adf:e34f:: with SMTP id n15mr2291911wrj.224.1615365531457;
        Wed, 10 Mar 2021 00:38:51 -0800 (PST)
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id u20sm32781061wru.6.2021.03.10.00.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 00:38:51 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Moritz Fischer <mdf@kernel.org>, Tom Rix <trix@redhat.com>,
        Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-fpga@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        arm@kernel.org, soc@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [RFC v2 4/5] arm64: intel: merge Agilex and N5X into ARCH_SOCFPGA64
Date:   Wed, 10 Mar 2021 09:38:38 +0100
Message-Id: <20210310083840.481615-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310083840.481615-1-krzysztof.kozlowski@canonical.com>
References: <20210310083327.480837-1-krzysztof.kozlowski@canonical.com>
 <20210310083840.481615-1-krzysztof.kozlowski@canonical.com>
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
ARCH_SOCFPGA64.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/arm64/Kconfig.platforms       | 10 ----------
 arch/arm64/boot/dts/intel/Makefile |  6 +++---
 arch/arm64/configs/defconfig       |  1 -
 drivers/clk/socfpga/Kconfig        |  4 ++--
 drivers/firmware/Kconfig           |  2 +-
 drivers/reset/Kconfig              |  2 +-
 6 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platforms
index 78bba3633eab..754738029cc6 100644
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
diff --git a/arch/arm64/boot/dts/intel/Makefile b/arch/arm64/boot/dts/intel/Makefile
index 3a052540605b..bb340584785c 100644
--- a/arch/arm64/boot/dts/intel/Makefile
+++ b/arch/arm64/boot/dts/intel/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-dtb-$(CONFIG_ARCH_AGILEX) += socfpga_agilex_socdk.dtb \
-			     socfpga_agilex_socdk_nand.dtb
+dtb-$(CONFIG_ARCH_SOCFPGA64) += socfpga_agilex_socdk.dtb \
+				socfpga_agilex_socdk_nand.dtb
 dtb-$(CONFIG_ARCH_KEEMBAY) += keembay-evm.dtb
-dtb-$(CONFIG_ARCH_N5X) += socfpga_n5x_socdk.dtb
+dtb-$(CONFIG_ARCH_SOCFPGA64) += socfpga_n5x_socdk.dtb
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index ee742900a150..4968d4b3d89d 100644
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
diff --git a/drivers/clk/socfpga/Kconfig b/drivers/clk/socfpga/Kconfig
index 8cf3dfdba255..834797c68cb2 100644
--- a/drivers/clk/socfpga/Kconfig
+++ b/drivers/clk/socfpga/Kconfig
@@ -2,5 +2,5 @@
 config COMMON_CLK_SOCFPGA64
 	bool
 	# Intel Stratix / Agilex / N5X clock controller support
-	default y if ARCH_AGILEX || ARCH_N5X || ARCH_SOCFPGA64
-	depends on ARCH_AGILEX || ARCH_N5X || ARCH_SOCFPGA64
+	default y if ARCH_SOCFPGA64
+	depends on ARCH_SOCFPGA64
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 59660798f05f..f290fad41731 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -206,7 +206,7 @@ config FW_CFG_SYSFS_CMDLINE
 
 config INTEL_STRATIX10_SERVICE
 	tristate "Intel Stratix10 Service Layer"
-	depends on (ARCH_SOCFPGA64 || ARCH_AGILEX) && HAVE_ARM_SMCCC
+	depends on ARCH_SOCFPGA64 && HAVE_ARM_SMCCC
 	default n
 	help
 	  Intel Stratix10 service layer runs at privileged exception level,
diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index fa7f1394697b..796c9e3e5e81 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -183,7 +183,7 @@ config RESET_SCMI
 
 config RESET_SIMPLE
 	bool "Simple Reset Controller Driver" if COMPILE_TEST
-	default ARCH_AGILEX || ARCH_ASPEED || ARCH_BCM4908 || ARCH_BITMAIN || ARCH_REALTEK || ARCH_STM32 || ARCH_SOCFPGA64 || ARCH_SUNXI || ARC
+	default ARCH_ASPEED || ARCH_BCM4908 || ARCH_BITMAIN || ARCH_REALTEK || ARCH_STM32 || ARCH_SOCFPGA64 || ARCH_SUNXI || ARC
 	help
 	  This enables a simple reset controller driver for reset lines that
 	  that can be asserted and deasserted by toggling bits in a contiguous,
-- 
2.25.1

