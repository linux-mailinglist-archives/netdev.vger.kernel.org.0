Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98AE9552009
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243484AbiFTPMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241371AbiFTPMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:12:09 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC9AFF
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:49 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id w9so3199928lji.4
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e2Cd3eQM+C0dmzMqQNndhsAzgMvOaojaEFbBvNt2Fic=;
        b=Y4nEEPRsmVHDrSrrfoAQXg2HXs8O1oRslQ0rXWFDmT1MQg4bHUJL2uHX/OOCRvZAW4
         2S6o+7TVjw/ERDVOILwrSaPS//OM63T7tfMQ4K/VVBbwUrIjCmSeHYpfukvEnXSaH3GS
         g9RopuRsVEIfV6WG/l0vQ8Q8QjuOD79ofy6E9L+ud6q0kHSVqfMLkHrRPYzRV83RZdXv
         182nkIlpjYjDUe6WaGf4cfvKkOVyzgEpWJBMRJVB5+qoNl/WL0IOIaE6l2MgkrQsuYHU
         C3O/mpbvUhWnVF473pNgkRNOL/MnwEH2NvhmlPAS7T0YMgj854Mca35OKYj/8+gOunDY
         8qiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e2Cd3eQM+C0dmzMqQNndhsAzgMvOaojaEFbBvNt2Fic=;
        b=1gnUB9JZIDiaM1EveTF9K+tf0b9mYN4oBAnGtvttKdRgsksGxXiMuwmGVoCyertr2r
         CVQik7ppw7ISYQ0aZhO0eNCgPGjRVXoWk4PBbYIpOWYdthbhZftWpqjxABhS4aZBb6He
         RL1TJvhUYEh0UyusQA/3PaKcw8cIresu6f23iWdvm0N3ZzcoVNsz9G7HWH3FywHuV2oG
         2K8vFa7Ng2bBzwuwnPtKgCd685H5NY3WXgCOqcvpzsPLUVWjFcepu38hME6A8yNN1bUL
         rLD7KDvhfRa9z/NC1C8Xrhu/Yzf7YVOuqDtQSEWmLcSmemLZJXXDh8Sx1jsd7CUp7vFL
         stVw==
X-Gm-Message-State: AJIora/1m27oTqp/MCVemzGSU1LjF5ftY9NUkGqNsCrrQh3nbVMEEFbE
        NwqG/74B6ugF672hdgHH0Ed4NQ==
X-Google-Smtp-Source: AGRyM1sssAdqhBLIlWixMfcjN1PbIhBI1R2jYI1eP+BdaY9z+Y9WaAwKpF25q33k5Pl/owqtSeU3RA==
X-Received: by 2002:a2e:a289:0:b0:258:e917:36a4 with SMTP id k9-20020a2ea289000000b00258e91736a4mr11965710lja.510.1655737367628;
        Mon, 20 Jun 2022 08:02:47 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e19-20020a05651236d300b0047f79f7758asm17564lfs.22.2022.06.20.08.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:02:47 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        lenb@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: [net-next: PATCH 03/12] net: dsa: switch to device_/fwnode_ APIs
Date:   Mon, 20 Jun 2022 17:02:16 +0200
Message-Id: <20220620150225.1307946-4-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220620150225.1307946-1-mw@semihalf.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support both ACPI and DT, modify the generic
DSA code to use device_/fwnode_ equivalent routines.
No functional change is introduced by this patch.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 include/net/dsa.h |  1 +
 net/dsa/dsa2.c    | 76 +++++++++++---------
 net/dsa/port.c    | 54 +++++++-------
 net/dsa/slave.c   |  6 +-
 4 files changed, 71 insertions(+), 66 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 14f07275852b..692c1dddc5f8 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -299,6 +299,7 @@ struct dsa_port {
 	u8			setup:1;
 
 	struct device_node	*dn;
+	struct fwnode_handle    *fwnode;
 	unsigned int		ageing_time;
 
 	struct dsa_bridge	*bridge;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cac48a741f27..039022bf914b 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -493,7 +493,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 		break;
 	case DSA_PORT_TYPE_USER:
-		of_get_mac_address(dp->dn, dp->mac);
+		fwnode_get_mac_address(dp->fwnode, dp->mac);
 		err = dsa_slave_create(dp);
 		if (err)
 			break;
@@ -853,7 +853,7 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
 	struct dsa_devlink_priv *dl_priv;
-	struct device_node *dn;
+	struct fwnode_handle *fwnode;
 	struct dsa_port *dp;
 	int err;
 
@@ -909,10 +909,10 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
 		dsa_slave_mii_bus_init(ds);
 
-		dn = of_get_child_by_name(ds->dev->of_node, "mdio");
+		fwnode = fwnode_get_named_child_node(ds->dev->fwnode, "mdio");
 
-		err = of_mdiobus_register(ds->slave_mii_bus, dn);
-		of_node_put(dn);
+		err = of_mdiobus_register(ds->slave_mii_bus, to_of_node(fwnode));
+		fwnode_handle_put(fwnode);
 		if (err < 0)
 			goto free_slave_mii_bus;
 	}
@@ -1482,24 +1482,34 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 	return 0;
 }
 
-static int dsa_port_parse_of(struct dsa_port *dp, struct device_node *dn)
+static int dsa_port_parse_of(struct dsa_port *dp, struct fwnode_handle *fwnode)
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
+	dp->dn = to_of_node(fwnode);
 
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
 
@@ -1510,34 +1520,34 @@ static int dsa_port_parse_of(struct dsa_port *dp, struct device_node *dn)
 }
 
 static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
