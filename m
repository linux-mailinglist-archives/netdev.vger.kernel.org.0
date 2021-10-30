Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17E74406DE
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 04:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhJ3CIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 22:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbhJ3CIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 22:08:36 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34992C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 19:06:07 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id r15so11197963qkp.8
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 19:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jWwwKc5JOpZXeVZoUpN/2I6++QhB5L3MIJ8NZIx037U=;
        b=pjcIWebwoCXf81pM69lBX6UutTHRISz4miCDWap3FN+L+Wq4VQoPrX5yocUi3hneR7
         hm2q6Qyr2xRaG+SiN9at4bjMV1ikmMdoo06N/0dC0hxsHANmqmVCqT0qW+SpIp6B23qi
         mIqy2hX1u1B0MF2xNYoB4Dwmp/nU8yCJqNYtYvJ1p8ePraaLX5ApW09YotLhCVxrzE2p
         gTZIN1YmzrHWuGLME7qlQmQ2A5xO7DOlAQ8NQ0NlDg5wEVD+cnGsg/nSCXR6MnU85/ma
         me2f8lFiu+2CJy/eYNN5Cj5pJleQZzEXZD+1SWWFIv7F4J+U6yUCiaoW/SNxtZvUZgsg
         yNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jWwwKc5JOpZXeVZoUpN/2I6++QhB5L3MIJ8NZIx037U=;
        b=PhIVG+U/Z/D5A/CHns2wBa00Iqly84qOcBgE/a1L6ymTdLDIUQvrDKczcpjlquVnc6
         UR2VisCg1gkDSE/AzpCo63QWrNay2V8ev7sieweYT4kcYuJFE6frIyfBM5cAxAMZfDv8
         Ek3Xpc+Ch5ePfvXAU4HCTzvtSnxaBggTX83pDGd/lPUOIC4pvRaIpSdGSfbE2DuwxLTd
         yyCRwr+eUs6b/JP66fxKI6oFSJ4CJ0RcFgZF5ZIKKShfMHjKir0uVgWODIauf0qSvVtz
         Qx4M0xx6dV+nu9PAGdP9zbpVD0+Ubrzsz1E6fo2dhSjlB3maLcImWH5yOQ/ej0bMS/uh
         t1/Q==
X-Gm-Message-State: AOAM533QI3G+auVSGtjNOC9mBtSaJyyWM/zO2JQqRCtfYIifrZZ9rmCr
        gGx3cIaLruxrgXNKsrSu4ydJVDkvufAUUA==
X-Google-Smtp-Source: ABdhPJzPGJIt9imPX2KgVO7w5dyd2Rdg2WsX/ReKxqJRVvLtWNQrHeSZGZ+Q2lGBVeqVWNRQwYKPcw==
X-Received: by 2002:a05:620a:408c:: with SMTP id f12mr12344139qko.471.1635559566429;
        Fri, 29 Oct 2021 19:06:06 -0700 (PDT)
Received: from talalahmad1.nyc.corp.google.com ([2620:0:1003:317:25ce:101f:81db:24e8])
        by smtp.gmail.com with ESMTPSA id az12sm5044391qkb.28.2021.10.29.19.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 19:06:06 -0700 (PDT)
From:   Talal Ahmad <mailtalalahmad@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        willemb@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, cong.wang@bytedance.com, haokexin@gmail.com,
        jonathan.lemon@gmail.com, alobakin@pm.me, pabeni@redhat.com,
        ilias.apalodimas@linaro.org, memxor@gmail.com, elver@google.com,
        nogikh@google.com, vvs@virtuozzo.com,
        Talal Ahmad <talalahmad@google.com>
Subject: [PATCH net-next v2 1/2] tcp: rename sk_wmem_free_skb
Date:   Fri, 29 Oct 2021 22:05:41 -0400
Message-Id: <20211030020542.3870542-2-mailtalalahmad@gmail.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
In-Reply-To: <20211030020542.3870542-1-mailtalalahmad@gmail.com>
References: <20211030020542.3870542-1-mailtalalahmad@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Talal Ahmad <talalahmad@google.com>

