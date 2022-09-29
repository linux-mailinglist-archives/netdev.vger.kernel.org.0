Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B2E5EEC7C
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 05:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbiI2DfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 23:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbiI2DfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 23:35:17 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6854575FFA
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 20:35:15 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso4458638pjq.1
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 20:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=E9Zeq5//G0Opldrg47k5z+iMe81VJal5xl3to7qg4dk=;
        b=QRj+3SdbwVGWt1aGc4s0pJlvQFBZxU1fQuesoLzNpso/VGj9/lzLRXr5oavj8HhkVb
         zILc+wnwaU0ONeriVrS9YbfyZM/dDXiZybV+Oo2G5hMwz2LCcm7iTCDEMOyBFO6/1+y9
         PqN4rKoPey9VQEWCA2M+np+wwO9YIe9HrQPLuRwWPNDMTDL4AqLTvM8yCtE7eKmIlR4G
         fei7vd9ckZ3sKyMRgHy5JPSD8FWPHStzQmWazcsUsJkI+2Zfwbeimatym3te+VWLAvms
         RWrExD2Ct2jRoR9t9bpsFYqqXffIn4w7jXkkv2NjEsSShjExIdQgVLrgF2QUStcc0xec
         r/ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=E9Zeq5//G0Opldrg47k5z+iMe81VJal5xl3to7qg4dk=;
        b=BzUrSlN5PWY8nIiM09CLXhh7HJ7c2rt8yj2XQMdTElfHz3I2s2zrmJttu6e3wKm8fJ
         zKhtHf9H1otVmVs2SurPVJTAgnekuLMfozlaRu3E2PYabyVLFZt5fwHya55qU3xOptIk
         ziZyBh5LsEZcMEUXOO2OUNEumN8ZR2ZVkN+FQhhU3HFRs2qLq3F2w9OLViKnhJsT9XBw
         qzSJpeoLqxB45KbczmoDhMXEmDb3chIvhAZ7GkexxkuGrRDZGptqhEwdD3KQrsN2Kl2o
         sLWOcKwDVOvvz8dB5zixb629TUk2tHhtReKru1123MERw6TnMPeQe35wlTvtgCTcvZeZ
         pWCg==
X-Gm-Message-State: ACrzQf0YgKEzkKuHJDSgT+S7/OtQhi3cjaN6e5P8fShOGvx7qBtd2hjE
        ceJluGH15kFm1BSKvqyU5vaXK5I97TN21A==
X-Google-Smtp-Source: AMsMyM7IH6nV1EKnJUD40dKu1gK8Q9JNY8D/LZoYtCYP0Z3yXQnlcURgGCZuGwTA5al8a449Yf2Kew==
X-Received: by 2002:a17:90b:35cf:b0:202:6f3d:53a7 with SMTP id nb15-20020a17090b35cf00b002026f3d53a7mr1424555pjb.63.1664422514661;
        Wed, 28 Sep 2022 20:35:14 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id f9-20020a170902f38900b001783f964fe3sm4460831ple.113.2022.09.28.20.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 20:35:14 -0700 (PDT)
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
Subject: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Date:   Thu, 29 Sep 2022 11:35:05 +0800
Message-Id: <20220929033505.457172-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.2
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
doesn't require vswitchd log level adjusment. Let's add the extack message
in tfilter_notify so the monitor program could receive the failures.
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

Rebase the patch to latest net-next as the previous could not
apply to net-next.

