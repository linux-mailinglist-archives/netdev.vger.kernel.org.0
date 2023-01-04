Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C4F65CF54
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 10:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbjADJRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 04:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239041AbjADJQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 04:16:58 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033A6167C9
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 01:16:56 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v23so35515145pju.3
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 01:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VaHdewa5+m8kklViCOkj51WG6FKLbklkMuKTrxq1d0g=;
        b=kQ6VDNpBLKGHh4N6z5mTQCmSG6vJu41ZO+da/L9VxZibyOFyooY9ijjiaa0AnDhvFt
         lmkDxqNgHHLiQ6D9ICD8qaRaXRnPNW8NHVIFReEiN+eq7dZl1voeApi+kQvBzdtdHP4B
         jMQCw7ZchfLqDGJDjDjtRNTnXJOELEcqYAb83zMGNM5OOglx0blpwDQMkDqQGyJPW62s
         yvVV2VLlMpj7JEfsRwaJyJoaLeq7lA8YCseSYRLyfhONjSWgsKRX7AhqPL0IgvnFnWeD
         2Zqu+oB+L8u9wOx5QiEpcgbElFnZg9xfy3Jimp8GTQpSXLnWOTlXMMXbMtoY0s2jSi0R
         xhIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VaHdewa5+m8kklViCOkj51WG6FKLbklkMuKTrxq1d0g=;
        b=EmEPRKFoUSlc/+j/pCiJScDXDbySnm7GgfAYqdhMjnl1Qj1/JINBIaA7ec4VZJ3tHc
         PFGZjVuSNLIKYwUoFy5VYBCL1CN33j0In3mXoDBoz/vP1HJ/+3jlZM4IAQj04TgJu76i
         PbyFEyUgBP6tFwjFSWHZVap2OCPh3cj5LfaKCY4HXJ16KpBpN4I5NFvWzFllaxWETRh2
         ikXFfN1K+HP2fY438IXck9CIZMnWouzxZG/4cSng2bQMbLjDUcPHj46jaBF72Sf0MXHO
         yGG9yk0AfCcev0Gx+/KoKr57N+8ZEiIJyqo6Jox460eBwuYA3mB4bdyuNfZ39ScxXI2M
         YW7A==
X-Gm-Message-State: AFqh2kpP+6qrfmwR4Df5IZG46dPiY8r2tgdEsKc8HEdXfKcdAFU6UhDU
        WlwwLzeww5PK0aaVANs70BCadFPTMzWzKImU
X-Google-Smtp-Source: AMrXdXvCErdLTGQbinkwhYgK8viyjhEgrO522gGM/3Qoll/6/F0QjmXlQ2LOPXaXL2UrpQafaRdw6g==
X-Received: by 2002:a17:902:b907:b0:192:c426:d83f with SMTP id bf7-20020a170902b90700b00192c426d83fmr11320782plb.64.1672823814528;
        Wed, 04 Jan 2023 01:16:54 -0800 (PST)
Received: from localhost.localdomain ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902e74400b00178b9c997e5sm23769377plf.138.2023.01.04.01.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 01:16:53 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCHv3 net-next] sched: multicast sched extack messages
Date:   Wed,  4 Jan 2023 17:16:08 +0800
Message-Id: <20230104091608.1154183-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
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

In commit 81c7288b170a ("sched: cls: enable verbose logging") Marcelo
made cls could log verbose info for offloading failures, which helps
improving Open vSwitch debuggability when using flower offloading.

It would also be helpful if userspace monitor tools, like "tc monitor",
could log this kind of message, as it doesn't require vswitchd log level
adjusment. Let's add a new function to report the extack message so the
monitor program could receive the failures. e.g.

  # tc monitor
  added chain dev enp3s0f1np1 parent ffff: chain 0
  added filter dev enp3s0f1np1 ingress protocol all pref 49152 flower chain 0 handle 0x1
    ct_state +trk+new
    not_in_hw
          action order 1: gact action drop
           random type none pass val 0
           index 1 ref 1 bind 1

  Warning: mlx5_core: matching on ct_state +new isn't supported.

Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v3: also add this feature for qdisc, class, action, chain notify
v2: use NLMSG_ERROR instad of NLMSG_DONE to report the extack message
---
 include/net/sch_generic.h |  2 ++
 net/sched/act_api.c       | 15 ++++++----
 net/sched/cls_api.c       | 61 ++++++++++++++++++++++++---------------
 net/sched/sch_api.c       | 56 +++++++++++++++++++++--------------
 net/sched/sch_generic.c   | 26 +++++++++++++++++
 5 files changed, 111 insertions(+), 49 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index d5517719af4e..aa396843c099 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1288,4 +1288,6 @@ void mq_change_real_num_tx(struct Qdisc *sch, unsigned int new_real_tx);
 
 int sch_frag_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
 
