Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050DF445D92
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 02:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhKEBwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 21:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbhKEBwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 21:52:40 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CADDC06120E
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 18:50:01 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so5502661wme.4
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 18:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WVMQGvz1JzGP49ZR8f4x6hDkNtNhDSqb+g0cz83wFEk=;
        b=aQis27S3L+OgQ+z6AX4zIqgONns+vOrRZSCxRNJKDl2E/hcWqNWPWZWCkZqW6wQp4y
         rA0hpX6aLuO6nIFLvLrtspeh6p567c4anqR/P95x2EnKBX1y9Hx2xC1Rv9cj1qxXzIdl
         +ymQehYcx1yyP4SVP/LvrOgliB0yl/jKh2Ok4588P/NW3xtMttucku08lcSUk+f5Wsmm
         0NRNzbCkIVF5dBbl+no+MLwiYew7d1BKZqlcMJFFRhLz5lDNXpCJj7CdsepZ0RFMncXr
         U6izbYBg/r+QB8i4tH146wN2DCBaARhTgDliXtHRvL27hGFf0lVjeMID/mu9rDmraUxf
         7o3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WVMQGvz1JzGP49ZR8f4x6hDkNtNhDSqb+g0cz83wFEk=;
        b=DPqtxAI5f9pJ9wg5V9YMdW99byuBawcWFPmtK0AicCoUa+TLHzeNwodLUCKJfXPGjL
         1X72h6JAoboEDK0cnASHPQZUqxPzK9ekRj02G+Zl2nSBa+eH4Ll7/vXjtYUg1cyeuwZf
         nZzJNcKd8acFz8U2p6j/leDONBoRxQeMmMRNllKaA6CoUKcIvtUfYo08e1w/uZ0rrFec
         Y42UQUQuR27bgWtMGRhiVXDsYLqyYIY34cbem4tkfI3TzyDB3GiaPCV04ynkIR4zo1KF
         PSlNgS+xawhYGCRFRLvS3HJTL26aeu66asJm3Iw9V4vhYK+l6LX4b7h4OoVYa6p1dJiM
         FkwQ==
X-Gm-Message-State: AOAM530xlm0FukGnIU7LKfBC4OW8HDCRKEKjnVtAiJBH0S4Ic2v3Anks
        yQriwGSfolYYcQo6bVwqTyg0mw==
X-Google-Smtp-Source: ABdhPJzWbDL+KacOMA9l2vNuuEV3oFBBsEmnMC/TaPUAaxAIjQYjGZoT7K2DUv2v7rdxZqK7lnfd3w==
X-Received: by 2002:a05:600c:a49:: with SMTP id c9mr28076855wmq.172.1636076999814;
        Thu, 04 Nov 2021 18:49:59 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c6sm7202421wmq.46.2021.11.04.18.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 18:49:59 -0700 (PDT)
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
Subject: [PATCH 4/5] tcp/md5: Use tcp_md5sig_pool_* naming scheme
Date:   Fri,  5 Nov 2021 01:49:52 +0000
Message-Id: <20211105014953.972946-5-dima@arista.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211105014953.972946-1-dima@arista.com>
References: <20211105014953.972946-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use common prefixes for operations with (struct tcp_md5sig_pool).

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h   |  6 +++---
 net/ipv4/tcp.c      | 18 +++++++++---------
 net/ipv4/tcp_ipv4.c | 14 +++++++-------
 net/ipv6/tcp_ipv6.c | 14 +++++++-------
 4 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 3e5423a10a74..27eb71dd7ff8 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1671,11 +1671,11 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
 #define tcp_twsk_md5_key(twsk)	NULL
 #endif
 
-bool tcp_alloc_md5sig_pool(void);
+bool tcp_md5sig_pool_alloc(void);
 bool tcp_md5sig_pool_ready(void);
 
-struct tcp_md5sig_pool *tcp_get_md5sig_pool(void);
-static inline void tcp_put_md5sig_pool(void)
+struct tcp_md5sig_pool *tcp_md5sig_pool_get(void);
+static inline void tcp_md5sig_pool_put(void)
 {
 	local_bh_enable();
 }
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index eb478028b1ea..8d8692fc9cd5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4257,7 +4257,7 @@ static DEFINE_PER_CPU(struct tcp_md5sig_pool, tcp_md5sig_pool);
 static DEFINE_MUTEX(tcp_md5sig_mutex);
 static bool tcp_md5sig_pool_populated = false;
 
-static void __tcp_alloc_md5sig_pool(void)
+static void __tcp_md5sig_pool_alloc(void)
 {
 	struct crypto_ahash *hash;
 	int cpu;
@@ -4289,7 +4289,7 @@ static void __tcp_alloc_md5sig_pool(void)
 		per_cpu(tcp_md5sig_pool, cpu).md5_req = req;
 	}
 	/* before setting tcp_md5sig_pool_populated, we must commit all writes
-	 * to memory. See smp_rmb() in tcp_get_md5sig_pool()
+	 * to memory. See smp_rmb() in tcp_md5sig_pool_get()
 	 */
 	smp_wmb();
 	tcp_md5sig_pool_populated = true;
@@ -4305,13 +4305,13 @@ static void __tcp_alloc_md5sig_pool(void)
 	crypto_free_ahash(hash);
 }
 
