Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3DF692890
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 21:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbjBJUpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 15:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbjBJUo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 15:44:57 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996F270714
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 12:44:56 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id cz14so5458978oib.12
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 12:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8INlq6xo7R2+lXLjUMCK9seRY08jAOSgCaggF49ap3w=;
        b=550GZBtXSaMVqkuV+x4ZeRfkti/ZaiQI59c5OGJDTxZ8zjOuwbF182k05ZfnE5hZUd
         MDRZijzTox4DbeUQGPOBv4k+KXf72pB2IkMM96QJJp0mkzoW1YYK4CrqONSgxFsUeBve
         PG343lZ3LQzm7T7+2pWSEZyy8FZOuqSFvWMHR7LXtLY9KNw++tW2mlAdURdc7Vg80JCF
         OyoMqj4GE5XipjMDTEngCTGefSLmarYYIFIvW93ueYGb2xgapehobb4uqpSJlYb0gThG
         uG03rCft54jB6DaCUTPJSyK5xXrq3GbmNbibGebFNSUNYiHI4136bd5Nue6Sev0408H6
         Qpuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8INlq6xo7R2+lXLjUMCK9seRY08jAOSgCaggF49ap3w=;
        b=qzgVI65oqKG5K43A05OmwtnowXnjLQIObi3V1v2rx69lBayg+qWSLWM0TTBOvWXYs2
         vFBXYbFXCKVHXStF5+5F2eqefxEYEEPp/UnP9KgGrL3KuYLmsodQ2p3TS+IZaGI27iOX
         ETIEDSgFMspZptQXtqoD5xi1QsYS4U2rwCnt/8uNMcVH2fElX0IWkEN7tpIRW2RWK281
         uYGocbEjScIaa0TEy8m6SkLO0vR623VJxUX1PcOeBh0HPIBwMcqC/JvnyCic24xOcNsZ
         xLH/euDmf95boXZIPtVVbRswXX2oDkfiv/L+j4FaCnZ8yRAWZkzECvMwSy1UPDealftP
         8vXw==
X-Gm-Message-State: AO0yUKX4t4oWV8FuQ6p1o5u/WTdx5lB4cK9tgbDcNOGuu4EiQw7cPAgv
        HFASHZ9gsxBcS0V+hyJicN0KgfdbFHV8V37N
X-Google-Smtp-Source: AK7set9UkyFX+JrM3JHyb8Pne0rPsT4YKru4YsnR0Ibbs9mhpJC7rivJ3nx7RH3vc+G6lWFBrMfhGg==
X-Received: by 2002:a05:6808:7da:b0:375:45c3:3e8e with SMTP id f26-20020a05680807da00b0037545c33e8emr7118593oij.59.1676061895777;
        Fri, 10 Feb 2023 12:44:55 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:2ce0:9122:6880:760c])
        by smtp.gmail.com with ESMTPSA id v23-20020a9d5a17000000b0068bc8968753sm2396681oth.17.2023.02.10.12.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 12:44:55 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next 1/3] net/sched: act_nat: transition to percpu stats and rcu
Date:   Fri, 10 Feb 2023 17:27:24 -0300
Message-Id: <20230210202725.446422-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230210202725.446422-1-pctammela@mojatatu.com>
References: <20230210202725.446422-1-pctammela@mojatatu.com>
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
 net/sched/act_nat.c         | 68 ++++++++++++++++++++++++++-----------
 2 files changed, 55 insertions(+), 23 deletions(-)

diff --git a/include/net/tc_act/tc_nat.h b/include/net/tc_act/tc_nat.h
index c14407160..c869274ac 100644
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
index 74c74be33..fb986d97c 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -40,6 +40,7 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct nlattr *tb[TCA_NAT_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
+	struct tcf_nat_parms *nparm, *oparm;
 	struct tc_nat *parm;
 	int ret = 0, err;
 	struct tcf_nat *p;
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
@@ -264,15 +276,20 @@ static int tcf_nat_dump(struct sk_buff *skb, struct tc_action *a,
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
 
@@ -289,6 +306,16 @@ static int tcf_nat_dump(struct sk_buff *skb, struct tc_action *a,
 	return -1;
 }
 
+static void tcf_nat_cleanup(struct tc_action *a)
+{
+	struct tcf_nat_parms *parms;
+	struct tcf_nat *p = to_tcf_nat(a);
+
+	parms = rcu_dereference_protected(p->parms, 1);
+	if (parms)
+		kfree_rcu(parms, rcu);
+}
+
 static struct tc_action_ops act_nat_ops = {
 	.kind		=	"nat",
 	.id		=	TCA_ID_NAT,
@@ -296,6 +323,7 @@ static struct tc_action_ops act_nat_ops = {
 	.act		=	tcf_nat_act,
 	.dump		=	tcf_nat_dump,
 	.init		=	tcf_nat_init,
+	.cleanup	=	tcf_nat_cleanup,
 	.size		=	sizeof(struct tcf_nat),
 };
 
-- 
2.34.1

