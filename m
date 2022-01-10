Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388E7489886
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 13:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245376AbiAJMXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 07:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245415AbiAJMXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 07:23:14 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B49C06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 04:23:13 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id x4so1236774wru.7
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 04:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=d5pQe12aMTp9K2Ar029wPLMoAM2l+tag/tJuNAihSfA=;
        b=oJPzZWiJGiiJbT4/DpmWXxwLQYl6V3un3f2VMq9gR7xu1Vg0i7bZ927q0i6k6AQopH
         EMyuitOKXW8UrzPrA8eOw7VIwHiup4VsiSBK70Fwh3ZHQOw8z80zEoQuv/4CO+GM9ivz
         F5QUJ+ddCeY/O2IGHQoaAHfFjZBPVjvkv+z5R1r8GVyPWIRO/0eMm5lWFMJ9u0SODO/G
         MdBs5h8FelfgOYX3f78MFfDQiSxzbfqga00uHApimjp9PagVhvMXJoFmnNYqNKov7brQ
         vTMyqbYIDiV5KSYQLZHE20N7CHzkl+83RKoT9KdBiD7amP2upvF6OjdjXJB6L3Rolsqe
         gmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=d5pQe12aMTp9K2Ar029wPLMoAM2l+tag/tJuNAihSfA=;
        b=C+t/hzd6MCbppUNX8VQnCUb1YGS+exWl5r8wApYTe6MHUPwKkIDbVafwK1Y5NqA3dP
         LFhIgFmARi6E2tirRbMrzfnPT4DTC01LScNnpGx6E4WfADXQfvFnyLG4nzOtWZ7yKcQG
         eli/i0R6Atoh9LyUyY4oauqKnHKiKNhbn6OVmf+y9mXjOmiFcfZFtKjynXeXnfbQlMeJ
         iCCwFAr3uBZZOw5bqVNBpA9/m54Whd5LbMV4Bl78EE9djDa426B+QW2za4c3p5A2o60r
         LDy3TOwnI7kaFPoxFICa/OFZzwm80XPYwMybeh4zRyol7NkNv5NPCc1yucOK8ub4OwSP
         6wUA==
X-Gm-Message-State: AOAM531gw68a5NGt42Ej4EmxWX2wzEBJnJDdijBGBfHPMVvQRwZQi3rJ
        JypiroUy379iW4m9DtIRbPj5fg==
X-Google-Smtp-Source: ABdhPJxJTGBqADrh2dO8M5zq/V0efObTWO7ybtVGTQGANdUuw72l8ka3sOvJLzv6aUoWNXVdmQ1BEQ==
X-Received: by 2002:adf:e2cc:: with SMTP id d12mr17686855wrj.107.1641817392300;
        Mon, 10 Jan 2022 04:23:12 -0800 (PST)
Received: from google.com ([31.124.24.179])
        by smtp.gmail.com with ESMTPSA id l4sm6533168wrm.62.2022.01.10.04.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 04:23:11 -0800 (PST)
Date:   Mon, 10 Jan 2022 12:23:09 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC v5 net-next 08/13] mfd: add interface to check whether a
 device is mfd
Message-ID: <YdwlLYFPU16roS8E@google.com>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
 <20211218214954.109755-9-colin.foster@in-advantage.com>
 <Ycx+A4KNKiVmH2PJ@google.com>
 <20211230020443.GB1347882@euler>
 <Yc23mTo6g1tBiMjT@google.com>
 <20211230201253.GA1484230@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211230201253.GA1484230@euler>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Dec 2021, Colin Foster wrote:

