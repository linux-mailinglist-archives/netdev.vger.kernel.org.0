Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C77C14EFB2
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgAaPgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:36:09 -0500
Received: from mail-eopbgr150074.outbound.protection.outlook.com ([40.107.15.74]:17057
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729286AbgAaPgI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 10:36:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edSsApinKazZ8KksMS7lPsbHP2+81YVzPcFWqnr7aALB/WxudjiYMSXiG6ZuLR/G4pMfUKRpxoVGC15pSdEiAqS8JC7O4LJuFalLj10hYt+HbIdAOpqIGh6zDtDAt8bBLDXn8+2DGczZu+hCmlujffWm4RFFFGUuuYBwjz3xWZlE/yqhVf6cn/N5pd6+in/JIgGhSotvadJnyQHpX7MMO9abXBu6/QJlspWK+earPh/1Q3ZeRPNViFEkRSErGXEoMydYW7AdznfIuWQ9oOr6q3Jp7mPwJ2qjDhOUJT0d2Dy68sFCMP/zx/gLhUqV2ARg9EA4lRLKKoBPNt5+wiayFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TwGOicNnzeq2GnTIJ2qxqZ8J9KSEynaNV7JqA5nHp0=;
 b=GVDZTiyWFnCdfizW5qHUbVkZXYeGPcmcpNy+5lvQjkExiacXYDjUPEdgobGnoLpTDHibvHihMgO+k/Z7H8aWEdVvkE5ZI4kOliMIpVZ7UqTEa/ESM3V4S8UcyGZ1K1yoO98Rj7xAB05w4/ti7GGapRu73dOReo2//i2Nn88/gdJcIOVzlEq+Fi6Fp54VOkgxZHDMtq2rOQvcLlHr7G8SnZheakCRRfk+WC4gQm7INq35x2gJiGQ3Yar8w8lL8tKlBNukJwmnyWMgfsRJf1YeImrp64XDyo9c/OAj1ogpWrjfXlMSLQjKQxRc9qE3aNeT0QkXkxSu4XmqCbCeIublXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TwGOicNnzeq2GnTIJ2qxqZ8J9KSEynaNV7JqA5nHp0=;
 b=spafmJCWteXf8z6b2A9nw4wVC2EK5H5oIOvl9RrA7XqNIukaxHQPN+BKP06IEPuizCFdKZ1guowhwtfU/8YuNh8uER9S/cX3AY3J8UQkMhTSuW2dlGEsi1RLgoA6g523lcboNYVEEvtwTfLwT7DRolZ0zs4mqHqJapyNbVwVGSM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@nxp.com; 
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com (20.179.10.153) by
 DB8PR04MB6730.eurprd04.prod.outlook.com (20.179.249.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Fri, 31 Jan 2020 15:35:55 +0000
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::e1be:98ef:d81c:1eef]) by DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::e1be:98ef:d81c:1eef%2]) with mapi id 15.20.2686.025; Fri, 31 Jan 2020
 15:35:55 +0000
From:   Calvin Johnson <calvin.johnson@nxp.com>
To:     linux.cj@gmail.com, Jon Nettleton <jon@solid-run.com>,
        linux@armlinux.org.uk, Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 7/7]  dpaa2-eth: Add ACPI support for DPAA2 MAC driver
Date:   Fri, 31 Jan 2020 21:04:40 +0530
Message-Id: <20200131153440.20870-8-calvin.johnson@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200131153440.20870-1-calvin.johnson@nxp.com>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0061.apcprd02.prod.outlook.com
 (2603:1096:4:54::25) To DB8PR04MB5643.eurprd04.prod.outlook.com
 (2603:10a6:10:aa::25)
MIME-Version: 1.0
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0061.apcprd02.prod.outlook.com (2603:1096:4:54::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.29 via Frontend Transport; Fri, 31 Jan 2020 15:35:51 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc82fe5f-ec83-46d5-e485-08d7a6634329
X-MS-TrafficTypeDiagnostic: DB8PR04MB6730:|DB8PR04MB6730:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6730305B212ED7E043B8BA2B93070@DB8PR04MB6730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-Forefront-PRVS: 029976C540
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(189003)(199004)(52116002)(7696005)(1006002)(66556008)(66476007)(2906002)(66946007)(8676002)(110136005)(55236004)(8936002)(26005)(81156014)(81166006)(316002)(6666004)(478600001)(54906003)(1076003)(36756003)(6636002)(6486002)(186003)(16526019)(5660300002)(956004)(86362001)(44832011)(2616005)(4326008)(110426005)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6730;H:DB8PR04MB5643.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zoEC0XdM1PLztDjWJTltvhk1y+Me5owK8bUMViaQIauj05PHfr0Ie294LOyZvB6DVbnJxm+9uuGIU+DRcYZyeAwJAs3pwf3EV9IVEHNLm/JrotNlCyI77evciUeQ3EkoJFFH503qguD+zEkDDeFhFCzHTDDPgGfeWw+gpJ9S7PG6FlxVc77bnj7u+l1r2vzL/KBLCQo+/J7UXD36Pqj/nnm0Eq2NVaLRpa8oOE2Aod3hN2OSs77NRGptv1bF6hqOJkASVAvHVeoDz/PdIMz1+b7pmha2zXdG9I6e5nVecsBA7WZ1YjxbFIZOwUckH58uzT4pCc5yoxxfMPRIBJ6gzqUcfMT/ZCe5cZjnZUqmdkJQmdgKhwkWYwp8vXlJgHddjoM6cy5EiunrCvC2MIIlcI+quoMa0/bBrf/ApPFPlMNYR2jgMlfVtpPfQoBoE3Jo9zHF3TCubJSsIDURGp0TtrrGeRbvbJUfOdPY6Vj2lKXEWjyHaT2HWeirtwJ4+KLLgi0w6h3iFNhgO4oCqmta4jBpH4E30jww2WIfU/RFyWI=
X-MS-Exchange-AntiSpam-MessageData: RScqU1P6QLkKQE1OZebrUxyHK3bkLgIBs2JfraARMDePreF8wx1TWjrMPhLWKZjNZVF6ngyUIM9Tt/Z6C3i7srFR4SIvn2g7VAugr/pSnRUgJnomUdDdMeq894npicm59ncSrZWmZQhJg+hrlHzW8Q==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc82fe5f-ec83-46d5-e485-08d7a6634329
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2020 15:35:55.6635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fk0reexQYRXN9Fl67WEkiKZ8FxabiR5cumy/21bqVZ08X/CqPT6F7ynFejcbhUMs3cESHZ9XoofUwZ+vydZJVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6730
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

fwnode APIs are used to handle both DT and ACPI nodes.
Whereever common fwnode APIs cannot be used, corresponding DT
and ACPI APIs are used.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 78 ++++++++++++-------
 1 file changed, 50 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 84233e467ed1..29d2d85383de 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -3,6 +3,7 @@
 
 #include "dpaa2-eth.h"
 #include "dpaa2-mac.h"
+#include <linux/acpi.h>
 
 #define phylink_to_dpaa2_mac(config) \
 	container_of((config), struct dpaa2_mac, phylink_config)
@@ -23,37 +24,51 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 }
 
 /* Caller must call of_node_put on the returned value */
