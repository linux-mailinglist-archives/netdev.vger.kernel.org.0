Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB127575E21
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 11:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbiGOIvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 04:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbiGOIuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 04:50:50 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407A68244E
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:50:46 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id bu42so6842111lfb.0
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sbDYvZq4O+B1/WFFjCS89/4ARFp4dv9vR5UNAfQQqpk=;
        b=T2cxWhtoCc31+EasHa9s4YeAouB4t79XBKAjfoULt4x7IE1oPxQ5Dc2h4NBUR0qMJS
         8rIuoOGEvjeyNlrvhYVbV6B1DJ2/+IGuEKFvtpcBJlWYJzxtUwYVJQF6SFP5/gzVg81M
         sxIH27ZS2stCYGVETcSYIltPjlJ9/mr22RdmR5SFE9RmvA/FvmYFLbDsmxGOWC9h4HCh
         nXNYQWAhisWVFWjzkYs7vlAB2p9+itOy25TUaNIBWqTrIfveSwbZdbDtc7SIgrM8N6SU
         0VmA/HwftKXmCQpzbDVQahioY4v0Hs5QWzPicsLwdrNkcvgATLNGOoo8Yt02/4M/Aytp
         9q+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sbDYvZq4O+B1/WFFjCS89/4ARFp4dv9vR5UNAfQQqpk=;
        b=jUtaSUrQfLGIRWl9FTZVnHYRfDX9/psMpJDURglfOacuGjR5h85to2XNz7QaNYw579
         bFlc9g6UV+rbfM6nbUTIrCC3ZnoqfrrEZTa+7cX9xja60fuoE0qAvk1FfAdaOhpklIug
         SaW3m3K6lYSsLxsE2B+I3iVajbr39ha2HuyQGqnkzjvH49W3ewO8sVAKDnxmdsreUVVR
         3jbO2cLRURAzvXmoTA1JPJarJvyusxfsQCarajFdpllXtIVVW30o/itfPNW2qBZQkg42
         pPwHY71KEhxpyt9DLQbi4ghK8VM9sFhtGy7sliFsHLXeyLTXGrkCdJceuWHcUd+4u20B
         Sctg==
X-Gm-Message-State: AJIora8DSkqWPa6ySqhylzohIXVVdZ6+/vXBOX2FVMayfkuyjHN46zI9
        bap48es+y8M6iBa2km2vVgkFVg==
X-Google-Smtp-Source: AGRyM1vEO61Awb80CQQLsZTm/BwCjgyZ/hJw6c7DxuGkdQwvLXxaQbNHeKJbkMmQVHZBsxOkceltow==
X-Received: by 2002:a05:6512:3084:b0:489:e658:25ac with SMTP id z4-20020a056512308400b00489e65825acmr7777395lfd.431.1657875044088;
        Fri, 15 Jul 2022 01:50:44 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e4-20020a2e9e04000000b0025d773448basm667846ljk.23.2022.07.15.01.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 01:50:43 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: [net-next: PATCH v2 3/8] net: dsa: switch to device_/fwnode_ APIs
Date:   Fri, 15 Jul 2022 10:50:07 +0200
Message-Id: <20220715085012.2630214-4-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220715085012.2630214-1-mw@semihalf.com>
References: <20220715085012.2630214-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support both ACPI and DT, modify the generic
DSA code to use device_/fwnode_ equivalent routines.
Drop using port's dn field and use only fwnode - update
all dependent drivers.
Because support for more generic fwnode is added,
replace '_of' suffix with '_fw' in related routines.
No functional change is introduced by this patch.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 include/net/dsa.h                   |   2 +-
 net/dsa/dsa_priv.h                  |   4 +-
 drivers/net/dsa/mt7530.c            |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c    |   2 +-
 drivers/net/dsa/qca8k.c             |   2 +-
 drivers/net/dsa/realtek/rtl8365mb.c |   2 +-
 net/dsa/dsa2.c                      | 100 +++++++++++---------
 net/dsa/port.c                      |  70 +++++++-------
 net/dsa/slave.c                     |   7 +-
 9 files changed, 97 insertions(+), 94 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 7c6870d2c607..d0c944e2b920 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -302,7 +302,7 @@ struct dsa_port {
 
 	u8			setup:1;
 
-	struct device_node	*dn;
+	struct fwnode_handle    *fwnode;
 	unsigned int		ageing_time;
 
 	struct dsa_bridge	*bridge;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d9722e49864b..2c0034a915ee 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -285,8 +285,8 @@ int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
 int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
 			       const struct switchdev_obj_ring_role_mrp *mrp);
 int dsa_port_phylink_create(struct dsa_port *dp);
