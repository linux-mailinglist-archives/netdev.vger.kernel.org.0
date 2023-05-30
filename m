Return-Path: <netdev+bounces-6345-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B34BE715D74
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:40:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7799A281086
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C223E17FEB;
	Tue, 30 May 2023 11:40:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BE117FE2
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:40:35 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011FBC5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 04:40:33 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-64f47448aeaso3126518b3a.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 04:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685446833; x=1688038833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zSeZy3dBgM/hAvW1l4S3j81M4ry+F3vLfbl4Wg72DeY=;
        b=hhLQ3LoKBaJEJ5y7uGQ1a6tBrIrMZV+1pnIfqUg+3PPYZLcdnc+7VDqo7mmHd61hrj
         Sd4swO79Q16159eQDWb/4DVkqYPSM/uwLu9+nrIMavuQvSS0iMMA2tKxbWYOLOTyMNNW
         8Q9YqbEBpn+Nx2pNK4smxSztJf5X5kZARTJKBTBELw90yTB1VKCkqnwAR8Px/p/KKR7V
         fOhc0w5nYnh7RRxeDgcc3lEBrXih07VolZo5Ebp7QGT1yNFQEfcQDeiZsXJhF9CLMeJk
         SavXV7b4KyPrvCtY6W/D4aQTnvHV5HjuN8C1ttrCgPPMzrSoHBP01IYNksy9EhRLI1EZ
         mTeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685446833; x=1688038833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zSeZy3dBgM/hAvW1l4S3j81M4ry+F3vLfbl4Wg72DeY=;
        b=Ai9ZDTBMSH1e2+jQJPueeCmMxgi9561rcgtMD8LI8Y6Urh9WjG8nD7L7R4Epb6lnPz
         H8Z1QgF2xbwLDZE1+Ga7Px5zT4WZfgpGd2/Qz5xesg96O9IAqC/cXmgTFpG8NCwbCMxm
         qE1xaWB5/OWnWjDq1F09X97xPL+Cb1TNfQzLsUe36O6d1zpZ3vY06/OdLsqm2IwDy4Lt
         cYcXkoe9Y3gyvAvGfEsfOJbmZh5e7TMZDS0sdB7VZBdj5GEu3R/VpcXbaTlTeb594JHS
         ArEi/N+FgX2eLm+sengWjtlN34hcO1+tdfwHMYVFwDaUjNwDZ9Ni+jDJnT0Dk0fw1en3
         3WvA==
X-Gm-Message-State: AC+VfDydBHgQcYJYtf5RyNfpmgHv0vT/42BjhVnYfRyqIyJWsqHesYBI
	YO7BbITG6lP/KRR5KeDueqvpIg==
X-Google-Smtp-Source: ACHHUZ4xzkdDhUOHefB08/7eoqUUKTgwsuecz4t21GvJg0uPWZgET1FRSQPRi1s3ik542LqiUkJgag==
X-Received: by 2002:a05:6a20:8e14:b0:103:b0f9:7110 with SMTP id y20-20020a056a208e1400b00103b0f97110mr2307010pzj.11.1685446833446;
        Tue, 30 May 2023 04:40:33 -0700 (PDT)
Received: from C02DV8HUMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id j20-20020aa78dd4000000b00642ea56f06fsm1515103pfr.0.2023.05.30.04.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 04:40:32 -0700 (PDT)
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
Subject: [PATCH v4 1/4] net-memcg: Fold dependency into memcg pressure cond
Date: Tue, 30 May 2023 19:40:08 +0800
Message-Id: <20230530114011.13368-2-wuyun.abel@bytedance.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230530114011.13368-1-wuyun.abel@bytedance.com>
References: <20230530114011.13368-1-wuyun.abel@bytedance.com>
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
	autolearn=unavailable autolearn_force=no version=3.4.6
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


