Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223F944055D
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 00:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhJ2WVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 18:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbhJ2WVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 18:21:31 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBC1C061714
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 15:19:02 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id v17so10536602qtp.1
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 15:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jWwwKc5JOpZXeVZoUpN/2I6++QhB5L3MIJ8NZIx037U=;
        b=VnvtBZKzuEjnB5Ep/aoaW3IBaDNT61Tc9Z6C4nYnoL7HyTukoOp6oCVGsDfiZjvwZn
         ZjbV83K8Z55YQ0jl1l2BWuo+s1PKOILMwwZxYo2EBOaV5QaImqbZq8JS9EOEySk4mccr
         SUi4BsMzxSB0VL3F4ecyCAQ69pwI0h5AU6fYUFItV7kp7zFydiHemoI3eTnW89TzI/zg
         R8TZZl/HE/dReHa3v64bjRJEUE9KNSw08W+gPNqW54VZuxhntGLPcwX1WLBiyvslARRT
         XRvRCA5OkyB9v5XAFzcCu+3/lLg5i0DTbUH480blEVyOrpRrEID6ikWgM/Br5I4WD04D
         kuKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jWwwKc5JOpZXeVZoUpN/2I6++QhB5L3MIJ8NZIx037U=;
        b=aHvTtjj+YoIrJMRiipInlHVN5YCd9C7QcA5sfUvMdgu28njozGatNj1Xh8fud2vG7F
         EOpTv+WyOqloF6G/gDxRIBtQ90eaU+PHgQu/zHFZTpExGeFST4BODZVqucyPfp1X8Raa
         7/ogqF1muMCsBfEGRXEQ++CQgLlpujAIWH8UdJ0I+xSs/C71C1E0+VEK0jja2sstlR6T
         dPuwkdSd1oWdHAFKWJp0SzQ/fWt1sxTBnZlEWjb0/JrzbMP2JHxVVA1VqtjQjgyOvPuv
         uYDNtT1M3SIYPd2pN5OHgYJ7aFfMRJvZWuSrd23UI+jW3TEfWqs/V2nktp65z4YSynDC
         PskQ==
X-Gm-Message-State: AOAM533mdi43qjLzZpaY3jDa3MWMOpu/72mrDUIQ0seVPUxJ1zo1ic4H
        dFVdkL4ukl876Kmu9OfCKGs=
X-Google-Smtp-Source: ABdhPJxRuDQ4AFJDQrF4YV0djholPUN61GmE2c4yn9cpxCY1Sa16fyHoqo78bWjbTI+eZc5Q/7MKcg==
X-Received: by 2002:a05:622a:310:: with SMTP id q16mr15057149qtw.10.1635545941890;
        Fri, 29 Oct 2021 15:19:01 -0700 (PDT)
Received: from talalahmad1.nyc.corp.google.com ([2620:0:1003:317:25ce:101f:81db:24e8])
        by smtp.gmail.com with ESMTPSA id p15sm4931730qti.70.2021.10.29.15.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 15:19:01 -0700 (PDT)
From:   Talal Ahmad <mailtalalahmad@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        willemb@google.com, Talal Ahmad <talalahmad@google.com>
Subject: [PATCH net-next 1/2] tcp: rename sk_wmem_free_skb
Date:   Fri, 29 Oct 2021 18:18:29 -0400
Message-Id: <20211029221830.3608066-2-mailtalalahmad@gmail.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
In-Reply-To: <20211029221830.3608066-1-mailtalalahmad@gmail.com>
References: <20211029221830.3608066-1-mailtalalahmad@gmail.com>
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

