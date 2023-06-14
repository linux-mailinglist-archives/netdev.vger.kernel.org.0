Return-Path: <netdev+bounces-10921-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3890730B49
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:14:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78C70281573
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7818E154BE;
	Wed, 14 Jun 2023 23:10:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C18182AF
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:10:19 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25A82717
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:10:11 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f8d17639feso13243445e9.2
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1686784210; x=1689376210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ncDYxUu4X3Sr8RmB+EuUNZDkcMBwcfy/LBXCi+9YGSg=;
        b=NLolUOCrMWU6hwyghXYOvdHhY9P4WpypVuQELeUNNa4KnbJsWcgTh3sdEfeV3n5l+W
         234BoQkQe55MK8KwUoUcEgDVBVHx7+w1/DLm8uhS8mv3mugOe3fpFK2cCHQ+Y7Ra/LIo
         /cS5lLqMLuICndwSt1a8j4jAsdGRf6cg8qv610g+A67JpHKxKn3vgrcd7l3hGXI9/QLV
         9NWrcM9lzEYglDEqtI8bm8McTYPv8/DyeFOYFZ1WID6aOUGv/fTKXk3LMPWeYMGbUiNr
         I/P6rib4IMm7/DGqxmk0zUFG+x9oqNYbDCrTnGRllJU7Pg02lOS3qIvRXciGY+u/ncnt
         tmOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686784210; x=1689376210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ncDYxUu4X3Sr8RmB+EuUNZDkcMBwcfy/LBXCi+9YGSg=;
        b=JpHTwezTJypCSsOroXxXX8C6Q8Pk0PpVoPpioaXeN59GXeFSQ5Iyt3o8hnjD2NXhhb
         FSOpq7p9JgCQ6YT0rLYgD/AB/1IaVko1gpQMGc/pQUgUEu1NqiX+1uXN2hFvzjX0O1Ql
         1NNbgXqlvoSpzSsFRmFK5/bGndLV1vQOwlvjMxv73JWemeym/oNi1OLMZr4egdhJAgpF
         FLCVgCRklEovvl1RbmgOsGJ+f/5xlfRldQqzT1rKqdwmo4/rGDa8DLCSefyqoYzywZJq
         8eAW6Ot71efMOS6Q6BEBojPIc/ZhN48PuQYULielZzEWMzFy2Spfgdl2gH6+GyfpydDF
         aMjw==
X-Gm-Message-State: AC+VfDw4coxkJtKfgeX4MafThjgcZSjtBeW9+Ac2pKGfTrT0+xAdfGJ3
	/7/lJjpimEcycu2BZNyTp/RBcQ==
X-Google-Smtp-Source: ACHHUZ49CPKf9SCSy5AKsKax28Xw6/IrE0Wj6Z8bodXhGdLwIlr0w9lEZ1WaZ2s5l5afzjMNRWdZNw==
X-Received: by 2002:a05:600c:2041:b0:3f8:d0e7:daed with SMTP id p1-20020a05600c204100b003f8d0e7daedmr4626384wmg.19.1686784209725;
        Wed, 14 Jun 2023 16:10:09 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s12-20020a7bc38c000000b003f7ba52eeccsm18725261wmj.7.2023.06.14.16.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 16:10:09 -0700 (PDT)
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
Subject: [PATCH v7 09/22] net/tcp: Add TCP-AO sign to twsk
Date: Thu, 15 Jun 2023 00:09:34 +0100
Message-Id: <20230614230947.3954084-10-dima@arista.com>
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
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for sockets in time-wait state.
ao_info as well as all keys are inherited on transition to time-wait
socket. The lifetime of ao_info is now protected by ref counter, so
that tcp_ao_destroy_sock() will destruct it only when the last user is
gone.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/tcp.h      |  3 ++
 include/net/tcp_ao.h     | 11 +++++--
 net/ipv4/tcp_ao.c        | 46 ++++++++++++++++++++++-----
 net/ipv4/tcp_ipv4.c      | 68 ++++++++++++++++++++++++++++++++++++----
 net/ipv4/tcp_minisocks.c |  4 ++-
 net/ipv4/tcp_output.c    |  2 +-
 net/ipv6/tcp_ipv6.c      | 44 +++++++++++++++++++++++---
 7 files changed, 157 insertions(+), 21 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 673b32e47c30..0c50a9aaa780 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -500,6 +500,9 @@ struct tcp_timewait_sock {
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key	  *tw_md5_key;
 #endif
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info	  *ao_info;
+#endif
 };
 
 static inline struct tcp_timewait_sock *tcp_twsk(const struct sock *sk)
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 010c77c4456e..c518452af09a 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -91,6 +91,7 @@ struct tcp_ao_info {
 	u32			snd_sne_seq;
 	u32			rcv_sne;
 	u32			rcv_sne_seq;
+	atomic_t		refcnt;		/* Protects twsk destruction */
 	struct rcu_head		rcu;
 };
 
