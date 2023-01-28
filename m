Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF22967F37C
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbjA1BIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbjA1BIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:08:02 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2089.outbound.protection.outlook.com [40.107.8.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDF546727
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:07:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aT4D8l7LN9mP1RPj2Mql6tqcAuFTK7E/IdRFaKQbXYqCHOOsn8MzqmK8DLPr1mKvf7ZX1d++6eGgKQmMIg4zt5a1zhU+6sbUuv2PnOc5dClZ1yWFpwbDkQfJ6dsvf3/UbTZOY+IjwPxLOsOfn06sqNYFUAFItuaKktEOw3Yg/2wtAcu65cACRtIq4bvZS3n/yxAXD5H/8dMJQqoVwWjeROxc8ibIQUF87sNWmG+NqPyqdMzCE5YWj+6FIp7lNaGxIVys5yK9375KOyCU0/wJu79vywv2+GBQjDEeViuMfhPEWNp9wPvC5TVo2wGcqJzdIe6J5Neyuv+7xk7nHHhOTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16S+S9Z6o+eA4XI0GV+EggXpp+GI9KS+VLnfKQaSpgE=;
 b=EcC1s5PVnpRmQXmVzsL54HHuqH9mU9oly6W6YwTWS/3JWSTYrdcybCrPBj9MbxPvgjZLpufn1qlaRjbQWG6YKeaPKfzTnnWHuw3tC0vqiT2MAt1SL25awWyhQFtBq109vLQZG9fYzQfQkn7FLuEGhcXEBblE/MXJNAB60yyCau0m2qqaYhd1J0sudA2Becxxa7WIaA8jfRZTThHsiHzCFXaWYKWyaTm7DrswkA61VQeM0fjaqZyA/juKpSCxlVv7s57dws+XaFIViGIdyJbaqyoVvCUNia6zWNmKVxZ1IN5cBHhjQg92as+ExKKM3UGYa1e3oybHkeSILB9J/IGFFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16S+S9Z6o+eA4XI0GV+EggXpp+GI9KS+VLnfKQaSpgE=;
 b=U0247Vvx3bo5zJOiN6LbTNnWlfh+EWp13HQQiYBB9GT3VzCwO+RW48FRXY8Thet/CbgILWjwvQNwPuCe2wafGhSxKkGAKisRZq4NEeSFvUQgGYDx17PC/X+B6T/rPk5Zmv1XhK9ius17ssZKzf1zK50XNw7T/489o4ghHxTzITY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 01:07:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:07:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 08/15] net/sched: taprio: calculate budgets per traffic class
