Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCDF1573869
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbiGMOIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236592AbiGMOIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:08:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59305326E3;
        Wed, 13 Jul 2022 07:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jgdDx9LQsyARI/DRrgkq1Gryik1L6rg1Iq2G8EvXqII=; b=Q4MP47P2aBk15ILq2lkz03Wv4v
        hspWH+jbBBT4knvzmOYxIzyJg/6Y/DOZNlwDMMbBhsRn5AxFYPb9OCStlJmlW4JGM2VFJQh9myao1
        ZBOyjNd1B16O1iBCqFp0yLQTNc7lEa8XaWtKLOy/WmAVEJXKcEg8V2s4vBUDTuyC1R+Wp+20QUH/M
        v/2tV4uzbYWgmd17tcSjOtzGBsNsKwE7qjxAul0i79JNAjj0OG8TM3TQrDdg0EWJuLKZzx8vYtHLL
        /u1yc0shQUsqoNGP3BX+CI1DCI2I6FMQL5BrZM/fTvHwziodoH5cyVoFfszCCeK2WJvZhxOfNjC3I
        pcOzrm2w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37056 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oBd1y-0004bQ-KF; Wed, 13 Jul 2022 15:07:58 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oBd1x-006UD2-T6; Wed, 13 Jul 2022 15:07:57 +0100
In-Reply-To: <Ys7RdzGgHbYiPyB1@shell.armlinux.org.uk>
References: <Ys7RdzGgHbYiPyB1@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Alvin __ipraga" <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: [PATCH RFC net-next v2 4/6] net: dsa: mv88e6xxx: report the default
 interface mode for the port
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oBd1x-006UD2-T6@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 13 Jul 2022 15:07:57 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report the maximum speed interface mode for the port, or if we don't
have that information, the hardware configured interface mode for
the port.

This allows phylink to know which interface mode CPU and DSA ports
are operating, which will be necessary when we want to select the
maximum speed for the port (required for such ports without a PHY or
fixed-link specified in firmware.)

Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 82 +++++++++++++++++++++++---------
 drivers/net/dsa/mv88e6xxx/chip.h |  3 +-
 2 files changed, 61 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f98be98551ef..ccb35ea5d7b0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -578,7 +578,8 @@ static const u8 mv88e6185_phy_interface_modes[] = {
 };
 
 static void mv88e6095_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
-				       struct phylink_config *config)
+				       struct phylink_config *config,
+				       phy_interface_t *default_interface)
 {
 	u8 cmode = chip->ports[port].cmode;
 
@@ -588,23 +589,29 @@ static void mv88e6095_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 		__set_bit(PHY_INTERFACE_MODE_MII, config->supported_interfaces);
 	} else {
 		if (cmode < ARRAY_SIZE(mv88e6185_phy_interface_modes) &&
-		    mv88e6185_phy_interface_modes[cmode])
+		    mv88e6185_phy_interface_modes[cmode]) {
 			__set_bit(mv88e6185_phy_interface_modes[cmode],
 				  config->supported_interfaces);
+			*default_interface =
+				mv88e6185_phy_interface_modes[cmode];
+		}
 
 		config->mac_capabilities |= MAC_1000FD;
 	}
 }
 
 static void mv88e6185_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
-				       struct phylink_config *config)
+				       struct phylink_config *config,
+				       phy_interface_t *default_interface)
 {
 	u8 cmode = chip->ports[port].cmode;
 
 	if (cmode < ARRAY_SIZE(mv88e6185_phy_interface_modes) &&
-	    mv88e6185_phy_interface_modes[cmode])
+	    mv88e6185_phy_interface_modes[cmode]) {
 		__set_bit(mv88e6185_phy_interface_modes[cmode],
 			  config->supported_interfaces);
+		*default_interface = mv88e6185_phy_interface_modes[cmode];
+	}
 
 	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 |
 				   MAC_1000FD;
@@ -616,6 +623,7 @@ static const u8 mv88e6xxx_phy_interface_modes[] = {
 	[MV88E6XXX_PORT_STS_CMODE_GMII]		= PHY_INTERFACE_MODE_GMII,
 	[MV88E6XXX_PORT_STS_CMODE_RMII_PHY]	= PHY_INTERFACE_MODE_RMII,
 	[MV88E6XXX_PORT_STS_CMODE_RMII]		= PHY_INTERFACE_MODE_RMII,
+	[MV88E6XXX_PORT_STS_CMODE_RGMII]	= PHY_INTERFACE_MODE_RGMII,
 	[MV88E6XXX_PORT_STS_CMODE_100BASEX]	= PHY_INTERFACE_MODE_100BASEX,
 	[MV88E6XXX_PORT_STS_CMODE_1000BASEX]	= PHY_INTERFACE_MODE_1000BASEX,
 	[MV88E6XXX_PORT_STS_CMODE_SGMII]	= PHY_INTERFACE_MODE_SGMII,
@@ -625,22 +633,32 @@ static const u8 mv88e6xxx_phy_interface_modes[] = {
 	 */
 };
 
-static void mv88e6xxx_translate_cmode(u8 cmode, unsigned long *supported)
+static void mv88e6xxx_translate_cmode(u8 cmode, unsigned long *supported,
+				      phy_interface_t *default_interface)
 {
+	phy_interface_t interface;
+
 	if (cmode < ARRAY_SIZE(mv88e6xxx_phy_interface_modes) &&
-	    mv88e6xxx_phy_interface_modes[cmode])
-		__set_bit(mv88e6xxx_phy_interface_modes[cmode], supported);
-	else if (cmode == MV88E6XXX_PORT_STS_CMODE_RGMII)
-		phy_interface_set_rgmii(supported);
+	    mv88e6xxx_phy_interface_modes[cmode]) {
+		interface = mv88e6xxx_phy_interface_modes[cmode];
+		if (interface == PHY_INTERFACE_MODE_RGMII)
+			phy_interface_set_rgmii(supported);
+		else
+			__set_bit(interface, supported);
+		if (default_interface)
+			*default_interface = interface;
+	}
 }
 
 static void mv88e6250_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
