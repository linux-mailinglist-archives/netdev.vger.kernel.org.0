Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A62664450A
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiLFNzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbiLFNzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:55:35 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDC12BB0C
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 05:55:32 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-144bd860fdbso4324244fac.0
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 05:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rid02IRhR3h1FXJHifEtRjb++cO+TmZI45dj68ry7uw=;
        b=ZXz9lTR/g2sHUt5mIaHTrKYdvRHku0OogW7+vxJ/UmyrAqFYKfjxiI9luqptepzVR0
         VrZgxaWSLnxwmaGeZoej8HfBDmmIwfnVfOLilvxQoJX8wVvvu96DG+LOZRkFyuSDbKay
         zxgS9SX1s9biKcDURvONRAhoBHlIznNqx5rylJx9DwAlb/6yl/pmfs5M0lXgFx6EGNi5
         8P74eJmsj9DF0UVhY+4naFqPc23Dm0jmmv3U6wnrwTw/s5C4ISR4IhmhvABzKnWe6r1L
         y4/yEK6lDsrKJ0fQCTCmU+ACD/KTdfHcu89xRgTWp9yPyaZ0oUahaBlt5ca+ryS7fGBQ
         QLqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rid02IRhR3h1FXJHifEtRjb++cO+TmZI45dj68ry7uw=;
        b=3UJTaGv53EQDF4RvpGHvmtQyHmVbr4l/LD82eNoBO6AfJqExFABaE4smJ7ojfmHU3z
         6TH+j1leYJKqHeEx6Ght90c20T/4OCmRWkaGxjWji5aWQAmR7cocruUu4gCYuPjvReUC
         Es6ru7FxYFKNHCQvNLK7vT0RsiSdJ7HMzykiyne8JMAR/nKA+M6siTHPa2BT8a55zy3D
         ugnWDbtyqFld8qkhIjxC8y4saGx+RBDUlUfvSh+CjReIn3N7MeCdxA6LrnRFSWVUZUnr
         NDPPQaMKC5aCpmIkKH83AQXg16H7bu+k/WrYtQkokn9EVLJyxKGi3Hso4rTZId2ApV8Q
         RWEA==
X-Gm-Message-State: ANoB5pl5+3qDnkRSx/zRzsq1Sq8e0YPW6C1icNtX9mCSNfLRwHhm964O
        ClZofcGrW02CbvY0rEJ+3Y/Iag+Rx6Du2zxD
X-Google-Smtp-Source: AA0mqf58HGPlYiuxmvvs1JGih39atK5gYQChHGbNBlxhsPseSBGnSywSX4VvqqHuPU8njVYuxCzOOQ==
X-Received: by 2002:a05:6870:f613:b0:142:7fc7:7f3f with SMTP id ek19-20020a056870f61300b001427fc77f3fmr41485228oab.43.1670334931422;
        Tue, 06 Dec 2022 05:55:31 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:6544:c4a9:5a4c:3545])
        by smtp.gmail.com with ESMTPSA id h5-20020a056830164500b00667ff6b7e9esm9319792otr.40.2022.12.06.05.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 05:55:31 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH net-next v6 2/4] net/sched: add retpoline wrapper for tc
Date:   Tue,  6 Dec 2022 10:55:11 -0300
Message-Id: <20221206135513.1904815-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206135513.1904815-1-pctammela@mojatatu.com>
References: <20221206135513.1904815-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On kernels using retpoline as a spectrev2 mitigation,
optimize actions and filters that are compiled as built-ins into a direct call.

On subsequent patches we expose the classifiers and actions functions
and wire up the wrapper into tc.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
---
 include/net/tc_wrapper.h | 251 +++++++++++++++++++++++++++++++++++++++
 net/sched/sch_api.c      |   5 +
 2 files changed, 256 insertions(+)
 create mode 100644 include/net/tc_wrapper.h

