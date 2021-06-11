Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5061E3A409A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhFKK60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhFKK5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:57:41 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223BFC0617AF;
        Fri, 11 Jun 2021 03:55:30 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id c10so3885975eja.11;
        Fri, 11 Jun 2021 03:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YxWK5rDm9HOhsUcOPl3aQTEbE17JeYf9sqBtDE4EGxE=;
        b=SFcMBx4Hi4WbE4lhBKebID8gDeKdRdsSNw2vGOimAVWZKBPSzt64mXMsb+mrC18ek0
         zR9QrDzoBe9OLYbt660ap3Pf3RC4qgerbZZhQt8S17ivwCczVfI4pHhjSnrVgJnug/pC
         G+g/NDAUZQA5GPhTJWkAObFiCHdN6Sim5/KabHuFzYfSo0XOGIDAE99UMME0MChIbrd0
         C1J6TJR2U/ao7NMB/II9B6dEA9rnVNPbDs/8ZEo0swOPLx9JxTyQQCL+K32nRaAsaeE4
         cGsI3uv9BgylsQDSG38EeKrlKdbw5vcCJHxczDb0NIRhBUzBxqsJYm0Enjz5JRPeaWq5
         bzaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YxWK5rDm9HOhsUcOPl3aQTEbE17JeYf9sqBtDE4EGxE=;
        b=fKy4VST/V9I54H8k4l6CeplDvI9wVfgLRqfacu1cQVIN+w0ivYTgyEzv48QE9mENQ8
         SYRou3Ayxm1RDB5pwiN1bOKPFQZt9pZ3cRTvxXew4eH9mx3wsJ5a+++ZzLVjE9EbOOm3
         Sdomrsb+mD2Cg18e0M/Dspn8MTYwaw5dR6yOp8iOV9hvxDVeKgKBUCQ92Tr48TQ7HDuq
         uY3zVfeRh4PHW6AuhbY4MfmErr5+H/OWc5prHUhCTuNttw9t+upWh8PvjIWIFMARH/2L
         pnbbYFYdrVC+HE9uDzvnXb9nvdBn98SQefs3wQVM4zSbx1gDjQ2CJ/3HL6aOWu4p4N8h
         wVMA==
X-Gm-Message-State: AOAM530EkypFyrNFrivvlx9XC1GB1YXq9smkfJKCp79/zQjNhWEXV564
        9KafPS1uVO5bt0BLYaYptnI=
X-Google-Smtp-Source: ABdhPJwgFNR9TF+9X/SfzT7KoERKiH8g7zAUEk/h2YpN0qIaw8ANxavHgXesaeFxziQFw6U8AKGYrA==
X-Received: by 2002:a17:906:c141:: with SMTP id dp1mr3212241ejc.87.1623408928645;
        Fri, 11 Jun 2021 03:55:28 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r19sm2492051eds.75.2021.06.11.03.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:55:28 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, Grant Likely <grant.likely@arm.com>,
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
        Randy Dunlap <rdunlap@infradead.org>,
        calvin.johnson@oss.nxp.com
Cc:     Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v9 15/15] net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
Date:   Fri, 11 Jun 2021 13:54:01 +0300
Message-Id: <20210611105401.270673-16-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105401.270673-1-ciorneiioana@gmail.com>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
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
Acked-by: Rafael J. Wysocki <rafael@kernel.org> # from the ACPI side
Acked-by: Grant Likely <grant.likely@arm.com>
---

Changes in v9: None
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