---
 net/sched/cls_api.c | 45 ++++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 50566db45949..7994dfdbd312 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1816,13 +1816,15 @@ static int tcf_fill_node(struct net *net, struct sk_buff *skb,
 			 struct tcf_proto *tp, struct tcf_block *block,
 			 struct Qdisc *q, u32 parent, void *fh,
 			 u32 portid, u32 seq, u16 flags, int event,
-			 bool terse_dump, bool rtnl_held)
+			 bool terse_dump, bool rtnl_held,
+			 struct netlink_ext_ack *extack)
 {
 	struct tcmsg *tcm;
 	struct nlmsghdr  *nlh;
 	unsigned char *b = skb_tail_pointer(skb);
 
-	nlh = nlmsg_put(skb, portid, seq, event, sizeof(*tcm), flags);
+	nlh = nlmsg_put(skb, portid, seq, event, sizeof(*tcm),
+			(extack && extack->_msg) ? flags | NLM_F_MULTI : flags);
 	if (!nlh)
 		goto out_nlmsg_trim;
 	tcm = nlmsg_data(nlh);
@@ -1857,6 +1859,18 @@ static int tcf_fill_node(struct net *net, struct sk_buff *skb,
 			goto nla_put_failure;
 	}
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
+
+	if (extack && extack->_msg) {
+		nlh = nlmsg_put(skb, portid, seq, NLMSG_DONE, 0, flags | NLM_F_ACK_TLVS);
+		if (!nlh)
+			goto out_nlmsg_trim;
+
+		if (nla_put_string(skb, NLMSGERR_ATTR_MSG, extack->_msg))
+			goto nla_put_failure;
+
+		nlmsg_end(skb, nlh);
+	}
+
 	return skb->len;
 
 out_nlmsg_trim:
@@ -1870,7 +1884,7 @@ static int tfilter_notify(struct net *net, struct sk_buff *oskb,
 			  struct nlmsghdr *n, struct tcf_proto *tp,
 			  struct tcf_block *block, struct Qdisc *q,
 			  u32 parent, void *fh, int event, bool unicast,
-			  bool rtnl_held)
+			  bool rtnl_held, struct netlink_ext_ack *extack)
 {
 	struct sk_buff *skb;
 	u32 portid = oskb ? NETLINK_CB(oskb).portid : 0;
@@ -1882,7 +1896,7 @@ static int tfilter_notify(struct net *net, struct sk_buff *oskb,
 
 	if (tcf_fill_node(net, skb, tp, block, q, parent, fh, portid,
 			  n->nlmsg_seq, n->nlmsg_flags, event,
-			  false, rtnl_held) <= 0) {
+			  false, rtnl_held, extack) <= 0) {
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -1911,7 +1925,7 @@ static int tfilter_del_notify(struct net *net, struct sk_buff *oskb,
 
 	if (tcf_fill_node(net, skb, tp, block, q, parent, fh, portid,
 			  n->nlmsg_seq, n->nlmsg_flags, RTM_DELTFILTER,
-			  false, rtnl_held) <= 0) {
+			  false, rtnl_held, extack) <= 0) {
 		NL_SET_ERR_MSG(extack, "Failed to build del event notification");
 		kfree_skb(skb);
 		return -EINVAL;
@@ -1937,14 +1951,15 @@ static int tfilter_del_notify(struct net *net, struct sk_buff *oskb,
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
@@ -2148,7 +2163,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 			      flags, extack);
 	if (err == 0) {
 		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
-			       RTM_NEWTFILTER, false, rtnl_held);
+			       RTM_NEWTFILTER, false, rtnl_held, extack);
 		tfilter_put(tp, fh);
 		/* q pointer is NULL for shared blocks */
 		if (q)
@@ -2276,7 +2291,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 
 	if (prio == 0) {
 		tfilter_notify_chain(net, skb, block, q, parent, n,
-				     chain, RTM_DELTFILTER);
+				     chain, RTM_DELTFILTER, extack);
 		tcf_chain_flush(chain, rtnl_held);
 		err = 0;
 		goto errout;
@@ -2300,7 +2315,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 
 		tcf_proto_put(tp, rtnl_held, NULL);
 		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
-			       RTM_DELTFILTER, false, rtnl_held);
+			       RTM_DELTFILTER, false, rtnl_held, extack);
 		err = 0;
 		goto errout;
 	}
@@ -2444,7 +2459,7 @@ static int tc_get_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 		err = -ENOENT;
 	} else {
 		err = tfilter_notify(net, skb, n, tp, block, q, parent,
-				     fh, RTM_NEWTFILTER, true, rtnl_held);
+				     fh, RTM_NEWTFILTER, true, rtnl_held, extack);
 		if (err < 0)
 			NL_SET_ERR_MSG(extack, "Failed to send filter notify message");
 	}
@@ -2482,7 +2497,7 @@ static int tcf_node_dump(struct tcf_proto *tp, void *n, struct tcf_walker *arg)
 	return tcf_fill_node(net, a->skb, tp, a->block, a->q, a->parent,
 			     n, NETLINK_CB(a->cb->skb).portid,
 			     a->cb->nlh->nlmsg_seq, NLM_F_MULTI,
-			     RTM_NEWTFILTER, a->terse_dump, true);
+			     RTM_NEWTFILTER, a->terse_dump, true, NULL);
 }
 
 static bool tcf_chain_dump(struct tcf_chain *chain, struct Qdisc *q, u32 parent,
@@ -2516,7 +2531,7 @@ static bool tcf_chain_dump(struct tcf_chain *chain, struct Qdisc *q, u32 parent,
 			if (tcf_fill_node(net, skb, tp, block, q, parent, NULL,
 					  NETLINK_CB(cb->skb).portid,
 					  cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					  RTM_NEWTFILTER, false, true) <= 0)
+					  RTM_NEWTFILTER, false, true, NULL) <= 0)
 				goto errout;
 			cb->args[1] = 1;
 		}
@@ -2904,7 +2919,7 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 		break;
 	case RTM_DELCHAIN:
 		tfilter_notify_chain(net, skb, block, q, parent, n,
-				     chain, RTM_DELTFILTER);
+				     chain, RTM_DELTFILTER, extack);
 		/* Flush the chain first as the user requested chain removal. */
 		tcf_chain_flush(chain, true);
 		/* In case the chain was successfully deleted, put a reference
-- 
2.37.2

