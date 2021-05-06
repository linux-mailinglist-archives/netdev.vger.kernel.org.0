Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB513751C4
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 11:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbhEFJqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 05:46:12 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:59406
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231194AbhEFJqK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 05:46:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Su+VyK+1rozM21/ZAoej5vWrxrYL4IXL+tFttme75GW3wXFi7gPyWcTlcskGLL4v7vc4D3qbvriKFGHHj0Jghkzq2g2aPRNXzBnEUJUedbnjuFN/oCiYnS/+58UiUfOYnTG7bQ7jwiJxP8SWTuAA8mb8Exuso+KiUYc1IuVu76SK7B7q7kdYWA8eZIcKeNHwzNApzyvl9rERObcYOoUD9XW0hFK2ygZAMqUAqNXFVK3Rplri5ZB2e3gcH+RHAvoS/jHjF8ENXXmo5zrLbYLDkn+W63G3bWhVDJ9YqxTYtaaV4+J0cwrQhlgmgVE20bJMgx0d4ytt0r+xZ1F8zmABdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=793kS7m6f8a/Te7vVE17ZBu3r6kU/j0zqWP3OIxUR/s=;
 b=X/e6bl356rQ2ateI6PmjT99VyErl1k+3wIJgDVO7XymP5GHrmlkQMBsYGAZMGev+wV9e+yWCuGhYaLC+LB8YweXJgCXMH8HiZMIywDuO9P/xzsfCRbQJVN6KCkacpw54oHypzaGXevhutswkJqbb1jeKzG8KUB/CjZyWRAVG/39kyWdW5TdReoJXTsrik5hR9/Sc0t/LKjtwGmmFnTbRbfRwLHQbcwvPqzRPIQZQ80bPLBfbcpLBhkPwqbTb2o2ILo3dHETe9qNp6++z+AlYRsjw8OW1NRhhpwbFJmFAVcDPohgT33p/3zDMnFQYGZ/rFmAWKORQmcfuV5OiYnTAhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=793kS7m6f8a/Te7vVE17ZBu3r6kU/j0zqWP3OIxUR/s=;
 b=gqPN5dFVKF0Mjvt2zueS66p6XJpR2KHAyHm3d8EiuQskkYs2FBpz5L08HowHimVT0N81liwtGKl0R6+MZo1cOESfjPS23k6E53lINsd7TVBFZFShLJ+yckE5YOLeqmvV3mguEGbJ6XQWyrt0qWa47LCpzptsEMI6+7gODnT9Bg0=
Authentication-Results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8838.eurprd04.prod.outlook.com (2603:10a6:10:2e1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Thu, 6 May
 2021 09:45:10 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387%6]) with mapi id 15.20.4108.027; Thu, 6 May 2021
 09:45:09 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [RFC PATCH net v1] net: taprio offload: enforce qdisc to netdev queue mapping
