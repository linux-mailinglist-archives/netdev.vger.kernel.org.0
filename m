Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B2162F9CA
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 16:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240965AbiKRP6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 10:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241449AbiKRP6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 10:58:30 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839EF62C3;
        Fri, 18 Nov 2022 07:58:26 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id g10so4903246plo.11;
        Fri, 18 Nov 2022 07:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fnPf5p+CHRKHFc3oj+O3zmjlxH1aDU9mG+1B/0K1ofI=;
        b=A7LrNpVAKtF+kz78j6TvVNx5nTmjh4BBWvgehnLZklRwtUcWtWyz6Kjj+mDw2EloER
         f6BhIsl2rLtnZHa8svcKczsVT6ShZWHbT3VNK8sPCrqIdFJnTztm9FvTWItnk3qQI6U6
         86+0Ku54uFsCe4BXDzM36/yqHkFRfjFTCPEmY6hdBOi8nQUaLIebHBxMirt76URjCkVc
         FWq9rs2UIXGgCz51fsYQD9mZeSGpa/bCuQbYEnlHpDVcBYUxpqtl9UzRmZRTLsM2D/5n
         8taJGIE78KdNAV7qfF/qjPmj8Ewkx1ZDv9Zq8zrjUqSRAwbt/bQi+uHIQuYpngOA4UFr
         BIKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fnPf5p+CHRKHFc3oj+O3zmjlxH1aDU9mG+1B/0K1ofI=;
        b=EKhGN0RLZajtRSVjFFm3IhH3hxXG1on/LBRcba3Yn17ABjdJboigrpeUjC55+5tJoM
         8xHBNTo+HjvZO/LA6LMHVVOBwZQBjsMkSLOnYrM0iQH6yoNCbHpIhbGqJiJBKhZMglVQ
         +u632n/BItDmR9aE2DTbab8PmtNy9Ai9VSJb+Brzg/2IbmWkiA+IKD3kFs2PCR7AZY96
         Vv90bC9NB/k0tqbIG77kUWKZ5r2nUONhCury197wpBoDVkLogD+C95rg5hwLVSvWMdBC
         p8uJxRjEjNHLAuKuixx257A2XBFqF3yFIkmC1s06+ZZ1Bd6BElJ/fsRZ/KAhePSBcyKx
         J5PQ==
X-Gm-Message-State: ANoB5plIqnjicQFWgPunS+/UcvX8xHqQg5/rWLG6xjH2RAKHU1d0Kg+y
        Uur2zY6aB/+/XeFM4rfA808=
X-Google-Smtp-Source: AA0mqf6KE4Cx6SV9zZT3KAXk+1k++4TMseBo4yfDiUjbCZiyz2K+hzqQPmFeGm6xVmMKMCPRZZhKVw==
X-Received: by 2002:a17:903:2144:b0:188:a1eb:9a8a with SMTP id s4-20020a170903214400b00188a1eb9a8amr29765ple.153.1668787105654;
        Fri, 18 Nov 2022 07:58:25 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:e4c5:c31d:4c68:97a0])
        by smtp.gmail.com with ESMTPSA id n13-20020a170903110d00b00176b63535adsm3841808plh.260.2022.11.18.07.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 07:58:24 -0800 (PST)
Date:   Fri, 18 Nov 2022 07:58:21 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: davicom: dm9000: switch to using gpiod API
Message-ID: <Y3ernUQfdWMBtO9z@google.com>
References: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
 <88VJLR.GYSEKGBPLGZC1@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <88VJLR.GYSEKGBPLGZC1@crapouillou.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