Date:   Sat, 28 Jan 2023 03:07:12 +0200
Message-Id: <20230128010719.2182346-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0128.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: 9212e8e0-814c-4676-7a92-08db00cc155a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p/WdyOSD5fYHP49mI4RhSjOyrpwlI+Obzi00i7Z0OCj29c99WJwug66bxzyayDXKwPsAqE7CkfoptsPeGRUUtceOBZ1TNclU9KAmdg+B9pVgHSsWV0ZGsJidZF4tHfwgSLmgz2CFz56TaI4BuIom8f9r6stiHVeAXbLmFmwr5HdOVRuDDfSjSktx8xRHYp10Ig/QbsfdRLnWJ8RfYoTm7GrBZWyxwMa27Qf3TCwpE9fSw8iEfQH3ryf15Wmrn/WWii0h8esRilhpzOdoNlWTdtYWowKwND7vk77LTGouJ6ByTOO+I8Bq2QUs5bVmMLlaMSy6J8fV11A1AE0MF82kOlXkTuOrcAbGz29RSa9ur1xlhoTTLIE6bQ7sOhxm9U2XMnP57Dubx26ifbwuOV76R2odNada/5HqjYEVdtF2JpXcqq6dvExPSGVh5DV4ESAI5TFs3g7QOLXmACMTIbZQ8FsOpCPM3bzu5igR8m5nZs/MHfiDj/v41qI2JtOihUuylLiDf4Kya7S8polekUkeQfiQtyF4KeGwguLd+HHqtvHkis8Qogu+q7PJP83hx5eI2UUDIP4ACcfH7gPkVLyCslzG5OkJyBFGGIbOZG7I8WEUR/VTmGKiP0tk+1yQ4GYN+dlMrnM2O42+fKV6PCUnXUcx7klN4GCJN6qANOl3pEB+NNopdNvryf7tzb/A3L3ztwvhfSswiMKpqnypFMyDLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(186003)(36756003)(6506007)(1076003)(6512007)(26005)(38350700002)(5660300002)(38100700002)(44832011)(2906002)(6486002)(6666004)(52116002)(2616005)(86362001)(83380400001)(6916009)(4326008)(66946007)(54906003)(478600001)(66476007)(66556008)(316002)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yzjVt/8OoR9B21+r5ioinZq3xo6ETaeQV0LZayUWfERALWfNGzNdYvSyICTJ?=
 =?us-ascii?Q?dzzthbghywA7XiwYxN8j4+7vT8OSX7W34pO0AV5c6cnSE4HAtCdo6ukKcarD?=
 =?us-ascii?Q?iJN77OKaV7vOuIegTg7zE61CGwjlP9nekV2u0yhilXl6eip3qMqS11SxUPEH?=
 =?us-ascii?Q?rNt6/7Wp1cQOaQxTQ0/usUCJH/ZBGsNwcgGhaTj2Jtp4lpNRYSh6dFWynEwH?=
 =?us-ascii?Q?gXz1CXb5ohGx0Q1wLWbyaeXX4/6MuAf9p3xdQUMvyrReOIdV3/WPQxVnkWGf?=
 =?us-ascii?Q?0TLC4qgNWyKgXAtunBOjzqZFIh1NH2l+O2k2OBKCtsZyoZ6qDhhsDvgy/Sie?=
 =?us-ascii?Q?Jx17PLvb7rNtwWp2EWrWQ2ThM7DNljQXlSOlIgMPfj8Pfk4A4POva33bQ8WY?=
 =?us-ascii?Q?sWGDF6QX7N8sRYvHiGSn59QE/xdb+L2A2Ua2Zg1hio1LtChC3nwgH2aU8FsD?=
 =?us-ascii?Q?B/NPDqCaB3xFYP/z1MqvHMWoQZ3KHwI3Q71bodx/2GxVDV+EbxIrHw+8LZmo?=
 =?us-ascii?Q?BimUlUdcHgYKmb1jcdpjRAYJ/Z8USjaUyxXfB+7Y8aRyIxgVDQXXOx9Mt/l1?=
 =?us-ascii?Q?6MqW2li8uP4zUu8pOV7ylNDFAoHHWzoBL2jdRtvwEVXuTrTT/d+mx9CNQy2/?=
 =?us-ascii?Q?aFEgSeFUYtLdlMTwjEJY4dvdfF8xO+IRVqcKlx6CEjtvVn/YtBxb6BtcA3Tk?=
 =?us-ascii?Q?QdXWzKpINov1JPFAbdQ1lKcJHARb1jm4nvVtu+yQcTjpdkNnHpV9mGbSiDoi?=
 =?us-ascii?Q?Dy3GXzx1XbqDKpSbEbD34sTyqk3PH4twUVoZPZlEti7b2sDRL409JZOFsV8p?=
 =?us-ascii?Q?/wDvBl5Cy/6MvCNqePcTVSywfSNWHD4r79Hbxrmb2PK9nnlgCP73twr9WbLn?=
 =?us-ascii?Q?InrxC74eZ1WC61PY0T2q6Ds06NK3EJ3Eq6Uf7KQzpROljteQ1obt1Aa3Q63t?=
 =?us-ascii?Q?UUTC+kpTeQ2vPn1odHXz7jkysKOp0pVh0ODy3LzvZWtrdp4qT0UjmSpN1nE8?=
 =?us-ascii?Q?4n1rSNsyXGDcJWxUQ/mKMgDBmuh2KKGi7jBICHBB39hfiKFgFgx7VU7FUHMJ?=
 =?us-ascii?Q?5/uutiZyUEOLgf+QCYNtJfTsy+wp8jRxlItuVE2tccc6lPYMzQvKcQZhkz9u?=
 =?us-ascii?Q?hJk9KwAMB06lZW/MVzRXHxZhrgsL5MCNOS5AXbFmyzMHFu9Ks6X9Q+fjt1TC?=
 =?us-ascii?Q?Zk67J25hCtkqS98bcwg0Y2WIpTOkszmnelpbVbwphuEPAI5RPQ6hZcjayQBS?=
 =?us-ascii?Q?5WWx+GpwKRu/9XJ7nm3WRTc9BKxRDwILLt9Mnm7k2A6xZ9nS1tX75oHQAjZz?=
 =?us-ascii?Q?lT0jvKU5yuts2zjsLzoAaEZX9ThirXKa/vtNwgnzAt5kho5bfxtPqpxcI9Zp?=
 =?us-ascii?Q?C3XVfAMAiabqQUXrWYsQZGt57TLnsUwJJHyp56gNYSqgwhAMgCSViPQG1A6C?=
 =?us-ascii?Q?Q1bgKsxS7oSWvvmjVh6weD0B5I9OwDMSzq3V3LE1qe6odPguIT3H5HP45CuL?=
 =?us-ascii?Q?7P8nE92Xa/9gmXliJCtoZRTpmh0szed6N76Ko3Q5I/KPykmfVawxV5Sv1erB?=
 =?us-ascii?Q?mUvMXD6HDcZWGviICbNpP1zSeqZvgJQUYOSeQNwRQZvdNnqfTVO3Sbpf/VQD?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9212e8e0-814c-4676-7a92-08db00cc155a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:07:53.6199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pf+q+PLU3ssXtMUWNe35E/R4V57xFZNgmpiaXFanlGv6WCKbDabFUVjHzQir20n4HXwv4n1bkWg/LWkkjNIdgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently taprio assumes that the budget for a traffic class expires at
