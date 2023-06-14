Return-Path: <netdev+bounces-10934-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9707A730B66
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:18:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF5AB28163B
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D12E1D2A2;
	Wed, 14 Jun 2023 23:11:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494CC1ACA2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:11:30 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDE42738
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:11:05 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f8d17639feso13245465e9.2
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1686784230; x=1689376230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CgOiH78bskMVpxiSYceQHWbm6QSKHLyJsHX97A7+Evo=;
        b=K1h3FXzOiUOZmWtQS+/4xZxjeVgqM33D3+qFBALVVGjT4hELVY9FikaiXjplokk3c5
         vDEil9C5mdou9skDTqA7oBmAjKyYZkb2WM1GpXXOG4KjbQga/sB2ToT0AtuS/riYIaH4
         +FbbxH6LfgtSzc0+RQR4PtSfieW4DMpEu2kAwxQzJljvNj2/tdyqw0f7K96Qch3Qrg/C
         jqYkRZjzC7l4aNCVQ4dcLpKJKKSatVQsbba3vY+m571viIChj2188WOtITNcp/oVx+gU
         pm+iijpjIWy65tacsOVpzHwqY+azrm8Rng/BVQkyccTY+c+7Xb8ojh8pSoU/H6X7/vBc
         i9uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686784230; x=1689376230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CgOiH78bskMVpxiSYceQHWbm6QSKHLyJsHX97A7+Evo=;
        b=ko83TcG/iASpzrfme4WwRWU8YSAyRAlyRGBqBVE02DXiG1mX3ntFaIKkQQ6riFxqDK
         Mn7qalDqCQbDJoulWBdZciG7BBt1rWQNovdm4AzA/NdmR+51AtU5h5YxerH2IZuIcqa1
         +pgvOvRvfkH9Gp8ywhBrYIwwpuPCFB7sZqiYazYlJxRvSDHw8Y8nrUgesQcNMOCvb/54
         KBEgQtccSAU2JxUUCBTnmgmDjeWMoJMFalcCjlPPj5zGOKtMsZtHxR646JsKI0P4kwZO
         73PBacB6oqHsjkcPH3copg3jBar07H8uLskEML7nigD7WkuHbkHWfoMoVXQYXGJW/paD
         +ffw==
X-Gm-Message-State: AC+VfDzJVicqa/8iJi0/X4HpfRwmaov09of7d9FGTxNr48stI0uzeIdF
	hm/8cvkegbR1tcUyAcDCnhMBqA==
X-Google-Smtp-Source: ACHHUZ5LGyWIj30Shu0FeCUdlT9N6SVPAkWK7y01vdpWp0RlA7t4OwX0qlMD/RYr15WE+UjAsPn1GQ==
X-Received: by 2002:a05:600c:21c7:b0:3f5:ce4:6c3f with SMTP id x7-20020a05600c21c700b003f50ce46c3fmr13296014wmj.7.1686784230055;
        Wed, 14 Jun 2023 16:10:30 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s12-20020a7bc38c000000b003f7ba52eeccsm18725261wmj.7.2023.06.14.16.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 16:10:29 -0700 (PDT)
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
Subject: [PATCH v7 22/22] net/tcp: Add TCP_AO_REPAIR
Date: Thu, 15 Jun 2023 00:09:47 +0100
Message-Id: <20230614230947.3954084-23-dima@arista.com>
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

Add TCP_AO_REPAIR setsockopt(), getsockopt(). They let a user to repair
TCP-AO ISNs/SNEs. Also let the user hack around when (tp->repair) is on
and add ao_info on a socket in any supported state.
As SNEs now can be read/written at any moment, use
WRITE_ONCE()/READ_ONCE() to set/read them.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp_ao.h     |  14 ++++++
 include/uapi/linux/tcp.h |  10 ++++
 net/ipv4/tcp.c           |  24 +++++++---
 net/ipv4/tcp_ao.c        | 100 ++++++++++++++++++++++++++++++++++++---
 net/ipv4/tcp_input.c     |  12 ++---
 net/ipv4/tcp_ipv4.c      |   4 +-
 net/ipv4/tcp_output.c    |   3 +-
 net/ipv6/tcp_ipv6.c      |   4 +-
 8 files changed, 147 insertions(+), 24 deletions(-)

diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 3449d093143e..54eec4859b35 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -182,6 +182,8 @@ void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp);
 bool tcp_ao_ignore_icmp(struct sock *sk, int type, int code);
 int tcp_ao_get_mkts(struct sock *sk, sockptr_t optval, sockptr_t optlen);
 int tcp_ao_get_sock_info(struct sock *sk, sockptr_t optval, sockptr_t optlen);
+int tcp_ao_get_repair(struct sock *sk, sockptr_t optval, sockptr_t optlen);
+int tcp_ao_set_repair(struct sock *sk, sockptr_t optval, unsigned int optlen);
 enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
 			const struct sk_buff *skb, unsigned short int family,
 			const struct request_sock *req, int l3index,
@@ -303,6 +305,18 @@ static inline int tcp_ao_get_sock_info(struct sock *sk, sockptr_t optval, sockpt
 {
 	return -ENOPROTOOPT;
 }
+
+static inline int tcp_ao_get_repair(struct sock *sk,
+				    sockptr_t optval, sockptr_t optlen)
+{
+	return -ENOPROTOOPT;
+}
+
+static inline int tcp_ao_set_repair(struct sock *sk,
+				    sockptr_t optval, unsigned int optlen)
+{
+	return -ENOPROTOOPT;
+}
 #endif
 
 #if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 979ff960fddb..a0dd4612a37c 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -133,6 +133,7 @@ enum {
 #define TCP_AO_DEL_KEY		39	/* Delete MKT */
 #define TCP_AO_INFO		40	/* Set/list TCP-AO per-socket options */
 #define TCP_AO_GET_KEYS		41	/* List MKT(s) */
+#define TCP_AO_REPAIR		42	/* Get/Set SNEs and ISNs */
 
 #define TCP_REPAIR_ON		1
 #define TCP_REPAIR_OFF		0
@@ -445,6 +446,15 @@ struct tcp_ao_getsockopt { /* getsockopt(TCP_AO_GET_KEYS) */
 	__u64	pkt_bad;		/* out: segments that failed verification */
 } __attribute__((aligned(8)));
 
+struct tcp_ao_repair { /* {s,g}etsockopt(TCP_AO_REPAIR) */
+	__be32			snt_isn;
+	__be32			rcv_isn;
+	__u32			snd_sne;
+	__u32			snd_sne_seq;
+	__u32			rcv_sne;
+	__u32			rcv_sne_seq;
+} __attribute__((aligned(8)));
+
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c4143b67a67b..b814a3ce9e69 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3714,20 +3714,28 @@ int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		__tcp_sock_set_quickack(sk, val);
 		break;
 
+	case TCP_AO_REPAIR:
+		err = tcp_ao_set_repair(sk, optval, optlen);
+		break;
 #ifdef CONFIG_TCP_AO
 	case TCP_AO_ADD_KEY:
 	case TCP_AO_DEL_KEY:
 	case TCP_AO_INFO: {
 		/* If this is the first TCP-AO setsockopt() on the socket,
-		 * sk_state has to be LISTEN or CLOSE
+		 * sk_state has to be LISTEN or CLOSE. Allow TCP_REPAIR
+		 * in any state.
 		 */
-		if (((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE)) ||
-		    rcu_dereference_protected(tcp_sk(sk)->ao_info,
+		if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
+			goto ao_parse;
+		if (rcu_dereference_protected(tcp_sk(sk)->ao_info,
 					      lockdep_sock_is_held(sk)))
-			err = tp->af_specific->ao_parse(sk, optname, optval,
-							optlen);
-		else
-			err = -EISCONN;
+			goto ao_parse;
+		if (tp->repair)
+			goto ao_parse;
+		err = -EISCONN;
+		break;
+ao_parse:
+		err = tp->af_specific->ao_parse(sk, optname, optval, optlen);
 		break;
 	}
 #endif
@@ -4394,6 +4402,8 @@ int do_tcp_getsockopt(struct sock *sk, int level,
 		return err;
 	}
 #endif
+	case TCP_AO_REPAIR:
+		return tcp_ao_get_repair(sk, optval, optlen);
 	case TCP_AO_GET_KEYS:
 	case TCP_AO_INFO: {
 		int err;
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index d8a02cf0ba3c..6fe745e0b04c 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1061,8 +1061,8 @@ void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb)
 
 	ao->risn = tcp_hdr(skb)->seq;
 
-	ao->rcv_sne = 0;
-	ao->rcv_sne_seq = ntohl(tcp_hdr(skb)->seq);
+	WRITE_ONCE(ao->rcv_sne, 0);
+	WRITE_ONCE(ao->rcv_sne_seq, ntohl(tcp_hdr(skb)->seq));
 
 	hlist_for_each_entry_rcu(key, &ao->head, node) {
 		tcp_ao_cache_traffic_keys(sk, ao, key);
@@ -1452,6 +1452,16 @@ static struct tcp_ao_info *setsockopt_ao_info(struct sock *sk)
 	return ERR_PTR(-ESOCKTNOSUPPORT);
 }
 
+static struct tcp_ao_info *getsockopt_ao_info(struct sock *sk)
+{
+	if (sk_fullsock(sk))
+		return rcu_dereference(tcp_sk(sk)->ao_info);
+	else if (sk->sk_state == TCP_TIME_WAIT)
+		return rcu_dereference(tcp_twsk(sk)->ao_info);
+
+	return ERR_PTR(-ESOCKTNOSUPPORT);
+}
+
 #define TCP_AO_KEYF_ALL (TCP_AO_KEYF_IFINDEX | TCP_AO_KEYF_EXCLUDE_OPT)
 #define TCP_AO_GET_KEYF_VALID	(TCP_AO_KEYF_IFINDEX)
 
@@ -1586,11 +1596,13 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 	if (ret < 0)
 		goto err_free_sock;
 
-	/* Change this condition if we allow adding keys in states
-	 * like close_wait, syn_sent or fin_wait...
-	 */
-	if (sk->sk_state == TCP_ESTABLISHED)
+	if (!((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))) {
 		tcp_ao_cache_traffic_keys(sk, ao_info, key);
+		if (first) {
+			ao_info->current_key = key;
+			ao_info->rnext_key = key;
+		}
+	}
 
 	tcp_ao_link_mkt(ao_info, key);
 	if (first) {
@@ -1837,6 +1849,8 @@ static int tcp_ao_info_cmd(struct sock *sk, unsigned short int family,
 	if (IS_ERR(ao_info))
 		return PTR_ERR(ao_info);
 	if (!ao_info) {
+		if (!((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE)))
+			return -EINVAL;
 		ao_info = tcp_ao_alloc_info(GFP_KERNEL);
 		if (!ao_info)
 			return -ENOMEM;
@@ -2219,3 +2233,77 @@ int tcp_ao_get_sock_info(struct sock *sk, sockptr_t optval, sockptr_t optlen)
 	return 0;
 }
 
+int tcp_ao_set_repair(struct sock *sk, sockptr_t optval, unsigned int optlen)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_ao_repair cmd;
+	struct tcp_ao_key *key;
+	struct tcp_ao_info *ao;
+	int err;
+
+	if (optlen < sizeof(cmd))
+		return -EINVAL;
+
+	err = copy_struct_from_sockptr(&cmd, sizeof(cmd), optval, optlen);
+	if (err)
+		return err;
+
+	if (!tp->repair)
+		return -EPERM;
+
+	ao = setsockopt_ao_info(sk);
+	if (IS_ERR(ao))
+		return PTR_ERR(ao);
+	if (!ao)
+		return -ENOENT;
+
+	WRITE_ONCE(ao->lisn, cmd.snt_isn);
+	WRITE_ONCE(ao->risn, cmd.rcv_isn);
+	WRITE_ONCE(ao->snd_sne, cmd.snd_sne);
+	WRITE_ONCE(ao->snd_sne_seq, cmd.snd_sne_seq);
+	WRITE_ONCE(ao->rcv_sne, cmd.rcv_sne);
+	WRITE_ONCE(ao->rcv_sne_seq, cmd.rcv_sne_seq);
+
+	hlist_for_each_entry_rcu(key, &ao->head, node)
+		tcp_ao_cache_traffic_keys(sk, ao, key);
+
+	return 0;
+}
+
+int tcp_ao_get_repair(struct sock *sk, sockptr_t optval, sockptr_t optlen)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_ao_repair opt;
+	struct tcp_ao_info *ao;
+	int len;
+
+	if (copy_from_sockptr(&len, optlen, sizeof(int)))
+		return -EFAULT;
+
+	if (len <= 0)
+		return -EINVAL;
+
+	if (!tp->repair)
+		return -EPERM;
+
+	rcu_read_lock();
+	ao = getsockopt_ao_info(sk);
+	if (IS_ERR(ao))
+		return PTR_ERR(ao);
+	if (!ao) {
+		rcu_read_unlock();
+		return -ENOENT;
+	}
+
+	opt.snt_isn	= ao->lisn;
+	opt.rcv_isn	= ao->risn;
+	opt.snd_sne	= READ_ONCE(ao->snd_sne);
+	opt.snd_sne_seq	= READ_ONCE(ao->snd_sne_seq);
+	opt.rcv_sne	= READ_ONCE(ao->rcv_sne);
+	opt.rcv_sne_seq	= READ_ONCE(ao->rcv_sne_seq);
+	rcu_read_unlock();
+
+	if (copy_to_sockptr(optval, &opt, len))
+		return -EFAULT;
+	return 0;
+}
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c0c18b05fd1c..1bd47cb8fb9a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3536,8 +3536,8 @@ static void tcp_snd_sne_update(struct tcp_sock *tp, u32 ack)
 				       lockdep_sock_is_held((struct sock *)tp));
 	if (ao) {
 		if (ack < ao->snd_sne_seq)
-			ao->snd_sne++;
-		ao->snd_sne_seq = ack;
+			WRITE_ONCE(ao->snd_sne, ao->snd_sne + 1);
+		WRITE_ONCE(ao->snd_sne_seq, ack);
 	}
 #endif
 }
@@ -3565,8 +3565,8 @@ static void tcp_rcv_sne_update(struct tcp_sock *tp, u32 seq)
 				       lockdep_sock_is_held((struct sock *)tp));
 	if (ao) {
 		if (seq < ao->rcv_sne_seq)
-			ao->rcv_sne++;
-		ao->rcv_sne_seq = seq;
+			WRITE_ONCE(ao->rcv_sne, ao->rcv_sne + 1);
+		WRITE_ONCE(ao->rcv_sne_seq, seq);
 	}
 #endif
 }
