Return-Path: <netdev+bounces-2274-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 174BA700FB5
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 22:26:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2534281D96
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 20:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A53200D6;
	Fri, 12 May 2023 20:23:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C713F200DF
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 20:23:35 +0000 (UTC)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EE340DD
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:23:33 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-3078c092056so5211930f8f.1
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1683923012; x=1686515012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f6z0xmO4zq2oqQFzEdP5GI7EgIOIcsMykxB51L1W6Ys=;
        b=feFfjkebv3hB6coequmtvyNwYg9Hs98TdvNIqYBDoDE5Ira+nMdOZmzuewDxmnl808
         u8aYp0ZuQ8GpdVRR+8iubmAG+J058fqbpQxAVk2MeRwOFqnujFQ5+J4+QWaJC5nPInKE
         53HidK7ORhOKdI81fCQg0bIfr+QPwa3PM+lIy8bCW2gQwCeEjmCkyURdpFttMgPPdjMY
         6JMHjeKhIfUIpC58Y1a/672FQ8otq5FEB0piO9Ri5FG8VhJr5v9/SiGrnR4H7ZkJmoGY
         LEI2QvKCYYbYcB/YFc07RkHRlO6lHOATpdIQNmWUc5tYW6oPJhTSALOKSJU8Ah5jLXGG
         0b6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683923012; x=1686515012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f6z0xmO4zq2oqQFzEdP5GI7EgIOIcsMykxB51L1W6Ys=;
        b=WPuwZEE5FEhewlwLqp+3/8fZmzcB0AqNC740f/pAyG+ls4l7n4l4sMt4mU244W7E4s
         /jbw3cS+4Q3bomTuHMruLi5tsVORSlzDzDAwPZGPsciP+vNoD1cma+L4M82lkw0hv5Li
         RNnwrS+OVadeaM8mTqbEiA7f1i8lMzb1Qm1CQ6ket3NP9tRp1DrxhbnDcaag9XKYlP2X
         lZWB7knlJLoHADL4ix39iJziFBA6NzhIGt6A6AojvMuNh1ozsbZFtYvB+jM+tOWSaAvy
         0PFu+dvP1pjdxs9VRQOJSlESSDPyUckAyq3a5lvSXH+yNfj7bDiOzA0u1FF3ggEhW6n8
         7BHg==
X-Gm-Message-State: AC+VfDzErt2eBFItLTMdiWALh7b248FQV6bBtFBtqXEVIoG521fwjLva
	QCMz5zu2L84qr8W9noUjvNwKRg==
X-Google-Smtp-Source: ACHHUZ48E2GsY+oY4HPg57DasIskU1DAoHryfmTidKuMSGZyXBFLO0lBKb6VcrllNIHTF1PQIrSJ/Q==
X-Received: by 2002:adf:de03:0:b0:2f5:7ce1:781d with SMTP id b3-20020adfde03000000b002f57ce1781dmr16832689wrm.50.1683923011726;
        Fri, 12 May 2023 13:23:31 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n9-20020a05600c294900b003f423508c6bsm17304527wmd.44.2023.05.12.13.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 13:23:31 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: linux-kernel@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <dima@arista.com>,
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
	netdev@vger.kernel.org
Subject: [PATCH v6 09/21] net/tcp: Add TCP-AO sign to twsk
Date: Fri, 12 May 2023 21:22:59 +0100
Message-Id: <20230512202311.2845526-10-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230512202311.2845526-1-dima@arista.com>
References: <20230512202311.2845526-1-dima@arista.com>
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
 include/net/tcp_ao.h     | 11 ++++--
 net/ipv4/tcp_ao.c        | 38 ++++++++++++++++++---
 net/ipv4/tcp_ipv4.c      | 74 +++++++++++++++++++++++++++++++++++-----
 net/ipv4/tcp_minisocks.c |  4 ++-
 net/ipv4/tcp_output.c    |  2 +-
 net/ipv6/tcp_ipv6.c      | 49 +++++++++++++++++++++++---
 7 files changed, 159 insertions(+), 22 deletions(-)

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
index 5b85ecd7024a..a8632f258890 100644
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
@@ -176,7 +178,7 @@ static inline struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 	return NULL;
 }
 
-static inline void tcp_ao_destroy_sock(struct sock *sk)
+static inline void tcp_ao_destroy_sock(struct sock *sk, bool twsk)
 {
 }
 
@@ -184,6 +186,11 @@ static inline void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb)
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
index 61f26e9c3fc0..741d12eb46d5 100644
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
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 1e30161c7a09..7b82e5ee4073 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -814,8 +814,10 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		if (sk->sk_state == TCP_NEW_SYN_RECV)
 			goto skip_ao_sign;
 
-		ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
-
+		if (sk->sk_state == TCP_TIME_WAIT)
+			ao_info = rcu_dereference(tcp_twsk(sk)->ao_info);
+		else
+			ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
 		if (!ao_info)
 			goto skip_ao_sign;
 
@@ -924,16 +926,16 @@ static void tcp_v4_send_ack(const struct sock *sk,
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
@@ -978,6 +980,24 @@ static void tcp_v4_send_ack(const struct sock *sk,
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
@@ -1012,6 +1032,39 @@ static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
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
@@ -1020,10 +1073,14 @@ static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
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
 
@@ -1053,6 +1110,7 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			req->ts_recent,
 			0,
 			tcp_md5_do_lookup(sk, l3index, addr, AF_INET),
+			NULL, NULL, 0, 0,
 			inet_rsk(req)->no_srccheck ? IP_REPLY_ARG_NOSRCCHECK : 0,
 			ip_hdr(skb)->tos);
 }
@@ -2413,7 +2471,7 @@ void tcp_v4_destroy_sock(struct sock *sk)
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
index 99ce31ef13b8..3e77a0c0cc39 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1118,7 +1118,10 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		if (sk->sk_state == TCP_NEW_SYN_RECV)
 			goto skip_ao_sign;
 
-		ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
+		if (sk->sk_state == TCP_TIME_WAIT)
+			ao_info = rcu_dereference(tcp_twsk(sk)->ao_info);
+		else
+			ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
 		if (!ao_info)
 			goto skip_ao_sign;
 
@@ -1177,24 +1180,60 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
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
 
@@ -1221,7 +1260,7 @@ static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			req->ts_recent, sk->sk_bound_dev_if,
 			tcp_v6_md5_do_lookup(sk, &ipv6_hdr(skb)->saddr, l3index),
 			ipv6_get_dsfield(ipv6_hdr(skb)), 0, sk->sk_priority,
-			tcp_rsk(req)->txhash);
+			tcp_rsk(req)->txhash, NULL, NULL, 0, 0);
 }
 
 
-- 
2.40.0


