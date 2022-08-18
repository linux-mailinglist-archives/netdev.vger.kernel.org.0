Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C8A598D51
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345733AbiHRUBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345639AbiHRUAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:00:40 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8606AD11D4;
        Thu, 18 Aug 2022 13:00:39 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id gb36so5150664ejc.10;
        Thu, 18 Aug 2022 13:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ALA3NgbJH24c7kXFgyLAAjdU36rH8Zjbi/84b6XrCIo=;
        b=H2Qbfehzi73jxoFVUDeu0cxg9MI6/SbH1eBQyX1S+JQyMJS/Q21IuPEErbLl00QiZw
         eklwW8Y4eoAA4oAKT+xz08pOqtTpPsBp+J848vO4X3TkOUA0P3zabjjGunW0ROi3InI9
         UnGNq5Yq+RANA+TsQ3UQqBYMZz0A0fa1DPNlsjS52eZj0Y8RO1Gg+BqvYjEQP9kK7RjS
         2U14L9J/iyGTyiKmeo+1NS1oBTNpQkI90T3yhKIxAReQYjKOgCe/rSp4ZuWmJZHYCEre
         2Q3Xrxn3xw7xjzmMxb5cih+Zxlar73Z91bKwdA8s9evmkh24090X9541Me10cm0ozqe7
         Y7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ALA3NgbJH24c7kXFgyLAAjdU36rH8Zjbi/84b6XrCIo=;
        b=tMGXWH4zRUbp3yXxUd/CwHtSbEUZB4CBtv5kWddaNM0UmSGg0iLDVYEIiS4oRKSQ+s
         anejwxArsAFEuYMOEjeQYzQS1DJ6iXt0FRy8zURWR95mKADSYAi9NZxVt0qWtf5Vzw2u
         xyHmM5u9KSxAge8KzLvjeGY7lPidJgPZ4Y4OtCTi7Q/3DMY6Txz2RSLKY5CznbtPF3ee
         qPCd6d/cOGrPc37vKcNWiRZBH18pBof6xrlV99M7qcEHw3lLgsOimxkP49vtfrboC/MI
         r74wZSLqarWJWpy6To+jB5edpi74DFL9kbDOkrPOuwLt7I+y6oRiDHZNrXCLhRxcS7qt
         pjSg==
X-Gm-Message-State: ACgBeo22TAw4IGZ6LVmTUOslpUNp42ySugLM+C80x3rKmqo01/GVd8nr
        BswJYrXkWELPY09inN1P7Ic=
X-Google-Smtp-Source: AA6agR41iMVxP+t2Wb+MtTV9H7NL2L69biZ446IdOquMzBBulxaY0L5XM/0bi0uxGe/GO7xVjz5S2g==
X-Received: by 2002:a17:907:7e9f:b0:730:d954:c2b5 with SMTP id qb31-20020a1709077e9f00b00730d954c2b5mr2693257ejc.311.1660852839133;
        Thu, 18 Aug 2022 13:00:39 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:38 -0700 (PDT)
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
Subject: [PATCH v7 12/26] tcp: ipv4: Add AO signing for skb-less replies
Date:   Thu, 18 Aug 2022 22:59:46 +0300
Message-Id: <9e034bbf242527335a139919bf6beb9da79af292.1660852705.git.cdleonard@gmail.com>
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

