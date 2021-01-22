Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCED300A56
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbhAVR0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 12:26:44 -0500
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:16040
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729193AbhAVPrQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:47:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYQ/2BxO0VGi73x69n7iwrMW7qmgZqoIPVpccpM2R5lGxvFLf6yztxIIpMwAH1vcBvIloNp4pznbUo+GnNBnrB5cei3V9fIJkKyizXH4HUdqrlznTKz9SgYidvRKUN+McngO/kM2OQnrU4iVBexyPxicIQkH5h2qCYiFcpSeIw/+h+YhL3WUgGj1QwhVENoL09J3PiiQZtl9QsnayuhPLkX/59zg4JpLcHFF0I8wscUTZOIJtpryMIBLAYmq6iXMesceo8Sc9oS+bS9J7Uzenta+XV0NKHd0ktQfPLlDJ5brOTjc2g+tkFr4i5qgndAewqygG3dqWYrxLRcsiC+dYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZ+Sad1o+bp70pULx46qnPf6XZSF2p+QFZE/XTBIWEY=;
 b=SnwyQmDkfY53CUtGyD/PuUT6VRQeKfWQPIq2UW4t0NhqN2ALa9DZzL7UrjwH3wWAFcK7WjjZA7oqtoO0JT88Hl2qtKUihgm4hcRdrOsbzCgH+y59OqHJk9nK3/+hyVUkgjvZz9qih6iPTKQ30CJrp+iAgw/3nWsQRysP6nADCusxKpam9MwfXbksALW6f7Wlxsuy0uefRa5P1ZsJOktIXaQZDyQDBmntx6N+H+QjXedzUhChHfSJSsvoiUyzRk19uSXRiKzRIoVPIV5RWBaenOJqlfj0mZ/a0eFJVt+RrM4VltGIMmq27kRAg6UfEHnc5xrbUBkj+Ofl/vC9cE4cqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZ+Sad1o+bp70pULx46qnPf6XZSF2p+QFZE/XTBIWEY=;
 b=ULvxd5KbJACzbmVfs6iRgx38l7et3EuX37bT0j5vs2hmrJyUg0MGN3aKOLdPqQMSdhtKYAxGhIEo9gi/irovRQjEHSfvTp87D/9b41dM6XVANYQOfgXN+/hjj8B8LvvsZsn4bl6FGjtPFA4nIjzODiOrZAtSlP6FukiQnGwrIak=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 15:45:11 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 15:45:11 +0000
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
        Jakub Kicinski <kuba@kernel.org>,
        Jamie Iles <jamie@nuviainc.com>
