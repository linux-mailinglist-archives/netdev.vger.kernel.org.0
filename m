Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20901489869
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 13:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245291AbiAJMRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 07:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245276AbiAJMRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 07:17:03 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DF1C061751
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 04:17:03 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id c126-20020a1c9a84000000b00346f9ebee43so7085625wme.4
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 04:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=q/bYLC883mDqr/XPF4STq6rklrV+RHbvazODC3wWiTU=;
        b=sS6LSs4Fy2xO3mwZZD3kUSyG46X4wnClviLQwBWkUNiNuFv95Q8snbKMFzo4nJMcVd
         yO3Ti9xsdsNejdniYxOPuR6wBaxsH3uGP2z8hjBzAv9uDMJDN+8vu3Pq/6yan9lQoFjQ
         daVyXN42FMySYyNnX5VHN6GFc8qC0LLzceXZrksttANP79aPIoinYXTA91kIy0l0g+BF
         rPrY8VrPnBcoAsW6InYOqrk40rIQNWXu7CxB3YCxynNZQLveAlseWlr6gBd8iZOrLYlK
         POdr+YhoNhOstXgNcsl7PBmZicc2gPPkN3sbKgQoYK2F1YKRE05L/05CahIHSPVVuxLl
         VXKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=q/bYLC883mDqr/XPF4STq6rklrV+RHbvazODC3wWiTU=;
        b=lPeUD/wOInuHL16xHtuV2oVYGwE5tYQFleShaYL025VkeNnP5TyjqT2AXIciay9Kl2
         dvroOC2bh8sZRs2wGS8J9nt8WK4rlnFP2v2aLmpvL70uJQaZAg9z4euEZv3ROUerUWcU
         e6UffQ0HKCLU61Qc/WmdRz8tXPNnKOyaVB3U+5HRhHC8SP2DGImMXk6vFOYFNu1gikyR
         Vk8g8cJkKkYe94BjV6J6kxsIk+WfbYR2ZWKwdtCTn7r3KeDfSolFA8QXK4HfG5FfP0wC
         CTHz5TJ7uXYdgCTKAu9aUrOPG4ASl0KDQe5qq48l7COEeLsy9bA6na2KM7vh9O1waAH4
         Ux8A==
X-Gm-Message-State: AOAM5339ePGubd+ibpXBvmrL75mFunNwUVk+2snlP8VfTaWO4X7TObc9
        ttA7E+O9H+nMp4ve0W8NZFPMbw==
X-Google-Smtp-Source: ABdhPJwjQ9AjVv0AC7vdz7XwDI5XaI9x9iucscvpq597gf1GQK06f4RKKqHkpsdoL6RQnFMrlhQBuQ==
X-Received: by 2002:a1c:770b:: with SMTP id t11mr5546852wmi.61.1641817021850;
        Mon, 10 Jan 2022 04:17:01 -0800 (PST)
Received: from google.com ([31.124.24.179])
        by smtp.gmail.com with ESMTPSA id j13sm7007166wmq.11.2022.01.10.04.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 04:17:01 -0800 (PST)
Date:   Mon, 10 Jan 2022 12:16:59 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     broonie@kernel.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Subject: Re: [RFC v5 net-next 01/13] mfd: ocelot: add support for external
 mfd control over SPI for the VSC7512
Message-ID: <Ydwju35sN9QJqJ/P@google.com>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
 <20211218214954.109755-2-colin.foster@in-advantage.com>
 <Ycx9MMc+2ZhgXzvb@google.com>
 <20211230014300.GA1347882@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211230014300.GA1347882@euler>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Dec 2021, Colin Foster wrote:
> On Wed, Dec 29, 2021 at 03:22:24PM +0000, Lee Jones wrote:

[...]

> > > +	tristate "Microsemi Ocelot External Control Support"
> > > +	select MFD_CORE
> > > +	help
> > > +	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
> > > +	  VSC7513, VSC7514) controlled externally.
> > 
> > Please describe the device in more detail here.
> > 
> > I'm not sure what an "External Control Support" is.
> 
> A second paragraph "All four of these chips can be controlled internally
> (MMIO) or externally via SPI, I2C, PCIe. This enables control of these
> chips over one or more of these buses"

