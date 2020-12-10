Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3377F2D605A
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 16:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391255AbgLJPsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 10:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390949AbgLJPr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 10:47:57 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E558C0613CF;
        Thu, 10 Dec 2020 07:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SCk5LViIdQiiPV0OTu2H/d5OHm84hRrWgoX/RnOgAqc=; b=b0owhUpITfjZe9qEZY2J39cBw
        UEOcNIDzVdvMWIWwggv8mkHwVe3xUcqadRxd6kylC43wNPbg0LvWgN/y6vzGrSl3bhYHpNidB2N0R
        hrE/HWEK/56Qe7t6iGcntQvALEF3fzaOO662xPMFAVf6igM2OOkP4K8CjNwM7qPLip0tk3lA2aBgL
        YZfE2kSsThK2mJyGEcZsLcTj70bqxskJjLYgzvmpaHqwrAUxxTzI4XcsnNWHegzWoorvyvQGirjTA
        FyfJSNQNpi9vXxu68fAxQjSfBDtCYBKIfxSamzEBtFSN1bNnrFchnJEKnF6/wKmwhSUa/pRRxO9Jm
        aYTziDuhw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42226)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1knO9d-0004VV-IJ; Thu, 10 Dec 2020 15:46:53 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1knO9b-0008VM-Nu; Thu, 10 Dec 2020 15:46:51 +0000
Date:   Thu, 10 Dec 2020 15:46:51 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Jon Nettleton <jon@solid-run.com>,
        Andrew Elwell <andrew.elwell@gmail.com>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port()
 helper
Message-ID: <20201210154651.GV1551@shell.armlinux.org.uk>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKdKOnd+iBkfcVkoOZkHj16jOpBprY3A01ERJeq6ZQCkVQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 03:35:29PM +0100, Marcin Wojtas wrote:
> Hi Greg,
> 
> śr., 9 gru 2020 o 11:59 Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> napisał(a):
> > What part fixes the issue?  I can't see it...
> 
> I re-checked in my setup and here's the smallest part of the original
> patch, that fixes previously described issue:
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index e98be8372780..9d71a4fe1750 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -4767,6 +4767,11 @@ static void mvpp2_port_copy_mac_addr(struct
> net_device *dev, struct mvpp2 *priv,
>         eth_hw_addr_random(dev);
>  }
> 
> +static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_config *config)
> +{
> +       return container_of(config, struct mvpp2_port, phylink_config);
> +}
> +
>  static void mvpp2_phylink_validate(struct phylink_config *config,
>                                    unsigned long *supported,
>                                    struct phylink_link_state *state)
> @@ -5105,13 +5110,12 @@ static void mvpp2_gmac_config(struct
> mvpp2_port *port, unsigned int mode,
>  static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
>                              const struct phylink_link_state *state)
>  {
> -       struct net_device *dev = to_net_dev(config->dev);
> -       struct mvpp2_port *port = netdev_priv(dev);
> +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
>         bool change_interface = port->phy_interface != state->interface;
> 
>         /* Check for invalid configuration */
>         if (mvpp2_is_xlg(state->interface) && port->gop_id != 0) {
> -               netdev_err(dev, "Invalid mode on %s\n", dev->name);
> +               netdev_err(port->dev, "Invalid mode on %s\n", port->dev->name);
>                 return;
>         }
> 
> @@ -5151,8 +5155,7 @@ static void mvpp2_mac_link_up(struct
> phylink_config *config,
>                               int speed, int duplex,
>                               bool tx_pause, bool rx_pause)
>  {
> -       struct net_device *dev = to_net_dev(config->dev);
> -       struct mvpp2_port *port = netdev_priv(dev);
> +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
>         u32 val;
> 
>         if (mvpp2_is_xlg(interface)) {
> @@ -5199,7 +5202,7 @@ static void mvpp2_mac_link_up(struct
> phylink_config *config,
> 
>         mvpp2_egress_enable(port);
>         mvpp2_ingress_enable(port);
> -       netif_tx_wake_all_queues(dev);
> +       netif_tx_wake_all_queues(port->dev);
>  }
> 
>  static void mvpp2_mac_link_down(struct phylink_config *config,

The problem is caused by this hack:

                /* Phylink isn't used as of now for ACPI, so the MAC has to be
                 * configured manually when the interface is started. This will
                 * be removed as soon as the phylink ACPI support lands in.
                 */
                struct phylink_link_state state = {
                        .interface = port->phy_interface,
                };
                mvpp2_mac_config(&port->phylink_config, MLO_AN_INBAND, &state);
                mvpp2_mac_link_up(&port->phylink_config, MLO_AN_INBAND,
                                  port->phy_interface, NULL);

which passes an un-initialised (zeroed) port->phylink_config, as
phylink is not used in ACPI setups.

The problem occurs because port->phylink_config.dev (which is a
NULL pointer in this instance) is passed to to_net_dev():

#define to_net_dev(d) container_of(d, struct net_device, dev)

Which then means netdev_priv(dev) attempts to dereference a not-quite
NULL pointer, leading to an oops.

The problem here is that the bug was not noticed; it seems hardly
anyone bothers to run mainline kernels with ACPI on Marvell platforms,
or if they do, they don't bother reporting to mainline communities
when they have problems. Likely, there's posts on some random web-based
bulletin board or mailing list that kernel developers don't read
somewhere complaining that there's an oops.

Like...

https://lists.einval.com/pipermail/macchiato/2020-January/000309.html
https://gist.github.com/AdrianKoshka/ff9862da2183a2d8e26d47baf8dc04b9

This kind of segmentation is very disappointing; it means potentially
lots of bugs go by unnoticed by kernel developers, and bugs only get
fixed by chance.  Had it been reported to somewhere known earlier
this year, it is likely that a proper fix patch would have been
created.

How this gets handled is ultimately up to the stable developers to
decide what they wish to accept. Do they wish to accept a back-ported
full version of my commit 6c2b49eb9671 ("net: mvpp2: add
mvpp2_phylink_to_port() helper") that unintentionally fixed this
unknown issue, or do they want a more minimal fix such as the cut-down
version of that commit that Marcin has supplied.

Until something changes in the way bugs get reported, I suspect this
won't be the only instance of bug-fixing-by-accident happening.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
