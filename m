Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46CD26D539A
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbjDCVgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbjDCVfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:35:02 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FBE3AA0
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:34:41 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e18so30775487wra.9
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 14:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1680557681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NGroHlro/mESOarazNun4akDrVFoaYx6xFK0f4nFXo4=;
        b=XWuzmqkJFc+rJyA9GajUBU2CFSjpPIJgXqt3HRW8xNyIm9h6XaRwgdMEGyXMSEOZI+
         6FOnIFDdV8rKodTGq0Yapcp5ING2jAq4kv2JX2fAEfOi8yhL0LbzET+1kjQqcE6CMLwH
         B7QNUlFIXJ4PoopbGZjms7ZjkmA73rASY/rbSIWudrvtxz6iWgIwF5eWPAQgOYdF3Pdr
         UB+gXq3PSCNnvXrOze8BMcJeitxSki53zcQdoHy5LjAtjJMStlU3rev+jWOKwEl/MWcR
         FedmthI+EAmgAbXJ3IezGF9BTsPKD2SzetFzDwC4nG88cg805MFoCZgE/isi1XDnWRq3
         r2fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680557681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NGroHlro/mESOarazNun4akDrVFoaYx6xFK0f4nFXo4=;
        b=ReFEjQMfFOqPq6/23r47leGVajAKDD8b8L6Pki1V1G4G9qj7SAx0bhj0cMMH6l1b33
         //VG0uXoKEzyBqQD6Z2xp0c9HW/o/S4u/EKdKnN2cWIr36Rf4YMVIk2hEaRV64hqg6qy
         vQpcyP2EXkINZuYJKYWH9bai2b3KC14QgVWlnn76ty29Ipw27Dt6MUKtEGEHU/M3+1s7
         igj3bz+Gdt9K2SjoM1xH1H7qAQ8D8dfZRZnSpteyGFh9l1O3C26SDUIuBt3IAEWGVEKw
         zwkx9XCzPB9pDR3wp/U4Pqbt6d7L7RNxyNJzTuYMU2o3vHASFodzU/9hTeyXyMK341We
         BS/w==
X-Gm-Message-State: AAQBX9enbSUY+BPfYUY+6glkWQ0g6ZuoABGNEVVsu8S/muplG6X5FR42
        +DMOn1Gu8iEXR2fRGAXC7Frrqg==
X-Google-Smtp-Source: AKy350aYx8GPy+cG7+7WMHSTyDI+3jAg0Wt+pIli3Kz4V5HPQmDSOdNwKpNySPLWAMg5OPExzOk+EQ==
X-Received: by 2002:adf:f887:0:b0:2ce:a9e9:4905 with SMTP id u7-20020adff887000000b002cea9e94905mr30327246wrp.34.1680557681255;
        Mon, 03 Apr 2023 14:34:41 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id o5-20020a5d4a85000000b002c3f9404c45sm10682740wrq.7.2023.04.03.14.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 14:34:40 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <error27@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>
Subject: [PATCH v5 10/21] net/tcp: Wire TCP-AO to request sockets
Date:   Mon,  3 Apr 2023 22:34:09 +0100
Message-Id: <20230403213420.1576559-11-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403213420.1576559-1-dima@arista.com>
References: <20230403213420.1576559-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now when the new request socket is created from the listening socket,
it's recorded what MKT was used by the peer. tcp_rsk_used_ao() is
a new helper for checking if TCP-AO option was used to create the
request socket.
tcp_ao_copy_all_matching() will copy all keys that match the peer on the
request socket, as well as preparing them for the usage (creating
traffic keys).

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/tcp.h      |  18 ++++
 include/net/tcp.h        |   7 ++
 include/net/tcp_ao.h     |  22 +++++
 net/ipv4/syncookies.c    |   2 +
 net/ipv4/tcp_ao.c        | 183 +++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c     |  15 ++++
 net/ipv4/tcp_ipv4.c      |  63 ++++++++++++--
 net/ipv4/tcp_minisocks.c |  10 +++
 net/ipv4/tcp_output.c    |  40 ++++++---
 net/ipv6/syncookies.c    |   2 +
 net/ipv6/tcp_ao.c        |  23 +++++
 net/ipv6/tcp_ipv6.c      |  77 +++++++++++++---
 12 files changed, 431 insertions(+), 31 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 80d450622474..28048908a485 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -165,6 +165,11 @@ struct tcp_request_sock {
 						  * after data-in-SYN.
 						  */
 	u8				syn_tos;
+#ifdef CONFIG_TCP_AO
+	u8				ao_keyid;
+	u8				ao_rcv_next;
+	u8				maclen;
+#endif
 };
 
 static inline struct tcp_request_sock *tcp_rsk(const struct request_sock *req)