-				       struct phylink_config *config)
+				       struct phylink_config *config,
+				       phy_interface_t *default_interface)
 {
 	unsigned long *supported = config->supported_interfaces;
 
 	/* Translate the default cmode */
-	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
+	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported,
+				  default_interface);
 
 	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100;
 }
@@ -676,13 +694,15 @@ static int mv88e6352_get_port4_serdes_cmode(struct mv88e6xxx_chip *chip)
 }
 
 static void mv88e6352_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
-				       struct phylink_config *config)
+				       struct phylink_config *config,
+				       phy_interface_t *default_interface)
 {
 	unsigned long *supported = config->supported_interfaces;
 	int err, cmode;
 
 	/* Translate the default cmode */
-	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
+	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported,
+				  default_interface);
 
 	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 |
 				   MAC_1000FD;
@@ -702,19 +722,21 @@ static void mv88e6352_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 			dev_err(chip->dev, "p%d: failed to read serdes cmode\n",
 				port);
 		else
-			mv88e6xxx_translate_cmode(cmode, supported);
+			mv88e6xxx_translate_cmode(cmode, supported, NULL);
 unlock:
 		mv88e6xxx_reg_unlock(chip);
 	}
 }
 
 static void mv88e6341_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
-				       struct phylink_config *config)
+				       struct phylink_config *config,
+				       phy_interface_t *default_interface)
 {
 	unsigned long *supported = config->supported_interfaces;
 
 	/* Translate the default cmode */
-	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
+	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported,
+				  default_interface);
 
 	/* No ethtool bits for 200Mbps */
 	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 |
@@ -726,17 +748,21 @@ static void mv88e6341_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 		__set_bit(PHY_INTERFACE_MODE_1000BASEX, supported);
 		__set_bit(PHY_INTERFACE_MODE_2500BASEX, supported);
 
+		*default_interface = PHY_INTERFACE_MODE_2500BASEX;
+
 		config->mac_capabilities |= MAC_2500FD;
 	}
 }
 
 static void mv88e6390_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
-				       struct phylink_config *config)
+				       struct phylink_config *config,
+				       phy_interface_t *default_interface)
 {
 	unsigned long *supported = config->supported_interfaces;
 
 	/* Translate the default cmode */
-	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
+	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported,
+				  default_interface);
 
 	/* No ethtool bits for 200Mbps */
 	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 |
@@ -748,16 +774,19 @@ static void mv88e6390_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 		__set_bit(PHY_INTERFACE_MODE_1000BASEX, supported);
 		__set_bit(PHY_INTERFACE_MODE_2500BASEX, supported);
 
+		*default_interface = PHY_INTERFACE_MODE_2500BASEX;
+
 		config->mac_capabilities |= MAC_2500FD;
 	}
 }
 
 static void mv88e6390x_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
-					struct phylink_config *config)
+					struct phylink_config *config,
+					phy_interface_t *default_interface)
 {
 	unsigned long *supported = config->supported_interfaces;
 
-	mv88e6390_phylink_get_caps(chip, port, config);
+	mv88e6390_phylink_get_caps(chip, port, config, default_interface);
 
 	/* For the 6x90X, ports 2-7 can be in automedia mode.
 	 * (Note that 6x90 doesn't support RXAUI nor XAUI).
@@ -783,18 +812,22 @@ static void mv88e6390x_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 		__set_bit(PHY_INTERFACE_MODE_XAUI, supported);
 		__set_bit(PHY_INTERFACE_MODE_RXAUI, supported);
 
+		*default_interface = PHY_INTERFACE_MODE_XAUI;
+
 		config->mac_capabilities |= MAC_10000FD;
 	}
 }
 
 static void mv88e6393x_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
-					struct phylink_config *config)
+					struct phylink_config *config,
+					phy_interface_t *default_interface)
 {
 	unsigned long *supported = config->supported_interfaces;
 	bool is_6191x =
 		chip->info->prod_num == MV88E6XXX_PORT_SWITCH_ID_PROD_6191X;
 
-	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
+	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported,
+				  default_interface);
 
 	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 |
 				   MAC_1000FD;
@@ -812,6 +845,8 @@ static void mv88e6393x_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 			/* FIXME: USXGMII is not supported yet */
 			/* __set_bit(PHY_INTERFACE_MODE_USXGMII, supported); */
 
+			*default_interface = PHY_INTERFACE_MODE_10GBASER;
+
 			config->mac_capabilities |= MAC_2500FD | MAC_5000FD |
 				MAC_10000FD;
 		}
@@ -824,7 +859,8 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
-	chip->info->ops->phylink_get_caps(chip, port, config);
+	chip->info->ops->phylink_get_caps(chip, port, config,
+					  default_interface);
 
 	/* Internal ports need GMII for PHYLIB */
 	if (mv88e6xxx_phy_is_internal(ds, port))
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e693154cf803..4518c17c1b9b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -643,7 +643,8 @@ struct mv88e6xxx_ops {
 
 	/* Phylink */
 	void (*phylink_get_caps)(struct mv88e6xxx_chip *chip, int port,
-				 struct phylink_config *config);
+				 struct phylink_config *config,
+				 phy_interface_t *default_interface);
 
 	/* Max Frame Size */
 	int (*set_max_frame_size)(struct mv88e6xxx_chip *chip, int mtu);
-- 
2.30.2

