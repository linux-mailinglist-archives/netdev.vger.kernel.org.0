Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF5D679FA0
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbjAXRGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbjAXRGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:06:03 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5544DCCC
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:22 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-15fe106c7c7so12262490fac.8
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H39ymevul8gsuCC6zs2ZkPH3UbsWZS2CiywEUp+1ZEE=;
        b=dKqQ51KoxL35Lcnw1hrQPwMGq8cuRLcqoDMd520nPNQy+Qw/EsbStPv971aKOlxbHS
         HEILrM1KAeue1EiI7fBzOw6ih7vDCmnneORzUT+i/hy4LKCgvcOJslQtPHPalFmpA0jV
         dQOAylJsZ3rS4XSHDlTne+L9fpIpQdnFd+bGYlfIXdFJlB4pbF/sr/Em/ruzY6aiTo0x
         +YIBpwjm9pOfouLsoa9FqKyR2C8CQlBWH4NCWslH9rRocnw3Q8vx2Bhlfw8Y3JBDSdKr
         Seuq9+KMsc1LGrSyDdnmEl27JTE/OihoYH6EAMPp4yA24QjKq9GsVy+Z1wSnmlk4swaK
         PZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H39ymevul8gsuCC6zs2ZkPH3UbsWZS2CiywEUp+1ZEE=;
        b=j+KahRAQXJ6/ETvxT+WUcgqBVE0n/+BNLoLrQvaP14fjoCGC4GYqU6IDSoL414aOub
         fNDKxxNRw6cHL7JqkO9v3V5Qj4h/i8hIF90hc4NaCeEpqjF2khVTtU1bGBunNEjrjQWX
         2sRn0lKybT/xV8KpZlRyjq87bOXETrwDIbD3BsKDy1vUGm2fT2mvxFZujH0cPf2QO3gG
         kgaI2hJMNwXdQzUxSOHQWdEGpvAXKTBqJjFdYx/0L8064j5FlR+q6OoiS3POkxYrSzuQ
         CgpPbHEsmzkW8jQfksK9yadFYts/ihBZxDh8kXSsKh/UcOO+7r78QAELImiTPkhZTw22
         G1tA==
X-Gm-Message-State: AFqh2koR2KVtXSMAUjvLjJCjvZiFaaNzLj4qqkcXwqM8HNPR1NLcmWFB
        cSPNtjG1NA1xMg1JXXW5w37wPaAj2Bmj6TDZ
X-Google-Smtp-Source: AMrXdXsDbS+oQ/CxSLoiSj2Ebiu8roJu1QHctS0pVIgOIFB4sx2YtNh+rhfUnRs8OAxycJjsoCbGgg==
X-Received: by 2002:a05:6870:2809:b0:158:a50:d7c4 with SMTP id gz9-20020a056870280900b001580a50d7c4mr15409503oab.57.1674579919095;
        Tue, 24 Jan 2023 09:05:19 -0800 (PST)
Received: from localhost.localdomain (bras-base-kntaon1618w-grc-10-184-145-9-64.dsl.bell.ca. [184.145.9.64])
        by smtp.gmail.com with ESMTPSA id t5-20020a05620a0b0500b007063036cb03sm1700208qkg.126.2023.01.24.09.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 09:05:18 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com
Subject: [PATCH net-next RFC 07/20] net/sched: act_api: create and export __tcf_register_action
Date:   Tue, 24 Jan 2023 12:04:57 -0500
Message-Id: <20230124170510.316970-7-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124170510.316970-1-jhs@mojatatu.com>
References: <20230124170510.316970-1-jhs@mojatatu.com>
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

Create and export __tcf_register_action, which will register an action
without registering per net ops for it. This is necessary for dynamic
P4TC actions, which are bound to a P4 pipeline which is bound to a namespace;
for this reason they only need to store themselves in the act_base API, but
don't need to be propagated to all net namespaces.

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/act_api.h |  2 ++
 net/sched/act_api.c   | 74 +++++++++++++++++++++++++++++++++----------
 2 files changed, 60 insertions(+), 16 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 7328183b4..26d8d33f9 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -206,9 +206,11 @@ int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
 int tcf_idr_release(struct tc_action *a, bool bind);
 
 int tcf_register_action(struct tc_action_ops *a, struct pernet_operations *ops);
