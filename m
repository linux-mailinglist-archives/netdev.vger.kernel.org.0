Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9917F2DB1C1
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbgLOQpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:45:35 -0500
Received: from mail-eopbgr20054.outbound.protection.outlook.com ([40.107.2.54]:56934
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729453AbgLOQpL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:45:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJZtJlpgwYh5QUyE8S4l7JneGNHZy78sLTG3nwuBFGzcfvSrzkKpxyvDuy09T/htdU2BrdUyqsR7fV6JQD6ntE3lqNbIi4yuXDu1Y+pQ9tJ72L58wsmpoQ8C5u3hqHZ8VhibJlhj8HQQfzZInTa6TLYOYPBD+yS8hKBq32wkfzQFoS078YiiwRZBWMuGX5cblczZ3Fr+6n3ZuYGFy5vMQsEtKDDDiWYjJQBpJQ06YYb7Bqm445gA5bQZnTR1W9tcHvwZsLRfIIp+wyA4E7NIwE4MrzbxXRIOCoUr9Q+IF18HDCvpTh92hm/I334/K5YF6eayskvAEfjLFyy4KC2WuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4X4WQhBWjreYs41FUyUmSUAhA1txuBBdVGLOwpyqK8=;
 b=esk45H7m/v/acplSKEkQWlzZPAzXdi7VLjN2T2zm6v1tuwrxE2i6I0spKSRpQBp54zGl8euvi4NVUQmGQMDtnMxRvrwDqyx8pZmNwtkzif1zQn/JnC97Yp4kqHD4NXn8O/P9yH1GyTtwHd0FoawD10BwO8tauWCglAVeMmHBztLHsU2cyIXjEFooN0jO/3tL2Xc5ATQIocK7HIPX1J1xHULwfg33ACrnhDbHdBnhO/2jfQ3bAqorenA6MEGtZYmM0N0zq5J4WCyFemby8HD+FcntYTwZ6vvbDGJEI6fv6xIJqe87k7hCiwbdKeP3RU4GpXUiofJnynvKAM4VjwNgBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4X4WQhBWjreYs41FUyUmSUAhA1txuBBdVGLOwpyqK8=;
 b=ZPNjCZkiG03cXlP4XNkQw4Rg715cLn/8WRyCOiaKmWO2l9BadfguKv7yrdOTMN3KVsrjnVfkyiYfnFKLhLd4exzKW/Z2imi4+pLjwg64Yiwd2jcnxqgHHkAIC0xaOgVaW8lu7MuCbPntCIjBvAumwk5d5hpyRswsa4ULxqhuNvg=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6963.eurprd04.prod.outlook.com (2603:10a6:208:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Tue, 15 Dec
 2020 16:44:03 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Tue, 15 Dec 2020
 16:44:03 +0000
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
        Jon <jon@solid-run.com>
Cc:     linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v2 02/14] net: phy: Introduce phy related fwnode functions
Date:   Tue, 15 Dec 2020 22:13:03 +0530
Message-Id: <20201215164315.3666-3-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0152.apcprd06.prod.outlook.com
 (2603:1096:1:1f::30) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0152.apcprd06.prod.outlook.com (2603:1096:1:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 16:43:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 22de5d48-859a-408e-a6bd-08d8a118a1c5
X-MS-TrafficTypeDiagnostic: AM0PR04MB6963:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB696344350227F2D7C55A3A13D2C60@AM0PR04MB6963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IYxM4SBTonhlz78F2/tPGhVCXsM2kXeXSBFmoAMcm/UxVvU8EWQ+KkfnPe9Q3e37NWZeS38og9uVp5rzYBkfA3byXmIl68XOiXMpzirmrz6ajizOFLyfnrmzZRm96lH1mISuzJ9FhFbJ5wZsTldJzQjv5JOtm2JUG+27dMoUQYt8wKk8TiYp6U4jd3KG0+vryr5hJquNxFEylLSkFKoViIc8jwmnVJbLd6fr2hmIZcCKoW+vEC0Rt7WKqKnGOb+djph/y2ehIM0/P8gGtTPKoUKAZNfneUNB2o3/c981ccdQ3oMoXpcSLZw8ebN6kcsTjoVAQsCGfacaRfr3vUd+ueHmVkJF9G79SxpuM/PJYVdbSFdnQao8AprETwon1U93qOyOwXDOfHWKIkCT/jzRFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(4326008)(6506007)(498600001)(83380400001)(66946007)(921005)(2616005)(956004)(86362001)(52116002)(16526019)(8676002)(2906002)(26005)(6512007)(44832011)(7416002)(186003)(5660300002)(55236004)(1006002)(1076003)(66476007)(110136005)(6486002)(66556008)(6666004)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?WFwvzYQ6tCmYu1NNG7hhbUqZMvC2+YugBqa4VBPriqPiHnC20wN/C/eloJyy?=
 =?us-ascii?Q?nk1pukh3kOB/3cA4ga5KsOCMKvhr+cw9FT3FuqTP/CvaD95XM/Usf0Dwg1R9?=
 =?us-ascii?Q?7wPa/fkydBAxMBABYwOtiDaG6UqWsUdkW9Cm2RazpM0QGejzl3rwpeXor51t?=
 =?us-ascii?Q?ySM4I97bQMcx5+102NBQ6HDoxJAK+S0BIZZOzJJRl/08uPtMdfZH7B9jFElW?=
 =?us-ascii?Q?xqm6oRnw1uJhWAPim/QS9mGUGAxs1JLmz6AgaNwYyAsjdHdV/LhyJWeMai4q?=
 =?us-ascii?Q?FjchFeJwUL1tEoKPTOmjdYFqKUm/ARxd1DJSPy42fCFbTmz++JJRfIkrw98U?=
 =?us-ascii?Q?hFLrjopgthimpKH6zU6Ur6DZlhvwriiHin4B4hAbT5DZY/Sn0JSF2uuVHBGV?=
 =?us-ascii?Q?FMLlt+9wfft6s5f3O5cCuXWmklVsMEv+RukOMqwqSuXsSbItg5EFDXsHQXSZ?=
 =?us-ascii?Q?93Htxe4+hYNFRpD59k/kJbCNeghpvr5qemKcA6jyE/o1eABpuYDuLJERTtor?=
 =?us-ascii?Q?rmsZNc9wGlOuZN7maQdXjN+WjRK5RGJQbYw/moaPnT2xG/a6Bbf51G7I2qVk?=
 =?us-ascii?Q?n/Xuo1eaJ9dEmD7uwGDa2M757cT2xGQGhynRntLG4zmfPmeCBpTHtWkvGp7d?=
 =?us-ascii?Q?/E5jcZmabuL8n8t72xnfGvG++/3PCkKT50QUqkbnZcdbLIFys8PV4xc7bz8Z?=
 =?us-ascii?Q?GrX1gUB/6FrcH6FUepxrTGbb7BVFhz7SFGfw/nzG5G9i3eEa+TAu4qlYq4nA?=
 =?us-ascii?Q?HDUNJptAwqYuij73H8HLhnm5mZo8Al8eOdzCjXStSFuLFp17QAFGcUHb9/li?=
 =?us-ascii?Q?9CEDMswEOhuqLk3gXV7H2xxT3eOJ5bgSqVy38fjN/qY8hv4DQqbJGwSjuUyG?=
 =?us-ascii?Q?0ZuZ/sdv1Q0dsL3wVQwekmY/mY9e++VYJVrSc7S7eNKNOjPjlAwRvFdGi1A2?=
 =?us-ascii?Q?GSsgISOQ+oKP3aqUofy6h8Jddq3skq+UGjwudsMBA1SVifU6dvTZI/8zBCod?=
 =?us-ascii?Q?2cnM?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 16:44:03.6878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 22de5d48-859a-408e-a6bd-08d8a118a1c5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U6EdF8+zifbYL1RsEYztA6ENtoa4bRUhDiXiZJnmircGsF/hs0dRAMsrDaqiTtZza3c4nwfZvhheClOYxVw+Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define fwnode_phy_find_device() to iterate an mdiobus and find the
phy device of the provided phy fwnode. Additionally define
device_phy_find_device() to find phy device of provided device.

Define fwnode_get_phy_node() to get phy_node using named reference.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2:
- use reverse christmas tree ordering for local variables

 drivers/net/phy/phy_device.c | 64 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 20 +++++++++++
 2 files changed, 84 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 80c2e646c093..c153273606c1 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -9,6 +9,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/acpi.h>
 #include <linux/bitmap.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -2829,6 +2830,69 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 	return phydrv->config_intr && phydrv->handle_interrupt;
 }
 
+/**
+ * fwnode_phy_find_device - Find phy_device on the mdiobus for the provided
+ * phy_fwnode.
+ * @phy_fwnode: Pointer to the phy's fwnode.
+ *
+ * If successful, returns a pointer to the phy_device with the embedded
+ * struct device refcount incremented by one, or NULL on failure.
+ */
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
+{
+	struct mdio_device *mdiodev;
+	struct device *d;
+
+	if (!phy_fwnode)
+		return NULL;
+
+	d = bus_find_device_by_fwnode(&mdio_bus_type, phy_fwnode);
+	if (d) {
+		mdiodev = to_mdio_device(d);
+		if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
+			return to_phy_device(d);
+		put_device(d);
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(fwnode_phy_find_device);
+
+/**
+ * device_phy_find_device - For the given device, get the phy_device
+ * @dev: Pointer to the given device
+ *
+ * Refer return conditions of fwnode_phy_find_device().
+ */
+struct phy_device *device_phy_find_device(struct device *dev)
+{
+	return fwnode_phy_find_device(dev_fwnode(dev));
+}
+EXPORT_SYMBOL_GPL(device_phy_find_device);
+
+/**
+ * fwnode_get_phy_node - Get the phy_node using the named reference.
+ * @fwnode: Pointer to fwnode from which phy_node has to be obtained.
+ *
+ * Refer return conditions of fwnode_find_reference().
+ * For ACPI, only "phy-handle" is supported. DT supports all the three
+ * named references to the phy node.
+ */
+struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
+{
+	struct fwnode_handle *phy_node;
+
+	/* Only phy-handle is used for ACPI */
+	phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
+	if (is_acpi_node(fwnode) || !IS_ERR(phy_node))
+		return phy_node;
+	phy_node = fwnode_find_reference(fwnode, "phy", 0);
+	if (IS_ERR(phy_node))
+		phy_node = fwnode_find_reference(fwnode, "phy-device", 0);
+	return phy_node;
+}
+EXPORT_SYMBOL_GPL(fwnode_get_phy_node);
+
 /**
  * phy_probe - probe and init a PHY device
  * @dev: device to probe and init
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 381a95732b6a..7790a9a56d0f 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1341,10 +1341,30 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
+struct phy_device *device_phy_find_device(struct device *dev);
+struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode);
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
 #else
+static inline
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
+{
+	return NULL;
+}
+
+static inline struct phy_device *device_phy_find_device(struct device *dev)
+{
+	return NULL;
+}
+
+static inline
+struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
+{
+	return NULL;
+}
+
 static inline
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 {
-- 
2.17.1

