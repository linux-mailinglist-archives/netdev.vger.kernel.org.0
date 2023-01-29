Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5071D67FF53
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 14:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjA2NSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 08:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjA2NSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 08:18:05 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2088.outbound.protection.outlook.com [40.107.8.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4248413504
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 05:18:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOj9GlGG4dk7pgjOmp7mIbiK14uOp9MSpXcCnK3oCh9sz3UCDVnVf10QKia3V719F3G9E9u26xRgz4UkuRQgiWhJGoo0OHowm8tV9szxmQcjWE9JP5zS2bltVUSgqu2R/HKmKwTMoJh/Uh5Oqx+oOWRRbhiS0w3fhUeE7TF0QJBRTJ6ApzwqmbmGLda4k/FMIxXYakGOKCn1e17gY5JYT04gmcWqNQUeFuYQuVHkEpauDLYNTqjb6hAhMtCVsWNga0XBJKYek6F54yCzR/gZODte4dEUtob2M2EOWuxHXBEvqaimB+dDQANOjdbpgEt2odZqFmdFHR7dR2WdQSpX5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0YT/0zUlJJKUmPkVrau1f2ZgIOCaD4fxLfG4rrWINZc=;
 b=FL4irtyq+HgZxr1GwAZUtemBDAccW3nOaQjqtKEGbQfLWHgT0fg9//RI/VQeo4+VrVK1rB4Oiz+nrE8wsV/8Jp76XkfyyG4agjOFP9RH1BHbN4gv7/S7/xqy0SmgQbHjYjp83QG/+HCQoFP+4CKVxLIjKQpL24zL9ng247zHEdVNKccAn9uNlhOUVJDGd1K09miDZUR789Vw0la664M/OQy2CuZYL651qDxxvBIYRoaJpIC9pzt/cUaeIpmpP9x0iLLhwzezGVTaV5czR90RdNOMpVZMrZSNRN383xi2QCZh48zgeRaCwJDUS+tMAOMBmSDcYLnXWBUznleJDrpH7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YT/0zUlJJKUmPkVrau1f2ZgIOCaD4fxLfG4rrWINZc=;
 b=fgTMzpxtNnQ3UpSQaKpPSo4smgeKIZKRM6bgTjnyJlzluTlOVdgb/jfAsClemD48bAjreLMeOQ48j3c1083U2n7cxtpUXyCEhltRdJgWKZJzu8VHshUORomgc5i0qZAPSOI/DEBz3iQiubKBzcXJRv2LiLLrykjVlotJzrPSZV0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9668.eurprd04.prod.outlook.com (2603:10a6:102:243::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.28; Sun, 29 Jan
 2023 13:17:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6043.033; Sun, 29 Jan 2023
 13:17:59 +0000
Date:   Sun, 29 Jan 2023 15:17:55 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 05/15] net/sched: taprio: give higher
 priority to higher TCs in software dequeue mode
Message-ID: <20230129131755.6uyekemd65243vg2@skbuf>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-6-vladimir.oltean@nxp.com>
 <87k016vp9m.fsf@kurt>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k016vp9m.fsf@kurt>
X-ClientProxiedBy: FR0P281CA0005.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9668:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c56a92b-3e2d-449a-4584-08db01fb3e06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XzaaXoOPbDGhw5ABtlHM5rKwDfNhtx5HH1oAQgNYYU9tzp1HSuUpfiWhfUEdBRilirl2YgCn26teDiJb+1VvaP4bGB7nWmutACyfm4Cza2ycGXQxcfxSjhNrMYF8pT0ewovJdwNCe9koxRuja/Jri66M42JlXQkyte0925sfzi4sKmnwIzt9Ey9bVLttPC4l2nQtpNezpR6sLoHlO2oCqBi9g/OJkW3rU+oiBOK/9V3e4Y4/kgTsCp9s3dSEBKAEx1138cd2wawGViKE2eAxe45ITNtD85wv+armtyS/Uu/V1CvD1eAx2nCVwj1YBtLcKXaWz2LcUET8iEfOkhSKRgRiNT5WYBnJWSL4c3OWzohouugaGqN/rH1ESLVkPUAuhevQSLxkBZUECnwQOSHJmljDjCj37HNPddFFd78LBOcUH9UQE33LSxu6OMFQBDI0IkVPjpBktrRhw39p6z/tbfWeLvDDOHf6NZe732oPhMH7xeta4A2iew6+qGcBP8s8XVXemMC8kdYaCHX/Grr6uNrF0PBvY9lFk8KvyGIWx6cw2HHUnSEl9jPvM/ORdj/QONAe0uQmle4B9iykMGFVO4LJuTxq/32aLADuc1BSLWkQRExiixF+Tq7IkPbjl6X+ZBnpERfmobz5CDBvl0EwSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(396003)(366004)(39860400002)(346002)(376002)(136003)(451199018)(2906002)(83380400001)(8936002)(6486002)(478600001)(316002)(4326008)(6916009)(66946007)(38100700002)(8676002)(5660300002)(6666004)(66476007)(66556008)(53546011)(86362001)(30864003)(44832011)(41300700001)(26005)(186003)(33716001)(6506007)(1076003)(9686003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Ye/9/cx7DMAK1tOivVacgQY8rDkAFSKmwM/XUDkKYpFQrPGKdRkkM8EVOgT?=
 =?us-ascii?Q?p7riav5kHOZBe/4//osQTlrDRG9pGo0bp2GffepMc2cVpLBtltXu1JTeY6Zj?=
 =?us-ascii?Q?Q0/6ufgIo/eSjLvT1tlGe8G02FGnztrEhSt86DfIiWxhP0qN5XvOmIrjoTCQ?=
 =?us-ascii?Q?FUorUgjUwlEULfB3p2425CihTYf/gvEjATUyBYoCgc7suuKm8jfwljJZ0OVP?=
 =?us-ascii?Q?dWyGsjODDa5fZiZthsBYtJ0ga8WtZ2b6QJkJ+H2H6FV3gkzcg6uPaX4zGj0y?=
 =?us-ascii?Q?f0qtq1Sy+aHTXLeyTNGG5a/dVaVELxj3cJ/sCgRzP7nYHgxJ05HcWXMMbLyc?=
 =?us-ascii?Q?a+jTpquDwS8OfqO5O9BLKfBrM892DUQ4cZhq1rsD/mv1AQVmNiTj7WKBA9fd?=
 =?us-ascii?Q?aLqVhuBMAPjPoIOBmLnJL7S4OonNqh5+BUd9kmsKZcjPt+ydpdnTew5ODNlf?=
 =?us-ascii?Q?97a7MB+5u/uJ6XEz2bfbjBs37gkXrKVrOZl3udGWi1nwNrGilcMxwgO3isI1?=
 =?us-ascii?Q?KxJ45qlOr0MgTPlxZXQ9WC4PWStucqe+O7mBYTVmiSRSyR/VwHXxcK17KEAZ?=
 =?us-ascii?Q?srm0WlkcUWVaxDjBzmFmuBqdXY4ltC5+UP49yfoUK1Uwl78k57ta2SbA8QJm?=
 =?us-ascii?Q?qnn6JBRS+KSGXiLJVxQBKMvanbFaScO6jUMLL2oPaQZ1euhc5S6MNBYAdOFX?=
 =?us-ascii?Q?+xPS8wjQ+zQRLEVEOW7PLVwBfyGdeiiIfcxQ07ZNuoHXNJxCMDKoCrdUu7Gj?=
 =?us-ascii?Q?v1tRsua2Fo8/i4oTeZmfI2Ixhx9nyf3iJRH+q38EkCpNMxsRTyQYLjLkbf0C?=
 =?us-ascii?Q?rgDjjbgmbRoJflajDko1Wzyuy/fHkXfUGlntxspo+bM0dclBgZimpM/HuoMY?=
 =?us-ascii?Q?Gj1tBDjx9PMMKq873gCFaCjwNRHQUORaxjTDbqzfXjkAmaPp3q/MoYClWBZz?=
 =?us-ascii?Q?nS4gamoknO1A3xnv7O/JMQDWTZQyfHs05ZKePP9H2Y1M/x+RuP80gV2Jo6E4?=
 =?us-ascii?Q?VfdCv1oQR91O5azW7ezEs1/Zp0YH9HRnp3lpBe49eNtRoiVRyq/HtfOcIdWx?=
 =?us-ascii?Q?XiXiS9NVmZKEpejAPED70unSz67zO2iuTvcFa6l308XzyeTo4bdZVvcT1zoE?=
 =?us-ascii?Q?Sooa94POVk8oGFBiVGyrLAhQJKeGBrsBOlnKT8v2+CsPFSb8F7DNs9qJ89vM?=
 =?us-ascii?Q?HlcIBK+eJzTaHh9u7t237zpg18BXp3Zd4uGQWd2HKPYzrdox2ELAwSJsDGVV?=
 =?us-ascii?Q?Hb+1t1FiGVdIhDbezXY9AaiEaF8qCBT6NwDk+hpAUkWWOVd5MMOSceNODKOv?=
 =?us-ascii?Q?XaeIu4jFGm8ebk2Uzdrr3wQxml3uNO0SBIfpwcHV5wOgotpgZnHz71TpTb+A?=
 =?us-ascii?Q?6NXwjVx5fKoMUm1iLnJO8akcJgf1FuPtZVfpM34qoWtV6ulDW4rq5hZf45w2?=
 =?us-ascii?Q?uF9ZqXbtAQnxk6X1GVpSXEAdedqFWhOiMmewReOVIJMzvBl9vfwLFajrnTD6?=
 =?us-ascii?Q?Wgqfj+ip/2IpYCkcFT9ZjX2U5nBa0J12ROhtmGeK3MWqvCJVgW4fmlJEJtAf?=
 =?us-ascii?Q?FrieVhlKVFQI7TdEP7pRKuz6RR2L2gvWaOJdNaRbH7I0kh9lHY7QOfnz5ctp?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c56a92b-3e2d-449a-4584-08db01fb3e06
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 13:17:59.4886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qVZP7JzEm0vz11whmIgnOQ3tlMmxTHktdKiWZSH6Ve2tipyg0PolKX/0Xuf7wW+vECxuttBhtRCgHrRulVo93g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9668
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 01:04:37PM +0100, Kurt Kanzenbach wrote:
> > Something tells me Vinicius won't like the way in which this patch
> > interacts with TXTIME_ASSIST_IS_ENABLED(q->flags) and NICs where TXQ 0
> > really has higher priority than TXQ 1....
> 
> However, this change may be problematic for i210/i225/i226 NIC(s).
> 
> AFAIK the Tx queue priorities for i225/i226 are configurable. Meaning
> the default could be adjusted to have Tx queue 4 with higher priority
> than 3 and so on. For i210 I don't know.

Assuming the TX ring priorities aren't configurable, it's just a matter
of mapping the Linux traffic classes to the TXQs correctly, am I right?
So TC 3 to TXQ 0, TC 2 to TXQ 1, TC 1 to TXQ 2 and TC 0 to TXQ 3?
What prevents Intel from telling users to do just that?

I see neither igb nor igc implement mqprio offloading, but you're saying
they have intrinsic strict prioritization. So the default configuration
is already a problem even without taprio/mqprio, isn't it? How many TXQs
is the stack aware of? All of them? Since neither igb nor igc implement
ndo_select_queue(), the network stack performs skb_tx_hash() per packet
and selects a TX queue of arbitrary hardware priority, or am I missing
something?

My knee-jerk reaction is: when we say "this change may be problematic
for X/Y/Z", aren't these plain configuration bugs that we're so
cautiously defending?

Anyway, I also need to be very realistic about what's possible for me to
change and how far I'm willing to go, and Vinicius made it pretty clear
that the existing taprio/mqprio configurations should be kept "working"
(given an arbitrary definition of "working"). So things like adding UAPI
for TXQ feature detection, such that an automated way of constructing
the mqprio queue configuration, would be interesting but practically
useless, since existing setups don't use that.

He proposed to cut our losses and use the capability structure to
conditionally keep that code in place. The resulting taprio code would
be pretty horrible, but it might be doable.

Here is a completely untested patch below, which is intended to replace
this one. Feedback for the approach appreciated.

From 4a83f369ffce71361c90618ce2ea8ec2ee97ad78 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Fri, 27 Jan 2023 18:16:44 +0200
Subject: [PATCH] net/sched: taprio: give higher priority to higher TCs in
 software dequeue mode

Currently taprio iterates over child qdiscs in increasing order of TXQ
index, therefore giving higher xmit priority to TXQ 0 and lower to TXQ N.
This is because that is the default prioritization scheme used for the
NICs that taprio was first written for (igb, igc), and we have a case of
two bugs canceling out, resulting in a functional setup on igb/igc, but
a less sane one on other NICs.

To the best of my understanding, we should prioritize based on the
traffic class, so we should really dequeue starting with the highest
traffic class and going down from there. We get to the TXQ using the
tc_to_txq[] netdev property.

TXQs within the same TC have the same (strict) priority, so we should
pick from them as fairly as we can. We can achieve that by implementing
something very similar to q->curband from multiq_dequeue().

Since igb/igc really do have TXQ 0 of higher hardware priority than
TXQ 1 etc, we need to preserve the behavior for them as well. Things are
made worse by the fact that in txtime-assist mode, taprio is essentially
a software scheduler towards offloaded child tc-etf qdiscs, so the TXQ
selection really does matter.

To preserve the behavior, we need a capability bit so that taprio can
determine if it's running on igb/igc, or on something else. Because igb
doesn't offload taprio at all, we can't piggyback on the
qdisc_offload_query_caps() call from taprio_enable_offload(), but
instead we need a separate call which is also made for software
scheduling.

Introduce two static keys to minimize the performance penalty on systems
which only have igb/igc NICs, and on systems which only have other NICs.
For mixed systems, taprio will have to dynamically check whether to
dequeue using one prioritization algorithm or using the other.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c |  18 ++++
 drivers/net/ethernet/intel/igc/igc_main.c |   6 +-
 include/net/pkt_sched.h                   |   1 +
 net/sched/sch_taprio.c                    | 122 ++++++++++++++++++++--
 4 files changed, 136 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 3c0c35ecea10..8eed18efc1e7 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2810,6 +2810,22 @@ static int igb_offload_txtime(struct igb_adapter *adapter,
 	return 0;
 }
 
+static int igb_tc_query_caps(struct igb_adapter *adapter,
+			     struct tc_query_caps_base *base)
+{
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		caps->broken_mqprio = true;
+
+		return 0;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static LIST_HEAD(igb_block_cb_list);
 
 static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
@@ -2818,6 +2834,8 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	struct igb_adapter *adapter = netdev_priv(dev);
 
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return igb_tc_query_caps(adapter, type_data);
 	case TC_SETUP_QDISC_CBS:
 		return igb_offload_cbs(adapter, type_data);
 	case TC_SETUP_BLOCK:
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index cce1dea51f76..166c41926be5 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6214,10 +6214,10 @@ static int igc_tc_query_caps(struct igc_adapter *adapter,
 	case TC_SETUP_QDISC_TAPRIO: {
 		struct tc_taprio_caps *caps = base->caps;
 
-		if (hw->mac.type != igc_i225)
-			return -EOPNOTSUPP;
+		caps->broken_mqprio = true;
 
-		caps->gate_mask_per_txq = true;
+		if (hw->mac.type == igc_i225)
+			caps->gate_mask_per_txq = true;
 
 		return 0;
 	}
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index fd889fc4912b..9bf120fb2073 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -177,6 +177,7 @@ struct tc_mqprio_qopt_offload {
 struct tc_taprio_caps {
 	bool supports_queue_max_sdu:1;
 	bool gate_mask_per_txq:1;
+	bool broken_mqprio:1;
 };
 
 struct tc_taprio_sched_entry {
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 163e5244a9af..cef9b3e8d29e 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -27,6 +27,8 @@
 #include <net/tcp.h>
 
 static LIST_HEAD(taprio_list);
+static struct static_key_false taprio_have_broken_mqprio;
+static struct static_key_false taprio_have_working_mqprio;
 
 #define TAPRIO_ALL_GATES_OPEN -1
 
@@ -67,6 +69,8 @@ struct taprio_sched {
 	enum tk_offsets tk_offset;
 	int clockid;
 	bool offloaded;
+	bool detected_mqprio;
+	bool broken_mqprio;
 	atomic64_t picos_per_byte; /* Using picoseconds because for 10Gbps+
 				    * speeds it's sub-nanoseconds per byte
 				    */
@@ -78,6 +82,7 @@ struct taprio_sched {
 	struct sched_gate_list __rcu *admin_sched;
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
+	int cur_txq[TC_MAX_QUEUE];
 	u32 max_frm_len[TC_MAX_QUEUE]; /* for the fast path */
 	u32 max_sdu[TC_MAX_QUEUE]; /* for dump and offloading */
 	u32 txtime_delay;
@@ -566,17 +571,78 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 	return skb;
 }
 
+static void taprio_next_tc_txq(struct net_device *dev, int tc, int *txq)
+{
+	int offset = dev->tc_to_txq[tc].offset;
+	int count = dev->tc_to_txq[tc].count;
+
+	(*txq)++;
+	if (*txq == offset + count)
+		*txq = offset;
+}
+
+/* Prioritize higher traffic classes, and select among TXQs belonging to the
+ * same TC using round robin
+ */
+static struct sk_buff *taprio_dequeue_tc_priority(struct Qdisc *sch,
+						  struct sched_entry *entry,
+						  u32 gate_mask)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	int num_tc = netdev_get_num_tc(dev);
+	struct sk_buff *skb;
+	int tc;
+
+	for (tc = num_tc - 1; tc >= 0; tc--) {
+		int first_txq = q->cur_txq[tc];
+
+		if (!(gate_mask & BIT(tc)))
+			continue;
+
+		do {
+			skb = taprio_dequeue_from_txq(sch, q->cur_txq[tc],
+						      entry, gate_mask);
+
+			taprio_next_tc_txq(dev, tc, &q->cur_txq[tc]);
+
+			if (skb)
+				return skb;
+		} while (q->cur_txq[tc] != first_txq);
+	}
+
+	return NULL;
+}
+
+/* Broken way of prioritizing smaller TXQ indices and ignoring the traffic
+ * class other than to determine whether the gate is open or not
+ */
+static struct sk_buff *taprio_dequeue_txq_priority(struct Qdisc *sch,
+						   struct sched_entry *entry,
+						   u32 gate_mask)
+{
+	struct net_device *dev = qdisc_dev(sch);
+	struct sk_buff *skb;
+	int i;
+
+	for (i = 0; i < dev->num_tx_queues; i++) {
+		skb = taprio_dequeue_from_txq(sch, i, entry, gate_mask);
+		if (skb)
+			return skb;
+	}
+
+	return NULL;
+}
+
 /* Will not be called in the full offload case, since the TX queues are
  * attached to the Qdisc created using qdisc_create_dflt()
  */
 static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
-	struct net_device *dev = qdisc_dev(sch);
 	struct sk_buff *skb = NULL;
 	struct sched_entry *entry;
 	u32 gate_mask;
-	int i;
 
 	rcu_read_lock();
 	entry = rcu_dereference(q->current_entry);
@@ -586,14 +652,20 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 	 * "AdminGateStates"
 	 */
 	gate_mask = entry ? entry->gate_mask : TAPRIO_ALL_GATES_OPEN;
-
 	if (!gate_mask)
 		goto done;
 
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		skb = taprio_dequeue_from_txq(sch, i, entry, gate_mask);
-		if (skb)
-			goto done;
+	if (static_branch_unlikely(&taprio_have_broken_mqprio) &&
+	    !static_branch_likely(&taprio_have_working_mqprio)) {
+		skb = taprio_dequeue_txq_priority(sch, entry, gate_mask);
+	} else if (static_branch_likely(&taprio_have_working_mqprio) &&
+		   !static_branch_unlikely(&taprio_have_broken_mqprio)) {
+		skb = taprio_dequeue_tc_priority(sch, entry, gate_mask);
+	} else {
+		if (q->broken_mqprio)
+			skb = taprio_dequeue_txq_priority(sch, entry, gate_mask);
+		else
+			skb = taprio_dequeue_tc_priority(sch, entry, gate_mask);
 	}
 
 done:
@@ -1223,6 +1295,34 @@ taprio_mqprio_qopt_reconstruct(struct net_device *dev,
 	}
 }
 
+static void taprio_detect_broken_mqprio(struct taprio_sched *q)
+{
+	struct net_device *dev = qdisc_dev(q->root);
+	struct tc_taprio_caps caps;
+
+	qdisc_offload_query_caps(dev, TC_SETUP_QDISC_TAPRIO,
+				 &caps, sizeof(caps));
+
+	q->broken_mqprio = caps.broken_mqprio;
+	if (q->broken_mqprio)
+		static_branch_inc(&taprio_have_broken_mqprio);
+	else
+		static_branch_inc(&taprio_have_working_mqprio);
+
+	q->detected_mqprio = true;
+}
+
+static void taprio_cleanup_broken_mqprio(struct taprio_sched *q)
+{
+	if (!q->detected_mqprio)
+		return;
+
+	if (q->broken_mqprio)
+		static_branch_dec(&taprio_have_broken_mqprio);
+	else
+		static_branch_dec(&taprio_have_working_mqprio);
+}
+
 static int taprio_enable_offload(struct net_device *dev,
 				 struct taprio_sched *q,
 				 struct sched_gate_list *sched,
@@ -1588,10 +1688,12 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		err = netdev_set_num_tc(dev, mqprio->num_tc);
 		if (err)
 			goto free_sched;
-		for (i = 0; i < mqprio->num_tc; i++)
+		for (i = 0; i < mqprio->num_tc; i++) {
 			netdev_set_tc_queue(dev, i,
 					    mqprio->count[i],
 					    mqprio->offset[i]);
+			q->cur_txq[i] = mqprio->offset[i];
+		}
 
 		/* Always use supplied priority mappings */
 		for (i = 0; i <= TC_BITMASK; i++)
@@ -1742,6 +1844,8 @@ static void taprio_destroy(struct Qdisc *sch)
 
 	if (admin)
 		call_rcu(&admin->rcu, taprio_free_sched_cb);
+
+	taprio_cleanup_broken_mqprio(q);
 }
 
 static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
@@ -1806,6 +1910,8 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 		q->qdiscs[i] = qdisc;
 	}
 
+	taprio_detect_broken_mqprio(q);
+
 	return taprio_change(sch, opt, extack);
 }
 
-- 
2.34.1

> Also Tx Launch Time only works for the lower queues. Hm.

Lower TXQ numbers or higher priorities? Not that it makes a difference,
just curious.
