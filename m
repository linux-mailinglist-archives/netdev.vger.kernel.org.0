Return-Path: <netdev+bounces-3291-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1110B70661D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:06:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0FE61C20F17
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0251EA87;
	Wed, 17 May 2023 11:04:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913331DDD2
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:04:13 +0000 (UTC)
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4FE198
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:37 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 3f1490d57ef6-ba829e17aacso799382276.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321399; x=1686913399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S+26kp6BBlBA/n28soCu1j/nI6xVz9eGfj+7N+7l2YI=;
        b=wHYOqKxF/IzjExrl10BWrpJ6sZ5WhmW5Y+PG8B31YFKv2qJbbXkBlmey2E05rRXvJ/
         VBOqajAGiZ7yr74j+k1dqTQqfEbUy9K7BKEKrunKwprpXSY0rrayygYAuUdVpv4j9TjK
         A0IwzElYfGNDTCpMZs7U+4fG9kJ/pVuHcgvu3Xk2CdMkg/z3/BmpWZ1NIFeWx5XpKgdL
         NJkJ2Gciu/8vRj8LdJUj2lHlwfBTDGwB1goikPczZmmU85fm+TcI2+vQtJu7ATNS+4BA
         cwQnQ3nUzggWLUbjcdj43QWdm341TNojS1vhmRyg27z/4yeooSB3lloANZA6A0/d8Zx2
         zwnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321399; x=1686913399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S+26kp6BBlBA/n28soCu1j/nI6xVz9eGfj+7N+7l2YI=;
        b=c27V4mUgmh53DxqXKdnYz91D+/L5EDwaag3o4NyFuVMCHjCX3FswzSGVhc/+Go/jxN
         Wh6bleE75C4VzIkOIxVj1S64vWZHDCoy5zpABrG1iHcPPC7AyupbxBEGNUfxAGBtuma3
         QAJ6bVTLr4UEqG/YVx77sJQXRUXVQqNeJ7a4a28aLu9qEH3pwFuPM5gwgu/KeB7y7gOC
         QlWNZ9QdDdsw2im3s5NpDM1OHYLOxGOMG1hs50tmBPtpth8W1iexFQnBG3KSPoHnLPuV
         4qznFCiX7roxsriWYuYfrH5wY8uO/8J5su5B+A6yn6ghIMn7le7I95olw5Sowpf4SyU4
         VTsw==
X-Gm-Message-State: AC+VfDzmt0EkrnOXUnERa63ZwLWJVhSKG+JFxEXVDbUZ5kXhJ5tXRINX
	5y1Kz8D6z09PV0s+J8jUW92fK8ejJwVG5uEhaNA=
X-Google-Smtp-Source: ACHHUZ6UIAmjwPS0y8VBNeQnQYxqczaHk7IG6xBqXABBxm4aQ4eXkGqmZQRW8SxCnO5l0Of6idGmXw==
X-Received: by 2002:a25:3486:0:b0:ba6:7d34:2b54 with SMTP id b128-20020a253486000000b00ba67d342b54mr17698596yba.31.1684321399048;
        Wed, 17 May 2023 04:03:19 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id c22-20020a05620a135600b00758ae50d7ebsm516370qkl.123.2023.05.17.04.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:03:18 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 07/28] net/sched: act_api: add struct p4tc_action_ops as a parameter to lookup callback
Date: Wed, 17 May 2023 07:02:11 -0400
Message-Id: <20230517110232.29349-7-jhs@mojatatu.com>
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

For P4TC dynamic actions, we require information from struct tc_action_ops,
specifically the action kind, to find and locate the dynamic action
information for the lookup operation.

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/act_api.h | 3 ++-
 net/sched/act_api.c   | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index cc392b994844..a0f443990f27 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -115,7 +115,8 @@ struct tc_action_ops {
 		       struct tcf_result *); /* called under RCU BH lock*/
 	int     (*dump)(struct sk_buff *, struct tc_action *, int, int);
 	void	(*cleanup)(struct tc_action *);
-	int     (*lookup)(struct net *net, struct tc_action **a, u32 index);
+	int     (*lookup)(struct net *net, const struct tc_action_ops *ops,
+			  struct tc_action **a, u32 index);
 	int     (*init)(struct net *net, struct nlattr *nla,
 			struct nlattr *est, struct tc_action **act,
 			struct tcf_proto *tp,
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index ba0315e686bf..788127329d96 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -728,7 +728,7 @@ int __tcf_idr_search(struct net *net, const struct tc_action_ops *ops,
 	struct tc_action_net *tn = net_generic(net, ops->net_id);
 
 	if (unlikely(ops->lookup))
-		return ops->lookup(net, a, index);
+		return ops->lookup(net, ops, a, index);
 
 	return tcf_idr_search(tn, a, index);
 }
-- 
2.25.1


