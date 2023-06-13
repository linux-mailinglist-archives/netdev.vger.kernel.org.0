Return-Path: <netdev+bounces-10535-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CE8F72EE63
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:55:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 677531C20931
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5B7D3ED88;
	Tue, 13 Jun 2023 21:55:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9469E17FE6
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 21:55:13 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03171FC2;
	Tue, 13 Jun 2023 14:55:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d2gjde760FgVKaqaYR65SaBSUaDHDGMPDwX0CSSuHRkmvTtYGhYvqy4QSBMHhScz0OzojIUNfSsYytYNDxMAX/A2vCWpgRKlBI5dWAHZxskw3Y5qY51UyXp0mC/m2r1E/6iwgtdzuBzgnPCzXSW6+JnntphdkvKb1qvZx9QedBK2kgUbE5kDibblUO+euVFA4whTqdt0U9rDL3e5zw3ztvdYKfpUPRUBKpSo+JgCt1SR6o7gL5pX4VFot3tFjH/v+Og4y5tyuKqvuN0k3K3aR6NetAByhJtK7Jm5ypU7Q+BuB0iWK6KmXTgDcmmHecqg4xfUzglgVeABKRy2dqToWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n3gEstquR+TN9FFCuvBI5iKzqQAK/JnwRznKpXQ8Ps8=;
 b=L/QYeZ9Ia2uUp/FagbawLc4lpHdqyorqYtQA6CQZPlymBL4Bj6apSq3THuNVqb4jLRtydCzA+1mbXK1hh27uiaL6YPrCuoUrQCpiTn5YRNjGGt2MtLtodCr3+X1n0E+8q+MGHncQ7QoHeB2GXy9x0/1PiwmdNO1yPs/sYjWpDwBUsU6XqtfLT5u+u9oTOSPpMaBVs0IgShu0jg5bIe6YExHZXxwb32GaOIq/iz3Yz5dIKqLtkXf0lWz83rreYudLXXKIQRMLApgACB0SQKLmP+QqV2LSq/00zj+1SriYbZITZW8qr6ESwBr9SfGzVZ3RSA/JegKbWxt5V/1DZygzUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3gEstquR+TN9FFCuvBI5iKzqQAK/JnwRznKpXQ8Ps8=;
 b=VFE0r8UZQAUpTs/7uNGuINmzg9+j0AQ7mYUZkQqMny+39UnyxjgT4i7qZifO4flLyFtWv9HhxYR61Ls5Bzndjc0V8dRg0g9t4Q7FhQBHdR7fzL/k5+IwoGA200uStjQ7eVwWIFd4raIyK7p0Y0LjJm9D6t4+FEzCQk9xjsy0TT4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8081.eurprd04.prod.outlook.com (2603:10a6:20b:3e2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 21:54:54 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 21:54:53 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	linux-kernel@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Maxim Georgiev <glipus@gmail.com>
Subject: [PATCH v2 net-next 2/9] net/sched: taprio: keep child Qdisc refcount elevated at 2 in offload mode
Date: Wed, 14 Jun 2023 00:54:33 +0300
Message-Id: <20230613215440.2465708-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230613215440.2465708-1-vladimir.oltean@nxp.com>
References: <20230613215440.2465708-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0044.eurprd04.prod.outlook.com
 (2603:10a6:208:1::21) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8081:EE_
X-MS-Office365-Filtering-Correlation-Id: 169996e2-73ea-4641-95b4-08db6c58d1da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2DLb8iC8kiHjXGqbcyVoO98rr2ILEb973S2c2pZ+4sMT6pRo9a5ITGVXMZTw97nxkVzfgxlXQ+lTJTHSIZo+bCcP4yFQBqx3QL8RWx7jF0L7nnAB2vlXaB2wQWQkkgMbjeUY8SgCgEPsmpasM5FKm2HLSizSo6qIZFk29B+L9ML7p8vHuv72c3Gm9b6tF/9/Rb+XOzEyo3QtXnEBgAwXSsbrOtvKSH9LRCfkRKLGDLnQsLijMigddWuO39K/NSnJoGAJm43eA+F4WheDIWpZMPygic5SV+U6XLg7XlGr1j9Q2gsWDiH5mCdPoIohQrdEKa5/AJLSx0qEs+VNwuzqK97b/v3xg9/TEk5Nc+JEAiODRDCYPZR3bYDeJNsMr4yZto8tiu3PxdA6OQW1ptQUobYeS/RHNz0+3kwVTa47xTG5dqNcutTMsxJSPefNSJ6Ci3F22KCqFHfh+ora27FchRhgcfPvCb4dkJEsQ8OKl3A0rsb921gXvzDMI4qdRvsPWIsbALGVKgeeMXYJBzUsaBbuPWsMfVJtzp9e8iOL+/p8/Vj+frqh/iixOk9Zsw9/08ovTz+6X/L8R5wtgRXdRIu/44CuCQdZeOSoXOubztAHMjqXtxjGXtld7cbI5TkQ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199021)(6916009)(66946007)(4326008)(66556008)(36756003)(186003)(54906003)(478600001)(2616005)(2906002)(66476007)(8676002)(6666004)(316002)(41300700001)(86362001)(6486002)(7416002)(6506007)(1076003)(8936002)(44832011)(83380400001)(26005)(5660300002)(38100700002)(52116002)(38350700002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9VyWzot9A1Y/baEVq4kWcIzTri7UgKdcdD1sBeALR6Af9rIwCt1Ev4oW7Qa9?=
 =?us-ascii?Q?cwt3XxG1XoQaTJN2xDPDtHe6zzRcrVztC3vPPd/kUTbLCpfLNnOFjGrolTVH?=
 =?us-ascii?Q?nawcayz9mu7s6fKI4g0hxOAYe24oC5Rp6S4fTMuo3QW/NV5jLwkISvySQHbQ?=
 =?us-ascii?Q?/MV+80+VrXNxX1yxY3xBj4lra5DKNqvohnVc2IsQT8EYRul0EgRLwy/G3Goy?=
 =?us-ascii?Q?NQkkxKWWePoOJF29p47CIgTl+f1nIME+I7ki7Ydr7Kvda+wfGDVTT07jHXCL?=
 =?us-ascii?Q?hF7/vDVxBKTBiH6YNhhDgmIyz6p5JePj5HoVGrdl1tZwA0Yp/JrtzbYr7tx2?=
 =?us-ascii?Q?kRrRnBB4VaiFW2Lpuyufc34nGMSpvnJD3ep3e2ni+C+hac2pS9pGuVCHbK9p?=
 =?us-ascii?Q?3PK+yjkCKD5ebrhkW0M2WdisT55qHBdMj5DyU1jaYeKOYd5EvRCufuMTuOzv?=
 =?us-ascii?Q?zUDoVsgVKiGUwY6aZKupFBUhkaIInfzRqGqt87/8AP/H7xXtSo7bVr3AUgCr?=
 =?us-ascii?Q?n11hfSHSNsN7nx7XsIvzbI6n/Iavryzj0G0rWsup3W6Q8ThqX+xm24G5Gl3f?=
 =?us-ascii?Q?ygMNO/ts9PljDbDMhXLlOdNx8cWiOluvBVDXMTgIWTLM+wQBdNopMAiEcpkP?=
 =?us-ascii?Q?J1SPeKuvs5iankEzIyv688Fbd/njZhzpm0DlbVcVIMHbXOQsZQKfcuGs8Z+O?=
 =?us-ascii?Q?/r4LnI+UWlEIbKx47nJTnUSjsZSJP8GOlV5Mbu1/J9JzaMveSpGtt8o9x1q+?=
 =?us-ascii?Q?n8j4EyQwUCEFLXobH1VPfIhO8QLlEyv2ljyojrbQsLy0MRjk3ecWhb6dkFBP?=
 =?us-ascii?Q?8Wt0dpNP4OJbXwuszk+LP+ryDUMFEWgQTFn1TtiP5yZJlnh1YxYVTO0OzoyZ?=
 =?us-ascii?Q?2+3j5nfyUNenCoFk2/pr67CC5CyhDb1M/UtOlctTqkIuAJy/fJaqBkn9I4fg?=
 =?us-ascii?Q?7KT+FcIYvfvHGQF3UbmnOVaUl/jhXWzvJO2rrXYH0dUbgjLbCPC/6oqzEcYB?=
 =?us-ascii?Q?on1Qr/BotnZS8ar3vWp76riAMTo+7DCxPZnKB9BFlONCoCo/ibpuESqKdStg?=
 =?us-ascii?Q?xXFzRp/jJoVpxrZC0XKBaHmgJdp/md/Nz+mfcjI03fs29yI1IYKutfVCFPzC?=
 =?us-ascii?Q?HeiEsHSlaTDqaIjkmrPTI7bjsGvazImxDRUAOhOWpGzkRWDAzKI8h88Iarku?=
 =?us-ascii?Q?aU6edgkw+LMP+jRoDN+/8QzCkH6QK22ER5roFMaD0Vjpi+Y3CBGFYmKJTd0w?=
 =?us-ascii?Q?8+PvVtV3Q2XnHIHFZ0BROkllGJoEyj+hIc5TWJc9TvRmIrc0GQEqArEoIvoE?=
 =?us-ascii?Q?EIAp5ATIW11V6BXIm949b50sriaER/fB6EhqzTNuQw6OUGUHf5CPy/WijXFS?=
 =?us-ascii?Q?oY7E41fJUjlmhHcrgArHLyAQSZ2Rg7+3cDyopqGGdzZH0RYxEYqdROaycHz3?=
 =?us-ascii?Q?+sDdAZD2LKbd8q3EWaGFRM67a8sbCXK7hB2L3xHUfLzsWkHwBHA2oaO0v3Me?=
 =?us-ascii?Q?8MgNTkjV7snp6EJ1OOU4+uY5tJnk0UG2krojEhlfk9c88bZbQ56JYV1r/9fa?=
 =?us-ascii?Q?ukntSJkR7IggWK3JTGAiCQB2RBEQ8XhqyjqEG9XqOUPE/QzNxwkNIJgJf80B?=
 =?us-ascii?Q?sw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 169996e2-73ea-4641-95b4-08db6c58d1da
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 21:54:53.9020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2InGh1lT6j46Ma5tjYne7h/WWzCsUVTcATFy/rTcx7exoY03RtLRBkV9V13/WQdqOq2CfFzjpR8WIM/Kwo7Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Normally, Qdiscs have one reference on them held by their owner and one
held for each TXQ to which they are attached, however this is not the
case with the children of an offloaded taprio. Instead, the taprio qdisc
currently lives in the following fragile equilibrium.

In the software scheduling case, taprio attaches itself (the root Qdisc)
to all TXQs, thus having a refcount of 1 + the number of TX queues. In
this mode, the q->qdiscs[] children are not visible directly to the
Qdisc API. The lifetime of the Qdiscs from this private array lasts
until qdisc_destroy() -> taprio_destroy().

In the fully offloaded case, the root taprio has a refcount of 1, and
all child q->qdiscs[] also have a refcount of 1. The child q->qdiscs[]
are attached to the netdev TXQs directly and thus are visible to the
Qdisc API, however taprio loses a reference to them very early - during
qdisc_graft(parent==NULL) -> taprio_attach(). At that time, taprio frees
the q->qdiscs[] array to not leak memory, but interestingly, it does not
release a reference on these qdiscs because it doesn't effectively own
them - they are created by taprio but owned by the Qdisc core, and will
be freed by qdisc_graft(parent==NULL, new==NULL) -> qdisc_put(old) when
the Qdisc is deleted or when the child Qdisc is replaced with something
else.

My interest is to change this equilibrium such that taprio also owns a
reference on the q->qdiscs[] child Qdiscs for the lifetime of the root
Qdisc, including in full offload mode. I want this because I would like
taprio_leaf(), taprio_dump_class(), taprio_dump_class_stats() to have
insight into q->qdiscs[] for the software scheduling mode - currently
they look at dev_queue->qdisc_sleeping, which is, as mentioned, the same
as the root taprio.

The following set of changes is necessary:
- don't free q->qdiscs[] early in taprio_attach(), free it late in
  taprio_destroy() for consistency with software mode. But:
- currently that's not possible, because taprio doesn't own a reference
  on q->qdiscs[]. So hold that reference - once during the initial
  attach() and once during subsequent graft() calls when the child is
  changed.
- always keep track of the current child in q->qdiscs[], even for full
  offload mode, so that we free in taprio_destroy() what we should, and
  not something stale.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- fix refcount not dropping to 0 after a graft operation - spotted by
  Paolo
- slightly reword commit message and comments

 net/sched/sch_taprio.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 3ee8a7cca786..b5f533914415 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -2132,30 +2132,31 @@ static void taprio_attach(struct Qdisc *sch)
 	/* Attach underlying qdisc */
 	for (ntx = 0; ntx < dev->num_tx_queues; ntx++) {
 		struct netdev_queue *dev_queue = netdev_get_tx_queue(dev, ntx);
-		struct Qdisc *old;
+		struct Qdisc *old, *dev_queue_qdisc;
 
 		if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
 			struct Qdisc *qdisc = q->qdiscs[ntx];
 
+			/* In offload mode, the root taprio qdisc is bypassed
+			 * and the netdev TX queues see the children directly
+			 */
 			qdisc->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
-			old = dev_graft_qdisc(dev_queue, qdisc);
+			dev_queue_qdisc = qdisc;
 		} else {
 			/* In software mode, attach the root taprio qdisc
 			 * to all netdev TX queues, so that dev_qdisc_enqueue()
 			 * goes through taprio_enqueue().
 			 */
-			old = dev_graft_qdisc(dev_queue, sch);
-			qdisc_refcount_inc(sch);
+			dev_queue_qdisc = sch;
 		}
+		old = dev_graft_qdisc(dev_queue, dev_queue_qdisc);
+		/* The qdisc's refcount requires to be elevated once
+		 * for each netdev TX queue it is grafted onto
+		 */
+		qdisc_refcount_inc(dev_queue_qdisc);
 		if (old)
 			qdisc_put(old);
 	}
