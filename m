Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C613414EFA7
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgAaPfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:35:31 -0500
Received: from mail-eopbgr150088.outbound.protection.outlook.com ([40.107.15.88]:24231
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728922AbgAaPfa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 10:35:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZm+A7Q0DSeOJ0PsSVrWfj2KYPY40PBdMz2+A7LgGRB87sEoHBjOef5mVT57nKZJetDPNhF184+jHzP/ESimq0B9JXXDrr/gaQSy8TpZ4ZziH1gNjwGjLmRVL/FxFM6IefcOMz8UAv3mFRZuBqSgfqsYAJTm6fN/8KSc3YjV1uj/fKzqIE3jk28yOOQ9DMsh7BP5J4nhLq32oj3coOS72q2xkNQ2NGre7JduPXzlZeLC8xeSBpCG2ctWRTucUYhBNwSgLPY6GK5RD1w++5V/zGg08XlRqEBGXns8mxOCqGdo1toFpHYFaHdB8Ta254TkIJM3NKnVDkw/9shmin4eow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hTRpipYJTW3VF3bItMDl3M6eYaSewsQeotAJFnJUaNY=;
 b=RhN5u/gcvGAHyjdOKnqSSv9C98JwdKZ686YkOl3+ckOOxchO7oEwpaGWVY+F8UauQJvC0sxdqQomE603sw5gdEjK2MJwGfkhIAuxylQM4K0yAnTQV3r0dxP6CuqHVBKkpdSEz8yUMGzqVSC1PlmrUe2iB3t0YXQ/tHwEcRGNkzR62drII42wgj2NTfB7/iSBIp/SbYsprbffavvxRCTCAeKuc1o8jgdTxMkVW6/iGpLHIYPsV0QH7Sb2yASl5NQzpALB9Lsx7dYMRarIZWEm8qInE2hkKVqQZ9PLColq/OfmgP4W1T8yzWpMG2DxRv5KYOqVxScagwH5jI4/3fu3/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hTRpipYJTW3VF3bItMDl3M6eYaSewsQeotAJFnJUaNY=;
 b=srcIEFcENWccrC0L1WEQ5W5bzJ4iskCj31gt/WG366iE+Hdq8yjfjNN2Tq+YyOZjSl7PszZkYxJ+NH6p0cTjeOjSh+MqskZ91G8mAZMtPTS5uH1sFqd+2th+XAYk+7YhGHykhQde//03FgR/zSN6y/fOCAfOuNPbFSyewAivu2s=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@nxp.com; 
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com (20.179.10.153) by
 DB8PR04MB6730.eurprd04.prod.outlook.com (20.179.249.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Fri, 31 Jan 2020 15:35:27 +0000
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::e1be:98ef:d81c:1eef]) by DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::e1be:98ef:d81c:1eef%2]) with mapi id 15.20.2686.025; Fri, 31 Jan 2020
 15:35:27 +0000
From:   Calvin Johnson <calvin.johnson@nxp.com>
To:     linux.cj@gmail.com, Jon Nettleton <jon@solid-run.com>,
        linux@armlinux.org.uk, Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 1/7] mdio_bus: Introduce fwnode MDIO helpers
Date:   Fri, 31 Jan 2020 21:04:34 +0530
Message-Id: <20200131153440.20870-2-calvin.johnson@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200131153440.20870-1-calvin.johnson@nxp.com>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0061.apcprd02.prod.outlook.com
 (2603:1096:4:54::25) To DB8PR04MB5643.eurprd04.prod.outlook.com
 (2603:10a6:10:aa::25)
