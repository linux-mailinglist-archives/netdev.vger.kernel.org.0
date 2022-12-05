Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC752643874
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 23:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbiLEWxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 17:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiLEWxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 17:53:23 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A271D677
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 14:53:21 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id v82so14818971oib.4
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 14:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O03XGO9+hjeLYWBgZUcHTsanZYJMevaBnrps5qB+/EQ=;
        b=mHOyzWav+x2PDpYOy/bxgJkF1pD0VmcmHnJMyivCNx0AxgH9EvWSbFWvjY37MrZdmK
         LivhHX/+LdXXFpkNF4rzO5CDO035Rf5eVbXufnYv0WuK2tK4NCb/Gxsou6XQfjWmxxq/
         8TGJLvDvr1fgr4QYDXl4Yg3cyOWtMyp+s+Mt+6XqgyDWqhM/Di7cq9q6oJGFFrI2JTcB
         AbVocXBgKQvwFfK9CWuprQGsxZ4FoUEHsRxv4iPNwWQcH38t7kYY9dBUpcRXeLH5szmp
         q3AaSYpHV3Xd/Tnh+PpDI/7mAMKLmSrRcYaa89vGLyVcIM+xx773qaYt/OW/alnodROQ
         BEDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O03XGO9+hjeLYWBgZUcHTsanZYJMevaBnrps5qB+/EQ=;
        b=Faq3YiGlyqZFU7rhuu1B52Dk2bdbxrRtdELAQDi+JjGcBkE1ToEyAdZE0Hpi95RatU
         LIyegSpytByaeBZXzIZzPT/bljtV1XdKjXlnY6SiJuB+3vcuiviMFWNmKoMb/CN8YbbW
         rT0zwcn93fdm4UZ7ZneP2bhTWlrsmWEj0FjjdhPOUuJkpTiNoGuNjNfNTHgdG8jfQuls
         1f9k3H0quGhZ+BoS/gIl2SpF4FuljCQpQETKLtBWLIG59CXgzd6rft8b9Kj48xrBpCTN
         DkwfzK350GnRsz5ma5mRU8pZ3WKzLfnSsgkV6SsEqJGw6HNTL0J/wr6oafjQYY5B15k8
         Iolg==
X-Gm-Message-State: ANoB5pmSj8400LpEZEP8bylQ/vppWNqrOXzpk/8XBUUjZLkHEEm5H+Pn
        Bi58ok9qUPvWYoegO/5w8gDvf9777PeYKocG
X-Google-Smtp-Source: AA0mqf6slm5r9ok0tlfqEzXzVx3RV3HtPMH/RiOx17clYnsOb8ZNBQjmdABwoYP56cCKWYwPgO0NDw==
X-Received: by 2002:a05:6808:287:b0:35a:ac8:182d with SMTP id z7-20020a056808028700b0035a0ac8182dmr33206706oic.264.1670280800915;
        Mon, 05 Dec 2022 14:53:20 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:56de:4ea4:df4e:f7cc])
        by smtp.gmail.com with ESMTPSA id e5-20020a544f05000000b0035a5ed5d935sm7608935oiy.16.2022.12.05.14.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 14:53:20 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH net-next v4 2/4] net/sched: add retpoline wrapper for tc
Date:   Mon,  5 Dec 2022 19:53:04 -0300
Message-Id: <20221205225306.1778712-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221205225306.1778712-1-pctammela@mojatatu.com>
References: <20221205225306.1778712-1-pctammela@mojatatu.com>
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
 include/net/tc_wrapper.h | 250 +++++++++++++++++++++++++++++++++++++++
 net/sched/act_api.c      |   2 +
 net/sched/cls_api.c      |   2 +
 3 files changed, 254 insertions(+)
 create mode 100644 include/net/tc_wrapper.h

diff --git a/include/net/tc_wrapper.h b/include/net/tc_wrapper.h
new file mode 100644
index 000000000000..429ebd7255b4
--- /dev/null
+++ b/include/net/tc_wrapper.h
@@ -0,0 +1,250 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_TC_WRAPPER_H
+#define __NET_TC_WRAPPER_H
+
+#include <net/pkt_cls.h>
+
+#if IS_ENABLED(CONFIG_RETPOLINE)
+
+#include <asm/cpufeature.h>
+
+#include <linux/static_key.h>
+#include <linux/indirect_call_wrapper.h>
+
+#define TC_INDIRECT_SCOPE
+
+static DEFINE_STATIC_KEY_FALSE(tc_skip_wrapper);
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
+	if (!cpu_feature_enabled(X86_FEATURE_RETPOLINE))
+		static_branch_enable(&tc_skip_wrapper);
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
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 9b31a10cc639..9f4c0f5f45c1 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -2178,6 +2178,8 @@ static int __init tc_action_init(void)
 	rtnl_register(PF_UNSPEC, RTM_GETACTION, tc_ctl_action, tc_dump_action,
 		      0);
 
+	tc_wrapper_init();
+
 	return 0;
 }
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 23d1cfa4f58c..a2c276116244 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3764,6 +3764,8 @@ static int __init tc_filter_init(void)
 	rtnl_register(PF_UNSPEC, RTM_GETCHAIN, tc_ctl_chain,
 		      tc_dump_chain, 0);
 
+	tc_wrapper_init();
+
 	return 0;
 
 err_register_pernet_subsys:
-- 
2.34.1

