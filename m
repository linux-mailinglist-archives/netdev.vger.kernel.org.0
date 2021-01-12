Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14AE02F31F2
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731523AbhALNms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:42:48 -0500
Received: from mail-eopbgr130055.outbound.protection.outlook.com ([40.107.13.55]:1476
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726714AbhALNml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:42:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itGMdzPABJmeepj2KDB/D/sulxbke2qOn43m3Yol7YRIismPljrBOkgnHcrLCE8t+Z7aJ9WY7r1d6xZ2P6hHoB3TAS7AXRB5z+mKAYIbjMWoMzlLqnxB7K+o8QJ1W/Q+OfIioWbSa2QDT8BQPW9ibhTgBwO+r+LjkvKf05G8PrSLlvOBKzBNo6HlYtYeX/EKIrsDfmrOu8AlOaiou01NiNxDHk72aZiiczmRS8n0tNEX0QnoDeDmxedkEuFwcvqwRk00cwRknVLyHR2hZy+iz/6LSUCdq/ofAJhYgubE88FTQ7sMoLKaebhV3PX3V5PvSykpruReV3FcBCCaVGBPbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/GZYEKwN2XEO7X3Ja85i44fA9G+dbp4sg/xUjpRGgw=;
 b=L+Fmm60Icec2l9/cxcaLs7/5Sx3COLJjjrYh9IwLNTRYyRpuT+lKQP3eJUrQO/6MXZmeJ/Fd44TwTANzAgh0rGflqoH1a96R4JYFlfBkbJUnp0DFvBKwaIPidYqcFLU4aZYG4q/ReePjkL/WcEQx42a4PKGKMZ4dkK5byRum3bE1mYNUHH5VEaKNbhdNxPS3pYGMfVfzNfqBBl0hHyP0C3uxXGqkMfdXlWlR+JtTB6B7yJ0tbniNWw9qlcXD9MYWw0e8VZlB34+VvHovIIBSgNQkHh0P7ox1PcWRtswJsV8A0wZ0c/l0PCu0uLcCdRXPAZ1pVaZdqc36jyPqdXCO+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/GZYEKwN2XEO7X3Ja85i44fA9G+dbp4sg/xUjpRGgw=;
 b=mYMsyIIRVl/12sAilqd5ozTyE3t/5CrLeN+E4IqJLWlVZGLTlA0BrMbFJEune9WV/zOAdjRdhT8/Wueq9AWR3GPfHT8dr2pV/I37bvWd2LM4pkkDHdDX1JMO8WO/KdfPAH6xelQtRazqkQZbv4xDTXqxB5x4YtQv/htWZsxhaOs=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6964.eurprd04.prod.outlook.com (2603:10a6:208:18a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 13:42:13 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 13:42:13 +0000
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
        Jon <jon@solid-run.com>
Cc:     Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v3 06/15] of: mdio: Refactor of_get_phy_id()
Date:   Tue, 12 Jan 2021 19:10:45 +0530
Message-Id: <20210112134054.342-7-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:3:18::35) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0047.apcprd02.prod.outlook.com (2603:1096:3:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 13:42:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b0435022-5da2-4071-054b-08d8b6ffde3a
X-MS-TrafficTypeDiagnostic: AM0PR04MB6964:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB696406D54F2D42CCAEFABE2AD2AA0@AM0PR04MB6964.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /I1Zmm0yazXPo5q11rvLOyxaWR6ABfmoIEExhQ6HdBtCQ7GOsnuAS+ZoigOfIT8hDqPQw9WOI+HSEy07jLJdDWHbwAktZV547HflT/XdKtDYLUtJYlTkfmlp5rLnBEgnXC9hgvUKanjbJOCqdFNJ4CoaiBF2b+PHb3B0AjaeHLVj1AlRHaejcXZs8Yzzi4wKw42sB6KIjhOFw5zVgKH+ywG0MWi95p7cxMH8KXV5BpL1wwbGrOJ9TxJLIQc7xP2lMBrpQCTz5YaQgWtO34EMpW66cwCWN0C+KvaoMAfYiEV2OMWrixGN68/aArLiVMt5WprysvD+BWhqIzJelxC+G3olZiBCIocmH/c6OAUudDo/f+oQuJvog1leAErL6QSm8KUJT9feeQSpCRWIBDJPVeQ92XGOkUfHEiZdubfmpBVr1yhZEzqUAykY7SKtLle9ycYE+2X143z9mdbm29NclQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(376002)(136003)(396003)(366004)(1076003)(6512007)(7416002)(1006002)(5660300002)(52116002)(6666004)(8936002)(6506007)(16526019)(186003)(26005)(55236004)(66476007)(83380400001)(921005)(478600001)(66946007)(66556008)(6486002)(8676002)(86362001)(44832011)(2906002)(110136005)(2616005)(4326008)(956004)(54906003)(316002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VOFXFs3zh19u6dH3KiFJ/r5J0++9RGmsDNt58+qBbMCu3KYjLOKuOYlotF54?=
 =?us-ascii?Q?MXPCApOQiJSQ7H8dMvhh/eUTVbbPSbRc9gihDi2jEZgsz5bp/VuD6T+QwIii?=
 =?us-ascii?Q?yD52AGCacTbVgY7tTUUVWuuFfZlFgucJOsU9tvj6WOkIabDoIQA23FLg+Hqw?=
 =?us-ascii?Q?XzSmKY4cHQ48iCus53vNfbTG5Qz8ebpGj7edY4DIklmjKeADrs8RfMV8PWCP?=
 =?us-ascii?Q?ATY2TSTO2NcG2Z9P6BOuFO31HlHUCZijmdxidRDl2QdGeOlenJWHtPeWO9hH?=
 =?us-ascii?Q?OyfSUyufuVerE44Y9AZuy1NWKEh9Xdl5siXYwdklwd15PKR0Fp7HQeDM+AqS?=
 =?us-ascii?Q?XIjkXjBi6mRZNEtRXdR1/xwsbAOI57SLXlPYGPhJdN/3zXN75Jdnl/XTnhTt?=
 =?us-ascii?Q?KIR8zDNQGH+prkxSCyzCOpdeu1QTJlnK7K/Sg79qrNSEckqd6gkERKAj1Kmb?=
 =?us-ascii?Q?ZCuUQZV35zz9wCLMBcM9nexEULXz6MMiOh6Nlo8pBgJi5/o1R0Fn7OLRUBnI?=
 =?us-ascii?Q?MLvcLSB9TJP6Z2Lrt9CLw8iZn8bYi/gyMkjsIYEjFIHsR/LA8F//hgxSK93O?=
 =?us-ascii?Q?ycvlQLBUgoF5HZl1B+IpcYPJQpJ8d4MH1sVwanZETM+ykYwmzxgdmc8V9zRJ?=
 =?us-ascii?Q?n05Z3nD0k+/hhOppxXigmGz1dJ6lTF/KCVjow1lrMhRPnBArVTJRAFpEkXK+?=
 =?us-ascii?Q?80CgW51wfSH8QYew4AcIwP+BUvGLIYOym7QCkJTKI+t4hYOiZCSiC5Sjrzxj?=
 =?us-ascii?Q?E/TcFxVYlslG4W+r3CnEIr2zlSf8OET/uoQx/OODnPzylc+73dcWue7eoZxC?=
 =?us-ascii?Q?jgIPg7xE13K9NZAQdM5SPoADJgkHzTUYQIOHLkOpzWcLfoTRlZIK/CYMA9gE?=
 =?us-ascii?Q?JiV6iPBrnR0X7ikORWaSj8Dz1f7vWQ/Tk89H64/ibyb3Ftg1g8TUY6GYMChv?=
 =?us-ascii?Q?bu4i8FQfpTzQ/rtY9nyz7OydCYz5s4BqZfDT0XrLFmqUcATxpCNloVYNzdf8?=
 =?us-ascii?Q?ujDT?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 13:42:13.3155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: b0435022-5da2-4071-054b-08d8b6ffde3a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b4JjjWawT0yFrAgsoy78B0Qgj2dTtpHzKi69NhV0RW8bIPmF38xWZq/bnbBqqtp26IGSuxhPjWKLlpAhHqueRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6964
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the introduction of fwnode_get_phy_id(), refactor of_get_phy_id()
to use fwnode equivalent.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

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

