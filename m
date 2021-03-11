Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B09336C0E
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhCKGVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:21:41 -0500
Received: from mail-eopbgr70083.outbound.protection.outlook.com ([40.107.7.83]:51643
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230263AbhCKGVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 01:21:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQqqjhju7fKa9s+p7pHULV2ZcEuXVRtUMJ/DU52hv/S8vnyBOUtSGGPmQeHAzvhr6LD4t0SeaUkPZZnYodVkL0/hKbtsTh+ukI5/NuSIU22YxAwZVxuSVebE1HBI4BzpE2kFEWq4rucil4Fzn3ndewK4hThuKTxkKwoKZIWtv+nDKnH8CIq72gRWfsg620ToOG/2V2vkIMhCOK1XIAMdtE5DfEe2PEisKpLjN/RnmwGCMzOyM5/WMHGYGjIeLuYGzAahXYeQ2aFeG8eLsOWLrhEg+lxbXNi/CkQIT6D0x8zdz905Rd1FLHsv/IzLPujTdldng0XwYwIlrnoYsBwFQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mA9n+CzKw760mthl8WNU1R68T0UjsjxA9RAup/kG3oA=;
 b=dhMPNEo+3JsGML04p1gD0kr+qZiJQ6+gHJIW4rmxm2g7GMyaPT5eWx41tKpVIZYfk+tAGBkbbPjWYydk0XHy+B2m4YuJZUmSsq4/LWivnQdqZTd8xiKL/sLCfl1U1vke6KHedhJWZhzNwmf8jgj8RhB1Z5CVdDJlDMKuNiqMBPMBxMwucEiwB/7NkyfXgblUUF/2lDGZN1aYM4cysNxi9/51ityYf/XuvhLHdoN84S2K/UBvwCubshm2mHA4ocZ09IX537GGVzF91nAVioPWiy642JF5ydkshlKBRkvfR8ygszK3e9oKrjhEj3RJhD/nPk39oDF0lBEyCvnKbsrG4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mA9n+CzKw760mthl8WNU1R68T0UjsjxA9RAup/kG3oA=;
 b=ajtF3AfERgli5ZT2zcRHRFo7IfQEUILqRz1+oHLWw6zePht3H0ycptJLhdiZWzDSMy57wCupfEeMCxcPBaIUdJt16NvoEDXgtqf4gUZwNLxwlnA7JPYmZD6KwaX2HS3tTMEcBezMGqSgxdi/TFNuOkJoz5c8/+Rkkq5g8lDvg/A=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5473.eurprd04.prod.outlook.com (2603:10a6:208:112::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26; Thu, 11 Mar
 2021 06:21:10 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 06:21:10 +0000
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
Cc:     linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v7 03/16] net: phy: Introduce phy related fwnode functions
Date:   Thu, 11 Mar 2021 11:49:58 +0530
Message-Id: <20210311062011.8054-4-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HKAPR03CA0026.apcprd03.prod.outlook.com
 (2603:1096:203:c9::13) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 06:21:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 68579370-079b-4f20-0954-08d8e455dc8c
X-MS-TrafficTypeDiagnostic: AM0PR04MB5473:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB547314A48EF6C300204D14F7D2909@AM0PR04MB5473.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KusriLlBx09LknlqRkefMSzLNTqiFdsFCahkdpC1RT9sF/Jb4GVliZsgFlKjM5kXXxvB0pCbcu6uhPfzRDeDQZ+/2jHpa9Q2c+OFX2psdn4PjbM3Xaj2K1pKxoKOKsikHWRJOSROoShCfW2HPD4/oqFZ19ORvh/SD2X+yLZYnPeZYK1/VcjvQtN31vHWFb3wi+ld0U84WtiQ0t5+hgOBl8nsxcWUG67o7yC+/z+CEhX6MVZyMHX0q8FUWvb8mpbff46tbu0k2ymxh7m9x3Q//Fa2GMC7jECDruiPZMLpCwtg31VW23uwn/1okNJM0qVoaVZwUqqW9GfRjwdzhW96P/tuasczhMsm5bxG6XsV0sKhZ7tyKxZ9jRlFiCqBoX+F3WOfVDP3jrEmgxdJ2fK7pXDmTrb7G92GNkqSNYjBCBmbaAwlUwcZNnHBKOd3rY9Kdh3/5UhMgjbywZ4r7yAIC5lveDk8I0AbdMzrEGHUo2A5etMbstXSMspYG2tWX3lsMKYJfGU8a1JiHlhAAFQt+yfRPlQXbZ1l2tmo6/1roz0pAQ/kHAsFYhwd/s4SU8WjccjcA726GZqrMy3+LT0QSGopYVevEXyH1hlInxMA70o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(44832011)(186003)(54906003)(66476007)(52116002)(5660300002)(110136005)(1076003)(66946007)(2906002)(316002)(16526019)(6666004)(6486002)(921005)(4326008)(478600001)(83380400001)(6506007)(26005)(2616005)(6512007)(8936002)(7416002)(55236004)(1006002)(8676002)(86362001)(66556008)(956004)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6slTvZb6krx/5RrFzdiiPnkwGXLieDRoUZuLUYRciKp5PiOKAKPAvgZdph2q?=
 =?us-ascii?Q?tMG8NmF2Q5JxW+5Ry1jf8gnB3HbdopiZmUwGdGtQ6BRO8rpBBGEZVf+tHWon?=
 =?us-ascii?Q?kQ8uqQq47Vcd1gxm3ufqKftX34NAW8tdHESL3amzO1MLppQG9G4SCHnUgTOP?=
 =?us-ascii?Q?U3x/qbLTqmkVFGmFp/QtyXcrlpm3lctBk5XcUb04GjeJJQ8iRTu6lvMUGXYG?=
 =?us-ascii?Q?tCPGPzKweK58POUo+U/RPtKvh3jgOp0nNRJ3xz10rr5L6juo64muCq7ntKS7?=
 =?us-ascii?Q?AdgMbQTjZY+tz78jgC50h2muNBLDvW2tPLxv2bli8kTvCzI9mJI6zFYlY0qJ?=
 =?us-ascii?Q?WQe2A1dS6YS4RDuT3nt6b8nmOqzBbAVxOVN4KnzjJK6gV0GiTVzkLqyd0evb?=
 =?us-ascii?Q?yTTn84JJvcHw5iKx3uVIYJOdQWTHn7LFI1VJwACNL94n5N1ZayRPP60pC0bd?=
 =?us-ascii?Q?pvtD3GTKrdop8XfHS7N/KVNeDJXXDoxETbo4Jsr9NQIqgTUWg+PzcorYrqjx?=
 =?us-ascii?Q?N1Dv5ziHwROprxXCiLnvIhJg8AZ4/dorkH33jvp/cky3lpeKq5F1KHGvRjYZ?=
 =?us-ascii?Q?d7dyanmG6Z9HnEHgqihAPb0GgsrTYtDZwzLN9uhAatizGVyA/PQH1CaxnRWS?=
 =?us-ascii?Q?IWrDffy8ELHmRp7WfxoggJtdk/qVMAiio3TN8MXzzdmvMu57MyhB4YV3nUkJ?=
 =?us-ascii?Q?dKXtZEl9Z8JFNWvtsnkM2LX/FLo4vpMHd8kZB6jHMoNAi+8aiBvO6ZgRSczB?=
 =?us-ascii?Q?/JBG8BaTp88MeJYYDH5AREwshdva3Y3PYwpwhvqwLDD2znIMtGcENYPp8H0J?=
 =?us-ascii?Q?DDrIhp4oZP7aDftwHxujGq9aleag3ckPz/RP2yvviQuVhR4970tcd/MqOsnt?=
 =?us-ascii?Q?7FslSh8FCsurNI6Fw6577cfvkEospdRVy4GrS0HoM75/tbRZ/7hMc/L8fDuq?=
 =?us-ascii?Q?9do+Jl7hOHWnNkVpILeSDiH30aIC5pKor1gOz0+718bCej1PwD7ojKql8fNS?=
 =?us-ascii?Q?TMGPAl7ACA+RbiersL9V/2KlQHxAVClrDb2zcBXLRCjdIQ4m/vp2hI5k/NEV?=
 =?us-ascii?Q?xpc2qlTQeL/z2f7RwxuNLDKVyh/11jLIS3SMNxsXje/06e7YoWPk3LYJ64DG?=
 =?us-ascii?Q?kmgdpUDMoXfUvhauNkorjL2JlYRBpA03zcPwBdhFCCoeqZ4JunUVfbFvo5//?=
 =?us-ascii?Q?ZGzrDCQLfU80wyyMDfGu9y2O7m6mS+yVokAgafD7fbcE7SF9LvpWjjTuZRhL?=
 =?us-ascii?Q?lHx0Sjl5q+wZLrhu3ZWlpNyrXBJyJkbDV4dng8quub0sh5ajFlZVi+z5KULS?=
 =?us-ascii?Q?gBZlRr4IFTTcTbj0Ej4gN3IN?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68579370-079b-4f20-0954-08d8e455dc8c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 06:21:09.9231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zl9HWstuk+OKCkViod3XtmZsQieqBojqwxM5VKQSTYUNaXKbfVQPm5eLWndDNYy6xGEynrZgquHPuCq8lXuyqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5473
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define fwnode_phy_find_device() to iterate an mdiobus and find the
phy device of the provided phy fwnode. Additionally define
device_phy_find_device() to find phy device of provided device.

Define fwnode_get_phy_node() to get phy_node using named reference.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v7: None
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
index daabb17bba00..aec8dadf5d8b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -9,6 +9,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/acpi.h>
 #include <linux/bitmap.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -2842,6 +2843,67 @@ struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
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

