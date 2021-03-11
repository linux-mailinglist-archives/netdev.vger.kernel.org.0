Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57AF336C27
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhCKGWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:22:16 -0500
Received: from mail-eopbgr20056.outbound.protection.outlook.com ([40.107.2.56]:8480
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231332AbhCKGV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 01:21:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nR4FCE8hqKtm4mvO+vXAywoS8yxrMA6bVblDnhegRVtZ3ZuaBL+1/QL4k2wCb/YZxD4wXULb9J4Wrj19D4AVca0LNfCUqm3nwohfK/Z1EyODGJj3Xg7SPViM026Foeog41dO6Yqd5kK0qCloPV+/hDIKAFS40wXBvFMC6fVo1xxCKYMdqtBQuVHlG4WtvWDKB9cFGnNm1lQ3ksBGtWoEc/9wg7/xuk2i/GRpSJ8SZHhZka1mz11Dx/YhU3+ATIPmWMyTlfgBQO9RWTPPZnuq2csApUaluuii/hZq6Vu3gHIz/pTlLlQtj95IArXJ6RVusosAfanSdlUhbj1ENZj7zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHgD1m43jOEfkZjcvOtBymrbTr+Wedda505cNjBA9y0=;
 b=F/jywN9SFdwZzgS3FHkSXL+EKCVcwc4aC7t9g3iYS6jnSiISuNwUWQ0Xfu4y5BXaoGfTtUU8SB8kQ34bleW/4Ph2dxQjg6o+KM7t7bvmQ17Zy0hJUMzVJpCmHG9PHV7XMxG+S03as1bhmaFAHRp7zybTgHRXRLcAPYBwz+8sx5N68WAwWqkPfNDztH1KlTLi/2PmfgzjoXO70m3X+aPxCBAVHAMaBrPORCHfJXzBhDmuEVGGybW9ij1pXatqWPtc8utohHzHgA9eHO3/JSYvaqPfjnaC7Dkh7FjZ/enIkyyDXkj4maGB6Mt9D3g9Op5bb0o+q+DyA4YDlwb3aeZJag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHgD1m43jOEfkZjcvOtBymrbTr+Wedda505cNjBA9y0=;
 b=HQrYYVhZYU4fqPDwR/EjpGViMgWarwoFoiwdEaEl1meiLbMHEOVDGhfBK3vJhBVRLRfXJH68RNM6HvhX5S1XcF1e173BOsxbqUuGy3OA+Xv86/S+tuF7E8fOrErsJPJ56xXsY1ofgsnn8Ec7E788EA6nWSAlCTjlGrWN99nEuDc=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6611.eurprd04.prod.outlook.com (2603:10a6:208:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 06:21:56 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 06:21:56 +0000
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
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [net-next PATCH v7 08/16] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
Date:   Thu, 11 Mar 2021 11:50:03 +0530
Message-Id: <20210311062011.8054-9-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 06:21:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 94a2f53b-81b3-42af-0fe1-08d8e455f7d0
X-MS-TrafficTypeDiagnostic: AM0PR04MB6611:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6611F1948AC6AAF74A74F0F9D2909@AM0PR04MB6611.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NbCm5wlsuA/IESLj4Eldm2denT02hyCJyk9vhOeNF/TVEWi0555We7iTk3q+K+1ADLg717/9ZjMyqRb9tuwm8/4u6tW/DPD8mign0OWX2I07BkEB+6D3zp+LF7wucDhmAAzAZ3btF62DEY+4aZGP1HyGQ0FtE2m+0iHRvg/ObJ9YswTgM8TNJxQjtzmiSEZIdSsPUup0kPa+KyxocicBdmsDhcm6xrkFZLAnbHDJyBNqQddEPlm5tLYqz1Zh4fdj3aswTY2WsbA8q5/WArw2CFR03gOsBkoeO97LNYwemKrtFhqlqtT2B65R++BhoBzlG+csxoxLoMy9YFC+AcN1uIREc3DK2SRXzUytx9aUJ85WhK0e6dDPRCrsEwDuDR3sJ8sQOGk3M0EWpfMocdXCWMeWgNFFfTvnBBlp26zoMPzDr/DhGQd3YOxtL+//XUAiNwrfRRUbgOuoIx8/hPU0curQabWk6e6kQUm+DQuyF4JSX17SCoHVWx0aPBJkYlxcvFG4Ylv3GTXDR9WCltrNrOfvKZcVLVf6C6vO6r1CkhVJyTGSdHXfUIwzuJR9qZ3ot78N4sdKYk3PaPh+WmbOA3rUKiWR4DhrdAP5lwhikkM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(2906002)(921005)(16526019)(26005)(186003)(83380400001)(6486002)(8936002)(6506007)(66556008)(66946007)(55236004)(66476007)(44832011)(478600001)(6512007)(2616005)(316002)(54906003)(5660300002)(956004)(1006002)(52116002)(8676002)(6666004)(110136005)(86362001)(4326008)(7416002)(1076003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ig1F2BW9mcGoAGevIxcKIWdT9ZUjiwdyBgMF7d0+fw9zxM9Q4ZYeWmGn9H/i?=
 =?us-ascii?Q?Ve10jrfUcwt1dnWwTdwibWLMFhiasvDJrcMa7SWGgkBOHcRQZ55l0IS0lGGN?=
 =?us-ascii?Q?UgBq9TVivSnK3Dj7xBkL8d3e7Bf9AI+i/W1KFDvDc53hYXBpPexVgxbjpXty?=
 =?us-ascii?Q?XzVnE0JH6TIiKIGNgHdus1T4BjVGhLS3mA8WOFc1MFmWi/X2N0taeGvP+xZx?=
 =?us-ascii?Q?yC2K6Dy4MhCirHNMygyi08ov5GWk23xAuoo3MwEIi59UeLWXWAFLW1jPrzRK?=
 =?us-ascii?Q?ttWVmwjDwvEcKTWAE1HvS0ZLjNaxW5HmC5piNuHbJ6C6sQTaPds7lMdbWOWC?=
 =?us-ascii?Q?0RzVHVuq2YikEjdVQiWTtt0p2vFah7wR1To5Ece+LzE7giCzYXpEvbtYBqCa?=
 =?us-ascii?Q?oYms7Grr5CHZtJFDBbA32qp01MPlJeFAvrsah5q7kWi+xef+1ddGESqnLrhO?=
 =?us-ascii?Q?BVwG/Qe0FTxjQLqwd3C4IEmKnYzNAVimD4Ixr9XQbVDbA6lbhO3KZ2DTihfB?=
 =?us-ascii?Q?SvE3znOf+uXJwZ/wgytyJs8QJ9i3sYuryHvWGQP49uRYieW3b8mK0l4uSkKq?=
 =?us-ascii?Q?8psE9Ut1FgkLT0G1NjsVyVZx5O8wk3UR3Xs574KgNOq6bYUg/D1EzLknHm7d?=
 =?us-ascii?Q?J0R/9XKGGrpyEp/uyWAi8vyR3nX+OLFNUqyl9o2uahpgPOXyBgHJ6Sgdo8mL?=
 =?us-ascii?Q?KpuWX6JGxz42ZMpfUKETbj8PXSvlGaQhHdVqfuP34l2cfcojw8fzIIO/No6P?=
 =?us-ascii?Q?wBiwNG8lNIel8NcbGpC/Ny+E9qcKtIznRcORoLyxjcF0rRdSUxxT3sFLYtvS?=
 =?us-ascii?Q?s1yvsm59X4axqpMlLFM+FOldjnSuiCqMBpc58pCleypYsE/PaG32QMJO5bEo?=
 =?us-ascii?Q?bp0Gb6oSo7Z0KtIOqeS/C2GgZfXyrSIDdXVAkSQu/OH6mTkIR5LiP1VkQMxR?=
 =?us-ascii?Q?0qOu8AQU7aTSjFTWSAOj0OIqYmvb7J8tagDlOwupDIngIMMbiEHJP+IbZGrI?=
 =?us-ascii?Q?MtG4LqT+D2JlDXuZwO+mEKXevJySTNEcUyqOsMQsqB5tppb72d5DQ0AbjuXz?=
 =?us-ascii?Q?JdFP+kESPPIFL865GEJE7hotoBgXYHv1+jizqJgtwMjwXZJ9qx+lAO7tRq9V?=
 =?us-ascii?Q?638Gp0xTs82xFSAgB1xQ4oJvnQPpnMTn/WC67nvNO+r38EwWIFcYedZgB8K+?=
 =?us-ascii?Q?HLvA7V2sYB+TxueWggsJR6TmVDUxuvsDeqtDhLatLFzG9y1Uq7se6UfdXNi0?=
 =?us-ascii?Q?7uTFc2cqHyGQQQ+FKVZlkVdZeBr1hWCjz1NWnOvRtH7tbDm2dywTpYKX4vKg?=
 =?us-ascii?Q?lomTWOS5rWekR/3qHvtLxmIG?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94a2f53b-81b3-42af-0fe1-08d8e455f7d0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 06:21:55.8043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7zT4o2yO3lMxahrhonsyA1Ey7eu0zhR2Cj8RCr7iDQ29N/vHCsE7kuB5BzwV51tYf82JEmOZ/LMfpFiyLbvufg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6611
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

Changes in v7:
- Call unregister_mii_timestamper() without NULL check
- Create fwnode_mdio.c and move fwnode_mdiobus_register_phy()

Changes in v6:
- Initialize mii_ts to NULL

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 MAINTAINERS                    |  1 +
 drivers/net/mdio/Kconfig       |  9 ++++
 drivers/net/mdio/Makefile      |  3 +-
 drivers/net/mdio/fwnode_mdio.c | 77 ++++++++++++++++++++++++++++++++++
 drivers/net/mdio/of_mdio.c     |  3 +-
 include/linux/fwnode_mdio.h    | 24 +++++++++++
 include/linux/of_mdio.h        |  6 ++-
 7 files changed, 120 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/mdio/fwnode_mdio.c
 create mode 100644 include/linux/fwnode_mdio.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e1fa5ad9bb30..146de41d2656 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6680,6 +6680,7 @@ F:	Documentation/devicetree/bindings/net/mdio*
 F:	Documentation/devicetree/bindings/net/qca,ar803x.yaml
 F:	Documentation/networking/phy.rst
 F:	drivers/net/mdio/
+F:	drivers/net/mdio/fwnode_mdio.c
 F:	drivers/net/mdio/of_mdio.c
 F:	drivers/net/pcs/
 F:	drivers/net/phy/
diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index a10cc460d7cf..2d5bf5ccffb5 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -19,6 +19,15 @@ config MDIO_BUS
 	  reflects whether the mdio_bus/mdio_device code is built as a
 	  loadable module or built-in.
 
+config FWNODE_MDIO
+	def_tristate PHYLIB
+	depends on ACPI
+	depends on OF
+	depends on PHYLIB
+	select FIXED_PHY
+	help
+	  FWNODE MDIO bus (Ethernet PHY) accessors
+
 config OF_MDIO
 	def_tristate PHYLIB
 	depends on OF
diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
index 5c498dde463f..ea5390e2ef84 100644
--- a/drivers/net/mdio/Makefile
+++ b/drivers/net/mdio/Makefile
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for Linux MDIO bus drivers
 
-obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
+obj-$(CONFIG_FWNODE_MDIO)	+= fwnode_mdio.o
+obj-$(CONFIG_OF_MDIO)		+= of_mdio.o
 
 obj-$(CONFIG_MDIO_ASPEED)		+= mdio-aspeed.o
 obj-$(CONFIG_MDIO_BCM_IPROC)		+= mdio-bcm-iproc.o
diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
new file mode 100644
index 000000000000..0982e816a6fb
--- /dev/null
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * fwnode helpers for the MDIO (Ethernet PHY) API
+ *
+ * This file provides helper functions for extracting PHY device information
+ * out of the fwnode and using it to populate an mii_bus.
+ */
+
+#include <linux/acpi.h>
+#include <linux/of.h>
+#include <linux/of_mdio.h>
+#include <linux/phy.h>
+
+MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
+MODULE_LICENSE("GPL");
+
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
+		unregister_mii_timestamper(mii_ts);
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
+			unregister_mii_timestamper(mii_ts);
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
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 48b6b8458c17..db293e0b8249 100644
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
diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
new file mode 100644
index 000000000000..8c0392845916
--- /dev/null
+++ b/include/linux/fwnode_mdio.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * FWNODE helper for the MDIO (Ethernet PHY) API
+ */
+
+#ifndef __LINUX_FWNODE_MDIO_H
+#define __LINUX_FWNODE_MDIO_H
+
+#include <linux/phy.h>
+
+#if IS_ENABLED(CONFIG_FWNODE_MDIO)
+int fwnode_mdiobus_register_phy(struct mii_bus *bus,
+				struct fwnode_handle *child, u32 addr);
+
+#else /* CONFIG_FWNODE_MDIO */
+static inline int fwnode_mdiobus_register_phy(struct mii_bus *bus,
+					      struct fwnode_handle *child,
+					      u32 addr)
+{
+	return -EINVAL;
+}
+#endif
+
+#endif /* __LINUX_FWNODE_MDIO_H */
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

