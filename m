Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBD263ACDA
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 16:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbiK1Pps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 10:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbiK1Ppp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 10:45:45 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7138A1DF0F
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 07:45:43 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id l42-20020a9d1b2d000000b0066c6366fbc3so7207256otl.3
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 07:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3OVw2f0hUPT320LSgIi0n+X13FNO+ZxV1WJgX3jIiB8=;
        b=qixxdqdUyVYCZiXp5Alb0w5WV0UVAZMVBCVfd/OBvzYjh7F6u3Y9NI+dohRw9zxVP0
         BNHFtsUtG2dWGAPrhg5/0pxjIs0h3kgKdyVbE7yJjMVHYuS1ImFHDn1FED/2fnuPl5Bg
         vlCpqAIx/5/r5iiA5PrjrJbTtUIjaPKKRkQZa4GGH06nX64k2mDjyM+LsjG0A058ctGZ
         iuzh1Sl3/0lf9OrS+M5vX+vPaPba7/exqWr7w7EnXbaldnsgMevuN3sktYNfOVrgXxVy
         LFpuuRRJkyy3o3m9vE59mjqUpzk9kt3bqDUgNWbeBmUADV4GY+o9uIE8w0fmf09VwhjX
         aXhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3OVw2f0hUPT320LSgIi0n+X13FNO+ZxV1WJgX3jIiB8=;
        b=EItVWcOh3l3jYXmMQJIZHw3GrSbUVy9qzg2FAKrFDPKqnJPAmgIAV8beLbDWeFWRrG
         8j/vgFcamESCrYy4mhADx5tyd1hRqSFSHtIwYZGlMhutOPT+LPKO8SEpkgGUdFwHblug
         0v1MdaXNtPJm+JP/cWLJaLz2nPrCbImtatmHPtxl8kdd79YP/Cqj16PbPQo4aI/VCeeo
         umaWfATiG31qGhCYpWXLBq2pPUhCalJgpHdpFZkyJSHRZ6Qa0jo/hoa+B/EbIvXdU04o
         +wH3qBQb1kwTpPMc75TfYu+/1kD5/ELF7YrfDe7Dqra97vFPUP/F+eE2hZRj9AZTSV2w
         cQRA==
X-Gm-Message-State: ANoB5plY/v4fFp6ab6Eq1hq2o0blDnBLjobXfIUg3pf/z8p/wvSfh3eo
        avJja3sL6MnlRi1IHHv6aEuAlNgbZn8W+A==
X-Google-Smtp-Source: AA0mqf7kmlzIWqPGvPgCFpZp8WMp1KcORg7tegYdNo9ai6srZQoGIyEYAFU23WdIn3b5H8a1WNXzAg==
X-Received: by 2002:a05:6830:1183:b0:661:a3ca:7432 with SMTP id u3-20020a056830118300b00661a3ca7432mr16552647otq.3.1669650342354;
        Mon, 28 Nov 2022 07:45:42 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:562:c37c:87b7:acb4])
        by smtp.gmail.com with ESMTPSA id bx19-20020a056830601300b0066c55e23a16sm4885012otb.2.2022.11.28.07.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 07:45:41 -0800 (PST)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 2/3] net/sched: avoid indirect act functions on retpoline kernels
