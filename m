Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E805F2467AF
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 15:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbgHQNtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 09:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbgHQNtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 09:49:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F39C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 06:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hc3Ug4LQZtcNmMWpEtTqZR+F5+XiWumB7xo0GKaBR4o=; b=Tc6NjR2z5NXhllSoqvyxS5m0X
        n9RrUYEra+iSJqbg+XFcxV2iUU5Oxx4ecs/kmu9MqF+Jr0q2KKVlp0T13+SonrMVLXDOqKqoGqldc
        ig76AiZg3NLrj0XLXxcpV3uDuwZu9DLqvEGGRJcGWVw6Pb8WvfnYDFJlpOoL5av1D2S9ShDvDYCaN
        KRbqZNmi3mxYAb9Hhvlw70DjrGDhWJkHlDBzN8IO8yTr4Ge4jTfiHouEtJ5kHq8z6gB+HjvwChK2M
        62RxVx9T6ejnNjcaaDI0nLtautFwESEvQSGwOnX1inv/CGkOck5rgoMGzPsqmBzlaem0hq33hi0UB
        BFRmLgyNw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53660)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k7fVe-0007Gc-VM; Mon, 17 Aug 2020 14:49:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k7fVd-0000SE-C5; Mon, 17 Aug 2020 14:49:09 +0100
Date:   Mon, 17 Aug 2020 14:49:09 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 0/4] Support for RollBall 10G copper SFP
 modules
Message-ID: <20200817134909.GY1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200810220645.19326-1-marek.behun@nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 12:06:41AM +0200, Marek Behún wrote:
> Hi Russell,
> 
> this series should apply on linux-arm git repository, on branch
> clearfog.

How about something like this - only build tested, and you may
encounter fuzz with this:

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 147b4cf4188e..bcbef68e0917 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -117,6 +117,7 @@ enum {
 	MV_V2_PORT_CTRL_FT_1000BASEX = 0 << 3,
 	MV_V2_PORT_CTRL_FT_SGMII = 1 << 3,
 	MV_V2_PORT_CTRL_FT_10GBASER = 3 << 3,
+	MV_V2_PORT_CTRL_MACTYPE	= 7 << 0,
 	MV_V2_UIS		= 0xf040,
 	MV_V2_PIS		= 0xf042,
 	MV_V2_PIS_PI		= BIT(0),
@@ -691,17 +692,44 @@ static bool mv3310_has_pma_ngbaset_quirk(struct phy_device *phydev)
 		MV_PHY_ALASKA_NBT_QUIRK_MASK) == MV_PHY_ALASKA_NBT_QUIRK_REV;
 }
 
+static int mv3310_select_mode(struct phy_device *phydev,
+			      unsigned long *host_interfaces)
+{
+	int mac_type = -1;
+
+	if (test_bit(PHY_INTERFACE_MODE_USXGMII, host_interfaces))
+		mac_type = 7;
+	else if (test_bit(PHY_INTERFACE_MODE_SGMII, host_interfaces) &&
+		 test_bit(PHY_INTERFACE_MODE_10GBASER, host_interfaces))
+		mac_type = 4;
+	else if (test_bit(PHY_INTERFACE_MODE_SGMII, host_interfaces) &&
+		 test_bit(PHY_INTERFACE_MODE_RXAUI, host_interfaces))
+		mac_type = 0;
+	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, host_interfaces))
+		mac_type = 6;
+	else if (test_bit(PHY_INTERFACE_MODE_RXAUI, host_interfaces))
+		mac_type = 2;
+	else if (test_bit(PHY_INTERFACE_MODE_SGMII, host_interfaces))
+		mac_type = 4;
+
+	return mac_type;
+}
+
 static int mv3310_config_init(struct phy_device *phydev)
 {
-	int err;
+	int ret, err, mac_type = -1;
 
 	/* Check that the PHY interface type is compatible */
-	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
-	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
-	    phydev->interface != PHY_INTERFACE_MODE_XAUI &&
-	    phydev->interface != PHY_INTERFACE_MODE_RXAUI &&
-	    phydev->interface != PHY_INTERFACE_MODE_10GBASER)
+	if (!phy_interface_empty(phydev->host_interfaces)) {
+		mac_type = mv3310_select_mode(phydev, phydev->host_interfaces);
+		phydev_info(phydev, "mac_type=%d\n", mac_type);
+	} else if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
+		   phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
+		   phydev->interface != PHY_INTERFACE_MODE_XAUI &&
+		   phydev->interface != PHY_INTERFACE_MODE_RXAUI &&
+		   phydev->interface != PHY_INTERFACE_MODE_10GBASER) {
 		return -ENODEV;
+	}
 
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
 
@@ -710,6 +738,20 @@ static int mv3310_config_init(struct phy_device *phydev)
 	if (err)
 		return err;
 
+	if (mac_type != -1) {
+		ret = phy_modify_mmd_changed(phydev, MDIO_MMD_VEND2,
+					     MV_V2_PORT_CTRL,
+					     MV_V2_PORT_CTRL_MACTYPE, mac_type);
+		if (ret > 0)
+			ret = phy_modify_mmd(phydev, MDIO_MMD_VEND2,
+					     MV_V2_PORT_CTRL,
+					     MV_V2_PORT_CTRL_SWRST,
+					     MV_V2_PORT_CTRL_SWRST);
+
+		if (ret < 0)
+			return ret;
+	}
+
 	/* Enable EDPD mode - saving 600mW */
 	err = mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
 	if (err)
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5785eb040f11..4ad64973432a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2082,6 +2082,8 @@ static void phylink_sfp_detach(void *upstream, struct sfp_bus *bus)
 	sfp_bus_unlink_netdev(bus, pl->netdev);
 }
 
+static DECLARE_PHY_INTERFACE_MASK(phylink_sfp_interfaces);
+
 static const phy_interface_t phylink_sfp_interface_preference[] = {
 	PHY_INTERFACE_MODE_USXGMII,
 	PHY_INTERFACE_MODE_10GBASER,
@@ -2091,6 +2093,18 @@ static const phy_interface_t phylink_sfp_interface_preference[] = {
 	PHY_INTERFACE_MODE_1000BASEX,
 };
 
+static int __init phylink_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(phylink_sfp_interface_preference); i++)
+		set_bit(phylink_sfp_interface_preference[i],
+			phylink_sfp_interfaces);
+
+	return 0;
+}
+module_init(phylink_init);
+
 static phy_interface_t phylink_select_interface(struct phylink *pl,
 						const unsigned long *intf,
 						const char *intf_name)
@@ -2342,6 +2356,10 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 	else
 		mode = MLO_AN_INBAND;
 
+	/* Set the PHY's host supported interfaces */
+	phy_interface_and(phy->host_interfaces, phylink_sfp_interfaces,
+			  pl->config->supported_interfaces);
+
 	if (!phy_interface_empty(phy->supported_interfaces) &&
 	    !phy_interface_empty(pl->config->supported_interfaces)) {
 		interface = phylink_select_interface(pl,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 7408e2240c1e..14f73378f4e9 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -527,6 +527,7 @@ struct phy_device {
 
 	/* bitmap of supported interfaces */
 	DECLARE_PHY_INTERFACE_MASK(supported_interfaces);
+	DECLARE_PHY_INTERFACE_MASK(host_interfaces);
 
 	/* Energy efficient ethernet modes which should be prohibited */
 	u32 eee_broken_modes;

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
