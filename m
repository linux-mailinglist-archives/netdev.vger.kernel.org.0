Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAEA74D9999
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 11:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348234AbiCOKxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 06:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345262AbiCOKwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 06:52:40 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20565419B
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 03:50:06 -0700 (PDT)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 642733F7DF
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 10:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647341402;
        bh=Ey8drcAf2R1SHpM1HZTEkJQdDVCwzHfEqgUU/nFist8=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=wEgr95DVAQKqKspxmQCvvdS7ZucL8jSl4WmM+1juRdRGNkjjb5PXDm6Ds8LaRO2F8
         FDSEVN+msHKdefpwa6DB/wEacjvuaPNuZIBikN+AKXFHz9s/J2KLvgX0X3r4GgRCIf
         lsBgQ3qFAxAcpUnzxTiOvrbcv62wmEuqcmjr54HwYs0mSza13S2ZAQtd4kMMJnXag7
         nD6laUbkwGCfGvbC4c2Z+H79Rt9qzX3zd3zvstwKawcOqRqtqMvxIMzCntuvHKmQqK
         W/zOboJ44n5k/tUXPR2GsCUU5ir5Iel5iN6wWEErAWyGgQI+PwXm5WL2i7y1lHi8tP
         Mxt2SATiHxN0Q==
Received: by mail-ed1-f69.google.com with SMTP id s9-20020a50d489000000b00418d556edbdso338402edi.4
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 03:50:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ey8drcAf2R1SHpM1HZTEkJQdDVCwzHfEqgUU/nFist8=;
        b=16wxBfuUBXT+VmfevziA1748RWdfYUUG4iwCIl2SCuq8qQGsYbcVM6Ykr9+HFLRJQd
         fgRIQ36exM+fDtnJ9fRDDn6cwUi41P5RV1ttHcK+0ds0gy3pFBcZVSxU3rJUPrc7dLnn
         HeJBlwDjA5JC44SMXzpAmPGxlo+xQa8ny3y+lgF/LusnGnpRcqXEcOXk935fW6M1Li/6
         XNJYJmPcx8LTL+ZqpXDf+dAU69h4oJhUdYtuVQcI7LKZcZ+xyJtr6k3GhVb0PiCmj/By
         PKlMeFIZmND4m1BE8QyHyKukpdMTVzSdcCZwU4ACKgPPLZrU7M3Th5WKuyfPP+MpObit
         Dlvg==
X-Gm-Message-State: AOAM5315aapiU+yefeNlW0VQd+W/3UiEl6yhzuHco0CcxgUE2QZbapX4
        dszZra+9vaMRGf+3fThguV3Fm6NwWsti80BxjlhmALND+WZM1o5Q59WgecucmDLKhjTIg6g0k7m
        MKStJJbIBUD2JWDNHl55xsRQ73R3cbh37DA==
X-Received: by 2002:a17:906:154c:b0:6ce:21d7:2826 with SMTP id c12-20020a170906154c00b006ce21d72826mr22475599ejd.9.1647341401564;
        Tue, 15 Mar 2022 03:50:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyF9UaD6/CVW3zUoCDdkgb4OFu0x67auCClmiRFX0zBBedOf/2/kXyNEMIzdX3QM2hJInyqOQ==
X-Received: by 2002:a17:906:154c:b0:6ce:21d7:2826 with SMTP id c12-20020a170906154c00b006ce21d72826mr22475571ejd.9.1647341401319;
        Tue, 15 Mar 2022 03:50:01 -0700 (PDT)
Received: from [192.168.0.155] (xdsl-188-155-174-239.adslplus.ch. [188.155.174.239])
        by smtp.googlemail.com with ESMTPSA id v6-20020a17090651c600b006d5c69301e4sm8012981ejk.202.2022.03.15.03.49.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 03:50:00 -0700 (PDT)
