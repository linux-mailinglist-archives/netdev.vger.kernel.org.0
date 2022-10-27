Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F717610326
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237066AbiJ0UrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237033AbiJ0UpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:45:02 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08E49410C
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:44:13 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id bk15so4129817wrb.13
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SvpBIzB80zoncTXVKn2CMKV32VOSx9DN7/sSdVAlkPs=;
        b=QTfH1kNbwMAOzIOlKpQ2ZFUaUXuFcG3OdLZPDukYMQfGig6egfkav0ANfV+4PL8u3o
         It01Ejali4WJrEV9s65nRhcYOSxkzVV6mckE3QyC9nP3MqNsyDIhuFEvO8uEi0O0cJQs
         4oaOOUJObeww0OOa5Cz79ktrciz3KOVWGbsrMg2vPI8sgYBmVh9h5SOIuK+xkfEumrE0
         0NPr9w1t2/rGcWBnqOOd9MiiNtk8hZIKHzXFijTUuoF6etPpiA0PS/SJ5ca9aoVXaynm
         VAPALPf5AjWfiDn6RFViZvqEwXsq+G+SzwQKvHzzvTViCI2/vLHfFtFeiwOa4pnSOKwu
         Tpsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SvpBIzB80zoncTXVKn2CMKV32VOSx9DN7/sSdVAlkPs=;
        b=hMFXVfzfmnJ30K7EuGL3ee8bYBt8xCXIwhBIK/Mh5Ci5rC8OUgknEIaqf66amJzEtX
         C4Bu/PLes3OZkDiFAEpIhK7BxD2XQWM/WNoy56Wmv7hLQ1Rhvfxr43ElRBmzj0EMRF+l
         S6NqnhjfB34VIAmgWopyMctOsIXjBVZdrZiRD/t0x4u3DpAerkFPVrNu1yZR/QX1LJcs
         zqwI40dF/9eo9lctmolfxMWqkHy1U7p25wO2yO98tEtgTswUSBHiR492CprSNrwlzksP
         RNgll7nv4XvQPp9p01cRicDCiRRAEjEkfpJ6EkVN+iesVj5XHeoKUqbtXAgjLV/5qtj0
         df3Q==
X-Gm-Message-State: ACrzQf1mDGHrVuxkZyynsnrZHaITyefFb/JSOQB9G8YJJoM/pARPiiz8
        8AqC0HepdjLGNv2SKsCV8eRQMg==
X-Google-Smtp-Source: AMsMyM7bDFixi+UAZKIDLMS2w2UmQ3xw8J8pj2dZE1zZYN0GuRZyOnt5sO+kZuaFmvcppZisBIHQRA==
X-Received: by 2002:a05:6000:1f8e:b0:236:86de:6fff with SMTP id bw14-20020a0560001f8e00b0023686de6fffmr8648410wrb.387.1666903453378;
        Thu, 27 Oct 2022 13:44:13 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:44:12 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 12/36] net/tcp: Add tcp_parse_auth_options()
Date:   Thu, 27 Oct 2022 21:43:23 +0100
Message-Id: <20221027204347.529913-13-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
References: <20221027204347.529913-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a helper that:
(1) shares the common code with TCP-MD5 header options parsing
(2) looks for hash signature only once for both TCP-MD5 and TCP-AO
(3) fails with -EEXIST if any TCP sign option is present twice, see
    RFC5925 (2.2):
    ">> A single TCP segment MUST NOT have more than one TCP-AO in its
    options sequence. When multiple TCP-AOs appear, TCP MUST discard
    the segment."

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h    | 24 +++++++++++++++++++++++-
 include/net/tcp_ao.h | 17 ++++++++++++++++-
 net/ipv4/tcp.c       |  3 ++-
 net/ipv4/tcp_input.c | 39 +++++++++++++++++++++++++++++----------
 net/ipv4/tcp_ipv4.c  | 15 ++++++++++-----
 net/ipv6/tcp_ipv6.c  | 11 +++++++----
 6 files changed, 87 insertions(+), 22 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index f3d1e7370461..d2395ae7484c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -435,7 +435,6 @@ int tcp_mmap(struct file *file, struct socket *sock,
 void tcp_parse_options(const struct net *net, const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx,
 		       int estab, struct tcp_fastopen_cookie *foc);
-const u8 *tcp_parse_md5sig_option(const struct tcphdr *th);
 
 /*
  *	BPF SKB-less helpers
@@ -2477,4 +2476,27 @@ static inline u64 tcp_transmit_time(const struct sock *sk)
 	return 0;
 }
 
+static inline int tcp_parse_auth_options(const struct tcphdr *th,
+		const u8 **md5_hash, const struct tcp_ao_hdr **aoh)
+{
+	const u8 *md5_tmp, *ao_tmp;
+	int ret;
+
+	ret = tcp_do_parse_auth_options(th, &md5_tmp, &ao_tmp);
+	if (ret)
+		return ret;
+
+	if (md5_hash)
+		*md5_hash = md5_tmp;
+
+	if (aoh) {
+		if (!ao_tmp)
+			*aoh = NULL;
+		else
+			*aoh = (struct tcp_ao_hdr *)(ao_tmp - 2);
+	}
+
+	return 0;
+}
+
 #endif	/* _TCP_H */
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index f840b693d038..7b38ac70416f 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -150,7 +150,9 @@ int tcp_v6_parse_ao(struct sock *sk, int cmd,
 		    sockptr_t optval, int optlen);
 void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb);
 void tcp_ao_connect_init(struct sock *sk);
