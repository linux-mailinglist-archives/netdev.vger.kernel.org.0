Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE6A2103B9
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 08:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgGAGNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 02:13:37 -0400
Received: from mail-eopbgr10070.outbound.protection.outlook.com ([40.107.1.70]:60875
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726615AbgGAGNg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 02:13:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GaziaAgeoINLJA5pIVp7Ebvnzc5kprrtfHWzxG/LbP5xPlA9wQ+D2QRAWn1lzIdT/G6k2NYlT+srKilHVA3+5WtAaEcMBUaUrQuC2e9NDqGYWH6DHAOnzz+WKFJYXUwnIRRuRPp0miwI+C3lACmCz7j+huF5Bvh9M/bRRIlFIvd2l5Sn9pmGSAm7YSxPyFNXoNyIaL2ghqsNp5hXz7bTzItQIxt/Yy+mqhIPI0zByYUMobwG5hQcVBk2ccqolr8/VkewvQNM5/J6Xqs9N5sk5q3GiWQtIYUGn/VfKEFBmwCprit8jAjNxZtsyzZKYGm+fx2DAAwNe8D0WKEDdu9M2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/yJw4XIgQtFs3W2W/ixMX1wl2ZZqlrgEKkqFid2SEE=;
 b=fdwCDOs5Gkbtfh6FY76WWGfeLFtpI9BTOVumRH7ze0NoDY28ABrLgFpFt4yycFsDacITM/VtYYFHBM0Hso7yiMFjoQyru/NxsvTIpM0JkbjUE+ZJ4tH93oCEQw2HvHd1w4amSBu3ZOcgYNGIVlb6x3lm7FCbe4dmJKbWuZEkbYUJV7sHh6mrct0u2ADYx5vX43W/MUPW26dKZSm2NE7yb3TMIJRWN4YqLfMsAin68Q7OFFiLNRaaiMtz2FXJf1zUYSY57IoOyWuW0f9PwemDc/c3j79yifW67bWMUrxWKMyPC1lFZzHhJWHpnZ7yZriN/s3OrJo4aGp4YnpUDnYl+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/yJw4XIgQtFs3W2W/ixMX1wl2ZZqlrgEKkqFid2SEE=;
 b=RurYNZuB+3ffpnkoZh7N23KFzQz9w/Ohc2oi4vlWP3V/faU2Zth26fig6IdvCNZTsRwET3As4NMJiwV0bNzEyCezm+D2MWdqHWB5ohDdpSq0ffSx1JPZmC/2jaKiMiyJDbw1afwc3G1NmeY5dXcph//GNtzdMVlmBadN1Tc/IrY=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6066.eurprd04.prod.outlook.com (2603:10a6:208:13e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Wed, 1 Jul
 2020 06:13:29 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3131.026; Wed, 1 Jul 2020
 06:13:29 +0000
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
Cc:     netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux.cj@gmail.com, Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [net-next PATCH v2 3/3] net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
Date:   Wed,  1 Jul 2020 11:42:33 +0530
Message-Id: <20200701061233.31120-4-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200701061233.31120-1-calvin.johnson@oss.nxp.com>
References: <20200701061233.31120-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0230.apcprd06.prod.outlook.com
 (2603:1096:4:ac::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0230.apcprd06.prod.outlook.com (2603:1096:4:ac::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Wed, 1 Jul 2020 06:13:25 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed8617dd-aaac-4a2e-a988-08d81d85dfc8
X-MS-TrafficTypeDiagnostic: AM0PR04MB6066:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB60660EA57E87F4D205112E3BD26C0@AM0PR04MB6066.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JBOQwGtn7q5H0QWRs8/wnnsvuW3jJwEVgcDfqy7KwIK+ZhisWfoRMhrpCQhvXxaV8BovSDcnKyNUsphyxImFA7bCoInqpLGRRDJCdcINtSfST7FcyQhZkV4Uf1aXDQQw/miyJl+Xs25b8BY7ptDvcF1N3B0sEY/j8w+foFa2tWIY21/5i6jrhBCefVctXastlFKnThL9c4qnaVbhtoadBAkzqbrwU2nOVmuxoNDKtkwgydx28DKluKyL9dHmg+V8u1+9wFmQFW9HTQhgfwVVuKWxALqCJFjFQMjEYm5F+M+/nKDS/K7DeCED2N/8/ow+JfyYvFKBuzEnZDF6KQ4ZMB613clG8/8WxUMfaRrff/PQiaj7JYuw9ipPy0qx/3LZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(2906002)(6666004)(4326008)(7416002)(6512007)(316002)(110136005)(54906003)(86362001)(1006002)(8676002)(478600001)(66556008)(55236004)(83380400001)(8936002)(5660300002)(186003)(26005)(52116002)(6506007)(44832011)(16526019)(2616005)(956004)(66946007)(66476007)(1076003)(6486002)(6636002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: X7GZe1cfBgcBbMx28NbjpekjIiyQJDAFSdDTKoaouHf/lXM9gV2T3DYyu8h4OSI+pztyQa9Z4oVnOp+NRTbczL95VWWiGAEt17a1hhiLulDNbel1lkHd1Yi7H3v2GrGZh1hzpdg+mj8vmECUTE2s2d5KYIqiWucmPfO/nGnNdwZpB/87lAr9IOf4AY7tHwdlczuaWT4kno8JDcjaLYhBeO/8YYQWv4MPB10FlITZvwxakjH6eqB5ivd9eztATAMTKtN9aTfUhX88ooBFF0YQLtl5Cx9v/t0scoNDBL3jN1SQdqXx2F9HgFkRollExA1+XFRGRc/56Sr2jopuyR67hsZNVbhxI8Xsxo6wgkvNM9cf8WasYPW42UFa4VkVp1oBobuhH/gzoOyLWULUMzi1jfY34SoVEzlkBZIBksZC2+XKmJjzNcMkgvypxN0abfoobrVpczcZxDllGpEn0rfFXMgIsaILLUQdCdUMlpZBYlY=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed8617dd-aaac-4a2e-a988-08d81d85dfc8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 06:13:29.6779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: skYtdUAs6Myh5G7yCRB+EPQqxPb4TQE121pY/ErioJJSAasdqU3VjN81iL17R3jeSA6mzhdAXxfB4G9pII93YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6066
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

Changes in v2:
    - clean up dpaa2_mac_get_node()
    - introduce find_phy_device()
    - use acpi_find_child_device()

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 79 ++++++++++++-------
 1 file changed, 50 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 3ee236c5fc37..78e8160c9b52 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -3,6 +3,8 @@
 
 #include "dpaa2-eth.h"
 #include "dpaa2-mac.h"
+#include <linux/acpi.h>
+#include <linux/platform_device.h>
 
 #define phylink_to_dpaa2_mac(config) \
 	container_of((config), struct dpaa2_mac, phylink_config)
@@ -23,38 +25,46 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 }
 
 /* Caller must call of_node_put on the returned value */
-static struct device_node *dpaa2_mac_get_node(u16 dpmac_id)
+static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
+						u16 dpmac_id)
 {
-	struct device_node *dpmacs, *dpmac = NULL;
-	u32 id;
+	struct fwnode_handle *fsl_mc_fwnode = dev->parent->parent->fwnode;
+	struct fwnode_handle *dpmacs, *dpmac = NULL;
+	struct device *fsl_mc = dev->parent->parent;
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
+		dpmacs = device_get_named_child_node(fsl_mc, "dpmacs");
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
+	} else if (is_acpi_node(fsl_mc_fwnode)) {
+		adev = acpi_find_child_device(ACPI_COMPANION(dev->parent),
+					      dpmac_id, false);
+		if (adev)
+			return (&adev->fwnode);
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
@@ -231,7 +241,8 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
 	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
 	struct net_device *net_dev = mac->net_dev;
-	struct device_node *dpmac_node;
+	struct fwnode_handle *dpmac_node = NULL;
+	struct phy_device *phy_dev;
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
@@ -290,20 +301,30 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	}
 	mac->phylink = phylink;
 
-	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
+	if (is_of_node(dpmac_node))
+		err = phylink_of_phy_connect(mac->phylink,
+					     to_of_node(dpmac_node), 0);
+	else if (is_acpi_node(dpmac_node)) {
+		phy_dev = find_phy_device(dpmac_node);
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

