Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F207C62FA4C
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 17:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242063AbiKRQad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 11:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241997AbiKRQa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 11:30:29 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179B756D55;
        Fri, 18 Nov 2022 08:30:29 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id b62so5482444pgc.0;
        Fri, 18 Nov 2022 08:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ThAESvPIblUscawDt70ZAsptAymfFb39kmKZmxY7IDc=;
        b=QDtkZ3iWm5xsN7BnrS8qwlo1QeIZBloSTWPbfN+F+rElBF3VyV6/uM0OD+eYq9Tur4
         pIkllSqp+S+AWvuM2tCXgzWev6T3Uk7pGtdHNVqcFQC8Ublzf1WzqbaJLcJyagyeKzU8
         N99OscVLko3ivsn8p95o8H8WSQdE5hUvXUFReADEDelFzxPrraaeYCor1BxJI2IrtaVk
         ba+Ty9cmpj4rFHTo19b+LQx76kADTSZ7rahFVTIcRX/fCOey8n/WpvDiFtGx3ob4silQ
         DFz/yinyvXEpEEa0pWDJQ73pkZGMxpm4SkR0t0qn5Jbhw78fWpQai+xS/LLFqtShnbGI
         HIeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ThAESvPIblUscawDt70ZAsptAymfFb39kmKZmxY7IDc=;
        b=Ns3IybYy4+A1Oar9Yar0eu+20ICMwBAwQLqe59mFXOgSMTY/7hDKbv7pyhvuXfj3Cp
         F/OjwtYHh8NCgLPj/s59XTUUqi+0NLY6H5/QyJJb2fKs7QGPyR+Be49q3MHlbjvo9pLs
         T858OZni5Gsnptyj3LvqnizYP7cLXb9tD0IDN7o+VXlS5ib5iP8a7m5uDRl9Ysnjk8lR
         beXwB8BuC+PNpVJv8+X5xMrWOwdOANt9Nsp5uTL1YjOvAEfhHcSQuXDgw86iQI/lzg9y
         gKl2C1on7EC24IzvcNHJVtXBvQIxg6EanN2k2fsdOixcoVKm+UgtsfZZHpZwZ6OmmTej
         GOdQ==
X-Gm-Message-State: ANoB5pnR6AtOt9UdBTu/V0EwP56KmaTfooW3jAvZJZ2zi2zex6VTZFDK
        72JEm0i67e0vx8UA94IrBWg=
X-Google-Smtp-Source: AA0mqf5QfG5AJxdlSl4DICNW8wIFV+NTzKztxygiAraRWf1JRZ82uWHYtknWuG2lWjpENEGoUB66HA==
X-Received: by 2002:a62:9409:0:b0:572:ccf6:e7c7 with SMTP id m9-20020a629409000000b00572ccf6e7c7mr8607507pfe.74.1668789028260;
        Fri, 18 Nov 2022 08:30:28 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:e4c5:c31d:4c68:97a0])
        by smtp.gmail.com with ESMTPSA id mr9-20020a17090b238900b00203ab277966sm5720821pjb.7.2022.11.18.08.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 08:30:27 -0800 (PST)
Date:   Fri, 18 Nov 2022 08:30:24 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: davicom: dm9000: switch to using gpiod API
Message-ID: <Y3ezIBgci24Jkq7L@google.com>
References: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
 <88VJLR.GYSEKGBPLGZC1@crapouillou.net>
 <Y3ernUQfdWMBtO9z@google.com>
 <EOXJLR.T44BFQBJ4YLG1@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EOXJLR.T44BFQBJ4YLG1@crapouillou.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 04:26:38PM +0000, Paul Cercueil wrote:
