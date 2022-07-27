Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4340B58204F
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiG0Goj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiG0Gnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:43:52 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B93371B4
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:43:44 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id b16so13230832lfb.7
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LCYfkQYBVUz+N80duT8GehXeSbCMzuDkINreOMolbEg=;
        b=jIkc5ADh2NQaFz9xfHLydQdc2SLuHpwUDaPsVGK03uL66OFTjgVquWkw39KdPdmmPF
         3miZ36H8ojRxBYf+f7bAl47AahCDwK2LI3HjXx0Z8Jum2qXx+HAU0WfDiuTy1h/smJz5
         Pm8Qjic8o+yXVCyw6laqxGY+i2wACbOCtG9ClMVSuwHC5NYQl4PYlu3k4tAsVakJ4FTm
         /4qjVOQeR5EyhaOJx8N41DTfhgnW1MOfgHbY10vikTEME+C8Azci8gjmvaXSB2xh8f1W
         hABhi54TbK05s9LZFkUKawkP/3HxnAGIbaTUPaQcr6yZqH5c5ZC+jfKivsx1Q4I9g3hl
         0/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LCYfkQYBVUz+N80duT8GehXeSbCMzuDkINreOMolbEg=;
        b=E9IGWDfuHQk2nEjJjYuWwy5TO+TPLLj+F/kb/BCLhgVrru6ZbVrDAUuq3Ps+vf8DdJ
         mv9rwzJLyhFPRkID4AuXyKjOLhFu0jJAwVYkDJIpFNEGES29OoI8DJ0r9fn3PflyhOep
         revreSnZDS4Vz4dQ2KHy7aFwuer+0zIBLVGBXBRzotiKuwRAO1zaLPzf8Pk7m3iIvcT2
         KBJBmJOfOcOGoTHuY07u4nLj+CITAzGPuB0pmGEIqTd5O1iOZLN/CldbJOXc7cADlnAA
         9cDaeWbHEfKP/N0RYf+qjgX/tg04wyCllVjNcjZR8yK2cJAZG64NpDumJMbtyoPPt0IA
         UgKg==
X-Gm-Message-State: AJIora8PpX5E65dMDtkRKUITtsUW4FV42zsAx0ypHlGmw/p3mMNkvlUE
        na1tQy+lBaZQG3Bwcj8avXOyfg==
X-Google-Smtp-Source: AGRyM1v75qA+ISRsWkPw1KmxR25Z9t+gjZ+afAk5jSOgr/4F0bz4ZmaWu9ZTfRZhNyJw0OCwSzia/Q==
X-Received: by 2002:a19:674a:0:b0:47f:863d:5bc2 with SMTP id e10-20020a19674a000000b0047f863d5bc2mr7452792lfj.92.1658904222856;
        Tue, 26 Jul 2022 23:43:42 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id w19-20020a05651234d300b0048a97a1df02sm1157231lfr.6.2022.07.26.23.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 23:43:42 -0700 (PDT)
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
Subject: [net-next: PATCH v3 3/8] net: dsa: switch to device_/fwnode_ APIs
Date:   Wed, 27 Jul 2022 08:43:16 +0200
Message-Id: <20220727064321.2953971-4-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220727064321.2953971-1-mw@semihalf.com>
References: <20220727064321.2953971-1-mw@semihalf.com>
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

In order to support both DT and ACPI in future, modify the generic DSA
code to use device_/fwnode_ equivalent routines. Drop using port's 'dn'
field and use only fwnode - update all dependent drivers.

Because support for more generic fwnode is added, replace '_of' suffix
with '_fw' in related routines. No functional change is introduced by
this patch.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 include/net/dsa.h                   |   2 +-
 net/dsa/dsa_priv.h                  |   4 +-
 drivers/net/dsa/mt7530.c            |   6 +-
 drivers/net/dsa/mv88e6xxx/chip.c    |  14 +--
 drivers/net/dsa/qca/qca8k.c         |   2 +-
 drivers/net/dsa/realtek/rtl8365mb.c |   2 +-
 net/dsa/dsa2.c                      | 100 +++++++++++---------
 net/dsa/port.c                      |  68 +++++++------
 net/dsa/slave.c                     |   7 +-
 9 files changed, 103 insertions(+), 102 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index b902b31bebce..0a328c0073ec 100644
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
index 835807911be0..427b66342493 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2109,8 +2109,8 @@ mt7530_setup(struct dsa_switch *ds)
 	struct device_node *phy_node;
 	struct device_node *mac_np;
 	struct mt7530_dummy_poll p;
-	phy_interface_t interface;
 	struct dsa_port *cpu_dp;
+	int interface;
 	u32 id, val;
 	int ret, i;
 
