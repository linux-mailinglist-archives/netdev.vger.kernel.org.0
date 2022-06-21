Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF11B553B84
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 22:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354312AbiFUUXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 16:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354318AbiFUUXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 16:23:14 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A21CAE7D
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 13:23:11 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id m2so6250853plx.3
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 13:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nNqn2KpA9Wu6Kk0gAFVTMZsINKotYp5vQjkZHl0c4/4=;
        b=oroR6o/pWC6FIruKw6lG2fUc7mJKEkagLHe1VdBTmn/VN5OSsuJUag8vLhvI6qGJx/
         v/Dp5kohI0Tz76prc09Wa+djZkGl4fRaQr7IALXQuzVrzdb6VTZj6cUVdCESi6sy+7dV
         PMluw9noUPGcGqGHnhoB+ZTzfV7PU7/IM06ZrOAiUhYI0quWUYT7wOoAMrxnz1u92eRZ
         sDm72nMiJdPG/j7RuJIaLnrNp6s/0z0KtALX4/R3aeiq63tLkE5Tyfn1YnPFqN1sHIiH
         Uvwiml7UNzvVYFlC7PfOc6FPsTm6BCvaaUfqG1wRYE9sh24FFSrYvFm2ptpFRhCDvbT3
         BxSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nNqn2KpA9Wu6Kk0gAFVTMZsINKotYp5vQjkZHl0c4/4=;
        b=8ARdYhiUCz74P3nef7M8XHDbmdqt1YqzrnpTMq1Elqh3n+MEtxQWTtL3MyHQ77LH4k
         WudkqkOaYuJlftqhIoHZ3Zr7gd7JzuRDCM9YMhN21c7VYQ4FJe73o8eIgSrbAZnkquA9
         oQJX8XhaQ/HTfLU+N/IXYrZLLjZOuYiq6wUPBm+eLCuSdAb3ChEAK9rVAY9Gcad0sVhP
         D1vZ1gYBAtue/eyb6D2LB2NoGfUCIfT4PhwP1J/GIUVvgkYjD4Z+P/1C/qesTuqakISk
         FEAUQwTs7eeijEEwEjMoxFqg5IPALCuuduxtcxgmFCElvX+3aaTNu/eMMknp3dzkJuO1
         o9pw==
X-Gm-Message-State: AJIora+hbjqDhD0Y3Ye/WbRkBZ2Fv1yPxus54PjwH5PHerFSgz1PNkby
        cOon/YBV8+9L8/MfldJDHR1KkmTaBnKJakzo55M=
X-Google-Smtp-Source: AGRyM1vO47vvJPY7hwVy73U2YFLFu4kJZPKd4YjGLtInMCC4Rnr0sm8J1QlzdGs9A5HLP4lAmJ0LoA==
X-Received: by 2002:a17:90a:c718:b0:1eb:af0e:36fd with SMTP id o24-20020a17090ac71800b001ebaf0e36fdmr30820446pjt.99.1655842990540;
        Tue, 21 Jun 2022 13:23:10 -0700 (PDT)
Received: from sewookseo1.c.googlers.com.com (253.78.80.34.bc.googleusercontent.com. [34.80.78.253])
        by smtp.gmail.com with ESMTPSA id u1-20020a170903124100b0016188a4005asm11059354plh.122.2022.06.21.13.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 13:23:10 -0700 (PDT)
From:   Sewook Seo <ssewook@gmail.com>
To:     Sewook Seo <sewookseo@google.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        "David S . Miller " <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sehee Lee <seheele@google.com>
Subject: [PATCH] net-tcp: Find dst with sk's xfrm policy not ctl_sk
Date:   Tue, 21 Jun 2022 20:22:40 +0000
Message-Id: <20220621202240.4182683-1-ssewook@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
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

Effort: net-tcp
Cc: Maciej Żenczykowski <maze@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Sehee Lee <seheele@google.com>
Signed-off-by: sewookseo <sewookseo@google.com>
---
 net/ipv4/ip_output.c | 7 ++++++-
 net/ipv4/tcp_ipv4.c  | 8 ++++++++
 net/ipv6/tcp_ipv6.c  | 7 ++++++-
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 00b4bf26fd93..26f388decee9 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1704,7 +1704,12 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 			   tcp_hdr(skb)->source, tcp_hdr(skb)->dest,
 			   arg->uid);
 	security_skb_classify_flow(skb, flowi4_to_flowi_common(&fl4));
-	rt = ip_route_output_key(net, &fl4);
+#ifdef CONFIG_XFRM
+	if (sk && sk->sk_policy[XFRM_POLICY_OUT])
+		rt = ip_route_output_flow(net, &fl4, sk);
+	else
+#endif
+		rt = ip_route_output_key(net, &fl4);
 	if (IS_ERR(rt))
 		return;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fda811a5251f..6a9afd2fdf70 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -819,6 +819,10 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		ctl_sk->sk_priority = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_priority : sk->sk_priority;
 		transmit_time = tcp_transmit_time(sk);
+#ifdef CONFIG_XFRM
+		if (sk->sk_policy[XFRM_POLICY_OUT])
+			xfrm_sk_clone_policy(ctl_sk, sk);
+#endif
 	}
 	ip_send_unicast_reply(ctl_sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
@@ -827,6 +831,10 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 			      transmit_time);
 
 	ctl_sk->sk_mark = 0;
+#ifdef CONFIG_XFRM
+	if (ctl_sk->sk_policy[XFRM_POLICY_OUT])
+		xfrm_sk_free_policy(ctl_sk);
+#endif
 	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c72448ba6dc9..f731884cda90 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -952,7 +952,12 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	 * Underlying function will use this to retrieve the network
 	 * namespace
 	 */
-	dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
+#ifdef CONFIG_XFRM
+	if (sk && sk->sk_policy[XFRM_POLICY_OUT])
+		dst = ip6_dst_lookup_flow(net, sk, &fl6, NULL);  /* Get dst with sk's XFRM policy */
+	else
+#endif
+		dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(buff, dst);
 		ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL,
-- 
2.37.0.rc0.104.g0611611a94-goog

