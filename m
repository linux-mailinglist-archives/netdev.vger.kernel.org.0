Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2BA47493B
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 18:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbhLNRYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 12:24:55 -0500
Received: from mail-bn8nam08on2069.outbound.protection.outlook.com ([40.107.100.69]:40032
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236424AbhLNRYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 12:24:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ey4/52GpipTCgm8NVHTRz19r0gMEyZW6HsJ2Z00X4Gix20FKfgCf1XfpWkmIwhyT8ka9iGe2Q2tdBecN5Oj68MJWNmJ0L5mkIAqmnmPZhept+d2kLXuxEspPOKy82TDSn2CtSrDtp1mg2x/yiniWQsOR+KBvLhY1RNkDg0yQOGCDvLZdvToDYMfbY2vKqel5OD+M52cd7dkprMRwWCIdml1MW/6fThQKfGKRBp5lh3mNTlnnsQofI24M70wy8hQ8HYjm1cBW6we7chKmdVN3swRwwBBNmrOxNk+raBchF+urARlyKrt2yJk60V71BWqZVt82zlYBOrMyueQP0Ja9Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79JM/MbrmODiFRgErMjsuA+5wfvYPFNkA4dhLysjHNk=;
 b=aPPtgkcsalExv40S85WdnwYR8y3YBTctqrBZIX8hJNS7PuCtmexUMKAD+RMOFDM0QEBsDBvdH5jAByaa7Xbd0i0arupCUR8AKAbhKW0UAKxDTsyssf+bdrPf0eo8qyCnuuHYp9ZzXdQxRRcr1TN2QboZ59xZaEaXMjs4UuMUjgXaYPRar6J0VbD2dA2wl3dIFICsoUsSTD8rcYae71TXXBq8hX/jC6GRE6Cbzvx1OW3RxKojxua23ygynErmXsxbhmxUdd6gBVboe9MHwcSxviErE7nV89K3JS2kuv9lbxVtYkr1dOzKqkdsaWd4XNTXH+9VtAB36R7kJ2sVB6LBDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.13) smtp.rcpttodomain=ovn.org smtp.mailfrom=nvidia.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79JM/MbrmODiFRgErMjsuA+5wfvYPFNkA4dhLysjHNk=;
 b=CkSitJYauhcZLk1rhYpgNVqoBkXrCfEO5+os8UMTcCsaAfsyfYTaXnrPjbp7UeO7cdJNASFGSjUyBXMmg1rrIPsf3JQOjBc7GurxIh9clN217swmrz+L/pOI5u4xERP0PRjPQkK+z/Y5kzRTvOS3iWyloPepL3JMk9/w4T3/SADQu9rgdEI9KN1nGaBdDBpnaUBVb2U1UaTrney7mYAzIGVOH71PrQiJoKkFiDwC0nkZE9W6Mui4twgUMfBE56QpYP3rYlKd04gCc7zy0ONVElOaPTtoXUTryxJhPT8E5W++t/ccXTSI8ztos83JOr82VOXoW1KyIutkdVaEwvPssA==
Received: from MW4PR03CA0291.namprd03.prod.outlook.com (2603:10b6:303:b5::26)
 by CH0PR12MB5041.namprd12.prod.outlook.com (2603:10b6:610:e0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 14 Dec
 2021 17:24:52 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::57) by MW4PR03CA0291.outlook.office365.com
 (2603:10b6:303:b5::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15 via Frontend
 Transport; Tue, 14 Dec 2021 17:24:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.13)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.13 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.13; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.13) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Tue, 14 Dec 2021 17:24:51 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Dec
 2021 17:24:51 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Dec
 2021 17:24:49 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Tue, 14 Dec 2021 17:24:45 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, wenxu <wenxu@ucloud.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net v3 1/3] net/sched: Extend qdisc control block with tc control block
