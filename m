Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEC6218E5C
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgGHRfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:35:25 -0400
Received: from mail-eopbgr20042.outbound.protection.outlook.com ([40.107.2.42]:43335
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726837AbgGHRfY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 13:35:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZWvbe3GNlJzq46Jz4hcieubAoGPBisqMyhlijooUftP+g1qIvu30fGV+FjLj533PZmpuzyVOUo9c2y76qlDmtQLrT1UQ+gedAHK0KKQr9OGny8LXK0izCzqo/NJSLjtm+Y9DhM7plx7OLHOUDhUAN2OjC1ogUDqE4ToTuTxcD7AGZpE+7JAjec3hbeAU4aBSEkbjyIefx9YWHpQ81OsfSobUPzGSb5usUXYaOxfkY1i1JgAhRBSiPgZGza6E8Rt9lCPXIeX8WEaj6l2bELR/CEcMqjPx3Oz3oS7nwH4G53LNOGUGPdV7xqJCPw17t/QzY3H3+9F4LuTSXNlibv5jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rP45jMIru9NwB2O9CaVgGBFnRSd2VPj2JSK3MfAm52U=;
 b=Xf6peZpbY6LFRRFPwMLVZUEjMMxuREdydim5P9n3O7dga0pEtDS70ApyHxjKjj6D3GWpZ93bPsbl2WPVrXRTUFfSrYnpmuE9qBZyGoFRlt3idfXc/3YBqpV5AquAROKbvQ0illXbAnl0HJxLJol7KnlHYsO5HHJvaf77wGG6RSI5iPKYpBiJoHHQwtSJi4+fUYD8YcjzadnVnqAqBhVI6unITVR9C9Tim29w5zFiV83EwAMBHIS8CxDugXmxU5t+BuqTWl7kQwCtfsnuY3oPzJXqsOYi6rnXfE/9mc80L1vHNDelPyUfxGOnW/u1NVmNCiSpeMpxNEdo7UBIwSmRQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rP45jMIru9NwB2O9CaVgGBFnRSd2VPj2JSK3MfAm52U=;
 b=AXjX/HR3XuJcjzYMHskxECJSkm3H0+u4y6WPv83IOYTi4VxtY0NjG/N3rQxpo/WYfglnpWxDDPOQTSrj2IYXvimrib3PA/A+2SQetyihb0mnU1BrcrskXEXHY00num2l2lB4rhW9hELuscz28EBg9oJFmQTgTjflFa7J2aZjZFY=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5730.eurprd04.prod.outlook.com (2603:10a6:208:12c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Wed, 8 Jul
 2020 17:35:19 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 17:35:19 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     linux.cj@gmail.com, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v3 5/5] net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
Date:   Wed,  8 Jul 2020 23:04:35 +0530
Message-Id: <20200708173435.16256-6-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200708173435.16256-1-calvin.johnson@oss.nxp.com>
References: <20200708173435.16256-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::26) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0100.apcprd01.prod.exchangelabs.com (2603:1096:3:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Wed, 8 Jul 2020 17:35:15 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 40801395-0d28-48f1-8216-08d82365487e
X-MS-TrafficTypeDiagnostic: AM0PR04MB5730:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5730D20EBF7678950CEDB43BD2670@AM0PR04MB5730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k9AtAngfnpn1PrTIYhx9BLELV+Lt3KKeibTFNHit6JuYB7BetEo4A7fipp918zMScEnQqEUTPUMbkMXMBdTfwAMj/H1BBmFKR68SWzQXj3jYcLuUNnOUQmLo8HedqINPQHdguAj6G0ak8eHpQDAAZwld8CRSsLpvg5xJCDaR9GaXIQWS8nkL9Tzvv2IZRhfWIKLurYfOZXAm7rlJ0qteizRRUDxWwxeGv9r8AP9kmpV+Ps1BqkAhhmDwMHq/anXC54OuCG9RfDr6vf83JhJMpgAfppqNEu0+crQbsYxYD+aRIiGy3CBXces2l3QbC9kkiU0O7IFt2dYon53ZsBDdpzCHsBPbiXZiia/asXnqKBGg4Q9joDss4Ku6Gyn8rvoU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(86362001)(6506007)(66946007)(55236004)(1076003)(66476007)(66556008)(6636002)(110136005)(4326008)(26005)(83380400001)(6486002)(52116002)(8936002)(956004)(2616005)(316002)(8676002)(186003)(2906002)(16526019)(6512007)(5660300002)(44832011)(6666004)(1006002)(478600001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ozrdjNVbpalG8EwRvDFyuOWOrlx4g+Lvt8NU5YMHwGHKQvySUoPNH0/g0/IU/EVTn8xteU7ukRAV3RetkqcLwGx3Tso7Z4I+0Gt4AqzXN0dqGPmLSb2Uh+G5wa671dsTb0d8my4WPfVJhWY2r6DP5WRAMhukFeBNnWTOYVunbcQSysyXmT0cmpTOZyjcKV1sMAcyenrH2tDM2qvhcgbfyz6a188L85e4UYNC7zD8hI8msGkDSipYFLGkIjSxD6dQCngYjVwgPZym4tA9/U2ZCgr7emByXVY2YVplQHLqQwx79nbgAT46fJEp86XDGntZf9StSlIam2xfZsZJ5Ns1wzfZAU1xrG7QUiyXjzIhNG5kHGrxmvt0NUda8mW9MZXXusQcsWxJEMMQu+cRFlc2mpsu2jqteY/si/1bKYRKPcqKPCARTDmZGRxICz1sFzvVILGtMPHRUHRRro9StagO+raikLHSmvETd8oFZ+1UzXw=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40801395-0d28-48f1-8216-08d82365487e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 17:35:18.9913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tq39UQfqvyOyRTpTdsa7ovWTLfPson1anXT9OAJNrs34U5lDuON6vbaTXo8AiQiBT7xyHCafQa9zHNT/9NlD5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5730
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify dpaa2_mac_connect() to support ACPI along with DT.
Modify dpaa2_mac_get_node() to get the dpmac fwnode from either
DT or ACPI.
Replace of_get_phy_mode with fwnode_get_phy_mode to get
phy-mode for a dpmac_node.
Define and use helper function find_phy_device() to find phy_dev
that is later connected to mac->phylink.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

Changes in v3:
- cleanup based on v2 comments
- move code into phylink_fwnode_phy_connect()

Changes in v2:
- clean up dpaa2_mac_get_node()
- introduce find_phy_device()
- use acpi_find_child_device()

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 70 +++++++++++--------
 1 file changed, 40 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 3ee236c5fc37..297d2dab9e97 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -1,6 +1,9 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2019 NXP */
 
+#include <linux/acpi.h>
+#include <linux/platform_device.h>
+
 #include "dpaa2-eth.h"
 #include "dpaa2-mac.h"
 
@@ -23,38 +26,46 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 }
 
 /* Caller must call of_node_put on the returned value */
-static struct device_node *dpaa2_mac_get_node(u16 dpmac_id)
+static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
+						u16 dpmac_id)
 {
-	struct device_node *dpmacs, *dpmac = NULL;
-	u32 id;
+	struct fwnode_handle *fsl_mc_fwnode = dev_fwnode(dev->parent->parent);
+	struct fwnode_handle *dpmacs, *dpmac = NULL;
+	struct acpi_device *adev;
 	int err;
+	u32 id;
 
-	dpmacs = of_find_node_by_name(NULL, "dpmacs");
-	if (!dpmacs)
-		return NULL;
-
-	while ((dpmac = of_get_next_child(dpmacs, dpmac)) != NULL) {
-		err = of_property_read_u32(dpmac, "reg", &id);
-		if (err)
-			continue;
-		if (id == dpmac_id)
-			break;
+	if (is_of_node(fsl_mc_fwnode)) {
+		dpmacs = fwnode_get_named_child_node(fsl_mc_fwnode, "dpmacs");
+		if (!dpmacs)
+			return NULL;
+
+		while ((dpmac = fwnode_get_next_child_node(dpmacs, dpmac))) {
+			err = fwnode_property_read_u32(dpmac, "reg", &id);
+			if (err)
+				continue;
+			if (id == dpmac_id)
+				return dpmac;
+		}
+		fwnode_handle_put(dpmacs);
+	} else if (is_acpi_device_node(fsl_mc_fwnode)) {
+		adev = acpi_find_child_device(ACPI_COMPANION(dev->parent),
+					      dpmac_id, false);
+		if (adev)
+			return acpi_fwnode_handle(adev);
 	}
-
-	of_node_put(dpmacs);
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
@@ -231,7 +242,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
 	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
 	struct net_device *net_dev = mac->net_dev;
-	struct device_node *dpmac_node;
+	struct fwnode_handle *dpmac_node = NULL;
 	struct phylink *phylink;
 	struct dpmac_attr attr;
 	int err;
@@ -251,7 +262,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 
 	mac->if_link_type = attr.link_type;
 
-	dpmac_node = dpaa2_mac_get_node(attr.id);
+	dpmac_node = dpaa2_mac_get_node(&dpmac_dev->dev, attr.id);
 	if (!dpmac_node) {
 		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);
 		err = -ENODEV;
@@ -269,7 +280,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	 * error out if the interface mode requests them and there is no PHY
 	 * to act upon them
 	 */
-	if (of_phy_is_fixed_link(dpmac_node) &&
+	if (of_phy_is_fixed_link(to_of_node(dpmac_node)) &&
 	    (mac->if_mode == PHY_INTERFACE_MODE_RGMII_ID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_TXID)) {
@@ -282,7 +293,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	mac->phylink_config.type = PHYLINK_NETDEV;
 
 	phylink = phylink_create(&mac->phylink_config,
-				 of_fwnode_handle(dpmac_node), mac->if_mode,
+				 dpmac_node, mac->if_mode,
 				 &dpaa2_mac_phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
@@ -290,20 +301,19 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	}
 	mac->phylink = phylink;
 
-	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
+	err = phylink_fwnode_phy_connect(mac->phylink, dpmac_node, 0);
 	if (err) {
-		netdev_err(net_dev, "phylink_of_phy_connect() = %d\n", err);
+		netdev_err(net_dev, "phylink_fwnode_phy_connect() = %d\n", err);
 		goto err_phylink_destroy;
 	}
 
-	of_node_put(dpmac_node);
-
+	fwnode_handle_put(dpmac_node);
 	return 0;
 
 err_phylink_destroy:
 	phylink_destroy(mac->phylink);
 err_put_node:
-	of_node_put(dpmac_node);
+	fwnode_handle_put(dpmac_node);
 err_close_dpmac:
 	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
 	return err;
-- 
2.17.1

