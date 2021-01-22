Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6330D300B1E
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbhAVSWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:22:46 -0500
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:16040
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729171AbhAVPqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:46:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aF0HO/T+/KguzoVbfn8uBxcqVkQY+edFadAIe4KXpqkdsBKvWnuqiEgu86PLDbrQYBn2j4j7nvU35IX+c3zpWNYe8MwPbUlx+eJx2knudy5IVm2qQaaNY5pOTeVZcd8goxH1RkrLd75zOLSDjSQwV1/f0wRTrf3SGwvNZus7HUKdqVrU7XgnoCokKT/KIodvB8EuNDx1nS51f4DGhx6FTdhy+eSbdt9mJFzGMswOtwjobPpx81TOyeGSuUSHuExH+yJBaZdw0Qq3T7OLMVGVNk6QOlP86SbO9ZWnKJ5s18fvhuUrYVcrhpS46WUFwgg8MfAQc+4jKpaGN/uoatB99Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aW6r0cI8jRG/e0VimEQv7mMN1od2J255b/xafb/Bfy0=;
 b=CiW3epCBz8Bkv7ycpiHhnNgyC3eFtt1yVAODflFyI/ENTIHTcVerH08FFz2X/VXcmQHNL7xnQ+VLIZtC+YRjlhKXtT0IOCmJWccqvCFugBNKakh76Y7a6Q9LDim9UpbSfgSWtZPTpYaBbcQtDystbEf+/YZRnuqhRwZtlUM3C3DfvvWJtZxUHID1oeitG1hd08qPrFePoGcvLJVnm+Pmt8kOzscj2QJv85xb5ypqysODGggcgNeaXuyR73ahnGbjwZCcGmkMkn4/WBPmoY/s6DDFJ/91f3PkjN/80hEEjdFQur0WAscXImbVl03DpxZmsvCOI9Ly0XYNwiJ5vCKmrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aW6r0cI8jRG/e0VimEQv7mMN1od2J255b/xafb/Bfy0=;
 b=lDMdWo7S3xXpgmOayfcVZ4tFJMuKM6tF25yZQj8+BfuWQk15SVTdXEFdZ5VftyQ0OFwHCUu0jpvnF9+i8yDd+nR4oERg+3kaU5+SSjMRTj5cyg3m791UfZHa2srlEAgcfbvPvCxxbIcL6xHahwskNki8aPBWnaMHd6nSXpAOyJ8=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 15:44:33 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 15:44:33 +0000
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
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [net-next PATCH v4 07/15] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
Date:   Fri, 22 Jan 2021 21:12:52 +0530
Message-Id: <20210122154300.7628-8-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0117.apcprd06.prod.outlook.com (2603:1096:1:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 15:44:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f9b65e87-3b05-4fd0-d926-08d8beec9d1d
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB344343D8250B2BAB313BD22DD2A00@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EAR6VcB6ExOa1VUq7FZm3eOCsWJfS5nxjjJJpu2pHEhUlsHIehS6dDse1TPgHVOFDK7VjULI9gDteTXoMRpL7tGVe8JRV8IzPnWT0iiXPBWwfazdoMspsn2vB0wWapDyrPHfu+XeGfb+59eMvs5qnP4SUZixItRYzeGS31p07Q33VYF9inbDsAYiN4R1nbpOUbKNRCJOQ3Km7nEx78tTwilH5IQTYTU7nFcZd/gPtQv2Qw5qzSNHiUFNejRIbkn02Dq1BEA6Cf/flhXtLAwm0A7sHJznVJp50IP6D+SuBm04tuEux3lch9GRUL9WzBwSFboWsDOgLOjuHY1d5LzEdDPK1bN7sI0pm1WR9DyunRH1tv+fMkVz57pWDCUrqvJ1QtNe/MfWPOAo0jHFWPpt+P3PSRjKfcZ+skz/aAxn0etX+5VmN5ytPnY3Br/ToxOTloe4paSWXHVKnOdKuCcBQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(2906002)(6506007)(921005)(6512007)(6666004)(186003)(5660300002)(1006002)(16526019)(52116002)(54906003)(956004)(55236004)(8676002)(66556008)(8936002)(83380400001)(66476007)(2616005)(66946007)(1076003)(478600001)(26005)(110136005)(86362001)(316002)(7416002)(4326008)(6486002)(44832011)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qLQcL3iyOyd2MPeMOzSxJQtNEAXBrdPbvPreNrQ0LH1Rz+Pt9zrstIaBG+j0?=
 =?us-ascii?Q?X6C7VYqszikGs5Xm5D07XQY2bk37raS7Mkf1WPFrD+09hfbVFTafFI/9zL22?=
 =?us-ascii?Q?61KewBmDvS+e0Jl/r+3REBcLxuh3xrdAYTqahkJpx/VNas+jjemqfHI+SfK4?=
 =?us-ascii?Q?7lk9pFTCKNQ50eMYxjrDnrtkwTrPsJ7J//A0hj4UoWEsnLJEAwe9/haOWjGZ?=
 =?us-ascii?Q?qpdC2yqADiwYcjgBFJV2b+Fg67w/lJfkole6gmZTgUr3bKIL44B0SmfHhuYD?=
 =?us-ascii?Q?cBjAyjnh+ZwQssjf8USGJyRjFSqWBjOCbpzjOSNjicz2YGCaYLRyKg7t3Nbb?=
 =?us-ascii?Q?6w4YTALuH0MA1c6AC4OgCXOcKfMr9F7K1sWX/O6DNZvWq3jTQOFdykVz7p46?=
 =?us-ascii?Q?Ojmh9fGnfPCb8mKXuw3mO+qzF+e0a8QDlStxhWxL/8qxFTqacesq69us6zSt?=
 =?us-ascii?Q?OkQ7CB48XH1D2dZ/vC3bSJknKTc2pn3oinUQEGu25l5gCgT+iLKGKs20DM37?=
 =?us-ascii?Q?VuTRmx6Xmuy5l44lFSIau6/0F8Ozq26E70sanezebznSJJbon9imCd7f3uUb?=
 =?us-ascii?Q?OQojCHV4I2VD+K+5KvBv+lufZG9nK/pSiMU65/P1VgkB0f3wl066eEHGHOR7?=
 =?us-ascii?Q?Hry39muE1NJ5AHXleDAOnyAUuLSdcs9bYpuhzW9VN1WnUDSsFrqAUKVGBP95?=
 =?us-ascii?Q?rXPd5MBxMtI6wEYtB3UMsXSOEwpmPc0elZcT9WCRX1PfZAlBnydvMSOSxAeA?=
 =?us-ascii?Q?rjJsZVfMvNQd15Oh3Jowp1JFy1jQ7H9no4X3h0lkXcUCIlG2j1gl85VaLVGO?=
 =?us-ascii?Q?MyJAAAmh8rOd4VUMRF56jvE1jEu0HIqKlCgaorIWlJbIjUWrKyMSkFT9U5tP?=
 =?us-ascii?Q?0viCEWciDsaB9mSf8m6a548VW5K8CEyCoDRmRUP1aERr8/xzVmRELgcEw83V?=
 =?us-ascii?Q?izWYQXydn2JknFFHsKfyiTtfMv8d1L4Z/lQBFmeJGXTMgaFQLWX2iVuhtEPH?=
 =?us-ascii?Q?aoL7VECdar4Bj8zqiRZ8NAMcMY/4/oZSOcWwqkNPi30oVaPhudOCkZdBRRoB?=
 =?us-ascii?Q?d63Df/lZ?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b65e87-3b05-4fd0-d926-08d8beec9d1d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 15:44:33.4221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OWfe4OZk5RSwOdcn+0+v12lhuGSH+L9XkI5KgMUVenD1cR61dpIimtbNRr+Bd55S3OlFbhKeoxeZq/BwwUE4mQ==
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

Changes in v4: None
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

