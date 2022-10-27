Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB6F61032F
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbiJ0Urg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbiJ0Uqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:46:49 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9A89411F
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:44:16 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id w14so4155121wru.8
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZzygEftNO9uBdJknMQ3dhxwVGxhJy8qR9pjIa567u0c=;
        b=JNp/w2XJApiAeK7vMWWUdv/UbmD0LTMBL6M3w9fA0WXnyA4Mm0lRgekv/8jYJ7p18y
         FvKDHoXPmWN+OVGkg//1cKy66LggGeimv6xdNszL0KxKsucAQKuHeJjLBGXUL3v9znd5
         RflDxQ9X55gcRckyft1/q9jIPHmT+ukquplV66tVgvD5uCFmxFM8AczKuwKHM0MWDZOK
         xw8oCc/2Nony+P0EX50yxoSic3Ocwt5Rj36w8V3lorICqgx3Id5GarxbtnyS4Q1V0oMm
         nhpuneU7l6C9juebD1jjKANYgVAGYT6KAlmQcUbGnEkoXfGo+hiP4FpXIbob044VZUbZ
         5+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZzygEftNO9uBdJknMQ3dhxwVGxhJy8qR9pjIa567u0c=;
        b=iB95utkEkMHSrQ/kimVFHxk157ity9yUGNLKI7+iRq31vkPPeuj7YRsF66tZOnUC4A
         wwIJPBYr2o8hQiunNDsdy2QGeDcjDxgV3nHHeconXSyrjz5MLQVCOQcYRF2c7gPS/gu9
         4eLKwmHm5f1rB+aUG6qHpsMbKqMVrB+hSlBtzALyDltiyeDEkibIEqXldGIGBmLquDCH
         lUWlEpDnaFSTi+TsY1iFy3L0+tpU0FGkjo4eF53KxBTQVk1RBnexHfRGnTAc8JwM297b
         OSkmYrfZhNoZqufplcmsWbmO13xLYc8n1QNEq6F+AQxGpdULI0kd13MDtoAHwNjOyLOO
         d2Kw==
X-Gm-Message-State: ACrzQf2Uwv5aAejqvXZPhYQ1PCTz4GQN+optgGI43FwZc5fehK090ItE
        bfY9iwjQL6lMsIaC4TLLKV0crA==
X-Google-Smtp-Source: AMsMyM48M1KauTSA3pgUBI4zJ/+sM//1uN+9fzykaMfEh2Fs0cBjL5jpdnCtCEKsDft3DVUxuq6R5Q==
X-Received: by 2002:a05:6000:184:b0:236:7685:7e6d with SMTP id p4-20020a056000018400b0023676857e6dmr13904166wrx.305.1666903456416;
        Thu, 27 Oct 2022 13:44:16 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:44:15 -0700 (PDT)
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
Subject: [PATCH v3 14/36] net/tcp: Add TCP-AO sign to twsk
Date:   Thu, 27 Oct 2022 21:43:25 +0100
Message-Id: <20221027204347.529913-15-dima@arista.com>
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
 net/ipv4/tcp_ao.c        | 47 ++++++++++++++++++++++----
 net/ipv4/tcp_ipv4.c      | 71 ++++++++++++++++++++++++++++++++++++----
 net/ipv4/tcp_minisocks.c |  4 ++-
 net/ipv6/tcp_ipv6.c      | 45 ++++++++++++++++++++++---
 6 files changed, 159 insertions(+), 22 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index fd248875b0a9..6630a8195ea6 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -497,6 +497,9 @@ struct tcp_timewait_sock {
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key	  *tw_md5_key;
 #endif
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info	  *ao_info;
+#endif
 };
 
 static inline struct tcp_timewait_sock *tcp_twsk(const struct sock *sk)
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index d359fbf89da8..9804881fd2bf 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -85,6 +85,7 @@ struct tcp_ao_info {
 	u32			snd_sne_seq;
 	u32			rcv_sne;
 	u32			rcv_sne_seq;
+	atomic_t		refcnt;		/* Protects twsk destruction */
 };
 
 #ifdef CONFIG_TCP_AO
@@ -117,8 +118,9 @@ int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
 struct tcp_ao_key *tcp_ao_do_lookup_sndid(const struct sock *sk, u8 keyid);
 int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 			    unsigned int len);
