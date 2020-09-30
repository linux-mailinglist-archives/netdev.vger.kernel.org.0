Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB5827EE58
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731202AbgI3QG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:06:27 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:11246
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725355AbgI3QGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:06:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLOoSlgoqnAv3r8yelG40ETLFZ5M5a4BuEI5eY0U9rj1JYz4BMt7X0NknAO6+hWcDDciIZIrCy8AFUvXWVgl+Nq35Jey2z9noLKOzyfDRPG+EwrZNpgSuG5A2QMmmI+6zAnz5OjKGq813xtnWEyRE3JVpcM4seeW/h3731f0z8tDCxo1Cytk0TBcn4Yhl0ZHLesa7CgsnMz5uD5hx4xvDESYapbcBnYn37Hk/SOU40CKXco8YrmlAy0Nrx2FNfICR0S6qxMLlvNl9j8bv987hWNT65wm0aZvK7V6d9my4Jji6Lu/3vx6QvAPwQa51pUTLMs4KhtYhzWZ2xOK3+WrFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyMoqU/rBUT3Rgvjcn5APWweuSROhJSwJIUOFfJvq4k=;
 b=B60AVjSpo5E6XemDib11hKD0Bt7Vs48osF9JsdPZ0Qmq3/Vk541d7RR6jqoiXYNXIug54jdKgEYRztp+9MOZ2oPKULAh4STiLmB6rSck8IFeBc9PZ+hNQV0lAeD9c9agxoHWIHIfhXQuUarktJGeIuEkXKFutwsugsPphZMZdOiyg8kEaJBMq7awaoKAeW0/mGYH2U5DbCXcfp/qATVI5n2VEz+0xX4tZn9u2D3OAnHm35n2f+3S387+Ql7/cqDpg8KJ1M9zLkvhLUMOzxvfdNRugIcofXdaWSvFcsF8UkfmwzuA35NvbkOrGTk9Q+qT8PHJUlooNXBKZ38/c8Ou/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyMoqU/rBUT3Rgvjcn5APWweuSROhJSwJIUOFfJvq4k=;
 b=a/5QarEnKKpxjhAc5pJIVxr0ftgY4ym1ig9Xmzjkn5CZ461m954Cs7BqkcuxFh/GpgBxCxYbmNOkmdNGapx8BQvMxVtw6XPCkMHSRIH8DLCbBwOHjGYPEa1I33sc99WcA/pGGsUN+o83i3Aa6Epq+3GqvyLgAUZTQE6jb4uC4ts=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4225.eurprd04.prod.outlook.com (2603:10a6:208:59::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Wed, 30 Sep
 2020 16:06:03 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.032; Wed, 30 Sep 2020
 16:06:03 +0000
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
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v1 6/7] net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
Date:   Wed, 30 Sep 2020 21:34:29 +0530
Message-Id: <20200930160430.7908-7-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR03CA0168.apcprd03.prod.outlook.com
 (2603:1096:4:c9::23) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0168.apcprd03.prod.outlook.com (2603:1096:4:c9::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.16 via Frontend Transport; Wed, 30 Sep 2020 16:05:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f548f740-6652-4f75-1cc6-08d8655abac2
X-MS-TrafficTypeDiagnostic: AM0PR04MB4225:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4225ADB36DB95B15960F8151D2330@AM0PR04MB4225.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:628;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P1aoRShlpJl9qt0b7tpfQuUnyUMBkom49WE2IKamj26DOz9voh941W8cHNlahqhp8lq1xrsGdl/Kw6rIGb3pgxZLN3JSRLSXJWYLYQ7/K+4tLB34jipkq2GCM2VaKBv6gI627R29n9tZirF5DyZLuLNjcnyxKamkyIl53Ebs5XkxfM+QT+3SFd37nQRbOTlEMeIhfnBdqFUXYPknNbp2ks2NqVNXKP4pBRwtAv6ZHvmif31gQ5srG4yl1OwMOsgGUO1ZfYrL/PWS3cP9QOHQNq185TtfcGQ7MJrx3BHKs/RFtPQq7Tu6lDSr6GF2W9ZWwipYPI88hiXN3cScefdkvlE3uAx1mAoXeFcWT+cZLT33JtXv8ZGL9h7wFbh1IrFd4Q3FoYNU3mUEUDqQ/EFqSap1GTyuR9HjzvaL5sWyv5DyMRDo3aEBbP4+XafcjE+d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(2906002)(8676002)(1076003)(26005)(4326008)(54906003)(6506007)(316002)(478600001)(8936002)(6512007)(55236004)(86362001)(66556008)(66476007)(5660300002)(956004)(52116002)(44832011)(1006002)(6666004)(110136005)(7416002)(2616005)(66946007)(83380400001)(186003)(16526019)(6486002)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HaUoV1FQpnMYR6LZrITZQV8F+rIJ1aE5qg4cB7wI9l3ozAzRnXpHjjbkcJWUctFMa8xlGaz5TXKxHeSVSWf7qn3bL05KlhdntoQnNpXEG/WdXXPhZkqfJ0Pcidi45zdZCb99Vx282mhcvTV3+xzNCwIddt7zpaMrdEnqg0TAyuWCJuAbruPRcpKT0dTKm/2kup4M3L+qZNktAjhoayqqOc/Wm9u3esuupp7P8w167LAAmWJ1k+BwFEWAvgm7jZqtEYqPFsTbcs7fDbjWzpHdO4H8S6sIN9CEeOJTFaq2wnfM61PiKYRIMzxh5+6mSEl+A+XIUsH0BRl0r9Zri/nOPnCQCiF1EvRPh2Igjlz6KRYN9kL3c3WQ3UDYxeT+32/PYW+1/RcovIdvE+3cXJIg/yZqVRSGEquVmvhk8KwQoUKBt/1m1st8UwCe6+IOT1d/Kz5wM1jfbRRhJa0N3Dr5fOzH3lPD2taDrb5pZsfelTKXzLJLaqahloCdeKs+emzE9cp0KNdGe8Uu/JTEbF6vmxhgFjqy5GnFFC1q0gWRmYaoj4aQdAl5GvlcwZIssio7S75wzQkt58gDENgT/gpNciU8vPO1JGt2SS8cv8bSCc1bMLvlELIG7y/RnlUN3Q2NZSlGfVUmf2XmmMuK05UCnw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f548f740-6652-4f75-1cc6-08d8655abac2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 16:06:02.9319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +nMUC9GymHGHOmeYVdBsehUDg8pyvoCQcocglICCmeFKXtS/RQo3Fa2rLEZRg6xjHzm5DhFlJ00fTjCbRXToLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4225
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

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 79 ++++++++++++-------
 1 file changed, 50 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 90cd243070d7..18502ee83e46 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -3,6 +3,7 @@
 
 #include "dpaa2-eth.h"
 #include "dpaa2-mac.h"
+#include <linux/acpi.h>
 
 #define phylink_to_dpaa2_mac(config) \
 	container_of((config), struct dpaa2_mac, phylink_config)
@@ -35,38 +36,56 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 }
 
 /* Caller must call of_node_put on the returned value */
