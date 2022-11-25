Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A242638F5A
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 18:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiKYRwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 12:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiKYRwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 12:52:37 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E867410D5
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 09:52:35 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id h132so5131536oif.2
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 09:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/7MKXq9dYEYfL16O9NYxncqEjD/2Z37zyovnvO9V5b0=;
        b=eI/IBqRUKFoRaZU4/zapPjhjuLipd51EgH2GWE2ptw2zkjvwWZI4d+Iu9GdGgnEmyU
         6wPaMJ98v4egLjkd90ZEWt2oI6z1+IesERB/z4OzAY0kOqhFt7jVbdF1SvI7zPUJcxeh
         RPgkUliUXnsYTPONSaHmXZPZVV1KZY+BbJJgse3hpW/FZgAjXiTh2QkiHqHO0P1/fNcw
         jP1qmghjPmy+g/RpnXQUNKk9ta6k9ExCHH8URnzKAfmmkxB31bH+Lh78kQoak49jkn2y
         XxzeVB6sHAcZjv8G54ztlUAbhSX1Ovpf7Bug0T8wmbu37fAuSQ6fq6xB15TNZmpetmrP
         lx+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/7MKXq9dYEYfL16O9NYxncqEjD/2Z37zyovnvO9V5b0=;
        b=xA20ufCSNftsz8yhQA39iseVnbrZ0L7p1RV0Iqqd60waggxMOdztr8D5vunIfPEgJS
         sfxAJl6gsiZyJ3rWtSkH7xexSn+SfsqfD9tLSc2aqRloP7S8JwmL7IdEkFmDvWTth0yi
         Cnznwitp5FLhrzuzEoXZmPJoPwnXHkip4Gh4iKz3sA0y3yhn2Cnheq62rvWUVfBh73j9
         cq5W49Ktg5oWPpJtEpV00nkwOFGSx8lIvK9NEerHj2bzVUUAEAId0sKo47NXmvJPQ+au
         ufzUqBYNjQpX7QOCPLVWn00JdWj3NtlA96Jh2XYDxyItD9WmVw/tSMTpqAdY7gbZxJwv
         kfnQ==
X-Gm-Message-State: ANoB5pmahm7P4Lc0wB89ntNSs6EZbj7oELBgO2xP7AHmkmwYjF1YtWTJ
        g3HoBN50gQExlqh+0mQN6y1+yd66EP4hIo54
X-Google-Smtp-Source: AA0mqf5KOe9GYy8PEzJVr3pr3zjQX9fhiYvcmW3t2h7kt3q/YwgNvUvv3QVAjMAYhTukvk9yGwveXw==
X-Received: by 2002:a54:4615:0:b0:359:e8b1:7ac4 with SMTP id p21-20020a544615000000b00359e8b17ac4mr11183223oip.70.1669398754887;
        Fri, 25 Nov 2022 09:52:34 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:e90:8a20:11c9:921b])
        by smtp.gmail.com with ESMTPSA id j44-20020a4a946f000000b0049fcedf1899sm1771570ooi.3.2022.11.25.09.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 09:52:34 -0800 (PST)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH RFC net-next 1/3] net/sched: add retpoline wrapper for tc
Date:   Fri, 25 Nov 2022 14:52:05 -0300
Message-Id: <20221125175207.473866-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221125175207.473866-1-pctammela@mojatatu.com>
References: <20221125175207.473866-1-pctammela@mojatatu.com>
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

On kernels compiled with CONFIG_RETPOLINE and CONFIG_NET_TC_INDIRECT_WRAPPER,
optimize actions and filters that are compiled as built-ins into a direct call.
The calls are ordered alphabetically, but new ones should be ideally
added last.

On subsequent patches we expose the classifiers and actions functions
and wire up the wrapper into tc.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/tc_wrapper.h | 274 +++++++++++++++++++++++++++++++++++++++
 net/sched/Kconfig        |  13 ++
 2 files changed, 287 insertions(+)
 create mode 100644 include/net/tc_wrapper.h

