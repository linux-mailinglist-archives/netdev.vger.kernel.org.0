Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A63E5ACC54
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237373AbiIEHIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237235AbiIEHHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:07:20 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11C33E75D;
        Mon,  5 Sep 2022 00:06:53 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id nc14so15130423ejc.4;
        Mon, 05 Sep 2022 00:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=DDAdDDKNEDarG/TIf8PFofQDb3qfrTMogxncAYXkt6w=;
        b=qHAr5AkJfyzOu+SmLgqy5OQk+/UYRT1W7NkB2/QpyCzRozYxs9G/7kF7TSBbauwAgn
         ynQUWnd54yS49tmunW8JNTPKYmSCLGoLwxnzoxDigwafoHqRdGNCqbu1MZ6y09YtTgID
         LVqiWWRfrcs+z7j7plLl37RiStbVboXFd1VpKhM0KeVY3a6stEIy45lkpYTp0XGf674P
         STWvze4CVla7I+hrmy0CLYZc7Iosa6vcEJRWMOt19UFSK/g1ek3YwXnU8GhPwqB7N2Qv
         x9HixUHpU45pdReXE7A06paXk1XNkqQJFUsBJVvuWQX+R+6KKQZIrsLpzF02yTAjc80O
         gexw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=DDAdDDKNEDarG/TIf8PFofQDb3qfrTMogxncAYXkt6w=;
        b=znDJdlIXjOx4WgGZapb6B9V021pZ6iws0XXrVcMxJMMArMsiwBF8Mj+6KdvFEJdk+Y
         Owmcd1bV52Wz7Z5wCfVKNSFzt81uowPBlAvcHzVBp+gPB25YP+/A8RMu8AtpygWWmcml
         3nzWFrOmzFqQ7Xfy6qd8K5ARnRoD8fZh+EaxU5KuwqOht8uNS2ZXwseQnFaXM6GCodlk
         +/MN8QYaisRWNcXcP1ITTYrksM8gZWJe0eWaWerI1PVa8SwDNoiLdngfXEmfmdrRXpN6
         ihJQvBx/c4ET81L7Gq1zURS/JgmtNq1p9EeCppWNgOwKbbPBswCXHM2Gw6j4PhSf8wmK
         xCdw==
X-Gm-Message-State: ACgBeo0tmCQutDPucS+p6VJc1UtCTzHQ5SQfX1/Svbt3X6lb4bGeZL3E
        AxyubvqFYGVBCbVRsKRoyFg=
X-Google-Smtp-Source: AA6agR5UqzREzQuzbsICKrpM6inAHXBhpxHPuhhpm/ZCRcLijdKba4gkwmgqgQzk5w5FhwIJmKXloQ==
X-Received: by 2002:a17:906:8a52:b0:741:5a6e:adb5 with SMTP id gx18-20020a1709068a5200b007415a6eadb5mr26856216ejc.47.1662361612428;
        Mon, 05 Sep 2022 00:06:52 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:40ec:9f50:387:3cfb])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5882775edd.48.2022.09.05.00.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:06:52 -0700 (PDT)
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
Subject: [PATCH v8 21/26] tcp: authopt: Try to respect rnextkeyid from SYN on SYNACK
Date:   Mon,  5 Sep 2022 10:05:57 +0300
Message-Id: <ca20d110fdcda4d595e5cfed6b673237c2f9b958.1662361354.git.cdleonard@gmail.com>
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

According to the RFC we should use the key that the peer suggests via
rnextkeyid.

This is currently done by storing recv_rnextkeyid in tcp_authopt_info
but this does not work for the SYNACK case because the tcp_request_sock
does not hold an info pointer for reasons of memory usage.

