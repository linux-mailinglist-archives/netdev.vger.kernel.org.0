Return-Path: <netdev+bounces-1270-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADF286FD277
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 00:16:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82A2E281129
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 22:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4BE918C06;
	Tue,  9 May 2023 22:16:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FB918C05
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 22:16:20 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6B23A8B
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:16:18 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f475366514so729205e9.2
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 15:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1683670576; x=1686262576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y6EGYjnQ/WyZ5lGG/G0UzhGu7aE+rdmJ2jNh/CB1dks=;
        b=NIA7icVyTxq2prfx2oVx3NhEvGTxl+OLH+p4cw1f0R+gTgse1UwmNXScSEQ6kpw5X6
         /arhlTSLX9QD9kWvlhL8dUXgpMGI1bLd7P5izg1zAl8MbVzb0N3qcfMCbk+f2LBiO9TN
         bboQ+Pu0dhB//juC0VYaz5jA6LowIYlo6p50FcrMpQZNkmT6H/VzsaILEPb33xT47RtA
         /FbYxbnZzJtdBLs0vDuZzIqwGt7zVEgI/PgdXKqLIE3I/LzSUS3N3K3Oj/fpiZu/LNaZ
         cpiygz5BU4fJR9S75nrsvsE3KMwoHr1rRDxvpVhQ8v8QYR2v969QoL1jfTQ7UflEbbVy
         BH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683670576; x=1686262576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y6EGYjnQ/WyZ5lGG/G0UzhGu7aE+rdmJ2jNh/CB1dks=;
        b=X2LRnW1m9aV/D4o3aeSEV9vUev9ODAH58Kqj4wZwg2SYkD0Ey89aWT2TH4WuAUzb/y
         qMidbVGzBfyRMgCCHQt8ezk7Xqg03oUoOmQ4QvxfK3Wxievp4ATnlAmFo91alLcU8aZj
         x9mHwX7LWI4lXKNyl4mkNcvoRxH/i6er2oXQai47YJP0BanmHUsdX2OjN+RvQW9Nesi5
         kioyZy90ONCmOtPZjXC8l1oOdLH+JXVilferwCkndZQddBvupRf78LHRPkZ2JZ+406p5
         cepzx6yu44ZYXasVSlOq6+b1SO3D03LCdDboHgn+Svp6wZb1h8RRsVzzend+Hte4BCuP
         JDrQ==
X-Gm-Message-State: AC+VfDxx8p6kv3bBNGaTo4lFXEGf/uGnjyg+NPPpCXhdcr8NFSUrRh2b
	jUakoStbyFKJ+3PfGlFNGXImuw==
X-Google-Smtp-Source: ACHHUZ6wgvotrUb/tm0TOg0te2P4XxsvMPXWrxHm+qcAywC9h/wd9u01Ef+pBiYFL4pQQDhwCkmTKQ==
X-Received: by 2002:a1c:7c10:0:b0:3f4:253b:92b3 with SMTP id x16-20020a1c7c10000000b003f4253b92b3mr5795825wmc.18.1683670576558;
        Tue, 09 May 2023 15:16:16 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id t25-20020a7bc3d9000000b003f42d3111b8sm2052888wmj.30.2023.05.09.15.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 15:16:16 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: linux-kernel@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <dima@arista.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>,
	netdev@vger.kernel.org