-void tcp_ao_destroy_sock(struct sock *sk);
+void tcp_ao_destroy_sock(struct sock *sk, bool twsk);
 u32 tcp_ao_compute_sne(u32 sne, u32 seq, u32 new_seq);
+void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp);
 int tcp_ao_cache_traffic_keys(const struct sock *sk, struct tcp_ao_info *ao,
 			      struct tcp_ao_key *ao_key);
 struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
@@ -169,7 +171,7 @@ static inline struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 	return NULL;
 }
 
-static inline void tcp_ao_destroy_sock(struct sock *sk)
+static inline void tcp_ao_destroy_sock(struct sock *sk, bool twsk)
 {
 }
 
@@ -177,6 +179,11 @@ static inline void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb)
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
index e20e3b435ce1..09d5cee7c6d7 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -75,8 +75,13 @@ struct tcp_ao_key *tcp_ao_do_lookup_sndid(const struct sock *sk, u8 keyid)
 	struct tcp_ao_key *key;
 	struct tcp_ao_info *ao;
 
-	ao = rcu_dereference_check(tcp_sk(sk)->ao_info,
-				   lockdep_sock_is_held(sk));
+	if (sk->sk_state == TCP_TIME_WAIT)
+		ao = rcu_dereference_check(tcp_twsk(sk)->ao_info,
+					   lockdep_sock_is_held(sk));
+	else
+		ao = rcu_dereference_check(tcp_sk(sk)->ao_info,
+					   lockdep_sock_is_held(sk));
+
 	if (!ao)
 		return NULL;
 
@@ -177,6 +182,7 @@ static struct tcp_ao_info *tcp_ao_alloc_info(gfp_t flags,
 	if (!ao)
 		return NULL;
 	INIT_HLIST_HEAD(&ao->head);
+	atomic_set(&ao->refcnt, 1);
 
 	if (cloned_from)
 		ao->ao_flags = cloned_from->ao_flags;
@@ -196,27 +202,54 @@ static void tcp_ao_key_free_rcu(struct rcu_head *head)
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
index b76933bb073e..fcf61b5bc581 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -823,7 +823,10 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 			struct tcp_ao_info *ao_info;
 			u8 keyid;
 
-			ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
+			if (sk->sk_state == TCP_TIME_WAIT)
+				ao_info = rcu_dereference(tcp_twsk(sk)->ao_info);
+			else
+				ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
 
 			/* XXX: optimize by using cached traffic key depending
 			 * on socket state
@@ -926,16 +929,16 @@ static void tcp_v4_send_ack(const struct sock *sk,
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
@@ -981,6 +984,25 @@ static void tcp_v4_send_ack(const struct sock *sk,
 				    ip_hdr(skb)->daddr, &rep.th);
 	}
 #endif
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
+#endif
+	/* XXX: TCP-AO: hash ACK header */
 	arg.flags = reply_flags;
 	arg.csum = csum_tcpudp_nofold(ip_hdr(skb)->daddr,
 				      ip_hdr(skb)->saddr, /* XXX */
@@ -1014,6 +1036,36 @@ static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
 {
 	struct inet_timewait_sock *tw = inet_twsk(sk);
 	struct tcp_timewait_sock *tcptw = tcp_twsk(sk);
+	struct tcp_ao_key *ao_key = NULL;
+	u8 *traffic_key = NULL;
+	u8 rcv_next = 0;
+	u32 ao_sne = 0;
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info *ao_info = NULL;
+	const struct tcp_ao_hdr *aoh;
+#endif
+
+#ifdef CONFIG_TCP_AO
+	if (tcp_parse_auth_options(tcp_hdr(skb), NULL, &aoh))
+		goto out; /* something is wrong with the sign */
+
+	/* FIXME: we haven't verified the segment to-be-acked */
+	if (aoh)
+		ao_key = tcp_ao_do_lookup_sndid(sk, aoh->rnext_keyid);
+
+	if (ao_key) {
+		traffic_key = snd_other_key(ao_key);
+		ao_info = rcu_dereference(tcptw->ao_info);
+		/* It's possible we can get rid of computing the sne
+		 * below since sne probably doesn't change once we are
+		 * in timewait state.
+		 */
+		ao_sne = tcp_ao_compute_sne(ao_info->snd_sne,
+					    ao_info->snd_sne_seq,
+					    tcptw->tw_snd_nxt);
+		rcv_next = ao_info->rnext_key->rcvid;
+	}
+#endif
 
 	tcp_v4_send_ack(sk, skb,
 			tcptw->tw_snd_nxt, tcptw->tw_rcv_nxt,
@@ -1022,10 +1074,14 @@ static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
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
 
@@ -1055,6 +1111,7 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			req->ts_recent,
 			0,
 			tcp_md5_do_lookup(sk, l3index, addr, AF_INET),
+			NULL, NULL, 0, 0,
 			inet_rsk(req)->no_srccheck ? IP_REPLY_ARG_NOSRCCHECK : 0,
 			ip_hdr(skb)->tos);
 }
@@ -2400,7 +2457,7 @@ void tcp_v4_destroy_sock(struct sock *sk)
 		rcu_assign_pointer(tp->md5sig_info, NULL);
 	}
 #endif
-	tcp_ao_destroy_sock(sk);
+	tcp_ao_destroy_sock(sk, false);
 
 	/* Clean up a referenced TCP bind bucket. */
 	if (inet_csk(sk)->icsk_bind_hash)
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index f7a75dce140b..87cf3073b6c2 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -246,7 +246,7 @@ EXPORT_SYMBOL(tcp_timewait_state_process);
 void tcp_time_wait(struct sock *sk, int state, int timeo)
 {
 	const struct inet_connection_sock *icsk = inet_csk(sk);
-	const struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
 	struct inet_timewait_sock *tw;
 
@@ -305,6 +305,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 			}
 		} while (0);
 #endif
