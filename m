Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D8D5ECF17
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 23:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbiI0VEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 17:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbiI0VEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 17:04:21 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EAA1ED21E;
        Tue, 27 Sep 2022 14:04:17 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id rk17so10049356ejb.1;
        Tue, 27 Sep 2022 14:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=dwJjSyJsER8fu8KaFJu/+9H/JRzimbvYtz7bUiJaAMg=;
        b=LNjkyGy1QJ6wRsWRW9atYqfNX2O5mrLw2YUI0juyHo/Jvf+yMD2xERny2vjwNkUzNQ
         7/S1Eugns/jTgZQp8KvEHNHG7tcL82D3ZEndC4Fv5pcVWMPZl85aAbllnF6zpjhAwGw7
         aq6sL5jJsYFo+Y1QreFAtfDj4tJ45G/vhLn84Ml4wi+v+lPBK4lkiqo21tdhbHkgbjcv
         DjFK7rHfvjajMLuBABPywmc19ftokTM4vFdIefEnI2I7tCyFhRHrk6tBoEcEdj50hgbt
         fXO4uEfkPAMxGD6JQYkoaI2wqP5jePTN0sqqDKOKDeRUTAcQjfMmr1Gf/JAfcjFrThc/
         nHKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=dwJjSyJsER8fu8KaFJu/+9H/JRzimbvYtz7bUiJaAMg=;
        b=DqZLWL7XrcfWivHgyYuLpeGli8FunzFhakS8clvXqJkaxS2Qf8OsTtG6ueLSzah6oA
         xjWcWC+Mjj60J0nJVtNVwjVaFsjpR2ClCawzBepYHV+sFSULMQeOFZRKhwen15W78Llp
         qvekYIVdrRmeT0HG3RRCFZTomfkgDSNbc3K/Fo6ST55tpYUtR6dG2LdZu8Oe7ts2cWp6
         YN6RkDwiJGVJDSni6KMWgaNCH156tewBr4yeq3B4IbNVUlD1ZV7hbsNlTA1joDwiD09m
         K7DSMuT8MUTyWK2W0Q+kqpeOe3vIs83UFTBMR7ySQtOA5l/gVHN0s7gkLx8Iba9U8wok
         4kTg==
X-Gm-Message-State: ACrzQf1GapyMYz/s2xOQOsnDQyCjxJPd6Gbe9ypATiYmHQsvNK7kd56i
        E5xdmB0nefE+2RO2MYRwtDWLc9xDPrFdnrJI
X-Google-Smtp-Source: AMsMyM6i6nNNyLuaK2nxSVMc5/lwEZzu06kWlB9WJ0eeM1NNO6aPdH4Eev68mCA6/c4inVvaCFUkJQ==
X-Received: by 2002:a17:907:3e02:b0:782:1267:f2c8 with SMTP id hp2-20020a1709073e0200b007821267f2c8mr24098245ejc.585.1664312655552;
        Tue, 27 Sep 2022 14:04:15 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id r19-20020a05640251d300b0044f21c69608sm2044515edd.10.2022.09.27.14.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 14:04:14 -0700 (PDT)
Date:   Wed, 28 Sep 2022 00:04:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 11/14] mfd: ocelot: add regmaps for ocelot_ext
Message-ID: <20220927210411.6oc3aphlyp4imgsq@skbuf>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-12-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926002928.2744638-12-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 05:29:25PM -0700, Colin Foster wrote:
> The Ocelot switch core driver relies heavily on a fixed array of resources
> for both ports and peripherals. This is in contrast to existing peripherals
> - pinctrl for example - which have a one-to-one mapping of driver <>
> resource. As such, these regmaps must be created differently so that
> enumeration-based offsets are preserved.
> 
> Register the regmaps to the core MFD device unconditionally so they can be
> referenced by the Ocelot switch / Felix DSA systems.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v3
>     * No change
> 
> v2
>     * Alignment of variables broken out to a separate patch
>     * Structs now correctly use EXPORT_SYMBOL*
>     * Logic moved and comments added to clear up conditionals around
>       vsc7512_target_io_res[i].start
> 
> v1 from previous RFC:
>     * New patch
> 
> ---
>  drivers/mfd/ocelot-core.c  | 87 ++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/ocelot.h |  5 +++
>  2 files changed, 92 insertions(+)
> 
> diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> index 013e83173062..702555fbdcc5 100644
> --- a/drivers/mfd/ocelot-core.c
> +++ b/drivers/mfd/ocelot-core.c
> @@ -45,6 +45,45 @@
>  #define VSC7512_SIO_CTRL_RES_START	0x710700f8
>  #define VSC7512_SIO_CTRL_RES_SIZE	0x00000100
>  
> +#define VSC7512_HSIO_RES_START		0x710d0000
> +#define VSC7512_HSIO_RES_SIZE		0x00000128

