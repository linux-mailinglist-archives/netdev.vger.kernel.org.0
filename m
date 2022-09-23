Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4934B5E8338
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbiIWUOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbiIWUOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:14:23 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951911323F0
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:52 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n10so1510297wrw.12
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=/k4g1FhHi3OusP5oSj3EPRB1Z5BMxSvoekk9TRX2sQI=;
        b=b6nJ6xWLruj45iEHq6+B+tAg1ekTyajSynsBePm4GpBRUQQTxwWDzy80VF7xJpjbUn
         +gZvu+dWzsVKlH/cx+oLZ4oLLyWsgStxiTal/YeVONHAgqbU0xHMm8lrLC5FRbl6zTnJ
         NoqZi/5mNxkulxLA47spDBro1YqlFezaCUQRNWBr7Nj73/fogbBiXcFbY4iExI/DzjJk
         JLqSvZfYpjIq9KLCUM0OrEO9eUOFaa8D9sxacofw/tGJoVYUSoQYmlxsH47wEVBMpFvx
         yaQg8YbvnJiyBXu0g/9jUh41MBOStTY0DO+TE85rzv1VYQ5AMBtYtMuhv6DFSNvX/+tG
         qvWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=/k4g1FhHi3OusP5oSj3EPRB1Z5BMxSvoekk9TRX2sQI=;
        b=TAbkvuttvuWx8R0QJbVgsoANtdM4q090mY2wXNPWLrUsz121nAGAaLfe6/OqQ3yJd6
         RQ9S7P52gHJYyxNpiRGzSM+ey3+FOnUIjZNj/loIEcGDkHkgV4Ot0+n01FBLEY/tt/7z
         u3yn4D1lRgocdkCg7a5LMgU8oDcA1luF7+RKaWt6A5aJ5mixW8FO9blrUqaT2s1zaUHT
         ljz9XIojKD3LKqkxN9gLcRivOwuzOoE8T0j4ukwGEWYnZ8y+n7hOn1rgylDdyzvQRsM3
         ROPfExFdgRW57KmdPEXMhgFzd2GEYXvqemPX3Lk7fZM8cUNmJGFEJwZueEdw8LMYnLDj
         YrDA==
X-Gm-Message-State: ACrzQf0gnFifkswWUcUne0jVaoBFPJOWA43KnS5NadpOGkrC6vlKTv/h
        4ctYfwPfGCzvTKiFldazQOBs/A==
X-Google-Smtp-Source: AMsMyM4yqUmeoSLyeABcPB0O9BGo2TZ7+QZir9ONzx8DLdFCjQg3OyZoh/zhlud7fZBLaM53U7kqXQ==
X-Received: by 2002:a5d:55c1:0:b0:228:6b57:c60b with SMTP id i1-20020a5d55c1000000b002286b57c60bmr6093559wrw.68.1663964031759;
        Fri, 23 Sep 2022 13:13:51 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:13:51 -0700 (PDT)
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
Subject: [PATCH v2 16/35] net/tcp: Sign SYN-ACK segments with TCP-AO
Date:   Fri, 23 Sep 2022 21:13:00 +0100
Message-Id: <20220923201319.493208-17-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 net/ipv4/tcp_ao.c     | 14 ++++++++++++++
 net/ipv4/tcp_ipv4.c   |  1 +
 net/ipv4/tcp_output.c | 37 +++++++++++++++++++++++++++++++------
 net/ipv6/tcp_ao.c     | 14 ++++++++++++++
 net/ipv6/tcp_ipv6.c   |  1 +
 7 files changed, 71 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index f21898bb31bd..19549be29265 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2109,6 +2109,10 @@ struct tcp_request_sock_ops {
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
index a1d26e1a0b82..cc3f6686d5c9 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -142,6 +142,9 @@ int tcp_ao_hash_hdr(unsigned short family, char *ao_hash,
 int tcp_v4_parse_ao(struct sock *sk, int optname, sockptr_t optval, int optlen);
 struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 				    int sndid, int rcvid);
+int tcp_v4_ao_synack_hash(char *ao_hash, struct tcp_ao_key *mkt,
+			  struct request_sock *req, const struct sk_buff *skb,
+			  int hash_offset, u32 sne);
 int tcp_v4_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 			  const struct sock *sk,
 			  __be32 sisn, __be32 disn, bool send);
