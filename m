Return-Path: <netdev+bounces-9705-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2A0672A4DB
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:43:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C7A3281A83
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:43:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FD5D1E500;
	Fri,  9 Jun 2023 20:42:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DA81B902
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 20:42:54 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F053584
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:42:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba8c3186735so2778158276.3
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 13:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686343372; x=1688935372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mnOHGdVAoFxRsL1qunGJo2mCHrEl0ykyVupOVQwR7Fs=;
        b=0ZTqMlJIqKcGwzNcIfdOfQkceoGSrXVJtSPWbbWPkGCmLG9ZELymVo++Aao7+zkJyK
         JOc+NIIiSr4JIDi3fdGgq19wa9s61Y1oHy37crmnlP+ZvgOTZc2R7YeJqd2hYi12Ytdr
         ZU5zKiYkTsf0O80RTtrJPddp+jRfljYWG2PB9JDrkMTEVcnm8/wVxQvJTR3kvdz9MUaV
         bqVJ8mMQaoT37Ha+tFG5MSr63JvNkFSg7PM9KjJQ9Tb1Vkd8bsdCmV7kYMmIb4v3kjaY
         YxrcBGJ/PdsFBEr0AeQnXd9EmGW6+UIsV1edqz1fu8m9Mp8/CzApIrArxbJVX5C81ELX
         POKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686343372; x=1688935372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mnOHGdVAoFxRsL1qunGJo2mCHrEl0ykyVupOVQwR7Fs=;
        b=Tp2AwtvQRfv1s6U63LMGFbYLHMOZPPp8MzsXRZPZ/B27zcVpf90l+4B9ngeMsCPRhv
         NWOMSoNdi4qy2Cnr+4+lMLcRPBIusFfQoWAe4vUFP0v1SeGa+/C2wpj8ADBdIU9053pJ
         fxR7Lslfb5CvTlz5t+jj8+5UkRh4Ko9cJttTVnQOG9R7t6tVB1avaptwrrVjXU+K8zUz
         55zQsp0fygM6WcV3OJvLOg9y4626KJlU+fguASTdH+mYUGMUxvqt9spS5dFA7+69E81g
         m85CPUbE2G3R8tT0bc3fwuCDPDS293cKb/Kuxb4ar7ryjmYY7S5bx5pjLTSXQ3wsl10X
         a/cg==
X-Gm-Message-State: AC+VfDxJdzPLrkd15w3NHaSS+gwad2WPW5rVpgo892kSbXtQjPyujIvZ
	noiEO4K43ZKsWwPWUGteERobfXIDGxuAhg==
X-Google-Smtp-Source: ACHHUZ7nUeCLO1zCGT6jgP+39JqVAYCmc03xOl97vpyIZWUe7X/xgkOajBp4DEZKOx4ttwvFQU0HSv4nYUMG9g==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:ab62:0:b0:ba8:8ec4:db50 with SMTP id
 u89-20020a25ab62000000b00ba88ec4db50mr654129ybi.1.1686343372080; Fri, 09 Jun
 2023 13:42:52 -0700 (PDT)
Date: Fri,  9 Jun 2023 20:42:45 +0000
In-Reply-To: <20230609204246.715667-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230609204246.715667-1-edumazet@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230609204246.715667-3-edumazet@google.com>
Subject: [PATCH net-next 2/3] tcp: remove some dead code
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

Now all skbs in write queue do not contain any payload in skb->head,
we can remove some dead code.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_output.c | 40 ++++++++++++----------------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index d0396633735932857e131709a893b2a811fe4bd6..fedbe842abdd027a95f2ac7960185fd2906a04bc 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1530,7 +1530,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *buff;
-	int nsize, old_factor;
+	int old_factor;
 	long limit;
 	int nlen;
 	u8 flags;
@@ -1538,9 +1538,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 	if (WARN_ON(len > skb->len))
 		return -EINVAL;
 