I don't think you should give the HSIO resource to the switching driver.
In drivers/net/ethernet/mscc/ocelot_vsc7514.c, there is this comment:

static void ocelot_pll5_init(struct ocelot *ocelot)
{
	/* Configure PLL5. This will need a proper CCF driver
	 * The values are coming from the VTSS API for Ocelot
	 */

I believe CCF stands for Common Clock Framework.

> +
> +#define VSC7512_ANA_RES_START		0x71880000
> +#define VSC7512_ANA_RES_SIZE		0x00010000
> +
> +#define VSC7512_QS_RES_START		0x71080000
> +#define VSC7512_QS_RES_SIZE		0x00000100
> +
> +#define VSC7512_QSYS_RES_START		0x71800000
> +#define VSC7512_QSYS_RES_SIZE		0x00200000
> +
> +#define VSC7512_REW_RES_START		0x71030000
> +#define VSC7512_REW_RES_SIZE		0x00010000
> +
> +#define VSC7512_SYS_RES_START		0x71010000
> +#define VSC7512_SYS_RES_SIZE		0x00010000
> +
> +#define VSC7512_S0_RES_START		0x71040000
> +#define VSC7512_S1_RES_START		0x71050000
> +#define VSC7512_S2_RES_START		0x71060000
> +#define VSC7512_S_RES_SIZE		0x00000400

VCAP_RES_SIZE?

> +
> +#define VSC7512_GCB_RES_START		0x71070000
> +#define VSC7512_GCB_RES_SIZE		0x0000022c

Again, I don't think devcpu_gcb should be given to a switching-only
driver. There's nothing switching-related about it.

> +#define VSC7512_PORT_0_RES_START	0x711e0000
> +#define VSC7512_PORT_1_RES_START	0x711f0000
> +#define VSC7512_PORT_2_RES_START	0x71200000
> +#define VSC7512_PORT_3_RES_START	0x71210000
> +#define VSC7512_PORT_4_RES_START	0x71220000
> +#define VSC7512_PORT_5_RES_START	0x71230000
> +#define VSC7512_PORT_6_RES_START	0x71240000
> +#define VSC7512_PORT_7_RES_START	0x71250000
> +#define VSC7512_PORT_8_RES_START	0x71260000
> +#define VSC7512_PORT_9_RES_START	0x71270000
> +#define VSC7512_PORT_10_RES_START	0x71280000
> +#define VSC7512_PORT_RES_SIZE		0x00010000
> +
>  #define VSC7512_GCB_RST_SLEEP_US	100
>  #define VSC7512_GCB_RST_TIMEOUT_US	100000
>  
> @@ -96,6 +135,36 @@ static const struct resource vsc7512_sgpio_resources[] = {
>  	DEFINE_RES_REG_NAMED(VSC7512_SIO_CTRL_RES_START, VSC7512_SIO_CTRL_RES_SIZE, "gcb_sio"),
>  };
>  
> +const struct resource vsc7512_target_io_res[TARGET_MAX] = {
> +	[ANA] = DEFINE_RES_REG_NAMED(VSC7512_ANA_RES_START, VSC7512_ANA_RES_SIZE, "ana"),
> +	[QS] = DEFINE_RES_REG_NAMED(VSC7512_QS_RES_START, VSC7512_QS_RES_SIZE, "qs"),
> +	[QSYS] = DEFINE_RES_REG_NAMED(VSC7512_QSYS_RES_START, VSC7512_QSYS_RES_SIZE, "qsys"),
> +	[REW] = DEFINE_RES_REG_NAMED(VSC7512_REW_RES_START, VSC7512_REW_RES_SIZE, "rew"),
> +	[SYS] = DEFINE_RES_REG_NAMED(VSC7512_SYS_RES_START, VSC7512_SYS_RES_SIZE, "sys"),
> +	[S0] = DEFINE_RES_REG_NAMED(VSC7512_S0_RES_START, VSC7512_S_RES_SIZE, "s0"),
> +	[S1] = DEFINE_RES_REG_NAMED(VSC7512_S1_RES_START, VSC7512_S_RES_SIZE, "s1"),
> +	[S2] = DEFINE_RES_REG_NAMED(VSC7512_S2_RES_START, VSC7512_S_RES_SIZE, "s2"),
> +	[GCB] = DEFINE_RES_REG_NAMED(VSC7512_GCB_RES_START, VSC7512_GCB_RES_SIZE, "devcpu_gcb"),
> +	[HSIO] = DEFINE_RES_REG_NAMED(VSC7512_HSIO_RES_START, VSC7512_HSIO_RES_SIZE, "hsio"),
> +};
> +EXPORT_SYMBOL_NS(vsc7512_target_io_res, MFD_OCELOT);
> +
> +const struct resource vsc7512_port_io_res[] = {

I hope you will merge these 2 arrays now.

> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_0_RES_START, VSC7512_PORT_RES_SIZE, "port0"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_1_RES_START, VSC7512_PORT_RES_SIZE, "port1"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_2_RES_START, VSC7512_PORT_RES_SIZE, "port2"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_3_RES_START, VSC7512_PORT_RES_SIZE, "port3"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_4_RES_START, VSC7512_PORT_RES_SIZE, "port4"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_5_RES_START, VSC7512_PORT_RES_SIZE, "port5"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_6_RES_START, VSC7512_PORT_RES_SIZE, "port6"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_7_RES_START, VSC7512_PORT_RES_SIZE, "port7"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_8_RES_START, VSC7512_PORT_RES_SIZE, "port8"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_9_RES_START, VSC7512_PORT_RES_SIZE, "port9"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_10_RES_START, VSC7512_PORT_RES_SIZE, "port10"),
> +	{}
> +};
> +EXPORT_SYMBOL_NS(vsc7512_port_io_res, MFD_OCELOT);
> +
>  static const struct mfd_cell vsc7512_devs[] = {
>  	{
>  		.name = "ocelot-pinctrl",
> @@ -144,6 +213,7 @@ static void ocelot_core_try_add_regmaps(struct device *dev,
>  
>  int ocelot_core_init(struct device *dev)
>  {
> +	const struct resource *port_res;
>  	int i, ndevs;
>  
>  	ndevs = ARRAY_SIZE(vsc7512_devs);
> @@ -151,6 +221,23 @@ int ocelot_core_init(struct device *dev)
>  	for (i = 0; i < ndevs; i++)
>  		ocelot_core_try_add_regmaps(dev, &vsc7512_devs[i]);
>  
> +	/*
> +	 * Both the target_io_res and the port_io_res structs need to be referenced directly by
> +	 * the ocelot_ext driver, so they can't be attached to the dev directly and referenced by
> +	 * offset like the rest of the drivers. Instead, create these regmaps always and allow any
> +	 * children look these up by name.
> +	 */
> +	for (i = 0; i < TARGET_MAX; i++)
> +		/*
> +		 * The target_io_res array is sparsely populated. Use .start as an indication that
> +		 * the entry isn't defined
> +		 */
> +		if (vsc7512_target_io_res[i].start)
> +			ocelot_core_try_add_regmap(dev, &vsc7512_target_io_res[i]);
> +
> +	for (port_res = vsc7512_port_io_res; port_res->start; port_res++)
> +		ocelot_core_try_add_regmap(dev, port_res);
> +

Will need to be updated.

>  	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs, ndevs, NULL, 0, NULL);
>  }
>  EXPORT_SYMBOL_NS(ocelot_core_init, MFD_OCELOT);
> diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
> index dd72073d2d4f..439ff5256cf0 100644
> --- a/include/linux/mfd/ocelot.h
> +++ b/include/linux/mfd/ocelot.h
> @@ -11,8 +11,13 @@
>  #include <linux/regmap.h>
>  #include <linux/types.h>
>  
> +#include <soc/mscc/ocelot.h>
> +

Is this the problematic include that makes it necessary to have the
pinctrl hack? Can we drop the #undef REG now?

>  struct resource;
>  
> +extern const struct resource vsc7512_target_io_res[TARGET_MAX];
> +extern const struct resource vsc7512_port_io_res[];
> +

Will need to be removed.

>  static inline struct regmap *
>  ocelot_regmap_from_resource_optional(struct platform_device *pdev,
>  				     unsigned int index,
> -- 
> 2.25.1
> 
