Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047E63A310D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhFJQoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:44:16 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:36848 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbhFJQno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:43:44 -0400
Received: by mail-ed1-f47.google.com with SMTP id w21so33743944edv.3;
        Thu, 10 Jun 2021 09:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yvHFyQ/agosabwkcKUcNoOmx65V0N/UbwYIAHR5bR5w=;
        b=GPsbG6YiuA0hWWC6GQYoQLw98R+dnbg3lepYbmDUS/B+uLwtN/p+3iM2p/31MGfN87
         SbCnDYQ6uT87nDYVV9poNQSYTeRXmCQDHAjPOU4A9La2dgdmR+ocC6Yqx18lqY4aEsU6
         EEuWO3QqF21w2h+umfMXuLkvQDhxLDcM7iaOQz2ysjQtJziE4I7oEucWw3G04IZUF+zL
         H8oVocPk+73eXnDH8D1MLhViZotjm/ArsEWUAgvePPXgBYVq/Vw3D9fTubMXOKBrEhK8
         6R1f4rCi99wttsYibEfWCIX82e0AG63/as9+gITtxcrw+V/PKap2EwCe/REeJuqGJRYZ
         GvZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yvHFyQ/agosabwkcKUcNoOmx65V0N/UbwYIAHR5bR5w=;
        b=TXNJiToszVT+JXOH3YD95s8gMx6GbCXwyDMUdrxRUUDYXjgG1WsETUpCdcdXNn8LcH
         U1qm6wdxJtA6xJQlLKG8/C+bnjfvPIbuKm8/1GGGYoJ/dXhOnDEeygqu/7/VahNeXBAs
         ATBmAwOK7sdXXU/0YW4K/ZLKFgJuQdUr+46ovmuoOdkhpvyBpfheHUxESU0mTMEsmxgG
         kgKoHnZ+wHhAKtmay1SWRd8CW8GiSasJLA23r2AbbOhL6BNOgHAWnKZJhbIYWqb6EoC4
         1Q2G/mjQu97SFwnz1BLwzIHjIFOxkg+b62vLyZgawtUk69K2en7g2wNFaXK1QSQHnNSu
         JgdQ==
X-Gm-Message-State: AOAM5336ekZswKI1bdlL02UvEoPV0nOvfT+iOZy0vbXoAmt7luNAnTWq
        crcL5BFtO1z+N+Sl8RD2798=
X-Google-Smtp-Source: ABdhPJxKWEyLvrBNQBzGx/LDQrqfxoDGWqOMvSzIDoHJQ2idKxwuEt6UqvBSrJJweVxZG19zuf6VTQ==
X-Received: by 2002:a05:6402:5256:: with SMTP id t22mr404335edd.54.1623343246463;
        Thu, 10 Jun 2021 09:40:46 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e22sm1657166edv.57.2021.06.10.09.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:40:46 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, calvin.johnson@nxp.com
Cc:     Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v8 15/15] net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
Date:   Thu, 10 Jun 2021 19:39:17 +0300
Message-Id: <20210610163917.4138412-16-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Modify dpaa2_mac_get_node() to get the dpmac fwnode from either
DT or ACPI.

Modify dpaa2_mac_get_if_mode() to get interface mode from dpmac_node
which is a fwnode.

Modify dpaa2_pcs_create() to create pcs from dpmac_node fwnode.

Modify dpaa2_mac_connect() to support ACPI along with DT.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---

Changes in v8:
- adjust code over latest changes applied on the driver

Changes in v7:
- remove unnecassary checks

Changes in v6:
- use dev_fwnode()
- remove useless else
- replace of_device_is_available() to fwnode_device_is_available()

Changes in v5:
- replace fwnode_get_id() with OF and ACPI function calls

Changes in v4: None
Changes in v3: None
Changes in v2:
- Refactor OF functions to use fwnode functions

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 88 +++++++++++--------
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  2 +-
 2 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 4dfadf2b70d6..ae6d382d8735 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -1,6 +1,9 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2019 NXP */
 
+#include <linux/acpi.h>
+#include <linux/property.h>
+
 #include "dpaa2-eth.h"
 #include "dpaa2-mac.h"
 
@@ -34,39 +37,51 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 	return 0;
 }
 
-/* Caller must call of_node_put on the returned value */
-static struct device_node *dpaa2_mac_get_node(u16 dpmac_id)
+static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
+						u16 dpmac_id)
 {
-	struct device_node *dpmacs, *dpmac = NULL;
-	u32 id;
+	struct fwnode_handle *fwnode, *parent, *child  = NULL;
+	struct device_node *dpmacs = NULL;
 	int err;
+	u32 id;
 
-	dpmacs = of_find_node_by_name(NULL, "dpmacs");
-	if (!dpmacs)
-		return NULL;
+	fwnode = dev_fwnode(dev->parent);
+	if (is_of_node(fwnode)) {
+		dpmacs = of_find_node_by_name(NULL, "dpmacs");
+		if (!dpmacs)
+			return NULL;
+		parent = of_fwnode_handle(dpmacs);
+	} else if (is_acpi_node(fwnode)) {
+		parent = fwnode;
+	}
 
-	while ((dpmac = of_get_next_child(dpmacs, dpmac)) != NULL) {
-		err = of_property_read_u32(dpmac, "reg", &id);
+	fwnode_for_each_child_node(parent, child) {
+		err = -EINVAL;
+		if (is_acpi_device_node(child))
+			err = acpi_get_local_address(ACPI_HANDLE_FWNODE(child), &id);
+		else if (is_of_node(child))
+			err = of_property_read_u32(to_of_node(child), "reg", &id);
 		if (err)
 			continue;
-		if (id == dpmac_id)
-			break;
-	}
 
+		if (id == dpmac_id) {
+			of_node_put(dpmacs);
+			return child;
+		}
+	}
 	of_node_put(dpmacs);
-
-	return dpmac;
+	return NULL;
 }
 
