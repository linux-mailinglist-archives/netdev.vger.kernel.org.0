Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564B1668A59
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 04:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbjAMDox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 22:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbjAMDot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 22:44:49 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818A95792D
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 19:44:47 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b9-20020a17090a7ac900b00226ef160dcaso21397525pjl.2
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 19:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VXS3yC4iOlMffeggjw2b2MPmDoYKlfjpbClmIiWgnTA=;
        b=JWqBDJUMGDIJBjJ/uiBgwKzaVL8xrU/fPmpOIMEVbH5AIh186Vu24CbYQrq+ErEUUb
         2OMdHdRbWO5lLb4e3kchtsi2544Dv5y8croAMgH+il8UR/obe4C2FAlGFIm1cbpjRPxt
         7/u/kG2ME8PSCyX1ncKKEFQIJlGYbg6g5K47aUXTN4odY7KBWAF+o3P8AYM2mcoHUkFY
         PuT2gTyIt/XzyBz/sb3lfwOqTMP5GDKTCA7FZYxCF0moAakeUSTAbRbMfVDfrc8q+UIC
         DwmpUwn0HbITww87iCVDA00MiYYWOml1UgX49yCP6cx2X2sG0u27BdrRSufXBB5DGtiV
         rbqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VXS3yC4iOlMffeggjw2b2MPmDoYKlfjpbClmIiWgnTA=;
        b=Hh0nX5LmyEHA4X1Y5OOt39EnRezruFvd4Szq1DHJp+iqeTkuaIj4nTLX9v4NRunzv9
         FHvT0anKJmuNiZehTYhbrPdeGOf1XHR2nADGs53RTyCz4MPthtwj24GbSSea7LDWt8yj
         RvpqqXo2pb2wkntH76yl3mCNiTuXZR93MkbCtsuT3W6/4cHFtF9FyF1mjp8p+XkhK2Md
         CQLulkB8EovsFgmIMCnz4dhHpmsucaK7n9CvjHOWeRk+7A4SLCtYJWqaCub8r2+dzi5C
         z+mS1E8BD5EfPoi5RivHQytnYTrOaazyHIColw1QFIxsTDWjQuG1XTmeRHV9A770DB/u
         yK0Q==
X-Gm-Message-State: AFqh2kpPl+bOyLIwc8C6ln8FEUJfHtUfhD7sRwI1isF8v7ZCUPWZZfte
        +tDc6RJcPM1mWfhWYxooHjYbufELg8+6VBDP
X-Google-Smtp-Source: AMrXdXsvIp2GzVrFnARsiw4leF18k++I91NS9PJtS4swY3rhdpH7R8KXsG0Wnn1fUfZJewbhUNWVWg==
X-Received: by 2002:a17:902:eed3:b0:194:4503:947 with SMTP id h19-20020a170902eed300b0019445030947mr11474809plb.37.1673581486324;
        Thu, 12 Jan 2023 19:44:46 -0800 (PST)
Received: from localhost.localdomain ([2409:8a02:781c:2330:c2cc:a0ba:7da8:3e4b])
        by smtp.gmail.com with ESMTPSA id t13-20020a1709027fcd00b00176b84eb29asm12872010plb.301.2023.01.12.19.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 19:44:44 -0800 (PST)
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
Subject: [PATCHv4 net-next] sched: add new attr TCA_EXT_WARN_MSG to report tc extact message
Date:   Fri, 13 Jan 2023 11:43:53 +0800
Message-Id: <20230113034353.2766735-1-liuhangbin@gmail.com>
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

We will report extack message if there is an error via netlink_ack(). But
if the rule is not to be exclusively executed by the hardware, extack is not
passed along and offloading failures don't get logged.

In commit 81c7288b170a ("sched: cls: enable verbose logging") Marcelo
made cls could log verbose info for offloading failures, which helps
improving Open vSwitch debuggability when using flower offloading.

