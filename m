Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558E84A57DB
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 08:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbiBAHg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 02:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbiBAHg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 02:36:26 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8F4C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 23:36:25 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id c23so30133246wrb.5
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 23:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Bb6Mga8U7K4glRZ6MmtVlPXAX6IIPgGD3C6UTBEFxHU=;
        b=Ahq7jif3/GDZalygQ6KbDff2Y7Dn6Zh26zZBI/jiyAdElTrO/SSvFV7SCpPjKoWt5g
         hI+7EPZ+BHYlw21dR2EzdcWdHDt9eqSqKaYK9X/RO9aX2CeDYLot8Ro+/LzCJa1IovPc
         ZU6I4uP//AAniwRZHOYDYnhMl4gVGG5MqVwZHSVKdlOQUB/PjBpS7gfAu7MZJk9wGz2S
         i05ByWDb4ie8AQ142sd3m67EBW/v5+dk3Y4J2S4UfY9FDrd5PCWyIzxcnIoyKEd8PIr0
         UA6UFRdfO3pGykYvR0eKAyaIC+QLHlD8abJ0+08XRqYdZtcpPHqjhMaMWep+rNPelcJm
         fyyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Bb6Mga8U7K4glRZ6MmtVlPXAX6IIPgGD3C6UTBEFxHU=;
        b=jhah4xwfPXyUpZwGZJFyZAqMk0y85Q8C1woWizGm+oQzz9l/Dvqt1YMrW6vpC983EY
         1mgmOpOeW6JpUF3dD1yVgbbHNfCz54ZWiZAQldQTH85ozp3058aQff6h3iacLrO7NpzX
         wnYEFILdeU98JPWvBVB0AyZulqtDRIllY9CHd3OBO8Uf+XLRsXeGCQLRNpwOAqo6jDZ1
         b8uSRsPvv1WPvQWNWL5XA0NThYuwvHtxVEdramRgx3U6blb092mp+WSMoYzGzoczpH2N
         IOwztdReym0bAKoeM/bjQosClIz5mbwAPea8LBbyyG3BKg0guD8o34N7N72Czq0QCdqG
         V0uw==
X-Gm-Message-State: AOAM533EheUMbqqGcietW/FYclRBWI2Wyg/3J0IXY11VqCkB7a2Ug6oU
        w7zhlz8s414HKX+iqOGwiSddiQ==
X-Google-Smtp-Source: ABdhPJw0te5xOcbBzC+a3jqrrIgxBT+vb9ApuO2zXf7MyjEmiqExE7WWqNHRMqZA2vyoiNlbCKfslQ==
X-Received: by 2002:a05:6000:1885:: with SMTP id a5mr19750194wri.705.1643700984292;
        Mon, 31 Jan 2022 23:36:24 -0800 (PST)
Received: from google.com (cpc106310-bagu17-2-0-cust853.1-3.cable.virginm.net. [86.15.223.86])
        by smtp.gmail.com with ESMTPSA id 1sm16170216wry.52.2022.01.31.23.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 23:36:23 -0800 (PST)
Date:   Tue, 1 Feb 2022 07:36:21 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
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
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        katie.morris@in-advantage.com
Subject: Re: [RFC v6 net-next 6/9] mfd: ocelot: add support for external mfd
 control over SPI for the VSC7512
Message-ID: <Yfji9Yy/VtrVv+Js@google.com>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-7-colin.foster@in-advantage.com>
 <Yfer/qJmwRdShv4y@google.com>
 <20220131172934.GB28107@COLIN-DESKTOP1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220131172934.GB28107@COLIN-DESKTOP1.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Jan 2022, Colin Foster wrote:

> Hi Lee,
> 
> Thank you very much for your time / feedback.
> 
> On Mon, Jan 31, 2022 at 09:29:34AM +0000, Lee Jones wrote:
> > On Sat, 29 Jan 2022, Colin Foster wrote:
> > 
> > > Create a single SPI MFD ocelot device that manages the SPI bus on the
> > > external chip and can handle requests for regmaps. This should allow any
> > > ocelot driver (pinctrl, miim, etc.) to be used externally, provided they
> > > utilize regmaps.
> > > 
> > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > ---
> > >  drivers/mfd/Kconfig                       |  19 ++
> > >  drivers/mfd/Makefile                      |   3 +
> > >  drivers/mfd/ocelot-core.c                 | 165 +++++++++++
> > >  drivers/mfd/ocelot-spi.c                  | 325 ++++++++++++++++++++++
> > >  drivers/mfd/ocelot.h                      |  36 +++
> > 
> > >  drivers/net/mdio/mdio-mscc-miim.c         |  21 +-
> > >  drivers/pinctrl/pinctrl-microchip-sgpio.c |  22 +-
> > >  drivers/pinctrl/pinctrl-ocelot.c          |  29 +-
> > >  include/soc/mscc/ocelot.h                 |  11 +
> > 
> > Please avoid mixing subsystems in patches if at all avoidable.
> > 
> > If there are not build time dependencies/breakages, I'd suggest
> > firstly applying support for this into MFD *then* utilising that
> > support in subsequent patches.
> 
> My last RFC did this, and you had suggested to squash the commits. To
> clarify, are you suggesting the MFD / Pinctrl get applied in a single
> patch, then the MIIM get applied in a separate one? Because I had
> started with what sounds like you're describing - an "empty" MFD with
> subsequent patches rolling in each subsystem.
> 
> Perhaps I misinterpreted your initial feedback.

I want you to add all device support into the MFD driver at once.

The associated drivers, the ones that live in other subsystems, should
be applied as separate patches.  There seldom exist any *build time*
dependencies between the device side and the driver side.

> > >  9 files changed, 614 insertions(+), 17 deletions(-)
> > >  create mode 100644 drivers/mfd/ocelot-core.c
> > >  create mode 100644 drivers/mfd/ocelot-spi.c
> > >  create mode 100644 drivers/mfd/ocelot.h
> > > 
> > > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > > index ba0b3eb131f1..57bbf2d11324 100644
> > > --- a/drivers/mfd/Kconfig
> > > +++ b/drivers/mfd/Kconfig
> > > @@ -948,6 +948,25 @@ config MFD_MENF21BMC
> > >  	  This driver can also be built as a module. If so the module
> > >  	  will be called menf21bmc.
> > >  
> > > +config MFD_OCELOT
> > > +	tristate "Microsemi Ocelot External Control Support"
> > 
> > Please explain exactly what an ECS is in the help below.
> 
> I thought I had by way of the second paragraph below. I'm trying to
> think of what extra information could be of use at this point... 
> 
> I could describe how they have internal processors and using this level
> of control would basically bypass that functionality.

Yes please.

Also provide details about what the device actually does.

