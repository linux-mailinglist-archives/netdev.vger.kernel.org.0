Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2AE7696F16
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbjBNVQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbjBNVQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:16:54 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1902030199
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:16:13 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id bh15so14120233oib.4
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CUMZon3G1SSF0JaI1sM77pr2rVr5hh58jVa2Fclo+jc=;
        b=AZQvqbKh7xqrjdLfOxTxMNPv/Zec/Tk2zb4I//b2FURVrsunIHH9SFZHWLArRqPjbs
         r/G43okWBX/DtDzIQ5OBB5DOzJD1HUoa29tffgh/k4rwaCnkoTDpsWp8BGpadouTxTMF
         AD618lYXYhc9wswiGK3B0vlYi1DavkGqAl7RdlbGf2xy9u0n8uURdMgzQc+xWwyPhFk9
         blCRFCrZ4PdbrmudRwckDAfxCsOpX/79QMJHJSPrZBzj4mZWO4GfmBmVUrzKwsr9nD+C
         Ihw3RfI90MOQIREW784zPaFkofIWXZvzJbQJLo/M8oHnT54ozCLUtlM32isn+ZympktH
         Wd8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CUMZon3G1SSF0JaI1sM77pr2rVr5hh58jVa2Fclo+jc=;
        b=iniFsbUGmX8agN9JErNbG0TvX7aVjaxLbuDdNOOiRyh9YauoJpQs4hXCEUMK920k5N
         TI5m2Xoohz4lXB13vTiKh/B7fBY17fcuMGyMM5R1Tmml8qZ+CCOZ2mIZs8DOPfWqNcDL
         dTrOhuaJeZlzU3aI0wkK7N2t63xlEVB/9Ow4NE9xyclrYG8T4begACnx7Cl6tJkHWlHA
         bUUPIM8aLgayuVp0GOiXG79rZzLK83P4lQ+v3d7RrnZKM/k1yUC+ZVjnZxjudqZMG5eV
         0GFBzNZrQKXuQ+fAei3u/GYENsyP8JrelbCeUeFZz0/TnO4th4YPL5RzxWcU5ERSPLNY
         sCTQ==
X-Gm-Message-State: AO0yUKUq8r1UmMCt23tn3sSoiVcVUFaJbXSB3WOwK6XGeKATqnpYXgJA
        zyFhiuOT4TJTezyrwgl2ONvwI1pi3t11vvF7
X-Google-Smtp-Source: AK7set+4+ytp8787WAXUdq40rjXfDW6eqnNWVbACfbMrfaVvzTJG5sJRp54ExqLlw9o+PFxCPVSVzg==
X-Received: by 2002:aca:170e:0:b0:378:954e:95b7 with SMTP id j14-20020aca170e000000b00378954e95b7mr1957863oii.58.1676409356896;
        Tue, 14 Feb 2023 13:15:56 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:565a:c0a1:97af:209b])
        by smtp.gmail.com with ESMTPSA id b6-20020a9d5d06000000b0068bd3001922sm6949754oti.45.2023.02.14.13.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:15:55 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 2/4] net/sched: act_connmark: transition to percpu stats and rcu
Date:   Tue, 14 Feb 2023 18:15:32 -0300
Message-Id: <20230214211534.735718-3-pctammela@mojatatu.com>
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

The tc action act_connmark was using shared stats and taking the per
action lock in the datapath. Improve it by using percpu stats and rcu.

perf before:
- 13.55% tcf_connmark_act
   - 81.18% _raw_spin_lock
       80.46% native_queued_spin_lock_slowpath

perf after:
- 2.85% tcf_connmark_act