@@ -2232,8 +2232,8 @@ mt7530_setup(struct dsa_switch *ds)
 
 	if (!dsa_is_unused_port(ds, 5)) {
 		priv->p5_intf_sel = P5_INTF_SEL_GMAC5;
-		ret = of_get_phy_mode(dsa_to_port(ds, 5)->dn, &interface);
-		if (ret && ret != -ENODEV)
+		interface = fwnode_get_phy_mode(dsa_to_port(ds, 5)->fwnode);
+		if (interface < 0)
 			return ret;
 	} else {
 		/* Scan the ethernet nodes. look for GMAC1, lookup used phy */
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 07e9a4da924c..a46ebdfba1c3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3275,7 +3275,7 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 
 static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
-	struct device_node *phy_handle = NULL;
+	struct fwnode_handle *phy_handle = NULL;
 	struct dsa_switch *ds = chip->ds;
 	phy_interface_t mode;
 	struct dsa_port *dp;
@@ -3499,15 +3499,15 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 
 	if (chip->info->ops->serdes_set_tx_amplitude) {
 		if (dp)
-			phy_handle = of_parse_phandle(dp->dn, "phy-handle", 0);
+			phy_handle = fwnode_find_reference(dp->fwnode, "phy-handle", 0);
 
-		if (phy_handle && !of_property_read_u32(phy_handle,
-							"tx-p2p-microvolt",
-							&tx_amp))
+		if (!IS_ERR(phy_handle) && !fwnode_property_read_u32(phy_handle,
+								     "tx-p2p-microvolt",
+								     &tx_amp))
 			err = chip->info->ops->serdes_set_tx_amplitude(chip,
 								port, tx_amp);
-		if (phy_handle) {
-			of_node_put(phy_handle);
+		if (!IS_ERR(phy_handle)) {
+			fwnode_handle_put(phy_handle);
 			if (err)
 				return err;
 		}
diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
index 1cbb05b0323f..77b14ade0828 100644
--- a/drivers/net/dsa/qca/qca8k.c
+++ b/drivers/net/dsa/qca/qca8k.c
@@ -1517,7 +1517,7 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 			continue;
 
 		dp = dsa_to_port(priv->ds, port);
-		port_dn = dp->dn;
+		port_dn = to_of_node(dp->fwnode);
 		cpu_port_index++;
 
 		if (!of_device_is_available(port_dn))
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index da31d8b839ac..d61da012451f 100644
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
index 2dd76eb1621c..40c7d1d9b488 100644
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
 
@@ -1380,20 +1379,20 @@ void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 
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
 
@@ -1525,11 +1524,10 @@ static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 int dsa_port_phylink_create(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
-	phy_interface_t mode;
-	int err;
+	int mode;
 
-	err = of_get_phy_mode(dp->dn, &mode);
-	if (err)
+	mode = fwnode_get_phy_mode(dp->fwnode);
+	if (mode < 0)
 		mode = PHY_INTERFACE_MODE_NA;
 
 	/* Presence of phylink_mac_link_state or phylink_mac_an_restart is
@@ -1542,7 +1540,7 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	if (ds->ops->phylink_get_caps)
 		ds->ops->phylink_get_caps(ds, dp->index, &dp->pl_config);
 
-	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
+	dp->pl = phylink_create(&dp->pl_config, dp->fwnode,
 				mode, &dsa_port_phylink_mac_ops);
 	if (IS_ERR(dp->pl)) {
 		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
@@ -1552,7 +1550,7 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	return 0;
 }
 
-static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
+static int dsa_port_setup_phy_fw(struct dsa_port *dp, bool enable)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct phy_device *phydev;
@@ -1590,16 +1588,15 @@ static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
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
@@ -1607,10 +1604,10 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
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
 
@@ -1627,7 +1624,6 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
 static int dsa_port_phylink_register(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
-	struct device_node *port_dn = dp->dn;
 	int err;
 
 	dp->pl_config.dev = ds->dev;
@@ -1637,7 +1633,7 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 	if (err)
 		return err;
 
-	err = phylink_of_phy_connect(dp->pl, port_dn, 0);
+	err = phylink_fwnode_phy_connect(dp->pl, dp->fwnode, 0);
 	if (err && err != -ENODEV) {
 		pr_err("could not attach to PHY: %d\n", err);
 		goto err_phy_connect;
@@ -1650,35 +1646,35 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 	return err;
 }
 
-int dsa_port_link_register_of(struct dsa_port *dp)
+int dsa_port_link_register_fw(struct dsa_port *dp)
 {
+	struct fwnode_handle *phy_handle;
 	struct dsa_switch *ds = dp->ds;
-	struct device_node *phy_np;
 	int port = dp->index;
 
 	if (!ds->ops->adjust_link) {
-		phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
-		if (of_phy_is_fixed_link(dp->dn) || phy_np) {
+		phy_handle = fwnode_find_reference(dp->fwnode, "phy-handle", 0);
+		if (fwnode_phy_is_fixed_link(dp->fwnode) || !IS_ERR(phy_handle)) {
 			if (ds->ops->phylink_mac_link_down)
 				ds->ops->phylink_mac_link_down(ds, port,
 					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
-			of_node_put(phy_np);
+			fwnode_handle_put(dp->fwnode);
 			return dsa_port_phylink_register(dp);
 		}
-		of_node_put(phy_np);
+		fwnode_handle_put(dp->fwnode);
 		return 0;
 	}
 
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
 
@@ -1691,10 +1687,10 @@ void dsa_port_link_unregister_of(struct dsa_port *dp)
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

