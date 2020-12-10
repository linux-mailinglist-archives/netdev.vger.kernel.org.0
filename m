Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D8C2D63F1
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 18:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392824AbgLJRop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 12:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392818AbgLJRoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 12:44:44 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31326C06179C
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 09:44:04 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id c7so5607638qke.1
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 09:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HR2j1Lh1j1pFPcbSQMjzaQI2SE2XB/P5aUZLPCnOyyc=;
        b=z4PtusWaLUFPJ4+Xti3rgU4dxFtgwWDGjV3EEyo6E/hABmxiV00Rq8ZiXG4deOVAxF
         fLkxTlHqAiJ6HMyvcvb1JhZ2GmMK9+JFzNtPenF0Gj0inTrfWGUctvkqVeTeaCGIXICy
         1Kl1SECXZQK2XFp7N16IUQm1OuwBV4dEKtjpvFIAD+LAehUBQ28iv8eFBlpOJbdAb4vl
         +gSuzsjRJdoMwNyEgkTSTkm6E1X/5nF10m2WLvZ9RNXHu8zughZu5ckqkuOF9/qKO/sk
         0ludiZC4BHD1MCAMtqVs6FrKm4keK20N5wT5opQ10C7igSmtS1nLNFjfu46/crCbN4mg
         S2Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HR2j1Lh1j1pFPcbSQMjzaQI2SE2XB/P5aUZLPCnOyyc=;
        b=YTM8G1gfTBaTK9oay6gazx38m1RZbX4dqU+1N3gOgdzqIl12UOUx9aJW3usfh0w2wD
         nQ3wXUdvsvWcXuTsx+klH6l4pC/B/j1uy5anFVUxXg4KjFzRx8ll/926Zt79W13EGxpJ
         LPApm2+oNDWOPN/rjKaS6aKBWlVCHcnK+JlP/xecB5CUQcLRJa8Juqw1infbrtZFDrfX
         9rrPszD+yzfWseHMsWi1/jkDjlAS+Zv0eruPiLhneYyh1T9XVcz/FxO4dlpQNIUK1WUm
         P8ufF804bVeJMZwkViRptczjAfQYibgvO9hpHukpz5cHDw567YpHxIvGnNN1ze6OP5UE
         pjJQ==
X-Gm-Message-State: AOAM53279cwfNN8Qi9yt/uOSSJDA4C+CUkO0SzoedpIbTVXvX0anFGV/
        +DQ06KZ7Trm5IAeUIASjDP0O+xGkr1SdqUaLQVxoWA==
X-Google-Smtp-Source: ABdhPJzZZjNJAE5d/aKqVLf4/P9Yrns9GFZ3rPDsaz1Wpf7AvUfqUdfMqYZ+XkOHXy4M1cCpxbUwA/OIWFy2a4n+U5Q=
X-Received: by 2002:a37:f509:: with SMTP id l9mr10163369qkk.155.1607622243292;
 Thu, 10 Dec 2020 09:44:03 -0800 (PST)
MIME-Version: 1.0
References: <20200620092047.GR1551@shell.armlinux.org.uk> <E1jmZgq-0001UG-1c@rmk-PC.armlinux.org.uk>
 <CAPv3WKdJKAEwCoj5z6NzP2xRFfT1HG+2o0wigt=Czi4bG7EQcg@mail.gmail.com>
 <CAPv3WKfEN22cKbM8=+qDANefQE67KQ1zwURrCqAsrbo1+gBCDA@mail.gmail.com>
 <20201102180326.GA2416734@kroah.com> <CAPv3WKf0fNOOovq9UzoxoAXwGLMe_MHdfCZ6U9sjgKxarUKA+Q@mail.gmail.com>
 <20201208133532.GH643756@sasha-vm> <CAPv3WKed9zhe0q2noGKiKdzd=jBNLtN6vRW0fnQddJhhiD=rkg@mail.gmail.com>
 <X9CuTjdgD3tDKWwo@kroah.com> <CAPv3WKdKOnd+iBkfcVkoOZkHj16jOpBprY3A01ERJeq6ZQCkVQ@mail.gmail.com>
 <20201210154651.GV1551@shell.armlinux.org.uk>
In-Reply-To: <20201210154651.GV1551@shell.armlinux.org.uk>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 10 Dec 2020 18:43:50 +0100
Message-ID: <CAPv3WKdWr0zfuTkK+x6u7C6FpFxkVtRFrEq1FvemVpLYw2+5ng@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port() helper
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Jon Nettleton <jon@solid-run.com>,
        Andrew Elwell <andrew.elwell@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