-int dsa_port_link_register_of(struct dsa_port *dp);
-void dsa_port_link_unregister_of(struct dsa_port *dp);
+int dsa_port_link_register_fw(struct dsa_port *dp);
+void dsa_port_link_unregister_fw(struct dsa_port *dp);
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
 void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index dab308e454e3..036ca130d86e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2232,7 +2232,7 @@ mt7530_setup(struct dsa_switch *ds)
 
 	if (!dsa_is_unused_port(ds, 5)) {
 		priv->p5_intf_sel = P5_INTF_SEL_GMAC5;
-		ret = of_get_phy_mode(dsa_to_port(ds, 5)->dn, &interface);
+		ret = of_get_phy_mode(to_of_node(dsa_to_port(ds, 5)->fwnode), &interface);
 		if (ret && ret != -ENODEV)
 			return ret;
 	} else {
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 01dff8d46642..1baf07b3284b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3499,7 +3499,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 
 	if (chip->info->ops->serdes_set_tx_amplitude) {
 		if (dp)
-			phy_handle = of_parse_phandle(dp->dn, "phy-handle", 0);
+			phy_handle = of_parse_phandle(to_of_node(dp->fwnode), "phy-handle", 0);
 
 		if (phy_handle && !of_property_read_u32(phy_handle,
 							"tx-p2p-microvolt",
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index beccd8338c81..597ff5f1be4c 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1517,7 +1517,7 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 			continue;
 
 		dp = dsa_to_port(priv->ds, port);
-		port_dn = dp->dn;
+		port_dn = to_of_node(dp->fwnode);
 		cpu_port_index++;
 
 		if (!of_device_is_available(port_dn))
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 7bf420c2b083..143e5718b531 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -887,7 +887,7 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 		return -ENODEV;
 
 	dp = dsa_to_port(priv->ds, port);
-	dn = dp->dn;
+	dn = to_of_node(dp->fwnode);
 
 	/* Set the RGMII TX/RX delay
 	 *
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cac48a741f27..82fb3b009fb4 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -296,12 +296,12 @@ static void dsa_tree_put(struct dsa_switch_tree *dst)
 }
 
 static struct dsa_port *dsa_tree_find_port_by_node(struct dsa_switch_tree *dst,
-						   struct device_node *dn)
+						   struct fwnode_handle *fwnode)
 {
 	struct dsa_port *dp;
 
 	list_for_each_entry(dp, &dst->ports, list)
-		if (dp->dn == dn)
+		if (dp->fwnode == fwnode)
 			return dp;
 
 	return NULL;
@@ -337,14 +337,13 @@ static bool dsa_port_setup_routing_table(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_switch_tree *dst = ds->dst;
-	struct device_node *dn = dp->dn;
 	struct of_phandle_iterator it;
 	struct dsa_port *link_dp;
 	struct dsa_link *dl;
 	int err;
 
-	of_for_each_phandle(&it, err, dn, "link", NULL, 0) {
-		link_dp = dsa_tree_find_port_by_node(dst, it.node);
+	of_for_each_phandle(&it, err, to_of_node(dp->fwnode), "link", NULL, 0) {
+		link_dp = dsa_tree_find_port_by_node(dst, of_fwnode_handle(it.node));
 		if (!link_dp) {
 			of_node_put(it.node);
 			return false;
@@ -469,7 +468,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 		dsa_port_disable(dp);
 		break;
 	case DSA_PORT_TYPE_CPU:
-		err = dsa_port_link_register_of(dp);
+		err = dsa_port_link_register_fw(dp);
 		if (err)
 			break;
 		dsa_port_link_registered = true;
@@ -481,7 +480,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 		break;
 	case DSA_PORT_TYPE_DSA:
-		err = dsa_port_link_register_of(dp);
+		err = dsa_port_link_register_fw(dp);
 		if (err)
 			break;
 		dsa_port_link_registered = true;
@@ -493,7 +492,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 		break;
 	case DSA_PORT_TYPE_USER:
-		of_get_mac_address(dp->dn, dp->mac);
+		fwnode_get_mac_address(dp->fwnode, dp->mac);
 		err = dsa_slave_create(dp);
 		if (err)
 			break;
@@ -505,7 +504,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (err && dsa_port_enabled)
 		dsa_port_disable(dp);
 	if (err && dsa_port_link_registered)
-		dsa_port_link_unregister_of(dp);
+		dsa_port_link_unregister_fw(dp);
 	if (err) {
 		if (ds->ops->port_teardown)
 			ds->ops->port_teardown(ds, dp->index);
@@ -577,11 +576,11 @@ static void dsa_port_teardown(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_CPU:
 		dsa_port_disable(dp);
-		dsa_port_link_unregister_of(dp);
+		dsa_port_link_unregister_fw(dp);
 		break;
 	case DSA_PORT_TYPE_DSA:
 		dsa_port_disable(dp);
-		dsa_port_link_unregister_of(dp);
+		dsa_port_link_unregister_fw(dp);
 		break;
 	case DSA_PORT_TYPE_USER:
 		if (dp->slave) {
@@ -853,7 +852,7 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
 	struct dsa_devlink_priv *dl_priv;
-	struct device_node *dn;
+	struct fwnode_handle *fwnode;
 	struct dsa_port *dp;
 	int err;
 
@@ -909,10 +908,10 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
 		dsa_slave_mii_bus_init(ds);
 
-		dn = of_get_child_by_name(ds->dev->of_node, "mdio");
+		fwnode = device_get_named_child_node(ds->dev, "mdio");
 
-		err = of_mdiobus_register(ds->slave_mii_bus, dn);
-		of_node_put(dn);
+		err = of_mdiobus_register(ds->slave_mii_bus, to_of_node(fwnode));
+		fwnode_handle_put(fwnode);
 		if (err < 0)
 			goto free_slave_mii_bus;
 	}
@@ -1482,24 +1481,33 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 	return 0;
 }
 
-static int dsa_port_parse_of(struct dsa_port *dp, struct device_node *dn)
+static int dsa_port_parse_fw(struct dsa_port *dp, struct fwnode_handle *fwnode)
 {
-	struct device_node *ethernet = of_parse_phandle(dn, "ethernet", 0);
-	const char *name = of_get_property(dn, "label", NULL);
-	bool link = of_property_read_bool(dn, "link");
+	struct fwnode_handle *ethernet = fwnode_find_reference(fwnode, "ethernet", 0);
+	bool link = fwnode_property_present(fwnode, "link");
+	const char *name;
+	int ret;
+
+	ret = fwnode_property_read_string(fwnode, "label", &name);
+	if (ret)
+		return ret;
 
-	dp->dn = dn;
+	dp->fwnode = fwnode;
 
-	if (ethernet) {
+	if (!IS_ERR(ethernet)) {
 		struct net_device *master;
 		const char *user_protocol;
 
-		master = of_find_net_device_by_node(ethernet);
-		of_node_put(ethernet);
+		master = of_find_net_device_by_node(to_of_node(ethernet));
+		fwnode_handle_put(ethernet);
 		if (!master)
 			return -EPROBE_DEFER;
 
-		user_protocol = of_get_property(dn, "dsa-tag-protocol", NULL);
+		ret = fwnode_property_read_string(fwnode, "dsa-tag-protocol",
+						  &user_protocol);
+		if (ret)
+			user_protocol = NULL;
+
 		return dsa_port_parse_cpu(dp, master, user_protocol);
 	}
 
@@ -1509,61 +1517,61 @@ static int dsa_port_parse_of(struct dsa_port *dp, struct device_node *dn)
 	return dsa_port_parse_user(dp, name);
 }
 
-static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
-				     struct device_node *dn)
+static int dsa_switch_parse_ports_fw(struct dsa_switch *ds,
+				     struct fwnode_handle *fwnode)
 {
-	struct device_node *ports, *port;
+	struct fwnode_handle *ports, *port;
 	struct dsa_port *dp;
 	int err = 0;
 	u32 reg;
 
-	ports = of_get_child_by_name(dn, "ports");
+	ports = fwnode_get_named_child_node(fwnode, "ports");
 	if (!ports) {
 		/* The second possibility is "ethernet-ports" */
-		ports = of_get_child_by_name(dn, "ethernet-ports");
+		ports = fwnode_get_named_child_node(fwnode, "ethernet-ports");
 		if (!ports) {
 			dev_err(ds->dev, "no ports child node found\n");
 			return -EINVAL;
 		}
 	}
 
-	for_each_available_child_of_node(ports, port) {
-		err = of_property_read_u32(port, "reg", &reg);
+	fwnode_for_each_available_child_node(ports, port) {
+		err = fwnode_property_read_u32(port, "reg", &reg);
 		if (err) {
-			of_node_put(port);
+			fwnode_handle_put(port);
 			goto out_put_node;
 		}
 
 		if (reg >= ds->num_ports) {
 			dev_err(ds->dev, "port %pOF index %u exceeds num_ports (%u)\n",
 				port, reg, ds->num_ports);
-			of_node_put(port);
+			fwnode_handle_put(port);
 			err = -EINVAL;
 			goto out_put_node;
 		}
 
 		dp = dsa_to_port(ds, reg);
 
-		err = dsa_port_parse_of(dp, port);
+		err = dsa_port_parse_fw(dp, port);
 		if (err) {
-			of_node_put(port);
+			fwnode_handle_put(port);
 			goto out_put_node;
 		}
 	}
 
 out_put_node:
-	of_node_put(ports);
+	fwnode_handle_put(ports);
 	return err;
 }
 
-static int dsa_switch_parse_member_of(struct dsa_switch *ds,
-				      struct device_node *dn)
+static int dsa_switch_parse_member_fw(struct dsa_switch *ds,
+				      struct fwnode_handle *fwnode)
 {
 	u32 m[2] = { 0, 0 };
 	int sz;
 
 	/* Don't error out if this optional property isn't found */
-	sz = of_property_read_variable_u32_array(dn, "dsa,member", m, 2, 2);
+	sz = fwnode_property_read_u32_array(fwnode, "dsa,member", m, 2);
 	if (sz < 0 && sz != -EINVAL)
 		return sz;
 
@@ -1600,11 +1608,11 @@ static int dsa_switch_touch_ports(struct dsa_switch *ds)
 	return 0;
 }
 
-static int dsa_switch_parse_of(struct dsa_switch *ds, struct device_node *dn)
+static int dsa_switch_parse_fw(struct dsa_switch *ds, struct fwnode_handle *fwnode)
 {
 	int err;
 
-	err = dsa_switch_parse_member_of(ds, dn);
+	err = dsa_switch_parse_member_fw(ds, fwnode);
 	if (err)
 		return err;
 
@@ -1612,7 +1620,7 @@ static int dsa_switch_parse_of(struct dsa_switch *ds, struct device_node *dn)
 	if (err)
 		return err;
 
-	return dsa_switch_parse_ports_of(ds, dn);
+	return dsa_switch_parse_ports_fw(ds, fwnode);
 }
 
 static int dsa_port_parse(struct dsa_port *dp, const char *name,
@@ -1705,20 +1713,20 @@ static int dsa_switch_probe(struct dsa_switch *ds)
 {
 	struct dsa_switch_tree *dst;
 	struct dsa_chip_data *pdata;
-	struct device_node *np;
+	struct fwnode_handle *fwnode;
 	int err;
 
 	if (!ds->dev)
 		return -ENODEV;
 
 	pdata = ds->dev->platform_data;
-	np = ds->dev->of_node;
+	fwnode = dev_fwnode(ds->dev);
 
 	if (!ds->num_ports)
 		return -EINVAL;
 
-	if (np) {
-		err = dsa_switch_parse_of(ds, np);
+	if (fwnode) {
+		err = dsa_switch_parse_fw(ds, fwnode);
 		if (err)
 			dsa_switch_release_ports(ds);
 	} else if (pdata) {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index abcf7899abf8..c03baf20f5e5 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -6,10 +6,9 @@
  *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
  */
 
+#include <linux/fwnode_mdio.h>
 #include <linux/if_bridge.h>
 #include <linux/notifier.h>
-#include <linux/of_mdio.h>
-#include <linux/of_net.h>
 
 #include "dsa_priv.h"
 
@@ -1379,20 +1378,20 @@ void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 
 static struct phy_device *dsa_port_get_phy_device(struct dsa_port *dp)
 {
-	struct device_node *phy_dn;
+	struct fwnode_handle *phy_handle;
 	struct phy_device *phydev;
 
-	phy_dn = of_parse_phandle(dp->dn, "phy-handle", 0);
-	if (!phy_dn)
+	phy_handle = fwnode_find_reference(dp->fwnode, "phy-handle", 0);
+	if (IS_ERR(phy_handle))
 		return NULL;
 
-	phydev = of_phy_find_device(phy_dn);
+	phydev = fwnode_phy_find_device(phy_handle);
 	if (!phydev) {
-		of_node_put(phy_dn);
+		fwnode_handle_put(phy_handle);
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 
-	of_node_put(phy_dn);
+	fwnode_handle_put(phy_handle);
 	return phydev;
 }
 
@@ -1592,20 +1591,19 @@ static struct fwnode_handle *dsa_port_get_fwnode(struct dsa_port *dp,
 	struct property_entry port_props[3] = {};
 	struct fwnode_handle *fixed_link_fwnode;
 	struct fwnode_handle *new_port_fwnode;
-	struct device_node *dn = dp->dn;
-	struct device_node *phy_node;
+	struct fwnode_handle *phy_handle;
 	int err, speed, duplex;
 	unsigned long caps;
 
-	phy_node = of_parse_phandle(dn, "phy-handle", 0);
-	of_node_put(phy_node);
-	if (phy_node || of_phy_is_fixed_link(dn))
+	phy_handle = fwnode_find_reference(dp->fwnode, "phy-handle", 0);
+	fwnode_handle_put(phy_handle);
+	if (!IS_ERR(phy_handle) || fwnode_phy_is_fixed_link(dp->fwnode))
 		/* Nothing broken, nothing to fix.
 		 * TODO: As discussed with Russell, maybe phylink could provide
 		 * a more comprehensive helper to determine what constitutes a
 		 * valid fwnode binding than this guerilla kludge.
 		 */
-		return of_fwnode_handle(dn);
+		return dp->fwnode;
 
 	if (mode == PHY_INTERFACE_MODE_NA)
 		dsa_port_find_max_caps(dp, &mode, &caps);
@@ -1644,9 +1642,9 @@ static struct fwnode_handle *dsa_port_get_fwnode(struct dsa_port *dp,
 int dsa_port_phylink_create(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
-	phy_interface_t mode, def_mode;
 	struct fwnode_handle *fwnode;
-	int err;
+	phy_interface_t def_mode;
+	int mode;
 
 	/* Presence of phylink_mac_link_state or phylink_mac_an_restart is
 	 * an indicator of a legacy phylink driver.
@@ -1660,8 +1658,8 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 		ds->ops->phylink_get_caps(ds, dp->index, &dp->pl_config,
 					  &def_mode);
 
-	err = of_get_phy_mode(dp->dn, &mode);
-	if (err) {
+	mode = fwnode_get_phy_mode(dp->fwnode);
+	if (mode < 0) {
 		/* We must not set the default mode for user ports as a PHY
 		 * overrides the NA mode in phylink. Setting it here would
 		 * prevent the interface mode being updated.
@@ -1686,6 +1684,8 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 
 	fwnode_remove_software_node(fwnode);
 
+	dp->pl = phylink_create(&dp->pl_config, dp->fwnode,
+				mode, &dsa_port_phylink_mac_ops);
 	if (IS_ERR(dp->pl)) {
 		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
 		return PTR_ERR(dp->pl);
@@ -1694,7 +1694,7 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	return 0;
 }
 
-static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
+static int dsa_port_setup_phy_fw(struct dsa_port *dp, bool enable)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct phy_device *phydev;
@@ -1732,16 +1732,15 @@ static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
 	return err;
 }
 
-static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
+static int dsa_port_fixed_link_register_fw(struct dsa_port *dp)
 {
-	struct device_node *dn = dp->dn;
 	struct dsa_switch *ds = dp->ds;
 	struct phy_device *phydev;
 	int port = dp->index;
-	phy_interface_t mode;
+	int mode;
 	int err;
 
-	err = of_phy_register_fixed_link(dn);
+	err = fwnode_phy_register_fixed_link(dp->fwnode);
 	if (err) {
 		dev_err(ds->dev,
 			"failed to register the fixed PHY of port %d\n",
@@ -1749,10 +1748,10 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
 		return err;
 	}
 
-	phydev = of_phy_find_device(dn);
+	phydev = fwnode_phy_find_device(dp->fwnode);
 
-	err = of_get_phy_mode(dn, &mode);
-	if (err)
+	mode = fwnode_get_phy_mode(dp->fwnode);
+	if (mode < 0)
 		mode = PHY_INTERFACE_MODE_NA;
 	phydev->interface = mode;
 
@@ -1769,7 +1768,6 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
 static int dsa_port_phylink_register(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
-	struct device_node *port_dn = dp->dn;
 	int err;
 
 	dp->pl_config.dev = ds->dev;
@@ -1779,7 +1777,7 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 	if (err)
 		return err;
 
-	err = phylink_of_phy_connect(dp->pl, port_dn, 0);
+	err = phylink_fwnode_phy_connect(dp->pl, dp->fwnode, 0);
 	if (err && err != -ENODEV) {
 		pr_err("could not attach to PHY: %d\n", err);
 		goto err_phy_connect;
@@ -1792,7 +1790,7 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 	return err;
 }
 
-int dsa_port_link_register_of(struct dsa_port *dp)
+int dsa_port_link_register_fw(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
@@ -1808,13 +1806,13 @@ int dsa_port_link_register_of(struct dsa_port *dp)
 	dev_warn(ds->dev,
 		 "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
 
-	if (of_phy_is_fixed_link(dp->dn))
-		return dsa_port_fixed_link_register_of(dp);
+	if (fwnode_phy_is_fixed_link(dp->fwnode))
+		return dsa_port_fixed_link_register_fw(dp);
 	else
-		return dsa_port_setup_phy_of(dp, true);
+		return dsa_port_setup_phy_fw(dp, true);
 }
 
-void dsa_port_link_unregister_of(struct dsa_port *dp)
+void dsa_port_link_unregister_fw(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 
@@ -1827,10 +1825,10 @@ void dsa_port_link_unregister_of(struct dsa_port *dp)
 		return;
 	}
 
-	if (of_phy_is_fixed_link(dp->dn))
-		of_phy_deregister_fixed_link(dp->dn);
+	if (fwnode_phy_is_fixed_link(dp->fwnode))
+		fwnode_phy_deregister_fixed_link(dp->fwnode);
 	else
-		dsa_port_setup_phy_of(dp, false);
+		dsa_port_setup_phy_fw(dp, false);
 }
 
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ad6a6663feeb..209e24cb1477 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -10,8 +10,6 @@
 #include <linux/phy.h>
 #include <linux/phy_fixed.h>
 #include <linux/phylink.h>
-#include <linux/of_net.h>
-#include <linux/of_mdio.h>
 #include <linux/mdio.h>
 #include <net/rtnetlink.h>
 #include <net/pkt_cls.h>
@@ -2228,7 +2226,6 @@ static int dsa_slave_phy_connect(struct net_device *slave_dev, int addr,
 static int dsa_slave_phy_setup(struct net_device *slave_dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(slave_dev);
-	struct device_node *port_dn = dp->dn;
 	struct dsa_switch *ds = dp->ds;
 	u32 phy_flags = 0;
 	int ret;
@@ -2252,7 +2249,7 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 	if (ds->ops->get_phy_flags)
 		phy_flags = ds->ops->get_phy_flags(ds, dp->index);
 
-	ret = phylink_of_phy_connect(dp->pl, port_dn, phy_flags);
+	ret = phylink_fwnode_phy_connect(dp->pl, dp->fwnode, phy_flags);
 	if (ret == -ENODEV && ds->slave_mii_bus) {
 		/* We could not connect to a designated PHY or SFP, so try to
 		 * use the switch internal MDIO bus instead
@@ -2364,7 +2361,7 @@ int dsa_slave_create(struct dsa_port *port)
 	SET_NETDEV_DEVTYPE(slave_dev, &dsa_type);
 
 	SET_NETDEV_DEV(slave_dev, port->ds->dev);
-	slave_dev->dev.of_node = port->dn;
+	device_set_node(&slave_dev->dev, port->fwnode);
 	slave_dev->vlan_features = master->vlan_features;
 
 	p = netdev_priv(slave_dev);
-- 
2.29.0

