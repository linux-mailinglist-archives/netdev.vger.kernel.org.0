Return-Path: <netdev+bounces-3289-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90139706619
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:05:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56CE81C20F33
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AB111E536;
	Wed, 17 May 2023 11:04:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004291DDD2
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:04:10 +0000 (UTC)
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964D06E91
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:34 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 6a1803df08f44-6238b15d298so1261226d6.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321385; x=1686913385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSwJ90KGk9t7LlTjCVS+Q76hji8RHtbhCmgk4rEJoeU=;
        b=s9xH/LIb2eH59Ih+TDJkNanq+0DBoUapmqDs+HV/ZBTGKYYVe+PNj9uzy7E9cd3guh
         DbL3bGr9pcln4y1mAw5k3lAyQ0h9BVuYgRpJif3LbB4G1W7CgwvyP31ZgaPwUtbn54Kv
         NkvUCuIGibi9eVmFGyCbP+XhOiHTBCuiXHLiADrmNI8IwS9iMIl1ZXMrbtRqbufOot8n
         P6yFJswC9vT1XSS1Vcm8fN/qtghmLgZnGMPBQHxoLuyLIqmDl4omVVSrtP10sB+H6Dnl
         A4TSoiwYRTIbBsMnebMinL27a5R73NcBf86u5pdNrwCPAkcNhc7f0LLMcevYSAAAmTI7
         eMRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321385; x=1686913385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gSwJ90KGk9t7LlTjCVS+Q76hji8RHtbhCmgk4rEJoeU=;
        b=bzBXN/BMA21L6NC3VNwNKtOzYeQK9dYkjXy2wm0+7+VKVjyiTK3XfYCT6umCInteSm
         TkIOO6Ud6YHeOvIKiWjmBYSnXs5/iTa+qLykNZz6maetbs9FG0JEUOhTr4KLun3iD1Y4
         akf2L4MeIwLWLdAQacan7Fzd9rMEtOJpc8X8+cFKHEBY8sM2lq5R26wDhrVtupia9Lqf
         AEMETrk3ywc7xFkqbmEB6flV2SmHKma7mLXNihx6iiOk80vCZVX65fFziA0GK2+i3eU9
         JtxyEhncgbmQ75Q8d5WWSg6d1kOLCdwXTxlCR2C+yjYmfs5qTolWTthWzioFH/uaO3kA
         NfLg==
X-Gm-Message-State: AC+VfDz6D0qemXkVBLPc/FX4f7AWwV7bJzn3eJ7s7t8Y1l/2CYFpSuxa
	BFzfX7YrUSKWZ3o3+fbTIKVYDuF2Lb99adpPbzM=
X-Google-Smtp-Source: ACHHUZ4vMrtw1oSM54OEhycYaO2j7vDoNGV7WGZfwmbus7ag8J6KsUkOrJNfbmeNc7Xm9I415e0KVg==
X-Received: by 2002:ad4:5964:0:b0:622:7b7f:ed46 with SMTP id eq4-20020ad45964000000b006227b7fed46mr28143165qvb.7.1684321385010;
        Wed, 17 May 2023 04:03:05 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id w20-20020a0cdf94000000b006237c66ae3dsm933447qvl.62.2023.05.17.04.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:03:04 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 05/28] net/sched: act_api: introduce tc_lookup_action_byid()
Date: Wed, 17 May 2023 07:02:09 -0400
Message-Id: <20230517110232.29349-5-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517110232.29349-1-jhs@mojatatu.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
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

Introduce a lookup helper to retrieve the tc_action_ops
instance given its action id.

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/act_api.h |  1 +
 net/sched/act_api.c   | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 363f7f8b5586..34b9a9ff05ee 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -205,6 +205,7 @@ int tcf_idr_release(struct tc_action *a, bool bind);
 
 int tcf_register_action(struct tc_action_ops *a, struct pernet_operations *ops);
 int tcf_register_dyn_action(struct net *net, struct tc_action_ops *act);
+struct tc_action_ops *tc_lookup_action_byid(struct net *net, u32 act_id);
 int tcf_unregister_action(struct tc_action_ops *a,
 			  struct pernet_operations *ops);
 int tcf_unregister_dyn_action(struct net *net, struct tc_action_ops *act);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 0ba5a4b5db6f..101c6debf356 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1084,6 +1084,41 @@ int tcf_unregister_dyn_action(struct net *net, struct tc_action_ops *act)
 }
 EXPORT_SYMBOL(tcf_unregister_dyn_action);
 
+/* lookup by ID */
+struct tc_action_ops *tc_lookup_action_byid(struct net *net, u32 act_id)
+{
+	struct tcf_dyn_act_net *base_net;
+	struct tc_action_ops *a, *res = NULL;
+
+	if (!act_id)
+		return NULL;
+
+	read_lock(&act_mod_lock);
+
+	list_for_each_entry(a, &act_base, head) {
+		if (a->id == act_id) {
+			if (try_module_get(a->owner)) {
+				read_unlock(&act_mod_lock);
+				return a;
+			}
+			break;
+		}
+	}
+	read_unlock(&act_mod_lock);
+
+	read_lock(&base_net->act_mod_lock);
+
+	base_net = net_generic(net, dyn_act_net_id);
+	a = idr_find(&base_net->act_base, act_id);
+	if (a && try_module_get(a->owner))
+		res = a;
+
+	read_unlock(&base_net->act_mod_lock);
+
+	return res;
+}
+EXPORT_SYMBOL(tc_lookup_action_byid);
+
 /* lookup by name */
 static struct tc_action_ops *tc_lookup_action_n(struct net *net, char *kind)
 {
-- 
2.25.1


