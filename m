Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA8C57386B
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbiGMOJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236509AbiGMOIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:08:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0757532442;
        Wed, 13 Jul 2022 07:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JBGLL8+01TkLvqvp9hs2J1XBXDqP2UWt2/BalFs9+uU=; b=f4yFdKm5MZCrE7+JTmgOEmwX44
        y3RKeFL8l61Y//MDX3rYFuxnhTrUWL/sqxMCfy354xAcEa4HzO/eYUpaK83Xle0s9XT2vGNQdpb8Q
        BmGGSjfOMYfLufKr6GoX2l8XoEet8zSHQKVbzTAPfpAMaPbqpUDKYLUMPyOcYJYY3HPn3eY0VzJD5
        dIKFHSPltsxbbISzGZG7Yzi11iZJXqOXBA3N8SAbbdwL/98xZPWqz+kSlUWU5/YdO3FNn7Ji+Efjv
        ELcCuvfMBZpAMxK3/YSd+YCptzQWqtgnbaw1ZTNYiMvjz7AAXzGxWcJzr7DEFB3P6z8F4cplNl0DO
        z5T+rcbw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37058 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oBd23-0004br-Pi; Wed, 13 Jul 2022 15:08:03 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oBd23-006UD8-1d; Wed, 13 Jul 2022 15:08:03 +0100
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
Subject: [PATCH RFC net-next v2 5/6] net: dsa: create swnode fixed-link if
 using default params
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oBd23-006UD8-1d@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 13 Jul 2022 15:08:03 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create and use a swnode fixed-link specification for phylink if no
parameters are given in DT for a fixed-link. This allows phylink to
be used for "default" cases for DSA and CPU ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 net/dsa/port.c | 152 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 139 insertions(+), 13 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 35b4e1f8dc05..abcf7899abf8 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1521,10 +1521,131 @@ static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 	.mac_link_up = dsa_port_phylink_mac_link_up,
 };
 