Where?  Or do you mean that you'll add one?

> > Please remove the term 'mfd\|MFD' from everywhere.
> 
> "ocelot_init" conflicts with a symbol in
> drivers/net/ethernet/mscc/ocelot.o, otherwise I belive I got them all
> now.

Then rename the other one.  Or call this one 'core', or something.

> > > +struct ocelot_mfd_core {
> > > +	struct ocelot_mfd_config *config;
> > > +	struct regmap *gcb_regmap;
> > > +	struct regmap_field *gcb_regfields[GCB_REGFIELD_MAX];
> > > +};
> > 
> > Not sure about this at all.
> > 
> > Which driver did you take your inspiration from?
> 
> Mainly drivers/net/dsa/ocelot/* and drivers/net/ethernet/mscc/*.

I doubt you need it.  Please try to remove it.

> > > +static const struct resource vsc7512_gcb_resource = {
> > > +	.start	= 0x71070000,
> > > +	.end	= 0x7107022b,
> > 
> > No magic numbers please.
> 
> I've gotten conflicting feedback on this. Several of the ocelot drivers
> (drivers/net/dsa/ocelot/felix_vsc9959.c) have these ranges hard-coded.
> Others (Documentation/devicetree/bindings/net/mscc-ocelot.txt) have them
> all passed in through the device tree. 
> 
> https://lore.kernel.org/netdev/20211126213225.okrskqm26lgprxrk@skbuf/

Ref or quote?

I'm not brain grepping it searching for what you might be referring to.

I'm not sure what you're trying to say here.  I'm asking you to define
this numbers please.

> > > +	.name	= "devcpu_gcb",
> > 
> > What is a 'devcpu_gcb'?
> 
> It matches the datasheet of the CPU's general configuation block.

Please could you quote that part for me?

> > > +	ret = regmap_field_write(core->gcb_regfields[GCB_SOFT_RST_CHIP_RST], 1);
> > 
> > No magic numbers please.  I have no idea what this is doing.
> 
> I'm not sure how much more verbose it can be... I suppose a define for
> "RESET" and "CLEAR" instead of "1" and "0" on that bit. Maybe I'm just
> blinded by having stared at this code for the last several months.

Yes please.  '1' could mean anything.

'CLEAR' is just as opaque.

What actually happens when you clear that register bit?

> > 
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	/*
> > > +	 * Note: This is adapted from the PCIe reset strategy. The manual doesn't
> > > +	 * suggest how to do a reset over SPI, and the register strategy isn't
> > > +	 * possible.
> > > +	 */
> > > +	msleep(100);
> > > +
> > > +	ret = core->config->init_bus(core->config);
> > 
> > You're not writing a bus.  I doubt you need ops call-backs.
> 
> In the case of SPI, the chip needs to be configured both before and
> after reset. It sets up the bus for endianness, padding bytes, etc. This
> is currently achieved by running "ocelot_spi_init_bus" once during SPI
> probe, and once immediately after chip reset.
> 
> For other control mediums I doubt this is necessary. Perhaps "init_bus"
> is a misnomer in this scenario...

Please find a clearer way to do this without function pointers.

> > > +void ocelot_mfd_get_resource_name(char *name, const struct resource *res,
> > > +				  int size)
> > > +{
> > > +	if (res->name)
> > > +		snprintf(name, size - 1, "ocelot_mfd-%s", res->name);
> > > +	else
> > > +		snprintf(name, size - 1, "ocelot_mfd@0x%08x", res->start);
> > > +}
> > > +EXPORT_SYMBOL(ocelot_mfd_get_resource_name);
> > 
> > What is this used for?
> > 
> > You should not be hand rolling device resource names like this.
> > 
> > This sort of code belongs in the bus/class API.
> > 
> > Please use those instead.
> 
> The idea here was to allow shared regmaps across different devices. The
> "devcpu_gcb" might be used in two ways - either everyone shares the same
> regmap across the "GCB" range, or everyone creates their own. 
> 
> This was more useful when the ocelot-core.c had a copy of the 
> "devcpu_org" regmap that was shared with ocelot-spi.c. I was able to
> remove that, but also feel like the full switch driver (patch 6 of this
> set) ocelot-ext should use the same "devcpu_gcb" regmap instance as
> ocelot-core does.
> 
> Admittedly, there are complications. There should probably be more
> checks added to "ocelot_regmap_init" / "get_regmap" to ensure that the
> regmap for ocelot_ext exactly matches the existing regmap for
> ocelot_core.
> 
> There's yet another complexity with these, and I'm not sure what the
> answer is. Currently all regmaps are tied to the ocelot_spi device...
> ocelot_spi calls devm_regmap_init. So those regmaps hang around if
> they're created by a module that has been removed. At least until the
> entire MFD module is removed. Maybe there's something I haven't seen yet
> where the devres or similar has a reference count. I don't know the best
> path forward on this one.

