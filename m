Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658F161E5F1
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 21:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiKFUeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 15:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiKFUeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 15:34:31 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FC211812
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 12:34:29 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id l15so5984403qtv.4
        for <netdev@vger.kernel.org>; Sun, 06 Nov 2022 12:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d31Dt3ofmZwjF6t1U0wUhEvYuQCCwFxS7EqjrCvQOvY=;
        b=IBo/lQx6VoTDDa5R5KHwZG+JZbVddZ1BEnXKyZD22q8gzOWcbCpT+ZVodG/cLpUmlP
         gAVWZi1LAUk/ojnWOHAK6EZ95TssEhKfa3GwKjG+8A9rLC+CZbwtdmY+rU5Dwvf5JF3k
         DqA67NSde6QFDTNRb/pG34Gw46CYm+XLRoO67+ZnTbjEZSbD7Q2THDvwMPvEZAESebS3
         kWmqLCE2Rx4+uoqQ6RyiC46bNCQ7nM43lxWNYETb/diWnL6i6H8Nqso27Ild2ExwUpTK
         G4e6RetgihH60f7R4jQJ/1VQi+380GE/L9RTqBRb6woNZ+jqcT1PoUBzxr0NR1mxnRU5
         eIXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d31Dt3ofmZwjF6t1U0wUhEvYuQCCwFxS7EqjrCvQOvY=;
        b=hAV7ProwK1Y+f1X80LAR+79PGeL3PFtZp06uBp6qWKkwnONVdT51fGI+fALwZnJB4Z
         aSDif0mnhImzmvgr0xTw4Wly4wE0WD5GUwut93g6qEPuYOnfZbZO60lUWEEwYuZ1ChEQ
         sZ2DML4kd6zj3/z0yRUyZ2WsuyxfluEd6OKpYIApW05dA3h3IwBjUbFvBVrAcU0igRJS
         HkKr00qBIoFgMAULJixZ7/xZOtMmvxkt6C55jxcNVFokAih6fiwL47VZZVKla+eeo07X
         hlXZXwdZyypsTAipDu4+NUD8U/5zI4YYJOVMGd0QFbBPZfQ2sH3Y/m/8xdNqL7da19S4
         fCNw==
X-Gm-Message-State: ACrzQf3IrTrsMIZHPIhOFTcomRlR2sOu07hxkuSo3qh/1WDfPR0fSUeF
        V81nlrqUfB03wZt/CRIPkiYx25vfrC7siA==
X-Google-Smtp-Source: AMsMyM6cpS0V5xnLz6q7MqbScj0pIrUUzYm67GQytNCtzLREXp/vMP9WDyzeEJBGbkeVbwLhhhusAg==
X-Received: by 2002:ac8:6bc5:0:b0:3a5:1ecb:157 with SMTP id b5-20020ac86bc5000000b003a51ecb0157mr32971041qtt.503.1667766867737;
        Sun, 06 Nov 2022 12:34:27 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id t31-20020a05622a181f00b003a540320070sm4703551qtc.6.2022.11.06.12.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 12:34:27 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCHv4 net-next 4/4] net: sched: add helper support in act_ct
Date:   Sun,  6 Nov 2022 15:34:17 -0500
Message-Id: <7ce806d2895ce52d9ffef9ea1f26b68425b32662.1667766782.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1667766782.git.lucien.xin@gmail.com>
References: <cover.1667766782.git.lucien.xin@gmail.com>
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

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/tc_act/tc_ct.h        |  1 +
 include/uapi/linux/tc_act/tc_ct.h |  3 ++
 net/sched/act_ct.c                | 89 ++++++++++++++++++++++++++++---
 3 files changed, 85 insertions(+), 8 deletions(-)

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
index 193a460a9d7f..da0b7f665277 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -33,6 +33,7 @@
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <net/netfilter/nf_conntrack_act_ct.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
 #include <uapi/linux/netfilter/nf_nat.h>
 
 static struct workqueue_struct *act_ct_wq;
@@ -655,7 +656,7 @@ struct tc_ct_action_net {
 
 /* Determine whether skb->_nfct is equal to the result of conntrack lookup. */
 static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
-				   u16 zone_id, bool force)
+				   struct tcf_ct_params *p)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
@@ -665,11 +666,19 @@ static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
 		return false;
 	if (!net_eq(net, read_pnet(&ct->ct_net)))
 		goto drop_ct;
-	if (nf_ct_zone(ct)->id != zone_id)
+	if (nf_ct_zone(ct)->id != p->zone)
 		goto drop_ct;
+	if (p->helper) {
+		struct nf_conn_help *help;
+
+		help = nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
+		if (help && rcu_access_pointer(help->helper) != p->helper)
+			goto drop_ct;
+	}
 
 	/* Force conntrack entry direction. */