-
+void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
+		      struct tcp_request_sock *treq,
+		      unsigned short int family);
 #else /* CONFIG_TCP_AO */
 
 static inline struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
@@ -173,4 +175,17 @@ static inline void tcp_ao_connect_init(struct sock *sk)
 }
 #endif
 
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
+int tcp_do_parse_auth_options(const struct tcphdr *th,
+			      const u8 **md5_hash, const u8 **ao_hash);
+#else
+static int tcp_do_parse_auth_options(const struct tcphdr *th,
+				     const u8 **md5_hash, const u8 **ao_hash)
+{
+	*md5_hash = NULL;
+	*ao_hash = NULL;
+	return 0;
+}
+#endif
+
 #endif /* _TCP_AO_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 27662c9b0870..875149817036 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4538,7 +4538,8 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	l3index = sdif ? dif : 0;
 
 	hash_expected = tcp_md5_do_lookup(sk, l3index, saddr, family);
-	hash_location = tcp_parse_md5sig_option(th);
+	if (tcp_parse_auth_options(th, &hash_location, NULL))
+		return true;
 
 	/* We've parsed the options - do we have a hash? */
 	if (!hash_expected && !hash_location)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0e753a2f84e4..a7c3823cd052 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4201,39 +4201,58 @@ static bool tcp_fast_parse_options(const struct net *net,
 	return true;
 }
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 /*
- * Parse MD5 Signature option
+ * Parse Signature options
  */
