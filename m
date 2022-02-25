Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044CD4C433C
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240005AbiBYLX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235085AbiBYLX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:23:58 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C901788B02
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 03:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZE6ytgGHLWwg1djS9w5SYqbrrZv7L1B/p9IPVgDQEFc=; b=cGYPpcMIVRoO4+me525sdRpKUy
        YIFqBFapZ2CL807FSt6bOvgT0+lbnEVUMX50w5eMit8hx3fFkGUIIIUpHSTdK0+wag6qzOIuUVQ7Q
        rDUWgfpw096yHrbsKG4fgpwwqQPV1c6xi93NgwxneBtWj8OtoLTHOzOSgfZ1J376Fk0RI2S+d0n0N
        y7XCDXcwEcZ2KRE26ph4ArgdoIHnr6lSwf8J/8VNLsbYpL9lTrjYQy2rw/oPjRfZBmdjkIgncnDJz
        xUymkzr8IqX4PRuixGhvLmRWQd7R2K4OzCJbYDaXq1wdxqmYrXE33Loz4WXqkjHMTslKn/fpB4oGL
        z64FdP1w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57476)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nNYh0-0005F6-5i; Fri, 25 Feb 2022 11:23:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nNYgy-00030X-Va; Fri, 25 Feb 2022 11:23:20 +0000
Date:   Fri, 25 Feb 2022 11:23:20 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 6/6] net: dsa: sja1105: support switching
 between SGMII and 2500BASE-X
Message-ID: <Yhi8KKOMlqbvkhDA@shell.armlinux.org.uk>
References: <YhevAJyU87bfCzfs@shell.armlinux.org.uk>
 <E1nNGmL-00AOjC-HP@rmk-PC.armlinux.org.uk>
 <20220225111649.pkmq3jxo6mm4qzfv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225111649.pkmq3jxo6mm4qzfv@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 01:16:49PM +0200, Vladimir Oltean wrote:
> On Thu, Feb 24, 2022 at 04:15:41PM +0000, Russell King (Oracle) wrote:
> > Vladimir Oltean suggests that sla1105 can support switching between
> 
> s/sla1105/sja1105/

Thanks for catching that.

> > SGMII and 2500BASE-X modes. Augment sja1105_phylink_get_caps() to
> > fill in both interface modes if they can be supported.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/dsa/sja1105/sja1105_main.c | 28 +++++++++++++++++++++-----
> >  1 file changed, 23 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> > index 5beef06d8ff7..36001b1d7968 100644
> > --- a/drivers/net/dsa/sja1105/sja1105_main.c
> > +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> > @@ -1396,6 +1396,7 @@ static void sja1105_phylink_get_caps(struct dsa_switch *ds, int port,
> >  {
> >  	struct sja1105_private *priv = ds->priv;
> >  	struct sja1105_xmii_params_entry *mii;
> > +	phy_interface_t phy_mode;
> >  
> >  	/* This driver does not make use of the speed, duplex, pause or the
> >  	 * advertisement in its mac_config, so it is safe to mark this driver
> > @@ -1403,11 +1404,28 @@ static void sja1105_phylink_get_caps(struct dsa_switch *ds, int port,
> >  	 */
> >  	config->legacy_pre_march2020 = false;
> >  
> > -	/* The SJA1105 MAC programming model is through the static config
> > -	 * (the xMII Mode table cannot be dynamically reconfigured), and
> > -	 * we have to program that early.
> > -	 */
> > -	__set_bit(priv->phy_mode[port], config->supported_interfaces);
> > +	phy_mode = priv->phy_mode[port];
> > +	if (phy_mode == PHY_INTERFACE_MODE_SGMII ||
> > +	    phy_mode == PHY_INTERFACE_MODE_2500BASEX) {
> > +		/* Changing the PHY mode on SERDES ports is possible and makes
> > +		 * sense, because that is done through the XPCS. We allow
> > +		 * changes between SGMII and 2500base-X (it is unknown whether
> > +		 * 1000base-X is supported).
> > +		 */
> 
> It is actually known (or so I think).
> Bits 2:1 (PCS_MODE) of register VR_MII_AN_CTRL (MMD 0x1f, address 0x8001)
> of the XPCS, as instantiated in SJA1105R/S, says:
> 00: Clause 37 auto-negotiation for 1000BASE-X mode
>     *Not supported*
> 10: Clause 37 auto-negotiation for SGMII mode
> 
> When I look at the XPCS documentation for SJA1110, it doesn't say
> "Not supported", however I don't have the setup to try it.
> If it's anything like the XPCS instantiation from SJA1105 though, this
> is possibly a documentation glitch and I wouldn't say it was implemented
> just because the documentation doesn't say it isn't.
> 
> On the other hand, disabling SGMII in-band autoneg is possible, and the
> resulting mode is electrically compatible with 1000Base-X without
> in-band autoneg. Interpret this as you wish.

The comment above comes directly from your patch back in November.
Are you suggesting you aren't happy with your own comment? If you
would like to update it, please let me have a suitable replacement
for it.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
