Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612A65ACC65
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237225AbiIEHJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237142AbiIEHHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:07:20 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C303F302;
        Mon,  5 Sep 2022 00:06:52 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id y3so15186881ejc.1;
        Mon, 05 Sep 2022 00:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=utxtg9IZVwjgC6RJQQhltL787qSzW/51yGuH9rnx5/Q=;
        b=fMTOWksiEyD6+PEElE2UoGKG1iq/iiY1q/XwfM7EEc37/Uu2W3sHZ7w8+CIPPfZa7G
         LN125q7ottbebHvvWjbfz+CvGRK+9qIOrZt/1nn22BF/jY5/pIKttjrN8/UUI4d6dggU
         0zbPugCZIEGG5rGEkU1OlE4NrRXUT56Rk0pu3pp+Z/qgMPiW+fiTJ+xtApqoAcj1RVGC
         Vca/h9w/GQQo0Nap6+mlk6ixQAj8hoEkReOLYphxV0wFqK3HkwmApeD8/pTV5ErO9eH+
         Q99Y4jFnjwHy8lybdDjKTUbL9zkT/7Tal7ESpDppshD2QwH1wRZbgnrjjuqLCiYFi/vn
         OuHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=utxtg9IZVwjgC6RJQQhltL787qSzW/51yGuH9rnx5/Q=;
        b=eNMZu0YP66jXCjwhWQmdODUOMlahidj+kLGRyV8U7znbLuexFDjZVkUg37ITZv/aDc
         88PShY9/s0XK5GAs/HtpRlTQhdr6X0uaNSOXSZN+nnAnJAAJzz8iMzKsXwC+VfBpvO0A
         rwe5WRm/JWIhtxw1rYNUu9PVWjMufGbixs5+tu6WYBZCE/6B7U3zyqMYw46Qwri64eU+
         A5j4rnId+I23L/mwcYk5qGjAr3mml6yKsb7ihueurZVHt4B4kr+H4BE2BHvACatndfYg
         QTfMcbwm76IhEG1i6XiUB2ttyAn0Xa4NlrsewgAMkrCYdvOVkzBOcxmXwVveznyapcdC
         wuiw==
X-Gm-Message-State: ACgBeo0B0VtlS0uY7SrYxFuCDBKopW4yDIQuUmHOiZ+5LcRlFQHsABDf
        Pdx1IsMok+YoIrJeFhxsP7Q=
X-Google-Smtp-Source: AA6agR7FXo3sWejox5nyoJTqZAOCVEwBHmIHLVhXEDtJTk0SO4/WpBxwD2B+gxfMoQOImCfk/xGw4g==
X-Received: by 2002:a17:907:94c4:b0:741:9910:9dd with SMTP id dn4-20020a17090794c400b00741991009ddmr23623915ejc.568.1662361610581;
        Mon, 05 Sep 2022 00:06:50 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:40ec:9f50:387:3cfb])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5882775edd.48.2022.09.05.00.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:06:50 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
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
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 20/26] tcp: authopt: If no keys are valid for send report an error
Date:   Mon,  5 Sep 2022 10:05:56 +0300
Message-Id: <f302529ecfece72f1d599bb614e3358789c36aed.1662361354.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662361354.git.cdleonard@gmail.com>
References: <cover.1662361354.git.cdleonard@gmail.com>
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
 net/ipv4/tcp_authopt.c |  4 ++++
 net/ipv4/tcp_output.c  | 20 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index ba16b8c50565..2a1ddae69b27 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -555,10 +555,12 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 		if (info->flags & TCP_AUTHOPT_FLAG_LOCK_KEYID)
 			pref_send_id = info->user_pref_send_keyid;
 		else
 			pref_send_id = -1;
 		key = tcp_authopt_lookup_send(net, addr_sk, pref_send_id, rnextkeyid, &anykey);
+		if (!key && anykey)
+			return ERR_PTR(-ENOKEY);
 
 		return key;
 	}
 
 	/* Try to keep the same sending key unless user or peer requires a different key
@@ -569,10 +571,12 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 	else
 		pref_send_id = info->recv_rnextkeyid;
 
 	key = tcp_authopt_lookup_send(net, addr_sk, pref_send_id, rnextkeyid, &anykey);
 
+	if (!key && anykey)
+		return ERR_PTR(-ENOKEY);
 	if (!key)
 		return NULL;
 
 	info->send_keyid = key->send_id;
 	if (rnextkeyid) {
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index d48d5dc36916..e8a6fec22fbf 100644
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