diff --git a/include/net/tc_wrapper.h b/include/net/tc_wrapper.h
new file mode 100644
index 000000000000..ceed2fc089ff
--- /dev/null
+++ b/include/net/tc_wrapper.h
@@ -0,0 +1,251 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_TC_WRAPPER_H
+#define __NET_TC_WRAPPER_H
+
+#include <net/pkt_cls.h>
+
+#if IS_ENABLED(CONFIG_RETPOLINE)
+
+#include <linux/cpufeature.h>
+#include <linux/static_key.h>
+#include <linux/indirect_call_wrapper.h>
+
+#define TC_INDIRECT_SCOPE
+
+extern struct static_key_false tc_skip_wrapper;
+
+/* TC Actions */
+#ifdef CONFIG_NET_CLS_ACT
+
+#define TC_INDIRECT_ACTION_DECLARE(fname)                              \
+	INDIRECT_CALLABLE_DECLARE(int fname(struct sk_buff *skb,       \
+					    const struct tc_action *a, \
+					    struct tcf_result *res))
+
+TC_INDIRECT_ACTION_DECLARE(tcf_bpf_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_connmark_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_csum_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_ct_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_ctinfo_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_gact_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_gate_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_ife_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_ipt_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_mirred_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_mpls_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_nat_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_pedit_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_police_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_sample_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_simp_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_skbedit_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_skbmod_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_vlan_act);
+TC_INDIRECT_ACTION_DECLARE(tunnel_key_act);
+
+static inline int tc_act(struct sk_buff *skb, const struct tc_action *a,
+			   struct tcf_result *res)
+{
+	if (static_branch_likely(&tc_skip_wrapper))
+		goto skip;
+
+#if IS_BUILTIN(CONFIG_NET_ACT_GACT)
+	if (a->ops->act == tcf_gact_act)
+		return tcf_gact_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_MIRRED)
+	if (a->ops->act == tcf_mirred_act)
+		return tcf_mirred_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_PEDIT)
+	if (a->ops->act == tcf_pedit_act)
+		return tcf_pedit_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_SKBEDIT)
+	if (a->ops->act == tcf_skbedit_act)
+		return tcf_skbedit_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_SKBMOD)
+	if (a->ops->act == tcf_skbmod_act)
+		return tcf_skbmod_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_POLICE)
+	if (a->ops->act == tcf_police_act)
+		return tcf_police_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_BPF)
+	if (a->ops->act == tcf_bpf_act)
+		return tcf_bpf_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_CONNMARK)
+	if (a->ops->act == tcf_connmark_act)
+		return tcf_connmark_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_CSUM)
+	if (a->ops->act == tcf_csum_act)
+		return tcf_csum_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_CT)
+	if (a->ops->act == tcf_ct_act)
+		return tcf_ct_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_CTINFO)
+	if (a->ops->act == tcf_ctinfo_act)
+		return tcf_ctinfo_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_GATE)
+	if (a->ops->act == tcf_gate_act)
+		return tcf_gate_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_MPLS)
+	if (a->ops->act == tcf_mpls_act)
+		return tcf_mpls_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_NAT)
+	if (a->ops->act == tcf_nat_act)
+		return tcf_nat_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_TUNNEL_KEY)
+	if (a->ops->act == tunnel_key_act)
+		return tunnel_key_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_VLAN)
+	if (a->ops->act == tcf_vlan_act)
+		return tcf_vlan_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_IFE)
+	if (a->ops->act == tcf_ife_act)
+		return tcf_ife_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_IPT)
+	if (a->ops->act == tcf_ipt_act)
+		return tcf_ipt_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_SIMP)
+	if (a->ops->act == tcf_simp_act)
+		return tcf_simp_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_SAMPLE)
+	if (a->ops->act == tcf_sample_act)
+		return tcf_sample_act(skb, a, res);
+#endif
+
+skip:
+	return a->ops->act(skb, a, res);
+}
+
+#endif /* CONFIG_NET_CLS_ACT */
+
+/* TC Filters */
+#ifdef CONFIG_NET_CLS
+
+#define TC_INDIRECT_FILTER_DECLARE(fname)                               \
+	INDIRECT_CALLABLE_DECLARE(int fname(struct sk_buff *skb,        \
+					    const struct tcf_proto *tp, \
+					    struct tcf_result *res))
+
+TC_INDIRECT_FILTER_DECLARE(basic_classify);
+TC_INDIRECT_FILTER_DECLARE(cls_bpf_classify);
+TC_INDIRECT_FILTER_DECLARE(cls_cgroup_classify);
+TC_INDIRECT_FILTER_DECLARE(fl_classify);
+TC_INDIRECT_FILTER_DECLARE(flow_classify);
+TC_INDIRECT_FILTER_DECLARE(fw_classify);
+TC_INDIRECT_FILTER_DECLARE(mall_classify);
+TC_INDIRECT_FILTER_DECLARE(route4_classify);
+TC_INDIRECT_FILTER_DECLARE(rsvp_classify);
+TC_INDIRECT_FILTER_DECLARE(rsvp6_classify);
+TC_INDIRECT_FILTER_DECLARE(tcindex_classify);
+TC_INDIRECT_FILTER_DECLARE(u32_classify);
+
+static inline int tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
+				struct tcf_result *res)
+{
+	if (static_branch_likely(&tc_skip_wrapper))
+		goto skip;
+
+#if IS_BUILTIN(CONFIG_NET_CLS_BPF)
+	if (tp->classify == cls_bpf_classify)
+		return cls_bpf_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_U32)
+	if (tp->classify == u32_classify)
+		return u32_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_FLOWER)
+	if (tp->classify == fl_classify)
+		return fl_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_FW)
+	if (tp->classify == fw_classify)
+		return fw_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_MATCHALL)
+	if (tp->classify == mall_classify)
+		return mall_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_BASIC)
+	if (tp->classify == basic_classify)
+		return basic_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_CGROUP)
+	if (tp->classify == cls_cgroup_classify)
+		return cls_cgroup_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_FLOW)
+	if (tp->classify == flow_classify)
+		return flow_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_ROUTE4)
+	if (tp->classify == route4_classify)
+		return route4_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_RSVP)
+	if (tp->classify == rsvp_classify)
+		return rsvp_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_RSVP6)
+	if (tp->classify == rsvp6_classify)
+		return rsvp6_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_TCINDEX)
+	if (tp->classify == tcindex_classify)
+		return tcindex_classify(skb, tp, res);
+#endif
+
+skip:
+	return tp->classify(skb, tp, res);
+}
+
+static inline void tc_wrapper_init(void)
+{
+#ifdef CONFIG_X86
+	if (!cpu_feature_enabled(X86_FEATURE_RETPOLINE))
+		static_branch_enable(&tc_skip_wrapper);
+#endif
+}
+
+#endif /* CONFIG_NET_CLS */
+
+#else
+
+#define TC_INDIRECT_SCOPE static
+
+static inline int tc_act(struct sk_buff *skb, const struct tc_action *a,
+			   struct tcf_result *res)
+{
+	return a->ops->act(skb, a, res);
+}
+
+static inline int tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
+				struct tcf_result *res)
+{
+	return tp->classify(skb, tp, res);
+}
+
+static inline void tc_wrapper_init(void)
+{
+}
+
+#endif
+
+#endif /* __NET_TC_WRAPPER_H */
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 4a27dfb1ba0f..2317db02c764 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -31,6 +31,7 @@
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 #include <trace/events/qdisc.h>
 
@@ -2273,6 +2274,8 @@ static struct pernet_operations psched_net_ops = {
 	.exit = psched_net_exit,
 };
 
+DEFINE_STATIC_KEY_FALSE(tc_skip_wrapper);
+
 static int __init pktsched_init(void)
 {
 	int err;
@@ -2300,6 +2303,8 @@ static int __init pktsched_init(void)
 	rtnl_register(PF_UNSPEC, RTM_GETTCLASS, tc_ctl_tclass, tc_dump_tclass,
 		      0);
 
+	tc_wrapper_init();
+
 	return 0;
 }
 
-- 
2.34.1