-
-	/* access to the child qdiscs is not needed in offload mode */
-	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
-		kfree(q->qdiscs);
-		q->qdiscs = NULL;
-	}
 }
 
 static struct netdev_queue *taprio_queue_get(struct Qdisc *sch,
@@ -2184,13 +2185,23 @@ static int taprio_graft(struct Qdisc *sch, unsigned long cl,
 	if (dev->flags & IFF_UP)
 		dev_deactivate(dev);
 
+	/* In offload mode, the child Qdisc is directly attached to the netdev
+	 * TX queue, and thus, we need to keep its refcount elevated in order
+	 * to counteract qdisc_graft()'s call to qdisc_put() once per TX queue.
+	 * However, save the reference to the new qdisc in the private array in
+	 * both software and offload cases, to have an up-to-date reference to
+	 * our children.
+	 */
+	*old = q->qdiscs[cl - 1];
 	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
-		*old = dev_graft_qdisc(dev_queue, new);
-	} else {
-		*old = q->qdiscs[cl - 1];
-		q->qdiscs[cl - 1] = new;
+		WARN_ON_ONCE(dev_graft_qdisc(dev_queue, new) != *old);
+		if (new)
+			qdisc_refcount_inc(new);
+		if (*old)
+			qdisc_put(*old);
 	}
 
+	q->qdiscs[cl - 1] = new;
 	if (new)
 		new->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
 
-- 
2.34.1


