Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D87763ACD9
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 16:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbiK1Ppn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 10:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbiK1Ppl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 10:45:41 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069891DA7A
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 07:45:40 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id q186so11966569oia.9
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 07:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+hEN630A4kgx4wAEubYbH0v6gg+fm7KjlmYkbd/10y4=;
        b=KFfyAub2PffK4wQixjJRXG34aBdVZlD4eo4WqC8yJq2WucGfSSiHTT8kJyAEr+XzCK
         dyNhP1GKSEoFhYkRIHjfuUZO5ocHi2JfK7Evjt6fs3aAA/MD/DPt02p3IWfUaXYvk2uc
         7MN3d8Vy6Bp5DI2jKWPQWwakmqlVZwJZuI1R3IuS1s4lDjygk90O5K04psBvUrm7oNnW
         8LWsbwOrrwK7VM5iLTVVnsTbyZmS5Nb48mLz0Jm3B3795mmR/zaoJlZ4ev7goJRqlARE
         wlG3AlCgoRxLdWvVFDxpZKkPKGn2P2ti1R/GTbV/MmIdIBIYzNJQNVxzdPKGQopp53UI
         naZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+hEN630A4kgx4wAEubYbH0v6gg+fm7KjlmYkbd/10y4=;
        b=ZiXK5OA36oUDW2L9fyXN9eQqVt4bh0GFJLsNR3abgYrABxBC3aqZO8f3bDUarL6kxa
         yuGw3gFVO/gzbpOv3e1Zcv5fg/RIgfnxxTnWT83o2UMhP6eD/Jkyb+qMg+v/JOyB8e0t
         YO8Kpn9JYmSaIOemZZGvwO6ZVOCAdqeVx2mIJFIHX0g4PlC2qAV4ne7jysNwWJXZ8rNn
         dqskt87piPtXEct8bjJOvFHr3JjSG4ta4qnKSRHuANEO0l0X4NtUlMFeWtkz/hkDaW4S
         /q/K7/aClD8ykeuQT4pAnoVCsKJUl1LZTkNK137kNSOOkGX0kKmcoJI/g6JeySZJnolG
         +IgQ==
X-Gm-Message-State: ANoB5pntPXfEggZ3n4+/iKawaSbHNMR64J8NtGpmHFcefkw9m+SBsdXe
        YRH3+asA/EMg+c/zB7DmrEb+bp6zifybPA==
X-Google-Smtp-Source: AA0mqf6Ww7e+CFgBW0oRhdXsaR55oBZWGsX6yLaEwnrrYxZ7+nk5oi1szYf04VYIBf1RhuB47c8qwg==
X-Received: by 2002:a05:6808:19a5:b0:35a:2a68:8d6a with SMTP id bj37-20020a05680819a500b0035a2a688d6amr15777784oib.261.1669650338979;
        Mon, 28 Nov 2022 07:45:38 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:562:c37c:87b7:acb4])
        by smtp.gmail.com with ESMTPSA id bx19-20020a056830601300b0066c55e23a16sm4885012otb.2.2022.11.28.07.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 07:45:38 -0800 (PST)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 1/3] net/sched: add retpoline wrapper for tc
Date:   Mon, 28 Nov 2022 12:44:54 -0300
Message-Id: <20221128154456.689326-2-pctammela@mojatatu.com>
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

On kernels compiled with CONFIG_RETPOLINE and CONFIG_NET_TC_INDIRECT_WRAPPER,
optimize actions and filters that are compiled as built-ins into a direct call.
The calls are ordered alphabetically, but new ones should be ideally
added last.

On subsequent patches we expose the classifiers and actions functions
and wire up the wrapper into tc.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 include/net/tc_wrapper.h | 232 +++++++++++++++++++++++++++++++++++++++
 net/sched/Kconfig        |  13 +++
 2 files changed, 245 insertions(+)
 create mode 100644 include/net/tc_wrapper.h

diff --git a/include/net/tc_wrapper.h b/include/net/tc_wrapper.h
new file mode 100644
index 000000000000..bd2b4789db2b
--- /dev/null
+++ b/include/net/tc_wrapper.h
@@ -0,0 +1,232 @@
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
+#endif /* CONFIG_NET_CLS */
+
+#else
+
+#define TC_INDIRECT_SCOPE static
+
+#ifdef CONFIG_NET_CLS_ACT
+static inline int __tc_act(struct sk_buff *skb, const struct tc_action *a,
+			   struct tcf_result *res)
+{
+	return a->ops->act(skb, a, res);
+}
+#endif
+
+#ifdef CONFIG_NET_CLS
+static inline int __tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
+				struct tcf_result *res)
+{
+	return tp->classify(skb, tp, res);
+}
+#endif
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

