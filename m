Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01425220828
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 11:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbgGOJE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 05:04:59 -0400
Received: from mail-eopbgr60055.outbound.protection.outlook.com ([40.107.6.55]:26718
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730490AbgGOJE6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 05:04:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUrGJyCZHN0gDRhnzwd2S7bzpyuHmERK3uEfrA5mturOPyLI3qewi7GwHlj2OXaOT7uRF7lT9e5CYK2d/xt6NZvKHa8K+dfDLB7Q797at344ONcRD5U4SSk71OLUmHzRxH1xj08Aw3yFIWibIUrlA7NdJiGz5xUcw64CCwG298+6Vs9gthyX3Ni6v7stLPvKAxu0MzSnrPnb5a0iUzX8nhMupHgYt3s1Jy9y2N821IHHO6HHWBt7C63uCWemG3+oa/dbb8UkxZzevQr3DCnAMj285XQ5W9AObNpnX3FK4NkSlFwtmaPkN2UC4xxh2fDnEUONnI7KGE77wkqL6u0p7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1a+LynARogaUE+B20N8pKJgKotImA1s+9CwVCTT63w=;
 b=WOnS7x67UhT1FU+0aHhsv317h2nw7/gidhfjFnrNwSyZ6wwJkLz+hlWF5j9zRQuFJMe0eBPk2J/D2pMSVCkTzd1vU+mTjxOl2CCwO3+NzmPSdHGiQ18dzOMYEECPimXhD/1LF8dJ+/nV01odXGF0zxT8ElCQBFEjnOkhNG4FDDFFzH9t0I8VuhWSMYZtbVBay4I+H1TYC2GQzDgZ9du/KxmN/AkpajnqG1dyzQZNFX1Dauo8nlQx/ijR5gumTFLQXFl3X2FMlKb45aGuX2XXCz6JT/Cf3ZB06ErJp7mo0LyjRKbsoyW0Gaf+ZrgkC7knslJEZdHnLLC4C3t058TwhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1a+LynARogaUE+B20N8pKJgKotImA1s+9CwVCTT63w=;
 b=TeobDDkmtCGpPhkl/YlDKd0Bl6jStATpL9oY4wsrIlEmw8A7dWi1QAa2emG+dq3rjG9Tt9b70jqAUvd4hQE5sy/R7UqSggSgLDHvvDfWJ5OYND35bqRqSBddXhiHAJoioN7Wqycn/SAAIdo9LbVbKlKrecPrMQrZv04qNsotNSI=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3763.eurprd04.prod.outlook.com (2603:10a6:208:e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Wed, 15 Jul
 2020 09:04:53 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 09:04:53 +0000
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
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v7 6/6] net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
Date:   Wed, 15 Jul 2020 14:34:00 +0530
Message-Id: <20200715090400.4733-7-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0070.apcprd02.prod.outlook.com
 (2603:1096:4:54::34) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0070.apcprd02.prod.outlook.com (2603:1096:4:54::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Wed, 15 Jul 2020 09:04:49 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 076f0d0a-7bd3-4e31-f562-08d8289e230c
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3763:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3763B38C536B83C83CE4AF43D27E0@AM0PR0402MB3763.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f8W+kUD4qlwbnUPPVED2t8VGaBDknXAhX4XCh1Gh03bdt6XJv7vLXkBxepqzkw2HKbymmMwpB9sc3mgvpwyDTau7NEDvQkcbafl0v5Qaeb6ams/OG5BhvN6wnNGg7/AQ+seXiKzRrBAL+h7O7gPj+OylQBwjfPD7u7RdJVsQPmGOxhWQ7eaRWodSvJNx+e9Bhc6j2ukMEeBkGMjZCmR4++hRV6VuPNPiDT5n7MKh4Td0pqBfjyKMEd2xUrQ3U/jDdbdvxJMk3YC4Fby4PaUGTdv/t9CENH+qfYi99gdqi0dDrrkjhOfyWAmFnobXGiDbL5wgUzcY0FSOiAdSj04U7hDYbFYHN1dW6ltcwjpQ0zV2OT/Pvj0E81iI7ibQlyIO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(5660300002)(110136005)(2906002)(6512007)(66946007)(6666004)(66476007)(86362001)(1006002)(4326008)(66556008)(52116002)(44832011)(316002)(956004)(83380400001)(26005)(6486002)(2616005)(6636002)(6506007)(55236004)(1076003)(186003)(16526019)(8676002)(8936002)(478600001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9ygtOeEc6v3Bc2J5QJFsiHTvrmmtYQdrateCuiPcak3fJthd68oVAbqqhf41hvEoznSzMyAcIWs+3er2mOZuioY151O2U/BFXpzIwW+UsaEMnOFHvF8zfbBC2KNOTL7vFOkJPJvwuvjzN0S3L5Xeg/CuT3SmMRhRk0N/P75w1XAZsEJVq7c225iOthm9y1eOPH8EBRWYxbpXXwZzRd2APTUTFqBmqltPr0gu+dF+IefPQ6carx+XTShmfkA7Wiqq+vhVUj5wVKY3EDwJWJp+9yUNuIN8lCeZ7N+8cbN27yezVk1T8lgMPRgQeAfvdGRsLI+JDVKdoGEkJClWZSnguqd9hSMEgE0b+LTN99x3ve1LJW5IkbCm1AiGDHkOYzp+5CSwgAhYXdggSmqTSZtFdc5kmBlg1P1CrbSsZCjRcC6EEdJaJiP/75EiwrJdcTuuZ3zkUTcm/S6uQErhhBk6U4H6rCU08wQz4Hh78UThugpx8VjNy4D/wW9tU8BF02nE
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 076f0d0a-7bd3-4e31-f562-08d8289e230c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 09:04:53.2999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7WZM4Sn181VUHH1z1PC5pezxU9SamFNppBMau6HELG6a9+DZNMf4x5YtgYUs5+Mk3HbnJcDvRUDQ25U7LWDB+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3763
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

Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4:
- introduce device_mdiobus_register()

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

