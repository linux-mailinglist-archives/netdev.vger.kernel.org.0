Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7DB3C5F2E
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbhGLPZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:48 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:46304
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235445AbhGLPZb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IyUY2NGUwzx/ahy6YAjR6xCyjOeFhrJjzvh3PPlJiUaeKakUJXfVqoFRZeq3Ait19XmQ8RRnewRTj83ZBymRPx1EnLP4ANtxOdt1i5Rv9F7neLpU+E7ZFyiVI9SR5qS/Y1x+Q4xPH6z4XgUgIrkSV91p4xJAVeZXgcZCW4ocqhJaayLpAqWhVB0NRUlSyqaBPJo65+D4zP5PE8mmNBuXNr2s1eBoA0p9sQf9uoQsiWrxqyYRWxzRlzpFIcWYCq5FfM7ovtb7ckyAlDcMfljTnhC9tg72NAnpTCvfg71x44rR7AdP0zyrZtcG2Zyh6ffCZjZmv76tHwu02s3db3W33A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YcXpR57JCcAMQ9q/jdIeT5Ev/nTHUqZD/rJq1Q8j8q4=;
 b=T5w8htG5G/yAYl7NxFBA4hXlSBB+w5w+stVrMtPzLmR5Wzj94Va9L99a4mlMyc1ytLyXyh6eKUKp11AzxK7iCVhagThzFdEPr7Bn28X5k9qBwBr0JIiMERc8JOfSvQEB2GBylckUZc7f2qZX6k7vK7EvJlrxCJB2s9MkhyWgVU+E0eUuiOe5T0B+2zxKPK2ss3Z6VZYG/1tGZBG0IwJIgwAIoVKI0VgjPDw4627Z9pEHf3gt2913I0mhLmduU6YbAU2Z6KF+bwr1L60PjzJuQuBGBu9HQFnKo1lUf8rJp58ranUWGMYVmlRrZRb2vrMMiPnYc0RzqxBRNqCFvOJ3rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YcXpR57JCcAMQ9q/jdIeT5Ev/nTHUqZD/rJq1Q8j8q4=;
 b=dHfunPyJGNSuNRomavHpUVq3K00au5jrAe9unexPM7GFLGdWz6H0c7vF42DVllnoJ8zJGlmXdY4qsD9A522yEc4ImSc1TlmN6E44TGcCQi0m+wuFupjNDwmzFhY/XKBxLHYc47pqUZlNqf7qB38oL7tPMcQqaJNXHi6YOPG0378=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 21/24] net: dsa: track the number of switches in a tree
