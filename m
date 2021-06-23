Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE08B3B2374
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 00:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhFWWQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 18:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbhFWWQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 18:16:33 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C381DC0698C8
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 15:10:38 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id j184so9287369qkd.6
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 15:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0TJKI4xg1MiJTtI9uHGWJ686K09GTfrrpJPfhT4aShg=;
        b=GOHJ9m5SNCptct6yjocdXwedQaeSofI8mOZ3RQrQ0IxXnIyGCVSOUnavx1jX/sQJdM
         pheR6Wq9aR4FWu7bCAuWSi4lvITk+8JKMTrgRwMhh9naxcAJA+Ov9YQ1uK0jtqNwmYdX
         48EXoq8VukYz9YeVJyL8FcEBpt4FKXP2SSBAuOZc7kSKAzbXZBoQHKy2fovrLxZSCta9
         459D3t1i1cumoOGx2x+9H4R8GqDsafS/2bqVKhf7r8eiiTnUEuFkRDMtowyLHY4Xg8nr
         dngowICkhKLOnHdtExcQs/ZAcakgGiu7HA41lDJFk9UEOQddopWMC21vgqZ41b6rgg3n
         2vsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0TJKI4xg1MiJTtI9uHGWJ686K09GTfrrpJPfhT4aShg=;
        b=gkmZnlBoEzDH4ym5hdCV5P9T/pZgCZPYVjT9LtKmsUyXl9wy8oOO+RLOgzUJVdvfVf
         Px2DJerxtAE2GRu9tnJVYll4NE6UkfSJ1MISugnUf0OnY7r+SLEFphIYSm//h55W++NI
         /m39Z0dZzu4IpebgA4rqFNHhQNdnmmpIb2alrJAwtWpgpP7+as3ZhFkH+Gz+y4a13e9i
         Llyd8XtgsLwtdinUFfmknrg6UIBeZCjy6JQZFgcMHvhGfd1MftGDOaGwygEp5kWEQNsG
         ZMSTH65bSNDyTJ7Z2rSKITeYQI5gcttD/lUqS1HONBXG2miYtX/Z7Qe269fv6ReWnK2O
         ZI9w==
X-Gm-Message-State: AOAM533Ek4lUgaG/NbiUZApfJ/cBW0o84M6XUlvuz3fSIg0ax1qPvet7
        l4O54tFPeW86tNn3BBbusQdvNy4GhPv1bN/Wy+g83A==
X-Google-Smtp-Source: ABdhPJwH6G33CSLRbK/YrlBVYQgaxrVkIGfnuaoOZoME1EqaPdgjdwiBFGo/91dZUEdsIzo9e3Hd4CNZALLtH9Agb1w=
X-Received: by 2002:a37:a1d5:: with SMTP id k204mr2452384qke.300.1624486237874;
 Wed, 23 Jun 2021 15:10:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210621173028.3541424-1-mw@semihalf.com> <20210621173028.3541424-3-mw@semihalf.com>
 <YNOYFFgB5UNdSYeI@lunn.ch>
In-Reply-To: <YNOYFFgB5UNdSYeI@lunn.ch>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 24 Jun 2021 00:10:28 +0200
Message-ID: <CAPv3WKdR-NJ8oPo5JHb9rztYdQUZA=D3sLyf07D5n5oOm=UfjA@mail.gmail.com>
Subject: Re: [net-next: PATCH v3 2/6] net: mdiobus: Introduce fwnode_mdbiobus_register()
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, upstream@semihalf.com,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Jon Nettleton <jon@solid-run.com>,
        Tomasz Nowicki <tn@semihalf.com>, rjw@rjwysocki.net,
        lenb@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

=C5=9Br., 23 cze 2021 o 22:22 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> On Mon, Jun 21, 2021 at 07:30:24PM +0200, Marcin Wojtas wrote:
> > This patch introduces a new helper function that
> > wraps acpi_/of_ mdiobus_register() and allows its
> > usage via common fwnode_ interface.
> >
> > Fall back to raw mdiobus_register() in case CONFIG_FWNODE_MDIO
> > is not enabled, in order to satisfy compatibility
> > in all future user drivers.
> >
> > Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> > ---
> >  include/linux/fwnode_mdio.h    | 12 +++++++++++
> >  drivers/net/mdio/fwnode_mdio.c | 22 ++++++++++++++++++++
> >  2 files changed, 34 insertions(+)
> >
> > diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
> > index faf603c48c86..13d4ae8fee0a 100644
> > --- a/include/linux/fwnode_mdio.h
> > +++ b/include/linux/fwnode_mdio.h
> > @@ -16,6 +16,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus=
 *mdio,
> >  int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> >                               struct fwnode_handle *child, u32 addr);
> >
> > +int fwnode_mdiobus_register(struct mii_bus *bus, struct fwnode_handle =
*fwnode);
> >  #else /* CONFIG_FWNODE_MDIO */
> >  int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
> >                                      struct phy_device *phy,
> > @@ -30,6 +31,17 @@ static inline int fwnode_mdiobus_register_phy(struct=
 mii_bus *bus,
> >  {
> >       return -EINVAL;
> >  }
> > +
> > +static inline int fwnode_mdiobus_register(struct mii_bus *bus,
> > +                                       struct fwnode_handle *fwnode)
> > +{
> > +     /*
> > +      * Fall back to mdiobus_register() function to register a bus.
> > +      * This way, we don't have to keep compat bits around in drivers.
> > +      */
> > +
> > +     return mdiobus_register(mdio);
> > +}
> >  #endif
>
> I looked at this some more, and in the end i decided it was O.K.
>
> > +/**
> > + * fwnode_mdiobus_register - bring up all the PHYs on a given MDIO bus=
 and
> > + *   attach them to it.
> > + * @bus: Target MDIO bus.
> > + * @fwnode: Pointer to fwnode of the MDIO controller.
> > + *
> > + * Return values are determined accordingly to acpi_/of_ mdiobus_regis=
ter()
> > + * operation.
> > + */
> > +int fwnode_mdiobus_register(struct mii_bus *bus, struct fwnode_handle =
*fwnode)
> > +{
> > +     if (is_acpi_node(fwnode))
> > +             return acpi_mdiobus_register(bus, fwnode);
> > +     else if (is_of_node(fwnode))
> > +             return of_mdiobus_register(bus, to_of_node(fwnode));
> > +     else
> > +             return -EINVAL;
>
> I wounder if here you should call mdiobus_register(mdio), rather than
> -EINVAL?
>
> I don't have a strong opinion.

Currently (and in foreseeable future) we support only DT/ACPI as a
firmware description, reaching the last "else" means something really
wrong. The case of lack of DT/ACPI and the fallback is handled on the
include/linux/fwnode_mdio.h level.

>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>

Thanks,
Marcin
