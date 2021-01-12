Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A612F31F0
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730809AbhALNmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:42:43 -0500
Received: from mail-eopbgr00079.outbound.protection.outlook.com ([40.107.0.79]:33088
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725843AbhALNml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:42:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9cJlMBGWwBQ0NJsHiltzWVWQOBT3UZ1is87ArE161gQOrllIXHA1oqxyOFxUXnkXeqHTg6Rf/iC1ZH5RBCrA7cmJpoK6a5V8/XPEjPbnnXV3oszdiZ8mmbf70/ULQYBJ0osKAOqztXSFajwY7kYL1ghLRquesk/HEBwNqc/I74f1Z4O90Mdor7qHEQCBjYa4EYP1AJd6MFc3WGo3zD6nEOVTsIzC7nRTZcksyWy4U6UK1JjHXshcLbyuRCkmrKHG1uuMrzMzluu1SGhk1hfDSaOUvDoRYr5RkdtEfAj+fpNW5kYovYKNd5SewOFupeEoWt8r/tX6UwUYPdPzhZAbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sir8v3rNx4GcVDux9K9KZ54i/2RfDh+vbBX2seB4Rw0=;
 b=Y65DlfGzxRDDCnuv+aI1VvKgOmSc0/7OOr+JH5wgTmPv+7GUVCSUyziCe9xM+3t53Y84OK3hsRa27CWMc4EZsS5Fih6o1BlHoPqBAJFqySScja5gB88ABRiNgmhnH3DrPNjk5zbJnor7emb3N1UX+bISfK1DBLsG2GNSXnjAACDT0I3XYYzmGSvaNtFVkVAQEn3nWqAqnspBJzbGAJjO6IZlWChngMf02Oa6+H1X5gGS8NXkclxtng4asy4GFeMfZaZwpj5Hdlg78A19SjKl3EJBbIHRPByzBLHY5vSV+ylfuhHSKbNGUD3IcH2ClCnLw/SfctE0uDWrti/mzaI8lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sir8v3rNx4GcVDux9K9KZ54i/2RfDh+vbBX2seB4Rw0=;
 b=SchwIt+SiUyfSCuhKnJND5YOGOvdKtY4/4PLlMITNgvglwRf3LIK5r8Ya5l2RV5so6839B64aeg2dpT/PbMuK1G6fczaIqcwbiFdp5ULBC0dGZv9JU9z+6RCz9Xsdyk42i+9KUQqyzdgv4mDL5Q8LpNudU1T8iDd8P5z5MWJxlc=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6436.eurprd04.prod.outlook.com (2603:10a6:208:16b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 12 Jan
 2021 13:41:50 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 13:41:50 +0000
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
Subject: [net-next PATCH v3 03/15] net: phy: Introduce phy related fwnode functions
Date:   Tue, 12 Jan 2021 19:10:42 +0530
Message-Id: <20210112134054.342-4-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0047.apcprd02.prod.outlook.com (2603:1096:3:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 13:41:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eb448f5f-9467-458c-c841-08d8b6ffd06b
X-MS-TrafficTypeDiagnostic: AM0PR04MB6436:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB64363B329516255071C0C925D2AA0@AM0PR04MB6436.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zAH2EtLBK4mZ245MBofUwhuGljxo5Ikb1tzUW7bNjZ4xsZidScwdRTSpsJE8HmTrf1v+j9a5eK6Qd8XkyNiGs9KSd4AkpAnavsSWLplf19SAUvbnmK4z9KpIJ/NhtY+Wx7lleLoJg5jLSx6DrfAPrcfrEfz4LJb7GmX5zlc09KVp9CVApkaCEuAOCGiIzdvaQrCC7CnGE0GXXuxReyKBVH6RiDGkoC872BsPNLh8L2HqQVhLdwhbgZ/ocgFct8TfYfPEcfpcXRYFLouarIbz9WiMqUuAvSFDnKbBtSDdXVx8OHW6fsRI62iM8a09ku6KRJmESYDlmqzmUvACpP1UOPP4GP+PXBkRmRyTXjgXXrgpxToXNbPu47MtYyMZQDoyj2BetrylJy++HAYgeY6oAr1eJ7V+RDOxYNBeTBq4FlSg+br7kHWTaQoJFuw6qBYNObN7Qc0TURmkgHzpVWRA8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39850400004)(366004)(8676002)(956004)(83380400001)(921005)(6506007)(66556008)(478600001)(66476007)(66946007)(6486002)(8936002)(55236004)(26005)(2616005)(52116002)(16526019)(44832011)(4326008)(316002)(5660300002)(1076003)(54906003)(2906002)(186003)(1006002)(86362001)(110136005)(6512007)(7416002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?D85EQmdBKB9no9+Rn+gdv+xsplwwChGcn845eLgq/XzK5UFKHo+A9HB+7HNS?=
 =?us-ascii?Q?qYcfbInkO+iFlDLtwgO5yB5MlNV5CNtHTvoBod4qgMpYYEzkjmcTcG6vPxeO?=
 =?us-ascii?Q?ZFpWW8wbXwRyy7iiiDp/2621SDkH+xIDOAjl6Z9UlN20rZse5aw6qz2uoztg?=
 =?us-ascii?Q?JWcj60pmlUtL7ATr2/zWLQPM32vgOUDeA8TyaZjFpbJeDlfu/OmC8RmuX1/U?=
 =?us-ascii?Q?uTJUHULg/gYXXq55f7iyVrt7BMg5q3Bz0dTHXQt+sKkD4GhHKBHL/WaIWG+Y?=
 =?us-ascii?Q?WQp0f30xEuI5tUpEhFg8Z+Cr0tSaUCKfGBFuJWndluW9JGiZR/Qj9heDvAye?=
 =?us-ascii?Q?TOSXrh2thJGsTsfaiSrLZSwJ+mMTKy148TfljB8/Ne+dM93dhZWOEZfFFFtE?=
 =?us-ascii?Q?NZOJdBSk0eauw43UnVNs0VoM3KITPKG3xV77RIaMUYjGo5StEizT22j3pP3k?=
 =?us-ascii?Q?fsmTwAJzmfVuvir/DvGYeRreR3YD1T35Qi+uvPKeKqCE1+1gdXZWhW9qhjbh?=
 =?us-ascii?Q?wbllovZhUmnA7gDNjfUMYQteiBPrEnt2XAgqV7+a2wr2ueFsVnq5/aq7As0L?=
 =?us-ascii?Q?E3MbARyAnu8839eM3sPXYJyPQqN/48pkfo8lST2AmZjZ5PioZNr0+QHXUoe2?=
 =?us-ascii?Q?maB9Y9W0Pnei1YKX+f+RQjP4OEeL9GkQVvu7m7WaL+bnAlvgtCS3d14rCVpr?=
 =?us-ascii?Q?0A8K4Kyxq4navZ87nDn2uLDovHfeJt/zaxtNgDKxQF95GsmbeGA9gnY3wjug?=
 =?us-ascii?Q?mDAo2xqbDGVy6mkPf0fZJVK2nFqk1dd7URWYgqkcxFnQ/BpjtybUeOUTqZuF?=
 =?us-ascii?Q?MBsRGkfV0TDOn1wqPthMDZ932RY7XJHM7WDLF7BGwoek3m9JOFkIjYMEh+o5?=
 =?us-ascii?Q?TNJSegznVZZZwqnrxmPa6hE7FGiTIc7COYvzGgnhHcpnPvxOUXC7Isygiwg8?=
 =?us-ascii?Q?y9DJltlnf1Z5qa+g8uxkrysAy8VEeWfwyUZ9Dg4udnpjlQe9PlW5TSNlJCM+?=
 =?us-ascii?Q?VfJj?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 13:41:50.1795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: eb448f5f-9467-458c-c841-08d8b6ffd06b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uRn7ShkO+U43yU+7G1IlT/rBFtxcfHmDwIniFU1IzG/PmYY5Prf0pql16ZxSebu/kzJ8LjcBrEBVUQLHWgMS7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6436
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define fwnode_phy_find_device() to iterate an mdiobus and find the
phy device of the provided phy fwnode. Additionally define
device_phy_find_device() to find phy device of provided device.

Define fwnode_get_phy_node() to get phy_node using named reference.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

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
index ce3987e4e615..46b9637dc27e 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1343,6 +1343,9 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
 struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
+struct phy_device *device_phy_find_device(struct device *dev);
+struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode);
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
@@ -1352,6 +1355,23 @@ struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
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

