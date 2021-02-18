Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED47831E5A8
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhBRFd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:33:29 -0500
Received: from mail-eopbgr70084.outbound.protection.outlook.com ([40.107.7.84]:51426
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230299AbhBRF3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 00:29:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFAVAa3PyHo4Yic0OCfQBR3R55v0UaKrm6EPdVp/vr3BfNpy3KioSklW7t3j45/juG15wg8EnkaeVduSLBAMhUaaqKhFO7pIz2eZc6Yzv59zzyFSVNXV9Eottd2++U718bgEYsKTFeO1Ea7TPFIxSN1Fj4tKytmHUwjWVRrvSlT2RumYnoiSAR85lDz8UvFQ8VTJzDet36FK7q9ASHb7bpTKcJ/5Ue4pDs/BImKbzEXS7gGKvlIpxlB/E26hW2AQ+1WgVpRl9IpMwUG4EwA3QYYVxG9KNGU8EfIvV9e7bna7hCtsmYibn6a3IXl2Wq0F/zzHblCoMQSwMEVtylKMfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YYxpulQDAtVrfpNEyGQJiXxHvsvjdW9NoYt+0KMipRE=;
 b=iY4Y6YGVSLacG0RE2ymt3RFvxqxySCBpL4cKDqUMUZIP7rq8rksOvz863glFp1ykc36N5vzfrTvJ7DqFd0SbDkYXd7ar0eb6mQaobouChLLQzqIomSFtI1YZrNZ03B7csFiVHZl+lTKbyJyVk/n8GhkZ4cJc/hqmrdA+YQxNKXPoNXiWf8jSJvf0prYJuE600zaDqAsTYuMQS52kpYXDX0BoXYOHVQkODizZGqsnCerrpf5YS5ezGNVQ+I7NVNJQapYEldXPLM1pMp4jwNVqHmY2PkAMBIInxIHwvETHzPhILAHfKWtyV07690qPgU1fKJLyyb49X3XxbZLNZnWCkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YYxpulQDAtVrfpNEyGQJiXxHvsvjdW9NoYt+0KMipRE=;
 b=YQT8Wp7YdA8va0F3MYYesiNR6IdUmQ7k7WaSZrryUUacTLgPe3/0LqLa0RkMo4RFh+x3yao9opzqotbdxuV4AT8TQ9ZGZxV04AcGiFhmA9PJZNrR1fhLLORRQSscpbgzCnPeQOd2/prsIAGzXtA7DtHTGqvCKVyP+rwCM/s3jdE=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7730.eurprd04.prod.outlook.com (2603:10a6:20b:242::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 05:28:15 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 05:28:15 +0000
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
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [net-next PATCH v6 07/15] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
Date:   Thu, 18 Feb 2021 10:56:46 +0530
Message-Id: <20210218052654.28995-8-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 05:28:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c38f586f-426f-44c8-223c-08d8d3cdfdbb
X-MS-TrafficTypeDiagnostic: AM8PR04MB7730:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB7730255B7D4FDD872779B26AD2859@AM8PR04MB7730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y4PyEboYNJ0pExzuORMpLEgh77coJ3wtpOU96HzJUb1BCT2ON3xGvc3xe8H5i9JTjYPRx5HDOjDSegENQ2FaHuZd5Y/N8vEYCPSF707I3fbI7jDPemRpib8d/jvgHSoUvYW4AYZUGrcBhCcLNJ2tA+FU5OJ3ah/U+gueJLBEBdVrrkU733ynfGcneWpIefbXpYkMu2xnbvb8iF4qA0dDobFb0zt9e0RPiHrfeLUKLiLOoQizTRmMz9Lu7HaMBgQXFVAj23dzMnxpBPPw5PhvOpHb+NHKlNah0ONGK8t6lhhBSOiqaTMvCTgmx2P16HefAQcXihRf98J7Y1d5t6fFJwg5W4fgAefP52gpOAr/RQ70pNaZKx5flY9/6S998bfce7tEpk42G47H36L/xwUYSaxlGXtLadA1wYxrGvep4j4tOmdlRmse7W/kKLO+3KL9eIyZZIicYO35gQL4mNIrKX6PYmYaPegGgyRdfFA28rk0A835lmVDSZkWStvKsYCe5sTx2AxWQyCf38vygvwAFiEI7uku0ONAqViv7WJcv9A0gmrBkovMXnqS1rczuvVrypgA4yWOMm1mARy0d2hYLRvrFtzyq98sESZa5q/TsX8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(26005)(8936002)(52116002)(16526019)(921005)(478600001)(1076003)(6486002)(8676002)(55236004)(83380400001)(5660300002)(186003)(44832011)(110136005)(6512007)(956004)(54906003)(316002)(66946007)(2906002)(2616005)(1006002)(66476007)(86362001)(7416002)(6506007)(6666004)(4326008)(66556008)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zRq1qyGMrZC5/co1J29qC7XIODc5i0ei/QrJA1lqMZ2gHOuKnuOLy8FMo7GP?=
 =?us-ascii?Q?VZpk0A3Y6YGyzK+Zh6hc2+kbScQ6PiecRBPqDFp7MX2BJS/WUOlE7EnZ7SaY?=
 =?us-ascii?Q?txlxVfbt73RV796MViganzFUO9JeH0lPPYuulGBLMZjRMM4XeiHkwHUiNxN+?=
 =?us-ascii?Q?Pnhi+tlNi4P04he/4nqU+R7b659gedQQC+97WlOVCcuQ6/FPgkR5LxGVadt7?=
 =?us-ascii?Q?Zj85Ur1ZXLVimjVTFogs51aDpughoJNort3pQzNarK9pVvUZSnxuOsHJrip3?=
 =?us-ascii?Q?4uy6nhZ6ESHQg4r5oKhQ5Jeqc1Gm0++Ecu0w3bAk6/8ApEQ3n0seX7dHvkeg?=
 =?us-ascii?Q?HtMYkFOKlh7LJIEu3efPOOyPdFS0IB17rtFeCEBKRkvuBCpcF9krkLss2HKf?=
 =?us-ascii?Q?3xXK8eT0JyQcq/lolyEw4g6bK2kw8ZTTKeE7QR7XZZCdGaH8dCXDiVVloEWy?=
 =?us-ascii?Q?gwT5oKobWDE8wkUjkoa/6vv6r4sJO6Ag/AxIy61Mv8dcMeAnVYI/AuEVN6/r?=
 =?us-ascii?Q?hltnAYwC/QFBWma+tITFoxOPiolttanudkapERRyxKYgCbeEMjM9r14DjzDi?=
 =?us-ascii?Q?xoAkBC4m7qja02VCONviCq2nclh+SYg05cRMLLtyvJ5FHrAL0fAdBZwqn4EA?=
 =?us-ascii?Q?ArdthMVBF2aYNJQ4qgxrnBWwoXuPHJ3TVLfh3h5ULNKgFGgbk9vzTWFYr0Xa?=
 =?us-ascii?Q?pzV7tGRM72ht0llD8CM7/lOmw9zNaKp3qgXaJwwHEgNny2KWK2ujDfOjc6r4?=
 =?us-ascii?Q?+UgmIHDsxD9OLpnt9w0Ao5eWwkmvlwXhc3p0m8XyrHwzGlgAFdeEBjVK69JZ?=
 =?us-ascii?Q?x89d/T3kO0QxXuxz1bT6mQyDeJzJq/vKWJr38nHAHzR/vSykEdEq1wEjMgq5?=
 =?us-ascii?Q?3o7MitKwgm4wMiiGFiw9IJJLxLlALibfKW/BkbOXNmk4MmEipIqlSgkxznLr?=
 =?us-ascii?Q?8daKURVOF7y29GHIF0wuMMGCGgghjJJN7Azd1EULq8XDvg36CDTK42n7bgFf?=
 =?us-ascii?Q?5IHw3GTfOpR5fEpD+Qu5S/GcqdBzzhgMc0CGW2Cq0hlW/rqqtrAXTKyGS8m2?=
 =?us-ascii?Q?IpueQDHJUOQChblw4kLYhAvBsP8Qg8I57GEMM/yT2rRoHPV1TSd4EX5dw69z?=
 =?us-ascii?Q?NfBCwc9SVZBYFSXHaGt/E9C62ff6Wkda7UrF0zKbcblG4sMOdJai6O6zwyBv?=
 =?us-ascii?Q?OM5qokrH9Wti7jZ3QUe9M7nzoQnLzOQCnAxHpNyabCt7wSVGxR+SDGzHxg7r?=
 =?us-ascii?Q?abcdO44SJbYhJjP38O7fFPpdYobpUOJFwVGEkUgiLYYeUu26yq8lgpl58Pbi?=
 =?us-ascii?Q?++F9XbsTexdRr5JiR9vqDg2D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c38f586f-426f-44c8-223c-08d8d3cdfdbb
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 05:28:15.3610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vnzG6WOshAUuEX/kriZMIZluG2b/no8FtGMb5LJkV/wrEcmcEr0lFC1QizdPHBv2fxqnPmj41RiJRt9zIHbwlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7730
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce fwnode_mdiobus_register_phy() to register PHYs on the
mdiobus. From the compatible string, identify whether the PHY is
c45 and based on this create a PHY device instance which is
registered on the mdiobus.

uninitialized symbol 'mii_ts'
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v6:
- Initialize mii_ts to NULL

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c |  3 +-
 drivers/net/phy/mdio_bus.c | 65 ++++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h       |  2 ++
 include/linux/of_mdio.h    |  6 +++-
 4 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 612a37970f14..d3f7f104f1ed 100644
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
index 823518554079..6158ea6e350b 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -8,6 +8,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/acpi.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
@@ -106,6 +107,70 @@ int mdiobus_unregister_device(struct mdio_device *mdiodev)
 }
 EXPORT_SYMBOL(mdiobus_unregister_device);
 
+int fwnode_mdiobus_register_phy(struct mii_bus *bus,
+				struct fwnode_handle *child, u32 addr)
+{
+	struct mii_timestamper *mii_ts = NULL;
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
+		if (mii_ts)
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
+	} else if (is_of_node(child)) {
+		rc = of_mdiobus_phy_device_register(bus, phy, to_of_node(child), addr);
+		if (rc) {
+			if (mii_ts)
+				unregister_mii_timestamper(mii_ts);
+			phy_device_free(phy);
+			return rc;
+		}
+	}
+
+	/* phy->mii_ts may already be defined by the PHY driver. A
+	 * mii_timestamper probed via the device tree will still have
+	 * precedence.
+	 */
+	if (mii_ts)
+		phy->mii_ts = mii_ts;
+	return 0;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
+
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
 {
 	struct mdio_device *mdiodev = bus->mdio_map[addr];
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index ffb787d5ebde..7f4215c069fe 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -381,6 +381,8 @@ int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
 bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr);
+int fwnode_mdiobus_register_phy(struct mii_bus *bus,
+				      struct fwnode_handle *child, u32 addr);
 
 /**
  * mdio_module_driver() - Helper macro for registering mdio drivers
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index 2b05e7f7c238..e4ee6c4d9431 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -31,6 +31,7 @@ struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np);
 int of_phy_register_fixed_link(struct device_node *np);
 void of_phy_deregister_fixed_link(struct device_node *np);
 bool of_phy_is_fixed_link(struct device_node *np);
+struct mii_timestamper *of_find_mii_timestamper(struct device_node *np);
 int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
 				   struct device_node *child, u32 addr);
 
@@ -118,7 +119,10 @@ static inline bool of_phy_is_fixed_link(struct device_node *np)
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