-	if (force && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
+	if ((p->ct_action & TCA_CT_ACT_FORCE) &&
+	    CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
 		if (nf_ct_is_confirmed(ct))
 			nf_ct_kill(ct);
 
@@ -832,6 +841,13 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 
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
@@ -1026,13 +1042,14 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		      struct tcf_result *res)
 {
 	struct net *net = dev_net(skb->dev);
-	bool cached, commit, clear, force;
 	enum ip_conntrack_info ctinfo;
 	struct tcf_ct *c = to_ct(a);
 	struct nf_conn *tmpl = NULL;
 	struct nf_hook_state state;
+	bool cached, commit, clear;
 	int nh_ofs, err, retval;
 	struct tcf_ct_params *p;
+	bool add_helper = false;
 	bool skip_add = false;
 	bool defrag = false;
 	struct nf_conn *ct;
@@ -1043,7 +1060,6 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	retval = READ_ONCE(c->tcf_action);
 	commit = p->ct_action & TCA_CT_ACT_COMMIT;
 	clear = p->ct_action & TCA_CT_ACT_CLEAR;
-	force = p->ct_action & TCA_CT_ACT_FORCE;
 	tmpl = p->tmpl;
 
 	tcf_lastuse_update(&c->tcf_tm);
@@ -1086,7 +1102,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	 * actually run the packet through conntrack twice unless it's for a
 	 * different zone.
 	 */
-	cached = tcf_ct_skb_nfct_cached(net, skb, p->zone, force);
+	cached = tcf_ct_skb_nfct_cached(net, skb, p);
 	if (!cached) {
 		if (tcf_ct_flow_table_lookup(p, skb, family)) {
 			skip_add = true;
@@ -1119,6 +1135,22 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	if (err != NF_ACCEPT)
 		goto drop;
 
+	if (!nf_ct_is_confirmed(ct) && commit && p->helper && !nfct_help(ct)) {
+		err = __nf_ct_try_assign_helper(ct, p->tmpl, GFP_ATOMIC);
+		if (err)
+			goto drop;
+		add_helper = true;
+		if (p->ct_action & TCA_CT_ACT_NAT && !nfct_seqadj(ct)) {
+			if (!nfct_seqadj_ext_add(ct))
+				goto drop;
+		}
+	}
+
+	if (nf_ct_is_confirmed(ct) ? ((!cached && !skip_add) || add_helper) : commit) {
+		if (nf_ct_helper(skb, ct, ctinfo, family) != NF_ACCEPT)
+			goto drop;
+	}
+
 	if (commit) {
 		tcf_ct_act_set_mark(ct, p->mark, p->mark_mask);
 		tcf_ct_act_set_labels(ct, p->labels, p->labels_mask);
@@ -1167,6 +1199,9 @@ static const struct nla_policy ct_policy[TCA_CT_MAX + 1] = {
 	[TCA_CT_NAT_IPV6_MAX] = NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
 	[TCA_CT_NAT_PORT_MIN] = { .type = NLA_U16 },
 	[TCA_CT_NAT_PORT_MAX] = { .type = NLA_U16 },
+	[TCA_CT_HELPER_NAME] = { .type = NLA_STRING, .len = NF_CT_HELPER_NAME_LEN },
+	[TCA_CT_HELPER_FAMILY] = { .type = NLA_U8 },
+	[TCA_CT_HELPER_PROTO] = { .type = NLA_U8 },
 };
 
 static int tcf_ct_fill_params_nat(struct tcf_ct_params *p,
@@ -1256,8 +1291,9 @@ static int tcf_ct_fill_params(struct net *net,
 {
 	struct tc_ct_action_net *tn = net_generic(net, act_ct_ops.net_id);
 	struct nf_conntrack_zone zone;
+	int err, family, proto, len;
 	struct nf_conn *tmpl;
-	int err;
+	char *name;
 
 	p->zone = NF_CT_DEFAULT_ZONE_ID;
 
@@ -1318,10 +1354,31 @@ static int tcf_ct_fill_params(struct net *net,
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
+		err = nf_ct_add_helper(tmpl, name, family, proto,
+				       p->ct_action & TCA_CT_ACT_NAT, &p->helper);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to add helper");
+			goto err;
+		}
+	}
 
+	__set_bit(IPS_CONFIRMED_BIT, &tmpl->status);
 	return 0;
+err:
+	nf_ct_put(p->tmpl);
+	p->tmpl = NULL;
+	return err;
 }
 
 static int tcf_ct_init(struct net *net, struct nlattr *nla,
@@ -1490,6 +1547,19 @@ static int tcf_ct_dump_nat(struct sk_buff *skb, struct tcf_ct_params *p)
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
@@ -1542,6 +1612,9 @@ static inline int tcf_ct_dump(struct sk_buff *skb, struct tc_action *a,
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

