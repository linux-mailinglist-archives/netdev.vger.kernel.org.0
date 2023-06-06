Return-Path: <netdev+bounces-8320-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A315A723998
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:41:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F17F2813B0
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:41:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7FE2261D0;
	Tue,  6 Jun 2023 07:41:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5821C29
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:41:30 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BEFE5F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:41:19 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba8337ade1cso9169780276.2
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 00:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686037279; x=1688629279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lb2n4ay5TpH566lNUz/WA5Jzkxx0IeiwxNxWilmEoQM=;
        b=due6NnmssZoM8X7ZNauFJxDoxDhFjEJhMqa/TVO9YlJo0GgMrYsO3grl47fHw30kRA
         nSavWB2PmHdbd+rwWe3ZddYvqYMqgZfwthMWrIliOIfc+NR7g5qYWlQRupDHPkJc6Wr5
         W3U07DcU3QRD9Sx5tLDWyVakY9MXkhkxfyfP5H9zK3dw84vA3zRe5hN28KGEAX+Sy3cR
         IOmr5e6XQQYOzfIhxKAnepXyUoYgjFDawHxetN0mxM8CML6g/lsM5Q8YVqfzWdUvrlho
         PzPuet7XGGscZ/RSb3xRLrmmnnh1seISagwF47C0G28shxujMZpFnp71iAOmfAueotGA
         BUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686037279; x=1688629279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lb2n4ay5TpH566lNUz/WA5Jzkxx0IeiwxNxWilmEoQM=;
        b=XoS7DvypCm/EY/vMD+5R5MGA8l211GNRtKRFDtXZmzQHaTiZgZ/y2g3DEhemNsfGuB
         1oW75veejebC75LmhQ70zXFVJ1sGg8fEpG+oIE7wzg5XrPQCnbTrTAfHxuJ1XLgCbOpf
         JSwLC9mrd8tZpS7azEpwqjHPZSvMf2Bix2yD9vRUu1WkdLN0TpeErobRsmtmxyDLHSbM
         lrljrEtiIUt9p/7grRKDuFuYK2IPKXBM4Px5/ONEJB8S1AD408WA0otj1w6p+q4NpO+A
         QEEIFeoBaDAGLaAIbtC+bPBOe46ZxMV6PrHxKkBvWaTvr04hWaYQvCe6zo/fdrqgS0kT
         sx1g==
X-Gm-Message-State: AC+VfDwChONB5dyjR++7h/3xZLNL9LQ1XNAYfUtQL99XgO0mspGXs4BL
	aNVXAFLqk5SQTHzE+JCZe/51SXHnSDT1gQ==
X-Google-Smtp-Source: ACHHUZ7Pld4xnrv0B/oLAaYc9QsBOYmIQAkS3rSCupKr/05WVRriSNIdGaC9F7lE2TLK+JlVa4uIfDOqlqd2Qg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1896:b0:b9d:d623:1960 with SMTP
 id cj22-20020a056902189600b00b9dd6231960mr407737ybb.0.1686037279040; Tue, 06
 Jun 2023 00:41:19 -0700 (PDT)
Date: Tue,  6 Jun 2023 07:41:14 +0000
In-Reply-To: <20230606074115.3789733-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230606074115.3789733-1-edumazet@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230606074115.3789733-2-edumazet@google.com>
Subject: [PATCH v2 net 1/2] rfs: annotate lockless accesses to sk->sk_rxhash
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

Add READ_ONCE()/WRITE_ONCE() on accesses to sk->sk_rxhash.

This also prevents a (smart ?) compiler to remove the condition in:

if (sk->sk_rxhash != newval)
	sk->sk_rxhash = newval;

We need the condition to avoid dirtying a shared cache line.

Fixes: fec5e652e58f ("rfs: Receive Flow Steering")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index b418425d7230c8cee81df34fcc66d771ea5085e9..6f428a7f356755e73852c0e0006f2eb533fc7f57 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1152,8 +1152,12 @@ static inline void sock_rps_record_flow(const struct sock *sk)
 		 * OR	an additional socket flag
 		 * [1] : sk_state and sk_prot are in the same cache line.
 		 */
-		if (sk->sk_state == TCP_ESTABLISHED)
-			sock_rps_record_flow_hash(sk->sk_rxhash);
+		if (sk->sk_state == TCP_ESTABLISHED) {
+			/* This READ_ONCE() is paired with the WRITE_ONCE()
+			 * from sock_rps_save_rxhash() and sock_rps_reset_rxhash().
+			 */
+			sock_rps_record_flow_hash(READ_ONCE(sk->sk_rxhash));
+		}
 	}
 #endif
 }
@@ -1162,15 +1166,19 @@ static inline void sock_rps_save_rxhash(struct sock *sk,
 					const struct sk_buff *skb)
 {
 #ifdef CONFIG_RPS
-	if (unlikely(sk->sk_rxhash != skb->hash))
-		sk->sk_rxhash = skb->hash;
+	/* The following WRITE_ONCE() is paired with the READ_ONCE()
+	 * here, and another one in sock_rps_record_flow().
+	 */
+	if (unlikely(READ_ONCE(sk->sk_rxhash) != skb->hash))
+		WRITE_ONCE(sk->sk_rxhash, skb->hash);
 #endif
 }
 
 static inline void sock_rps_reset_rxhash(struct sock *sk)
 {
 #ifdef CONFIG_RPS
-	sk->sk_rxhash = 0;
+	/* Paired with READ_ONCE() in sock_rps_record_flow() */
+	WRITE_ONCE(sk->sk_rxhash, 0);
 #endif
 }
 
-- 
2.41.0.rc0.172.g3f132b7071-goog