> On Thu, Dec 30, 2021 at 01:43:53PM +0000, Lee Jones wrote:
> > On Wed, 29 Dec 2021, Colin Foster wrote:
> > 
> > > On Wed, Dec 29, 2021 at 03:25:55PM +0000, Lee Jones wrote:
> > > > On Sat, 18 Dec 2021, Colin Foster wrote:
> > > > 
> > > > > Some drivers will need to create regmaps differently based on whether they
> > > > > are a child of an MFD or a standalone device. An example of this would be
> > > > > if a regmap were directly memory-mapped or an external bus. In the
> > > > > memory-mapped case a call to devm_regmap_init_mmio would return the correct
> > > > > regmap. In the case of an MFD, the regmap would need to be requested from
> > > > > the parent device.
> > > > > 
> > > > > This addition allows the driver to correctly reason about these scenarios.
> > > > > 
> > > > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > > > ---
> > > > >  drivers/mfd/mfd-core.c   |  5 +++++
> > > > >  include/linux/mfd/core.h | 10 ++++++++++
> > > > >  2 files changed, 15 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> > > > > index 684a011a6396..905f508a31b4 100644
> > > > > --- a/drivers/mfd/mfd-core.c
> > > > > +++ b/drivers/mfd/mfd-core.c
> > > > > @@ -33,6 +33,11 @@ static struct device_type mfd_dev_type = {
> > > > >  	.name	= "mfd_device",
> > > > >  };
> > > > >  
> > > > > +int device_is_mfd(struct platform_device *pdev)
> > > > > +{
> > > > > +	return (!strcmp(pdev->dev.type->name, mfd_dev_type.name));
> > > > > +}
> > > > > +
> > > > 
> > > > Why is this device different to any other that has ever been
> > > > mainlined?
> > > 
> > > Hi Lee,
> > > 
> > > First, let me apologize for not responding to your response from the
> > > related RFC from earlier this month. It had been blocked by my spam
> > > filter and I had not seen it until just now. I'll have to check that
> > > more diligently now.
> > > 
> > > Moving on...
> > > 
> > > That's a question I keep asking myself. Either there's something I'm
> > > missing, or there's something new I'm doing.
> > > 
> > > This is taking existing drivers that work via MMIO regmaps and making
> > > them interface-independent. As Vladimir pointed out here:
> > > https://lore.kernel.org/all/20211204022037.dkipkk42qet4u7go@skbuf/T/
> > > device_is_mfd could be dropped in lieu of an mfd-specific probe
> > > function.
> > > 
> > > If there's something I'm missing, please let me know. But it feels like
> > > devm_get_regmap_from_resource at the end of the day would be the best
> > > solution to the design, and that doesn't exist. And implementing
> > > something like that is a task that I feel I'm not capable of tackling at
> > > this time.
> > 
> > I'm really not a fan of leaking any MFD API outside of drivers/mfd.
> > MFD isn't a tangible thing.  It's a Linuxiusm, something we made up, a
> > figment of your imagination.
> > 
> > What happens if you were to all dev_get_regmap() in the non-MFD case
> > or when you call devm_regmap_init_mmio() when the driver was
> > registered via the MFD framework?
> 
> I'd imagine dev_get_regmap in a non-MFD case would be the same as
> dev_get_and_ioremap_resource() followed by devm_regmap_init_mmio().
> 
> In the MFD case it would possibly request the regmap from the parent,
> which could reason about how to create the regmap. As you understand,
> this is exactly the behavior I created in this patch set. I did it by
> way of ocelot_get_regmap_from_resource, and admit it isn't the best way.
> But it certainly seems there isn't an existing method that I'm missing.
> 
> I'm coming from a pretty narrow field of view, but believe my use-case
> is a valid one. If that is true, and there isn't another design I should
> use... this is the opportunity to create it. Implementing
> ocelot_get_regmap_from_resource is a way to achieve my needs without
> affecting anyone else. 
> 
> Going one step further and implementing mfd_get_regmap_from_parent (or
> similar) would creep into the design of MFD. I don't know enough about
> MFD and the users to suggest this. I wouldn't want to start venturing
> down that path without blessing from the community. And this would
> indirectly affect every MFD driver.
> 
> Going all in and implementing device_get_regmap_from_resource... I don't
> know that I'd be comfortable even starting down that path knowing that
> it would affect every device. Perhaps it would have to utilize something
> like IORESOURCE_REG that seems to only get utilized in a handful of 
> files:
> https://elixir.bootlin.com/linux/v5.16-rc7/C/ident/IORESOURCE_REG

Let's speak to Mark and see if he can provide any insight.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
