Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D404561E5EF
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 21:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiKFUea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 15:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiKFUe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 15:34:28 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693AD11479
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 12:34:27 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id k4so6187281qkj.8
        for <netdev@vger.kernel.org>; Sun, 06 Nov 2022 12:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UWT0jOuXhE0Q7uIZzOugbz09aVE+DCkuvqop6cLxWAM=;
        b=dgYvyC2AEbzmJPbrmIiOV3r3QhTV3YvX2Ks11ypmdF3fhzn30KED8T7n5DHhORrPM5
         qN0EhWk9RSGlqQiLVRIKRrn4S63c56B6YIqXFqYNJNAdrFLa757IFpNQ2JHAtfqPpEiD
         ehT8nP/elaFUQKeeD71OKZ3jsNCiNl7Avss2Kh+bF2GbRUAJ6IPT9Ppq6CILQySl7M1M
         wBUFw18Lb02uqGRtd6TKH5jNwTFnArtnL9vjGGi1KCIxygAR4KBgG8K8ur1bvAx3hHTc
         w/WM0Y5QyBfUxy1L3MmSfogHPKLQPKu+ZIIMEwbuBS2DBB2C6IbpLQHEVIqxBbT4hOR4
         od+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UWT0jOuXhE0Q7uIZzOugbz09aVE+DCkuvqop6cLxWAM=;
        b=f+CdpUueLsnQWVmScMDse5nJiOTcj1sJdCURcrFC4W5Jdl7Mf7vRxg84MuB+0Kv/sK
         Y/1p0TIXIrXUFYLPMcQDAdz+jHwMc2UzG6wQXnQWg6f3ZsufrnAunEBp0EmtwcyqLNum
         Avcs+NvEjEx6bMHXBXgQE8aVLmvaK6LPkkCbt15NTi5WcFCjH3iIqPFc8XwlDikwNE2S
         IkMsF/q9+pV5trHz+Wtl58mMi7Ke7IQZq3f/XAfSad+h6rPwlogXhNJ1UIrucEqj6cGM
         iRP2RKw4NDYyBu9KlOcnwxWhj1TjOwS77oFkgcTc1X+nFqNvs9M+4Ok7xSSUgvMbak5L
         Y+Tw==
X-Gm-Message-State: ACrzQf3GQKdVFKsUJL8GcivI0BCLMebqQ8DrvDevjaTyaaN7YNqGZJe9
        82vscLCfJvPRfJCvMybShpJpHEwvRuuA5w==
X-Google-Smtp-Source: AMsMyM4DITP2/mBMymG1J9HURfXIihvJP3NtMk0g4DSomvrY5ZguIspy6uHfs2Ii5We4b5KSWZ3+7A==
X-Received: by 2002:a05:620a:13fa:b0:6fa:15e3:a277 with SMTP id h26-20020a05620a13fa00b006fa15e3a277mr31606155qkl.479.1667766866351;
        Sun, 06 Nov 2022 12:34:26 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id t31-20020a05622a181f00b003a540320070sm4703551qtc.6.2022.11.06.12.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 12:34:25 -0800 (PST)
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
Subject: [PATCHv4 net-next 3/4] net: sched: call tcf_ct_params_free to free params in tcf_ct_init
Date:   Sun,  6 Nov 2022 15:34:16 -0500
Message-Id: <380dabb8c6386df41ac66324791925fc3f8594d1.1667766782.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1667766782.git.lucien.xin@gmail.com>
References: <cover.1667766782.git.lucien.xin@gmail.com>
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

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
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

