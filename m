Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D67481692
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 21:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbhL2UMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 15:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbhL2UMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 15:12:48 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEEBC06173F
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 12:12:48 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id e5so46421355wrc.5
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 12:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=n8krvMOUPEK6F0o+N9+XFosmRDgMxP8QBHCs3kla8RI=;
        b=IC55bGUOP7ZwPBye4DspVIQhb7jnifJNc6BUf+60ovYN536DYgrUoQJNAp5410jb/4
         e/ks53xs822USd9st6cR77JrMKZxO5J6/oHfsVL4P4E+D+F7wD9r91+tT5uwIIQKf9rj
         KvM7dfOXxKIikyOcOV3f1WtaYMqJGwBl9mV9OH5qhrJXoi8qfN+JZQiyEl80P4rZWFfS
         6ogr2fgBAd26OWTKlfr/k2uUyxdhRsAS4dQGoG54aoa6U+wbvfskVs3NIPQzWjSvlc5L
         g1afh6Dme2yrInsdibLTo/P+Einq4ADBJgMIQIkSHsgpr06x6LxydSQ+qzIKPZ3yeMYs
         /vYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=n8krvMOUPEK6F0o+N9+XFosmRDgMxP8QBHCs3kla8RI=;
        b=UI+rWmlAjAEEBUW/ou4HTC3/Btd2558cOGVkv01KzJUeRuO+i8xWNQgP+3V4g0AUPH
         6ZUKkrVwLiO7pqaVme3EzqT+4frYQ8C6felG/6KpgPPX4P1u1mRfIoKYnClQKuwcqum7
         t0Mlcxa74MnFmrC2s7r6hConzJQVApxsjhjgmiw8yuTRLaZrwPuOrKabDDgCwr+/LTsf
         3K5jnZ+TxN057jKQotls7dmpWNgbCxG7xZjwOGfZOVVVuZoHbbK9Rd1gb1l4V+VvdFaR
         1wFqsZWESPKkpKCba99/jkQtywVrsz4LFd/6VMkTWyiYMkjIi1xPhnuH9ibQAIT0fktG
         yNIg==
X-Gm-Message-State: AOAM530wHZXqgLPoTZqfBNab0HjNMTtc3OzDjjtUEVr/mhPJi5wTXcf9
        QDewCdDLlaBAFbG6gdeTAg+YSQ==
X-Google-Smtp-Source: ABdhPJy1yOGQ3+RzhnmTKk1jgmLANfR6jpUQUpuuGNa9PKHTT1y4KLRkmer2xcdLOcLWqLSwp2IsXg==
X-Received: by 2002:adf:e844:: with SMTP id d4mr21464307wrn.151.1640808766838;
        Wed, 29 Dec 2021 12:12:46 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id l12sm27352493wmq.2.2021.12.29.12.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 12:12:46 -0800 (PST)
Date:   Wed, 29 Dec 2021 20:12:39 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        clement.leger@bootlin.com
Subject: Re: [RFC v5 net-next 02/13] mfd: ocelot: offer an interface for MFD
 children to get regmaps
Message-ID: <YczBN3CT1qSXHpMw@google.com>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
 <20211218214954.109755-3-colin.foster@in-advantage.com>
 <Ycx9j3bflcTGsb7b@google.com>
 <Ycy4VPy+XVgYmfeg@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ycy4VPy+XVgYmfeg@piout.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > This is almost certainly not the right way to do whatever it is you're
> > trying to do!
> > 
> > Please don't try to upstream "somewhat a hack"s into the Mainline
> > kernel.
> > 
> 
> Please elaborate on the correct way to do that. What we have here is a
> SoC (vsc7514) that has MMIO devices. This SoC has a MIPS CPU and
> everything is fine when using it. However, the CPU can be disabled and
> the SoC connected to another CPU using SPI or PCIe. What Colin is doing
> here is using this SoC over SPI. Don't tell me this is not an MFD

When did anyone say that?

> because this is exactly what this is, a single chip with a collection of
> devices that are also available separately.
> 
> The various drivers for the VSC7514 have been written using regmap
> exactly for this use case. The missing piece is probing the devices over
> SPI instead of MMIO.
> 
> Notice that all of that gets worse when using PCIe on architectures that
> don't have device tree support and Clément will submit multiple series
> trying to fix that.

Okay, it sounds like I'm missing some information, let's see if we can
get to the bottom of this so that I can provide some informed
guidance.

> On 29/12/2021 15:23:59+0000, Lee Jones wrote:
> > On Sat, 18 Dec 2021, Colin Foster wrote:
> > 
> > > Child devices need to get a regmap from a resource struct,
> > > specifically from the MFD parent.

Child devices usually fetch the Regmap from a pointer the parent
provides.  Usually via either 'driver_data' or 'platform_data'.

However, we can't do that here because ...

> > > The MFD parent has the interface to the hardware
> > > layer, which could be I2C, SPI, PCIe, etc.
> > > 
> > > This is somewhat a hack... ideally child devices would interface with the
> > > struct device* directly, by way of a function like
> > > devm_get_regmap_from_resource which would be akin to
> > > devm_get_and_ioremap_resource.

However, we can't do that here because ...

> > > A less ideal option would be to interface
> > > directly with MFD to get a regmap from the parent.
> > > 
> > > This solution is even less ideal than both of the two suggestions, so is
> > > intentionally left in a separate commit after the initial MFD addition.
> > > 
> > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > ---
> > >  drivers/mfd/ocelot-core.c |  9 +++++++++
> > >  include/soc/mscc/ocelot.h | 12 ++++++++++++
> > >  2 files changed, 21 insertions(+)
> > > 
> > > diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> > > index a65619a8190b..09132ea52760 100644
> > > --- a/drivers/mfd/ocelot-core.c
> > > +++ b/drivers/mfd/ocelot-core.c
> > > @@ -94,6 +94,15 @@ static struct regmap *ocelot_mfd_regmap_init(struct ocelot_mfd_core *core,
> > >  	return regmap;
> > >  }
> > >  
> > > +struct regmap *ocelot_mfd_get_regmap_from_resource(struct device *dev,
> > > +						   const struct resource *res)
> > > +{
> > > +	struct ocelot_mfd_core *core = dev_get_drvdata(dev);
> > > +
> > > +	return ocelot_mfd_regmap_init(core, res);
> > > +}
> > > +EXPORT_SYMBOL(ocelot_mfd_get_regmap_from_resource);
> > 
> 

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
