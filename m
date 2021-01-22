Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E71300B14
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbhAVSU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:20:57 -0500
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:4995
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729167AbhAVPqF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:46:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCjcrvefY+4hBz3uVOJWyfaeSbhF6c0vXe77hqBeJRqJC6MV5OVY1qc9u6XkBfdxRtLEhjlZpUbf3g5t2sBFULmdZqUBSGi1+r/0i30Zjnppcr7vQQK1eeG+7D1o7Khg8ubhUDcNODgVsPUZ9Ez7jIwqcU2IqeGzhNXATOqafDnRKHxc8IJT+nRc8etGb/cMdaGoaie11gZAPqaS+GeCveZ9dqOnp4mHkY7jJqJT3ORY6xHBzruykvPhGV6Tj45oE/+2uFqYGCCzoycFdKNYwXyn2ryWI0cmtJoAf46ExvxBIUQco/32RD7//YJWW/tdEWcou/jfTwhXVtWSWX2w4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nkyyugcVZXBAnF29aC5M48+TcLFQfMp0V5THskW2dLI=;
 b=h1SvUNerlifnUSt/mEzlidb1ngA3xQGXrXhBVNdImCV53B97nuA7ZirotZolTZjPNarO4UDOxfBf6yYtyi35DBdVnEQAjky1/oEhrB6WICO/IcC1wG53qRtwwOlidiDnmQeLlcfsQZc7vXIE4Ul+FqNwt+XaZtesUplmhftejx9JRVL/leYqxjoJzojG4hGVQ+OMy3XpaSx5hAUqOz6n8EcFsLCIywvUK5ghEVs5osj0I15jTY9j7LyIlM3tBfohWTW10si2KZArNZy0bw1ER/u0vOz1SrvLKAUmoEw8HKjJo2rWvzYN0v6simFA0T4opk/lNXhrXBpsE9w6oypgGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nkyyugcVZXBAnF29aC5M48+TcLFQfMp0V5THskW2dLI=;
 b=BzGmYIh1mIvX5eKtRLs5tU29ahmiKo5tYRCzEPSKkiTYWNFE1b6NvEdRZQLCo2lDZ+ANBZWvgOz1zfI8Kx3ZF1u0ghfoFYsUIciwPCYLjkG3ud2GVP0bAI2LJ7HawxElw04lvosL5hVEHdOZiJUSrVtN7x+aa7OzBLSPuY+EPjA=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 15:45:34 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 15:45:34 +0000
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
Cc:     linux.cj@gmail.com, Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v4 15/15] net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
Date:   Fri, 22 Jan 2021 21:13:00 +0530
Message-Id: <20210122154300.7628-16-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0117.apcprd06.prod.outlook.com
 (2603:1096:1:1d::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0117.apcprd06.prod.outlook.com (2603:1096:1:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 15:45:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1f71c28b-2762-49b9-7e64-08d8beecc1d1
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB34439E75AFF7C07CD7B92009D2A00@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pa5EvtOHNN5yyIyozXxlROzERWvGkHv3Qes0l4eRtU33tGtrzmRaT5btJYgqUC3K04NidCzG6jdq/KCE8Xnz61MAlPl6fHy4JZnIYNOmNYIEq91/vAaDUpmTyt4RnYNOoP6fdR+8EdKgRqz6SCDHVVePqBn88uoNezrPvuzvj5VVAq0djj8MitdPv0hGW2GhUWsRSYNuzBnApnJbsYuXzg27Q/Jk5IhpvN1gaUAKwzY7DjevJejQ7/uN8wNc0q4kB/5vWjn6d1NqDt2doyJld52xi4hw7Ijz49VG+ESlz9TzUeRLFuslzA0MlCLVg6nFRW9FvTBz2QzuOKIhEDMiqMvvYxDjs4FoNJyYQf7JODTSY18UAqVuRChZPqkzQ4xImsF9WOR/amRJiom11MZJW7SCnk3vDEdhDL9/xmwsR7rUbkGsdyZrYMYFD0taXQJzqYsOX6EF0W2cEDuME+u7xQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(2906002)(6506007)(921005)(6512007)(6666004)(186003)(5660300002)(1006002)(16526019)(52116002)(54906003)(956004)(55236004)(8676002)(66556008)(8936002)(83380400001)(66476007)(2616005)(66946007)(1076003)(478600001)(26005)(110136005)(86362001)(316002)(7416002)(4326008)(6486002)(44832011)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mtR6z84gFR0/V2r8fNATkd6IszqDxg76HYhMIqvACqdPjvx48qFsXJyFwoNO?=
 =?us-ascii?Q?GV20biliVSx7KJK2UXBqRgZSZ9NIi8YvQVSS9U6ENTWkFU8laZeRSiDnMs+G?=
 =?us-ascii?Q?Eemuocma6ZVKuWIximgR4SLzIVz+r49ZOPhaGMSpqN0XNnDhGKYXjNvZMWL0?=
 =?us-ascii?Q?Uye+G6VGy7NFv+5j9HdXz/itOgDDJl+vBtDf7spZN41k0AP5W/uTd2tCJ+F0?=
 =?us-ascii?Q?lu4ONex2ce5xtMBV5ChKB+lkuTqR5E+DJh+eIRuSM30f68J+ObLo3VbLIBQI?=
 =?us-ascii?Q?yxCb0fDiE9Suf+XV5tmycbZ1ohUbExAglaYj+TIZ0JhMCDDwCrZ+xFucwMiK?=
 =?us-ascii?Q?WYcqFl24UT4LCLO7Y5ue30MiGhmYBAGBbhhJgfTLKVsNketvqkA/Waj7I51b?=
 =?us-ascii?Q?TS6PTj90BpmZ87aZnJoxhyjveJvXeeFxcK5CdI104rHPPd5EWW79BTz5aa84?=
 =?us-ascii?Q?P9ydUuBjIjOK4TbsntjoYtcgcGyqFw42LFMy+Ig5iq81tcn8p5T4MyjHIqh0?=
 =?us-ascii?Q?yF0c8VHtrnenMe/CkgJYrHsION5zwDmEwyhamOaNDCrVqJzZPhw5KJhL014f?=
 =?us-ascii?Q?H10/5LxlS1TJlnNvdG6CsjLHC/nesP9SU5Rad0Snqh9glxc100do1IpF9lPO?=
 =?us-ascii?Q?4VqsG3sCsiRxWfC63zyXE/INECpDTcpZ62/luoJP7mdtcvXlu8PV2d5/8WP9?=
 =?us-ascii?Q?ul7Gl7PHqJYiau26mIPqlzQ0LsSqoRTwooj2/18guF+Zs+wFyRqFo/q30zHw?=
 =?us-ascii?Q?Y13eYqDXODUQs/u7w0iuIlAZ2wzefF3G9+iVA/bpbfespl027wg7iCDmox1p?=
 =?us-ascii?Q?DmKvur2gJ58Nxz1WSAodFX+wWcrZ0z8uRqdxMW8R1mE4dw6fx6SZf3neLoAB?=
 =?us-ascii?Q?2X+u6XUnlKHyvwsoVzZ3Qk/9NKf0Lxpd7j31npQ7uiKTI/XeCWmn8DVcKrQZ?=
 =?us-ascii?Q?J4r+YtlM/ekXHIYsTd4rP027GoCzITDf1pIaInPKzkrpB1TvjKpO0muGqeE/?=
 =?us-ascii?Q?xGu7+zKlC8pjEpsDHD2d0SFGfr4G5GD6J0ei6zvTI3Xw835WYXypWCih9ste?=
 =?us-ascii?Q?whlfd43+?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f71c28b-2762-49b9-7e64-08d8beecc1d1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 15:45:34.8455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bigSAEZifMey8zoRTP9gEYJX8cGr/1nu8sAP1KuCkPqTqmxhV9DjsT7YHC9jKYzj2it+DNC0Q7ZbZRP/neAjUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
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

Changes in v4: None
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

