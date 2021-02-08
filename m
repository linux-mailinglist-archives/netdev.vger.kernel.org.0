Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE873137E0
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhBHPcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:32:48 -0500
Received: from mail-db8eur05on2085.outbound.protection.outlook.com ([40.107.20.85]:53953
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232475AbhBHPS1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 10:18:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BfZJatA9n/ymG1uiZk4iyeA4qlrXfHcEYnUBLd59/QcDFSdPCkGX081vvi3Jl80PKMo0gpTKr0diMq/41Ofj31bjE9+RjG8v4vkQxwiMAIcHXRFlEl2ji7aBQnfdPJ70FjHWnH8j1wn3okfzjKNpWY/57clDxczQV3g6kEpfmmDiSljbnNjyNpkZucYcD9JV3AMj3/IHZ9f/tzaMp8BsxwDs7Zwxj4rO24KY4YY6Vse/edbbRuZc55mtwn1Gzqh/jWATk6PX81jR1bWKNO1lRhxid2MXrf5oDf/wwGf0GCsdnOJSBW+pHyhD7FNZe/9gWz3JiwYAMG3A17lb2fusZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0B+DlhlE59a/1w9sbZBwFS89F1rr8gVsTRD25iw1Ts8=;
 b=hae3kOxYEBUSq266ijuMMkAt+IhwmdL66ET50Ktacq0VRCYD2Kxt169P08ue3CCdCa+1EpzbbdmyJo0VHAHJA/xX6DELRg5EWULelPosBo7Q7LIp+BqZDmh33JbGW92OauSbZ7J8TK/EmU7KtsdmL65/aqZdlcI4BDCOZkWfRoMkSQdt4KqJpLRziih5siR6b3WeA1CCJuNtjWRNTIDcDtZgDetksvdBoiNWQfh0/wlNuARgq8NFf9KZNSwkeBjhTYUgbTbvvL0EgMumis+gD7P6CIuZJFJI2w/IbPcYX6Pd258qO1T1jGVxNWtXmnfCYzatpk/gaH04RL8hAbX+VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0B+DlhlE59a/1w9sbZBwFS89F1rr8gVsTRD25iw1Ts8=;
 b=Iu2n85NyGkDQ9S4RLVIVZ/L/3w+H90PJSLqKRjVEUAMdCb+NgiX3cioTuqilpCTJ8ASVmjLEYquTrYFf/OPiTaG+fadUnxrYHO9zJaEmLu2R7qWzc4lLklHxkCX2ekdVs27cj4b4Q/+Zzz/m0Ldboc5B6NH1vOlkgd6GMKdKkrA=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6435.eurprd04.prod.outlook.com (2603:10a6:208:176::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Mon, 8 Feb
 2021 15:15:01 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:15:01 +0000
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
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v5 15/15] net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
Date:   Mon,  8 Feb 2021 20:42:44 +0530
Message-Id: <20210208151244.16338-16-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0176.apcprd04.prod.outlook.com
 (2603:1096:4:14::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0176.apcprd04.prod.outlook.com (2603:1096:4:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 15:14:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 49ddb2cf-dbcf-4f42-b551-08d8cc444dea
X-MS-TrafficTypeDiagnostic: AM0PR04MB6435:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6435F83CAB4D1EA41D4E308BD28F9@AM0PR04MB6435.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wPdVAbz5+KP1gdMxCU1n03Ak9PvqkwKmjm5dJiGyyD9/UsEz0r2q8fF1ru75hc2yVHGwJZGh5Xn1awULVn1Q5qzIHZntm/0xBmtAEe6mrMTCNiPQ2M6/ro5EhUs3+VUdlJKU8J2N3P+OaKrh6ouJSAybHC41g60gmj41LEwc0GGw+8/FTL+/EFbUH8TcdLFgsYSNVW8xQEuLNXB24JDB65llYkSi1gB6j8/DYi4JKxurquRcdpSuX2PfvrsqyIv+A16oQLAMV2q+nIz9eGY4ShaMPvjOFg8w7BBE1Pw8ei5t9JUcfPvu18EKfjST9FbocVimjzAQ5sPpspP5zXCV/zM6XPO/lk/s12e41weUC/+AZTeYvINOWw55BRlRQq2fcf4gPAg/yhHOko1891FVAZ19AvLfZnwfxBqkuy+zifd86Kq4EfEndNy9RJViiottsABXD2qzOiYcT4qzbGTjq8TON7pBFsqOEPTnEFEsjQpnVdqJLv8bEK1wsp/mTqLaRpFPI/pBS8Crvonql3fRl7cU6LWnaObhMAEUD38CERcO7Naoyb55JzzhBz10tBLLeIDyTH+5a2WwQ2k0q+/rSLJonbA22kwBY740HYnd7K0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(44832011)(86362001)(83380400001)(6506007)(5660300002)(921005)(8676002)(66946007)(2616005)(66556008)(26005)(66476007)(1076003)(52116002)(316002)(110136005)(186003)(16526019)(8936002)(54906003)(7416002)(55236004)(2906002)(4326008)(478600001)(6512007)(1006002)(956004)(6486002)(6666004)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eMKOiRyCmNYtaHqSwnnm4cvHJUPLRgE9a/xBOhGWoooj/t5K0FSMJAZAgWI0?=
 =?us-ascii?Q?1Vz73JU+vr5sLe/ne9i+uQ9qVK9a9lZP1rUUHB1FN9whxeDXOzVOgwziqG1C?=
 =?us-ascii?Q?gAtrT+5jSagV7QMPBAIikcK7zRO5N7HcdABZqM19LN4Z9nvz0WezKBpFexBt?=
 =?us-ascii?Q?wDixFL52eNB3v4F6UHnIGeBxifWKU0FzJ9ADw++sRJzRh2/dCAZK9CnYz8Hb?=
 =?us-ascii?Q?+hKyIUVis8Pg2kQQFAxl2kHjS5eWUYfYWCnu1WRVYf7r4UZTTDzsnevsQLF8?=
 =?us-ascii?Q?F0oAcVpBbRGBmlkAIq1lL1KKEFwlrbEdpTHOdvYI2Y+q8g+zEHJwFvqM3rjj?=
 =?us-ascii?Q?o1UR6VveX187dVXY1T8XBxJ4bOWNw+uPYYmbOAf7GgudMzbEgc31utzcYamH?=
 =?us-ascii?Q?W3lrpiAC2kkEeknjXy8e4DYJYtgNPDjMqIZDlmPdblcU5dhCeFUrqncUzaGb?=
 =?us-ascii?Q?YufzyJQKB1vnCCn8ZycWPZ5uFuInG5zfxRjAdX8HJzMhDM6an/5dyIuKxbUn?=
 =?us-ascii?Q?eZVrtDQTLe6AvNMnkN+QPQnV0WVAWIu4Lx/4bm75YfLMGvMn/jEEttBOJILQ?=
 =?us-ascii?Q?h2ifWOmMkgv1NfiXc0ppX5phUCXDrS16blXoa7mysKP0vtGdNYKAXYMiqsNc?=
 =?us-ascii?Q?xTOT+YayjlWAAU+m0NvQq9IuPaOzdMkSH2iVWqOn1C+vgsw9C2sAOmE6T6GV?=
 =?us-ascii?Q?r3IKSQGYXhr6oPJzc2RDUiEaaLipJuMuWvJWbBX4vxjVT4jDbLAXjOBBzCyq?=
 =?us-ascii?Q?CMp37n9PwDCKPP+cdulGhf0O3I0RQBDNtxR2i6JBtccCTqil/vizMgHn2pjK?=
 =?us-ascii?Q?W+IAAhHxKBpLryMIFWtMK7RyokZy07usVwnfW2AJoToDcBJ+zPOwbYugVEXj?=
 =?us-ascii?Q?2X9NDY4bZv8tEhwEPPmFR4URqomuMkGckxK5b1wpgi7O/0/PBgxBEYxLhMnl?=
 =?us-ascii?Q?aHDYIXKDai+xHRN7Vvbu1VOFvsQbF1cgwukqeoXifmq7aRnQ8kTm22xKev3+?=
 =?us-ascii?Q?Wj2GvyujVm2Tw8eOrLKkihWlpWxFfaTl8p3PT+r5/P+eFiaLpm8mptjjqTiG?=
 =?us-ascii?Q?FYTVGng90oEeQu8Vx+Cn7cvYDUYj/bfGwQ0EUUqFo9rdUBpOvBcvrN4iLosH?=
 =?us-ascii?Q?cfwVMHt2tZRZm/qzMbnesr4Z03hh6J4oEkyaKcTfH+rMbgk7Nsx6af9MM5un?=
 =?us-ascii?Q?qBgDnxoXQb+WDZMqFyS5SmNKJ1XelaqVvYyy/7s9DMgXHOS2iUxrSdaMoaZ0?=
 =?us-ascii?Q?ODwmBKAZLH+FV/hhMxpws7EqfMNmd6hrl9c6eDBjLD6UYUmeV2ITfilLpK9W?=
 =?us-ascii?Q?WaJtPOsBMDTj/qlNrStKGyaN?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ddb2cf-dbcf-4f42-b551-08d8cc444dea
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:15:01.6241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1E08kT14ZET/DH1+DoN6PLKtAo/MjFyefT8GORbJHqo5U+aBOkqXyMpM10PfSHY4WC+YZXO6x45IkGYsloOb6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6435
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

Changes in v5:
- replace fwnode_get_id() with OF and ACPI function calls

Changes in v4: None
Changes in v3: None
Changes in v2:
- Refactor OF functions to use fwnode functions

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 91 +++++++++++--------
 1 file changed, 54 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index ccaf7e35abeb..87bb49722611 100644
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
+	struct fwnode_handle *parent, *child  = NULL;
+	struct device_node *dpmacs = NULL;
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
+		err = -EINVAL;
+		if (is_acpi_device_node(child))
+			err = acpi_get_local_address(ACPI_HANDLE_FWNODE(child), &id);
+		else if (is_of_node(child))
+			err = of_property_read_u32(to_of_node(child), "reg", &id);
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
 
@@ -283,13 +299,12 @@ static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
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
@@ -306,7 +321,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	 * error out if the interface mode requests them and there is no PHY
 	 * to act upon them
 	 */
-	if (of_phy_is_fixed_link(dpmac_node) &&
+	if (of_phy_is_fixed_link(to_of_node(dpmac_node)) &&
 	    (mac->if_mode == PHY_INTERFACE_MODE_RGMII_ID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_TXID)) {
@@ -327,7 +342,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	mac->phylink_config.type = PHYLINK_NETDEV;
 
 	phylink = phylink_create(&mac->phylink_config,
-				 of_fwnode_handle(dpmac_node), mac->if_mode,
+				 dpmac_node, mac->if_mode,
 				 &dpaa2_mac_phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
@@ -338,13 +353,14 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
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
 
@@ -353,7 +369,8 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
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

