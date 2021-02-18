Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C846131E5C0
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhBRFhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbhBRFdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 00:33:37 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0603.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44DEC06178C;
        Wed, 17 Feb 2021 21:30:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ep38+QL1G7Ahwsvf++gNP9TJ1A9e82oinQh3Jl+3IbbgUP9bY6ivzLHIq3khEU7wouueCiLkV0XB2vfYxDihbEty/nEsIZmXt5do9+WT992ahAqSMEq/4qqvbuEVtOGer7jktwKOO9pe+nztvT339bqN8DP/xIXdi2NY0VtvBmscxSdHL+1N0YVilNG71WNvDk199PHU+Atnnhpmcj3UwhVGnolZsYD6Wh30R2675dMIXWxcEwxMxsJ3G4F1hrNPBZgEaeqL6DIqv+3Qsp9j8AtZjm7uhw2kpNy1RuOSrxQfp5ObdcaYVcn5zRqPr2ebijJQ3MtSy1ebQa51xxy5Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kBwdEWmkcu8/U1Y+MFpbmKXP42UUfum/P/awBMJZrPA=;
 b=PIhjcptJIRlmj8qgvKObwdTJvPXB+Umt5Kbms7Ea4rKwccVzn2puiEQrR6wCdsoYS2I3zfCuYywezPEZgly0xeN5EqhPoJ+FA0FRrwyPLiy1FrqcYF6Fv4piHPcjAm1kriJzBOq9ky69hAbRNBh2jzPRarGJDpu36xUwovnJkQNZh6YYO1lfQbAhyVj+0HxqiL4t3FPX5RmvvuQDDmJJohp65swd3DhW5r9e8YyTJ4wa13OIJU8CgOJn2aQdYrz76AXVhu1cTd2Bo8usGCRBva8SGe+2lFop+Ny2DbQkS8S3fsgjMWXf2CgVK+4RbclT3/VZJD3odahpoUCgqq197g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kBwdEWmkcu8/U1Y+MFpbmKXP42UUfum/P/awBMJZrPA=;
 b=K4RSaK2nKjy8UPSHoJS/WJyEZMNqPz2kmIR+LzuCriP8ml9U03XfZHFrzSFFEK8cVfEx7cmrQ0gLlUWDFccdwuzv3W5OnrwkZskHeipYpv0mwTcYy9bI8+bBnDaNobtbgt77pST4JQ/AkSNaETKSCWIY7entMZLLaxAQAcv+l6I=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7730.eurprd04.prod.outlook.com (2603:10a6:20b:242::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 05:29:09 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 05:29:09 +0000
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
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux.cj@gmail.com,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v6 15/15] net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
Date:   Thu, 18 Feb 2021 10:56:54 +0530
Message-Id: <20210218052654.28995-16-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:54::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 05:29:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 718cd302-a9e6-48d3-95ea-08d8d3ce1dfd
X-MS-TrafficTypeDiagnostic: AM8PR04MB7730:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB7730DD57F3E16DA1F58FA19BD2859@AM8PR04MB7730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rKA9Sqx+hU/NqIwjFUfqs/6rVfUCcdZ2f2tefXCH/VWxJMzMhSYAcp8xoNFNQcwpVhf3GYu8ebNw2fDMm+rjTc6YakZkGkWWsgU2e8oRNdizk8df9L0m/GbW9ZZVmTiVUIBHmcqqm9jFAXsHsK8DqUR76dcSCxl4kWIHZc7oNdHA7y+1nQ4M15qUypCvyfbWXK2XYAi1DowYVWj/Mno4w3Vkt5A2T98/DSQDQO0sAuisCq75DEUZuxdJ2LurH3dsDhtoQ7LGsawQ7TSfXapQd9eN2BkjLplXTzsEieVvyc71DMmnM07Sd08Q2zlSYVonoFS5ojS1HGqoXqJAIbwpeAQGdJ+a0mGkApb37H2/EDSwkeeieRUdH+UtQplkSGRVjTQ2asgxUPM8RaNz6wl88vpiXBu+e9KxvOSXR7cO1LQP79yKeipbReuIcN5Wlu1D0rITfZaq0M7IuqvVxnjMTlxnqMmYveN4fYn3x5YyPF+ZookIt6p0Q4DEXsQzSl7xhjx2TpUr8w5vDuBdwR4E5ZNdHaQ6Lci2lw+yJa7tGS2jYhzNgPEmPIhwHDJiEIakBOFHnAJbm5dIhiZHyJwKMf/kWeOevqZ1VvTmPlJz9Hg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(26005)(8936002)(52116002)(16526019)(921005)(478600001)(1076003)(6486002)(8676002)(55236004)(83380400001)(5660300002)(186003)(44832011)(110136005)(6512007)(956004)(54906003)(316002)(66946007)(2906002)(2616005)(1006002)(66476007)(86362001)(7416002)(6506007)(6666004)(4326008)(66556008)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4CkvCq6u4jPrfp4wSzs0yEFA9HVN2upRhrW/wiHpgqx/l5Y0NlAUwyslx90E?=
 =?us-ascii?Q?TrXGZ8j8tGAvFIz2NgNUFLz3I/6VcAWuqTrBqYqSf9mbaWemUPQ9WjvZa7be?=
 =?us-ascii?Q?65HH1Z6D7ZLSbk4VcgWw5SKi0zzMtyk8buYH/CL3GZ8qwixHuHA3gd4FpmmG?=
 =?us-ascii?Q?DS04WWfrzMjHo6UJSrmRu/Ejgp54dRdmEWpo27l1h42csMh5TNCYxitPqJ/U?=
 =?us-ascii?Q?tS+xdyNhjq6XpRRe+Y4FAnvO9f7G5zjg/miPsApDAZrpMdb1XxA1HERaEUDr?=
 =?us-ascii?Q?nd90Vs+TODxbYBmp8jwYfqurJ4c6t0svUlxosv3zQt8uH6XOc4/yOTTMKCZa?=
 =?us-ascii?Q?Tw4KBq/tXiavt1RwyD9N4d82vOVBmI6KwecQZlUAw81/ZiX9406IHHmrsE/1?=
 =?us-ascii?Q?5/GzmXzsb3PwfrZPe2gWvzf0lq3oN22KbhJKce0zpDSpmh22pveSlbtqCxit?=
 =?us-ascii?Q?5hTQA/BrtROp+vJ/6zEvh4n9J2nW5CDUXT/iOJTrOwwi3RPe3Cem7OGEuRdY?=
 =?us-ascii?Q?ZRPa4Csp+KOKP9TRQyiQ92463LnfKUULzhKz5IFWFNzThrHPKOkQrbvIR6GW?=
 =?us-ascii?Q?M3fbZpfrRFHAgn13X9SO+chxbFPX2qn8egG5AAZhozyVUSVXSKrkYug9nOhF?=
 =?us-ascii?Q?Rn4vcY+T9DGrSfGDCecBPtAVzfSVhTOt0UImIhZ2tNL56aMoZqG5AKxOoz8W?=
 =?us-ascii?Q?9GjTC0ULdcpLrGXPUX1dHLSXYvFRsIgtk5Sk1v8W7lFFt4EOuNbc1xWdCCvd?=
 =?us-ascii?Q?NYlB+tQayJ0bSdqiN3SScF2oRLKpgKh9FMqYWEpOMOJ3Ar8s6GS0qQf0eHI2?=
 =?us-ascii?Q?jY4DPgOlz2715rBu/x8IpFJF5URIR2gn9mzsDCCH5PqELQnPePQg79ImvJN3?=
 =?us-ascii?Q?ARr6C7EX7iJpWTRpaCw3oTvsw5HvywrAHuVSP4KgsrimX3kuc7WXj1XUCIIj?=
 =?us-ascii?Q?JKJDfaK5hJo1tACasy61HyIwpv3e8UD5HVO1sC9ppyrk+Dt5Kvq1pVbDArAt?=
 =?us-ascii?Q?pNJhsBlyhk3C/gfGufYBvitD2xY/aoHx2QgZaCKnng4e+Pqg1oxfSCwYZuVd?=
 =?us-ascii?Q?IbEJs9wbfjrsd72HemXIHROoqk1tNLOoyyJ0CEmruq9rZNSyD8alettWyXWI?=
 =?us-ascii?Q?H8G4yZzLBhbbT7o+/hbi6d6AUU3SGuUSDx6MSuchcB+PbayfvOJxDtc31y4z?=
 =?us-ascii?Q?PpbQ26VBUNARMQ3cKoTBdHrMZFCHFaggEJ6w/x7x7fW5BNGJ644oL5zTEQ6f?=
 =?us-ascii?Q?h0j17n8n/f+1EXy2BslwqFFWjrixBDrp+Ji7oPTR75sV03rPvG2k8+YhVSp/?=
 =?us-ascii?Q?cthARfrfexVQwmvnQPVLq/zB?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 718cd302-a9e6-48d3-95ea-08d8d3ce1dfd
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 05:29:09.7024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3A06470WUfiFt/wdlU+P3ohAje3BRSsEcYz4iJjkRALPZhM8/P8Y7zOC1nkLkH2fAMjuLs5hyO89haVeiFXnFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7730
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify dpaa2_mac_get_node() to get the dpmac fwnode from either
DT or ACPI.

