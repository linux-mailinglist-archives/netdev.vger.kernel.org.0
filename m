Return-Path: <netdev+bounces-4150-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D349970B5CD
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:03:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA5421C209C4
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 07:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C1F63D3;
	Mon, 22 May 2023 07:02:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D80963C5
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:02:28 +0000 (UTC)
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412491FC3
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 00:02:04 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-64d2981e3abso2853002b3a.1
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 00:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684738919; x=1687330919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YKnhyBNVHnSoKN/wGLElGxvEFyvxXF8SFNAoMlqNKrY=;
        b=ZmZuiA9chQo3zzFy1MN/j1tmB3q9BwCEWejSH0Rw60P8CaMT86ntqYQ03QfwrZEVwq
         FkbNnm6pV+w/CbkyNpQ+JIfm6QmwN+qoKl+h+4+1xWAYo+xx2dS5AKRsDAhmXzTm3riv
         6Yo7TWV0fJGX3G/KMzwrWpCBq6ukeZdBlNENLcrA8ScMItzQjo6RKpDunzDs2oanPBXD
         bT6lMxF4eYBiZGA4Lw23kjUspUGRjpSUqS+8SDubOpIx/Nv5FJzFWf0+MgMdaFfeddqZ
         lv86fX/pMhyqLJO8qog2FKOhcCKTrmCQUbQsEEaaKowuWMks0r3LIMi2U5OtkHIU1Vd4
         ihOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684738919; x=1687330919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YKnhyBNVHnSoKN/wGLElGxvEFyvxXF8SFNAoMlqNKrY=;
        b=EOUAjCGy0suSWcYERy97pZPiPfgIdL2XCcXu0X1Ro9RY/KEk1J2SS+QbuJ1WfU9OYx
         igCw2wJgo/croCea5R4TNz7SfUyglrn6hdJ7jRDWUjRZAD5QoVnuIpTJ2JrrG6p9gVng
         R0I5ghZrvtFQ5gs1LD/sYGqH+YeSPS1pC7wZrK464A0yJZdyXFy6CGQTptg6C607WPqu
         LYlLy04/hOHG+etx7eETy8Ss6F0IXA+Ur5YvB3uvsXsbvf1/r7KhxO9sXnEY2ZRsLd8j
         vWQMlVRqhflgls70wsdvrmEKz09I+kSWuGl/0arQz17emsegdgLqtnIPG86g7Hx/nK5k
         JNkw==
X-Gm-Message-State: AC+VfDyJg+o4rPYvGiZSH2hkX2q8HXD9CPDLjQ3xswJEwGEFvRu2+5v7
	hcW/0FCkcaw973M8fy90WqBXBw==
X-Google-Smtp-Source: ACHHUZ4B/jsyzL/apdJ3kEiN7e27Upz2uNormul3H87UZR7L7LeAxfmRdG+5Y/bM8xTdHdg7t8zukg==
X-Received: by 2002:a05:6a21:918c:b0:106:3b67:b5db with SMTP id tp12-20020a056a21918c00b001063b67b5dbmr9275449pzb.18.1684738919559;
        Mon, 22 May 2023 00:01:59 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.251])
        by smtp.gmail.com with ESMTPSA id d27-20020a630e1b000000b0052cbd854927sm3687505pgl.18.2023.05.22.00.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 00:01:58 -0700 (PDT)
From: Abel Wu <wuyun.abel@bytedance.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Glauber Costa <glommer@parallels.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH v2 4/4] sock: Remove redundant cond of memcg pressure
Date: Mon, 22 May 2023 15:01:22 +0800
Message-Id: <20230522070122.6727-5-wuyun.abel@bytedance.com>
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
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Now with the preivous patch, __sk_mem_raise_allocated() considers
the memory pressure of both global and the socket's memcg on a func-
wide level, making the condition of memcg's pressure in question
redundant.

Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 net/core/sock.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 7641d64293af..baccbb58a11a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3029,9 +3029,14 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 	if (sk_has_memory_pressure(sk)) {
 		u64 alloc;
 
-		if (!sk_under_memory_pressure(sk))
+		if (!sk_under_global_memory_pressure(sk))
 			return 1;
 		alloc = sk_sockets_allocated_read_positive(sk);
+		/*
+		 * If under global pressure, allow the sockets that are below
+		 * average memory usage to raise, trying to be fair among all
+		 * the sockets under global constrains.
+		 */
 		if (sk_prot_mem_limits(sk, 2) > alloc *
 		    sk_mem_pages(sk->sk_wmem_queued +
 				 atomic_read(&sk->sk_rmem_alloc) +
-- 
2.37.3


