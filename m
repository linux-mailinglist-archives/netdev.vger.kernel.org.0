Return-Path: <netdev+bounces-4147-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F04970B5C3
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:02:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54CE31C209B6
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 07:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F044C46AF;
	Mon, 22 May 2023 07:02:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43814A36
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:02:17 +0000 (UTC)
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9441BDA
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 00:01:54 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-64d2f99c8c3so2107338b3a.0
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 00:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684738907; x=1687330907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bAQinShNGu83yZk3rp1RX6U81r/+0AkNU5ra2AmWYPc=;
        b=R6qQVs8Q1EC7za9C0/4qceRDywImj4defA+/MxD5u5cL6DHOsp8Fo7zRfkA3tL3j4D
         lNyjLVK9jTeCzqt/i4lcpUIX1xMtpu2n5MLzkWz0bmtuupHIhPGlQ3LrsbHgIiH+zGar
         GyFrcO5kZ90L8eXWQXvpl4AB9adbMG7raaVldlWWmBkSrPEvinkkSxojT5/qC6t1JoBC
         ZXFTp6y2KVlqqWOOjQkm668oAE21GsEVSwMZ4j3C2GwxiUCk1a8zYaCJIaes7V48eFmG
         osdXJSikN8/mo9c59yhD/vAZbZDI3aqEtXB1hsd2HTjTEjgpJVNe2C1o1N9raWiK4Zwo
         m3Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684738907; x=1687330907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bAQinShNGu83yZk3rp1RX6U81r/+0AkNU5ra2AmWYPc=;
        b=g/0tIk+LLGeMh8oXcZybE2gOFo2Tt8fBh8iJVT7eaLzrmAXECtwzYYzjW07gmUB65J
         4OChhWImfa3WzvysHG33T3bD+vIguT8ztSRKAEdxe3UPYbVH/3hLLjaQCHJ7GCAQK/0W
         3enqyDoseSpfpBEi6jOo3H9MeQwMA2Du0BNsH9jEMZU8fa8hAHyrpKs5rFlLGNwdTSix
         gSo8LHWLAfkaqVSuV56JxBN3AMPG+GRM9IHPwapecZrt9tlNoJ8qUhIWHPUxpXu4Q+nz
         R3h59oxNzvM3Gg8ofMd/MZNRAF71maoHwHT0a49llqFK5XEFNMDvh/jNZR0GGQtkOozC
         PHgQ==
X-Gm-Message-State: AC+VfDwY5q0HEVi7AQ3B7XkG6/Gq2LkLVYc8n4MoAMJr/6EVqMCNezxt
	sfeDlnnY3rjlX5/57kWDRDfowYCm64jv0XRrjBM=
X-Google-Smtp-Source: ACHHUZ5KWE6uNrz9B0dQhspuvs0CqmLb5hN3tWINo/EwRjj/SHAKsnFFjJrmCEAnGpvQaQbH8Q0wZQ==
X-Received: by 2002:a05:6a00:10c4:b0:63b:1708:10aa with SMTP id d4-20020a056a0010c400b0063b170810aamr12715822pfu.34.1684738907531;
        Mon, 22 May 2023 00:01:47 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.251])
        by smtp.gmail.com with ESMTPSA id d27-20020a630e1b000000b0052cbd854927sm3687505pgl.18.2023.05.22.00.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 00:01:46 -0700 (PDT)
From: Abel Wu <wuyun.abel@bytedance.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Glauber Costa <glommer@parallels.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH v2 1/4] sock: Always take memcg pressure into consideration
Date: Mon, 22 May 2023 15:01:19 +0800
Message-Id: <20230522070122.6727-2-wuyun.abel@bytedance.com>
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

The sk_under_memory_pressure() is called to check whether there is
memory pressure related to this socket. But now it ignores the net-
memcg's pressure if the proto of the socket doesn't care about the
global pressure, which may put burden on its memcg compaction or
reclaim path (also remember that socket memory is un-reclaimable).

So always check the memcg's vm status to alleviate memstalls when
it's in pressure.

Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 include/net/sock.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 8b7ed7167243..c73d9bad7ac7 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1411,14 +1411,12 @@ static inline bool sk_has_memory_pressure(const struct sock *sk)
 
 static inline bool sk_under_memory_pressure(const struct sock *sk)
 {
-	if (!sk->sk_prot->memory_pressure)
-		return false;
-
 	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
 	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
-	return !!*sk->sk_prot->memory_pressure;
+	return sk->sk_prot->memory_pressure &&
+		*sk->sk_prot->memory_pressure;
 }
 
 static inline long
-- 
2.37.3


