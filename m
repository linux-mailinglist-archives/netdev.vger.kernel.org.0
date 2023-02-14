Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE2B696F15
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbjBNVQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbjBNVQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:16:47 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E712FCD9
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:16:11 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id n132so14116937oih.7
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61cD+QNQWQc65NzLYQxjvLMKXx3ltSxpX+mXg/Fqqgg=;
        b=F+3OUDR3nEe2BBjWLtTj2rAehh3C4mP0lKm2fB6FBNnSz1vMbVifs3PdaqqAHr3ZRy
         ixiXK8Kzo3LbPlngTgQmlF51LMpFiXBpDJemWGJoTZ0o54ck3SNu0RGPfjbtud8efNmE
         fp3BdUcxI8uQm4GCeWI5QDTxKGNhyPnJUSuiv1Lx3TAAHQGagbYH0+6fn1JzZQ1SJ40C
         lYw4+bw4ECFxqIpO+7KmeeMCI4+O1RewBma/iUsiqrQ47kvT7hRGJVuuTElIY2A59v6+
         dSr3rT9E4HwGn87fSEbtB8nN8VK1W9UPE8F0cwuNpSY9JnrlthiB7oEy+s/z993lPx+Y
         4nyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61cD+QNQWQc65NzLYQxjvLMKXx3ltSxpX+mXg/Fqqgg=;
        b=BbfDb8CJl7JLFijpiL4kXuJPmjSC3oYU3b4uh6xXwWEBVks6l9bJ0tvxXqwz9tg8Bj
         wjSFUohKsq0t67PCld1HKuOnycdu+GATZ4s9so10DGa5bYU/+iMXcrCirLs/eovP+3kg
         ZV2XNHSU5+Q8uZix7YijY3vX749KxspF1mAhW9x7w45SdjcDMIDIHOPlmuLOazxxLpoJ
         MRVsV0zQO1rbic+hRwUiBKZczpaSSGd+GeMsilE8C/PRx2NORtVWd0fT710sjvfS5pKU
         OiGYXF7tBMovtuOn8JN7zjZK/XZrJRA9ObVzxKzwvQwo9oqB+F7rFDemqOhXz26aaiNq
         cfUA==
X-Gm-Message-State: AO0yUKVuUx/2wTpnIipPgPMM6lU59oEGTyXyUADCErDwdlFAUMG8UYFb
        GhbJPmJ3tlp/Pb1k34k3mhJLMcW7o0iT+qpI
X-Google-Smtp-Source: AK7set+KqkLOvehV+08qMKrYj2E20jBXep31R1E3I6/aTROcJStm1+wvDZUsLaDDX3I1o0+8NOvH/A==
X-Received: by 2002:a54:4183:0:b0:378:81e7:4ee2 with SMTP id 3-20020a544183000000b0037881e74ee2mr141834oiy.10.1676409353009;
        Tue, 14 Feb 2023 13:15:53 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:565a:c0a1:97af:209b])
        by smtp.gmail.com with ESMTPSA id b6-20020a9d5d06000000b0068bd3001922sm6949754oti.45.2023.02.14.13.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:15:52 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 1/4] net/sched: act_nat: transition to percpu stats and rcu
Date:   Tue, 14 Feb 2023 18:15:31 -0300
Message-Id: <20230214211534.735718-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230214211534.735718-1-pctammela@mojatatu.com>
References: <20230214211534.735718-1-pctammela@mojatatu.com>
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

The tc action act_nat was using shared stats and taking the per action
lock in the datapath. Improve it by using percpu stats and rcu.

perf before:
- 10.48% tcf_nat_act
   - 81.83% _raw_spin_lock
        81.08% native_queued_spin_lock_slowpath

perf after:
- 0.48% tcf_nat_act

