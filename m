Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E9531E59E
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhBRFb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:31:28 -0500
Received: from mail-am6eur05on2076.outbound.protection.outlook.com ([40.107.22.76]:48096
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230282AbhBRF3K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 00:29:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HF90btY+P2NKF3HgXpLuCJlCOXl4fZ5HApg+NgKf7V49zp+k5iC+hjmW8MFwr23xJOIEA+CJv0O2SZwZZz1ytjR49sV+ti63Bz9jdmGI6Hi7Ce3+v3m4aIIKc9bqbLOMA7Hx77yCz8gr1C7wtJhJT9Ro2ssC39PDrFO8BqJUONsIa1UPiKXiMeNrHHUhP7LUA5RyAInhuQqEwBmYDdwm1na+FRYSt7ewj63aROKwFW9gmh+MO+RN78TfwLr9NvrL1JqF4IoLdwpentqA7PNhHths/F2Ps/qrgYomCZyMzHA7+bKNsqtVqcLVceUmvT90dDiDldnxW9l+EdIkWcVGfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZOYecOt4RSVmkzwuwUIQWBC6q5eTkoxJIpLnAA0Np4=;
 b=BtCRW2rKLNkxNzoeKI5uz1i1ompqMCv//OktXw7kMpDU8L39Gh9Av1QVWbCL0rd7uXQmSqQg/QhTfEvnHQzCr+3c3DQXEwJY3aVgBAkA56lLhta8Rus7RZG11ybU4NeKq0lmwRzlka3sremubA7modIHYGqHbES7aGxxd8BUD8R0D1cj+DSH+JZ4gHLFDRoLnz3cW3LZ9fGmSTPBCZTkbKiLK+zWXssqyS0Xmh1H69DKv+wEuKyANdiQEXFylipGbeQZLcogxgB3YcraoSMahJgY8mifAxGtFJBBjT+fSYPmdFfYhYFK+L0e4hIc9Uh7D7R4IRxUXOEEjJtes+y3ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZOYecOt4RSVmkzwuwUIQWBC6q5eTkoxJIpLnAA0Np4=;
 b=Wca/z+hKq8lS7dlCgRAB+g8xpKKVOb9mb9++JmbgqR51C/QZA9XYzpTU2hfBMuCuSUvj79cLvhDl+d/gz9B/19s3TFyVkfivbBWHYpvdreVdKr8g0PnEpErvl4ZvswH+TTveHy30Nx4a3Q9eC7tEG6GRYqitscfNHCb39DJpl9U=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3442.eurprd04.prod.outlook.com (2603:10a6:208:21::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.42; Thu, 18 Feb
 2021 05:27:46 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 05:27:46 +0000
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
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux.cj@gmail.com,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v6 03/15] net: phy: Introduce phy related fwnode functions
Date:   Thu, 18 Feb 2021 10:56:42 +0530
Message-Id: <20210218052654.28995-4-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:54::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 05:27:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e3b72d66-ceaf-42f3-4537-08d8d3cdec9f
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3442:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3442F1B53B0ABDCCAAC6B7E8D2859@AM0PR0402MB3442.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nRBe+aawi4jvYREZ2kxxYWhfmFDhADjSgKIfRNBTypNexAV2anugX3hzagZTwuKT3NVqvvE4mefqsv2RUhi47v0D3O1r8siN+wjhafBPjBQXwNqzLRi652ICV/wzw88jiPfbGekLqHUnJ8DlwVpIgP2Cnh0O7AD1sn7Bli2TnmDhZub1mmS6L+ivNZq03sy7uj0PJQHBCZVMbpQXBWMltHhCsSpmA6n+bgUxTVVuAsPcuMv6aNnB0BEtPGeR5rn6TqFYtYFASy48VtcJfsrAa613neeMXv7AKftpmgk9fYNWkwoK6rfGKFtVZ/GSvQtb14X0QyZ7YOnAL2bfQtPhK/C2zq8zH223d4u1WOnOorYuLqNzqemLGsGjYKuFa0YAv28+FljxALA4WdGKeGp2PnoEyw6hmF8TGc1HV8SieQm82SM6lZn8tR9SgTNE5oQG0JlSEZilGLiYHhjIATwtaqgx5spCc1503xQqyjuqxOj41lPhGTEvwa6L2V1QfWu/FEsk95LOubtbTraWAFo5OfRU1qsyB5ek6bDADwUKxNUQmNKwBW92qlmeMY9IGxMT08FxFpUYOfaqckPp4EHf7cOqXVdfygQ+7a7LMZpNDg4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(44832011)(6486002)(26005)(7416002)(16526019)(110136005)(956004)(2616005)(186003)(55236004)(83380400001)(1076003)(4326008)(316002)(1006002)(54906003)(8936002)(5660300002)(921005)(2906002)(52116002)(478600001)(86362001)(8676002)(6512007)(66946007)(6506007)(66476007)(66556008)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5OKDYrqSaHTBbIzuZFQGCNlPRIrZ96EQoTI7THPDXMFgrxMJ97UbJqx/FgUj?=
 =?us-ascii?Q?V1neR1mZlU+mCZKDSykb6p+YwGWuUiqPRm1oNFTGRfejfK0dK7J7GKKGrqhl?=
 =?us-ascii?Q?6zTXu/9w66g4o6+xFXylrIzIf74bVFhS6EtMWbjbFLWpFefCMDv2d5nAFJvu?=
 =?us-ascii?Q?7GsvkXx91TH02GjR+Okznua1LDlibH6zzu2+RsQpWg5xpE1cr27pHpXYCaot?=
 =?us-ascii?Q?PMBVPT5cboTttASSn7AMZ2scVO4GjrGk9Lbgz0bz1cjWc5dP1+BfXQlRpQhU?=
 =?us-ascii?Q?UTF45HdUnI28pXLozmQNtXwQDH0UxkLLaulEMHZCjUr5+dL7ZHu2FnTv26T3?=
 =?us-ascii?Q?djiQU+mIZAKBLaCXXsflgvx8dPka7XVxPrIZIBoNp191wg/vONaO+lGURFGT?=
 =?us-ascii?Q?GMfEYJ+/9eT/CTroU/VcsMnGPdeak5+2e446yTdMhbSAR55ZZlyuUjfH+8KZ?=
 =?us-ascii?Q?1eNt5dNuWBSD4747jP3QStlqoeiJvW33GG9fNygtRaGue7K3dce3SYhX4GA4?=
 =?us-ascii?Q?rJ7R51WVyB7L9SuxLSu/FHqAzncPPb/ixsr/utdnrG9tooTPw7mDYfcXeGKZ?=
 =?us-ascii?Q?sTHocVXOQUovLYsKBip0hnV5TphLswTD6Uphws+61XciQooNKboiKszGSGrb?=
 =?us-ascii?Q?nPOLE1rze/kfeZ7frdnrKvtrlhqzo3vn7cIGfP5D5at/qNvIX7PrTjfJSQhz?=
 =?us-ascii?Q?jWlJK3uCvGH9JqA8srseSjsNaf20JWZFVc0kRqSiwZ00rVXdW1Q+8gaulX4V?=
 =?us-ascii?Q?1Jpg9t2P6TT+ow47yKcXhwaVUSXcPcfZbZ8Q9m+hCqFg8BxRxmzArKq6lCLm?=
 =?us-ascii?Q?KYMmKne6zMZ5iIjMvVlSAFgHdDEwPHYDV3G39S1vVaUckyZ91lDtL+4/y6nx?=
 =?us-ascii?Q?v5bhhmJarGDUqFb5hiHnzFLatFBpPlwXeTMWWOS3dHxR2+oo0nzHvFmfAkrX?=
 =?us-ascii?Q?Q1HGc+zl/tpOYu+tM9ISA6Rso+Y+YfziOEQwxMGFI3PqMzx/vWVZCrWkOMC1?=
 =?us-ascii?Q?EkxGiCXr10KXElHRC0Egb0qxDZ8VA7UJQ24EYYddTKZkJ+dKBxGP3X3qTCIi?=
 =?us-ascii?Q?9eqOuICs89E70DCZw7XlA2c+J6PmoCjBTzhyRzhyteGyqDWzt/pUpIpJy33/?=
 =?us-ascii?Q?sGxb1gBuguZrdTN2C/WFBrKYE1zfMIM7DZxe6ijOL3ia7dur6QjAbavwB8Jv?=
 =?us-ascii?Q?QeQTnrobXNyn0uXE4vi7TiYYqyZ40nlV40wA2pb13N7loBNUEDNp3GpXpdmK?=
 =?us-ascii?Q?ngUw2izo28WHNVoirCgWK2DiQG64P9SdTIgNHvNGBNbowQeFgosWmszlqw35?=
 =?us-ascii?Q?ve15MlsQQxHRZEtarSe+cYKz?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3b72d66-ceaf-42f3-4537-08d8d3cdec9f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 05:27:46.6621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QDBFf9JZ6SBkwHbKphGnaVJcE3VRtfkP0Ae1bwfSraMXze8nvaJ7wvrV+mjkuvq470er2AR8vVrYJMX9sdY6Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3442
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define fwnode_phy_find_device() to iterate an mdiobus and find the
phy device of the provided phy fwnode. Additionally define
device_phy_find_device() to find phy device of provided device.

Define fwnode_get_phy_node() to get phy_node using named reference.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3:
- Add more info on legacy DT properties "phy" and "phy-device"
- Redefine fwnode_phy_find_device() to follow of_phy_find_device()

Changes in v2:
- use reverse christmas tree ordering for local variables

 drivers/net/phy/phy_device.c | 62 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 20 ++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index e673912e8938..537a25b9ee94 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -9,6 +9,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/acpi.h>
 #include <linux/bitmap.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -2844,6 +2845,67 @@ struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
 }
 EXPORT_SYMBOL(fwnode_mdio_find_device);
 
+/**
+ * fwnode_phy_find_device - For provided phy_fwnode, find phy_device.
+ *
+ * @phy_fwnode: Pointer to the phy's fwnode.
+ *
+ * If successful, returns a pointer to the phy_device with the embedded
+ * struct device refcount incremented by one, or NULL on failure.
+ */
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
+{
+	struct mdio_device *mdiodev;
+
+	mdiodev = fwnode_mdio_find_device(phy_fwnode);
+	if (!mdiodev)
+		return NULL;
+
+	if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
+		return to_phy_device(&mdiodev->dev);
+
+	put_device(&mdiodev->dev);
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
+ * For ACPI, only "phy-handle" is supported. Legacy DT properties "phy"
+ * and "phy-device" are not supported in ACPI. DT supports all the three
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
index f5eb1e3981a1..720a2a8cf355 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1367,6 +1367,9 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
 struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
+struct phy_device *device_phy_find_device(struct device *dev);
+struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode);
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
@@ -1376,6 +1379,23 @@ struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
 {
 	return 0;
 }
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

