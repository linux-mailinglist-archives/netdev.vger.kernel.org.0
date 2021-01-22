Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64A23007B7
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbhAVPrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:47:04 -0500
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:4995
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728799AbhAVPpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:45:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HkOhaRzFP7UnooryvegT2FioHU+6mExs+U/S5WE5vxKJV93kOzPQXM1Og43ySaAJ4LrlOBuk6HDU1Sjv+Yv9AX0htNm9V4gZmcBWnAdtghXJQcfFB7Kcq3VOB3x5UK5wyMnGKEp2CmlidGOHPQp0oTdxqKBIPm5cSe3jiJPG3L/KcC4FMss9qxORuUkAYwoeDlRKCILVgz7/9WPh8Sf2rqkr8+V4q2K09gjNo6HzwaFZCQ4dI3/y2HOKLvLr7RaKGpgyOxV/VEqo/TT3ZOwyAMPUuLVARPHvCE46p0lHvO2JBan4oh+FsOibhUCz3BMK5q+H1Uhh5r3IoKNJblMqdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWihxsSG68im8fYDBPXbGyUw7gtTYotk1PRlSVJCg8w=;
 b=WLCZOX5dPWuTIL8LRlov+VTXwCTgTqGuiZZgqKm1+9f6rUarV1pwGwxiKcz3iwvbFbuFRc4igt+QVQIshwxFJMFOc3by2VhwCPnrxARl9axMSb6Lu1OCi6p6dRkvcZpkIhn8eklDGjxSyMcOJWuCxL/BrBDf0gF0590AWqij3v+h1tWvzWKR5aZ3yjDtu2ZPxh7FN9LF2oM8mrj9x2QH/4xurxKQnn+SE0vWuM5O7eHGaYNTQttQoAYdd4ofutCZV0kh2XbyHB98EM17PiKu9uV/aKwQF3OS1RO+zf5CHho8bLM1qtwroAujxxp8lw+GkBhCaXIvJOe25mEmCGGogw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWihxsSG68im8fYDBPXbGyUw7gtTYotk1PRlSVJCg8w=;
 b=g4BXIBPCA6PJuxVQA0APZgx1cD44zef8wcnGLU60etidaqwTexUMsG4dntRNLxZeXJAL5dSzab+xv+pMDulmyoh7NwTkqujm/5nNu3EQamf7scvOmne6oBZGVOk8DIYVNU9HYGlgrIskYUIWd2FEQGeMqhzW2HzIhhg8LcUPx1c=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 15:44:24 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 15:44:24 +0000
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
Subject: [net-next PATCH v4 06/15] of: mdio: Refactor of_get_phy_id()
Date:   Fri, 22 Jan 2021 21:12:51 +0530
Message-Id: <20210122154300.7628-7-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0117.apcprd06.prod.outlook.com (2603:1096:1:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 15:44:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d0f34664-4015-4456-7c9f-08d8beec9772
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3443967F8B6CC55BBD3882A0D2A00@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RhZZ+ZW0Xxv+Qq/0TcmwfdlsF4pI5qp2h2eNz+GCQFEHUMGJOFEBiGkT6+g81cFjp5l6yFmIIx5AttxLRMBGNRsT3ZwsAiYXwhzJXE2IlapCVsE2BPUJS0q/XahGGLgigUrnzuBAjMrtyQcLAVyRgi1KjxIlyx++0LSAolV0TG5qVbZi9JJyWe8XV8905NXkdTWokn9o0p7vUYcXtoNSUVJ3q4y2A3EKIY9Ha2yJgMLNfwNaf1J+yZS9iID9nlwx6ULfsu5iu81CABmgdbai30H2RlmOWmZQb3/+DR4kXcon1fWFGi1B8HbxsWZcGV93RcH4t95/N2Wwp20B+1/QQ2j4HRFkA2KTDFazmM2nRzT5FYOE1ULApoUN0Aov6iK3YeZKvClilEpDUx4sdMBwceP6lgWSONgDXdKRzy3RisBirk7HD12nApXtbQKpBAq4ezxFUo+QqUgD0xTm5ecS8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(2906002)(6506007)(921005)(6512007)(6666004)(186003)(5660300002)(1006002)(16526019)(52116002)(54906003)(956004)(55236004)(8676002)(66556008)(8936002)(83380400001)(66476007)(2616005)(66946007)(1076003)(478600001)(26005)(110136005)(86362001)(316002)(7416002)(4326008)(6486002)(44832011)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eZLixcoVJENL4yJgNSq25sir1V7Q8iJ/nk2oNNAeOLhq1X3dmVVn4qIK6Ku4?=
 =?us-ascii?Q?lHEfhy7EKCxMzATme9PnGkXPU5ZoJnCY5XGBBJ/DgOjq5oKJoi3ZoYTRBBVz?=
 =?us-ascii?Q?iRB/DYyk8+z/t0x/961G9Ps7PxXhnscIoduClvY7+O6bCJFXqJKGTwmZtIiT?=
 =?us-ascii?Q?6Qdp48GcZ34c72vyBSabJNl9e3XrpFNUdS2QSt6XmEf0dwsoGH1gKOpQfPnH?=
 =?us-ascii?Q?bz5IBVq6Gkr5bulx+lJjr2pKwbmWpuKxWF06eblmV891R8t4BzwpI07LdAUF?=
 =?us-ascii?Q?2BhMJGZASMQYjdZhv6nqNLo20tmdEJxxUtUaun/aDkrz5puOiiV+s4Sg/fYp?=
 =?us-ascii?Q?H2QLzw4t8HAG4XtU5E9en8wTetTWSKW8AdFxm5WYaGWf4FlF8i9tXRRJAPSL?=
 =?us-ascii?Q?Goq3LOF9gzwlJTbPeHmJo7i5fmrCZNKDm1NZwkXCnJb7ayq/uAvExKUw7hxo?=
 =?us-ascii?Q?saNwIrbG8cwAJM8e/1ui04gntOEwv3YUwwB5cdmWOjIbshuHrnYRoPabF5le?=
 =?us-ascii?Q?OajrStZM7gVZq890fC+XcwzBNnyDmHQm/LpOFc6yKkLV5ihEsDRBQtFSkqCE?=
 =?us-ascii?Q?QG0ZajsvR3Re5EyZcwIwxfFN74b+uBhtf9VcP++qRO5yKhWSwQYlIcKquzLK?=
 =?us-ascii?Q?xtOwDOKWF8c50qSd8tzBoeQ9Tk6O8LX+HqYDyrZFv3DVZKn9lYkRj3gybf16?=
 =?us-ascii?Q?c+nfC5bYloV6uJGaJoqodHiT1eLO4/GxpjKAYaMpVeHKr7BLv9ge6GZuSpo7?=
 =?us-ascii?Q?Z6GWKdwPDrnXOhaxOxaxurFD9e30MpJKwMc6RDKEdYo6yi4kS1ZN8orIQ+z9?=
 =?us-ascii?Q?LpIa1VbdwWg+Fp2pQtyYB47u0/XtLANyrd6QtKa6wKkxUmf9vaKt0xEyD7+m?=
 =?us-ascii?Q?8eR/qFgmTE5jkCzFcDaJwZjDU+qsFcv0Php4IJtf48ctF1N5vLu4GC1fXTXD?=
 =?us-ascii?Q?kbyaVwW6FCJD8Dp0SDED1DJi6p+kzkBBYO7WrE4hzqUS8PWwYJJpNsDNn/M4?=
 =?us-ascii?Q?LbopK/kRXP8Yj4KsGgM7i+Nhu/Y5J+1OYi5OZcKQHp6Xj53TMhlHk48JmzcO?=
 =?us-ascii?Q?gHeV3F6y?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0f34664-4015-4456-7c9f-08d8beec9772
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 15:44:24.3652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mT70GdF3NNuUjltCOpR3Kht8FiaJXZt05aUNEXaRxCCd0QAs9qb3XZP9/NUNC4cxQm1k1K+VDEWfSllH3qmCuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the introduction of fwnode_get_phy_id(), refactor of_get_phy_id()
to use fwnode equivalent.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 94ec421dd91b..d4cc293358f7 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -29,17 +29,7 @@ MODULE_LICENSE("GPL");
  * ethernet-phy-idAAAA.BBBB */
 static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 {
-	struct property *prop;
-	const char *cp;
-	unsigned int upper, lower;
-
-	of_property_for_each_string(device, "compatible", prop, cp) {
-		if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
-			*phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
-			return 0;
-		}
-	}
-	return -EINVAL;
+	return fwnode_get_phy_id(of_fwnode_handle(device), phy_id);
 }
 
 static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
-- 
2.17.1

