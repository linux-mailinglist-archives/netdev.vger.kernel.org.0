Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDDA1AEBFD
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 12:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgDRKzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 06:55:46 -0400
Received: from mail-eopbgr50084.outbound.protection.outlook.com ([40.107.5.84]:30181
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726224AbgDRKzp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 06:55:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPlJoMUay0neJ2YFBMHG5XsqVOL+dMcq4WUoyd7gbd/j6yevoHFBy27LYkH6ohVMnhHZpWmgwSLH8/7FOwStOYy4GgyfAi2l+UkUMXf3mpd4sc+GChymXXXIpwDNXx/H4Nb6Pyly6ej96QdSttYmqLNcrJtAxNwi4MnaVAuweP2EI/qk5A/hQ/LmWgv8idxJRrdZ+czRaHfxPPPTDFuJfyEnA3oySaBmaEjCH09PmzKe2gZYDr0U/YywAH8b+388Pzht+rp9GZqHyVgoeYJCvFh9/0saFSLob6dn9f+XZPhx4QK1G0RbGNNfSMMzPtLOu51GVBRRZboQUeJBVYGpyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0l56irLD1C8aWBRjDKWr+jrOD801c2V+/NafQPp0oyM=;
 b=BBv5Y2hgXv1qpUg+wMg8Zun+Zyy2pZOBy6J7cMlivpd137Q6/99iraVLQ0IZV+UOE70UFfVh4leMGYDzEQOzoesmY4UKGLzpSSePWjWIIMYHtbb4BkrQIBy7zHNFUXV9ZiRecPFytqDIWU7unX4ot5JWWmG8LeLDUjYtn/XW8NZK182vEgm4AVc+14VobQ9trW8lDNSeUzpIZsE19yJhA9483h09SKH+PJj1FNAumbFHv6BAx5zjtMxJr5NSdFu824AeHgPlryvOMTmOrVYqM7vKFDMql9DGUUkbD2k4rnLebnL9uya43pwYthVCUx4hnK5ELRqSRYrsWTqgweR6Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0l56irLD1C8aWBRjDKWr+jrOD801c2V+/NafQPp0oyM=;
 b=Gk35Q4397vR6z+eippu3i4S79NuUM8QRWcv4DNBEvqyjvelHu9nj99edMj8zRO4ZJfvCtB9EuAzkCj7GmisgveE/MrZXC5p2R0qToXIsMDzL+c9uS9CDjQ0DcrMGNx0ka3N9rMn10pHut3Xsprq/GkQs27mwlDKGSEMUX3gS0rA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6899.eurprd04.prod.outlook.com (2603:10a6:208:183::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Sat, 18 Apr
 2020 10:55:40 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2921.027; Sat, 18 Apr 2020
 10:55:40 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, Varun Sethi <V.Sethi@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: [RFC net-next PATCH v2 2/2] net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
Date:   Sat, 18 Apr 2020 16:24:32 +0530
Message-Id: <20200418105432.11233-3-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200418105432.11233-1-calvin.johnson@oss.nxp.com>
References: <20200418105432.11233-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0099.apcprd03.prod.outlook.com
 (2603:1096:4:7c::27) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0099.apcprd03.prod.outlook.com (2603:1096:4:7c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.6 via Frontend Transport; Sat, 18 Apr 2020 10:55:35 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aaa37b56-c8e5-4716-8e7c-08d7e38708df
X-MS-TrafficTypeDiagnostic: AM0PR04MB6899:|AM0PR04MB6899:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB68993E7CB3C4B47FA2086D06D2D60@AM0PR04MB6899.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-Forefront-PRVS: 0377802854
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(478600001)(1076003)(86362001)(81156014)(26005)(4326008)(8676002)(8936002)(1006002)(6666004)(6512007)(316002)(6636002)(7416002)(186003)(16526019)(54906003)(110136005)(44832011)(2616005)(2906002)(956004)(52116002)(66476007)(55236004)(66556008)(6506007)(5660300002)(6486002)(66946007)(110426005)(921003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: brPSHiWwotiIHQDrLbwCqFzUYDGR58NfIQUaUYALiKFHckn1Q3crXt/3I3FdeDi5gRujM/S+saBGOwtSEO77CuSP1CxQt4BKMz9ncLVIn9oRBti0+U9fXzcOKgcho8eYaWHRxF8AVlINJRYxOmMt3eb2B+kT628CkuDorNcQgkeNND+5b7yuDehK2psdaXwBTQYS4KuUrxKRl1L5230gsBZjQYrfyXte0caphtM8KZh/IdYSRJkBYonJGZ6+pu73uPJKZ2jYJqDtd8hDQm3hCkT6xCVW/SX6hyqAYZtor4fE39vSLKYlTD4xAfM5Y32p+mDGsaozeWbTXi2Lg/hJy6N0AR0O3GHcPD7/gjsYpZUg1vWoY2yGhJ88rCCohj2X8JNu4UiZ2bIqUg+5ckwUi3B+UTeN/29w3lFMfjsnhCqgmwRDybVzSINgUsvVyKbNWzvj2mTkdqp2uwBDMD7nbd0uA8Gz3+AkrL8B36q6nlM8A5sPy4wC6cuUZ92JKurrfPv4IE1jYQ6v4Uw2vAhyTQ==
X-MS-Exchange-AntiSpam-MessageData: Skux+se3JHrbCP+Z4P/s0gh/swcBHFVO591IqMvMU+rBpuSdUTAx4PJ0XdyHO5FL7K7G3Gh1o9tt31y7/S7Tusx0bWE/ucup3iU/A1wk53aWGUY4sE+5d9snfEhuNY16hCyZiac0TyFtnbls/y7yHA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaa37b56-c8e5-4716-8e7c-08d7e38708df
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2020 10:55:40.7002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wNbqPS09TEesK751nNCYMabUcQQ2rV9mwtLiIJhLeBatf99BjHGMBXS0iDvrKRtcfW+hRNauXpiXVFwzaLsxGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6899
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify dpaa2_mac_connect() to support ACPI along with DT.
Modify dpaa2_mac_get_node() to get the dpmac fwnode from either
DT or ACPI.
Replace of_get_phy_mode with fwnode_get_phy_mode to get
phy-mode for a dpmac_node.
Define and use helper functions fwnode_phy_match() and
fwnode_phy_find_device() to find phy_dev that is later
connected to mac->phylink.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2:
- Major change following other network drivers supporting ACPI
- dropped v1 patches 1, 2, 4, 5 and 6 as they are no longer valid
- incorporated other v1 review comments

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 122 ++++++++++++++----
 1 file changed, 94 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 3ee236c5fc37..5a03da54a67f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -3,6 +3,9 @@
 
 #include "dpaa2-eth.h"
 #include "dpaa2-mac.h"
+#include <linux/acpi.h>
+#include <linux/phy.h>
+#include <linux/phylink.h>
 
 #define phylink_to_dpaa2_mac(config) \
 	container_of((config), struct dpaa2_mac, phylink_config)
@@ -23,38 +26,56 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
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
@@ -227,13 +248,40 @@ bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
 	return fixed;
 }
 
+static int fwnode_phy_match(struct device *dev, const void *phy_fwnode)
+{
+	return dev->fwnode == phy_fwnode;
+}
+
+static struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
+{
+	struct device *d;
+	struct mdio_device *mdiodev;
+
+	if (!phy_fwnode)
+		return NULL;
+
+	d = bus_find_device(&mdio_bus_type, NULL, phy_fwnode, fwnode_phy_match);
+	if (d) {
+		mdiodev = to_mdio_device(d);
+		if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
+			return to_phy_device(d);
+		put_device(d);
+	}
+
+	return NULL;
+}
+
 int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
 	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
 	struct net_device *net_dev = mac->net_dev;
-	struct device_node *dpmac_node;
+	struct fwnode_handle *dpmac_node = NULL;
+	struct fwnode_reference_args args;
+	struct phy_device *phy_dev;
 	struct phylink *phylink;
 	struct dpmac_attr attr;
+	int status;
 	int err;
 
 	err = dpmac_open(mac->mc_io, 0, dpmac_dev->obj_desc.id,
@@ -251,7 +299,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 
 	mac->if_link_type = attr.link_type;
 
-	dpmac_node = dpaa2_mac_get_node(attr.id);
+	dpmac_node = dpaa2_mac_get_node(&mac->mc_dev->dev, attr.id);
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
@@ -290,20 +338,38 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	}
 	mac->phylink = phylink;
 
-	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
+	if (is_of_node(dpmac_node))
+		err = phylink_of_phy_connect(mac->phylink,
+					     to_of_node(dpmac_node), 0);
+	else if (is_acpi_node(dpmac_node)) {
+		status = acpi_node_get_property_reference(dpmac_node,
+							  "phy-handle",
+							  0, &args);
+		if (ACPI_FAILURE(status))
+			goto err_phylink_destroy;
+		phy_dev = fwnode_phy_find_device(args.fwnode);
+		if (!phy_dev)
+			goto err_phylink_destroy;
+
+		err = phylink_connect_phy(mac->phylink, phy_dev);
+		if (err)
+			phy_detach(phy_dev);
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

