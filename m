Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD46313736
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbhBHPVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:21:35 -0500
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:39337
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230521AbhBHPQm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 10:16:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXy3Kkou4PQuj2kzBrWIOVziepuChiHZ6vf/hZcpZPcUkIwpAW3vmuPnF/xm68z1MMze5A9K7izv+zgOm1fOwOBbrg09etBokUNzRkpAxvGd14NF5q2GiUnMn7+3pfkkp2/901zNE8qkWlyqnFWCCB/m7fkHYVO5l2WXyp7le3T3yDGQfUP5gm7PRuRTZJnS9/ilmpnLgt8uqYhVFoaToTnCwxjv1RavtXf7MY+J7Cb7fcuwSrV5fqLGuQkQoev1SaUOy25lfFqqeqXGK2k2a0/1GWr1UEMrDgk79KBkfwwcngYJjtOnlNKVOYkaIDPrpFW4097KAR94NzD/wn5srQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0DzNknCy4kzCZIErFlhvXWI3OW6q80jHOib1InfJkc=;
 b=YttKUHFAm+MWt6wtEM+DxLqE3ap8oj2fVqJOZVLEDR4V+CJe8h6TsP5qh9r14SggfGTbF2AVwB+hn1xdn8DyFdZ31G2TU6ehipa0YT02nEtdQstry/ERRrVxFW+U7rNGVP3RwJs4r7iPfZ6u4A1vEyTA0TkfcjhOxCSvXvlOBv5qma793SeeVISDjQQKDSBq10fo0nXrcsybPPBsGwd7/4TiJtrqkqI/bhSXYTRY9u/N1fVjv8fixUnLpA0D+XyIkEqkbPunHDJOT5/WW+vx6BOe/+7DzWBxKeMU3qoQd03Pv/z00res2buF0Y5dPL239AYwdPa6XG4UqPGpzlrElg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0DzNknCy4kzCZIErFlhvXWI3OW6q80jHOib1InfJkc=;
 b=iLs/K6sXi/sbsHfteHm3j7LyYiX+fT5UmVPlGrCykzqKTCNKeKoG7qXeOqJ1YfuOX2MYNzDIJbDfbUbTEAYFB9i50HkOO5dtMgBOAfjNvtCNcbv1K7QNwGTRMr7t45SFcCrT9Fu9RGLmY173gBSTtUP1CrrlPnmclltlfo7HcC0=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6435.eurprd04.prod.outlook.com (2603:10a6:208:176::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Mon, 8 Feb
 2021 15:14:06 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:14:06 +0000
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
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [net-next PATCH v5 07/15] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
Date:   Mon,  8 Feb 2021 20:42:36 +0530
Message-Id: <20210208151244.16338-8-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0176.apcprd04.prod.outlook.com
 (2603:1096:4:14::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0176.apcprd04.prod.outlook.com (2603:1096:4:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 15:13:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d5066c55-cc12-4f3b-2c6e-08d8cc442d6c
X-MS-TrafficTypeDiagnostic: AM0PR04MB6435:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6435E587A3C65619700A6D73D28F9@AM0PR04MB6435.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xxFO64Iw854qoHKNhib3XTKQ0FJayLUL8re4vQ5K/hLQ+dX9BpER/D3JYIVDHRfPPl+WbALfY7syAId0i2PZaDct1Y9hi/tTkxmE0NG78qxTY9+kOMwIpFboyvsWbO6kdLImTOgfe35mzsz8eRJ3SuSC8l8XQwN1P+EbG7/s2E00aBawHqWbaYqUMFu6fEEc7Rqg9LOREULK86whl6Weapcx6ooimldR/YN2FPCWMe9FcH9DxjcIF/i290oxT4J50M1fJGdnTMxMXFj6pnn/tza1ZSgqI8AJvn62xZPDDBe4i6kkKPu3ZgbFdXMYNWBh2V4Z2M7/wAT0rooJKior9pyU4NaoNrYvtPryzKRQFk1i59o0u9hLiN4wdXjKMmQ033US4ef5Yw5lzlHzRB82a6i+X++GMpmyvAxky21RVvA6gFu7DU2BIMVAuu4idiWXIbpkZTZ62QirQ7UFs8bQnPIDI0gRv8/I3NI9u14avR89aOukwk6ScAN9OQ3fXChnOykqqG0ty7eOy+cX7atXsXmAQLUkPJyp6tebRCQqs43sO7Gw058Hw/OGxT42pvIvK4jcgJd0HVsd6ThMgEfI6v53R8NNB3GYlBbYXim9Qa0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(8936002)(54906003)(7416002)(52116002)(110136005)(186003)(16526019)(316002)(55236004)(956004)(6486002)(6666004)(1006002)(4326008)(2906002)(478600001)(6512007)(1076003)(6506007)(5660300002)(921005)(44832011)(83380400001)(86362001)(66556008)(26005)(2616005)(66476007)(66946007)(8676002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SPgJGsEyzfzpX4OWPXX2ODre98s32sJLjo31Ds9yYz1ereONuDMywJ2f751O?=
 =?us-ascii?Q?GVIxzQo1pom9wG+u2tsreSxfLZz7+NblyJwJstY/u/vk+jA0QpRQDIbaTkwF?=
 =?us-ascii?Q?oQPdfBiZsxZgqp2QHC0A7ZhDcRTBSKSStUXTvlhiCVBRpW/y6GUgi4tvXyTZ?=
 =?us-ascii?Q?tMqIjRDBwVl6Fc+Wd8+z72BtMX8eJfSlO6m0mPgLuyNe0Nky9izU35HdJE3K?=
 =?us-ascii?Q?/mNavuOEtZoxFbnWbY5myMlYRFywoEXuEyp6oSSziY115kKCghDAsAETHLze?=
 =?us-ascii?Q?nm8f5xVZunc1ikckjeoTgWFeaWeX0sbxr1kKpvqtqjFEZ4XXFR3uwS4TcbUa?=
 =?us-ascii?Q?3tlHHeVM6ytMu+wpKjRSmxWkK/5uTq5Qdv7OlmLo4W3ldXXifxKsS6oh24N/?=
 =?us-ascii?Q?toxRlk3h/1+SB1i6yVHGZk3eYDH7j7ZRWighncP+d5vCFteOhWi5a2idMM+6?=
 =?us-ascii?Q?aEG/sh6GKYFm0/UK01mXjsCZFjBOD580r5HSAWxc7Ekhn5lETTvA/bG22lQD?=
 =?us-ascii?Q?hoLk19sXp34r+E925XcU2YWVSDM0Cr5SKKriLX2fZNlQUT9219FFEp1T6zRV?=
 =?us-ascii?Q?SID7yzHZumyx0jdRevZsNR2j5DIbPsLuflw8NMV+7GbvFZ2zwU6P+weLfMbN?=
 =?us-ascii?Q?Uf1tyKbD/ZQa1jWrT4OgJ2euk6bPJ+etRds8ds207NLIW1L6B7KYr7LtGjGu?=
 =?us-ascii?Q?3M0kG5U2MAFOOwu9kAvGsXftc9vPqrguu6JhjflzlIeEyyfkZgtORytH58kT?=
 =?us-ascii?Q?9XM5TSVZ0oKkWufTi3ys7/ASQilMvg0Yy6MVAEp5g7V7n8jGDP+gaCeJVxzy?=
 =?us-ascii?Q?aA5sKNO/VKSMwQcAUmDCe8EVjRhXuYvVp9X/wj6nlHbWxBxyfkJLVMpg+G7D?=
 =?us-ascii?Q?kBhuFv0nWyJzpWcDhPN0KaY9iNf5HoinFOUOO78/CSoJtnccPj+a/OMVPiJF?=
 =?us-ascii?Q?7T2d7PReksNgtmKe3gn8WE2yilG+g4a5a776Owyr+ISZg1rVpzCJZ2btYfO9?=
 =?us-ascii?Q?yEXTQKMFjeQ0yazFWBjHo0dYWdk/JbnGQDT5srBxhTzy9NfugywGVzAVGXJn?=
 =?us-ascii?Q?f9v23E4smIoZwutjYQbw0/DLwEWxyUjVSZVM2pm9C1G5XeCk6pccLttvp7vV?=
 =?us-ascii?Q?+as6ggvopzHUnF/b5fL8n1MRvX78WwvdorXR6KnuPqI5fm3swK7iZAHfemrz?=
 =?us-ascii?Q?fkTqAY6G+hsOOShyjSabJmRR9zm2couwue+f94Anf4WfshbCaYRP/xcQrngO?=
 =?us-ascii?Q?EYSX3TSJh9p28gJuMXXpiDs318Cno0etGqxd7rs4yU6JOk8VKZ07DaNf+kPf?=
 =?us-ascii?Q?iVWIxIyX8oAvzSYBS177DX3m?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5066c55-cc12-4f3b-2c6e-08d8cc442d6c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:14:06.7050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VYJ4kYwE9npldhRdWMKwei0A0+GUWjLv2oD2UreAfTox+tqujMGBiymB1rNGbHLh1KqsU1f4dtI3aybXMc+G7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce fwnode_mdiobus_register_phy() to register PHYs on the
mdiobus. From the compatible string, identify whether the PHY is
c45 and based on this create a PHY device instance which is
registered on the mdiobus.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c |  3 +-
 drivers/net/phy/mdio_bus.c | 65 ++++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h       |  2 ++
 include/linux/of_mdio.h    |  6 +++-
 4 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index d4cc293358f7..cd7da38ae763 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -32,7 +32,7 @@ static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 	return fwnode_get_phy_id(of_fwnode_handle(device), phy_id);
 }
 
-static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
+struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
 {
 	struct of_phandle_args arg;
 	int err;
@@ -49,6 +49,7 @@ static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
 
 	return register_mii_timestamper(arg.np, arg.args[0]);
 }
+EXPORT_SYMBOL(of_find_mii_timestamper);
 
 int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
 			      struct device_node *child, u32 addr)
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 823518554079..33d1667fdeca 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -8,6 +8,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/acpi.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
@@ -106,6 +107,70 @@ int mdiobus_unregister_device(struct mdio_device *mdiodev)
 }
 EXPORT_SYMBOL(mdiobus_unregister_device);
 
+int fwnode_mdiobus_register_phy(struct mii_bus *bus,
+				struct fwnode_handle *child, u32 addr)
+{
+	struct mii_timestamper *mii_ts;
+	struct phy_device *phy;
+	bool is_c45 = false;
+	u32 phy_id;
+	int rc;
+
+	if (is_of_node(child)) {
+		mii_ts = of_find_mii_timestamper(to_of_node(child));
+		if (IS_ERR(mii_ts))
+			return PTR_ERR(mii_ts);
+	}
+
+	rc = fwnode_property_match_string(child, "compatible", "ethernet-phy-ieee802.3-c45");
+	if (rc >= 0)
+		is_c45 = true;
+
+	if (is_c45 || fwnode_get_phy_id(child, &phy_id))
+		phy = get_phy_device(bus, addr, is_c45);
+	else
+		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
+	if (IS_ERR(phy)) {
+		if (mii_ts && is_of_node(child))
+			unregister_mii_timestamper(mii_ts);
+		return PTR_ERR(phy);
+	}
+
+	if (is_acpi_node(child)) {
+		phy->irq = bus->irq[addr];
+
+		/* Associate the fwnode with the device structure so it
+		 * can be looked up later.
+		 */
+		phy->mdio.dev.fwnode = child;
+
+		/* All data is now stored in the phy struct, so register it */
+		rc = phy_device_register(phy);
+		if (rc) {
+			phy_device_free(phy);
+			fwnode_handle_put(phy->mdio.dev.fwnode);
+			return rc;
+		}
+	} else if (is_of_node(child)) {
+		rc = of_mdiobus_phy_device_register(bus, phy, to_of_node(child), addr);
+		if (rc) {
+			if (mii_ts)
+				unregister_mii_timestamper(mii_ts);
+			phy_device_free(phy);
+			return rc;
+		}
+
+		/* phy->mii_ts may already be defined by the PHY driver. A
+		 * mii_timestamper probed via the device tree will still have
+		 * precedence.
+		 */
+		if (mii_ts)
+			phy->mii_ts = mii_ts;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
+
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
 {
 	struct mdio_device *mdiodev = bus->mdio_map[addr];
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index ffb787d5ebde..7f4215c069fe 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -381,6 +381,8 @@ int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
 bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr);
+int fwnode_mdiobus_register_phy(struct mii_bus *bus,
+				      struct fwnode_handle *child, u32 addr);
 
 /**
  * mdio_module_driver() - Helper macro for registering mdio drivers
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index cfe8c607a628..3b66016f18aa 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -34,6 +34,7 @@ struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np);
 int of_phy_register_fixed_link(struct device_node *np);
 void of_phy_deregister_fixed_link(struct device_node *np);
 bool of_phy_is_fixed_link(struct device_node *np);
+struct mii_timestamper *of_find_mii_timestamper(struct device_node *np);
 int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
 				   struct device_node *child, u32 addr);
 
@@ -128,7 +129,10 @@ static inline bool of_phy_is_fixed_link(struct device_node *np)
 {
 	return false;
 }
-
+static inline struct mii_timestamper *of_find_mii_timestamper(struct device_node *np)
+{
+	return NULL;
+}
 static inline int of_mdiobus_phy_device_register(struct mii_bus *mdio,
 					    struct phy_device *phy,
 					    struct device_node *child, u32 addr)
-- 
2.17.1

