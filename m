Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017136D53B6
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbjDCViN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbjDCVhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:37:10 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14A35274
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:35:16 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id e9so16556291ljq.4
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 14:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1680557714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bg1GAUQ8orDuaJEFgpnPnfLLLPClPLM0sb6SOYipuYA=;
        b=eEM1QyKkGUBju6vbrrTgNUxrpeGHgMvHa3fDfpDe2y8ruI86EbyHZQ/0x5sxW/KYdd
         IVWJ4cbtv+mkV8lVyJ1hYvF4t08nur6ajeapnXwVMEpgl6MC2JngCxBeSFvCDF1b9/Ug
         v2PW8P5A593ese+FjmT2f2ZPMg/uNotIyJjbPoP6kXvOqaeem+syHqRwmfPNOMub0Fpm
         9enP998y2SFJ+ftbZm8EHBVbb6PBXNW2UL35poxHcg6wmqMBK/EakgCLxo06ibudVT5H
         Iz92MfKxu35Hwd4nmpomtX3ddb5g+ua3zPo7ZNm7u2a5cwI6cZSP4aHTWklA59aM1IR6
         YWqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680557714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bg1GAUQ8orDuaJEFgpnPnfLLLPClPLM0sb6SOYipuYA=;
        b=rsG3zT5ivedke53ivHxuZzVJNX/Ych8Nz+jwh1iaQjfdM+ATQOSn8njaDKNzB96WJf
         2uPHB2vbw0hPRHISvycKdBPOGt7wXoxO66UPOr2TAPM8YnTMJAgqvAWdw3A9riatig1e
         wqfGKzgEA3FvLd5i5gHzkAP7GKsR6qcMBx8hbpvZNsaFZvJdPBaI7PrZujMLU3PyO1FU
         1MiZ30TX8R7eY7WD85vRfa2UVQLuy04RvovMPRe0JjsbLLPsKwm6WndpMF/smGURJKm5
         6doAT3VUvMM3v9xXVHG/mqgoq3SouXLJ0p2wdxp5bxpltVfqcqLMkTTo0EWXFGuK6+jZ
         /4QA==
X-Gm-Message-State: AAQBX9e42Vd5g1Wrf0VG82ROtUqqSUF2s/V1b8JaOrprPORjxEmryyKK
        JUa/VIIE07otkNQEAJhhVdt0Bt1rke3xLFrfuqw=
X-Google-Smtp-Source: AKy350YEEy8UtjlbCsjHg9aauTDcuxZWgRhQIa0/z97ewbPY2iEJh0wM1PzqrprRKcrKaPvyS0Yb9A==
X-Received: by 2002:adf:f4c7:0:b0:2ce:ac70:5113 with SMTP id h7-20020adff4c7000000b002ceac705113mr27783879wrp.41.1680557688102;
        Mon, 03 Apr 2023 14:34:48 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id o5-20020a5d4a85000000b002c3f9404c45sm10682740wrq.7.2023.04.03.14.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 14:34:47 -0700 (PDT)
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
Subject: [PATCH v5 15/21] net/tcp: Add tcp_hash_fail() ratelimited logs
Date:   Mon,  3 Apr 2023 22:34:14 +0100
Message-Id: <20230403213420.1576559-16-dima@arista.com>
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

