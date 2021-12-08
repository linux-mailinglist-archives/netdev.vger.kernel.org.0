Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E172146D278
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbhLHLnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbhLHLmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:42:13 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CA3C0698D0;
        Wed,  8 Dec 2021 03:38:13 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id g14so7310284edb.8;
        Wed, 08 Dec 2021 03:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MMLAmFX0zEOyfm3B5C4FVgHVXF9ulUP9xOResbDzMxs=;
        b=JcXIGu0jItBLL9jwJaqdd1BlVgVjDbviQe8fgGbOubMHo55L7Dmo98LsEb6WQUYlTq
         ni7EI3rVb4/6fIviXspLkZdgyqWmIzmfk4ho2hpLRNzoukc6B6TSd3dYtZ8YW5O+HFbO
         kTJ1Et+Vn2BO57p2CaIp707MJ/zMLWZlrB7Ju7ubF+QidN12CNucXIJ/JduNMcHXjeFh
         7p3XRroJL8T1tzp86dlhKcmhlUa/KmbiJSjENKuqN9SMCequ48A9WXqpLoM/L9sD23OS
         fd1J9MMdNKfNflMEwYPXy8KjgxpgqHEiMI06FltUillb4QqmuhgRUnogPiUw7o+Gwok/
         fkaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MMLAmFX0zEOyfm3B5C4FVgHVXF9ulUP9xOResbDzMxs=;
        b=sG11ulTdrLzuQvjuCTeL14qph+uwtYb3NT7pSLoOjcvk9gTKPc0fg1vX1EMfdOPZu0
         1WjJfC08rpnXwu14mRfMvWXbkyuSotcn9qlsFKFYRE/09hrspQyIEMtBksHzTzZXX/cn
         QA+kIFH8lVdLAvLLOLxyTV3WCJhZefHRyXInkqz3hn3ZySII1kbWg3wzA6tjg27Gf8f8
         WP9RFY8avmW2Z+tAqEdqb9PFdL82pF7BOIE8U5BEpjqxABDdpqlK8mTnrBDLlvjPbAoP
         TK9s+lwx5waufAjdAwWpCijVgylF797deOfgQaVPry5scNOz1Rgjt6Wk5BscgNZRFA6o
         mupg==
X-Gm-Message-State: AOAM532lIh+bRO7eiJ8vJGjLmbv35sU5/LcJpC2MXSRmpcnYfjIPuFs0
        kQzQdF93vE2UPPVhPSoBZUM=
X-Google-Smtp-Source: ABdhPJzStl2OBhC00FlAZ2tBb2qIsP9wGdHxEGtVs4kZETN43gyyWFYpyK+ZHXNBhqxXxEXLayGpJQ==
X-Received: by 2002:aa7:dd53:: with SMTP id o19mr17888137edw.369.1638963491360;
        Wed, 08 Dec 2021 03:38:11 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:3c9f:e05b:4dff:43ba])
        by smtp.gmail.com with ESMTPSA id g11sm1883810edz.53.2021.12.08.03.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:38:10 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/18] tcp: authopt: Implement Sequence Number Extension
Date:   Wed,  8 Dec 2021 13:37:23 +0200
Message-Id: <54fb10bbeb0b4b301c40eef215b18f041e141c0f.1638962992.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1638962992.git.cdleonard@gmail.com>
References: <cover.1638962992.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a compute_sne function which finds the value of SNE for a certain
SEQ given an already known "recent" SNE/SEQ. This is implemented using
the standard tcp before/after macro and will work for SEQ values that
are without 2^31 of the SEQ for which we know the SNE.

For updating we advance the value for rcv_sne at the same time as
rcv_nxt and for snd_sne at the same time as snd_nxt. We could track
other values (for example snd_una) but this is good enough and works
very easily for timewait socket.

This implementation is different from RFC suggestions and doesn't
require additional flags. It does pass tests from this draft:
    https://datatracker.ietf.org/doc/draft-touch-sne/

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h | 34 ++++++++++++++
 net/ipv4/tcp_authopt.c    | 98 ++++++++++++++++++++++++++++++++++++++-
 net/ipv4/tcp_input.c      |  1 +
 net/ipv4/tcp_output.c     |  1 +
 4 files changed, 132 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 4e872af7b180..d5d344d599f7 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -62,10 +62,14 @@ struct tcp_authopt_info {
 	u32 flags;
 	/** @src_isn: Local Initial Sequence Number */
 	u32 src_isn;
 	/** @dst_isn: Remote Initial Sequence Number */
 	u32 dst_isn;
+	/** @rcv_sne: Recv-side Sequence Number Extension tracking tcp_sock.rcv_nxt */
+	u32 rcv_sne;
+	/** @snd_sne: Send-side Sequence Number Extension tracking tcp_sock.snd_nxt */
+	u32 snd_sne;
 };
 
 /* TCP authopt as found in header */
 struct tcphdr_authopt {
 	u8 num;
@@ -180,10 +184,34 @@ static inline int tcp_authopt_inbound_check_req(struct request_sock *req, struct
 		if (info)
 			return __tcp_authopt_inbound_check((struct sock *)req, skb, info, opt);
 	}
 	return 0;
 }
