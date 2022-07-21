Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF79057C2C4
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 05:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiGUDeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 23:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiGUDd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 23:33:58 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B14F77A51;
        Wed, 20 Jul 2022 20:33:57 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id s18-20020a17090aa11200b001f1e9e2438cso3966984pjp.2;
        Wed, 20 Jul 2022 20:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LnixZrpABN5PEEwrud92GnJX7Fo4kP4jl8q2QWvMo/w=;
        b=Sx2miLaDwwoouPj4ji8DiGqfvzWQ4PvGuDEOj7Z4qBa8mnYhCHu9YjjK8dP8nKQ2ao
         Xl1nCijBsrg5up+U+L5hUqwlqWfZSugVkTv1MBhXv7ZSqKeC4zYqdhlMSy+aN969DwGy
         LBIf5HaK1tGFYZBhOW3MBKs9SbYePIv3nRbTqfnWFVA+Lp7linoQ3EvNHDooSrqkYFIK
         pgVW/34uxSVrP9+3d5LCSFUCY0XFdDd/BVIPeU/nFgck/CrdcvKDCQ9YXTaawd2kuG8G
         5rf6t8+SGrZjggTuWiCFPNNLdIJqv/nVxqV/kBR675zBG7xrUon7mNsAFdnO4dNbBI9O
         UoKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LnixZrpABN5PEEwrud92GnJX7Fo4kP4jl8q2QWvMo/w=;
        b=p2lSwPExI4Jk0vNHRdIYl58ott7lHI7GbmN4QOD02O8D7Dv7YjGdsmzHAP0lBClhB9
         UH7pHbn+OqQDkBkE61jqgr6c4S0HsDEyuELXUUg2eqacCVTpBB0/ws037JMURCZv5eA7
         gw0gg2Y09teE6o3VCXdmN9HO/DSUJjwaE3mXNI2SDtV6XuQ9pQ3TXy7J0ax4pxTepoD6
         uyBV84kUxQtUp09z19c9o/jB8evEbzKDkxFbOER6kw0Omr0eKQTRoZ+iB32QPPapEnu6
         FhZyB03IbPjLTfnOR6OI08XNxnTPPnxJxU/hiG20vtzhoheRwVr8sx98zb+sUAMLTCer
         AyuA==
X-Gm-Message-State: AJIora85zXT8fu4T082urdTQJUondqAomxfSX8AV9Ixc7i09rpxSYGxz
        oBfWn+Xq5CYZOdHYTsg448c=
X-Google-Smtp-Source: AGRyM1syJOt6KFT4Jm22y+DPnnFnol3qZ/uTo7TZ+MyZWYxlEL6gc4ZE/+gj7dS3qqudqGm0zdM0IA==
X-Received: by 2002:a17:90b:164c:b0:1f2:31f5:7d68 with SMTP id il12-20020a17090b164c00b001f231f57d68mr696160pjb.5.1658374436842;
        Wed, 20 Jul 2022 20:33:56 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y5-20020a17090322c500b0016d2ef2b7b9sm347736plg.56.2022.07.20.20.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 20:33:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <dc9a6f40-ae8c-b025-7ac5-13d28150dd88@roeck-us.net>
Date:   Wed, 20 Jul 2022 20:33:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RESEND PATCH 6/9] arm64: bcmbca: Make BCM4908 drivers depend on
 ARCH_BCMBCA
Content-Language: en-US
To:     William Zhang <william.zhang@broadcom.com>,
        Linux ARM List <linux-arm-kernel@lists.infradead.org>
Cc:     joel.peshkin@broadcom.com, dan.beygelman@broadcom.com,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "open list:I2C SUBSYSTEM HOST DRIVERS" <linux-i2c@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:MEMORY TECHNOLOGY DEVICES (MTD)" 
        <linux-mtd@lists.infradead.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:PCI NATIVE HOST BRIDGE AND ENDPOINT DRIVERS" 
        <linux-pci@vger.kernel.org>,
        "open list:GENERIC PHY FRAMEWORK" <linux-phy@lists.infradead.org>,
        "open list:PIN CONTROL SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:BROADCOM BMIPS MIPS ARCHITECTURE" 
        <linux-mips@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:WATCHDOG DEVICE DRIVERS" <linux-watchdog@vger.kernel.org>
References: <20220721000740.29624-1-william.zhang@broadcom.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220721000740.29624-1-william.zhang@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/22 17:07, William Zhang wrote:
> Replace ARCH_BCM4908 with ARCH_BCMBCA in subsystem Kconfig files.
> 
> Signed-off-by: William Zhang <william.zhang@broadcom.com>
> ---
> 
>   drivers/i2c/busses/Kconfig            | 4 ++--
>   drivers/mtd/parsers/Kconfig           | 6 +++---
>   drivers/net/ethernet/broadcom/Kconfig | 4 ++--
>   drivers/pci/controller/Kconfig        | 2 +-
>   drivers/phy/broadcom/Kconfig          | 4 ++--
>   drivers/pinctrl/bcm/Kconfig           | 4 ++--
>   drivers/reset/Kconfig                 | 2 +-
>   drivers/soc/bcm/bcm63xx/Kconfig       | 4 ++--
>   drivers/tty/serial/Kconfig            | 4 ++--
>   drivers/watchdog/Kconfig              | 2 +-

