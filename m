Return-Path: <netdev+bounces-9706-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1679A72A4E0
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:43:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51D4E1C2118C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8762E1E514;
	Fri,  9 Jun 2023 20:42:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7552B1B902
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 20:42:56 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10D32D7C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:42:54 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb397723627so2638639276.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 13:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686343374; x=1688935374;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5mGIknPiNpVJCDj5zjG6P1QgIWrS0Jhg4SkZk7u1X18=;
        b=g/8z30ELirl9SesuQdLPpYJdoYWCW5OToABsBvOrEx+ZCixT5fYPlmeSXEFfn855zM
         hLhouiZJekP5TOl0+eInOf4n6nBqKqy77cMdSJcz66bct980L7rF+N1jG5bIILVg3XOD
         SU6+KZ6QpzTiCUNjtRzdmTeDnMrOSdrXLKkAPsd/itjBfB+sJV8IneBeqOPqaZRUgqtH
         nIu5D/QAGvSsdJFibC1xnXKjsSubjMa9pY2CEEhxTdm+WdHJ4cKPZxV4NgPaRe0sezJ0
         BO0+F//hq2TWs0kk/0OVbi2X5R+bCxCRWrjhGc9QheYao0yaFfBJa0RPrxqTnpmMZfo4
         cQUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686343374; x=1688935374;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5mGIknPiNpVJCDj5zjG6P1QgIWrS0Jhg4SkZk7u1X18=;
        b=S9eGkjd8BXYM6ncj142SKerCkBsrF5x8wYyAIdAZfeKiyZhkbItGa4bsdrGP6uhwNl
         91Zyg3j8apkxsSDYKBt9tHNeTwFHMTfLFIT5G2id77CIi5Ct14kPDV7k0ZxEdXrLO012
         NXst1OdvrCZR4T9qOaXAImrnWpocVfFtB4Bkyx3HghUVIHioG4XMtNKaUz7x26NeE3uE
         uSoga4czb/rrK8pkixp0hNpUeEbUFR3D6744KREOj3doz2vsQ9TAIIlZGFHv2iwVI42M
         q4V3ZlDFYaa06PvZzOHgzkCj5C1tUvD69dWZCvmF383D5TaIKt29gbo1A7DY31ZEwzl9
         1LVw==
X-Gm-Message-State: AC+VfDyNhiMOotQWiSulyp2j4ZTAzjpyV8Q8pspSH31kD4IwhirWG8A/
	pqwdfEhtIeDn0FTO3j65EbRNES8GfbqyLg==
X-Google-Smtp-Source: ACHHUZ4gVRNwJMVyIcKP4lFCKEd4o5IK0ajslO9jtinD+92vfIwfagReY2hV4Y9ZYEtbQjhkluLsMWqt6trilw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:b10:0:b0:bc2:3b92:316e with SMTP id
 16-20020a250b10000000b00bc23b92316emr375387ybl.4.1686343373847; Fri, 09 Jun
 2023 13:42:53 -0700 (PDT)
Date: Fri,  9 Jun 2023 20:42:46 +0000
In-Reply-To: <20230609204246.715667-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230609204246.715667-1-edumazet@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230609204246.715667-4-edumazet@google.com>
Subject: [PATCH net-next 3/3] tcp: remove size parameter from tcp_stream_alloc_skb()
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

Now all tcp_stream_alloc_skb() callers pass @size == 0, we can
remove this parameter.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h     |  2 +-
 net/ipv4/tcp.c        |  6 +++---
 net/ipv4/tcp_output.c | 10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index f718ed258f07caedca41d01670b1c91fc11e2233..bf9f56225821fbb0b7a377b51b3b597b95985b4c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -350,7 +350,7 @@ void tcp_twsk_purge(struct list_head *net_exit_list, int family);
 ssize_t tcp_splice_read(struct socket *sk, loff_t *ppos,
 			struct pipe_inode_info *pipe, size_t len,
 			unsigned int flags);
-struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
+struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, gfp_t gfp,
 				     bool force_schedule);
 
 void tcp_enter_quickack_mode(struct sock *sk, unsigned int max_quickacks);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index da7f156d9fad93b0ab97cd52bc9e7f9cd3822ea2..fba6578bc98f98feae8afea522e113ea3994eea0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -858,12 +858,12 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
 }
 EXPORT_SYMBOL(tcp_splice_read);
 
-struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
+struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, gfp_t gfp,
 				     bool force_schedule)
 {
 	struct sk_buff *skb;
 
-	skb = alloc_skb_fclone(size + MAX_TCP_HEADER, gfp);
+	skb = alloc_skb_fclone(MAX_TCP_HEADER, gfp);
 	if (likely(skb)) {
 		bool mem_scheduled;
 
@@ -1178,7 +1178,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 					goto restart;
 			}
 			first_skb = tcp_rtx_and_write_queues_empty(sk);
-			skb = tcp_stream_alloc_skb(sk, 0, sk->sk_allocation,
+			skb = tcp_stream_alloc_skb(sk, sk->sk_allocation,
 						   first_skb);
 			if (!skb)
 				goto wait_for_space;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fedbe842abdd027a95f2ac7960185fd2906a04bc..660eac4bf2a77080def76b4ee8ae6fbfc4e13284 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1558,7 +1558,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 		return -ENOMEM;
 
 	/* Get a new skb... force flag on. */
-	buff = tcp_stream_alloc_skb(sk, 0, gfp, true);
+	buff = tcp_stream_alloc_skb(sk, gfp, true);
 	if (!buff)
 		return -ENOMEM; /* We'll just try again later. */
 	skb_copy_decrypted(buff, skb);
@@ -2118,7 +2118,7 @@ static int tso_fragment(struct sock *sk, struct sk_buff *skb, unsigned int len,
 	/* All of a TSO frame must be composed of paged data.  */
 	DEBUG_NET_WARN_ON_ONCE(skb->len != skb->data_len);
 
-	buff = tcp_stream_alloc_skb(sk, 0, gfp, true);
+	buff = tcp_stream_alloc_skb(sk, gfp, true);
 	if (unlikely(!buff))
 		return -ENOMEM;
 	skb_copy_decrypted(buff, skb);
@@ -2434,7 +2434,7 @@ static int tcp_mtu_probe(struct sock *sk)
 		return -1;
 
 	/* We're allowed to probe.  Build it now. */
-	nskb = tcp_stream_alloc_skb(sk, 0, GFP_ATOMIC, false);
+	nskb = tcp_stream_alloc_skb(sk, GFP_ATOMIC, false);
 	if (!nskb)
 		return -1;
 
@@ -3811,7 +3811,7 @@ static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
 	    !skb_page_frag_refill(min_t(size_t, space, PAGE_SIZE),
 				  pfrag, sk->sk_allocation))
 		goto fallback;
-	syn_data = tcp_stream_alloc_skb(sk, 0, sk->sk_allocation, false);
+	syn_data = tcp_stream_alloc_skb(sk, sk->sk_allocation, false);
 	if (!syn_data)
 		goto fallback;
 	memcpy(syn_data->cb, syn->cb, sizeof(syn->cb));
@@ -3896,7 +3896,7 @@ int tcp_connect(struct sock *sk)
 		return 0;
 	}
 
-	buff = tcp_stream_alloc_skb(sk, 0, sk->sk_allocation, true);
+	buff = tcp_stream_alloc_skb(sk, sk->sk_allocation, true);
 	if (unlikely(!buff))
 		return -ENOBUFS;
 
-- 
2.41.0.162.gfafddb0af9-goog


