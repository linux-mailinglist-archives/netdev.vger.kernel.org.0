Return-Path: <netdev+bounces-3284-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0FCF706600
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:04:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84B4D2810D2
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA88168D6;
	Wed, 17 May 2023 11:03:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C08D171B0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:03:55 +0000 (UTC)
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914B930F8
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:15 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-3f443080ef7so4017281cf.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321356; x=1686913356;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=peThC93R7SZPguQGzbXZwhmlyhHY0h2P0J/fFOI9LCk=;
        b=kA2ZuIuq0NONy+/7i4aLStZSbplspuPJQ6reO8snyCXRkoGCfrL3yAE3PAMjwwpzhJ
         sf8aK6fL9F1h6Ht7UW9n8KIzjHvHWol3+y7aLMUHnCgQLhuSJpk3W4ytLuJHn/MzMjSI
         y05sY+KU1mi6CCAaZ8AyWHSuxiLi0GJH3cUSVl//UOK6jW3e07VU4WYbFc9ldb6+m+Y1
         OUK/jr1c2k4HMP3aEaDbED7Ja11811Rb1/qkShRjhfITj/Eh6e3ZPEP9xFLI9zu0Epr1
         grM6Y8A/ZNiDyybD2cuDR2Fiqy8V8KWQgEhjNsHvVJlUbNqeYtAskh+HfaVdsfV1jrnw
         nZaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321356; x=1686913356;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=peThC93R7SZPguQGzbXZwhmlyhHY0h2P0J/fFOI9LCk=;
        b=VkvCdWfIo4z8VxlXQ8cxm5fHkDWoIB5HFnfDpR1lUVrw0tKxlqIDu5A+S8tnXlIU99
         WNwjzB4ylNV9HWKGBq4/um3Hon/A8BizGzy7TqLLq0dGhDc0wuvfpLKygdyeWdcAbokm
         4+MGLcyIEqdDojt8aDPKB3gco3kYAd5DMjIiP3MZaEJH6AgcF6CFGX2Au0+oTmeiQ0P1
         zwyp3qEDaweLdroa6mwJhc8koxwZh32sOs5gaWzCmz7ddZHKXSfyYOEUcfNW0VeoVScO
         ZnConaQyFl/fnMPbjWdJL4Pn04gr6UWbqCy9KnPMIXMK5vxuPOMjU/vVFzJAL5/JR4Rz
         vj/A==
X-Gm-Message-State: AC+VfDww6vBpiV1t7kokiKxfhypKjYMdM9eOWBXiyjcDm5em0EcRNjgf
	LqHt+PgiAQvZeKak01LEQphi/cpshr9KspHzuYo=
X-Google-Smtp-Source: ACHHUZ4GYt+gileB6XL8fu+HDLQifzjtpiPJ8r25inGbSuFC5m8ayPXFJofqPEJvSrhnWubzP+iG2g==
X-Received: by 2002:ac8:7fd6:0:b0:3f5:3f9e:ffce with SMTP id b22-20020ac87fd6000000b003f53f9effcemr8766248qtk.43.1684321355614;
        Wed, 17 May 2023 04:02:35 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id k3-20020ac80203000000b003e39106bdb2sm7034660qtg.31.2023.05.17.04.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:02:35 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: netdev@vger.kernel.org
Cc: deb.chatterjee@intel.com,
	anjali.singhai@intel.com,
	namrata.limaye@intel.com,
	tom@sipanda.io,
	p4tc-discussions@netdevconf.info,
	mleitner@redhat.com,
	Mahesh.Shirshyad@amd.com,
	Vipin.Jain@amd.com,
	tomasz.osinski@intel.com,
	jiri@resnulli.us,
	xiyou.wangcong@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	vladbu@nvidia.com,
	simon.horman@corigine.com,
	khalidm@nvidia.com,
	toke@redhat.com