For watchdog:

Acked-by: Guenter Roeck <linux@roeck-us.net>

>   10 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 45a4e9f1b639..fd9a4dd01997 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -487,8 +487,8 @@ config I2C_BCM_KONA
>   
>   config I2C_BRCMSTB
>   	tristate "BRCM Settop/DSL I2C controller"
> -	depends on ARCH_BCM2835 || ARCH_BCM4908 || ARCH_BCMBCA || \
> -		   ARCH_BRCMSTB || BMIPS_GENERIC || COMPILE_TEST
> +	depends on ARCH_BCM2835 || ARCH_BCMBCA || ARCH_BRCMSTB || \
> +		   BMIPS_GENERIC || COMPILE_TEST
>   	default y
>   	help
>   	  If you say yes to this option, support will be included for the
> diff --git a/drivers/mtd/parsers/Kconfig b/drivers/mtd/parsers/Kconfig
> index b43df73927a0..d6db655a1d24 100644
> --- a/drivers/mtd/parsers/Kconfig
> +++ b/drivers/mtd/parsers/Kconfig
> @@ -69,8 +69,8 @@ config MTD_OF_PARTS
>   
>   config MTD_OF_PARTS_BCM4908
>   	bool "BCM4908 partitioning support"
> -	depends on MTD_OF_PARTS && (ARCH_BCM4908 || COMPILE_TEST)
> -	default ARCH_BCM4908
> +	depends on MTD_OF_PARTS && (ARCH_BCMBCA || COMPILE_TEST)
> +	default ARCH_BCMBCA
>   	help
>   	  This provides partitions parser for BCM4908 family devices
>   	  that can have multiple "firmware" partitions. It takes care of
> @@ -78,7 +78,7 @@ config MTD_OF_PARTS_BCM4908
>   
>   config MTD_OF_PARTS_LINKSYS_NS
>   	bool "Linksys Northstar partitioning support"
> -	depends on MTD_OF_PARTS && (ARCH_BCM_5301X || ARCH_BCM4908 || COMPILE_TEST)
> +	depends on MTD_OF_PARTS && (ARCH_BCM_5301X || ARCH_BCMBCA || COMPILE_TEST)
>   	default ARCH_BCM_5301X
>   	help
>   	  This provides partitions parser for Linksys devices based on Broadcom
> diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
> index 56e0fb07aec7..f4e1ca68d831 100644
> --- a/drivers/net/ethernet/broadcom/Kconfig
> +++ b/drivers/net/ethernet/broadcom/Kconfig
> @@ -53,8 +53,8 @@ config B44_PCI
>   
>   config BCM4908_ENET
>   	tristate "Broadcom BCM4908 internal mac support"
> -	depends on ARCH_BCM4908 || COMPILE_TEST
> -	default y if ARCH_BCM4908
> +	depends on ARCH_BCMBCA || COMPILE_TEST
> +	default y if ARCH_BCMBCA
>   	help
>   	  This driver supports Ethernet controller integrated into Broadcom
>   	  BCM4908 family SoCs.
> diff --git a/drivers/pci/controller/Kconfig b/drivers/pci/controller/Kconfig
> index d1c5fcf00a8a..bfd9bac37e24 100644
> --- a/drivers/pci/controller/Kconfig
> +++ b/drivers/pci/controller/Kconfig
> @@ -274,7 +274,7 @@ config VMD
>   
>   config PCIE_BRCMSTB
>   	tristate "Broadcom Brcmstb PCIe host controller"
> -	depends on ARCH_BRCMSTB || ARCH_BCM2835 || ARCH_BCM4908 || \
> +	depends on ARCH_BRCMSTB || ARCH_BCM2835 || ARCH_BCMBCA || \
>   		   BMIPS_GENERIC || COMPILE_TEST
>   	depends on OF
>   	depends on PCI_MSI_IRQ_DOMAIN
> diff --git a/drivers/phy/broadcom/Kconfig b/drivers/phy/broadcom/Kconfig
> index 93a6a8ee4716..1d89a2fd9b79 100644
> --- a/drivers/phy/broadcom/Kconfig
> +++ b/drivers/phy/broadcom/Kconfig
> @@ -93,11 +93,11 @@ config PHY_BRCM_SATA
>   
>   config PHY_BRCM_USB
>   	tristate "Broadcom STB USB PHY driver"
> -	depends on ARCH_BCM4908 || ARCH_BRCMSTB || COMPILE_TEST
> +	depends on ARCH_BCMBCA || ARCH_BRCMSTB || COMPILE_TEST
>   	depends on OF
>   	select GENERIC_PHY
>   	select SOC_BRCMSTB if ARCH_BRCMSTB
> -	default ARCH_BCM4908 || ARCH_BRCMSTB
> +	default ARCH_BCMBCA || ARCH_BRCMSTB
>   	help
>   	  Enable this to support the Broadcom STB USB PHY.
>   	  This driver is required by the USB XHCI, EHCI and OHCI
> diff --git a/drivers/pinctrl/bcm/Kconfig b/drivers/pinctrl/bcm/Kconfig
> index 8f4d89806fcb..35b51ce4298e 100644
> --- a/drivers/pinctrl/bcm/Kconfig
> +++ b/drivers/pinctrl/bcm/Kconfig
> @@ -31,13 +31,13 @@ config PINCTRL_BCM2835
>   
>   config PINCTRL_BCM4908
>   	tristate "Broadcom BCM4908 pinmux driver"
> -	depends on OF && (ARCH_BCM4908 || COMPILE_TEST)
> +	depends on OF && (ARCH_BCMBCA || COMPILE_TEST)
>   	select PINMUX
>   	select PINCONF
>   	select GENERIC_PINCONF
>   	select GENERIC_PINCTRL_GROUPS
>   	select GENERIC_PINMUX_FUNCTIONS
> -	default ARCH_BCM4908
> +	default ARCH_BCMBCA
>   	help
>   	  Driver for BCM4908 family SoCs with integrated pin controller.
>   
> diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
> index f9a7cee01659..7ae71535fe2a 100644
> --- a/drivers/reset/Kconfig
> +++ b/drivers/reset/Kconfig
> @@ -201,7 +201,7 @@ config RESET_SCMI
>   
>   config RESET_SIMPLE
>   	bool "Simple Reset Controller Driver" if COMPILE_TEST || EXPERT
> -	default ARCH_ASPEED || ARCH_BCM4908 || ARCH_BITMAIN || ARCH_REALTEK || ARCH_STM32 || (ARCH_INTEL_SOCFPGA && ARM64) || ARCH_SUNXI || ARC
> +	default ARCH_ASPEED || ARCH_BCMBCA || ARCH_BITMAIN || ARCH_REALTEK || ARCH_STM32 || (ARCH_INTEL_SOCFPGA && ARM64) || ARCH_SUNXI || ARC
>   	help
>   	  This enables a simple reset controller driver for reset lines that
>   	  that can be asserted and deasserted by toggling bits in a contiguous,
> diff --git a/drivers/soc/bcm/bcm63xx/Kconfig b/drivers/soc/bcm/bcm63xx/Kconfig
> index 9e501c8ac5ce..355c34482076 100644
> --- a/drivers/soc/bcm/bcm63xx/Kconfig
> +++ b/drivers/soc/bcm/bcm63xx/Kconfig
> @@ -13,8 +13,8 @@ endif # SOC_BCM63XX
>   
>   config BCM_PMB
>   	bool "Broadcom PMB (Power Management Bus) driver"
> -	depends on ARCH_BCM4908 || (COMPILE_TEST && OF)
> -	default ARCH_BCM4908
> +	depends on ARCH_BCMBCA || (COMPILE_TEST && OF)
> +	default ARCH_BCMBCA
>   	select PM_GENERIC_DOMAINS if PM
>   	help
>   	  This enables support for the Broadcom's PMB (Power Management Bus) that
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index e3279544b03c..f32bb01c3feb 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -1100,8 +1100,8 @@ config SERIAL_TIMBERDALE
>   config SERIAL_BCM63XX
>   	tristate "Broadcom BCM63xx/BCM33xx UART support"
>   	select SERIAL_CORE
> -	depends on ARCH_BCM4908 || ARCH_BCMBCA || BCM63XX || BMIPS_GENERIC || COMPILE_TEST
> -	default ARCH_BCM4908 || ARCH_BCMBCA || BCM63XX || BMIPS_GENERIC
> +	depends on ARCH_BCMBCA || BCM63XX || BMIPS_GENERIC || COMPILE_TEST
> +	default ARCH_BCMBCA || BCM63XX || BMIPS_GENERIC
>   	help
>   	  This enables the driver for the onchip UART core found on
>   	  the following chipsets:
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 32fd37698932..1f85ec8a4b3b 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -1798,7 +1798,7 @@ config BCM7038_WDT
>   	tristate "BCM63xx/BCM7038 Watchdog"
>   	select WATCHDOG_CORE
>   	depends on HAS_IOMEM
> -	depends on ARCH_BCM4908 || ARCH_BRCMSTB || BMIPS_GENERIC || BCM63XX || COMPILE_TEST
> +	depends on ARCH_BCMBCA || ARCH_BRCMSTB || BMIPS_GENERIC || BCM63XX || COMPILE_TEST
>   	help
>   	  Watchdog driver for the built-in hardware in Broadcom 7038 and
>   	  later SoCs used in set-top boxes.  BCM7038 was made public