+void __tcp_authopt_update_rcv_sne(struct tcp_sock *tp, struct tcp_authopt_info *info, u32 seq);
+static inline void tcp_authopt_update_rcv_sne(struct tcp_sock *tp, u32 seq)
+{
+	struct tcp_authopt_info *info;
+
+	if (tcp_authopt_needed) {
+		info = rcu_dereference_protected(tp->authopt_info,
+						 lockdep_sock_is_held((struct sock *)tp));
+		if (info)
+			__tcp_authopt_update_rcv_sne(tp, info, seq);
+	}
+}
+void __tcp_authopt_update_snd_sne(struct tcp_sock *tp, struct tcp_authopt_info *info, u32 seq);
+static inline void tcp_authopt_update_snd_sne(struct tcp_sock *tp, u32 seq)
+{
+	struct tcp_authopt_info *info;
+
+	if (tcp_authopt_needed) {
+		info = rcu_dereference_protected(tp->authopt_info,
+						 lockdep_sock_is_held((struct sock *)tp));
+		if (info)
+			__tcp_authopt_update_snd_sne(tp, info, seq);
+	}
+}
 #else
 static inline int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	return -ENOPROTOOPT;
 }
@@ -230,8 +258,14 @@ static inline int tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb
 static inline int tcp_authopt_inbound_check_req(struct request_sock *sk, struct sk_buff *skb,
 						const u8 *opt)
 {
 	return 0;
 }
+static inline void tcp_authopt_update_rcv_sne(struct tcp_sock *tp, u32 seq)
+{
+}
+static inline void tcp_authopt_update_snd_sne(struct tcp_sock *tp, u32 seq)
+{
+}
 #endif
 
 #endif /* _LINUX_TCP_AUTHOPT_H */
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 85de430d3326..05234923cb9f 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -631,10 +631,97 @@ static int tcp_authopt_get_isn(struct sock *sk,
 		*disn = htonl(info->dst_isn);
 	}
 	return 0;
 }
 
