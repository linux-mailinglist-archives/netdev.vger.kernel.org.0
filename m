Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A043137EE
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhBHPda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:33:30 -0500
Received: from mail-db8eur05on2054.outbound.protection.outlook.com ([40.107.20.54]:24577
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233613AbhBHPRr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 10:17:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPIrCvoUFDTugwGtdmKsb5DL0Ighw8rAt02ySnxsDnzqrALzB5B6AcMRF7v5dMeo4yhj/vAb9kT5oHvqF5VIuqBTAOTjKCd73s1FsnIAIdXaDwt5i60cUOClHtnncFTqZqjH1Y7LsHb0SIaPhqcDt+zTKNoWVe5oWiCWUDoaZt8k+wkQUjwxViffotsdcH6jzMNtLzHMHojP1JKe1wJE61Mmg3aEQ0r4NDvjg3SKsWb1LXKqR7hXfRHMQSAJAtpT2TBucuYJ2dxuXbuEJUrEiC80cAhZdYwRJVTTHAHNEoJ09fbY21SAFtYyUt/unIsJLHhv67+pPp3MQMf0IzaEHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FGUENR71cDvFAMcLpUQut8kDNaJm/+Wm7e7kJwuSAnY=;
 b=cy/7RVfULdX8U4k/Ousy+OEP/EFVpcF6bDsaxZs/qCJUQf31v3ObYvS2GvVFfN+pAQQTxfMxCmP05pmxKdWPeJbHVLDydu6N9NkaP7NaTnPl8oRpk5zIuLhK8DCY+fvJpzDi7ajwmSmlGrCXK8E+pFSghPcasJp0w4tzzda37IDWuP0JQFpS8SdGwAXzjLfWLvm5cRhlHDEbWLi9c27vo9faodBFVhzPgqG8U2wk7LdO08piwmxnkeaxO54uxGY0wjDVcvN3oIJbwMY6XdxDPqfxU5YJ67cDgbJ9Gbc9ZX9G5XWOM5CZTlnZRgYzAcchgpXW00SafS05A5B3xLBquA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FGUENR71cDvFAMcLpUQut8kDNaJm/+Wm7e7kJwuSAnY=;
 b=LUgDfYqp8VQNyBkjcZiQNbdSprqsWPqWM2IUpwfZPuHbPi+opajzyBeFWaSs0XYLmy8znUDQf7BDyeRqiC4uAhmjWVZt/qYKbGLmKX3Dxvz7C5T3n/hS2zFNQAH3nA2s5qLpDOnqmpmr/fhbBUO253reBZQmehnUkQbCGqb49ag=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6435.eurprd04.prod.outlook.com (2603:10a6:208:176::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Mon, 8 Feb
 2021 15:14:33 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:14:33 +0000
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
Subject: [net-next PATCH v5 11/15] net: mdiobus: Introduce fwnode_mdiobus_register()
Date:   Mon,  8 Feb 2021 20:42:40 +0530
Message-Id: <20210208151244.16338-12-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0176.apcprd04.prod.outlook.com (2603:1096:4:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 15:14:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 550ddd92-031d-4d24-e397-08d8cc443d6f
X-MS-TrafficTypeDiagnostic: AM0PR04MB6435:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB643599C77C10A3EFC3849C7AD28F9@AM0PR04MB6435.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xN+SkmzWNRmtYFkzbkZDGh5aJz3Tx1GaTl5czwmtaRJwnhlDYs90i+Z3gaGJHFnpraa5FNKDIVFUD4dKBBesL9C/UzyEUkwbXtYhRw9kP26q2u+uFhog0eGTDGOsRhLRNnDqFMBLObzLs6/TnmU4/AJ1jmnHy1VOaa+zF4dWU2A0lQ5N85IjitCSxoFbinXh7uVlj9SixBaDC2H32+CyudAiygTXmNIiXvv8HNOVLaIdqRA9p1ymcXdoldsNdEhEuK6oG66i+MZKAIJcW34aAO97MhglzMEtXdV72DMgnhgk1Rcc/YpIOT7+5yHdDNEHIY0qPo8aEXUzwdIH7GXmNstWhMcid/xGeAbRt7GTgaPRPsvODABATlGbJFRK/a0qIcnCBm1m/QhMtUcj6XhEbJtXGWy36/wUACEBWuGDFm807WPLfaugduEoIZEsYpQkpPr0rxppb25FSfEoKAC1NKmu5Y3nGGHyjwhFHqrlIyJ1T8vXFcXaEqteu/htXKvWeeQk/1QSZ9Nwg/Dd00yN2mD3uHLkMNxDtEThhx75Zvz0YHw4IhCvAbEchSib9cAxogBx4X4OnwA7EPEYqCGRtmk2BlGpD2l87VTdsbGxntI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(44832011)(86362001)(6506007)(5660300002)(921005)(8676002)(66946007)(2616005)(66556008)(26005)(66476007)(1076003)(52116002)(316002)(110136005)(186003)(16526019)(8936002)(54906003)(7416002)(55236004)(2906002)(4326008)(478600001)(6512007)(1006002)(956004)(6486002)(6666004)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?B2YN6gbW2ACF0+QA/iPC/UFcFeI/9YG83DNDcerVgAaKN0FGXXZheDlR2CdJ?=
 =?us-ascii?Q?og4Hk2BRMf3kNfkSnoT6l+2otu/Pm1cZT3ZZlKf4WMvWjS6cq0Hvw+lRMyn+?=
 =?us-ascii?Q?ySRSZULALhyD5Y0tO/TNhhukbEtYcANWV2NlY+Ydkei0jxMVkqphFv4F/hEH?=
 =?us-ascii?Q?5jANE+0Kx4xivbdygppX3jJDnX7WgcRaefiZGuarcqobCgJq6dtSMc8tS4Si?=
 =?us-ascii?Q?FtyrCJcT+B+6RX58Ya3BbS2e1BZBO2B/8AB2MxoSQ0iKQ7kL0486fBMDHCQU?=
 =?us-ascii?Q?BxFcocVOSqDltKrrcSYb/7vpvjOzx1GmdPbxhIEo3XqEo6gEgXhhEWM2AVNR?=
 =?us-ascii?Q?axNpQeNZOgbC9K9RBhgYrqtWcZR5x9PzEx/gFXdl4AZhd6zFZPOaEPF7THlt?=
 =?us-ascii?Q?wNYGnMXC3y5rj/XgEjiEkaPYdkz/encUlPsDQm5PHpzZJFfitCPPZlJUHo6x?=
 =?us-ascii?Q?Xc1ZRQPU4k/F/irT7WXk5PwQU8MWfdqogKtCZr4hLQrQB82GxIfL2la1PbWb?=
 =?us-ascii?Q?gLEFV7DrzxK7zkTz9Y8y4w6K2HuWweo8TQASICAoU3ritVW9NOk675w+Ha8x?=
 =?us-ascii?Q?teYYUFslndMSP/NHlnn5P3aS22lGt6/obzxZ2VUdjTMSb6Dxx1KePVs+K4a/?=
 =?us-ascii?Q?HjKIUdcm54xA3NiqHgSHv3L4dH6f+T9kuy+zzRM3IGHiHIR5Z51j9mM5Zvbp?=
 =?us-ascii?Q?ntOA82fDbo6aB5dYaLBqYKYWUhFAMHpelrmu40msjMfYoZLuGZ/zFEuHfwo1?=
 =?us-ascii?Q?+PivUmyCjH76UDxG0f25eF73okJmC1NN4Zk7rwvFr97N8mTbVAREr0XcYLB5?=
 =?us-ascii?Q?5vxDINpJx1I5IPtnOBj/Adtep03fjZ7UonC4MoTopAN0mA2fZc8ZbQ43yFhE?=
 =?us-ascii?Q?mcUCUr1ciLdyLV0MwUlUF1x/LlAzbs6szXv5THC+4frcm2Zru7N8x1sEPyw1?=
 =?us-ascii?Q?yeAGmQKPtScDntr0OgvfV6QUFr7qUdBx6HyiuvoOv1bNwJ6XijcIgU/TrjTf?=
 =?us-ascii?Q?6CdUrlmr9KnrcFRPdVPz6X2NqZg7DrHmcHdViH+lRzAF8z35N0ZOIkP1NRqh?=
 =?us-ascii?Q?zYhU+aFTvmFlopniMlhXYnwZn59iKAREy7R/JTwoHn8MPjviadGtEmpATdFR?=
 =?us-ascii?Q?QVYMZQGfnXvmj+F3NcBu4HkKXjGkDanGNFaEloQD3UApOi7gf34YQSHVLzfR?=
 =?us-ascii?Q?v726N3KOI8G6q78z0RD05HuW6RW5V0ZMojZtaInDcftlVYBc15jzcUjLt+0d?=
 =?us-ascii?Q?qE+zUHEBIEYLxJwpHzq24lvRs7WleDn2ZDXmwjLaJ69OPdqjY1uLnoUiT9MK?=
 =?us-ascii?Q?yFTvxgUVqCIK+pYMuWJxsM5j?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 550ddd92-031d-4d24-e397-08d8cc443d6f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:14:33.5559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWBPY+61eFuUKy0ZA98ry3kYBUpgqm5MhMKO/bB2EgBb0/JgaRuiKEbbCjZ58w8LpdNVbYiwyn4m3EQYHQO+SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce fwnode_mdiobus_register() to register PHYs on the  mdiobus.
If the fwnode is DT node, then call of_mdiobus_register().
If it is an ACPI node, then call acpi_mdiobus_register().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v5: None
Changes in v4:
- Remove redundant else from fwnode_mdiobus_register()

Changes in v3:
- Use acpi_mdiobus_register()

Changes in v2: None

 drivers/net/phy/mdio_bus.c | 21 +++++++++++++++++++++
 include/linux/phy.h        |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 33d1667fdeca..c597dd41695d 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -9,6 +9,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/acpi.h>
+#include <linux/acpi_mdio.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
@@ -566,6 +567,26 @@ static int mdiobus_create_device(struct mii_bus *bus,
 	return ret;
 }
 
+/**
+ * fwnode_mdiobus_register - Register mii_bus and create PHYs from fwnode
+ * @mdio: pointer to mii_bus structure
+ * @fwnode: pointer to fwnode of MDIO bus.
+ *
+ * This function returns of_mdiobus_register() for DT and
+ * acpi_mdiobus_register() for ACPI.
+ */
+int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
+{
+	if (is_of_node(fwnode))
+		return of_mdiobus_register(mdio, to_of_node(fwnode));
+
+	if (is_acpi_node(fwnode))
+		return acpi_mdiobus_register(mdio, fwnode);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register);
+
 /**
  * __mdiobus_register - bring up all the PHYs on a given bus and attach them to bus
  * @bus: target mii_bus
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 957ce3c9b058..765e1844cfdb 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -387,6 +387,7 @@ static inline struct mii_bus *mdiobus_alloc(void)
 	return mdiobus_alloc_size(0);
 }
 
+int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode);
 int __mdiobus_register(struct mii_bus *bus, struct module *owner);
 int __devm_mdiobus_register(struct device *dev, struct mii_bus *bus,
 			    struct module *owner);
-- 
2.17.1

