Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B237037ACF9
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 19:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhEKRUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 13:20:24 -0400
Received: from mail-eopbgr130050.outbound.protection.outlook.com ([40.107.13.50]:57666
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231304AbhEKRUV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 13:20:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9aMafrBdcaZ8yUCJFY97uVvO5veSmuDIfaoKdnoa1juA1HdI6ZCeksUrp0CKBsK6uLA/EWlV2Wuk5xe6vkZRKDCOImsRyA+FGVvQeW2XfAgBmUKHPOpM4SyTgOkGofu6UkCGV0Ej11a8vurEr51qaPZgh0cGoiNT7HDUH1A0sQNEpaqt7a0RbGpmD6I5mGgiakExea9sPXBLPEduJ3ux6IvTsuhwGLI2ae10N/OKr3hZSVrYWWpTv3nWXIibsVxfYwdm6QDPeRPWmviKxrB/aKLX1Loh9SY04GtjgY1jr3vYzVBS6jdHqbya5tG8jQUspQrLOkf4kFV8mTw839AWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEzS+jus7/EA8rlXVsGzDhK+6fxU4T8UzdC6PHlm04o=;
 b=MLhyLhQbhIgG6Qgvrc/UPYN9Yada3y/HtOM3hOPlufpv8sp5HLbx7xm6Prhpi2IVKg/xHCOhdkDQb6lrGie6d4fpE2x2cVBVEyCGatVHMwfu5WoW5XktTFEKEIfhMtvDwnJMnqXqwGHjaofe9CuBJQhjkHCLZscWs5JlKHcaHuCyTEkH+ZVwr/wtgJb2URuyFXIsiFNYQhVDVUdG8T/PNiHw21CVGquWx7tV8QKjQgIIH5RyyLGwDggXPGO8nERl5GZ7ehkwOlBBCDmPr+IVBfJXMlApDIPi2TaY6kuWZFivak3mkUYdrGIXeeUwefFQvnBfJ1bj5wYEM7FVRCULNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEzS+jus7/EA8rlXVsGzDhK+6fxU4T8UzdC6PHlm04o=;
 b=GlZDN+FlUJ43Qkby9428xkv6VcWxQasKPSX1IyjY8VbDQPAmFpeJlfDQWF9XiWaUS65Gd3lY8Lbiky6jPU/r2yPPtw4WMYwYBSU9Zh/xin5F9pNDDxJudNWN+2KzjqY+agE5SRwVNtl8wuIjTXnPylkHk9+Yr5+jrJQnV8bM/Lg=
Authentication-Results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8757.eurprd04.prod.outlook.com (2603:10a6:10:2e0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Tue, 11 May
 2021 17:19:11 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387%6]) with mapi id 15.20.4129.025; Tue, 11 May 2021
 17:19:11 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [PATCH net v1] net: taprio offload: enforce qdisc to netdev queue mapping