Subject: [PATCH RFC v2 net-next 01/28] net: sched: act_api: Add dynamic actions IDR
Date: Wed, 17 May 2023 07:02:05 -0400
Message-Id: <20230517110232.29349-1-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Kernel native actions kinds, such as gact, etc, have a predefined action
ID that is statically defined; example TCA_ID_GACT (0x2) for gact. In P4
we would require to generate new actions "on the fly" based on the P4
program requirement. Doing this in a list, like act_base does, would require us
to us to reimplement all of the ID generation that we get for free with IDRs,
so we chose to stick with an IDR for this. We could've simply converted
act_base into an IDR and used the same structure to store kernel native and
dynamic actions. However dynamic action kinds, like the pipeline they are
attached to, must be per net namespace, as opposed to native action kinds
which are global. For that reason, we chose to create a separate structure
to store dynamic actions.

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/act_api.h        |   6 +-
 include/uapi/linux/pkt_cls.h |   1 +
 net/sched/act_api.c          | 129 +++++++++++++++++++++++++++++++----
 net/sched/cls_api.c          |   2 +-
 4 files changed, 123 insertions(+), 15 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 4ae0580b63ca..54754deed15e 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -198,8 +198,10 @@ int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
 int tcf_idr_release(struct tc_action *a, bool bind);
 
 int tcf_register_action(struct tc_action_ops *a, struct pernet_operations *ops);
+int tcf_register_dyn_action(struct net *net, struct tc_action_ops *act);
 int tcf_unregister_action(struct tc_action_ops *a,
 			  struct pernet_operations *ops);
+int tcf_unregister_dyn_action(struct net *net, struct tc_action_ops *act);
 int tcf_action_destroy(struct tc_action *actions[], int bind);
 int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 		    int nr_actions, struct tcf_result *res);
@@ -207,8 +209,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est,
 		    struct tc_action *actions[], int init_res[], size_t *attr_size,
 		    u32 flags, u32 fl_flags, struct netlink_ext_ack *extack);
-struct tc_action_ops *tc_action_load_ops(struct nlattr *nla, bool police,
-					 bool rtnl_held,
+struct tc_action_ops *tc_action_load_ops(struct net *net, struct nlattr *nla,
+					 bool police, bool rtnl_held,
 					 struct netlink_ext_ack *extack);
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 648a82f32666..4d716841ca05 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -139,6 +139,7 @@ enum tca_id {
 	TCA_ID_MPLS,
 	TCA_ID_CT,
 	TCA_ID_GATE,
+	TCA_ID_DYN,
 	/* other actions go here */
 	__TCA_ID_MAX = 255
 };
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index f7887f42d542..3cd686d0094e 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -57,6 +57,43 @@ static void tcf_free_cookie_rcu(struct rcu_head *p)
 	kfree(cookie);
 }
 
+static unsigned int dyn_act_net_id;
+
+struct tcf_dyn_act_net {
+	struct idr act_base;
+	rwlock_t act_mod_lock;
+};
+
+static __net_init int tcf_dyn_act_base_init_net(struct net *net)
+{
+	struct tcf_dyn_act_net *dyn_base_net = net_generic(net, dyn_act_net_id);
+	rwlock_t _act_mod_lock = __RW_LOCK_UNLOCKED(_act_mod_lock);
+
+	idr_init(&dyn_base_net->act_base);
+	dyn_base_net->act_mod_lock = _act_mod_lock;
+	return 0;
+}
+
+static void __net_exit tcf_dyn_act_base_exit_net(struct net *net)
+{
+	struct tcf_dyn_act_net *dyn_base_net = net_generic(net, dyn_act_net_id);
+	struct tc_action_ops *ops;
+	unsigned long opid, tmp;
+
+	idr_for_each_entry_ul(&dyn_base_net->act_base, ops, tmp, opid) {
+		idr_remove(&dyn_base_net->act_base, ops->id);
+	}
+
+	idr_destroy(&dyn_base_net->act_base);
+}
+
+static struct pernet_operations tcf_dyn_act_base_net_ops = {
+	.init = tcf_dyn_act_base_init_net,
+	.exit = tcf_dyn_act_base_exit_net,
+	.id = &dyn_act_net_id,
+	.size = sizeof(struct tc_action_ops),
+};
+
 static void tcf_set_action_cookie(struct tc_cookie __rcu **old_cookie,
 				  struct tc_cookie *new_cookie)
 {
@@ -941,6 +978,28 @@ static void tcf_pernet_del_id_list(unsigned int id)
 	mutex_unlock(&act_id_mutex);
 }
 
