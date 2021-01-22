Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499A0300B6C
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbhAVSVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:21:54 -0500
Received: from mail-db8eur05on2048.outbound.protection.outlook.com ([40.107.20.48]:19008
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729168AbhAVPqG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:46:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FK1PS+a1UHHCz676YH3bS6tpNvIn1O+/dIpCl2mR+N4ImINeUTRtPPo/EDIaPi9rT9FUU6OmDoT487MeKWnR62RrYT0z+OjL0oBnl52bG4niKtPIXFY6PbS8Z4I5BSkQF/399tEvZqj0G29xKX23luYwS+2pj1FzXW3OTcVXDZXyFZdPHU/paOsIM5d+TVCV1GciWNO0sDOQfcacJhCB1W1oQK3iYUFdT9r9fGRnBSu0duE3f+kx4VJoTh1vSkzFePPLyNJMUoHw3RkB6wgeYJV904fatQNpkFm/QT2sPSepWvbCk61N5FNXR85cz0swg1n/zUYdzuuPGKPGapvkBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNj2O1W+lf7nF6T5f4VaSWcc5VbW7vCtB92IYJ+Yepo=;
 b=Uq2OM1XMwLCM1HiTEiMNPX1nt39MqEp8YSpjAMMFPxPs4bh9AbAGPAdqg+0fmejS20zQTR2APbRpKjzugrgDk0vovF71cqNKHQU8BtUKEe9S7FB7wzF8S5pUY4R7I+Sl8VGIHMkCml1hzCGgrXb5I97/+7xuGrdxkK4qmmJAev0fxWxoBwhlO459oMcPRVV2dQgQdMRbdJfzkoy7NLmqSKCBl7KDzerXSchWX50QIo5JgnYWoq/F/Q53UX4y7yrif6GMKPfs0MlS9gf5vVVCvVN4aOyOz6p9hA2R8XLCHDggf012IsABKTGL7kyjN92/oowzjbCdMqI1QCpbCN5zlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNj2O1W+lf7nF6T5f4VaSWcc5VbW7vCtB92IYJ+Yepo=;
 b=CE+67sdzptw9hr88bbnj3GbZzEeYCbN8VBvInfhT5ZOnubF4hkJAtqX5JWF8PunIz9lfVmos/gVUYjG5w73qXxkiwn8JctTQNoef0bLzDxlpB6ez6toVrgkwNnuxePIFgclW+2jQw86Xkvu3QWg73ajSXfIrnU4hbYqj2K36bJA=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3764.eurprd04.prod.outlook.com (2603:10a6:208:9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 15:44:09 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 15:44:09 +0000
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
Subject: [net-next PATCH v4 04/15] of: mdio: Refactor of_phy_find_device()
Date:   Fri, 22 Jan 2021 21:12:49 +0530
Message-Id: <20210122154300.7628-5-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0117.apcprd06.prod.outlook.com (2603:1096:1:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 15:44:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6353df2e-7484-46c6-b0cb-08d8beec8eef
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3764:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB37645A35A09913B06E96641AD2A00@AM0PR0402MB3764.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rkLr3khN13OmZIdfMVVRrgwhxmbJz03aAo2LGimMBVtTki4A/R1upHn+vhmdtUjm9ptnoXqmWVIAkoKCRBcURspONP/+v3tnAAEt7gyLnd2R+Gp5p5AbqxWpjRlprthaZydukkhVnROKPVHkqqYdTvInOvFkSCD0eYMZN19O1cMlpEzj3KSrfJ69KW4xN33PWnmUTsOnrYW3KydjoW8gMaoUDVi/5d2tl2qfDPZu9fWSRp3vgjWGR5olGf5snNZm4UOjuOaeCi6UdWsx6EZXHdbXBAukFJPjV7FOE0mCE6iN3WYxwq2g6VayV5liTZi76yZSzGhW9ZJKEwt6RGBsIYci7XP64npOjBLzhW+lKm36uIIJG1xV4+uY2kBuNniKj0+jKP0ygK3nkVEcaX+xh9iV2WXq/IGmgcM6BpOFxVWsxU3QTUKFavDi60YlVLvI/Y8j9EwBRRMxzoFGInwdx1zG8ikl3wyAKEGroK4iJLjC7xJGLMCuUa8eHNlVyvhIaq3SNNCN6fQZt3BsGaJvhjAdX6SMkfwoBaMWCu2zU9BATCyBddkRl48cI7VC+fpqI7ot9zbr9AoMHH8MpPX/mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39850400004)(346002)(376002)(54906003)(956004)(66946007)(66556008)(1076003)(6486002)(83380400001)(66476007)(4744005)(8936002)(8676002)(4326008)(55236004)(7416002)(26005)(110136005)(2616005)(86362001)(44832011)(1006002)(478600001)(16526019)(6512007)(316002)(921005)(6506007)(6666004)(2906002)(52116002)(186003)(5660300002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DLpBfYelbykA+rQMEQjMjmMl3aW3AHKbI4ibKoPERWIwE0rwc+2JwBcnS3Sf?=
 =?us-ascii?Q?+DO4wSJ9vqE8qEL2YpJ5YMUMkA3KIy3sYSiw1q0yo59EnAWwaqgpccRaVm7W?=
 =?us-ascii?Q?UuAqJ/265wmjwCTB46LxaTqLPPWkTnb8XOK0B3+s1z2uCXZeJdZVuVdpcSdw?=
 =?us-ascii?Q?sN0DzKn51nbBOGNHZpummwiEXeex3ExnX6aXdcYAehHJBf7xeHOzCom23l0w?=
 =?us-ascii?Q?RXLBW6HLEh4XQKqfLXsHg75YfigAUnYgzg4oEvxQLEIXFDYmQ2cm3rDkivO7?=
 =?us-ascii?Q?pgdZ6JaphEmk5VQSZTkhXlcKhpFuG6C/ww2L0pbD3X9tvXwRQTCohvQoo6S8?=
 =?us-ascii?Q?abVtKgdmbG8pIABKZccI5VZe2wTRs9xrtOgdxm5I+q/evCDNEged5S51wom1?=
 =?us-ascii?Q?VvtjIJkfee+sfjBPkvJNqYTo3YS3cp7op1dqNW+dDuxudtuYXrPuf44hHGtn?=
 =?us-ascii?Q?Rfu9u4GqtURYzz6txHCcBBbT8KwFqo8pG9yUfzCfQAjzwmi45fFlDox5jh4g?=
 =?us-ascii?Q?+2yp07ZYDRPNviYUCIvm1fYIB1gF45wmnTtqHKjGXAnKO3v1vGPoObn8KMo5?=
 =?us-ascii?Q?EchQMGZAN3ZS6BQvHMK3amLQVmkvZo8FS94mb46kEsO6cg5jbU02wYr8JwjT?=
 =?us-ascii?Q?bzU0GpdKoLpXFjG1TQsOzU9Ex8NZTE2cjD/wJWRC8DJSnRP7/sWqf0tXr0e2?=
 =?us-ascii?Q?lWSBMFpC4HL7oDb9S2eq8JYRJS+13zyof+xCzqwSPrKYAmPgvzTE6CAvYkBB?=
 =?us-ascii?Q?Vqp/j56NC+xcwwyEKw+wzd+Q6xKZHvjwzX3GEuWWPRiLCM9up8sSikxhNszJ?=
 =?us-ascii?Q?jwOYjAUhuY0dVpa8QljAFPFQPHVLUGEBiyKlCeyXE05g67BcAxagqlGLmhWV?=
 =?us-ascii?Q?OzoYoIu9jYs0FR8+CJxsjHKoM1W+TnxSBNVmzLVGzDPselI0D3KUjH1iSiJS?=
 =?us-ascii?Q?TGizjKmIhupUgaMyVfv/+oZfOxFjrv/C2RxV7kBO02p50XgVC2p9BRKmSGnr?=
 =?us-ascii?Q?tZPoFe4vfADrieCBrt7JccDrR3x8MEZWZXijD6GGBSVt6sgFWJmeR/hw5Lux?=
 =?us-ascii?Q?th+0ZnpW?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6353df2e-7484-46c6-b0cb-08d8beec8eef
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 15:44:09.7284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W/g/cUxIxM7LVqtSLbMpeFkQ2d20eQSNFA1yLPsPaaNTiFR1uN3BD8wV69afHxMjbJ0Modr9i20hcT3W9Ixnng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3764
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor of_phy_find_device() to use fwnode_phy_find_device().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 7bd33b930116..94ec421dd91b 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -360,18 +360,7 @@ EXPORT_SYMBOL(of_mdio_find_device);
  */
 struct phy_device *of_phy_find_device(struct device_node *phy_np)
 {
-	struct mdio_device *mdiodev;
-
-	mdiodev = of_mdio_find_device(phy_np);
-	if (!mdiodev)
-		return NULL;
-
-	if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
-		return to_phy_device(&mdiodev->dev);
-
-	put_device(&mdiodev->dev);
-
-	return NULL;
+	return fwnode_phy_find_device(of_fwnode_handle(phy_np));
 }
 EXPORT_SYMBOL(of_phy_find_device);
 
-- 
2.17.1

