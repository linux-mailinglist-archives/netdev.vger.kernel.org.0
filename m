Return-Path: <netdev+bounces-4619-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB70970D970
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:47:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4792281299
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C48881E532;
	Tue, 23 May 2023 09:47:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EFC1DDE5
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:47:14 +0000 (UTC)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5570794
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:47:13 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64d426e63baso4138549b3a.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684835233; x=1687427233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zSeZy3dBgM/hAvW1l4S3j81M4ry+F3vLfbl4Wg72DeY=;
        b=O06lEBAs+5Eoxzd1wIs6DBaPLQaIKoySacNOnVoqMNyuuuH7QAO7G1QGk4c99I8+s/
         ZGgXooronTdovPxYNwkii+X4BWjP+OkCBIQKjNd2rdLzhkzbEjBTRHnEYvW2t9LWHSCc
         epJfFOheoOPOBWJ2uYRHSVB+TRR7MnHFCHHipwrAZL3WwjLmvdaWxE/ufB9Ni23DX9tR
         aVC8Ed1tWF4kMycrLwek1nsWvnOWC2zkkZ8U3l7l2+j6/c8lOx8I+/0h+1U0uKlQTULU
         YRrQetIlPircJ5m0BuklZMOMwuPFbKEt7M3gFbVbueJosraYOXJxbjMfNCCRhuTkdtyr
         koTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684835233; x=1687427233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zSeZy3dBgM/hAvW1l4S3j81M4ry+F3vLfbl4Wg72DeY=;
        b=IZHofvo4yH4boZs14eNYrReHGzXhruV4O6Iu8REmEaADr1get8V2wYlPqFY9u/JzIj
         j8UAJ3/aFaZEV7YBrA80A+qB6bSsyIv6C2Na6/f/JEnPXrwgYo9hYJR6DTWMWgv8ppwR
         rOggMsYViGaXPJ7BhlhVLZVVSJyySgQ/eHsonsTp3mi8BK6NUKDw+EGBWRTveKbpq/5z
         4Cm2McfbnODMPGSbf6PvxlkATFKso6+yeEUTD7EeCGUmwdzoBQPi/hWFxe3+3CoUZUok
         FXBqEqnnSA8LhcwagHeWOeVKnc1DGyerGLIUbA5rmv/w10y0zLxUwTfPizdBJeCj/3dE
         Poyg==
X-Gm-Message-State: AC+VfDzIiXxoaskwCOu8/bAinSLnCJrUl70rzJ/Fc3DJII/hUe/9RNV6
	mkK0r2PuVDZkPhQ4zua8NPAx2g==
X-Google-Smtp-Source: ACHHUZ7pooz0B7VbymfYjthlSe/h/bL0s1OnpZY/LiIbUylPNxh9mStfsdIABB88QcmT4d2NFpElYA==
X-Received: by 2002:a05:6a00:98f:b0:645:cfb0:2779 with SMTP id u15-20020a056a00098f00b00645cfb02779mr19397362pfg.26.1684835232865;
        Tue, 23 May 2023 02:47:12 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.230])
        by smtp.gmail.com with ESMTPSA id 22-20020aa79116000000b0063b898b3502sm5457216pfh.153.2023.05.23.02.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 02:47:12 -0700 (PDT)
From: Abel Wu <wuyun.abel@bytedance.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH v3 1/5] net-memcg: Fold dependency into memcg pressure cond
Date: Tue, 23 May 2023 17:46:48 +0800
Message-Id: <20230523094652.49411-2-wuyun.abel@bytedance.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230523094652.49411-1-wuyun.abel@bytedance.com>
References: <20230523094652.49411-1-wuyun.abel@bytedance.com>
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

The callers of mem_cgroup_under_socket_pressure() should always make
sure that (mem_cgroup_sockets_enabled && sk->sk_memcg) is true. So
instead of coding around all the callsites, put the dependencies into
mem_cgroup_under_socket_pressure() to avoid redundancy and possibly
bugs.

This change might also introduce slight function call overhead *iff*
the function gets expanded in the future. But for now this change
doesn't make binaries different (checked by vimdiff) except the one
net/ipv4/tcp_input.o (by scripts/bloat-o-meter), which is probably
negligible to performance:

add/remove: 0/0 grow/shrink: 1/2 up/down: 5/-5 (0)
Function                                     old     new   delta
tcp_grow_window                              573     578      +5
tcp_try_rmem_schedule                       1083    1081      -2
tcp_check_space                              324     321      -3
Total: Before=44647, After=44647, chg +0.00%

So folding the dependencies into mem_cgroup_under_socket_pressure()
is generally a good thing and provides better readablility.

Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 include/linux/memcontrol.h | 2 ++
 include/net/sock.h         | 3 +--
 include/net/tcp.h          | 3 +--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 222d7370134c..a1aead140ff8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1743,6 +1743,8 @@ void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
+	if (!mem_cgroup_sockets_enabled || !memcg)
+		return false;
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
 		return true;
 	do {
diff --git a/include/net/sock.h b/include/net/sock.h
index 8b7ed7167243..641c9373b44b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1414,8 +1414,7 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
 	if (!sk->sk_prot->memory_pressure)
 		return false;
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
-	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
+	if (mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
 	return !!*sk->sk_prot->memory_pressure;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 04a31643cda3..3c5e3718b454 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -261,8 +261,7 @@ extern unsigned long tcp_memory_pressure;
 /* optimized version of sk_under_memory_pressure() for TCP sockets */
 static inline bool tcp_under_memory_pressure(const struct sock *sk)
 {
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
-	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
+	if (mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
 	return READ_ONCE(tcp_memory_pressure);
-- 
2.37.3