@@ -172,6 +177,19 @@ static inline struct tcp_request_sock *tcp_rsk(const struct request_sock *req)
 	return (struct tcp_request_sock *)req;
 }
 
+static inline bool tcp_rsk_used_ao(const struct request_sock *req)
+{
+	/* The real length of MAC is saved in the request socket,
+	 * signing anything with zero-length makes no sense, so here is
+	 * a little hack..
+	 */
+#ifndef CONFIG_TCP_AO
+	return false;
+#else
+	return tcp_rsk(req)->maclen != 0;
+#endif
+}
+
 struct tcp_sock {
 	/* inet_connection_sock has to be the first member of tcp_sock */
 	struct inet_connection_sock	inet_conn;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 6b8af03d0f65..1f346927b1d0 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2142,6 +2142,13 @@ struct tcp_request_sock_ops {
 					  const struct sock *sk,
 					  const struct sk_buff *skb);
 #endif
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_key	*(*ao_lookup)(const struct sock *sk,
+					       struct request_sock *req,
+					       int sndid, int rcvid);
+	int			(*ao_calc_key)(struct tcp_ao_key *mkt, u8 *key,
+						struct request_sock *sk);
+#endif
 #ifdef CONFIG_SYN_COOKIES
 	__u32 (*cookie_init_seq)(const struct sk_buff *skb,
 				 __u16 *mss);
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index a8632f258890..2faeaa3a857a 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -124,6 +124,9 @@ int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
 		 sockptr_t optval, int optlen);
 struct tcp_ao_key *tcp_ao_established_key(struct tcp_ao_info *ao,
 					  int sndid, int rcvid);
+int tcp_ao_copy_all_matching(const struct sock *sk, struct sock *newsk,
+			     struct request_sock *req, struct sk_buff *skb,
+			     int family);
 int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 			    unsigned int len);
 void tcp_ao_destroy_sock(struct sock *sk, bool twsk);
@@ -145,6 +148,11 @@ struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 int tcp_v4_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 			  const struct sock *sk,
 			  __be32 sisn, __be32 disn, bool send);
+int tcp_v4_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
+			   struct request_sock *req);
+struct tcp_ao_key *tcp_v4_ao_lookup_rsk(const struct sock *sk,
+					struct request_sock *req,
+					int sndid, int rcvid);
 int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 		       const struct sock *sk, const struct sk_buff *skb,
 		       const u8 *tkey, int hash_offset, u32 sne);
@@ -156,9 +164,17 @@ int tcp_v6_ao_hash_pseudoheader(struct tcp_sigpool *hp,
 int tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 				 const struct sock *sk, __be32 sisn,
 				 __be32 disn, bool send);
+int tcp_v6_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
+			   struct request_sock *req);
+struct tcp_ao_key *tcp_v6_ao_do_lookup(const struct sock *sk,
+				       const struct in6_addr *addr,
+				       int sndid, int rcvid);
 struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
 				    struct sock *addr_sk,
 				    int sndid, int rcvid);
+struct tcp_ao_key *tcp_v6_ao_lookup_rsk(const struct sock *sk,
+					struct request_sock *req,
+					int sndid, int rcvid);
 int tcp_v6_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 		       const struct sock *sk, const struct sk_buff *skb,
 		       const u8 *tkey, int hash_offset, u32 sne);
@@ -171,6 +187,12 @@ void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
 		      unsigned short int family);
 #else /* CONFIG_TCP_AO */
 
+static inline void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
+		      struct tcp_request_sock *treq,
+		      unsigned short int family)
+{
+}
+
 static inline struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 		const union tcp_ao_addr *addr,
 		int family, int sndid, int rcvid, u16 port)
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 26fb97d1d4d9..9e3d7083af7d 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -394,6 +394,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	treq->snt_synack	= 0;
 	treq->tfo_listener	= false;
 
+	tcp_ao_syncookie(sk, skb, treq, AF_INET);
+
 	if (IS_ENABLED(CONFIG_SMC))
 		ireq->smc_ok = 0;
 
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 76dacb41aa2f..9144df7d16dc 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -181,6 +181,23 @@ static void tcp_ao_link_mkt(struct tcp_ao_info *ao, struct tcp_ao_key *mkt)
 	hlist_add_head_rcu(&mkt->node, &ao->head);
 }
 
