Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F503B2D4C
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 13:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhFXLMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 07:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbhFXLMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 07:12:36 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEE7C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:10:17 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id u2so3029321qvp.13
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7Kmszu6cucNqXB6Mb5j/8fAwFEGVFfmkw2+JHwAEEiM=;
        b=nJXky57xz0x7I98tBot6BTTDCKBhipY4/W6TqjIq+rVlcwTaEuRGYRH1yUZIm1Lw2T
         55Fmn5qymxCIssEPmdIMUdq7zKex8WslkjYAL90d3NuPTV31HSb2fFdgYjzmGzXJSYFz
         HyTSZ8wJ+QqJ0WpV2h3XuIl0x5tzxexO9r4JuWk+4Q/FQ6EqrsKz/rh9+CsQO6w+KP0Z
         tSLR4QA0KgKnmez5FcxiKGoFUYGYW7OO1CXW+CZuxYoH7ZGSIfL4ukqwI4xPMJC6SMGW
         mMNpg8Ly9LIR3nWr/eiUDh/cQCOd3Yh1cXmJlI5uDKBSfLXQQldQ7FtcHK+FVPZRkTtv
         jU6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7Kmszu6cucNqXB6Mb5j/8fAwFEGVFfmkw2+JHwAEEiM=;
        b=GZsYHNfc+i4OIKc7i3Dnvcjsl2Zn0ZbkH2lxN+pehM/qqWBegJ8bDfy5gM8vBVFs46
         ryGVnKPbLOJDtoN2PGcNgejq3OvPx1YXjJYSyaqOnbjjOupzHGo8BY7OGcq94NLqID37
         DEAYOUPn1oJriuapyS/b/fTvrSROLCscSm15qHZcSQSiYLZjVoLZfuqdatT6U1ID3oGy
         Kst7Z8ipJPV+k40SLL6bQ1TIBdvBADaFd6AHYCY96GAPSq+8Hbbf2bNDFFOZMO3aZV8u
         8e0sAQbFJpw/aHpvz9tCTdO/tBS7st80WrVnur+Fg7hVOGdjZu0xvvl3NormFJ5aeZYQ
         5c6g==
X-Gm-Message-State: AOAM532DsiLlnfOfXDD2td/AZOPiAq57MUWrwEU6YmLCiY6XNNs1l6d9
        +qgXoXe/l941H8eTv7PYi9T73zB5ea/L5EITK5np6Q==
X-Google-Smtp-Source: ABdhPJyuxLHvPFObd6POVT1jQHPEMa7EDK7m2QCVQAR5KroPHQHCehDC1xr8EBrrm9iNLl6RKXNuS6GApbblGPAcBDM=
X-Received: by 2002:a05:6214:8ed:: with SMTP id dr13mr4792385qvb.59.1624533016863;
 Thu, 24 Jun 2021 04:10:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210621173028.3541424-1-mw@semihalf.com> <20210621173028.3541424-3-mw@semihalf.com>
 <YNOYFFgB5UNdSYeI@lunn.ch> <CAPv3WKdR-NJ8oPo5JHb9rztYdQUZA=D3sLyf07D5n5oOm=UfjA@mail.gmail.com>
In-Reply-To: <CAPv3WKdR-NJ8oPo5JHb9rztYdQUZA=D3sLyf07D5n5oOm=UfjA@mail.gmail.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 24 Jun 2021 13:10:04 +0200
Message-ID: <CAPv3WKdSNZzvDS5-FNK4eTMfRt6xuk6xYJ6eQf0N01Q4OhRS9Q@mail.gmail.com>
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
        lenb@kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