Date:   Thu,  6 May 2021 11:44:13 +0200
Message-Id: <20210506094413.27586-1-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [81.1.10.98]
X-ClientProxiedBy: AM0PR02CA0194.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::31) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by AM0PR02CA0194.eurprd02.prod.outlook.com (2603:10a6:20b:28e::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 09:45:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87965869-675d-43b6-2dbc-08d91073a328
X-MS-TrafficTypeDiagnostic: DU2PR04MB8838:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB8838538679127F96AE4D04BAD2589@DU2PR04MB8838.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nBw8Dr+MdKzJd7RRgsAW9iaUVmUCiRbSUmtG2kqgTb7fNNk34Wmuw8u11G1EEftJhXrW4TgTd33in2QBIvqEwTrLvdm0QVk8ftSozjsrb5OWwfyi32zPYqHeZZ5CnMi2S4Zf/Ljoz4ywYzDBoy0vO7nHDsPJNseSgvZnZTptMA2Az09HjzUy70tklDPshK0rWd+sb7gAibhnR7IOy7PwJqWKZHHWHjakPFqGsyKDGx3TnTbRVpqQM/6GZCt/yrLv1TROA9KRAqWWlF13SoGNlykmI4ctqebrY/pQpgZrCaDBwgO8/LmCyvFNDyHpx/o8d6E2eTTOy3kHNS5zlJTTA78u6AXGFn5FJH+YmLTQNt2eHRXapcAXTRGXi6Ny58uhM8W9svHRqZm1VnN3S3Dopr7mfLGU6mWwywRZFw3jdMqTdX9hlFgRPalQ3rQwbWnyvL0XLAZdQMBjvIs8EqWUDqbz1xpZ+yYVyuehGfYgLJPPr6rYDtpbv54BSFp2+Z96VyuasY8VR9fog8yWX9sFuZNzrCw0Si0yBXn5AVIp88GlxIpbZrVsNMWUlkuQRVu+mPruivGlAjxnC0S0EZ5J7dhrFxrtK+S+k/G5iq/dTVLJqhC8cfwv9iMjFLGEVgnA1S/4p+uUdIaWiBox3hCzj6ye/IHRW6h5Cz/5qlBnLFE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(6506007)(4326008)(6636002)(316002)(1076003)(52116002)(5660300002)(186003)(16526019)(66556008)(66476007)(8936002)(6486002)(8676002)(110136005)(6512007)(2906002)(6666004)(44832011)(26005)(66946007)(2616005)(956004)(38100700002)(83380400001)(38350700002)(86362001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jr0Dc2OFp/A7QU1dAv7KFNRidRYI4FE8EjZ/t2MHtg8yDSZ5bDP47vpgz0WT?=
 =?us-ascii?Q?ZOlEIt/fo9eoLZan4PRS4oZCloBbYiWx2fdQB0AWh0Z5tpb/A3Za4HeLfd/b?=
 =?us-ascii?Q?Vklsb+BP7V7blcgbuOg8nXxhv7PUfP8BZFNTx4SWhJHP5M6TGN6vfyw8NDe/?=
 =?us-ascii?Q?f61YQR4GeqwkJl0TJ6VcwCguXfzPu0wj97PFfzFxbRmTCH1fGI1JghjemVpq?=
 =?us-ascii?Q?iOTv2yXMWSOU9yTbTqU5ayoKPkLtFgZDAaPi/QDsmYTy4Wh238Xlx5uA55u8?=
 =?us-ascii?Q?3q9wmoh/X2T3nGcOMGFnMNveF/V8AzozE3y6PwGhX4/uQZPJ3Sjy0aPyDM+s?=
 =?us-ascii?Q?YfsMfpFT9YgHfEYt9jFQPtbISvLgeBezxJClgoYJA/K1SL5648D/2TsrVGPl?=
 =?us-ascii?Q?Jp28JPeta14Dt4Est9zlbNW0u89ulMECAiLL9iSUGQX6uhdaSSqhRTFev6Vt?=
 =?us-ascii?Q?1vYZKmjCW23PaoMlgCo0B9Fn3o5trp2a+NQ6r134UpsNEcimkHcLoHbQHpJv?=
 =?us-ascii?Q?PaEf3c3znug/510tYrMXvbTX4JO6pwxHGv8QPBbFzb/zC3A9a2VQHkP62/Qb?=
 =?us-ascii?Q?jSrTMh2re6aUx8zaF2XZZN/augXqKO/Q13XpsBlztRHa4dCgXVBQdz5rf2IJ?=
 =?us-ascii?Q?hQzPsDxhutKu/GfGO5N8jyLkigcdoY04MGBAQrDziVFuu2yMewKo11R2RVjR?=
 =?us-ascii?Q?p9W4fRdSBBpMsFPOv5DAyTcrRErDQHkqw33srGGcTq51qijHruWfDBwKQN4S?=
 =?us-ascii?Q?+2P42Sxswxi46tA/R9uqD3BR7g5Btj8GyOyNTWq/EAaQqUhQehC8lOyGZa53?=
 =?us-ascii?Q?gBTN33QAjLLe4bbHiNVHurcNXdXvG0H5oAaf09HQOXTYN1zUh5BSO1EUm2al?=
 =?us-ascii?Q?KXaPOxLjUgIKhEV8iaPnKb9sLAAH8ZZyDQHbv30ESDWz/gK5OJAA7+lZ3nR0?=
 =?us-ascii?Q?5BOXQ1/RPw0UR27OBxs5vyMqVbH+OebCfo096v5226YW8O0GhOHOQDS6p9kS?=
 =?us-ascii?Q?VRp7V9+w82is0XnHiSHU/O/LLXCGNKYSN8kxhCiq7puY+ySgLtJVgZwMHYrR?=
 =?us-ascii?Q?4UtOFzn/ynSUroLiDaqkErxtkj46IMyI2a7JG9taUz8G/rm0+huoshRRdVRo?=
 =?us-ascii?Q?KkuLSuZs3d8dw/JSpdp+oVnKqLVxyVdfGovwIcABL7O2kxuuRq6x270qrqIw?=
 =?us-ascii?Q?T2mBiMY2xARBeOC4TX+cfxF3G4XT0OsCawTOJva4fBL2a6hrGfoXEU5oRleN?=
 =?us-ascii?Q?SZHijmkznU1NSN/hGtWirZ83adsiSJdr1Sx3I5EiPp8Mwt21mjs5vkAGBiFK?=
 =?us-ascii?Q?6eQ0mPsvyNh0+X3d4ePb1oHs?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87965869-675d-43b6-2dbc-08d91073a328
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 09:45:09.7653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jx3CsxYnDOr8UZG+lyy3Q7z6PofFcfchLOMVoBRdSLkdyF4eF05YD6Q3lZ8hDjFeYbGkuG7C1YE09bym07YBzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8838
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
I am sending it as an RFC as I am not completely sure this is the right
way of fixing the problem. In particular, I am wondering if implementing
separate taprio qdiscs for the software and accelerated cases wouldn't 
be a better solution, but that would require changes to the iproute2 
package as well, and would break backwards compatibility.

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

