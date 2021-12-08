Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D992C46D27C
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhLHLnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbhLHLmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:42:13 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AF6C0698D7;
        Wed,  8 Dec 2021 03:38:14 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id l25so7269246eda.11;
        Wed, 08 Dec 2021 03:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i2Xy/53y4dXqLZswi6r2h86/iHNvMywouKpA+caLINQ=;
        b=dhH8mw0TFHcfbQUjSngMmBoFjaFEclnWp7jnpljmtCDEmSkk5ydez63ZWCgot+t6Fx
         wJ7QMIYnNCwAoGMp23slAqONtOIM9Qp5jzfxctpo+/wUJzt2ySwDNhL68OHRZO+6Q0LO
         MGDVb4rFFaG8zHaqdpzKS+RYCx2jK5Vk4tBM0yGeqmWv8EX0Z9yHRU2pRz5+GLnNXfpC
         HiDwxp2gYxYu6/xkMVvKdXQTtAeC/TQE+2s/X5bIoCnot/8nkVk1psj/iHYl42DMdeyB
         iOH3CofsavUvzv2jqNFVgrP12iGdAYkNrfmyC625LHm/jA+NWjZhwUfcTGYxsfwUlbru
         b/Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i2Xy/53y4dXqLZswi6r2h86/iHNvMywouKpA+caLINQ=;
        b=DcQxV0HvxnVLT05d1vKsg8Pa820XeGz2sGo1d/l6/U8BbNORti31/ROHYflJC1+Kl4
         cHwpMF2wHtdVNXm08I/hcpHpQScabYgkGJFWyfEv01/FjchZclDuHnxCNkY/4EJBYeaR
         SxFFkCscxFvuph4zKRs1IIh9j5FHfTIjQZT2HKJbuz4NfEAdyeFrFMF3MD5xBvQUj35h
         uz0REjrcn9WzivGURqo3/EIPFeIiCffvg19Q47MSpNBtYIsqgFH9O3upWZDsbUOXD6g2
         JsNiVdF+rx+bHARYqyaVKpSab/Ow+SS2K/0lYTNQKDARcM2gtV6SbGltJF4/Pp+I9gso
         bxMQ==
X-Gm-Message-State: AOAM533uA7krleELEZjM7Df6D9T3gknQvQknrP2gn+ZbPe8UTo4B8v4q
        7jz5V7yWsMQwQk55np5ZDyM=
X-Google-Smtp-Source: ABdhPJz5zzWNO5geIPBgCL8eiLxQHZ/Fqn2m5LfK8V5ugd1d/FNJAF9LOKp3y59VLRUXFdT+IQ3lIg==
X-Received: by 2002:a05:6402:4311:: with SMTP id m17mr18492477edc.103.1638963493018;
        Wed, 08 Dec 2021 03:38:13 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:3c9f:e05b:4dff:43ba])
        by smtp.gmail.com with ESMTPSA id g11sm1883810edz.53.2021.12.08.03.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:38:12 -0800 (PST)
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
Subject: [PATCH v3 09/18] tcp: ipv6: Add AO signing for tcp_v6_send_response
Date:   Wed,  8 Dec 2021 13:37:24 +0200
Message-Id: <0df999535ac5c76b75abcf8a0b0f40fa64c27a7f.1638962992.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1638962992.git.cdleonard@gmail.com>
References: <cover.1638962992.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a special code path for acks and resets outside of normal
connection establishment and closing.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_authopt.c |  2 ++
 net/ipv6/tcp_ipv6.c    | 57 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 05234923cb9f..f1213c7db63b 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -320,10 +320,11 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 						      const struct sock *addr_sk,
 						      u8 *rnextkeyid)
 {
 	return tcp_authopt_lookup_send(info, addr_sk, -1);
 }
+EXPORT_SYMBOL(__tcp_authopt_select_key);
 
 static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_authopt_info *info;
@@ -1195,10 +1196,11 @@ int tcp_authopt_hash(char *hash_location,
 	 * try to make it obvious inside the packet.
 	 */
 	memset(hash_location, 0, TCP_AUTHOPT_MACLEN);
 	return err;
 }
