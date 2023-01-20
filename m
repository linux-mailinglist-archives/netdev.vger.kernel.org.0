Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5229E675263
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 11:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjATK1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 05:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjATK1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 05:27:17 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7167DB2D07
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:26:51 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id c10-20020a05600c0a4a00b003db0636ff84so3320834wmq.0
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=e4mt5lGPeAiHXoegntNYO5GB6SA6d9P+daV7EOX7KxE=;
        b=fUjHtccIWB0vyjuM9shK7iOBnKRcjVRyDKG0+xnJ/+VnAf+laV6pKo7tbZ3ksh8PvH
         DTpqVBt9YxlTy9n6MPUwHXfZ17dkV9yIPWutuUoJu1xJKHVVNMqdVkVp71GC8ya2gIrM
         eKdkevkw7tLtIFyHILfqruPo7R105xSjIPdWcI+57E+FGKb1pzNud70c4jQxXTrpbH5g
         0MuACQyEH65XIdgQYsrV8x7ILK0SztEBKHhA8qS4PiGT/5AJcMjRPWZSU7O7U19qxeM6
         AqiHyd94dI/VIZPCUrv69g6vEPxL73eyTPX7/XkYMkKowY3ofeEkr6zxH/d9UwiJo5pd
         XOnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e4mt5lGPeAiHXoegntNYO5GB6SA6d9P+daV7EOX7KxE=;
        b=Aboga0K9+EI5ajSA8dz1J6JWG91F02vfK7TTvhbUNAMklXjBzetq4rl9PKsv7/kCrz
         865CTtZTXgFbP3MuiRQjxuc7aoV+baNws1x0rBcqQixMOYnAD2VOEQA2LJWFxfhILict
         C5b4HRr17TGdqtZmGQecMhh9TEpaP0W9DYw9uc0L9e1Qs75vn8uAJBPot3o6HrkKJaGt
         9uUbELzUb2uAYTvijJ5B2uxdbhS3ne0dTwXBHDp7iql/6RyL+vs49Mu+zSFVHlxFlOy/
         VLQ2aNw1DXDsoVtwkm4cQAdD3mtxhA3f0lL0fANmWChik0M7i68dgRJesCjwFXL4YSyp
         TDFA==
X-Gm-Message-State: AFqh2kqpZ9D1CodUq+3/B2zLBQIuKSUq5SymEfBOFzJQEc1UHxkIGbZr
        UwOnwiEtSTaOf5WupUT3EqN7Aw==
X-Google-Smtp-Source: AMrXdXurHyG2XSMT/oqWAcqCqisVjbAkEuwYynC+zJ20Z/Wc3RoAgIV4gZyyioyzciWoE/Yk0mgjTg==
X-Received: by 2002:a05:600c:3ac8:b0:3da:f67c:aca6 with SMTP id d8-20020a05600c3ac800b003daf67caca6mr13518984wms.34.1674210407420;
        Fri, 20 Jan 2023 02:26:47 -0800 (PST)
Received: from localhost (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id z4-20020a05600c0a0400b003db01178b62sm2095567wmp.40.2023.01.20.02.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 02:26:46 -0800 (PST)
References: <20230116091637.272923-1-jbrunet@baylibre.com>
 <20230116091637.272923-3-jbrunet@baylibre.com> <Y8dhUwIMb4tTeqWN@lunn.ch>
 <1jmt6eye1m.fsf@starbuckisacylon.baylibre.com> <Y8l7Rc9Vde9J45ij@lunn.ch>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: mdio: add amlogic gxl mdio mux support
Date:   Fri, 20 Jan 2023 11:16:20 +0100
In-reply-to: <Y8l7Rc9Vde9J45ij@lunn.ch>
Message-ID: <1jcz79wlgc.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 19 Jan 2023 at 18:17, Andrew Lunn <andrew@lunn.ch> wrote:

>> >> +
>> >> +	/* Set the internal phy id */
>> >> +	writel_relaxed(FIELD_PREP(REG2_PHYID, 0x110181),
>> >> +		       priv->regs + ETH_REG2);
>> >
>> > So how does this play with what Heiner has been reporting recently?
>> 
>> What Heiner reported recently is related to the g12 family, not the gxl
>> which this driver address.
>> 
>> That being said, the g12 does things in a similar way - the glue
>> is just a bit different:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/mdio/mdio-mux-meson-g12a.c?h=v6.2-rc4#n165
>> 
>> > What is the reset default? Who determined this value?
>> 
>> It's the problem, the reset value is 0. That is why GXL does work with the
>> internal PHY if the bootloader has not initialized it before the kernel
>> comes up ... and there is no guarantee that it will.
>> 
>> The phy id value is arbitrary, same as the address. They match what AML
>> is using internally.
>
> Please document where these values have come from. In the future we
> might need to point a finger when it all goes horribly wrong.
>

OK

>> They have been kept to avoid making a mess if a vendor bootloader is
>> used with the mainline kernel, I guess.
>> 
>> I suppose any value could be used here, as long as it matches the value
>> in the PHY driver:
>> 
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/phy/meson-gxl.c?h=v6.2-rc4#n253
>
> Some Marvell Ethernet switches with integrated PHYs have IDs with the
> vendor part set to Marvell, but the lower part is 0. The date sheet
> even says this is deliberate, you need to look at some other register
> in the switches address space to determine what the part is. That
> works O.K in the vendor crap monolithic driver, but not for Linux
> which separates the drivers up. So we have to intercept the reads and
> fill in the lower part. And we have no real knowledge if the PHYs are
> all the same, or there are differences. So we put in the switch ID,
> and the PHY driver then has an entry per switch. That gives us some
> future wiggle room if we find the PHYs are actually different.
>
> Is there any indication in the datasheets that the PHY is the exact
> same one as in the g12? Are we really safe to reuse this value between
> different SoCs?

There is zero information about the PHY in the datasheet.
The gxl and g12 don't use the same ID values.
The PHY ip is very similar but slightly different between the 2.
(see https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/phy/meson-gxl.c)

My guess is the g12 as another version of the IP, with some bug fixed.
The integration (clocking scheme mostly) is also different, which is why
the mux/glue is different.

>
> I actually find it an odd feature. Does the datasheet say anything
> about Why you can set the ID in software? The ID describes the
> hardware, and software configuration should not be able to change the
> hardware in any meaningful way.

Again, zero information. 
It is a bought IP (similar to the Rockchip judging by the PHY driver).
I'm not surprised the provider of the IP would make the ID
easy to configure. AML chose to keep that configurable through the glue,
instead of fixing it. This is how it is.

>
>> >> +	/* Enable the internal phy */
>> >> +	val |= REG3_PHYEN;
>> >> +	writel_relaxed(val, priv->regs + ETH_REG3);
>> >> +	writel_relaxed(0, priv->regs + ETH_REG4);
>> >> +
>> >> +	/* The phy needs a bit of time to come up */
>> >> +	mdelay(10);
>> >
>> > What do you mean by 'come up'? Not link up i assume. But maybe it will
>> > not respond to MDIO requests?
>> 
>> Yes this MDIO multiplexer is also the glue that provides power and
>> clocks to the internal PHY. Once the internal PHY is selected, it needs
>> a bit a of time before it is usuable. 
>
> O.K, please reword it to indicate power up, not link up.
>

Sure

>      Andrew
