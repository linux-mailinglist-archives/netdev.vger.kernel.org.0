Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1E05613BF
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 09:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbiF3Hys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 03:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiF3Hyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 03:54:47 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FA13EAA4
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 00:54:46 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id j7so1039294wmp.2
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 00:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=CCykJYUXKv51rZ8nTMW18vjqVnPZBcTRE0urrPA7hH4=;
        b=Z3YQlrsYDNeBCjZRgzx9MKmS0d+MIjGEWt+UBH1uzDnDvllumP4ONc+5d2XS9hu4a8
         1g1WWWcMRnXTjpSnpEU1dhS2gvsOkfAdcz1G2mkSUzUY3fTbAswgt83sm3cwfEMiZ57t
         vvcWk2wc6G0iaW1tjYMUtuc3EZHs7WPXa6u6tm6VJYOvqEQNCmXggkcUwSM1Btwmda2o
         cEX4TkVzHSkGtmy/4k9x6PjofkRoSeD/rUbY9J6WrAT7y66c+5GvbIzUmj9TRbyXaB1/
         43H07TvNeTX2IUgvbjxa9Rysv4aDDL60oNgfpjHap+0g2DNozvyq748EZRLwPx4HaUyX
         gahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CCykJYUXKv51rZ8nTMW18vjqVnPZBcTRE0urrPA7hH4=;
        b=VpdtQKWwzwQtJU9U1BFCM+GnZslOk8Dym8u0LN4dVmzLOR11AHYuv4arioSR4m07yF
         mrhMb2Vm0CYMCjH0bBF0WVNVpvNwg3XMBNu+lt/7ndT7ZVrucakvVpE7N/pSpXe16cFe
         i1aTklbqeyvbnOXGpT5XJKVvMotSJLDY/SJcXkjN6nAyblfUujHGK2sg5XTEf4J2ZT7T
         bbwsUBwM2Jv7Ogr0ZPSQKZ6NH0jx+K8rczrm6nOm3f0iI3y7+SlDGc5jszri34GoWeuB
         SOL1YgmWRstabFWzXfMOrC9lBqmYDjjnyR621hYamCmRa90VZJF+U/8knG4ZfAq7K8sL
         P3kA==
X-Gm-Message-State: AJIora8y3Q9bzWaoUWYK1XLsICLDUjYJ9IeLnNErKOlZJDnSiX2V3IbG
        dvWwJhIh5WCKsb0OD2w4hVfRvA==
X-Google-Smtp-Source: AGRyM1tBnnpxwzXTNYYIrONKbhI1E0t5nzd18tCkH1azo2MF2q31f4j7BJc+CfboYCD9eU+M66/zYQ==
X-Received: by 2002:a7b:cd85:0:b0:3a0:4c45:16c1 with SMTP id y5-20020a7bcd85000000b003a04c4516c1mr10046046wmj.125.1656575684605;
        Thu, 30 Jun 2022 00:54:44 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id h19-20020a05600c351300b0039c54bb28f2sm6092291wmq.36.2022.06.30.00.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 00:54:44 -0700 (PDT)
Date:   Thu, 30 Jun 2022 08:54:41 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Message-ID: <Yr1WwQwlmQiYnk00@google.com>
References: <20220628160809.marto7t6k24lneau@skbuf>
 <20220628172518.GA855398@euler>
 <20220628184659.sel4kfvrm2z6rwx6@skbuf>
 <20220628185638.dpm2w2rfc3xls7xd@skbuf>
 <CAHp75Ve-MF=MafvwYbFvW330-GhZM9VKKUWmSVxUQ4r_8U1mJQ@mail.gmail.com>
 <20220628195654.GE855398@euler>
 <20220629175305.4pugpbmf5ezeemx3@skbuf>
 <20220629203905.GA932353@euler>
 <20220629230805.klgcklovkkunn5cm@skbuf>
 <20220629235435.GA992734@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220629235435.GA992734@euler>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022, Colin Foster wrote:

