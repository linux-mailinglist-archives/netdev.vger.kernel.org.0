Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5D6698387
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjBOSgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjBOSee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:34:34 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD2A3D92D
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:34:11 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id r18so14004250wmq.5
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x17E+eium4VyrfGc7M1myMUnIQM/HJYLttYEMQIU4XY=;
        b=drIBnfo8BmIYETYhR0pcax10wLOPxJ+wXDgHFy8Qm0ZQytfDYvylUeXrkqM2KMI29H
         uSrVZcpyJWe9h41LHuh5zJO3szcXDLqa/rLvcrVKcHFLzdgL8C1UYcAw6xapvCpBbwbX
         nFlzHxjxm+6+d7jlPTYKVtucoeINgm60UXJmKLxv6dnRpewaK+6d5oMTjtJnYx6jv+V1
         Wm4CoUzAuzBLV0e0QIQ+R9sKPXpK5N9QahMBZaDdNXFfqXqwmPmM1cMBjCNvA4OSjSUz
         JEWMMTnPzwgUrBPkNvqpCoecl2XxUBYSbfrzuIJ3+Oy9+2D3yj9wYRT09QlblsuGVvf6
         QVyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x17E+eium4VyrfGc7M1myMUnIQM/HJYLttYEMQIU4XY=;
        b=jtWS+yVZZOzkPMxkb7TdSABlGdg1+mKZfq5xjEECnAo+SvMiLD5UYDTfKhKfHuHcCq
         ZpON6x57V1I2sWf/1pN21kT65b4jfcWfK2r065+cDLGBaHt1TdNy5EdV1WSo8E8sUQr6
         HQdyn/95AFikfGo01D3HVPuGZFvlVTODmk9TxSICJBZaKec35lOSZnR95IqNinIkaNDy
         LIucitLUQWZLaDPMcSK6OWSb44p9FyXYz/dCAjCBZzNrtFDAzXRdgHOP18veeA7kyt5V
         xoLYZGLL7H3UbEDGCHQQ6s+McvbLqCjsJDD5RmgKzOFgZUEFIVITxu5UsWRWp3xKROIw
         w/3A==
X-Gm-Message-State: AO0yUKXp28DMo1M4c9rfbKig7BejXfWmigXXKqyyIwh8/zCE77Gbti1k
        j0flnQzoI6ekv2NMsyuRzylyTA==
X-Google-Smtp-Source: AK7set9o3pNND0YfqQtKqdaBS6DMHAI5qmU2BXmTeF8UsrS4Cz6utn7sdLFB2UpNmOlesyNqccJv7w==
X-Received: by 2002:a05:600c:310b:b0:3df:f7ba:14e1 with SMTP id g11-20020a05600c310b00b003dff7ba14e1mr2944594wmo.8.1676486051002;
        Wed, 15 Feb 2023 10:34:11 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s9-20020a05600c45c900b003e00c9888besm3196306wmo.30.2023.02.15.10.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 10:34:10 -0800 (PST)
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
        Dan Carpenter <dan.carpenter@oracle.com>,
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
Subject: [PATCH v4 15/21] net/tcp: Add tcp_hash_fail() ratelimited logs
Date:   Wed, 15 Feb 2023 18:33:29 +0000
Message-Id: <20230215183335.800122-16-dima@arista.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215183335.800122-1-dima@arista.com>
References: <20230215183335.800122-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 include/net/tcp.h    | 14 ++++++++++++--
 include/net/tcp_ao.h | 27 +++++++++++++++++++++++++++
 net/ipv4/tcp.c       | 23 +++++++++++++----------
 net/ipv4/tcp_ao.c    |  7 +++++++
 4 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index ff1680611530..7b1d8b05e3bc 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2579,12 +2579,19 @@ tcp_inbound_hash(struct sock *sk, const struct request_sock *req,
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
+					family, skb, " %s",
+					!aoh ? "missing AO" : "AO signed");
 			return SKB_DROP_REASON_TCP_AOFAILURE;
