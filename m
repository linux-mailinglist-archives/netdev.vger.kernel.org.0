Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB395F4D54
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 03:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiJEBUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 21:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJEBUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 21:20:08 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21DB1E3DA
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 18:20:03 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-132555b7121so9453594fac.2
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 18:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=vYCp3d34DHyk/MSd0SLsGCr9Tzl/7iMlVaqVp/bW8fs=;
        b=OT2j927URhzm3UFME4Sumhe2g86XOO2SZRDUdq0xi2rarwH17JYnMPF9G3RiLUgwzq
         nxO52mZAP2wae3jXnDU6grcd66C7yPLF8WXZCvyqpa3/LMPGXo9leBb+iQnJEPfQqkSl
         QnKsYCzcXqM4uEj03TWenWSmv92OT+4VFMtBHck46ZVlkM8B9wEScG4/wnVU/p6c2cPl
         mZHnWeYuVlzjym/BYbgemgzjucpxHfKwyEyZHn2BOCGXS5510kmW/DqB8YhlygmQUlIu
         /eTSzwJoPO+HWrXN93/hl/azwBThSIsKKxabvwlcFoc6+mZc00fZ8iRHXvmCz0ta42Ks
         Plmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vYCp3d34DHyk/MSd0SLsGCr9Tzl/7iMlVaqVp/bW8fs=;
        b=w6fboGs3Ch/BWuOJvntB6ysnWBloijj7DQGC9hzCEkhOuc5eNDs6e2Bk/jWlLMfU3k
         cHKXD/reJrAAjJIrvMg5w8Q5EpNr9gycwf0B+56F7HVKklpcS8SCIcZisRTQN0zxoOqv
         oomJXoTKjMJpB0M85JUJ3PP+3dTWoW4g4xIE6YCyzdJy778xJFR237BtdO5csM7MdBPu
         3F8VrsVDLKYZURXfQJDLbApkH75hDyfzAouOsxYMwhD/KKzkGfg9UuWP47KP9I8u403M
         D1P01jCJs7Xqae95W52aaNsdIL9pAfJgvWBGdvGYVzZsLS5DdLBTq9mOO3b4bUg3OcH6
         vw4g==
X-Gm-Message-State: ACrzQf0SfFoY0c6GIl+rJ9lqp8IQuWO47g9Ih9QAcJir2LM16pRk6122
        y46ZcPaBcUlZ+9tVLxvnMe6bC57cKkL5FQ==
X-Google-Smtp-Source: AMsMyM7gup+8nf853Q56gP5S4tLnPLquddLJJNqbesL1aoicxNUJpvsgszP+2B4/sYaHFOvRHG5YrQ==
X-Received: by 2002:a05:6870:95a9:b0:132:2020:42ba with SMTP id k41-20020a05687095a900b00132202042bamr1408454oao.50.1664932802694;
        Tue, 04 Oct 2022 18:20:02 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id ce4-20020a056830628400b00660a927e3bcsm1631787otb.25.2022.10.04.18.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 18:20:02 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>
Subject: [PATCH net-next 2/3] net: sched: call tcf_ct_params_free to free params in tcf_ct_init
Date:   Tue,  4 Oct 2022 21:19:55 -0400
Message-Id: <47242b0c07e0bdda7931120c762cc39ba5f327ac.1664932669.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1664932669.git.lucien.xin@gmail.com>
References: <cover.1664932669.git.lucien.xin@gmail.com>
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

This patch is to make the err path simple by calling tcf_ct_params_free(),
so that it won't cause problems when more members are added into param and
need freeing on the err path.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/act_ct.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index b38d91d6b249..193a460a9d7f 100644
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
@@ -1390,7 +1393,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 
 	err = tcf_ct_flow_table_get(net, params);
 	if (err)
-		goto cleanup_params;
+		goto cleanup;
 
 	spin_lock_bh(&c->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
@@ -1401,17 +1404,15 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 	if (params)
-		call_rcu(&params->rcu, tcf_ct_params_free);
+		call_rcu(&params->rcu, tcf_ct_params_free_rcu);
 
 	return res;
 
-cleanup_params:
-	if (params->tmpl)
-		nf_ct_put(params->tmpl);
 cleanup:
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
-	kfree(params);
+	if (params)
+		tcf_ct_params_free(params);
 	tcf_idr_release(*a, bind);
 	return err;
 }
@@ -1423,7 +1424,7 @@ static void tcf_ct_cleanup(struct tc_action *a)
 
 	params = rcu_dereference_protected(c->params, 1);
 	if (params)
-		call_rcu(&params->rcu, tcf_ct_params_free);
+		call_rcu(&params->rcu, tcf_ct_params_free_rcu);
 }
 
 static int tcf_ct_dump_key_val(struct sk_buff *skb,
-- 
2.31.1

