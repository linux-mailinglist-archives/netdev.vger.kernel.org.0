Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84642F31F6
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732067AbhALNmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:42:54 -0500
Received: from mail-eopbgr10085.outbound.protection.outlook.com ([40.107.1.85]:39271
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726253AbhALNmu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:42:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAlkPZ0f5jhflk4cWXKkV8ICTh62vUqAXFCZje228nr6otSV+LA4sKTDm7kGZlrKDL+JGLUdZb9LzNiGiASypJzgw0Fw0LMDed/tGPSdz/GhEJ8MWyV8KCsLpa1HlPV5s/+GrnI3Pay6UJLs3n93vgYC00XV8LZuW16lj+A2RyWA0iryEcsjNVRmxDsxu8fqHJJTwh4Qo1EWNHF1tnhRw4KW0PWlI3/siCHqtwXIUFM8Gui5MSGy+x6LwgmXjI7Qb7/coS5kI8uuBPpRrX7Z9yAIQgp3yhAGCDaBImQa2lhTfurj9Js0fXT5ZBSLOEOlsARw9/gQpE5QQ9OCNYGBfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WsybhVlvbfI3fHXteC4zkRA3UhxDCQnDq/VekuFDeSk=;
 b=l6W71BpHc55QuO/AcBWvhrLYfx5cuL+d3d4sdwelBRlUSOszD6VeCNH3xo3QGDYQg9t9dc0V36FZTNLWARZR3IowbnSYLTTTHhuHuYRU/Jh2+VPVH0eLiARomCap54nC8DC+dwn/r3dKshJGAKPP10bB2KnSinDaX5oNqkVgMsekVNTfozsEhJkGt8htGsfiyr6DShCemza54q7oowv5kmQ/TZS5IN/jgDeGKHziiSQaPbDE9HvuUYn+BN28CFBgAki2aA3Nt5lyuhEdR3u64LQFcWAt0LEi1X90zNGkO3FFJ5YyHj63gQqE/IrbzIZuN9zkR0kXVawd7HnCPn63wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WsybhVlvbfI3fHXteC4zkRA3UhxDCQnDq/VekuFDeSk=;
 b=DMO56kgMLhF4cTKAtTe6X1eDB2zaycz4EJibHFUYMAdC2lAfRWN0hH3Z3ZqB4J8QGzKFZ3VWqZHEaAG823DcMMee/UQIGZmMrC/30cdok5zYOyaX8eGFTw55cme7nzWH0TuEFHHtAZGL1M04FKwwme8NXX/LUK1VTc8nmC3P29w=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 13:42:20 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 13:42:20 +0000
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
Cc:     Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [net-next PATCH v3 07/15] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
Date:   Tue, 12 Jan 2021 19:10:46 +0530
Message-Id: <20210112134054.342-8-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:3:18::35) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0047.apcprd02.prod.outlook.com (2603:1096:3:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 13:42:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 55ea22e9-b565-4199-ccea-08d8b6ffe23e
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3443C758811F87A3151C2AC8D2AA0@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tk4NLfTdNIdnmsVNEw4BcwDak8IHcaeTyuY4IoXBFfzb9n7sAlQj6ThvsUUs7KscigyL8GHtOmULRw97SlX7/jQ2ukmq23Mk6mleH09VxMFIb2nN2WkrVqphJvQdQntbwYX0UW8TQqbjQOkFlQotWBfwOeritjfI2qt3HIyZv0HeY2phG68MFlHCqC7FV0bN82zroFJ4htwiG47x+DegZyVpJ3RD7wrWayTMjgb1a6MbaaoPbCIV5fGPMHvj7dbmSxK4lN2Z/W6ALFABeH17A1q6AXuW2Q6sTXhpg2bPkGMVBvUbsrdlEbEtGVw7OFELEYFVukrjhwXRJzbbJhwws6rZF4Z4hprV/UZNB2fxUhQZe0bmIeWJ2k48LMvteQth5vsdJ0ZLvmLRy44RhBOfu8B8PSMm+YqCtmJr6ejDNuAi5qF3q7TMQCjlGorKVk/aXXftUlZn17PXKfzEaucByA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39850400004)(376002)(396003)(366004)(478600001)(1006002)(66946007)(921005)(110136005)(6506007)(54906003)(16526019)(83380400001)(6666004)(52116002)(2616005)(66556008)(66476007)(186003)(7416002)(4326008)(956004)(1076003)(44832011)(86362001)(55236004)(8676002)(6486002)(6512007)(26005)(5660300002)(316002)(8936002)(2906002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TgMZjtQIq+oR/MHY6we9svgpvHed0uaxZVnQAbIz+O+iYgYhPg7zJMIp1Rxp?=
 =?us-ascii?Q?DmV3pvuWv1m6bzaiemM1FJuplLBXKVV5tdMxYF75gvPkayKj1QXnQ3b9R2DM?=
 =?us-ascii?Q?xEJVAx7B45/yL1senewX3jqBV931UsVhh1SYzPnNQmqe6Pb7LOMCwXIJi6qM?=
 =?us-ascii?Q?6nf67tDZ5b7ICo6mTSk2pJ3v0pbulctM1uH+/m3bkuprM1KgV3F/t3aMwu50?=
 =?us-ascii?Q?7m6khs4KkXpPKd3faGBM/t+AKiHFFFOGFqysLMjc99Jz5kc8VoyH7gLa7EES?=
 =?us-ascii?Q?TSStQFk0RYk5VDl39rfWEtcVgj5bnnVorlab0vQjviru1YXraIgp9AgBabN7?=
 =?us-ascii?Q?pnt3FEYpM+WK5YJr+Ew+8SXq5ELCSLts7BB2Dob9P1/K2z9AAYXn5qzrKi9z?=
 =?us-ascii?Q?HmJoVXAWxJsfxtNbTXKenR7YFpoi3aHFlEfMG7p40YiUWpYa7ODM1PDvggdM?=
 =?us-ascii?Q?HcsDaMDf2b4GiKvvV+BljmXYB6n1MvVabzXBaBOSlSvyGJ22d5lcWurWNkVC?=
 =?us-ascii?Q?Je2ptWpDE2lPsErVBFcTakeUd5SYXv2EhLRQOAPibEGtPOQqeZhFAuSMO8iN?=
 =?us-ascii?Q?WiPJheveHEEwOQBh+zkgmgkJjamE5a5wEDS1luGA5y3aaDHX4dhFq1CoY5GE?=
 =?us-ascii?Q?6srNd2fbo2q62Esu2Su4YKUyY5VVf1MMchcbrWIm+qVulYKdMcm+2tzpy/9w?=
 =?us-ascii?Q?qTp2W5w48YzbMCP0h/L897yq4qRUcvEiiIGvew0a9GR2rEdjyfJ3Zcuyo+ca?=
 =?us-ascii?Q?Y1yviy2YsOoUbWPg+NGptZxkYVqz2GO/vkbfM2Rqbdnh7vMEHgQ6Lwjix7nz?=
 =?us-ascii?Q?HwvGrZEetL02yoP1Q0jAHdl7mCHB7t6R4chEeZtPgcy0+ZyBg0RVPxr7lnF2?=
 =?us-ascii?Q?oMcrKwtnNRWt90dgdPFDtyO3q8ztFDormomr3yGEaekn8tTtY/B3r3H23bJ/?=
 =?us-ascii?Q?XgoBUrd7kl4R1TMI1KXSSwjK3H1f9C1ers9HtpvGzICJKadWvE1osu5a9tAL?=
 =?us-ascii?Q?xOt6?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 13:42:20.0887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 55ea22e9-b565-4199-ccea-08d8b6ffe23e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UPvMrC7DhL2mZVt1GM7kxGNytlx15daFyvG/LiyJ7pV+PG2MZvE3CzvVZdyY1dVBo5Gbpw9rhN7QPZKzFyuGpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce fwnode_mdiobus_register_phy() to register PHYs on the
mdiobus. From the compatible string, identify whether the PHY is
c45 and based on this create a PHY device instance which is
registered on the mdiobus.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c |  3 +-
 drivers/net/phy/mdio_bus.c | 67 ++++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h       |  2 ++
 include/linux/of_mdio.h    |  6 +++-
 4 files changed, 76 insertions(+), 2 deletions(-)

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
index 040509b81f02..44ddfb0ba99f 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -8,6 +8,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/acpi.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
@@ -106,6 +107,72 @@ int mdiobus_unregister_device(struct mdio_device *mdiodev)
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
+
+		dev_dbg(&bus->dev, "registered phy at address %i\n", addr);
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
index dbd69b3d170b..f138ec333725 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -368,6 +368,8 @@ int mdiobus_register_device(struct mdio_device *mdiodev);
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