-static int dpaa2_mac_get_if_mode(struct device_node *node,
+static int dpaa2_mac_get_if_mode(struct fwnode_handle *dpmac_node,
 				 struct dpmac_attr attr)
 {
 	phy_interface_t if_mode;
 	int err;
 
-	err = of_get_phy_mode(node, &if_mode);
-	if (!err)
-		return if_mode;
+	err = fwnode_get_phy_mode(dpmac_node);
+	if (err > 0)
+		return err;
 
 	err = phy_mode(attr.eth_if, &if_mode);
 	if (!err)
@@ -235,26 +250,27 @@ static const struct phylink_mac_ops dpaa2_mac_phylink_ops = {
 };
 
 static int dpaa2_pcs_create(struct dpaa2_mac *mac,
-			    struct device_node *dpmac_node, int id)
+			    struct fwnode_handle *dpmac_node,
+			    int id)
 {
 	struct mdio_device *mdiodev;
-	struct device_node *node;
+	struct fwnode_handle *node;
 
-	node = of_parse_phandle(dpmac_node, "pcs-handle", 0);
-	if (!node) {
+	node = fwnode_find_reference(dpmac_node, "pcs-handle", 0);
+	if (IS_ERR(node)) {
 		/* do not error out on old DTS files */
 		netdev_warn(mac->net_dev, "pcs-handle node not found\n");
 		return 0;
 	}
 
-	if (!of_device_is_available(node)) {
+	if (!fwnode_device_is_available(node)) {
 		netdev_err(mac->net_dev, "pcs-handle node not available\n");
-		of_node_put(node);
+		fwnode_handle_put(node);
 		return -ENODEV;
 	}
 
-	mdiodev = of_mdio_find_device(node);
-	of_node_put(node);
+	mdiodev = fwnode_mdio_find_device(node);
+	fwnode_handle_put(node);
 	if (!mdiodev)
 		return -EPROBE_DEFER;
 
@@ -283,13 +299,13 @@ static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
 	struct net_device *net_dev = mac->net_dev;
-	struct device_node *dpmac_node;
+	struct fwnode_handle *dpmac_node;
 	struct phylink *phylink;
 	int err;
 
 	mac->if_link_type = mac->attr.link_type;
 
-	dpmac_node = mac->of_node;
+	dpmac_node = mac->fw_node;
 	if (!dpmac_node) {
 		netdev_err(net_dev, "No dpmac@%d node found.\n", mac->attr.id);
 		return -ENODEV;
@@ -304,7 +320,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	 * error out if the interface mode requests them and there is no PHY
 	 * to act upon them
 	 */
-	if (of_phy_is_fixed_link(dpmac_node) &&
+	if (of_phy_is_fixed_link(to_of_node(dpmac_node)) &&
 	    (mac->if_mode == PHY_INTERFACE_MODE_RGMII_ID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_TXID)) {
@@ -324,7 +340,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	mac->phylink_config.type = PHYLINK_NETDEV;
 
 	phylink = phylink_create(&mac->phylink_config,
-				 of_fwnode_handle(dpmac_node), mac->if_mode,
+				 dpmac_node, mac->if_mode,
 				 &dpaa2_mac_phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
@@ -335,9 +351,9 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	if (mac->pcs)
 		phylink_set_pcs(mac->phylink, &mac->pcs->pcs);
 
-	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
+	err = phylink_fwnode_phy_connect(mac->phylink, dpmac_node, 0);
 	if (err) {
-		netdev_err(net_dev, "phylink_of_phy_connect() = %d\n", err);
+		netdev_err(net_dev, "phylink_fwnode_phy_connect() = %d\n", err);
 		goto err_phylink_destroy;
 	}
 
@@ -384,8 +400,8 @@ int dpaa2_mac_open(struct dpaa2_mac *mac)
 	/* Find the device node representing the MAC device and link the device
 	 * behind the associated netdev to it.
 	 */
-	mac->of_node = dpaa2_mac_get_node(mac->attr.id);
-	net_dev->dev.of_node = mac->of_node;
+	mac->fw_node = dpaa2_mac_get_node(&mac->mc_dev->dev, mac->attr.id);
+	net_dev->dev.of_node = to_of_node(mac->fw_node);
 
 	return 0;
 
@@ -399,8 +415,8 @@ void dpaa2_mac_close(struct dpaa2_mac *mac)
 	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
 
 	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
-	if (mac->of_node)
-		of_node_put(mac->of_node);
+	if (mac->fw_node)
+		fwnode_handle_put(mac->fw_node);
 }
 
 static char dpaa2_mac_ethtool_stats[][ETH_GSTRING_LEN] = {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
index 8ebcb3420d02..7842cbb2207a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -24,7 +24,7 @@ struct dpaa2_mac {
 	phy_interface_t if_mode;
 	enum dpmac_link_type if_link_type;
 	struct lynx_pcs *pcs;
-	struct device_node *of_node;
+	struct fwnode_handle *fw_node;
 };
 
 bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
-- 
2.31.1

