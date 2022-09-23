Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6A25E7E60
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbiIWP2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiIWP2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:28:32 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32B71449E1
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:28:30 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id i15so129104qvp.5
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=u8IIii0CTMnWPPuWjb5ZJnoQbavdY4WoZdRZNHMjDyA=;
        b=I4E/PZ/L3DT4JyUSwIIM/SJIxgKMs9kdpzInEJGrrsKBkzGCPwyXqu32jESwTBoTpr
         /Q67+HUFoWf+RencUbmQK1KbgM/V4gW2Yw6Pd09ltJQdJoPN3/ffFl1ueXBNR2zD9agX
         FMu/6rN/uxJnZh14rCZH8IcNF38lklGBDo2vPhK6lchVWnRE7SHg7RVQAQeJkVr0l2jh
         CDtU8cd8ZeMzwauJSX20xog1R3vig+1RHWm9gEvSMckUHoIT0zfPYfCFO7tah6RjYJTf
         ArGBIloMj3foHlzDWN1VDKNENKJwkIqoUwb2YnFQRpbMi7DqDZuFAYmF6oYwmc7/HN9m
         uapA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=u8IIii0CTMnWPPuWjb5ZJnoQbavdY4WoZdRZNHMjDyA=;
        b=aEqHIjrmLUDd9IIm+XQKQS6FKy/T0BmWlizdCmGkOMDgM4sBQGD4wSXI6EJwF3zJjA
         ybgYIlDIu9r/RLiy6JkRLxHaXXlyOgTacIo7S0LxD6sribRN7CaquAJVPBswPRH++i8S
         GgSWaOU1a95Wt+1qsga5BtLAmlLIKQfmLPJkN0L7HiNhaMUHSc9H3tURaNUpdMC1zcEb
         6wzWJQ1HhbDp3m9RGhV6u013IT1UiUBa2Ij5ROoK6YF1YbXuUD2XfP4zWpYrFXbpIc5o
         BAVkFmBLxDqQllgIR/bo0144NzznPxDXLsXQklxeQJHmrRv+dGiYsNmmefZFAEsaHmlv
         HYVQ==
X-Gm-Message-State: ACrzQf2RS/o/8+H3UOePLOcWz4vdhtJeHMS7b/KUylSGTUoOR/EbzrOb
        Dx/wsyICejGPpzAcA2vuiPHg08/zm7eJww==
X-Google-Smtp-Source: AMsMyM7gI8CNA4nSc/sP4b/NKB/pK9qvyAIqHQpOeUtBfxJhKM2WqARBxBMaJCldyxxC+JqxZ1TAVQ==
X-Received: by 2002:a05:6214:1cc5:b0:498:5d76:69f with SMTP id g5-20020a0562141cc500b004985d76069fmr7469985qvd.33.1663946909758;
        Fri, 23 Sep 2022 08:28:29 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id dm52-20020a05620a1d7400b006ce3f1af120sm6623051qkb.44.2022.09.23.08.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 08:28:29 -0700 (PDT)
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
Subject: [PATCH net-next 1/2] net: sched: fix the err path of tcf_ct_init in act_ct
Date:   Fri, 23 Sep 2022 11:28:26 -0400
Message-Id: <208333ca564baf0994d3af3c454dc16127c9ad09.1663946157.git.lucien.xin@gmail.com>
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

When it returns err from tcf_ct_flow_table_get(), the param tmpl should
have been freed in the cleanup. Otherwise a memory leak will occur.

While fixing this problem, this patch also makes the err path simple by
calling tcf_ct_params_free(), so that it won't cause problems when more
members are added into param and need freeing on the err path.

Fixes: c34b961a2492 ("net/sched: act_ct: Create nf flow table per zone")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/act_ct.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 9d19710835b0..193a460a9d7f 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -345,11 +345,9 @@ static void tcf_ct_flow_table_cleanup_work(struct work_struct *work)
 	module_put(THIS_MODULE);
 }
 
-static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
+static void tcf_ct_flow_table_put(struct tcf_ct_flow_table *ct_ft)
 {
-	struct tcf_ct_flow_table *ct_ft = params->ct_ft;
-
-	if (refcount_dec_and_test(&params->ct_ft->ref)) {
+	if (refcount_dec_and_test(&ct_ft->ref)) {
 		rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
 		INIT_RCU_WORK(&ct_ft->rwork, tcf_ct_flow_table_cleanup_work);
 		queue_rcu_work(act_ct_wq, &ct_ft->rwork);
@@ -832,18 +830,23 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 	return err;
 }
 
-static void tcf_ct_params_free(struct rcu_head *head)
+static void tcf_ct_params_free(struct tcf_ct_params *params)
 {
-	struct tcf_ct_params *params = container_of(head,
-						    struct tcf_ct_params, rcu);
-
-	tcf_ct_flow_table_put(params);
-
+	if (params->ct_ft)
+		tcf_ct_flow_table_put(params->ct_ft);
 	if (params->tmpl)
 		nf_ct_put(params->tmpl);
 	kfree(params);
 }
 
+static void tcf_ct_params_free_rcu(struct rcu_head *head)
+{
+	struct tcf_ct_params *params;
+
+	params = container_of(head, struct tcf_ct_params, rcu);
+	tcf_ct_params_free(params);
+}
+
 #if IS_ENABLED(CONFIG_NF_NAT)
 /* Modelled after nf_nat_ipv[46]_fn().
  * range is only used for new, uninitialized NAT state.
@@ -1401,14 +1404,15 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 	if (params)
-		call_rcu(&params->rcu, tcf_ct_params_free);
+		call_rcu(&params->rcu, tcf_ct_params_free_rcu);
 
 	return res;
 
 cleanup:
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
-	kfree(params);
+	if (params)
+		tcf_ct_params_free(params);
 	tcf_idr_release(*a, bind);
 	return err;
 }
@@ -1420,7 +1424,7 @@ static void tcf_ct_cleanup(struct tc_action *a)
 
 	params = rcu_dereference_protected(c->params, 1);
 	if (params)
-		call_rcu(&params->rcu, tcf_ct_params_free);
+		call_rcu(&params->rcu, tcf_ct_params_free_rcu);
 }
 
 static int tcf_ct_dump_key_val(struct sk_buff *skb,
-- 
2.31.1

