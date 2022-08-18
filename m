Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98C7598D6A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345634AbiHRUFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345636AbiHRUDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:03:36 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060F8D21FD;
        Thu, 18 Aug 2022 13:01:03 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id k26so5191460ejx.5;
        Thu, 18 Aug 2022 13:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=H5V0U/ugRc2yNsTQ00bggFRxq7p5sRi0qHJBCC5NX4A=;
        b=SObI8qErQ47x48a8m/znBP4X/oZ2tyg1fESECgBf1h6ttoWaUI0szRvMdK6uj/He/y
         d/Jk/D4t9Z/ezEDj9b1Yvx56EvTTdnCXH+B3bQN9H9tsGWQUDoUvDcNeYMZqcdE7O8QK
         g+MOjsX8WDgrVJGBinPO3mOLokal/LTtnCJOGoVIXYTuc3AoSKL1fyObsF43+cN6LVqj
         Ki1e2xGpbS8xp52qJ4iubxHD0a8T2StD2Ifv4mDYRDXLmzjq5iZxiyZQeuvj8UHkln3V
         rEntLgePtDv9tXF7SQM1gnhOr/1ITiDjmhMqFJ93G2TgBif9NUur0PcRJqf8jCJqPdDi
         oTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=H5V0U/ugRc2yNsTQ00bggFRxq7p5sRi0qHJBCC5NX4A=;
        b=jw2kJq4Do+T60+Yt4DwP8XX662KWm9v7cT7Wgdso1u4ZuijbcE7tM1xCM2RREz1e6M
         46H2kgMWI84UwGTZElIBXncwj5Tmg3zj4rMEo1DO8LuHq0+XMdLaONocyCrQwV7iSXLO
         +xWB+wnMqSBrpp32ZLkSopo2zUvGLJSEV6RsFlnI74P0jhmx/9VSMH2PcTXUIil8Utb8
         BGRzI3y2OLnW0cLtV6ouvFNLmGjQDUkfBapMDu8fL/ZZI6KtTxX31vtBV8ZzCYrNJKp2
         4qUH0bjQIZHGkMq4iBuuJF8MW8ewmBvN9TS8QqCMd75+HmsqtnYLCAwF4jR+76vzmpgO
         GRGg==
X-Gm-Message-State: ACgBeo3B4hSuLofr25R1m+Lm3k5IFUkWH1dlUtZy+0XxGp0N6SFMdWnt
        HzJU5H1MGFqJhU9mFD7y4z8=
X-Google-Smtp-Source: AA6agR60slY3ts9SbYBTQMFOvOoZ4Qn6FVmWhhwg7s1jetZE2sOpt1dFBLl3gybogpyovAE41SF0Ww==
X-Received: by 2002:a17:907:6e14:b0:730:a229:f747 with SMTP id sd20-20020a1709076e1400b00730a229f747mr2989402ejc.202.1660852863416;
        Thu, 18 Aug 2022 13:01:03 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:01:02 -0700 (PDT)
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
Subject: [PATCH v7 25/26] tcp: authopt: If no keys are valid for send report an error
Date:   Thu, 18 Aug 2022 22:59:59 +0300
Message-Id: <1ebffe1a92b0d36488168aa273ac87fa3866d9ca.1660852705.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660852705.git.cdleonard@gmail.com>
References: <cover.1660852705.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If this is not treated specially then when all keys are removed or
expired then TCP will start sending unsigned packets which is
undesirable. Instead try to report an error on key selection and
propagate it to userspace.

The error is assigned to sk_err and propagate it as soon as possible.
In theory we could try to make the error "soft" and even let the
connection continue if userspace adds a new key but the advantages are
unclear.

Since userspace is responsible for managing keys it can also avoid
sending unsigned packets by always closing the socket before removing
the active last key.

The specific error reported is ENOKEY.

