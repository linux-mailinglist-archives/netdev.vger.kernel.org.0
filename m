Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1B82F321E
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389194AbhALNpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:45:10 -0500
Received: from mail-eopbgr70083.outbound.protection.outlook.com ([40.107.7.83]:38766
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388744AbhALNo5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:44:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVMkBoNIR79nkEo/hJ4izMw6RICPT/JmvqICy9CkNHy8hLfW3CllqG8ARpeqejOmGheWMWcLFx3sxZmXm5b2yiGCGsrSJc4UknmDnOmangH+yPaExjAb2HOlMp3rr/dVcTo2rM9afCDXYq+c3Fm/8jga2htMT9YfqmoNF2Kf0ctzxEMgB4e7BBl/4WIegunbNT27Fvci9ZtGvjHAZsLuupqhMEi6FdgPdr+W4x1AiEUiG7D0kR1iSk7x3yL0Io91clsKpavS+J7M2aIce6uNp40dP97xhbjmeKTFK5CR+lTIbWus3PfoGBugDya1tO2j9sNLPPjt7etU04/D71tiyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b//OUlxZ0wCcsSRdenYT5np+MID2Flbpazna4UQS4P0=;
 b=YVmIiAX3s4M5UbivUS71ewyySes39gayvndFmBoE+cJblHtrxF4VFuSSqaEVID0+ajTPJOYGNpECCUIAeJGf3YdklPOtbLjX8GCtQH6pvvqRcQFRzcSYtdzh7Pqllo2y0roGDOIL6KlxTcumTVrwobEFhl90t3KU5ZFCB67VIFWjjA11VQ4kFS+S1S42VsI9Mn6wTLDCyyyVdIyRe+BIxNiaiOFAUDfUjHHz+++WXLIPpNNz9/Inq2xwINW980/yqlCUz1f/Is3GS4Vj3HDE4ARKwD7m6nqBf3EBIVraoU3cbSlhaf5g4MNZYtnza6zAbT3JTBUjNiUNfjc+3GPpjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b//OUlxZ0wCcsSRdenYT5np+MID2Flbpazna4UQS4P0=;
 b=AEbYcvwAKXhbk7fObbvvBH0hIVWXlQyJij1Ihg3fN30aTz+bfSeQO/qIYdIuPuTnbbkQRoPCdFU0VW5yLTpKBby2UkNprLmNZ9s2dqGm0tusGNeBQTSti5ZW7u/HlxxYFG9RJPMoxgSDvR70q6prOvqTUlIL/XGbCfth00YA4Hg=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7937.eurprd04.prod.outlook.com (2603:10a6:20b:248::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 13:43:23 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 13:43:22 +0000
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
Cc:     Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v3 15/15] net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
Date:   Tue, 12 Jan 2021 19:10:54 +0530
Message-Id: <20210112134054.342-16-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:3:18::35) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0047.apcprd02.prod.outlook.com (2603:1096:3:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 13:43:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7036a4cf-cf97-4617-3556-08d8b70007ac
X-MS-TrafficTypeDiagnostic: AM8PR04MB7937:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB7937FDF876B175B0D41F4C1BD2AA0@AM8PR04MB7937.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zn/YhgJLYZTZL1h+VbBZlslDULHnAQ2w0PFZnXU6VUVTcgrgnAQYmzjUR2FT3ru/T4Ic9T9gu3xYg64YbKEuA1nd8uH7JJi4TVstPqWsdVHfBOfjmcta7YAVd3Czku/vn+Iw2opwtxodOrDDFPyAMbrpeM2JemUhZF7mWb/wOSsg2TezNZhZMtPM+twy1ys28m5PaK0hQnFwfTYfitGF+7LjOyoKaidNOVUykbLM64bmojk3wWaBWXO6h5eJjb2VQ2jGjZBddonR9ZdIxgE+VG5R891HcQ7UbRCcGD98l12Fvs6v7Nh7KcGNNIa0uBjd4LhVaM86Ok2VnWrI1ilzq2QeFgKg5laJXvpxxcFuX84OSNVKvs/q/qprYNbm0i6w/k4u5Ie8LuCUm9TjiONAUAfb4AB07VET5LETvMglFiOqJqBHmzQcmJivU7y8KdpcEBYWuAyTb7NofVetu4NfqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39850400004)(16526019)(5660300002)(1076003)(86362001)(52116002)(44832011)(66476007)(110136005)(6512007)(55236004)(26005)(186003)(8676002)(66556008)(316002)(8936002)(4326008)(478600001)(921005)(1006002)(6666004)(2616005)(6486002)(54906003)(6506007)(83380400001)(956004)(7416002)(66946007)(2906002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YW3ka87G+OIqW5D0ME4C++7kncW9vzgN5mPLgD0Of8FZdK9kNh2r1+pHATJI?=
 =?us-ascii?Q?2aieZcm0g7XiTtPtj3WBbvzMGfiJJCZ9rAp6m+oAc6WpYwN5qes8CSYHgad5?=
 =?us-ascii?Q?Ge16Fi61+64qU4WxZHDkMLEjYrJu9UGizEbKSJfhbjpBB8pVYFxwssKo3lOa?=
 =?us-ascii?Q?VJgvV4xJonsj9ABsgIPeABoAgIRx1QRrZnpU6lPkNgn6vdIqO6eTW6Lw9Xer?=
 =?us-ascii?Q?dJ9Xl1800eIuzDZPJaAEUyRYlOFiPgkVwd5hoYkK3WSKWr5bMF51LErh2cKR?=
 =?us-ascii?Q?C6ZniK5P4rtBc6e90j3hJMZefbi0OPJSDV9o2H/ncioRoTJ1uAG9DlsHa1Rf?=
 =?us-ascii?Q?NKlxXpY7lEoim/vYgYJxs388hidefJs4IQWJP8XxdNnoLNdUMb4lqnezH+FO?=
 =?us-ascii?Q?QmyHz2YbPeINxAeEByUOo4OjJKLmLyNOVc/efdQkCgpLDZLrMqh2UzSLhSzZ?=
 =?us-ascii?Q?lKFd4U45YvCoErGwpYcsVtxQdCHv4tNm07hsFNPuV7BThvXFPWg4K5ZRSphA?=
 =?us-ascii?Q?tVMQ1FEWMVbPYTur/bMClCOTeFzNyPL6NNvW7q0qQWOZSBkEQDsi2t5Kzs7M?=
 =?us-ascii?Q?vIZh1/wDzpMEiuwZNDKJ7v3FwyotC4z+5hyYXNGDyK+cKR+pkcEQuS6HbVbw?=
 =?us-ascii?Q?vYzDVpD+qT/8V5DI8KnpjEiDTnheiyCv0KlB/sgWSyjOKZzzr6Yhx/EH6pyO?=
 =?us-ascii?Q?5p+qOM6CdxxsQZCum8XAFtAt48ax2SFNJy5ZpmI9RmDP8D8XNi8tw8XrT15B?=
 =?us-ascii?Q?RpB7sPnPQIceEKMAzsqNxOQr/bSHBddDucBIvcsjiddTGFbRwEEhl/DbT9jV?=
 =?us-ascii?Q?sYzN+AiDj68xuwS5uFP4FphhFrXrGZ9n5IcjnrVVVTJ6vtJkmK/3KnAh9S6u?=
 =?us-ascii?Q?cTlCke7pC8xA6XpO4fUv7r+KuX1Bw/7DWcXKIHrh6cdvdI3ZIIKxo36WQYia?=
 =?us-ascii?Q?Vsrs+fKuql0W9Z/AWI+eCoeGVMnBkbOj6KKUIGk8zQ1oKUTw7FWRsxcGo7Nu?=
 =?us-ascii?Q?cnZ/?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 13:43:22.8834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 7036a4cf-cf97-4617-3556-08d8b70007ac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: suTfehhwn0f7XDQsClMU4CKPCv7qOe3y1dAN8ZUK0hmME+1+CNwM0YqiIs5ZOIL80Yf33L/ymaMcJJCVEyWzTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7937
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

Changes in v3: None
Changes in v2:
- Refactor OF functions to use fwnode functions

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 87 +++++++++++--------
 1 file changed, 50 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 69ad869446cf..2aa320fd84ce 100644
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
@@ -221,26 +232,27 @@ static const struct phylink_mac_ops dpaa2_mac_phylink_ops = {
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
 
@@ -269,13 +281,12 @@ static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
 	struct net_device *net_dev = mac->net_dev;
-	struct device_node *dpmac_node;
+	struct fwnode_handle *dpmac_node = NULL;
 	struct phylink *phylink;
 	int err;
 
 	mac->if_link_type = mac->attr.link_type;
-
-	dpmac_node = dpaa2_mac_get_node(mac->attr.id);
+	dpmac_node = dpaa2_mac_get_node(&mac->mc_dev->dev, mac->attr.id);
 	if (!dpmac_node) {
 		netdev_err(net_dev, "No dpmac@%d node found.\n", mac->attr.id);
 		return -ENODEV;
@@ -292,7 +303,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	 * error out if the interface mode requests them and there is no PHY
 	 * to act upon them
 	 */
-	if (of_phy_is_fixed_link(dpmac_node) &&
+	if (of_phy_is_fixed_link(to_of_node(dpmac_node)) &&
 	    (mac->if_mode == PHY_INTERFACE_MODE_RGMII_ID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_TXID)) {
@@ -312,7 +323,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	mac->phylink_config.type = PHYLINK_NETDEV;
 
 	phylink = phylink_create(&mac->phylink_config,
-				 of_fwnode_handle(dpmac_node), mac->if_mode,
+				 dpmac_node, mac->if_mode,
 				 &dpaa2_mac_phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
@@ -323,13 +334,14 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
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
 
@@ -338,7 +350,8 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 err_pcs_destroy:
 	dpaa2_pcs_destroy(mac);
 err_put_node:
-	of_node_put(dpmac_node);
+	if (is_of_node(dpmac_node))
+		fwnode_handle_put(dpmac_node);
 
 	return err;
 }
-- 
2.17.1