the end of the current interval as if the next interval contains a "gate
close" event for this traffic class.

This is, however, an unfounded assumption. Allow schedule entry
intervals to be fused together for a particular traffic class by
calculating the budget until the gate *actually* closes.

This means we need to keep budgets per traffic class, and we also need
to update the budget consumption procedure.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 57 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index d5d284eaab66..b3c25ab6a559 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -39,6 +39,7 @@ struct sched_entry {
 	 * respective traffic class gate closes
 	 */
 	u64 tc_gate_duration[TC_MAX_QUEUE];
+	atomic_t budget[TC_MAX_QUEUE];
 	struct list_head list;
 
 	/* The instant that this entry ends and the next one
@@ -47,7 +48,6 @@ struct sched_entry {
 	 */
 	ktime_t end_time;
 	ktime_t next_txtime;
-	atomic_t budget;
 	int index;
 	u32 gate_mask;
 	u32 interval;
@@ -557,14 +557,52 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 	return NULL;
 }
 
-static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
+static void taprio_set_budgets(struct taprio_sched *q,
+			       struct sched_gate_list *sched,
+			       struct sched_entry *entry)
 {
-	atomic_set(&entry->budget,
-		   div64_u64((u64)entry->interval * PSEC_PER_NSEC,
-			     atomic64_read(&q->picos_per_byte)));
+	struct net_device *dev = qdisc_dev(q->root);
+	int num_tc = netdev_get_num_tc(dev);
+	int tc, budget;
+
+	for (tc = 0; tc < num_tc; tc++) {
+		/* Traffic classes which never close have infinite budget */
+		if (entry->tc_gate_duration[tc] == sched->cycle_time)
+			budget = INT_MAX;
+		else
+			budget = div64_u64((u64)entry->tc_gate_duration[tc] * PSEC_PER_NSEC,
+					   atomic64_read(&q->picos_per_byte));
+
+		atomic_set(&entry->budget[tc], budget);
+	}
+}
+
+/* When an skb is sent, it consumes from the budget of all traffic classes */
+static int taprio_update_budgets(struct sched_entry *entry, size_t len,
+				 int tc_consumed, int num_tc)
+{
+	int tc, budget, new_budget = 0;
+
+	for (tc = 0; tc < num_tc; tc++) {
+		budget = atomic_read(&entry->budget[tc]);
+		/* Don't consume from infinite budget */
+		if (budget == INT_MAX) {
+			if (tc == tc_consumed)
+				new_budget = budget;
+			continue;
+		}
+
+		if (tc == tc_consumed)
+			new_budget = atomic_sub_return(len, &entry->budget[tc]);
+		else
+			atomic_sub(len, &entry->budget[tc]);
+	}
+
+	return new_budget;
 }
 
 static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
+					       int tc, int num_tc,
 					       struct sched_entry *entry,
 					       u32 gate_mask)
 {
@@ -596,7 +634,7 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 
 	/* ... and no budget. */
 	if (gate_mask != TAPRIO_ALL_GATES_OPEN &&
-	    atomic_sub_return(len, &entry->budget) < 0)
+	    taprio_update_budgets(entry, len, tc, num_tc) < 0)
 		return NULL;
 
 skip_peek_checks:
@@ -657,7 +695,8 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 		 */
 		do {
 			skb = taprio_dequeue_from_txq(sch, q->cur_txq[tc],
-						      entry, gate_mask);
+						      tc, num_tc, entry,
+						      gate_mask);
 
 			taprio_next_tc_txq(dev, tc, &q->cur_txq[tc]);
 
@@ -772,7 +811,7 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	}
 
 	next->end_time = end_time;
-	taprio_set_budget(q, next);
+	taprio_set_budgets(q, oper, next);
 
 first_run:
 	rcu_assign_pointer(q->current_entry, next);
@@ -1080,7 +1119,7 @@ static void setup_first_end_time(struct taprio_sched *q,
 	sched->cycle_end_time = ktime_add_ns(base, cycle);
 
 	first->end_time = ktime_add_ns(base, first->interval);
-	taprio_set_budget(q, first);
+	taprio_set_budgets(q, sched, first);
 	rcu_assign_pointer(q->current_entry, NULL);
 }
 
-- 
2.34.1