Modify dpaa2_mac_get_if_mode() to get interface mode from dpmac_node
which is a fwnode.

Modify dpaa2_pcs_create() to create pcs from dpmac_node fwnode.

Modify dpaa2_mac_connect() to support ACPI along with DT.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

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

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 91 +++++++++++--------
 1 file changed, 55 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index ccaf7e35abeb..3e39a15b001f 100644
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
 
@@ -34,39 +37,53 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
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
 
-	of_node_put(dpmacs);
-
-	return dpmac;
+		if (id == dpmac_id) {
+			if (is_of_node(fwnode))
+				of_node_put(dpmacs);
+			return child;
+		}
+	}
+	if (is_of_node(fwnode))
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
@@ -235,26 +252,27 @@ static const struct phylink_mac_ops dpaa2_mac_phylink_ops = {
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
 
@@ -283,13 +301,12 @@ static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
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
@@ -306,7 +323,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	 * error out if the interface mode requests them and there is no PHY
 	 * to act upon them
 	 */
-	if (of_phy_is_fixed_link(dpmac_node) &&
+	if (of_phy_is_fixed_link(to_of_node(dpmac_node)) &&
 	    (mac->if_mode == PHY_INTERFACE_MODE_RGMII_ID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_TXID)) {
@@ -327,7 +344,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	mac->phylink_config.type = PHYLINK_NETDEV;
 
 	phylink = phylink_create(&mac->phylink_config,
-				 of_fwnode_handle(dpmac_node), mac->if_mode,
+				 dpmac_node, mac->if_mode,
 				 &dpaa2_mac_phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
@@ -338,13 +355,14 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
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
 
@@ -353,7 +371,8 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
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

