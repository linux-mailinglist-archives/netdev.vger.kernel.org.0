Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7A643A65A
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbhJYWQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbhJYWQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 18:16:09 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95C1C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 15:13:46 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t11so8867491plq.11
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 15:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fK2AuSC/dL5cpRudqXJd07eLvFf8M8PsNRGcYkfsGpE=;
        b=dD7VSgxia3Piawxbcs2DqrfZkeWnIxz8X10/RDol1ZgxjnySrunHrp6G6wOUGu9Mo5
         2uP0vzfnghz3Q0oUdoRWyjkNcwPpKpF9FTFcHOsausT4suJ9eOKF5UKq9gscXhIOvs5J
         BNjBv57IBQGpFsivfGQ3DfypJuuMA9lrCBSm7eY3ZcOTkKwNXeVmOPKYHz1V9gjJVa81
         weJ+AK4FpPD6t5r0cvxr+n4ZbT06JMBje64oT2GEuRHlkIbIo7/Jj/tGVP+AarHUahJa
         wnsqPSVkS8KsFykugx2DqxhVpNAcTd71LBK1H0USq/yHudZ0K3cPrmWbPs27W170g1KM
         I7Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fK2AuSC/dL5cpRudqXJd07eLvFf8M8PsNRGcYkfsGpE=;
        b=orTlT6sSSQhnzdl0+KLDX9fSEb3fvXBIT2lcMWHHhwmN/Tlvi4TXGbnsKjsthUOfAz
         V7+N35nYUAT2e5DO4KnFYvSxUqLaqNTmdc5Iz56Kg3ghg4UsmJdm33XBtK/t3qKXdicr
         7Z04/G+4oQDurdF9PCaPJ6XlKeapL8W2pI+UUrbammaqznlYOkI128W/H2Zyo3co0K9O
         FSlVm9nn1Idw31RfkNk8oNO4HdgGTWTfVy7UgY2CdK9HdZQBkjN/z4B4nELHHAaarStw
         dAbrSaeid4pwt3T2YiXkzroA7vTsqP3beJCbwNVhn9dcm+ggZJ921VHxmL6KgMQRar5d
         ZQNg==
X-Gm-Message-State: AOAM533BdYiswI/s3rLR2TksPR3ZUILy/+DFIHLSg/RPHnzdYCaHYiSm
        YQGWZ+Li/lHoHnMPrt5E51zuG+HSoIM=
X-Google-Smtp-Source: ABdhPJxNL9YLZWXFmX+mFehSFmCnA+B9iXCKb39lECycR717m/chZV304nVgtAtXzH0OBY+h18JE7g==
X-Received: by 2002:a17:90a:6542:: with SMTP id f2mr37951568pjs.159.1635200026369;
        Mon, 25 Oct 2021 15:13:46 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b7cd:daa3:a144:1652])
        by smtp.gmail.com with ESMTPSA id f15sm22351108pfe.132.2021.10.25.15.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 15:13:46 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/3] tcp: rename sk_stream_alloc_skb
Date:   Mon, 25 Oct 2021 15:13:40 -0700
Message-Id: <20211025221342.806029-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211025221342.806029-1-eric.dumazet@gmail.com>
References: <20211025221342.806029-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

sk_stream_alloc_skb() is only used by TCP.

Rename it to make this clear, and move its declaration
to include/net/tcp.h

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h    |  3 ---
 include/net/tcp.h     |  2 ++
 net/ipv4/tcp.c        | 12 ++++++------
 net/ipv4/tcp_output.c | 10 +++++-----
 4 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index b76be30674efc88434ed45d46b9c4600261b6271..ff4e62aa62e51a68d086e9e2b8429cba5731be00 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2422,9 +2422,6 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
 	WRITE_ONCE(sk->sk_sndbuf, max_t(u32, val, SOCK_MIN_SNDBUF));
 }
 
-struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
-				    bool force_schedule);
-
 /**
  * sk_page_frag - return an appropriate page_frag
  * @sk: socket
diff --git a/include/net/tcp.h b/include/net/tcp.h
index d62467a0094fe016ee2f5d9581631e1425e8f201..701587af685296a6b2372fee7b3e94f998c3bbe8 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -337,6 +337,8 @@ void tcp_twsk_destructor(struct sock *sk);
 ssize_t tcp_splice_read(struct socket *sk, loff_t *ppos,
 			struct pipe_inode_info *pipe, size_t len,
 			unsigned int flags);
+struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
+				     bool force_schedule);
 
 void tcp_enter_quickack_mode(struct sock *sk, unsigned int max_quickacks);
 static inline void tcp_dec_quickack_mode(struct sock *sk,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c2d9830136d298a27abc12a5633bf77d1224759c..68dd580dba3d0e04412466868135c49225a4a33b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -856,8 +856,8 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
 }
 EXPORT_SYMBOL(tcp_splice_read);
 
-struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
-				    bool force_schedule)
+struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
+				     bool force_schedule)
 {
 	struct sk_buff *skb;
 
@@ -960,8 +960,8 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 		if (!sk_stream_memory_free(sk))
 			return NULL;
 
-		skb = sk_stream_alloc_skb(sk, 0, sk->sk_allocation,
-					  tcp_rtx_and_write_queues_empty(sk));
+		skb = tcp_stream_alloc_skb(sk, 0, sk->sk_allocation,
+					   tcp_rtx_and_write_queues_empty(sk));
 		if (!skb)
 			return NULL;
 
@@ -1289,8 +1289,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 					goto restart;
 			}
 			first_skb = tcp_rtx_and_write_queues_empty(sk);
-			skb = sk_stream_alloc_skb(sk, 0, sk->sk_allocation,
-						  first_skb);
+			skb = tcp_stream_alloc_skb(sk, 0, sk->sk_allocation,
+						   first_skb);
 			if (!skb)
 				goto wait_for_space;
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 3a01e5593a171d8e8978c11c9880eb9314feeda9..c0c55a8be8f79857e176714f240fddcb0580fa6b 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1564,7 +1564,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 		return -ENOMEM;
 
 	/* Get a new skb... force flag on. */
-	buff = sk_stream_alloc_skb(sk, nsize, gfp, true);
+	buff = tcp_stream_alloc_skb(sk, nsize, gfp, true);
 	if (!buff)
 		return -ENOMEM; /* We'll just try again later. */
 	skb_copy_decrypted(buff, skb);
@@ -2121,7 +2121,7 @@ static int tso_fragment(struct sock *sk, struct sk_buff *skb, unsigned int len,
 		return tcp_fragment(sk, TCP_FRAG_IN_WRITE_QUEUE,
 				    skb, len, mss_now, gfp);
 
-	buff = sk_stream_alloc_skb(sk, 0, gfp, true);
+	buff = tcp_stream_alloc_skb(sk, 0, gfp, true);
 	if (unlikely(!buff))
 		return -ENOMEM;
 	skb_copy_decrypted(buff, skb);
@@ -2388,7 +2388,7 @@ static int tcp_mtu_probe(struct sock *sk)
 		return -1;
 
 	/* We're allowed to probe.  Build it now. */
-	nskb = sk_stream_alloc_skb(sk, probe_size, GFP_ATOMIC, false);
+	nskb = tcp_stream_alloc_skb(sk, probe_size, GFP_ATOMIC, false);
 	if (!nskb)
 		return -1;
 	sk_wmem_queued_add(sk, nskb->truesize);
@@ -3754,7 +3754,7 @@ static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
 	/* limit to order-0 allocations */
 	space = min_t(size_t, space, SKB_MAX_HEAD(MAX_TCP_HEADER));
 
-	syn_data = sk_stream_alloc_skb(sk, space, sk->sk_allocation, false);
+	syn_data = tcp_stream_alloc_skb(sk, space, sk->sk_allocation, false);
 	if (!syn_data)
 		goto fallback;
 	syn_data->ip_summed = CHECKSUM_PARTIAL;
@@ -3835,7 +3835,7 @@ int tcp_connect(struct sock *sk)
 		return 0;
 	}
 
-	buff = sk_stream_alloc_skb(sk, 0, sk->sk_allocation, true);
+	buff = tcp_stream_alloc_skb(sk, 0, sk->sk_allocation, true);
 	if (unlikely(!buff))
 		return -ENOBUFS;
 
-- 
2.33.0.1079.g6e70778dc9-goog

