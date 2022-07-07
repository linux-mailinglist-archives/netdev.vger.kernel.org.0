Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B8E5699F6
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 07:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbiGGFlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 01:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiGGFlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 01:41:14 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA8531901
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 22:41:14 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g4so16572639pgc.1
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 22:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3t0Mz/uQqIUOiN6mlxhKZ4uhLX/YzUmX24wtKVe8He4=;
        b=SGpQUxeALcZUcu0GrvcSWnbYadqNSgmjw3p99vxcOJwn5SI34PaLpuPP83em4DFTFM
         zDOm2aGftQ7xbRme9RS0eK2/4inqtAANOJDG8XJhyALlRk66RQPu8K9j/t7EbCYoKWSk
         pFl5EHH1UR12/2JfSxt3oU1M0klbGKCgFg8svYWXJxuM3QV1buLOihJqbjbOWlG1VjzN
         uAmfPHZXviftToV6pJdRqOcT1JAwjM/XvQ9JqdUP28cGs8geeAaF+eAvRGwomZUPSDQr
         CC/+kpErjJ65ocsygrnUu8OU6N3Jgusa9Erm2SQVqJJ2ArXx3Uxycb09EqajaoZxe4aq
         kdGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3t0Mz/uQqIUOiN6mlxhKZ4uhLX/YzUmX24wtKVe8He4=;
        b=TamWM21ga7tacoONbvcwI1jz4SAzmiOm/dlfxhQa91HfIew/CWUxGLD+hiYlGYjecl
         wdevMk7a0rGENXj7+8yPgj04mYvO6XBeDADUhbIBWyUGdzIhFPspi3wbp2j5EZoXAJQ1
         yy2MbC/leb3HjrxmIQKZEPjed+c8gCZ/l9eYsCCPwkOHLlTOc82JUagNRJ/ob+yZEQmC
         vnZ5cIQ1FllfXIJQ/s6/LEYPWsG0gV5oBx2d0ZzycTvbkQMBuGN7JrieVBo10d4MESYC
         3d2KtQUow8mQMGHUndR/ZhQXSKCbKddvAq5UIYTXTTCJVf0lm6nPBQMoAxKjgZ07HnUo
         kjeQ==
X-Gm-Message-State: AJIora/9lqThGUZElnDCefzCZIySblJ/mhfbrePah2gr7Mil8y1d3ybu
        iagRnLKgPCcfZK1R7j8YRPAuPqIWbw5o+1/bE24=
X-Google-Smtp-Source: AGRyM1sd5ma43RnRqLQjeIwunWB1Uzn/8BNku636ibFp7xdqr4h5la+Unhrr4zZIj9Q8rX15Q2QUWw==
X-Received: by 2002:a17:902:e5c5:b0:16b:ff65:d5a4 with SMTP id u5-20020a170902e5c500b0016bff65d5a4mr8335799plf.151.1657172473740;
        Wed, 06 Jul 2022 22:41:13 -0700 (PDT)
Received: from sewookseo1.c.googlers.com.com (174.71.80.34.bc.googleusercontent.com. [34.80.71.174])
        by smtp.gmail.com with ESMTPSA id p47-20020a056a0026ef00b0050dc7628150sm25892394pfw.42.2022.07.06.22.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 22:41:13 -0700 (PDT)
From:   Sewook Seo <ssewook@gmail.com>
To:     Sewook Seo <sewookseo@google.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        "David S . Miller " <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sehee Lee <seheele@google.com>
Subject: [PATCH v4 net-next] net: Find dst with sk's xfrm policy not ctl_sk
Date:   Thu,  7 Jul 2022 05:40:08 +0000
Message-Id: <20220707054008.3471371-1-ssewook@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220706063243.2782818-1-ssewook@gmail.com>
References: <20220706063243.2782818-1-ssewook@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: sewookseo <sewookseo@google.com>

If we set XFRM security policy by calling setsockopt with option
IPV6_XFRM_POLICY, the policy will be stored in 'sock_policy' in 'sock'
struct. However tcp_v6_send_response doesn't look up dst_entry with the
actual socket but looks up with tcp control socket. This may cause a
problem that a RST packet is sent without ESP encryption & peer's TCP
socket can't receive it.
This patch will make the function look up dest_entry with actual socket,
if the socket has XFRM policy(sock_policy), so that the TCP response
packet via this function can be encrypted, & aligned on the encrypted
TCP socket.

Tested: We encountered this problem when a TCP socket which is encrypted
in ESP transport mode encryption, receives challenge ACK at SYN_SENT
state. After receiving challenge ACK, TCP needs to send RST to
establish the socket at next SYN try. But the RST was not encrypted &
peer TCP socket still remains on ESTABLISHED state.
So we verified this with test step as below.
[Test step]
1. Making a TCP state mismatch between client(IDLE) & server(ESTABLISHED).
2. Client tries a new connection on the same TCP ports(src & dst).
3. Server will return challenge ACK instead of SYN,ACK.
4. Client will send RST to server to clear the SOCKET.
5. Client will retransmit SYN to server on the same TCP ports.
[Expected result]
The TCP connection should be established.

Cc: Maciej Żenczykowski <maze@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Sehee Lee <seheele@google.com>
Signed-off-by: Sewook Seo <sewookseo@google.com>
---
Changelog since v3:
- avoid to use ifdef directives for CONFIG_XFRM

 include/net/xfrm.h   | 2 ++
 net/ipv4/ip_output.c | 2 +-
 net/ipv4/tcp_ipv4.c  | 2 ++
 net/ipv6/tcp_ipv6.c  | 5 ++++-
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 9287712ad977..67b799ef5f67 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1195,6 +1195,8 @@ int __xfrm_sk_clone_policy(struct sock *sk, const struct sock *osk);
 
 static inline int xfrm_sk_clone_policy(struct sock *sk, const struct sock *osk)
 {
+	if (!sk_fullsock(osk))
+		return 0;
 	sk->sk_policy[0] = NULL;
 	sk->sk_policy[1] = NULL;
 	if (unlikely(osk->sk_policy[0] || osk->sk_policy[1]))
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 00b4bf26fd93..1c0013c9a9d1 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1704,7 +1704,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 			   tcp_hdr(skb)->source, tcp_hdr(skb)->dest,
 			   arg->uid);
 	security_skb_classify_flow(skb, flowi4_to_flowi_common(&fl4));
-	rt = ip_route_output_key(net, &fl4);
+	rt = ip_route_output_flow(net, &fl4, sk);
 	if (IS_ERR(rt))
 		return;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fda811a5251f..076010f82939 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -819,6 +819,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		ctl_sk->sk_priority = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_priority : sk->sk_priority;
 		transmit_time = tcp_transmit_time(sk);
+		xfrm_sk_clone_policy(ctl_sk, sk);
 	}
 	ip_send_unicast_reply(ctl_sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
@@ -827,6 +828,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 			      transmit_time);
 
 	ctl_sk->sk_mark = 0;
+	xfrm_sk_free_policy(ctl_sk);
 	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c72448ba6dc9..ffa2f6bb37dd 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -952,7 +952,10 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	 * Underlying function will use this to retrieve the network
 	 * namespace
 	 */
-	dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
+	if (sk && sk->sk_state != TCP_TIME_WAIT)
+		dst = ip6_dst_lookup_flow(net, sk, &fl6, NULL); /*sk's xfrm_policy can be referred.*/
+	else
+		dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(buff, dst);
 		ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL,
-- 
2.37.0.rc0.161.g10f37bed90-goog