+EXPORT_SYMBOL(tcp_authopt_hash);
 
 static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
 							    struct sk_buff *skb,
 							    struct tcp_authopt_info *info,
 							    int recv_id,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 3105a367d6b5..cd8544d08a36 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -886,10 +886,48 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
 	.init_seq	=	tcp_v6_init_seq,
 	.init_ts_off	=	tcp_v6_init_ts_off,
 	.send_synack	=	tcp_v6_send_synack,
 };
 
+#ifdef CONFIG_TCP_AUTHOPT
+static int tcp_v6_send_response_init_authopt(const struct sock *sk,
+					     struct tcp_authopt_info **info,
+					     struct tcp_authopt_key_info **key,
+					     u8 *rnextkeyid)
+{
+	/* Key lookup before SKB allocation */
+	if (!(tcp_authopt_needed && sk))
+		return 0;
+	if (sk->sk_state == TCP_TIME_WAIT)
+		*info = tcp_twsk(sk)->tw_authopt_info;
+	else
+		*info = rcu_dereference(tcp_sk(sk)->authopt_info);
+	if (!*info)
+		return 0;
+	*key = __tcp_authopt_select_key(sk, *info, sk, rnextkeyid);
+	if (*key)
+		return TCPOLEN_AUTHOPT_OUTPUT;
+	return 0;
+}
+
+static void tcp_v6_send_response_sign_authopt(const struct sock *sk,
+					      struct tcp_authopt_info *info,
+					      struct tcp_authopt_key_info *key,
+					      struct sk_buff *skb,
+					      struct tcphdr_authopt *ptr,
+					      u8 rnextkeyid)
+{
+	if (!(tcp_authopt_needed && key))
+		return;
+	ptr->num = TCPOPT_AUTHOPT;
+	ptr->len = TCPOLEN_AUTHOPT_OUTPUT;
+	ptr->keyid = key->send_id;
+	ptr->rnextkeyid = rnextkeyid;
+	tcp_authopt_hash(ptr->mac, key, info, (struct sock *)sk, skb);
+}
+#endif
+
 static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32 seq,
 				 u32 ack, u32 win, u32 tsval, u32 tsecr,
 				 int oif, struct tcp_md5sig_key *key, int rst,
 				 u8 tclass, __be32 label, u32 priority)
 {
@@ -901,13 +939,28 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	struct sock *ctl_sk = net->ipv6.tcp_sk;
 	unsigned int tot_len = sizeof(struct tcphdr);
 	__be32 mrst = 0, *topt;
 	struct dst_entry *dst;
 	__u32 mark = 0;
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_info *aoinfo;
+	struct tcp_authopt_key_info *aokey;
+	u8 aornextkeyid;
+	int aolen;
+#endif
 
 	if (tsecr)
 		tot_len += TCPOLEN_TSTAMP_ALIGNED;
+#ifdef CONFIG_TCP_AUTHOPT
+	/* Key lookup before SKB allocation */
+	aolen = tcp_v6_send_response_init_authopt(sk, &aoinfo, &aokey, &aornextkeyid);
+	if (aolen) {
+		tot_len += aolen;
+		/* Don't use MD5 */
+		key = NULL;
+	}
+#endif
 #ifdef CONFIG_TCP_MD5SIG
 	if (key)
 		tot_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
 
@@ -960,10 +1013,14 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 		tcp_v6_md5_hash_hdr((__u8 *)topt, key,
 				    &ipv6_hdr(skb)->saddr,
 				    &ipv6_hdr(skb)->daddr, t1);
 	}
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	tcp_v6_send_response_sign_authopt(sk, aoinfo, aokey, buff,
+					  (struct tcphdr_authopt *)topt, aornextkeyid);
+#endif
 
 	memset(&fl6, 0, sizeof(fl6));
 	fl6.daddr = ipv6_hdr(skb)->saddr;
 	fl6.saddr = ipv6_hdr(skb)->daddr;
 	fl6.flowlabel = label;
-- 
2.25.1

