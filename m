Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F6C652EB9
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 10:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbiLUJj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 04:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbiLUJj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 04:39:58 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984E7183BA
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 01:39:56 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id k88-20020a17090a4ce100b00219d0b857bcso1564616pjh.1
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 01:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I+axwS0NjFSJ68C4qJyo4nPLinkVsy7+4TDR0W/9E14=;
        b=nvqwNsAOGAOROPDAHHNOLe1IZMcMa/61mdnTUdeBGa0KaPDjyJh/gOrca+Y5D5Al0j
         pIr8m660x8WEjBbieYblsbwmWiv9U9nOswe3yUBoUTd4pGjQSFtV6SGSote5a2yMf5r1
         fQ5P3BJAu+gCf02YkZDxzv+Uon5GJl89hFcDNZVNI7y/Bd/uNqrNN9Jr78NfUwic046k
         TWMgaXEhQbBiCqtqxxtWckrokx1hF60sO1MFREJXAATEHeCIHqOCdxXXirmHv0Nk9/Uj
         59ktBnASZ589dg9T0SGg+kZxINSJlNK1Ixy3buAU4rlXbghK2jUHxFU3rj//SzDGuHdy
         2pIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I+axwS0NjFSJ68C4qJyo4nPLinkVsy7+4TDR0W/9E14=;
        b=2bh2g/j4jAFYULyaDlFpZIcSSoLRcCVz6PmiogkRPcIbYDZlA7Bj99UDJGx1gkoEur
         JsivDnhz2KstwRYuKzlx840tTqCIUwAubDn2Ug5e7YtMHRtRDuC3dxOmIo9B09FS/C2v
         fnZSTgOoTl4/OkPCpsw6OCLT753+eXmqklM2zy+hmQ31VknYCnW52iiuL/3xK0bqGi/d
         tKRHsTt/Yc0Vc4Yus7igfRCWWtkAZFxv+z2lGNR09DdgBVj8AJTrByFTQeCqmvWmgihJ
         lUHqj/s9mnFzu21pWmzqmoTnBscYPrMenJqCl6NeQGsNIb/PX8JL7guGqd+Fq9B9yF2A
         xMkQ==
X-Gm-Message-State: AFqh2krJSqucFQaSI29laxESB/LmhjgPEv1flUN/SeMJJA7nCtiwDqm4
        UZJwA9TWbxd1KWLzqCJC5/r/pquLGdHhmYGo
X-Google-Smtp-Source: AMrXdXsOTextwz42BzO62lw9rcgwUxKDb21vG+3jLPXdb9Bn2AptB27vBbXyoFjJbchP+/DSqq17vA==
X-Received: by 2002:a17:902:b402:b0:188:d434:9c67 with SMTP id x2-20020a170902b40200b00188d4349c67mr1287050plr.32.1671615595477;
        Wed, 21 Dec 2022 01:39:55 -0800 (PST)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id cp10-20020a170902e78a00b001788ccecbf5sm10923181plb.31.2022.12.21.01.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 01:39:54 -0800 (PST)
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
Subject: [PATCHv2 net-next] sched: multicast sched extack messages
Date:   Wed, 21 Dec 2022 17:39:40 +0800
Message-Id: <20221221093940.2086025-1-liuhangbin@gmail.com>
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

It would also be helpful if "tc monitor" could log this message, as it
doesn't require vswitchd log level adjusment. Let's add a new function
to report the extack message so the monitor program could receive the
failures.
e.g.

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
v2: use NLMSG_ERROR instad of NLMSG_DONE to report the extack message
---
 net/sched/cls_api.c | 61 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 14 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 668130f08903..a63262f0dc2c 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1813,11 +1813,39 @@ static struct tcf_proto *tcf_chain_tp_find(struct tcf_chain *chain,
 	return tp;
 }
 