-bool tcp_alloc_md5sig_pool(void)
+bool tcp_md5sig_pool_alloc(void)
 {
 	if (unlikely(!tcp_md5sig_pool_populated)) {
 		mutex_lock(&tcp_md5sig_mutex);
 
 		if (!tcp_md5sig_pool_populated) {
-			__tcp_alloc_md5sig_pool();
+			__tcp_md5sig_pool_alloc();
 			if (tcp_md5sig_pool_populated)
 				static_branch_inc(&tcp_md5_needed);
 		}
@@ -4320,7 +4320,7 @@ bool tcp_alloc_md5sig_pool(void)
 	}
 	return tcp_md5sig_pool_populated;
 }
-EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
+EXPORT_SYMBOL(tcp_md5sig_pool_alloc);
 
 bool tcp_md5sig_pool_ready(void)
 {
@@ -4329,25 +4329,25 @@ bool tcp_md5sig_pool_ready(void)
 EXPORT_SYMBOL(tcp_md5sig_pool_ready);
 
 /**
- *	tcp_get_md5sig_pool - get md5sig_pool for this user
+ *	tcp_md5sig_pool_get - get md5sig_pool for this user
  *
  *	We use percpu structure, so if we succeed, we exit with preemption
  *	and BH disabled, to make sure another thread or softirq handling
  *	wont try to get same context.
  */
-struct tcp_md5sig_pool *tcp_get_md5sig_pool(void)
+struct tcp_md5sig_pool *tcp_md5sig_pool_get(void)
 {
 	local_bh_disable();
 
 	if (tcp_md5sig_pool_populated) {
-		/* coupled with smp_wmb() in __tcp_alloc_md5sig_pool() */
+		/* coupled with smp_wmb() in __tcp_md5sig_pool_alloc() */
 		smp_rmb();
 		return this_cpu_ptr(&tcp_md5sig_pool);
 	}
 	local_bh_enable();
 	return NULL;
 }
-EXPORT_SYMBOL(tcp_get_md5sig_pool);
+EXPORT_SYMBOL(tcp_md5sig_pool_get);
 
 int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
 			  const struct sk_buff *skb, unsigned int header_len)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6a8ff9ab1cbc..44db9afa17fc 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1294,7 +1294,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
-	if (!tcp_alloc_md5sig_pool())
+	if (!tcp_md5sig_pool_alloc())
 		return -ENOMEM;
 
 	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen, l3index, flags,
@@ -1332,7 +1332,7 @@ static int tcp_v4_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
 	struct tcp_md5sig_pool *hp;
 	struct ahash_request *req;
 
-	hp = tcp_get_md5sig_pool();
+	hp = tcp_md5sig_pool_get();
 	if (!hp)
 		goto clear_hash_noput;
 	req = hp->md5_req;
@@ -1347,11 +1347,11 @@ static int tcp_v4_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
 	if (crypto_ahash_final(req))
 		goto clear_hash;
 
-	tcp_put_md5sig_pool();
+	tcp_md5sig_pool_put();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
+	tcp_md5sig_pool_put();
 clear_hash_noput:
 	memset(md5_hash, 0, 16);
 	return 1;
@@ -1375,7 +1375,7 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 		daddr = iph->daddr;
 	}
 
-	hp = tcp_get_md5sig_pool();
+	hp = tcp_md5sig_pool_get();
 	if (!hp)
 		goto clear_hash_noput;
 	req = hp->md5_req;
@@ -1393,11 +1393,11 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 	if (crypto_ahash_final(req))
 		goto clear_hash;
 
-	tcp_put_md5sig_pool();
+	tcp_md5sig_pool_put();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
+	tcp_md5sig_pool_put();
 clear_hash_noput:
 	memset(md5_hash, 0, 16);
 	return 1;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 3af13bd6fed0..9147f9f69196 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -654,7 +654,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
-	if (!tcp_alloc_md5sig_pool())
+	if (!tcp_md5sig_pool_alloc())
 		return -ENOMEM;
 
 	if (ipv6_addr_v4mapped(&sin6->sin6_addr))
@@ -701,7 +701,7 @@ static int tcp_v6_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
 	struct tcp_md5sig_pool *hp;
 	struct ahash_request *req;
 
-	hp = tcp_get_md5sig_pool();
+	hp = tcp_md5sig_pool_get();
 	if (!hp)
 		goto clear_hash_noput;
 	req = hp->md5_req;
@@ -716,11 +716,11 @@ static int tcp_v6_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
 	if (crypto_ahash_final(req))
 		goto clear_hash;
 
-	tcp_put_md5sig_pool();
+	tcp_md5sig_pool_put();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
+	tcp_md5sig_pool_put();
 clear_hash_noput:
 	memset(md5_hash, 0, 16);
 	return 1;
@@ -745,7 +745,7 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 		daddr = &ip6h->daddr;
 	}
 
-	hp = tcp_get_md5sig_pool();
+	hp = tcp_md5sig_pool_get();
 	if (!hp)
 		goto clear_hash_noput;
 	req = hp->md5_req;
@@ -763,11 +763,11 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 	if (crypto_ahash_final(req))
 		goto clear_hash;
 
-	tcp_put_md5sig_pool();
+	tcp_md5sig_pool_put();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
+	tcp_md5sig_pool_put();
 clear_hash_noput:
 	memset(md5_hash, 0, 16);
 	return 1;
-- 
2.33.1

