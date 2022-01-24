Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAE0497EED
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241524AbiAXMO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239293AbiAXMOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:14:05 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F86DC061768;
        Mon, 24 Jan 2022 04:13:42 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ka4so20791949ejc.11;
        Mon, 24 Jan 2022 04:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+zkef71pv3ca9bmC3MzbdhJfHwgVbVll3kyUZTGmol4=;
        b=nOKsWGXSYBMQYErU9oiPa7ig9YgzkN3GrhY8NjUvaZ+fPLe0fAldpiIgEw5XTnyjAA
         urFgUn48gv4moD48vP52Ncw85pLxu/t/b8brmWcFo6bxr1wbr7EQNPbNSLvgk8icZWbM
         QZtwACeUIzAtWCUEofN/wFJgIKpUlq7zT53RC5fMwKrBOPCgyLNMFx6XW4WUKjzRZFKu
         rZz92ifokBMgH3i9KnWvXXgmtw2IjpkfEILtRxwhz9zgyns0NN23KMz9i0IGWMmS4c8p
         dQ1fWbDoESdFzH3ROFslRyay82EgB2b1+Go9EfoMsJAZzGP7k3wd/gxuBqHkubgDOnw5
         Efqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+zkef71pv3ca9bmC3MzbdhJfHwgVbVll3kyUZTGmol4=;
        b=iMLcpV2ixzuRbdetZqsQR4NKmVq8YIzi6vldwc5yLp0otNnWJ0fhiMEw/AoSZSJdwd
         e0WMe8MBP7kmitHkdpRLEtz7D2PjPmPFRZK9hbTtPQNa6TrTasZXW+LZf9MJvCk20q88
         6D/DKKbyBy6IB/pjWuInOiy3Fb0sPisPZq5TbDpePipkDsUfQGr7SXOmGvjxDSTQpqSr
         ZTNniRR5p35v7osbRh5Ya1JBm0WwRGGPZ6WvbjnnLC1BykJmXcJDRaC/y5/rNEeM6s24
         jc9DbADLhMjbeoBWptEIPm2ns7JmY9Pb2vfEPNdwzXuJDBuPtWtAEPWdUf5jTCGvx6/f
         CF6g==
X-Gm-Message-State: AOAM530kb9fi7nWyNSTyRYeuqHGPVRMAZSKY+XCng2zP5O+8AJ74lDoP
        ZpFTJY8PaP4IUVHnSRK9uK8=
X-Google-Smtp-Source: ABdhPJwbNI06EggWhJH76KAc8y0IHEZgHrOfJQ00e6mEswWI5KIwBsymBX1ggcaCl7NQIaX03MUcTw==
X-Received: by 2002:a17:907:3f20:: with SMTP id hq32mr3600345ejc.613.1643026420839;
        Mon, 24 Jan 2022 04:13:40 -0800 (PST)
Received: from ponky.lan ([2a04:241e:502:a09c:a21f:7a9f:9158:4a40])
        by smtp.gmail.com with ESMTPSA id b16sm4847517eja.211.2022.01.24.04.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 04:13:40 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 11/20] tcp: ipv4: Add AO signing for skb-less replies
