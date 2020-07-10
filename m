Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B94121BB09
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgGJQcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:32:17 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:61635
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727065AbgGJQcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 12:32:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eG7KTnpYU8rbMhresZigpE9P4NljIsMCabnEbYHifziOMn/zaQES+O02+frOl7k9Wr4QA7xRtUje/ytOuYiKgE3aU8QVWl2qryYPNS9wKCsROlcTZUUwtq/7zCHCfdkB9CtylqsQOWU2JnTB6rpOiWLqBr8NCV1Uxnwy23RQI1nGjQhJ1Up6NPGiQQNWsVsOXK0dPvEsb70jyD8fix78IE8o0aLOEHV+rnNR7K2FR+wUftyNFpIZwIFsK9XD+EjVsxrQI9I3dxpvxNCQp+yYaaolT/dkalldJDrZPqSCAj6FVzExSekfNXf3p57xIyvM9qbwT5E3RYwa0nSehuRLlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jD6wzL+Ox42uosACvyWOy+0bWlltFD2XjLP/2Nlpbo=;
 b=PXn2ZHvyd+7aVcCzuypO0MT+UEFpOfpSE8acZ4qQY9kBLKhIew4IkvoBLKG26H4d2rCNwwc324O6JN37Ng3IXxIE7btxvWTRlq0gUDWiTRAix3pWSTGviWTVBhXuvFGiHGkPerhmU+2RS0f2jCZTUWHD4wzVtyjIYr+yxkllQVTrCZZG6I0Xhvphps/Pu+E949ZWAvLD44Ocv8BDJCJ49B8vE6MCUSlvPYF8cZuog0t81RzH+Z62Bo5yYLJW+evlQpAVDQ/k9tw/8YQmKyyHa+uk2nDeeRBs8go8rWiKX56Hv+yY91jZrG+nhkzmtB9TqhfPYKpoIjnVeNt5b3D/MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jD6wzL+Ox42uosACvyWOy+0bWlltFD2XjLP/2Nlpbo=;
 b=G98mkjflMfWoNA1gNAGSkfPWwxWHPO4TanKvkvCM80jcYAEAmRaaDaOWluw4RqybIGrHmxCFsn5CK6Ux1pFsdh4kg8ON+GFH71l3PvtVbN8dToV1WB7N4+tE5I5174rTDH+Szsa3xTo3wLRHiXyi5x+g6btnVpNh7o8t6VS8JIw=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3908.eurprd04.prod.outlook.com (2603:10a6:208:f::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 16:32:06 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 16:32:06 +0000
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
Subject: [net-next PATCH v5 6/6] net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
Date:   Fri, 10 Jul 2020 22:01:15 +0530
Message-Id: <20200710163115.2740-7-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200710163115.2740-1-calvin.johnson@oss.nxp.com>
References: <20200710163115.2740-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0137.apcprd06.prod.outlook.com
 (2603:1096:1:1f::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0137.apcprd06.prod.outlook.com (2603:1096:1:1f::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Fri, 10 Jul 2020 16:32:02 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7c2fb665-9aba-4d4c-a984-08d824eec8a8
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3908:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3908F3DCA8A3D31DE7756AFDD2650@AM0PR0402MB3908.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b0+JN3Fp5j2CU5+FCspJjxb/CcixObgCMnG73X0C6qeuGWwo3N6OR1Y2Ae9Q5lpiWYA1odtbpcmvPNYgIwgKQZPF9k71KKHlPGWX2ce/SSyM/Padm5/a7rXVQAWLu11rXoodBNYmurKSS130lOEYuqvEG+tiEfc6AJSYFbx1fl+vBQrN59CH/Q7llrBjUoT+/D1FVzYdzKx3kaz3cmuNyp7CZkZ2MGaMZheBpVTCS7pjFGGXPj0qvEcHqtBQUX05HXV1msih/jlUASiiAWv5uVkEHyJdI+DcppEk2R4nez7DpJhc2QwSxlTw12EciaReObr6Wj+8K8A4dTxYUBNy+fu76ZFc2VeT+06HNFmEArifFiawuA8SIEfzeZa08XRI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(4326008)(8676002)(2906002)(8936002)(86362001)(26005)(6512007)(52116002)(83380400001)(1076003)(6486002)(316002)(16526019)(110136005)(1006002)(66476007)(66556008)(6666004)(478600001)(956004)(66946007)(44832011)(5660300002)(186003)(6506007)(6636002)(55236004)(2616005)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: r/aWSD61mgJg6VxSsNAWGJFLKdqEfpgHljeNmbTC2aip9ECLTBWmZ1elDGOCDgQvjlOXqF8mZJihsB2ZswnUloU++c0WpEhbxMAdy8waT22HS6RGlOGXdLb3qzRFe90ZD27jWF5CKETfOdwcMK3ycXaV8hv3cshaKRgKUibtIjHXqIqsc+Rq45CcF4pNTXVJEvjwUE+OxT6J26Ukj1qxXsQNfCt+966om4uhAN54PPIB9GaUbum2z3qzn0yFxhoGEAOIB76g5AqBdXisxFmSk6h3s7eRcNCBDtDz4ZJEIe6BSsjrlMklCwaJZuVct8X0EDyAbeNDkuZ2/sR7deE1ZDP86toYM7eqjswb279loDCSwZDxw6c55NCchyYjCjs6hyw0gJNiul3mvzpEc6k5HhuCs3whxIoX8tDCBXhGfMDnsPp+SGPKaKC5uWHthDjQuXfY6vxHKl1SsvSMe7U0/GILa0wgsAFjgd1wtXp33jfW29gncjCE+1kqtId74ivq
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2fb665-9aba-4d4c-a984-08d824eec8a8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 16:32:06.2117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJV0LEaypQ/HrbBpCgGQeX8Egm32MnZ6OAtJRrmK0effTrNJ3uuB98FVz1S3ugw44TYYlwsE+ef9fzWHK2LUGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3908
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