+int tc_set_nl_ext(struct sk_buff *skb, const struct nlmsghdr *n,
+		  struct netlink_ext_ack *extack, u32 portid);
 #endif
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 5b3c0ac495be..7cecad5fd8f5 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1582,7 +1582,8 @@ int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
 
 static int tca_get_fill(struct sk_buff *skb, struct tc_action *actions[],
 			u32 portid, u32 seq, u16 flags, int event, int bind,
-			int ref)
+			int ref, const struct nlmsghdr *n,
+			struct netlink_ext_ack *extack)
 {
 	struct tcamsg *t;
 	struct nlmsghdr *nlh;
@@ -1607,6 +1608,10 @@ static int tca_get_fill(struct sk_buff *skb, struct tc_action *actions[],
 	nla_nest_end(skb, nest);
 
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
+
+	if ((flags & NLM_F_ACK) && tc_set_nl_ext(skb, n, extack, portid))
+		goto out_nlmsg_trim;
+
 	return skb->len;
 
 out_nlmsg_trim:
@@ -1625,7 +1630,7 @@ tcf_get_notify(struct net *net, u32 portid, struct nlmsghdr *n,
 	if (!skb)
 		return -ENOBUFS;
 	if (tca_get_fill(skb, actions, portid, n->nlmsg_seq, 0, event,
-			 0, 1) <= 0) {
+			 0, 1, NULL, NULL) <= 0) {
 		NL_SET_ERR_MSG(extack, "Failed to fill netlink attributes while adding TC action");
 		kfree_skb(skb);
 		return -EINVAL;
@@ -1799,7 +1804,7 @@ tcf_reoffload_del_notify(struct net *net, struct tc_action *action)
 	if (!skb)
 		return -ENOBUFS;
 
-	if (tca_get_fill(skb, actions, 0, 0, 0, RTM_DELACTION, 0, 1) <= 0) {
+	if (tca_get_fill(skb, actions, 0, 0, 0, RTM_DELACTION, 0, 1, NULL, NULL) <= 0) {
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -1886,7 +1891,7 @@ tcf_del_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 		return -ENOBUFS;
 
 	if (tca_get_fill(skb, actions, portid, n->nlmsg_seq, 0, RTM_DELACTION,
-			 0, 2) <= 0) {
+			 0, 2, n, extack) <= 0) {
 		NL_SET_ERR_MSG(extack, "Failed to fill netlink TC action attributes");
 		kfree_skb(skb);
 		return -EINVAL;
@@ -1965,7 +1970,7 @@ tcf_add_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 		return -ENOBUFS;
 
 	if (tca_get_fill(skb, actions, portid, n->nlmsg_seq, n->nlmsg_flags,
-			 RTM_NEWACTION, 0, 0) <= 0) {
+			 RTM_NEWACTION, 0, 0, n, extack) <= 0) {
 		NL_SET_ERR_MSG(extack, "Failed to fill netlink attributes while adding TC action");
 		kfree_skb(skb);
 		return -EINVAL;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 668130f08903..7619db6ebcae 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -41,6 +41,7 @@
 #include <net/tc_act/tc_gate.h>
 #include <net/flow_offload.h>
 #include <net/tc_wrapper.h>
+#include <net/sch_generic.h>
 
 extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
 
@@ -488,7 +489,8 @@ static struct tcf_chain *tcf_chain_lookup_rcu(const struct tcf_block *block,
 #endif
 
 static int tc_chain_notify(struct tcf_chain *chain, struct sk_buff *oskb,
-			   u32 seq, u16 flags, int event, bool unicast);
+			   u32 seq, u16 flags, int event, bool unicast,
+			   const struct nlmsghdr *n, struct netlink_ext_ack *extack);
 
 static struct tcf_chain *__tcf_chain_get(struct tcf_block *block,
 					 u32 chain_index, bool create,
@@ -521,7 +523,7 @@ static struct tcf_chain *__tcf_chain_get(struct tcf_block *block,
 	 */
 	if (is_first_reference && !by_act)
 		tc_chain_notify(chain, NULL, 0, NLM_F_CREATE | NLM_F_EXCL,
-				RTM_NEWCHAIN, false);
+				RTM_NEWCHAIN, false, NULL, NULL);
 
 	return chain;
 
@@ -1817,7 +1819,9 @@ static int tcf_fill_node(struct net *net, struct sk_buff *skb,
 			 struct tcf_proto *tp, struct tcf_block *block,
 			 struct Qdisc *q, u32 parent, void *fh,
 			 u32 portid, u32 seq, u16 flags, int event,
-			 bool terse_dump, bool rtnl_held)
+			 bool terse_dump, bool rtnl_held,
+			 const struct nlmsghdr *n,
+			 struct netlink_ext_ack *extack)
 {
 	struct tcmsg *tcm;
 	struct nlmsghdr  *nlh;
@@ -1858,6 +1862,10 @@ static int tcf_fill_node(struct net *net, struct sk_buff *skb,
 			goto nla_put_failure;
 	}
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
+
+	if ((flags & NLM_F_ACK) && tc_set_nl_ext(skb, n, extack, portid))
+		goto out_nlmsg_trim;
+
 	return skb->len;
 
 out_nlmsg_trim:
@@ -1871,7 +1879,7 @@ static int tfilter_notify(struct net *net, struct sk_buff *oskb,
 			  struct nlmsghdr *n, struct tcf_proto *tp,
 			  struct tcf_block *block, struct Qdisc *q,
 			  u32 parent, void *fh, int event, bool unicast,
-			  bool rtnl_held)
+			  bool rtnl_held, struct netlink_ext_ack *extack)
 {
 	struct sk_buff *skb;
 	u32 portid = oskb ? NETLINK_CB(oskb).portid : 0;
@@ -1883,7 +1891,7 @@ static int tfilter_notify(struct net *net, struct sk_buff *oskb,
 
 	if (tcf_fill_node(net, skb, tp, block, q, parent, fh, portid,
 			  n->nlmsg_seq, n->nlmsg_flags, event,
-			  false, rtnl_held) <= 0) {
+			  false, rtnl_held, n, extack) <= 0) {
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -1912,7 +1920,7 @@ static int tfilter_del_notify(struct net *net, struct sk_buff *oskb,
 
 	if (tcf_fill_node(net, skb, tp, block, q, parent, fh, portid,
 			  n->nlmsg_seq, n->nlmsg_flags, RTM_DELTFILTER,
-			  false, rtnl_held) <= 0) {
+			  false, rtnl_held, n, extack) <= 0) {
 		NL_SET_ERR_MSG(extack, "Failed to build del event notification");
 		kfree_skb(skb);
 		return -EINVAL;
@@ -1938,14 +1946,15 @@ static int tfilter_del_notify(struct net *net, struct sk_buff *oskb,
 static void tfilter_notify_chain(struct net *net, struct sk_buff *oskb,
 				 struct tcf_block *block, struct Qdisc *q,
 				 u32 parent, struct nlmsghdr *n,
-				 struct tcf_chain *chain, int event)
+				 struct tcf_chain *chain, int event,
+				 struct netlink_ext_ack *extack)
 {
 	struct tcf_proto *tp;
 
 	for (tp = tcf_get_next_proto(chain, NULL);
 	     tp; tp = tcf_get_next_proto(chain, tp))
-		tfilter_notify(net, oskb, n, tp, block,
-			       q, parent, NULL, event, false, true);
+		tfilter_notify(net, oskb, n, tp, block, q, parent, NULL,
+			       event, false, true, extack);
 }
 
 static void tfilter_put(struct tcf_proto *tp, void *fh)
@@ -2156,7 +2165,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 			      flags, extack);
 	if (err == 0) {
 		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
-			       RTM_NEWTFILTER, false, rtnl_held);
+			       RTM_NEWTFILTER, false, rtnl_held, extack);
 		tfilter_put(tp, fh);
 		/* q pointer is NULL for shared blocks */
 		if (q)
@@ -2284,7 +2293,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 
 	if (prio == 0) {
 		tfilter_notify_chain(net, skb, block, q, parent, n,
-				     chain, RTM_DELTFILTER);
+				     chain, RTM_DELTFILTER, extack);
 		tcf_chain_flush(chain, rtnl_held);
 		err = 0;
 		goto errout;
@@ -2308,7 +2317,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 
 		tcf_proto_put(tp, rtnl_held, NULL);
 		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
-			       RTM_DELTFILTER, false, rtnl_held);
+			       RTM_DELTFILTER, false, rtnl_held, extack);
 		err = 0;
 		goto errout;
 	}
@@ -2452,7 +2461,7 @@ static int tc_get_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 		err = -ENOENT;
 	} else {
 		err = tfilter_notify(net, skb, n, tp, block, q, parent,
-				     fh, RTM_NEWTFILTER, true, rtnl_held);
+				     fh, RTM_NEWTFILTER, true, rtnl_held, extack);
 		if (err < 0)
 			NL_SET_ERR_MSG(extack, "Failed to send filter notify message");
 	}
@@ -2490,7 +2499,7 @@ static int tcf_node_dump(struct tcf_proto *tp, void *n, struct tcf_walker *arg)
 	return tcf_fill_node(net, a->skb, tp, a->block, a->q, a->parent,
 			     n, NETLINK_CB(a->cb->skb).portid,
 			     a->cb->nlh->nlmsg_seq, NLM_F_MULTI,
-			     RTM_NEWTFILTER, a->terse_dump, true);
+			     RTM_NEWTFILTER, a->terse_dump, true, NULL, NULL);
 }
 
 static bool tcf_chain_dump(struct tcf_chain *chain, struct Qdisc *q, u32 parent,
@@ -2524,7 +2533,7 @@ static bool tcf_chain_dump(struct tcf_chain *chain, struct Qdisc *q, u32 parent,
 			if (tcf_fill_node(net, skb, tp, block, q, parent, NULL,
 					  NETLINK_CB(cb->skb).portid,
 					  cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					  RTM_NEWTFILTER, false, true) <= 0)
+					  RTM_NEWTFILTER, false, true, NULL, NULL) <= 0)
 				goto errout;
 			cb->args[1] = 1;
 		}
