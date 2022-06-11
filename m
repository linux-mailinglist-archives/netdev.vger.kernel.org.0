Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690C55471A4
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 05:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347633AbiFKDa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 23:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242868AbiFKDa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 23:30:28 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E672BD5
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 20:30:24 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u12-20020a17090a1d4c00b001df78c7c209so3978756pju.1
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 20:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S01D7AazD3l0Zu5kX4s9YB4IZ8cAdEjESuRW3hfBxQ8=;
        b=cCPvUdBwzYUQpJDgeQaJK0iFxAnxUKEiRcRlNZlLhpne4vWdhsRWh9y4UVz7Z7HAj9
         D5t0P2SzOGtrWLD5cJD8yuO7k7ouonlfd/rTrHx1BsFdGj0anq9Qp6YMwLVcZvLv7lb2
         QJf+v3eXSfclmFNrOoe5PtoS+uW2yHXiFJcpTWvjAgK+dcZYi6D5cDiN45RKLoeHfspz
         bpAppa3LfGyzKVnIGHqoBvoohs09y1+S7qIltTXb/3P2lj82Ogh2shBGcbXih7Sq9Pmi
         46PEODFaCJ+VOD97J609uXjGT1LymO9Vyi8cLehT/PVdr/XhqDHfq9CAp7zsDcD8HWVS
         0qBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S01D7AazD3l0Zu5kX4s9YB4IZ8cAdEjESuRW3hfBxQ8=;
        b=T7MuHi2fn4vrNNC/IfTlEdo0DJPW+dM8NvB15wTheMKRyFmFlGhUyW2cq7Xbksl4JW
         pOqY9GtyQTrH6bii8OgPIBeKzDeWUqxbxtTFuYDSeQe+RvHPVVsjfuLV6w0Xu8i2oF67
         vIllsnSLmahS6UJpJByMHXjrxpJD9F/wwIjGHyzJBRO0zfqKfYKfWk50keb2cgvUIz/8
         dHa/vfRYGLEjD7LMI4G3qZt/D1p8dN8zFZ2wu4sGK11qvcrtprfizUamI3srSCbx19fR
         Q7XsrmNi7OCiM6nBTPkdFOboX5ZLPrFr/RIR8VIEG3EfbKvp4D1mcf7/NBzfZ2NghCkL
         Qz2A==
X-Gm-Message-State: AOAM533JClz7gqnzQzY0wNnsUugC3Xr2be4pv5XFLYs3/fW1lgwn4yQJ
        Puj1c2TPOB+zZ9xJA77n8sg=
X-Google-Smtp-Source: ABdhPJypJzjYm1nJTmDcmjPzotZcp2FhDKvF4iyEeBd7s0rs+chR+Hl9szQ8fVFpL7JNBzakHa755w==
X-Received: by 2002:a17:902:e806:b0:164:164c:5a63 with SMTP id u6-20020a170902e80600b00164164c5a63mr47637951plg.102.1654918223637;
        Fri, 10 Jun 2022 20:30:23 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2f04:a9e2:499b:e1db])
        by smtp.gmail.com with ESMTPSA id 25-20020a17090a005900b001ded0506655sm2439300pjb.51.2022.06.10.20.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 20:30:22 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] tcp: sk_forced_mem_schedule() optimization
Date:   Fri, 10 Jun 2022 20:30:16 -0700
Message-Id: <20220611033016.3697610-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

sk_memory_allocated_add() has three callers, and returns
to them @memory_allocated.

sk_forced_mem_schedule() is one of them, and ignores
the returned value.

Change sk_memory_allocated_add() to return void.

Change sock_reserve_memory() and __sk_mem_raise_allocated()
to call sk_memory_allocated().

This removes one cache line miss [1] for RPC workloads,
as first skbs in TCP write queue and receive queue go through
sk_forced_mem_schedule().

[1] Cache line holding tcp_memory_allocated.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 3 +--
 net/core/sock.c    | 9 ++++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 0063e8410a4e3ed91aef9cf34eb1127f7ce33b93..304a5e39d41e27105148058066e8fa23490cf9fa 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1412,7 +1412,7 @@ sk_memory_allocated(const struct sock *sk)
 /* 1 MB per cpu, in page units */
 #define SK_MEMORY_PCPU_RESERVE (1 << (20 - PAGE_SHIFT))
 
-static inline long
+static inline void
 sk_memory_allocated_add(struct sock *sk, int amt)
 {
 	int local_reserve;
@@ -1424,7 +1424,6 @@ sk_memory_allocated_add(struct sock *sk, int amt)
 		atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
 	}
 	preempt_enable();
-	return sk_memory_allocated(sk);
 }
 
 static inline void
diff --git a/net/core/sock.c b/net/core/sock.c
index 697d5c8e2f0def49351a7d38ec59ab5e875d3b10..92a0296ccb1842f11fb8dd4b2f768885d05daa8f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1019,7 +1019,8 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
 		return -ENOMEM;
 
 	/* pre-charge to forward_alloc */
-	allocated = sk_memory_allocated_add(sk, pages);
+	sk_memory_allocated_add(sk, pages);
+	allocated = sk_memory_allocated(sk);
 	/* If the system goes into memory pressure with this
 	 * precharge, give up and return error.
 	 */
@@ -2906,11 +2907,13 @@ EXPORT_SYMBOL(sk_wait_data);
  */
 int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 {
-	struct proto *prot = sk->sk_prot;
-	long allocated = sk_memory_allocated_add(sk, amt);
 	bool memcg_charge = mem_cgroup_sockets_enabled && sk->sk_memcg;
+	struct proto *prot = sk->sk_prot;
 	bool charged = true;
+	long allocated;
 
+	sk_memory_allocated_add(sk, amt);
+	allocated = sk_memory_allocated(sk);
 	if (memcg_charge &&
 	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
 						gfp_memcg_charge())))
-- 
2.36.1.476.g0c4daa206d-goog