+static int tfilter_set_nl_ext(struct sk_buff *skb, const struct nlmsghdr *n,
+			      struct netlink_ext_ack *extack, u32 portid)
+{
+	struct nlmsgerr *errmsg;
+	struct nlmsghdr *nlh;
+
+	if (!extack || !extack->_msg)
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
+
 static int tcf_fill_node(struct net *net, struct sk_buff *skb,
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
@@ -1858,6 +1886,10 @@ static int tcf_fill_node(struct net *net, struct sk_buff *skb,
 			goto nla_put_failure;
 	}
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
+
+	if ((flags & NLM_F_ACK) && tfilter_set_nl_ext(skb, n, extack, portid))
+		goto out_nlmsg_trim;
+
 	return skb->len;
 
 out_nlmsg_trim:
@@ -1871,7 +1903,7 @@ static int tfilter_notify(struct net *net, struct sk_buff *oskb,
 			  struct nlmsghdr *n, struct tcf_proto *tp,
 			  struct tcf_block *block, struct Qdisc *q,
 			  u32 parent, void *fh, int event, bool unicast,
-			  bool rtnl_held)
+			  bool rtnl_held, struct netlink_ext_ack *extack)
 {
 	struct sk_buff *skb;
 	u32 portid = oskb ? NETLINK_CB(oskb).portid : 0;
@@ -1883,7 +1915,7 @@ static int tfilter_notify(struct net *net, struct sk_buff *oskb,
 
 	if (tcf_fill_node(net, skb, tp, block, q, parent, fh, portid,
 			  n->nlmsg_seq, n->nlmsg_flags, event,
-			  false, rtnl_held) <= 0) {
+			  false, rtnl_held, n, extack) <= 0) {
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -1912,7 +1944,7 @@ static int tfilter_del_notify(struct net *net, struct sk_buff *oskb,
 
 	if (tcf_fill_node(net, skb, tp, block, q, parent, fh, portid,
 			  n->nlmsg_seq, n->nlmsg_flags, RTM_DELTFILTER,
-			  false, rtnl_held) <= 0) {
+			  false, rtnl_held, n, extack) <= 0) {
 		NL_SET_ERR_MSG(extack, "Failed to build del event notification");
 		kfree_skb(skb);
 		return -EINVAL;
@@ -1938,14 +1970,15 @@ static int tfilter_del_notify(struct net *net, struct sk_buff *oskb,
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
@@ -2156,7 +2189,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 			      flags, extack);
 	if (err == 0) {
 		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
-			       RTM_NEWTFILTER, false, rtnl_held);
+			       RTM_NEWTFILTER, false, rtnl_held, extack);
 		tfilter_put(tp, fh);
 		/* q pointer is NULL for shared blocks */
 		if (q)
@@ -2284,7 +2317,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 
 	if (prio == 0) {
 		tfilter_notify_chain(net, skb, block, q, parent, n,
-				     chain, RTM_DELTFILTER);
+				     chain, RTM_DELTFILTER, extack);
 		tcf_chain_flush(chain, rtnl_held);
 		err = 0;
 		goto errout;
@@ -2308,7 +2341,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 
 		tcf_proto_put(tp, rtnl_held, NULL);
 		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
-			       RTM_DELTFILTER, false, rtnl_held);
+			       RTM_DELTFILTER, false, rtnl_held, extack);
 		err = 0;
 		goto errout;
 	}
@@ -2452,7 +2485,7 @@ static int tc_get_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 		err = -ENOENT;
 	} else {
 		err = tfilter_notify(net, skb, n, tp, block, q, parent,
-				     fh, RTM_NEWTFILTER, true, rtnl_held);
+				     fh, RTM_NEWTFILTER, true, rtnl_held, extack);
 		if (err < 0)
 			NL_SET_ERR_MSG(extack, "Failed to send filter notify message");
 	}
@@ -2490,7 +2523,7 @@ static int tcf_node_dump(struct tcf_proto *tp, void *n, struct tcf_walker *arg)
 	return tcf_fill_node(net, a->skb, tp, a->block, a->q, a->parent,
 			     n, NETLINK_CB(a->cb->skb).portid,
 			     a->cb->nlh->nlmsg_seq, NLM_F_MULTI,
-			     RTM_NEWTFILTER, a->terse_dump, true);
+			     RTM_NEWTFILTER, a->terse_dump, true, a->cb->nlh, NULL);
 }
 
 static bool tcf_chain_dump(struct tcf_chain *chain, struct Qdisc *q, u32 parent,
@@ -2524,7 +2557,7 @@ static bool tcf_chain_dump(struct tcf_chain *chain, struct Qdisc *q, u32 parent,
 			if (tcf_fill_node(net, skb, tp, block, q, parent, NULL,
 					  NETLINK_CB(cb->skb).portid,
 					  cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					  RTM_NEWTFILTER, false, true) <= 0)
+					  RTM_NEWTFILTER, false, true, cb->nlh, NULL) <= 0)
 				goto errout;
 			cb->args[1] = 1;
 		}
@@ -2912,7 +2945,7 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 		break;
 	case RTM_DELCHAIN:
 		tfilter_notify_chain(net, skb, block, q, parent, n,
-				     chain, RTM_DELTFILTER);
+				     chain, RTM_DELTFILTER, extack);
 		/* Flush the chain first as the user requested chain removal. */
 		tcf_chain_flush(chain, true);
 		/* In case the chain was successfully deleted, put a reference
-- 
2.38.1