Date:   Tue, 14 Dec 2021 19:24:33 +0200
Message-ID: <20211214172435.24207-2-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20211214172435.24207-1-paulb@nvidia.com>
References: <20211214172435.24207-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2070498b-a80e-41f6-a5a0-08d9bf26a35f
X-MS-TrafficTypeDiagnostic: CH0PR12MB5041:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB50418C94E71179EBE2C513CCC2759@CH0PR12MB5041.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qSY4yMgH6TjZdxVSzgA0eim5r3LJIfM40s2EndtAlLC54z7jqCR4bOSEdvaZqsNhr2HgSjl3V8LjhRtkVNBQhbRP5HbHUfXJli4ITk8xzEoaiIIN23xEJkRiS/knuyDK14SgkNAmbZkQAyZ9l209abMzjYofvF0mbBvOH8r7Z65mYSiOjiDxckJOTTlZBq2MMetKfzYRZcPYt8EKjESNE6qqgS67MrmTN5/WfCqN793NgU0Bg0+c9vorXNZUVjDu7PUzxsgAH6Z9t8eD4spjOY/dksIknZXC9BiIv2SHYn96CizdjhxMKLXatNOclSn9gibZldmudxYXo6n6N6SMvzApBywuIkCZbpTgwKLgHO1aJwry9wYvSYS6GCPuaiWV29xXBFsICAycBe7sWcMgu/WFWFKRi4/B/e9cAXdm7XNfQugK/xwCc2JeiBTGYjG+ShP0xXTpImJ8zSCIjZHi/6KKShjFExgz483PUduY+DrymY+0wTuegqYDe/uhniSwQs2qbNoaYapO5MaodOZ/sWW+ubiliqhqihC/jNJpKTL9GLNGeBb0AZXiVX1bFlH+CLV5RPGOIc14kV84PTn1ZKmI2e6VZipFL+FId1qOBPbrgf0joKYrmoTqN7Y6u7yPNplHquB29qvyFKdlEv49LtlCJtuJS7Db5k8WUvrpKWA6d3U5WNQm5BKMZIzN3GJl6uradiF3urAoL69imJYiYNNKs12pxVWrNDayF2b8TodAHuFIDnMBMNB5upKVliQyzIRc37fCLwCAPL1ZXavRQGLgazKs8CDrvhQUpasoIAA2i3gq6QN2oLE/nlAlLDgh
X-Forefront-Antispam-Report: CIP:203.18.50.13;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(5660300002)(2616005)(426003)(7636003)(107886003)(86362001)(2906002)(1076003)(356005)(336012)(26005)(83380400001)(4326008)(47076005)(921005)(36860700001)(186003)(36756003)(8676002)(6666004)(82310400004)(70206006)(70586007)(110136005)(316002)(508600001)(40460700001)(8936002)(34020700004)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 17:24:51.6815
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2070498b-a80e-41f6-a5a0-08d9bf26a35f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.13];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5041
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF layer extends the qdisc control block via struct bpf_skb_data_end
and because of that there is no more room to add variables to the
qdisc layer control block without going over the skb->cb size.

Extend the qdisc control block with a tc control block,
and move all tc related variables to there as a pre-step for
extending the tc control block with additional members.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 include/net/pkt_sched.h   | 15 +++++++++++++++
 include/net/sch_generic.h |  2 --
 net/core/dev.c            |  8 ++++----
 net/sched/act_ct.c        | 14 +++++++-------
 net/sched/cls_api.c       |  6 ++++--
 net/sched/cls_flower.c    |  3 ++-
 net/sched/sch_frag.c      |  3 ++-
 7 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index bf79f3a890af..05f18e81f3e8 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -193,4 +193,19 @@ static inline void skb_txtime_consumed(struct sk_buff *skb)
 	skb->tstamp = ktime_set(0, 0);
 }
 
+struct tc_skb_cb {
+	struct qdisc_skb_cb qdisc_cb;
+
+	u16 mru;
+	bool post_ct;
+};
+
+static inline struct tc_skb_cb *tc_skb_cb(const struct sk_buff *skb)
+{
+	struct tc_skb_cb *cb = (struct tc_skb_cb *)skb->cb;
+
+	BUILD_BUG_ON(sizeof(*cb) > sizeof_field(struct sk_buff, cb));
+	return cb;
+}
+
 #endif
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 22179b2fda72..c70e6d2b2fdd 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -447,8 +447,6 @@ struct qdisc_skb_cb {
 	};
 #define QDISC_CB_PRIV_LEN 20
 	unsigned char		data[QDISC_CB_PRIV_LEN];
-	u16			mru;
-	bool			post_ct;
 };
 
 typedef void tcf_chain_head_change_t(struct tcf_proto *tp_head, void *priv);
diff --git a/net/core/dev.c b/net/core/dev.c
index 2a352e668d10..c4708e2487fb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3941,8 +3941,8 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 		return skb;
 
 	/* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
-	qdisc_skb_cb(skb)->mru = 0;
-	qdisc_skb_cb(skb)->post_ct = false;
+	tc_skb_cb(skb)->mru = 0;
+	tc_skb_cb(skb)->post_ct = false;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
 	switch (tcf_classify(skb, miniq->block, miniq->filter_list, &cl_res, false)) {
@@ -5103,8 +5103,8 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 	}
 
 	qdisc_skb_cb(skb)->pkt_len = skb->len;
-	qdisc_skb_cb(skb)->mru = 0;
-	qdisc_skb_cb(skb)->post_ct = false;
+	tc_skb_cb(skb)->mru = 0;
+	tc_skb_cb(skb)->post_ct = false;
 	skb->tc_at_ingress = 1;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 90866ae45573..98e248b9c0b1 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -690,10 +690,10 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 				   u8 family, u16 zone, bool *defrag)
 {
 	enum ip_conntrack_info ctinfo;
-	struct qdisc_skb_cb cb;
 	struct nf_conn *ct;
 	int err = 0;
 	bool frag;
+	u16 mru;
 
 	/* Previously seen (loopback)? Ignore. */
 	ct = nf_ct_get(skb, &ctinfo);
