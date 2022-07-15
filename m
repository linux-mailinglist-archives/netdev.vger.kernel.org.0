Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC029576506
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 18:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbiGOQCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 12:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbiGOQCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 12:02:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC4874DCD;
        Fri, 15 Jul 2022 09:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ee0S/L/lAaawjhGQkdBJydNVbnF4FxpHz5nSk4/ecXA=; b=sl1F19CLN6rb7NOrnwdMLwMK/g
        GAngKGXU0eid+AVplNeyYiLz50q6npmcJqExM0vFLK9fXEWfPTNr0RDJptioQ11st5Rv9VUJdbDYI
        vL3tm9Gy5H2C1gbKLE4qIQ8Xsl5WQ/XjdIn70kORSmS1Bo4zcMYVYqpqCSVPLKYneFGqpbW9ke1u4
        qhby2li7dYpgXSFiQTZrvIffZtd/cPm0pwxvaAXDfAEnFddcHmUtwn4Y1ALKdvAxZJvyxt0a99X4q
        v5aDgiICHVjRpQpIZTMKx8eZBj1pEXDG5Muosc3v1Sr8IDlo+vPFEBaeeacnWeWyYArjb7H/hR3Wp
        19/3RMcA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46056 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oCNlK-0007EM-1h; Fri, 15 Jul 2022 17:01:54 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oCNlJ-006e45-8V; Fri, 15 Jul 2022 17:01:53 +0100
In-Reply-To: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
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
Subject: [PATCH net-next 6/6] net: dsa: mv88e6xxx: remove handling for DSA and
 CPU ports
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oCNlJ-006e45-8V@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 15 Jul 2022 17:01:53 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we now always use a fixed-link for DSA and CPU ports, we no longer
need the hack in the Marvell code to make this work. Remove it.

This is especially important with the conversion of DSA drivers to
phylink_pcs, as the PCS code only gets called if we are using
phylink for the port.

Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 49 +++-----------------------------
 drivers/net/dsa/mv88e6xxx/chip.h |  3 --
 drivers/net/dsa/mv88e6xxx/port.c | 32 ---------------------
 drivers/net/dsa/mv88e6xxx/port.h |  5 ----
 4 files changed, 4 insertions(+), 85 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index ccb35ea5d7b0..01dff8d46642 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3314,9 +3314,8 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
 	struct device_node *phy_handle = NULL;
 	struct dsa_switch *ds = chip->ds;
-	phy_interface_t mode;
 	struct dsa_port *dp;
-	int tx_amp, speed;
+	int tx_amp;
 	int err;
 	u16 reg;
 
@@ -3325,40 +3324,9 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 
 	dp = dsa_to_port(ds, port);
 
-	/* MAC Forcing register: don't force link, speed, duplex or flow control
-	 * state to any particular values on physical ports, but force the CPU
-	 * port and all DSA ports to their maximum bandwidth and full duplex.
-	 */
-	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port)) {
-		unsigned long caps = dp->pl_config.mac_capabilities;
-
-		if (chip->info->ops->port_max_speed_mode)
-			mode = chip->info->ops->port_max_speed_mode(port);
-		else
-			mode = PHY_INTERFACE_MODE_NA;
-
-		if (caps & MAC_10000FD)
-			speed = SPEED_10000;
-		else if (caps & MAC_5000FD)
-			speed = SPEED_5000;
-		else if (caps & MAC_2500FD)
-			speed = SPEED_2500;
-		else if (caps & MAC_1000)
-			speed = SPEED_1000;
-		else if (caps & MAC_100)
-			speed = SPEED_100;
-		else
-			speed = SPEED_10;
-
-		err = mv88e6xxx_port_setup_mac(chip, port, LINK_FORCED_UP,
-					       speed, DUPLEX_FULL,
-					       PAUSE_OFF, mode);
-	} else {
-		err = mv88e6xxx_port_setup_mac(chip, port, LINK_UNFORCED,
-					       SPEED_UNFORCED, DUPLEX_UNFORCED,
-					       PAUSE_ON,
-					       PHY_INTERFACE_MODE_NA);
-	}
+	err = mv88e6xxx_port_setup_mac(chip, port, LINK_UNFORCED,
+				       SPEED_UNFORCED, DUPLEX_UNFORCED,
+				       PAUSE_ON, PHY_INTERFACE_MODE_NA);
 	if (err)
 		return err;
 