Message-ID: <04ed13f1-671f-7416-61d0-0bf452ae862e@canonical.com>
Date:   Tue, 15 Mar 2022 11:49:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 4/8] pinctrl: mvebu: pinctrl driver for 98DX2530 SoC
Content-Language: en-US
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        huziji@marvell.com, ulf.hansson@linaro.org, robh+dt@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        catalin.marinas@arm.com, will@kernel.org, andrew@lunn.ch,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        adrian.hunter@intel.com, thomas.petazzoni@bootlin.com,
        kostap@marvell.com, robert.marko@sartura.hr
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
 <20220314213143.2404162-5-chris.packham@alliedtelesis.co.nz>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220314213143.2404162-5-chris.packham@alliedtelesis.co.nz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2022 22:31, Chris Packham wrote:
> This pinctrl driver supports the 98DX25xx and 98DX35xx family of chips
> from Marvell. It is based on the Marvell SDK with additions for various
> (non-gpio) pin configurations based on the datasheet.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> ---
> 
> Notes:
>     Changes in v2:
>     - Make pinctrl a child of a syscon node like the armada-7k-pinctrl
> 
>  drivers/pinctrl/mvebu/Kconfig       |   4 +
>  drivers/pinctrl/mvebu/Makefile      |   1 +
>  drivers/pinctrl/mvebu/pinctrl-ac5.c | 226 ++++++++++++++++++++++++++++
>  3 files changed, 231 insertions(+)
>  create mode 100644 drivers/pinctrl/mvebu/pinctrl-ac5.c
> 
> diff --git a/drivers/pinctrl/mvebu/Kconfig b/drivers/pinctrl/mvebu/Kconfig
> index 0d12894d3ee1..aa5883f09d7b 100644
> --- a/drivers/pinctrl/mvebu/Kconfig
> +++ b/drivers/pinctrl/mvebu/Kconfig
> @@ -45,6 +45,10 @@ config PINCTRL_ORION
>  	bool
>  	select PINCTRL_MVEBU
>  
> +config PINCTRL_AC5
> +	bool
> +	select PINCTRL_MVEBU
> +
>  config PINCTRL_ARMADA_37XX
>  	bool
>  	select GENERIC_PINCONF
> diff --git a/drivers/pinctrl/mvebu/Makefile b/drivers/pinctrl/mvebu/Makefile
> index cd082dca4482..23458ab17c53 100644
> --- a/drivers/pinctrl/mvebu/Makefile
> +++ b/drivers/pinctrl/mvebu/Makefile
> @@ -11,3 +11,4 @@ obj-$(CONFIG_PINCTRL_ARMADA_CP110) += pinctrl-armada-cp110.o
>  obj-$(CONFIG_PINCTRL_ARMADA_XP)  += pinctrl-armada-xp.o
>  obj-$(CONFIG_PINCTRL_ARMADA_37XX)  += pinctrl-armada-37xx.o
>  obj-$(CONFIG_PINCTRL_ORION)  += pinctrl-orion.o
> +obj-$(CONFIG_PINCTRL_AC5) += pinctrl-ac5.o
> diff --git a/drivers/pinctrl/mvebu/pinctrl-ac5.c b/drivers/pinctrl/mvebu/pinctrl-ac5.c
> new file mode 100644
> index 000000000000..8bc0bbff7c1b
> --- /dev/null
> +++ b/drivers/pinctrl/mvebu/pinctrl-ac5.c
> @@ -0,0 +1,226 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Marvell ac5 pinctrl driver based on mvebu pinctrl core
> + *
> + * Copyright (C) 2021 Marvell
> + *
> + * Noam Liron <lnoam@marvell.com>
> + */
> +
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/pinctrl/pinctrl.h>
> +
> +#include "pinctrl-mvebu.h"
> +
> +static struct mvebu_mpp_mode ac5_mpp_modes[] = {
> +	MPP_MODE(0,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "sdio",  "d0"),
> +		 MPP_FUNCTION(2, "nand",  "io4")),
> +	MPP_MODE(1,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "sdio",  "d1"),
> +		 MPP_FUNCTION(2, "nand",  "io3")),
> +	MPP_MODE(2,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "sdio",  "d2"),
> +		 MPP_FUNCTION(2, "nand",  "io2")),
> +	MPP_MODE(3,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "sdio",  "d3"),
> +		 MPP_FUNCTION(2, "nand",  "io7")),
> +	MPP_MODE(4,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "sdio",  "d4"),
> +		 MPP_FUNCTION(2, "nand",  "io6"),
> +		 MPP_FUNCTION(3, "uart3", "txd"),
> +		 MPP_FUNCTION(4, "uart2", "txd")),
> +	MPP_MODE(5,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "sdio",  "d5"),
> +		 MPP_FUNCTION(2, "nand",  "io5"),
> +		 MPP_FUNCTION(3, "uart3", "rxd"),
> +		 MPP_FUNCTION(4, "uart2", "rxd")),
> +	MPP_MODE(6,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "sdio",  "d6"),
> +		 MPP_FUNCTION(2, "nand",  "io0"),
> +		 MPP_FUNCTION(3, "i2c1",  "sck")),
> +	MPP_MODE(7,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "sdio",  "d7"),
> +		 MPP_FUNCTION(2, "nand",  "io1"),
> +		 MPP_FUNCTION(3, "i2c1",  "sda")),
> +	MPP_MODE(8,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "sdio",  "clk"),
> +		 MPP_FUNCTION(2, "nand",  "wen")),
> +	MPP_MODE(9,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "sdio",  "cmd"),
> +		 MPP_FUNCTION(2, "nand",  "ale")),
> +	MPP_MODE(10,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "sdio",  "ds"),
> +		 MPP_FUNCTION(2, "nand",  "cle")),
> +	MPP_MODE(11,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "sdio",  "rst"),
> +		 MPP_FUNCTION(2, "nand",  "cen")),
> +	MPP_MODE(12,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "spi0",  "clk")),
> +	MPP_MODE(13,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "spi0",  "csn")),
> +	MPP_MODE(14,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "spi0",  "mosi")),
> +	MPP_MODE(15,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "spi0",  "miso")),
> +	MPP_MODE(16,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "spi0",  "wpn"),
> +		 MPP_FUNCTION(2, "nand",  "ren"),
> +		 MPP_FUNCTION(3, "uart1", "txd")),
> +	MPP_MODE(17,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "spi0",  "hold"),
> +		 MPP_FUNCTION(2, "nand",  "rb"),
> +		 MPP_FUNCTION(3, "uart1", "rxd")),
> +	MPP_MODE(18,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(2, "uart2", "rxd")),
> +	MPP_MODE(19,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(2, "uart2", "txd")),
> +	MPP_MODE(20,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(2, "i2c1",  "sck"),
> +		 MPP_FUNCTION(3, "spi1",  "clk"),
> +		 MPP_FUNCTION(4, "uart3", "txd")),
> +	MPP_MODE(21,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(2, "i2c1",  "sda"),
> +		 MPP_FUNCTION(3, "spi1",  "csn"),
> +		 MPP_FUNCTION(4, "uart3", "rxd")),
> +	MPP_MODE(22,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(3, "spi1",  "mosi")),
> +	MPP_MODE(23,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(3, "spi1",  "miso")),
> +	MPP_MODE(24,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(2, "uart2", "txd")),
> +	MPP_MODE(25,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(2, "uart2", "rxd")),
> +	MPP_MODE(26,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "i2c0",  "sck"),
> +		 MPP_FUNCTION(3, "uart3", "txd")),
> +	MPP_MODE(27,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "i2c0",  "sda"),
> +		 MPP_FUNCTION(3, "uart3", "rxd")),
> +	MPP_MODE(28,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(3, "uart3", "txd")),
> +	MPP_MODE(29,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(3, "uart3", "rxd")),
> +	MPP_MODE(30,
> +		 MPP_FUNCTION(0, "gpio",  NULL)),
> +	MPP_MODE(31,
> +		 MPP_FUNCTION(0, "gpio",  NULL)),
> +	MPP_MODE(32,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "uart0", "txd")),
> +	MPP_MODE(33,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(1, "uart0", "rxd")),
> +	MPP_MODE(34,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(2, "uart3", "rxd")),
> +	MPP_MODE(35,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(2, "uart3", "txd")),
> +	MPP_MODE(36,
> +		 MPP_FUNCTION(0, "gpio",  NULL)),
> +	MPP_MODE(37,
> +		 MPP_FUNCTION(0, "gpio",  NULL)),
> +	MPP_MODE(38,
> +		 MPP_FUNCTION(0, "gpio",  NULL)),
> +	MPP_MODE(39,
> +		 MPP_FUNCTION(0, "gpio",  NULL)),
> +	MPP_MODE(40,
> +		 MPP_FUNCTION(0, "gpio",  NULL)),
> +	MPP_MODE(41,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(4, "uart2", "txd"),
> +		 MPP_FUNCTION(5, "i2c1",  "sck")),
> +	MPP_MODE(42,
> +		 MPP_FUNCTION(0, "gpio",  NULL),
> +		 MPP_FUNCTION(4, "uart2", "rxd"),
> +		 MPP_FUNCTION(5, "i2c1",  "sda")),
> +	MPP_MODE(43,
> +		 MPP_FUNCTION(0, "gpio",  NULL)),
> +	MPP_MODE(44,
> +		 MPP_FUNCTION(0, "gpio",  NULL)),
> +	MPP_MODE(45,
> +		 MPP_FUNCTION(0, "gpio",  NULL)),
> +};
> +
> +static struct mvebu_pinctrl_soc_info ac5_pinctrl_info;

