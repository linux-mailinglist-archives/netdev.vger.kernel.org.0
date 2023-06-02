Return-Path: <netdev+bounces-7334-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E43F671FB98
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:12:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49CFD1C20B99
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 08:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E0CD305;
	Fri,  2 Jun 2023 08:11:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B37D304
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:11:58 +0000 (UTC)
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9160EB
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 01:11:56 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 98e67ed59e1d1-256531ad335so1387788a91.0
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 01:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685693516; x=1688285516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iCepPOl9mp4meHusGBh1Wos+X24ELWJG4xhc1EAvakM=;
        b=akVOHUmEY2HrSn8sCzEPkJCFaO4u/D8Dl9fqbknyN67dHYkE9iTOGSKXYoTJp6cVCd
         JRl8C39ECchyPoiYpI/L8CS3Bn86nSsQnpFshC4ZMefWpdMj0zzc6//2p2olbGZ2xWTL
         1bQXup3D0YO7GRokeldNi9fgYYhlqHntQbM6BpJy04r8p7E4nCjFY16KmEXA2chJkH17
         m6LIljvVpIUuddw7o4NcWuHZP2Hw6BQBMPCqmzvnsRrHSvuKCVsLrhDbPDn8dsaov90H
         bOXS93BM+3QrLj9jFZtV+yrsJzn3pOKUGkUfUicRFlygWh/gPgOc0/Ypcg4bN+tt9Dfl
         WQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685693516; x=1688285516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iCepPOl9mp4meHusGBh1Wos+X24ELWJG4xhc1EAvakM=;
        b=aJKSvQdvIYgBFhwBOM7ct85qrfZe36bFx2gubPShGp9fO7ThvJtvMFs7qaAt8g+7Tr
         CsV151Rz1ME0VePMBx5D6UmUJNnjwmkyLmw7387XrCwSmhflhDpDZcIB2UU1OYDKfslF
         Uwy8D/CXrMsTMA2ePFTO9gBwHu2SXzU8OZssDpG93tKQaLiYyAcMnu0z3o7LkAPThqEf
         yqFw6c98R2MrPxw1nS+EHZ657pKUUv/Gwv5a0EPy6tsnox3BIS2JZKI5BG5VDv48mQs9
         a9FMhPcZz3Efu5jjsO5ZbPLKfdG+rfIAn5syzmx4XPihbUo7E+BCGZ1B0mC41S3OjNcI
         fy9g==
X-Gm-Message-State: AC+VfDyW5LerhJhEzbw0NdEoh2cUbk9BGYIuzWs0+tx5joRnoUCAHbqw
	CvBrIiMzVRajJ7iXqyi9msi1CQ==
X-Google-Smtp-Source: ACHHUZ5DwYTBIaQBiPoaru74ouktiUFZQ/5VNR/JoQ2bzJ9gjHqpW8vuV2nlRo37pxM4NQD552U2Cw==
X-Received: by 2002:a17:902:c94b:b0:1b1:a9e7:5d4b with SMTP id i11-20020a170902c94b00b001b1a9e75d4bmr2030133pla.22.1685693516240;
        Fri, 02 Jun 2023 01:11:56 -0700 (PDT)
Received: from C02DV8HUMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id ij9-20020a170902ab4900b001b025aba9edsm703570plb.220.2023.06.02.01.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 01:11:55 -0700 (PDT)
From: Abel Wu <wuyun.abel@bytedance.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Vladimir Davydov <vdavydov.dev@gmail.com>,
	Shakeel Butt <shakeelb@google.com>,
	Muchun Song <muchun.song@linux.dev>
Cc: Simon Horman <simon.horman@corigine.com>,
	netdev@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH net-next v5 1/3] net-memcg: Fold dependency into memcg pressure cond
Date: Fri,  2 Jun 2023 16:11:33 +0800
Message-Id: <20230602081135.75424-2-wuyun.abel@bytedance.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230602081135.75424-1-wuyun.abel@bytedance.com>
References: <20230602081135.75424-1-wuyun.abel@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
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
index 656ea89f60ff..3f63253ee092 100644
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
index 14fa716cac50..d4c358bc0c52 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -259,8 +259,7 @@ extern unsigned long tcp_memory_pressure;
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