sk_wmem_free_skb() is only used by TCP.

Rename it to make this clear, and move its declaration to
include/net/tcp.h

Signed-off-by: Talal Ahmad <talalahmad@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h    | 7 -------
 include/net/tcp.h     | 9 ++++++++-
 net/ipv4/tcp.c        | 6 +++---
 net/ipv4/tcp_output.c | 2 +-
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 620de053002d..b32906e1ab55 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1603,13 +1603,6 @@ static inline void sk_mem_uncharge(struct sock *sk, int size)
 		__sk_mem_reclaim(sk, SK_RECLAIM_CHUNK);
 }
 
-static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
-{
-	sk_wmem_queued_add(sk, -skb->truesize);
-	sk_mem_uncharge(sk, skb->truesize);
-	__kfree_skb(skb);
-}
-
 static inline void sock_release_ownership(struct sock *sk)
 {
 	if (sk->sk_lock.owned) {
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 8e8c5922a7b0..70972f3ac8fa 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -290,6 +290,13 @@ static inline bool tcp_out_of_memory(struct sock *sk)
 	return false;
 }
 
+static inline void tcp_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
+{
+	sk_wmem_queued_add(sk, -skb->truesize);
+	sk_mem_uncharge(sk, skb->truesize);
+	__kfree_skb(skb);
+}
+
 void sk_forced_mem_schedule(struct sock *sk, int size);
 
 bool tcp_check_oom(struct sock *sk, int shift);
@@ -1875,7 +1882,7 @@ static inline void tcp_rtx_queue_unlink_and_free(struct sk_buff *skb, struct soc
 {
 	list_del(&skb->tcp_tsorted_anchor);
 	tcp_rtx_queue_unlink(skb, sk);
-	sk_wmem_free_skb(sk, skb);
+	tcp_wmem_free_skb(sk, skb);
 }
 
 static inline void tcp_push_pending_frames(struct sock *sk)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a7b1138d619c..bc7f419184aa 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -932,7 +932,7 @@ void tcp_remove_empty_skb(struct sock *sk)
 		tcp_unlink_write_queue(skb, sk);
 		if (tcp_write_queue_empty(sk))
 			tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
-		sk_wmem_free_skb(sk, skb);
+		tcp_wmem_free_skb(sk, skb);
 	}
 }
 
@@ -2893,7 +2893,7 @@ static void tcp_rtx_queue_purge(struct sock *sk)
 		 * list_del(&skb->tcp_tsorted_anchor)
 		 */
 		tcp_rtx_queue_unlink(skb, sk);
-		sk_wmem_free_skb(sk, skb);
+		tcp_wmem_free_skb(sk, skb);
 	}
 }
 
@@ -2904,7 +2904,7 @@ void tcp_write_queue_purge(struct sock *sk)
 	tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
 	while ((skb = __skb_dequeue(&sk->sk_write_queue)) != NULL) {
 		tcp_skb_tsorted_anchor_cleanup(skb);
-		sk_wmem_free_skb(sk, skb);
+		tcp_wmem_free_skb(sk, skb);
 	}
 	tcp_rtx_queue_purge(sk);
 	INIT_LIST_HEAD(&tcp_sk(sk)->tsorted_sent_queue);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6867e5db3e35..6fbbf1558033 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2412,7 +2412,7 @@ static int tcp_mtu_probe(struct sock *sk)
 			TCP_SKB_CB(nskb)->eor = TCP_SKB_CB(skb)->eor;
 			tcp_skb_collapse_tstamp(nskb, skb);
 			tcp_unlink_write_queue(skb, sk);
-			sk_wmem_free_skb(sk, skb);
+			tcp_wmem_free_skb(sk, skb);
 		} else {
 			TCP_SKB_CB(nskb)->tcp_flags |= TCP_SKB_CB(skb)->tcp_flags &
 						   ~(TCPHDR_FIN|TCPHDR_PSH);
-- 
2.33.1.1089.g2158813163f-goog

