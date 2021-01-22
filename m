Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3223300B63
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbhAVSTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:19:45 -0500
Received: from mail-db8eur05on2065.outbound.protection.outlook.com ([40.107.20.65]:39968
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729122AbhAVPpM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:45:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZJ0zfBJCVIAdjJCH0bktexdad8HDOcbju4Cggqy6o/q1R9pdy6NCe/5n+p+TFztDgeR/sn6gPzvkCvXEQQVMga1rH2iFosWTh9EphuzOfW0Aln1XKt1dDd7JGP2V55JzqdzZhIHsVMesbZ0hywqVX0PsCed3xdYYJrprs0bMMBOh3LZCKLvp6vG9ziCs9XyLNE7cW0t7F4wqMZhSJV8sBtiHb9uC4NYvksDY4dCNbKFLTkhpfX0YvZTUBFJYjeLBbV9hHOq3br35EGblYygYBJq0gCogimoXvc44wJ1gcTFyqD0kM/O7myqVASjX2sQbeInOqACn/rZWlPrcVE6UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WjHnZe53MLeFhWs1Y7NOqOkwKmM3NEIis5YVorKWN7E=;
 b=ayvh6IEEKqQEsKfMkl8rZ+muu87/dq9K1fZ3WhSVNuRlgjbVBqy3ZWLs0In9sYiaH8WjmtSMRgpoQ2aPcnoZ5kG9NoJDSB0V3qv9Jng+wl4b0kMGGo9o6HxQkRIuJzoP9vhbmt5X8rHXBLvO47rdkrwYKae/q1hL5kQo5vGAIluoW+rh10RwGjuh5vMqfRXDonx6qsLwnEypj5VUE9nT/lLK1R125iK1fo5W1+ehUPgEDv5OfZrZixWixJ8DFWxlVeVsMq4Aai2CDliOQZod3vBh5V6AnXvMI57zDgjpIPikDRBq1cnf3IpD35BBxCDkKDtFCBZS2LcBoyH/nJd9Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WjHnZe53MLeFhWs1Y7NOqOkwKmM3NEIis5YVorKWN7E=;
 b=AwPyryP0OkhQW8MBe5Nyw2x8zEXNyDl2XmVo/PsiTSNcfmNqZNQ6/7c+QblX1IToAVl5P7SWDd0bpRYOFjg2TIX6+miwLASXuiurEb6Hpho7VQFpwAgeOhIOQ7M4Jnb8gkTAQzUb3Aa1+coQ7LnMkqkl3IK4Aj9bZKpeCCRCqpQ=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3764.eurprd04.prod.outlook.com (2603:10a6:208:9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 15:44:02 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 15:44:02 +0000
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
Cc:     linux.cj@gmail.com, Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v4 03/15] net: phy: Introduce phy related fwnode functions
Date:   Fri, 22 Jan 2021 21:12:48 +0530
Message-Id: <20210122154300.7628-4-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0117.apcprd06.prod.outlook.com
 (2603:1096:1:1d::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0117.apcprd06.prod.outlook.com (2603:1096:1:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 15:43:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bab25f88-8baa-4df3-1c4b-08d8beec8a7d
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3764:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB37640C7946EDD17207339320D2A00@AM0PR0402MB3764.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zMgcPNfXlJh6ppWx3xoaisogg8KeD8qKL4PcPC02XrObFt3L5MDW7Kuqf4YR2QhrbCZjKFzbf+/h74l9ui/TAx7D5gM117InxW50z85k7sbruiQDgGH5+XypsHUx4+6VwiYgQSqMkKKATuoUboABU/sulZBkvS64CloH1cVuqfQv3qOdtV0e6iiMyHcpa9xMcfv/jvHQXRyueM4FOGQtCMWtQmos2reVb19V/MMS4mPyLwqsb3g54mhNMlKp9q+QOSRsezm4SbvjfExpw3fE1ac+lFkShNfCuXknPqf0y6gewHHnxpyvEN1qfG6M/pn52pWd60x5AbBgPOyt6SSVOvje5vpoSu6XYG3QtThwALHzRTfE6DvTC2+QB0QwG/sfhIqSeAtbNMxd2SevyVQ6B007XbwV2sS5eZw+mal141etfD4Rv7d6jvj4SzUXRGumh4TOUhje7ozW2BPzhdR9eAelHWt0vBmz5ouKCXktkKVklSPbiThsxyaNivaJC8gzASYHGVyrdSPti+z8MsMZ0RRD/cRnPynoAq7Ta7Y/1uAExtWoRIkhWRZFm2JX5XWsK+4nxUoAVZexW3PS15rNCbA2rCSUc6l0OdqQxqO/JpU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39850400004)(346002)(376002)(54906003)(956004)(66946007)(66556008)(1076003)(6486002)(83380400001)(66476007)(8936002)(8676002)(4326008)(55236004)(7416002)(26005)(110136005)(2616005)(86362001)(44832011)(1006002)(478600001)(16526019)(6512007)(316002)(921005)(6506007)(6666004)(2906002)(52116002)(186003)(5660300002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0ez0/SFhqo/zUhB365rOOFqW0Fgs3dGE0sBVs+apuWlQDb9uZLa0S9XhG7d0?=
 =?us-ascii?Q?VkzuZhUpzm5drFAd9bmeNoLt6Sf7cjb21kutCeMV1qpxuE//h4loLiLJE6t2?=
 =?us-ascii?Q?dBefisdfVY803/iGVGDH9TVeRxIyakUhzcXlnGNYy+D/T3brqGpWS47Xsbo6?=
 =?us-ascii?Q?pTAfwYkQDqaErUvlui+uJHvgAOYqhnHo2kT5cdUrc1Y1M3WTi5suniVMmql0?=
 =?us-ascii?Q?0SPM/u3GNAcKJAmW3hZQtx2hG9tYcyqez0N3Af8fCMzh3sRsCDd9o52Ha4fx?=
 =?us-ascii?Q?9RO6T0SV0sO0E6fGB3kpmhl6ynOoemu2QEHCROICZ9sOnN/6hj56J7wP8/T0?=
 =?us-ascii?Q?PCLN13nv8TIjq7yGeFbdTqfv/ZE0CodhNbMWiYgbMMgDdChrqW4OK04aQuu+?=
 =?us-ascii?Q?IYdunE3IDZCrDxjokxkWcznsBLSrsg6EkiqGadkXr9iyNDofWNgdWRPgKysa?=
 =?us-ascii?Q?BgufTDMMwhm5G+NoBIQxP6YZUFNS/cp0S89sunga5gUj8eMpVq78P9kU6O99?=
 =?us-ascii?Q?e7yZfzt6csPW8ivRs7xX4IFUqeBz+5PV87hCO89rm/rZurJEbOuRuplHmF3r?=
 =?us-ascii?Q?ujPTYUW9WxvAyFZ8muSv/zjajgYzUprbi4Ps8DgZY0RiR4htLyeqcecTDttg?=
 =?us-ascii?Q?6FuS7Ks+lHxdjPa7fowzzET6cYA7E9oB9fIPLLikzljHI3Ir1Ikf1DJfE/Vt?=
 =?us-ascii?Q?B4XVc2c1cr+5S376JHnJSkKpV+DeWm3dsdlFOxDXOVtzt6eLUQ2B50HASdLO?=
 =?us-ascii?Q?S44XT+coW07N+4AzdakXIRyECc0KUK8NhePAOckqoWahF/GJvpZBIEBshwxa?=
 =?us-ascii?Q?tSttIZjAFVE9noz9zJX8XHvEoV0T1D4nzEDvc+Uz2kLedxkvl9Axk5nGLIgh?=
 =?us-ascii?Q?8J4ovgfFkpK/DdyDbUDM3Oc9SeAAmKJI/mYu4fs8ssvqOo+FLj0OglZNfkWo?=
 =?us-ascii?Q?Fi6SxH68FL9u589UEUXUO0sTL9oIQ9eNcXnvkbDuJ9+gHWRl4CePmo19slnN?=
 =?us-ascii?Q?4lx2ASaKFBXN3vonWEMSaY/K+GwlPRLpnSictcWzr6k4YxcSfz7x0p/8QNXE?=
 =?us-ascii?Q?VZoRxRsW?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bab25f88-8baa-4df3-1c4b-08d8beec8a7d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 15:44:02.3726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0lBb2j95I838kKIl5N7cxN3JiqLolmhrNmEU9o1eyxhZx+a1K628zpfcSkKI5UmsafKP4ISls394DhOx/Kf4Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3764
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define fwnode_phy_find_device() to iterate an mdiobus and find the
phy device of the provided phy fwnode. Additionally define
device_phy_find_device() to find phy device of provided device.

Define fwnode_get_phy_node() to get phy_node using named reference.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

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
index 06e0ddcca8c9..66e779cd905a 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -9,6 +9,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/acpi.h>
 #include <linux/bitmap.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -2852,6 +2853,67 @@ struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
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
index 8314051d384a..dee7064ea4eb 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1350,6 +1350,9 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
 struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
+struct phy_device *device_phy_find_device(struct device *dev);
+struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode);
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
@@ -1359,6 +1362,23 @@ struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
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