-				     struct device_node *dn)
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
@@ -1546,24 +1556,24 @@ static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
 
 		err = dsa_port_parse_of(dp, port);
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
 
 static int dsa_switch_parse_member_of(struct dsa_switch *ds,
-				      struct device_node *dn)
+				      struct fwnode_handle *fwnode)
 {
 	u32 m[2] = { 0, 0 };
 	int sz;
 
 	/* Don't error out if this optional property isn't found */
-	sz = of_property_read_variable_u32_array(dn, "dsa,member", m, 2, 2);
+	sz = fwnode_property_read_u32_array(fwnode, "dsa,member", m, 2);
 	if (sz < 0 && sz != -EINVAL)
 		return sz;
 
@@ -1600,11 +1610,11 @@ static int dsa_switch_touch_ports(struct dsa_switch *ds)
 	return 0;
 }
 
-static int dsa_switch_parse_of(struct dsa_switch *ds, struct device_node *dn)
+static int dsa_switch_parse_of(struct dsa_switch *ds, struct fwnode_handle *fwnode)
 {
 	int err;
 
-	err = dsa_switch_parse_member_of(ds, dn);
+	err = dsa_switch_parse_member_of(ds, fwnode);
 	if (err)
 		return err;
 
@@ -1612,7 +1622,7 @@ static int dsa_switch_parse_of(struct dsa_switch *ds, struct device_node *dn)
 	if (err)
 		return err;
 
-	return dsa_switch_parse_ports_of(ds, dn);
+	return dsa_switch_parse_ports_of(ds, fwnode);
 }
 
 static int dsa_port_parse(struct dsa_port *dp, const char *name,
@@ -1705,20 +1715,20 @@ static int dsa_switch_probe(struct dsa_switch *ds)
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
+	fwnode = ds->dev->fwnode;
 
 	if (!ds->num_ports)
 		return -EINVAL;
 
-	if (np) {
-		err = dsa_switch_parse_of(ds, np);
+	if (fwnode) {
+		err = dsa_switch_parse_of(ds, fwnode);
 		if (err)
 			dsa_switch_release_ports(ds);
 	} else if (pdata) {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 3738f2d40a0b..a0e46e276de0 100644
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
 
@@ -1524,11 +1523,10 @@ static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
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
@@ -1541,7 +1539,7 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	if (ds->ops->phylink_get_caps)
 		ds->ops->phylink_get_caps(ds, dp->index, &dp->pl_config);
 
-	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
+	dp->pl = phylink_create(&dp->pl_config, dp->fwnode,
 				mode, &dsa_port_phylink_mac_ops);
 	if (IS_ERR(dp->pl)) {
 		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
@@ -1591,14 +1589,13 @@ static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
 
 static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
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
@@ -1606,10 +1603,10 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
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
 
@@ -1626,7 +1623,6 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
 static int dsa_port_phylink_register(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
-	struct device_node *port_dn = dp->dn;
 	int err;
 
 	dp->pl_config.dev = ds->dev;
@@ -1636,7 +1632,7 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 	if (err)
 		return err;
 
-	err = phylink_of_phy_connect(dp->pl, port_dn, 0);
+	err = phylink_fwnode_phy_connect(dp->pl, dp->fwnode, 0);
 	if (err && err != -ENODEV) {
 		pr_err("could not attach to PHY: %d\n", err);
 		goto err_phy_connect;
@@ -1651,27 +1647,27 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 
 int dsa_port_link_register_of(struct dsa_port *dp)
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
+	if (fwnode_phy_is_fixed_link(dp->fwnode))
 		return dsa_port_fixed_link_register_of(dp);
 	else
 		return dsa_port_setup_phy_of(dp, true);
@@ -1690,8 +1686,8 @@ void dsa_port_link_unregister_of(struct dsa_port *dp)
 		return;
 	}
 
-	if (of_phy_is_fixed_link(dp->dn))
-		of_phy_deregister_fixed_link(dp->dn);
+	if (fwnode_phy_is_fixed_link(dp->fwnode))
+		fwnode_phy_deregister_fixed_link(dp->fwnode);
 	else
 		dsa_port_setup_phy_of(dp, false);
 }
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2e1ac638d135..b801795d73a6 100644
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
@@ -2204,7 +2202,6 @@ static int dsa_slave_phy_connect(struct net_device *slave_dev, int addr,
 static int dsa_slave_phy_setup(struct net_device *slave_dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(slave_dev);
-	struct device_node *port_dn = dp->dn;
 	struct dsa_switch *ds = dp->ds;
 	u32 phy_flags = 0;
 	int ret;
@@ -2228,7 +2225,7 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 	if (ds->ops->get_phy_flags)
 		phy_flags = ds->ops->get_phy_flags(ds, dp->index);
 
-	ret = phylink_of_phy_connect(dp->pl, port_dn, phy_flags);
+	ret = phylink_fwnode_phy_connect(dp->pl, dp->fwnode, phy_flags);
 	if (ret == -ENODEV && ds->slave_mii_bus) {
 		/* We could not connect to a designated PHY or SFP, so try to
 		 * use the switch internal MDIO bus instead
@@ -2341,6 +2338,7 @@ int dsa_slave_create(struct dsa_port *port)
 
 	SET_NETDEV_DEV(slave_dev, port->ds->dev);
 	slave_dev->dev.of_node = port->dn;
+	slave_dev->dev.fwnode = port->fwnode;
 	slave_dev->vlan_features = master->vlan_features;
 
 	p = netdev_priv(slave_dev);
-- 
2.29.0

