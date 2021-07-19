Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4199B3CE828
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352896AbhGSQi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:38:27 -0400
Received: from mail-eopbgr60064.outbound.protection.outlook.com ([40.107.6.64]:32129
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354997AbhGSQfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 12:35:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6WJaxU/dLVdNDnMuosofMrzNN9FdVmjlt91s5l2EtxeohknaLxg6knfq7GLAjfkjb0howl/KaCGhKIQ5lfBgYgDzfmlUZNtt0IJrklFDcrwGR1agYsFIhGfS6oenVoZODuqy46vWNJMldrsRzzZTROAT5lGSxedjAhthHpkswA2GQIK5iToSApT5723SWvLu5qiNnzlMiszz9n6IymLhdv4CJI/VnNXrxHwUYfp4jO8fKVCPrvOHSKKg342Hx25GiSMqr3uun50djYiB73pI7wirEzgwkAiP4GyiaCSDznimMhddX1lmXef544W9sQuz8t/fx9hg87+GNe2oSe2Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZf5EERXBllj8RqL2dAYh7jEHNvw08hODIGkcIw+Uic=;
 b=fOJ/xRpcs9PTOvh4KHcO9diaBQjPHY4Efgk2GwX+XTXnm8jxIjkyoLry96Q4Zo5VfS2861dodTjHsOpw4l/SKugSTytkddTQAO5i5kMkfig+sySHbGAqPISlqMkEuSJ8rd9eR7nctFtQzUHQC9tkpPGHFP9Mk3YjAp1SzDGXeizCFxKkeR1PZcA3v0rMZhjL6OHlBeY2Vfv/jZXlum1TuADSb2XzKYU88vH+g6o/ZoXTFnJdQ3D/sU/WuP2uYqzwFC9pSon/6XcRkh7541ILVTEV/Dksd9o0HazjOthsfO6UWqLBp+ID6GJNzBGABh/+lnuEjUM6RZdihqZfo+Iy5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZf5EERXBllj8RqL2dAYh7jEHNvw08hODIGkcIw+Uic=;
 b=QtPbeahh37gcWNpOcGjtitEewYU3Rpedjfvyl0DZnx6bs17thVHB9qY9USLd/lW2WVyUMM0AB/3xcEYUU7LNCFnaupaJRqII7jmO6OND2AscuhqV14SxNJymU5w6GgV9ERDAsB8jWCcI1SI8N3oEU4mwb7qS5C8TecervZXIL+I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 17:16:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 17:16:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 03/11] net: dsa: tag_8021q: use symbolic error names
