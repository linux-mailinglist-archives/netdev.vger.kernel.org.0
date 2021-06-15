Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEFB3A8B0D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 23:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhFOVYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 17:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbhFOVYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 17:24:02 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7239BC061760
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 14:21:56 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id hq2so121053ejc.2
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 14:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xvhT/S8kCbVqzCY1hyEoijsiaIE2btxzwX4mDloUr2k=;
        b=mUjY8kKLOP+R6mH5rUzaLSEaDu6r4sZPx8SVtmISVeK/6aOLwwx9Kt0axxWOTLe8oT
         G81gdLO4OspRxfGKql/GxccfowQXt3Fp4p3kOqm/uKLnKfjXjFzUs+BO2zhWbcs/hVGy
         joVV+DvOLxJmnaxYkCSCpeH/SD29OR3yizhPymhjOaBhYIcc8DjpP8GbMU6ID3Dgpmw3
         cy8uLD4JAN0Y4eH/Pe8lPSXtTnJdz+ti5D8oXZ7z02Q2h9N3jTbyDTkU+bfE92LDJ/vc
         rWxr4FJ30UoWl6nJtkf5Rpkw3i6GIXZEpeBXjPw4audZSJo3z3FouebXe2YH/RCpxRT1
         gjEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xvhT/S8kCbVqzCY1hyEoijsiaIE2btxzwX4mDloUr2k=;
        b=NnJVwG0ZKPbLjZlENxs0PB5eLsIUtnnqumiH1ryguDKdMyoFyd1NIxBLHQhEVouhD/
         EbO0pUMtU77rKnkN1IJGEK/Fe1LkD0tq5ZeJwxJ4heIU2NuE7GKfvo2dYK5mKcHF9/Q5
         bYw8i9l/Unr7toJ/oALSgfcp3QGL0bkpEnMpJtHufBtLRwXCXuoh+snijRAySENUzNer
         8miGljamgDnAhXXv1mL1wb1L3rSL5v54wuPyInnJhvKVKt0AgN/ovuLCuIShGgFrOTpM
         YVQnUo6g0dL0jS7gYlojMtTTfe270Uhr+FbiwuP/qiO57hUa7/T71AHCk9QdcFg9ZNFR
         5GPA==
X-Gm-Message-State: AOAM533InnuDAXQQ6jDysAdWTShOqWrYNTMQjePHmCYIOinOX1CmZQpv
        +tQd7vHtmVamqhyAa8NKEGmrcffMlEE=
X-Google-Smtp-Source: ABdhPJxkD3eW1ouhyIOHK+UZHYEQPK3m1ZviXuplDrphpozOKCRmFS7WmH4tg/85J446fJkD45YtiA==
X-Received: by 2002:a17:906:5593:: with SMTP id y19mr1571215ejp.195.1623792115040;
        Tue, 15 Jun 2021 14:21:55 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id c14sm107535ejb.2.2021.06.15.14.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 14:21:54 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Wed, 16 Jun 2021 00:21:53 +0300
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ciorneiioana@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        calvin.johnson@oss.nxp.com, hkallweit1@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] mdio: mdiobus: setup of_node for the MDIO device
Message-ID: <20210615212153.fvfenkyqabyqp7dk@skbuf>
References: <20210615154401.1274322-1-ciorneiioana@gmail.com>
 <20210615171330.GW22278@shell.armlinux.org.uk>
 <YMjx6iBD88+xdODZ@lunn.ch>
 <20210615210907.GY22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615210907.GY22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 10:09:07PM +0100, Russell King (Oracle) wrote:
> On Tue, Jun 15, 2021 at 08:31:06PM +0200, Andrew Lunn wrote:
> > On Tue, Jun 15, 2021 at 06:13:31PM +0100, Russell King (Oracle) wrote:
> > > On Tue, Jun 15, 2021 at 06:44:01PM +0300, Ioana Ciornei wrote:
> > > > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > > 
> > > > By mistake, the of_node of the MDIO device was not setup in the patch
> > > > linked below. As a consequence, any PHY driver that depends on the
> > > > of_node in its probe callback was not be able to successfully finish its
> > > > probe on a PHY, thus the Generic PHY driver was used instead.
> > > > 
> > > > Fix this by actually setting up the of_node.
> > > > 
> > > > Fixes: bc1bee3b87ee ("net: mdiobus: Introduce fwnode_mdiobus_register_phy()")
> > > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > > ---
> > > >  drivers/net/mdio/fwnode_mdio.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> > > > index e96766da8de4..283ddb1185bd 100644
> > > > --- a/drivers/net/mdio/fwnode_mdio.c
> > > > +++ b/drivers/net/mdio/fwnode_mdio.c
> > > > @@ -65,6 +65,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
> > > >  	 * can be looked up later
> > > >  	 */
> > > >  	fwnode_handle_get(child);
> > > > +	phy->mdio.dev.of_node = to_of_node(child);
> > > >  	phy->mdio.dev.fwnode = child;
> > > 
> > > Yes, this is something that was missed, but let's first look at what
> > > other places to when setting up a device:
> > > 
> > >         pdev->dev.fwnode = pdevinfo->fwnode;
> > >         pdev->dev.of_node = of_node_get(to_of_node(pdev->dev.fwnode));
> > >         pdev->dev.of_node_reused = pdevinfo->of_node_reused;
> > > 
> > >         dev->dev.of_node = of_node_get(np);
> > >         dev->dev.fwnode = &np->fwnode;
> > > 
> > >         dev->dev.of_node = of_node_get(node);
> > >         dev->dev.fwnode = &node->fwnode;
> > > 
> > > That seems to be pretty clear that an of_node_get() is also needed.
> > 
> > I think it also shows we have very little consistency, and the recent
> > patchset needs a bit of cleanup. Maybe yet another helper which when
> > passed a struct device * and a node pointer, it sets both values?
> 
> I do like that idea - maybe a couple of helpers, one that takes the
> of_node for a struct device, and another that takes a fwnode and
> does the appropriate stuff.
> 

I agree. Some consistency would be needed here.
I'll submit something tomorrow.

On the other hand, I would like to keep this patch as it is and build on
top of it with the helpers that Andrew suggested.

> Note that platform_device_release() does this:
> 
> 	of_node_put(pa->pdev.dev.of_node);
> 
> which is currently fine, because platform devices appear to only
> have their DT refcount increased. From what I can tell from looking
> at drivers/acpi/arm64/iort.c, ACPI fwnodes don't look like they're
> refcounted. Seems we're wading into something of a mess here. :(
> 

The fwnode_operations declared in drivers/acpi/property.c also suggest
the ACPI fwnodes are not refcounted.

Ioana
