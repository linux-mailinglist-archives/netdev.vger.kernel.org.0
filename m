Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371374685B4
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 15:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbhLDOqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 09:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbhLDOqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 09:46:20 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2BCC061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 06:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bs2psogHgYpkReWj90tylFnAHnsy7Ee86MAwjjU6XRU=; b=IWYQnRh0eF+1I0t9WlnTF8W7Lr
        CvVMeorCLlO/Wpz0eVbOla0KC84L6N7/Y0pKh0ne2XGe9FDvtJb5/N1CDXQXDEgjF0o8GxfRBgvm9
        XYK80yLNUjGCDTU3VoKtrAzjbxAXjyHaoXZuadkKVAGQwtEUxzFrwFpUyo8Q73R6KeLyAtxPHLnhP
        2smPTAys1yjY+sukNBKfE3aTIvC1HnYWNSbmPCXAcUYujLrYUxR/QE1HzB9LxQ36nqDEx2tEUyOOf
        RF1mO+kGV4Irz91f/V2gz4TFrEBT3EAU54c4f4DG+y9qfRqGsmo3Y3bOsUmSYJwQQHUTm4iZR71JR
        DaOpgrTQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56060)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mtWFP-0003LX-QB; Sat, 04 Dec 2021 14:42:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mtWFM-0002V5-Kz; Sat, 04 Dec 2021 14:42:40 +0000
Date:   Sat, 4 Dec 2021 14:42:40 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH RFC net-next 05/12] net: dsa: bcm_sf2: convert to
 phylink_generic_validate()
Message-ID: <Yat+YKhx9E5Xyad4@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRs-00D8LK-N3@rmk-PC.armlinux.org.uk>
 <6ef4f764-cd91-91bd-e921-407e9d198179@gmail.com>
 <3b3fed98-0c82-99e9-dc72-09fe01c2bcf3@gmail.com>
 <Yast4PrQGGLxDrCy@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yast4PrQGGLxDrCy@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 04, 2021 at 08:59:12AM +0000, Russell King (Oracle) wrote:
> On Fri, Dec 03, 2021 at 08:18:22PM -0800, Florian Fainelli wrote:
> > On 12/3/21 12:03 PM, Florian Fainelli wrote:
> > > On 11/24/21 9:52 AM, Russell King (Oracle) wrote:
> > > > Populate the supported interfaces and MAC capabilities for the bcm_sf2
> > > > DSA switch and remove the old validate implementation to allow DSA to
> > > > use phylink_generic_validate() for this switch driver.
> > > > 
> > > > The exclusion of Gigabit linkmodes for MII and Reverse MII links is
> > > > handled within phylink_generic_validate() in phylink, so there is no
> > > > need to make them conditional on the interface mode in the driver.
> > > > 
> > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > 
> > > Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> > > 
> > > but it looks like the fixed link ports are reporting some pretty strange
> > > advertisement values one of my two platforms running the same kernel image:
> > 
> > We would want to amend your patch with something that caters a bit more
> > towards how the ports have been configured:
> > 
> > diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> > index d6ef0fb0d943..88933c3feddd 100644
> > --- a/drivers/net/dsa/bcm_sf2.c
> > +++ b/drivers/net/dsa/bcm_sf2.c
> > @@ -675,12 +675,18 @@ static u32 bcm_sf2_sw_get_phy_flags(struct
> > dsa_switch *ds, int port)
> >  static void bcm_sf2_sw_get_caps(struct dsa_switch *ds, int port,
> >                                 struct phylink_config *config)
> >  {
> > -       __set_bit(PHY_INTERFACE_MODE_MII, config->supported_interfaces);
> > -       __set_bit(PHY_INTERFACE_MODE_REVMII, config->supported_interfaces);
> > -       __set_bit(PHY_INTERFACE_MODE_GMII, config->supported_interfaces);
> > -       __set_bit(PHY_INTERFACE_MODE_INTERNAL,
> > config->supported_interfaces);
> > -       __set_bit(PHY_INTERFACE_MODE_MOCA, config->supported_interfaces);
> > -       phy_interface_set_rgmii(config->supported_interfaces);
> > +       struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
> > +
> > +       if (priv->int_phy_mask & BIT(port))
> > +               __set_bit(PHY_INTERFACE_MODE_INTERNAL,
> > config->supported_interfaces);
> > +       else if (priv->moca_port == port)
> > +               __set_bit(PHY_INTERFACE_MODE_MOCA,
> > config->supported_interfaces);
> > +       else {
> > +               __set_bit(PHY_INTERFACE_MODE_MII,
> > config->supported_interfaces);
> > +               __set_bit(PHY_INTERFACE_MODE_REVMII,
> > config->supported_interfaces);
> > +               __set_bit(PHY_INTERFACE_MODE_GMII,
> > config->supported_interfaces);
> > +               phy_interface_set_rgmii(config->supported_interfaces);
> > +       }
> > 
> >         config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
> >                 MAC_10 | MAC_100 | MAC_1000;
> 
> That's fine, thanks for the update.

Here's the resulting updated patch. I've changed it slightly to avoid
the wrapping, and updated the commit text - please let me know if you'd
like any attributations added. Thanks!

8<===
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH RFC v2 net-next] net: dsa: bcm_sf2: convert to
 phylink_generic_validate()