This requires changes inside TCP option write code to support aborting
the actual packet send, until this point this did not happen in any
scenario.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_authopt.c |  9 +++++++--
 net/ipv4/tcp_output.c  | 20 ++++++++++++++++++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index bbdc5f68ab56..933a4bbddb70 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -448,10 +448,11 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 						      u8 *rnextkeyid,
 						      bool locked)
 {
 	struct tcp_authopt_key_info *key, *new_key = NULL;
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
+	bool anykey = false;
 
 	/* Listen sockets don't refer to any specific connection so we don't try
 	 * to keep using the same key.
 	 * The rnextkeyid is stored in tcp_request_sock
 	 */
@@ -470,11 +471,13 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 		else
 			send_id = rsk->recv_rnextkeyid;
 		key = tcp_authopt_lookup_send(net, addr_sk, send_id, NULL);
 		/* If no key found with specific send_id try anything else. */
 		if (!key)
-			key = tcp_authopt_lookup_send(net, addr_sk, -1, NULL);
+			key = tcp_authopt_lookup_send(net, addr_sk, -1, &anykey);
+		if (!key && anykey)
+			return ERR_PTR(-ENOKEY);
 		if (key)
 			*rnextkeyid = key->recv_id;
 		return key;
 	}
 
@@ -506,11 +509,13 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 							  info->recv_rnextkeyid,
 							  NULL);
 	}
 	/* If no key found with specific send_id try anything else. */
 	if (!key && !new_key)
-		new_key = tcp_authopt_lookup_send(net, addr_sk, -1, NULL);
+		new_key = tcp_authopt_lookup_send(net, addr_sk, -1, &anykey);
+	if (!new_key && anykey)
+		return ERR_PTR(-ENOKEY);
 
 	/* Update current key only if we hold the socket lock. */
 	if (new_key && key != new_key) {
 		if (locked) {
 			if (kref_get_unless_zero(&new_key->ref)) {
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 74c3ef86f0bc..a1c2d4d2c426 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -411,10 +411,11 @@ static inline bool tcp_urg_mode(const struct tcp_sock *tp)
 #define OPTION_SACK_ADVERTISE	BIT(0)
 #define OPTION_TS		BIT(1)
 #define OPTION_MD5		BIT(2)
 #define OPTION_WSCALE		BIT(3)
 #define OPTION_AUTHOPT		BIT(4)
+#define OPTION_AUTHOPT_FAIL	BIT(5)
 #define OPTION_FAST_OPEN_COOKIE	BIT(8)
 #define OPTION_SMC		BIT(9)
 #define OPTION_MPTCP		BIT(10)
 
 static void smc_options_write(__be32 *ptr, u16 *options)
@@ -783,10 +784,14 @@ static int tcp_authopt_init_options(const struct sock *sk,
 {
 #ifdef CONFIG_TCP_AUTHOPT
 	struct tcp_authopt_key_info *key;
 
 	key = tcp_authopt_select_key(sk, addr_sk, &opts->authopt_info, &opts->authopt_rnextkeyid);
+	if (IS_ERR(key)) {
+		opts->options |= OPTION_AUTHOPT_FAIL;
+		return TCPOLEN_AUTHOPT_OUTPUT;
+	}
 	if (key) {
 		opts->options |= OPTION_AUTHOPT;
 		opts->authopt_key = key;
 		return TCPOLEN_AUTHOPT_OUTPUT;
 	}
@@ -1342,10 +1347,18 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		 * release the following packet.
 		 */
 		if (tcp_skb_pcount(skb) > 1)
 			tcb->tcp_flags |= TCPHDR_PSH;
 	}
+#ifdef CONFIG_TCP_AUTHOPT
+	if (opts.options & OPTION_AUTHOPT_FAIL) {
+		rcu_read_unlock();
+		sk->sk_err = ENOKEY;
+		sk_error_report(sk);
+		return -ENOKEY;
+	}
+#endif
 	tcp_header_size = tcp_options_size + sizeof(struct tcphdr);
 
 	/* if no packet is in qdisc/device queue, then allow XPS to select
 	 * another queue. We can be called from tcp_tsq_handler()
 	 * which holds one reference to sk.
@@ -3652,10 +3665,17 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	/* bpf program will be interested in the tcp_flags */
 	TCP_SKB_CB(skb)->tcp_flags = TCPHDR_SYN | TCPHDR_ACK;
 	tcp_header_size = tcp_synack_options(sk, req, mss, skb, &opts, md5,
 					     foc, synack_type,
 					     syn_skb) + sizeof(*th);
+#ifdef CONFIG_TCP_AUTHOPT
+	if (opts.options & OPTION_AUTHOPT_FAIL) {
+		rcu_read_unlock();
+		kfree_skb(skb);
+		return NULL;
+	}
+#endif
 
 	skb_push(skb, tcp_header_size);
 	skb_reset_transport_header(skb);
 
 	th = (struct tcphdr *)skb->data;
-- 
2.25.1

