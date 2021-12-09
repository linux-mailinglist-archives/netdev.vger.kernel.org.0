Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0BB546E393
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 08:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbhLIIBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:01:23 -0500
Received: from mail-mw2nam10on2055.outbound.protection.outlook.com ([40.107.94.55]:35041
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230042AbhLIIBX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 03:01:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPilZNUo4oOuvDrRBbl6DCCWiT5pT2t+IEFyQIS9nvTT4XJWp4sBCPDysF7NPl53ij69YtxDhqrhqm/nEMYyFizQ4xubrpxD4irY0T9+ac4UYzLLGdayT3+Y55oXSO26ChDkAKRv3A4zqgSmABw2L9p7XgyGTNuUl1z0Y/rsCLKJfzHhXLIYpaqBblLoPK2yiX5wg280+AoHsVVKbVMKFQ8KOuWNXIUtUSzHTK3V8ERbZZ3Y5EZupUBi+LWIn8NGoHmztD260W926lxwQ6Qjo7H2DstNEkJyxd7uyVH3lihcus2+VuAIwVAfMOfyCK2gi3IYECyumJXzNgx5VIHwiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79JM/MbrmODiFRgErMjsuA+5wfvYPFNkA4dhLysjHNk=;
 b=RfZU26Wq+8nZIFhs9BxbWINcXYU3Z0IkFNUjaDNF1x7mEMobkxdjIBGbYr6wKXCNzJkruwE0Rr/Brlb/TRfuziefa+TsNr5FXPMTY27rlEBkJ/M9mCR+3u70bKnvrAoLZnOTPYxWabez83ZCzLd3sP6S43YVq2ql3INe/Ruqm7Rm53Fthx2BwEEEF/zKNFz8I023cO/+I/TCWYGlBh+HqpUrVN4lVO8vaJXuX9aMLrwqPE7ncqPWKQI/kx4qza8FzlDtXP6/87L+zVVal6YsPv1oNqhx9tIwgu6YhxuXQixVGUcAFDsQQFYXuzdFH2YsjYPTxSn3nH/MNXvF0kNBNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.13) smtp.rcpttodomain=ovn.org smtp.mailfrom=nvidia.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79JM/MbrmODiFRgErMjsuA+5wfvYPFNkA4dhLysjHNk=;
 b=c8PIlYljQEaVevzX1E9+FTrYDRj4WeV4HYsQEh7neT0hGRCMyIoc8+J+ciZKqw6jXxDDtayk0dhLiM9RfRmK2+pp++UYmlag9WaVa+Ah1LekyJFuOdhNKWABfwQcyQQ0O2bo+yvO03fRZh8L/R/bKoqIQGywmhofGXYuhiYoaGLxnYIMvGnrnTjIY4DxVwJJLAh1aB0CpSxZFq+alksh2cBEtreCemkDwnmoPa0fgV8HVTJ31jaccm9We9phoNV+G6OmrLKig/Z7AeHUzh6L3xdQZnX8wRqu3A23swvRf7WZbPI2K1dAvlPflfmcIgBngF8NgKHDszu5Nud5vi8Ujg==
Received: from DM5PR19CA0046.namprd19.prod.outlook.com (2603:10b6:3:9a::32) by
 MWHPR12MB1277.namprd12.prod.outlook.com (2603:10b6:300:f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Thu, 9 Dec 2021 07:57:48 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:9a:cafe::8c) by DM5PR19CA0046.outlook.office365.com
 (2603:10b6:3:9a::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend
 Transport; Thu, 9 Dec 2021 07:57:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.13)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.13 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.13; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.13) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 9 Dec 2021 07:57:47 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Dec
 2021 07:57:45 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Dec
 2021 23:57:43 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.5) by
 mail.nvidia.com (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Thu, 9 Dec 2021 07:57:40 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, wenxu <wenxu@ucloud.cn>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net v2 1/3] net/sched: Extend qdisc control block with tc control block
Date:   Thu, 9 Dec 2021 09:57:32 +0200
Message-ID: <20211209075734.10199-2-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20211209075734.10199-1-paulb@nvidia.com>
References: <20211209075734.10199-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c4d89a2-11df-43b9-db0f-08d9bae99797
X-MS-TrafficTypeDiagnostic: MWHPR12MB1277:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1277C0E14A079379D7A735C5C2709@MWHPR12MB1277.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lnyzyd24JmCdV/LcB4W0Q2urPXOoS9GifbwY51kn/xtJQ+1QaA6xgG1v+TyUIXUn0AU7mgCQVeh9iudyYJkahNGAkESR0SBL18WsVWW02OYE8DEINZnypHYL8kSVrpJd6NbdYKocNxnUZqGrAFN90qa9FKS2hj9izmstVI+dLYzRBMGkXxMfk2/TWWccv9KGqlCBk95xRUMP6RpsL2rqLyXGUV5foB+R6Ym848Be9QcUDhBxGGksZ97X2q1FIImj+z9VsKlr+yGpF/hNOuLPdVpX5kdO+nehwnDg4e7HIyC1IrlCSxk4C2r5fFHEcopOuq67J0gDaC+tdiZF3UpindFHMH/TYCqt1z/fU0xyG0onFa3NPqek6aPGZUngHB7tcK9RYIi/vIsVAVow2VhfxUeT+8/qtcWd/nOlBnFD65ef6QfwDsZ+O7hMdVK1kUXkb51LfFAcc2WPxnlOZxMzoBjSZzFDD1oVbIwVIpWZVVsYh0qx24x0ioWbU8416Vz52tUxfsT6FYniR00987hGzpl3lTdWj8X+J+sRdI7fXkRBRrh2G6eGjDCU5LtiMDnrTsLb+/9/fkmiQ8jKBnJsYIseWroxAuj1SgcQ1EDB1zSSUDrjEMwi5LcfqeVCa+iTbSCu+Si5pr+lrk4WltgWOyd9/Yq5dUPe5oamYElJ+8dm/SHaD5PZ46T460lTTSR2mbkRQ/Ue1VCcVLmrsxwwYIWXvgyDc1bRpdbndNoL4b5XI+6ygWU07ztZiupcHvU9/APBSwkXcFeiiiD4C/E+lcWryNX3BrxAUwYFWwbia4lapWquFs/qX7rieNPOZ5uq
X-Forefront-Antispam-Report: CIP:203.18.50.13;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(26005)(70206006)(107886003)(83380400001)(336012)(2616005)(426003)(70586007)(4326008)(47076005)(8936002)(356005)(7636003)(5660300002)(1076003)(36860700001)(186003)(8676002)(36756003)(316002)(6666004)(86362001)(508600001)(54906003)(110136005)(82310400004)(2906002)(921005)(40460700001)(34070700002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 07:57:47.8332
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c4d89a2-11df-43b9-db0f-08d9bae99797
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.13];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1277
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