tdc results:
1..27
ok 1 7565 - Add nat action on ingress with default control action
ok 2 fd79 - Add nat action on ingress with pipe control action
ok 3 eab9 - Add nat action on ingress with continue control action
ok 4 c53a - Add nat action on ingress with reclassify control action
ok 5 76c9 - Add nat action on ingress with jump control action
ok 6 24c6 - Add nat action on ingress with drop control action
ok 7 2120 - Add nat action on ingress with maximum index value
ok 8 3e9d - Add nat action on ingress with invalid index value
ok 9 f6c9 - Add nat action on ingress with invalid IP address
ok 10 be25 - Add nat action on ingress with invalid argument
ok 11 a7bd - Add nat action on ingress with DEFAULT IP address
ok 12 ee1e - Add nat action on ingress with ANY IP address
ok 13 1de8 - Add nat action on ingress with ALL IP address
ok 14 8dba - Add nat action on egress with default control action
ok 15 19a7 - Add nat action on egress with pipe control action
ok 16 f1d9 - Add nat action on egress with continue control action
ok 17 6d4a - Add nat action on egress with reclassify control action
ok 18 b313 - Add nat action on egress with jump control action
ok 19 d9fc - Add nat action on egress with drop control action
ok 20 a895 - Add nat action on egress with DEFAULT IP address
ok 21 2572 - Add nat action on egress with ANY IP address
ok 22 37f3 - Add nat action on egress with ALL IP address
ok 23 6054 - Add nat action on egress with cookie
ok 24 79d6 - Add nat action on ingress with cookie
ok 25 4b12 - Replace nat action with invalid goto chain control
ok 26 b811 - Delete nat action with valid index
ok 27 a521 - Delete nat action with invalid index

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 include/net/tc_act/tc_nat.h | 10 ++++--
 net/sched/act_nat.c         | 72 +++++++++++++++++++++++++------------
 2 files changed, 56 insertions(+), 26 deletions(-)

diff --git a/include/net/tc_act/tc_nat.h b/include/net/tc_act/tc_nat.h
index c14407160812..c869274ac529 100644
--- a/include/net/tc_act/tc_nat.h
+++ b/include/net/tc_act/tc_nat.h
@@ -5,13 +5,17 @@
 #include <linux/types.h>
 #include <net/act_api.h>
 
