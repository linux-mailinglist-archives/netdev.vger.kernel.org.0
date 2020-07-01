Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFEB210A3F
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 13:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbgGALZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 07:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730159AbgGALZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 07:25:03 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E0BC061755
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 04:25:02 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id dr13so24185244ejc.3
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 04:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5ldzACZu0veQk05izSw826jYF5u64WxixG+XTn1u+10=;
        b=n1LhgMfyNqb9GNx6ZKKy08mwsQWdYgXHHTB1Sn8+fNHWd7epF8qXdojNoBiiYs7FnE
         1FjSZNTr+2UpwG8RBZX08GbpigXVhqqdFAVk52V49aRnxQiPU7KCHmryj7Z0LI0XW93W
         OuS8hUNs9Vfor0FyDmxHMWsA+15kJ2ameuiOj3eL7SXid8VTMnjqDYRUSirRt5r383Rn
         ypOAHqq4HJuG85QwT8OhsBy6Un5/dDuSfSv9GmeqzplLPeaBb4PU6CneoaO9il9zCbXI
         3fGv1a1IEEyqAXkuIkuTEndXWbWNU/N8RXFYeNusQR0vgUIbWARKbjjqLnqSfTucjpNc
         QSxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ldzACZu0veQk05izSw826jYF5u64WxixG+XTn1u+10=;
        b=rXpoxjjaU/kNZSuKk6/y5z+e88BrE0a7AOd0HE4GZQWa8NUvXe4Q4LyLw1iN1pG0aQ
         hDgX3nTksfk9Uc3pM7UxqGL+ZjeJ+UzgYkscAUL/I2hye2QLy9pek/K3D/g4C1GB+5dj
         pi0LeV7waf+TuFN9kSRyxO/Yj+YCOeQF5vdKvW8ig6ghOGUN7AX0Riqhigu27SVDgTl0
         gJRhc643m+87FEmI4KKTflykPqPMt/kZ4NcGH9A+0pLmgzO4eKGEd5YiiXuw4vIjNsNO
         u4VFhSQpJhV/KQLrqVwME87x+ZkVmzvBGxb3sHh2gGhpDBtUP1GlHHWoONzxyYCNQeTi
         8vtg==
X-Gm-Message-State: AOAM533je2JGTf4EV2Rx27vW6rgnyI4AtVRdyNMHguutcojUq3enIdn4
        4rMUhu79VP58fZfcvF6Kd0ysWnp5PX4EDgp1WWM=
X-Google-Smtp-Source: ABdhPJwiG5neD5qAuPE2GEkSKjUwo30u7MdwIW++7A5gKiHsJ86ydzmZx0TMmnTZhQPFV46MQXedqYFavqPN8axVg+Q=
X-Received: by 2002:a17:906:1499:: with SMTP id x25mr22078378ejc.406.1593602701606;
 Wed, 01 Jul 2020 04:25:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200630142754.GC1551@shell.armlinux.org.uk> <E1jqHGO-0006QN-Hw@rmk-PC.armlinux.org.uk>
 <CA+h21hokR=966wRCWctN+gNALjZmr3tXU1D4uHhoFDwos7vNdQ@mail.gmail.com> <20200701111642.GJ1551@shell.armlinux.org.uk>