MIME-Version: 1.0
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0061.apcprd02.prod.outlook.com (2603:1096:4:54::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.29 via Frontend Transport; Fri, 31 Jan 2020 15:35:22 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1188d636-e608-4d41-52b3-08d7a6633224
X-MS-TrafficTypeDiagnostic: DB8PR04MB6730:|DB8PR04MB6730:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB67305F41C51D1143A69B19B993070@DB8PR04MB6730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-Forefront-PRVS: 029976C540
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(189003)(199004)(52116002)(7696005)(1006002)(66556008)(66476007)(2906002)(66946007)(8676002)(110136005)(55236004)(8936002)(26005)(81156014)(81166006)(316002)(6666004)(478600001)(54906003)(7416002)(1076003)(36756003)(6636002)(6486002)(186003)(16526019)(5660300002)(956004)(86362001)(44832011)(2616005)(4326008)(110426005)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6730;H:DB8PR04MB5643.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pa30z0axfPlnnvGrnm6DpwGOCA1/cJDBO0Oz+r2+SNGAiRn56k/pB6YcceqGTxyJsKQhiinlcHPy1CIo/Elg/TKCXQKXJfiJ0rnlfB3nP+Q330JZjHcijLrHBaxSWMcO8o8dWullxzEWnd3QBOiuWmCf3QSIUn+M+tIDGNjich31pepJ+bf7jMf1WXeJAzaj3R413FRr2gmZIk4vW0Cmupu2yPnxKSI8AaKHHGjZMYPncyuxyhujCbfTlA2CQCI3IDV0QXy8wSNwgm12RKyy+RoUY1CCjjldky56dyiGSkyCJ3rVL1cDq1U0dDOGZptIMa8/V4dBnxtgd4OFBrICdm/ZF1qXWw00MDmzce3ZNiTrW6PzZQs91X+aa8cXX1YOVETwIOL6pIbE5YaJAFM4+C1EJ2UA3DFhq2Xk8EHeLUUNHlhXpB3ROl/a0ImAgI2qOe2cdwN4g1G2ZdyUBuOhXwa1lH65b3AQPOaGzOVkmksFpoiQBoNqS55vUr9PVRkz9ogD5oFU4L1OA9zfio5FYjaKYxtBlyf8dDMGYYt6FSE=
X-MS-Exchange-AntiSpam-MessageData: YUpbBO9f993vuQE3m0Qu/roi0b2JbYddgLGGAGFFLmyGssrfVLERoRLt0QtU7PnGV+UJiKdTJJKCKowW+OqR6QvYZ4YoqnqQTNBFe4rdS0DbPsEFf5UWFPjE+V+zpGjBqsGjiu7P7S/rCm10UeoUFg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1188d636-e608-4d41-52b3-08d7a6633224
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2020 15:35:27.1067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Xx/K8zmEFGFmprBS71IIROjQiQkvEUJHTiy+39T4JV4lgPixq5i1iV/Ra3l6Mfv/DwCf7afIIg6LmkZ/+X33A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6730
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Wojtas <mw@semihalf.com>

This patch introduces fwnode helper for registering MDIO
bus, as well as one for finding the PHY, basing on its
firmware node pointer. Comparing to existing OF equivalent,
fwnode_mdiobus_register() does not support:
 * deprecated bindings (device whitelist, nor the PHY ID embedded
   in the compatible string)
 * MDIO bus auto scanning

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

 drivers/net/phy/mdio_bus.c | 218 +++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h       |   3 +
 2 files changed, 221 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 229e480179ff..b1830ae2abd9 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -22,6 +22,7 @@
 #include <linux/of_device.h>
 #include <linux/of_mdio.h>
 #include <linux/of_gpio.h>
+#include <linux/of_irq.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/reset.h>
@@ -725,6 +726,223 @@ static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
+static int fwnode_mdiobus_register_phy(struct mii_bus *bus,
+				       struct fwnode_handle *child, u32 addr)
+{
+	struct phy_device *phy;
+	bool is_c45 = false;
+	int rc;
+
+	rc = fwnode_property_match_string(child, "compatible",
+					  "ethernet-phy-ieee802.3-c45");
+	if (!rc)
+		is_c45 = true;
+
+	phy = get_phy_device(bus, addr, is_c45);
+	if (IS_ERR(phy))
+		return PTR_ERR(phy);
+
+	phy->irq = bus->irq[addr];
+
+	if (to_of_node(child)) {
+		rc = of_irq_get(to_of_node(child), 0);
+		if (rc == -EPROBE_DEFER) {
+			phy_device_free(phy);
+			return rc;
+		} else if (rc > 0) {
+			phy->irq = rc;
+			bus->irq[addr] = rc;
+		}
+	}
+
+	if (fwnode_property_read_bool(child, "broken-turn-around"))
+		bus->phy_ignore_ta_mask |= 1 << addr;
+
+	/* Associate the fwnode with the device structure so it
+	 * can be looked up later.
+	 */
+	phy->mdio.dev.fwnode = child;
+
+	/* All data is now stored in the phy struct, so register it */
+	rc = phy_device_register(phy);
+	if (rc) {
+		phy_device_free(phy);
+		fwnode_handle_put(child);
+		return rc;
+	}
+
+	dev_dbg(&bus->dev, "registered phy at address %i\n", addr);
+
+	return 0;
+}
+
+static int fwnode_mdiobus_register_device(struct mii_bus *bus,
+					  struct fwnode_handle *child, u32 addr)
+{
+	struct mdio_device *mdiodev;
+	int rc;
+
+	mdiodev = mdio_device_create(bus, addr);
+	if (IS_ERR(mdiodev))
+		return PTR_ERR(mdiodev);
+
+	/* Associate the fwnode with the device structure so it
+	 * can be looked up later.
+	 */
+	mdiodev->dev.fwnode = child;
+
+	/* All data is now stored in the mdiodev struct; register it. */
+	rc = mdio_device_register(mdiodev);
+	if (rc) {
+		mdio_device_free(mdiodev);
+		fwnode_handle_put(child);
+		return rc;
+	}
+
+	dev_dbg(&bus->dev, "registered mdio device at address %i\n", addr);
+
+	return 0;
+}
+
+static int fwnode_mdio_parse_addr(struct device *dev,
+				  const struct fwnode_handle *fwnode)
+{
+	u32 addr;
+	int ret;
+
+	ret = fwnode_property_read_u32(fwnode, "reg", &addr);
+	if (ret < 0) {
+		dev_err(dev, "PHY node has no 'reg' property\n");
+		return ret;
+	}
+
+	/* A PHY must have a reg property in the range [0-31] */
+	if (addr < 0 || addr >= PHY_MAX_ADDR) {
+		dev_err(dev, "PHY address %i is invalid\n", addr);
+		return -EINVAL;
+	}
+
+	return addr;
+}
+
+/**
+ * fwnode_mdiobus_child_is_phy - Return true if the child is a PHY node.
+ * It must either:
+ * o Compatible string of "ethernet-phy-ieee802.3-c45"
+ * o Compatible string of "ethernet-phy-ieee802.3-c22"
+ * Checking "compatible" property is done, in order to follow the DT binding.
+ */
+static bool fwnode_mdiobus_child_is_phy(struct fwnode_handle *child)
+{
+	int ret;
+
+	ret = fwnode_property_match_string(child, "compatible",
+					   "ethernet-phy-ieee802.3-c45");
+	if (!ret)
+		return true;
+
+	ret = fwnode_property_match_string(child, "compatible",
+					   "ethernet-phy-ieee802.3-c22");
+	if (!ret)
+		return true;
+
+	if (!fwnode_property_present(child, "compatible"))
+		return true;
+
+	return false;
+}
+
+/**
+ * fwnode_mdiobus_register - Register mii_bus and create PHYs from the fwnode
+ * @bus: pointer to mii_bus structure
+ * @fwnode: pointer to fwnode_handle of MDIO bus.
+ *
+ * This function registers the mii_bus structure and registers a phy_device
+ * for each child node of @fwnode.
+ */
+int fwnode_mdiobus_register(struct mii_bus *bus, struct fwnode_handle *fwnode)
+{
+	struct fwnode_handle *child;
+	int addr, rc;
+	int default_gpio_reset_delay_ms = 10;
+
+	/* Do not continue if the node is disabled */
+	if (!fwnode_device_is_available(fwnode))
+		return -ENODEV;
+
+	/* Mask out all PHYs from auto probing. Instead the PHYs listed in
+	 * the firmware nodes are populated after the bus has been registered.
+	 */
+	bus->phy_mask = ~0;
+
+	bus->dev.fwnode = fwnode;
+
+	/* Get bus level PHY reset GPIO details */
+	bus->reset_delay_us = default_gpio_reset_delay_ms;
+	fwnode_property_read_u32(fwnode, "reset-delay-us",
+				 &bus->reset_delay_us);
+
+	/* Register the MDIO bus */
+	rc = mdiobus_register(bus);
+	if (rc)
+		return rc;
+
+	/* Loop over the child nodes and register a phy_device for each PHY */
+	fwnode_for_each_child_node(fwnode, child) {
+		addr = fwnode_mdio_parse_addr(&bus->dev, child);
+		if (addr < 0)
+			continue;
+
+		if (fwnode_mdiobus_child_is_phy(child))
+			rc = fwnode_mdiobus_register_phy(bus, child, addr);
+		else
+			rc = fwnode_mdiobus_register_device(bus, child, addr);
+		if (rc)
+			goto unregister;
+	}
+
+	return 0;
+
+unregister:
+	mdiobus_unregister(bus);
+
+	return rc;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register);
+
+/* Helper function for fwnode_phy_find_device */
+static int fwnode_phy_match(struct device *dev, const void *phy_fwnode)
+{
+	return dev->fwnode == phy_fwnode;
+}
+
+/**
+ * fwnode_phy_find_device - find the phy_device associated to fwnode
+ * @phy_fwnode: Pointer to the PHY's fwnode
+ *
+ * If successful, returns a pointer to the phy_device with the embedded
+ * struct device refcount incremented by one, or NULL on failure.
+ */
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
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
+EXPORT_SYMBOL(fwnode_phy_find_device);
+
 struct bus_type mdio_bus_type = {
 	.name		= "mdio_bus",
 	.match		= mdio_bus_match,
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index a7604248777b..5c600bb1183c 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -327,6 +327,9 @@ int mdiobus_unregister_device(struct mdio_device *mdiodev);
 bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr);
 
+int fwnode_mdiobus_register(struct mii_bus *bus, struct fwnode_handle *fwnode);
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
+
 /**
  * mdio_module_driver() - Helper macro for registering mdio drivers
  *
-- 
2.17.1