Date:   Mon, 19 Jul 2021 20:14:44 +0300
Message-Id: <20210719171452.463775-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210719171452.463775-1-vladimir.oltean@nxp.com>
References: <20210719171452.463775-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 17:16:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93efa179-bc95-4e94-c70d-08d94ad8e4de
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34072200D54E39B2BF69D766E0E19@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B6qw9E/wxqzH8Qbri8d6rAORyhKQ7HMXpBVCm+b0etQ/vve0AwVYdrIdKSkTNqXSZ8spIFG32O3lNExoH1MQ7Na4Gl/9T40AO9VuuvZUMXPFx/4SCGKiYYP79Gp3NaIsll6JNAl5LbW2iArT4/ihoy0v//XNFBObPISYrtfRXPsnNq7fG+soIMnMKSjb/2bONzugg/Z5Etz2dOp7nYauKQ/VFONWsp1QetepChwLpyO3K+LwAWCwFtVtqc4bxLzd92nqRctnBAaNWemTm4uUJ4W6pkqpDZ6OVOSZ98llkkSTyR1yKQRqS0i1Eq++Ve1txHB1gAalQ14psaoLv4y4Yi+Az7QbawqsoOpaMNx00B3RnUbG1OwDAxKE8Vy5KKumnnoZ3Klu+p8qE9w/XXsmJRULjwezd70LW4w/hcBk3eELnZ80LSm2Omy/byQ5ncHIJT0yBUruJne4GliKLt4W/xAxa6v7aim5ZESvUBVa7n1md5R/i/RZIr+LdBe2QLCV07LQk/ParOAJCwhoLtzae3fvZn/h+mEsbbqq5xIvxmHn2AVyrPlQgaq3U5rrTxFz8edtjUdIbH0UCgjMZgM+qHUCzdUJYebTCO1sq4J1onKF3z+6VUC/PB1LX1LjVc/zPY0nqqP5UfxVuC5NqTSqm77gcNyq9eNzU62XZn81pJQFSff530I7CyKQC04ZfLRaNp7nUKpkE4pt+DBPB85S4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(366004)(136003)(346002)(376002)(6666004)(6512007)(86362001)(36756003)(52116002)(8676002)(8936002)(6506007)(83380400001)(316002)(5660300002)(66476007)(4326008)(66946007)(66556008)(110136005)(2616005)(956004)(1076003)(6486002)(54906003)(38350700002)(478600001)(38100700002)(186003)(44832011)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IUsZ8l9YBhkW8mSfK2BZ4SZHV/t2EtVGztbNorvFR5qRBt6Hpz/D5fuRGhm4?=
 =?us-ascii?Q?bpFeT5u6gJLvgCllD9Y3jtRGbzinNihGb9QEJWE0Y7fwoXVyujkAn6RqhNwq?=
 =?us-ascii?Q?HLK+H5H/0YNFz00I8AUL+eHvfNLUtC/s7lmdHNkA2bjoER+aqqVz4QVwlkqw?=
 =?us-ascii?Q?y5syacO7ZjhBmMQbQuY544d/y25vF5LN1n+WDbj2KZB4+q9+VfobDRdbxtB/?=
 =?us-ascii?Q?biluU5RJ5CkqGk5HZjEMH+CenRD5BFTUu69c7N9FzIcuQNlCE5qh3Z/Vuyfs?=
 =?us-ascii?Q?3oQAUT1vEnISXCim8mrivYHnkH4oC4xn0nC9pH39zsK3ZQWMvF3praPscRa5?=
 =?us-ascii?Q?Ja9vYyuRIorPNZJt/1ww8iXKKVc356XBsVqx4pMh1Z/Uj2rmKDfNBFvJiGBk?=
 =?us-ascii?Q?wfbjhpEenMJa0ymxuW4+7Wd8+NH/apHY/P/71DZiuGiaSCXOPao7aTjep9+j?=
 =?us-ascii?Q?5KVgyK/ZQzMsntPkV/tX2dzP3wBD5NrvdXuExu3tmanpG74j0nqK/U09ljJF?=
 =?us-ascii?Q?smwSwIpXmdBw2++dvnjp0JCji2WP0RABGbxsypYWjBLio+F+Rowf1ouu0SzW?=
 =?us-ascii?Q?zY0oo1QmZNk9FK9P+LzGgPs2RioDMvn98oC6DErSdOZ3qpKPV6XcEVTHE9EJ?=
 =?us-ascii?Q?Xi3oQ22NrkNVnOWMqHGkBUzHPHkqtnE8qsMjdUeDHojPJdg2lwGnNdR5qS2O?=
 =?us-ascii?Q?2eMcdLrXx6v3jOFtL7U6/NHoLlPZrwBVzRtk1OLWwa4QfOp6N2CsfryXwZhp?=
 =?us-ascii?Q?/HH0vJbxeCklxvGEepCs7rk3yEHB0JP/zHUD7oqTeC83sPE3uQVVG0EyCBaQ?=
 =?us-ascii?Q?8EsrQ2APe3C4l3zgn7KzlyVoZzvgL6piwnuDot5lC62pymVnTDGBmzDDYcS5?=
 =?us-ascii?Q?KXzo5L53DPEpOA7qTqO3EyKYHITetg2LSlHQGsqINoz3/5ghu0sVOwItGpW1?=
 =?us-ascii?Q?0bHvRAXhRhvtzTFWSwtKSNm6wjFwzrAJ3rJpGfbPuXvr2H9JzNqfKtVfGYFs?=
 =?us-ascii?Q?0o3rAcz+wC42rRZah6SiuJjMZVfVKCxa+H955s3WJw+exKeW80YsEALkwT9P?=
 =?us-ascii?Q?FYfbEL2O/ss0Ghv5zJz1xH0B3aJP85gmX3dXCgJ6K7RSvUuTQdl1HC5Fofz7?=
 =?us-ascii?Q?2+7sO21VY6iraH1SW5pKfL0beydW8lndlSsBu2HSDEAyDmrNjXpro2cWKqH7?=
 =?us-ascii?Q?AYj2NluljRThm/LJQGtTSMHTI79XYg63vPALvKG8Bz4ZhXPt7QQYSQqDUNr/?=
 =?us-ascii?Q?PV6r255StYfgJ1T6cX0HqxBKz1v7gNPj15SH0WnX8ElPnigpN+mMrULv15PK?=
 =?us-ascii?Q?qIiVlusiucKc3V8BkvYzKeyM?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93efa179-bc95-4e94-c70d-08d94ad8e4de
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 17:16:06.4411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0g36G4poRLfF1+r1ggNfK5/ZE/HQJkXpQD1niG3J59nOC+X93Ps+s3bcfij6ak+Tc7GV+Z9Owdc2Sp/2tkl44g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use %pe to give the user a string holding the error code instead of just
a number.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_8021q.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 1c5a32019773..3a25b7b1ba50 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -214,8 +214,8 @@ static int dsa_8021q_setup_port(struct dsa_8021q_context *ctx, int port,
 		err = dsa_8021q_vid_apply(ctx, i, rx_vid, flags, enabled);
 		if (err) {
 			dev_err(ctx->ds->dev,
-				"Failed to apply RX VID %d to port %d: %d\n",
-				rx_vid, port, err);
+				"Failed to apply RX VID %d to port %d: %pe\n",
+				rx_vid, port, ERR_PTR(err));
 			return err;
 		}
 	}
