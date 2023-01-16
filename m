Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965FB66CE04
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbjAPRxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235051AbjAPRwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:52:31 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0822C3B649
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:35:02 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id y18so27131690ljk.11
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2mmk9wI3+C8ssmxR+DpT3SDJM6QGPsI0pDiXXE/Ux+4=;
        b=mVSJR9izrtn8REjhj4XqnwcyPGABR2JM6lKBsAZbCEjbjsHURusNR09T5nKNDVhIIZ
         NTaYjBj8l7WG9pkdbHHGCOYl0yrqUES+kElLjeaXPo6GSTje2genBqcuhWjgaVRnhPx8
         yatCz72qgWRumx2nfT0Lp1DOwoSBLsXRFH9AT9M4V8+1DbKEfzxPACN97T+sNzAsVW4M
         Oc8g7B1djvHKggbrz+Fy6zgU0JlosLxCnMFdyltQY46tggiYUnG58NrzpRHbKJuHxLBQ
         mA3Dd5UCy9v3CLLuIA6r6tPXn8HvRs+tuv385DmyMQyldDQUruLpcDL+NYRTATsXWo+b
         uW/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2mmk9wI3+C8ssmxR+DpT3SDJM6QGPsI0pDiXXE/Ux+4=;
        b=2ShnLLXSpx1NIuFR6/ShufhPjQuYFyVHtXr3ilV3QAYTLMtvXqJD7aFZBjjLYH+g/s
         RlR3M8ifjEpG6npUuX0lS1A99LxBWzckyGpcq9SpuS8HjIZmqT8S74l+igYDxtwyM83A
         Pjek5d1pjU6F/mRjSuT4DAinpNS0tojyZjTFMEdjV3WTOeimkaigoN2QA61CZ9GSICs+
         dnP2YUYjOFWL0JrdIikviUSs/UNFT70rtciP/UxffvhTRc/bQ8kAHClJBw979oj3d+qN
         dtDZU7qVxAEW7abPTDBN+GllGItqG8z5Ovpr6nFprhCo5FjtSYvNpiNrqszkdV2BK2/9
         gxVw==
X-Gm-Message-State: AFqh2kr9rqXinw0KZaFQyGt1mXT+pCrcwf/1XLrwLBU6pboSacfnkSEM
        d4JvhvECqpyRRg26MziNWkrdoA==
X-Google-Smtp-Source: AMrXdXss8H0gbWs28XqQtnJ2QyT/hDi+CE2b0WlWVk57pQf05wIO5SbYvmxXHAzd6auZ7WOrCC7Qeg==
X-Received: by 2002:a2e:5cd:0:b0:282:160b:e359 with SMTP id 196-20020a2e05cd000000b00282160be359mr166385ljf.23.1673890501403;
        Mon, 16 Jan 2023 09:35:01 -0800 (PST)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id k20-20020a2e8894000000b0028b7f51414fsm707333lji.80.2023.01.16.09.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 09:35:00 -0800 (PST)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, mw@semihalf.com,
        jaz@semihalf.com, tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com
Subject: [net-next: PATCH v4 3/8] net: dsa: switch to device_/fwnode_ APIs
Date:   Mon, 16 Jan 2023 18:34:15 +0100
Message-Id: <20230116173420.1278704-4-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20230116173420.1278704-1-mw@semihalf.com>
References: <20230116173420.1278704-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 net/dsa/port.h                      |   4 +-
 drivers/net/dsa/mt7530.c            |   6 +-
 drivers/net/dsa/mv88e6xxx/chip.c    |  16 +--
 drivers/net/dsa/qca/qca8k-8xxx.c    |   2 +-
 drivers/net/dsa/realtek/rtl8365mb.c |   2 +-
 net/dsa/dsa.c                       | 117 +++++++++++---------
 net/dsa/port.c                      |  85 +++++++-------
 net/dsa/slave.c                     |   7 +-
 9 files changed, 120 insertions(+), 121 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 96086289aa9b..b933b88ace78 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -300,7 +300,7 @@ struct dsa_port {
 
 	u8			setup:1;
 
-	struct device_node	*dn;
+	struct fwnode_handle    *fwnode;
 	unsigned int		ageing_time;
 
 	struct dsa_bridge	*bridge;
diff --git a/net/dsa/port.h b/net/dsa/port.h
index 9c218660d223..5037b8be982e 100644
--- a/net/dsa/port.h
+++ b/net/dsa/port.h
@@ -101,8 +101,8 @@ int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
 			       const struct switchdev_obj_ring_role_mrp *mrp);
 int dsa_port_phylink_create(struct dsa_port *dp);
 void dsa_port_phylink_destroy(struct dsa_port *dp);
