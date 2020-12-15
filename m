Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B9A2DB1D9
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731138AbgLOQr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:47:29 -0500
Received: from mail-eopbgr20074.outbound.protection.outlook.com ([40.107.2.74]:21124
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731124AbgLOQrR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:47:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4RhQTziVVhMWQUJTXnNcZVOAwLh92ixgpBde/b+wKb0ULJ1vjF37JC6BGZ7KJRA0s5oei4C8JTFfP2iZmr4ld96dd7HcXFrd3Tr5fFZ+VyfsuPdgW4NWt6hgnlbLyVlJh+tzf4tx4duMuWQCXd5/tytBUMrk5bP/SxqExSj+tiaWJIgTIjCqqNJzKud9iKCcZNOzCTtKIvoLolHSJWb6Fr+imnhw4cXc3X71MqBzzqdra9HapdNHf6Nbk7Eax9ctgHhaIxuYSGno2u/lrHNwJCNQPMDJANOlZhCy4iGpq4hdIP7UDoGcWgJqY4Tsg/OHhWYK6qRS2ti1MIsADqNIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMRbpQD0LVMf6T7TrGvafn1q8NLPEbIyAAG44pHcTDk=;
 b=b2JkVvdJz/AgJ451vS4FBbuucrA8HFLRn7XDyZKHgk1qv7pnnKzj69gZ0W1VU1Ru7GDUJ+5kTs+C/2jU1XMUQlYT8qlCFqY7wdBrNJOgyAlgtWVB0IpTOjIqiTsB5F922+TO1fOBK57FO4SfWJGSvO0w4fvcqoke+PiA/m1QKxF+VjqkgvlM0fiNovSqEdMn7F8KClkrBPAqhqwtoi4J8oVFIJhMoRjBSecJhomoAaeVi0O+aO0RKsYtXkNqRlN3v5UYpII/n8fT0IEdDjf94S50o14KH59fyg41w4Mx2vy3bTdcuo2JFb0c1EdKsVfPKXoz23NzohDeXnKoqb2JKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMRbpQD0LVMf6T7TrGvafn1q8NLPEbIyAAG44pHcTDk=;
 b=gQsqxxG2KgNDFf2atX344OaqJn2STyyT/09V2u7AOj8YwcaWfJKgItxhzoBmuGSVLIzGGcyK5saKX4ZxYBk1YV7Il+9bO3n/TsbC+37MTVMy0U7yjRT5fiikl3K3+VR0LKRQHlaljJpV/3JKZAc6IfQFZlHn9tRIwMVWNcppOcU=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6963.eurprd04.prod.outlook.com (2603:10a6:208:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Tue, 15 Dec
 2020 16:45:22 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Tue, 15 Dec 2020
 16:45:21 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>
Cc:     linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v2 14/14] net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
Date:   Tue, 15 Dec 2020 22:13:15 +0530
Message-Id: <20201215164315.3666-15-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0152.apcprd06.prod.outlook.com
 (2603:1096:1:1f::30) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0152.apcprd06.prod.outlook.com (2603:1096:1:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 16:45:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d06ff694-e5f6-49be-72c4-08d8a118d05d
X-MS-TrafficTypeDiagnostic: AM0PR04MB6963:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6963F7AAD14BEBA0282638FED2C60@AM0PR04MB6963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: elnx3THHH3+kCoIf8Q6bUaXuGyQ0ubTUroN5ZKf2RGU3qVzna2xy0/UuFaFUyROMNGc5HV3xyGBy5RYP2FKd9hTCYFFC31hWE/FCO+K110MReXx7cI9e6XpcCT0Xpayd2FfOo68HPnjTFW+XRO+ADZu6nacTpGEZXaBfMIBIfTXb2mQIP5mRQcJtdSo/UAIMEbdTCrESfBoJ0uXnUakrPw9+LdwbILrDhCmmsI6W7b8mK12gz9RCWheRDfv6M25cp17XZ3seJo3faTqImaznRb4VPJGFYAZ+gsT9kBvtJa3J8oLQAN0pVVBnhKjAlQcSzB7V79JcCxk/bT45OmJ5Wyh0mMPjwmUvsFz5pWpxPqr1KQFdl4pZGPSbhC+DJ9BH3yYdDMjIjdLzZC46sBs7Fw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(4326008)(6506007)(498600001)(83380400001)(66946007)(921005)(2616005)(956004)(86362001)(52116002)(16526019)(8676002)(2906002)(26005)(6512007)(44832011)(7416002)(186003)(5660300002)(55236004)(1006002)(1076003)(66476007)(110136005)(6486002)(66556008)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?y3vF0z4qAYuJ2t3Ox2z83vYXumT2Yja6sh8CVKoIj+GKOjEL6C4nI94jzMkm?=
 =?us-ascii?Q?FqkRWyRhIsfs9IPSXQg6kK4B8pwin8goXKhoxuT3kOi10egVagdeO4jMz8F5?=
 =?us-ascii?Q?4fy7v/ngSY/ufhhfVfJZgYKkAqkUR/jGO2vEGaW4MmO38/rnoM9BCDJXgcas?=
 =?us-ascii?Q?5o3F0jTxQouQJMPZ1ikW3tTC1bvtiyxdakDwLgvmWZn7g/qd4oFqAjUbM5PS?=
 =?us-ascii?Q?ASY3HyShJ4oRDhcBQzqLbz3SbvSi4qsBBX1lBzoWIqqNTAxh4xmLUDrQ3zPx?=
 =?us-ascii?Q?BZj3SI9XiDKDF7EwooC0NdgTNfijM0IDLyG0G8Sn0oYaPipTjWTXri4oZqUI?=
 =?us-ascii?Q?rXSPbNIAg0BRO09jv1BCU55TsVQ0VygK1mX1NSdd7bA5GuUZPiLOx1AdZ07K?=
 =?us-ascii?Q?ZRhjLURm0W/2U0dMqaepifPt9hvdtBMW+bPTueuyJ4oey1VqXYPf7KSGhwpk?=
 =?us-ascii?Q?AdTreY9XG+x89HoWI7gTCToYZL0yR8zFr8rnqrJnpfOBQKLbEpuJmPi4T/Ko?=
 =?us-ascii?Q?olOCz2+t2Zf4GUy2Nf38k0+/pX9gVlgiXsmLHcqDWmHiyGR21PO637L7wOQb?=
 =?us-ascii?Q?lVrZcDanFiKxAkm0DH3c2JFJejc0qzNVSYwr0VCVneOMtWuoKIrzrz59sYwg?=
 =?us-ascii?Q?MU6k9ZF4MBu9EUrSppvuPs+vxzgFkm3fj3CvVEZeUUjA9wnmRdpei/lxeD4y?=
 =?us-ascii?Q?j83GPlOsmiuhXLoud2/J0jrotCbHieQErFvZXxxtxWZZ4SqQs/XIp4LP6pNA?=
 =?us-ascii?Q?VERwvgYpupubjvYtv/cUgFK79iKx+htquSyD96m4jJUDX64use/kJty079QF?=
 =?us-ascii?Q?/yNv8rkuTU2oI4VFrrnC93zcASOKkO3180Ex1DOUbowyj8vb9v8usjpEdTKe?=
 =?us-ascii?Q?63ZoYGE6ZcdJghaBlVB7elrZ/GkL5K69UgcFs7Wd9X/UmXoitK2xUdL9qASh?=
 =?us-ascii?Q?fqFSASFSjJY0F0OTJAHr04QOEppg/hoxPkTPu6bwuSNZsJl9oEn8aOy6iPeM?=
 =?us-ascii?Q?T6nN?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 16:45:21.9287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: d06ff694-e5f6-49be-72c4-08d8a118d05d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u+agCN1c9BAEgW5I4ygxpXc8o7GDd+ys6xTqx/1oPQDtUTJv+xcAIw7LtL3qxlSv8GWtZ2sr76JGp8RShcPdxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify dpaa2_mac_connect() to support ACPI along with DT.
Modify dpaa2_mac_get_node() to get the dpmac fwnode from either
DT or ACPI.

Replace of_get_phy_mode with fwnode_get_phy_mode to get
phy-mode for a dpmac_node.

Use helper function phylink_fwnode_phy_connect() to find phy_dev and
connect to mac->phylink.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2:
- Refactor OF functions to use fwnode functions

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 86 +++++++++++--------
 1 file changed, 50 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 828c177df03d..c242d5c2a9ed 100644
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
 
@@ -34,39 +37,47 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 	return 0;
 }
 
-/* Caller must call of_node_put on the returned value */
-static struct device_node *dpaa2_mac_get_node(u16 dpmac_id)
+static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
+						u16 dpmac_id)
 {
-	struct device_node *dpmacs, *dpmac = NULL;
-	u32 id;
+	struct device_node *dpmacs = NULL;
+	struct fwnode_handle *parent, *child  = NULL;
 	int err;
+	u32 id;
 
-	dpmacs = of_find_node_by_name(NULL, "dpmacs");
-	if (!dpmacs)
-		return NULL;
+	if (is_of_node(dev->parent->fwnode)) {
+		dpmacs = of_find_node_by_name(NULL, "dpmacs");
+		if (!dpmacs)
+			return NULL;
+		parent = of_fwnode_handle(dpmacs);
+	} else if (is_acpi_node(dev->parent->fwnode)) {
+		parent = dev->parent->fwnode;
+	}
 
-	while ((dpmac = of_get_next_child(dpmacs, dpmac)) != NULL) {
-		err = of_property_read_u32(dpmac, "reg", &id);
-		if (err)
+	fwnode_for_each_child_node(parent, child) {
+		err = fwnode_get_id(child, &id);
+		if (err) {
 			continue;
-		if (id == dpmac_id)
-			break;
+		} else if (id == dpmac_id) {
+			if (is_of_node(dev->parent->fwnode))
+				of_node_put(dpmacs);
+			return child;
+		}
 	}
-
-	of_node_put(dpmacs);
-
-	return dpmac;
+	if (is_of_node(dev->parent->fwnode))
+		of_node_put(dpmacs);
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
@@ -255,26 +266,27 @@ bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
 }
 
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
+	if (!of_device_is_available(to_of_node(node))) {
 		netdev_err(mac->net_dev, "pcs-handle node not available\n");
-		of_node_put(node);
+		of_node_put(to_of_node(node));
 		return -ENODEV;
 	}
 
-	mdiodev = of_mdio_find_device(node);
-	of_node_put(node);
+	mdiodev = fwnode_mdio_find_device(node);
+	fwnode_handle_put(node);
 	if (!mdiodev)
 		return -EPROBE_DEFER;
 
@@ -304,7 +316,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
 	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
 	struct net_device *net_dev = mac->net_dev;
-	struct device_node *dpmac_node;
+	struct fwnode_handle *dpmac_node = NULL;
 	struct phylink *phylink;
 	struct dpmac_attr attr;
 	int err;
@@ -324,7 +336,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 
 	mac->if_link_type = attr.link_type;
 
-	dpmac_node = dpaa2_mac_get_node(attr.id);
+	dpmac_node = dpaa2_mac_get_node(&mac->mc_dev->dev, attr.id);
 	if (!dpmac_node) {
 		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);
 		err = -ENODEV;
@@ -342,7 +354,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	 * error out if the interface mode requests them and there is no PHY
 	 * to act upon them
 	 */
-	if (of_phy_is_fixed_link(dpmac_node) &&
+	if (of_phy_is_fixed_link(to_of_node(dpmac_node)) &&
 	    (mac->if_mode == PHY_INTERFACE_MODE_RGMII_ID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_TXID)) {
@@ -362,7 +374,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	mac->phylink_config.type = PHYLINK_NETDEV;
 
 	phylink = phylink_create(&mac->phylink_config,
-				 of_fwnode_handle(dpmac_node), mac->if_mode,
+				 dpmac_node, mac->if_mode,
 				 &dpaa2_mac_phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
@@ -373,13 +385,14 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	if (mac->pcs)
 		phylink_set_pcs(mac->phylink, &mac->pcs->pcs);
 
-	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
+	err = phylink_fwnode_phy_connect(mac->phylink, dpmac_node, 0);
 	if (err) {
-		netdev_err(net_dev, "phylink_of_phy_connect() = %d\n", err);
+		netdev_err(net_dev, "phylink_fwnode_phy_connect() = %d\n", err);
 		goto err_phylink_destroy;
 	}
 
-	of_node_put(dpmac_node);
+	if (is_of_node(dpmac_node))
+		fwnode_handle_put(dpmac_node);
 
 	return 0;
 
@@ -388,7 +401,8 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 err_pcs_destroy:
 	dpaa2_pcs_destroy(mac);
 err_put_node:
-	of_node_put(dpmac_node);
+	if (is_of_node(dpmac_node))
+		fwnode_handle_put(dpmac_node);
 err_close_dpmac:
 	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
 	return err;
-- 
2.17.1

