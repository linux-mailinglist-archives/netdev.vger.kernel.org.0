Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66AB6209923
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 06:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389457AbgFYEgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 00:36:13 -0400
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:45538
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726400AbgFYEgM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 00:36:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evd4qUkYUZd9GB8xp5CapuZapZnz8nXoaKy//VHeMDSxyvrGsomKEzn2YjkkkL6lXoimRoyt3uio6PQrAzM4wKPS9RzsBAMfFIJiPDit/P130upVryyjFIek6o05TkU7XGd87v+oQBJAvVd9kVq5lrzeW4id7rsH/ORfFgoM+fu3JxS1um53fCZvQY/3rHu6YTyROrHByb2pPQm8qM5frdl+7FCOg3IKi3GLdzTdS5Z2rKceoZHsh4DtM6++3SoCFAG+O8tCGIqw3+fm6xXO5bqeWWanfF7STqKXhMafh9+nhEWVHEsQ33fkQVJrgMo6gzvswZ0vORd7hAQyC7hSnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kM/azCT6rtz3DaB5NkGbYT3PyD8BwBLRG2pck20jlTk=;
 b=MMx+z5h/7FlIjv+VZSb/Skzue16miRajQR6UDmKnIIAUZcuV42y4BoZsImh94C0qSHMJFt9vpdU4HiAnmKBEZT58/N9PHscNX0LZPElBFL1a73w7LTtQI1/VJKVahHYl0mJdWwyZbyL9O3VH+J9Q1CeOUZQv0iI2mJNw6dd2kID9tfofutKDTtY4CRM+lX8pk77X281tDCoXUb10DVTfhFaDwczaR69i6D+qWIexdhz20UE/l+is/V+Oi1I1K83P+U/GanK+hQyGtWJSfE4k/+5aZeQ4sNN8B3YVGLI3ETkIIwQkQpJjEZPDii8qP2pDHY4bhuIddwQgQUY2Q5Kj2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kM/azCT6rtz3DaB5NkGbYT3PyD8BwBLRG2pck20jlTk=;
 b=mqI0dAYbX7I7lJa0POIyuzXROs5dpF6fGAacvANqaQGdvXQNxTV6zTV0eNJZxNKA7kt0BcVTCxqrp5yPpypGAjb7zeCcHnp+NnewFrZiPoT7wshGhMPFUipneovtmWu57RdIpKWae2VECGRry/oB+764BLRn6iRprJ2wMal16HM=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5683.eurprd04.prod.outlook.com (2603:10a6:208:12b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Thu, 25 Jun
 2020 04:36:07 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3109.027; Thu, 25 Jun 2020
 04:36:07 +0000
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
Cc:     linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v1] net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
Date:   Thu, 25 Jun 2020 10:05:38 +0530
Message-Id: <20200625043538.25464-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:3:18::21) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0033.apcprd02.prod.outlook.com (2603:1096:3:18::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.27 via Frontend Transport; Thu, 25 Jun 2020 04:36:03 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e0737073-0539-4e60-9fbf-08d818c146c7
X-MS-TrafficTypeDiagnostic: AM0PR04MB5683:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB56834F213CE5B1D508F07476D2920@AM0PR04MB5683.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-Forefront-PRVS: 0445A82F82
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +YYFeCTtINjKVhUC1ofc1+BiUcxJHGsOtDMvwrEIy1ltBSx8N1sywh6YfaAlsxDZwWgDIW2yohT6qg1j4/6OmIFNBn1535qQwlWgA4vkQnaK6b5dMSJQRSpMCjFBV+sugfdaXWYVw3KBpD3gYZVjzrGJA+tQJpQgmqdOQvmFG6gw7IoXnd790gGsXeW/WNWSO/LkL+VBLyigcy+Rv3kWuMWLgB3VKE0DfbZZkgOqtRsuOLcY6k9UyCFUysracnJzKJpFo9yb3zjhTAoFmmKyTuFZBcADVdv95fVyqqLnjG4Od24Cuq6g+lWUMOm4tfPqC6nE4ipqQvzu1IAwF16RnoCcGSQbDOTL1CV2+T+iG2l98F1RlFQXVSXXa/fT0Erp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(66476007)(6636002)(83380400001)(66946007)(66556008)(55236004)(52116002)(4326008)(6506007)(2906002)(956004)(8676002)(478600001)(1076003)(316002)(2616005)(6512007)(6486002)(26005)(8936002)(5660300002)(86362001)(186003)(110136005)(16526019)(6666004)(44832011)(1006002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kMN+b2AGP6oo62YI1W6vw/mBDtPlLi1BSSnbsVVdAVJlwgY2p49ZIeQOqcC+DmSf0kXaHCxwlqsB7Dm+QhqHGkbJkY4muGH9jh0YM85Hl/NgNvIRXTZAPt8k3He6egb6zMkgeoiEq4uASK5KIpYtcJFuhbQG7AtFEY1+XmKlTBq5OvcfOp79LC3HKInsTK5B3s0/AudHlrvVOQgvMd1BpKRzYgBZtfucPcSvupmxGvEPaLRXjAscZjsLWgalurhyFoD5tB5xH/g9WnwKRGUZrTQe4dKPugKWwlSo7qDU2Zpx71/+OiyFWFjzl0FVfhjJxd5M0gG8VtywBYCQuKmixHEPItlCiOgHYHB3CKx5USGY3MZ/TNty+mOJczobWio8A7VPACFR/nns1yyXE0IVkr2+lgargiURxe7CCejZAqerO+1JFYT+OY9E5yLPqU9GT+RufqOqPtpYXL1x2Kh7mqo9vMK2g5LQiL/RxjrTd6IdDSZEyatEjmjEbsx7AcS1
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0737073-0539-4e60-9fbf-08d818c146c7
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2020 04:36:07.2365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RIxYsGBY2dtRmQcac3ShBldo4LvNekjj3++ZcrR3tOeuhMeYQqSTu25nET7ZGWXwdkTqvLR0cMwbG09m1iFJiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5683
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify dpaa2_mac_connect() to support ACPI along with DT.
Modify dpaa2_mac_get_node() to get the dpmac fwnode from either
DT or ACPI.
Replace of_get_phy_mode() with fwnode_get_phy_mode() to get
phy-mode for a dpmac_node.
Define and use helper function dpaa2_find_phy_device() to find phy_dev
that is later connected to mac->phylink.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 114 +++++++++++++-----
 1 file changed, 86 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 3ee236c5fc37..163da735ab29 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -3,6 +3,8 @@
 
 #include "dpaa2-eth.h"
 #include "dpaa2-mac.h"
+#include <linux/acpi.h>
+#include <linux/platform_device.h>
 
 #define phylink_to_dpaa2_mac(config) \
 	container_of((config), struct dpaa2_mac, phylink_config)
@@ -23,38 +25,54 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 }
 
 /* Caller must call of_node_put on the returned value */
-static struct device_node *dpaa2_mac_get_node(u16 dpmac_id)
+static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
+						u16 dpmac_id)
 {
-	struct device_node *dpmacs, *dpmac = NULL;
-	u32 id;
+	struct fwnode_handle *dpmacs, *dpmac = NULL;
+	unsigned long long adr;
+	acpi_status status;
 	int err;
+	u32 id;
 
-	dpmacs = of_find_node_by_name(NULL, "dpmacs");
-	if (!dpmacs)
-		return NULL;
+	if (is_of_node(dev->parent->fwnode)) {
+		dpmacs = device_get_named_child_node(dev->parent, "dpmacs");
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
 
-	while ((dpmac = of_get_next_child(dpmacs, dpmac)) != NULL) {
-		err = of_property_read_u32(dpmac, "reg", &id);
-		if (err)
-			continue;
-		if (id == dpmac_id)
-			break;
+	} else if (is_acpi_node(dev->parent->fwnode)) {
+		device_for_each_child_node(dev->parent, dpmac) {
+			status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(dpmac),
+						       "_ADR", NULL, &adr);
+			if (ACPI_FAILURE(status)) {
+				dev_info(dev, "_ADR returned status 0x%x\n", status);
+				continue;
+			} else {
+				id = (u32)adr;
+				if (id == dpmac_id)
+					return dpmac;
+			}
+		}
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
@@ -227,11 +245,41 @@ bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
 	return fixed;
 }
 
+static struct phy_device *dpaa2_find_phy_device(struct fwnode_handle *fwnode)
+{
+	struct fwnode_reference_args args;
+	struct platform_device *pdev;
+	struct mii_bus *mdio;
+	struct device *dev;
+	acpi_status status;
+	int addr;
+	int err;
+
+	status = acpi_node_get_property_reference(fwnode, "mdio-handle",
+						  0, &args);
+
+	if (ACPI_FAILURE(status) || !is_acpi_device_node(args.fwnode))
+		return NULL;
+
+	dev = bus_find_device_by_fwnode(&platform_bus_type, args.fwnode);
+	if (IS_ERR_OR_NULL(dev))
+		return NULL;
+	pdev =  to_platform_device(dev);
+	mdio = platform_get_drvdata(pdev);
+
+	err = fwnode_property_read_u32(fwnode, "phy-channel", &addr);
+	if (err < 0 || addr < 0 || addr >= PHY_MAX_ADDR)
+		return NULL;
+
+	return mdiobus_get_phy(mdio, addr);
+}
+
 int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
 	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
 	struct net_device *net_dev = mac->net_dev;
-	struct device_node *dpmac_node;
+	struct fwnode_handle *dpmac_node = NULL;
+	struct phy_device *phy_dev;
 	struct phylink *phylink;
 	struct dpmac_attr attr;
 	int err;
@@ -251,7 +299,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 
 	mac->if_link_type = attr.link_type;
 
-	dpmac_node = dpaa2_mac_get_node(attr.id);
+	dpmac_node = dpaa2_mac_get_node(&dpmac_dev->dev, attr.id);
 	if (!dpmac_node) {
 		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);
 		err = -ENODEV;
@@ -269,7 +317,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	 * error out if the interface mode requests them and there is no PHY
 	 * to act upon them
 	 */
-	if (of_phy_is_fixed_link(dpmac_node) &&
+	if (of_phy_is_fixed_link(to_of_node(dpmac_node)) &&
 	    (mac->if_mode == PHY_INTERFACE_MODE_RGMII_ID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_TXID)) {
@@ -282,7 +330,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	mac->phylink_config.type = PHYLINK_NETDEV;
 
 	phylink = phylink_create(&mac->phylink_config,
-				 of_fwnode_handle(dpmac_node), mac->if_mode,
+				 dpmac_node, mac->if_mode,
 				 &dpaa2_mac_phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
@@ -290,20 +338,30 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	}
 	mac->phylink = phylink;
 
-	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
+	if (is_of_node(dpmac_node))
+		err = phylink_of_phy_connect(mac->phylink,
+					     to_of_node(dpmac_node), 0);
+	else if (is_acpi_node(dpmac_node)) {
+		phy_dev = dpaa2_find_phy_device(dpmac_node);
+		if (IS_ERR(phy_dev))
+			goto err_phylink_destroy;
+		err = phylink_connect_phy(mac->phylink, phy_dev);
+	}
 	if (err) {
-		netdev_err(net_dev, "phylink_of_phy_connect() = %d\n", err);
+		netdev_err(net_dev, "phylink_fwnode_phy_connect() = %d\n", err);
 		goto err_phylink_destroy;
 	}
 
-	of_node_put(dpmac_node);
+	if (is_of_node(dpmac_node))
+		of_node_put(to_of_node(dpmac_node));
 
 	return 0;
 
 err_phylink_destroy:
 	phylink_destroy(mac->phylink);
 err_put_node:
-	of_node_put(dpmac_node);
+	if (is_of_node(dpmac_node))
+		of_node_put(to_of_node(dpmac_node));
 err_close_dpmac:
 	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
 	return err;
-- 
2.17.1

