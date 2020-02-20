Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAD8165B53
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 11:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgBTKUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 05:20:10 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57804 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgBTKUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 05:20:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6moDnFKQqPOewRkxNBYP20F+qayHFJQuzc0h1sreZ74=; b=pZBzU+9eIaJhVS0pf55ubOuHS
        hUM6CpVaaxnVn29ruIsr4Gwu0FeN5a/wALz8vgz5yVqq5GrQYFg80c8O7wEHRSP9pqKOclm9QIfdq
        H9f4XaU+8pdwbkTct+BmQB2i37b6pGfE1WDq4/W7hbHCJajaXhEROUOQqYMZ3MBg8Wug4V0QP3UgK
        GerKHo0h65CRpDWeYZCethJ5xoeuzvkMq9wop0qjWHlczF2h8saHaNiwpSkd24Vmu9o3XcMR+7wUG
        dD7Cd/XsAi36HIZB3UC2a4+HLXcKcwtS+E3qBHBYQu+Tl4S4ATGRE//384/1vacwfT6LOIDa7pyq0
        HfOjLfOCg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54482)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j4iw8-0002df-3X; Thu, 20 Feb 2020 10:20:04 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j4iw6-0002LR-U9; Thu, 20 Feb 2020 10:20:02 +0000
Date:   Thu, 20 Feb 2020 10:20:02 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [CFT 5/8] net: dpaa2-mac: use resolved link config in
 mac_link_up()
Message-ID: <20200220102002.GW25745@shell.armlinux.org.uk>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
 <E1j3k80-00072W-E5@rmk-PC.armlinux.org.uk>
 <20200218103400.GF25745@shell.armlinux.org.uk>
 <DB8PR04MB6828ECB9945F747281C5796EE0110@DB8PR04MB6828.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6828ECB9945F747281C5796EE0110@DB8PR04MB6828.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 10:42:41AM +0000, Ioana Ciornei wrote:
> > Subject: Re: [CFT 5/8] net: dpaa2-mac: use resolved link config in mac_link_up()
> > 
> > It would really help if MAINTAINERS were updated with the correct information
> > for this driver:
> > 
> > DPAA2 ETHERNET DRIVER
> > M:      Ioana Radulescu <ruxandra.radulescu@nxp.com>
> > 
> > This address bounces.  Given what I find in the git history, is the correct person is
> > now:
> > 
> > Ioana Ciornei <ioana.ciornei@nxp.com>
> > 
> > Please submit a patch updating MAINTAINERS.  Thanks.
> 
> Sure thing.  I'll update the MAINTAINERS file and list myself instead of Ioana Radulescu.

Any comments on the patch itself?

