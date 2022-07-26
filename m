Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9D9581AD7
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 22:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239908AbiGZUQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 16:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239863AbiGZUQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 16:16:22 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149A932B84
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:16:14 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id g2so13550768wru.3
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=pmSO5o3Q44tqKwKFfKNMm0Ze8ef3CVpVV9CI9yXzviE=;
        b=D5lUTewwVLHHGjzMcNus5GsYhY5VOyJ5EbsBDumqrRq9zpSv8LL+NILNY+idc7V+jy
         gwssJlDW4770QDmmsH1d8Z2O7J/OOre7FLr4zdjpP6erd/N5/yx5S7DUdz/51yqjxP1F
         XkQpdIlAPcuuU9EK2Hp55iUVvyctYxw5oBCKEMSQJ7N5BNayUJNb8F5yjlmA8z28kUVP
         A/AzsOtOML497PIrxw9l3CfdJCNw9/gT3tP0R6Td5iUkT08C2NtmMEKETjiSeQZku+3s
         IoRefq1rlqZP+SVAhReLcNqCIZfD07wbzR0r9SkPpyEzb0AaR/oVqFPa8A4oqfVyQGOU
         pNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=pmSO5o3Q44tqKwKFfKNMm0Ze8ef3CVpVV9CI9yXzviE=;
        b=o5lzk3DN/UlK1LayBI4X5LqtWeEPIDbuwCb2aW7LWGNDL9NevMaZ67L7ms6Q6aamgb
         Wt55zY5Pc9xQtoUCigYldBSf/HBM1WwiY78jEjQ6TtE6/CURLX+a99U+/giMHyS3wvSn
         t/b1vsBJwxas9wnp94pIphhcRF1hEVtaOQBUAwjJsWeSTGQfSyCU8Fd9gj7cKk/na2hL
         /25k9eJmhac5oqVtO88xWlj2e1tklBTZ4Ha8X2TWKxAaIa1FsGyws61LmGlcrY5pMT4E
         xLvsdqCMi0pD98cSvyeqtKqV5+8xR+loXv/1fkoyWSCFvPZ34i++Y55cXQ6/xnRKkIAs
         kPcw==
X-Gm-Message-State: AJIora/sBFlcSHUZrpvw1paoF/yRXz0UE7EEnqXtll5QOP2hvwOfAzHe
        bgeS0tV5E9FRYDXC0i3qaeZIJA==
X-Google-Smtp-Source: AGRyM1uB79Y9Ri2seTNWcO7Gq0vlx1PC/AF/5zeWVVl++TFNfM6zhF2Jc/Q/fwlASGpGWU8eiPG99Q==
X-Received: by 2002:a05:6000:986:b0:21e:939b:a71 with SMTP id by6-20020a056000098600b0021e939b0a71mr5780694wrb.256.1658866572371;
        Tue, 26 Jul 2022 13:16:12 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c3b0600b003a320e6f011sm28073wms.1.2022.07.26.13.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 13:16:11 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 4/6] net/tcp: Disable TCP-MD5 static key on tcp_md5sig_info destruction
Date:   Tue, 26 Jul 2022 21:15:58 +0100
Message-Id: <20220726201600.1715505-5-dima@arista.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220726201600.1715505-1-dima@arista.com>
References: <20220726201600.1715505-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To do that, separate two scenarios:
- where it's the first MD5 key on the system, which means that enabling
  of the static key may need to sleep;
- copying of an existing key from a listening socket to the request
  socket upon receiving a signed TCP segment, where static key was
  already enabled (when the key was added to the listening socket).

Now the life-time of the static branch for TCP-MD5 is until:
- last tcp_md5sig_info is destroyed
- last socket in time-wait state with MD5 key is closed.

Which means that after all sockets with TCP-MD5 keys are gone, the
system gets back the performance of disabled md5-key static branch.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h        | 10 ++++++---
 net/ipv4/tcp.c           |  5 +----
 net/ipv4/tcp_ipv4.c      | 45 +++++++++++++++++++++++++++++++---------
 net/ipv4/tcp_minisocks.c |  9 +++++---
 net/ipv4/tcp_output.c    |  4 ++--
 net/ipv6/tcp_ipv6.c      | 10 ++++-----
 6 files changed, 55 insertions(+), 28 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index f366626cbbba..aa735f963723 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1663,7 +1663,11 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 			const struct sock *sk, const struct sk_buff *skb);
 int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		   int family, u8 prefixlen, int l3index, u8 flags,
