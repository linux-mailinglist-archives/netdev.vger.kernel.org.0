Return-Path: <netdev+bounces-7336-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3741471FB9F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:12:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBC0D1C20B19
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 08:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 827B7C8F7;
	Fri,  2 Jun 2023 08:12:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EB48474
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:12:10 +0000 (UTC)
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70501BD
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 01:12:08 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-19f6f8c840bso1827408fac.3
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 01:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685693527; x=1688285527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jiy6rp/teLKUThWdNiCcsRgTjbB074BNeS/UwKIzIT4=;
        b=FcENutYDdzs+NLTMwlqtxPI7kQe9B9F3492UNa2AvSZ3MxWSDDRKB0NjErfj07Cy+I
         lcryEwsmuLr/Rna0uvSCsg0jGws2Kih7hnkAQCxmrKEko+IRebwiaimFfWQF9D6EnRg5
         WMt2jLz+Fry5HFMXqRkTZFteE1adrdDLaaTNVhiEDH0oZFH6nmmDOxD1vED/7hp4clg7
         i5VonGkD7Z9+DL2kJT9JGCGy1JkMDhSAZbQA3e3hkKE8ho2Ne1ZAsG7XARqmAqSrku1h
         HS24GS0ml598fRcd3JAWW/6zZ4GINKyFqP9OU8xiW38noVicpGBYIs5cmmN4isHizMin
         XsvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685693527; x=1688285527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jiy6rp/teLKUThWdNiCcsRgTjbB074BNeS/UwKIzIT4=;
        b=W4Jr84dkAwJKd2N+BKvCqo4r/f2Ppf7Jtp5wwDlE21YEo4hhtlujAhVc0AMPtxpwhc
         U4/wZOL6rhXkFX3XpJSAMIxvWwZxQjRt6ZgzLQqYza9KpDrRjeO0FjT2j3ZMHrk2Bz9M
         w6LlhSR4k3WmDGO/S1RL9UYtV3c3xeBR1ldVY9n0S0T8HtUTD981Lj5EFN4H22rabpX5
         s+nWoOjAngQQrjiOQURMbVV9MapghxRMq147PHlQEIFCptehFjgewPXjqUvW9KxqK0ZF
         DUjnbs+FlyCj0x2I2kwoZcFlER+437mtAu1q2sIxk5it/Sn/X1SM3Kv0tGQEbW37TaSb
         8MDw==
X-Gm-Message-State: AC+VfDx9dnq2Pgv+B0p7gHwD/3BcGtrEIf59Kdur8hnZpAj7INsOqQIE
	rJFJprDirvNK7LqsAJkhJB/qiQ==
X-Google-Smtp-Source: ACHHUZ7CNQtcusWmTYjr7kkqOWjT8K7czNAqdYl2iTFd0Z0fE8k2zcGs/Fog4KFmH0pAmQ29q/PNvQ==
X-Received: by 2002:a05:6870:a8b0:b0:163:3be0:1195 with SMTP id eb48-20020a056870a8b000b001633be01195mr1715224oab.11.1685693527679;
        Fri, 02 Jun 2023 01:12:07 -0700 (PDT)
Received: from C02DV8HUMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id ij9-20020a170902ab4900b001b025aba9edsm703570plb.220.2023.06.02.01.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 01:12:07 -0700 (PDT)
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
Subject: [PATCH net-next v5 3/3] sock: Fix misuse of sk_under_memory_pressure()
Date: Fri,  2 Jun 2023 16:11:35 +0800
Message-Id: <20230602081135.75424-4-wuyun.abel@bytedance.com>
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
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The status of global socket memory pressure is updated when:

  a) __sk_mem_raise_allocated():

	enter: sk_memory_allocated(sk) >  sysctl_mem[1]
	leave: sk_memory_allocated(sk) <= sysctl_mem[0]

  b) __sk_mem_reduce_allocated():

	leave: sk_under_memory_pressure(sk) &&
		sk_memory_allocated(sk) < sysctl_mem[0]

So the conditions of leaving global pressure are inconstant, which
may lead to the situation that one pressured net-memcg prevents the
global pressure from being cleared when there is indeed no global
pressure, thus the global constrains are still in effect unexpectedly
on the other sockets.

This patch fixes this by ignoring the net-memcg's pressure when
deciding whether should leave global memory pressure.

Fixes: e1aab161e013 ("socket: initial cgroup code.")
Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 include/net/sock.h | 9 +++++++--
 net/core/sock.c    | 2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index ad1895ffbc4a..22695f776e76 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1409,13 +1409,18 @@ static inline bool sk_has_memory_pressure(const struct sock *sk)
 	return sk->sk_prot->memory_pressure != NULL;
 }
 
+static inline bool sk_under_global_memory_pressure(const struct sock *sk)
+{
+	return sk->sk_prot->memory_pressure &&
+		*sk->sk_prot->memory_pressure;
+}
+
 static inline bool sk_under_memory_pressure(const struct sock *sk)
 {
 	if (mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
-	return sk->sk_prot->memory_pressure &&
-		*sk->sk_prot->memory_pressure;
+	return sk_under_global_memory_pressure(sk);
 }
 
 static inline long
diff --git a/net/core/sock.c b/net/core/sock.c
index 5440e67bcfe3..801df091e37a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3095,7 +3095,7 @@ void __sk_mem_reduce_allocated(struct sock *sk, int amount)
 	if (mem_cgroup_sockets_enabled && sk->sk_memcg)
 		mem_cgroup_uncharge_skmem(sk->sk_memcg, amount);
 
-	if (sk_under_memory_pressure(sk) &&
+	if (sk_under_global_memory_pressure(sk) &&
 	    (sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 0)))
 		sk_leave_memory_pressure(sk);
 }
-- 
2.37.3


