Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EC9313721
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhBHPUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:20:33 -0500
Received: from mail-db8eur05on2050.outbound.protection.outlook.com ([40.107.20.50]:65248
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233574AbhBHPQS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 10:16:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DV1Yh8ZG68Ekn4hpcxorHNZXt02peaVBFXTr2azD/9RyWRsHZCQflR8h8aAd8+xSQkbYAsBtG5KknIyyYgmFWhEYhMqRGms0dBqsRA+2jDxqkyWaA68dUBR1ARRm3DVD/5bS1egARHxdi9N85iwYsSOFX+45jb8YIVSu+rSudoDw/Eja87F6dsxsTV2vVhFxJLRERWNI25Pbte3eIow7q4Ixblz7m/uNa3WWbwEC9yfW/AfuacDmuIGvXfNBVf3vFNPdNSJWdOZMHOtE/OmATs4gxk/hPoMZZAdOm8nAnPrDvoOH0sTHHZdf3yAmViDhU/7aG/Ui8dbnRTq3/B7p+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2V6s6XI0TYXSfjZLeXu1sqJNvc4lJnjwdeZllJubzK4=;
 b=ENoh1q66JpB3T3rLykSECCrAzNdjWlh+Hhec7TMtzsvTnBmzexIbUQ2xy8ncQbwz0uN5eoOR8URlrrfvcHedqetcVBq3f0Pati+4D9Nqmxi2hMZ3UItCRBa0GmUHnYRt3QRuZnS3ZVrWKsHbhrKAWOmvXFIEocwt0QD+lcvRjvzU/u7jykrJ8Bcspz0RJqI54LYahuV2n+sthLbhxpMiCzLp/KabPk3bLsorZfCnibU7XVbaqzJiIBrfmrhBY+p9+T4JlybQHdNOnI7giB1hlFZ8zfFM1t7Y6rz/kqXXrcgaG1ojGPFuzLr5AIl5coiGgliQBaRuxOWcdSH/QkPALQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2V6s6XI0TYXSfjZLeXu1sqJNvc4lJnjwdeZllJubzK4=;
 b=MTzoqcKZXOtZk3x3Un0eJnPPMmtf1acn+n48rdXtYhrzD9TFxlheZftDrGCfvcVoXwAygroq+6barliEOqKoujSHJyva5OwUQbKjZrAwVjts1uoBKUoAw1tqM3FsFHp5wUzJXBX48P97DNidcBUOZqXscU34B+6kFBI/tgohBcg=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6435.eurprd04.prod.outlook.com (2603:10a6:208:176::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Mon, 8 Feb
 2021 15:13:45 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:13:45 +0000
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
Subject: [net-next PATCH v5 04/15] of: mdio: Refactor of_phy_find_device()
Date:   Mon,  8 Feb 2021 20:42:33 +0530
Message-Id: <20210208151244.16338-5-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0176.apcprd04.prod.outlook.com (2603:1096:4:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 15:13:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0fcb7ab8-64d2-45b7-a301-08d8cc442088
X-MS-TrafficTypeDiagnostic: AM0PR04MB6435:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB64359919F573AD36FFBA3C52D28F9@AM0PR04MB6435.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G8GyFoA4nP5CbwD/8d2G8jHeutTLH75D60er6Vioqet5ns7yLCI1YqDvfZjsfKztNu+387saheRi7mKL0fUAVApPtFuOHu4P8WEvJJuUIhepMAxHi7hed2EP4ixHXyYqWbKhFJS9flmsJaedtvu+Yr2LG5bQAEyHVjukoBh6DjQWk1PGodk3jg+WNIlI3kr/GfLkuGRRUeh11CBz6sAeRZC0DnuzMUZCx5n+LxInns3+maz21UtwB6kAwaEzL10/CuyZayXva9H6Uu7k9MAiveQOenYRk7mNuCRoyCQ9v+CTnzu1COBGH4sRzilVhKFw0RU9iP/DiOvT0vyZAJfka5BVKAt3lmLcEMR1r+w1oK8KKroaxYjNuy5K54gLdRhgohCuOxuh7AcEbFC+kgvOEGjhmcemk5Zl6dzWx4KWqTauiweH3prRV2J7fUdUo5Tik6f2dTkhiQAqevdLwOM1YVX8a5YxUj+GE25jNaswxFw9WJeT7xJyEDPXmkKcA0Qttzm3UUsnR4IwagiOu08NytnUoevEWfOMY1m2cnWhqAY2WEsEAFY3c8Y8Yy2bzE+lXCMlZ5w+YVlee1OcF29Iow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(8936002)(54906003)(7416002)(52116002)(110136005)(186003)(16526019)(316002)(55236004)(956004)(6486002)(6666004)(1006002)(4326008)(2906002)(478600001)(6512007)(1076003)(4744005)(6506007)(5660300002)(921005)(44832011)(83380400001)(86362001)(66556008)(26005)(2616005)(66476007)(66946007)(8676002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uaf8iccntK9P968IgHiY5LnC7D1zxdFj5jsOS0OzJaAUSfwzq1KzNwBdxMhV?=
 =?us-ascii?Q?NG8Fqm9HsQChcToma4UvSpcJulB56UH8TuJwzKDs4GBPQPp9036sdL8D++aJ?=
 =?us-ascii?Q?fqbdhSQIAjZSd0UKKQtU+18IPbFFuHir2SE8xXuledQQ+lsk5l4tklJpprpJ?=
 =?us-ascii?Q?VzclMFh1wuL1BMASnfHAgGg4V7kjTpRDn0T3Q924NvT5qTHAwbX0X+Ao1ukH?=
 =?us-ascii?Q?LivK0+KOs6HPbMabbBZppFuLJqXZBwWZGFXYVSo37bjLlM5BsFTII1+T4eMa?=
 =?us-ascii?Q?wP6KqaPCnkAFyGRP1gc6os9j/PwXWx6st87wi/JHjXryDVQmgoOyPnSBNQIJ?=
 =?us-ascii?Q?Adw5vWGGyFU8VFGDDw2XarObI5QB9QcBXElh6DlpPPtj+vgKMEym3+fwUuC2?=
 =?us-ascii?Q?4FhGssu6pKeGuKYTlMPMtCgfnAfeloQIEkorGHepTgjx6sA/kzR5zneivszQ?=
 =?us-ascii?Q?Q2QXWGCdOj+szwiRICb81zQNMAQWE74AgKhwYiyWiZqvzk1Cxdq3VNzW8Zz9?=
 =?us-ascii?Q?rEkrECDw09GFMNOdjOoFMHuSd6sH4TbsrnlUPDypRSwhtn5BVnFGQH3ti6KM?=
 =?us-ascii?Q?H64nC8dlMMu8bvB5WmLOochMutYp0aPMpVAPbG6tooSWoZyOH/YaY2oKmteR?=
 =?us-ascii?Q?nbg7rP+VfzLBvUQ6uTurSJK2Ek3Q5AVdGHDYs4yVPtbBOSCaMgALCxg+VtuF?=
 =?us-ascii?Q?0R+NlWG7E+N6gHXwVMv15TEzzqAyZ+I+JWNa07nU0CQufJ9IIFKmSSBnC4nj?=
 =?us-ascii?Q?FVQHa7ZsOvJWfOEmfm5h/51xGEE9dioskAeE7vOGQlHlDsi6AFbMRBXLcpq+?=
 =?us-ascii?Q?rsom2YKV+yTS87ZRrj+9kfI6qJV3jZtsumDnmq3BYsn7a2uYZ0xO16/jNKSI?=
 =?us-ascii?Q?COwfgoEFG3ErVfFA84BKfVFdBusaiv41uRD4HvfYN4MZhzFrFFkk3a4wtazs?=
 =?us-ascii?Q?XJ9BY1JrNupqDjbY+TJIz2HDSZ+Zg57U9H3H8Jtbv6fVYVwkaE7fLTgOKolC?=
 =?us-ascii?Q?UCWQjdC/oCoqo8WFO/pZ7DE4Pro9+0Owk3hxQCzJ54gq2OV7/1sIhWAGv656?=
 =?us-ascii?Q?/jIDwR40IpUp8DB27bssiyJ4zdgIqFfPTKx28mse3rtNwOxV2evDqXIRM7wp?=
 =?us-ascii?Q?1WWx6iL5Awn+WlUiMw4DOGiff3jvz9dC9FvCLOst12bi1GjrUotRBRniGXpI?=
 =?us-ascii?Q?iDPSaVNmLt/dfEN1p4L2RrSbEJWR11Y7v5fRIK5Y2xxTL930JIbRBRa5i0lk?=
 =?us-ascii?Q?iAMhYA9S/mYKsKuw9JjfnTXihHdL7vfIV5HqCe8YUguZgHo+z60S8YPX2veq?=
 =?us-ascii?Q?0nwj3iUZigd7UiVUfg6KKT6T?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fcb7ab8-64d2-45b7-a301-08d8cc442088
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:13:45.6748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ppwNg/04Bbi1ZwA7jVMesayP0vnmYH+c/08+8NKzCIMQ5FbWcrfLdd6iuAfQLoy4ja2NKrL06DO/mPSCex3HYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor of_phy_find_device() to use fwnode_phy_find_device().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v5: None
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

