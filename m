Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C09B5989B5
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344515AbiHRRCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345432AbiHRRAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:00:47 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4BCB9F83
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:37 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id e20so1937959wri.13
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Wbc32LplcthNECwQ3XSLnSTtNoYHvDa/GfoZYIXw7pQ=;
        b=FqgYhAtjkpP9V0t6e7qUWtsKI24bIP9QEPsJhtLEkWiUKCCLSB6i9FJj3MWSkQyH2n
         htInieB/sU7YcdgZvmSe97U6SBnTJVShz9RbbN7Mge5U7KY/v6MATChIPwI2rg8lEJyv
         yLiAeE2s+cubjjUC6S5KVpv7S5gxVTvQEUW9psXZP4Ls0cavx8SJkuRln2tt5cuSoXCw
         t2xhsDOxIEj0NsXg8ctda/BTiw6myCLFLk806MXn1XMt0GO0UG1+2LpoXgjXzb/Oo2Eq
         R1ldO5ZM3mcM7sWi1I0d+V7lssCONyqF6k3x5iFfapGfnRZ5g1nZWBaKoTJjv0JxqVDt
         WgPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Wbc32LplcthNECwQ3XSLnSTtNoYHvDa/GfoZYIXw7pQ=;
        b=tSJBPaJNaaDqRz/mnOnr8eQImQDZahZ80axLyMu6Ri+ahRKo+bVMkAXELf7E6ek2FM
         +/RDDg1CKTaAAFFkWXN5wy/BLDxjEu5lFpM0RY2h4eevgqsfxGWDq0ZOtEoiPhCsc1LI
         btjpaV6n8HDRXtZKFzbgD9O3698s8JXHlRUpTXjC/z5sXCo1cnvnypEzys08TLGH8rs+
         YHk1Jrn2DlY02fxvsefycqhD3Ub7AbnuOeWB8BJII/K5cnizSK2Zvg7FX/foAWYHNeAU
         XZTmreUOSlcLlumduxbODO6NqRPgcbnZzjfu8w3C1+boV4O5mqK6Q1qyQo90KO/7ZPQ7
         7FjQ==
X-Gm-Message-State: ACgBeo3cWmeIvGX0tpdwV0dyrlnfx4Cri6R0WTGk0dvoHVjtrFkA2N7F
        W7+kb6Ga5iFa40C4gdOY/Hkbeg==
X-Google-Smtp-Source: AA6agR6kQTuVQKDI0NgRLJXKI8D/0Nzh6aotUFJbRV01HbOeEjfSnxLBzOVp8G7Q9iBHJUHQugFHkg==
X-Received: by 2002:a05:6000:80b:b0:21e:d62e:b282 with SMTP id bt11-20020a056000080b00b0021ed62eb282mr2122675wrb.557.1660842037192;
        Thu, 18 Aug 2022 10:00:37 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:36 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
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
Subject: [PATCH 16/31] net/tcp: Sign SYN-ACK segments with TCP-AO
Date:   Thu, 18 Aug 2022 17:59:50 +0100
Message-Id: <20220818170005.747015-17-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
References: <20220818170005.747015-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index a797eedfbcdf..78c24ade9a03 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -586,6 +586,20 @@ int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
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
index 55c763b8bf24..02ab94461e86 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1649,6 +1649,7 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops = {
 #ifdef CONFIG_TCP_AO
 	.ao_lookup	=	tcp_v4_ao_lookup_rsk,
 	.ao_calc_key	=	tcp_v4_ao_calc_key_rsk,
+	.ao_synack_hash	=	tcp_v4_ao_synack_hash,
 #endif
 #ifdef CONFIG_SYN_COOKIES
 	.cookie_init_seq =	cookie_v4_init_sequence,
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 81f897f95147..43111e39b6e1 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3630,6 +3630,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	struct inet_request_sock *ireq = inet_rsk(req);
 	const struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_key *md5 = NULL;
+	struct tcp_ao_key *ao_key = NULL;
 	struct tcp_out_options opts;
 	struct sk_buff *skb;
 	int tcp_header_size;
@@ -3680,16 +3681,32 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
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
@@ -3709,7 +3726,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 
 	/* RFC1323: The window in SYN & SYN/ACK segments is never scaled. */
 	th->window = htons(min(req->rsk_rcv_wnd, 65535U));
-	tcp_options_write(th, NULL, NULL, &opts, NULL);
+	tcp_options_write(th, NULL, tcp_rsk(req), &opts, NULL);
 	th->doff = (tcp_header_size >> 2);
 	__TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
 
@@ -3717,7 +3734,15 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
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