-static struct device_node *dpaa2_mac_get_node(u16 dpmac_id)
+static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
+						u16 dpmac_id)
 {
-	struct device_node *dpmacs, *dpmac = NULL;
+	struct fwnode_handle *dpmac_fwnode;
+	struct fwnode_handle *dpmacs, *dpmac = NULL;
 	u32 id;
 	int err;
 
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
+		device_for_each_child_node(dev->parent, dpmac_fwnode) {
+			err = fwnode_property_read_u32(dpmac_fwnode, "reg",
+						       &id);
+			if (err) {
+				dev_err(dev->parent, "failed to get reg\n");
+				continue;
+			} else {
+				if (id == dpmac_id)
+					return dpmac_fwnode;
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
+static int dpaa2_mac_get_if_mode(struct fwnode_handle *dpmac_fwnode,
 				 struct dpmac_attr attr)
 {
 	phy_interface_t if_mode;
 	int err;
 
-	err = of_get_phy_mode(node, &if_mode);
-	if (!err)
+	err = fwnode_get_phy_mode(dpmac_fwnode, &if_mode);
+	if (err > 0)
 		return if_mode;
 
 	err = phy_mode(attr.eth_if, &if_mode);
@@ -220,7 +235,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
 	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
 	struct net_device *net_dev = mac->net_dev;
-	struct device_node *dpmac_node;
+	struct fwnode_handle *dpmac_fwnode = NULL;
 	struct phylink *phylink;
 	struct dpmac_attr attr;
 	int err;
@@ -238,25 +253,26 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 		goto err_close_dpmac;
 	}
 
-	dpmac_node = dpaa2_mac_get_node(attr.id);
-	if (!dpmac_node) {
+	dpmac_fwnode = dpaa2_mac_get_node(&mac->mc_dev->dev, attr.id);
+	if (!dpmac_fwnode) {
 		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);
 		err = -ENODEV;
 		goto err_close_dpmac;
 	}
 
-	err = dpaa2_mac_get_if_mode(dpmac_node, attr);
+	err = dpaa2_mac_get_if_mode(dpmac_fwnode, attr);
 	if (err < 0) {
 		err = -EINVAL;
 		goto err_put_node;
 	}
+
 	mac->if_mode = err;
 
 	/* The MAC does not have the capability to add RGMII delays so
 	 * error out if the interface mode requests them and there is no PHY
 	 * to act upon them
 	 */
-	if (of_phy_is_fixed_link(dpmac_node) &&
+	if (fwnode_phy_is_fixed_link(dpmac_fwnode) &&
 	    (mac->if_mode == PHY_INTERFACE_MODE_RGMII_ID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_TXID)) {
@@ -269,7 +285,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	mac->phylink_config.type = PHYLINK_NETDEV;
 
 	phylink = phylink_create(&mac->phylink_config,
-				 of_fwnode_handle(dpmac_node), mac->if_mode,
+				 dpmac_fwnode, mac->if_mode,
 				 &dpaa2_mac_phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
@@ -277,20 +293,26 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	}
 	mac->phylink = phylink;
 
-	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
+	if (is_of_node(dpmac_fwnode))
+		err = phylink_of_phy_connect(mac->phylink,
+					     to_of_node(dpmac_fwnode), 0);
+	else if (is_acpi_node(dpmac_fwnode))
+		err = phylink_fwnode_phy_connect(mac->phylink, dpmac_fwnode, 0);
 	if (err) {
-		netdev_err(net_dev, "phylink_of_phy_connect() = %d\n", err);
+		netdev_err(net_dev, "phylink_fwnode_phy_connect() = %d\n", err);
 		goto err_phylink_destroy;
 	}
 
-	of_node_put(dpmac_node);
+	if (is_of_node(dpmac_fwnode))
+		of_node_put(to_of_node(dpmac_fwnode));
 
 	return 0;
 
 err_phylink_destroy:
 	phylink_destroy(mac->phylink);
 err_put_node:
-	of_node_put(dpmac_node);
+	if (is_of_node(dpmac_fwnode))
+		of_node_put(to_of_node(dpmac_fwnode));
 err_close_dpmac:
 	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
 	return err;
-- 
2.17.1