+		tcp_ao_time_wait(tcptw, tp);
 
 		/* Get the TIME_WAIT timeout firing. */
 		if (timeo < rto)
@@ -359,6 +360,7 @@ void tcp_twsk_destructor(struct sock *sk)
 			call_rcu(&twsk->tw_md5_key->rcu, tcp_md5_twsk_free_rcu);
 	}
 #endif
+	tcp_ao_destroy_sock(sk, true);
 }
 EXPORT_SYMBOL_GPL(tcp_twsk_destructor);
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 23e0d4ffc007..7bd4d0bb77cd 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1126,7 +1126,10 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		ao_key = tcp_ao_do_lookup_sndid(sk, aoh->rnext_keyid);
 
 		if (ao_key) {
-			ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
+			if (sk->sk_state == TCP_TIME_WAIT)
+				ao_info = rcu_dereference(tcp_twsk(sk)->ao_info);
+			else
+				ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
 
 			/* XXX: optimize by using cached traffic key depending
 			 * on socket state
@@ -1178,24 +1181,56 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
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
+	const struct tcp_ao_hdr *aoh;
+
+	ao_info = rcu_dereference(tcptw->ao_info);
+	if (ao_info) {
+		/* Invalid TCP option size or twice included auth */
+		if (tcp_parse_auth_options(tcp_hdr(skb), NULL, &aoh))
+			goto out;
+		/* FIXME: we haven't verified the segment to-be-acked */
+		if (aoh)
+			ao_key = tcp_ao_do_lookup_sndid(sk, aoh->rnext_keyid);
+		if (ao_key) {
+			traffic_key = snd_other_key(ao_key);
+			/* rcv_next switches to our rcv_next */
+			rcv_next = ao_info->rnext_key->rcvid;
+			ao_sne = tcp_ao_compute_sne(ao_info->snd_sne,
+						    ao_info->snd_sne_seq,
+						    tcptw->tw_snd_nxt);
+		}
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
 
@@ -1222,7 +1257,7 @@ static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			req->ts_recent, sk->sk_bound_dev_if,
 			tcp_v6_md5_do_lookup(sk, &ipv6_hdr(skb)->saddr, l3index),
 			ipv6_get_dsfield(ipv6_hdr(skb)), 0, sk->sk_priority,
-			tcp_rsk(req)->txhash);
+			tcp_rsk(req)->txhash, NULL, NULL, 0, 0);
 }
 
 
-- 
2.38.1