-		   const u8 *newkey, u8 newkeylen, gfp_t gfp);
+		   const u8 *newkey, u8 newkeylen);
+int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
+		     int family, u8 prefixlen, int l3index,
+		     struct tcp_md5sig_key *key);
+
 int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr,
 		   int family, u8 prefixlen, int l3index, u8 flags);
 struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
@@ -1671,7 +1675,7 @@ struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
 
 #ifdef CONFIG_TCP_MD5SIG
 #include <linux/jump_label.h>
-extern struct static_key_false tcp_md5_needed;
+extern struct static_key_false_deferred tcp_md5_needed;
 struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 					   const union tcp_md5_addr *addr,
 					   int family);
@@ -1679,7 +1683,7 @@ static inline struct tcp_md5sig_key *
 tcp_md5_do_lookup(const struct sock *sk, int l3index,
 		  const union tcp_md5_addr *addr, int family)
 {
-	if (!static_branch_unlikely(&tcp_md5_needed))
+	if (!static_branch_unlikely(&tcp_md5_needed.key))
 		return NULL;
 	return __tcp_md5_do_lookup(sk, l3index, addr, family);
 }
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 635c6782cdbb..300056008e90 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4404,11 +4404,8 @@ bool tcp_alloc_md5sig_pool(void)
 	if (unlikely(!tcp_md5sig_pool_populated)) {
 		mutex_lock(&tcp_md5sig_mutex);
 
-		if (!tcp_md5sig_pool_populated) {
+		if (!tcp_md5sig_pool_populated)
 			__tcp_alloc_md5sig_pool();
-			if (tcp_md5sig_pool_populated)
-				static_branch_inc(&tcp_md5_needed);
-		}
 
 		mutex_unlock(&tcp_md5sig_mutex);
 	}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 55e4092209a5..5b0caaea5029 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1044,7 +1044,7 @@ static void tcp_v4_reqsk_destructor(struct request_sock *req)
  * We need to maintain these in the sk structure.
  */
 
-DEFINE_STATIC_KEY_FALSE(tcp_md5_needed);
+DEFINE_STATIC_KEY_DEFERRED_FALSE(tcp_md5_needed, HZ);
 EXPORT_SYMBOL(tcp_md5_needed);
 
 static bool better_md5_match(struct tcp_md5sig_key *old, struct tcp_md5sig_key *new)
@@ -1171,9 +1171,9 @@ static int tcp_md5sig_info_add(struct sock *sk, gfp_t gfp)
 }
 
 /* This can be called on a newly created socket, from other files */
-int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
-		   int family, u8 prefixlen, int l3index, u8 flags,
-		   const u8 *newkey, u8 newkeylen, gfp_t gfp)
+int __tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
+		     int family, u8 prefixlen, int l3index, u8 flags,
+		     const u8 *newkey, u8 newkeylen, gfp_t gfp)
 {
 	/* Add Key to the list */
 	struct tcp_md5sig_key *key;
@@ -1200,9 +1200,6 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		return 0;
 	}
 
-	if (tcp_md5sig_info_add(sk, gfp))
-		return -ENOMEM;
-
 	md5sig = rcu_dereference_protected(tp->md5sig_info,
 					   lockdep_sock_is_held(sk));
 
@@ -1226,8 +1223,36 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	hlist_add_head_rcu(&key->node, &md5sig->head);
 	return 0;
 }
+
+int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
+		   int family, u8 prefixlen, int l3index, u8 flags,
+		   const u8 *newkey, u8 newkeylen)
+{
+	if (tcp_md5sig_info_add(sk, GFP_KERNEL))
+		return -ENOMEM;
+
+	static_branch_inc(&tcp_md5_needed.key);
+
+	return __tcp_md5_do_add(sk, addr, family, prefixlen, l3index, flags,
+				newkey, newkeylen, GFP_KERNEL);
+}
 EXPORT_SYMBOL(tcp_md5_do_add);
 
+int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
+		     int family, u8 prefixlen, int l3index,
+		     struct tcp_md5sig_key *key)
+{
+	if (tcp_md5sig_info_add(sk, sk_gfp_mask(sk, GFP_ATOMIC)))
+		return -ENOMEM;
+
+	atomic_inc(&tcp_md5_needed.key.key.enabled);
+
+	return __tcp_md5_do_add(sk, addr, family, prefixlen, l3index,
+				key->flags, key->key, key->keylen,
+				sk_gfp_mask(sk, GFP_ATOMIC));
+}
+EXPORT_SYMBOL(tcp_md5_key_copy);
+
 int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr, int family,
 		   u8 prefixlen, int l3index, u8 flags)
 {
@@ -1314,7 +1339,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 		return -EINVAL;
 
 	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen, l3index, flags,
-			      cmd.tcpm_key, cmd.tcpm_keylen, GFP_KERNEL);
+			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
 static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
