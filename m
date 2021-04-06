Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABEE3558E5
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 18:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346254AbhDFQKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 12:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbhDFQKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 12:10:09 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A254FC06174A;
        Tue,  6 Apr 2021 09:10:01 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id x2so15660594oiv.2;
        Tue, 06 Apr 2021 09:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=70/WXuRSOVM+Cc9ViyI6lDUSxH+eDXC41IovFsWbeYs=;
        b=mZHPqUim93e/5u+URkvc/Ye1e5GK97PBlzfwKox4sOBT0lN+SkMyIKlSxqOOXncrAK
         6vC4G+ZyvQX97b1+02ESEbKpWxy6wpdVgcvS3TML68NHexPqdOTJYcS2owuFsU4G/IQw
         2m6PgS4O+foYkxYMBeufP2rbxsFCpYuGbB+YZgt6f42vITYALda/lf2H3CFixXYuqAVN
         Qot5vsNWbluJqtZuxX7JwGE2pWMkl7cmc3V4dMSdVzMMp07mI8uZbBp0dyzbOk4mRjfO
         NMLENOqxmZvhSEPNuzYgXh1CIdskUDOAzniyiTPpp+6SJZhlzYwHIn0rsE4GObpAQKPP
         CJsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=70/WXuRSOVM+Cc9ViyI6lDUSxH+eDXC41IovFsWbeYs=;
        b=AkA7rHEAi0e2dGCbv3tk0Wcbf7jyO6RkDB8d8ODgi371c9rFYrDEHlQ6ngY6FdHVCX
         VhlIsCWGeq6rDZERGFfK2zZC3fxKYUV7O1JhGlGd3qhQ0enCoiA7L0GoNrgGSMxsTvPV
         AXiMVerjHndyMTdxnmX5snLEMAig6y+sDlTLU5xpQAuQAbBsF/rDt97wKciOul6cWqa+
         HEyxE2mvJW28J/R4wNX+7vG6h/91TlRXrxAewB9qUGaH3meXEeBE3tCu9JWvm4U7p/xA
         g8tQtoPZtDB5E/zW3l02ZEb4OSM0zRTyEmdlChpwUM63QUCbwBzVTtj2w7X+S5HgIBhH
         QhIQ==
X-Gm-Message-State: AOAM531uEE1igVyMS5icD3EqClKlGxN6s8TNkjzDgB+D0lQWoWLtBPYT
        QSuCQPHgUw+sqfAo91h9las=
X-Google-Smtp-Source: ABdhPJw+oRcabyeXlR7veCmXYel+3+bxwvoQzsVviymeaR2MbFVB6NWM8xsX1yZHtzLpbix2jLBDXA==
X-Received: by 2002:aca:4187:: with SMTP id o129mr3872937oia.10.1617725401042;
        Tue, 06 Apr 2021 09:10:01 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r22sm4644989otg.4.2021.04.06.09.10.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Apr 2021 09:10:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 6 Apr 2021 09:09:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Russell King <linux@armlinux.org.uk>,
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
Subject: Re: [PATCH v3 08/15] arm64: socfpga: merge Agilex and N5X into
 ARCH_INTEL_SOCFPGA
Message-ID: <20210406160959.GA208060@roeck-us.net>
References: <20210311152545.1317581-1-krzysztof.kozlowski@canonical.com>
 <20210311152545.1317581-9-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311152545.1317581-9-krzysztof.kozlowski@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 04:25:38PM +0100, Krzysztof Kozlowski wrote:
> Agilex, N5X and Stratix 10 share all quite similar arm64 hard cores and
> SoC-part.  Up to a point that N5X uses the same DTSI as Agilex.  From
> the Linux kernel point of view these are flavors of the same
> architecture so there is no need for three top-level arm64
> architectures.  Simplify this by merging all three architectures into
> ARCH_INTEL_SOCFPGA and dropping the other ARCH* arm64 Kconfig entries.
> 
> The side effect is that the INTEL_STRATIX10_SERVICE will now be
> available for both 32-bit and 64-bit Intel SoCFPGA, even though it is
> used only for 64-bit.

Did you try to compile, say, arm:allmodconfig with this patch applied ?
Because for me that results in:

