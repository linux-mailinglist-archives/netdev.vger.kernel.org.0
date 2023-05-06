Return-Path: <netdev+bounces-691-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 005A96F90B5
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 10:59:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE3FD1C21AFB
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 08:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73D1D1FDC;
	Sat,  6 May 2023 08:59:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6883E7C
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 08:59:21 +0000 (UTC)
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D235249EF
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 01:59:19 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a516fb6523so24638175ad.3
        for <netdev@vger.kernel.org>; Sat, 06 May 2023 01:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1683363559; x=1685955559;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/yFOZs9UBviVnHJO1aVdELp7g3Y/8jlve773AyEi+qo=;
        b=KQpgaYXFK2A85M/RCva4x3AfDUaf3aYrBM1vsRUfoQGIOH6c3V9XLfWSprpd258rLw
         K/I75OR1FFIASPpdBEm/wO86r5MVhUCo8Ql1YcRoZSqowa+pzJsNLCZpldnKKeOBmbka
         jtodE6583Ef9EOMk/CiVC0TaVEB+hD2dc+1sx6qGYH7zTkQe8qKK5F8wCWIZHdld3PoC
         oY6FoWpcysb/+4lkQrM1bndqmTgOWum2LB9S5ItLRmfX87whljQXk4tY7nH4hqfHRT7w
         BV2GpAdZunJBx/IJQgFaT8Q99ptNpnpFTkehb/CthD7fTpO9+0sDNUpffNp8FnJuqApw
         pm9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683363559; x=1685955559;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/yFOZs9UBviVnHJO1aVdELp7g3Y/8jlve773AyEi+qo=;
        b=UjALjIVEWLPQNu1nEB6fIfMrawCkVrHqNF4OFiQ6IZaIvtvlcNRxTiuZ8Rp31IKJhg
         +xwRpgGY5TlisXNddkNOwGIldmYpoJ16YUXUFShr/zW3r8ag6wFqqp7T414DDwuoGdZr
         DF8nkOpq7D1FhGKf1zR4Aa7UsITYgQBVsgteFnylSsgbIXp3yij2cXfPB6BcuU00cpgR
         Lt6p/x5jnjZOonQazCXe9on6SmmllLNtFYC/uNVVN1oYTw3B+c5AOf9QrJ1UbEMVHCtp
         B6yTZWxzW3xvShrVUU0iP5d9/gSoBRBncXwiScqHP7NeCiHTUohsvxSKM6e27YHsYWnv
         gULA==
X-Gm-Message-State: AC+VfDyDRSizLsRlxcVIjRKyTeXpaa0OEkbkIWSvqMIWSvqG38rsrMdI
	lJjQCiZiApSjtSX7QJ/MXRpe+A==
X-Google-Smtp-Source: ACHHUZ6AgOAs6K75h6psskFE61rfVFqoB/jeU15IOwds4ac9MR35NBruz5ueGPNh/FkckpCITsDYCw==
X-Received: by 2002:a17:903:6ce:b0:1a6:3799:ec2a with SMTP id kj14-20020a17090306ce00b001a63799ec2amr3451130plb.35.1683363559334;
        Sat, 06 May 2023 01:59:19 -0700 (PDT)
Received: from C02DV8HUMD6R.bytedance.net ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id g2-20020a170902740200b001aaf2172418sm3083332pll.95.2023.05.06.01.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 May 2023 01:59:18 -0700 (PDT)
From: Abel Wu <wuyun.abel@bytedance.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH] sock: Fix misuse of sk_under_memory_pressure()
Date: Sat,  6 May 2023 16:59:03 +0800
Message-Id: <20230506085903.96133-1-wuyun.abel@bytedance.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The commit 180d8cd942ce ("foundations of per-cgroup memory pressure
controlling") wrapped proto::memory_pressure status into an accessor
named sk_under_memory_pressure(), and in the next commit e1aab161e013
("socket: initial cgroup code") added the consideration of net-memcg
pressure into this accessor.

But with the former patch applied, not all of the call sites of
sk_under_memory_pressure() are interested in net-memcg's pressure.
The __sk_mem_{raise,reduce}_allocated() only focus on proto/netns
pressure rather than net-memcg's. IOW this accessor are generally
used for deciding whether should reclaim or not.

Fixes: e1aab161e013 ("socket: initial cgroup code")
Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 include/net/sock.h |  5 -----
 net/core/sock.c    | 17 +++++++++--------
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 8b7ed7167243..752d51030c5a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1404,11 +1404,6 @@ static inline int sk_under_cgroup_hierarchy(struct sock *sk,
 #endif
 }
 
-static inline bool sk_has_memory_pressure(const struct sock *sk)
-{
-	return sk->sk_prot->memory_pressure != NULL;
-}
-
 static inline bool sk_under_memory_pressure(const struct sock *sk)
 {
 	if (!sk->sk_prot->memory_pressure)
diff --git a/net/core/sock.c b/net/core/sock.c
index 5440e67bcfe3..8d215f821ea6 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3017,13 +3017,14 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 		}
 	}
 
-	if (sk_has_memory_pressure(sk)) {
-		u64 alloc;
-
-		if (!sk_under_memory_pressure(sk))
-			return 1;
-		alloc = sk_sockets_allocated_read_positive(sk);
-		if (sk_prot_mem_limits(sk, 2) > alloc *
+	if (prot->memory_pressure) {
+		/*
+		 * If under global pressure, allow the sockets that are below
+		 * average memory usage to raise, trying to be fair between all
+		 * the sockets under global constrains.
+		 */
+		if (!*prot->memory_pressure ||
+		    sk_prot_mem_limits(sk, 2) > sk_sockets_allocated_read_positive(sk) *
 		    sk_mem_pages(sk->sk_wmem_queued +
 				 atomic_read(&sk->sk_rmem_alloc) +
 				 sk->sk_forward_alloc))
@@ -3095,7 +3096,7 @@ void __sk_mem_reduce_allocated(struct sock *sk, int amount)
 	if (mem_cgroup_sockets_enabled && sk->sk_memcg)
 		mem_cgroup_uncharge_skmem(sk->sk_memcg, amount);
 
-	if (sk_under_memory_pressure(sk) &&
+	if (sk->sk_prot->memory_pressure && *sk->sk_prot->memory_pressure &&
 	    (sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 0)))
 		sk_leave_memory_pressure(sk);
 }
-- 
2.37.3


