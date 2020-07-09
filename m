Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A3221A66D
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 19:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgGIR6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 13:58:21 -0400
Received: from mail-db8eur05on2077.outbound.protection.outlook.com ([40.107.20.77]:27872
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728516AbgGIR6U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 13:58:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K47VKwfG5bqSWQNLbeEbeHg6VHbIrlI0WiXscyz8rf5FkQUEJlzojKSqD4IUQcMrmDGO8fPHR1Sp9DsFDxzJxjAQp7wa57UmPRgmSU4pVxtfv0gF8H/xNWJjmV5Bq9aBgzTvTxfFhvO22tX+DXbxhYrswnDqq1aCmp6dYRoShkH/YmGjMK+9wxKkNyIjxs6zVjs8OHTwTCuhf+/ZScfZaRL+PjM7SOpV0p4VU2yTBu83vdY+A2KPaBnQS+nhQcyvL35DR+KMCYCEqIcwQRgpul+wK+d4ELTfKlltc+tF3hc/+6lnKLb7I4WsFPhjsrW2+nb7CjfKVY0Dc6bbG/3o1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XdRg6sR1TUq43RIrXNFXsG3dBFGKjBg/B00Zc+zjA6U=;
 b=IBgJgtaX+IOBQNjXl9/ew/cpjvyym5deCGHd8gG72Z+iHTwN338B2lBmAFcGXKDIzxmGWghNE8k2ZhLiY8jPFCdonsTwzDw/G9Qe4DLrH2HvJikOjwCOg+SxxOGDAcj5KfIDCr8l/WQ3ZQlIBq8Z4hOFG49pJUA0HTDXdRved0WmYQciYE349+jTV1cQj1w9rrTfgMfpz1OEQRjA6D7t3+f3G1HXf9elCY6DYoK3jcRO+IO0ovSQRJ7pUT4cjrhLLIWTH6qcutjt5DwpXy6m4jsivyo1azpuLq4XBfLtE9E71QFfxg+iOPGaM/ICijVi+hYn5dyUprqTf5+Q5CATMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XdRg6sR1TUq43RIrXNFXsG3dBFGKjBg/B00Zc+zjA6U=;
 b=b7+2jgTQWzJHHyYygqrugrx9X5LC+huCmAqEbOEhd98qKIPizuRhaSqi9qaAaK5NtQvT9BQWFDXwjBQjTLDWqG2IEwg2xtK6zKF7qr2s9QrxBGOMHg7P5q2F5Ko78KRP8EO7EdpWlYxLdemLHaxZfrJjjm+10cIBWk5Y28pgGp4=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6898.eurprd04.prod.outlook.com (2603:10a6:208:185::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 9 Jul
 2020 17:57:58 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.021; Thu, 9 Jul 2020
 17:57:58 +0000
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
Cc:     linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v4 4/6] net: phy: introduce phy_find_by_fwnode()
Date:   Thu,  9 Jul 2020 23:27:20 +0530
Message-Id: <20200709175722.5228-5-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200709175722.5228-1-calvin.johnson@oss.nxp.com>
References: <20200709175722.5228-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0151.apcprd04.prod.outlook.com (2603:1096:4::13)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0151.apcprd04.prod.outlook.com (2603:1096:4::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Thu, 9 Jul 2020 17:57:55 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b175964d-e87c-4ac5-a98f-08d824319d25
X-MS-TrafficTypeDiagnostic: AM0PR04MB6898:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6898A8A44623F26767084C65D2640@AM0PR04MB6898.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IwPkTpR0jntUya25Fg+DyHXK1YE1zXMsDmuZ3zWU/BiZUKxQ7AVuYJqCzBDC1aUm/L3uI+ykaQg9RQM/s/qxq5aFJrqtRbXV+EERLbmOZnRyhXWWf201vJ8d5uHOVFjh8PS/ykDkf5T71v9NijgFxXDLeBDd4J6kxT/Te8dkzPKsVSIIo6cCC2QVE2Bbp3PT+Tk+aammKM5bFi/SZxN1xYQQ7QJFJAFPdIWFVhIAukbAx8E1gCL68+4gv7QYU+x1ul/nijnIDJq3oJ4tw60FSTtT3FMisFPvemNBrgkISYWK+6Qa4qhDC2MqzKGYQk9fJyrfjhMI0zu/LZBucFibJIfGNw+U0kiMeZ3MVHC2XLbVgklMhJPuzrUj5lHjMuB+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(83380400001)(6666004)(44832011)(1006002)(8936002)(2906002)(52116002)(2616005)(956004)(110136005)(4326008)(316002)(6512007)(66476007)(8676002)(66946007)(86362001)(66556008)(6636002)(16526019)(26005)(5660300002)(478600001)(55236004)(6506007)(6486002)(186003)(1076003)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: I8Xx/41kJ2OyHHm6eeI74Soz8RshPjpI2ciR6BUJ2UbSzogL9/36GzU8FS1eOmit+lAYLJtcJZUUCjkE51GvnmnDu4hTqSObNMHbKB69ZhgMp0eUSdsfmct7Ct6p667+KgujW1iickx9KFDXYi6q3sgLKsCCv98li6c+UaKqWfpanSjJcGVKHUxu67CbPSt5MVDCVbCVHjpkplrgTvCjPtc+j9xBDGYrPc5FXRGD+Y/7B/i9sKtw2voVLJHBePp47KS9t1QPLhyvEzsfqLhmVpn7ytY5+awwxfKeUboWfPlOWl2WM334qnZGcleCE+OatDVgUn/rJ+GvwBXWGMmAdvUgpcaXq7+A1Ulznc3MsHKY5RLg6GTx9RrTarMSJi0aIpUjQxVaV7JJT2BCiCXzFqtY7vYc+wgjidwrDaBEkRqayWIx3rDL/s8+JZ4gJRAMfSW6P7K8strp4dzwyDtNbsa4RXeRM2/Kd79yfq0zNNc=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b175964d-e87c-4ac5-a98f-08d824319d25
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 17:57:58.4002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kaR136Qv8FzwyekbwdBDkF4s2yElf0UKGJHZnkNUtjUFQnrfTGJVg9fOysP0uTGEFZ/U1kcZa1dcOzkhLLMFyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6898
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

Changes in v4:
- release fwnode_mdio after use
- return ERR_PTR instead of NULL

Changes in v3:
- introduce fwnode_mdio_find_bus()
- renamed and improved phy_find_by_fwnode()

Changes in v2: None

 drivers/net/phy/mdio_bus.c   | 25 +++++++++++++++++++++++++
 drivers/net/phy/phy_device.c | 22 ++++++++++++++++++++++
 include/linux/phy.h          |  2 ++
 3 files changed, 49 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 3c2749e84f74..dcac8cd8f5cd 100644
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
index 7cda95330aea..97a25397348c 100644
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
@@ -964,6 +965,27 @@ struct phy_device *phy_find_first(struct mii_bus *bus)
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
+	fwnode_handle_put(fwnode_mdio);
+	if (!mdio)
+		return ERR_PTR(-ENODEV);
+
+	err = fwnode_property_read_u32(fwnode, "phy-channel", &addr);
+	if (err < 0 || addr < 0 || addr >= PHY_MAX_ADDR)
+		return ERR_PTR(-EINVAL);
+
+	return mdiobus_get_phy(mdio, addr);
+}
+EXPORT_SYMBOL(phy_find_by_fwnode);
+
 static void phy_link_change(struct phy_device *phydev, bool up)
 {
 	struct net_device *netdev = phydev->attached_dev;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 0403eb799913..a2ec1c288db0 100644
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