@@ -4306,7 +4274,6 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex = mv88e6341_port_set_speed_duplex,
-	.port_max_speed_mode = mv88e6341_port_max_speed_mode,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
@@ -4699,7 +4666,6 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex = mv88e6390_port_set_speed_duplex,
-	.port_max_speed_mode = mv88e6390_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
@@ -4762,7 +4728,6 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex = mv88e6390x_port_set_speed_duplex,
-	.port_max_speed_mode = mv88e6390x_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
@@ -4825,7 +4790,6 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex = mv88e6390_port_set_speed_duplex,
-	.port_max_speed_mode = mv88e6390_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
@@ -4990,7 +4954,6 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex = mv88e6390_port_set_speed_duplex,
-	.port_max_speed_mode = mv88e6390_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
@@ -5141,7 +5104,6 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex = mv88e6341_port_set_speed_duplex,
-	.port_max_speed_mode = mv88e6341_port_max_speed_mode,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
@@ -5364,7 +5326,6 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex = mv88e6390_port_set_speed_duplex,
-	.port_max_speed_mode = mv88e6390_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
@@ -5431,7 +5392,6 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex = mv88e6390x_port_set_speed_duplex,
-	.port_max_speed_mode = mv88e6390x_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
@@ -5497,7 +5457,6 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex = mv88e6393x_port_set_speed_duplex,
-	.port_max_speed_mode = mv88e6393x_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_policy = mv88e6393x_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 4518c17c1b9b..a3b7cfe3eb23 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -502,9 +502,6 @@ struct mv88e6xxx_ops {
 	int (*port_set_speed_duplex)(struct mv88e6xxx_chip *chip, int port,
 				     int speed, int duplex);
 
-	/* What interface mode should be used for maximum speed? */
-	phy_interface_t (*port_max_speed_mode)(int port);
-
 	int (*port_tag_remap)(struct mv88e6xxx_chip *chip, int port);
 
 	int (*port_set_policy)(struct mv88e6xxx_chip *chip, int port,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 90c55f23b7c9..47e21f3c437a 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -333,14 +333,6 @@ int mv88e6341_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 					       duplex);
 }
 
-phy_interface_t mv88e6341_port_max_speed_mode(int port)
-{
-	if (port == 5)
-		return PHY_INTERFACE_MODE_2500BASEX;
-
-	return PHY_INTERFACE_MODE_NA;
-}
-
 /* Support 10, 100, 200, 1000 Mbps (e.g. 88E6352 family) */
 int mv88e6352_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				    int speed, int duplex)
@@ -372,14 +364,6 @@ int mv88e6390_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 					       duplex);
 }
 
-phy_interface_t mv88e6390_port_max_speed_mode(int port)
-{
-	if (port == 9 || port == 10)
-		return PHY_INTERFACE_MODE_2500BASEX;
-
-	return PHY_INTERFACE_MODE_NA;
-}
-
 /* Support 10, 100, 200, 1000, 2500, 10000 Mbps (e.g. 88E6190X) */
 int mv88e6390x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				     int speed, int duplex)
@@ -394,14 +378,6 @@ int mv88e6390x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 					       duplex);
 }
 
-phy_interface_t mv88e6390x_port_max_speed_mode(int port)
-{
-	if (port == 9 || port == 10)
-		return PHY_INTERFACE_MODE_XAUI;
-
-	return PHY_INTERFACE_MODE_NA;
-}
-
 /* Support 10, 100, 200, 1000, 2500, 5000, 10000 Mbps (e.g. 88E6393X)
  * Function mv88e6xxx_port_set_speed_duplex() can't be used as the register
  * values for speeds 2500 & 5000 conflict.
@@ -491,14 +467,6 @@ int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 	return 0;
 }
 
-phy_interface_t mv88e6393x_port_max_speed_mode(int port)
-{
-	if (port == 0 || port == 9 || port == 10)
-		return PHY_INTERFACE_MODE_10GBASER;
-
-	return PHY_INTERFACE_MODE_NA;
-}
-
 static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 				    phy_interface_t mode, bool force)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index cb04243f37c1..2a5741a44e97 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -357,11 +357,6 @@ int mv88e6390x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				     int speed, int duplex);
 
-phy_interface_t mv88e6341_port_max_speed_mode(int port);
-phy_interface_t mv88e6390_port_max_speed_mode(int port);
-phy_interface_t mv88e6390x_port_max_speed_mode(int port);
-phy_interface_t mv88e6393x_port_max_speed_mode(int port);
-
 int mv88e6xxx_port_set_state(struct mv88e6xxx_chip *chip, int port, u8 state);
 
 int mv88e6xxx_port_set_vlan_map(struct mv88e6xxx_chip *chip, int port, u16 map);
-- 
2.30.2