In file included from <command-line>:
drivers/firmware/stratix10-rsu.c: In function 'rsu_status_callback':
include/linux/compiler_types.h:320:38: error:
	call to '__compiletime_assert_177' declared with attribute error:
	FIELD_GET: type of reg too small for mask

and lots of similar errors.

Guenter

> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  arch/arm64/Kconfig.platforms       | 21 ++++-----------------
>  arch/arm64/boot/dts/intel/Makefile |  6 +++---
>  arch/arm64/configs/defconfig       |  3 +--
>  drivers/clk/Makefile               |  2 --
>  drivers/clk/socfpga/Kconfig        |  4 ++--
>  drivers/firmware/Kconfig           |  2 +-
>  drivers/fpga/Kconfig               |  2 +-
>  drivers/reset/Kconfig              |  2 +-
>  8 files changed, 13 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platforms
> index ecab67a1afb8..ce50dd129eec 100644
> --- a/arch/arm64/Kconfig.platforms
> +++ b/arch/arm64/Kconfig.platforms
> @@ -8,16 +8,6 @@ config ARCH_ACTIONS
>  	help
>  	  This enables support for the Actions Semiconductor S900 SoC family.
>  
> -config ARCH_AGILEX
> -	bool "Intel's Agilex SoCFPGA Family"
> -	help
> -	  This enables support for Intel's Agilex SoCFPGA Family.
> -
> -config ARCH_N5X
> -	bool "Intel's eASIC N5X SoCFPGA Family"
> -	help
> -	  This enables support for Intel's eASIC N5X SoCFPGA Family.
> -
>  config ARCH_SUNXI
>  	bool "Allwinner sunxi 64-bit SoC Family"
>  	select ARCH_HAS_RESET_CONTROLLER
> @@ -254,14 +244,11 @@ config ARCH_SEATTLE
>  	help
>  	  This enables support for AMD Seattle SOC Family
>  
> -config ARCH_STRATIX10
> -	bool "Altera's Stratix 10 SoCFPGA Family"
> -	select ARCH_INTEL_SOCFPGA
> -	help
> -	  This enables support for Altera's Stratix 10 SoCFPGA Family.
> -
>  config ARCH_INTEL_SOCFPGA
> -	bool
> +	bool "Intel's SoCFPGA ARMv8 Families"
> +	help
> +	  This enables support for Intel's SoCFPGA ARMv8 families:
> +	  Stratix 10 (ex. Altera), Agilex and eASIC N5X.
>  
>  config ARCH_SYNQUACER
>  	bool "Socionext SynQuacer SoC Family"
> diff --git a/arch/arm64/boot/dts/intel/Makefile b/arch/arm64/boot/dts/intel/Makefile
> index 3a052540605b..0b5477442263 100644
> --- a/arch/arm64/boot/dts/intel/Makefile
> +++ b/arch/arm64/boot/dts/intel/Makefile
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -dtb-$(CONFIG_ARCH_AGILEX) += socfpga_agilex_socdk.dtb \
> -			     socfpga_agilex_socdk_nand.dtb
> +dtb-$(CONFIG_ARCH_INTEL_SOCFPGA) += socfpga_agilex_socdk.dtb \
> +				socfpga_agilex_socdk_nand.dtb \
> +				socfpga_n5x_socdk.dtb
>  dtb-$(CONFIG_ARCH_KEEMBAY) += keembay-evm.dtb
> -dtb-$(CONFIG_ARCH_N5X) += socfpga_n5x_socdk.dtb
> diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
> index d612f633b771..cf8a3009b858 100644
> --- a/arch/arm64/configs/defconfig
> +++ b/arch/arm64/configs/defconfig
> @@ -28,7 +28,6 @@ CONFIG_KALLSYMS_ALL=y
>  # CONFIG_COMPAT_BRK is not set
>  CONFIG_PROFILING=y
>  CONFIG_ARCH_ACTIONS=y
> -CONFIG_ARCH_AGILEX=y
>  CONFIG_ARCH_SUNXI=y
>  CONFIG_ARCH_ALPINE=y
>  CONFIG_ARCH_BCM2835=y
> @@ -50,7 +49,7 @@ CONFIG_ARCH_RENESAS=y
>  CONFIG_ARCH_ROCKCHIP=y
>  CONFIG_ARCH_S32=y
>  CONFIG_ARCH_SEATTLE=y
> -CONFIG_ARCH_STRATIX10=y
> +CONFIG_ARCH_INTEL_SOCFPGA=y
>  CONFIG_ARCH_SYNQUACER=y
>  CONFIG_ARCH_TEGRA=y
>  CONFIG_ARCH_SPRD=y
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 1e29e5ad107a..96802294d35a 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -105,8 +105,6 @@ obj-$(CONFIG_ARCH_ROCKCHIP)		+= rockchip/
>  obj-$(CONFIG_COMMON_CLK_SAMSUNG)	+= samsung/
>  obj-$(CONFIG_CLK_SIFIVE)		+= sifive/
>  obj-$(CONFIG_ARCH_INTEL_SOCFPGA)	+= socfpga/
> -obj-$(CONFIG_ARCH_AGILEX)		+= socfpga/
> -obj-$(CONFIG_ARCH_N5X)			+= socfpga/
>  obj-$(CONFIG_PLAT_SPEAR)		+= spear/
>  obj-y					+= sprd/
>  obj-$(CONFIG_ARCH_STI)			+= st/
> diff --git a/drivers/clk/socfpga/Kconfig b/drivers/clk/socfpga/Kconfig
> index bc102e0f0be0..b6c5b9737174 100644
> --- a/drivers/clk/socfpga/Kconfig
> +++ b/drivers/clk/socfpga/Kconfig
> @@ -2,5 +2,5 @@
>  config CLK_INTEL_SOCFPGA64
>  	bool
>  	# Intel Stratix / Agilex / N5X clock controller support
> -	default (ARCH_AGILEX || ARCH_N5X || ARCH_STRATIX10)
> -	depends on ARCH_AGILEX || ARCH_N5X || ARCH_STRATIX10
> +	default ARM64 && ARCH_INTEL_SOCFPGA
> +	depends on ARM64 && ARCH_INTEL_SOCFPGA
> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index 3f14dffb9669..6a4e882e448d 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -206,7 +206,7 @@ config FW_CFG_SYSFS_CMDLINE
>  
>  config INTEL_STRATIX10_SERVICE
>  	tristate "Intel Stratix10 Service Layer"
> -	depends on (ARCH_STRATIX10 || ARCH_AGILEX) && HAVE_ARM_SMCCC
> +	depends on ARCH_INTEL_SOCFPGA && HAVE_ARM_SMCCC
>  	default n
>  	help
>  	  Intel Stratix10 service layer runs at privileged exception level,
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> index 5ff9438b7b46..fd325e9c5ce6 100644
> --- a/drivers/fpga/Kconfig
> +++ b/drivers/fpga/Kconfig
> @@ -60,7 +60,7 @@ config FPGA_MGR_ZYNQ_FPGA
>  
>  config FPGA_MGR_STRATIX10_SOC
>  	tristate "Intel Stratix10 SoC FPGA Manager"
> -	depends on (ARCH_STRATIX10 && INTEL_STRATIX10_SERVICE)
> +	depends on (ARCH_INTEL_SOCFPGA && INTEL_STRATIX10_SERVICE)
>  	help
>  	  FPGA manager driver support for the Intel Stratix10 SoC.
>  
> diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
> index 4171c6f76385..b1e8efa16166 100644
> --- a/drivers/reset/Kconfig
> +++ b/drivers/reset/Kconfig
> @@ -183,7 +183,7 @@ config RESET_SCMI
>  
>  config RESET_SIMPLE
>  	bool "Simple Reset Controller Driver" if COMPILE_TEST
> -	default ARCH_AGILEX || ARCH_ASPEED || ARCH_BCM4908 || ARCH_BITMAIN || ARCH_REALTEK || ARCH_STM32 || ARCH_STRATIX10 || ARCH_SUNXI || ARC
> +	default ARCH_ASPEED || ARCH_BCM4908 || ARCH_BITMAIN || ARCH_REALTEK || ARCH_STM32 || (ARCH_INTEL_SOCFPGA && ARM64) || ARCH_SUNXI || ARC
>  	help
>  	  This enables a simple reset controller driver for reset lines that
>  	  that can be asserted and deasserted by toggling bits in a contiguous,
> -- 
> 2.25.1
> 
