Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3608567EAE
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 08:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiGFGe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 02:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiGFGey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 02:34:54 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3CB13E36
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 23:34:53 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id z14so13316189pgh.0
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 23:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hmQJ2vxY6vQYm9uqg++CEt5ftPJ9sGGia71wT7vGN40=;
        b=cImpzWyc1+MBBcw1PkgxgGD51+4BKkafPgEajbFNxNa4UD3XDPP82aPKuuBkbixR8I
         gEZlFrMwvntvgLaoON2AoTn3hmZpNMRfPNCmZsGdAllIOs+d7dfRrAB1crRE821nPEb/
         dLeKSRamSDGvrMXYU6SqtvfgdUXC9Wky8PSTby8y8RajKxka3A6+XRTzsYl6GjjtlEyZ
         QfrzINYrGeo8/UMk9e/AvGInHdbnupbASONnq2vOZcrOGJs67UlaWE8wXHxkwESurV73
         JOODgc7zdb/hPOGCXhzbtmImrZ+wauXdkDkvXRWfMAM4DIrl8p8xkLKIoDb6JHKPMfLc
         +rBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hmQJ2vxY6vQYm9uqg++CEt5ftPJ9sGGia71wT7vGN40=;
        b=diPjNPub98P2i/DSUhtIwTSpW0G8wiSkv4mkAyyDcq6FxlHQM1npiLSNDBk9AtGo1O
         0RItkSKWWxM6izPrw8HmLyLpoqMx7vxP1h8+J/u/hYl/Nb1VabduuMJJ9sYo8c1EgZ2G
         yyMADc7AAXDqGE5tkQwZ0Y/GUVgpaapPziAwLI6pBuPZf3E+J9l4XTtRxX/CGJvH8qOk
         gS9tj4bZ0HjgrLyE+z/0jgWO2C6WUwzmE2ikSjhO6QF/C0/buYn93CpCw1F7e8604Qn1
         IpGsvCWtg9tE6dDWJI1FuYkwL1RQazY99thd+fisgJYP7RBcPZbUQoYtEeekByAz3RHu
         AXwg==
X-Gm-Message-State: AJIora9EZ3KbNAeFSSF7GJPAncDh7S1UjrbLLdljtARnKSUcyLmc/p4j
        uUT0QAkrJiGzqqQr36S6v4PPuH/+t7VMRDD7RN8=
X-Google-Smtp-Source: AGRyM1skMCbss4YA0h8Z41cjZgsn2322xR7YDmdQohnpQAyaQKU4JUYS3zt9YEqtXa+f5CDK8+kTww==
X-Received: by 2002:a63:134a:0:b0:411:e6ff:db5 with SMTP id 10-20020a63134a000000b00411e6ff0db5mr22299571pgt.120.1657089293423;
        Tue, 05 Jul 2022 23:34:53 -0700 (PDT)
Received: from sewookseo1.c.googlers.com.com (174.71.80.34.bc.googleusercontent.com. [34.80.71.174])
        by smtp.gmail.com with ESMTPSA id b21-20020a17090a8c9500b001ec8d191db4sm16322090pjo.17.2022.07.05.23.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 23:34:52 -0700 (PDT)
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
Subject: [PATCH v3 net-next] net: Find dst with sk's xfrm policy not ctl_sk
Date:   Wed,  6 Jul 2022 06:32:43 +0000
Message-Id: <20220706063243.2782818-1-ssewook@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220621202240.4182683-1-ssewook@gmail.com>
References: <20220621202240.4182683-1-ssewook@gmail.com>
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

Effort: net
Cc: Maciej Żenczykowski <maze@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Sehee Lee <seheele@google.com>
Signed-off-by: Sewook Seo <sewookseo@google.com>
---
 net/ipv4/ip_output.c | 7 ++++++-
 net/ipv4/tcp_ipv4.c  | 5 +++++
 net/ipv6/tcp_ipv6.c  | 7 ++++++-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 00b4bf26fd93..1da430c8fee2 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1704,7 +1704,12 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 			   tcp_hdr(skb)->source, tcp_hdr(skb)->dest,
 			   arg->uid);
 	security_skb_classify_flow(skb, flowi4_to_flowi_common(&fl4));
-	rt = ip_route_output_key(net, &fl4);
+#ifdef CONFIG_XFRM
+	if (sk->sk_policy[XFRM_POLICY_OUT])
+		rt = ip_route_output_flow(net, &fl4, sk);
+	else
+#endif
+		rt = ip_route_output_key(net, &fl4);
 	if (IS_ERR(rt))
 		return;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fda811a5251f..3c2ab436c692 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -819,6 +819,10 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		ctl_sk->sk_priority = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_priority : sk->sk_priority;
 		transmit_time = tcp_transmit_time(sk);
+#ifdef CONFIG_XFRM
+		if (sk->sk_policy[XFRM_POLICY_OUT] && sk_fullsock(sk))
+			xfrm_sk_clone_policy(ctl_sk, sk);
+#endif
 	}
 	ip_send_unicast_reply(ctl_sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
@@ -827,6 +831,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 			      transmit_time);
 
 	ctl_sk->sk_mark = 0;
+	xfrm_sk_free_policy(ctl_sk);
 	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c72448ba6dc9..8b8819c3d2c2 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -952,7 +952,12 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	 * Underlying function will use this to retrieve the network
 	 * namespace
 	 */
-	dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
+#ifdef CONFIG_XFRM
+	if (sk && sk->sk_policy[XFRM_POLICY_OUT] && sk_fullsock(sk))
+		dst = ip6_dst_lookup_flow(net, sk, &fl6, NULL);  /* Get dst with sk's XFRM policy */
+	else
+#endif
+		dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(buff, dst);
 		ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL,
-- 
2.37.0.rc0.161.g10f37bed90-goog

