Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B9E2F31FA
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732558AbhALNnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:43:06 -0500
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:16694
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726253AbhALNnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:43:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QqssI2Y3D0fSA7Y/e6GbnbEDuHYufQy7ZCuOm3Jk2WChzu4mnjjEk3vy20Os4U+lZBKM1vmGR31XBFZNG2ypMlaH9IlhpwwdofxWUdxmS/Dkv9gVJW5ORluA2qo+jU/E0rFh7yjiQKCwFjlyl0mA1caQJmuQDGBOn1DtaTMdNX5bZW2cFkMUOQHFARc8+NteIWb902IF6O1RabCSPVscKUXfdj1bMG+Cux7Nphy50j0qvLs+3CaKKAyNPozaxoiTmfK0AJTrmXfyOeDtPxLe/rTxfc31bRT6xWgdJ9k5C39e+epvKvG75oZUJzaw4rR8FUMuTAJgXWVdDZDF6DPhtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXpABcfmKrz+MvWiOvDhJ1frsNXJUygFo5nom6tv2HY=;
 b=GCWnzp0rfiqTPX8VPE3BvVPH5Dtl2FLQfAu70mHDAWe1jiZIL6KI0889txnAMi28OAqStkA5SusLiYvU1+vXvRWnFerI2Uzx/mEyaqIcEINEvF5NU6RnYmmD+yXQwJmzazqtmTFLjZUkQwW/PSV3Koy+e88vhOuK3vFautUTEkbzF/0T3lUBweKjXIT/Nn3Q46YLA/5n5GsnyaE/UU6OFOY2ts+4UedQh2oX/kIEAkXyMCcvGOwV1txX6CdUn9HEZixk5gwdmZs+ZULzEPNusjkc0E9GZXGTAqrGQuwrGvZnOJGHHrlP0y5VbzRPaItfFVZ8/kakWfInYrZEWKuUZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXpABcfmKrz+MvWiOvDhJ1frsNXJUygFo5nom6tv2HY=;
 b=iuvbv6QtbYvcTk4FquPA30SoYU5ct450wJZSnaip/7oD5amobNLJtkIua+w0Nwmr87NWBMgjucgPLzET3Y6sPvSf6Gj2ioj9BX2m/IEzZZb4BZOkdxqXgdmpVH8FIX8PMX7hbE4hcbWE7ylN0vlkkZHrzhzZLHBPcdMxM6rN4DY=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 13:41:40 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 13:41:40 +0000
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
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v3 02/15] net: phy: Introduce fwnode_mdio_find_device()
Date:   Tue, 12 Jan 2021 19:10:41 +0530
Message-Id: <20210112134054.342-3-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0047.apcprd02.prod.outlook.com (2603:1096:3:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 13:41:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c3f1d1dc-f09b-48ce-eefa-08d8b6ffcaa8
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB34430FA62780A748ED305807D2AA0@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i8wnilx2HO5l9J9Ja9ErjF0aD5WC8QHZsNmKb8Rug+ozdaIqiCBopIFrX1BoQQ+Mp8JEa8PcFpngrA3SuVn9HhxC1CN/3re3LSJX/rtyEIrRTOXxBgEGdlthNhfcBZCNxy7tcjVvIQ+KXOprQMVX7JH51r6UfKoqEU0McaJVThSQV1DR1aLrylS+CVTzwImP88C7WMtcdvZgYcyWC57G9tlF0BW6ve1hhPCbUGcPMsWdPRGcuvs0rT3NFEXwwRSNZ/SdaGieX/a9PeG+a1VFrMxIcLBDsBi0hOSI6B272bL1V50TGwIcudvaEUCk5F/zn4ASW82S3TImergYXnalrFhcpH/SiHDCJZyK7odfn2f98+Sr8sSd/IRpQiItE3x9CD6r5Ql0achWlUa+IxnXrXvs/B1tZgXZfYuIvJrSae8zaaL/0LoAoKcCjBpcQR9D6qfZPq/saI8qDVluEso2mQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39850400004)(376002)(396003)(366004)(478600001)(1006002)(66946007)(921005)(110136005)(6506007)(54906003)(16526019)(83380400001)(6666004)(52116002)(2616005)(66556008)(66476007)(186003)(7416002)(4326008)(956004)(1076003)(44832011)(86362001)(55236004)(8676002)(6486002)(6512007)(26005)(5660300002)(316002)(8936002)(2906002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lUH+lzKW1BaWs0QJPWOZrYMKJvYiu26x0HbZLmeLF0CMmvLx6mIXef667u+M?=
 =?us-ascii?Q?CGxtvQjfq2duePvJs6Ko4k2XEdaFlJvfTI2lCQJdbefct0gMFVte58QlF5sd?=
 =?us-ascii?Q?EIByN9ubanIZaWx80UTvPa1k9hWlt/YK5DRzoOKMd/BoZZ+PNJQ0oBHBqa5/?=
 =?us-ascii?Q?YXThaeclpe31LbU/CoNP8E/0vhxWUmPtF7F2CCePw8DDmoAT5EJ18ePCzV7S?=
 =?us-ascii?Q?BrVcx4tsdTqdLe6X6ycteuZjh6V8zmXgKLfbz76B1KD00TbDhtbQd7Xzqg+k?=
 =?us-ascii?Q?Ep1B5SDhkxiP503eNz6MyVlJ9iLCGKB0e5TfNw51smNxxHQG7ypiAGWQtVCJ?=
 =?us-ascii?Q?rLA1sXA9QLdeDGtrCXnNbtfoxLTzVtNja0y3ifknEAdBmaZHqwzb4QqkvjWG?=
 =?us-ascii?Q?okVnmdj4W8MO4CGbgevKmH8gzOj54jb7B3S9g1mACfAcRn5gYrrnt+H2juxE?=
 =?us-ascii?Q?CfIx3y1u4TjuW/33bqFZOe8vJ/1vFOUTpG2bnLbnOjWfe/SvjH+HSwRIa9pL?=
 =?us-ascii?Q?FYGg8aT9H366Y75skXsfi9BcfwV3tADo57BW200yAzESVAn58/15rxlDEOMz?=
 =?us-ascii?Q?w+lPOuFdJfi0W5ZHlfqyyX02Lf7vJhgtL8bd/26/0aKbVH2miCsxq8cQY4M/?=
 =?us-ascii?Q?1Nk9Qu4h8/LsSYhNzGNNvNWNvE+YptJo/DDtzBMUHr1I8yNoA3+7FDJw+XjF?=
 =?us-ascii?Q?NTBrVyCgMOvTdoqIJtT3R7XcCWNC+B2RcCuOgHnca0vGjwwJc27+SrWYVm2C?=
 =?us-ascii?Q?k+S2jY5TPtStm6oQrzqLDLQCwz2icG7bhuL2OW3sHKh8hDwvn8ggvbtzO2Gw?=
 =?us-ascii?Q?CO9XfNzehRU+XJ39oTisGDpKhK69lQZTmMrIcRpD4e2X4fVcTtrt+0gPXDtg?=
 =?us-ascii?Q?uCFUVtozApK5adFv96qrEgi3OoGJa69x5Pa8/2t5LO194EgBawyM0NSe7h1E?=
 =?us-ascii?Q?+ylcEBzjy7w4N/nxvyGxhAswM+gPxIljTJ3gkL5V0JcffRmvjUnK+LGRhLFa?=
 =?us-ascii?Q?H3kR?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 13:41:40.5190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f1d1dc-f09b-48ce-eefa-08d8b6ffcaa8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sBEEGRohFTPPtsIc4YqbRg5YKKCXYqXr3Ge0SbCzzB2Lqbr6mJDwhvku2dQpFsnKJIJ2xYJOrAKfDQp+0ZMaxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define fwnode_mdio_find_device() to get a pointer to the
mdio_device from fwnode passed to the function.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c   | 11 +----------
 drivers/net/phy/phy_device.c | 23 +++++++++++++++++++++++
 include/linux/phy.h          |  6 ++++++
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 4daf94bb56a5..7bd33b930116 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -347,16 +347,7 @@ EXPORT_SYMBOL(of_mdiobus_register);
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
index 8447e56ba572..06e0ddcca8c9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2829,6 +2829,29 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
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
  * phy_probe - probe and init a PHY device
  * @dev: device to probe and init
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9effb511acde..ce3987e4e615 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1342,11 +1342,17 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
 #else
 static inline
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
+{
+	return 0;
+}
+static inline
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 {
 	return NULL;
-- 
2.17.1

