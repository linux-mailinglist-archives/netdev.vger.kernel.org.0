Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A899B613A2D
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbiJaPgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiJaPgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:36:18 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698A1B4BE
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:36:17 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id j6so8530536qvn.12
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vYCp3d34DHyk/MSd0SLsGCr9Tzl/7iMlVaqVp/bW8fs=;
        b=jVN+OaM4vCeKBeIE+jTJkff/beDf3rRBVqm/lr2ZJnKEO3Wb2DwvizKuYJvmAiIxJE
         gB+izr4hY/C3k5XFlOXLp+Vxva79L7QApHlgiTmpjHOaWQMCyDzA2GWJUb1j+ZGUAZII
         PGUaJCzngkXY2YQ/gln/GrTYGdoFvLHRB/HdGdEeRvtyVgOUn5nZD+1iQceImgG3Aa18
         S/CpqtW4BE+zF0TwgYeWUmGrde0xADedJTnnlWjxMfBHiUrDMj8VY4Z2l+j7L4G/ubmm
         /m/ShQajDlqhW79PrZHQ0snUk5ZcdumXiB9MHHg4ZMTAobE+c7NyTmlTqsPbsp83WqDs
         pbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vYCp3d34DHyk/MSd0SLsGCr9Tzl/7iMlVaqVp/bW8fs=;
        b=rRtC+YoNQ6h0S+9lRnIe7c2zdYAoZcdCRCv/yb1u0Pf0o0tx4w9+SQIrpDJirJik0J
         X6QYSZ2PaEhSgGxGl+/em/8CajlmOwLrq8az0x6zAKOa+Sdj2kofZcy1+P5svFDTu/og
         cUzjdzf6ZdWufFAzFiU5TG1vnvNgMQxCbEdj/jdC2bVezNTqlzEcfhhgqBd7U5HCq5I/
         ih1GCZ4mdTJ9q/CBfZQ3xm9JnW+pg090lmuEF1cYVo4gSLHYNd67Uv/Y8SiCv0K++cBj
         9TmsbKC36dbrisdyzJF9c06+07NPC39GAoNWpHZpNeE1tlVcfvl60h+nDTnZLkkjOUKc
         HLrA==
X-Gm-Message-State: ACrzQf1KZZgsDN0Zy6kmRHjH/2ywFwAZx98UVIqBcsiuRok17Ed/mbHD
        s8cowkMeC5r9+ztwlExfdwQf0nSzkLAK+A==
X-Google-Smtp-Source: AMsMyM6itiE9a3UYw7yX/ddMo+vEGJl1jACgX97xg3KvTCwM59tARGD9/AnJ2mlnvqdt6V5fC3Bblw==
X-Received: by 2002:a05:6214:f2e:b0:4bb:ee2f:43b2 with SMTP id iw14-20020a0562140f2e00b004bbee2f43b2mr5519771qvb.105.1667230576279;
        Mon, 31 Oct 2022 08:36:16 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bi29-20020a05620a319d00b006f956766f76sm4957924qkb.1.2022.10.31.08.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 08:36:15 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCHv3 net-next 3/4] net: sched: call tcf_ct_params_free to free params in tcf_ct_init
Date:   Mon, 31 Oct 2022 11:36:09 -0400
Message-Id: <342ecff78212f474db95e45987e6b5c053f83e07.1667230381.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1667230381.git.lucien.xin@gmail.com>
References: <cover.1667230381.git.lucien.xin@gmail.com>
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

