Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2DC6C49D0
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 13:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjCVMAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 08:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbjCVMAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 08:00:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98A25D263;
        Wed, 22 Mar 2023 05:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KJBQQ1PBt+CBAtmD4WG9aowdjIwjYCP4sx9s51U3L4c=; b=sd1grvSW0dLEvw8ZmoyTQtJEDR
        B2ZqpDjJLoFiVreCelFX+Rhu/sS3QPIlFEL/AR+aWGV0Vo9LSQT+KTNDH+oHU/elG3uV2Xd6oL2Dz
        VnZDLkYQAT5gqU6lt6VHb/HQcKMNaqIxbs0Lm9VAGOw22jSp7BYNWT/UWqkN3yojHOmQZhzxVVjcb
        fgTCcFjANA/siJ0/wnEYuxU9nSY627Dv6Yn0hkf5AIDMIRcYIVTZTsYJVCVOFgkoinGL4yMsEAX6g
        Zt1nZ+tetY450w9ntKZd3MA5lg23yr/LfRxUsPe7XpfvD6ENbJd9QYrHNH3Iji8RxIwV545TRX6pC
        SzH/mB0Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45536 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pex8g-00036s-Ac; Wed, 22 Mar 2023 12:00:22 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pex8f-00Dvo9-KT; Wed, 22 Mar 2023 12:00:21 +0000
In-Reply-To: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RFC net-next 6/7] net: dsa: mv88e6xxx: provide software node
 for default settings
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pex8f-00Dvo9-KT@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 22 Mar 2023 12:00:21 +0000
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a software node for default settings when no phy, sfp or
fixed link is specified.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 109 +++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b73d1d6747b7..dde0c306fb3a 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -26,6 +26,7 @@
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_mdio.h>
+#include <linux/of_net.h>
 #include <linux/platform_data/mv88e6xxx.h>
 #include <linux/netdevice.h>
 #include <linux/gpio/consumer.h>
@@ -841,6 +842,113 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
 	}
 }
 
+static struct fwnode_handle *mv88e6xxx_create_fixed_swnode(struct fwnode_handle *parent,
+							   int speed,
+							   int duplex)
+{
+	struct property_entry fixed_link_props[3] = { };
+
+	fixed_link_props[0] = PROPERTY_ENTRY_U32("speed", speed);
+	if (duplex == DUPLEX_FULL)
+		fixed_link_props[1] = PROPERTY_ENTRY_BOOL("full-duplex");
+
+	return fwnode_create_named_software_node(fixed_link_props, parent,
+						 "fixed-link");
+}
+
+static struct fwnode_handle *mv88e6xxx_create_port_swnode(phy_interface_t mode,
+							  int speed,
+							  int duplex)
+{
+	struct property_entry port_props[2] = {};
+	struct fwnode_handle *fixed_link_fwnode;
+	struct fwnode_handle *new_port_fwnode;
+
+	port_props[0] = PROPERTY_ENTRY_STRING("phy-mode", phy_modes(mode));
+	new_port_fwnode = fwnode_create_software_node(port_props, NULL);
+	if (IS_ERR(new_port_fwnode))
+		return new_port_fwnode;
+
+	fixed_link_fwnode = mv88e6xxx_create_fixed_swnode(new_port_fwnode,
+							  speed, duplex);
+	if (IS_ERR(fixed_link_fwnode)) {
+		fwnode_remove_software_node(new_port_fwnode);
+		return fixed_link_fwnode;
+	}
+
+	return new_port_fwnode;
+}
+
+static unsigned long mv88e6xxx_get_max_caps(struct phylink_config *config,
+					    phy_interface_t *mode)
+{
+	unsigned long max_caps, caps, mac_caps;
+	phy_interface_t interface;
+
+	mac_caps = config->mac_capabilities;
+	if (*mode != PHY_INTERFACE_MODE_NA)
+		return phylink_get_capabilities(*mode, mac_caps,
+						RATE_MATCH_NONE);
+
+	max_caps = 0;
+	for_each_set_bit(interface, config->supported_interfaces,
+			 PHY_INTERFACE_MODE_MAX) {
+		caps = phylink_get_capabilities(interface, mac_caps,
+						RATE_MATCH_NONE);
+		if (caps > max_caps) {
+			max_caps = caps;
+			*mode = interface;
+		}
+	}
+
+	return max_caps;
+}
+
+static struct fwnode_handle *mv88e6xxx_port_get_fwnode(struct dsa_switch *ds,
+						       int port,
+						       struct fwnode_handle *h)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct device_node *np, *phy_node;
+	int speed, duplex, err;
+	phy_interface_t mode;
+	struct dsa_port *dp;
+	unsigned long caps;
+
+	dp = dsa_to_port(ds, port);
+	if (dsa_port_is_user(dp))
+		return h;
+
+	/* No DT? Eh? */
+	np = to_of_node(h);
+	if (!np)
+		return h;
+
+	/* If a PHY, fixed-link specification, or in-band mode, then we
+	 * don't need to do any fixup. Simply return the provided fwnode.
+	 */
+	phy_node = of_parse_phandle(np, "phy-handle", 0);
+	of_node_put(phy_node);
+	if (phy_node || of_phy_is_fixed_link(np))
+		return h;
+
+	/* Get the DT specified phy-mode. If missing, try the chip's max speed
+	 * mode method if implemented, otherwise try the supported_interfaces
+	 * mask for the interface mode that gives the fastest speeds.
+	 */
+	err = of_get_phy_mode(np, &mode);
+	if (err && chip->info->ops->port_max_speed_mode)
+		mode = chip->info->ops->port_max_speed_mode(port);
+
+	caps = mv88e6xxx_get_max_caps(&dp->pl_config, &mode);
+
+	err = phylink_find_max_speed(caps, &speed, &duplex);
+	if (err)
+		return ERR_PTR(err);
+
+	return mv88e6xxx_create_port_swnode(mode, speed, duplex);
+}
+
 static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 				 unsigned int mode,
 				 const struct phylink_link_state *state)
@@ -6994,6 +7102,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.teardown		= mv88e6xxx_teardown,
 	.port_setup		= mv88e6xxx_port_setup,
 	.port_teardown		= mv88e6xxx_port_teardown,
+	.port_get_fwnode	= mv88e6xxx_port_get_fwnode,
 	.phylink_get_caps	= mv88e6xxx_get_caps,
 	.phylink_mac_link_state	= mv88e6xxx_serdes_pcs_get_state,
 	.phylink_mac_config	= mv88e6xxx_mac_config,
-- 
2.30.2