> On Wed, Jun 29, 2022 at 11:08:05PM +0000, Vladimir Oltean wrote:
> > On Wed, Jun 29, 2022 at 01:39:05PM -0700, Colin Foster wrote:
> > > I liked the idea of the MFD being "code complete" so if future regmaps
> > > were needed for the felix dsa driver came about, it wouldn't require
> > > changes to the "parent." But I think that was a bad goal - especially
> > > since MFD requires all the resources anyway.
> > > 
> > > Also at the time, I was trying a hybrid "create it if it doesn't exist,
> > > return it if was already created" approach. I backed that out after an
> > > RFC.
> > > 
> > > Focusing only on the non-felix drivers: it seems trivial for the parent
> > > to create _all_ the possible child regmaps, register them to the parent
> > > via by way of regmap_attach_dev().
> > > 
> > > At that point, changing things like drivers/pinctrl/pinctrl-ocelot.c to
> > > initalize like (untested, and apologies for indentation):
> > > 
> > > regs = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
> > > if (IS_ERR(regs)) {
> > >     map = dev_get_regmap(dev->parent, name);
> > > } else {
> > >     map = devm_regmap_init_mmio(dev, regs, config);
> > > }
> > 
> > Again, those dev_err(dev, "invalid resource\n"); prints you were
> > complaining about earlier are self-inflicted IMO, and caused exactly by
> > this pattern. I get why you prefer to call larger building blocks if
> > possible, but in this case, devm_platform_get_and_ioremap_resource()
> > calls exactly 2 sub-functions: platform_get_resource() and
> > devm_ioremap_resource(). The IS_ERR() that you check for is caused by
> > devm_ioremap_resource() being passed a NULL pointer, and same goes for
> > the print. Just call them individually, and put your dev_get_regmap()
> > hook in case platform_get_resource() returns NULL, rather than passing
> > NULL to devm_ioremap_resource() and waiting for that to fail.
> 
> I see that now. Hoping this next version removes a lot of this
> unnecessary complexity.
> 
> > 
> > > In that case, "name" would either be hard-coded to match what is in
> > > drivers/mfd/ocelot-core.c. The other option is to fall back to
> > > platform_get_resource(pdev, IORESOURCE_REG, 0), and pass in
> > > resource->name. I'll be able to deal with that when I try it. (hopefully
> > > this evening)
> > 
> > I'm not exactly clear on what you'd do with the REG resource once you
> > get it. Assuming you'd get access to the "reg = <0x71070034 0x6c>;"
> > from the device tree, what next, who's going to set up the SPI regmap
> > for you?
> 
> The REG resource would only get the resource name, while the MFD core
> driver would set up the regmaps.
> 
> e.g. drivers/mfd/ocelot-core.c has (annotated):
> static const struct resource vsc7512_sgpio_resources[] = {
>     DEFINE_RES_REG_NAMED(start, size, "gcb_gpio") };
> 
> Now, the drivers/pinctrl/pinctrl-ocelot.c expects resource 0 to be the
> gpio resource, and gets the resource by index.
> 
> So for this there seem to be two options:
> Option 1:
> drivers/pinctrl/pinctrl-ocelot.c:
> res = platform_get_resource(pdev, IORESOURCE_REG, 0);
> map = dev_get_regmap(dev->parent, res->name);
> 
> 
> OR Option 2:
> include/linux/mfd/ocelot.h has something like:
> #define GCB_GPIO_REGMAP_NAME "gcb_gpio"
> 
> and drivers/pinctrl/pinctrl-ocelot.c skips get_resource and jumps to:
> map = dev_get_regmap(dev->parent, GCB_GPIO_REGMAP_NAME);
> 
> (With error checking, macro reuse, etc.)
> 
> 
> I like option 1, since it then makes ocelot-pinctrl.c have no reliance
> on include/linux/mfd/ocelot.h. But in both cases, all the regmaps are
> set up in advance during the start of ocelot_core_init, just before
> devm_mfd_add_devices is called.
> 
> 
> I should be able to test this all tonight.

Thank you Vladimir for stepping in to clarify previous points.

Well done both of you for this collaborative effort.  Great to see!

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
