Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFBD22081D
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 11:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbgGOJEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 05:04:50 -0400
Received: from mail-eopbgr60073.outbound.protection.outlook.com ([40.107.6.73]:41219
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730370AbgGOJEu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 05:04:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvYwfURkNsyNR4Iq5Vy8zqr7j2VJ8LjMkm0N5lU6lJSKIbFcyZkyw8/W9hgT14YJHZ2ZjHLR5EbLhlP5rYv6wdgjWZAZDX4VArBsZuGZGlTW665Ew0WBEOkYZDAZj38ZTPa5WZzgK7nGxnmCQjwfg9Wu4VidpUmHbXi6NUfUAhsB8LDsJJU+5+UhdjLgARKolT2vuKUenKraN+Vsbbt/jnxvNoZiLYyePqf8JF0dmsjxvE2frc9loyq9RHc8LXBg/1S4nvVFfH9Q+syZgaRZanFEkuQt26rm5bVlWj7NOydMW4pRUQv1zFpuxh6mzvpLmgLBLIj4wK9Olro07bfkuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YW8t4Fe6YahYDhgUrcxeVM4KS7MCNZdMblIwRp13UBo=;
 b=Ddx/P9cuAIYWKxnDscjLJn6B0IrnTkYdZTgpNzHl4krykob1ej3B9kL69agGpox7v+TxtpaTndHqWR3VhOksA/pMF8aov8rY0v8/EZbFrYM84Gsg6y1Alx29tG1BU5/WdkIlf7GRLwE7SomEP4GPvBJniKKN7qqsKZh6CYo6w3G/dCOUF11rak1Kr5fkW1Ax5MQlEI4B2B1AcdNBcmDbXJay/KpqmE/WNCvjyxcjEpXmb4yi133B/PzHi+3F9sjWhBJBtEu7CWNF3Bz9FelRwc5TCgjbOP3tRn9plUlCjbI0dEYtaSHBczATAbGXQIZGncH/nyomLS4ULe1yAtkD0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YW8t4Fe6YahYDhgUrcxeVM4KS7MCNZdMblIwRp13UBo=;
 b=HP4zznee/dz/HS24nzkS6zeFuONlcU3iy3MgEYVhV8U1adG188rfNji34R1lR2japQaAaTON1G9RVJmgE+4DlbGD/YlbDXiaJ6QkgZpeMe5zmsEfGVzG8Q0RLikX6MDElSYOC4aR4XQGsmGFOVj3dd+nvwjdLkjklO99c+3XgIA=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3763.eurprd04.prod.outlook.com (2603:10a6:208:e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Wed, 15 Jul
 2020 09:04:45 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 09:04:45 +0000
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
Subject: [net-next PATCH v7 4/6] net: phy: introduce phy_find_by_mdio_handle()
Date:   Wed, 15 Jul 2020 14:33:58 +0530
Message-Id: <20200715090400.4733-5-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0070.apcprd02.prod.outlook.com
 (2603:1096:4:54::34) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0070.apcprd02.prod.outlook.com (2603:1096:4:54::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Wed, 15 Jul 2020 09:04:41 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3c023b04-7904-4a0e-6071-08d8289e1e39
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3763:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3763AF7E95D63502C2B5E791D27E0@AM0PR0402MB3763.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R+w4HxdD+PGTBSlW6yO9+OFB/CW63psGk9m0noIDzDFELzd9BzMXTyZ017W8ztaTtljVcgqR3A+hwRo1p1VizEGgCiJ+ODjpSKNwP5qAnuTSELglQqn5VyQzfVRfhABqyM66VLvZnwgYXutwn831IIRzg25B/06Q9paouHFw7PniLZEJYiztlD5ES/TLPPNHnrC7m4HXl+QK5mc+H9ve3koWkWdfJ2hz6IvCCig3U4aiqERPjB2G5TuE0o+BM9jo2ixeYo4LSi1Tu212zkh9EjALowAMogWDz4YrvBrXmg4bYHZSGZMx+98lE29mYUEowAKTkWJkuJYPY4GN2L5BvZ4yTQl0sMieaZlw/Y0zdQ4IOE1M5JbFhcPisEwdCdUs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(5660300002)(110136005)(2906002)(6512007)(66946007)(6666004)(66476007)(86362001)(1006002)(4326008)(66556008)(52116002)(44832011)(316002)(956004)(83380400001)(26005)(6486002)(2616005)(6636002)(6506007)(55236004)(1076003)(186003)(16526019)(8676002)(8936002)(478600001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1cAAqOqVp3sZit1tYHsjLDKL2emzOTQ3ANgU51aa8jEh0q0WHYSC0wx1imd8+xJfwwrNmdyECQ0EkW+yWcyot5y/gvWsTMi/8sUcmp1a3M/F2cilDbXD0pQg/Tqrsmog8bbu+HOHX8SBNatbghm3HzjHQF+2EYp8SaM2+RfhbSd0k3imF2kEcBWTc7ofjhAtCfHyfMCYQxXxLfYvn/3tYpEJTZ5dGaGWC8s6HNnlDaEqCi27RQzOhJKC6CxXMKut1xVAHG7L86kRnD2zzIlSYlaNQ8+2siF40vDmvn2fCNN0/DO9VuuR/I6kFEI1TYXgmzxfk5KeivRqPS8oHh8iGrpuckrYWj8IFNhxo3b9nJ0JOgUv3sHb9PwG29J32YvTvwMHYFMX3It2K1tfYokrwB+9TCGKJhlejw67fdGjFg8OSAploAcs39bdwJwJmzOY8mw/LBPymeofg7rayRnwav/Td+gbrIMNXcxS8w4oivQ=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c023b04-7904-4a0e-6071-08d8289e1e39
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 09:04:45.1484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V+DD6Mn/7csg59vLnjgYfzLR8ctxKBgsUI5+FZWvj0WTWrLaQPqWu85KwdL4EkE/aw93TuKP9aYrW+Vj80xdJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3763
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

Changes in v7:
- remove unnecessary -ve check for u32 var

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
index 7cda95330aea..38d781720670 100644
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
+	if (addr >= PHY_MAX_ADDR)
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