-static struct device_node *dpaa2_mac_get_node(u16 dpmac_id)
+static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
+						u16 dpmac_id)
 {
-	struct device_node *dpmacs, *dpmac = NULL;
-	u32 id;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
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
+				pr_debug("_ADR returned %d on %s\n",
+					 status, (char *)buffer.pointer);
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
@@ -303,7 +322,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
 	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
 	struct net_device *net_dev = mac->net_dev;
-	struct device_node *dpmac_node;
+	struct fwnode_handle *dpmac_node = NULL;
 	struct phylink *phylink;
 	struct dpmac_attr attr;
 	int err;
@@ -323,7 +342,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 
 	mac->if_link_type = attr.link_type;
 
-	dpmac_node = dpaa2_mac_get_node(attr.id);
+	dpmac_node = dpaa2_mac_get_node(&mac->mc_dev->dev, attr.id);
 	if (!dpmac_node) {
 		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);
 		err = -ENODEV;
@@ -341,7 +360,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	 * error out if the interface mode requests them and there is no PHY
 	 * to act upon them
 	 */
-	if (of_phy_is_fixed_link(dpmac_node) &&
+	if (of_phy_is_fixed_link(to_of_node(dpmac_node)) &&
 	    (mac->if_mode == PHY_INTERFACE_MODE_RGMII_ID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_TXID)) {
@@ -352,7 +371,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 
 	if (attr.link_type == DPMAC_LINK_TYPE_PHY &&
 	    attr.eth_if != DPMAC_ETH_IF_RGMII) {
-		err = dpaa2_pcs_create(mac, dpmac_node, attr.id);
+		err = dpaa2_pcs_create(mac, to_of_node(dpmac_node), attr.id);
 		if (err)
 			goto err_put_node;
 	}
@@ -361,7 +380,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	mac->phylink_config.type = PHYLINK_NETDEV;
 
 	phylink = phylink_create(&mac->phylink_config,
-				 of_fwnode_handle(dpmac_node), mac->if_mode,
+				 dpmac_node, mac->if_mode,
 				 &dpaa2_mac_phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
@@ -372,13 +391,14 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
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
+		of_node_put(to_of_node(dpmac_node));
 
 	return 0;
 
@@ -387,7 +407,8 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 err_pcs_destroy:
 	dpaa2_pcs_destroy(mac);
 err_put_node:
-	of_node_put(dpmac_node);
+	if (is_of_node(dpmac_node))
+		of_node_put(to_of_node(dpmac_node));
 err_close_dpmac:
 	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
 	return err;
-- 
2.17.1

