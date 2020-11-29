Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9943E2C78D2
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 12:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgK2L3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 06:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgK2L3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 06:29:03 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0178BC0613CF;
        Sun, 29 Nov 2020 03:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sZ+dBX5S94khbymeif4mad8kZfApM2klPCUgh0A8MB8=; b=szgfVuZ4HYowNeC8qNNPA5p2B
        mQR2vQbHhbjHj+/z4iieIvsgiQ7senwiLVVfYeLQkoBqKTCDyRHSx69GCT6X0RxzHSTQO06aSxllc
        Ren5IbjAR1YdslTfakOdxkLWIYorv3uaCpZJdYMZLozPBeeHdkT6t0lu5VehcjeL/un9bV968nv6F
        6TAe0JcN/u0MyG0I9iIacxmOzBkY/tDwfBvLaLVBZ0itDepp5W7meOltl8nzH5eNfQhRzifWIalIB
        lY7LViTw6WF8jOw6nu/Ob7rKyc1iXXgxLbyCzr/IDhY3tqhL0QL6R8xQztOKubxddziUBMK4/FItg
        NVD1SVJ5Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37552)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kjKsJ-0005YA-Ff; Sun, 29 Nov 2020 11:28:15 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kjKsI-0003xw-RX; Sun, 29 Nov 2020 11:28:14 +0000
Date:   Sun, 29 Nov 2020 11:28:14 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201129112814.GH1605@shell.armlinux.org.uk>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201128190616.GF2191767@lunn.ch>
 <20201128222828.GQ1551@shell.armlinux.org.uk>
 <20201129105245.GG1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201129105245.GG1605@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 29, 2020 at 10:52:45AM +0000, Russell King - ARM Linux admin wrote:
> On Sat, Nov 28, 2020 at 10:28:28PM +0000, Russell King - ARM Linux admin wrote:
> > On Sat, Nov 28, 2020 at 08:06:16PM +0100, Andrew Lunn wrote:
> > > > +static void sparx5_phylink_mac_config(struct phylink_config *config,
> > > > +				      unsigned int mode,
> > > > +				      const struct phylink_link_state *state)
> > > > +{
> > > > +	struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
> > > > +	struct sparx5_port_config conf;
> > > > +	int err = 0;
> > > > +
> > > > +	conf = port->conf;
> > > > +	conf.autoneg = state->an_enabled;
> > > > +	conf.pause = state->pause;
> > > > +	conf.duplex = state->duplex;
> > > > +	conf.power_down = false;
> > > > +	conf.portmode = state->interface;
> > > > +
> > > > +	if (state->speed == SPEED_UNKNOWN) {
> > > > +		/* When a SFP is plugged in we use capabilities to
> > > > +		 * default to the highest supported speed
> > > > +		 */
> > > 
> > > This looks suspicious.
> > 
> > Yes, it looks highly suspicious. The fact that
> > sparx5_phylink_mac_link_up() is empty, and sparx5_phylink_mac_config()
> > does all the work suggests that this was developed before the phylink
> > re-organisation, and this code hasn't been updated for it.
> > 
> > Any new code for the kernel really ought to be updated for the new
> > phylink methodology before it is accepted.
> > 
> > Looking at sparx5_port_config(), it also seems to use
> > PHY_INTERFACE_MODE_1000BASEX for both 1000BASE-X and 2500BASE-X. All
> > very well for the driver to do that internally, but it's confusing
> > when it comes to reviewing this stuff, especially when people outside
> > of the driver (such as myself) reviewing it need to understand what's
> > going on with the configuration.
> 
> There are other issues too.
> 
> Looking at sparx5_get_1000basex_status(), we have:
> 
>  +       status->link = DEV2G5_PCS1G_LINK_STATUS_LINK_STATUS_GET(value) |
>  +                      DEV2G5_PCS1G_LINK_STATUS_SYNC_STATUS_GET(value);
> 
> Why is the link status the logical OR of these?
> 
>  +                       if ((lp_abil >> 8) & 1) /* symmetric pause */
>  +                               status->pause = MLO_PAUSE_RX | MLO_PAUSE_TX;
>  +                       if (lp_abil & (1 << 7)) /* asymmetric pause */
>  +                               status->pause |= MLO_PAUSE_RX;
> 
> is actually wrong, and I see I need to improve the documentation for
> mac_pcs_get_state(). The intention in the documentation was concerning
> hardware that indicated the _resolved_ status of pause modes. It was
> not intended that drivers resolve the pause modes themselves.
> 
> Even so, the above is still wrong; it takes no account of what is being
> advertised at the local end. If one looks at the implementation in
> phylink_decode_c37_word(), one will notice there is code to deal with
> this.
> 
> I think we ought to make phylink_decode_c37_word() and
> phylink_decode_sgmii_word() public functions, and then this driver can
> use these helpers to decode the link partner advertisement to the
> phylink state.
> 
> Does the driver need to provide an ethtool .get_link function? That
> seems to bypass phylink. Why can't ethtool_op_get_link() be used?
> 
> I think if ethtool_op_get_link() is used, we then have just one caller
> for sparx5_get_port_status(), which means "struct sparx5_port_status"
> can be eliminated and the code cleaned up to use the phylink decoding
> helpers.

(Sorry, I keep spotting bits in the code - it's really not an easy
chunk of code to review.)

I'm also not sure that this is really correct:

+       status->serdes_link = !phy_validate(port->serdes, PHY_MODE_ETHERNET,
+                                           port->conf.portmode, NULL);

The documentation for phy_validate() says:

 * Used to check that the current set of parameters can be handled by
 * the phy. Implementations are free to tune the parameters passed as
 * arguments if needed by some implementation detail or
 * constraints. It will not change any actual configuration of the
 * PHY, so calling it as many times as deemed fit will have no side
 * effect.

and clearly, passing NULL for opts, gives the function no opportunity
to do what it's intended, so phy_validate() is being used for some
other purpose than that which the drivers/phy subsystem intends it to
be used for.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