Subject: [PATCH 1/5] net/tcp: Separate TCP-MD5 signing from tcp_v{4,6}_send_reset()
Date: Tue,  9 May 2023 23:16:04 +0100
Message-Id: <20230509221608.2569333-2-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230509221608.2569333-1-dima@arista.com>
References: <20230509221608.2569333-1-dima@arista.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Separate TCP-MD5 part from the generic TCP code, cleaning it up from
MD5-related ifdeffery (this is most noticeable on ipv4 part). Mostly,
it is refactoring, but with a small bonus: now RST sending functions can
nicely get tcp_md5_needed static key check, making them faster on systems
without TCP-MD5 keys.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/ipv4/tcp_ipv4.c | 177 +++++++++++++++++++++++---------------------
 net/ipv6/tcp_ipv6.c | 106 ++++++++++++++------------
 2 files changed, 152 insertions(+), 131 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 39bda2b1066e..b1056a4af60f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -655,6 +655,97 @@ void tcp_v4_send_check(struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(tcp_v4_send_check);
 
+#define REPLY_OPTIONS_LEN	(MAX_TCP_OPTION_SPACE / sizeof(__be32))
+
+static bool tcp_v4_md5_sign_reset(struct net *net, const struct sock *sk,
+				  struct sk_buff *skb, struct ip_reply_arg *arg,
+				  struct tcphdr *reply,
+				  __be32 reply_options[REPLY_OPTIONS_LEN])
+{
+#ifdef CONFIG_TCP_MD5SIG
+	const struct tcphdr *th = tcp_hdr(skb);
+	struct tcp_md5sig_key *key = NULL;
+	const __u8 *hash_location = NULL;
+	unsigned char newhash[16];
+	struct sock *sk1 = NULL;
+	int genhash;
+
+	hash_location = tcp_parse_md5sig_option(th);
+	/* Fastpath: no keys in system, don't send RST iff segment is signed */
+	if (!static_branch_unlikely(&tcp_md5_needed.key))
+		return !!hash_location;
+
+	rcu_read_lock();
+	if (sk && sk_fullsock(sk)) {
+		const union tcp_md5_addr *addr;
+		int l3index;
+
+		/* sdif set, means packet ingressed via a device
+		 * in an L3 domain and inet_iif is set to it.
+		 */
+		l3index = tcp_v4_sdif(skb) ? inet_iif(skb) : 0;
+		addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
+		key = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
+	} else if (hash_location) {
+		const union tcp_md5_addr *addr;
+		int sdif = tcp_v4_sdif(skb);
+		int dif = inet_iif(skb);
+		int l3index;
+
+		/*
+		 * active side is lost. Try to find listening socket through
+		 * source port, and then find md5 key through listening socket.
+		 * we are not loose security here:
+		 * Incoming packet is checked with md5 hash with finding key,
+		 * no RST generated if md5 hash doesn't match.
+		 */
+		sk1 = __inet_lookup_listener(net, net->ipv4.tcp_death_row.hashinfo,
+					     NULL, 0, ip_hdr(skb)->saddr,
+					     th->source, ip_hdr(skb)->daddr,
+					     ntohs(th->source), dif, sdif);
+		/* don't send rst if it can't find key */
+		if (!sk1) {
+			rcu_read_unlock();
+			return true;
+		}
+
+		/* sdif set, means packet ingressed via a device
+		 * in an L3 domain and dif is set to it.
+		 */
+		l3index = sdif ? dif : 0;
+		addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
+		key = tcp_md5_do_lookup(sk1, l3index, addr, AF_INET);
+		if (!key) {
+			rcu_read_unlock();
+			return true;
+		}
+
+		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
+		if (genhash || memcmp(hash_location, newhash, 16) != 0) {
+			rcu_read_unlock();
+			return true;
+		}
+	}
+
+	if (key) {
+		reply_options[0] = htonl((TCPOPT_NOP << 24) |
+				   (TCPOPT_NOP << 16) |
+				   (TCPOPT_MD5SIG << 8) |
+				   TCPOLEN_MD5SIG);
+		/* Update length and the length the header thinks exists */
+		arg->iov[0].iov_len += TCPOLEN_MD5SIG_ALIGNED;
+		reply->doff = arg->iov[0].iov_len / 4;
+
+		tcp_v4_md5_hash_hdr((__u8 *)&reply_options[1],
+				    key, ip_hdr(skb)->saddr,
+				    ip_hdr(skb)->daddr, reply);
+	}
+	rcu_read_unlock();
+#endif
+
+	return false;
+}
+
 /*
  *	This routine will send an RST to the other tcp.
  *
@@ -668,27 +759,14 @@ EXPORT_SYMBOL(tcp_v4_send_check);
  *	Exception: precedence violation. We do not implement it in any case.
  */
 
-#ifdef CONFIG_TCP_MD5SIG
-#define OPTION_BYTES TCPOLEN_MD5SIG_ALIGNED
-#else
-#define OPTION_BYTES sizeof(__be32)
-#endif
-
 static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
 	struct {
 		struct tcphdr th;
-		__be32 opt[OPTION_BYTES / sizeof(__be32)];
+		__be32 opt[REPLY_OPTIONS_LEN];
 	} rep;
 	struct ip_reply_arg arg;
-#ifdef CONFIG_TCP_MD5SIG
-	struct tcp_md5sig_key *key = NULL;
-	const __u8 *hash_location = NULL;
-	unsigned char newhash[16];
-	int genhash;
-	struct sock *sk1 = NULL;
-#endif
 	u64 transmit_time = 0;
 	struct sock *ctl_sk;
 	struct net *net;
@@ -723,70 +801,8 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	arg.iov[0].iov_len  = sizeof(rep.th);
 
 	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
-#ifdef CONFIG_TCP_MD5SIG
-	rcu_read_lock();
-	hash_location = tcp_parse_md5sig_option(th);
-	if (sk && sk_fullsock(sk)) {
-		const union tcp_md5_addr *addr;
-		int l3index;
-
-		/* sdif set, means packet ingressed via a device
-		 * in an L3 domain and inet_iif is set to it.
-		 */
-		l3index = tcp_v4_sdif(skb) ? inet_iif(skb) : 0;
-		addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
-		key = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
-	} else if (hash_location) {
-		const union tcp_md5_addr *addr;
-		int sdif = tcp_v4_sdif(skb);
-		int dif = inet_iif(skb);
-		int l3index;
-
-		/*
-		 * active side is lost. Try to find listening socket through
-		 * source port, and then find md5 key through listening socket.
-		 * we are not loose security here:
-		 * Incoming packet is checked with md5 hash with finding key,
-		 * no RST generated if md5 hash doesn't match.
-		 */
-		sk1 = __inet_lookup_listener(net, net->ipv4.tcp_death_row.hashinfo,
-					     NULL, 0, ip_hdr(skb)->saddr,
-					     th->source, ip_hdr(skb)->daddr,
-					     ntohs(th->source), dif, sdif);
-		/* don't send rst if it can't find key */
-		if (!sk1)
-			goto out;
-
-		/* sdif set, means packet ingressed via a device
-		 * in an L3 domain and dif is set to it.
-		 */
-		l3index = sdif ? dif : 0;
-		addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
-		key = tcp_md5_do_lookup(sk1, l3index, addr, AF_INET);
-		if (!key)
-			goto out;
-
-
-		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
-		if (genhash || memcmp(hash_location, newhash, 16) != 0)
-			goto out;
-
-	}
-
-	if (key) {
-		rep.opt[0] = htonl((TCPOPT_NOP << 24) |
-				   (TCPOPT_NOP << 16) |
-				   (TCPOPT_MD5SIG << 8) |
-				   TCPOLEN_MD5SIG);
-		/* Update length and the length the header thinks exists */
-		arg.iov[0].iov_len += TCPOLEN_MD5SIG_ALIGNED;
-		rep.th.doff = arg.iov[0].iov_len / 4;
-
-		tcp_v4_md5_hash_hdr((__u8 *) &rep.opt[1],
-				     key, ip_hdr(skb)->saddr,
-				     ip_hdr(skb)->daddr, &rep.th);
-	}
-#endif
+	if (tcp_v4_md5_sign_reset(net, sk, skb, &arg, &rep.th, rep.opt))
+		return;
 	/* Can't co-exist with TCPMD5, hence check rep.opt[0] */
 	if (rep.opt[0] == 0) {
 		__be32 mrst = mptcp_reset_option(skb);
@@ -842,11 +858,6 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
 	local_bh_enable();
-
-#ifdef CONFIG_TCP_MD5SIG
-out:
-	rcu_read_unlock();
-#endif
 }
 
 /* The code following below sending ACKs in SYN-RECV and TIME-WAIT states
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 7132eb213a7a..42792bc5b9bf 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -977,18 +977,67 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	kfree_skb(buff);
 }
 
+#ifdef CONFIG_TCP_MD5SIG
+static int tcp_v6_md5_lookup_reset_key(struct net *net, const struct sock *sk,
+		struct sk_buff *skb, struct tcp_md5sig_key **key,
+		const struct tcphdr *th, struct ipv6hdr *ipv6h)
+{
+	const __u8 *hash_location = NULL;
+	int genhash, l3index;
+
+	hash_location = tcp_parse_md5sig_option(th);
+	if (!static_branch_unlikely(&tcp_md5_needed.key))
+		return !!hash_location;
+
+	if (sk && sk_fullsock(sk)) {
+		/* sdif set, means packet ingressed via a device
+		 * in an L3 domain and inet_iif is set to it.
+		 */
+		l3index = tcp_v6_sdif(skb) ? tcp_v6_iif_l3_slave(skb) : 0;
+		*key = tcp_v6_md5_do_lookup(sk, &ipv6h->saddr, l3index);
+	} else if (hash_location) {
+		int dif = tcp_v6_iif_l3_slave(skb);
+		int sdif = tcp_v6_sdif(skb);
+		unsigned char newhash[16];
+		struct sock *sk1;
+
+		/*
+		 * active side is lost. Try to find listening socket through
+		 * source port, and then find md5 key through listening socket.
+		 * we are not loose security here:
+		 * Incoming packet is checked with md5 hash with finding key,
+		 * no RST generated if md5 hash doesn't match.
+		 */
+		sk1 = inet6_lookup_listener(net, net->ipv4.tcp_death_row.hashinfo,
+					    NULL, 0, &ipv6h->saddr, th->source,
+					    &ipv6h->daddr, ntohs(th->source),
+					    dif, sdif);
+		if (!sk1)
+			return -ENOKEY;
+
+		/* sdif set, means packet ingressed via a device
+		 * in an L3 domain and dif is set to it.
+		 */
+		l3index = tcp_v6_sdif(skb) ? dif : 0;
+
+		*key = tcp_v6_md5_do_lookup(sk1, &ipv6h->saddr, l3index);
+		if (!*key)
+			return -ENOKEY;
+
+		genhash = tcp_v6_md5_hash_skb(newhash, *key, NULL, skb);
+		if (genhash || memcmp(hash_location, newhash, 16) != 0)
+			return -EKEYREJECTED;
+	}
+	return 0;
+}
+#endif
+
 static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
 	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-	u32 seq = 0, ack_seq = 0;
 	struct tcp_md5sig_key *key = NULL;