> 
> 
> Le ven. 18 nov. 2022 à 07:58:21 -0800, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> a écrit :
> > Hi Paul,
> > 
> > On Fri, Nov 18, 2022 at 03:33:44PM +0000, Paul Cercueil wrote:
> > >  Hi Dmitry,
> > > 
> > >  Le mar. 6 sept. 2022 à 13:49:20 -0700, Dmitry Torokhov
> > >  <dmitry.torokhov@gmail.com> a écrit :
> > >  > This patch switches the driver away from legacy gpio/of_gpio API
> > > to
> > >  > gpiod API, and removes use of of_get_named_gpio_flags() which I
> > > want to
> > >  > make private to gpiolib.
> > >  >
> > >  > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > >  > ---
> > >  >  drivers/net/ethernet/davicom/dm9000.c | 26
> > > ++++++++++++++------------
> > >  >  1 file changed, 14 insertions(+), 12 deletions(-)
> > >  >
> > >  > diff --git a/drivers/net/ethernet/davicom/dm9000.c
> > >  > b/drivers/net/ethernet/davicom/dm9000.c
> > >  > index 77229e53b04e..c85a6ebd79fc 100644
> > >  > --- a/drivers/net/ethernet/davicom/dm9000.c
> > >  > +++ b/drivers/net/ethernet/davicom/dm9000.c
> > >  > @@ -28,8 +28,7 @@
> > >  >  #include <linux/irq.h>
> > >  >  #include <linux/slab.h>
> > >  >  #include <linux/regulator/consumer.h>
> > >  > -#include <linux/gpio.h>
> > >  > -#include <linux/of_gpio.h>
> > >  > +#include <linux/gpio/consumer.h>
> > >  >
> > >  >  #include <asm/delay.h>
> > >  >  #include <asm/irq.h>
> > >  > @@ -1421,8 +1420,7 @@ dm9000_probe(struct platform_device *pdev)
> > >  >  	int iosize;
> > >  >  	int i;
> > >  >  	u32 id_val;
> > >  > -	int reset_gpios;
> > >  > -	enum of_gpio_flags flags;
> > >  > +	struct gpio_desc *reset_gpio;
> > >  >  	struct regulator *power;
> > >  >  	bool inv_mac_addr = false;
> > >  >  	u8 addr[ETH_ALEN];
> > >  > @@ -1442,20 +1440,24 @@ dm9000_probe(struct platform_device *pdev)
> > >  >  		dev_dbg(dev, "regulator enabled\n");
> > >  >  	}
> > >  >
> > >  > -	reset_gpios = of_get_named_gpio_flags(dev->of_node,
> > > "reset-gpios", 0,
> > >  > -					      &flags);
> > >  > -	if (gpio_is_valid(reset_gpios)) {
> > >  > -		ret = devm_gpio_request_one(dev, reset_gpios, flags,
> > >  > -					    "dm9000_reset");
> > >  > +	reset_gpio = devm_gpiod_get_optional(dev, "reset",
> > > GPIOD_OUT_HIGH);
> > >  > +	ret = PTR_ERR_OR_ZERO(reset_gpio);
> > >  > +	if (ret) {
> > >  > +		dev_err(dev, "failed to request reset gpio: %d\n", ret);
> > >  > +		goto out_regulator_disable;
> > >  > +	}
> > >  > +
> > >  > +	if (reset_gpio) {
> > >  > +		ret = gpiod_set_consumer_name(reset_gpio, "dm9000_reset");
> > >  >  		if (ret) {
> > >  > -			dev_err(dev, "failed to request reset gpio %d: %d\n",
> > >  > -				reset_gpios, ret);
> > >  > +			dev_err(dev, "failed to set reset gpio name: %d\n",
> > >  > +				ret);
> > >  >  			goto out_regulator_disable;
> > >  >  		}
> > >  >
> > >  >  		/* According to manual PWRST# Low Period Min 1ms */
> > >  >  		msleep(2);
> > >  > -		gpio_set_value(reset_gpios, 1);
> > >  > +		gpiod_set_value_cansleep(reset_gpio, 0);
> > > 
> > >  Why is that 1 magically turned into a 0?
> > 
> > Because gpiod uses logical states (think active/inactive), not absolute
> > ones. Here we are deasserting the reset line.
> > 
> > > 
> > >  On my CI20 board I can't get the DM9000 chip to probe correctly
> > > with this
> > >  patch (it fails to read the ID).
> > >  If I revert this patch then everything works fine.
> > 
> > Sorry, it is my fault of course: I missed that board has incorrect
> > annotation for the reset line. I will send out the patch below
> > (formatted properly of course):
> 
> So in *theory* you wouldn't fix it like that, because the driver should work
> with old Device Tree files, even if it had a broken property, as long as it
> used to work in the past.
> 
> The ci20.dts file however is always built into the kernel and I'm not aware
> of anybody doing things differently. As long as you make that explicit in
> your commit message I think Rob won't mind.
> 
> If he does, or if more boards are affected, an alternative is to switch the
> polarity of the GPIO in the driver, like so:
> 
> if (of_machine_is_compatible("mips,ci20") &&
>    gpiod_is_active_low(reset_gpio)) {
> 	gpiod_toggle_active_low(reset_gpio);
> }

Right, we are typically hiding this kind of quirks in gpiolib-of instead
of polluting drivers, but yes, it is possible.

Thanks.

-- 
Dmitry