Date:   Tue, 11 May 2021 19:18:29 +0200
Message-Id: <20210511171829.17181-1-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [81.1.10.98]
X-ClientProxiedBy: AM3PR07CA0088.eurprd07.prod.outlook.com
 (2603:10a6:207:6::22) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by AM3PR07CA0088.eurprd07.prod.outlook.com (2603:10a6:207:6::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.12 via Frontend Transport; Tue, 11 May 2021 17:19:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38f9ad9f-7b0f-4ad2-31e8-08d914a0e4b2
X-MS-TrafficTypeDiagnostic: DU2PR04MB8757:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB8757D29BA3DFA7DBF7C9D35FD2539@DU2PR04MB8757.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: crhJibrHX1EMUkF5D6Zb4AM7T1IKq6ixVN1A9C47P1B4Bgr0V/2JaPPP4vW3rObIiyjPzXvnrxFh9hWBTkdZ6kgryiGBCGWBdmpzOZnwMFI6gQwG26rVlGX2QiPXURuLBwCbrf1OZL3Tm7ueV/L0ZABZg0Sxu/TPzFyya46BEGjmvdU/JoiSKj+JA6gvmWvkPu8SPTFa6GUQAKxUjVlbNKKIYb3IzfuO88UF+FQD+TB+mJx0xTiwk/QIJGUoJOXGkgmcb3lhcP4KKDZsXEq+F+FYvTMpQOhO9aXO+y43RmU5ziCG6Qw2UkZHJ010pVZVR3WrSKAEJq+Nh/b7r3/T4xjgXWb1RHK/afqWMGuk+FTRarxySyMNolP5thuxgWV4bZIXn4qYCn3lLvpyP8NRIzmhLw8Q1NrAkGcqeK5e5u0pgvBiml9vi87nqiwCmsSvoQyhOL/5ssGV6ro2eIvEtboAb+H0NObm4uQJOu5plW0lk2WrnYYaD+zOTOb5wL2Nwvaebefi+BwvgICxYVGJbYwKWdgsahFkXNe7/xscb7j1fZGVdCZdzeDU7ZBgnAyVxcfty3jXkl5W3yrWBSGJuDPVgqEZaxICbzza/VVlpHpfWBMB4HcuIP0SgtmPGCVWKr2/NOMMq45XY4fUwnR6BCd9L7Hn5/jTJujviEEpIwc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(44832011)(6506007)(6666004)(66476007)(5660300002)(186003)(16526019)(6636002)(66556008)(52116002)(2906002)(8936002)(83380400001)(38100700002)(86362001)(6486002)(38350700002)(316002)(1076003)(26005)(2616005)(956004)(66946007)(6512007)(110136005)(478600001)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XV4axVxFn+qBENxs407nJH9cQo7cyM+J40too4zyvXweq7AdLu/OVrwGiZSU?=
 =?us-ascii?Q?t+v2s+Oo+zl2Jct+ZwPKVwuUAcF8rvFSlhiIkSXRrCzMQsY+JDyl3zrP9Ee9?=
 =?us-ascii?Q?uH1BGrsS4hhYaHYhmG6QBEz/cms0ufLYbGDdMLo/loDw6YsHw58fmlPS438p?=
 =?us-ascii?Q?5qgtpDWwarj8JbEzXv7oV141QuGuNj4GQ0sQpo/DaPFLatAaPJiljh/oWLQI?=
 =?us-ascii?Q?kvReNMgekYZY0LNORtyF2OK/ISoMDPYSsj6ENWxrAdTuHc6ihjNfTPDmytOR?=
 =?us-ascii?Q?GHrWhwc304RX+TNjSecVrON6KEzNhLQ060ppUVa2GjuFUPf2gXyUVJyZ1jF3?=
 =?us-ascii?Q?KiEtj+ILFkRj/0cwiKU/VPbgr8BQGClDfJ/NBBsGB/6g4T0mqxGSDJjEpo4d?=
 =?us-ascii?Q?5/RO+YVYUz2uTAoq9FSC1TIsxw+SPgJq2f6X9GeE9wDrloGBAizoAAQef1qp?=
 =?us-ascii?Q?YeoEahXTR1IiAgbJp7lUIjEYC6aCiRFLIgFEgrWPtmZPap7yOQes6BlmSe7L?=
 =?us-ascii?Q?ddHTFM0e/GCDpf/jVSx+fFYM2DohxeEz2PLAZC8JYHwwyVfuuZQO2R7NLQSa?=
 =?us-ascii?Q?vPgoCrc2BPFxOnyPUhJJJpHWEGQ/eb5LbIL3PafnkG6B+u3MFgGTW6amHOe7?=
 =?us-ascii?Q?GtKESrETwoGIFV62f7KAD1iQXhe6azZvnvg8Uxix1xYTjnJB/vQEokGZ3JNI?=
 =?us-ascii?Q?Bv6NADJCoomvFf7hf3aJdIZLGuLQyjOZ+7JCYQYAx8sDZrH9Gu8pkpOgiP37?=
 =?us-ascii?Q?fVCioVOaig8aCh+sBvScWUkQno1XlVo6oTwFxwrhYhJO/rkFOK1idJNv1tR0?=
 =?us-ascii?Q?8KRKhfGUblfrxAkhT/9BlhlObGgNbr7pGxIw/kvk4Q4ESk0pxRRRKkM2hDnN?=
 =?us-ascii?Q?s9yu4O+94r3FjL+psbVvTwQ0J0d623Ph9Roob9Cs1ECeFoIJMbwt4PRprFld?=
 =?us-ascii?Q?E52SSKaPuLlDrYcYLF3auOCuqfLFyRFrILj7ShzkRoaRHL/cKscUR1N1yJkx?=
 =?us-ascii?Q?1BQHsiMnDxJwMmMhWf3znHXpcqITLt+u8sadGoA5KDzus55LO/K76WtAUG1E?=
 =?us-ascii?Q?kaFiBrqUDe8OLP5BVKHKR2xxflrkjZPIFSPScB8Nmap4ruDQ7gtH+b1jWlhw?=
 =?us-ascii?Q?ulYqHkS+8FgidjuHfpALNGu9+hg97VR6KWpHMeaKYCsq8UyyuITfUo29Ccee?=
 =?us-ascii?Q?Y83ldAam+uMpVUr8xd/h8UF1KaV/WgYWJQd4OZ46KfJPLE8ta9WHTuJDtKdh?=
 =?us-ascii?Q?EHyiuS9BiZhBuiE1pIPZ1fHJjXh/QMTGwRD2UXQ1ZP0BHrTwNdpZixHOp7Zt?=
 =?us-ascii?Q?Qu9nbyf9K3gOJOwstPtqRfTs?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38f9ad9f-7b0f-4ad2-31e8-08d914a0e4b2
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 17:19:11.5166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IPczJQb6AZyGvhj/F2xhoImbbvCsZBTjrRxipAfeqQqFJhQVleq6KdcJqgGs2jj+aeIxt4pV0MBj5Zdh3OdQKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8757
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

Even though the taprio qdisc is designed for multiqueue devices, all the
queues still point to the same top-level taprio qdisc. This works and is
probably required for software taprio, but at least with offload taprio,
it has an undesirable side effect: because the whole qdisc is run when a
packet has to be sent, it allows packets in a best-effort class to be
processed in the context of a task sending higher priority traffic. If
there are packets left in the qdisc after that first run, the NET_TX
softirq is raised and gets executed immediately in the same process
context. As with any other softirq, it runs up to 10 times and for up to
2ms, during which the calling process is waiting for the sendmsg call (or
similar) to return. In my use case, that calling process is a real-time
task scheduled to send a packet every 2ms, so the long sendmsg calls are
leading to missed timeslots.

By attaching each netdev queue to its own qdisc, as it is done with
the "classic" mq qdisc, each traffic class can be processed independently
without touching the other classes. A high-priority process can then send
packets without getting stuck in the sendmsg call anymore.

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---

This patch fixes an issue I observed while verifying the behavior of the
taprio qdisc in a real-time networking situation.
I am wondering if implementing separate taprio qdiscs for the software
and accelerated cases wouldn't be a better solution, but that would
require changes to the iproute2 package as well, and would break
backwards compatibility.

---
 net/sched/sch_taprio.c | 85 ++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 40 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 5c91df52b8c2..0bfb03052429 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -438,6 +438,11 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct Qdisc *child;
 	int queue;
 
+	if (unlikely(FULL_OFFLOAD_IS_ENABLED(q->flags))) {
+		WARN_ONCE(1, "Trying to enqueue skb into the root of a taprio qdisc configured with full offload\n");
+		return qdisc_drop(skb, sch, to_free);
+	}
+
 	queue = skb_get_queue_mapping(skb);
 
 	child = q->qdiscs[queue];
@@ -529,23 +534,7 @@ static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
 
 static struct sk_buff *taprio_peek_offload(struct Qdisc *sch)
 {
-	struct taprio_sched *q = qdisc_priv(sch);
-	struct net_device *dev = qdisc_dev(sch);
-	struct sk_buff *skb;
-	int i;
-
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		struct Qdisc *child = q->qdiscs[i];
-
-		if (unlikely(!child))
-			continue;
-
-		skb = child->ops->peek(child);
-		if (!skb)
-			continue;
-
-		return skb;
-	}
+	WARN_ONCE(1, "Trying to peek into the root of a taprio qdisc configured with full offload\n");
 
 	return NULL;
 }