+static struct {
+	unsigned long mask;
+	int speed;
+	int duplex;
+} phylink_caps_params[] = {
+	{ MAC_400000FD, SPEED_400000, DUPLEX_FULL },
+	{ MAC_200000FD, SPEED_200000, DUPLEX_FULL },
+	{ MAC_100000FD, SPEED_100000, DUPLEX_FULL },
+	{ MAC_56000FD,  SPEED_56000,  DUPLEX_FULL },
+	{ MAC_50000FD,  SPEED_50000,  DUPLEX_FULL },
+	{ MAC_40000FD,  SPEED_40000,  DUPLEX_FULL },
+	{ MAC_25000FD,  SPEED_25000,  DUPLEX_FULL },
+	{ MAC_20000FD,  SPEED_20000,  DUPLEX_FULL },
+	{ MAC_10000FD,  SPEED_10000,  DUPLEX_FULL },
+	{ MAC_5000FD,   SPEED_5000,   DUPLEX_FULL },
+	{ MAC_2500FD,   SPEED_2500,   DUPLEX_FULL },
+	{ MAC_1000FD,   SPEED_1000,   DUPLEX_FULL },
+	{ MAC_100FD,    SPEED_100,    DUPLEX_FULL },
+	{ MAC_10FD,     SPEED_10,     DUPLEX_FULL },
+	{ MAC_1000HD,   SPEED_1000,   DUPLEX_HALF },
+	{ MAC_100HD,    SPEED_100,    DUPLEX_HALF },
+	{ MAC_10HD,     SPEED_10,     DUPLEX_HALF },
+};
+
+static int dsa_port_find_max_speed(unsigned long caps, int *speed, int *duplex)
+{
+	int i;
+
+	*speed = SPEED_UNKNOWN;
+	*duplex = DUPLEX_UNKNOWN;
+
+	for (i = 0; i < ARRAY_SIZE(phylink_caps_params); i++) {
+		if (caps & phylink_caps_params[i].mask) {
+			*speed = phylink_caps_params[i].speed;
+			*duplex = phylink_caps_params[i].duplex;
+			break;
+		}
+	}
+
+	return *speed == SPEED_UNKNOWN ? -EINVAL : 0;
+}
+
+static void dsa_port_find_max_caps(struct dsa_port *dp,
+				   phy_interface_t *max_interface,
+				   unsigned long *max_caps)
+{
+	struct phylink_config *config = &dp->pl_config;
+	phy_interface_t interface;
+	unsigned long caps;
+
+	*max_interface = PHY_INTERFACE_MODE_NA;
+	*max_caps = 0;
+
+	for_each_set_bit(interface, config->supported_interfaces,
+			 PHY_INTERFACE_MODE_MAX) {
+		caps = config->mac_capabilities &
+		       phylink_interface_to_caps(interface);
+		if (caps > *max_caps) {
+			*max_caps = caps;
+			*max_interface = interface;
+		}
+	}
+}
+
+static struct fwnode_handle *dsa_port_get_fwnode(struct dsa_port *dp,
+						 phy_interface_t mode)
+{
+	struct property_entry fixed_link_props[3] = { };
+	struct property_entry port_props[3] = {};
+	struct fwnode_handle *fixed_link_fwnode;
+	struct fwnode_handle *new_port_fwnode;
+	struct device_node *dn = dp->dn;
+	struct device_node *phy_node;
+	int err, speed, duplex;
+	unsigned long caps;
+
+	phy_node = of_parse_phandle(dn, "phy-handle", 0);
+	of_node_put(phy_node);
+	if (phy_node || of_phy_is_fixed_link(dn))
+		/* Nothing broken, nothing to fix.
+		 * TODO: As discussed with Russell, maybe phylink could provide
+		 * a more comprehensive helper to determine what constitutes a
+		 * valid fwnode binding than this guerilla kludge.
+		 */
+		return of_fwnode_handle(dn);
+
+	if (mode == PHY_INTERFACE_MODE_NA)
+		dsa_port_find_max_caps(dp, &mode, &caps);
+	else
+		caps = dp->pl_config.mac_capabilities &
+		       phylink_interface_to_caps(mode);
+
+	err = dsa_port_find_max_speed(caps, &speed, &duplex);
+	if (err)
+		return ERR_PTR(err);
+
+	fixed_link_props[0] = PROPERTY_ENTRY_U32("speed", speed);
+	if (duplex == DUPLEX_FULL)
+		fixed_link_props[1] = PROPERTY_ENTRY_BOOL("full-duplex");
+
+	port_props[0] = PROPERTY_ENTRY_STRING("phy-mode", phy_modes(mode));
+
+	new_port_fwnode = fwnode_create_software_node(port_props, NULL);
+	if (IS_ERR(new_port_fwnode))
+		return new_port_fwnode;
+
+	/* Node needs to be named so that phylink's call to
+	 * fwnode_get_named_child_node() finds it.
+	 */
+	fixed_link_fwnode = fwnode_create_named_software_node(fixed_link_props,
+							      new_port_fwnode,
+							      "fixed-link");
+	if (IS_ERR(fixed_link_fwnode)) {
+		fwnode_remove_software_node(new_port_fwnode);
+		return fixed_link_fwnode;
+	}
+
+	return new_port_fwnode;
+}
+
 int dsa_port_phylink_create(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	phy_interface_t mode, def_mode;
+	struct fwnode_handle *fwnode;
 	int err;
 
 	/* Presence of phylink_mac_link_state or phylink_mac_an_restart is
@@ -1552,8 +1673,19 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 			mode = PHY_INTERFACE_MODE_NA;
 	}
 
-	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
-				mode, &dsa_port_phylink_mac_ops);
+	fwnode = dsa_port_get_fwnode(dp, mode);
+	if (IS_ERR(fwnode)) {
+		dev_err(ds->dev,
+			"Failed to get fwnode for port %d: %pe\n",
+			dp->index, fwnode);
+		return PTR_ERR(fwnode);
+	}
+
+	dp->pl = phylink_create(&dp->pl_config, fwnode, mode,
+				&dsa_port_phylink_mac_ops);
+
+	fwnode_remove_software_node(fwnode);
+
 	if (IS_ERR(dp->pl)) {
 		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
 		return PTR_ERR(dp->pl);
@@ -1663,20 +1795,14 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 int dsa_port_link_register_of(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
-	struct device_node *phy_np;
 	int port = dp->index;
 
 	if (!ds->ops->adjust_link) {
-		phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
-		if (of_phy_is_fixed_link(dp->dn) || phy_np) {
-			if (ds->ops->phylink_mac_link_down)
-				ds->ops->phylink_mac_link_down(ds, port,
-					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
-			of_node_put(phy_np);
-			return dsa_port_phylink_register(dp);
-		}
-		of_node_put(phy_np);
-		return 0;
+		if (ds->ops->phylink_mac_link_down)
+			ds->ops->phylink_mac_link_down(ds, port, MLO_AN_FIXED,
+						       PHY_INTERFACE_MODE_NA);
+
+		return dsa_port_phylink_register(dp);
 	}
 
 	dev_warn(ds->dev,
-- 
2.30.2

