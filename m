Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D307F445D89
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 02:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhKEBwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 21:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbhKEBwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 21:52:36 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E869CC061203
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 18:49:57 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id o14so11310400wra.12
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 18:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rQaR7pp39Z0B6hBnX5gFqMWGoIyCNaiLBW5E59MvVPU=;
        b=HpKBBKdcwfPb3BMYNPFePf+BzaC0GDFahXGNk6Xf3M1UObOb5421v7FFc07VdVU1WC
         J1/772b1SSlAjfPajdR2V345GHLG07oHXjOpjrNG9cCKsPCpANeP0PkuM/zcErR0oM0g
         Dc79B3CVgKl8USygfoQVaNZfvertwqBr2p7yFq1c+z4f7YKLMEsXEAnpn4GZVOBYhghM
         3JHacOGOA2OQN5WjvHNOhualZnF72yExBCkAjzZFdMgUdeE7b6CGhHMvMMKCS8esz/bt
         Ux9z52Qpt9kOdySlK08zeRih87wA8bgyYpdEptTrw5NOVHLDy9j0SY2lJn75SYlj7CMW
         BrAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rQaR7pp39Z0B6hBnX5gFqMWGoIyCNaiLBW5E59MvVPU=;
        b=Jpsjg2laLnU4PEjvO3HupC8rxFpCuIFSFI76nWXmLdPvM/ySDlGgoJBAuvwhK1NLuZ
         6IiNKIKX67SGY9aQJJKcB/i/f7sTf6o/ac3nPUM3ZoeO3EEseFNQTL/BdeVWHbuBYD40
         VueSr6rAAa4g/k+9EFaZEhFbyDXQs+tdxKZ7ZKo17i5D/hUM9SnE9Z+5ZkYC7pQQOwKd
         nqT1lhe17RNDp5kCDsz6OF2q+/WqrEYGSm7UMfYzrUN2i2xGnTR5BQ9IUwnwDs9ENvzd
         yZIx4XKmaBCZDRcsFCsCcmhdg2NnXurtYowRpWonqzO2++V+nTpwCzJubSa0/SeH6mQL
         rFVA==
X-Gm-Message-State: AOAM530UNsNe9xOcyUQXPdKwWUARBzwu8URAo8GQYd1xZBgfrLllkupw
        PrJL0TyLLbZtjFYgPdtAUXdjag==
X-Google-Smtp-Source: ABdhPJxood27uGNuAJy89dbUs4q1LVV544g8s4ei9ZS6BOn6gHSZyEs/iyJSjCj57SDkdUgfgcoRdg==
X-Received: by 2002:adf:a389:: with SMTP id l9mr58721497wrb.121.1636076996488;
        Thu, 04 Nov 2021 18:49:56 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c6sm7202421wmq.46.2021.11.04.18.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 18:49:56 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/5] tcp/md5: Don't BUG_ON() failed kmemdup()
Date:   Fri,  5 Nov 2021 01:49:49 +0000
Message-Id: <20211105014953.972946-2-dima@arista.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211105014953.972946-1-dima@arista.com>
References: <20211105014953.972946-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

static_branch_unlikely(&tcp_md5_needed) is enabled by
tcp_alloc_md5sig_pool(), so as long as the code doesn't change
tcp_md5sig_pool has been already populated if this code is being
executed.

In case tcptw->tw_md5_key allocaion failed - no reason to crash kernel:
tcp_{v4,v6}_send_ack() will send unsigned segment, the connection won't be
established, which is bad enough, but in OOM situation totally
acceptable and better than kernel crash.

Introduce tcp_md5sig_pool_ready() helper.
tcp_alloc_md5sig_pool() usage is intentionally avoided here as it's
fast-path here and it's check for sanity rather than point of actual
pool allocation. That will allow to have generic slow-path allocator
for tcp crypto pool.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h        | 1 +
 net/ipv4/tcp.c           | 5 +++++
 net/ipv4/tcp_minisocks.c | 5 +++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4da22b41bde6..3e5423a10a74 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1672,6 +1672,7 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
 #endif
 
 bool tcp_alloc_md5sig_pool(void);
+bool tcp_md5sig_pool_ready(void);
 
 struct tcp_md5sig_pool *tcp_get_md5sig_pool(void);
 static inline void tcp_put_md5sig_pool(void)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b7796b4cf0a0..c0856a6af9f5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4314,6 +4314,11 @@ bool tcp_alloc_md5sig_pool(void)
 }
 EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
 
+bool tcp_md5sig_pool_ready(void)
+{
+	return tcp_md5sig_pool_populated;
+}
+EXPORT_SYMBOL(tcp_md5sig_pool_ready);
 
 /**
  *	tcp_get_md5sig_pool - get md5sig_pool for this user
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index cf913a66df17..c99cdb529902 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -293,11 +293,12 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 			tcptw->tw_md5_key = NULL;
 			if (static_branch_unlikely(&tcp_md5_needed)) {
 				struct tcp_md5sig_key *key;
+				bool err = WARN_ON(!tcp_md5sig_pool_ready());
 
 				key = tp->af_specific->md5_lookup(sk, sk);
-				if (key) {
+				if (key && !err) {
 					tcptw->tw_md5_key = kmemdup(key, sizeof(*key), GFP_ATOMIC);
-					BUG_ON(tcptw->tw_md5_key && !tcp_alloc_md5sig_pool());
+					WARN_ON_ONCE(tcptw->tw_md5_key == NULL);
 				}
 			}
 		} while (0);
-- 
2.33.1

