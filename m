Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE8F5443D3
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 08:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiFIGeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 02:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiFIGeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 02:34:19 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11AF186FD
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 23:34:18 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o6-20020a17090a0a0600b001e2c6566046so25881100pjo.0
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 23:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0abhAtFaXlCnrdg1se2pezovH988jn6vXslYDVO4DCQ=;
        b=LozJ88UFfUpkyR6WO4meNvzURoaajlF8NtbtbQhNzgiI0JGy5tZ5oezDz/HZjym23X
         IAciUJFN/GuLFLXwEX+AFHCYxILqZhfSx+eVlpE3ABje9GO09NIZ+CgQRW9W6jXFuwSL
         VPoXXt1zAvnNwPriuzxNQzhR4Qq14xEkFDD8AwzK/fhXS2HQNpkuygMZNf8JTNj6Zc4O
         a0YtbJ8WCBex/JFqA8cVPMOAFHG4eb5rTC2NKUAi2ZY6T2zQoiFxElV3JsJ47v1Rwe64
         8rN57MGpjxcUO4N7ZJUbYVW5g3fXUfdD5M3j3yLuiOBperU/VY1En7lAiXT9sDf1fU64
         5mfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0abhAtFaXlCnrdg1se2pezovH988jn6vXslYDVO4DCQ=;
        b=5xeaWN/rpoh+ymb86bGSdbo4zNUn0AD6V1jzlfYGzthOPq344O8EG0EO8l6PCnJwse
         WEYSZB2JqKU6FK/zlwVgKVoPglMd+9ngxGP/LXci59W+WmY7hdQUh0gE+FvBOKNlZuVd
         te1sUeibC85AHFDlLL915eKs7MSZI5UbTqt3+Aq4jweWjKmBWEAHh55CtniUDWjivX05
         7jqWUS/EHaa1kCuUzpOn9qT6bybWcLPSbEacj0uKmSjqBo8BKL7s+BjBVT8yY7iUfA8R
         +I1y2OzgIRy33UxObgbns9wd2FBUBEEWgt+Lx83syCFVi2diwyMnJZBuDNBWHhXamd4a
         qoYA==
X-Gm-Message-State: AOAM5300EWKU0Kt6dyyCBfhc3SRRIvhqoYH6GvM/9dDjzz9wjY+wsxBO
        gdpKiWTfB38+wzurHJUt4Ik=
X-Google-Smtp-Source: ABdhPJyM0H2GjPUUYYBzTNwmKfhlhMAQfBAoCvWrFQoeemFwRYJ9l+uoj5+6z1AQYQXfoXJjM0miAg==
X-Received: by 2002:a17:903:2287:b0:164:95f:b4d6 with SMTP id b7-20020a170903228700b00164095fb4d6mr37713685plh.140.1654756458553;
        Wed, 08 Jun 2022 23:34:18 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id 199-20020a6215d0000000b0051b9c0af43dsm16340050pfv.155.2022.06.08.23.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 23:34:18 -0700 (PDT)
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
Subject: [PATCH net-next 1/7] Revert "net: set SK_MEM_QUANTUM to 4096"
Date:   Wed,  8 Jun 2022 23:34:06 -0700
Message-Id: <20220609063412.2205738-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220609063412.2205738-1-eric.dumazet@gmail.com>
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
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

This reverts commit bd68a2a854ad5a85f0c8d0a9c8048ca3f6391efb.

This change broke memcg on arches with PAGE_SIZE != 4096

Later, commit 2bb2f5fb21b04 ("net: add new socket option SO_RESERVE_MEM")
also assumed PAGE_SIZE==SK_MEM_QUANTUM

Following patches in the series will greatly reduce the over allocations
problem.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 657873e2d90fbb2254144aa2405a0551a789edbb..5c5265269899091a7bb8f14766085a463a476403 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1532,25 +1532,15 @@ int __sk_mem_schedule(struct sock *sk, int size, int kind);
 void __sk_mem_reduce_allocated(struct sock *sk, int amount);
 void __sk_mem_reclaim(struct sock *sk, int amount);
 
-/* We used to have PAGE_SIZE here, but systems with 64KB pages
- * do not necessarily have 16x time more memory than 4KB ones.
- */
-#define SK_MEM_QUANTUM 4096
+#define SK_MEM_QUANTUM ((int)PAGE_SIZE)
 #define SK_MEM_QUANTUM_SHIFT ilog2(SK_MEM_QUANTUM)
 #define SK_MEM_SEND	0
 #define SK_MEM_RECV	1
 
-/* sysctl_mem values are in pages, we convert them in SK_MEM_QUANTUM units */
+/* sysctl_mem values are in pages */
 static inline long sk_prot_mem_limits(const struct sock *sk, int index)
 {
-	long val = sk->sk_prot->sysctl_mem[index];
-
-#if PAGE_SIZE > SK_MEM_QUANTUM
-	val <<= PAGE_SHIFT - SK_MEM_QUANTUM_SHIFT;
-#elif PAGE_SIZE < SK_MEM_QUANTUM
-	val >>= SK_MEM_QUANTUM_SHIFT - PAGE_SHIFT;
-#endif
-	return val;
+	return sk->sk_prot->sysctl_mem[index];
 }
 
 static inline int sk_mem_pages(int amt)
-- 
2.36.1.255.ge46751e96f-goog