> > > +static struct regmap *ocelot_devm_regmap_init(struct ocelot_core *core,
> > > +					      struct device *dev,
> > > +					      const struct resource *res)
> > > +{
> > > +	struct regmap *regmap;
> > > +
> > > +	regmap = dev_get_regmap(dev, res->name);
> > > +	if (!regmap)
> > > +		regmap = ocelot_spi_devm_get_regmap(core, dev, res);
> > 
> > Why are you making SPI specific calls from the Core driver?
> 
> This was my interpretation of your initial feedback. It was initially
> implemented as a config->get_regmap() function pointer so that core
> didn't need to know anything about ocelot_spi.
> 
> If function pointers aren't used, it seems like core would have to know
> about all possible bus types... Maybe my naming led to some
> misunderstandings. Specifically I'd used "init_bus" which was intended
> to be "set up the chip to be able to properly communicate via SPI" but
> could have been interpreted as "tell the user of this driver that the
> bus is being initialized by way of a callback"?

Okay, I see what's happening now.

Please add a comment to describe why you're calling one helper, what
failure means in the first instance and what you hope to achieve by
calling the subsequent one.

> > > +	return regmap;
> > > +}
> > > +
> > > +struct regmap *ocelot_get_regmap_from_resource(struct device *dev,
> > > +					       const struct resource *res)
> > > +{
> > > +	struct ocelot_core *core = dev_get_drvdata(dev);
> > > +
> > > +	return ocelot_devm_regmap_init(core, dev, res);
> > > +}
> > > +EXPORT_SYMBOL(ocelot_get_regmap_from_resource);
> > 
> > Why don't you always call ocelot_devm_regmap_init() with the 'core'
> > parameter dropped and just do dev_get_drvdata() inside of there?
> > 
> > You're passing 'dev' anyway.
> 
> This might be an error. I'll look into this, but I changed the intended
> behavior of this between v5 and v6.
> 
> In v5 I had intended to attach all regmaps to the spi_device. This way
> they could be shared amongst child devices of spi->dev. I think that was
> a bad design decision on my part, so I abandoned it. If the child
> devices are to share regmaps, they should explicitly do so by way of
> syscon, not implicitly by name.
> 
> In v6 my intent is to have every regmap be devm-linked to the children.
> This way the regmap would be destroyed and recreated by rmmod / insmod,
> of the sub-modules, instead of being kept around the MFD module.

What's the reason for using an MFD to handle the Regmap(s) if you're
going to have per-device ones anyway?  Why not handle them in the
children?

> So perhaps to clear this up I should rename "dev" to "child" because it
> seems that the naming has already gotten too confusing. What I intended
> to do was:
> 
> struct regmap *ocelot_get_regmap_from_resource(struct device *parent,
> 					       struct device *child,
> 					       const struct resource *res)
> {
> 	struct ocelot_core *core = dev_get_drvdata(parent);
> 
> 	return ocelot_devm_regmap_init(core, child, res);
> }
> 
> Or maybe even:
> struct regmap *ocelot_get_regmap_from_resource(struct device *child,
> 					       const struct resource *res)
> {
> 	struct ocelot_core *core = dev_get_drvdata(child->parent);
> 
> 	return ocelot_devm_regmap_init(core, child, res);
> }

Or just call:

  ocelot_devm_regmap_init(core, dev->parent, res);

... from the original call-site?

Or, as I previously suggested:

  ocelot_devm_regmap_init(dev->parent, res);

[...]

> > > +	ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, vsc7512_devs,
> > 
> > Why NONE?
> 
> I dont know the implication here. Example taken from
> drivers/mfd/madera-core.c. I imagine PLATFORM_DEVID_AUTO is the correct
> macro to use here?

That's why I asked.  Please read-up on the differences and use the
correct one for your device instead of just blindly copy/pasting from
other sources. :)

[...]

> > > +	WARN_ON(!val);
> > 
> > Is this possible?
> 
> Hmm... I don't know if regmap_read guards against val == NULL. It
> doesn't look like it does. It is very much a "this should never happen"
> moment...
> 
> I can remove it, or change this to return an error if !val, which is
> what I probably should have done in the first place. Thoughts?

Not really.  Just make sure whatever you decide to do is informed.

[...]

> > > -	regs = devm_platform_ioremap_resource(pdev, 0);
> > > -	if (IS_ERR(regs))
> > > -		return PTR_ERR(regs);
> > > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > +
> > > +	if (!device_is_mfd(pdev)) {
> > > +		regs = devm_ioremap_resource(dev, res);
> > 
> > What happens if you call this if the device was registered via MFD?
> 
> I don't recall if it was your suggestion, but I tried this.
> devm_ioremap_resource on the MFD triggered a kernel crash. I didn't look
> much more into things than that, but if trying devm_ioremap_resource and
> falling back to ocelot_get_regmap_from_resource is the desired path, I
> can investigate further.

Yes please.  It should never crash.  That's probably a bug.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