Add a helper for logging connection-detailed messages for failed TCP
hash verification (both MD5 and AO).

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h    | 17 ++++++++++++++---
 include/net/tcp_ao.h | 29 +++++++++++++++++++++++++++++
 net/ipv4/tcp.c       | 23 +++++++++++++----------
 net/ipv4/tcp_ao.c    |  7 +++++++
 4 files changed, 63 insertions(+), 13 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 45343a0a128c..7b5d4ee8f6b0 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2604,12 +2604,19 @@ tcp_inbound_hash(struct sock *sk, const struct request_sock *req,
 	int l3index;
 
 	/* Invalid option or two times meet any of auth options */
-	if (tcp_parse_auth_options(th, &md5_location, &aoh))
+	if (tcp_parse_auth_options(th, &md5_location, &aoh)) {
+		tcp_hash_fail("TCP segment has incorrect auth options set",
+				family, skb, "");
 		return SKB_DROP_REASON_TCP_AUTH_HDR;
+	}
 
 	if (req) {
-		if (tcp_rsk_used_ao(req) != !!aoh)
+		if (tcp_rsk_used_ao(req) != !!aoh) {
+			tcp_hash_fail("TCP connection can't start/end using TCP-AO",
+					family, skb, "%s",
+					!aoh ? "missing AO" : "AO signed");
 			return SKB_DROP_REASON_TCP_AOFAILURE;
+		}
 	}
 
 	/* sdif set, means packet ingressed via a device
@@ -2624,10 +2631,14 @@ tcp_inbound_hash(struct sock *sk, const struct request_sock *req,
 		 * the last key is impossible to remove, so there's
 		 * always at least one current_key.
 		 */
-		if (tcp_ao_required(sk, saddr, family, true))
+		if (tcp_ao_required(sk, saddr, family, true)) {
+			tcp_hash_fail("AO hash is required, but not found",
+					family, skb, "L3 index %d", l3index);
 			return SKB_DROP_REASON_TCP_AONOTFOUND;
+		}
 		if (unlikely(tcp_md5_do_lookup(sk, l3index, saddr, family))) {
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
+			tcp_hash_fail("MD5 Hash not found", family, skb, "");
 			return SKB_DROP_REASON_TCP_MD5NOTFOUND;
 		}
 		return SKB_NOT_DROPPED_YET;
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index bd67e3680a2b..391b8260c325 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -105,6 +105,35 @@ struct tcp_ao_info {
 	struct rcu_head		rcu;
 };
 
+#define tcp_hash_fail(msg, family, skb, fmt, ...)			\
+do {									\
+	const struct tcphdr *th = tcp_hdr(skb);				\
+	char hdr_flags[5] = {};						\
+	char *f = hdr_flags;						\
+									\
+	if (th->fin)							\
+		*f++ = 'F';						\
+	if (th->syn)							\
+		*f++ = 'S';						\
+	if (th->rst)							\
+		*f++ = 'R';						\
+	if (th->ack)							\
+		*f++ = 'A';						\
+	if (f != hdr_flags)						\
+		*f = ' ';						\
+	if (family == AF_INET) {					\
+		net_info_ratelimited("%s for (%pI4, %d)->(%pI4, %d) %s" fmt "\n", \
+				msg, &ip_hdr(skb)->saddr, ntohs(th->source), \
+				&ip_hdr(skb)->daddr, ntohs(th->dest),	\
+				hdr_flags, ##__VA_ARGS__);		\
+	} else {							\
+		net_info_ratelimited("%s for [%pI6c]:%u->[%pI6c]:%u %s" fmt "\n", \
+				msg, &ipv6_hdr(skb)->saddr, ntohs(th->source), \
+				&ipv6_hdr(skb)->daddr, ntohs(th->dest),	\
+				hdr_flags, ##__VA_ARGS__);		\
+	}								\
+} while (0)
+
 #ifdef CONFIG_TCP_AO
 /* TCP-AO structures and functions */
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 95d872ae8d82..6d892fd2abe3 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4484,7 +4484,6 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	 * o MD5 hash and we're not expecting one.
 	 * o MD5 hash and its wrong.
 	 */
-	const struct tcphdr *th = tcp_hdr(skb);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_key *key;
 	int genhash;
@@ -4494,6 +4493,7 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 
 	if (!key && hash_location) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
+		tcp_hash_fail("Unexpected MD5 Hash found", family, skb, "");
 		return SKB_DROP_REASON_TCP_MD5UNEXPECTED;
 	}
 
@@ -4509,16 +4509,19 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
 		if (family == AF_INET) {
-			net_info_ratelimited("MD5 Hash failed for (%pI4, %d)->(%pI4, %d)%s L3 index %d\n",
-					saddr, ntohs(th->source),
-					daddr, ntohs(th->dest),
-					genhash ? " tcp_v4_calc_md5_hash failed"
-					: "", l3index);
+			tcp_hash_fail("MD5 Hash failed", AF_INET, skb, "%s L3 index %d",
+				      genhash ? "tcp_v4_calc_md5_hash failed"
+				      : "", l3index);
 		} else {
-			net_info_ratelimited("MD5 Hash %s for [%pI6c]:%u->[%pI6c]:%u L3 index %d\n",
-					genhash ? "failed" : "mismatch",
-					saddr, ntohs(th->source),
-					daddr, ntohs(th->dest), l3index);
+			if (genhash) {
+				tcp_hash_fail("MD5 Hash failed",
+					      AF_INET6, skb, "L3 index %d",
+					      l3index);
+			} else {
+				tcp_hash_fail("MD5 Hash mismatch",
+					      AF_INET6, skb, "L3 index %d",
+					      l3index);
+			}
 		}
 		return SKB_DROP_REASON_TCP_MD5FAILURE;
 	}
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 8fec1af5ebd7..8c74965b7575 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -671,6 +671,8 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOBAD);
 		atomic64_inc(&info->counters.pkt_bad);
 		atomic64_inc(&key->pkt_bad);
+		tcp_hash_fail("AO hash wrong length", family, skb,
+			      "%u != %d", maclen, tcp_ao_maclen(key));
 		return SKB_DROP_REASON_TCP_AOFAILURE;
 	}
 
@@ -681,6 +683,7 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOBAD);
 		atomic64_inc(&info->counters.pkt_bad);
 		atomic64_inc(&key->pkt_bad);
+		tcp_hash_fail("AO hash mismatch", family, skb, "");
 		return SKB_DROP_REASON_TCP_AOFAILURE;
 	}
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOGOOD);
@@ -706,6 +709,8 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 	info = rcu_dereference(tcp_sk(sk)->ao_info);
 	if (!info) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
+		tcp_hash_fail("AO key not found", family, skb,
+			      "keyid: %u", aoh->keyid);
 		return SKB_DROP_REASON_TCP_AOUNEXPECTED;
 	}
 
@@ -804,6 +809,8 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 key_not_found:
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
 	atomic64_inc(&info->counters.key_not_found);
+	tcp_hash_fail("Requested by the peer AO key id not found",
+		      family, skb, "");
 	return SKB_DROP_REASON_TCP_AOKEYNOTFOUND;
 }
 EXPORT_SYMBOL_GPL(tcp_inbound_ao_hash);
-- 
2.40.0

