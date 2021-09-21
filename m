Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E78413723
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234436AbhIUQS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234408AbhIUQSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:18:13 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262CEC061757;
        Tue, 21 Sep 2021 09:16:45 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id u27so4130877edi.9;
        Tue, 21 Sep 2021 09:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WgCl/8N1xU0ogg40eA7oe0JV/xgw+jVwPRhb8bXB9rI=;
        b=QdHOZqy7jL7ykg/jKXOfpwYc4/Jy872Uo4uu2qBMHyURzWvSq678LeYot53vie6Qds
         E+y4QXzdmL4Q4yWN8+EYcBLBRuHuYFcDhCKxpzXWVrdh79CDXfHyXiCYPbXtan1BppQf
         i9DOicoBJfQqN6Lqp0FeYxUNQzwc3VC1QKArwRT2Y8IDWZn8u6aBcWC1aLSGT3VPjW8w
         sUfkIPDfNmLkuEuE3RKCxvSHTyUW3UoVURmeTJ42cFA8Z29o+CZVMAEu/+kFtd4plVKd
         UR182GsZdLNb6MHe3mzxpRfQGa5vuqv3yWv039umXJdF4HiS/LaVZ5XvkX1Cp/DKNU5n
         LLtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WgCl/8N1xU0ogg40eA7oe0JV/xgw+jVwPRhb8bXB9rI=;
        b=Ichl3vliokCoR4Q1BvVKItnTin3uO5LmKLaTnXru3aWHchu4oxF1aazMcqep2qi8Qj
         9fBWCvuDPW7SbSwKyCfnhAZ+49LO4hf1psGxN35AbhQn3gqxmrTyLn9iiIxmhSzJdsbH
         PQopOMoKlZbuafpEoNuOmHqcb5NDY2Y7dxj7AAab0QXB794Tr9UHN6vPe6VZX3rTg+5E
         S+P1Z1ZgQs9DYYXKJgv1D+XpBYfl/7f27m5YWP+ftVgoRuR415axzDBNklcVFjAXHghs
         XPb7RI2WuiR7LLIaPnXfTpxwMKUrDGauGr7YwSp5n+HemfgC/zgeyS0DN4YtHtPQxJqD
         IQvQ==
X-Gm-Message-State: AOAM530K3WV+ur9o/mFEphW1f67rkCBq4QBVTGUlchkRTj5tQz+BlGNy
        HGXUInxgu6Mhpe/m/3HioXI=
X-Google-Smtp-Source: ABdhPJzdAHGAoFGVBFMnG+75GZi6HDU5jM/M6p7NHklJ4FCVqWC9WtYNGB3I212c5+QHycHEKSCJpw==
X-Received: by 2002:a17:907:628d:: with SMTP id nd13mr36191653ejc.7.1632240937066;
        Tue, 21 Sep 2021 09:15:37 -0700 (PDT)
Received: from pinky.lan ([2a04:241e:502:1df0:b065:9bdf:4016:277])
        by smtp.gmail.com with ESMTPSA id kx17sm7674075ejc.51.2021.09.21.09.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:15:36 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
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
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/19] tcp: ipv4: Add AO signing for skb-less replies
Date:   Tue, 21 Sep 2021 19:14:55 +0300
Message-Id: <447b514284c1f8a6462bd8c248e3312095f4f5af.1632240523.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1632240523.git.cdleonard@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code in tcp_v4_send_ack and tcp_v4_send_reset does not allocate a
full skb so special handling is required for tcp-authopt handling.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_ipv4.c | 79 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e5c790795662..2d5fbe7690aa 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -641,10 +641,50 @@ void tcp_v4_send_check(struct sock *sk, struct sk_buff *skb)
 
 	__tcp_v4_send_check(skb, inet->inet_saddr, inet->inet_daddr);
 }
 EXPORT_SYMBOL(tcp_v4_send_check);
 