@@ -125,8 +126,9 @@ struct tcp_ao_key *tcp_ao_established_key(struct tcp_ao_info *ao,
 					  int sndid, int rcvid);
 int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 			    unsigned int len);
-void tcp_ao_destroy_sock(struct sock *sk);
+void tcp_ao_destroy_sock(struct sock *sk, bool twsk);
 u32 tcp_ao_compute_sne(u32 sne, u32 seq, u32 new_seq);
+void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp);
 struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 				    const union tcp_ao_addr *addr,
 				    int family, int sndid, int rcvid, u16 port);
@@ -180,7 +182,7 @@ static inline struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 	return NULL;
 }
 
-static inline void tcp_ao_destroy_sock(struct sock *sk)
+static inline void tcp_ao_destroy_sock(struct sock *sk, bool twsk)
 {
 }
 
@@ -188,6 +190,11 @@ static inline void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb)
 {
 }
 
+static inline void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw,
+				    struct tcp_sock *tp)
+{
+}
+
 static inline void tcp_ao_connect_init(struct sock *sk)
 {
 }
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index a45ab30265bf..9a3bb06e1046 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -171,6 +171,7 @@ static struct tcp_ao_info *tcp_ao_alloc_info(gfp_t flags)
 	if (!ao)
 		return NULL;
 	INIT_HLIST_HEAD(&ao->head);
+	atomic_set(&ao->refcnt, 1);
 
 	return ao;
 }
@@ -188,27 +189,54 @@ static void tcp_ao_key_free_rcu(struct rcu_head *head)
 	kfree(key);
 }
 
-void tcp_ao_destroy_sock(struct sock *sk)
+void tcp_ao_destroy_sock(struct sock *sk, bool twsk)
 {
 	struct tcp_ao_info *ao;
 	struct tcp_ao_key *key;
 	struct hlist_node *n;
 
-	ao = rcu_dereference_protected(tcp_sk(sk)->ao_info, 1);
-	tcp_sk(sk)->ao_info = NULL;
+	if (twsk) {
+		ao = rcu_dereference_protected(tcp_twsk(sk)->ao_info, 1);
+		tcp_twsk(sk)->ao_info = NULL;
+	} else {
+		ao = rcu_dereference_protected(tcp_sk(sk)->ao_info, 1);
+		tcp_sk(sk)->ao_info = NULL;
+	}
 
-	if (!ao)
+	if (!ao || !atomic_dec_and_test(&ao->refcnt))
 		return;
 
 	hlist_for_each_entry_safe(key, n, &ao->head, node) {
 		hlist_del_rcu(&key->node);
-		atomic_sub(tcp_ao_sizeof_key(key), &sk->sk_omem_alloc);
+		if (!twsk)
+			atomic_sub(tcp_ao_sizeof_key(key), &sk->sk_omem_alloc);
 		call_rcu(&key->rcu, tcp_ao_key_free_rcu);
 	}
 
 	kfree_rcu(ao, rcu);
 }
 