-int dsa_shared_port_link_register_of(struct dsa_port *dp);
-void dsa_shared_port_link_unregister_of(struct dsa_port *dp);
+int dsa_shared_port_link_register_fw(struct dsa_port *dp);
+void dsa_shared_port_link_unregister_fw(struct dsa_port *dp);
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
 void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 908fa89444c9..35c4c71216fe 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2235,8 +2235,10 @@ mt7530_setup(struct dsa_switch *ds)
 
 	if (!dsa_is_unused_port(ds, 5)) {
 		priv->p5_intf_sel = P5_INTF_SEL_GMAC5;
-		ret = of_get_phy_mode(dsa_to_port(ds, 5)->dn, &interface);
-		if (ret && ret != -ENODEV)
+		ret = fwnode_get_phy_mode(dsa_to_port(ds, 5)->fwnode);
+		if (ret >= 0)
+			interface = ret;
+		else if (ret != -ENODEV)
 			return ret;
 	} else {
 		/* Scan the ethernet nodes. look for GMAC1, lookup used phy */
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1168ea75f5f5..6731597bded0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3285,7 +3285,7 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 
 static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
-	struct device_node *phy_handle = NULL;
+	struct fwnode_handle *phy_handle = NULL;
 	struct dsa_switch *ds = chip->ds;
 	phy_interface_t mode;
 	struct dsa_port *dp;
@@ -3509,18 +3509,14 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 
 	if (chip->info->ops->serdes_set_tx_amplitude) {
 		if (dp)
-			phy_handle = of_parse_phandle(dp->dn, "phy-handle", 0);
+			phy_handle = fwnode_find_reference(dp->fwnode, "phy-handle", 0);
 
-		if (phy_handle && !of_property_read_u32(phy_handle,
-							"tx-p2p-microvolt",
-							&tx_amp))
+		if (!fwnode_property_read_u32(phy_handle, "tx-p2p-microvolt", &tx_amp))
 			err = chip->info->ops->serdes_set_tx_amplitude(chip,
 								port, tx_amp);
-		if (phy_handle) {
-			of_node_put(phy_handle);
-			if (err)
-				return err;
-		}
+		fwnode_handle_put(phy_handle);
+		if (err)
+			return err;
 	}
 
 	/* Port based VLAN map: give each port the same default address
diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 2f224b166bbb..6ceb9478309f 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1088,7 +1088,7 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
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
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index e5f156940c67..d1ca3bb03858 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -273,12 +273,12 @@ static void dsa_tree_put(struct dsa_switch_tree *dst)
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
@@ -314,14 +314,13 @@ static bool dsa_port_setup_routing_table(struct dsa_port *dp)
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
@@ -366,14 +365,17 @@ static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
 
 struct net_device *dsa_tree_find_first_master(struct dsa_switch_tree *dst)
 {
-	struct device_node *ethernet;
+	struct fwnode_handle *ethernet;
 	struct net_device *master;
 	struct dsa_port *cpu_dp;
 
 	cpu_dp = dsa_tree_find_first_cpu(dst);
-	ethernet = of_parse_phandle(cpu_dp->dn, "ethernet", 0);
-	master = of_find_net_device_by_node(ethernet);
-	of_node_put(ethernet);
+	ethernet = fwnode_find_reference(cpu_dp->fwnode, "ethernet", 0);
+	if (IS_ERR(ethernet))
+		return NULL;
+
+	master = of_find_net_device_by_node(to_of_node(ethernet));
+	fwnode_handle_put(ethernet);
 
 	return master;
 }
@@ -457,8 +459,8 @@ static int dsa_port_setup(struct dsa_port *dp)
 		dsa_port_disable(dp);
 		break;
 	case DSA_PORT_TYPE_CPU:
-		if (dp->dn) {
-			err = dsa_shared_port_link_register_of(dp);
+		if (dp->fwnode) {
+			err = dsa_shared_port_link_register_fw(dp);
 			if (err)
 				break;
 			dsa_port_link_registered = true;
@@ -475,8 +477,8 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 		break;
 	case DSA_PORT_TYPE_DSA:
-		if (dp->dn) {
-			err = dsa_shared_port_link_register_of(dp);
+		if (dp->fwnode) {
+			err = dsa_shared_port_link_register_fw(dp);
 			if (err)
 				break;
 			dsa_port_link_registered = true;
@@ -493,7 +495,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 		break;
 	case DSA_PORT_TYPE_USER:
-		of_get_mac_address(dp->dn, dp->mac);
+		fwnode_get_mac_address(dp->fwnode, dp->mac);
 		err = dsa_slave_create(dp);
 		break;
 	}
@@ -501,7 +503,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (err && dsa_port_enabled)
 		dsa_port_disable(dp);
 	if (err && dsa_port_link_registered)
-		dsa_shared_port_link_unregister_of(dp);
+		dsa_shared_port_link_unregister_fw(dp);
 	if (err) {
 		dsa_port_devlink_teardown(dp);
 		return err;
@@ -522,13 +524,13 @@ static void dsa_port_teardown(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_CPU:
 		dsa_port_disable(dp);
-		if (dp->dn)
-			dsa_shared_port_link_unregister_of(dp);
+		if (dp->fwnode)
+			dsa_shared_port_link_unregister_fw(dp);
 		break;
 	case DSA_PORT_TYPE_DSA:
 		dsa_port_disable(dp);
-		if (dp->dn)
-			dsa_shared_port_link_unregister_of(dp);
+		if (dp->fwnode)
+			dsa_shared_port_link_unregister_fw(dp);
 		break;
 	case DSA_PORT_TYPE_USER:
 		if (dp->slave) {
@@ -603,7 +605,7 @@ static void dsa_switch_teardown_tag_protocol(struct dsa_switch *ds)
 
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
-	struct device_node *dn;
+	struct fwnode_handle *fwnode;
 	int err;
 
 	if (ds->setup)
@@ -643,10 +645,10 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
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
@@ -1216,24 +1218,31 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
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
 
-	dp->dn = dn;
+	fwnode_property_read_string(fwnode, "label", &name);
 
-	if (ethernet) {
+	dp->fwnode = fwnode;
+
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
 
@@ -1243,61 +1252,61 @@ static int dsa_port_parse_of(struct dsa_port *dp, struct device_node *dn)
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
 
@@ -1334,11 +1343,11 @@ static int dsa_switch_touch_ports(struct dsa_switch *ds)
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
 
@@ -1346,7 +1355,7 @@ static int dsa_switch_parse_of(struct dsa_switch *ds, struct device_node *dn)
 	if (err)
 		return err;
 
-	return dsa_switch_parse_ports_of(ds, dn);
+	return dsa_switch_parse_ports_fw(ds, fwnode);
 }
 
 static int dev_is_class(struct device *dev, void *class)
@@ -1475,20 +1484,20 @@ static int dsa_switch_probe(struct dsa_switch *ds)
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
index 67ad1adec2a2..8f5793f87f40 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -6,11 +6,10 @@
  *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
  */
 
+#include <linux/fwnode_mdio.h>
 #include <linux/if_bridge.h>
 #include <linux/netdevice.h>
 #include <linux/notifier.h>
-#include <linux/of_mdio.h>
-#include <linux/of_net.h>
 
 #include "dsa.h"
 #include "port.h"
@@ -1535,20 +1534,20 @@ void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 
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
 
@@ -1678,12 +1677,11 @@ static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 int dsa_port_phylink_create(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
-	phy_interface_t mode;
 	struct phylink *pl;
-	int err;
+	int mode;
 
-	err = of_get_phy_mode(dp->dn, &mode);
-	if (err)
+	mode = fwnode_get_phy_mode(dp->fwnode);
+	if (mode < 0)
 		mode = PHY_INTERFACE_MODE_NA;
 
 	/* Presence of phylink_mac_link_state or phylink_mac_an_restart is
@@ -1696,7 +1694,7 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	if (ds->ops->phylink_get_caps)
 		ds->ops->phylink_get_caps(ds, dp->index, &dp->pl_config);
 
-	pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
+	pl = phylink_create(&dp->pl_config, dp->fwnode,
 			    mode, &dsa_port_phylink_mac_ops);
 	if (IS_ERR(pl)) {
 		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(pl));
@@ -1714,7 +1712,7 @@ void dsa_port_phylink_destroy(struct dsa_port *dp)
 	dp->pl = NULL;
 }
 
-static int dsa_shared_port_setup_phy_of(struct dsa_port *dp, bool enable)
+static int dsa_shared_port_setup_phy_fw(struct dsa_port *dp, bool enable)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct phy_device *phydev;
@@ -1752,16 +1750,15 @@ static int dsa_shared_port_setup_phy_of(struct dsa_port *dp, bool enable)
 	return err;
 }
 
-static int dsa_shared_port_fixed_link_register_of(struct dsa_port *dp)
+static int dsa_shared_port_fixed_link_register_fw(struct dsa_port *dp)
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
@@ -1769,10 +1766,10 @@ static int dsa_shared_port_fixed_link_register_of(struct dsa_port *dp)
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
 
@@ -1789,7 +1786,6 @@ static int dsa_shared_port_fixed_link_register_of(struct dsa_port *dp)
 static int dsa_shared_port_phylink_register(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
-	struct device_node *port_dn = dp->dn;
 	int err;
 
 	dp->pl_config.dev = ds->dev;
@@ -1799,7 +1795,7 @@ static int dsa_shared_port_phylink_register(struct dsa_port *dp)
 	if (err)
 		return err;
 
-	err = phylink_of_phy_connect(dp->pl, port_dn, 0);
+	err = phylink_fwnode_phy_connect(dp->pl, dp->fwnode, 0);
 	if (err && err != -ENODEV) {
 		pr_err("could not attach to PHY: %d\n", err);
 		goto err_phy_connect;
@@ -1926,51 +1922,50 @@ static const char * const dsa_switches_apply_workarounds[] = {
 	NULL,
 };
 
-static void dsa_shared_port_validate_of(struct dsa_port *dp,
+static void dsa_shared_port_validate_fw(struct dsa_port *dp,
 					bool *missing_phy_mode,
 					bool *missing_link_description)
 {
-	struct device_node *dn = dp->dn, *phy_np;
+	struct fwnode_handle *phy_handle;
 	struct dsa_switch *ds = dp->ds;
-	phy_interface_t mode;
 
 	*missing_phy_mode = false;
 	*missing_link_description = false;
 
-	if (of_get_phy_mode(dn, &mode)) {
+	if (fwnode_get_phy_mode(dp->fwnode) < 0) {
 		*missing_phy_mode = true;
 		dev_err(ds->dev,
-			"OF node %pOF of %s port %d lacks the required \"phy-mode\" property\n",
-			dn, dsa_port_is_cpu(dp) ? "CPU" : "DSA", dp->index);
+			"FW node %p of %s port %d lacks the required \"phy-mode\" property\n",
+			dp->fwnode, dsa_port_is_cpu(dp) ? "CPU" : "DSA", dp->index);
 	}
 
-	/* Note: of_phy_is_fixed_link() also returns true for
+	/* Note: fwnode_phy_is_fixed_link() also returns true for
 	 * managed = "in-band-status"
 	 */
-	if (of_phy_is_fixed_link(dn))
+	if (fwnode_phy_is_fixed_link(dp->fwnode))
 		return;
 
-	phy_np = of_parse_phandle(dn, "phy-handle", 0);
-	if (phy_np) {
-		of_node_put(phy_np);
+	phy_handle = fwnode_find_reference(dp->fwnode, "phy-handle", 0);
+	if (!IS_ERR(phy_handle)) {
+		fwnode_handle_put(phy_handle);
 		return;
 	}
 
 	*missing_link_description = true;
 
 	dev_err(ds->dev,
-		"OF node %pOF of %s port %d lacks the required \"phy-handle\", \"fixed-link\" or \"managed\" properties\n",
-		dn, dsa_port_is_cpu(dp) ? "CPU" : "DSA", dp->index);
+		"FW node %p of %s port %d lacks the required \"phy-handle\", \"fixed-link\" or \"managed\" properties\n",
+		dp->fwnode, dsa_port_is_cpu(dp) ? "CPU" : "DSA", dp->index);
 }
 
-int dsa_shared_port_link_register_of(struct dsa_port *dp)
+int dsa_shared_port_link_register_fw(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	bool missing_link_description;
 	bool missing_phy_mode;
 	int port = dp->index;
 
-	dsa_shared_port_validate_of(dp, &missing_phy_mode,
+	dsa_shared_port_validate_fw(dp, &missing_phy_mode,
 				    &missing_link_description);
 
 	if ((missing_phy_mode || missing_link_description) &&
@@ -1996,13 +1991,13 @@ int dsa_shared_port_link_register_of(struct dsa_port *dp)
 	dev_warn(ds->dev,
 		 "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
 
-	if (of_phy_is_fixed_link(dp->dn))
-		return dsa_shared_port_fixed_link_register_of(dp);
+	if (fwnode_phy_is_fixed_link(dp->fwnode))
+		return dsa_shared_port_fixed_link_register_fw(dp);
 	else
-		return dsa_shared_port_setup_phy_of(dp, true);
+		return dsa_shared_port_setup_phy_fw(dp, true);
 }
 
-void dsa_shared_port_link_unregister_of(struct dsa_port *dp)
+void dsa_shared_port_link_unregister_fw(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 
@@ -2014,10 +2009,10 @@ void dsa_shared_port_link_unregister_of(struct dsa_port *dp)
 		return;
 	}
 
-	if (of_phy_is_fixed_link(dp->dn))
-		of_phy_deregister_fixed_link(dp->dn);
+	if (fwnode_phy_is_fixed_link(dp->fwnode))
+		fwnode_phy_deregister_fixed_link(dp->fwnode);
 	else
-		dsa_shared_port_setup_phy_of(dp, false);
+		dsa_shared_port_setup_phy_fw(dp, false);
 }
 
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index aab79c355224..fb150a543c30 100644
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
@@ -2309,7 +2307,6 @@ static int dsa_slave_phy_connect(struct net_device *slave_dev, int addr,
 static int dsa_slave_phy_setup(struct net_device *slave_dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(slave_dev);
-	struct device_node *port_dn = dp->dn;
 	struct dsa_switch *ds = dp->ds;
 	u32 phy_flags = 0;
 	int ret;
@@ -2333,7 +2330,7 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 	if (ds->ops->get_phy_flags)
 		phy_flags = ds->ops->get_phy_flags(ds, dp->index);
 
-	ret = phylink_of_phy_connect(dp->pl, port_dn, phy_flags);
+	ret = phylink_fwnode_phy_connect(dp->pl, dp->fwnode, phy_flags);
 	if (ret == -ENODEV && ds->slave_mii_bus) {
 		/* We could not connect to a designated PHY or SFP, so try to
 		 * use the switch internal MDIO bus instead
@@ -2455,7 +2452,7 @@ int dsa_slave_create(struct dsa_port *port)
 
 	SET_NETDEV_DEV(slave_dev, port->ds->dev);
 	SET_NETDEV_DEVLINK_PORT(slave_dev, &port->devlink_port);
-	slave_dev->dev.of_node = port->dn;
+	device_set_node(&slave_dev->dev, port->fwnode);
 	slave_dev->vlan_features = master->vlan_features;
 
 	p = netdev_priv(slave_dev);
-- 
2.29.0

