Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739FA2DFFAB
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 19:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgLUS0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 13:26:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgLUS0V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 13:26:21 -0500
Date:   Mon, 21 Dec 2020 10:25:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608575140;
        bh=NzyDKbSpNFfRnN3VsafpplD3Q/O8witvPQs21aT4BTY=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kt2xoIzQV21HnsZ6nFoAD3Siae9kSxWyti/StkwSTCJ3xrjeLzbakIAa8K0tFq7bs
         EdjsQnfFhcV2PLYqSQNp//GfUZkFQwkYl1/3rP3wAF0koyesxBDfw69JE0xcWFJ6W2
         xeaQLUt2tnL1V39CiJzTCLEPuhzIq8zNS4xBv5xzKfiBS3mEH2aDBpeLi7hW8BgVmb
         25tbNOlocH4gUDlWuASsLZWrEqhKeEk8MiU5OyJqbn2uWmTjyb5y44ZgCIUKLksrzk
         ikTtbG3/WaX3lL2KpNVsm76kWnbSXwCpM8sw5fuavNSK/zAVdHfiL9Sy4fSHAft0ZL
         kRrOJXCML2dSA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Jon Nettleton <jon@solid-run.com>,
        Andrew Elwell <andrew.elwell@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port()
 helper
Message-ID: <20201221102539.6bdb9f5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAPv3WKfCfECmwjtXLAMbNe-vuGkws_icoQ+MrgJhZJqFcgGDyw@mail.gmail.com>
References: <20200620092047.GR1551@shell.armlinux.org.uk>
        <E1jmZgq-0001UG-1c@rmk-PC.armlinux.org.uk>
        <CAPv3WKdJKAEwCoj5z6NzP2xRFfT1HG+2o0wigt=Czi4bG7EQcg@mail.gmail.com>
        <CAPv3WKfEN22cKbM8=+qDANefQE67KQ1zwURrCqAsrbo1+gBCDA@mail.gmail.com>
        <20201102180326.GA2416734@kroah.com>
        <CAPv3WKf0fNOOovq9UzoxoAXwGLMe_MHdfCZ6U9sjgKxarUKA+Q@mail.gmail.com>
        <20201208133532.GH643756@sasha-vm>
        <CAPv3WKed9zhe0q2noGKiKdzd=jBNLtN6vRW0fnQddJhhiD=rkg@mail.gmail.com>
        <X9CuTjdgD3tDKWwo@kroah.com>
        <CAPv3WKdKOnd+iBkfcVkoOZkHj16jOpBprY3A01ERJeq6ZQCkVQ@mail.gmail.com>
        <CAPv3WKfCfECmwjtXLAMbNe-vuGkws_icoQ+MrgJhZJqFcgGDyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Dec 2020 18:08:19 +0100 Marcin Wojtas wrote:
> > > > > >> > > This patch fixes a regression that was introduced in v5.3:
> > > > > >> > > Commit 44cc27e43fa3 ("net: phylink: Add struct phylink_config to PHYLINK API")
> > > > > >> > >
> > > > > >> > > Above results in a NULL pointer dereference when booting the
> > > > > >> > > Armada7k8k/CN913x with ACPI between 5.3 and 5.8, which will be
> > > > > >> > > problematic especially for the distros using LTSv5.4 and above (the
> > > > > >> > > issue was reported on Fedora 32).
> > > > > >> > >
> > > > > >> > > Please help with backporting to the stable v5.3+ branches (it applies
> > > > > >> > > smoothly on v5.4/v5.6/v5.8).
> > > > > >> > >  
> > > > > >> >
> > > > > >> > Any chances to backport this patch to relevant v5.3+ stable branches?  
> > > > > >>
> > > > > >> What patch?  What git commit id needs to be backported?
> > > > > >>  
> > > > > >
> > > > > >The actual patch is:
> > > > > >Commit 6c2b49eb9671  ("net: mvpp2: add mvpp2_phylink_to_port() helper").
> > > > > >
> > > > > >URL for reference:
> > > > > >https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/ethernet/marvell/mvpp2?h=v5.10-rc7&id=6c2b49eb96716e91f202756bfbd3f5fea3b2b172
> > > > > >
> > > > > >Do you think it would be possible to get it merged to v5.3+ stable branches?  
> > > > >
> > > > > Could you explain how that patch fixes anything? It reads like a
> > > > > cleanup.
> > > > >  
> > > >
> > > > Indeed, I am aware of it, but I'm not sure about the best way to fix
> > > > it. In fact the mentioned patch is an unintentional fix. Commit
> > > > 44cc27e43fa3 ("net: phylink: Add struct phylink_config to PHYLINK
> > > > API") reworked an argument list of mvpp2_mac_config() routine in a way
> > > > that resulted in a NULL pointer dereference when booting the
> > > > Armada7k8k/CN913x with ACPI between 5.3 and 5.8. Part of Russell's
> > > > patch resolves this issue.  
> > >
> > > What part fixes the issue?  I can't see it...
> > >  
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
> > +static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_config *config)
> > +{
> > +       return container_of(config, struct mvpp2_port, phylink_config);
> > +}
> > +
> >  static void mvpp2_phylink_validate(struct phylink_config *config,
> >                                    unsigned long *supported,
> >                                    struct phylink_link_state *state)
> > @@ -5105,13 +5110,12 @@ static void mvpp2_gmac_config(struct
> > mvpp2_port *port, unsigned int mode,
> >  static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
> >                              const struct phylink_link_state *state)
> >  {
> > -       struct net_device *dev = to_net_dev(config->dev);
> > -       struct mvpp2_port *port = netdev_priv(dev);
> > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> >         bool change_interface = port->phy_interface != state->interface;
> >
> >         /* Check for invalid configuration */
> >         if (mvpp2_is_xlg(state->interface) && port->gop_id != 0) {
> > -               netdev_err(dev, "Invalid mode on %s\n", dev->name);
> > +               netdev_err(port->dev, "Invalid mode on %s\n", port->dev->name);
> >                 return;
> >         }
> >
> > @@ -5151,8 +5155,7 @@ static void mvpp2_mac_link_up(struct
> > phylink_config *config,
> >                               int speed, int duplex,
> >                               bool tx_pause, bool rx_pause)
> >  {
> > -       struct net_device *dev = to_net_dev(config->dev);
> > -       struct mvpp2_port *port = netdev_priv(dev);
> > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
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
> > --
> >
> > Do you think there is a point of slicing the original patch or rather
> > cherry-pick as-is?
> >  
> 
> Do you think there is a chance to get the above fix merged to stable (v5.3+)?

We need to work with stable maintainers on this, let's see..

Greg asked for a clear description of what happens, from your 
previous response it sounds like a null-deref in mvpp2_mac_config(). 
Is the netdev -> config -> netdev linking not ready by the time
mvpp2_mac_config() is called?