-	nsize = skb_headlen(skb) - len;
-	if (nsize < 0)
-		nsize = 0;
+	DEBUG_NET_WARN_ON_ONCE(skb_headlen(skb));
 
 	/* tcp_sendmsg() can overshoot sk_wmem_queued by one full size skb.
 	 * We need some allowance to not penalize applications setting small
@@ -1560,7 +1558,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 		return -ENOMEM;
 
 	/* Get a new skb... force flag on. */
-	buff = tcp_stream_alloc_skb(sk, nsize, gfp, true);
+	buff = tcp_stream_alloc_skb(sk, 0, gfp, true);
 	if (!buff)
 		return -ENOMEM; /* We'll just try again later. */
 	skb_copy_decrypted(buff, skb);
@@ -1568,7 +1566,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 
 	sk_wmem_queued_add(sk, buff->truesize);
 	sk_mem_charge(sk, buff->truesize);
-	nlen = skb->len - len - nsize;
+	nlen = skb->len - len;
 	buff->truesize += nlen;
 	skb->truesize -= nlen;
 
@@ -1626,13 +1624,7 @@ static int __pskb_trim_head(struct sk_buff *skb, int len)
 	struct skb_shared_info *shinfo;
 	int i, k, eat;
 
-	eat = min_t(int, len, skb_headlen(skb));
-	if (eat) {
-		__skb_pull(skb, eat);
-		len -= eat;
-		if (!len)
-			return 0;
-	}
+	DEBUG_NET_WARN_ON_ONCE(skb_headlen(skb));
 	eat = len;
 	k = 0;
 	shinfo = skb_shinfo(skb);
@@ -1671,12 +1663,10 @@ int tcp_trim_head(struct sock *sk, struct sk_buff *skb, u32 len)
 
 	TCP_SKB_CB(skb)->seq += len;
 
-	if (delta_truesize) {
-		skb->truesize	   -= delta_truesize;
-		sk_wmem_queued_add(sk, -delta_truesize);
-		if (!skb_zcopy_pure(skb))
-			sk_mem_uncharge(sk, delta_truesize);
-	}
+	skb->truesize	   -= delta_truesize;
+	sk_wmem_queued_add(sk, -delta_truesize);
+	if (!skb_zcopy_pure(skb))
+		sk_mem_uncharge(sk, delta_truesize);
 
 	/* Any change of skb->len requires recalculation of tso factor. */
 	if (tcp_skb_pcount(skb) > 1)
@@ -2126,9 +2116,7 @@ static int tso_fragment(struct sock *sk, struct sk_buff *skb, unsigned int len,
 	u8 flags;
 
 	/* All of a TSO frame must be composed of paged data.  */
-	if (skb->len != skb->data_len)
-		return tcp_fragment(sk, TCP_FRAG_IN_WRITE_QUEUE,
-				    skb, len, mss_now, gfp);
+	DEBUG_NET_WARN_ON_ONCE(skb->len != skb->data_len);
 
 	buff = tcp_stream_alloc_skb(sk, 0, gfp, true);
 	if (unlikely(!buff))
@@ -2487,12 +2475,8 @@ static int tcp_mtu_probe(struct sock *sk)
 		} else {
 			TCP_SKB_CB(nskb)->tcp_flags |= TCP_SKB_CB(skb)->tcp_flags &
 						   ~(TCPHDR_FIN|TCPHDR_PSH);
-			if (!skb_shinfo(skb)->nr_frags) {
-				skb_pull(skb, copy);
-			} else {
-				__pskb_trim_head(skb, copy);
-				tcp_set_skb_tso_segs(skb, mss_now);
-			}
+			__pskb_trim_head(skb, copy);
+			tcp_set_skb_tso_segs(skb, mss_now);
 			TCP_SKB_CB(skb)->seq += copy;
 		}
 
-- 
2.41.0.162.gfafddb0af9-goog