+int __tcf_register_action(struct tc_action_ops *a);
 struct tc_action_ops *tc_lookup_action_byid(u32 act_id);
 int tcf_unregister_action(struct tc_action_ops *a,
 			  struct pernet_operations *ops);
+int __tcf_unregister_action(struct tc_action_ops *a);
 int tcf_action_destroy(struct tc_action *actions[], int bind);
 int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 		    int nr_actions, struct tcf_result *res);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index c730078bb..628447669 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -946,18 +946,10 @@ static void tcf_pernet_del_id_list(unsigned int id)
 	mutex_unlock(&act_id_mutex);
 }
 
-int tcf_register_action(struct tc_action_ops *act,
-			struct pernet_operations *ops)
+static int tcf_register_action_pernet(struct pernet_operations *ops)
 {
 	int ret;
 
-	if (!act->act || !act->dump || (!act->init && !act->init_ops))
-		return -EINVAL;
-
-	/* We have to register pernet ops before making the action ops visible,
-	 * otherwise tcf_action_init_1() could get a partially initialized
-	 * netns.
-	 */
 	ret = register_pernet_subsys(ops);
 	if (ret)
 		return ret;
@@ -968,6 +960,17 @@ int tcf_register_action(struct tc_action_ops *act,
 			goto err_id;
 	}
 
+	return 0;
+
+err_id:
+	unregister_pernet_subsys(ops);
+	return ret;
+}
+
+int __tcf_register_action(struct tc_action_ops *act)
+{
+	int ret;
+
 	write_lock(&act_mod_lock);
 	if (act->id) {
 		if (idr_find(&act_base, act->id)) {
@@ -993,16 +996,46 @@ int tcf_register_action(struct tc_action_ops *act,
 
 err_out:
 	write_unlock(&act_mod_lock);
-	if (ops->id)
-		tcf_pernet_del_id_list(*ops->id);
+	return ret;
+}
+EXPORT_SYMBOL(__tcf_register_action);
+
+int tcf_register_action(struct tc_action_ops *act,
+			struct pernet_operations *ops)
+{
+	int ret;
+
+	if (!act->act || !act->dump || !act->init)
+		return -EINVAL;
+
+	/* We have to register pernet ops before making the action ops visible,
+	 * otherwise tcf_action_init_1() could get a partially initialized
+	 * netns.
+	 */
+	ret = tcf_register_action_pernet(ops);
+	if (ret)
+		return ret;
+
+	ret = __tcf_register_action(act);
+	if (ret < 0)
+		goto err_id;
+
+	return 0;
+
 err_id:
 	unregister_pernet_subsys(ops);
 	return ret;
 }
 EXPORT_SYMBOL(tcf_register_action);
 
-int tcf_unregister_action(struct tc_action_ops *act,
-			  struct pernet_operations *ops)
+static void tcf_unregister_action_pernet(struct pernet_operations *ops)
+{
+	unregister_pernet_subsys(ops);
+	if (ops->id)
+		tcf_pernet_del_id_list(*ops->id);
+}
+
+int __tcf_unregister_action(struct tc_action_ops *act)
 {
 	int err = 0;
 
@@ -1011,10 +1044,19 @@ int tcf_unregister_action(struct tc_action_ops *act,
 		err = -EINVAL;
 
 	write_unlock(&act_mod_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(__tcf_unregister_action);
+
+int tcf_unregister_action(struct tc_action_ops *act,
+			  struct pernet_operations *ops)
+{
+	int err;
+
+	err = __tcf_unregister_action(act);
 	if (!err) {
-		unregister_pernet_subsys(ops);
-		if (ops->id)
-			tcf_pernet_del_id_list(*ops->id);
+		tcf_unregister_action_pernet(ops);
 	}
 	return err;
 }
-- 
2.34.1

