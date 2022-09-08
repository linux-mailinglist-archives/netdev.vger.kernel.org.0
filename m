Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233875B23EC
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbiIHQuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiIHQtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:49:23 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60072.outbound.protection.outlook.com [40.107.6.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACF112950E;
        Thu,  8 Sep 2022 09:49:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aDmZeX5c8KgNPCot3SjGuXCSrjpF5/EQpaxCkL0Fsg7gwlPCfSYBI2sOk9sHX7m/CIEeMvocJf9dqRs2AVnWt2sHPAvVxpxooWCyZpHy7pw1mO0vJXwWyTMo6youzeIpmwF3c5uUdbG3t8OSMbVQXkQ+VHGPhDvz4FG9Lq27KFn1suR4hLYhNu6j1EVlwB5Gmlc/Ibz2d69GTobqjX1vRa7bLysCMeVWGdfsx+lxCEgOkqLWCVkZnuAKIete5rpki3hAwIIxK2343bukMFaKnjIVsqWDoaO2RZzLFSELmimVHpNAZPl+wQsljDZBeymhx4r9twYB509l9rOT7umrmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zOmORmOPPS+er3uZOA5Qky4mvzw44WhH855XFJBfPAU=;
 b=ASoJeo9Qw2cI89OsEse8KOuuHBuQsK0kdcOL/SdmM5/gTQOpCZsRBmvAx6lPsswxrH86dPIdGQk5bf47LcyQASTN4iwwVc8cqV7ki0QW7JNxnxzH/mMvW5rSv9x84Ha5orjSPKl5Vtb9Y6mVl30Sx3aLsLxlR7wQus+ZkGtQB8ocm5PAu4tLlU8pI2F0SgcCP/NRSkgLTkOHcsYtK0zSXy4fc6BfMXVROehGquQTms+d+0m7Wh1DZAw/GMb0vDUPHBN0bz55r4Ex2b+ayKzEJb2VCUX9gzitf4ceWS/4oDZxn5IlXO+ga/rWkEqzdwobymOU3fgyKjj5Qsg+J2P8Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOmORmOPPS+er3uZOA5Qky4mvzw44WhH855XFJBfPAU=;
 b=kdXbxDhzKom/spLTxPUjhxaFcUU+wRQHtECpzZZONRApzt1fmJmsY493XElkPSk/1yaWM97iSazaMiW5uXe4X+ceWCly6wGLl+OiaF+Yxz7al8dsAFCxgfTDzUxOfsPQncLsJ4+xSJwpF5hLPckpDbSENeAvzagfWSCplYi4vJw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5052.eurprd04.prod.outlook.com (2603:10a6:10:1b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 16:49:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 16:49:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 12/14] net: mscc: ocelot: harmonize names of SYS_COUNT_TX_AGING and OCELOT_STAT_TX_AGED
Date:   Thu,  8 Sep 2022 19:48:14 +0300
Message-Id: <20220908164816.3576795-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
References: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 766dc45a-c93c-472a-b210-08da91b9fcbd
X-MS-TrafficTypeDiagnostic: DB7PR04MB5052:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dg44Gb2QK9coMKhyH/DiQvrA//veion5MU+qf8zuAK9KD8x3jpLRt3vfqKzAiGJO2pJhVOgWeSaLhSWSuaTbySVAWx/aC2GGl9zrR9BBS7ektM66cefZFS/LUFH2jGImRCw222+gAtXFRsukTXbo36ydZTMrVNpTWk5B+TCNOGVKog1LKJZ0iwiUFWn+fc32kV6WAWu0VAj1ZCurQcDumHHWl9cwftC0VmOkKj2gs8ZLlM9eYb/RK0NzypHllEio22PW6c1HMkRSYm8JQv1akO6Y8IwCOcTnHzZhIJRvfRhjYu3xUZLSAGWyvlODldJqwFyrLdmjJjwR8naVjb7YGtKL/xLmKqdpMFBtHFHCBcmtxyqng2rli25U/UwPHoD/FvcVvneqHDNjcHJI1Tvs5FBC/iL5VdHPAU6LUh8rmza1Nfn3ppjB2jyLl5x9afm+EZrZZziXBxNNgRimTcWzGf+vgyjEAyrHXVteJOyxrDCEhVkPEwbPCj2A+VhFEKfB+T9M48N6ADdYOFgEb/a6KDpgA2GocClskDqPxl8TQePcwjTpvl+5V0V2GXnyTKMetdWJRBVGnOqaMP9H96J3g2h6FO/N+qFK9oXOdeNeqBmbPPsYhDNTVp6aXXxjHnt+YrDFs+dW06LvvzZNw/kxRZFBniHB71aMfx/px82EaKyusWAwJ2JL2foZpxP/ufPUzdwSSVfJqEAxNSMQqGafaxPAUQRS0jc5dp/kUIb3P18VgVFUPSX/MJlh8RZNjmCml5nJMNwY9ju893vepO3ZjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(38350700002)(8676002)(66476007)(66946007)(2616005)(6486002)(186003)(66556008)(38100700002)(36756003)(1076003)(4326008)(478600001)(83380400001)(8936002)(2906002)(5660300002)(44832011)(7416002)(52116002)(41300700001)(6506007)(6916009)(26005)(54906003)(6512007)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PijMBkDK3ujKsFmRiEyWo/3q6dX4BtQprz9+R8g4LTsMcC5W4ENd5wIn1OFI?=
 =?us-ascii?Q?8/NoeJty+E7fRKqcydD5+qwSUUSycoGDaufrGjKzCst2RnzgWFXYrcuyy7gA?=
 =?us-ascii?Q?qKnKOcAJSKqVdbKPjNS4h/+kA5qtbkwSEBx251qbGhF5wyipnso8KVXJTG00?=
 =?us-ascii?Q?1T7MI+GsiLTU75PmRJv7Moqz1ijIuFb8UxTU8t41/Kteon16dkdPlxr3Qf8/?=
 =?us-ascii?Q?Q0qukv42CkCay32YuyiRJ8puUZV9LF6Auxw0VfrU4a65BAE0TTg4Hzl2QY8+?=
 =?us-ascii?Q?lsAzsi5nVtpfswGEJN0lNGPPO5bbXZxTk1t3+CpQZmfXfvRd5W8BfJ4So8WW?=
 =?us-ascii?Q?lKJXCcLs93oOyCGHUHj4SWfQFRSFr3goDNeavzoXmgyNT5fr3DI80y/E//L9?=
 =?us-ascii?Q?x3QNLOFjbBblV6BWWZfGUTyXLhmX6xRkPbBuLZPpXC5mq18P2ke3ZzfxWz6E?=
 =?us-ascii?Q?7W/t2gkoyTZfnC4x4zasa7vuijTrf41IuWKt8WpjlK8ZN8IKG4loWOt8fy0f?=
 =?us-ascii?Q?frpeelvQek5Hevj7i9OhwloAudcRiRkUNO/w3uO/Ttz9C35j/+iOj/yVQOZV?=
 =?us-ascii?Q?NdNv33Yz8egOi3BiwTsb9gvWBf9GYFh/sEhln+MbKsua889D45PVxVSvPsK3?=
 =?us-ascii?Q?cHc8eZ6wZ2mOojTME8Dm3Ez6zuXelnonof7PPLxg4iUzLb8mjz8g71CUxJB7?=
 =?us-ascii?Q?/ExDbICu8XTOjiNDHY+I4Lu9KDtIKQudAqe3b0w04u5NREQLQBG3evfvKLsH?=
 =?us-ascii?Q?FDnCQmU52eES+HJCCw7zmnTr5k55wmvXxGtKSIfJBXTLcG7YgUQnOh293B+2?=
 =?us-ascii?Q?/6hI5YjnApNVVqvJTHtuGbv8ZdrRoV07F6SkKRC2AgDzT9Xf8P5ec5ZBzbt0?=
 =?us-ascii?Q?G/g4DunXNmKD24lHBW115iRV1N+bi9SvLlyhfD5RrPPUhM5CsP10oaMYsSgQ?=
 =?us-ascii?Q?RBqyS0hvj2R90/Hdkdr5OpPZPsXWkVSWG8Rtkrw1yllAmy28gHb3ivSJxFxP?=
 =?us-ascii?Q?0G8RVNIx9aw9ms4U9OgbamjQ5j9Ya4/9dlo9hKGbFnblQcYSzGFGHRuOPS/Q?=
 =?us-ascii?Q?2oQ1UHUH/APVw7Q9q5e9KDGh+k9LlfoyQm0YjPQ3+jmL6EQAGgXYPsuLw2/j?=
 =?us-ascii?Q?FGggtIksezx4Px2cmlXqjufi6jkY+anrhzzm5xTVoHAaE6gHxPFICFSsNfLn?=
 =?us-ascii?Q?nmq0Dq4hJbm7+Vv1ibl26py7T765yDAsehB6MrTHd736zPTiSA7eWeoDxuBW?=
 =?us-ascii?Q?dJQoNUF6tqXP+BIW7unA4PPUdHflzlWOERG9jf2ojicC5/+KKm0m2zVBOvF2?=
 =?us-ascii?Q?iChva2QMQpi/y8dIAKTEHw9xo0vaqu7aBU64vAU3s/wvDGdh7c7lfiJRlgp8?=
 =?us-ascii?Q?XNWmyrWUfdzatV95iEFbsJx0/WY6zMy+Zyx6tTuekIRXIMNG+q61vKP/bO4W?=
 =?us-ascii?Q?/oU0HrcgecnaOF/gh9GDroi2HYWd+BNvv7j6KNTgegBcMSW1f6vX15JcUhU3?=
 =?us-ascii?Q?kkeZ26p51CFphUHHYvwt49mvYvYi3o5Bg1JYtlY818Uwv/GrfGfqL3nzKc4L?=
 =?us-ascii?Q?S8gmPRMLkCP3VdYXnUq0jbpM9URtFNgVEqEl+lQ7C7TpfR5ZDcZjgyFuoxK0?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 766dc45a-c93c-472a-b210-08da91b9fcbd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:48:42.3645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +T5OCA+aoonbGwcTrkSe4IPVahAeVQUVldvOkbe/RWj5MTHr9X87CiP1LnPnqfzdUQXEXCZJtCLtiustT1ocVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5052
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware counter is called C_TX_AGED, so rename SYS_COUNT_TX_AGING
to SYS_COUNT_TX_AGED. This will become important since we want to
minimize the way in which we declare struct ocelot_stat_layout elements,
using the C preprocessor.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 4 ++--
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 4 ++--
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 2 +-
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 2 +-
 include/soc/mscc/ocelot.h                  | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index b56aad84b6cb..c8377a79d5ec 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -347,7 +347,7 @@ static const u32 vsc9959_sys_regmap[] = {
 	REG(SYS_COUNT_TX_GREEN_PRIO_5,		0x00026c),
 	REG(SYS_COUNT_TX_GREEN_PRIO_6,		0x000270),
 	REG(SYS_COUNT_TX_GREEN_PRIO_7,		0x000274),
-	REG(SYS_COUNT_TX_AGING,			0x000278),
+	REG(SYS_COUNT_TX_AGED,			0x000278),
 	REG(SYS_COUNT_DROP_LOCAL,		0x000400),
 	REG(SYS_COUNT_DROP_TAIL,		0x000404),
 	REG(SYS_COUNT_DROP_YELLOW_PRIO_0,	0x000408),
@@ -920,7 +920,7 @@ static const struct ocelot_stat_layout vsc9959_stats_layout[OCELOT_NUM_STATS] =
 	},
 	[OCELOT_STAT_TX_AGED] = {
 		.name = "tx_aged",
-		.reg = SYS_COUNT_TX_AGING,
+		.reg = SYS_COUNT_TX_AGED,
 	},
 	[OCELOT_STAT_DROP_LOCAL] = {
 		.name = "drop_local",
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 26fdd0d90724..5799c4e50e36 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -343,7 +343,7 @@ static const u32 vsc9953_sys_regmap[] = {
 	REG(SYS_COUNT_TX_GREEN_PRIO_5,		0x00016c),
 	REG(SYS_COUNT_TX_GREEN_PRIO_6,		0x000170),
 	REG(SYS_COUNT_TX_GREEN_PRIO_7,		0x000174),
-	REG(SYS_COUNT_TX_AGING,			0x000178),
+	REG(SYS_COUNT_TX_AGED,			0x000178),
 	REG(SYS_COUNT_DROP_LOCAL,		0x000200),
 	REG(SYS_COUNT_DROP_TAIL,		0x000204),
 	REG(SYS_COUNT_DROP_YELLOW_PRIO_0,	0x000208),
@@ -912,7 +912,7 @@ static const struct ocelot_stat_layout vsc9953_stats_layout[OCELOT_NUM_STATS] =
 	},
 	[OCELOT_STAT_TX_AGED] = {
 		.name = "tx_aged",
-		.reg = SYS_COUNT_TX_AGING,
+		.reg = SYS_COUNT_TX_AGED,
 	},
 	[OCELOT_STAT_DROP_LOCAL] = {
 		.name = "drop_local",
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 9c488953f541..fc1c890e3db1 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -395,7 +395,7 @@ static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
 	},
 	[OCELOT_STAT_TX_AGED] = {
 		.name = "tx_aged",
-		.reg = SYS_COUNT_TX_AGING,
+		.reg = SYS_COUNT_TX_AGED,
 	},
 	[OCELOT_STAT_DROP_LOCAL] = {
 		.name = "drop_local",
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index bd062203a6b2..9d2d3e13cacf 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -242,7 +242,7 @@ const u32 vsc7514_sys_regmap[] = {
 	REG(SYS_COUNT_TX_GREEN_PRIO_5,			0x00016c),
 	REG(SYS_COUNT_TX_GREEN_PRIO_6,			0x000170),
 	REG(SYS_COUNT_TX_GREEN_PRIO_7,			0x000174),
-	REG(SYS_COUNT_TX_AGING,				0x000178),
+	REG(SYS_COUNT_TX_AGED,				0x000178),
 	REG(SYS_COUNT_DROP_LOCAL,			0x000200),
 	REG(SYS_COUNT_DROP_TAIL,			0x000204),
 	REG(SYS_COUNT_DROP_YELLOW_PRIO_0,		0x000208),
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 050e142518e6..860ec592c689 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -392,7 +392,7 @@ enum ocelot_reg {
 	SYS_COUNT_TX_GREEN_PRIO_5,
 	SYS_COUNT_TX_GREEN_PRIO_6,
 	SYS_COUNT_TX_GREEN_PRIO_7,
-	SYS_COUNT_TX_AGING,
+	SYS_COUNT_TX_AGED,
 	SYS_COUNT_DROP_LOCAL,
 	SYS_COUNT_DROP_TAIL,
 	SYS_COUNT_DROP_YELLOW_PRIO_0,
-- 
2.34.1