The code in tcp_v4_send_ack and tcp_v4_send_reset does not allocate a
full skb so special handling is required for tcp-authopt handling.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_authopt.c |  3 +-
 net/ipv4/tcp_ipv4.c    | 84 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 83 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 2af6265041b4..f7635a37b972 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -966,10 +966,11 @@ static int tcp_v4_authopt_get_traffic_key_noskb(struct tcp_authopt_key_info *key
 						u8 *traffic_key)
 {
 	int err;
 	struct tcp_authopt_alg_pool *pool;
 	struct tcp_v4_authopt_context_data data;
+	char traffic_key_context_header[7] = "\x01TCP-AO";
 
 	BUILD_BUG_ON(sizeof(data) != 22);
 
 	pool = tcp_authopt_get_kdf_pool(key);
 	if (IS_ERR(pool))
@@ -982,11 +983,11 @@ static int tcp_v4_authopt_get_traffic_key_noskb(struct tcp_authopt_key_info *key
 	if (err)
 		goto out;
 
 	// RFC5926 section 3.1.1.1
 	// Separate to keep alignment semi-sane
-	err = crypto_ahash_buf(pool->req, "\x01TCP-AO", 7);
+	err = crypto_ahash_buf(pool->req, traffic_key_context_header, 7);
 	if (err)
 		return err;
 	data.saddr = saddr;
 	data.daddr = daddr;
 	data.sport = sport;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 58b5f197bde1..acce593bb7c9 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -645,10 +645,50 @@ void tcp_v4_send_check(struct sock *sk, struct sk_buff *skb)
 
 	__tcp_v4_send_check(skb, inet->inet_saddr, inet->inet_daddr);
 }
 EXPORT_SYMBOL(tcp_v4_send_check);
 
+#ifdef CONFIG_TCP_AUTHOPT
+/** tcp_v4_authopt_handle_reply - Insert TCPOPT_AUTHOPT if required
+ *
+ * returns number of bytes (always aligned to 4) or zero
+ */
+static int tcp_v4_authopt_handle_reply(const struct sock *sk,
+				       struct sk_buff *skb,
+				       __be32 *optptr,
+				       struct tcphdr *th)
+{
+	struct tcp_authopt_info *info;
+	struct tcp_authopt_key_info *key_info;
+	u8 rnextkeyid;
+
+	if (sk->sk_state == TCP_TIME_WAIT)
+		info = tcp_twsk(sk)->tw_authopt_info;
+	else
+		info = rcu_dereference_check(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
+	if (!info)
+		return 0;
+	key_info = __tcp_authopt_select_key(sk, info, sk, &rnextkeyid);
+	if (!key_info)
+		return 0;
+	*optptr = htonl((TCPOPT_AUTHOPT << 24) |
+			(TCPOLEN_AUTHOPT_OUTPUT << 16) |
+			(key_info->send_id << 8) |
+			(rnextkeyid));
+	/* must update doff before signature computation */
+	th->doff += TCPOLEN_AUTHOPT_OUTPUT / 4;
+	tcp_v4_authopt_hash_reply((char *)(optptr + 1),
+				  info,
+				  key_info,
+				  ip_hdr(skb)->daddr,
+				  ip_hdr(skb)->saddr,
+				  th);
+
+	return TCPOLEN_AUTHOPT_OUTPUT;
+}
+#endif
+
 /*
  *	This routine will send an RST to the other tcp.
  *
  *	Someone asks: why I NEVER use socket parameters (TOS, TTL etc.)
  *		      for reset.
@@ -660,10 +700,12 @@ EXPORT_SYMBOL(tcp_v4_send_check);
  *	Exception: precedence violation. We do not implement it in any case.
  */
 
 #ifdef CONFIG_TCP_MD5SIG
 #define OPTION_BYTES TCPOLEN_MD5SIG_ALIGNED
+#elif defined(OPTION_BYTES_TCP_AUTHOPT)
+#define OPTION_BYTES TCPOLEN_AUTHOPT_OUTPUT
 #else
 #define OPTION_BYTES sizeof(__be32)
 #endif
 
 static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
@@ -713,12 +755,29 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	memset(&arg, 0, sizeof(arg));
 	arg.iov[0].iov_base = (unsigned char *)&rep;
 	arg.iov[0].iov_len  = sizeof(rep.th);
 
 	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT)
 	rcu_read_lock();
+#endif
+#ifdef CONFIG_TCP_AUTHOPT
+	/* Unlike TCP-MD5 the signatures for TCP-AO depend on initial sequence
+	 * numbers so we can only handle established and time-wait sockets.
+	 */
+	if (tcp_authopt_needed && sk &&
+	    sk->sk_state != TCP_NEW_SYN_RECV &&
+	    sk->sk_state != TCP_LISTEN) {
+		int tcp_authopt_ret = tcp_v4_authopt_handle_reply(sk, skb, rep.opt, &rep.th);
+
+		if (tcp_authopt_ret) {
+			arg.iov[0].iov_len += tcp_authopt_ret;
+			goto skip_md5sig;
+		}
+	}
+#endif
+#ifdef CONFIG_TCP_MD5SIG
 	hash_location = tcp_parse_md5sig_option(th);
 	if (sk && sk_fullsock(sk)) {
 		const union tcp_md5_addr *addr;
 		int l3index;
 
@@ -756,11 +815,10 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
 		key = tcp_md5_do_lookup(sk1, l3index, addr, AF_INET);
 		if (!key)
 			goto out;
 
-
 		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
 		if (genhash || memcmp(hash_location, newhash, 16) != 0)
 			goto out;
 
 	}
@@ -776,10 +834,13 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 
 		tcp_v4_md5_hash_hdr((__u8 *) &rep.opt[1],
 				     key, ip_hdr(skb)->saddr,
 				     ip_hdr(skb)->daddr, &rep.th);
 	}
+#endif
+#ifdef CONFIG_TCP_AUTHOPT
+skip_md5sig:
 #endif
 	/* Can't co-exist with TCPMD5, hence check rep.opt[0] */
 	if (rep.opt[0] == 0) {
 		__be32 mrst = mptcp_reset_option(skb);
 
@@ -833,12 +894,14 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
 	local_bh_enable();
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG)
 out:
+#endif
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT)
 	rcu_read_unlock();
 #endif
 }
 
 /* The code following below sending ACKs in SYN-RECV and TIME-WAIT states
@@ -855,10 +918,12 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	struct {
 		struct tcphdr th;
 		__be32 opt[(TCPOLEN_TSTAMP_ALIGNED >> 2)
 #ifdef CONFIG_TCP_MD5SIG
 			   + (TCPOLEN_MD5SIG_ALIGNED >> 2)
+#elif defined(CONFIG_TCP_AUTHOPT)
+			   + (TCPOLEN_AUTHOPT_OUTPUT >> 2)
 #endif
 			];
 	} rep;
 	struct net *net = sock_net(sk);
 	struct ip_reply_arg arg;
@@ -886,10 +951,23 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	rep.th.seq     = htonl(seq);
 	rep.th.ack_seq = htonl(ack);
 	rep.th.ack     = 1;
 	rep.th.window  = htons(win);
 
+#ifdef CONFIG_TCP_AUTHOPT
+	if (tcp_authopt_needed) {
+		int aoret, offset = (tsecr) ? 3 : 0;
+
+		aoret = tcp_v4_authopt_handle_reply(sk, skb, &rep.opt[offset], &rep.th);
+		if (aoret) {
+			arg.iov[0].iov_len += aoret;
+#ifdef CONFIG_TCP_MD5SIG
+			key = NULL;
+#endif
+		}
+	}
+#endif
 #ifdef CONFIG_TCP_MD5SIG
 	if (key) {
 		int offset = (tsecr) ? 3 : 0;
 
 		rep.opt[offset++] = htonl((TCPOPT_NOP << 24) |
-- 
2.25.1