It would also be helpful if userspace monitor tools, like "tc monitor",
could log this kind of message, as it doesn't require vswitchd log level
adjusment. Let's add a new tc attributes to report the extack message so
the monitor program could receive the failures. e.g.

  # tc monitor
  added chain dev enp3s0f1np1 parent ffff: chain 0
  added filter dev enp3s0f1np1 ingress protocol all pref 49152 flower chain 0 handle 0x1
    ct_state +trk+new
    not_in_hw
          action order 1: gact action drop
           random type none pass val 0
           index 1 ref 1 bind 1

  Warning: mlx5_core: matching on ct_state +new isn't supported.

In this patch I only report the extack message on add/del operations.
It doesn't look like we need to report the extack message on get/dump
operations.

Note this message not only reporte to multicast groups, it could also
be reported unicast, which may affect the current usersapce tool's behaivor.

Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v4: use specific tc attributes to wrap the warn message
v3: also add this feature for qdisc, class, action, chain notify
v2: use NLMSG_ERROR instad of NLMSG_DONE to report the extack message
---
 include/uapi/linux/rtnetlink.h |  1 +
 net/sched/act_api.c            | 15 +++++---
 net/sched/cls_api.c            | 62 +++++++++++++++++++++-------------
 net/sched/sch_api.c            | 55 ++++++++++++++++++------------
 4 files changed, 84 insertions(+), 49 deletions(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index eb2747d58a81..25a0af57dd5e 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -635,6 +635,7 @@ enum {
 	TCA_INGRESS_BLOCK,
 	TCA_EGRESS_BLOCK,
 	TCA_DUMP_FLAGS,
+	TCA_EXT_WARN_MSG,
 	__TCA_MAX
 };
 
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 5b3c0ac495be..cd09ef49df22 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1582,7 +1582,7 @@ int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
 
 static int tca_get_fill(struct sk_buff *skb, struct tc_action *actions[],
 			u32 portid, u32 seq, u16 flags, int event, int bind,
-			int ref)
+			int ref, struct netlink_ext_ack *extack)
 {
 	struct tcamsg *t;
 	struct nlmsghdr *nlh;
@@ -1606,7 +1606,12 @@ static int tca_get_fill(struct sk_buff *skb, struct tc_action *actions[],
 
 	nla_nest_end(skb, nest);
 
+	if (extack && extack->_msg &&
+	    nla_put_string(skb, TCA_EXT_WARN_MSG, extack->_msg))
+		goto out_nlmsg_trim;
+
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
+
 	return skb->len;
 
 out_nlmsg_trim:
@@ -1625,7 +1630,7 @@ tcf_get_notify(struct net *net, u32 portid, struct nlmsghdr *n,
 	if (!skb)
 		return -ENOBUFS;
 	if (tca_get_fill(skb, actions, portid, n->nlmsg_seq, 0, event,
-			 0, 1) <= 0) {
+			 0, 1, NULL) <= 0) {
 		NL_SET_ERR_MSG(extack, "Failed to fill netlink attributes while adding TC action");
 		kfree_skb(skb);
 		return -EINVAL;
@@ -1799,7 +1804,7 @@ tcf_reoffload_del_notify(struct net *net, struct tc_action *action)
 	if (!skb)
 		return -ENOBUFS;
 
-	if (tca_get_fill(skb, actions, 0, 0, 0, RTM_DELACTION, 0, 1) <= 0) {
+	if (tca_get_fill(skb, actions, 0, 0, 0, RTM_DELACTION, 0, 1, NULL) <= 0) {
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -1886,7 +1891,7 @@ tcf_del_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 		return -ENOBUFS;
 
 	if (tca_get_fill(skb, actions, portid, n->nlmsg_seq, 0, RTM_DELACTION,
-			 0, 2) <= 0) {
+			 0, 2, extack) <= 0) {
 		NL_SET_ERR_MSG(extack, "Failed to fill netlink TC action attributes");
 		kfree_skb(skb);
 		return -EINVAL;
@@ -1965,7 +1970,7 @@ tcf_add_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 		return -ENOBUFS;
 
 	if (tca_get_fill(skb, actions, portid, n->nlmsg_seq, n->nlmsg_flags,
-			 RTM_NEWACTION, 0, 0) <= 0) {
+			 RTM_NEWACTION, 0, 0, extack) <= 0) {
 		NL_SET_ERR_MSG(extack, "Failed to fill netlink attributes while adding TC action");
 		kfree_skb(skb);
 		return -EINVAL;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 668130f08903..5b4a95e8a1ee 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -488,7 +488,8 @@ static struct tcf_chain *tcf_chain_lookup_rcu(const struct tcf_block *block,
 #endif
 
 static int tc_chain_notify(struct tcf_chain *chain, struct sk_buff *oskb,
-			   u32 seq, u16 flags, int event, bool unicast);
+			   u32 seq, u16 flags, int event, bool unicast,
+			   struct netlink_ext_ack *extack);
 
 static struct tcf_chain *__tcf_chain_get(struct tcf_block *block,
 					 u32 chain_index, bool create,
@@ -521,7 +522,7 @@ static struct tcf_chain *__tcf_chain_get(struct tcf_block *block,
 	 */
 	if (is_first_reference && !by_act)
 		tc_chain_notify(chain, NULL, 0, NLM_F_CREATE | NLM_F_EXCL,
-				RTM_NEWCHAIN, false);
+				RTM_NEWCHAIN, false, NULL);
 
 	return chain;
 
@@ -1817,7 +1818,8 @@ static int tcf_fill_node(struct net *net, struct sk_buff *skb,
 			 struct tcf_proto *tp, struct tcf_block *block,
 			 struct Qdisc *q, u32 parent, void *fh,
 			 u32 portid, u32 seq, u16 flags, int event,
-			 bool terse_dump, bool rtnl_held)
+			 bool terse_dump, bool rtnl_held,
+			 struct netlink_ext_ack *extack)
 {
 	struct tcmsg *tcm;
 	struct nlmsghdr  *nlh;
@@ -1857,7 +1859,13 @@ static int tcf_fill_node(struct net *net, struct sk_buff *skb,
 		    tp->ops->dump(net, tp, fh, skb, tcm, rtnl_held) < 0)
 			goto nla_put_failure;
 	}
+
+	if (extack && extack->_msg &&
+	    nla_put_string(skb, TCA_EXT_WARN_MSG, extack->_msg))
+		goto nla_put_failure;
+
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
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
+			  false, rtnl_held, extack) <= 0) {
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -1912,7 +1920,7 @@ static int tfilter_del_notify(struct net *net, struct sk_buff *oskb,
 
 	if (tcf_fill_node(net, skb, tp, block, q, parent, fh, portid,
 			  n->nlmsg_seq, n->nlmsg_flags, RTM_DELTFILTER,
-			  false, rtnl_held) <= 0) {
+			  false, rtnl_held, extack) <= 0) {
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
+				     fh, RTM_NEWTFILTER, true, rtnl_held, NULL);
 		if (err < 0)
 			NL_SET_ERR_MSG(extack, "Failed to send filter notify message");
 	}
@@ -2490,7 +2499,7 @@ static int tcf_node_dump(struct tcf_proto *tp, void *n, struct tcf_walker *arg)
 	return tcf_fill_node(net, a->skb, tp, a->block, a->q, a->parent,
 			     n, NETLINK_CB(a->cb->skb).portid,
 			     a->cb->nlh->nlmsg_seq, NLM_F_MULTI,
-			     RTM_NEWTFILTER, a->terse_dump, true);
+			     RTM_NEWTFILTER, a->terse_dump, true, NULL);
 }
 
 static bool tcf_chain_dump(struct tcf_chain *chain, struct Qdisc *q, u32 parent,
@@ -2524,7 +2533,7 @@ static bool tcf_chain_dump(struct tcf_chain *chain, struct Qdisc *q, u32 parent,
 			if (tcf_fill_node(net, skb, tp, block, q, parent, NULL,
 					  NETLINK_CB(cb->skb).portid,
 					  cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					  RTM_NEWTFILTER, false, true) <= 0)
+					  RTM_NEWTFILTER, false, true, NULL) <= 0)
 				goto errout;
 			cb->args[1] = 1;
 		}