In-Reply-To: <20200701111642.GJ1551@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 1 Jul 2020 14:24:50 +0300
Message-ID: <CA+h21hp_ZNRw9Df75nH64A6it26JXj-9DpQyft6cB22M0YMvNQ@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 12/13] net: phylink: add struct phylink_pcs
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Jul 2020 at 14:16, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Wed, Jul 01, 2020 at 01:47:27PM +0300, Vladimir Oltean wrote:
> > Hi Russell,
> >
> > On Tue, 30 Jun 2020 at 17:29, Russell King <rmk+kernel@armlinux.org.uk> wrote:
> > >
> > > Add a way for MAC PCS to have private data while keeping independence
> > > from struct phylink_config, which is used for the MAC itself. We need
> > > this independence as we will have stand-alone code for PCS that is
> > > independent of the MAC.  Introduce struct phylink_pcs, which is
> > > designed to be embedded in a driver private data structure.
> > >
> > > This structure does not include a mdio_device as there are PCS
> > > implementations such as the Marvell DSA and network drivers where this
> > > is not necessary.
> > >
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > ---
> > >  drivers/net/phy/phylink.c | 25 ++++++++++++++++------
> > >  include/linux/phylink.h   | 45 ++++++++++++++++++++++++++-------------
> > >  2 files changed, 48 insertions(+), 22 deletions(-)
> > >
> > > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > > index a31a00fb4974..fbc8591b474b 100644
> > > --- a/drivers/net/phy/phylink.c
> > > +++ b/drivers/net/phy/phylink.c
> > > @@ -43,6 +43,7 @@ struct phylink {
> > >         const struct phylink_mac_ops *mac_ops;
> > >         const struct phylink_pcs_ops *pcs_ops;
> > >         struct phylink_config *config;
> > > +       struct phylink_pcs *pcs;
> > >         struct device *dev;
> > >         unsigned int old_link_state:1;
> > >
> > > @@ -427,7 +428,7 @@ static void phylink_mac_pcs_an_restart(struct phylink *pl)
> > >             phy_interface_mode_is_8023z(pl->link_config.interface) &&
> > >             phylink_autoneg_inband(pl->cur_link_an_mode)) {
> > >                 if (pl->pcs_ops)
> > > -                       pl->pcs_ops->pcs_an_restart(pl->config);
> > > +                       pl->pcs_ops->pcs_an_restart(pl->pcs);
> > >                 else
> > >                         pl->mac_ops->mac_an_restart(pl->config);
> > >         }
> > > @@ -453,7 +454,7 @@ static void phylink_change_interface(struct phylink *pl, bool restart,
> > >         phylink_mac_config(pl, state);
> > >
> > >         if (pl->pcs_ops) {
> > > -               err = pl->pcs_ops->pcs_config(pl->config, pl->cur_link_an_mode,
> > > +               err = pl->pcs_ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
> > >                                               state->interface,
> > >                                               state->advertising,
> > >                                               !!(pl->link_config.pause &
> > > @@ -533,7 +534,7 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
> > >         state->link = 1;
> > >
> > >         if (pl->pcs_ops)
> > > -               pl->pcs_ops->pcs_get_state(pl->config, state);
> > > +               pl->pcs_ops->pcs_get_state(pl->pcs, state);
> > >         else
> > >                 pl->mac_ops->mac_pcs_get_state(pl->config, state);
> > >  }
> > > @@ -604,7 +605,7 @@ static void phylink_link_up(struct phylink *pl,
> > >         pl->cur_interface = link_state.interface;
> > >
> > >         if (pl->pcs_ops && pl->pcs_ops->pcs_link_up)
> > > -               pl->pcs_ops->pcs_link_up(pl->config, pl->cur_link_an_mode,
> > > +               pl->pcs_ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
> > >                                          pl->cur_interface,
> > >                                          link_state.speed, link_state.duplex);
> > >
> > > @@ -863,11 +864,19 @@ struct phylink *phylink_create(struct phylink_config *config,
> > >  }
> > >  EXPORT_SYMBOL_GPL(phylink_create);
> > >
> > > -void phylink_add_pcs(struct phylink *pl, const struct phylink_pcs_ops *ops)
> > > +/**
> > > + * phylink_set_pcs() - set the current PCS for phylink to use
> > > + * @pl: a pointer to a &struct phylink returned from phylink_create()
> > > + * @pcs: a pointer to the &struct phylink_pcs
> > > + *
> > > + * Bind the MAC PCS to phylink.
> > > + */
> > > +void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
> > >  {
> > > -       pl->pcs_ops = ops;
> > > +       pl->pcs = pcs;
> > > +       pl->pcs_ops = pcs->ops;
> > >  }
> > > -EXPORT_SYMBOL_GPL(phylink_add_pcs);
> > > +EXPORT_SYMBOL_GPL(phylink_set_pcs);
> > >
> > >  /**
> > >   * phylink_destroy() - cleanup and destroy the phylink instance
> > > @@ -1212,6 +1221,8 @@ void phylink_start(struct phylink *pl)
> > >                 break;
> > >         case MLO_AN_INBAND:
> > >                 poll |= pl->config->pcs_poll;
> > > +               if (pl->pcs)
> > > +                       poll |= pl->pcs->poll;
> >
> > Do we see a need for yet another way to request phylink to poll the
> > PCS for link status?
>
> Please consider what the model looks like if we have the PCS almost
> self contained except for this property, which is in the MAC side.
> What if some PCS need to be polled but others do not.  Why should the
> MAC need to have that knowledge - is it not a property of the PCS
> itself?
>
> The reason we stuffed it into phylink_config is that at the time, that
> was all that existed.  That doesn't mean that when we change the model
> that we should be tied by that decision.
>
> So, for example, does the Lynx PCS IP support any kind of notification
> of link changes to its integrated system?  If it does not, then having
> the Lynx PCS mark _itself_ as needing polling is entirely sane, rather
> than burying that information in the MAC driver.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Well, there is a MAC register called IEVENT[PCS]. For some Lynx
integrations, such as Felix, I know it doesn't fire an IRQ. Now, if it
doesn't fire on _all_ SoCs which integrate Lynx, that I don't know.
But the interrupt is going to be highly system-specific either way (on
some MACs it's a regular IRQ line, on others it's an MSI). So, in the
general case, I think this is system-specific and not a property of
the PCS itself.