-#ifdef CONFIG_TCP_MD5SIG
-	const __u8 *hash_location = NULL;
-	unsigned char newhash[16];
-	int genhash;
-	struct sock *sk1 = NULL;
-#endif
+	u32 seq = 0, ack_seq = 0;
 	__be32 label = 0;
 	u32 priority = 0;
 	struct net *net;
@@ -1007,47 +1056,8 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
 #ifdef CONFIG_TCP_MD5SIG
 	rcu_read_lock();
-	hash_location = tcp_parse_md5sig_option(th);
-	if (sk && sk_fullsock(sk)) {
-		int l3index;
-
-		/* sdif set, means packet ingressed via a device
-		 * in an L3 domain and inet_iif is set to it.
-		 */
-		l3index = tcp_v6_sdif(skb) ? tcp_v6_iif_l3_slave(skb) : 0;
-		key = tcp_v6_md5_do_lookup(sk, &ipv6h->saddr, l3index);
-	} else if (hash_location) {
-		int dif = tcp_v6_iif_l3_slave(skb);
-		int sdif = tcp_v6_sdif(skb);
-		int l3index;
-
-		/*
-		 * active side is lost. Try to find listening socket through
-		 * source port, and then find md5 key through listening socket.
-		 * we are not loose security here:
-		 * Incoming packet is checked with md5 hash with finding key,
-		 * no RST generated if md5 hash doesn't match.
-		 */
-		sk1 = inet6_lookup_listener(net, net->ipv4.tcp_death_row.hashinfo,
-					    NULL, 0, &ipv6h->saddr, th->source,
-					    &ipv6h->daddr, ntohs(th->source),
-					    dif, sdif);
-		if (!sk1)
-			goto out;
-
-		/* sdif set, means packet ingressed via a device
-		 * in an L3 domain and dif is set to it.
-		 */
-		l3index = tcp_v6_sdif(skb) ? dif : 0;
-
-		key = tcp_v6_md5_do_lookup(sk1, &ipv6h->saddr, l3index);
-		if (!key)
-			goto out;
-
-		genhash = tcp_v6_md5_hash_skb(newhash, key, NULL, skb);
-		if (genhash || memcmp(hash_location, newhash, 16) != 0)
-			goto out;
-	}
+	if (tcp_v6_md5_lookup_reset_key(net, sk, skb, &key, th, ipv6h))
+		goto out;
 #endif
 
 	if (th->ack)
-- 
2.40.0