@@ -176,6 +179,9 @@ int tcp_v6_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 		       const u8 *tkey, int hash_offset, u32 sne);
 int tcp_v6_parse_ao(struct sock *sk, int cmd,
 		    sockptr_t optval, int optlen);
+int tcp_v6_ao_synack_hash(char *ao_hash, struct tcp_ao_key *ao_key,
+			  struct request_sock *req, const struct sk_buff *skb,
+			  int hash_offset, u32 sne);
 void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb);
 void tcp_ao_connect_init(struct sock *sk);
 
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index a90b950781f9..6a601279852d 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -603,6 +603,20 @@ int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 			       tkey, hash_offset, sne);
 }
 
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
index cbe428957686..fedccda1dd55 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1654,6 +1654,7 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops = {
 #ifdef CONFIG_TCP_AO
 	.ao_lookup	=	tcp_v4_ao_lookup_rsk,
 	.ao_calc_key	=	tcp_v4_ao_calc_key_rsk,
+	.ao_synack_hash	=	tcp_v4_ao_synack_hash,
 #endif
 #ifdef CONFIG_SYN_COOKIES
 	.cookie_init_seq =	cookie_v4_init_sequence,
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index be92fe85e82c..c08ad98721d6 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3632,6 +3632,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	struct inet_request_sock *ireq = inet_rsk(req);
 	const struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_key *md5 = NULL;
+	struct tcp_ao_key *ao_key = NULL;
 	struct tcp_out_options opts;
 	struct sk_buff *skb;
 	int tcp_header_size;
@@ -3682,16 +3683,32 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 			tcp_rsk(req)->snt_synack = tcp_skb_timestamp_us(skb);
 	}
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 	rcu_read_lock();
-	md5 = tcp_rsk(req)->af_specific->req_md5_lookup(sk, req_to_sk(req));
 #endif
+	if (tcp_rsk_used_ao(req)) {
+#ifdef CONFIG_TCP_AO
+		/* TODO: what should we do if the key is no longer available on
+		 * the listening socket? Maybe we can try a different matching
+		 * key (without sndid match). If that also fails what should
+		 * we do? We currently send an unsigned synack. It's probably
+		 * better to not send anything.
+		 */
+		ao_key = tcp_sk(sk)->af_specific->ao_lookup(sk, req_to_sk(req),
+						    tcp_rsk(req)->ao_keyid, -1);
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
@@ -3711,7 +3728,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 
 	/* RFC1323: The window in SYN & SYN/ACK segments is never scaled. */
 	th->window = htons(min(req->rsk_rcv_wnd, 65535U));
-	tcp_options_write(th, NULL, NULL, &opts, NULL);
+	tcp_options_write(th, NULL, tcp_rsk(req), &opts, NULL);
 	th->doff = (tcp_header_size >> 2);
 	__TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
 
@@ -3719,7 +3736,15 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
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
index 31ae504af8e6..526bbe232a64 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -123,3 +123,17 @@ int tcp_v6_parse_ao(struct sock *sk, int cmd,
 {
 	return tcp_parse_ao(sk, cmd, AF_INET6, optval, optlen);
 }
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
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 7610fdf5d519..16cea7de0851 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -838,6 +838,7 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
 #ifdef CONFIG_TCP_AO
 	.ao_lookup	=	tcp_v6_ao_lookup_rsk,
 	.ao_calc_key	=	tcp_v6_ao_calc_key_rsk,
+	.ao_synack_hash =	tcp_v6_ao_synack_hash,
 #endif
 #ifdef CONFIG_SYN_COOKIES
 	.cookie_init_seq =	cookie_v6_init_sequence,
-- 
2.37.2