Subject: [net-next PATCH v4 12/15] net/fsl: Use fwnode_mdiobus_register()
Date:   Fri, 22 Jan 2021 21:12:57 +0530
Message-Id: <20210122154300.7628-13-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0117.apcprd06.prod.outlook.com (2603:1096:1:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 15:45:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d5902739-eef6-497a-bc4e-08d8beecb3c4
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3443226C9461979FE776D44ED2A00@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s8VAnlRbeHU4lPKniS5J7lC1UZzx2tXkyHR2amF7edvYedn6w1NiW444p3pka358cTm7+0pKBWg1otBYfrnZuuthL2LKeO0WOXIWDdARrHHuPNLpvj4uBupMfG9TZAenh9NRDxbfUEeqY94j0NZmmeCjYDY70fdNgu6KCQrmu479OLTKh/l889PcBb6eFuyCPU4mFaOygbeFtmbSeZsB//t+g+IlJisbTNcqco66YE8uyyvIJ7/IiRnrmrQa9bpO2Ys0u/a7AkwZ5GtwFQ5Y/skaktMQtJvLCmmP2BIhcF/g5o37sADmSiBOCIxuSWXA71XXPDshQDKyoBnu8xo5w14HTPPXZKLh5Bdn7oF7CkJWHxHT5ma8+jE2ewSF1yfHD4CTeOAp0LUM9157F6YDU9s0Aytbu2z0OUpOq/MwJ0VCXia6oIHivicVKaNxbJlBr30nH946dGTSWiyWYuIqSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(2906002)(6506007)(921005)(6512007)(6666004)(186003)(5660300002)(1006002)(16526019)(52116002)(54906003)(956004)(55236004)(8676002)(66556008)(8936002)(83380400001)(66476007)(2616005)(66946007)(1076003)(478600001)(26005)(110136005)(86362001)(316002)(7416002)(4326008)(6486002)(44832011)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YjyAqa2QzSKiXUwRyBuLVD4mfSPjPZsYGT7qx0qCYGKm73OoRi7R5RMbLGsF?=
 =?us-ascii?Q?H/QSwcKwaxeyp4BJBv1FlbicXGQPd18gzwn5OoeUSV99qCXQCAW6nxKjwHdS?=
 =?us-ascii?Q?OhG384g8xuuUvwKSktT9IiZjkpP2EdLmFWXNwrexbc63N18z2MN5XQ17OXoX?=
 =?us-ascii?Q?E58IRYKKkSk0hXKWsQt5/RQB7bDPpWQfQY5FniW6zRpjcP79MmW+aqUuQG+f?=
 =?us-ascii?Q?d/jy97ghb/34rDZHQPgEt+wtq6AyBSNTIYOLz8Ex7hBOzEGUzT6osla8LM3c?=
 =?us-ascii?Q?1ZZKIP4josRzjPVjUJBSV4tv0isK0w+yThRf5uV1XeCNU1VmoOqk6yCsD21E?=
 =?us-ascii?Q?X1MsYGWkgtMvTl0OY72MpsdHYDydtJPif6HaWB0kUosgeil/suaJ4DBDf1V5?=
 =?us-ascii?Q?qJPu1+Fpd4BtKNVVH7Z9oeMogbh721q5xTFOQvifC3UXqb+JFmgBCDAXKjbH?=
 =?us-ascii?Q?ulj1PFdj9IFYQNH8GwEFo6EDH9Zth2zaPq53udeIbqGFA29Qe8rdhSuLI0GE?=
 =?us-ascii?Q?v8n5dUiZ+qZ1N2TwNgG8eeI6y8bWaYTLGXV6H1pgUGeVchakqDyxWCy8NrUd?=
 =?us-ascii?Q?rs2rSuszZfX6Oja+bkbao8toGBtb9sj4iKlE22WOrVqnGNRlZhAeMwOMuZZ7?=
 =?us-ascii?Q?QDu9Xi4mowS+yLJpQwL5ySfDg3Uzj2hItBTenTHlj+KxSqfk5t8B+MG6vBSX?=
 =?us-ascii?Q?anZNJuYivR+ZwMvDGs1w2UmS/TNer2etOIbZ3yvZ+oSE/gooEO12IR4nqe4k?=
 =?us-ascii?Q?kZyyGoTLzYqBrv1E6k5/q1C7JDAywRZuznITIlCdFeQMRPrivweG1l6KDnse?=
 =?us-ascii?Q?Blg7cVGr78eSIaJ9QfpANXgAz30vqyHYc1zRhzSyTScib7zKQcIya5cgyOUQ?=
 =?us-ascii?Q?JEgbPgtOPL6+47J1fTqPWCkV2yeWAt1zPx2iTnZMYpc7SYOtcaz+5Z3BIhfB?=
 =?us-ascii?Q?526/NwD9GVcW1Mbo7ExQBULEQVQSdK0phiIc1XDTLzaacJU7cSxOfSkymjbe?=
 =?us-ascii?Q?DjNXRdazVxX8bkRt3Goj+O+U8wx7XSu63nfP1JBwqc/BYna0XVjM6odd9BTV?=
 =?us-ascii?Q?VzcuXSCU?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5902739-eef6-497a-bc4e-08d8beecb3c4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 15:45:11.6026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0nH6n/AP0t7794E5S1ndCJ6c3NkS+lvU7Nwh6LydWfDWylCKEKs4bLnWDNIua6Q0l+CqmsB45r6Fs0bAAnM/vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fwnode_mdiobus_register() internally takes care of both DT
and ACPI cases to register mdiobus. Replace existing
of_mdiobus_register() with fwnode_mdiobus_register().

Note: For both ACPI and DT cases, endianness of MDIO controller
need to be specified using "little-endian" property.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v4:
- Cleanup xgmac_mdio_probe()

Changes in v3:
- Avoid unnecessary line removal
- Remove unused inclusion of acpi.h

Changes in v2: None

 drivers/net/ethernet/freescale/xgmac_mdio.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index bfa2826c5545..dca5305e7185 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -2,6 +2,7 @@
  * QorIQ 10G MDIO Controller
  *
  * Copyright 2012 Freescale Semiconductor, Inc.
+ * Copyright 2021 NXP
  *
  * Authors: Andy Fleming <afleming@freescale.com>
  *          Timur Tabi <timur@freescale.com>
@@ -243,10 +244,9 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 
 static int xgmac_mdio_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
-	struct mii_bus *bus;
-	struct resource *res;
 	struct mdio_fsl_priv *priv;
+	struct resource *res;
+	struct mii_bus *bus;
 	int ret;
 
 	/* In DPAA-1, MDIO is one of the many FMan sub-devices. The FMan
@@ -279,13 +279,16 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
+	/* For both ACPI and DT cases, endianness of MDIO controller
+	 * needs to be specified using "little-endian" property.
+	 */
 	priv->is_little_endian = device_property_read_bool(&pdev->dev,
 							   "little-endian");
 
 	priv->has_a011043 = device_property_read_bool(&pdev->dev,
 						      "fsl,erratum-a011043");
 
-	ret = of_mdiobus_register(bus, np);
+	ret = fwnode_mdiobus_register(bus, pdev->dev.fwnode);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register MDIO bus\n");
 		goto err_registration;
-- 
2.17.1