On Fri, Nov 18, 2022 at 03:33:44PM +0000, Paul Cercueil wrote:
> Hi Dmitry,
> 
> Le mar. 6 sept. 2022 à 13:49:20 -0700, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> a écrit :
> > This patch switches the driver away from legacy gpio/of_gpio API to
> > gpiod API, and removes use of of_get_named_gpio_flags() which I want to
> > make private to gpiolib.
> > 
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > ---
> >  drivers/net/ethernet/davicom/dm9000.c | 26 ++++++++++++++------------
> >  1 file changed, 14 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/davicom/dm9000.c
> > b/drivers/net/ethernet/davicom/dm9000.c
> > index 77229e53b04e..c85a6ebd79fc 100644
> > --- a/drivers/net/ethernet/davicom/dm9000.c
> > +++ b/drivers/net/ethernet/davicom/dm9000.c
> > @@ -28,8 +28,7 @@
> >  #include <linux/irq.h>
> >  #include <linux/slab.h>
> >  #include <linux/regulator/consumer.h>
> > -#include <linux/gpio.h>
> > -#include <linux/of_gpio.h>
> > +#include <linux/gpio/consumer.h>
> > 
> >  #include <asm/delay.h>
> >  #include <asm/irq.h>
> > @@ -1421,8 +1420,7 @@ dm9000_probe(struct platform_device *pdev)
> >  	int iosize;
> >  	int i;
> >  	u32 id_val;
> > -	int reset_gpios;
> > -	enum of_gpio_flags flags;
> > +	struct gpio_desc *reset_gpio;
> >  	struct regulator *power;
> >  	bool inv_mac_addr = false;
> >  	u8 addr[ETH_ALEN];
> > @@ -1442,20 +1440,24 @@ dm9000_probe(struct platform_device *pdev)
> >  		dev_dbg(dev, "regulator enabled\n");
> >  	}
> > 
> > -	reset_gpios = of_get_named_gpio_flags(dev->of_node, "reset-gpios", 0,
> > -					      &flags);
> > -	if (gpio_is_valid(reset_gpios)) {
> > -		ret = devm_gpio_request_one(dev, reset_gpios, flags,
> > -					    "dm9000_reset");
> > +	reset_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
> > +	ret = PTR_ERR_OR_ZERO(reset_gpio);
> > +	if (ret) {
> > +		dev_err(dev, "failed to request reset gpio: %d\n", ret);
> > +		goto out_regulator_disable;
> > +	}
> > +
> > +	if (reset_gpio) {
> > +		ret = gpiod_set_consumer_name(reset_gpio, "dm9000_reset");
> >  		if (ret) {
> > -			dev_err(dev, "failed to request reset gpio %d: %d\n",
> > -				reset_gpios, ret);
> > +			dev_err(dev, "failed to set reset gpio name: %d\n",
> > +				ret);
> >  			goto out_regulator_disable;
> >  		}
> > 
> >  		/* According to manual PWRST# Low Period Min 1ms */
> >  		msleep(2);
> > -		gpio_set_value(reset_gpios, 1);
> > +		gpiod_set_value_cansleep(reset_gpio, 0);
> 
> Why is that 1 magically turned into a 0?

Because gpiod uses logical states (think active/inactive), not absolute
ones. Here we are deasserting the reset line.

> 
> On my CI20 board I can't get the DM9000 chip to probe correctly with this
> patch (it fails to read the ID).
> If I revert this patch then everything works fine.

Sorry, it is my fault of course: I missed that board has incorrect
annotation for the reset line. I will send out the patch below
(formatted properly of course):

diff --git a/arch/mips/boot/dts/ingenic/ci20.dts b/arch/mips/boot/dts/ingenic/ci20.dts
index 37c46720c719..f38c39572a9e 100644
--- a/arch/mips/boot/dts/ingenic/ci20.dts
+++ b/arch/mips/boot/dts/ingenic/ci20.dts
@@ -438,7 +438,7 @@ dm9000@6 {
 		ingenic,nemc-tAW = <50>;
 		ingenic,nemc-tSTRV = <100>;
 
-		reset-gpios = <&gpf 12 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpf 12 GPIO_ACTIVE_LOW>;
 		vcc-supply = <&eth0_power>;
 
 		interrupt-parent = <&gpe>;


Thanks.

-- 
Dmitry
