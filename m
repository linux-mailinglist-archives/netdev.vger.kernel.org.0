Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F82441E6E
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhKAQib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbhKAQiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:22 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3FBC061767;
        Mon,  1 Nov 2021 09:35:48 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id r12so66539768edt.6;
        Mon, 01 Nov 2021 09:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3hDRbdRghPPgrvzZsuV/srJDeiUgNbrFZsPckisRsbo=;
        b=RG+4DO2uUIWanaUBcHUmqKr768cqu9bku81cg5XkCiClsaM9baFjlcraceyxG3ZHd0
         LUsdskJ+5CjVesIddJUCVQm2X7ScHr2g5tSv91xohJmfC1xAPFzgff+Kd7I6v6TkewVX
         00Z0qZpqquBdJbUomxGCwGpEy0Su2hGQt0lxoYxT1r7xcD+DJOFDD+8bqci+PvVk05NI
         PLQHRYghUJEx85prUmzw5e/Bd61jUkkh2LVtrd8LQpQEoDOGlkb0RwIM3VpChbzscjfO
         myyDgFSDFvXEHXWTM66AKHzFgNo79NtQVebcDYRC7ZEPwQqPpacAEsdHDuYEHLeGpONh
         2LeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3hDRbdRghPPgrvzZsuV/srJDeiUgNbrFZsPckisRsbo=;
        b=i0ieaJvW+Pqvutnl/FruVidnzk/O60mbe1Ex635Q8WLQ7YPUC5J5FwQSF6n0YwXvry
         W1g3bB0NChNYY+MvpKBK/Upr8t9PuizgYbNFr+zHqdOUOvfgD14Ie07Rq8ccuYiatloF
         3zGtqyt+1u//DfJ5DsbPzR7GqQhTBLH23XH+dfnQTJHtlnUmjLcbQpF1Pu/5j74IM5pw
         H0pQvix/45FDsu4ZiIXXGO46PjI0PsWmOLZl0f4Q4XoNO5gR9m4lwwM7FZzkrq0+HQU6
         W46Y5qY5T9Uqqmrv314VI+mCFxTm8139mFmHAwIBi9RYlhDXTqFDcBUorornd/aHmmYs
         p9mg==
X-Gm-Message-State: AOAM531ajRpSMJLbIywjdWDOjllgUnjIU8GXPT2ozrqm70U6N7GgNwt7
        Rs2eSsjla+qWQ97ltYujOiY=
X-Google-Smtp-Source: ABdhPJzrZuWjYFJjtq9djgGYLCN5iG55Ld3fdoXjMx1Pq0Gb4YWwrud6jrkfwVfZQKy3Jxmt1Ju4bw==
X-Received: by 2002:a05:6402:270b:: with SMTP id y11mr43281572edd.116.1635784546954;
        Mon, 01 Nov 2021 09:35:46 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:35:46 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/25] tcp: authopt: Implement Sequence Number Extension
Date:   Mon,  1 Nov 2021 18:34:46 +0200
Message-Id: <6097ec24d87efc55962a1bfac9441132f0fc4206.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
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
 include/net/tcp_authopt.h | 36 ++++++++++++++++++
 net/ipv4/tcp_authopt.c    | 80 ++++++++++++++++++++++++++++++++++++++-
 net/ipv4/tcp_input.c      |  1 +
 net/ipv4/tcp_output.c     |  1 +
 4 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index a505db1dd67b..7360bda20f97 100644
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
 
 #ifdef CONFIG_TCP_AUTHOPT
 extern int sysctl_tcp_authopt;
 DECLARE_STATIC_KEY_FALSE(tcp_authopt_needed);
@@ -143,10 +147,36 @@ static inline int tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb
 			return __tcp_authopt_inbound_check(sk, skb, info);
 	}
 
 	return 0;
 }
+void __tcp_authopt_update_rcv_sne(struct tcp_sock *tp, struct tcp_authopt_info *info, u32 seq);
+static inline void tcp_authopt_update_rcv_sne(struct tcp_sock *tp, u32 seq)
+{
+	struct tcp_authopt_info *info;
+
+	if (static_branch_unlikely(&tcp_authopt_needed)) {
+		rcu_read_lock();
+		info = rcu_dereference(tp->authopt_info);
+		if (info)
+			__tcp_authopt_update_rcv_sne(tp, info, seq);
+		rcu_read_unlock();
+	}
+}
+void __tcp_authopt_update_snd_sne(struct tcp_sock *tp, struct tcp_authopt_info *info, u32 seq);
+static inline void tcp_authopt_update_snd_sne(struct tcp_sock *tp, u32 seq)
+{
+	struct tcp_authopt_info *info;
+
+	if (static_branch_unlikely(&tcp_authopt_needed)) {
+		rcu_read_lock();
+		info = rcu_dereference(tp->authopt_info);
+		if (info)
+			__tcp_authopt_update_snd_sne(tp, info, seq);
+		rcu_read_unlock();
+	}
+}
 #else
 static inline int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	return -ENOPROTOOPT;
 }
@@ -185,8 +215,14 @@ static inline void tcp_authopt_time_wait(
 }
 static inline int tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb)
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
index 7c49dcce7d24..a48b741c83e4 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -968,10 +968,84 @@ static int skb_shash_frags(struct shash_desc *desc,
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
+	// We can't use normal SNE computation before reaching TCP_ESTABLISHED
+	// For TCP_SYN_SENT the dst_isn field is initialized only after we
+	// validate the remote SYN/ACK
+	// For TCP_NEW_SYN_RECV there is no tcp_authopt_info at all
+	if (sk->sk_state == TCP_SYN_SENT ||
+	    sk->sk_state == TCP_NEW_SYN_RECV ||
+	    sk->sk_state == TCP_LISTEN)
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
 static int tcp_authopt_hash_packet(struct crypto_shash *tfm,
 				   struct sock *sk,
 				   struct sk_buff *skb,
 				   struct tcp_authopt_info *info,
 				   bool input,
@@ -979,14 +1053,16 @@ static int tcp_authopt_hash_packet(struct crypto_shash *tfm,
 				   bool include_options,
 				   u8 *macbuf)
 {
 	struct tcphdr *th = tcp_hdr(skb);
 	SHASH_DESC_ON_STACK(desc, tfm);
+	__be32 sne = 0;
 	int err;
 
-	/* NOTE: SNE unimplemented */
-	__be32 sne = 0;
+	err = compute_packet_sne(sk, info, ntohl(th->seq), input, &sne);
+	if (err)
+		return err;
 
 	desc->tfm = tfm;
 	err = crypto_shash_init(desc);
 	if (err)
 		return err;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 5dcde6e74bfc..0ac74e621b4e 100644
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
index 1e5acc5a38cf..ea53c24747b9 100644
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

