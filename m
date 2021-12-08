Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3D646D927
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 18:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbhLHRGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:06:31 -0500
Received: from mail-mw2nam12on2051.outbound.protection.outlook.com ([40.107.244.51]:50273
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234438AbhLHRGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 12:06:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBbrx0KNk2dUUFO8l6qLB/dsxGTPbSkmtJgVVa6GsZWHlwbGruDiiOvEszheQr5R6RAdGvSn7ingcji48FUSnwLlAOpaMr44SPvx9gLCM76/aSly0hWKd5YPE+c4DQUuPivOJ9B5+JdEovhxmmZvp9bAU7yKgV1Lhor4qJSOzwvaSr/Ztv9nXlzIS8oIIsKsW2CDp3oekySTMIx2lR5Z0kSmN4v1vSU0N6vjmFxtW12mRTmaEY/n6ytgTHojQi7KAKZ51PmfG69DFXOA+N2taFIDai0DbofrIg9tl5vfzvBfKxhZzp6wSf+eCgoPTh8JwDeSZ7rDx0PUXBucLk47LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79JM/MbrmODiFRgErMjsuA+5wfvYPFNkA4dhLysjHNk=;
 b=PcVeGmYddBDv44qkmb9gfLcI9xFXJKvDU1oNAHweh8KmuHAZY6/HFOYKvn/oaaSOx3Cxc6I7iPv6BYZQE6dUxlJaS+AyPbopF8c9Kp4bqu0ZvjnhDGdGdnklN+dUnkaw1M48/XEWJ/z60kgT0S/nMFQJo62uNMzLExUNmRLlymBNOaK/LWci+FSNpcZnFWKxdpNzHEjaXmhJ8xjtDHV8xc/nycEtjN3GEJGTS+qaLBkTmDdsZI3N/FxVJhmqNo/d8UADGBRh1czp4Y7N9Ur4yGHFiv70mS2v9Xbk5aknem+mP3GSbzC2mtQVu72aLmdCnqVrRjJTL0FPG0l8+O3Z+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.12) smtp.rcpttodomain=openvswitch.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79JM/MbrmODiFRgErMjsuA+5wfvYPFNkA4dhLysjHNk=;
 b=MKc4P6SzZ5nkLsZEhQbeht71kKgT60uUmwIXU3ds1JpynIVl5+xe0LZKaNPWD8v9+4aeqiyklmePhFVsq2z2PB7NDmx6ZvcM2i05aP7vYyAUhbLIFv0qWcstCzDBqgWwb+DWF/OrBvJJ0oPZkM+lbUdaPAxKYzCgOUwLLeSeZmyLL13o+vf8Kk0td7jE8KBJUSdgpwDTpGn68jUqulu0HK+dYcV9QnUYMoKV+UwEcw/lpVVMWYqnaFhbIwpFGUVkcBfzDOLZc7dcJd5PvUq98x2R6bH+XMce/BMZIC6cfoJvsZyfJ7XTgEmPUC6mQ2b41abBUJUPx+7EuIp7sBQdhw==
Received: from MW4PR04CA0299.namprd04.prod.outlook.com (2603:10b6:303:89::34)
 by MW2PR12MB2396.namprd12.prod.outlook.com (2603:10b6:907:9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Wed, 8 Dec
 2021 17:02:57 +0000
Received: from CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::ca) by MW4PR04CA0299.outlook.office365.com
 (2603:10b6:303:89::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend
 Transport; Wed, 8 Dec 2021 17:02:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.12)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.12; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.12) by
 CO1NAM11FT052.mail.protection.outlook.com (10.13.174.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Wed, 8 Dec 2021 17:02:56 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Dec
 2021 17:02:55 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Dec
 2021 09:02:53 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Wed, 8 Dec 2021 17:02:51 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net 1/3] net/sched: Extend qdisc control block with tc control block
Date:   Wed, 8 Dec 2021 19:02:38 +0200
Message-ID: <20211208170240.13458-2-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20211208170240.13458-1-paulb@nvidia.com>
References: <20211208170240.13458-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc5d77ce-30e9-4604-d021-08d9ba6c94d0
X-MS-TrafficTypeDiagnostic: MW2PR12MB2396:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB239694BE97A0078A7F19508FC26F9@MW2PR12MB2396.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BAbLK9rJrydWsZWv5hSIHNpgp4GGBA8YfoLqKOY2XRm9BjQOXAAoY4TkTLny7pVcwTmKBcs3f2kq4rdZQo3lj2U1Ynbv7B4dSbpzwoFi1aWVQFe2ijbZvkTfxed6L8sOtqde7igMxq/9jM2odq6uiU1/IhuN5FLTkoBiKUZ5FeKvoHkgkB4U2lQK6P3tMrlSYvPF93kcDCyYUF3a5wEx1srpeH6XJgGE5muUeh8h0TjmDlDvt0C3hnCu5lGKYw7XKjoZC86uHi0aJoSZQiR3ies5sSqt0icLdEC5o53gtt4OXAw/ddPeRrZqpzXA4jidQ+pEv7WKDG5qGNEZIUW8P8khqX+vM29MpCD6FRMRsQu15DEM7ESOCwYTnqmg2k+oJu1S5mo6dPYnCKO+nqMiXgEmy9QubagswfoPKYl2SZthmsMYuFn4kdOyTFyrP5JqcD3aLkoayRm51e2i19ew4aqOsxlVpoXcH5jDNZczdwAc7v/VXJyD6lMygbGGo0BNSOEzwdecNrpL8WvrUpHe5z0oaIJDkzBPrBJmO1yaJXwj3TTB7ZiryDAVBgdQKng+ARqCk/AlDO4S1B16Wp9/2941MiBKgFH/xJuLelpwOuEF07nEelWmHmhxoHHgYg2cHCepyBaz24Cj8LDcPhoHhcrvx8BC673y7WbO8ZIG9z4W8ixYkbJ8UEhdtUhY8GUwv9fzHuTaY/ky/ixZuiC3B942BgqvLnXwDq4+ZKdrR+3BT/QLlPMazjw9sj8td2KYpHJySV4tAYn4m2gLLFAyXnWjqTsUDMUHmGRZUDWcaKE=
X-Forefront-Antispam-Report: CIP:203.18.50.12;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(82310400004)(2906002)(508600001)(2616005)(4326008)(8936002)(40460700001)(107886003)(336012)(6666004)(8676002)(26005)(356005)(316002)(70586007)(54906003)(83380400001)(186003)(34070700002)(5660300002)(110136005)(86362001)(70206006)(426003)(47076005)(7636003)(6636002)(36756003)(1076003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 17:02:56.2049
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc5d77ce-30e9-4604-d021-08d9ba6c94d0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.12];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2396
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