@@ -708,7 +708,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 		return err;
 
 	skb_get(skb);
-	cb = *qdisc_skb_cb(skb);
+	mru = tc_skb_cb(skb)->mru;
 
 	if (family == NFPROTO_IPV4) {
 		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
@@ -722,7 +722,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 
 		if (!err) {
 			*defrag = true;
-			cb.mru = IPCB(skb)->frag_max_size;
+			mru = IPCB(skb)->frag_max_size;
 		}
 	} else { /* NFPROTO_IPV6 */
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
@@ -735,7 +735,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 
 		if (!err) {
 			*defrag = true;
-			cb.mru = IP6CB(skb)->frag_max_size;
+			mru = IP6CB(skb)->frag_max_size;
 		}
 #else
 		err = -EOPNOTSUPP;
@@ -744,7 +744,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 	}
 
 	if (err != -EINPROGRESS)
-		*qdisc_skb_cb(skb) = cb;
+		tc_skb_cb(skb)->mru = mru;
 	skb_clear_hash(skb);
 	skb->ignore_df = 1;
 	return err;
@@ -963,7 +963,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	tcf_action_update_bstats(&c->common, skb);
 
 	if (clear) {
-		qdisc_skb_cb(skb)->post_ct = false;
+		tc_skb_cb(skb)->post_ct = false;
 		ct = nf_ct_get(skb, &ctinfo);
 		if (ct) {
 			nf_conntrack_put(&ct->ct_general);
@@ -1048,7 +1048,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 out_push:
 	skb_push_rcsum(skb, nh_ofs);
 
-	qdisc_skb_cb(skb)->post_ct = true;
+	tc_skb_cb(skb)->post_ct = true;
 out_clear:
 	if (defrag)
 		qdisc_skb_cb(skb)->pkt_len = skb->len;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2ef8f5a6205a..a5050999d607 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1617,12 +1617,14 @@ int tcf_classify(struct sk_buff *skb,
 
 	/* If we missed on some chain */
 	if (ret == TC_ACT_UNSPEC && last_executed_chain) {
+		struct tc_skb_cb *cb = tc_skb_cb(skb);
+
 		ext = tc_skb_ext_alloc(skb);
 		if (WARN_ON_ONCE(!ext))
 			return TC_ACT_SHOT;
 		ext->chain = last_executed_chain;
-		ext->mru = qdisc_skb_cb(skb)->mru;
-		ext->post_ct = qdisc_skb_cb(skb)->post_ct;
+		ext->mru = cb->mru;
+		ext->post_ct = cb->post_ct;
 	}
 
 	return ret;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index aab13ba11767..9782b93db1b3 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -19,6 +19,7 @@
 
 #include <net/sch_generic.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <net/ip.h>
 #include <net/flow_dissector.h>
 #include <net/geneve.h>
@@ -309,7 +310,7 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		       struct tcf_result *res)
 {
 	struct cls_fl_head *head = rcu_dereference_bh(tp->root);
-	bool post_ct = qdisc_skb_cb(skb)->post_ct;
+	bool post_ct = tc_skb_cb(skb)->post_ct;
 	struct fl_flow_key skb_key;
 	struct fl_flow_mask *mask;
 	struct cls_fl_filter *f;
diff --git a/net/sched/sch_frag.c b/net/sched/sch_frag.c
index 8c06381391d6..5ded4c8672a6 100644
--- a/net/sched/sch_frag.c
+++ b/net/sched/sch_frag.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 #include <net/netlink.h>
 #include <net/sch_generic.h>
+#include <net/pkt_sched.h>
 #include <net/dst.h>
 #include <net/ip.h>
 #include <net/ip6_fib.h>
@@ -137,7 +138,7 @@ static int sch_fragment(struct net *net, struct sk_buff *skb,
 
 int sch_frag_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb))
 {
-	u16 mru = qdisc_skb_cb(skb)->mru;
+	u16 mru = tc_skb_cb(skb)->mru;
 	int err;
 
 	if (mru && skb->len > mru + skb->dev->hard_header_len)
-- 
2.30.1

