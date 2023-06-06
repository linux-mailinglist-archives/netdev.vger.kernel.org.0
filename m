Return-Path: <netdev+bounces-8321-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA8127239B2
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:42:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 163111C20E76
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F048417FF1;
	Tue,  6 Jun 2023 07:41:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65691C29
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:41:34 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF7810C9
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:41:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bad1c8dce48so7933083276.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 00:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686037280; x=1688629280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFjKdHmrntpuHkrgo6auPnB3E7mtl4GL225od8JlKGA=;
        b=Kx78+Au8Lg4d6sql4Ow73q/Ekz1eiJ2/riJaKLT7fuUfXz7ubA+a93vYQehCWcyc01
         7sxJ4US1tId5DdkTj33estO563J1YLPv0CbmWt2+TfAsyiir62yMUFbsTXT1fx5HiKsG
         dNna8HD9nUqoiuFr6xuimfH2Nk8bFRDzYOITw7YPd1TUv4anGPNuMKjSTDTlj/QkFmQy
         b67+oLLPeZbWf4QMxUTqYzRRId9wbIFBWY+L9qEOr5mBhtnZnp0FtIBcoX/tUWdnouLK
         3etFwtRA2NPx/kfKhh1gCV2S4biRalsPV68LpINofsZ4MV85ozEHuo2lqSR4239qUl9D
         XyWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686037280; x=1688629280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFjKdHmrntpuHkrgo6auPnB3E7mtl4GL225od8JlKGA=;
        b=e7TRWBwi4i/X6Y6qEdBHlDZaHdww1yKaLgcWpZNwZY1umaz+T/y6T4JC3Vc9sC7FcV
         QbNRRfl1Oae+uzyVLnPYxpOzLuOTaUJSDM6ad5uneIRWTn6uEaPQk38/WuBaJ/3XsDUO
         BE8eS+3VxJTqHwba/YWfSDmdHbsiDjPx9m383M4WhQgdyXkvvVhaTznX6iqZFvk73NpH
         kCaVmt/544PZsGlumCe+76d4AlUm6p5j/t8wo3MJDfKadhtIWHAsv2T6kkr/hmQ1T7it
         nNrV7/iK6YrdsjHGP7BHYMeMaC719Kqru4Q/Z2uf49v8RrX6LnJfgyDxeQhLUOUsHBMp
         BDbA==
X-Gm-Message-State: AC+VfDzZ40dlGz/IkZFBEJwYWkOMZYI8uWmv8r3SDZDFD4+2aR455vjN
	J7kSS0K4AA/QL1SyU/mcNyFscHfRiGuUnA==
X-Google-Smtp-Source: ACHHUZ5om8L5wJIeFd/KgBkNYu+d/INf1F6yn/at8bvqPg87KvfH2wf6vk5KV5JER95PvL4uURxUTk8yCMyrjQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:100c:b0:ba8:4ff5:3217 with SMTP
 id w12-20020a056902100c00b00ba84ff53217mr378080ybt.3.1686037280627; Tue, 06
 Jun 2023 00:41:20 -0700 (PDT)
Date: Tue,  6 Jun 2023 07:41:15 +0000
In-Reply-To: <20230606074115.3789733-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230606074115.3789733-1-edumazet@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230606074115.3789733-3-edumazet@google.com>
Subject: [PATCH v2 net 2/2] rfs: annotate lockless accesses to RFS sock flow table
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, 
	eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
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

Fixes: fec5e652e58f ("rfs: Receive Flow Steering")
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


