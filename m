Return-Path: <netdev+bounces-3288-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A309A70660F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:05:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F7A12811E1
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAFF41C76D;
	Wed, 17 May 2023 11:04:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBC31DDD2
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:04:09 +0000 (UTC)
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4E86186
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:34 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id 6a1803df08f44-6216a09ec38so2595206d6.3
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321378; x=1686913378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j8rj5+UCTfweWcOpgfYjBAg1E/WAhjyZhZiEuFMhPCM=;
        b=hvK03K/ZII253uMj4S35YdyFPCJYmmUCMORDySI01hssL1ZMD5QNGCDWBYsFcmI2bH
         NzWBS/UFn4tIyy+2E2ZeE8gtxYTgUDWO9/6vvoZ7TYxGpE9rCgOv6GuPyJfo5eL/5RIW
         qBO+c7nE8UAGLIvhmPiAIGLPuNcSA1tAia5YorCsErEqlEjKVUbvdG9qo7QQLv7tHKAg
         Vp3tS79OCpw2XBVg1WF8eZi8m4XEh2S6ui9Sh+kqt8Gzah2AeKlDIC4CLaGCDRhju0FP
         C3/L0UUoDB5/8JCo/1LAZOw7uG6NMdYJ1zJ7KFSKDU/wfvuMyaS0O/qJbyA7Y/MRbq5q
         hOaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321378; x=1686913378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j8rj5+UCTfweWcOpgfYjBAg1E/WAhjyZhZiEuFMhPCM=;
        b=k8x9vJznzjjibKJHgDBhcTX4fXCF336sGh+1N1vUbNLxko9cNqzZm3d/tAtnPwFZG5
         y19GhmvEatrWorBBlUCNBVEY0P55ouJjsTnXUhf2Qa6U8heP0j0eB/AlkR3PAsiEyJhc
         A2TEDKAgepsyiix3Br4OEEFGlZPqmAs3ReA9DuGQ3FbOTrIiEHx0jWFeN1gpihlV5A8u
         uxt6wjip5l2nd9L0l3pDT9J7xl5pcF7/7AnoCW1B1XpsEOwSAOPwehY/TDcmcsa6BnwE
         83olF9Gfv2kmN20YpOGisGw2xPKJG2iK0M+FXUmQNU88BxThhyv8aTG9HQaI2wJlx2kc
         QSBg==
X-Gm-Message-State: AC+VfDwAnpkkUDH204bfFiAoD17fm6PUHTCSaBwTp9zUzlMmcWba9UsX
	giwmv7qngimWubtuWV3J4W9xWYt4bklBuywV/Fo=
X-Google-Smtp-Source: ACHHUZ5dn1QoZ+RkCBGjnp3LSVDxjgrZ0k9FIxE809OPbIGdHmiQUvXuR3bhWrQ8aWrj6BuT6CwqXg==
X-Received: by 2002:ad4:5ae9:0:b0:5cd:1adc:30e2 with SMTP id c9-20020ad45ae9000000b005cd1adc30e2mr65442308qvh.11.1684321378100;
        Wed, 17 May 2023 04:02:58 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id t9-20020a0cef09000000b0061b2a2f949bsm6212183qvr.61.2023.05.17.04.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:02:57 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 04/28] net/sched: act_api: add init_ops to struct tc_action_op
Date: Wed, 17 May 2023 07:02:08 -0400
Message-Id: <20230517110232.29349-4-jhs@mojatatu.com>
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

The initialisation of P4TC action instances require access to a struct p4tc_act
(which appears in later patches) to help us to retrieve information like the
dynamic action parameters etc. In order to retrieve struct p4tc_act we need the
pipeline name or id and the action name or id. Also recall that P4TC
action IDs are dynamic and  are net namespace specific. The init callback from
tc_action_ops parameters had no way of supplying us that information. To solve
this issue, we decided to create a new tc_action_ops callback (init_ops), that
provides us with the tc_action_ops struct which then provides us with the
pipeline and action name. In addition we add a new refcount to struct
tc_action_ops called dyn_ref, which accounts for how many action instances we
have of a specific dynamic action.

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/act_api.h |  6 ++++++
 net/sched/act_api.c   | 11 ++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index a414c0f94ff1..363f7f8b5586 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -108,6 +108,7 @@ struct tc_action_ops {
 	char    kind[ACTNAMSIZ];
 	enum tca_id  id; /* identifier should match kind */
 	unsigned int	net_id;
+	refcount_t dyn_ref;
 	size_t	size;
 	struct module		*owner;
 	int     (*act)(struct sk_buff *, const struct tc_action *,
@@ -119,6 +120,11 @@ struct tc_action_ops {
 			struct nlattr *est, struct tc_action **act,
 			struct tcf_proto *tp,
 			u32 flags, struct netlink_ext_ack *extack);
+	/* This should be merged with the original init action */
+	int     (*init_ops)(struct net *net, struct nlattr *nla,
+			    struct nlattr *est, struct tc_action **act,
+			   struct tcf_proto *tp, struct tc_action_ops *ops,
+			   u32 flags, struct netlink_ext_ack *extack);
 	int     (*walk)(struct net *, struct sk_buff *,
 			struct netlink_callback *, int,
 			const struct tc_action_ops *,
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index bc4e178873e4..0ba5a4b5db6f 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1006,7 +1006,7 @@ int tcf_register_action(struct tc_action_ops *act,
 	struct tc_action_ops *a;
 	int ret;
 
-	if (!act->act || !act->dump || !act->init)
+	if (!act->act || !act->dump || (!act->init && !act->init_ops))
 		return -EINVAL;
 
 	/* We have to register pernet ops before making the action ops visible,
@@ -1494,8 +1494,13 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 			}
 		}
 
-		err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, tp,
-				userflags.value | flags, extack);
+		if (a_o->init)
+			err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, tp,
+					userflags.value | flags, extack);
+		else if (a_o->init_ops)
+			err = a_o->init_ops(net, tb[TCA_ACT_OPTIONS], est, &a,
+					    tp, a_o, userflags.value | flags,
+					    extack);
 	} else {
 		err = a_o->init(net, nla, est, &a, tp, userflags.value | flags,
 				extack);
-- 
2.25.1


