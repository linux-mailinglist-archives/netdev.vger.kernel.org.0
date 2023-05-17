Return-Path: <netdev+bounces-3290-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8281670661A
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:06:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23AC11C20F36
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A8D21EA72;
	Wed, 17 May 2023 11:04:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFC51DDD2
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:04:12 +0000 (UTC)
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEB3FE
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:36 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id d75a77b69052e-3f4f47336bcso3941681cf.3
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321392; x=1686913392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ftpqq5gYPC2d4GxsLutQJxqbX8zDHS3zETPrp3Oo54=;
        b=2vT/tsv8MDGxjyk08tK+V9R9RRqE+gk0caHzUlHxMySsVmcymyjkeO0QgSlbHr+HxV
         Uj97H3RgEux6uACs9czlj15QVUtIZyPjuSh7j7Y7NKJEk451svE/uzXaTew7EGhDAa7G
         zrf2fbvuebDMcEnRdHfknKdguDp2pQBLbdinGCEdk8wSr7exSXb2LKL1a5JSn7LfiqIL
         sYB/ucy18dCVFAQjDerQ1H7KMUEKFTqsIlCo1nVjQZyS/0eeISpxlqIUB6kBMFK7Fr2e
         qvSL54lC/YVTG0+z5gFnCKZKTO/64gMOttXFPuAglQ5R4qsEblzaGygBxp38HWHZ6H5K
         ebRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321392; x=1686913392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ftpqq5gYPC2d4GxsLutQJxqbX8zDHS3zETPrp3Oo54=;
        b=UtMqpGp1f3TpyIUFSmO825cjR2ZYGFpekrkAbC7TZuEcdToRxHBUOeNwBNxGKxqvTx
         NXVYbVKYAqnCBQTi9HgwlmiRgBSl0xNimJMBK9ram6A5IzXiprVTyDLSCaY+T9m9VTPu
         pJP9lk1w9JyyA5HxSGu/Mq9UOdfqK4gQ1bwjXUoTSpoET4O2OBlA3GbOrOE7xAV6fVhB
         YHe8KDmsuAcebMjlgGPYMeMsC7Cm/vvRE7EkI8CvjOY4QvmJl/UVUlPYLaj9e2+iCRjm
         r7+kw0aL04/i+a8OJTLn+t06UtI7YqXyZ7SiKRZsugfuAxAIeyQZQUKrAPbsWTXsA0Sb
         z6XA==
X-Gm-Message-State: AC+VfDxhpHXnKMXfBZNgCl7trBstPAD9VMyhdk9i1V8yQoIIqcyU3WjL
	mrj+OFUDhASzTZlMsavdQ2XK77OI38P4m+6Z5lU=
X-Google-Smtp-Source: ACHHUZ7EI5rm5DDi6djx45RkmjWHPWR08NyCLQCWL3DFW8rmDn17wwcOFK+PehwpdQBbndWvFg8evw==
X-Received: by 2002:a05:622a:144a:b0:3f5:aa8e:cae0 with SMTP id v10-20020a05622a144a00b003f5aa8ecae0mr3591244qtx.61.1684321391944;
        Wed, 17 May 2023 04:03:11 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id m9-20020ac84449000000b003f68223f7d7sm225925qtn.8.2023.05.17.04.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:03:11 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 06/28] net/sched: act_api: export generic tc action searcher
Date: Wed, 17 May 2023 07:02:10 -0400
Message-Id: <20230517110232.29349-6-jhs@mojatatu.com>
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

In P4TC we need to query the tc actions directly in a net namespace.
Therefore export __tcf_idr_search().

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/act_api.h | 2 ++
 net/sched/act_api.c   | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 34b9a9ff05ee..cc392b994844 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -190,6 +190,8 @@ int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
 		       const struct tc_action_ops *ops,
 		       struct netlink_ext_ack *extack);
 int tcf_idr_search(struct tc_action_net *tn, struct tc_action **a, u32 index);
+int __tcf_idr_search(struct net *net, const struct tc_action_ops *ops,
+		     struct tc_action **a, u32 index);
 int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 		   struct tc_action **a, const struct tc_action_ops *ops,
 		   int bind, bool cpustats, u32 flags);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 101c6debf356..ba0315e686bf 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -722,9 +722,8 @@ static int __tcf_generic_walker(struct net *net, struct sk_buff *skb,
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
-static int __tcf_idr_search(struct net *net,
-			    const struct tc_action_ops *ops,
-			    struct tc_action **a, u32 index)
+int __tcf_idr_search(struct net *net, const struct tc_action_ops *ops,
+		     struct tc_action **a, u32 index)
 {
 	struct tc_action_net *tn = net_generic(net, ops->net_id);
 
@@ -733,6 +732,7 @@ static int __tcf_idr_search(struct net *net,
 
 	return tcf_idr_search(tn, a, index);
 }
+EXPORT_SYMBOL(__tcf_idr_search);
 
 static int tcf_idr_delete_index(struct tcf_idrinfo *idrinfo, u32 index)
 {
-- 
2.25.1