Date:   Mon, 24 Jan 2022 14:12:57 +0200
Message-Id: <2990eee1b03b038709a8dfeee9fb915655b074b5.1643026076.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1643026076.git.cdleonard@gmail.com>
References: <cover.1643026076.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code in tcp_v4_send_ack and tcp_v4_send_reset does not allocate a
full skb so special handling is required for tcp-authopt handling.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_authopt.c |  3 +-
 net/ipv4/tcp_ipv4.c    | 84 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 83 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 7a2e15dd80ba..d924a73a17c1 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -955,10 +955,11 @@ static int tcp_v4_authopt_get_traffic_key_noskb(struct tcp_authopt_key_info *key
 						u8 *traffic_key)
 {
 	int err;
 	struct tcp_authopt_alg_pool *pool;
 	struct tcp_v4_authopt_context_data data;
+	char traffic_key_context_header[7] = "\x01TCP-AO";
 
 	BUILD_BUG_ON(sizeof(data) != 22);
 
 	pool = tcp_authopt_get_kdf_pool(key);
 	if (IS_ERR(pool))
@@ -971,11 +972,11 @@ static int tcp_v4_authopt_get_traffic_key_noskb(struct tcp_authopt_key_info *key
 	if (err)
 		goto out;
 
 	// RFC5926 section 3.1.1.1
 	// Separate to keep alignment semi-sane
-	err = crypto_ahash_buf(pool->req, "\x01TCP-AO", 7);
+	err = crypto_ahash_buf(pool->req, traffic_key_context_header, 7);
 	if (err)
 		return err;
 	data.saddr = saddr;
 	data.daddr = daddr;
 	data.sport = sport;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5a7fe973bc4e..e35463a378e7 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -644,10 +644,50 @@ void tcp_v4_send_check(struct sock *sk, struct sk_buff *skb)
 
 	__tcp_v4_send_check(skb, inet->inet_saddr, inet->inet_daddr);
 }
 EXPORT_SYMBOL(tcp_v4_send_check);
 
+#ifdef CONFIG_TCP_AUTHOPT
+/** tcp_v4_authopt_handle_reply - Insert TCPOPT_AUTHOPT if required
+ *
+ * returns number of bytes (always aligned to 4) or zero
+ */
+static int tcp_v4_authopt_handle_reply(const struct sock *sk,
+				       struct sk_buff *skb,
+				       __be32 *optptr,
+				       struct tcphdr *th)
+{
+	struct tcp_authopt_info *info;
+	struct tcp_authopt_key_info *key_info;
+	u8 rnextkeyid;
+
+	if (sk->sk_state == TCP_TIME_WAIT)
+		info = tcp_twsk(sk)->tw_authopt_info;
+	else
+		info = rcu_dereference_check(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
+	if (!info)
+		return 0;
+	key_info = __tcp_authopt_select_key(sk, info, sk, &rnextkeyid);
+	if (!key_info)
+		return 0;
+	*optptr = htonl((TCPOPT_AUTHOPT << 24) |
+			(TCPOLEN_AUTHOPT_OUTPUT << 16) |
+			(key_info->send_id << 8) |
+			(rnextkeyid));
+	/* must update doff before signature computation */
+	th->doff += TCPOLEN_AUTHOPT_OUTPUT / 4;
+	tcp_v4_authopt_hash_reply((char *)(optptr + 1),
+				  info,
+				  key_info,
+				  ip_hdr(skb)->daddr,
+				  ip_hdr(skb)->saddr,
+				  th);
+
+	return TCPOLEN_AUTHOPT_OUTPUT;
+}
+#endif
+
 /*
  *	This routine will send an RST to the other tcp.
  *
  *	Someone asks: why I NEVER use socket parameters (TOS, TTL etc.)
  *		      for reset.
@@ -659,10 +699,12 @@ EXPORT_SYMBOL(tcp_v4_send_check);
  *	Exception: precedence violation. We do not implement it in any case.
  */
 
 #ifdef CONFIG_TCP_MD5SIG
 #define OPTION_BYTES TCPOLEN_MD5SIG_ALIGNED
+#elif defined(OPTION_BYTES_TCP_AUTHOPT)
+#define OPTION_BYTES TCPOLEN_AUTHOPT_OUTPUT
 #else
 #define OPTION_BYTES sizeof(__be32)
 #endif
 
 static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
@@ -712,12 +754,29 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	memset(&arg, 0, sizeof(arg));
 	arg.iov[0].iov_base = (unsigned char *)&rep;
 	arg.iov[0].iov_len  = sizeof(rep.th);
 
 	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT)
 	rcu_read_lock();
+#endif
+#ifdef CONFIG_TCP_AUTHOPT
+	/* Unlike TCP-MD5 the signatures for TCP-AO depend on initial sequence
+	 * numbers so we can only handle established and time-wait sockets.
+	 */
+	if (tcp_authopt_needed && sk &&
+	    sk->sk_state != TCP_NEW_SYN_RECV &&
+	    sk->sk_state != TCP_LISTEN) {
+		int tcp_authopt_ret = tcp_v4_authopt_handle_reply(sk, skb, rep.opt, &rep.th);
+
+		if (tcp_authopt_ret) {
+			arg.iov[0].iov_len += tcp_authopt_ret;
+			goto skip_md5sig;
+		}
+	}
+#endif
+#ifdef CONFIG_TCP_MD5SIG
 	hash_location = tcp_parse_md5sig_option(th);
 	if (sk && sk_fullsock(sk)) {
 		const union tcp_md5_addr *addr;
 		int l3index;
 
@@ -755,11 +814,10 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
 		key = tcp_md5_do_lookup(sk1, l3index, addr, AF_INET);
 		if (!key)
 			goto out;
 
-
 		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
 		if (genhash || memcmp(hash_location, newhash, 16) != 0)
 			goto out;
 
 	}
@@ -775,10 +833,13 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 
 		tcp_v4_md5_hash_hdr((__u8 *) &rep.opt[1],
 				     key, ip_hdr(skb)->saddr,
 				     ip_hdr(skb)->daddr, &rep.th);
 	}
+#endif
+#ifdef CONFIG_TCP_AUTHOPT
+skip_md5sig:
 #endif
 	/* Can't co-exist with TCPMD5, hence check rep.opt[0] */
 	if (rep.opt[0] == 0) {
 		__be32 mrst = mptcp_reset_option(skb);
 
@@ -828,12 +889,14 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	ctl_sk->sk_mark = 0;
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
 	local_bh_enable();
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG)
 out:
+#endif
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT)
 	rcu_read_unlock();
 #endif
 }
 
 /* The code following below sending ACKs in SYN-RECV and TIME-WAIT states
@@ -850,10 +913,12 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	struct {
 		struct tcphdr th;
 		__be32 opt[(TCPOLEN_TSTAMP_ALIGNED >> 2)
 #ifdef CONFIG_TCP_MD5SIG
 			   + (TCPOLEN_MD5SIG_ALIGNED >> 2)
+#elif defined(CONFIG_TCP_AUTHOPT)
+			   + (TCPOLEN_AUTHOPT_OUTPUT >> 2)
 #endif
 			];
 	} rep;
 	struct net *net = sock_net(sk);
 	struct ip_reply_arg arg;
@@ -881,10 +946,23 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	rep.th.seq     = htonl(seq);
 	rep.th.ack_seq = htonl(ack);
 	rep.th.ack     = 1;
 	rep.th.window  = htons(win);
 
+#ifdef CONFIG_TCP_AUTHOPT
+	if (tcp_authopt_needed) {
+		int aoret, offset = (tsecr) ? 3 : 0;
+
+		aoret = tcp_v4_authopt_handle_reply(sk, skb, &rep.opt[offset], &rep.th);
+		if (aoret) {
+			arg.iov[0].iov_len += aoret;
+#ifdef CONFIG_TCP_MD5SIG
+			key = NULL;
+#endif
+		}
+	}
+#endif
 #ifdef CONFIG_TCP_MD5SIG
 	if (key) {
 		int offset = (tsecr) ? 3 : 0;
 
 		rep.opt[offset++] = htonl((TCPOPT_NOP << 24) |
-- 
2.25.1

