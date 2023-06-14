Return-Path: <netdev+bounces-10923-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28502730B4B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:14:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D79CC281603
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AB11156CE;
	Wed, 14 Jun 2023 23:10:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6827D18AFB
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:10:30 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B7B2945
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:10:14 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f8cc04c278so12091575e9.0
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1686784213; x=1689376213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o1vb5m6IVQJ1cFp2Ed14+1yhRSgEojUi75muFVumirk=;
        b=KQV8IpvgfOnn5KiyFM7tKdjuwxurvubkrp7/O2pDLkrylTj5RLRUw9o0c3g6fZAo6X
         zV0hiBqJ8QuJM/YWbqr35aB4KLUe8BgTTO8xhbQzzqiIGnQ8z96yoKYCKyl3mNqKynhD
         mNPvIxOTMGctu32yixS3W7OvIi8SA8byOvwdAyDo10EjauCoBcIpjhdaQ5f9aOtUudN2
         D7PM2Fp7C1xIAZCaKdcla3KPcQpBKfbW1IqMqJBu5SzSyXbtLz9z43zXqLp/br7GTKJz
         hcs6+PIVYj279K9VQPXerYmbvwjB1t1lKC95y+fn/OtcE/+ABRjxPok3QQbqR2e4B3Y3
         PHaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686784213; x=1689376213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o1vb5m6IVQJ1cFp2Ed14+1yhRSgEojUi75muFVumirk=;
        b=Bp84rrFz1RWNMgCjz59eyAxBWT9928sE1lCvnQfBpmduSMFTNeM/nP26lkbyxsDOYl
         VsUPFUq6ymlPQx5E29B8YS5nKHOaeE32yOwcUklhK0vhW8rLsGZK0hGemIqHYbFOc1GE
         8JPSerawtK+5HX8wr0eYzwfD6pjkUD6mwbQDPCAsYRfzDmGH4ZwqGWqOu9cVfrXMvFN3
         hSA802uqFEqrW0HQqQ3cURee5SdDySHqLSP8uHCBCFSKK1xYHNrKcnNdzkO028zwfZpS
         P4wqbjNlsekzNcWUWPVMGaSwcO2NhmDTgg3yJCWfGVbMIsMpnQjnQXFbX1YytiuGQ8mm
         xWSw==
X-Gm-Message-State: AC+VfDxLZQXmgYGMfngkto38ziJavRhShG7YEKQ9kgLF3zWiIA/1Dsvu
	rYB76lTrAFQF34YAjTXRFD0yXA==
X-Google-Smtp-Source: ACHHUZ52SUwPK9D5YxEfFFj0Kdk0yGGTp3JAmgeG+1lA8xZHg30UnJYFQ7dwXWM9yZvNdYlXEw4W+g==
X-Received: by 2002:a7b:c84c:0:b0:3f7:2d7d:c673 with SMTP id c12-20020a7bc84c000000b003f72d7dc673mr12651770wml.14.1686784212781;
        Wed, 14 Jun 2023 16:10:12 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s12-20020a7bc38c000000b003f7ba52eeccsm18725261wmj.7.2023.06.14.16.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 16:10:12 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
	Dmitry Safonov <dima@arista.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Bob Gilligan <gilligan@arista.com>,
	Dan Carpenter <error27@gmail.com>,
	David Laight <David.Laight@aculab.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Donald Cassidy <dcassidy@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>,
	netdev@vger.kernel.org
Subject: [PATCH v7 11/22] net/tcp: Sign SYN-ACK segments with TCP-AO
Date: Thu, 15 Jun 2023 00:09:36 +0100
Message-Id: <20230614230947.3954084-12-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230614230947.3954084-1-dima@arista.com>
References: <20230614230947.3954084-1-dima@arista.com>
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

Similarly to RST segments, wire SYN-ACKs to TCP-AO.
tcp_rsk_used_ao() is handy here to check if the request socket used AO
and needs a signature on the outgoing segments.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h     |  4 ++++
 include/net/tcp_ao.h  |  6 ++++++
 net/ipv4/tcp_ao.c     | 14 +++++++++++++
 net/ipv4/tcp_ipv4.c   |  1 +
 net/ipv4/tcp_output.c | 48 +++++++++++++++++++++++++++++++++++++------
 net/ipv6/tcp_ao.c     | 15 ++++++++++++++
 net/ipv6/tcp_ipv6.c   |  1 +
 7 files changed, 83 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index f80e99fc1922..1d38ecac9b00 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2151,6 +2151,10 @@ struct tcp_request_sock_ops {
 					       int sndid, int rcvid);
 	int			(*ao_calc_key)(struct tcp_ao_key *mkt, u8 *key,
 						struct request_sock *sk);