Date:   Mon, 12 Jul 2021 18:21:39 +0300
Message-Id: <20210712152142.800651-22-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5401af4b-68e8-4214-d5a9-08d94548e0e7
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB627162A7400327DCD5615C73E0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0qtLKxFDNjE6tkbZBjaR/BLBqEA2+rt+ussgXPHgNRiudY8vu1Q/mMpUdXmjFw6L5VrJmujK+O63En5UnWOP2FBrXvpQuFLH0Og0cGPWiyWaZgU1/XY+bY8CYvRL346h9NHtu4eXm7reWyez9SKxXbCl4+UrPAobjn6y/kijYPFqGcjgkm7A3ZK8jQzx5eEOd42j8+poD8AJ8JaKDDjWKukWA4fo+w7jEC/v9BnbsY/ekmVt/JUACHBYbBVQ5du+AFln0GJoUQqybhoBblASCSY4DhQxhiOO9UcBLzmPImDgAYCxvLCRV/4wh76uW18sHkHsfJMlXslY/4UepYaEd9Xv547hIHf1HTMPzMcOqdN4ap0tAh+Epqv8xgSzp+duD6cJFivZ+08tpUr5pZAxIdaW7nSQ3+DrSBWiGQx3NTPWz1GPDhyTvPyO5M/Wd3LYDiEwqU+YTCoA77nkkx5gs7HDLeJKqDi7SA6YHdBNMpraw5oYj5qDvcmP7uyQ3j6n2HlCuBn86A5fA2Ro4GvLe3ZYPC3uuLygA9Bl0JHIErIGp1gRuG7eifvRgA5dAQ0p1EP2gYSNZmPm0EwE1JYVjNoLCLq/Tyo8Mhrp+gqSZ05LhyPkAo7lceT96E6UwpLGZkKeMumaJ6fbRvNoepCDl6k0++MZbGyAEKJKx4EWJ5pZ4J5tZUmpwPBdNX6JUtpF3j/dghxSEeiNk1PxowZ68A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(66556008)(38100700002)(8676002)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QSkPeUV8YyofFxW05HRor2kt24RulqHPhVEvQyzfNPGRsfLE7BqFTHVRiiwQ?=
 =?us-ascii?Q?SjpqfQ+tXnKJEwWk0PnWdozMPwEfrWeBwLBpo6+mf/vKHsmm2ZlbNRICM5j7?=
 =?us-ascii?Q?pzf7lauWxAMMh8SH7HSwJ0qToFJliV4Dd0QhKsp8V8jZqi6crGjjGYNpK+AM?=
 =?us-ascii?Q?g0cb1fBWF8yZgURbnqdSLQzXCKrLY4w7yeTaGyopbr/80n9jO3LBbyeFOPpu?=
 =?us-ascii?Q?7NQwnT16bTBXjNGh9blLYsmBWgs9S4hM4ur2Yx1F507hKG37z/etkg1TZtlb?=
 =?us-ascii?Q?ZcBal4bNv1owT/NwZPH04n+9+yZ5Cesz/IZ9dCMnfqWWggHJHToGisXHmtDX?=
 =?us-ascii?Q?hOU1I5x2uMep0YUhu10h8SA9RrWUxubeI9H0LoaJ+kral0pcaJrXhoPC9fa5?=
 =?us-ascii?Q?bkkKGTCTj9Tt6IMK1Eq9lRtX3mwEALUpTFdBxmEIW2dInflH/2D/ec1sCsMV?=
 =?us-ascii?Q?lsO5LscRiqhFoJbdl+N0PzNH1+5bLpH9u+6NPtgLzOD2oWSlO/aL5jzMNSyN?=
 =?us-ascii?Q?i/NKcUjjFnBFfzzO63KifiLcT/ssaEKoyp7fBgBO366MmGJdGHijZtTibLbR?=
 =?us-ascii?Q?h3UqPaZqy9gfffUJh9lLvbhMZoSy1dZA0AynK7GN8M++RHjlAbxdraqU/GdP?=
 =?us-ascii?Q?awy2/L37rGMkDCRA/Mpjq2Ph0M2FqyNHe4T6OD22GQE9P9/7GhojuJDz6bXo?=
 =?us-ascii?Q?H1iMTGZ3PsYmRR7wP4juJiptHLdcYbCpCqrum9hanebaU6p3NoshMWgYLxm6?=
 =?us-ascii?Q?BaUfiS6uBAcmsJ0Shb9ClWXgpUY+paAvOPiS+OvvHGclLu4la2zSjwWAu5Vz?=
 =?us-ascii?Q?p/PbsWNCp9P61D4qXnr0Aek6GXJcIhQb3tXRQk34tJYx6fUO+54udwQGwz6/?=
 =?us-ascii?Q?+twOCBMucBedNbgDLK6CpwF7FXkfzQ61XUHDz3gDUUcQQQ9fm/9ECWTX395E?=
 =?us-ascii?Q?n/je8HDQC7dsdFz06Zj6RSpa1uhXxNmTcSZCWR92Fh9G3e/ByXr52SWedhDH?=
 =?us-ascii?Q?VjxNTRSuTc0Bz6IkQvGEqlak6C4Zb/uJYgUrJ7t8SvWscU0f+9iLUW7INBjd?=
 =?us-ascii?Q?0KxxLQtmf57ySB7NdV3LWk3I/tqEwCj8lCqUG1nwoOIEbShXh7GQ7Uembqry?=
 =?us-ascii?Q?6XGYWFQYQn+auQMF7Auu5+rJ8GPW++O84hob7Pc/Coc4ZEoYBBJadCR98IgS?=
 =?us-ascii?Q?z/m0pSp/juzUE+TuueBH/5BMItGGAysVjXQeRJPbcdYPOBm61BH2BHe+ab8C?=
 =?us-ascii?Q?9GKcwZlFuFblsAGjyUTUNq//8tMN3yyiEbToZhDFtXlR7gbnDvTZjk4vW1N8?=
 =?us-ascii?Q?c2Iu8F/cDctMoEpSmXZQlZky?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5401af4b-68e8-4214-d5a9-08d94548e0e7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:36.4336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +l0p4fCVR436rRKBi2GRJ6uV6bax+TxaxN6Jo0lW8MceA/AtXdhwsCDUzKzEiOj/lSIPneGOh82inDWoVZxJ7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of supporting data plane forwarding on behalf of a
software bridge, some drivers might need to view bridges as virtual
switches behind the CPU port in a cross-chip topology.

Give them some help and let them know how many physical switches there
are in the tree, so that they can count the virtual switches starting
from that number on.

Note that the first dsa_switch_ops method where this information is
reliably available is .setup(). This is because of how DSA works:
in a tree with 3 switches, each calling dsa_register_switch(), the first
2 will advance until dsa_tree_setup() -> dsa_tree_setup_routing_table()
and exit with error code 0 because the topology is not complete. Since
probing is parallel at this point, one switch does not know about the
existence of the other. Then the third switch comes, and for it,
dsa_tree_setup_routing_table() returns complete = true. This switch goes
ahead and calls dsa_tree_setup_switches() for everybody else, calling
their .setup() methods too. This acts as the synchronization point.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 3 +++
 net/dsa/dsa2.c    | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 33f40c1ec379..89626eab92b9 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -159,6 +159,9 @@ struct dsa_switch_tree {
 	 */
 	struct net_device **lags;
 	unsigned int lags_len;
+
+	/* Track the largest switch index within a tree */
+	unsigned int last_switch;
 };
 
 #define dsa_lags_foreach_id(_id, _dst)				\
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 185629f27f80..de5e93ba2a9d 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1265,6 +1265,9 @@ static int dsa_switch_parse_member_of(struct dsa_switch *ds,
 		return -EEXIST;
 	}
 
+	if (ds->dst->last_switch < ds->index)
+		ds->dst->last_switch = ds->index;
+
 	return 0;
 }
 
-- 
2.25.1