Why are you worrying about creating them 2 different ways?

If it's possible for them to all create and use their own regmaps,
what's preventing you from just do that all the time?

> > > +	/* Create and loop over all child devices here */
> > 
> > These need to all go in now please.
> 
> I'll squash them, as I saw you suggested in your other responses. I
> tried to keep them separate, especially since adding ocelot_ext to this
> commit (which has no functionality until this one) makes it quite a
> large single commit. That's why I went the path I did, which was to roll
> them in one at a time.

This is not an MFD until they are present.

> > > +int ocelot_mfd_remove(struct ocelot_mfd_config *config)
> > > +{
> > > +	/* Loop over all children and remove them */
> > 
> > Use devm_* then you won't have to.
> 
> Yeah, I was more worried than I needed to be when I wrote that comment.
> The only thing called to clean everything up is mfd_remove_devices();

Use devm_mfd_add_devices(), then you don't have to.

[...]

> > > +#include <linux/regmap.h>
> > > +
> > > +struct ocelot_mfd_config {
> > > +	struct device *dev;
> > > +	struct regmap *(*get_regmap)(struct ocelot_mfd_config *config,
> > > +				     const struct resource *res,
> > > +				     const char *name);
> > > +	int (*init_bus)(struct ocelot_mfd_config *config);
> > 
> > Please re-work and delete this 'config' concept.
> > 
> > See other drivers in this sub-directory for reference.
> 
> Do you have a specific example? I had focused on madera for no specific
> reason. But I really dislike the idea of throwing all of the structure
> definition for the MFD inside of something like
> "include/linux/mfd/ocelot/core.h", especially since all the child
> drivers (madera-pinctrl, madera-gpio, etc) heavily rely on this struct. 
> 
> It seemed to me that without the concept of
> "mfd_get_regmap_from_resource" this sort of back-and-forth was actually
> necessary.

Things like regmaps are usually passed in via driver_data or
platform_data.  Almost anything is better than call-backs.

[...]

> > > +	if (!ocelot_spi)
> > > +		return -ENOMEM;
> > > +
> > > +	if (spi->max_speed_hz <= 500000) {
> > > +		ocelot_spi->spi_padding_bytes = 0;
> > > +	} else {
> > > +		/*
> > > +		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG. Err
> > > +		 * on the side of more padding bytes, as having too few can be
> > > +		 * difficult to detect at runtime.
> > > +		 */
> > > +		ocelot_spi->spi_padding_bytes = 1 +
> > > +			(spi->max_speed_hz / 1000000 + 2) / 8;
> > 
> > Please explain what this means or define the values (or both).
> 
> I can certainly elaborate the comment. Searching the manual for the term
> "if_cfgstat" will take you right to the equation, and a description of
> what padding bytes are, etc. 

You shouldn't insist for your readers to RTFM.

If the code doesn't read well or is overly complicated, change it.

If the complexity is required, document it in comments.

> > > +	ocelot_spi->spi = spi;
> > 
> > Why are you saving this?
> 
> This file keeps the regmap_{read,write} implementations, so is needed
> for spi_sync() for any regmap. There might be a better way to infer
> this... but it seemed pretty nice to have each regmap only carry along
> an instance of "ocelot_spi_regmap_context."

I still need Mark to look at your Regmap implementation.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
