Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0525571CF
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiFWEkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbiFWEfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:35:06 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFC530F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:05 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-30ffc75d920so161291137b3.2
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2CUsOTdK8JALIGsuTPLTtiAjA4wcVESU0aO5OJ+gE5o=;
        b=cxmJ3M19EBvZcOkQ2fK8ZyXJxZM2h3M05KXpqCdgUDgIpMizKk/GBjRk011s28GSVS
         gy61PvyYBIZPlf+n8hK0YxqDENJi2BatbvXJqdx5p4t0jC0cDiqYH34hWgWEVj+OGAvq
         qiB6tfDGJaZKhEcZIQaNyRxLTGhmFNZHkMhJYtbPCaSmN+ycaOUbT6nFXuLrF575vsCK
         Da9rrFPjEntf+zjb7YNjefESaOmZ27QF7MOwo4qLZpSHSaLZGUoL9hqjetvtSaG/lWBy
         p2QW3asDecrYPJzVnutuoCEN0ady2JQFuUOXSKRQo+/XAigH+yjvnrpSAI6Ar8B0ZbQs
         fPTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2CUsOTdK8JALIGsuTPLTtiAjA4wcVESU0aO5OJ+gE5o=;
        b=ySnhODoZNyJ412L4xiirroZmMFA4PMSNlgkaITbOuEMgyrxe8yrFXbb7eAmPVTBkr0
         eITnMbGlW0elzsG2KxZiwKHZ7bTfJGTFc8qSWWzvZIdIQTQzg5o4rs+lVkJ0IZ1FLfT+
         iUV1c9BeC8WL92xBsn/+w9Mrw6HecwLcKv9u6JkZDPD56l3DcCIAgzzAWN5cbMQK6FBq
         TX47nGSXsK4jmv8ODr0aOH1+r4hYfSoOhTbwvugPawFjXX5oiaXHBm9sBaSfP3QV0mt5
         oi4iXVI0/728qs/eGRuFyEaHxiWRNn1A/fp1qJf9FJR0gRLUgqFujdBI2y7jIy22NBwN
         pGcw==
X-Gm-Message-State: AJIora9sbgf+ELzNCw3FJwR98zBthbJZ12DZtpEmDpGfBgEAIQtjOie9
        w4vp3QBUbQOBgabNGAk0ZxfE2cI6k4XmtQ==
X-Google-Smtp-Source: AGRyM1sY9qD6OnTK4MXwrCVaYd1GRCgIGrzrRuj9mKZ6mjD0Hwjx+7+GJcOnVgE0BMI5iivyN6/ZEb0fSccoPA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0d:f446:0:b0:318:5c8a:a41c with SMTP id
 d67-20020a0df446000000b003185c8aa41cmr5339674ywf.290.1655958904982; Wed, 22
 Jun 2022 21:35:04 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:33 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-4-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 03/19] ipmr: change igmpmsg_netlink_event() prototype
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

igmpmsg_netlink_event() first argument can be marked const.

igmpmsg_netlink_event() reads mrt->net and mrt->id,
both being set once in mr_table_alloc().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ipmr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 10371a9e78fc41e8562fa8d81222a8ae24e2fbb6..6710324497cae3bbc2fcdd12d6e1d44eed5215b3 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -110,7 +110,7 @@ static int ipmr_cache_report(struct mr_table *mrt,
 			     struct sk_buff *pkt, vifi_t vifi, int assert);
 static void mroute_netlink_event(struct mr_table *mrt, struct mfc_cache *mfc,
 				 int cmd);
-static void igmpmsg_netlink_event(struct mr_table *mrt, struct sk_buff *pkt);
+static void igmpmsg_netlink_event(const struct mr_table *mrt, struct sk_buff *pkt);
 static void mroute_clean_tables(struct mr_table *mrt, int flags);
 static void ipmr_expire_process(struct timer_list *t);
 
@@ -2410,7 +2410,7 @@ static size_t igmpmsg_netlink_msgsize(size_t payloadlen)
 	return len;
 }
 
-static void igmpmsg_netlink_event(struct mr_table *mrt, struct sk_buff *pkt)
+static void igmpmsg_netlink_event(const struct mr_table *mrt, struct sk_buff *pkt)
 {
 	struct net *net = read_pnet(&mrt->net);
 	struct nlmsghdr *nlh;
-- 
2.37.0.rc0.104.g0611611a94-goog