tdc results:
1..15
ok 1 2002 - Add valid connmark action with defaults
ok 2 56a5 - Add valid connmark action with control pass
ok 3 7c66 - Add valid connmark action with control drop
ok 4 a913 - Add valid connmark action with control pipe
ok 5 bdd8 - Add valid connmark action with control reclassify
ok 6 b8be - Add valid connmark action with control continue
ok 7 d8a6 - Add valid connmark action with control jump
ok 8 aae8 - Add valid connmark action with zone argument
ok 9 2f0b - Add valid connmark action with invalid zone argument
ok 10 9305 - Add connmark action with unsupported argument
ok 11 71ca - Add valid connmark action and replace it
ok 12 5f8f - Add valid connmark action with cookie
ok 13 c506 - Replace connmark with invalid goto chain control
ok 14 6571 - Delete connmark action with valid index
ok 15 3426 - Delete connmark action with invalid index

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 include/net/tc_act/tc_connmark.h |   9 ++-
 net/sched/act_connmark.c         | 107 ++++++++++++++++++++-----------
 2 files changed, 75 insertions(+), 41 deletions(-)

diff --git a/include/net/tc_act/tc_connmark.h b/include/net/tc_act/tc_connmark.h
index 1f4cb477bb5d..e8dd77a96748 100644
--- a/include/net/tc_act/tc_connmark.h
+++ b/include/net/tc_act/tc_connmark.h
@@ -4,10 +4,15 @@
 
 #include <net/act_api.h>
 
-struct tcf_connmark_info {
-	struct tc_action common;
+struct tcf_connmark_parms {
 	struct net *net;
 	u16 zone;
+	struct rcu_head rcu;
+};
+
+struct tcf_connmark_info {
+	struct tc_action common;
+	struct tcf_connmark_parms __rcu *parms;
 };
 
 #define to_connmark(a) ((struct tcf_connmark_info *)a)
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 7e63ff7e3ed7..8dabfb52ea3d 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -36,13 +36,15 @@ TC_INDIRECT_SCOPE int tcf_connmark_act(struct sk_buff *skb,
 	struct nf_conntrack_tuple tuple;
 	enum ip_conntrack_info ctinfo;
 	struct tcf_connmark_info *ca = to_connmark(a);
+	struct tcf_connmark_parms *parms;
 	struct nf_conntrack_zone zone;
 	struct nf_conn *c;
 	int proto;
 
-	spin_lock(&ca->tcf_lock);
 	tcf_lastuse_update(&ca->tcf_tm);
-	bstats_update(&ca->tcf_bstats, skb);
+	tcf_action_update_bstats(&ca->common, skb);
+
+	parms = rcu_dereference_bh(ca->parms);
 
 	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
@@ -64,31 +66,29 @@ TC_INDIRECT_SCOPE int tcf_connmark_act(struct sk_buff *skb,
 	c = nf_ct_get(skb, &ctinfo);
 	if (c) {
 		skb->mark = READ_ONCE(c->mark);
-		/* using overlimits stats to count how many packets marked */
-		ca->tcf_qstats.overlimits++;
-		goto out;
+		goto count;
 	}
 
-	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
-			       proto, ca->net, &tuple))
+	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), proto, parms->net,
+			       &tuple))
 		goto out;
 
-	zone.id = ca->zone;
+	zone.id = parms->zone;
 	zone.dir = NF_CT_DEFAULT_ZONE_DIR;
 
-	thash = nf_conntrack_find_get(ca->net, &zone, &tuple);
+	thash = nf_conntrack_find_get(parms->net, &zone, &tuple);
 	if (!thash)
 		goto out;
 
 	c = nf_ct_tuplehash_to_ctrack(thash);
-	/* using overlimits stats to count how many packets marked */
-	ca->tcf_qstats.overlimits++;
 	skb->mark = READ_ONCE(c->mark);
 	nf_ct_put(c);
 
+count:
+	/* using overlimits stats to count how many packets marked */
+	tcf_action_inc_overlimit_qstats(&ca->common);
 out:
-	spin_unlock(&ca->tcf_lock);
-	return ca->tcf_action;
+	return READ_ONCE(ca->tcf_action);
 }
 
 static const struct nla_policy connmark_policy[TCA_CONNMARK_MAX + 1] = {
@@ -101,6 +101,7 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 			     struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, act_connmark_ops.net_id);
+	struct tcf_connmark_parms *nparms, *oparms;
 	struct nlattr *tb[TCA_CONNMARK_MAX + 1];
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct tcf_chain *goto_ch = NULL;
@@ -120,52 +121,66 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 	if (!tb[TCA_CONNMARK_PARMS])
 		return -EINVAL;
 