-const u8 *tcp_parse_md5sig_option(const struct tcphdr *th)
+int tcp_do_parse_auth_options(const struct tcphdr *th,
+			      const u8 **md5_hash, const u8 **ao_hash)
 {
 	int length = (th->doff << 2) - sizeof(*th);
 	const u8 *ptr = (const u8 *)(th + 1);
+	unsigned int minlen = TCPOLEN_MD5SIG;
+
+	if (IS_ENABLED(CONFIG_TCP_AO))
+		minlen = sizeof(struct tcp_ao_hdr) + 1;
+
+	*md5_hash = NULL;
+	*ao_hash = NULL;
 
 	/* If not enough data remaining, we can short cut */
-	while (length >= TCPOLEN_MD5SIG) {
+	while (length >= minlen) {
 		int opcode = *ptr++;
 		int opsize;
 
 		switch (opcode) {
 		case TCPOPT_EOL:
-			return NULL;
+			return 0;
 		case TCPOPT_NOP:
 			length--;
 			continue;
 		default:
 			opsize = *ptr++;
 			if (opsize < 2 || opsize > length)
-				return NULL;
-			if (opcode == TCPOPT_MD5SIG)
-				return opsize == TCPOLEN_MD5SIG ? ptr : NULL;
+				return -EINVAL;
+			if (opcode == TCPOPT_MD5SIG) {
+				if (opsize != TCPOLEN_MD5SIG)
+					return -EINVAL;
+				if (unlikely(*md5_hash || *ao_hash))
+					return -EEXIST;
+				*md5_hash = ptr;
+			} else if (opcode == TCPOPT_AO) {
+				if (opsize <= sizeof(struct tcp_ao_hdr))
+					return -EINVAL;
+				if (unlikely(*md5_hash || *ao_hash))
+					return -EEXIST;
+				*ao_hash = ptr;
+			}
 		}
 		ptr += opsize - 2;
 		length -= opsize;
 	}
-	return NULL;
+	return 0;
 }
-EXPORT_SYMBOL(tcp_parse_md5sig_option);
+EXPORT_SYMBOL(tcp_do_parse_auth_options);
 #endif
 
 /* Sorry, PAWS as specified is broken wrt. pure-ACKs -DaveM
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ee9efaa9d8d5..1c014b326ee6 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -680,7 +680,9 @@ EXPORT_SYMBOL(tcp_v4_send_check);
  *	Exception: precedence violation. We do not implement it in any case.
  */
 
-#ifdef CONFIG_TCP_MD5SIG
+#ifdef CONFIG_TCP_AO
+#define OPTION_BYTES MAX_TCP_OPTION_SPACE
+#elif defined(CONFIG_TCP_MD5SIG)
 #define OPTION_BYTES TCPOLEN_MD5SIG_ALIGNED
 #else
 #define OPTION_BYTES sizeof(__be32)
@@ -696,7 +698,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	struct ip_reply_arg arg;
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key *key = NULL;
-	const __u8 *hash_location = NULL;
+	const __u8 *md5_hash_location = NULL;
 	unsigned char newhash[16];
 	int genhash;
 	struct sock *sk1 = NULL;
@@ -736,8 +738,11 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 
 	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
 #ifdef CONFIG_TCP_MD5SIG
+	/* Invalid TCP option size or twice included auth */
+	if (tcp_parse_auth_options(tcp_hdr(skb), &md5_hash_location, NULL))
+		return;
+
 	rcu_read_lock();
-	hash_location = tcp_parse_md5sig_option(th);
 	if (sk && sk_fullsock(sk)) {
 		const union tcp_md5_addr *addr;
 		int l3index;
@@ -748,7 +753,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		l3index = tcp_v4_sdif(skb) ? inet_iif(skb) : 0;
 		addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
 		key = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
-	} else if (hash_location) {
+	} else if (md5_hash_location) {
 		const union tcp_md5_addr *addr;
 		int sdif = tcp_v4_sdif(skb);
 		int dif = inet_iif(skb);
@@ -780,7 +785,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 
 
 		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
-		if (genhash || memcmp(hash_location, newhash, 16) != 0)
+		if (genhash || memcmp(md5_hash_location, newhash, 16) != 0)
 			goto out;
 
 	}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index bb2b21965911..58a77515aa27 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1000,7 +1000,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	u32 seq = 0, ack_seq = 0;
 	struct tcp_md5sig_key *key = NULL;
 #ifdef CONFIG_TCP_MD5SIG
-	const __u8 *hash_location = NULL;
+	const __u8 *md5_hash_location = NULL;
 	unsigned char newhash[16];
 	int genhash;
 	struct sock *sk1 = NULL;
@@ -1022,8 +1022,11 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 
 	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
 #ifdef CONFIG_TCP_MD5SIG
+	/* Invalid TCP option size or twice included auth */
+	if (tcp_parse_auth_options(th, &md5_hash_location, NULL))
+		return;
+
 	rcu_read_lock();
-	hash_location = tcp_parse_md5sig_option(th);
 	if (sk && sk_fullsock(sk)) {
 		int l3index;
 
@@ -1032,7 +1035,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		 */
 		l3index = tcp_v6_sdif(skb) ? tcp_v6_iif_l3_slave(skb) : 0;
 		key = tcp_v6_md5_do_lookup(sk, &ipv6h->saddr, l3index);
-	} else if (hash_location) {
+	} else if (md5_hash_location) {
 		int dif = tcp_v6_iif_l3_slave(skb);
 		int sdif = tcp_v6_sdif(skb);
 		int l3index;
@@ -1061,7 +1064,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 			goto out;
 
 		genhash = tcp_v6_md5_hash_skb(newhash, key, NULL, skb);
-		if (genhash || memcmp(hash_location, newhash, 16) != 0)
+		if (genhash || memcmp(md5_hash_location, newhash, 16) != 0)
 			goto out;
 	}
 #endif
-- 
2.38.1

