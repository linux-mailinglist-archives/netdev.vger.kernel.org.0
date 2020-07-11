Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1CB21C2F3
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 08:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgGKG6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 02:58:51 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:51726
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728197AbgGKG4v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 02:56:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIdv+ZFZ/7FvQcdacnglNRZvOOs087KNqD/ORxpkE2vBE+zm4zSif2HuKm8fzlQBoHiB9ksyMvurYbY0Icn51E1jRUQYzk5a7JA7DUnV6vCIQJ+RehG657/Zn2C6/ayyNJKDiOOJoVgOheHYwseYyzGLmsm8knU3lNoGU97W7/QL04OCaFv6NBJvbCECLtKYsSLQVJCWJyrp2T3VIreQOKxjfGhJcw0ouqoUaB2q2YuMpk5aYAWI7zb67tkssvnFuCwznTD0wOEvTWCYkj8m+n493Z87yVhV5VIv8Vu9eLbJ6ADJ2H4KfmrAz+w+UKQ7Arn2HRuzpYgf9gb4RzEd0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CWpOmph+hOXmXgo4TMusFprOlcfKEK97ciLlrhFjueU=;
 b=GbN2pByOMB0HZ5vyB+vghpzTMZDjkvyGxr5qoLGKcanwkj435zzbk+U3UDCliVZBIa7Eypy/k8Iefo+WtROYVeH4kzTtnU8U6choG59RLqjB+OtzQL+vlGqJnzK/hPUwyi02z4zZXZNtMZRyLOri6tYyWIw/EWaSX9oOyFXezhCd8YP5i1Ywrg/E2H7A/94+uJoiUwtg8aFaOOu0POPe5QGxrzYlAszIXKgnlKMyoOdWVqDpjV8cn4Ak+uyTiV2ApcZgIZkLNbX15vELK2UOqNNIu0601jBQZN+RjbwA0agJtTj/JhKQv3yYT/kiMLDq7x1AUaeyG87cLRLPTeRpwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CWpOmph+hOXmXgo4TMusFprOlcfKEK97ciLlrhFjueU=;
 b=N5wEjEsl0WrnKkUMFhQq5fShsKAeYOM95KB9KrydwZH6Xdd9yymTsz4h+dxB/2KVarjyx+DbwwZZawj424c49KD0XLX8POKJlxuUO2R25dcqrT/MYXa0VjXVSBBxMsoiIcB/BmO2q4W/u4s8sQqBqyNh31GmLg/waq7lBQIg7tA=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6961.eurprd04.prod.outlook.com (2603:10a6:208:180::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Sat, 11 Jul
 2020 06:56:47 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.023; Sat, 11 Jul 2020
 06:56:47 +0000
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
Subject: [net-next PATCH v6 4/6] net: phy: introduce phy_find_by_mdio_handle()
Date:   Sat, 11 Jul 2020 12:25:58 +0530
Message-Id: <20200711065600.9448-5-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200711065600.9448-1-calvin.johnson@oss.nxp.com>
References: <20200711065600.9448-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0132.apcprd06.prod.outlook.com
 (2603:1096:1:1d::34) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0132.apcprd06.prod.outlook.com (2603:1096:1:1d::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Sat, 11 Jul 2020 06:56:43 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 156be293-57fc-4f3b-a316-08d825679400
X-MS-TrafficTypeDiagnostic: AM0PR04MB6961:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB69613817AB673A5FCD945044D2620@AM0PR04MB6961.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PaGe2uu3LVmSqBP8HOaeOfR1MiRFfFoLZxUAPaI8Q2fmDHlTsUpLNNg2fARluoZhLBxZF913/EvxqcsqQjjUIl2havbih3WiLQrEqy2lyTvnsD5iAJoKfa/vi0QBYEfMGmXLbD1NSqf+gKGsToMUBgMMT8Ondll2dV/eQrQ/jJKLBb+iGCn2Thc8rLALN31KYpgHm5M7FO3ydPxBjtBpZS8ZxhGmTTsaBVF5nF3IUKHFdTkJHQSXbccQ3gVzBPgKdMrOnFah7LCWRyIpkYy6p0Bw65I8RF21tRKyHw/9WBDR7w5VPuBMaphNgUHAJ5pr0ez9ZkQNnmOedefu5c00y44fYNZSbRK2wlIgM00IRhmUkGwaPxjognoa52nFOF6D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(26005)(6636002)(16526019)(186003)(110136005)(55236004)(66476007)(44832011)(6666004)(66946007)(66556008)(5660300002)(2616005)(8676002)(52116002)(1006002)(6512007)(316002)(6486002)(6506007)(956004)(1076003)(4326008)(2906002)(83380400001)(478600001)(8936002)(86362001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zueZvxALeD1fxG/vqJ4mF3+RhVFV2RMUfrVHD7XTJCw7GG308vyvK2FESZMpbOBOoHAdtt19eml5zo3rIRziwwkz5RtH7kbcszDxuzbXgEJZh+000K0ZvBjY1PgkLeBHJ/nAr3LmlXtuibyYH4pHkUGJek2PKDBZoexFXQC/B6DHco+bjXghc0ABazEKb7uZwAqOoqzbUJr71T4aWlq4aMECO5MbjlA32CTcA/66dZ/+shLI4XxxhkqomTHM6PMFnYbd4+Xzay0em/HydTBiBpTg/ANrVKbEWD5Rv0iZ4Ys22Uij1G3zMfzoiVD4y+Z1E1hlYqJfKmqURtEgDDWK52x5RkiJOrc4iaKGTGRMqyK0adH0tDTBByB2bX21goOFRxCRL8CwN9TwjA7coF3TOEkMVbeZ1w0b4EeEh5HQHzeSHvI4yFkn1QT7TGlYkYDK/1d+JzClubnr2xTsPQAvXQ4BpLdJgqAAGRThHi2lmwE=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 156be293-57fc-4f3b-a316-08d825679400
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2020 06:56:46.9942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x9fz6x6YbhuwvyXJFlle0xratxEEfyp4xqo/g+EBv66CXzymuRFoN4fTv2zgWjBxES83QaNfTOawK5yRTMw7eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6961
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHYs on an mdiobus are probed and registered using mdiobus_register().
Later, for connecting these PHYs to MAC, the PHYs registered on the
mdiobus have to be referenced.

For each MAC node, a property "mdio-handle" is used to reference the
MDIO bus on which the PHYs are registered. On getting hold of the MDIO
bus, use phy_find_by_fwnode() to get the PHY connected to the MAC.

Introduce fwnode_mdio_find_bus() to find the mii_bus that corresponds
to given mii_bus fwnode.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

Changes in v6: None
Changes in v5:
- rename phy_find_by_fwnode() to phy_find_by_mdio_handle()
- add docment for phy_find_by_mdio_handle()
- error out DT in phy_find_by_mdio_handle()
- clean up err return

Changes in v4:
- release fwnode_mdio after use
- return ERR_PTR instead of NULL

Changes in v3:
- introduce fwnode_mdio_find_bus()
- renamed and improved phy_find_by_fwnode()

Changes in v2: None

 drivers/net/phy/mdio_bus.c   | 25 ++++++++++++++++++++++
 drivers/net/phy/phy_device.c | 40 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |  2 ++
 3 files changed, 67 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 8610f938f81f..d9597c5b55ae 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -435,6 +435,31 @@ struct mii_bus *of_mdio_find_bus(struct device_node *mdio_bus_np)
 }
 EXPORT_SYMBOL(of_mdio_find_bus);
 
+/**
+ * fwnode_mdio_find_bus - Given an mii_bus fwnode, find the mii_bus.
+ * @mdio_bus_fwnode: fwnode of the mii_bus.
+ *
+ * Returns a reference to the mii_bus, or NULL if none found.  The
+ * embedded struct device will have its reference count incremented,
+ * and this must be put once the bus is finished with.
+ *
+ * Because the association of a fwnode and mii_bus is made via
+ * mdiobus_register(), the mii_bus cannot be found before it is
+ * registered with mdiobus_register().
+ *
+ */
+struct mii_bus *fwnode_mdio_find_bus(struct fwnode_handle *mdio_bus_fwnode)
+{
+	struct device *d;
+
+	if (!mdio_bus_fwnode)
+		return NULL;
+
+	d = class_find_device_by_fwnode(&mdio_bus_class, mdio_bus_fwnode);
+	return d ? to_mii_bus(d) : NULL;
+}
+EXPORT_SYMBOL(fwnode_mdio_find_bus);
+
 /* Walk the list of subnodes of a mdio bus and look for a node that
  * matches the mdio device's address with its 'reg' property. If
  * found, set the of_node pointer for the mdio device. This allows
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 7cda95330aea..00b2ade9714f 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -23,8 +23,10 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
+#include <linux/platform_device.h>
 #include <linux/property.h>
 #include <linux/sfp.h>
 #include <linux/skbuff.h>
@@ -964,6 +966,44 @@ struct phy_device *phy_find_first(struct mii_bus *bus)
 }
 EXPORT_SYMBOL(phy_find_first);
 
+/**
+ * phy_find_by_mdio_handle - get phy device from mdio-handle and phy-channel
+ * @fwnode: a pointer to a &struct fwnode_handle  to get mdio-handle and
+ * phy-channel
+ *
+ * Find fwnode_mdio using mdio-handle reference. Using fwnode_mdio get the
+ * mdio bus. Property phy-channel provides the phy address on the mdio bus.
+ * Pass mdio bus and phy address to mdiobus_get_phy() and get corresponding
+ * phy_device. This method is used for ACPI and not for DT.
+ *
+ * Returns pointer to the phy device on success, else ERR_PTR.
+ */
+struct phy_device *phy_find_by_mdio_handle(struct fwnode_handle *fwnode)
+{
+	struct fwnode_handle *fwnode_mdio;
+	struct mii_bus *mdio;
+	int addr;
+	int err;
+
+	if (is_of_node(fwnode))
+		return ERR_PTR(-EINVAL);
+
+	fwnode_mdio = fwnode_find_reference(fwnode, "mdio-handle", 0);
+	mdio = fwnode_mdio_find_bus(fwnode_mdio);
+	fwnode_handle_put(fwnode_mdio);
+	if (!mdio)
+		return ERR_PTR(-ENODEV);
+
+	err = fwnode_property_read_u32(fwnode, "phy-channel", &addr);
+	if (err)
+		return ERR_PTR(err);
+	if (addr < 0 || addr >= PHY_MAX_ADDR)
+		return ERR_PTR(-EINVAL);
+
+	return mdiobus_get_phy(mdio, addr);
+}
+EXPORT_SYMBOL(phy_find_by_mdio_handle);
+
 static void phy_link_change(struct phy_device *phydev, bool up)
 {
 	struct net_device *netdev = phydev->attached_dev;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 0403eb799913..fd383a22eb61 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -334,6 +334,7 @@ static inline struct mii_bus *devm_mdiobus_alloc(struct device *dev)
 }
 
 struct mii_bus *mdio_find_bus(const char *mdio_name);
+struct mii_bus *fwnode_mdio_find_bus(struct fwnode_handle *mdio_bus_fwnode);
 struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr);
 
 #define PHY_INTERRUPT_DISABLED	false
@@ -1245,6 +1246,7 @@ int phy_sfp_probe(struct phy_device *phydev,
 struct phy_device *phy_attach(struct net_device *dev, const char *bus_id,
 			      phy_interface_t interface);
 struct phy_device *phy_find_first(struct mii_bus *bus);
+struct phy_device *phy_find_by_mdio_handle(struct fwnode_handle *fwnode);
 int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 		      u32 flags, phy_interface_t interface);
 int phy_connect_direct(struct net_device *dev, struct phy_device *phydev,
-- 
2.17.1