@@ -6416,8 +6416,8 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 					       lockdep_sock_is_held(sk));
 		if (ao) {
 			ao->risn = th->seq;
-			ao->rcv_sne = 0;
-			ao->rcv_sne_seq = ntohl(th->seq);
+			WRITE_ONCE(ao->rcv_sne, 0);
+			WRITE_ONCE(ao->rcv_sne_seq, ntohl(th->seq));
 		}
 #endif
 		tcp_set_state(sk, TCP_SYN_RECV);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 211d0edd6eea..229317e38a5e 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1040,8 +1040,8 @@ static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
 		 * below since sne probably doesn't change once we are
 		 * in timewait state.
 		 */
-		ao_sne = tcp_ao_compute_sne(ao_info->snd_sne,
-					    ao_info->snd_sne_seq,
+		ao_sne = tcp_ao_compute_sne(READ_ONCE(ao_info->snd_sne),
+					    READ_ONCE(ao_info->snd_sne_seq),
 					    tcptw->tw_snd_nxt);
 		rnext_key = READ_ONCE(ao_info->rnext_key);
 		rcv_next = rnext_key->rcvid;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f055ef225c37..e68ae7b896b7 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1455,7 +1455,8 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		} else {
 			traffic_key = snd_other_key(ao_key);
 		}
-		sne = tcp_ao_compute_sne(ao->snd_sne, ao->snd_sne_seq,
+		sne = tcp_ao_compute_sne(READ_ONCE(ao->snd_sne),
+					 READ_ONCE(ao->snd_sne_seq),
 					 ntohl(th->seq));
 		tp->af_specific->calc_ao_hash(opts.hash_location, ao_key, sk, skb,
 					      traffic_key,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 6b39da6c477e..ba9d4571b265 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1190,8 +1190,8 @@ static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
 		/* rcv_next switches to our rcv_next */
 		rnext_key = READ_ONCE(ao_info->rnext_key);
 		rcv_next = rnext_key->rcvid;
-		ao_sne = tcp_ao_compute_sne(ao_info->snd_sne,
-					    ao_info->snd_sne_seq,
+		ao_sne = tcp_ao_compute_sne(READ_ONCE(ao_info->snd_sne),
+					    READ_ONCE(ao_info->snd_sne_seq),
 					    tcptw->tw_snd_nxt);
 	}
 #endif
-- 
2.40.0


