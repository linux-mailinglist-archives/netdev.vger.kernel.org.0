Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C60A31372A
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbhBHPVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:21:08 -0500
Received: from mail-am6eur05on2060.outbound.protection.outlook.com ([40.107.22.60]:44416
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229565AbhBHPQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 10:16:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=huCRt6RRNW96v3gl4gvsLxnvKfEinuMKAUU6EkIuN3jP1NbVO1ELDceD8yPeiKUYNvZCI60b9UvLQP0uEADemcjiHtYulHPeRoGOwfGxWKM1zFQgIMubqbOM14Bzr7vPwtsm2PTdUpkan6aXXWG3/vOagDu8NnGshFCRlaCSQoLGKE64Lq9qU+y+lBjrCmagaq4vf0WxB2A/ClY/rxbIpF5mKHsgiK3THskmUHsYNWpuV7XJAbFwjdhlQx4VEs8Lc/yORflKg6hvWPaSYzd6QwjV+zVKW21QeTd5L+/hhl/678G1Lf1wTYogTvJ3u+QPLe3flfi5fuEKipobhc7XhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRvgSQHKAJvU9aFJfRrrx4h4veKkWYBtZnfpXrLrwQ8=;
 b=CYugh7Kq/wrLhmURdOFZx3p0QQdXBSN4nZOpBevXteD5gqHxcnmMhnDa1aDkoAQDN1Stnrun+2rYkig+73KBFOSP7kuaSzQhuwgMbn2XvwzVz5g2Q7ujaxy9B8D+ovyuz7321GckbRoOL69ADrz1DObIbDTJAa/fSZumTxPxgfRc6PQKx/xO2cF5CVX1GeEBZgqTVCGMBmyKgrHikVEkI4BZFOHbdTvV8gi13ccbBTHV9tYx3S+sQgWY4yTAP4SHVauYE3Eh55W6eaX+IcMyqF91z6zBZj7HLcTuTcL+R4d+NAzrDBmApewF0UZjlc73dDSng7Ae5DfXNHCOReGhaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRvgSQHKAJvU9aFJfRrrx4h4veKkWYBtZnfpXrLrwQ8=;
 b=HSuOAWKQjnbJoV8G474zTb5ZLHykgJcjPVHAruDCO80zmkOoQ7hph6Azf0m07bH/T4jOi/TL8yQagQnhi/bqniw6oLOGnSewKcrGPeKt53w/TtGqs69VbYEnC1ovzjU0znmou173riJrb4+8EmoF6P6ZwPZgGLhpsU2f136DBj8=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6435.eurprd04.prod.outlook.com (2603:10a6:208:176::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Mon, 8 Feb
 2021 15:13:38 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:13:38 +0000
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
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v5 03/15] net: phy: Introduce phy related fwnode functions
Date:   Mon,  8 Feb 2021 20:42:32 +0530
Message-Id: <20210208151244.16338-4-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0176.apcprd04.prod.outlook.com
 (2603:1096:4:14::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0176.apcprd04.prod.outlook.com (2603:1096:4:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 15:13:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 598d6afb-5e6c-4712-5cb7-08d8cc441c90
X-MS-TrafficTypeDiagnostic: AM0PR04MB6435:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6435746AF1F9A4E43179AA1DD28F9@AM0PR04MB6435.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dz/Zh7fZSvwdZCF9ReltYRrT+yuHj5P63wenw63BqmENPiwTHEpxxbvgSf6dSgghYY6xEWbpacBZSuYJs48ltuN8rg+2BSu/Hexqrlfn7ePdm80iYEMpmrMaZLwr++yaiB6ouGxmAEKiTtK8bSqTs62/aNKoqZhjgR+BEzoadUuxwfLOyE4ffuhXtKp8rIKF7Ka8SKwW0tRM6D4Z6aKpTx0Ez6zk4IzhDj4U46vr2LEqbZVEWlUnbeY2gBuUPmY5UoBOPjE9j0BPunnzwDsAdGRvrCgAcHCSZnNbki+cRfBuaHaMv/NR7ip4YXlkkJWoM9WQajOMsDwnu6Z/3oWO1YupIpNSxBfg/YNMlU8qE6csrr95UjG9yhEOmRUc0qtDXn13xcDvnhZTJDQtwZWBr2830BaW7aotUtUWe5BCkHSvHsLayZQG9lx1fLxakZhKq8uuBDzZQiZbXALbPoAUTp9YnqphmZH3h6He9WJdNnmX9f5ZoGL8QRdJ1nW++WJLhLrdDxdW9yfWCv5Cfi2vvjLG2gOCQeWXVm3ltbjOr0A2p48BF+BRuLUzUG8vbhtoeGyWN4JRGQkjHBZUXnwmaH8PM97p1MnPfqglLtQeCkg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(8936002)(54906003)(7416002)(52116002)(110136005)(186003)(16526019)(316002)(55236004)(956004)(6486002)(1006002)(4326008)(2906002)(478600001)(6512007)(1076003)(6506007)(5660300002)(921005)(44832011)(83380400001)(86362001)(66556008)(26005)(2616005)(66476007)(66946007)(8676002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?x7AvCnidtJZTOTrk7hv7xr8aFJOO3x5K08yAYdk62m3SfOzhNOP/TUPrU9dO?=
 =?us-ascii?Q?/pLlZ7kXJVTj7CHHGkgNCH6CPe6AdsOgK77tRyjWWZn5cYbcK7jOKaI0gkVX?=
 =?us-ascii?Q?TF6fMIyRKvI9O3iOve69n1wF15AllTZvKpqqPM03QQ1gY+b3aWKIxDxWNHpl?=
 =?us-ascii?Q?tTiy7JYpmnBtxHQ/tPhNA4Brk6u50A+PEfTvLjIO56WSuRT5Q//IQgIBpxUW?=
 =?us-ascii?Q?cNvx00SjVW3/iWG5psWdpZ6pQCujYYk2gS+8jH5IqH/H7a8VLLvdr3jFgCKD?=
 =?us-ascii?Q?AKBs3d3mH5D1GmYR6cHTbW904h+QQlFr+RAZK93lcKClqbjAEn17hSt+VC4f?=
 =?us-ascii?Q?VvzVO6+5JEqymyW8A8eUD9XX+usk9nPFh67Na3s/oT1dQjLSfIWzCWtqJSSn?=
 =?us-ascii?Q?r51kF73MxFK4gKtnC4bzq9uYplQWMucr0543UTcmQSI+tglbNlHJ24dvyNP9?=
 =?us-ascii?Q?FVteStMdtfJ8rclfL0eWG9IxUJjAwkSBSPSfOJgjCBSPG5sD5Wgj/9ohON82?=
 =?us-ascii?Q?+h80h1y1q2LdWaI5xuccB2QfIH5v7/WTOUd+BqNV+NibPltgCXd1UBXufrzV?=
 =?us-ascii?Q?egxAD5av6UJV+FE5Cn1csNxjWRAxK+Ro82VrvMZBoTipbBiO7AbjJQD9F0y4?=
 =?us-ascii?Q?hAf3yAp0wr4JSCkGM0Ms13uxFXxSUdzirpLImPJrk6gRosY0POKiuOvj+Hnb?=
 =?us-ascii?Q?B0WimUy/FdEQTUM1WXmY8KyICq3rfd3D0iPcIBSqnnJvgc5AWuhbcGafV3E+?=
 =?us-ascii?Q?jWzzEl/yovygTw4xVIL2iGrCILk7cFwcy0mYOoTzFR+D41yxtel1E3Li1s9+?=
 =?us-ascii?Q?loHTNWTnM0vwP347amOHEimlFi4NcnGeTdE9koSmHWwZ+QakE/F0nVKSEjM3?=
 =?us-ascii?Q?YkbKM0+W/do/ZcqQGRT3dsOwf9J5mORtxx003BM/0OFQC8VHpfDYW0PH2xSg?=
 =?us-ascii?Q?mj3va9253nhVEOHt7rl0bIYuxqcgtqacCcP5tr+EUfdoC7dSQjKLWmtBPzlR?=
 =?us-ascii?Q?TDOz7+oU+FKYN71ua3DCwhCBcjhbwsFUCoRi0UEsR3FRwMLfoEU4ohvcHm/4?=
 =?us-ascii?Q?DMjEF7n+Jc6wCyMQour1WtneE6bzotvuawgCQ8uZMzrvHDAQwQPBZnyWPTjy?=
 =?us-ascii?Q?F7Aw45bUo0F8l9KiDB78o0rzwcgvDIkwz66m9kFPDmgAOhv6FND6YRy/Nxor?=
 =?us-ascii?Q?VthxrraJy29iSAAeh8cAxzlFJpgbQc/bZuxk3sykPT90/dfz5DhW66Q6JpkK?=
 =?us-ascii?Q?9++uOSSlyx5yCd+6E4Lde1u2hca1entTHIe5ddAT7TdvPl73x3oepg8tsIL0?=
 =?us-ascii?Q?lAoyRMUhrJFa+aLl9R1EDg8d3YWnoO3PVr9nwpOpZs3WJw=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 598d6afb-5e6c-4712-5cb7-08d8cc441c90
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:13:38.3989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T3EyRO8O3PVZdLsshk2f1PoOd5v6XfqYOVRfeJp5GFrotO5AgrnDnaAOrV8dUFxZlW6bw6XUFv560tufP2J1/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define fwnode_phy_find_device() to iterate an mdiobus and find the
phy device of the provided phy fwnode. Additionally define
device_phy_find_device() to find phy device of provided device.

Define fwnode_get_phy_node() to get phy_node using named reference.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

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

