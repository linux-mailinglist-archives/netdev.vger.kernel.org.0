Return-Path: <netdev+bounces-7501-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F15BD7207A1
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:32:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C5281C21227
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 937411EA9F;
	Fri,  2 Jun 2023 16:31:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CCD1EA9B
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:31:48 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BA6194
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 09:31:46 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-565d1b86a64so30545537b3.3
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 09:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685723506; x=1688315506;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=57MXj3/H9RSkFTRrQoRMmiLMzWFmPoS/vFw7oSzKDy0=;
        b=WS1vRDLLr0PwfCuRa6QcHyp5NX4WuBEBopELLBTm9qKDYR5IKOmiz95xdrbJ+7xXkh
         eXpmfFe736UBizAqr/pq5Q2iDvXYukPDsOH6BhuIqxqHY9n7XqB5RPC9ul76PKxDO/Oc
         32cPJB5Ni42M1C+7tB6xvtdWqAlUpznPceKsrRTtXZsKCr9eeMb+tukcMLn5V+5gYoST
         IdssAE+lZCPxOKo0JhNyN73xtF1Wh8KaPDp6aInS0Bxz1wW5olIcMwou2q1FrYgYaOlC
         a4r0jm9ebfr0TTn/Txr8sD+7Hddb43oOPxEs9KyDEkCowhMnvkFKY958ZZO/fUXNqhJ9
         LB7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685723506; x=1688315506;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=57MXj3/H9RSkFTRrQoRMmiLMzWFmPoS/vFw7oSzKDy0=;
        b=AtuR+53ctGrlzbR0c/Oln8g9zrY4P9YntcqZpe7ok31jl2E9GjSCK0E7PxeicY+C/V
         tznxeB3RI6bCeaTCKdKZxAUUqJ34PjyqqgAnHQ4dyjRXVE3KtAe5necZSj8A9A5Vw73f
         iZh9SVWw4klchgFWC0q70YgdyUzZc6g9atbvRt8QsL+n8S8xNGmjTDOHyAbO6kfeLwB5
         0WS9rowjhV9gFbioUCbNuo6CO7UY2xXjdS7Ti62JgEneutuUu5+vZzgMmEcVePHVGmTd
         Y/Lt2TG7Y8k+y9G21e/iTcyYVqnVjmQE4BxQSFPRnihUIVtF72KfpXap6YNDlswX1BPo
         3Vig==
X-Gm-Message-State: AC+VfDzQPD8ZUZV/5MjW4yVvdJ0EypsQ9kCh/1Yw4qESGkjzLE4/owGj
	rdpYQpiOceRbd3RR1vt1NKgKqAO1I+/xAQ==
X-Google-Smtp-Source: ACHHUZ73nqC9QAfdBDYCsuNahCW5nEzAIehgJhTt857DS0lG/sc0/POiZuHk7o9WVin64y++KLKqGRj10eIiPw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:af62:0:b0:568:f589:2b4e with SMTP id
 x34-20020a81af62000000b00568f5892b4emr264910ywj.0.1685723506028; Fri, 02 Jun
 2023 09:31:46 -0700 (PDT)
Date: Fri,  2 Jun 2023 16:31:41 +0000
In-Reply-To: <20230602163141.2115187-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230602163141.2115187-1-edumazet@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602163141.2115187-3-edumazet@google.com>
Subject: [PATCH net 2/2] rfs: annotate lockless accesses to RFS sock flow table
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add READ_ONCE()/WRITE_ONCE() on accesses to the sock flow table.

This also prevents a (smart ?) compiler to remove the condition in:

if (table->ents[index] != newval)
        table->ents[index] = newval;

We need the condition to avoid dirtying a shared cache line.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 7 +++++--
 net/core/dev.c            | 6 ++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 08fbd4622ccf731daaee34ad99773d6dc2e82fa6..e6f22b7403d014a2cf4d81d931109a594ce1398e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -768,8 +768,11 @@ static inline void rps_record_sock_flow(struct rps_sock_flow_table *table,
 		/* We only give a hint, preemption can change CPU under us */
 		val |= raw_smp_processor_id();
 
-		if (table->ents[index] != val)
-			table->ents[index] = val;
+		/* The following WRITE_ONCE() is paired with the READ_ONCE()
+		 * here, and another one in get_rps_cpu().
+		 */
+		if (READ_ONCE(table->ents[index]) != val)
+			WRITE_ONCE(table->ents[index], val);
 	}
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index b3c13e0419356b943e90b1f46dd7e035c6ec1a9c..1495f8aff288e944c8cab21297f244a6fcde752f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4471,8 +4471,10 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 		u32 next_cpu;
 		u32 ident;
 
-		/* First check into global flow table if there is a match */
-		ident = sock_flow_table->ents[hash & sock_flow_table->mask];
+		/* First check into global flow table if there is a match.
+		 * This READ_ONCE() pairs with WRITE_ONCE() from rps_record_sock_flow().
+		 */
+		ident = READ_ONCE(sock_flow_table->ents[hash & sock_flow_table->mask]);
 		if ((ident ^ hash) & ~rps_cpu_mask)
 			goto try_rps;
 
-- 
2.41.0.rc0.172.g3f132b7071-goog


