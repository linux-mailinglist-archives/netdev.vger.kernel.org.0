Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4587F598D26
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345880AbiHRUEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345854AbiHRUCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:02:34 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A84D126F;
        Thu, 18 Aug 2022 13:00:58 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z20so3182136edb.9;
        Thu, 18 Aug 2022 13:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=YA6frCx1hRCNBxDfW475JeOMBGqfBd7hA2JFkcsGOKA=;
        b=mkZSNqIYhTtwxHezi9sMuoD5x30JnV73z7lmwKVXbPaUYeZbvchcRPtVnFL48GC3cp
         +qcb9LQpYjCvJ396qP5v87TF6jtuooEWjGrgxSawRtBDQv4SoIN1JUqF0Rhj858WJYEN
         aTdTHppTLzZ2OB4F+89mJwSZLULZ616fGHSQ4OWHP3ItDfwYG9bjs5lUbzWUoF9/oc7t
         brJrtU0PFZol/c4TvEuzaAL4Q/zGld3Ohn4zIBiMLidf6wa+uD5jZpLZK0X2i13C0ZFY
         J2FGyShNuNYpZ9BbNBkD9/rWZyU+txNRs3l29Hlz9hrKPjJxkCSoVQdksWZssEWZ87Za
         FCJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=YA6frCx1hRCNBxDfW475JeOMBGqfBd7hA2JFkcsGOKA=;
        b=pyvqdx9T94nnT5uURfl2YLn9SwoMjCnjvxqHalmWJYpCKJ4afdNwSoSLkMtykiXHHO
         pRfKvl3hT4naxdNOyF3easqoKrJwogxnIMeO2PHY4Qp1O3d7H+8zdT0PsYeQTJXpgbOz
         V3ikX5Bi+NPJiS9T4hNA4FfJaxUYtxz1bJPYqJSUb7K0svfeGd45owTcGL/CvVGEnXLq
         05adXv3uR/pQwTYiHzRNE3p8wN0tH70t5svhvNgoelf/9d3k/qenBkLDaquZPvwA5dGc
         DL6NxdvaXpyUXoh7tLgJmxbFQCeQ3bYVZ6ZxwEo0rpusNH3FchbZU4N75/G5IUsjHxw0
         D/CA==
X-Gm-Message-State: ACgBeo0e4kNxKTgHiv24A87pCCxgjtUY0TsNJZucymHNer0jyVIX4TJt
        53nRzOmaq8guRkSSdL1HMVI=
X-Google-Smtp-Source: AA6agR68lPrtwvGaLYpYwAp9y0gV+9Xwu4oXIHhBDoCunekonePkexA0cBl4olfpVWtrspAXfl76EQ==
X-Received: by 2002:a05:6402:51ce:b0:43e:74bc:dce with SMTP id r14-20020a05640251ce00b0043e74bc0dcemr3499322edd.225.1660852857863;
        Thu, 18 Aug 2022 13:00:57 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:57 -0700 (PDT)
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
Subject: [PATCH v7 22/26] tcp: authopt: Try to respect rnextkeyid from SYN on SYNACK
Date:   Thu, 18 Aug 2022 22:59:56 +0300
Message-Id: <4e54cde5124488ca725b4d057d1c3411e5befa1a.1660852705.git.cdleonard@gmail.com>
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
 net/ipv4/tcp_authopt.c | 26 ++++++++++++++++++++------
 net/ipv4/tcp_input.c   | 12 ++++++++++++
 3 files changed, 38 insertions(+), 6 deletions(-)

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
index 0a273ad239ec..de1390273ef3 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
+#include "linux/tcp.h"
+#include "net/tcp_states.h"
 #include <net/tcp_authopt.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <linux/kref.h>
@@ -444,21 +446,33 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 {
 	struct tcp_authopt_key_info *key, *new_key = NULL;
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
 
 	/* Listen sockets don't refer to any specific connection so we don't try
-	 * to keep using the same key and ignore any received keyids.
+	 * to keep using the same key.
+	 * The rnextkeyid is stored in tcp_request_sock
 	 */
 	if (sk->sk_state == TCP_LISTEN) {
-		int send_keyid = -1;
-
+		int send_id = -1;
+		struct tcp_request_sock *rsk;
+
+		if (WARN_ONCE(addr_sk->sk_state != TCP_NEW_SYN_RECV, "bad socket state"))
+			return NULL;
+		rsk = tcp_rsk((struct request_sock *)addr_sk);
+		/* Forcing a specific send_keyid on a listen socket forces it for
+		 * all clients so is unlikely to be useful.
+		 */
 		if (info->flags & TCP_AUTHOPT_FLAG_LOCK_KEYID)
-			send_keyid = info->send_keyid;
-		key = tcp_authopt_lookup_send(net, addr_sk, send_keyid);
+			send_id = info->send_keyid;
+		else
+			send_id = rsk->recv_rnextkeyid;
+		key = tcp_authopt_lookup_send(net, addr_sk, send_id);
+		/* If no key found with specific send_id try anything else. */
+		if (!key)
+			key = tcp_authopt_lookup_send(net, addr_sk, -1);
 		if (key)
 			*rnextkeyid = key->recv_id;
-
 		return key;
 	}
 
 	if (locked) {
 		sock_owned_by_me(sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d901e27801d1..579562de4551 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4107,10 +4107,18 @@ void tcp_parse_options(const struct net *net,
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
@@ -6963,10 +6971,14 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
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

