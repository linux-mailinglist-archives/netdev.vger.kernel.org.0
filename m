Return-Path: <netdev+bounces-7500-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDD1872079F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:32:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09864281A67
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726901E51E;
	Fri,  2 Jun 2023 16:31:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685151E51C
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:31:46 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C44513E
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 09:31:45 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5692be06cb2so26557487b3.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 09:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685723504; x=1688315504;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ykGS0mZuZjq73XKfgE/kdQNQyD6Jh0TrgRJ837TPrg=;
        b=2YGcyCBEpJzVmmsdc+zBdQPrGSIejwKsCuFzEMXBmIcxN1QuXJ6ubmCNliDzYB9bYd
         AVhAdARGN6qUnBf76p6WDdX8/3haiJXmOu/VY6EEbaxcRRRTb0cjGZYWb3LhzOj11PfN
         Hco+gI17XKanD8fPGK04l8IbPg02YC1dhVUW18hJY10IWoXt0W/jMqmwtjOe0wkbYptQ
         8w4JT9FVa8cs2SUJNjhTs3DF0Qs5c6ZDBO57yGFdU2ExKWaQ0nLREIIDOs+0We3NfX6I
         p5DdllnD1k1f0rmlJnblR9Ax9eqzBMR9jrekZ+e4sMa/0ETjH22JKRmAMAlsTC13/JhQ
         8Xlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685723504; x=1688315504;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ykGS0mZuZjq73XKfgE/kdQNQyD6Jh0TrgRJ837TPrg=;
        b=J9zrtJligAdTPPUEDQ2mWGKnPBtY8dhCrIN1SKOZf1b4bnFBtB69q/nDUypxT/0Pa3
         LMdQXi47jJewZeOU5CpcYghNkuCbbQxf7Aai6H7Nk4pkFBK6+NeTV0JFbcEUA9t95wED
         Y8tlYPkSTlZPA1DXiSKApTsU7xBObmhLibPHbKqb2MorPMhWayNStDw5rdOihfHUKLOE
         yUDwzvvRE7i0oGZz0MDaXPwnt9WNQ4XqvglOmuz041nn6RTuKevvspwRJJM9wo4Qvy2q
         HG2OOt2YVT+4DIACPtzsZ+8edBZQ39soGFmnEStpDnQXzNTY621q3+f/ZuSURr/k3gZ+
         4tcA==
X-Gm-Message-State: AC+VfDwUTlEG/RMHg6l9/9nv5nKa3RJY/ZQvDvO1T2iR87FLPppUwtmx
	x1ae7CWIK+JiUu32qlVojxg/pELIkJDstg==
X-Google-Smtp-Source: ACHHUZ66kLoeNn5FRYkh4nh2fuESmNg8nCueJg+mH5qB/HMiBazBYpbSR1tXAp0RmuB5wIRa+p2mw1zRadeljw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:7c7:0:b0:bac:f387:735b with SMTP id
 190-20020a2507c7000000b00bacf387735bmr1208049ybh.13.1685723504550; Fri, 02
 Jun 2023 09:31:44 -0700 (PDT)
Date: Fri,  2 Jun 2023 16:31:40 +0000
In-Reply-To: <20230602163141.2115187-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230602163141.2115187-1-edumazet@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602163141.2115187-2-edumazet@google.com>
Subject: [PATCH net 1/2] rfs: annotate lockless accesses to sk->sk_rxhash
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

Add READ_ONCE()/WRITE_ONCE() on accesses to sk->sk_rxhash.

This also prevents a (smart ?) compiler to remove the condition in:

if (sk->sk_rxhash != newval)
	sk->sk_rxhash = newval;

We need the condition to avoid dirtying a shared cache line.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index b418425d7230c8cee81df34fcc66d771ea5085e9..bf71855d47feccda716b3cabf259d6055b764a3c 100644
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
+			}
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


