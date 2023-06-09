Return-Path: <netdev+bounces-9704-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7168672A4D4
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:43:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F41D1281A63
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12BB21B905;
	Fri,  9 Jun 2023 20:42:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080EE1B902
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 20:42:52 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B1A3583
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:42:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bb39316a68eso2734014276.0
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 13:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686343370; x=1688935370;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cQSREP2IjKt00uUNEA5aRUAvqJgOyFnzUgitnqxO9pA=;
        b=PDgtODS6/jfO4wP7+QbjJgB/lIlgoDA3VaKIUPIDNm27JVh4ct17s2gdtAb6ox3cZV
         5F/w/3fIuoUgQEtaT71CVPW58t57Fiv4zMR3XQLsf6jeCZp8MM6AmZahwihyAZKEP/5L
         QpECLyDTzp8nI2nvSIDrsIVjEmxmMXfiA6J+OXe+2xLkPUmYmiRdYtIbVxiuUMCHX/tb
         k1SvHrZQqpuH7mCCdie5FSoM6xCIbn5pwWeo6j0oqsaIy7nv263aLuPMrCcW/uc7Yehk
         y7YJQCFwhv2Oy/ZRjOxOKjZ/5n/IXv+yNs/JsPMmZlLLwi9etUuEM6SNE32rdhum0eK0
         UDoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686343370; x=1688935370;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cQSREP2IjKt00uUNEA5aRUAvqJgOyFnzUgitnqxO9pA=;
        b=DSTf4xDf9buUFY8CBIo5xKxHbm/EkGXlKUQdfho8a61K2w1DhIPGK2MqqIYB1FTjC4
         lAN9ScEK7LmlgTvdkAc+GBTA5S1803Tb63opI781ROQyc+CV/iHl/r0eWmHOemyFjT6s
         JWR8H1yJl1ozL8OiN6Pwx5kKOu6fXqGqDb11dHlTzHEThI7q0Ni72eg1t6Tm3lZZnt+/
         dyQ2rzyfpbcisl6e/vK1ZAK8i0LoUw6u08JwhXgCVZWp2krx7DPKq+uTbg7PN0cFUorn
         tgrcW+AAd8tbZQ+yR6OpkyOPxCB7DEgWGuFHMpA2a9P4BsM1raH+OCuSH/nxgdr0vSl8
         QSBg==
X-Gm-Message-State: AC+VfDyxTG6ge30o3hA9SYLY+rj9Yw/n4eKYYnLUtei5RnxGjSgqEsZO
	vJG/ih0zz7xL7Joh7/ToAhRDHjPgDrXuKQ==
X-Google-Smtp-Source: ACHHUZ7ppDWdUxGcbbPf5VU6E335aQsrlhopLiGk4GLhlt9xgi+7jiWP3IczLqZrNnEq/t1y+y1dNJLdZaQDvg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:c2:b0:bad:23f:87bd with SMTP id
 i2-20020a05690200c200b00bad023f87bdmr711229ybs.9.1686343370429; Fri, 09 Jun
 2023 13:42:50 -0700 (PDT)
Date: Fri,  9 Jun 2023 20:42:44 +0000
In-Reply-To: <20230609204246.715667-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230609204246.715667-1-edumazet@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230609204246.715667-2-edumazet@google.com>
Subject: [PATCH net-next 1/3] tcp: let tcp_send_syn_data() build headless packets
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

tcp_send_syn_data() is the last component in TCP transmit
path to put payload in skb->head.

Switch it to use page frags, so that we can remove dead
code later.

This allows to put more payload than previous implementation.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h     |  1 +
 net/ipv4/tcp.c        |  2 +-
 net/ipv4/tcp_output.c | 31 +++++++++++++++++++------------
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 49611af31bb7693cbc18cba61fe8ae2fd1d8695f..f718ed258f07caedca41d01670b1c91fc11e2233 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -333,6 +333,7 @@ int tcp_sendpage(struct sock *sk, struct page *page, int offset, size_t size,
 int tcp_sendpage_locked(struct sock *sk, struct page *page, int offset,
 			size_t size, int flags);
 int tcp_send_mss(struct sock *sk, int *size_goal, int flags);
+int tcp_wmem_schedule(struct sock *sk, int copy);
 void tcp_push(struct sock *sk, int flags, int mss_now, int nonagle,
 	      int size_goal);
 void tcp_release_cb(struct sock *sk);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 09f03221a6f1597114162360a4c1aeed0758812d..da7f156d9fad93b0ab97cd52bc9e7f9cd3822ea2 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -957,7 +957,7 @@ static int tcp_downgrade_zcopy_pure(struct sock *sk, struct sk_buff *skb)
 }
 
 
-static int tcp_wmem_schedule(struct sock *sk, int copy)
+int tcp_wmem_schedule(struct sock *sk, int copy)
 {
 	int left;
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f8ce77ce7c3ef783717e60cce03d70aa10a4b9a8..d0396633735932857e131709a893b2a811fe4bd6 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3802,8 +3802,9 @@ static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_fastopen_request *fo = tp->fastopen_req;
-	int space, err = 0;
+	struct page_frag *pfrag = sk_page_frag(sk);
 	struct sk_buff *syn_data;
+	int space, err = 0;
 
 	tp->rx_opt.mss_clamp = tp->advmss;  /* If MSS is not cached */
 	if (!tcp_fastopen_cookie_check(sk, &tp->rx_opt.mss_clamp, &fo->cookie))
@@ -3822,25 +3823,31 @@ static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
 
 	space = min_t(size_t, space, fo->size);
 
-	/* limit to order-0 allocations */
-	space = min_t(size_t, space, SKB_MAX_HEAD(MAX_TCP_HEADER));
-
-	syn_data = tcp_stream_alloc_skb(sk, space, sk->sk_allocation, false);
+	if (space &&
+	    !skb_page_frag_refill(min_t(size_t, space, PAGE_SIZE),
+				  pfrag, sk->sk_allocation))
+		goto fallback;
+	syn_data = tcp_stream_alloc_skb(sk, 0, sk->sk_allocation, false);
 	if (!syn_data)
 		goto fallback;
 	memcpy(syn_data->cb, syn->cb, sizeof(syn->cb));
 	if (space) {
-		int copied = copy_from_iter(skb_put(syn_data, space), space,
-					    &fo->data->msg_iter);
-		if (unlikely(!copied)) {
+		space = min_t(size_t, space, pfrag->size - pfrag->offset);
+		space = tcp_wmem_schedule(sk, space);
+	}
+	if (space) {
+		space = copy_page_from_iter(pfrag->page, pfrag->offset,
+					    space, &fo->data->msg_iter);
+		if (unlikely(!space)) {
 			tcp_skb_tsorted_anchor_cleanup(syn_data);
 			kfree_skb(syn_data);
 			goto fallback;
 		}
-		if (copied != space) {
-			skb_trim(syn_data, copied);
-			space = copied;
-		}
+		skb_fill_page_desc(syn_data, 0, pfrag->page,
+				   pfrag->offset, space);
+		page_ref_inc(pfrag->page);
+		pfrag->offset += space;
+		skb_len_add(syn_data, space);
 		skb_zcopy_set(syn_data, fo->uarg, NULL);
 	}
 	/* No more data pending in inet_wait_for_connect() */
-- 
2.41.0.162.gfafddb0af9-goog


