Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3786B452ADA
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhKPGa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:30:26 -0500
Received: from mail-bn8nam12on2121.outbound.protection.outlook.com ([40.107.237.121]:4257
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231383AbhKPG22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:28:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNbyu2gLoBdk8r9HBjfUZcKXnZMHAeboRypF7feZiJE+IH8O+cg1WYTgMw5C2BU/ckk/lHAEXppatF3/Pj4MVo87AC1sbRuInMInVh9M5yjvbUeQm2hhw4k0a+cEPtmxsZnuuTf/tZHL7+jKO/pKgUfHGa+rRab2NGrRvoNkg6LRZZ58Y21uZTDiuF/i3cBuK/e37F5T1FjgoXGqTZzwW1PxjPxlbs1CWR8A/vERtAtFpERJ192OuMWCTyyXHDHZwi17UizW+atwkixKPRfxwfSckafSKgHYPD2dUM3Ja556kjzozIdPgL8k9UTvrTuAkHS0qbemAiOcTPL1CzwvWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nJsIVdGdQxc4duae8jEw39R/NAVBSIQKEwRd0yqzlss=;
 b=W0MYX6wkkX+iWgieaJq4VoQECBFd6E6j4m1f3cLiXazFN5JCIUH8oQOa1gx86maan6KpU4b02UN//znERfTh31mXjMqaj4T9ARSi/4/BDNkcljT60Bm+KngY3NUpyb2NicpitlLONVg3FT72232GZVUTd04U9Mu47R1VPqwjhR2FGBk+x0rYws9O13mu+WuHWlzKx/faB+BOnHFUPJ3Lw4luMO1DFeie9rI/Gj/GcjHTaX/Ag/TJDdX8fhBWGbWwvjshngOhUMz/ESDba9tm4MVW/WX5anYTQXudDJJfIyU+sd66h8BxB5RHpyeFnzwRNe40SEE0KBTOS/E4PBZ3QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nJsIVdGdQxc4duae8jEw39R/NAVBSIQKEwRd0yqzlss=;
 b=grZs6ezRTvsSmBtvfnUqQhI0w/0THhNcbQ37HJp2rrrSQcaBLwDxi2h8piySqo9rYStG97kUFwY0qrh9aQM+u1Nh2arn4EVz+ltQgceeL0E60LJ9FPi993mQ6AvlmJN5B0yy2qtczHHeE2nk1ojVPKOyccMg50CGbo2XnOCb9hE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2383.namprd10.prod.outlook.com
 (2603:10b6:301:31::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Tue, 16 Nov
 2021 06:23:47 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:47 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 06/23] net: dsa: ocelot: felix: add interface for custom regmaps
Date:   Mon, 15 Nov 2021 22:23:11 -0800
Message-Id: <20211116062328.1949151-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0a075d7-b781-4e90-bc8a-08d9a8c9a570
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2383:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2383ABE1741946FA04513DDAA4999@MWHPR1001MB2383.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8RM+8eksEDxDTu39a07Uu1Uoo1vr/NU/5qm51b9aR6tDnsr73l2P3gYIZlj2JJiElVhrcExtNlFj3TdIZQzYwq03r004EbJnoF4hWDf0OM4oaLz///NYkK9DXRi4EFZyzSpi8NkTTzL3IRVlLhw0srUL4urfrP3ARUErnLZxY4ok8bENaTMLBGW0XOcu042GZA2Hnd9idTt8M9fGELPVux7DGHLlaLlQP0hqM8zv8HPYCCEf9/CtSIYrNv9T0rC/L2WSxM+s1u0FqWlyknLtMwcwXUqwZ1/8SuTwF6/oSEqz2GzHuGUxHZTes6xWtysXBiFUZBorkfdoiNjCy+x0Ctbo6ZCgR1+am0AriZvIQK7rC11N7SpDlfh92LtQpvL4fL3pgZGgqwbCUjQ4Lj+VnV+ja3ACLV5Tl4YECnApNSgT5fvbbFSsfg0rIEXBJRgG/00Tldc3K2ta21bgtUZo0NDSHWzr+R6AxyQFvF6Wm7usULJODhakZX9UC31Ri7OdMkCtJJW2+KH0nKW7a5IB5p9hx3jcQ3gyItq11FrLq1e5OaBm771le3OGi9jUIhHvHzukCZwccxz9+FuE5lAKg74bxNtQpJslJUCdhoys1tyun3kClYZe23Z/wHgEG0tTkPHSGxQNn0wsdAGdYg3BwlCguhltEVxVMFycrixXEkIALq7suKAtX7tq3kM3bIZudhiXhIhPyyKBzNhhLaik5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39840400004)(136003)(366004)(346002)(396003)(6512007)(54906003)(316002)(4326008)(83380400001)(8676002)(86362001)(44832011)(1076003)(2906002)(66946007)(38100700002)(38350700002)(508600001)(956004)(26005)(66476007)(66556008)(6666004)(6486002)(6506007)(52116002)(5660300002)(36756003)(7416002)(8936002)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WNJ1bl2BAbdI6izA02Umi1wlk+C78/0uM11hcANopgfCQjlcBLpLKCvZzfyi?=
 =?us-ascii?Q?cvIfy8yJNpskI6m88lma4HvbmVo6ld8qUxlF6ESRS/bhB8ooV3AtIeEDiPoS?=
 =?us-ascii?Q?CIDyF9OMN3Lpa1fwAsU4jCoTE1C+QetbNj71Yx3DT9AJ6VzA7Fz56JTeVM/I?=
 =?us-ascii?Q?Q1P0qXEQepb/0AvMbJBVZn9CYJ3vIiHyrV9Rg7IcJGHGCnRT8bTNKszpxkx6?=
 =?us-ascii?Q?g4z2jkNqcIu9NZ+7ippJJjo+KMHPvVaRq1DduO8w7MPAs3WcKrLSH1FB4Mg7?=
 =?us-ascii?Q?8w5lz3TM/vBpFFBcSh7GkCKmGlTXpgDRh8vY39uOUq1aZ03b+FSZuU4iIAeU?=
 =?us-ascii?Q?8RYQaIsN6+sArfI5mTx84cgLoXGO7ud12+Sr254L+hkUY1Gj60Gryyr0ijQ/?=
 =?us-ascii?Q?ffP0YTysCLm2YU8fzXQCGNASFDYmYfN3TSwW9fmlmWWlID+OXrAlUailX+Qo?=
 =?us-ascii?Q?HniCJv08tA+KbfuKcR+eci5yj3Gmny9o2eARt6Jedlb9T7raB6bFID+dgBqe?=
 =?us-ascii?Q?OPgoMdTiMyVUFvKOZcPTlZmYMIgBQ/wpyvT9FPoRjpizPQ1gGfj4ZoYkP90E?=
 =?us-ascii?Q?tgwPOvuAl3Oi1Xf2+yshRcTFKhj6e7eHi3Hbg+Q70j2E20aZYPRjfm+ubGnH?=
 =?us-ascii?Q?KxObx/tbA1x+HBUtlRDLaeurvp95VMr7l3ZqF9vVu+5Usg6rRM02qx9f/Zi/?=
 =?us-ascii?Q?dr4+iwT9wrwDsMTCgeO68x7YR45b+vg37RBprDmfcPzrI3Wd4l1o7RodWjPQ?=
 =?us-ascii?Q?0lcvsYRAv9DtGXo7qythcbUmM6iMDrYGHaPbjeZjd9YV1Mx0nLfO908/4TYT?=
 =?us-ascii?Q?l0+ph2GT3hvLhdYUYRssqLnqL+LBZEJlSJaatdHVTg79hnsqbqoZxi1RzuT1?=
 =?us-ascii?Q?Yo9nYjQ2CY0IZal/5mxJFaL51m4DFoQ/Jh0xTvFaMkKWJvvO9SGzYLwDm/Ej?=
 =?us-ascii?Q?PK0Zut6Yk7qxMpoTlj49iFAon9xKk516Zk5ICC6ksrNJmBld3xEyEJXVjV5W?=
 =?us-ascii?Q?hQrGZF4CiWQTkAAwvUbbbfoWkyEu3pc/YGwRfg3RR4lLQ5SV3dBeHes068FX?=
 =?us-ascii?Q?Y9+1ZjwXWlcEqlXq2iqiUKwdiG1lLWoxJr4hO8g9bY10ZzJU8rGNKkXSlr5F?=
 =?us-ascii?Q?BqLaQ/GMdQgqYk4rTsAAIIErtF37DUO9IN3+bTUqPAb1kxWtOCrDfv+23U0m?=
 =?us-ascii?Q?fn4+0RM15qOPs2XQN1R+dogAmM+H1Lf9aAHOBflO2Xjkyrd+nw9KNI7ljJb6?=
 =?us-ascii?Q?Tl6iGRj1PeRNM6dbzOWQADmPG4xSxJw4R82y5j7V81qHmaZqeNp5MDNn/SWK?=
 =?us-ascii?Q?QrlROLHImw692rpOHpWQhcyseeC3fF4dCtthqD8415evIPEn6gft1QNCvmfk?=
 =?us-ascii?Q?5BrHuYhsubZX8fNCKT83ujb5BOPDDZ4q8P69cT/5uMfNPz67oeSRTQM150Tw?=
 =?us-ascii?Q?3hVSqrzfyxf/jOtonQxEm84M27yUipYwjkpj22APS/wpVGZMyVVKlOpIwMsE?=
 =?us-ascii?Q?U/Orr+yj0zvjWm+UpqSHq4Odz8jG16yNDDPt7RJpn0uHtPprPRUo3RmVS+Fl?=
 =?us-ascii?Q?hfK4GkUOQVLmQdWMs1zBJt4PhkcI2RfPbqtYWdmu76yNjR4W/s7spNeqXC0v?=
 =?us-ascii?Q?TdXupolFwEsYNTJknFXbbSP5oGB0nIfWLsrb+TeEdLHVgWTT+A8D19SJXyrk?=
 =?us-ascii?Q?MATE1qc0u85yzXlahlz4JGo81PI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a075d7-b781-4e90-bc8a-08d9a8c9a570
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:46.8786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RD/QYTNp+CgMq+ia3kXluQbTmp/5vHX4KQGj2i+KOyumQ6On81X2ot9eyKVNCnbUGGaCJLBcJhaE12/MWStZRJy9XCNdnEyRUEOdBMVcIHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2383
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an interface so that non-mmio regmaps can be used

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c           | 4 ++--
 drivers/net/dsa/ocelot/felix.h           | 2 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 6 +++---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 94702042246c..615f6b84c688 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1016,7 +1016,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
-		target = ocelot_regmap_init(ocelot, &res);
+		target = felix->info->init_regmap(ocelot, &res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map device memory space\n");
@@ -1053,7 +1053,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
-		target = ocelot_regmap_init(ocelot, &res);
+		target = felix->info->init_regmap(ocelot, &res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map memory space for port %d\n",
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index d7da307fc071..81a86bd60f03 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -46,6 +46,8 @@ struct felix_info {
 				 enum tc_setup_type type, void *type_data);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
+	struct regmap *(*init_regmap)(struct ocelot *ocelot,
+				      struct resource *res);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 0b3ccfd54603..789e1ff0d13b 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -17,6 +17,8 @@
 #include "felix.h"
 
 #define VSC9959_TAS_GCL_ENTRY_MAX	63
+#define VSC9959_SWITCH_PCI_BAR		4
+#define VSC9959_IMDIO_PCI_BAR		0
 
 static const u32 vsc9959_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x0089a0),
@@ -1365,6 +1367,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
+	.init_regmap		= ocelot_regmap_init,
 };
 
 static irqreturn_t felix_irq_handler(int irq, void *data)
@@ -1384,9 +1387,6 @@ static irqreturn_t felix_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-#define VSC9959_SWITCH_PCI_BAR 4
-#define VSC9959_IMDIO_PCI_BAR 0
-
 static int felix_pci_probe(struct pci_dev *pdev,
 			   const struct pci_device_id *id)
 {
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 610bdfd31903..47da279a8ff7 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1087,6 +1087,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
 	.phylink_validate	= vsc9953_phylink_validate,
 	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
+	.init_regmap		= ocelot_regmap_init,
 };
 
 static int seville_probe(struct platform_device *pdev)
-- 
2.25.1