You should not have static/file-scope variables, especially that it is
not actually used in that way.

> +
> +static const struct of_device_id ac5_pinctrl_of_match[] = {
> +	{
> +		.compatible = "marvell,ac5-pinctrl",
> +	},
> +	{ },
> +};
> +
> +static const struct mvebu_mpp_ctrl ac5_mpp_controls[] = {
> +	MPP_FUNC_CTRL(0, 45, NULL, mvebu_regmap_mpp_ctrl), };
> +
> +static struct pinctrl_gpio_range ac5_mpp_gpio_ranges[] = {
> +	MPP_GPIO_RANGE(0,   0,  0, 46), };
> +
> +static int ac5_pinctrl_probe(struct platform_device *pdev)
> +{
> +	struct mvebu_pinctrl_soc_info *soc = &ac5_pinctrl_info;
> +	const struct of_device_id *match =
> +		of_match_device(ac5_pinctrl_of_match, &pdev->dev);

Why is this needed? Unusual, dead-code.

> +
> +	if (!match || !pdev->dev.parent)
> +		return -ENODEV;
> +
> +	soc->variant = 0; /* no variants for ac5 */
> +	soc->controls = ac5_mpp_controls;
> +	soc->ncontrols = ARRAY_SIZE(ac5_mpp_controls);
> +	soc->gpioranges = ac5_mpp_gpio_ranges;
> +	soc->ngpioranges = ARRAY_SIZE(ac5_mpp_gpio_ranges);
> +	soc->modes = ac5_mpp_modes;
> +	soc->nmodes = ac5_mpp_controls[0].npins;
> +
> +	pdev->dev.platform_data = soc;
> +
> +	return mvebu_pinctrl_simple_regmap_probe(pdev, pdev->dev.parent, 0);
> +}
> +
> +static struct platform_driver ac5_pinctrl_driver = {
> +	.driver = {
> +		.name = "ac5-pinctrl",
> +		.of_match_table = of_match_ptr(ac5_pinctrl_of_match),

of_match_ptr() does not look correct for OF-only platform. This should
complain in W=1 compile tests on !OF config.

Best regards,
Krzysztof