diff --git a/include/net/tc_wrapper.h b/include/net/tc_wrapper.h
new file mode 100644
index 000000000000..7890d2810148
--- /dev/null
+++ b/include/net/tc_wrapper.h
@@ -0,0 +1,274 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_TC_WRAPPER_H
+#define __NET_TC_WRAPPER_H
+
+#include <linux/indirect_call_wrapper.h>
+#include <net/pkt_cls.h>
+
+#if IS_ENABLED(CONFIG_RETPOLINE) && IS_ENABLED(CONFIG_NET_TC_INDIRECT_WRAPPER)
+
+#define TC_INDIRECT_SCOPE
+
+/* TC Actions */
+INDIRECT_CALLABLE_DECLARE(int tcf_bpf_act(struct sk_buff *skb,
+					  const struct tc_action *a,
+					  struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_connmark_act(struct sk_buff *skb,
+					       const struct tc_action *a,
+					       struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_csum_act(struct sk_buff *skb,
+					   const struct tc_action *a,
+					   struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_ct_act(struct sk_buff *skb,
+					 const struct tc_action *a,
+					 struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_ctinfo_act(struct sk_buff *skb,
+					     const struct tc_action *a,
+					     struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_gact_act(struct sk_buff *skb,
+					   const struct tc_action *a,
+					   struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_gate_act(struct sk_buff *skb,
+					   const struct tc_action *a,
+					   struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_ife_act(struct sk_buff *skb,
+					  const struct tc_action *a,
+					  struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_ipt_act(struct sk_buff *skb,
+					  const struct tc_action *a,
+					  struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_mirred_act(struct sk_buff *skb,
+					     const struct tc_action *a,
+					     struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_mpls_act(struct sk_buff *skb,
+					   const struct tc_action *a,
+					   struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_nat_act(struct sk_buff *skb,
+					  const struct tc_action *a,
+					  struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_pedit_act(struct sk_buff *skb,
+					    const struct tc_action *a,
+					    struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_police_act(struct sk_buff *skb,
+					     const struct tc_action *a,
+					     struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_sample_act(struct sk_buff *skb,
+					     const struct tc_action *a,
+					     struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_simp_act(struct sk_buff *skb,
+					   const struct tc_action *a,
+					   struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_skbedit_act(struct sk_buff *skb,
+					      const struct tc_action *a,
+					      struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_skbmod_act(struct sk_buff *skb,
+					     const struct tc_action *a,
+					     struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcf_vlan_act(struct sk_buff *skb,
+					   const struct tc_action *a,
+					   struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tunnel_key_act(struct sk_buff *skb,
+					     const struct tc_action *a,
+					     struct tcf_result *res));
+
+/* TC Filters */
+INDIRECT_CALLABLE_DECLARE(int basic_classify(struct sk_buff *skb,
+					     const struct tcf_proto *tp,
+					     struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int cls_bpf_classify(struct sk_buff *skb,
+					       const struct tcf_proto *tp,
+					       struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int cls_cgroup_classify(struct sk_buff *skb,
+						  const struct tcf_proto *tp,
+						  struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int fl_classify(struct sk_buff *skb,
+					  const struct tcf_proto *tp,
+					  struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int flow_classify(struct sk_buff *skb,
+					    const struct tcf_proto *tp,
+					    struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int fw_classify(struct sk_buff *skb,
+					  const struct tcf_proto *tp,
+					  struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int mall_classify(struct sk_buff *skb,
+					    const struct tcf_proto *tp,
+					    struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int route4_classify(struct sk_buff *skb,
+					      const struct tcf_proto *tp,
+					      struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int rsvp_classify(struct sk_buff *skb,
+					    const struct tcf_proto *tp,
+					    struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int rsvp6_classify(struct sk_buff *skb,
+					     const struct tcf_proto *tp,
+					     struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int tcindex_classify(struct sk_buff *skb,
+					       const struct tcf_proto *tp,
+					       struct tcf_result *res));
+INDIRECT_CALLABLE_DECLARE(int u32_classify(struct sk_buff *skb,
+					   const struct tcf_proto *tp,
+					   struct tcf_result *res));
+
+static inline int __tc_act(struct sk_buff *skb, const struct tc_action *a,
+			   struct tcf_result *res)
+{
+	if (0) { /* noop */ }
+#if IS_BUILTIN(CONFIG_NET_ACT_BPF)
+	else if (a->ops->act == tcf_bpf_act)
+		return tcf_bpf_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_CONNMARK)
+	else if (a->ops->act == tcf_connmark_act)
+		return tcf_connmark_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_CSUM)
+	else if (a->ops->act == tcf_csum_act)
+		return tcf_csum_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_CT)
+	else if (a->ops->act == tcf_ct_act)
+		return tcf_ct_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_CTINFO)
+	else if (a->ops->act == tcf_ctinfo_act)
+		return tcf_ctinfo_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_GACT)
+	else if (a->ops->act == tcf_gact_act)
+		return tcf_gact_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_GATE)
+	else if (a->ops->act == tcf_gate_act)
+		return tcf_gate_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_IFE)
+	else if (a->ops->act == tcf_ife_act)
+		return tcf_ife_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_IPT)
+	else if (a->ops->act == tcf_ipt_act)
+		return tcf_ipt_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_MIRRED)
+	else if (a->ops->act == tcf_mirred_act)
+		return tcf_mirred_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_MPLS)
+	else if (a->ops->act == tcf_mpls_act)
+		return tcf_mpls_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_NAT)
+	else if (a->ops->act == tcf_nat_act)
+		return tcf_nat_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_PEDIT)
+	else if (a->ops->act == tcf_pedit_act)
+		return tcf_pedit_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_POLICE)
+	else if (a->ops->act == tcf_police_act)
+		return tcf_police_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_SAMPLE)
+	else if (a->ops->act == tcf_sample_act)
+		return tcf_sample_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_SIMP)
+	else if (a->ops->act == tcf_simp_act)
+		return tcf_simp_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_SKBEDIT)
+	else if (a->ops->act == tcf_skbedit_act)
+		return tcf_skbedit_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_SKBMOD)
+	else if (a->ops->act == tcf_skbmod_act)
+		return tcf_skbmod_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_TUNNEL_KEY)
+	else if (a->ops->act == tunnel_key_act)
+		return tunnel_key_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_VLAN)
+	else if (a->ops->act == tcf_vlan_act)
+		return tcf_vlan_act(skb, a, res);
+#endif
+	else
+		return a->ops->act(skb, a, res);
+}
+
+static inline int __tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
+				struct tcf_result *res)
+{
+	if (0) { /* noop */ }
+#if IS_BUILTIN(CONFIG_NET_CLS_BASIC)
+	else if (tp->classify == basic_classify)
+		return basic_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_BPF)
+	else if (tp->classify == cls_bpf_classify)
+		return cls_bpf_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_CGROUP)
+	else if (tp->classify == cls_cgroup_classify)
+		return cls_cgroup_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_FLOW)
+	else if (tp->classify == flow_classify)
+		return flow_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_FLOWER)
+	else if (tp->classify == fl_classify)
+		return fl_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_FW)
+	else if (tp->classify == fw_classify)
+		return fw_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_MATCHALL)
+	else if (tp->classify == mall_classify)
+		return mall_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_ROUTE4)
+	else if (tp->classify == route4_classify)
+		return route4_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_RSVP)
+	else if (tp->classify == rsvp_classify)
+		return rsvp_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_RSVP6)
+	else if (tp->classify == rsvp6_classify)
+		return rsvp_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_TCINDEX)
+	else if (tp->classify == tcindex_classify)
+		return tcindex_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_U32)
+	else if (tp->classify == u32_classify)
+		return u32_classify(skb, tp, res);
+#endif
+	else
+		return tp->classify(skb, tp, res);
+}
+
+#else
+
+#define TC_INDIRECT_SCOPE static
+
+static inline int __tc_act(struct sk_buff *skb, const struct tc_action *a,
+			   struct tcf_result *res)
+{
+	return a->ops->act(skb, a, res);
+}
+
+static inline int __tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
+				struct tcf_result *res)
+{
+	return tp->classify(skb, tp, res);
+}
+
+#endif
+
+#endif /* __NET_TC_WRAPPER_H */
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 1e8ab4749c6c..9bc055f8013e 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -1021,6 +1021,19 @@ config NET_TC_SKB_EXT
 
 	  Say N here if you won't be using tc<->ovs offload or tc chains offload.
 
+config NET_TC_INDIRECT_WRAPPER
+	bool "TC indirect call wrapper"
+	depends on NET_SCHED
+	depends on RETPOLINE
+
+	help
+	  Say Y here to skip indirect calls in the TC datapath for known
+	  builtin classifiers/actions under CONFIG_RETPOLINE kernels.
+
+	  TC may run slower on CPUs with hardware based mitigations.
+
+	  If unsure, say N.
+
 endif # NET_SCHED
 
 config NET_SCH_FIFO
-- 
2.34.1