-struct tcf_nat {
-	struct tc_action common;
-
+struct tcf_nat_parms {
 	__be32 old_addr;
 	__be32 new_addr;
 	__be32 mask;
 	u32 flags;
+	struct rcu_head rcu;
+};
+
+struct tcf_nat {
+	struct tc_action common;
+	struct tcf_nat_parms __rcu *parms;
 };
 
 #define to_tcf_nat(a) ((struct tcf_nat *)a)
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 74c74be33048..4184af5abbf3 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -38,6 +38,7 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 {
 	struct tc_action_net *tn = net_generic(net, act_nat_ops.net_id);
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
+	struct tcf_nat_parms *nparm, *oparm;
 	struct nlattr *tb[TCA_NAT_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
 	struct tc_nat *parm;
@@ -59,8 +60,8 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	index = parm->index;
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_nat_ops, bind, false, flags);
+		ret = tcf_idr_create_from_flags(tn, index, est, a, &act_nat_ops,
+						bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
@@ -79,19 +80,31 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
 	if (err < 0)
 		goto release_idr;
+
+	nparm = kzalloc(sizeof(*nparm), GFP_KERNEL);
+	if (!nparm) {
+		err = -ENOMEM;
+		goto release_idr;
+	}
+
+	nparm->old_addr = parm->old_addr;
+	nparm->new_addr = parm->new_addr;
+	nparm->mask = parm->mask;
+	nparm->flags = parm->flags;
+
 	p = to_tcf_nat(*a);
 
 	spin_lock_bh(&p->tcf_lock);
-	p->old_addr = parm->old_addr;
-	p->new_addr = parm->new_addr;
-	p->mask = parm->mask;
-	p->flags = parm->flags;
-
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
+	oparm = rcu_replace_pointer(p->parms, nparm, lockdep_is_held(&p->tcf_lock));
 	spin_unlock_bh(&p->tcf_lock);
+
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
+	if (oparm)
+		kfree_rcu(oparm, rcu);
+
 	return ret;
 release_idr:
 	tcf_idr_release(*a, bind);
@@ -103,6 +116,7 @@ TC_INDIRECT_SCOPE int tcf_nat_act(struct sk_buff *skb,
 				  struct tcf_result *res)
 {
 	struct tcf_nat *p = to_tcf_nat(a);
+	struct tcf_nat_parms *parms;
 	struct iphdr *iph;
 	__be32 old_addr;
 	__be32 new_addr;
@@ -113,18 +127,16 @@ TC_INDIRECT_SCOPE int tcf_nat_act(struct sk_buff *skb,
 	int ihl;
 	int noff;
 
-	spin_lock(&p->tcf_lock);
-
 	tcf_lastuse_update(&p->tcf_tm);
-	old_addr = p->old_addr;
-	new_addr = p->new_addr;
-	mask = p->mask;
-	egress = p->flags & TCA_NAT_FLAG_EGRESS;
-	action = p->tcf_action;
+	tcf_action_update_bstats(&p->common, skb);
 
-	bstats_update(&p->tcf_bstats, skb);
+	action = READ_ONCE(p->tcf_action);
 
-	spin_unlock(&p->tcf_lock);
+	parms = rcu_dereference_bh(p->parms);
+	old_addr = parms->old_addr;
+	new_addr = parms->new_addr;
+	mask = parms->mask;
+	egress = parms->flags & TCA_NAT_FLAG_EGRESS;
 
 	if (unlikely(action == TC_ACT_SHOT))
 		goto drop;
@@ -248,9 +260,7 @@ TC_INDIRECT_SCOPE int tcf_nat_act(struct sk_buff *skb,
 	return action;
 
 drop:
-	spin_lock(&p->tcf_lock);
-	p->tcf_qstats.drops++;
-	spin_unlock(&p->tcf_lock);
+	tcf_action_inc_drop_qstats(&p->common);
 	return TC_ACT_SHOT;
 }
 
@@ -264,15 +274,20 @@ static int tcf_nat_dump(struct sk_buff *skb, struct tc_action *a,
 		.refcnt   = refcount_read(&p->tcf_refcnt) - ref,
 		.bindcnt  = atomic_read(&p->tcf_bindcnt) - bind,
 	};
+	struct tcf_nat_parms *parms;
 	struct tcf_t t;
 
 	spin_lock_bh(&p->tcf_lock);
-	opt.old_addr = p->old_addr;
-	opt.new_addr = p->new_addr;
-	opt.mask = p->mask;
-	opt.flags = p->flags;
+
 	opt.action = p->tcf_action;
 
+	parms = rcu_dereference_protected(p->parms, lockdep_is_held(&p->tcf_lock));
+
+	opt.old_addr = parms->old_addr;
+	opt.new_addr = parms->new_addr;
+	opt.mask = parms->mask;
+	opt.flags = parms->flags;
+
 	if (nla_put(skb, TCA_NAT_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
 
@@ -289,6 +304,16 @@ static int tcf_nat_dump(struct sk_buff *skb, struct tc_action *a,
 	return -1;
 }
 
+static void tcf_nat_cleanup(struct tc_action *a)
+{
+	struct tcf_nat *p = to_tcf_nat(a);
+	struct tcf_nat_parms *parms;
+
+	parms = rcu_dereference_protected(p->parms, 1);
+	if (parms)
+		kfree_rcu(parms, rcu);
+}
+
 static struct tc_action_ops act_nat_ops = {
 	.kind		=	"nat",
 	.id		=	TCA_ID_NAT,
@@ -296,6 +321,7 @@ static struct tc_action_ops act_nat_ops = {
 	.act		=	tcf_nat_act,
 	.dump		=	tcf_nat_dump,
 	.init		=	tcf_nat_init,
+	.cleanup	=	tcf_nat_cleanup,
 	.size		=	sizeof(struct tcf_nat),
 };
 
-- 
2.34.1