@@ -1571,8 +1596,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 		 * memory, then we end up not copying the key
 		 * across. Shucks.
 		 */
-		tcp_md5_do_add(newsk, addr, AF_INET, 32, l3index, key->flags,
-			       key->key, key->keylen, GFP_ATOMIC);
+		tcp_md5_key_copy(newsk, addr, AF_INET, 32, l3index, key);
 		sk_gso_disable(newsk);
 	}
 #endif
@@ -2260,6 +2284,7 @@ void tcp_v4_destroy_sock(struct sock *sk)
 		tcp_clear_md5_list(sk);
 		kfree_rcu(rcu_dereference_protected(tp->md5sig_info, 1), rcu);
 		tp->md5sig_info = NULL;
+		static_branch_slow_dec_deferred(&tcp_md5_needed);
 	}
 #endif
 
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index cb95d88497ae..5d475a45a478 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -291,13 +291,14 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 		 */
 		do {
 			tcptw->tw_md5_key = NULL;
-			if (static_branch_unlikely(&tcp_md5_needed)) {
+			if (static_branch_unlikely(&tcp_md5_needed.key)) {
 				struct tcp_md5sig_key *key;
 
 				key = tp->af_specific->md5_lookup(sk, sk);
 				if (key) {
 					tcptw->tw_md5_key = kmemdup(key, sizeof(*key), GFP_ATOMIC);
 					BUG_ON(tcptw->tw_md5_key && !tcp_alloc_md5sig_pool());
+					atomic_inc(&tcp_md5_needed.key.key.enabled);
 				}
 			}
 		} while (0);
@@ -337,11 +338,13 @@ EXPORT_SYMBOL(tcp_time_wait);
 void tcp_twsk_destructor(struct sock *sk)
 {
 #ifdef CONFIG_TCP_MD5SIG
-	if (static_branch_unlikely(&tcp_md5_needed)) {
+	if (static_branch_unlikely(&tcp_md5_needed.key)) {
 		struct tcp_timewait_sock *twsk = tcp_twsk(sk);
 
-		if (twsk->tw_md5_key)
+		if (twsk->tw_md5_key) {
 			kfree_rcu(twsk->tw_md5_key, rcu);
+			static_branch_slow_dec_deferred(&tcp_md5_needed);
+		}
 	}
 #endif
 }
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 78b654ff421b..9e12845a8758 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -766,7 +766,7 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 
 	*md5 = NULL;
 #ifdef CONFIG_TCP_MD5SIG
-	if (static_branch_unlikely(&tcp_md5_needed) &&
+	if (static_branch_unlikely(&tcp_md5_needed.key) &&
 	    rcu_access_pointer(tp->md5sig_info)) {
 		*md5 = tp->af_specific->md5_lookup(sk, sk);
 		if (*md5) {
@@ -922,7 +922,7 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 
 	*md5 = NULL;
 #ifdef CONFIG_TCP_MD5SIG
-	if (static_branch_unlikely(&tcp_md5_needed) &&
+	if (static_branch_unlikely(&tcp_md5_needed.key) &&
 	    rcu_access_pointer(tp->md5sig_info)) {
 		*md5 = tp->af_specific->md5_lookup(sk, sk);
 		if (*md5) {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index e54eee80ce5f..cb891a71db0d 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -658,12 +658,11 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	if (ipv6_addr_v4mapped(&sin6->sin6_addr))
 		return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3],
 				      AF_INET, prefixlen, l3index, flags,
-				      cmd.tcpm_key, cmd.tcpm_keylen,
-				      GFP_KERNEL);
+				      cmd.tcpm_key, cmd.tcpm_keylen);
 
 	return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr,
 			      AF_INET6, prefixlen, l3index, flags,
-			      cmd.tcpm_key, cmd.tcpm_keylen, GFP_KERNEL);
+			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
 static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
@@ -1359,9 +1358,8 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 		 * memory, then we end up not copying the key
 		 * across. Shucks.
 		 */
-		tcp_md5_do_add(newsk, (union tcp_md5_addr *)&newsk->sk_v6_daddr,
-			       AF_INET6, 128, l3index, key->flags, key->key, key->keylen,
-			       sk_gfp_mask(sk, GFP_ATOMIC));
+		tcp_md5_key_copy(newsk, (union tcp_md5_addr *)&newsk->sk_v6_daddr,
+			       AF_INET6, 128, l3index, key);
 	}
 #endif
 
-- 
2.36.1