+/** tcp_v4_authopt_handle_reply - Insert TCPOPT_AUTHOPT if required
+ *
+ * returns number of bytes (always aligned to 4) or zero
+ */
+static int tcp_v4_authopt_handle_reply(
+		const struct sock *sk,
+		struct sk_buff *skb,
+		__be32* optptr,
+		struct tcphdr *th)
+{
+	struct tcp_authopt_info *info;
+	struct tcp_authopt_key_info *key_info;
+	u8 rnextkeyid;
+
+	if (sk->sk_state == TCP_TIME_WAIT)
+		info = tcp_twsk(sk)->tw_authopt_info;
+	else
+		info = tcp_sk(sk)->authopt_info;
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
+	tcp_v4_authopt_hash_reply(
+			(char*)(optptr + 1),
+			info,
+			key_info,
+			ip_hdr(skb)->daddr,
+			ip_hdr(skb)->saddr,
+			th);
+
+	return TCPOLEN_AUTHOPT_OUTPUT;
+}
+
 /*
  *	This routine will send an RST to the other tcp.
  *
  *	Someone asks: why I NEVER use socket parameters (TOS, TTL etc.)
  *		      for reset.
@@ -656,10 +696,12 @@ EXPORT_SYMBOL(tcp_v4_send_check);
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
@@ -709,12 +751,28 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
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
+	 *
+	 * FIXME: What about RST in response to SYN?
+	 */
+	if (static_branch_unlikely(&tcp_authopt_needed) && sk && sk->sk_state != TCP_NEW_SYN_RECV && sk->sk_state != TCP_LISTEN) {
+		int tcp_authopt_ret = tcp_v4_authopt_handle_reply(sk, skb, rep.opt, &rep.th);
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
 
@@ -752,11 +810,10 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
 		key = tcp_md5_do_lookup(sk1, l3index, addr, AF_INET);
 		if (!key)
 			goto out;
 
-
 		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
 		if (genhash || memcmp(hash_location, newhash, 16) != 0)
 			goto out;
 
 	}
@@ -773,10 +830,11 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		tcp_v4_md5_hash_hdr((__u8 *) &rep.opt[1],
 				     key, ip_hdr(skb)->saddr,
 				     ip_hdr(skb)->daddr, &rep.th);
 	}
 #endif
+skip_md5sig:
 	/* Can't co-exist with TCPMD5, hence check rep.opt[0] */
 	if (rep.opt[0] == 0) {
 		__be32 mrst = mptcp_reset_option(skb);
 
 		if (mrst) {
@@ -825,11 +883,11 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	ctl_sk->sk_mark = 0;
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
 	local_bh_enable();
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT)
 out:
 	rcu_read_unlock();
 #endif
 }
 
@@ -847,10 +905,12 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	struct {
 		struct tcphdr th;
 		__be32 opt[(TCPOLEN_TSTAMP_ALIGNED >> 2)
 #ifdef CONFIG_TCP_MD5SIG
 			   + (TCPOLEN_MD5SIG_ALIGNED >> 2)
+#elif defined (CONFIG_TCP_AUTHOPT)
+			   + (TCPOLEN_AUTHOPT_OUTPUT >> 2)
 #endif
 			];
 	} rep;
 	struct net *net = sock_net(sk);
 	struct ip_reply_arg arg;
@@ -878,10 +938,22 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	rep.th.seq     = htonl(seq);
 	rep.th.ack_seq = htonl(ack);
 	rep.th.ack     = 1;
 	rep.th.window  = htons(win);
 
+#ifdef CONFIG_TCP_AUTHOPT
+	if (static_branch_unlikely(&tcp_authopt_needed))
+	{
+		int offset = (tsecr) ? 3 : 0;
+
+		int tcp_authopt_ret = tcp_v4_authopt_handle_reply(sk, skb, &rep.opt[offset], &rep.th);
+		if (tcp_authopt_ret) {
+			arg.iov[0].iov_len += tcp_authopt_ret;
+			goto skip_md5sig;
+		}
+	}
+#endif
 #ifdef CONFIG_TCP_MD5SIG
 	if (key) {
 		int offset = (tsecr) ? 3 : 0;
 
 		rep.opt[offset++] = htonl((TCPOPT_NOP << 24) |
@@ -894,10 +966,11 @@ static void tcp_v4_send_ack(const struct sock *sk,
 		tcp_v4_md5_hash_hdr((__u8 *) &rep.opt[offset],
 				    key, ip_hdr(skb)->saddr,
 				    ip_hdr(skb)->daddr, &rep.th);
 	}
 #endif
+skip_md5sig:
 	arg.flags = reply_flags;
 	arg.csum = csum_tcpudp_nofold(ip_hdr(skb)->daddr,
 				      ip_hdr(skb)->saddr, /* XXX */
 				      arg.iov[0].iov_len, IPPROTO_TCP, 0);
 	arg.csumoffset = offsetof(struct tcphdr, check) / 2;
-- 
2.25.1

