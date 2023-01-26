Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485AE67CB5F
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236742AbjAZMyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236436AbjAZMyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:54:13 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2067.outbound.protection.outlook.com [40.107.20.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B146E417
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:54:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjaOepkQrSHIbVkS2WY8LVR6A4H/U69uhapd3fC76NWIMmrrIvGCxiKcQjcQyiBLiNGt4rB7rUaErFsm740S+C8E0ZOIEFtjpQWM2rF3W/2MmCueVo8EhuRGNdoGxfJEK9XwZgcXVx0hSeuJmY+gTSpqvd6eir0ZbXqPh9Gf3gNbc38Sb9hXUxfyeHVnBj3pEjd1SZ5dwwGH/PykviV0LT9H9GnBbaSSTx5sUqcJ8E7C3KZdPtWpTBDTlEweQ1r4dSXmTymf011XRO0g65KyTReB+JgxQlg/p+iT6M7/35oaULLK128FmqGNX8Om7bIeT6Fba7a3okIuHuTHMLf9kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yzNYNpPiLa0QcdeoEsMmlDDmadXti+voVp9aQtBQdUM=;
 b=fAA8xW2lIeo6n2oYrhtTfD1EGOFrp7cOEDAM5FYfEjwKZYsVtCB/e7c32OrkIx4lUhEBZQhqiBtWUghaKPGqrgqgXczARJB99sB4hmw8lrBwCLMeMwBfbPkxTA4XYKfuCOkcC/y2yPxZk7PJkQHXbLZfq0qYO98umZG4oxA+2R4+/yxZIvapww1fyNQ2rqbXhLl0KpxDNNiqz6HIdajGeNpkOqdly/wFJPxx1Hpv2BUXaRDQcdH+kYIhMvoIbNQORiGIgJp4S9STZ6mYNiu9EZnqt3WcqZMUXUJtVY/AssP+/PzJREE87I0vxzdcfg62IMUJykqZcHcTpj8Gwvilzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzNYNpPiLa0QcdeoEsMmlDDmadXti+voVp9aQtBQdUM=;
 b=muBe3PgEQ7Z4FCX8f/J47A5F0xNa6SjRomoi0GqyF0pu6c6JgVriK3Fh2N83nxh6pBCK6YqTbi5blVradeOYSAWiquSSaUiOy1O9yX8HhIsI6o4WcVPqegdvurPgW3gpgDs1FlJCTwNFWmCcMIsFf//arY326SM4nBGrbKofTmU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 12:53:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 12:53:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 14/15] net/sched: taprio: validate that gate mask does not exceed number of TCs
Date:   Thu, 26 Jan 2023 14:53:07 +0200
Message-Id: <20230126125308.1199404-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
References: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0123.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: 53ed00dd-ff95-441c-480a-08daff9c5e08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pdibKaKlYbVfyAvOgAhYOn12OUdBaJIjX7iQ1T89TmjSjO3QohrtlToHW2qu/ygUxWyy8e+3R0/NemL7V/Ni4amZKxfwtaXWD0KTO2w+0EaImwMmKCOysL4LECQi1MSJL0Py7efcqwFQw7tsc4r4VEMUUJi+bh5g4cBqXWEaw02cskaf7RuqOFTU11D1+wbbwYShBM1VkNf/jWlTcvHVag1NIQae8wCZzc6pD2RbCfomktJkw/GQQQsgKqO8fjsiFg8iOc4OoWyXukZ6VI3lM+7lJ401XwipINCm7cZq2bdABGicHgNqKh6ajmQYD6ErVKYhLFxW0z8gYRsS6pVgu7IKoaXm8XP+AfKFLNwJN5LvR6KIbJ5KK30/Y2k2U2s5rb/SGYOM8kSAssofs0IEOxMhlzRLsdyy0teKIe7PGySttOmXVFbdK+C4H6OX3/qHKzYaZOfU9wx+t8bCoPTtPhIxQ827+7QwEEpNcEJEPkrOWrkDObfPkmwvC7pxmQ/8amzYqs7nYPvHJx9dy6buFo+NtKFjEHerWDsO5RVdqi6yJVa2WWJ2h58ezk2T9qQShU00p6bQxlX91NXg28WYaYqcZEtDA0+WoCEzI22pXVOIvx7V31R3AkUJUdp7wSREqsWdTNxBgQm7hoaJp8YL/qN2zcT63EpV7iU84nPfmMlFmmu0x/HKI+acd93F2FjTifik1uZcd8JLZpzA1jEN9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199018)(26005)(83380400001)(38350700002)(38100700002)(5660300002)(2906002)(41300700001)(86362001)(6506007)(15650500001)(8936002)(4326008)(44832011)(6666004)(316002)(186003)(6512007)(66476007)(66556008)(8676002)(2616005)(478600001)(54906003)(6916009)(36756003)(66946007)(6486002)(52116002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oKX2xbbt5ikCny90zPNmF879agNWR3O6iTvyCYaa4fCPDK/MimpZwzqq7giv?=
 =?us-ascii?Q?irctbn8o7bwZcXk34sOrWqH1BM5KJGMa84e0+K1oSZNlSYhzKzPV7xFmZOs/?=
 =?us-ascii?Q?0MDQfCl74e0yhEsEVDoKCG/d0MFfS+MPTEjLMLMvqpdg2AsdOOtgkdBDGy0Y?=
 =?us-ascii?Q?75Bvg0HiFdVT9oOkQeZn/p7CohcXvD1sEflHonJCI9ODjwwpJ9yfi+7CZqvx?=
 =?us-ascii?Q?eMi1qZKYRXZExohK78vA4ZybUQQt0hmYrBMOeG//wFlzh4YzByCnv5fLuS9C?=
 =?us-ascii?Q?WVUY3trkieXjwuIGZ85E9LaAjk+Q2x7lJ1Bp+dM5kXKPcbAHNdfgfVS79FfQ?=
 =?us-ascii?Q?j9dDF7tB3AqmFyAZst8uz5Ktf4A65dbQUNRBL7JsDh4ZC4OXjDUkFrU34Fug?=
 =?us-ascii?Q?xOEkjwwDqIi05SyPHbBPKfo4Cn7qyYLvdlvZLgkBiCkb9TvTqcwLLuGv4kFu?=
 =?us-ascii?Q?TxNlJVfwQ1xd4yRExVNtaxXrlfO4d+cJkRmJvwfGD42Uqwv1LmOiaRFgx6mu?=
 =?us-ascii?Q?G0ilgr1GBVDJqRSl4imrUzkPzJU15DOMntbWOPbaFsM96JjEJHQlzo/CX8Mn?=
 =?us-ascii?Q?uU9Urr7IeAkbzGqNI6X/wrCV4i5+tFqeAyft1IPZN/p9v6RDJx1FJUMe4cu+?=
 =?us-ascii?Q?uQHYUyBglnLUZmV+LwUx244wBSEX2fyTsSiKZLjCng0nBE4/9Y5xOyDyPtcR?=
 =?us-ascii?Q?DIKpue711ASsCAFibzvcjsTu+aBAx92OjlHtoDIKdFHF/M5XXXWToNWVDN/d?=
 =?us-ascii?Q?qhL2r+5LuITmPG4cgOGoffVCKwEkGCwntm0oZ3uDaDH5BoUBap9ukiD//Q7r?=
 =?us-ascii?Q?oaxTpqswC1Pmr8P2ySF11dFZaH/2ROqJI8MLB/xFw0ppkY7a+omT5tUlDOUq?=
 =?us-ascii?Q?uWdCkHkIGilwWcCsQ+v3hbUh0E4CR5sO1lzufZ3vUP+74sntTDnlDQANJDqE?=
 =?us-ascii?Q?zX4lzD4xIwRiYTJSbfPGwW3J9WXIN//ixqcDoK6SykzGjaM7y2jWdPMCZNa/?=
 =?us-ascii?Q?dlSQP7RyiO58oOzWstVX7lqoMu1kmaxUTWgsrhSLC+Ykotw2fAzmDCgyizqu?=
 =?us-ascii?Q?ZXcIzNm0FVa6jgaSI7BkWAhCp3S+mZ8B8K9DJV06B0DQnofGt9gBUm5Sz+9K?=
 =?us-ascii?Q?GzKmD7x72NJAJFNC8YQEfst7PIz2PJve2cDueXizuJWz4ln1BfW2ugR1sHzX?=
 =?us-ascii?Q?Q3Ih0c7kktrg9+axbMCgpHkKITkpTKKzF+olhEKgls5ZRMJeE8gap91HOuAz?=
 =?us-ascii?Q?tB48m3ztF+pgVuEpFAj/SBRZZ/LhMJiNMlvxTVFCrVYfKuyVrjI5a+1fLvJd?=
 =?us-ascii?Q?gmK/n4G+OujnlVCqPeGdMuyVMi35+tbG69iOUz6mThgmHKV6ci+X0KPCStJF?=
 =?us-ascii?Q?KAQ061iS8nnsvztWzp2kTp6L4GMtJazLpTh2ATA3psHvU6+9V5b/nEKszktw?=
 =?us-ascii?Q?xVUiHMvUNSooPUUtbfdWUaSx2u8XXfsxr3crgsun88y4yXOvMQhJvziqABj9?=
 =?us-ascii?Q?R0QPbJDdk6bho5hZoS36BwXnUVSnNbWP/ndJc4OhIqrkBhKJNjFuksi3/4er?=
 =?us-ascii?Q?T+LjjnXthwJGDZ7S1YSccogYu4Qu6tOMUr7m+wEJofPHLyJXrTo1MxT/grJm?=
 =?us-ascii?Q?UA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53ed00dd-ff95-441c-480a-08daff9c5e08
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 12:53:48.5959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: URtP1sycyQl3Dm70x0Hzm1wOGZzNDvuwL4kZPnM0B139TVa3VOvpTtFdBb68jn8TAK+qmzg4KEALl0e9Kv8F1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"man tc-taprio" says:

| each gate state allows outgoing traffic for a subset (potentially
| empty) of traffic classes.

So it makes sense to not allow gate actions to have bits set for traffic
classes that exceed the number of TCs of the device (according to the
mqprio configuration). Validate precisely that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v1->v2: none

 net/sched/sch_taprio.c | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 6533200c5962..9cbc5c8ea6b1 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -789,15 +789,24 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 			    struct netlink_ext_ack *extack)
 {
 	int min_duration = length_to_duration(q, ETH_ZLEN);
+	struct net_device *dev = qdisc_dev(q->root);
+	int num_tc = netdev_get_num_tc(dev);
 	u32 interval = 0;
 
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
 		entry->command = nla_get_u8(
 			tb[TCA_TAPRIO_SCHED_ENTRY_CMD]);
 
-	if (tb[TCA_TAPRIO_SCHED_ENTRY_GATE_MASK])
+	if (tb[TCA_TAPRIO_SCHED_ENTRY_GATE_MASK]) {
 		entry->gate_mask = nla_get_u32(
 			tb[TCA_TAPRIO_SCHED_ENTRY_GATE_MASK]);
+		if (!num_tc || (entry->gate_mask & ~GENMASK(num_tc - 1, 0))) {
+			NL_SET_ERR_MSG_FMT(extack,
+					   "Gate mask 0x%x contains bits for non-existent traffic classes (device has %d)",
+					   entry->gate_mask, num_tc);
+			return -EINVAL;
+		}
+	}
 
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_INTERVAL])
 		interval = nla_get_u32(
@@ -1605,6 +1614,21 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto free_sched;
 	}
 
