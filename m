Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C01F22D821
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 16:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgGYOZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 10:25:22 -0400
Received: from mail-eopbgr30054.outbound.protection.outlook.com ([40.107.3.54]:55265
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726944AbgGYOZV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 10:25:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btdofCflL5J/GT9DTrR+p0cjNP2kFOCeP6IAk3Uih8uj3wArbodGnINsR+DWYOGt8J81Yqi/w9Tkb+Wt2/xzT86gA4OZjdBR/IzOt/YK39799hUkEJT2OX29AXeINbo2s6u4uNJiy+2onx5RblExoApKAJkvMIeOIgUHgzCVMsJyFhKvbq1q9dosXsaMIi4RjzcuumgNeIdKg8zEaAHx0aPGw3e7bvz5/xQGkoJYEOQlzY/5FMIA+Q4LXy5aj9y8K/2LF+ZCYzQf2ngUACX6KJMNRa82kG+ePQK28h9EvuZ85+mowhsMYXc6Nn4x5yqRHqoEOMGkRxUjQEjKAtwTDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1a+LynARogaUE+B20N8pKJgKotImA1s+9CwVCTT63w=;
 b=MWR6GyYOXBrLensMOMS5ekinqjaYtTtoFT8Rnhi77kuHqiNMywy5Re9gCRYsNsGpOsXjnLtAfIc3t2K+K/UVPDzxIZfSf6S5XLGAlDIR0SOvcuMQjtxOl5svLbhUYVDhq8ZscoW00unMYWAaal0p/Zsxjv7+7teiSQeXP+FWRH1KL9VkfyTM4VZgx/oHKjdfxlIFIMi/b1veMbVjJTtJQu/NR9yziZbgi4nXBTVummJaWV+kg/LWI3yg+B99MOb7RgsT5zQQ6yEYBM2oJNU7U9UphKDK3yOzOouOmwZntFZS9P/JGjdXTzJgMcIDdzrWOxgYoa0IUSrszYn2vIZOBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1a+LynARogaUE+B20N8pKJgKotImA1s+9CwVCTT63w=;
 b=FiaOgz07IgNddssDXqi/YzeBvIuw6u38Mw9lPiePDbzWStj3dQB4cEHuUy3KtJ8gqv6mGNZc9yadJ7AJ9gcZNJj9517mhMYFrXEslmvKwLnVsuLh6KCJL0hw4BPr5n18pm7sEX5mcj2v6WCjbMeYE3ImUpbEYpOclKOFLXheGx0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4931.eurprd04.prod.outlook.com (2603:10a6:208:c1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Sat, 25 Jul
 2020 14:25:17 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76%7]) with mapi id 15.20.3216.027; Sat, 25 Jul 2020
 14:25:17 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Al Stone <ahs3@redhat.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        linux.cj@gmail.com, Paul Yang <Paul.Yang@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v7 6/6] net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
Date:   Sat, 25 Jul 2020 19:54:04 +0530
Message-Id: <20200725142404.30634-7-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200725142404.30634-1-calvin.johnson@oss.nxp.com>
References: <20200725142404.30634-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0302CA0018.apcprd03.prod.outlook.com
 (2603:1096:3:2::28) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR0302CA0018.apcprd03.prod.outlook.com (2603:1096:3:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Sat, 25 Jul 2020 14:25:12 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3420e7d2-d9bd-402e-6c33-08d830a68d5b
X-MS-TrafficTypeDiagnostic: AM0PR04MB4931:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB49316A65C92DA549CF37831CD2740@AM0PR04MB4931.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8X7RFc83LCdHcRTcLci3PraJ4IomZjZAj2L+Tse/WA3ZA+VhkcH6XoUATgboRjJtGwpul7rHQPtjKuzS0SsUk+IvJSZFbtWEkyoGnHi98zNZ7sD85JZMWQP8sKgCKRqA47QTQPtVsCqOom0dSp0swOVyo5nTwcaii0oWg50aw5nXaSJoXSlMiI2/RC4vAwYIRK+VbGcpmeUhcR4tILeiuOj2pa1xb3TD4gn6b49DwJwqon/J2AmWO5BRPEQHe47zf+TxNwXjysYmym14864ne4c20RtRp6Vzh/QCWEfs5EXHpfjHDewcAXFQiwnhw4TYWw+AeuuJFpKhkLXXrtf99F155amLDS9kK9vi4bIByBVxuT6aNlYJUODZfSg+OiWmT6Fw1Zoe1gBLWAPk8wJKNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(66946007)(66476007)(5660300002)(6506007)(6512007)(86362001)(55236004)(52116002)(478600001)(44832011)(110136005)(8676002)(316002)(54906003)(1076003)(66556008)(4326008)(16526019)(956004)(2616005)(26005)(8936002)(6636002)(186003)(83380400001)(2906002)(6486002)(6666004)(1006002)(7416002)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7l6hcpFI1jkXqoM+4xsHsYLZJGRmv/a4IE1EU7RPZcg/UxcL+O0BR5IHzpgbMXYmfnsv0tR/4SlM9aSAVlpxdVcDuUhJ6IovS8tKCh5FDVdv7GWgzXh/Txfn3wJGq3X/HSRRCi9txuP83vphB+HuB+JhuW/fuPnLEIHOFCj+73D6pphOOatZ7ey8XKq1RHXyCZiE8KeJRdml9EfRGfxDQ72F7bu64ii2g9Z5LtlQ16AfRc+RfJX+wN/UqqCe4WfPhuHMnK0EvyDNLs2QhVux4ZZ5lLNpfqxk2Je3sWXIsu4orAaVJOBfR29qXyKJ5RVk3JQ2SUh2q73x4qSa7WTStwMvw7RqWMGSmoEmF54eDNscgnWE9bu8Gb1rA8W1YPcJwe7aLXjrHAh7dphNBaNjVkm8ghcJdEVQOEU1BUtw+m+ugOc+wtx51GnS3brTTgsUb7XBSPUi0rsC3q9wioDRDWog9UKJCkQ0m93/peV+YSw=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3420e7d2-d9bd-402e-6c33-08d830a68d5b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2020 14:25:16.9697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ms3kebN8lcFwTJX+Ign4Uvca7/WrxIQzjhXBxQszPChN0AgXf5J+YK/ZtSQUJUE9Y2yQ+Us8c9vPLl155XBMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4931
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

