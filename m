Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51876598D03
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345686AbiHRUAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345565AbiHRUAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:00:37 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC07D11DC;
        Thu, 18 Aug 2022 13:00:34 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id gb36so5150162ejc.10;
        Thu, 18 Aug 2022 13:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=WMRoj96bvg/NFH6ySg85AsREnkPlKZFCn/kF8BQCmXQ=;
        b=TIGMPF/5yqTgMjHxArH+PJTifBNF/jA/wzP/8ww3XVkjPVK8XJvM6ttpPXVb2yjoKc
         F0nh/dMphm5VUj7feVsYve6xumB4b2uRCQY4ou9g5OeUoRbdMjtjo9e1cpne+ld42wxg
         lmmpg974wyzvM4CuhEmuNPrUrCE2eS32PsY/JIJklhmmDIfsDgTCuU0I83v+3uLzRxEq
         seAyMaBkZzMTJVu+NN+NWZzuuD+HW4zJ+NxW3dq9Mmer0Fkx/Y6LpD6HsQrDYo1Anfs0
         +GmrGQ1n628rMzXVlzGn/m+sWjIP3cnCdggrfhk4bZxVfwLu5V3902UUMJ2VaVCNFxND
         lEhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=WMRoj96bvg/NFH6ySg85AsREnkPlKZFCn/kF8BQCmXQ=;
        b=NUU5WrlEBSTYvsd+np+kbVAvdioK1KcCJr1SmOsLqK8AZRGc4fBngT4ELSCxQpqS0p
         Kdk9gb90hYJfiuHZxhzMVmI7PzUH5hLhyUSunhNfA84swd4a0oDZp5Y8h85NUuDt4MDO
         7EdDcnpplwHVZ8WWOMqgkrgc/xxyc85irOAIeQQW0LGD2lGNxggGNCeVMVJsuhS6dClA
         qrie9KBujaXT5oGpjur/ACuITfWfxZbzxApSneUNq36dOeMxFBEYICQA/r8z/uGCmtSP
         AMarqXJ5PrEqC/uJzUkNgZ1UUWAICHCccTB5vGI4J30Omuy7UCqxHRokiDrp377OX2zK
         yP/Q==
X-Gm-Message-State: ACgBeo0XBKPQho3a4noZ27mny1kBg/DnT4NABre16lRVcy0N/9KMbaCi
        rfNx/nifSgL6XD6F+xl8eBY=
X-Google-Smtp-Source: AA6agR5O2sVgg1/SEhhJQ+SdFGjeT5Ogemku/sbQUsxuo0lqn0gQpfcQHVR6+rY6Vr6h7lzFA0Tf/Q==
X-Received: by 2002:a17:907:60c7:b0:731:17e4:7fcc with SMTP id hv7-20020a17090760c700b0073117e47fccmr2762229ejc.73.1660852833426;
        Thu, 18 Aug 2022 13:00:33 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:33 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 09/26] tcp: authopt: Implement Sequence Number Extension
Date:   Thu, 18 Aug 2022 22:59:43 +0300
Message-Id: <fc63215c23bd650175557ab9ad172110b94bf6d4.1660852705.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660852705.git.cdleonard@gmail.com>
References: <cover.1660852705.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 1f5020b790dd..1fa1b968c80c 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -66,10 +66,14 @@ struct tcp_authopt_info {
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
@@ -156,10 +160,34 @@ static inline void tcp_authopt_time_wait(
 int __tcp_authopt_inbound_check(
 		struct sock *sk,
 		struct sk_buff *skb,
 		struct tcp_authopt_info *info,
 		const u8 *opt);
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
 static inline void tcp_authopt_clear(struct sock *sk)
 {
 }
 static inline int tcp_authopt_openreq(struct sock *newsk,
@@ -174,8 +202,14 @@ static inline void tcp_authopt_finish_connect(struct sock *sk, struct sk_buff *s
 static inline void tcp_authopt_time_wait(
 		struct tcp_timewait_sock *tcptw,
 		struct tcp_sock *tp)
 {
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
index c470fce52f78..e64b97db927e 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -660,10 +660,97 @@ static int tcp_authopt_get_isn(struct sock *sk,
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
@@ -695,10 +782,13 @@ int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct r
 	if (!new_info)
 		return -ENOMEM;
 
 	new_info->src_isn = tcp_rsk(req)->snt_isn;
 	new_info->dst_isn = tcp_rsk(req)->rcv_isn;
+	/* Caller is tcp_create_openreq_child and already initializes snd_nxt/rcv_nxt */
+	new_info->snd_sne = compute_sne(0, new_info->src_isn, tcp_sk(newsk)->snd_nxt);
+	new_info->rcv_sne = compute_sne(0, new_info->dst_isn, tcp_sk(newsk)->rcv_nxt);
 	sk_gso_disable(newsk);
 	rcu_assign_pointer(tcp_sk(newsk)->authopt_info, new_info);
 
 	return 0;
 }
@@ -706,10 +796,12 @@ int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct r
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
@@ -963,14 +1055,16 @@ static int tcp_authopt_hash_packet(struct tcp_authopt_alg_pool *pool,
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
index b0c883521b1a..d901e27801d1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3527,10 +3527,11 @@ static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
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
index ae69936947f3..74c3ef86f0bc 100644
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