+int tcf_register_dyn_action(struct net *net, struct tc_action_ops *act)
+{
+	struct tcf_dyn_act_net *dyn_base_net = net_generic(net, dyn_act_net_id);
+	int ret;
+
+	write_lock(&dyn_base_net->act_mod_lock);
+
+	act->id = TCA_ID_DYN;
+
+	ret = idr_alloc_u32(&dyn_base_net->act_base, act, &act->id,
+			    TCA_ID_MAX, GFP_ATOMIC);
+	if (ret < 0)
+		goto err_out;
+	write_unlock(&dyn_base_net->act_mod_lock);
+
+	return 0;
+
+err_out:
+	write_unlock(&dyn_base_net->act_mod_lock);
+	return ret;
+}
+
 int tcf_register_action(struct tc_action_ops *act,
 			struct pernet_operations *ops)
 {
@@ -1010,40 +1069,84 @@ int tcf_unregister_action(struct tc_action_ops *act,
 }
 EXPORT_SYMBOL(tcf_unregister_action);
 
+int tcf_unregister_dyn_action(struct net *net, struct tc_action_ops *act)
+{
+	struct tcf_dyn_act_net *dyn_base_net = net_generic(net, dyn_act_net_id);
+	int err = 0;
+
+	write_lock(&dyn_base_net->act_mod_lock);
+	if (!idr_remove(&dyn_base_net->act_base, act->id))
+		err = -EINVAL;
+
+	write_unlock(&dyn_base_net->act_mod_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(tcf_unregister_dyn_action);
+
 /* lookup by name */
-static struct tc_action_ops *tc_lookup_action_n(char *kind)
+static struct tc_action_ops *tc_lookup_action_n(struct net *net, char *kind)
 {
+	struct tcf_dyn_act_net *dyn_base_net = net_generic(net, dyn_act_net_id);
 	struct tc_action_ops *a, *res = NULL;
 
 	if (kind) {
+		unsigned long tmp, id;
+
 		read_lock(&act_mod_lock);
 		list_for_each_entry(a, &act_base, head) {
+			if (strcmp(kind, a->kind) == 0) {
+				if (try_module_get(a->owner)) {
+					read_unlock(&act_mod_lock);
+					return a;
+				}
+			}
+		}
+		read_unlock(&act_mod_lock);
+
+		read_lock(&dyn_base_net->act_mod_lock);
+		idr_for_each_entry_ul(&dyn_base_net->act_base, a, tmp, id) {
 			if (strcmp(kind, a->kind) == 0) {
 				if (try_module_get(a->owner))
 					res = a;
 				break;
 			}
 		}
-		read_unlock(&act_mod_lock);
+		read_unlock(&dyn_base_net->act_mod_lock);
 	}
 	return res;
 }
 
 /* lookup by nlattr */
-static struct tc_action_ops *tc_lookup_action(struct nlattr *kind)
+static struct tc_action_ops *tc_lookup_action(struct net *net,
+					      struct nlattr *kind)
 {
+	struct tcf_dyn_act_net *dyn_base_net = net_generic(net, dyn_act_net_id);
 	struct tc_action_ops *a, *res = NULL;
 
 	if (kind) {
+		unsigned long tmp, id;
+
 		read_lock(&act_mod_lock);
 		list_for_each_entry(a, &act_base, head) {
+			if (nla_strcmp(kind, a->kind) == 0) {
+				if (try_module_get(a->owner)) {
+					read_unlock(&act_mod_lock);
+					return a;
+				}
+			}
+		}
+		read_unlock(&act_mod_lock);
+
+		read_lock(&dyn_base_net->act_mod_lock);
+		idr_for_each_entry_ul(&dyn_base_net->act_base, a, tmp, id) {
 			if (nla_strcmp(kind, a->kind) == 0) {
 				if (try_module_get(a->owner))
 					res = a;
 				break;
 			}
 		}
-		read_unlock(&act_mod_lock);
+		read_unlock(&dyn_base_net->act_mod_lock);
 	}
 	return res;
 }
@@ -1294,8 +1397,8 @@ void tcf_idr_insert_many(struct tc_action *actions[])
 	}
 }
 
-struct tc_action_ops *tc_action_load_ops(struct nlattr *nla, bool police,
-					 bool rtnl_held,
+struct tc_action_ops *tc_action_load_ops(struct net *net, struct nlattr *nla,
+					 bool police, bool rtnl_held,
 					 struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[TCA_ACT_MAX + 1];
@@ -1326,7 +1429,7 @@ struct tc_action_ops *tc_action_load_ops(struct nlattr *nla, bool police,
 		}
 	}
 
-	a_o = tc_lookup_action_n(act_name);
+	a_o = tc_lookup_action_n(net, act_name);
 	if (a_o == NULL) {
 #ifdef CONFIG_MODULES
 		if (rtnl_held)
@@ -1335,7 +1438,7 @@ struct tc_action_ops *tc_action_load_ops(struct nlattr *nla, bool police,
 		if (rtnl_held)
 			rtnl_lock();
 
-		a_o = tc_lookup_action_n(act_name);
+		a_o = tc_lookup_action_n(net, act_name);
 
 		/* We dropped the RTNL semaphore in order to
 		 * perform the module load.  So, even if we
@@ -1445,7 +1548,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 	for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
 		struct tc_action_ops *a_o;
 
-		a_o = tc_action_load_ops(tb[i], flags & TCA_ACT_FLAGS_POLICE,
+		a_o = tc_action_load_ops(net, tb[i],
+					 flags & TCA_ACT_FLAGS_POLICE,
 					 !(flags & TCA_ACT_FLAGS_NO_RTNL),
 					 extack);
 		if (IS_ERR(a_o)) {
@@ -1655,7 +1759,7 @@ static struct tc_action *tcf_action_get_1(struct net *net, struct nlattr *nla,
 	index = nla_get_u32(tb[TCA_ACT_INDEX]);
 
 	err = -EINVAL;
-	ops = tc_lookup_action(tb[TCA_ACT_KIND]);
+	ops = tc_lookup_action(net, tb[TCA_ACT_KIND]);
 	if (!ops) { /* could happen in batch of actions */
 		NL_SET_ERR_MSG(extack, "Specified TC action kind not found");
 		goto err_out;
@@ -1703,7 +1807,7 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
 
 	err = -EINVAL;
 	kind = tb[TCA_ACT_KIND];
-	ops = tc_lookup_action(kind);
+	ops = tc_lookup_action(net, kind);
 	if (!ops) { /*some idjot trying to flush unknown action */
 		NL_SET_ERR_MSG(extack, "Cannot flush unknown TC action");
 		goto err_out;
@@ -2109,7 +2213,7 @@ static int tc_dump_action(struct sk_buff *skb, struct netlink_callback *cb)
 		return 0;
 	}
 
-	a_o = tc_lookup_action(kind);
+	a_o = tc_lookup_action(net, kind);
 	if (a_o == NULL)
 		return 0;
 
@@ -2176,6 +2280,7 @@ static int __init tc_action_init(void)
 	rtnl_register(PF_UNSPEC, RTM_GETACTION, tc_ctl_action, tc_dump_action,
 		      0);
 
+	register_pernet_subsys(&tcf_dyn_act_base_net_ops);
 	return 0;
 }
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2621550bfddc..4af48f76fe55 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3271,7 +3271,7 @@ int tcf_exts_validate_ex(struct net *net, struct tcf_proto *tp, struct nlattr **
 		if (exts->police && tb[exts->police]) {
 			struct tc_action_ops *a_o;
 
-			a_o = tc_action_load_ops(tb[exts->police], true,
+			a_o = tc_action_load_ops(net, tb[exts->police], true,
 						 !(flags & TCA_ACT_FLAGS_NO_RTNL),
 						 extack);
 			if (IS_ERR(a_o))
-- 
2.25.1