+	int		(*ao_synack_hash)(char *ao_hash, struct tcp_ao_key *mkt,
+					  struct request_sock *req,
+					  const struct sk_buff *skb,
+					  int hash_offset, u32 sne);
 #endif
 #ifdef CONFIG_SYN_COOKIES
 	__u32 (*cookie_init_seq)(const struct sk_buff *skb,
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 02a15aa6650f..933b39445575 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -149,6 +149,9 @@ int tcp_ao_prepare_reset(const struct sock *sk, struct sk_buff *skb,
 int tcp_v4_parse_ao(struct sock *sk, int optname, sockptr_t optval, int optlen);
 struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 				    int sndid, int rcvid);
+int tcp_v4_ao_synack_hash(char *ao_hash, struct tcp_ao_key *mkt,
+			  struct request_sock *req, const struct sk_buff *skb,
+			  int hash_offset, u32 sne);
 int tcp_v4_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 			  const struct sock *sk,
 			  __be32 sisn, __be32 disn, bool send);
@@ -184,6 +187,9 @@ int tcp_v6_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 		       const u8 *tkey, int hash_offset, u32 sne);
 int tcp_v6_parse_ao(struct sock *sk, int cmd,
 		    sockptr_t optval, int optlen);
+int tcp_v6_ao_synack_hash(char *ao_hash, struct tcp_ao_key *ao_key,
+			  struct request_sock *req, const struct sk_buff *skb,
+			  int hash_offset, u32 sne);
 void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb);
 void tcp_ao_connect_init(struct sock *sk);
 void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index d3e916d2ed98..a22d6321bc81 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -554,6 +554,20 @@ int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 }
 EXPORT_SYMBOL_GPL(tcp_v4_ao_hash_skb);
 
+int tcp_v4_ao_synack_hash(char *ao_hash, struct tcp_ao_key *ao_key,
+			  struct request_sock *req, const struct sk_buff *skb,
+			  int hash_offset, u32 sne)
+{
+	char traffic_key[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+
+	tcp_v4_ao_calc_key_rsk(ao_key, traffic_key, req);
+
+	tcp_ao_hash_skb(AF_INET, ao_hash, ao_key, req_to_sk(req), skb,
+			traffic_key, hash_offset, sne);
+
+	return 0;
+}
+
 struct tcp_ao_key *tcp_v4_ao_lookup_rsk(const struct sock *sk,
 					struct request_sock *req,
 					int sndid, int rcvid)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 1d78853ec07c..97712b954e2d 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1673,6 +1673,7 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops = {
 #ifdef CONFIG_TCP_AO
 	.ao_lookup	=	tcp_v4_ao_lookup_rsk,
 	.ao_calc_key	=	tcp_v4_ao_calc_key_rsk,
+	.ao_synack_hash	=	tcp_v4_ao_synack_hash,
 #endif
 #ifdef CONFIG_SYN_COOKIES
 	.cookie_init_seq =	cookie_v4_init_sequence,
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5344e6564b56..f055ef225c37 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3638,6 +3638,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	struct inet_request_sock *ireq = inet_rsk(req);
 	const struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_key *md5 = NULL;
+	struct tcp_ao_key *ao_key = NULL;
 	struct tcp_out_options opts;
 	struct sk_buff *skb;
 	int tcp_header_size;
@@ -3688,16 +3689,43 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 			tcp_rsk(req)->snt_synack = tcp_skb_timestamp_us(skb);
 	}
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 	rcu_read_lock();
-	md5 = tcp_rsk(req)->af_specific->req_md5_lookup(sk, req_to_sk(req));
 #endif
+	if (tcp_rsk_used_ao(req)) {
+#ifdef CONFIG_TCP_AO
+		u8 maclen = tcp_rsk(req)->maclen;
+		u8 keyid = tcp_rsk(req)->ao_keyid;
+
+		ao_key = tcp_sk(sk)->af_specific->ao_lookup(sk, req_to_sk(req),
+							    keyid, -1);
+		/* If there is no matching key - avoid sending anything,
+		 * especially usigned segments. It could try harder and lookup
+		 * for another peer-matching key, but the peer has requested
+		 * ao_keyid (RFC5925 RNextKeyID), so let's keep it simple here.
+		 */
+		if (unlikely(!ao_key || tcp_ao_maclen(ao_key) != maclen)) {
+			rcu_read_unlock();
+			skb_dst_drop(skb);
+			kfree_skb(skb);
+			net_warn_ratelimited("TCP-AO: the keyid %u with maclen %u|%u from SYN packet is not present - not sending SYNACK\n",
+					     keyid, maclen,
+					     ao_key ? tcp_ao_maclen(ao_key) : 0);
+			return NULL;
+		}
+#endif
+	} else {
+#ifdef CONFIG_TCP_MD5SIG
+		md5 = tcp_rsk(req)->af_specific->req_md5_lookup(sk,
+								req_to_sk(req));
+#endif
+	}
 	skb_set_hash(skb, tcp_rsk(req)->txhash, PKT_HASH_TYPE_L4);
 	/* bpf program will be interested in the tcp_flags */
 	TCP_SKB_CB(skb)->tcp_flags = TCPHDR_SYN | TCPHDR_ACK;
 	tcp_header_size = tcp_synack_options(sk, req, mss, skb, &opts, md5,
-					     NULL, foc, synack_type,
-					     syn_skb) + sizeof(*th);
+					     ao_key, foc, synack_type, syn_skb)
+					+ sizeof(*th);
 
 	skb_push(skb, tcp_header_size);
 	skb_reset_transport_header(skb);