+/* compute_sne - Calculate Sequence Number Extension
+ *
+ * Give old upper/lower 32bit values and a new lower 32bit value determine the
+ * new value of the upper 32 bit. The new sequence number can be 2^31 before or
+ * after prev_seq but TCP window scaling should limit this further.
+ *
+ * For correct accounting the stored SNE value should be only updated together
+ * with the SEQ.
+ */
+static u32 compute_sne(u32 sne, u32 prev_seq, u32 seq)
+{
+	if (before(seq, prev_seq)) {
+		if (seq > prev_seq)
+			--sne;
+	} else {
+		if (seq < prev_seq)
+			++sne;
+	}
+
+	return sne;
+}
+
+/* Update rcv_sne, must be called immediately before rcv_nxt update */
+void __tcp_authopt_update_rcv_sne(struct tcp_sock *tp,
+				  struct tcp_authopt_info *info, u32 seq)
+{
+	info->rcv_sne = compute_sne(info->rcv_sne, tp->rcv_nxt, seq);
+}
+
+/* Update snd_sne, must be called immediately before snd_nxt update */
+void __tcp_authopt_update_snd_sne(struct tcp_sock *tp,
+				  struct tcp_authopt_info *info, u32 seq)
+{
+	info->snd_sne = compute_sne(info->snd_sne, tp->snd_nxt, seq);
+}
+
+/* Compute SNE for a specific packet (by seq). */
+static int compute_packet_sne(struct sock *sk, struct tcp_authopt_info *info,
+			      u32 seq, bool input, __be32 *sne)
+{
+	u32 rcv_nxt, snd_nxt;
+
+	// For TCP_NEW_SYN_RECV we have no tcp_authopt_info but tcp_request_sock holds ISN.
+	if (sk->sk_state == TCP_NEW_SYN_RECV) {
+		struct tcp_request_sock *rsk = tcp_rsk((struct request_sock *)sk);
+
+		if (input)
+			*sne = htonl(compute_sne(0, rsk->rcv_isn, seq));
+		else
+			*sne = htonl(compute_sne(0, rsk->snt_isn, seq));
+		return 0;
+	}
+
+	/* TCP_LISTEN only receives SYN */
+	if (sk->sk_state == TCP_LISTEN && input)
+		return 0;
+
+	/* TCP_SYN_SENT only sends SYN and receives SYN/ACK
+	 * For the input case rcv_nxt is initialized after the packet is
+	 * validated so tcp_sk(sk)->rcv_nxt is not initialized.
+	 */
+	if (sk->sk_state == TCP_SYN_SENT)
+		return 0;
+
+	if (sk->sk_state == TCP_TIME_WAIT) {
+		rcv_nxt = tcp_twsk(sk)->tw_rcv_nxt;
+		snd_nxt = tcp_twsk(sk)->tw_snd_nxt;
+	} else {
+		if (WARN_ONCE(!sk_fullsock(sk),
+			      "unexpected minisock sk=%p state=%d", sk,
+			      sk->sk_state))
+			return -EINVAL;
+		rcv_nxt = tcp_sk(sk)->rcv_nxt;
+		snd_nxt = tcp_sk(sk)->snd_nxt;
+	}
+
+	if (WARN_ONCE(!info, "unexpected missing info for sk=%p sk_state=%d", sk, sk->sk_state))
+		return -EINVAL;
+
+	if (input)
+		*sne = htonl(compute_sne(info->rcv_sne, rcv_nxt, seq));
+	else
+		*sne = htonl(compute_sne(info->snd_sne, snd_nxt, seq));
+
+	return 0;
+}
+
 /* Feed one buffer into ahash
  * The buffer is assumed to be DMA-able
  */
 static int crypto_ahash_buf(struct ahash_request *req, u8 *buf, uint len)
 {
@@ -686,10 +773,13 @@ int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct r
 	if (!new_info)
 		return -ENOMEM;
 
 	new_info->src_isn = tcp_rsk(req)->snt_isn;
 	new_info->dst_isn = tcp_rsk(req)->rcv_isn;
+	/* Caller is tcp_create_openreq_child and already initializes snd_nxt/rcv_nxt */
+	new_info->snd_sne = compute_sne(0, new_info->src_isn, tcp_sk(newsk)->snd_nxt);
+	new_info->rcv_sne = compute_sne(0, new_info->dst_isn, tcp_sk(newsk)->rcv_nxt);
 	INIT_HLIST_HEAD(&new_info->head);
 	err = tcp_authopt_clone_keys(newsk, oldsk, new_info, old_info);
 	if (err) {
 		tcp_authopt_free(newsk, new_info);
 		return err;
@@ -703,10 +793,12 @@ int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct r
 void __tcp_authopt_finish_connect(struct sock *sk, struct sk_buff *skb,
 				  struct tcp_authopt_info *info)
 {
 	info->src_isn = ntohl(tcp_hdr(skb)->ack_seq) - 1;
 	info->dst_isn = ntohl(tcp_hdr(skb)->seq);
+	info->snd_sne = compute_sne(0, info->src_isn, tcp_sk(sk)->snd_nxt);
+	info->rcv_sne = compute_sne(0, info->dst_isn, tcp_sk(sk)->rcv_nxt);
 }
 
 /* feed traffic key into ahash */
 static int tcp_authopt_ahash_traffic_key(struct tcp_authopt_alg_pool *pool,
 					 struct sock *sk,
@@ -952,14 +1044,16 @@ static int tcp_authopt_hash_packet(struct tcp_authopt_alg_pool *pool,
 				   bool ipv6,
 				   bool include_options,
 				   u8 *macbuf)
 {
 	struct tcphdr *th = tcp_hdr(skb);
+	__be32 sne = 0;
 	int err;
 
-	/* NOTE: SNE unimplemented */
-	__be32 sne = 0;
+	err = compute_packet_sne(sk, info, ntohl(th->seq), input, &sne);
+	if (err)
+		return err;
 
 	err = crypto_ahash_init(pool->req);
 	if (err)
 		return err;
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 4c9e403971fb..bc0a90c72391 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3517,10 +3517,11 @@ static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
 static void tcp_rcv_nxt_update(struct tcp_sock *tp, u32 seq)
 {
 	u32 delta = seq - tp->rcv_nxt;
 
 	sock_owned_by_me((struct sock *)tp);
+	tcp_authopt_update_rcv_sne(tp, seq);
 	tp->bytes_received += delta;
 	WRITE_ONCE(tp->rcv_nxt, seq);
 }
 
 /* Update our send window.
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index b959e8b949b6..6a6024a0b9e9 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -67,10 +67,11 @@ static void tcp_event_new_data_sent(struct sock *sk, struct sk_buff *skb)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int prior_packets = tp->packets_out;
 
+	tcp_authopt_update_snd_sne(tp, TCP_SKB_CB(skb)->end_seq);
 	WRITE_ONCE(tp->snd_nxt, TCP_SKB_CB(skb)->end_seq);
 
 	__skb_unlink(skb, &sk->sk_write_queue);
 	tcp_rbtree_insert(&sk->tcp_rtx_queue, skb);
 
-- 
2.25.1