Handle this by storing recv_rnextkeyid inside tcp_request_sock. This
doesn't increase the memory usage because there are unused bytes at the
end.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/linux/tcp.h    |  6 ++++++
 net/ipv4/tcp_authopt.c | 14 +++++++++++---
 net/ipv4/tcp_input.c   | 12 ++++++++++++
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 551942883f06..6a4ff0ed55c6 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -125,10 +125,13 @@ struct tcp_options_received {
 	u8	saw_unknown:1,	/* Received unknown option		*/
 		unused:7;
 	u8	num_sacks;	/* Number of SACK blocks		*/
 	u16	user_mss;	/* mss requested by user in ioctl	*/
 	u16	mss_clamp;	/* Maximal mss, negotiated at connection setup */
+#if IS_ENABLED(CONFIG_TCP_AUTHOPT)
+	u8	rnextkeyid;
+#endif
 };
 
 static inline void tcp_clear_options(struct tcp_options_received *rx_opt)
 {
 	rx_opt->tstamp_ok = rx_opt->sack_ok = 0;
@@ -163,10 +166,13 @@ struct tcp_request_sock {
 	u32				rcv_nxt; /* the ack # by SYNACK. For
 						  * FastOpen it's the seq#
 						  * after data-in-SYN.
 						  */
 	u8				syn_tos;
+#if IS_ENABLED(CONFIG_TCP_AUTHOPT)
+	u8				recv_rnextkeyid;
+#endif
 };
 
 static inline struct tcp_request_sock *tcp_rsk(const struct request_sock *req)
 {
 	return (struct tcp_request_sock *)req;
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 2a1ddae69b27..a141439d9ebe 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -547,21 +547,29 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
 	bool anykey = false;
 	int pref_send_id;
 
 	/* Listen sockets don't refer to any specific connection so we don't try
-	 * to keep using the same key and ignore any received keyids.
+	 * to keep using the same key.
+	 * The rnextkeyid is stored in tcp_request_sock
 	 */
 	if (sk->sk_state == TCP_LISTEN) {
+		struct tcp_request_sock *rsk;
+
+		if (WARN_ONCE(addr_sk->sk_state != TCP_NEW_SYN_RECV, "bad socket state"))
+			return NULL;
+		rsk = tcp_rsk((struct request_sock *)addr_sk);
+		/* Forcing a specific send_keyid on a listen socket forces it for
+		 * all clients so is unlikely to be useful.
+		 */
 		if (info->flags & TCP_AUTHOPT_FLAG_LOCK_KEYID)
 			pref_send_id = info->user_pref_send_keyid;
 		else
-			pref_send_id = -1;
+			pref_send_id = rsk->recv_rnextkeyid;
 		key = tcp_authopt_lookup_send(net, addr_sk, pref_send_id, rnextkeyid, &anykey);
 		if (!key && anykey)
 			return ERR_PTR(-ENOKEY);
-
 		return key;
 	}
 
 	/* Try to keep the same sending key unless user or peer requires a different key
 	 * User request (via TCP_AUTHOPT_FLAG_LOCK_KEYID) always overrides peer request.
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 4da39c32b934..6f477b110896 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4108,10 +4108,18 @@ void tcp_parse_options(const struct net *net,
 				/*
 				 * The MD5 Hash has already been
 				 * checked (see tcp_v{4,6}_do_rcv()).
 				 */
 				break;
+#endif
+#ifdef CONFIG_TCP_AUTHOPT
+			case TCPOPT_AUTHOPT:
+				/* Hash has already been checked.
+				 * We parse rnextkeyid here so we can match it on synack
+				 */
+				opt_rx->rnextkeyid = ptr[1];
+				break;
 #endif
 			case TCPOPT_FASTOPEN:
 				tcp_parse_fastopen_option(
 					opsize - TCPOLEN_FASTOPEN_BASE,
 					ptr, th->syn, foc, false);
@@ -6964,10 +6972,14 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 		tcp_clear_options(&tmp_opt);
 
 	if (IS_ENABLED(CONFIG_SMC) && want_cookie)
 		tmp_opt.smc_ok = 0;
 
+#if IS_ENABLED(CONFIG_TCP_AUTHOPT)
+	tcp_rsk(req)->recv_rnextkeyid = tmp_opt.rnextkeyid;
+#endif
+
 	tmp_opt.tstamp_ok = tmp_opt.saw_tstamp;
 	tcp_openreq_init(req, &tmp_opt, skb, sk);
 	inet_rsk(req)->no_srccheck = inet_sk(sk)->transparent;
 
 	/* Note: tcp_v6_init_req() might override ir_iif for link locals */
-- 
2.25.1