+void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp)
+{
+	struct tcp_ao_info *ao_info = rcu_dereference_protected(tp->ao_info, 1);
+
+	if (ao_info) {
+		struct tcp_ao_key *key;
+		struct hlist_node *n;
+		int omem = 0;
+
+		hlist_for_each_entry_safe(key, n, &ao_info->head, node) {
+			omem += tcp_ao_sizeof_key(key);
+		}
+
+		atomic_inc(&ao_info->refcnt);
+		atomic_sub(omem, &(((struct sock *)tp)->sk_omem_alloc));
+		rcu_assign_pointer(tcptw->ao_info, ao_info);
+	} else {
+		tcptw->ao_info = NULL;
+	}
+}
+
 /* 4 tuple and ISNs are expected in NBO */
 static int tcp_v4_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
 			      __be32 saddr, __be32 daddr,
@@ -529,8 +557,9 @@ int tcp_ao_prepare_reset(const struct sock *sk, struct sk_buff *skb,
 		struct tcp_ao_key *rnext_key;
 
 		if (sk->sk_state == TCP_TIME_WAIT)
-			return -1;
-		ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
+			ao_info = rcu_dereference(tcp_twsk(sk)->ao_info);
+		else
+			ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
 		if (!ao_info)
 			return -ENOENT;
 
@@ -914,6 +943,9 @@ static struct tcp_ao_info *setsockopt_ao_info(struct sock *sk)
 	if (sk_fullsock(sk)) {
 		return rcu_dereference_protected(tcp_sk(sk)->ao_info,
 						 lockdep_sock_is_held(sk));
+	} else if (sk->sk_state == TCP_TIME_WAIT) {
+		return rcu_dereference_protected(tcp_twsk(sk)->ao_info,
+						 lockdep_sock_is_held(sk));
 	}
 	return ERR_PTR(-ESOCKTNOSUPPORT);
 }
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 9638bab8ed92..0d310d0613b5 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -904,16 +904,16 @@ static void tcp_v4_send_ack(const struct sock *sk,
 			    struct sk_buff *skb, u32 seq, u32 ack,
 			    u32 win, u32 tsval, u32 tsecr, int oif,
 			    struct tcp_md5sig_key *key,
+			    struct tcp_ao_key *ao_key,
+			    u8 *traffic_key,
+			    u8 rcv_next,
+			    u32 ao_sne,
 			    int reply_flags, u8 tos)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
 	struct {
 		struct tcphdr th;
-		__be32 opt[(TCPOLEN_TSTAMP_ALIGNED >> 2)
-#ifdef CONFIG_TCP_MD5SIG
-			   + (TCPOLEN_MD5SIG_ALIGNED >> 2)
-#endif
-			];
+		__be32 opt[(MAX_TCP_OPTION_SPACE  >> 2)];
 	} rep;
 	struct net *net = sock_net(sk);
 	struct ip_reply_arg arg;
@@ -958,6 +958,24 @@ static void tcp_v4_send_ack(const struct sock *sk,
 				    key, ip_hdr(skb)->saddr,
 				    ip_hdr(skb)->daddr, &rep.th);
 	}
