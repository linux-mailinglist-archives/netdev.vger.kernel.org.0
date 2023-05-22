Return-Path: <netdev+bounces-4148-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B59770B5CA
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:02:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E33DB280E42
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 07:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A44C14A2C;
	Mon, 22 May 2023 07:02:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9659F4C6B
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:02:26 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648B11BF8
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 00:02:01 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64d2981e3abso2852881b3a.1
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 00:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684738911; x=1687330911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sgzO2oS5bCjgkGEKcuzpbbehzv1fqa08++GJhHZGJnk=;
        b=B9OMUnv33tNdd4xn/p1rnp8gpM96UCeXIDdHTzof5dEwYWX67z6JpdsyQaZPSH7fYP
         0xl2BymrQyLxgojJyRmIBKH64o8K6wqmHipT3fNNM8HjCm30OCRTAFhRZnQETqcP5thx
         P5yO6NgOVwy8MwNho2m98VZV1UY7rWaamv2fjlUEUnhCVpFhLcvZ7dp3OIYtosvdeWZc
         jfnYzwwptrztNkN3CdKh1BIIyb5WkJiJzBO9KXXNBx/b4FdN5Af3B47IgPO7hW9tXQNA
         4UA5fFW/5Os2QHbMchluOHsxg1m1u7Pl0bZEh6iuGfbBnVDFKNYDbK9/BDiwQbwl5uGz
         Ugwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684738911; x=1687330911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sgzO2oS5bCjgkGEKcuzpbbehzv1fqa08++GJhHZGJnk=;
        b=FXpPT7TlTZcw4ffrnQkn3Ag3m0p+gLN4s8YcMYKj0Db7gVH81i01YW/63ulvgIKKhU
         lBsQjJNh0uok+AZqPER3FCVDxa60b33TOYCZXhVuBc5UuZQMMr0e0gQiiTB+2rcPSt0k
         amsellxSIE1dXub0KpC60XAbbsf3BQ0IXzLDN5TiC23KcW+1Mkj6ttEnO3ouUew1QB5K
         OweR6Tq8OBn4nBMBWqsjRwrdOqz3+iZbS+j5/aVCmjrMtIPDn8Uf9MCcyU/C9tYDshHx
         DwnWkataejSztqARuzeJ6j3bIH8yVNX4O3Kpi/ksPaKtA6xywG8ZLaQhlU4rb2xBUAPy
         5jjQ==
X-Gm-Message-State: AC+VfDyyV7CLTZBp0L/k4p3mST0VIhUQoWq/AyNfF6j1crva9+bKRfVG
	mVMc6QlQU8T6KgjyePcN4ejkrw==
X-Google-Smtp-Source: ACHHUZ4ZJe5qP97101KavMhYgetzTkIyNddrBs0aAl/z7IHiyA0QOaL7RwH6lY3RFknmPsPuiBa9nA==
X-Received: by 2002:a05:6a20:7fa8:b0:101:9344:bf82 with SMTP id d40-20020a056a207fa800b001019344bf82mr11034569pzj.15.1684738911283;
        Mon, 22 May 2023 00:01:51 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.251])
        by smtp.gmail.com with ESMTPSA id d27-20020a630e1b000000b0052cbd854927sm3687505pgl.18.2023.05.22.00.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 00:01:50 -0700 (PDT)
From: Abel Wu <wuyun.abel@bytedance.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Glauber Costa <glommer@parallels.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH v2 2/4] sock: Fix misuse of sk_under_memory_pressure()
Date: Mon, 22 May 2023 15:01:20 +0800
Message-Id: <20230522070122.6727-3-wuyun.abel@bytedance.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230522070122.6727-1-wuyun.abel@bytedance.com>
References: <20230522070122.6727-1-wuyun.abel@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
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

Fixes: e1aab161e013 ("socket: initial cgroup code")
Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 include/net/sock.h | 9 +++++++--
 net/core/sock.c    | 2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index c73d9bad7ac7..bf930d4db7f0 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1409,14 +1409,19 @@ static inline bool sk_has_memory_pressure(const struct sock *sk)
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
 	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
 	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
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