> > On Mon, Feb 17, 2020 at 05:24:16PM +0000, Russell King wrote:
> > > Convert the DPAA2 ethernet driver to use the finalised link parameters
> > > in mac_link_up() rather than the parameters in mac_config(), which are
> > > more suited to the needs of the DPAA2 MC firmware than those available
> > > via mac_config().
> > >
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > ---
> > >  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 54
> > > +++++++++++--------  .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |
> > > 1 +
> > >  2 files changed, 33 insertions(+), 22 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > > index 3a75c5b58f95..3ee236c5fc37 100644
> > > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > > @@ -123,35 +123,16 @@ static void dpaa2_mac_config(struct phylink_config
> > *config, unsigned int mode,
> > >  	struct dpmac_link_state *dpmac_state = &mac->state;
> > >  	int err;
> > >
> > > -	if (state->speed != SPEED_UNKNOWN)
> > > -		dpmac_state->rate = state->speed;
> > > -
> > > -	if (state->duplex != DUPLEX_UNKNOWN) {
> > > -		if (!state->duplex)
> > > -			dpmac_state->options |=
> > DPMAC_LINK_OPT_HALF_DUPLEX;
> > > -		else
> > > -			dpmac_state->options &=
> > ~DPMAC_LINK_OPT_HALF_DUPLEX;
> > > -	}
> > > -
> > >  	if (state->an_enabled)
> > >  		dpmac_state->options |= DPMAC_LINK_OPT_AUTONEG;
> > >  	else
> > >  		dpmac_state->options &= ~DPMAC_LINK_OPT_AUTONEG;
> > >
> > > -	if (state->pause & MLO_PAUSE_RX)
> > > -		dpmac_state->options |= DPMAC_LINK_OPT_PAUSE;
> > > -	else
> > > -		dpmac_state->options &= ~DPMAC_LINK_OPT_PAUSE;
> > > -
> > > -	if (!!(state->pause & MLO_PAUSE_RX) ^ !!(state->pause &
> > MLO_PAUSE_TX))
> > > -		dpmac_state->options |= DPMAC_LINK_OPT_ASYM_PAUSE;
> > > -	else
> > > -		dpmac_state->options &= ~DPMAC_LINK_OPT_ASYM_PAUSE;
> > > -
> > >  	err = dpmac_set_link_state(mac->mc_io, 0,
> > >  				   mac->mc_dev->mc_handle, dpmac_state);
> > >  	if (err)
> > > -		netdev_err(mac->net_dev, "dpmac_set_link_state() = %d\n",
> > err);
> > > +		netdev_err(mac->net_dev, "%s: dpmac_set_link_state() =
> > %d\n",
> > > +			   __func__, err);
> > >  }
> > >
> > >  static void dpaa2_mac_link_up(struct phylink_config *config, @@
> > > -165,10 +146,37 @@ static void dpaa2_mac_link_up(struct phylink_config
> > *config,
> > >  	int err;
> > >
> > >  	dpmac_state->up = 1;
> > > +
> > > +	if (mac->if_link_type == DPMAC_LINK_TYPE_PHY) {
> > > +		/* If the DPMAC is configured for PHY mode, we need
> > > +		 * to pass the link parameters to the MC firmware.
> > > +		 */
> > > +		dpmac_state->rate = speed;
> > > +
> > > +		if (duplex == DUPLEX_HALF)
> > > +			dpmac_state->options |=
> > DPMAC_LINK_OPT_HALF_DUPLEX;
> > > +		else if (duplex == DUPLEX_FULL)
> > > +			dpmac_state->options &=
> > ~DPMAC_LINK_OPT_HALF_DUPLEX;
> > > +
> > > +		/* This is lossy; the firmware really should take the pause
> > > +		 * enablement status rather than pause/asym pause status.
> > > +		 */
> > > +		if (rx_pause)
> > > +			dpmac_state->options |= DPMAC_LINK_OPT_PAUSE;
> > > +		else
> > > +			dpmac_state->options &= ~DPMAC_LINK_OPT_PAUSE;
> > > +
> > > +		if (rx_pause ^ tx_pause)
> > > +			dpmac_state->options |=
> > DPMAC_LINK_OPT_ASYM_PAUSE;
> > > +		else
> > > +			dpmac_state->options &=
> > ~DPMAC_LINK_OPT_ASYM_PAUSE;
> > > +	}
> > > +
> > >  	err = dpmac_set_link_state(mac->mc_io, 0,
> > >  				   mac->mc_dev->mc_handle, dpmac_state);
> > >  	if (err)
> > > -		netdev_err(mac->net_dev, "dpmac_set_link_state() = %d\n",
> > err);
> > > +		netdev_err(mac->net_dev, "%s: dpmac_set_link_state() =
> > %d\n",
> > > +			   __func__, err);
> > >  }
> > >
> > >  static void dpaa2_mac_link_down(struct phylink_config *config, @@
> > > -241,6 +249,8 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
> > >  		goto err_close_dpmac;
> > >  	}
> > >
> > > +	mac->if_link_type = attr.link_type;
> > > +
> > >  	dpmac_node = dpaa2_mac_get_node(attr.id);
> > >  	if (!dpmac_node) {
> > >  		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);
> > diff
> > > --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
> > > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
> > > index 4da8079b9155..2130d9c7d40e 100644
> > > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
> > > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
> > > @@ -20,6 +20,7 @@ struct dpaa2_mac {
> > >  	struct phylink_config phylink_config;
> > >  	struct phylink *phylink;
> > >  	phy_interface_t if_mode;
> > > +	enum dpmac_link_type if_link_type;
> > >  };
> > >
> > >  bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
> > > --
> > > 2.20.1
> > >
> > >
> > 
> > --
> > RMK's Patch system:
> > https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.ar
> > mlinux.org.uk%2Fdeveloper%2Fpatches%2F&amp;data=02%7C01%7Cioana.cior
> > nei%40nxp.com%7C09d0167191914135433808d7b45e15fd%7C686ea1d3bc2b4
> > c6fa92cd99c5c301635%7C0%7C0%7C637176188497544105&amp;sdata=t0%2B
> > OzkoqRM180UHGBrW6FYAvHsIelx4CaP4oC3QcP1k%3D&amp;reserved=0
> > FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> > According to speedtest.net: 11.9Mbps down 500kbps up
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
