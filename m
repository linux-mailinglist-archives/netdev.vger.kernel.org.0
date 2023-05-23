Return-Path: <netdev+bounces-4623-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ABD970D981
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:48:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3ACEB2812FF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:48:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C36821EA8E;
	Tue, 23 May 2023 09:47:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86241DDE5
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:47:30 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C50132
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:47:29 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-64d2c865e4eso3772266b3a.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684835248; x=1687427248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bJNRFp1URkkAv14Fvh/BUBB9PNFK79930mw7UGuUDQY=;
        b=U4Qt34Z6pN6W4AL25USGqBadP06Vqhmo9JSJfVQCZc70CiJ7M0OKga9craqFE0GnI8
         NLMJIANE63+DHnEOMIxX7DO2qCdEbewRVqGS/O5pO5br4bfTrc3uDxLszVxc0OgolxnV
         aTa3JwnkdYOcbk3XEh+RIbsrLWwrH+lxONrUG5XwpcLq7ppOwFzilXmbro7u+yhFVsMP
         EN7fQjzet+Sv/Ubmgtxp0XjM+pbLUo9GrvYaHYWEq6DDhhD4nRGmFih1fAPFp9SgP5jG
         tRmJMdYXzqa4ezGKi45YbtXY94ukxpsPSM9JKp5hSByxj0OnJRYdhlAJFFui19XBhUR6
         1qkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684835248; x=1687427248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bJNRFp1URkkAv14Fvh/BUBB9PNFK79930mw7UGuUDQY=;
        b=aErr3G9hmRIVHvACaUgid7uxh8d0YtLHNXFfo+2ZN9AeW0a0iH+m+cMgv30Vou0OJ5
         dA6GaonitSi5edcptnpOYOU5dySdQgEha6KeZmotecOevYwNZYhGufHoO6Z5idI5BlN7
         5ihrisEYkwmvBUWXHHjuOsjhGzKCg6XGeKg1PFWJNCT+wy8F4tDVZIFXwaWMNs6nDpQ4
         56PPbdRI75DPJASxWIs0ntiym6uT26GzmBOuLOvdkhB7UqU2eAHgXi5bcoVWkgQirouj
         4XgwU5JQvTZ59E9Iy+Js0DUURl4KdPeHGj28cSGhM7K98UTcLDm89GTvms1fQBiAXiw4
         L0Qg==
X-Gm-Message-State: AC+VfDyBczHCo0QH4Fy7AJhjjBctzy6MqCfcOhJFRZrsHTqW9kNV+gwU
	pMmf3pKUG6/oZzdgCzYzayHUjw==
X-Google-Smtp-Source: ACHHUZ5B4JuSyG1yjWcuVZ88SwoM2AMIukUX5pAMUXBebemZ2uyfglRo+Cw4QPlOctY7/9Er7B2+Rw==
X-Received: by 2002:a05:6a20:3d09:b0:10a:cbe6:69f0 with SMTP id y9-20020a056a203d0900b0010acbe669f0mr11156449pzi.10.1684835248601;
        Tue, 23 May 2023 02:47:28 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.230])
        by smtp.gmail.com with ESMTPSA id 22-20020aa79116000000b0063b898b3502sm5457216pfh.153.2023.05.23.02.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 02:47:28 -0700 (PDT)
From: Abel Wu <wuyun.abel@bytedance.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH v3 5/5] sock: Remove redundant cond of memcg pressure
Date: Tue, 23 May 2023 17:46:52 +0800
Message-Id: <20230523094652.49411-6-wuyun.abel@bytedance.com>
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
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Now with the previous patch, __sk_mem_raise_allocated() considers
the memory pressure of both global and the socket's memcg on a func-
wide level, making the condition of memcg's pressure in question
redundant.

Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 net/core/sock.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index b899e0b9feda..b2deffb81c86 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3029,9 +3029,15 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 	if (sk_has_memory_pressure(sk)) {
 		u64 alloc;
 
-		if (!sk_under_memory_pressure(sk))
+		if (!sk_under_global_memory_pressure(sk))
 			return 1;
+
 		alloc = sk_sockets_allocated_read_positive(sk);
+
+		/* If under global pressure, allow the sockets that are below
+		 * average memory usage to raise, trying to be fair among all
+		 * the sockets under global constrains.
+		 */
 		if (sk_prot_mem_limits(sk, 2) > alloc *
 		    sk_mem_pages(sk->sk_wmem_queued +
 				 atomic_read(&sk->sk_rmem_alloc) +
-- 
2.37.3