+#endif
+#ifdef CONFIG_TCP_AO
+	if (ao_key) {
+		int offset = (tsecr) ? 3 : 0;
+
+		rep.opt[offset++] = htonl((TCPOPT_AO << 24) |
+					  (tcp_ao_len(ao_key) << 16) |
+					  (ao_key->sndid << 8) | rcv_next);
+		arg.iov[0].iov_len += round_up(tcp_ao_len(ao_key), 4);
+		rep.th.doff = arg.iov[0].iov_len / 4;
+
+		tcp_ao_hash_hdr(AF_INET, (char *)&rep.opt[offset],
+				ao_key, traffic_key,
+				(union tcp_ao_addr *)&ip_hdr(skb)->saddr,
+				(union tcp_ao_addr *)&ip_hdr(skb)->daddr,
+				&rep.th, ao_sne);
+	}
+	WARN_ON_ONCE(key && ao_key);
 #endif
 	arg.flags = reply_flags;
 	arg.csum = csum_tcpudp_nofold(ip_hdr(skb)->daddr,
@@ -991,6 +1009,39 @@ static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
 {
 	struct inet_timewait_sock *tw = inet_twsk(sk);
 	struct tcp_timewait_sock *tcptw = tcp_twsk(sk);
+	struct tcp_ao_key *ao_key = NULL;
+	u8 *traffic_key = NULL;
+	u8 rcv_next = 0;
+	u32 ao_sne = 0;
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info *ao_info;
+
+	/* FIXME: the segment to-be-acked is not verified yet */
+	ao_info = rcu_dereference(tcptw->ao_info);
+	if (ao_info) {
+		const struct tcp_ao_hdr *aoh;
+
+		if (tcp_parse_auth_options(tcp_hdr(skb), NULL, &aoh))
+			goto out; /* something is wrong with the sign */
+
+		if (aoh)
+			ao_key = tcp_ao_established_key(ao_info, aoh->rnext_keyid, -1);
+	}
+	if (ao_key) {
+		struct tcp_ao_key *rnext_key;
+
+		traffic_key = snd_other_key(ao_key);
+		/* It's possible we can get rid of computing the sne
+		 * below since sne probably doesn't change once we are
+		 * in timewait state.
+		 */
+		ao_sne = tcp_ao_compute_sne(ao_info->snd_sne,
+					    ao_info->snd_sne_seq,
+					    tcptw->tw_snd_nxt);
+		rnext_key = READ_ONCE(ao_info->rnext_key);
+		rcv_next = rnext_key->rcvid;
+	}
+#endif
 
 	tcp_v4_send_ack(sk, skb,
 			tcptw->tw_snd_nxt, tcptw->tw_rcv_nxt,
@@ -999,10 +1050,14 @@ static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
 			tcptw->tw_ts_recent,
 			tw->tw_bound_dev_if,
 			tcp_twsk_md5_key(tcptw),
+			ao_key, traffic_key, rcv_next, ao_sne,
 			tw->tw_transparent ? IP_REPLY_ARG_NOSRCCHECK : 0,
 			tw->tw_tos
 			);
 
+#ifdef CONFIG_TCP_AO
+out:
+#endif
 	inet_twsk_put(tw);
 }
 
@@ -1032,6 +1087,7 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			req->ts_recent,
 			0,
 			tcp_md5_do_lookup(sk, l3index, addr, AF_INET),
+			NULL, NULL, 0, 0,
 			inet_rsk(req)->no_srccheck ? IP_REPLY_ARG_NOSRCCHECK : 0,
 			ip_hdr(skb)->tos);
 }
@@ -2392,7 +2448,7 @@ void tcp_v4_destroy_sock(struct sock *sk)
 		rcu_assign_pointer(tp->md5sig_info, NULL);
 	}
 #endif
-	tcp_ao_destroy_sock(sk);
+	tcp_ao_destroy_sock(sk, false);
 
 	/* Clean up a referenced TCP bind bucket. */
 	if (inet_csk(sk)->icsk_bind_hash)
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 63b5c5f42a87..ea6e5c97c66a 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -279,7 +279,7 @@ static void tcp_time_wait_init(struct sock *sk, struct tcp_timewait_sock *tcptw)
 void tcp_time_wait(struct sock *sk, int state, int timeo)
 {
 	const struct inet_connection_sock *icsk = inet_csk(sk);
-	const struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
 	struct inet_timewait_sock *tw;
 
@@ -316,6 +316,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 #endif
 
 		tcp_time_wait_init(sk, tcptw);
+		tcp_ao_time_wait(tcptw, tp);
 
 		/* Get the TIME_WAIT timeout firing. */
 		if (timeo < rto)
@@ -370,6 +371,7 @@ void tcp_twsk_destructor(struct sock *sk)
 			call_rcu(&twsk->tw_md5_key->rcu, tcp_md5_twsk_free_rcu);
 	}
 #endif
