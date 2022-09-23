Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1BF5E7E61
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbiIWP24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbiIWP2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:28:33 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C576E13F2BD
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:28:31 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id ml1so145620qvb.1
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=HbMGFKc8LXn+lCm1vYGnRHKAAJ12mCem9Jfipba0kF0=;
        b=BgdJ8Rk2WcFsTduOlTElnqoVEciKj/9OaYri67neWv/hH/wCAth+6lVOpZKVR4fAhp
         lHc/OXY6MO9MOoay0lHJ8gwU4sA3venXN1/Ufld71hur2T0wkJtNjK5DAJj1t4zCAEob
         d9k0/q7Tf5p17vAyn05FY+P+8fRBjk2M1MRIdk0fENIo+5C07eW0RVTJq2JwzAP1FU9H
         LQeI9z8IFKABK/zbk7HQDf60qcgzZKC83IRQxQCMLsi7EADzJ4h9bdwCjcm8LZw/e+Wg
         a4sEgOU4AE12iWP0v5Utk2iZTkHIyFuL28l61ngImnCyS7ePrbAzqCikTWt3plNcWq5F
         IjFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=HbMGFKc8LXn+lCm1vYGnRHKAAJ12mCem9Jfipba0kF0=;
        b=oAUKq36+xehLKCtFXKDyrLy3/XVcD0MTNIo2lutqziLyU57v5DeMolOn7tyEXWIvTv
         SA+IpdKSB+L2swppGDr3eTy/Co/lUAf6F2KIaO7KaxMAsj75UUUX16Aa443g61MVBUzj
         W3JNSyfze/BwRr13Voh57ab1UN4tgWTvHYrWeAcgOog1xsTv2LcdXB3/eraWfu6q9nak
         CEzJ4/6l5jkj8X8uzWvCZfP0W53nKaviM+t+qgpniXQ9HQ90wR/OWjUX7l8fba0ZwVjt
         436vXfsTn0/anpbJ1St8qhyYv4+uTD8APFPtC8YhhhMkqDKCrODBdm+1EVIYET1ERryk
         On+w==
X-Gm-Message-State: ACrzQf16wh4Eb8YmFw84S/nh2SXtT5rMfymRbQ+1nXwUIsxlxfpmuDP+
        ZwlyB6O3FYDv0muwFLRAXANVpty6lUolXA==
X-Google-Smtp-Source: AMsMyM4K2+Nt89pqQjtMsmKg+99hli8B1j3mkNf0SFlcVu3WlvI90p6j2DMA/8xsesfWK6sJ+MjOzg==
X-Received: by 2002:ad4:5dc8:0:b0:4ac:907c:f5c0 with SMTP id m8-20020ad45dc8000000b004ac907cf5c0mr7246578qvh.63.1663946910677;
        Fri, 23 Sep 2022 08:28:30 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id dm52-20020a05620a1d7400b006ce3f1af120sm6623051qkb.44.2022.09.23.08.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 08:28:30 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>
Subject: [PATCH net-next 2/2] net: sched: add helper support in act_ct
Date:   Fri, 23 Sep 2022 11:28:27 -0400
Message-Id: <4781b55b0b7498c574ace703a1481e3688e3f18d.1663946157.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1663946157.git.lucien.xin@gmail.com>
References: <cover.1663946157.git.lucien.xin@gmail.com>
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