Date:   Mon, 28 Nov 2022 12:44:55 -0300
Message-Id: <20221128154456.689326-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221128154456.689326-1-pctammela@mojatatu.com>
References: <20221128154456.689326-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose the necessary tc act functions and wire up act_api to use
direct calls in retpoline kernels.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_api.c        | 3 ++-
 net/sched/act_bpf.c        | 6 ++++--
 net/sched/act_connmark.c   | 6 ++++--
 net/sched/act_csum.c       | 6 ++++--
 net/sched/act_ct.c         | 5 +++--
 net/sched/act_ctinfo.c     | 6 ++++--
 net/sched/act_gact.c       | 6 ++++--
 net/sched/act_gate.c       | 6 ++++--
 net/sched/act_ife.c        | 6 ++++--
 net/sched/act_ipt.c        | 6 ++++--
 net/sched/act_mirred.c     | 6 ++++--
 net/sched/act_mpls.c       | 6 ++++--
 net/sched/act_nat.c        | 7 ++++---
 net/sched/act_pedit.c      | 6 ++++--
 net/sched/act_police.c     | 6 ++++--
 net/sched/act_sample.c     | 6 ++++--
 net/sched/act_simple.c     | 6 ++++--
 net/sched/act_skbedit.c    | 6 ++++--
 net/sched/act_skbmod.c     | 6 ++++--
 net/sched/act_tunnel_key.c | 6 ++++--
 net/sched/act_vlan.c       | 6 ++++--
 21 files changed, 81 insertions(+), 42 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 9b31a10cc639..b3276720b80d 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -23,6 +23,7 @@
 #include <net/act_api.h>
 #include <net/netlink.h>
 #include <net/flow_offload.h>
+#include <net/tc_wrapper.h>
 
 #ifdef CONFIG_INET
 DEFINE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
@@ -1080,7 +1081,7 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 
 		repeat_ttl = 32;
 repeat:
-		ret = a->ops->act(skb, a, res);
+		ret = __tc_act(skb, a, res);
 		if (unlikely(ret == TC_ACT_REPEAT)) {
 			if (--repeat_ttl != 0)
 				goto repeat;
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index b79eee44e24e..b0455fda7d0b 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -18,6 +18,7 @@
 
 #include <linux/tc_act/tc_bpf.h>
 #include <net/tc_act/tc_bpf.h>
+#include <net/tc_wrapper.h>
 
 #define ACT_BPF_NAME_LEN	256
 
@@ -31,8 +32,9 @@ struct tcf_bpf_cfg {
 
 static struct tc_action_ops act_bpf_ops;
 
-static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
-		       struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_bpf_act(struct sk_buff *skb,
+				  const struct tc_action *act,
+				  struct tcf_result *res)
 {
 	bool at_ingress = skb_at_tc_ingress(skb);
 	struct tcf_bpf *prog = to_bpf(act);
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 66b143bb04ac..3e643aced3b3 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -20,6 +20,7 @@
 #include <net/pkt_cls.h>
 #include <uapi/linux/tc_act/tc_connmark.h>
 #include <net/tc_act/tc_connmark.h>
+#include <net/tc_wrapper.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
@@ -27,8 +28,9 @@
 
 static struct tc_action_ops act_connmark_ops;
 
-static int tcf_connmark_act(struct sk_buff *skb, const struct tc_action *a,
-			    struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_connmark_act(struct sk_buff *skb,
+				       const struct tc_action *a,
+				       struct tcf_result *res)
 {
 	const struct nf_conntrack_tuple_hash *thash;
 	struct nf_conntrack_tuple tuple;
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 1366adf9b909..95e9304024b7 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -32,6 +32,7 @@
 
 #include <linux/tc_act/tc_csum.h>
 #include <net/tc_act/tc_csum.h>
+#include <net/tc_wrapper.h>
 
 static const struct nla_policy csum_policy[TCA_CSUM_MAX + 1] = {
 	[TCA_CSUM_PARMS] = { .len = sizeof(struct tc_csum), },
@@ -563,8 +564,9 @@ static int tcf_csum_ipv6(struct sk_buff *skb, u32 update_flags)
 	return 0;
 }
 
-static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
-			struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_csum_act(struct sk_buff *skb,
+				   const struct tc_action *a,
+				   struct tcf_result *res)
 {
 	struct tcf_csum *p = to_tcf_csum(a);
 	bool orig_vlan_tag_present = false;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index da0b7f665277..249c138376bb 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -24,6 +24,7 @@
 #include <net/ipv6_frag.h>
 #include <uapi/linux/tc_act/tc_ct.h>
 #include <net/tc_act/tc_ct.h>
+#include <net/tc_wrapper.h>
 
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_conntrack.h>
@@ -1038,8 +1039,8 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
 #endif
 }
 
-static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
-		      struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
+				 struct tcf_result *res)
 {
 	struct net *net = dev_net(skb->dev);
 	enum ip_conntrack_info ctinfo;
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index d4102f0a9abd..0064934a4eac 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -18,6 +18,7 @@
 #include <net/pkt_cls.h>
 #include <uapi/linux/tc_act/tc_ctinfo.h>
 #include <net/tc_act/tc_ctinfo.h>
+#include <net/tc_wrapper.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
@@ -75,8 +76,9 @@ static void tcf_ctinfo_cpmark_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
 	skb->mark = ct->mark & cp->cpmarkmask;
 }
 
-static int tcf_ctinfo_act(struct sk_buff *skb, const struct tc_action *a,
-			  struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_ctinfo_act(struct sk_buff *skb,
+				     const struct tc_action *a,
+				     struct tcf_result *res)
 {
 	const struct nf_conntrack_tuple_hash *thash = NULL;
 	struct tcf_ctinfo *ca = to_ctinfo(a);
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 62d682b96b88..54f1b13b2360 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -18,6 +18,7 @@
 #include <net/pkt_cls.h>
 #include <linux/tc_act/tc_gact.h>
 #include <net/tc_act/tc_gact.h>
+#include <net/tc_wrapper.h>
 
 static struct tc_action_ops act_gact_ops;
 
@@ -145,8 +146,9 @@ static int tcf_gact_init(struct net *net, struct nlattr *nla,
 	return err;
 }
 
-static int tcf_gact_act(struct sk_buff *skb, const struct tc_action *a,
-			struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_gact_act(struct sk_buff *skb,
+				   const struct tc_action *a,
+				   struct tcf_result *res)
 {
 	struct tcf_gact *gact = to_gact(a);
 	int action = READ_ONCE(gact->tcf_action);
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 3049878e7315..9b8def0be41e 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -14,6 +14,7 @@
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_gate.h>
+#include <net/tc_wrapper.h>
 
 static struct tc_action_ops act_gate_ops;
 
@@ -113,8 +114,9 @@ static enum hrtimer_restart gate_timer_func(struct hrtimer *timer)
 	return HRTIMER_RESTART;
 }
 
-static int tcf_gate_act(struct sk_buff *skb, const struct tc_action *a,
-			struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_gate_act(struct sk_buff *skb,
+				   const struct tc_action *a,
+				   struct tcf_result *res)
 {
 	struct tcf_gate *gact = to_gate(a);
 
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 41d63b33461d..bc7611b0744c 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -29,6 +29,7 @@
 #include <net/tc_act/tc_ife.h>
 #include <linux/etherdevice.h>
 #include <net/ife.h>
+#include <net/tc_wrapper.h>
 
 static int max_metacnt = IFE_META_MAX + 1;
 static struct tc_action_ops act_ife_ops;
@@ -861,8 +862,9 @@ static int tcf_ife_encode(struct sk_buff *skb, const struct tc_action *a,
 	return action;
 }
 
-static int tcf_ife_act(struct sk_buff *skb, const struct tc_action *a,
-		       struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_ife_act(struct sk_buff *skb,
+				  const struct tc_action *a,
+				  struct tcf_result *res)
 {
 	struct tcf_ife_info *ife = to_ife(a);
 	struct tcf_ife_params *p;
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 1625e1037416..5d96ffebd40f 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -20,6 +20,7 @@
 #include <net/pkt_sched.h>
 #include <linux/tc_act/tc_ipt.h>
 #include <net/tc_act/tc_ipt.h>
+#include <net/tc_wrapper.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 
@@ -216,8 +217,9 @@ static int tcf_xt_init(struct net *net, struct nlattr *nla,
 			      a, &act_xt_ops, tp, flags);
 }
 
-static int tcf_ipt_act(struct sk_buff *skb, const struct tc_action *a,
-		       struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_ipt_act(struct sk_buff *skb,
+				  const struct tc_action *a,
+				  struct tcf_result *res)
 {
 	int ret = 0, result = 0;
 	struct tcf_ipt *ipt = to_ipt(a);
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index b8ad6ae282c0..7284bcea7b0b 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -24,6 +24,7 @@
 #include <net/pkt_cls.h>
 #include <linux/tc_act/tc_mirred.h>
 #include <net/tc_act/tc_mirred.h>
+#include <net/tc_wrapper.h>
 
 static LIST_HEAD(mirred_list);
 static DEFINE_SPINLOCK(mirred_list_lock);
@@ -217,8 +218,9 @@ static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
 	return err;
 }
 
-static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
-			  struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
+				     const struct tc_action *a,
+				     struct tcf_result *res)
 {
 	struct tcf_mirred *m = to_mirred(a);
 	struct sk_buff *skb2 = skb;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 8ad25cc8ccd5..ff47ce4d3968 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -14,6 +14,7 @@
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_mpls.h>
+#include <net/tc_wrapper.h>
 
 static struct tc_action_ops act_mpls_ops;
 
@@ -49,8 +50,9 @@ static __be32 tcf_mpls_get_lse(struct mpls_shim_hdr *lse,
 	return cpu_to_be32(new_lse);
 }
 
-static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
-			struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_mpls_act(struct sk_buff *skb,
+				   const struct tc_action *a,
+				   struct tcf_result *res)
 {
 	struct tcf_mpls *m = to_mpls(a);
 	struct tcf_mpls_params *p;
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 9265145f1040..74c74be33048 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -24,7 +24,7 @@
 #include <net/tc_act/tc_nat.h>
 #include <net/tcp.h>
 #include <net/udp.h>
-
+#include <net/tc_wrapper.h>
 
 static struct tc_action_ops act_nat_ops;
 
@@ -98,8 +98,9 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	return err;
 }
 
-static int tcf_nat_act(struct sk_buff *skb, const struct tc_action *a,
-		       struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_nat_act(struct sk_buff *skb,
+				  const struct tc_action *a,
+				  struct tcf_result *res)
 {
 	struct tcf_nat *p = to_tcf_nat(a);
 	struct iphdr *iph;
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 94ed5857ce67..a0378e9f0121 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -20,6 +20,7 @@
 #include <net/tc_act/tc_pedit.h>
 #include <uapi/linux/tc_act/tc_pedit.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 static struct tc_action_ops act_pedit_ops;
 
@@ -319,8 +320,9 @@ static int pedit_skb_hdr_offset(struct sk_buff *skb,
 	return ret;
 }
 
-static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
-			 struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
+				    const struct tc_action *a,
+				    struct tcf_result *res)
 {
 	struct tcf_pedit *p = to_pedit(a);
 	u32 max_offset;
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 0adb26e366a7..227cba58ce9f 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -19,6 +19,7 @@
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_police.h>
+#include <net/tc_wrapper.h>
 
 /* Each policer is serialized by its individual spinlock */
 
@@ -242,8 +243,9 @@ static bool tcf_police_mtu_check(struct sk_buff *skb, u32 limit)
 	return len <= limit;
 }
 
-static int tcf_police_act(struct sk_buff *skb, const struct tc_action *a,
-			  struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_police_act(struct sk_buff *skb,
+				     const struct tc_action *a,
+				     struct tcf_result *res)
 {
 	struct tcf_police *police = to_police(a);
 	s64 now, toks, ppstoks = 0, ptoks = 0;
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 7a25477f5d99..98dea08c1764 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -20,6 +20,7 @@
 #include <net/tc_act/tc_sample.h>
 #include <net/psample.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 #include <linux/if_arp.h>
 
@@ -153,8 +154,9 @@ static bool tcf_sample_dev_ok_push(struct net_device *dev)
 	}
 }
 
-static int tcf_sample_act(struct sk_buff *skb, const struct tc_action *a,
-			  struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_sample_act(struct sk_buff *skb,
+				     const struct tc_action *a,
+				     struct tcf_result *res)
 {
 	struct tcf_sample *s = to_sample(a);
 	struct psample_group *psample_group;
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index 18d376135461..4b84514534f3 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -14,6 +14,7 @@
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 #include <linux/tc_act/tc_defact.h>
 #include <net/tc_act/tc_defact.h>
@@ -21,8 +22,9 @@
 static struct tc_action_ops act_simp_ops;
 
 #define SIMP_MAX_DATA	32
-static int tcf_simp_act(struct sk_buff *skb, const struct tc_action *a,
-			struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_simp_act(struct sk_buff *skb,
+				   const struct tc_action *a,
+				   struct tcf_result *res)
 {
 	struct tcf_defact *d = to_defact(a);
 
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 1710780c908a..ce7008cf291c 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -16,6 +16,7 @@
 #include <net/ipv6.h>
 #include <net/dsfield.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 #include <linux/tc_act/tc_skbedit.h>
 #include <net/tc_act/tc_skbedit.h>
@@ -36,8 +37,9 @@ static u16 tcf_skbedit_hash(struct tcf_skbedit_params *params,
 	return netdev_cap_txqueue(skb->dev, queue_mapping);
 }
 
-static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
-			   struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_skbedit_act(struct sk_buff *skb,
+				      const struct tc_action *a,
+				      struct tcf_result *res)
 {
 	struct tcf_skbedit *d = to_skbedit(a);
 	struct tcf_skbedit_params *params;
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index d98758a63934..dffa990a9629 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -15,14 +15,16 @@
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 #include <linux/tc_act/tc_skbmod.h>
 #include <net/tc_act/tc_skbmod.h>
 
 static struct tc_action_ops act_skbmod_ops;
 
-static int tcf_skbmod_act(struct sk_buff *skb, const struct tc_action *a,
-			  struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_skbmod_act(struct sk_buff *skb,
+				     const struct tc_action *a,
+				     struct tcf_result *res)
 {
 	struct tcf_skbmod *d = to_skbmod(a);
 	int action, max_edit_len, err;
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 2691a3d8e451..2d12d2626415 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -16,14 +16,16 @@
 #include <net/pkt_sched.h>
 #include <net/dst.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 #include <linux/tc_act/tc_tunnel_key.h>
 #include <net/tc_act/tc_tunnel_key.h>
 
 static struct tc_action_ops act_tunnel_key_ops;
 
-static int tunnel_key_act(struct sk_buff *skb, const struct tc_action *a,
-			  struct tcf_result *res)
+TC_INDIRECT_SCOPE int tunnel_key_act(struct sk_buff *skb,
+				     const struct tc_action *a,
+				     struct tcf_result *res)
 {
 	struct tcf_tunnel_key *t = to_tunnel_key(a);
 	struct tcf_tunnel_key_params *params;
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 7b24e898a3e6..0251442f5f29 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -12,14 +12,16 @@
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 #include <linux/tc_act/tc_vlan.h>
 #include <net/tc_act/tc_vlan.h>
 
 static struct tc_action_ops act_vlan_ops;
 
-static int tcf_vlan_act(struct sk_buff *skb, const struct tc_action *a,
-			struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_vlan_act(struct sk_buff *skb,
+				   const struct tc_action *a,
+				   struct tcf_result *res)
 {
 	struct tcf_vlan *v = to_vlan(a);
 	struct tcf_vlan_params *p;
-- 
2.34.1