@@ -2667,7 +2676,8 @@ static int tc_chain_fill_node(const struct tcf_proto_ops *tmplt_ops,
 			      void *tmplt_priv, u32 chain_index,
 			      struct net *net, struct sk_buff *skb,
 			      struct tcf_block *block,
-			      u32 portid, u32 seq, u16 flags, int event)
+			      u32 portid, u32 seq, u16 flags, int event,
+			      struct netlink_ext_ack *extack)
 {
 	unsigned char *b = skb_tail_pointer(skb);
 	const struct tcf_proto_ops *ops;
@@ -2704,7 +2714,12 @@ static int tc_chain_fill_node(const struct tcf_proto_ops *tmplt_ops,
 			goto nla_put_failure;
 	}
 
+	if (extack && extack->_msg &&
+	    nla_put_string(skb, TCA_EXT_WARN_MSG, extack->_msg))
+		goto out_nlmsg_trim;
+
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
+
 	return skb->len;
 
 out_nlmsg_trim:
@@ -2714,7 +2729,8 @@ static int tc_chain_fill_node(const struct tcf_proto_ops *tmplt_ops,
 }
 
 static int tc_chain_notify(struct tcf_chain *chain, struct sk_buff *oskb,
-			   u32 seq, u16 flags, int event, bool unicast)
+			   u32 seq, u16 flags, int event, bool unicast,
+			   struct netlink_ext_ack *extack)
 {
 	u32 portid = oskb ? NETLINK_CB(oskb).portid : 0;
 	struct tcf_block *block = chain->block;
@@ -2728,7 +2744,7 @@ static int tc_chain_notify(struct tcf_chain *chain, struct sk_buff *oskb,
 
 	if (tc_chain_fill_node(chain->tmplt_ops, chain->tmplt_priv,
 			       chain->index, net, skb, block, portid,
-			       seq, flags, event) <= 0) {
+			       seq, flags, event, extack) <= 0) {
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -2756,7 +2772,7 @@ static int tc_chain_notify_delete(const struct tcf_proto_ops *tmplt_ops,
 		return -ENOBUFS;
 
 	if (tc_chain_fill_node(tmplt_ops, tmplt_priv, chain_index, net, skb,
-			       block, portid, seq, flags, RTM_DELCHAIN) <= 0) {
+			       block, portid, seq, flags, RTM_DELCHAIN, NULL) <= 0) {
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -2908,11 +2924,11 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 		}
 
 		tc_chain_notify(chain, NULL, 0, NLM_F_CREATE | NLM_F_EXCL,
-				RTM_NEWCHAIN, false);
+				RTM_NEWCHAIN, false, extack);
 		break;
 	case RTM_DELCHAIN:
 		tfilter_notify_chain(net, skb, block, q, parent, n,
-				     chain, RTM_DELTFILTER);
+				     chain, RTM_DELTFILTER, extack);
 		/* Flush the chain first as the user requested chain removal. */
 		tcf_chain_flush(chain, true);
 		/* In case the chain was successfully deleted, put a reference
@@ -2922,7 +2938,7 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 		break;
 	case RTM_GETCHAIN:
 		err = tc_chain_notify(chain, skb, n->nlmsg_seq,
-				      n->nlmsg_flags, n->nlmsg_type, true);
+				      n->nlmsg_flags, n->nlmsg_type, true, extack);
 		if (err < 0)
 			NL_SET_ERR_MSG(extack, "Failed to send chain notify message");
 		break;
@@ -3022,7 +3038,7 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
 					 chain->index, net, skb, block,
 					 NETLINK_CB(cb->skb).portid,
 					 cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					 RTM_NEWCHAIN);
+					 RTM_NEWCHAIN, NULL);
 		if (err <= 0)
 			break;
 		index++;
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 2317db02c764..88f7d528e3d0 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -902,7 +902,8 @@ static void qdisc_offload_graft_root(struct net_device *dev,
 }
 
 static int tc_fill_qdisc(struct sk_buff *skb, struct Qdisc *q, u32 clid,
-			 u32 portid, u32 seq, u16 flags, int event)
+			 u32 portid, u32 seq, u16 flags, int event,
+			 struct netlink_ext_ack *extack)
 {
 	struct gnet_stats_basic_sync __percpu *cpu_bstats = NULL;
 	struct gnet_stats_queue __percpu *cpu_qstats = NULL;
@@ -970,7 +971,12 @@ static int tc_fill_qdisc(struct sk_buff *skb, struct Qdisc *q, u32 clid,
 	if (gnet_stats_finish_copy(&d) < 0)
 		goto nla_put_failure;
 
+	if (extack && extack->_msg &&
+	    nla_put_string(skb, TCA_EXT_WARN_MSG, extack->_msg))
+		goto out_nlmsg_trim;
+
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
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
@@ -1002,12 +1009,12 @@ static int qdisc_notify(struct net *net, struct sk_buff *oskb,
 
 	if (old && !tc_qdisc_dump_ignore(old, false)) {
 		if (tc_fill_qdisc(skb, old, clid, portid, n->nlmsg_seq,
-				  0, RTM_DELQDISC) < 0)
+				  0, RTM_DELQDISC, extack) < 0)
 			goto err_out;
 	}
 	if (new && !tc_qdisc_dump_ignore(new, false)) {
 		if (tc_fill_qdisc(skb, new, clid, portid, n->nlmsg_seq,
-				  old ? NLM_F_REPLACE : 0, RTM_NEWQDISC) < 0)
+				  old ? NLM_F_REPLACE : 0, RTM_NEWQDISC, extack) < 0)
 			goto err_out;
 	}
 
@@ -1022,10 +1029,11 @@ static int qdisc_notify(struct net *net, struct sk_buff *oskb,
 
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
@@ -1105,12 +1113,12 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
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
@@ -1136,7 +1144,7 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 		err = cops->graft(parent, cl, new, &old, extack);
 		if (err)
 			return err;
-		notify_and_destroy(net, skb, n, classid, old, new);
+		notify_and_destroy(net, skb, n, classid, old, new, extack);
 	}
 	return 0;
 }
@@ -1504,7 +1512,7 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 		if (err != 0)
 			return err;
 	} else {
-		qdisc_notify(net, skb, n, clid, NULL, q);
+		qdisc_notify(net, skb, n, clid, NULL, q, NULL);
 	}
 	return 0;
 }
@@ -1643,7 +1651,7 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 	}
 	err = qdisc_change(q, tca, extack);
 	if (err == 0)
-		qdisc_notify(net, skb, n, clid, NULL, q);
+		qdisc_notify(net, skb, n, clid, NULL, q, extack);
 	return err;
 
 create_n_graft:
@@ -1710,7 +1718,7 @@ static int tc_dump_qdisc_root(struct Qdisc *root, struct sk_buff *skb,
 		if (!tc_qdisc_dump_ignore(q, dump_invisible) &&
 		    tc_fill_qdisc(skb, q, q->parent, NETLINK_CB(cb->skb).portid,
 				  cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				  RTM_NEWQDISC) <= 0)
+				  RTM_NEWQDISC, NULL) <= 0)
 			goto done;
 		q_idx++;
 	}
@@ -1732,7 +1740,7 @@ static int tc_dump_qdisc_root(struct Qdisc *root, struct sk_buff *skb,
 		if (!tc_qdisc_dump_ignore(q, dump_invisible) &&
 		    tc_fill_qdisc(skb, q, q->parent, NETLINK_CB(cb->skb).portid,
 				  cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				  RTM_NEWQDISC) <= 0)
+				  RTM_NEWQDISC, NULL) <= 0)
 			goto done;
 		q_idx++;
 	}
@@ -1805,8 +1813,8 @@ static int tc_dump_qdisc(struct sk_buff *skb, struct netlink_callback *cb)
  ************************************************/
 
 static int tc_fill_tclass(struct sk_buff *skb, struct Qdisc *q,
-			  unsigned long cl,
-			  u32 portid, u32 seq, u16 flags, int event)
+			  unsigned long cl, u32 portid, u32 seq, u16 flags,
+			  int event, struct netlink_ext_ack *extack)
 {
 	struct tcmsg *tcm;
 	struct nlmsghdr  *nlh;
@@ -1841,7 +1849,12 @@ static int tc_fill_tclass(struct sk_buff *skb, struct Qdisc *q,
 	if (gnet_stats_finish_copy(&d) < 0)
 		goto nla_put_failure;
 
+	if (extack && extack->_msg &&
+	    nla_put_string(skb, TCA_EXT_WARN_MSG, extack->_msg))
+		goto out_nlmsg_trim;
+
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
+
 	return skb->len;
 
 out_nlmsg_trim:
@@ -1852,7 +1865,7 @@ static int tc_fill_tclass(struct sk_buff *skb, struct Qdisc *q,
 
 static int tclass_notify(struct net *net, struct sk_buff *oskb,
 			 struct nlmsghdr *n, struct Qdisc *q,
-			 unsigned long cl, int event)
+			 unsigned long cl, int event, struct netlink_ext_ack *extack)
 {
 	struct sk_buff *skb;
 	u32 portid = oskb ? NETLINK_CB(oskb).portid : 0;
@@ -1861,7 +1874,7 @@ static int tclass_notify(struct net *net, struct sk_buff *oskb,
 	if (!skb)
 		return -ENOBUFS;
 
-	if (tc_fill_tclass(skb, q, cl, portid, n->nlmsg_seq, 0, event) < 0) {
+	if (tc_fill_tclass(skb, q, cl, portid, n->nlmsg_seq, 0, event, extack) < 0) {
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -1888,7 +1901,7 @@ static int tclass_del_notify(struct net *net,
 		return -ENOBUFS;
 
 	if (tc_fill_tclass(skb, q, cl, portid, n->nlmsg_seq, 0,
-			   RTM_DELTCLASS) < 0) {
+			   RTM_DELTCLASS, extack) < 0) {
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -2095,7 +2108,7 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
 			tc_bind_tclass(q, portid, clid, 0);
 			goto out;
 		case RTM_GETTCLASS:
-			err = tclass_notify(net, skb, n, q, cl, RTM_NEWTCLASS);
+			err = tclass_notify(net, skb, n, q, cl, RTM_NEWTCLASS, extack);
 			goto out;
 		default:
 			err = -EINVAL;
@@ -2113,7 +2126,7 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
 	if (cops->change)
 		err = cops->change(q, clid, portid, tca, &new_cl, extack);
 	if (err == 0) {
-		tclass_notify(net, skb, n, q, new_cl, RTM_NEWTCLASS);
+		tclass_notify(net, skb, n, q, new_cl, RTM_NEWTCLASS, extack);
 		/* We just create a new class, need to do reverse binding. */
 		if (cl != new_cl)
 			tc_bind_tclass(q, portid, clid, new_cl);
@@ -2135,7 +2148,7 @@ static int qdisc_class_dump(struct Qdisc *q, unsigned long cl,
 
 	return tc_fill_tclass(a->skb, q, cl, NETLINK_CB(a->cb->skb).portid,
 			      a->cb->nlh->nlmsg_seq, NLM_F_MULTI,
-			      RTM_NEWTCLASS);
+			      RTM_NEWTCLASS, NULL);
 }
 
 static int tc_dump_tclass_qdisc(struct Qdisc *q, struct sk_buff *skb,
-- 
2.38.1

