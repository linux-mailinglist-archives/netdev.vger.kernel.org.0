Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F3E2DB1E1
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgLOQtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:49:52 -0500
Received: from mail-eopbgr20071.outbound.protection.outlook.com ([40.107.2.71]:62181
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731085AbgLOQrG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:47:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxfCJ6uwZBOmHW7Fl2O06FYUoWMwkhRp6TcKiTApoQgtj0ZSJlooZ5Dhm4Gnx16Cv7qr4a9nkLgvMM4v/AgdkEAfQfQzWFXbUuRiqUIwguDid+/azPZ3xSWCKgok13TqL+Pge3RiYVVyAG1+7cUS1KE9Diad2ttdxM3GyHD5XjXSshYcf28lAlKnuGcGpZvyR1owzL5QgsVTI07JYtXjDuK6prIPRi+X7wPvna2uN5NuS4h/B30iW7jRly7q7dZ7HxFeGT7pjvxUcqeKPVV04ogWboEfzcCrmaWwksSlxYTSokWRgQywf58uIpmPosQZVZiW+QjOaWwTI62flVISDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UND/pck996DSy75bBqT6ZgaCDoQq7DUyw8eyoRx8PCU=;
 b=mEHff8PefSSw7NIVFGUg4bHrDo7Mbino/B3jJulaQPdzIF1xpoOv3XUfeWQ05VGULAUVFxcLiCTZ06APXw4JURThbZMgoMLG4Ht+eymyGQJchs8bF9inkr9pWpVMlP2t6ZgotPKBh41QG0yWDEQx1M7su4yMS/zEqtSk8eWlHF4F9bK4bzw40C/cCS0UW1+wZBJ2zgRRxErAt7s/zJ43s3fBFpWozA4FthqQK52eN2wCRhhWmGxC+vDTbTntNf5avcqHOguFdD8pE7ZY0L4l3qDDnlAVAUw8TxXKUCVdMAgNh4Jj0c2rfTNbI5wIvUTELKp9ESV/yY0wPIIOG8zAdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UND/pck996DSy75bBqT6ZgaCDoQq7DUyw8eyoRx8PCU=;
 b=PpHnXjJt82RGf9/lQ1zWhcobrLXBbV1ZGiubHnDpg+y1UaSodnle8I0LSYtW3R2Cqtw5Uqbh4+vhAsVymrMUd/ysPJUiVQUMll0+nVWz0QIWV5u2ESEyVjGgBf6tqOl89M0U+yO3O9Zt8EIfJOeN/frkNzQHJq7vqZ2CL0et6M0=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6963.eurprd04.prod.outlook.com (2603:10a6:208:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Tue, 15 Dec
 2020 16:45:15 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Tue, 15 Dec 2020
 16:45:15 +0000
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
Subject: [net-next PATCH v2 13/14] net: phy: Introduce fwnode_mdio_find_device()
Date:   Tue, 15 Dec 2020 22:13:14 +0530
Message-Id: <20201215164315.3666-14-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0152.apcprd06.prod.outlook.com (2603:1096:1:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 16:45:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 78729b63-e677-4417-5a36-08d8a118cc85
X-MS-TrafficTypeDiagnostic: AM0PR04MB6963:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB69632794F506550C7B870DD6D2C60@AM0PR04MB6963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QIblWHtQniyAXw6dXcDfAAvbN16NeFwqQP6aaYRXTMkpPPxwTYBcqGl/x150i4sGzRapKG0540q8IeuFSmJmnyv+v+C8n3yz1CLcB+Cw9Q6yED8hMydyYJHZu/xc9daBupqANVDBb3kbw1W4V6y7dFmOCX0fyj6zz+GIzC34jjRoxcR0A9JCy7oQx2tD/e3tzCXL70exJfJgB4Q/Ny+/sgKsIt2v28oIqIU+xtTH24itdGdwq8Aqi90DnSNBxtrQX5V++bB49O+1IrKASuloQ/LpAONcJPNJcVOqwDl8DyYYaxmZjZszwww/OXZ4EELT2L4gVAtqc47HxjbrqpIkReqWwY2R20zGeB+UkkeqMudc118DE36ojbRmU4y4XDYyPR64rEiqlbhYx40TFtHLsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(4326008)(6506007)(498600001)(83380400001)(66946007)(921005)(2616005)(956004)(86362001)(52116002)(16526019)(8676002)(2906002)(26005)(6512007)(44832011)(7416002)(186003)(5660300002)(55236004)(1006002)(1076003)(66476007)(110136005)(6486002)(66556008)(6666004)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xDsOUT3fhyYEwnQJF0AeNCDQGyCPwnX3L/2lAiLNs6G6ti1oZoCPYOk1/FLs?=
 =?us-ascii?Q?SFj/nwng1djD/PmoYnAY9AQhTTy5Oxvuq28f33th6e83zLHMcNivNNXJ26/C?=
 =?us-ascii?Q?r7Fl8xIHk7QEWAEYX2yaOfaRfLGE9XejOCKTY4dFMiZ/3TCy5XJrx5vy/p05?=
 =?us-ascii?Q?nOrG3P4Y9HOiItX/IcFB+IZDNP0J/Y+OjODJCe00v55wtaxabZi8C024mAO/?=
 =?us-ascii?Q?x9VQ/Cqkx0O8OIuWt5yoqPTCMQ8nm3QAWzg06oY4zOb+K1k1WHJOkJgtNrj7?=
 =?us-ascii?Q?wRskgXTospi6rMq9KrbzlRFFQTGO97FhllRRDAl9joW9K14P/vgvDUkeYMSm?=
 =?us-ascii?Q?BQJqv0Ge26qdi8JHLHLKt48cuopr+OuxhHij6unO2QszQ5g+ZQctCngOtm2Z?=
 =?us-ascii?Q?Y82yihKqL74myKfqaCgb6R8dbVkt+UUgzQTdogN9c+G9Oy7122MNUYR4/z9t?=
 =?us-ascii?Q?ItTyr3QROXHRKVvbToJMDji3BVQOH+TiCiHOfJGhYVW36saCmGUQ5GFkyd6P?=
 =?us-ascii?Q?09SzzB3T0lmKi9t+VeENmn9mqvXkh9MXEwrNILICFT155Uy29ZJMT5rotSWY?=
 =?us-ascii?Q?05jW4VKgPXRW9xkaK/o8nUb2Odhez13GwD19x4OhtP7cqxo/xXD+f5MWyTiS?=
 =?us-ascii?Q?juoC3kl+rV9/dY/JxsncA93mcpa3v97x/GTjkDrhJ42DBOcsCiCDVVTVq3hb?=
 =?us-ascii?Q?yxLuaDVy3KP1Yvh4Wn/3eMtF2A/xtYY+hM1vTRuvazzX4dUiiWUx2jpBOv58?=
 =?us-ascii?Q?fet4VvB+ry73VwkJKW+S1lyRnkPb93p/gszQ0lGcruPNWEWfU9jEEhBjpVf3?=
 =?us-ascii?Q?PPMH8I9ubXa8h4AGkU7oSdovReAj4fWDbGdFlSqaVNJfAU/aRJk1A3yI5HPK?=
 =?us-ascii?Q?r2pxVo/L0mYAMVbxRn6bx35YgBso5jEzWi5ocY8L9HYzGlUkacaDb704OoTr?=
 =?us-ascii?Q?9kBL3FmDPbILirE0GHwW1ugFw3P0ug8P8Ty60B/crSkv7Z50FFs7QxPJ7m12?=
 =?us-ascii?Q?VIqy?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 16:45:15.4624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 78729b63-e677-4417-5a36-08d8a118cc85
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GCqdCpQ/SlUuGV6/WUhTK+5nKJfUNs3JRle4exiimznbhE1oQu8uDyE78R+hYvo+0CPQNQZbXfZ2nvhWyhEHKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define fwnode_mdio_find_device() to get a pointer to the
mdio_device from fwnode passed to the function.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2: None

 drivers/net/mdio/of_mdio.c   | 11 +----------
 drivers/net/phy/phy_device.c | 23 +++++++++++++++++++++++
 include/linux/phy.h          |  6 ++++++
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index fa914d285271..1b561849269e 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -300,16 +300,7 @@ EXPORT_SYMBOL(of_mdiobus_register);
  */
 struct mdio_device *of_mdio_find_device(struct device_node *np)
 {
-	struct device *d;
-
-	if (!np)
-		return NULL;
-
-	d = bus_find_device_by_of_node(&mdio_bus_type, np);
-	if (!d)
-		return NULL;
-
-	return to_mdio_device(d);
+	return fwnode_mdio_find_device(of_fwnode_handle(np));
 }
 EXPORT_SYMBOL(of_mdio_find_device);
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 6fad89c02c5a..17d20e6d5416 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2851,6 +2851,29 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 	return phydrv->config_intr && phydrv->handle_interrupt;
 }
 
+/**
+ * fwnode_mdio_find_device - Given a fwnode, find the mdio_device
+ * @np: pointer to the mdio_device's fwnode
+ *
+ * If successful, returns a pointer to the mdio_device with the embedded
+ * struct device refcount incremented by one, or NULL on failure.
+ * The caller should call put_device() on the mdio_device after its use
+ */
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
+{
+	struct device *d;
+
+	if (!fwnode)
+		return NULL;
+
+	d = bus_find_device_by_fwnode(&mdio_bus_type, fwnode);
+	if (!d)
+		return NULL;
+
+	return to_mdio_device(d);
+}
+EXPORT_SYMBOL(fwnode_mdio_find_device);
+
 /**
  * fwnode_phy_find_device - Find phy_device on the mdiobus for the provided
  * phy_fwnode.
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 67ea4ca6f76f..5a0c290ff0f4 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1343,6 +1343,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
 int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id);
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
 struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
 struct phy_device *device_phy_find_device(struct device *dev);
 struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode);
@@ -1355,6 +1356,11 @@ static inline int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
 	return 0;
 }
 static inline
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
+{
+	return 0;
+}
+static inline
 struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
 {
 	return NULL;
-- 
2.17.1