Populate the supported interfaces and MAC capabilities for the bcm_sf2
DSA switch and remove the old validate implementation to allow DSA to
use phylink_generic_validate() for this switch driver.

The exclusion of Gigabit linkmodes for MII and Reverse MII links is
handled within phylink_generic_validate() in phylink, so there is no
need to make them conditional on the interface mode in the driver.

Thanks to Florian Fainelli for suggesting how to populate the supported
interfaces.

Link: https://lore.kernel.org/r/3b3fed98-0c82-99e9-dc72-09fe01c2bcf3@gmail.com
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/bcm_sf2.c | 54 +++++++++++----------------------------
 1 file changed, 15 insertions(+), 39 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 13aa43b5cffd..114d4ba7716f 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -672,49 +672,25 @@ static u32 bcm_sf2_sw_get_phy_flags(struct dsa_switch *ds, int port)
 		       PHY_BRCM_IDDQ_SUSPEND;
 }
 
-static void bcm_sf2_sw_validate(struct dsa_switch *ds, int port,
-				unsigned long *supported,
-				struct phylink_link_state *state)
+static void bcm_sf2_sw_get_caps(struct dsa_switch *ds, int port,
+				struct phylink_config *config)
 {
+	unsigned long *interfaces = config->supported_interfaces;
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-
-	if (!phy_interface_mode_is_rgmii(state->interface) &&
-	    state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_REVMII &&
-	    state->interface != PHY_INTERFACE_MODE_GMII &&
-	    state->interface != PHY_INTERFACE_MODE_INTERNAL &&
-	    state->interface != PHY_INTERFACE_MODE_MOCA) {
-		linkmode_zero(supported);
-		if (port != core_readl(priv, CORE_IMP0_PRT_ID))
-			dev_err(ds->dev,
-				"Unsupported interface: %d for port %d\n",
-				state->interface, port);
-		return;
-	}
-
-	/* Allow all the expected bits */
-	phylink_set(mask, Autoneg);
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
 
-	/* With the exclusion of MII and Reverse MII, we support Gigabit,
-	 * including Half duplex
-	 */
-	if (state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_REVMII) {
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseT_Half);
+	if (priv->int_phy_mask & BIT(port)) {
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL, interfaces);
+	} else if (priv->moca_port == port) {
+		__set_bit(PHY_INTERFACE_MODE_MOCA, interfaces);
+	} else {
+		__set_bit(PHY_INTERFACE_MODE_MII, interfaces);
+		__set_bit(PHY_INTERFACE_MODE_REVMII, interfaces);
+		__set_bit(PHY_INTERFACE_MODE_GMII, interfaces);
+		phy_interface_set_rgmii(interfaces);
 	}
 
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
+	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+		MAC_10 | MAC_100 | MAC_1000;
 }
 
 static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
@@ -1181,7 +1157,7 @@ static const struct dsa_switch_ops bcm_sf2_ops = {
 	.get_sset_count		= bcm_sf2_sw_get_sset_count,
 	.get_ethtool_phy_stats	= b53_get_ethtool_phy_stats,
 	.get_phy_flags		= bcm_sf2_sw_get_phy_flags,
-	.phylink_validate	= bcm_sf2_sw_validate,
+	.phylink_get_caps	= bcm_sf2_sw_get_caps,
 	.phylink_mac_config	= bcm_sf2_sw_mac_config,
 	.phylink_mac_link_down	= bcm_sf2_sw_mac_link_down,
 	.phylink_mac_link_up	= bcm_sf2_sw_mac_link_up,
-- 
2.30.2

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