czw., 10 gru 2020 o 16:46 Russell King - ARM Linux admin
<linux@armlinux.org.uk> napisa=C5=82(a):
>
> On Thu, Dec 10, 2020 at 03:35:29PM +0100, Marcin Wojtas wrote:
> > Hi Greg,
> >
> > =C5=9Br., 9 gru 2020 o 11:59 Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> napisa=C5=82(a):
> > > What part fixes the issue?  I can't see it...
> >
> > I re-checked in my setup and here's the smallest part of the original
> > patch, that fixes previously described issue:
> > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > index e98be8372780..9d71a4fe1750 100644
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > @@ -4767,6 +4767,11 @@ static void mvpp2_port_copy_mac_addr(struct
> > net_device *dev, struct mvpp2 *priv,
> >         eth_hw_addr_random(dev);
> >  }
> >
> > +static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_config =
*config)
> > +{
> > +       return container_of(config, struct mvpp2_port, phylink_config);
> > +}
> > +
> >  static void mvpp2_phylink_validate(struct phylink_config *config,
> >                                    unsigned long *supported,
> >                                    struct phylink_link_state *state)
> > @@ -5105,13 +5110,12 @@ static void mvpp2_gmac_config(struct
> > mvpp2_port *port, unsigned int mode,
> >  static void mvpp2_mac_config(struct phylink_config *config, unsigned i=
nt mode,
> >                              const struct phylink_link_state *state)
> >  {
> > -       struct net_device *dev =3D to_net_dev(config->dev);
> > -       struct mvpp2_port *port =3D netdev_priv(dev);
> > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
> >         bool change_interface =3D port->phy_interface !=3D state->inter=
face;
> >
> >         /* Check for invalid configuration */
> >         if (mvpp2_is_xlg(state->interface) && port->gop_id !=3D 0) {
> > -               netdev_err(dev, "Invalid mode on %s\n", dev->name);
> > +               netdev_err(port->dev, "Invalid mode on %s\n", port->dev=
->name);
> >                 return;
> >         }
> >
> > @@ -5151,8 +5155,7 @@ static void mvpp2_mac_link_up(struct
> > phylink_config *config,
> >                               int speed, int duplex,
> >                               bool tx_pause, bool rx_pause)
> >  {
> > -       struct net_device *dev =3D to_net_dev(config->dev);
> > -       struct mvpp2_port *port =3D netdev_priv(dev);
> > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
> >         u32 val;
> >
> >         if (mvpp2_is_xlg(interface)) {
> > @@ -5199,7 +5202,7 @@ static void mvpp2_mac_link_up(struct
> > phylink_config *config,
> >
> >         mvpp2_egress_enable(port);
> >         mvpp2_ingress_enable(port);
> > -       netif_tx_wake_all_queues(dev);
> > +       netif_tx_wake_all_queues(port->dev);
> >  }
> >
> >  static void mvpp2_mac_link_down(struct phylink_config *config,
>
> The problem is caused by this hack:
>
>                 /* Phylink isn't used as of now for ACPI, so the MAC has =
to be
>                  * configured manually when the interface is started. Thi=
s will
>                  * be removed as soon as the phylink ACPI support lands i=
n.
>                  */
>                 struct phylink_link_state state =3D {
>                         .interface =3D port->phy_interface,
>                 };
>                 mvpp2_mac_config(&port->phylink_config, MLO_AN_INBAND, &s=
tate);
>                 mvpp2_mac_link_up(&port->phylink_config, MLO_AN_INBAND,
>                                   port->phy_interface, NULL);
>
> which passes an un-initialised (zeroed) port->phylink_config, as
> phylink is not used in ACPI setups.
>
> The problem occurs because port->phylink_config.dev (which is a
> NULL pointer in this instance) is passed to to_net_dev():
>
> #define to_net_dev(d) container_of(d, struct net_device, dev)
>
> Which then means netdev_priv(dev) attempts to dereference a not-quite
> NULL pointer, leading to an oops.

Correct. Hopefully the MDIO+ACPI patchset will land and I'll be able
to get rid of this hack and do not maintain dual handling paths any
longer.

>
> The problem here is that the bug was not noticed; it seems hardly
> anyone bothers to run mainline kernels with ACPI on Marvell platforms,
> or if they do, they don't bother reporting to mainline communities
> when they have problems. Likely, there's posts on some random web-based
> bulletin board or mailing list that kernel developers don't read
> somewhere complaining that there's an oops.
>

I must admit that due to other duties I did not follow the mainline
mvpp2 for a couple revisions (and I am not maintainer of it). However
recently I got reached-out directly by different developers - the
trigger was different distros upgrading the kernel above v5.4+ and for
some reasons the DT path is not chosen there (and the ACPI will be
chosen more and more in the SystemReady world).

> Like...
>
> https://lists.einval.com/pipermail/macchiato/2020-January/000309.html
> https://gist.github.com/AdrianKoshka/ff9862da2183a2d8e26d47baf8dc04b9
>
> This kind of segmentation is very disappointing; it means potentially
> lots of bugs go by unnoticed by kernel developers, and bugs only get
> fixed by chance.  Had it been reported to somewhere known earlier
> this year, it is likely that a proper fix patch would have been
> created.

Totally agree. As soon as I got noticed directly it took me no time to
find the regression root cause.

>
> How this gets handled is ultimately up to the stable developers to
> decide what they wish to accept. Do they wish to accept a back-ported
> full version of my commit 6c2b49eb9671 ("net: mvpp2: add
> mvpp2_phylink_to_port() helper") that unintentionally fixed this
> unknown issue, or do they want a more minimal fix such as the cut-down
> version of that commit that Marcin has supplied.
>
> Until something changes in the way bugs get reported, I suspect this
> won't be the only instance of bug-fixing-by-accident happening.
>

Thank you Russell for your input.

Best regards,
Marcin
