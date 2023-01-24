Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D175679F9E
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbjAXRGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbjAXRFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:05:45 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E95549575
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:21 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-4fd37a1551cso202683227b3.13
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fpBc4DdaPjPB9YwHzixoGEvX+0rT4epKln3hHMBlcWs=;
        b=Nj3JtxszHLlZiAXT1APoQBhpfuZqM99QcpYVdQaRvs4jaqsu7rGWy6vwjrEqD41zY3
         ogffe0z3BCcD7A8gv5UiY4B4j236ycgrYZ0Y7E/YF6gf/CkyWzD5ek2UcBx6AWSUf9gC
         6yQe5QZ/1MOK6KKQqjwu4saHqttmJrsUztmgEdKQ39w1oxi2oD5Kxs8GLphNA6Tdhtwq
         FPTeiU2I+g+14cLGZaIhJfo8W9DLMVkjKhJvqGyvBTO3zlXeOydGcxl946GpC8COQtEe
         l6Lwc9e1VzyCjUSjQVDSPM1qx4T1y2hJwOK8FZzEK5MGsOGj6Gklj3nwLLpQG7muoOG2
         WLiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fpBc4DdaPjPB9YwHzixoGEvX+0rT4epKln3hHMBlcWs=;
        b=b4pFBD005RVQ/vxhkjPot4R+H9zYGKPNANUF8Ss6z3x+14nwXTtxKsrxyzy/e6pvnN
         Erjh5Ps3AQ71tpgj6qP9VhygvWpR2/M2mSb0Ard+pab4b09rRJ9LMJQSvpgvsH0YgSNX
         VflWpTwsIJ+DY9NVuwm2E7EkNZNGttX/RIUPS+ZtHA5ZB7O7vWpXrRVDHjv3uKpm57dd
         WbezJ/J8X6TpA1Xo9xGr8UuCmIEeIaI2xwhSW1ROPovBSCbGQZ1Xst6x5oAEZy6AVxgp
         nPWchCj226CQmQEl8ucPJX89s577IItEUUF7t2WF7LjRLU7HhdDCxfyyiGOoZz8KLJQj
         BPpA==
X-Gm-Message-State: AFqh2kqEglTjskEZ0QSWoZQO2lVxiAtvab0XeAK0qS27fk92MZcVX+RS
        6OBYxp7gu9jeEmAIJDocsqltoRAPC09J4qzu
X-Google-Smtp-Source: AMrXdXuZRxi9Fhzt813ytfexV0PIfeCa/VIbjpPAD3SAfJkpVQE9UiYWIcEAQlqltu9OZkb0EhJcQQ==
X-Received: by 2002:a05:7500:d83:b0:f2:55f5:2508 with SMTP id kn3-20020a0575000d8300b000f255f52508mr904347gab.15.1674579915291;
        Tue, 24 Jan 2023 09:05:15 -0800 (PST)
Received: from localhost.localdomain (bras-base-kntaon1618w-grc-10-184-145-9-64.dsl.bell.ca. [184.145.9.64])
        by smtp.gmail.com with ESMTPSA id t5-20020a05620a0b0500b007063036cb03sm1700208qkg.126.2023.01.24.09.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 09:05:14 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com
Subject: [PATCH net-next RFC 04/20] net/sched: act_api: add init_ops to struct tc_action_op
Date:   Tue, 24 Jan 2023 12:04:54 -0500
Message-Id: <20230124170510.316970-4-jhs@mojatatu.com>
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

The initialisation of P4TC action instances require access to a struct p4tc_act
(which appears in later patches) to help us to retrieve information like the
dynamic action parameters etc. In order to retrieve struct p4tc_act we need the
pipeline name or id and the action name or id. The init callback from
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
index 5557c55d5..64dc75ba6 100644
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
index 2e5a6ebb1..622b8d3c5 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -951,7 +951,7 @@ int tcf_register_action(struct tc_action_ops *act,
 {
 	int ret;
 
-	if (!act->act || !act->dump || !act->init)
+	if (!act->act || !act->dump || (!act->init && !act->init_ops))
 		return -EINVAL;
 
 	/* We have to register pernet ops before making the action ops visible,
@@ -1403,8 +1403,13 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
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
2.34.1