+	if (mqprio) {
+		err = netdev_set_num_tc(dev, mqprio->num_tc);
+		if (err)
+			goto free_sched;
+		for (i = 0; i < mqprio->num_tc; i++)
+			netdev_set_tc_queue(dev, i,
+					    mqprio->count[i],
+					    mqprio->offset[i]);
+
+		/* Always use supplied priority mappings */
+		for (i = 0; i <= TC_BITMASK; i++)
+			netdev_set_prio_tc_map(dev, i,
+					       mqprio->prio_tc_map[i]);
+	}
+
 	err = parse_taprio_schedule(q, tb, new_admin, extack);
 	if (err < 0)
 		goto free_sched;
@@ -1621,21 +1645,6 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 	taprio_set_picos_per_byte(dev, q);
 
-	if (mqprio) {
-		err = netdev_set_num_tc(dev, mqprio->num_tc);
-		if (err)
-			goto free_sched;
-		for (i = 0; i < mqprio->num_tc; i++)
-			netdev_set_tc_queue(dev, i,
-					    mqprio->count[i],
-					    mqprio->offset[i]);
-
-		/* Always use supplied priority mappings */
-		for (i = 0; i <= TC_BITMASK; i++)
-			netdev_set_prio_tc_map(dev, i,
-					       mqprio->prio_tc_map[i]);
-	}
-
 	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
 		err = taprio_enable_offload(dev, q, new_admin, extack);
 	else
-- 
2.34.1