+	nparms = kzalloc(sizeof(*nparms), GFP_KERNEL);
+	if (!nparms)
+		return -ENOMEM;
+
 	parm = nla_data(tb[TCA_CONNMARK_PARMS]);
 	index = parm->index;
 	ret = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!ret) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_connmark_ops, bind, false, flags);
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_connmark_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
-			return ret;
+			err = ret;
+			goto out_free;
 		}
 
 		ci = to_connmark(*a);
-		err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch,
-					       extack);
-		if (err < 0)
-			goto release_idr;
-		tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-		ci->net = net;
-		ci->zone = parm->zone;
+
+		nparms->net = net;
+		nparms->zone = parm->zone;
 
 		ret = ACT_P_CREATED;
 	} else if (ret > 0) {
 		ci = to_connmark(*a);
-		if (bind)
-			return 0;
-		if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
-			tcf_idr_release(*a, bind);
-			return -EEXIST;
+		if (bind) {
+			err = 0;
+			goto out_free;
 		}
-		err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch,
-					       extack);
-		if (err < 0)
+		if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
+			err = -EEXIST;
 			goto release_idr;
-		/* replacing action and zone */
-		spin_lock_bh(&ci->tcf_lock);
-		goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-		ci->zone = parm->zone;
-		spin_unlock_bh(&ci->tcf_lock);
-		if (goto_ch)
-			tcf_chain_put_by_act(goto_ch);
+		}
+
+		nparms->net = rtnl_dereference(ci->parms)->net;
+		nparms->zone = parm->zone;
+
 		ret = 0;
 	}
 
+	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
+	if (err < 0)
+		goto release_idr;
+
+	spin_lock_bh(&ci->tcf_lock);
+	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
+	oparms = rcu_replace_pointer(ci->parms, nparms, lockdep_is_held(&ci->tcf_lock));
+	spin_unlock_bh(&ci->tcf_lock);
+
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+
+	if (oparms)
+		kfree_rcu(oparms, rcu);
+
 	return ret;
+
 release_idr:
 	tcf_idr_release(*a, bind);
+out_free:
+	kfree(nparms);
 	return err;
 }
 
@@ -179,11 +194,14 @@ static inline int tcf_connmark_dump(struct sk_buff *skb, struct tc_action *a,
 		.refcnt  = refcount_read(&ci->tcf_refcnt) - ref,
 		.bindcnt = atomic_read(&ci->tcf_bindcnt) - bind,
 	};
+	struct tcf_connmark_parms *parms;
 	struct tcf_t t;
 
 	spin_lock_bh(&ci->tcf_lock);
+	parms = rcu_dereference_protected(ci->parms, lockdep_is_held(&ci->tcf_lock));
+
 	opt.action = ci->tcf_action;
-	opt.zone = ci->zone;
+	opt.zone = parms->zone;
 	if (nla_put(skb, TCA_CONNMARK_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
 
@@ -201,6 +219,16 @@ static inline int tcf_connmark_dump(struct sk_buff *skb, struct tc_action *a,
 	return -1;
 }
 
+static void tcf_connmark_cleanup(struct tc_action *a)
+{
+	struct tcf_connmark_info *ci = to_connmark(a);
+	struct tcf_connmark_parms *parms;
+
+	parms = rcu_dereference_protected(ci->parms, 1);
+	if (parms)
+		kfree_rcu(parms, rcu);
+}
+
 static struct tc_action_ops act_connmark_ops = {
 	.kind		=	"connmark",
 	.id		=	TCA_ID_CONNMARK,
@@ -208,6 +236,7 @@ static struct tc_action_ops act_connmark_ops = {
 	.act		=	tcf_connmark_act,
 	.dump		=	tcf_connmark_dump,
 	.init		=	tcf_connmark_init,
+	.cleanup	=	tcf_connmark_cleanup,
 	.size		=	sizeof(struct tcf_connmark_info),
 };
 
-- 
2.34.1