@@ -2667,7 +2676,8 @@ static int tc_chain_fill_node(const struct tcf_proto_ops *tmplt_ops,
 			      void *tmplt_priv, u32 chain_index,
 			      struct net *net, struct sk_buff *skb,
 			      struct tcf_block *block,
-			      u32 portid, u32 seq, u16 flags, int event)
+			      u32 portid, u32 seq, u16 flags, int event,
+			      const struct nlmsghdr *n, struct netlink_ext_ack *extack)
 {
 	unsigned char *b = skb_tail_pointer(skb);
 	const struct tcf_proto_ops *ops;
@@ -2705,6 +2715,10 @@ static int tc_chain_fill_node(const struct tcf_proto_ops *tmplt_ops,
 	}
 
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
+
+	if ((flags & NLM_F_ACK) && tc_set_nl_ext(skb, n, extack, portid))
+		goto out_nlmsg_trim;
+
 	return skb->len;
 
 out_nlmsg_trim:
@@ -2714,7 +2728,8 @@ static int tc_chain_fill_node(const struct tcf_proto_ops *tmplt_ops,
 }
 
 static int tc_chain_notify(struct tcf_chain *chain, struct sk_buff *oskb,
-			   u32 seq, u16 flags, int event, bool unicast)
+			   u32 seq, u16 flags, int event, bool unicast,
+			   const struct nlmsghdr *n, struct netlink_ext_ack *extack)
 {
 	u32 portid = oskb ? NETLINK_CB(oskb).portid : 0;
 	struct tcf_block *block = chain->block;
@@ -2728,7 +2743,7 @@ static int tc_chain_notify(struct tcf_chain *chain, struct sk_buff *oskb,
 
 	if (tc_chain_fill_node(chain->tmplt_ops, chain->tmplt_priv,
 			       chain->index, net, skb, block, portid,
-			       seq, flags, event) <= 0) {
+			       seq, flags, event, n, extack) <= 0) {
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -2756,7 +2771,7 @@ static int tc_chain_notify_delete(const struct tcf_proto_ops *tmplt_ops,
 		return -ENOBUFS;
 
 	if (tc_chain_fill_node(tmplt_ops, tmplt_priv, chain_index, net, skb,
-			       block, portid, seq, flags, RTM_DELCHAIN) <= 0) {
+			       block, portid, seq, flags, RTM_DELCHAIN, NULL, NULL) <= 0) {
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -2908,11 +2923,11 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 		}
 
 		tc_chain_notify(chain, NULL, 0, NLM_F_CREATE | NLM_F_EXCL,
-				RTM_NEWCHAIN, false);
+				RTM_NEWCHAIN, false, n, extack);
 		break;
 	case RTM_DELCHAIN:
 		tfilter_notify_chain(net, skb, block, q, parent, n,
-				     chain, RTM_DELTFILTER);
+				     chain, RTM_DELTFILTER, extack);
 		/* Flush the chain first as the user requested chain removal. */
 		tcf_chain_flush(chain, true);
 		/* In case the chain was successfully deleted, put a reference
@@ -2922,7 +2937,7 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 		break;
 	case RTM_GETCHAIN:
 		err = tc_chain_notify(chain, skb, n->nlmsg_seq,
-				      n->nlmsg_flags, n->nlmsg_type, true);
+				      n->nlmsg_flags, n->nlmsg_type, true, n, extack);
 		if (err < 0)
 			NL_SET_ERR_MSG(extack, "Failed to send chain notify message");
 		break;
@@ -3022,7 +3037,7 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
 					 chain->index, net, skb, block,
 					 NETLINK_CB(cb->skb).portid,
 					 cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					 RTM_NEWCHAIN);
+					 RTM_NEWCHAIN, NULL, NULL);
 		if (err <= 0)
 			break;
 		index++;
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 2317db02c764..d2499d744b61 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -32,6 +32,7 @@
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 #include <net/tc_wrapper.h>
+#include <net/sch_generic.h>
 
 #include <trace/events/qdisc.h>
 
@@ -902,7 +903,8 @@ static void qdisc_offload_graft_root(struct net_device *dev,
 }
 
 static int tc_fill_qdisc(struct sk_buff *skb, struct Qdisc *q, u32 clid,
-			 u32 portid, u32 seq, u16 flags, int event)
+			 u32 portid, u32 seq, u16 flags, int event,
+			 const struct nlmsghdr *n, struct netlink_ext_ack *extack)
 {
 	struct gnet_stats_basic_sync __percpu *cpu_bstats = NULL;
 	struct gnet_stats_queue __percpu *cpu_qstats = NULL;
@@ -971,6 +973,10 @@ static int tc_fill_qdisc(struct sk_buff *skb, struct Qdisc *q, u32 clid,
 		goto nla_put_failure;
 
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
+
+	if ((flags & NLM_F_ACK) && tc_set_nl_ext(skb, n, extack, portid))
+		goto out_nlmsg_trim;
+
 	return skb->len;
 
 out_nlmsg_trim:
@@ -991,7 +997,8 @@ static bool tc_qdisc_dump_ignore(struct Qdisc *q, bool dump_invisible)
 
 static int qdisc_notify(struct net *net, struct sk_buff *oskb,
 			struct nlmsghdr *n, u32 clid,
-			struct Qdisc *old, struct Qdisc *new)
+			struct Qdisc *old, struct Qdisc *new,
+			struct netlink_ext_ack *extack)
 {
 	struct sk_buff *skb;
 	u32 portid = oskb ? NETLINK_CB(oskb).portid : 0;
@@ -1002,12 +1009,13 @@ static int qdisc_notify(struct net *net, struct sk_buff *oskb,
 
 	if (old && !tc_qdisc_dump_ignore(old, false)) {
 		if (tc_fill_qdisc(skb, old, clid, portid, n->nlmsg_seq,
-				  0, RTM_DELQDISC) < 0)
+				  0, RTM_DELQDISC, n, extack) < 0)
 			goto err_out;
 	}
 	if (new && !tc_qdisc_dump_ignore(new, false)) {
 		if (tc_fill_qdisc(skb, new, clid, portid, n->nlmsg_seq,
-				  old ? NLM_F_REPLACE : 0, RTM_NEWQDISC) < 0)
+				  old ? NLM_F_REPLACE : 0, RTM_NEWQDISC,
+				  n, extack) < 0)
 			goto err_out;
 	}
 
@@ -1022,10 +1030,11 @@ static int qdisc_notify(struct net *net, struct sk_buff *oskb,
 
 static void notify_and_destroy(struct net *net, struct sk_buff *skb,
 			       struct nlmsghdr *n, u32 clid,
-			       struct Qdisc *old, struct Qdisc *new)
+			       struct Qdisc *old, struct Qdisc *new,
+			       struct netlink_ext_ack *extack)
 {
 	if (new || old)
-		qdisc_notify(net, skb, n, clid, old, new);
+		qdisc_notify(net, skb, n, clid, old, new, extack);
 
 	if (old)
 		qdisc_put(old);
@@ -1105,12 +1114,12 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 				qdisc_refcount_inc(new);
 			rcu_assign_pointer(dev->qdisc, new ? : &noop_qdisc);
 
-			notify_and_destroy(net, skb, n, classid, old, new);
+			notify_and_destroy(net, skb, n, classid, old, new, extack);
 
 			if (new && new->ops->attach)
 				new->ops->attach(new);
 		} else {
-			notify_and_destroy(net, skb, n, classid, old, new);
+			notify_and_destroy(net, skb, n, classid, old, new, extack);
 		}
 
 		if (dev->flags & IFF_UP)
@@ -1136,7 +1145,7 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 		err = cops->graft(parent, cl, new, &old, extack);
 		if (err)
 			return err;
-		notify_and_destroy(net, skb, n, classid, old, new);
+		notify_and_destroy(net, skb, n, classid, old, new, extack);
 	}
 	return 0;
 }
@@ -1504,7 +1513,7 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 		if (err != 0)
 			return err;
 	} else {
-		qdisc_notify(net, skb, n, clid, NULL, q);
+		qdisc_notify(net, skb, n, clid, NULL, q, extack);
 	}
 	return 0;
 }
@@ -1643,7 +1652,7 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 	}
 	err = qdisc_change(q, tca, extack);
 	if (err == 0)
-		qdisc_notify(net, skb, n, clid, NULL, q);
+		qdisc_notify(net, skb, n, clid, NULL, q, extack);
 	return err;
 
 create_n_graft:
@@ -1710,7 +1719,7 @@ static int tc_dump_qdisc_root(struct Qdisc *root, struct sk_buff *skb,
 		if (!tc_qdisc_dump_ignore(q, dump_invisible) &&
 		    tc_fill_qdisc(skb, q, q->parent, NETLINK_CB(cb->skb).portid,
 				  cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				  RTM_NEWQDISC) <= 0)
+				  RTM_NEWQDISC, NULL, NULL) <= 0)
 			goto done;
 		q_idx++;
 	}
@@ -1732,7 +1741,7 @@ static int tc_dump_qdisc_root(struct Qdisc *root, struct sk_buff *skb,
 		if (!tc_qdisc_dump_ignore(q, dump_invisible) &&
 		    tc_fill_qdisc(skb, q, q->parent, NETLINK_CB(cb->skb).portid,
 				  cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				  RTM_NEWQDISC) <= 0)
+				  RTM_NEWQDISC, NULL, NULL) <= 0)
 			goto done;
 		q_idx++;
 	}
@@ -1805,8 +1814,9 @@ static int tc_dump_qdisc(struct sk_buff *skb, struct netlink_callback *cb)
  ************************************************/
 
 static int tc_fill_tclass(struct sk_buff *skb, struct Qdisc *q,
-			  unsigned long cl,
-			  u32 portid, u32 seq, u16 flags, int event)
+			  unsigned long cl, u32 portid, u32 seq, u16 flags,
+			  int event, const struct nlmsghdr *n,
+			  struct netlink_ext_ack *extack)
 {
 	struct tcmsg *tcm;
 	struct nlmsghdr  *nlh;
@@ -1842,6 +1852,10 @@ static int tc_fill_tclass(struct sk_buff *skb, struct Qdisc *q,
 		goto nla_put_failure;
 
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
+
+	if ((flags & NLM_F_ACK) && tc_set_nl_ext(skb, n, extack, portid))
+		goto out_nlmsg_trim;
+
 	return skb->len;
 
 out_nlmsg_trim:
@@ -1852,7 +1866,7 @@ static int tc_fill_tclass(struct sk_buff *skb, struct Qdisc *q,
 
 static int tclass_notify(struct net *net, struct sk_buff *oskb,
 			 struct nlmsghdr *n, struct Qdisc *q,
-			 unsigned long cl, int event)
+			 unsigned long cl, int event, struct netlink_ext_ack *extack)
 {
 	struct sk_buff *skb;
 	u32 portid = oskb ? NETLINK_CB(oskb).portid : 0;
@@ -1861,7 +1875,7 @@ static int tclass_notify(struct net *net, struct sk_buff *oskb,
 	if (!skb)
 		return -ENOBUFS;
 
-	if (tc_fill_tclass(skb, q, cl, portid, n->nlmsg_seq, 0, event) < 0) {
+	if (tc_fill_tclass(skb, q, cl, portid, n->nlmsg_seq, 0, event, n, extack) < 0) {
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -1888,7 +1902,7 @@ static int tclass_del_notify(struct net *net,
 		return -ENOBUFS;
 
 	if (tc_fill_tclass(skb, q, cl, portid, n->nlmsg_seq, 0,
-			   RTM_DELTCLASS) < 0) {
+			   RTM_DELTCLASS, n, extack) < 0) {
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -2095,7 +2109,7 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
 			tc_bind_tclass(q, portid, clid, 0);
 			goto out;
 		case RTM_GETTCLASS:
-			err = tclass_notify(net, skb, n, q, cl, RTM_NEWTCLASS);
+			err = tclass_notify(net, skb, n, q, cl, RTM_NEWTCLASS, extack);
 			goto out;
 		default:
 			err = -EINVAL;
@@ -2113,7 +2127,7 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
 	if (cops->change)
 		err = cops->change(q, clid, portid, tca, &new_cl, extack);
 	if (err == 0) {
-		tclass_notify(net, skb, n, q, new_cl, RTM_NEWTCLASS);
+		tclass_notify(net, skb, n, q, new_cl, RTM_NEWTCLASS, extack);
 		/* We just create a new class, need to do reverse binding. */
 		if (cl != new_cl)
 			tc_bind_tclass(q, portid, clid, new_cl);
@@ -2135,7 +2149,7 @@ static int qdisc_class_dump(struct Qdisc *q, unsigned long cl,
 
 	return tc_fill_tclass(a->skb, q, cl, NETLINK_CB(a->cb->skb).portid,
 			      a->cb->nlh->nlmsg_seq, NLM_F_MULTI,
-			      RTM_NEWTCLASS);
+			      RTM_NEWTCLASS, NULL, NULL);
 }
 
 static int tc_dump_tclass_qdisc(struct Qdisc *q, struct sk_buff *skb,
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index a9aadc4e6858..d73306a75e9f 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1594,3 +1594,29 @@ void mini_qdisc_pair_init(struct mini_Qdisc_pair *miniqp, struct Qdisc *qdisc,
 	miniqp->p_miniq = p_miniq;
 }
 EXPORT_SYMBOL(mini_qdisc_pair_init);
+
+int tc_set_nl_ext(struct sk_buff *skb, const struct nlmsghdr *n,
+		  struct netlink_ext_ack *extack, u32 portid)
+{
+	struct nlmsgerr *errmsg;
+	struct nlmsghdr *nlh;
+
+	if (!n || !extack || !extack->_msg)
+		return 0;
+
+	nlh = nlmsg_put(skb, portid, n->nlmsg_seq, NLMSG_ERROR, sizeof(*errmsg),
+			NLM_F_ACK_TLVS | NLM_F_CAPPED);
+	if (!nlh)
+		return -1;
+
+	errmsg = (struct nlmsgerr *)nlmsg_data(nlh);
+	errmsg->error = 0;
+	errmsg->msg = *n;
+
+	if (nla_put_string(skb, NLMSGERR_ATTR_MSG, extack->_msg))
+		return -1;
+
+	nlmsg_end(skb, nlh);
+
+	return 0;
+}
-- 
2.38.1