+	tcp_ao_destroy_sock(sk, true);
 }
 EXPORT_SYMBOL_GPL(tcp_twsk_destructor);
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index d4c7ca5d5cf1..c08dae53b03b 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3968,7 +3968,7 @@ int tcp_connect(struct sock *sk)
 		 * then free up ao_info if allocated.
 		 */
 		if (needs_md5) {
-			tcp_ao_destroy_sock(sk);
+			tcp_ao_destroy_sock(sk, false);
 		} else if (needs_ao) {
 			tcp_clear_md5_list(sk);
 			kfree(rcu_replace_pointer(tp->md5sig_info, NULL,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 282603cb009c..5bf1ba48ca68 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1140,24 +1140,60 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 static void tcp_v6_send_ack(const struct sock *sk, struct sk_buff *skb, u32 seq,
 			    u32 ack, u32 win, u32 tsval, u32 tsecr, int oif,
 			    struct tcp_md5sig_key *key, u8 tclass,
-			    __be32 label, u32 priority, u32 txhash)
+			    __be32 label, u32 priority, u32 txhash,
+			    struct tcp_ao_key *ao_key, char *tkey,
+			    u8 rcv_next, u32 ao_sne)
 {
 	tcp_v6_send_response(sk, skb, seq, ack, win, tsval, tsecr, oif, key, 0,
-			     tclass, label, priority, txhash, NULL, NULL, 0, 0);
+			     tclass, label, priority, txhash,
+			     ao_key, tkey, rcv_next, ao_sne);
 }
 
 static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
 {
 	struct inet_timewait_sock *tw = inet_twsk(sk);
 	struct tcp_timewait_sock *tcptw = tcp_twsk(sk);
+	struct tcp_ao_key *ao_key = NULL;
+	u8 *traffic_key = NULL;
+	u8 rcv_next = 0;
+	u32 ao_sne = 0;
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info *ao_info;
+
+	/* FIXME: the segment to-be-acked is not verified yet */
+	ao_info = rcu_dereference(tcptw->ao_info);
+	if (ao_info) {
+		const struct tcp_ao_hdr *aoh;
+
+		/* Invalid TCP option size or twice included auth */
+		if (tcp_parse_auth_options(tcp_hdr(skb), NULL, &aoh))
+			goto out;
+		if (aoh)
+			ao_key = tcp_ao_established_key(ao_info, aoh->rnext_keyid, -1);
+	}
+	if (ao_key) {
+		struct tcp_ao_key *rnext_key;
+
+		traffic_key = snd_other_key(ao_key);
+		/* rcv_next switches to our rcv_next */
+		rnext_key = READ_ONCE(ao_info->rnext_key);
+		rcv_next = rnext_key->rcvid;
+		ao_sne = tcp_ao_compute_sne(ao_info->snd_sne,
+					    ao_info->snd_sne_seq,
+					    tcptw->tw_snd_nxt);
+	}
+#endif
 
 	tcp_v6_send_ack(sk, skb, tcptw->tw_snd_nxt, tcptw->tw_rcv_nxt,
 			tcptw->tw_rcv_wnd >> tw->tw_rcv_wscale,
 			tcp_time_stamp_raw() + tcptw->tw_ts_offset,
 			tcptw->tw_ts_recent, tw->tw_bound_dev_if, tcp_twsk_md5_key(tcptw),
 			tw->tw_tclass, cpu_to_be32(tw->tw_flowlabel), tw->tw_priority,
-			tw->tw_txhash);
+			tw->tw_txhash, ao_key, traffic_key, rcv_next, ao_sne);
 
+#ifdef CONFIG_TCP_AO
+out:
+#endif
 	inet_twsk_put(tw);
 }
 
@@ -1184,7 +1220,7 @@ static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			req->ts_recent, sk->sk_bound_dev_if,
 			tcp_v6_md5_do_lookup(sk, &ipv6_hdr(skb)->saddr, l3index),
 			ipv6_get_dsfield(ipv6_hdr(skb)), 0, sk->sk_priority,
-			tcp_rsk(req)->txhash);
+			tcp_rsk(req)->txhash, NULL, NULL, 0, 0);
 }
 
 
-- 
2.40.0


