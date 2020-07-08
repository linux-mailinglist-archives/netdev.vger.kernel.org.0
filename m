Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F74218E58
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGHRfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:35:18 -0400
Received: from mail-eopbgr20042.outbound.protection.outlook.com ([40.107.2.42]:43335
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726837AbgGHRfQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 13:35:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvgDG5Qkc6YnXuNFyQ83anFAamoBQMKwnHP5SME73DadiGscu1xG7vwVY5RdRSTM+QMh9P5EWw0IUy4r4dsnxUt2eWJztE1vlYAWvqZZcc4jKHqSoJS4Hqgm4nAcSY/LSl1gRiqz9k4/u/KrXA8Qj8ucO73twhnp45XM10KaUVOh0tfMAIxotR1MCku41qGglp5sjOXpUQesZLfD6wsbS3hj278BevhSiGmYv9NUKDUd3u7AqlavFPs8LC6yMj+0Exffpy811tQIblh1e/F9HdjWSQBYm6uHIH+Gu+T6NrA6bfr2OXix2Fh/H4CO9WpJrv9EDJOKHmpu9dnnDi6CCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UI1vJHTy3Ch7GWT7z2o43wIWGa3e3aZwgT1QeiFNjMQ=;
 b=SI0fxI5k8ZwWwZuabVMKmBDswZVG5/YFrD7WvFNYdRKRG5TNzLa6Kl5b3X1vYp83d6Qf9zBzHa7kFz9LvPa6i2sEgxGZmLTs2R3YleawZ3atre8ZvFF8WfTeMUnF1V/JZF1Q1OePsdTpww3dSGNCaRQTxujKv2iX4ow/eyz8UAa/dAeXyMbcm+j8aewrv+hpiSl5gpoEibHO8QEhC7W/BdxyAW3ZjkdKVwY8mrNgxAjl0Y3JRlfQEGuwNoQjV97Bmq27LTxo64LBWBdbBl05YmLfzmNmgf/eF37kHkmHA0tqY6U/qoG15QRpuHpWuEZnBPN73+nRIZhxmARK3KBUww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UI1vJHTy3Ch7GWT7z2o43wIWGa3e3aZwgT1QeiFNjMQ=;
 b=gUjlAGF12DZQjT0c1pSpivvTH1/P1hLWUj6l3ghwKLJom2HeUnFHPv3MW0/kGPMOBFjSBbFFBmVqVo068963jHNl6D+AmsaekaV3IzoB9pMhXotaZrgKRviaPUZ5zq6LHcKC+gK4NUD0Eje4B9KY19FxvZpPSHvmsji0VbvYIQA=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5730.eurprd04.prod.outlook.com (2603:10a6:208:12c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Wed, 8 Jul
 2020 17:35:11 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 17:35:11 +0000
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
Cc:     linux.cj@gmail.com, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v3 3/5] net: phy: introduce phy_find_by_fwnode()
Date:   Wed,  8 Jul 2020 23:04:33 +0530
Message-Id: <20200708173435.16256-4-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200708173435.16256-1-calvin.johnson@oss.nxp.com>
References: <20200708173435.16256-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::26) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0100.apcprd01.prod.exchangelabs.com (2603:1096:3:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Wed, 8 Jul 2020 17:35:08 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 25e2e28d-51d8-4a00-c983-08d823654409
X-MS-TrafficTypeDiagnostic: AM0PR04MB5730:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB57303A077AB9ECADC0FDDCDDD2670@AM0PR04MB5730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zxNVu2y0qKh0bh35qkgxnXRb78y4+Qed/lnHcKio82GpPCnh3xb8VJGcwX0G92vP9E6c1mBPbAaq8+iNib8wz+3YiCpEDlZsxN2CihJ4MzVkpJvnxw7snEyRSUpQNsQOdNvfjRuy+sIr/J2o1ayrpkwDTn9ycLJJH3QXYpFDEMVoFtr607nAqsR5TmShKcTXuAK+I3C6YoCRELC7UYPQ44dXThOIyx5RwSY1C2DdLx3gBNjP+U+GWMymHY8zrZ5ktAhJLxatY/UOaiUwoP1Lmmyu4XY8zGP5v2p+m0rlLRIuT1CAskzJzSwMG+XZfvBtBjOECEhYPxrcmrfgSagBIghtLHjqfBiB0ZP09fkLf2co2cZv0R01Fb+jI7LXfJ1F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(346002)(39860400002)(376002)(2906002)(186003)(16526019)(956004)(2616005)(8676002)(316002)(8936002)(1006002)(6666004)(478600001)(6512007)(5660300002)(44832011)(55236004)(66556008)(1076003)(66476007)(6636002)(86362001)(6506007)(66946007)(52116002)(26005)(110136005)(4326008)(6486002)(83380400001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mjzfy5GAL88ECkMN6r2KdEgqwqIKYmP3wn3O9MsvkpTZQJ7PTBWgHn7Vrsvm+vrSA0y9j8kluua8vW+/Mc7E3MEt+/E8p91JkLEc57oIdJid2R75LgtKBCprxhJKIak5Qih5B5pmohzgXQWc05wMnK2PNNfMe3USXmXLky6/KWt9mgjpvq1Ua8hnr0meWIbuvAHtsE1E1cCtCzLx/hxF+vGZj97vaLCzb6eogeLdZP3KcInXBZR+NG6xdIPFD6I5m4+svcJOR0afyZB0KOOSmyDO2eubgbPrqYu9QRjEG0YCH6scxieedMj+5/m12ITxgRMuTKxuDh8cpkY4q7IR4RVgwOU4SaBCpGQz+5KnSD5YMJdUSxFFPqlnY0HH3XBwaGVI7s66yoYU4Naz58uXONIRubvsHFFeNglLinnYbaWnuOl5eWpc5oGkQfh8Eb41uKBrjmew1I7o2ICnq2roZy/9VTXxclaB/r5g2WJ7O4o=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e2e28d-51d8-4a00-c983-08d823654409
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 17:35:11.6614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kRCe8uW6n4mfVPHiPLQjrTwcT7Cdt254l779ye7mn2yjJg3ER+2khv/AcWjgJL74LfKx8vLkG5znXsBVFFknJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5730
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

Changes in v3:
- introduce fwnode_mdio_find_bus()
- renamed and improved phy_find_by_fwnode()

Changes in v2: None

 drivers/net/phy/mdio_bus.c   | 25 +++++++++++++++++++++++++
 drivers/net/phy/phy_device.c | 21 +++++++++++++++++++++
 include/linux/phy.h          |  2 ++
 3 files changed, 48 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 46b33701ad4b..626da1070392 100644
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
index cf3505e2f587..6d113ae9eaa0 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -25,6 +25,7 @@
 #include <linux/netdevice.h>
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
+#include <linux/platform_device.h>
 #include <linux/property.h>
 #include <linux/sfp.h>
 #include <linux/skbuff.h>
@@ -964,6 +965,26 @@ struct phy_device *phy_find_first(struct mii_bus *bus)
 }
 EXPORT_SYMBOL(phy_find_first);
 
+struct phy_device *phy_find_by_fwnode(struct fwnode_handle *fwnode)
+{
+	struct fwnode_handle *fwnode_mdio;
+	struct mii_bus *mdio;
+	int addr;
+	int err;
+
+	fwnode_mdio = fwnode_find_reference(fwnode, "mdio-handle", 0);
+	mdio = fwnode_mdio_find_bus(fwnode_mdio);
+	if (!mdio)
+		return NULL;
+
+	err = fwnode_property_read_u32(fwnode, "phy-channel", &addr);
+	if (err < 0 || addr < 0 || addr >= PHY_MAX_ADDR)
+		return NULL;
+
+	return mdiobus_get_phy(mdio, addr);
+}
+EXPORT_SYMBOL(phy_find_by_fwnode);
+
 static void phy_link_change(struct phy_device *phydev, bool up)
 {
 	struct net_device *netdev = phydev->attached_dev;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 1592c3d0e12f..6f283789d6d3 100644
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
+struct phy_device *phy_find_by_fwnode(struct fwnode_handle *fwnode);
 int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 		      u32 flags, phy_interface_t interface);
 int phy_connect_direct(struct net_device *dev, struct phy_device *phydev,
-- 
2.17.1