czw., 24 cze 2021 o 00:10 Marcin Wojtas <mw@semihalf.com> napisa=C5=82(a):
>
> Hi,
>
> =C5=9Br., 23 cze 2021 o 22:22 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a=
):
> >
> > On Mon, Jun 21, 2021 at 07:30:24PM +0200, Marcin Wojtas wrote:
> > > This patch introduces a new helper function that
> > > wraps acpi_/of_ mdiobus_register() and allows its
> > > usage via common fwnode_ interface.
> > >
> > > Fall back to raw mdiobus_register() in case CONFIG_FWNODE_MDIO
> > > is not enabled, in order to satisfy compatibility
> > > in all future user drivers.
> > >
> > > Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> > > ---
> > >  include/linux/fwnode_mdio.h    | 12 +++++++++++
> > >  drivers/net/mdio/fwnode_mdio.c | 22 ++++++++++++++++++++
> > >  2 files changed, 34 insertions(+)
> > >
> > > diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.=
h
> > > index faf603c48c86..13d4ae8fee0a 100644
> > > --- a/include/linux/fwnode_mdio.h
> > > +++ b/include/linux/fwnode_mdio.h
> > > @@ -16,6 +16,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_b=
us *mdio,
> > >  int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> > >                               struct fwnode_handle *child, u32 addr);
> > >
> > > +int fwnode_mdiobus_register(struct mii_bus *bus, struct fwnode_handl=
e *fwnode);
> > >  #else /* CONFIG_FWNODE_MDIO */
> > >  int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
> > >                                      struct phy_device *phy,
> > > @@ -30,6 +31,17 @@ static inline int fwnode_mdiobus_register_phy(stru=
ct mii_bus *bus,
> > >  {
> > >       return -EINVAL;
> > >  }
> > > +
> > > +static inline int fwnode_mdiobus_register(struct mii_bus *bus,
> > > +                                       struct fwnode_handle *fwnode)
> > > +{
> > > +     /*
> > > +      * Fall back to mdiobus_register() function to register a bus.
> > > +      * This way, we don't have to keep compat bits around in driver=
s.
> > > +      */
> > > +
> > > +     return mdiobus_register(mdio);
> > > +}
> > >  #endif
> >
> > I looked at this some more, and in the end i decided it was O.K.
> >
> > > +/**
> > > + * fwnode_mdiobus_register - bring up all the PHYs on a given MDIO b=
us and
> > > + *   attach them to it.
> > > + * @bus: Target MDIO bus.
> > > + * @fwnode: Pointer to fwnode of the MDIO controller.
> > > + *
> > > + * Return values are determined accordingly to acpi_/of_ mdiobus_reg=
ister()
> > > + * operation.
> > > + */
> > > +int fwnode_mdiobus_register(struct mii_bus *bus, struct fwnode_handl=
e *fwnode)
> > > +{
> > > +     if (is_acpi_node(fwnode))
> > > +             return acpi_mdiobus_register(bus, fwnode);
> > > +     else if (is_of_node(fwnode))
> > > +             return of_mdiobus_register(bus, to_of_node(fwnode));
> > > +     else
> > > +             return -EINVAL;
> >
> > I wounder if here you should call mdiobus_register(mdio), rather than
> > -EINVAL?
> >
> > I don't have a strong opinion.
>
> Currently (and in foreseeable future) we support only DT/ACPI as a
> firmware description, reaching the last "else" means something really
> wrong. The case of lack of DT/ACPI and the fallback is handled on the
> include/linux/fwnode_mdio.h level.
>
> >
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> >

Unfortunately I have to withdraw this patch, as well as xgmac_mdio
one. In case the fwnode_/of_/acpi_mdio are built as modules, we get a
cycle dependency during depmod phase of modules_install, eg.:

depmod: ERROR: Cycle detected: fwnode_mdio -> of_mdio -> fwnode_mdio
depmod: ERROR: Found 2 modules in dependency cycles!

OR:

depmod: ERROR: Cycle detected: acpi_mdio -> fwnode_mdio -> acpi_mdio
depmod: ERROR: Found 2 modules in dependency cycles!

The proper solution would be to merge contents of
acpi_mdiobus_register and of_mdiobus_register inside the common
fwnode_mdiobus_register (so that the former would only call the
latter). However this change seems feasible, but I'd expect it to be a
patchset bigger than this one alone and deserves its own thorough
review and testing, as it would affect huge amount of current
of_mdiobus_register users.

Given above, for now I will resubmit this patchset in the shape as
proposed in v1, i.e. using the 'if' condition explicitly in mvmdio
driver.

Best regards,
Marcin