+static struct tcp_ao_key *tcp_ao_copy_key(struct sock *sk,
+					  struct tcp_ao_key *key)
+{
+	struct tcp_ao_key *new_key;
+
+	new_key = sock_kmalloc(sk, tcp_ao_sizeof_key(key),
+			       GFP_ATOMIC);
+	if (!new_key)
+		return NULL;
+
+	*new_key = *key;
+	INIT_HLIST_NODE(&new_key->node);
+	tcp_sigpool_get(new_key->tcp_sigpool_id);
+
+	return new_key;
+}
+
 static void tcp_ao_key_free_rcu(struct rcu_head *head)
 {
 	struct tcp_ao_key *key = container_of(head, struct tcp_ao_key, rcu);
@@ -293,6 +310,18 @@ static int tcp_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 		return -EOPNOTSUPP;
 }
 
+int tcp_v4_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
+			   struct request_sock *req)
+{
+	struct inet_request_sock *ireq = inet_rsk(req);
+
+	return tcp_v4_ao_calc_key(mkt, key,
+				  ireq->ir_loc_addr, ireq->ir_rmt_addr,
+				  htons(ireq->ir_num), ireq->ir_rmt_port,
+				  htonl(tcp_rsk(req)->snt_isn),
+				  htonl(tcp_rsk(req)->rcv_isn));
+}
+
 static int tcp_v4_ao_hash_pseudoheader(struct tcp_sigpool *hp,
 				       __be32 daddr, __be32 saddr,
 				       int nbytes)
@@ -525,6 +554,16 @@ int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 }
 EXPORT_SYMBOL_GPL(tcp_v4_ao_hash_skb);
 
+struct tcp_ao_key *tcp_v4_ao_lookup_rsk(const struct sock *sk,
+					struct request_sock *req,
+					int sndid, int rcvid)
+{
+	union tcp_ao_addr *addr =
+			(union tcp_ao_addr *)&inet_rsk(req)->ir_rmt_addr;
+
+	return tcp_ao_do_lookup(sk, addr, AF_INET, sndid, rcvid, 0);
+}
+
 struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 				    int sndid, int rcvid)
 {
@@ -533,6 +572,51 @@ struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 	return tcp_ao_do_lookup(sk, addr, AF_INET, sndid, rcvid, 0);
 }
 
+static struct tcp_ao_key *tcp_ao_inbound_lookup(unsigned short int family,
+		const struct sock *sk, const struct sk_buff *skb,
+		int sndid, int rcvid)
+{
+	if (family == AF_INET) {
+		const struct iphdr *iph = ip_hdr(skb);
+
+		return tcp_ao_do_lookup(sk, (union tcp_ao_addr *)&iph->saddr,
+				AF_INET, sndid, rcvid, 0);
+	} else {
+		const struct ipv6hdr *iph = ipv6_hdr(skb);
+
+		return tcp_ao_do_lookup(sk, (union tcp_ao_addr *)&iph->saddr,
+				AF_INET6, sndid, rcvid, 0);
+	}
+}
+
+void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
+		      struct tcp_request_sock *treq,
+		      unsigned short int family)
+{
+	const struct tcphdr *th = tcp_hdr(skb);
+	const struct tcp_ao_hdr *aoh;
+	struct tcp_ao_key *key;
+
+	treq->maclen = 0;
+
+	/* Shouldn't fail as this has been called on this packet
+	 * in tcp_inbound_hash()
+	 */
+	tcp_parse_auth_options(th, NULL, &aoh);
+	if (!aoh)
+		return;
+
+	key = tcp_ao_inbound_lookup(family, sk, skb, -1, aoh->keyid);
+	if (!key)
+		/* Key not found, continue without TCP-AO */
+		return;
+
+	treq->ao_rcv_next = aoh->keyid;
+	treq->ao_keyid = aoh->rnext_keyid;
+	treq->maclen = tcp_ao_maclen(key);
+}
+EXPORT_SYMBOL_GPL(tcp_ao_syncookie);
+
 static int tcp_ao_cache_traffic_keys(const struct sock *sk,
 				     struct tcp_ao_info *ao,
 				     struct tcp_ao_key *ao_key)