@@ -226,8 +226,8 @@ static int dsa_8021q_setup_port(struct dsa_8021q_context *ctx, int port,
 	err = dsa_8021q_vid_apply(ctx, upstream, rx_vid, 0, enabled);
 	if (err) {
 		dev_err(ctx->ds->dev,
-			"Failed to apply RX VID %d to port %d: %d\n",
-			rx_vid, port, err);
+			"Failed to apply RX VID %d to port %d: %pe\n",
+			rx_vid, port, ERR_PTR(err));
 		return err;
 	}
 
@@ -242,15 +242,15 @@ static int dsa_8021q_setup_port(struct dsa_8021q_context *ctx, int port,
 				  enabled);
 	if (err) {
 		dev_err(ctx->ds->dev,
-			"Failed to apply TX VID %d on port %d: %d\n",
-			tx_vid, port, err);
+			"Failed to apply TX VID %d on port %d: %pe\n",
+			tx_vid, port, ERR_PTR(err));
 		return err;
 	}
 	err = dsa_8021q_vid_apply(ctx, upstream, tx_vid, 0, enabled);
 	if (err) {
 		dev_err(ctx->ds->dev,
-			"Failed to apply TX VID %d on port %d: %d\n",
-			tx_vid, upstream, err);
+			"Failed to apply TX VID %d on port %d: %pe\n",
+			tx_vid, upstream, ERR_PTR(err));
 		return err;
 	}
 
@@ -267,8 +267,8 @@ int dsa_8021q_setup(struct dsa_8021q_context *ctx, bool enabled)
 		err = dsa_8021q_setup_port(ctx, port, enabled);
 		if (err < 0) {
 			dev_err(ctx->ds->dev,
-				"Failed to setup VLAN tagging for port %d: %d\n",
-				port, err);
+				"Failed to setup VLAN tagging for port %d: %pe\n",
+				port, ERR_PTR(err));
 			return err;
 		}
 	}
-- 
2.25.1