@@ -3717,7 +3745,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 
 	/* RFC1323: The window in SYN & SYN/ACK segments is never scaled. */
 	th->window = htons(min(req->rsk_rcv_wnd, 65535U));
-	tcp_options_write(th, NULL, NULL, &opts, NULL);
+	tcp_options_write(th, NULL, tcp_rsk(req), &opts, ao_key);
 	th->doff = (tcp_header_size >> 2);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
 
@@ -3725,7 +3753,15 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	/* Okay, we have all we need - do the md5 hash if needed */
 	if (md5)
 		tcp_rsk(req)->af_specific->calc_md5_hash(opts.hash_location,
-					       md5, req_to_sk(req), skb);
+					md5, req_to_sk(req), skb);
+#endif
+#ifdef CONFIG_TCP_AO
+	if (ao_key)
+		tcp_rsk(req)->af_specific->ao_synack_hash(opts.hash_location,
+					ao_key, req, skb,
+					opts.hash_location - (u8 *)th, 0);
+#endif
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 	rcu_read_unlock();
 #endif
 
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index 17acb2fd5182..bc032e441ef8 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -128,3 +128,18 @@ int tcp_v6_parse_ao(struct sock *sk, int cmd,
 	return tcp_parse_ao(sk, cmd, AF_INET6, optval, optlen);
 }
 EXPORT_SYMBOL_GPL(tcp_v6_parse_ao);
+
+int tcp_v6_ao_synack_hash(char *ao_hash, struct tcp_ao_key *ao_key,
+			  struct request_sock *req, const struct sk_buff *skb,
+			  int hash_offset, u32 sne)
+{
+	char traffic_key[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+
+	tcp_v6_ao_calc_key_rsk(ao_key, traffic_key, req);
+
+	tcp_ao_hash_skb(AF_INET6, ao_hash, ao_key, req_to_sk(req), skb,
+			traffic_key, hash_offset, sne);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tcp_v6_ao_synack_hash);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index a7efec5af4e6..19f644970196 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -849,6 +849,7 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
 #ifdef CONFIG_TCP_AO
 	.ao_lookup	=	tcp_v6_ao_lookup_rsk,
 	.ao_calc_key	=	tcp_v6_ao_calc_key_rsk,
+	.ao_synack_hash =	tcp_v6_ao_synack_hash,
 #endif
 #ifdef CONFIG_SYN_COOKIES
 	.cookie_init_seq =	cookie_v6_init_sequence,
-- 
2.40.0