@@ -631,6 +715,105 @@ void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb)
 	}
 }
 
+int tcp_ao_copy_all_matching(const struct sock *sk, struct sock *newsk,
+			     struct request_sock *req, struct sk_buff *skb,
+			     int family)
+{
+	struct tcp_ao_key *key, *new_key, *first_key;
+	struct tcp_ao_info *new_ao, *ao;
+	struct hlist_node *key_head;
+	union tcp_ao_addr *addr;
+	bool match = false;
+	int ret = -ENOMEM;
+
+	ao = rcu_dereference(tcp_sk(sk)->ao_info);
+	if (!ao)
+		return 0;
+
+	/* New socket without TCP-AO on it */
+	if (!tcp_rsk_used_ao(req))
+		return 0;
+
+	new_ao = tcp_ao_alloc_info(GFP_ATOMIC);
+	if (!new_ao)
+		return -ENOMEM;
+	new_ao->lisn = htonl(tcp_rsk(req)->snt_isn);
+	new_ao->risn = htonl(tcp_rsk(req)->rcv_isn);
+	new_ao->ao_required = ao->ao_required;
+
+	if (family == AF_INET) {
+		addr = (union tcp_ao_addr *)&newsk->sk_daddr;
+#if IS_ENABLED(CONFIG_IPV6)
+	} else if (family == AF_INET6) {
+		addr = (union tcp_ao_addr *)&newsk->sk_v6_daddr;
+#endif
+	} else {
+		ret = -EAFNOSUPPORT;
+		goto free_ao;
+	}
+
+	hlist_for_each_entry_rcu(key, &ao->head, node) {
+		if (tcp_ao_key_cmp(key, addr, key->prefixlen, family,
+				   -1, -1, 0))
+			continue;
+
+		new_key = tcp_ao_copy_key(newsk, key);
+		if (!new_key)
+			goto free_and_exit;
+
+		tcp_ao_cache_traffic_keys(newsk, new_ao, new_key);
+		tcp_ao_link_mkt(new_ao, new_key);
+		match = true;
+	}
+
+	if (!match) {
+		/* RFC5925 (7.4.1) specifies that the TCP-AO status
+		 * of a connection is determined on the initial SYN.
+		 * At this point the connection was TCP-AO enabled, so
+		 * it can't switch to being unsigned if peer's key
+		 * disappears on the listening socket.
+		 */
+		ret = -EKEYREJECTED;
+		goto free_and_exit;
+	}
+
+	key_head = rcu_dereference(hlist_first_rcu(&new_ao->head));
+	first_key = hlist_entry_safe(key_head, struct tcp_ao_key, node);
+
+	key = tcp_ao_established_key(new_ao, tcp_rsk(req)->ao_keyid, -1);
+	if (key)
+		new_ao->current_key = key;
+	else
+		new_ao->current_key = first_key;
+
+	/* set rnext_key */
+	key = tcp_ao_established_key(new_ao, -1, tcp_rsk(req)->ao_rcv_next);
+	if (key)
+		new_ao->rnext_key = key;
+	else
+		new_ao->rnext_key = first_key;
+
+	new_ao->snd_sne_seq = tcp_rsk(req)->snt_isn;
+	new_ao->rcv_sne_seq = tcp_rsk(req)->rcv_isn;
+
+	sk_gso_disable(newsk);
+	rcu_assign_pointer(tcp_sk(newsk)->ao_info, new_ao);
+
+	return 0;
+
+free_and_exit:
+	hlist_for_each_entry_safe(key, key_head, &new_ao->head, node) {
+		hlist_del(&key->node);
+		tcp_sigpool_release(key->tcp_sigpool_id);
+		atomic_sub(tcp_ao_sizeof_key(key), &newsk->sk_omem_alloc);
+		kfree(key);
+	}
+free_ao:
+	kfree(new_ao);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tcp_ao_copy_all_matching);
+
 static bool tcp_ao_can_set_current_rnext(struct sock *sk)
 {
 	struct tcp_ao_info *ao_info;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 78c2f238205f..9e7e5ee57137 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6955,6 +6955,10 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	struct flowi fl;
 	u8 syncookies;
 
+#ifdef CONFIG_TCP_AO
+	const struct tcp_ao_hdr *aoh;
+#endif
+
 	syncookies = READ_ONCE(net->ipv4.sysctl_tcp_syncookies);
 
 	/* TW buckets are converted to open requests without
@@ -7040,6 +7044,17 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 			inet_rsk(req)->ecn_ok = 0;
 	}
 
+#ifdef CONFIG_TCP_AO
+	if (tcp_parse_auth_options(tcp_hdr(skb), NULL, &aoh))
+		goto drop_and_release; /* Invalid TCP options */
+	if (aoh) {
+		tcp_rsk(req)->maclen = aoh->length - sizeof(struct tcp_ao_hdr);
+		tcp_rsk(req)->ao_rcv_next = aoh->keyid;
+		tcp_rsk(req)->ao_keyid = aoh->rnext_keyid;
+	} else {
+		tcp_rsk(req)->maclen = 0;
+	}
+#endif
 	tcp_rsk(req)->snt_isn = isn;
 	tcp_rsk(req)->txhash = net_tx_rndhash();
 	tcp_rsk(req)->syn_tos = TCP_SKB_CB(skb)->ip_dsfield;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index eb5052c48c75..dcae887d5265 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1087,30 +1087,73 @@ static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
 static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 				  struct request_sock *req)
 {
+	struct tcp_md5sig_key *md5_key = NULL;
+	struct tcp_ao_key *ao_key = NULL;
 	const union tcp_md5_addr *addr;
-	int l3index;
+	u8 keyid = 0;
+#ifdef CONFIG_TCP_AO
+	u8 traffic_key[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+	const struct tcp_ao_hdr *aoh;
+#else
+	u8 *traffic_key = NULL;
+#endif
 
 	/* sk->sk_state == TCP_LISTEN -> for regular TCP_SYN_RECV
 	 * sk->sk_state == TCP_SYN_RECV -> for Fast Open.
 	 */
 	u32 seq = (sk->sk_state == TCP_LISTEN) ? tcp_rsk(req)->snt_isn + 1 :
 					     tcp_sk(sk)->snd_nxt;
+	addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
+
+	if (tcp_rsk_used_ao(req)) {
+#ifdef CONFIG_TCP_AO
+		/* Invalid TCP option size or twice included auth */
+		if (tcp_parse_auth_options(tcp_hdr(skb), NULL, &aoh))
+			return;
+
+		if (!aoh)
+			return;
+
+		ao_key = tcp_ao_do_lookup(sk, addr, AF_INET,
+					  aoh->rnext_keyid, -1, 0);
+		if (unlikely(!ao_key)) {
+			/* Send ACK with any matching MKT for the peer */
+			ao_key = tcp_ao_do_lookup(sk, addr,
+						  AF_INET, -1, -1, 0);
+			/* Matching key disappeared (user removed the key?)
+			 * let the handshake timeout.
+			 */
+			if (!ao_key) {
+				net_info_ratelimited("TCP-AO key for (%pI4, %d)->(%pI4, %d) suddenly disappeared, won't ACK new connection\n",
+						     addr,
+						     ntohs(tcp_hdr(skb)->source),
+						     &ip_hdr(skb)->daddr,
+						     ntohs(tcp_hdr(skb)->dest));
+				return;
+			}
+		}
 
+		keyid = aoh->keyid;
+		tcp_v4_ao_calc_key_rsk(ao_key, traffic_key, req);
+#endif
+	} else {
+		int l3index;
+
+		l3index = tcp_v4_sdif(skb) ? inet_iif(skb) : 0;
+		md5_key = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
+	}
 	/* RFC 7323 2.3
 	 * The window field (SEG.WND) of every outgoing segment, with the
 	 * exception of <SYN> segments, MUST be right-shifted by
 	 * Rcv.Wind.Shift bits:
 	 */
-	addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
-	l3index = tcp_v4_sdif(skb) ? inet_iif(skb) : 0;
 	tcp_v4_send_ack(sk, skb, seq,
 			tcp_rsk(req)->rcv_nxt,
 			req->rsk_rcv_wnd >> inet_rsk(req)->rcv_wscale,
 			tcp_time_stamp_raw() + tcp_rsk(req)->ts_off,
 			req->ts_recent,
 			0,
-			tcp_md5_do_lookup(sk, l3index, addr, AF_INET),
-			NULL, NULL, 0, 0,
+			md5_key, ao_key, traffic_key, keyid, 0,
 			inet_rsk(req)->no_srccheck ? IP_REPLY_ARG_NOSRCCHECK : 0,
 			ip_hdr(skb)->tos);
 }
@@ -1650,6 +1693,10 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops = {
 	.req_md5_lookup	=	tcp_v4_md5_lookup,
 	.calc_md5_hash	=	tcp_v4_md5_hash_skb,
 #endif
+#ifdef CONFIG_TCP_AO
+	.ao_lookup	=	tcp_v4_ao_lookup_rsk,
+	.ao_calc_key	=	tcp_v4_ao_calc_key_rsk,
+#endif
 #ifdef CONFIG_SYN_COOKIES
 	.cookie_init_seq =	cookie_v4_init_sequence,
 #endif
@@ -1751,12 +1798,16 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	/* Copy over the MD5 key from the original socket */
 	addr = (union tcp_md5_addr *)&newinet->inet_daddr;
 	key = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
-	if (key) {
+	if (key && !tcp_rsk_used_ao(req)) {
 		if (tcp_md5_key_copy(newsk, addr, AF_INET, 32, l3index, key))
 			goto put_and_exit;
 		sk_gso_disable(newsk);
 	}
 #endif
+#ifdef CONFIG_TCP_AO
+	if (tcp_ao_copy_all_matching(sk, newsk, req, skb, AF_INET))
+		goto put_and_exit; /* OOM, release back memory */
+#endif
 
 	if (__inet_inherit_port(sk, newsk) < 0)
 		goto put_and_exit;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index afbfdb6e7277..1c0bf205da58 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -505,6 +505,9 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	struct inet_connection_sock *newicsk;
 	struct tcp_sock *oldtp, *newtp;
 	u32 seq;
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_key *ao_key;
+#endif
 
 	if (!newsk)
 		return NULL;
@@ -583,6 +586,13 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	if (treq->af_specific->req_md5_lookup(sk, req_to_sk(req)))
 		newtp->tcp_header_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
+#ifdef CONFIG_TCP_AO
+	newtp->ao_info = NULL;
+	ao_key = treq->af_specific->ao_lookup(sk, req,
+				tcp_rsk(req)->ao_keyid, -1);
+	if (ao_key)
+		newtp->tcp_header_len += tcp_ao_len(ao_key);
+ #endif
 	if (skb->len >= TCP_MSS_DEFAULT + newtp->tcp_header_len)
 		newicsk->icsk_ack.last_seg_size = skb->len - newtp->tcp_header_len;
 	newtp->rx_opt.mss_clamp = req->mss;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f4565169f6eb..167b1ce3804b 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -606,6 +606,7 @@ static void bpf_skops_write_hdr_opt(struct sock *sk, struct sk_buff *skb,
  * (but it may well be that other scenarios fail similarly).
  */
 static void tcp_options_write(struct tcphdr *th, struct tcp_sock *tp,
+			      const struct tcp_request_sock *tcprsk,
 			      struct tcp_out_options *opts,
 			      struct tcp_ao_key *ao_key)
 {
@@ -620,23 +621,36 @@ static void tcp_options_write(struct tcphdr *th, struct tcp_sock *tp,
 		ptr += 4;
 	}
 #ifdef CONFIG_TCP_AO
-	if (unlikely(OPTION_AO & options) && tp) {
-		struct tcp_ao_key *rnext_key;
-		struct tcp_ao_info *ao_info;
+	if (unlikely(OPTION_AO & options)) {
 		u8 maclen;
 
 		if (WARN_ON_ONCE(!ao_key))
 			goto out_ao;
-		ao_info = rcu_dereference_check(tp->ao_info,
+		maclen = tcp_ao_maclen(ao_key);
+
+		if (tp) {
+			struct tcp_ao_key *rnext_key;
+			struct tcp_ao_info *ao_info;
+
+			ao_info = rcu_dereference_check(tp->ao_info,
 				lockdep_sock_is_held(&tp->inet_conn.icsk_inet.sk));
-		rnext_key = READ_ONCE(ao_info->rnext_key);
-		if (WARN_ON_ONCE(!rnext_key))
+			rnext_key = READ_ONCE(ao_info->rnext_key);
+			if (WARN_ON_ONCE(!rnext_key))
+				goto out_ao;
+			*ptr++ = htonl((TCPOPT_AO << 24) |
+				       (tcp_ao_len(ao_key) << 16) |
+				       (ao_key->sndid << 8) |
+				       (rnext_key->rcvid));
+		} else if (tcprsk) {
+			u8 aolen = maclen + sizeof(struct tcp_ao_hdr);
+
+			*ptr++ = htonl((TCPOPT_AO << 24) | (aolen << 16) |
+				       (tcprsk->ao_keyid << 8) |
+				       (tcprsk->ao_rcv_next));
+		} else {
+			WARN_ON_ONCE(1);
 			goto out_ao;
-		maclen = tcp_ao_maclen(ao_key);
-		*ptr++ = htonl((TCPOPT_AO << 24) |
-				(tcp_ao_len(ao_key) << 16) |
-				(ao_key->sndid << 8) |
-				(rnext_key->rcvid));
+		}
 		opts->hash_location = (__u8 *)ptr;
 		ptr += maclen / sizeof(*ptr);
 		if (unlikely(maclen % sizeof(*ptr))) {
@@ -1412,7 +1426,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		th->window	= htons(min(tp->rcv_wnd, 65535U));
 	}
 
-	tcp_options_write(th, tp, &opts, ao_key);
+	tcp_options_write(th, tp, NULL, &opts, ao_key);
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* Calculate the MD5 hash, as we have all we need now */
@@ -3703,7 +3717,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 
 	/* RFC1323: The window in SYN & SYN/ACK segments is never scaled. */
 	th->window = htons(min(req->rsk_rcv_wnd, 65535U));
-	tcp_options_write(th, NULL, &opts, NULL);
+	tcp_options_write(th, NULL, NULL, &opts, NULL);
 	th->doff = (tcp_header_size >> 2);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
 
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index 5014aa663452..ad7a8caa7b2a 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -214,6 +214,8 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	treq->snt_isn = cookie;
 	treq->ts_off = 0;
 	treq->txhash = net_tx_rndhash();
+	tcp_ao_syncookie(sk, skb, treq, AF_INET6);
+
 	if (IS_ENABLED(CONFIG_SMC))
 		ireq->smc_ok = 0;
 
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index 4a21bcab733c..17acb2fd5182 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -53,6 +53,19 @@ int tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 					  htons(sk->sk_num), disn, sisn);
 }
 
+int tcp_v6_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
+			   struct request_sock *req)
+{
+	struct inet_request_sock *ireq = inet_rsk(req);
+
+	return tcp_v6_ao_calc_key(mkt, key,
+			&ireq->ir_v6_loc_addr, &ireq->ir_v6_rmt_addr,
+			htons(ireq->ir_num), ireq->ir_rmt_port,
+			htonl(tcp_rsk(req)->snt_isn),
+			htonl(tcp_rsk(req)->rcv_isn));
+}
+EXPORT_SYMBOL_GPL(tcp_v6_ao_calc_key_rsk);
+
 struct tcp_ao_key *tcp_v6_ao_do_lookup(const struct sock *sk,
 				       const struct in6_addr *addr,
 				       int sndid, int rcvid)
@@ -71,6 +84,16 @@ struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
 }
 EXPORT_SYMBOL_GPL(tcp_v6_ao_lookup);
 
+struct tcp_ao_key *tcp_v6_ao_lookup_rsk(const struct sock *sk,
+					struct request_sock *req,
+					int sndid, int rcvid)
+{
+	struct in6_addr *addr = &inet_rsk(req)->ir_v6_rmt_addr;
+
+	return tcp_v6_ao_do_lookup(sk, addr, sndid, rcvid);
+}
+EXPORT_SYMBOL_GPL(tcp_v6_ao_lookup_rsk);
+
 int tcp_v6_ao_hash_pseudoheader(struct tcp_sigpool *hp,
 				const struct in6_addr *daddr,
 				const struct in6_addr *saddr, int nbytes)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 8c8e5350c621..3e9c4fe6bd42 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -845,6 +845,10 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
 	.req_md5_lookup	=	tcp_v6_md5_lookup,
 	.calc_md5_hash	=	tcp_v6_md5_hash_skb,
 #endif
+#ifdef CONFIG_TCP_AO
+	.ao_lookup	=	tcp_v6_ao_lookup_rsk,
+	.ao_calc_key	=	tcp_v6_ao_calc_key_rsk,
+#endif
 #ifdef CONFIG_SYN_COOKIES
 	.cookie_init_seq =	cookie_v6_init_sequence,
 #endif
@@ -1239,9 +1243,51 @@ static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
 static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 				  struct request_sock *req)
 {
+	struct tcp_md5sig_key *md5_key = NULL;
+	struct tcp_ao_key *ao_key = NULL;
+	const struct in6_addr *addr;
+	u8 keyid = 0;
+#ifdef CONFIG_TCP_AO
+	char traffic_key[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+	const struct tcp_ao_hdr *aoh;
+#else
+	u8 *traffic_key = NULL;
+#endif
 	int l3index;
 
 	l3index = tcp_v6_sdif(skb) ? tcp_v6_iif_l3_slave(skb) : 0;
+	addr = &ipv6_hdr(skb)->saddr;
+
+	if (tcp_rsk_used_ao(req)) {
+#ifdef CONFIG_TCP_AO
+		/* Invalid TCP option size or twice included auth */
+		if (tcp_parse_auth_options(tcp_hdr(skb), NULL, &aoh))
+			return;
+		if (!aoh)
+			return;
+		ao_key = tcp_v6_ao_do_lookup(sk, addr, aoh->rnext_keyid, -1);
+		if (unlikely(!ao_key)) {
+			/* Send ACK with any matching MKT for the peer */
+			ao_key = tcp_v6_ao_do_lookup(sk, addr, -1, -1);
+			/* Matching key disappeared (user removed the key?)
+			 * let the handshake timeout.
+			 */
+			if (!ao_key) {
+				net_info_ratelimited("TCP-AO key for (%pI6, %d)->(%pI6, %d) suddenly disappeared, won't ACK new connection\n",
+						     addr,
+						     ntohs(tcp_hdr(skb)->source),
+						     &ipv6_hdr(skb)->daddr,
+						     ntohs(tcp_hdr(skb)->dest));
+				return;
+			}
+		}
+
+		keyid = aoh->keyid;
+		tcp_v6_ao_calc_key_rsk(ao_key, traffic_key, req);
+#endif
+	} else {
+		md5_key = tcp_v6_md5_do_lookup(sk, addr, l3index);
+	}
 
 	/* sk->sk_state == TCP_LISTEN -> for regular TCP_SYN_RECV
 	 * sk->sk_state == TCP_SYN_RECV -> for Fast Open.
@@ -1257,9 +1303,9 @@ static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			req->rsk_rcv_wnd >> inet_rsk(req)->rcv_wscale,
 			tcp_time_stamp_raw() + tcp_rsk(req)->ts_off,
 			req->ts_recent, sk->sk_bound_dev_if,
-			tcp_v6_md5_do_lookup(sk, &ipv6_hdr(skb)->saddr, l3index),
+			md5_key,
 			ipv6_get_dsfield(ipv6_hdr(skb)), 0, sk->sk_priority,
-			tcp_rsk(req)->txhash, NULL, NULL, 0, 0);
+			tcp_rsk(req)->txhash, ao_key, traffic_key, keyid, 0);
 }
 
 
@@ -1489,19 +1535,26 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 #ifdef CONFIG_TCP_MD5SIG
 	l3index = l3mdev_master_ifindex_by_index(sock_net(sk), ireq->ir_iif);
 
-	/* Copy over the MD5 key from the original socket */
-	key = tcp_v6_md5_do_lookup(sk, &newsk->sk_v6_daddr, l3index);
-	if (key) {
-		const union tcp_md5_addr *addr;
-
-		addr = (union tcp_md5_addr *)&newsk->sk_v6_daddr;
-		if (tcp_md5_key_copy(newsk, addr, AF_INET6, 128, l3index, key)) {
-			inet_csk_prepare_forced_close(newsk);
-			tcp_done(newsk);
-			goto out;
+	if (!tcp_rsk_used_ao(req)) {
+		/* Copy over the MD5 key from the original socket */
+		key = tcp_v6_md5_do_lookup(sk, &newsk->sk_v6_daddr, l3index);
+		if (key) {
+			const union tcp_md5_addr *addr;
+
+			addr = (union tcp_md5_addr *)&newsk->sk_v6_daddr;
+			if (tcp_md5_key_copy(newsk, addr, AF_INET6, 128, l3index, key)) {
+				inet_csk_prepare_forced_close(newsk);
+				tcp_done(newsk);
+				goto out;
+			}
 		}
 	}
 #endif
+#ifdef CONFIG_TCP_AO
+	/* Copy over tcp_ao_info if any */
+	if (tcp_ao_copy_all_matching(sk, newsk, req, skb, AF_INET6))
+		goto out; /* OOM */
+#endif
 
 	if (__inet_inherit_port(sk, newsk) < 0) {
 		inet_csk_prepare_forced_close(newsk);
-- 
2.40.0