@@ -654,27 +643,7 @@ static struct sk_buff *taprio_dequeue_soft(struct Qdisc *sch)
 
 static struct sk_buff *taprio_dequeue_offload(struct Qdisc *sch)
 {
-	struct taprio_sched *q = qdisc_priv(sch);
-	struct net_device *dev = qdisc_dev(sch);
-	struct sk_buff *skb;
-	int i;
-
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		struct Qdisc *child = q->qdiscs[i];
-
-		if (unlikely(!child))
-			continue;
-
-		skb = child->ops->dequeue(child);
-		if (unlikely(!skb))
-			continue;
-
-		qdisc_bstats_update(sch, skb);
-		qdisc_qstats_backlog_dec(sch, skb);
-		sch->q.qlen--;
-
-		return skb;
-	}
+	WARN_ONCE(1, "Trying to dequeue from the root of a taprio qdisc configured with full offload\n");
 
 	return NULL;
 }
@@ -1759,6 +1728,37 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	return taprio_change(sch, opt, extack);
 }
 
+static void taprio_attach(struct Qdisc *sch)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	unsigned int ntx;
+
+	/* Attach underlying qdisc */
+	for (ntx = 0; ntx < dev->num_tx_queues; ntx++) {
+		struct Qdisc *qdisc = q->qdiscs[ntx];
+		struct Qdisc *old;
+
+		if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
+			qdisc->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
+			old = dev_graft_qdisc(qdisc->dev_queue, qdisc);
+			if (ntx < dev->real_num_tx_queues)
+				qdisc_hash_add(qdisc, false);
+		} else {
+			old = dev_graft_qdisc(qdisc->dev_queue, sch);
+			qdisc_refcount_inc(sch);
+		}
+		if (old)
+			qdisc_put(old);
+	}
+
+	/* access to the child qdiscs is not needed in offload mode */
+	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
+		kfree(q->qdiscs);
+		q->qdiscs = NULL;
+	}
+}
+
 static struct netdev_queue *taprio_queue_get(struct Qdisc *sch,
 					     unsigned long cl)
 {
@@ -1785,8 +1785,12 @@ static int taprio_graft(struct Qdisc *sch, unsigned long cl,
 	if (dev->flags & IFF_UP)
 		dev_deactivate(dev);
 
-	*old = q->qdiscs[cl - 1];
-	q->qdiscs[cl - 1] = new;
+	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
+		*old = dev_graft_qdisc(dev_queue, new);
+	} else {
+		*old = q->qdiscs[cl - 1];
+		q->qdiscs[cl - 1] = new;
+	}
 
 	if (new)
 		new->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
@@ -2020,6 +2024,7 @@ static struct Qdisc_ops taprio_qdisc_ops __read_mostly = {
 	.change		= taprio_change,
 	.destroy	= taprio_destroy,
 	.reset		= taprio_reset,
+	.attach		= taprio_attach,
 	.peek		= taprio_peek,
 	.dequeue	= taprio_dequeue,
 	.enqueue	= taprio_enqueue,
-- 
2.17.1