This patch is to add helper support in act_ct for OVS actions=ct(alg=xxx)
offloading, which is corresponding to Commit cae3a2627520 ("openvswitch:
Allow attaching helpers to ct action") in OVS kernel part.

The difference is when adding TC actions family and proto cannot be got
from the filter/match, other than helper name in tb[TCA_CT_HELPER_NAME],
we also need to send the family in tb[TCA_CT_HELPER_FAMILY] and the
proto in tb[TCA_CT_HELPER_PROTO] to kernel.

Note when calling helper->help() in tcf_ct_act(), the packet will be
dropped if skb's family and proto do not match the helper's.

Reported-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/tc_act/tc_ct.h        |   1 +
 include/uapi/linux/tc_act/tc_ct.h |   3 +
 net/sched/act_ct.c                | 163 +++++++++++++++++++++++++++++-
 3 files changed, 165 insertions(+), 2 deletions(-)

diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
index 8250d6f0a462..b24ea2d9400b 100644
--- a/include/net/tc_act/tc_ct.h
+++ b/include/net/tc_act/tc_ct.h
@@ -10,6 +10,7 @@
 #include <net/netfilter/nf_conntrack_labels.h>
 
 struct tcf_ct_params {
+	struct nf_conntrack_helper *helper;
 	struct nf_conn *tmpl;
 	u16 zone;
 
diff --git a/include/uapi/linux/tc_act/tc_ct.h b/include/uapi/linux/tc_act/tc_ct.h
index 5fb1d7ac1027..6c5200f0ed38 100644
--- a/include/uapi/linux/tc_act/tc_ct.h
+++ b/include/uapi/linux/tc_act/tc_ct.h
@@ -22,6 +22,9 @@ enum {
 	TCA_CT_NAT_PORT_MIN,	/* be16 */
 	TCA_CT_NAT_PORT_MAX,	/* be16 */
 	TCA_CT_PAD,
+	TCA_CT_HELPER_NAME,	/* string */
+	TCA_CT_HELPER_FAMILY,	/* u8 */
+	TCA_CT_HELPER_PROTO,	/* u8 */
 	__TCA_CT_MAX
 };
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 193a460a9d7f..771cf72ee9e1 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -33,6 +33,7 @@
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <net/netfilter/nf_conntrack_act_ct.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
 #include <uapi/linux/netfilter/nf_nat.h>
 
 static struct workqueue_struct *act_ct_wq;
@@ -832,6 +833,13 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 
 static void tcf_ct_params_free(struct tcf_ct_params *params)
 {
+	if (params->helper) {
+#if IS_ENABLED(CONFIG_NF_NAT)
+		if (params->ct_action & TCA_CT_ACT_NAT)
+			nf_nat_helper_put(params->helper);
+#endif
+		nf_conntrack_helper_put(params->helper);
+	}
 	if (params->ct_ft)
 		tcf_ct_flow_table_put(params->ct_ft);
 	if (params->tmpl)
@@ -1022,6 +1030,69 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
 #endif
 }
 
+static int tcf_ct_helper(struct sk_buff *skb, u8 family)
+{
+	const struct nf_conntrack_helper *helper;
+	const struct nf_conn_help *help;
+	enum ip_conntrack_info ctinfo;
+	unsigned int protoff;
+	struct nf_conn *ct;
+	u8 proto;
+	int err;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
+		return NF_ACCEPT;
+
+	help = nfct_help(ct);
+	if (!help)
+		return NF_ACCEPT;
+
+	helper = rcu_dereference(help->helper);
+	if (!helper)
+		return NF_ACCEPT;
+
+	if (helper->tuple.src.l3num != NFPROTO_UNSPEC &&
+	    helper->tuple.src.l3num != family)
+		return NF_DROP;
+
+	switch (family) {
+	case NFPROTO_IPV4:
+		protoff = ip_hdrlen(skb);
+		proto = ip_hdr(skb)->protocol;
+		break;
+	case NFPROTO_IPV6: {
+		__be16 frag_off;
+		int ofs;
+
+		proto = ipv6_hdr(skb)->nexthdr;
+		ofs = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &proto, &frag_off);
+		if (ofs < 0 || (frag_off & htons(~0x7)) != 0) {
+			pr_debug("proto header not found\n");
+			return NF_DROP;
+		}
+		protoff = ofs;
+		break;
+	}
+	default:
+		WARN_ONCE(1, "helper invoked on non-IP family!");
+		return NF_DROP;
+	}
+
+	if (helper->tuple.dst.protonum != proto)
+		return NF_DROP;
+
+	err = helper->help(skb, protoff, ct, ctinfo);
+	if (err != NF_ACCEPT)
+		return NF_DROP;
+
+	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
+	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
+		return NF_DROP;
+
+	return NF_ACCEPT;
+}
+
 static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		      struct tcf_result *res)
 {
@@ -1033,6 +1104,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	struct nf_hook_state state;
 	int nh_ofs, err, retval;
 	struct tcf_ct_params *p;
+	bool add_helper = false;
 	bool skip_add = false;
 	bool defrag = false;
 	struct nf_conn *ct;
@@ -1119,6 +1191,22 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	if (err != NF_ACCEPT)
 		goto drop;
 
+	if (commit && p->helper && !nfct_help(ct)) {
+		err = __nf_ct_try_assign_helper(ct, p->tmpl, GFP_ATOMIC);
+		if (err)
+			goto drop;
+		add_helper = true;
+		if (p->ct_action & TCA_CT_ACT_NAT && !nfct_seqadj(ct)) {
+			if (!nfct_seqadj_ext_add(ct))
+				return -EINVAL;
+		}
+	}
+
+	if (nf_ct_is_confirmed(ct) ? (!cached || add_helper) : commit) {
+		if (tcf_ct_helper(skb, family) != NF_ACCEPT)
+			goto drop;
+	}
+
 	if (commit) {
 		tcf_ct_act_set_mark(ct, p->mark, p->mark_mask);
 		tcf_ct_act_set_labels(ct, p->labels, p->labels_mask);
@@ -1167,6 +1255,9 @@ static const struct nla_policy ct_policy[TCA_CT_MAX + 1] = {
 	[TCA_CT_NAT_IPV6_MAX] = NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
 	[TCA_CT_NAT_PORT_MIN] = { .type = NLA_U16 },
 	[TCA_CT_NAT_PORT_MAX] = { .type = NLA_U16 },
+	[TCA_CT_HELPER_NAME] = { .type = NLA_STRING, .len = NF_CT_HELPER_NAME_LEN },
+	[TCA_CT_HELPER_FAMILY] = { .type = NLA_U8 },
+	[TCA_CT_HELPER_PROTO] = { .type = NLA_U8 },
 };
 
 static int tcf_ct_fill_params_nat(struct tcf_ct_params *p,
@@ -1248,6 +1339,39 @@ static void tcf_ct_set_key_val(struct nlattr **tb,
 		nla_memcpy(mask, tb[mask_type], len);
 }
 
+static int tcf_ct_add_helper(struct tcf_ct_params *p, const char *name, u8 family,
+			     u8 proto, struct netlink_ext_ack *extack)
+{
+	struct nf_conntrack_helper *helper;
+	struct nf_conn_help *help;
+	int err;
+
+	helper = nf_conntrack_helper_try_module_get(name, family, proto);
+	if (!helper) {
+		NL_SET_ERR_MSG_MOD(extack, "Unknown helper");
+		return -EINVAL;
+	}
+
+	help = nf_ct_helper_ext_add(p->tmpl, GFP_KERNEL);
+	if (!help) {
+		nf_conntrack_helper_put(helper);
+		return -ENOMEM;
+	}
+#if IS_ENABLED(CONFIG_NF_NAT)
+	if (p->ct_action & TCA_CT_ACT_NAT) {
+		err = nf_nat_helper_try_module_get(name, family, proto);
+		if (err) {
+			nf_conntrack_helper_put(helper);
+			NL_SET_ERR_MSG_MOD(extack, "Failed to load NAT helper");
+			return err;
+		}
+	}
+#endif
+	rcu_assign_pointer(help->helper, helper);
+	p->helper = helper;
+	return 0;
+}
+
 static int tcf_ct_fill_params(struct net *net,
 			      struct tcf_ct_params *p,
 			      struct tc_ct *parm,
@@ -1256,8 +1380,9 @@ static int tcf_ct_fill_params(struct net *net,
 {
 	struct tc_ct_action_net *tn = net_generic(net, act_ct_ops.net_id);
 	struct nf_conntrack_zone zone;
+	int err, family, proto, len;
 	struct nf_conn *tmpl;
-	int err;
+	char *name;
 
 	p->zone = NF_CT_DEFAULT_ZONE_ID;
 
@@ -1318,10 +1443,28 @@ static int tcf_ct_fill_params(struct net *net,
 		NL_SET_ERR_MSG_MOD(extack, "Failed to allocate conntrack template");
 		return -ENOMEM;
 	}
-	__set_bit(IPS_CONFIRMED_BIT, &tmpl->status);
 	p->tmpl = tmpl;
+	if (tb[TCA_CT_HELPER_NAME]) {
+		name = nla_data(tb[TCA_CT_HELPER_NAME]);
+		len = nla_len(tb[TCA_CT_HELPER_NAME]);
+		if (len > 16 || name[len - 1] != '\0') {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to parse helper name.");
+			err = -EINVAL;
+			goto err;
+		}
+		family = tb[TCA_CT_HELPER_FAMILY] ? nla_get_u8(tb[TCA_CT_HELPER_FAMILY]) : AF_INET;
+		proto = tb[TCA_CT_HELPER_PROTO] ? nla_get_u8(tb[TCA_CT_HELPER_PROTO]) : IPPROTO_TCP;
+		err = tcf_ct_add_helper(p, name, family, proto, extack);
+		if (err)
+			goto err;
+	}
 
+	__set_bit(IPS_CONFIRMED_BIT, &tmpl->status);
 	return 0;
+err:
+	nf_ct_put(p->tmpl);
+	p->tmpl = NULL;
+	return err;
 }
 
 static int tcf_ct_init(struct net *net, struct nlattr *nla,
@@ -1490,6 +1633,19 @@ static int tcf_ct_dump_nat(struct sk_buff *skb, struct tcf_ct_params *p)
 	return 0;
 }
 
+static int tcf_ct_dump_helper(struct sk_buff *skb, struct nf_conntrack_helper *helper)
+{
+	if (!helper)
+		return 0;
+
+	if (nla_put_string(skb, TCA_CT_HELPER_NAME, helper->name) ||
+	    nla_put_u8(skb, TCA_CT_HELPER_FAMILY, helper->tuple.src.l3num) ||
+	    nla_put_u8(skb, TCA_CT_HELPER_PROTO, helper->tuple.dst.protonum))
+		return -1;
+
+	return 0;
+}
+
 static inline int tcf_ct_dump(struct sk_buff *skb, struct tc_action *a,
 			      int bind, int ref)
 {
@@ -1542,6 +1698,9 @@ static inline int tcf_ct_dump(struct sk_buff *skb, struct tc_action *a,
 	if (tcf_ct_dump_nat(skb, p))
 		goto nla_put_failure;
 
+	if (tcf_ct_dump_helper(skb, p->helper))
+		goto nla_put_failure;
+
 skip_dump:
 	if (nla_put(skb, TCA_CT_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
-- 
2.31.1