+		}
 	}
 
 	/* sdif set, means packet ingressed via a device
@@ -2607,11 +2614,14 @@ tcp_inbound_hash(struct sock *sk, const struct request_sock *req,
 					lockdep_sock_is_held(sk));
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOREQUIRED);
 			atomic64_inc(&ao_info->counters.ao_required);
+			tcp_hash_fail("AO hash is required, but not found",
+					family, skb, "");
 			return SKB_DROP_REASON_TCP_AONOTFOUND;
 		}
 #endif
 		if (unlikely(tcp_md5_do_lookup(sk, l3index, saddr, family))) {
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
+			tcp_hash_fail("MD5 Hash not found", family, skb, "");
 			return SKB_DROP_REASON_TCP_MD5NOTFOUND;
 		}
 		return SKB_NOT_DROPPED_YET;
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 07d05bb49e46..d953105f5f73 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -98,6 +98,33 @@ struct tcp_ao_info {
 	atomic_t		refcnt;		/* Protects twsk destruction */
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
+		*f = 'A';						\
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
index 3a2caa5eeee2..d59e7422a481 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4525,7 +4525,6 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	 * o MD5 hash and we're not expecting one.
 	 * o MD5 hash and its wrong.
 	 */
-	const struct tcphdr *th = tcp_hdr(skb);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_key *key;
 	int genhash;
@@ -4535,6 +4534,7 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 
 	if (!key && hash_location) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
+		tcp_hash_fail("Unexpected MD5 Hash found", family, skb, "");
 		return SKB_DROP_REASON_TCP_MD5UNEXPECTED;
 	}
 
@@ -4550,16 +4550,19 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
 		if (family == AF_INET) {
-			net_info_ratelimited("MD5 Hash failed for (%pI4, %d)->(%pI4, %d)%s L3 index %d\n",
-					saddr, ntohs(th->source),
-					daddr, ntohs(th->dest),
-					genhash ? " tcp_v4_calc_md5_hash failed"
-					: "", l3index);
+			tcp_hash_fail("MD5 Hash failed", AF_INET, skb, "%s L3 index %d",
+				      genhash ? " tcp_v4_calc_md5_hash failed"
+				      : "", l3index);
 		} else {
-			net_info_ratelimited("MD5 Hash %s for [%pI6c]:%u->[%pI6c]:%u L3 index %d\n",
-					genhash ? "failed" : "mismatch",
-					saddr, ntohs(th->source),
-					daddr, ntohs(th->dest), l3index);
+			if (genhash) {
+				tcp_hash_fail("MD5 Hash failed",
+					      AF_INET6, skb, " L3 index %d",
+					      l3index);
+			} else {
+				tcp_hash_fail("MD5 Hash mismatch",
+					      AF_INET6, skb, " L3 index %d",
+					      l3index);
+			}
 		}
 		return SKB_DROP_REASON_TCP_MD5FAILURE;
 	}
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index d34ff3682cf8..6f650ebe01c4 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -693,6 +693,8 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOBAD);
 		atomic64_inc(&info->counters.pkt_bad);
 		atomic64_inc(&key->pkt_bad);
+		tcp_hash_fail("AO hash wrong length", family, skb,
+			      " %u != %d", maclen, tcp_ao_maclen(key));
 		return SKB_DROP_REASON_TCP_AOFAILURE;
 	}
 
@@ -703,6 +705,7 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOBAD);
 		atomic64_inc(&info->counters.pkt_bad);
 		atomic64_inc(&key->pkt_bad);
+		tcp_hash_fail("AO hash mismatch", family, skb, "");
 		return SKB_DROP_REASON_TCP_AOFAILURE;
 	}
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOGOOD);
@@ -728,6 +731,8 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 	info = rcu_dereference(tcp_sk(sk)->ao_info);
 	if (!info) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
+		tcp_hash_fail("AO key not found", family, skb,
+			      " keyid: %u", aoh->keyid);
 		return SKB_DROP_REASON_TCP_AOUNEXPECTED;
 	}
 
@@ -824,6 +829,8 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 key_not_found:
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
 	atomic64_inc(&info->counters.key_not_found);
+	tcp_hash_fail("Requested by the peer AO key id not found",
+		      family, skb, "");
 	return SKB_DROP_REASON_TCP_AOKEYNOTFOUND;
 }
 
-- 
2.39.1

