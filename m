Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D55E563725
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 17:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiGAPpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 11:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiGAPpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 11:45:08 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC9F2E688
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 08:45:07 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id c6-20020a17090abf0600b001eee794a478so6808190pjs.1
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 08:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4kL2J3waI1/HipljLlbESi16CzaasBnMD53my+eWr+Q=;
        b=oUQjrU57BYd4TEclijhVgVa7fuexssMPx1jo+mofihv0bkTaosbqn2WRcic8By7aOi
         QBuzm/qPlFZAcgfZmR05iaeSv4m6fJIgB9SODx7YH5tVyxNQanTdv6fpG0JEbMmtpHSz
         aodQGKYG8Riiwwym5LyUpw9mq/X23CWWg8evHStFxuE3pAHSj5XEiFJ09Ohw8ejv2+Ba
         DN/rQxhUCiXGvzt1Q/chr23qhRkg2zvDjC9ejI4M9v+OlXRAZ1cIMNek63lWfCQLmQIt
         qHGhuLHsRD5EBzFxUnOEKsFLtR/tTEkahUPcbZk+eO0z89TabrkazyriTvXkcKCosq2s
         UZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4kL2J3waI1/HipljLlbESi16CzaasBnMD53my+eWr+Q=;
        b=eu4JWos0Ny/y1Na1xzmj7FEq04suWLXe0H9ZJPPYdd7VyvoOJMCO/j+f9SXE1MFFAb
         e63VPMYi8yW9TRwv+KyLbFtGi6kFc5dnXwyAtYpWC36rzdFI/YKAP9WyIuhDlbsQX6dO
         +Xx1kRSRDCa9a1loSbd26IfZlBMy7U9J6coMx8nesCxRIensIAP+B4nf/GGfnj83o9R5
         wNm0QbBXKqJpQQYF1sXeMDatiY74fKTYpw1T55pjBAgbmGVi81kS4c4FRetXi4iFhBRx
         CMYc756IAOcxwFuxtw7+nFhzDn8HL5Qo51boFDP9nj2i9awBdpGzJ3PGgms9ZF9vbxi4
         ZEdg==
X-Gm-Message-State: AJIora8K+PIfrCXzGPT2JuVRKlMtHHbbOuPqKRcuR7hY4drgKLbYElz3
        v9hvhJ+zWhyQoJfRx1hs6NDBdiweNYd0NjxXC92Kt7XN
X-Google-Smtp-Source: AGRyM1uDMbt0oGWcL80QGM0InpfQUCVtCl2ZY+DtmgonmMTZrXjzNCOQ9hndu1PZl7O+W/GjYQJSGA==
X-Received: by 2002:a17:90a:dc82:b0:1ea:c77d:c9a4 with SMTP id j2-20020a17090adc8200b001eac77dc9a4mr19702806pjv.197.1656690307249;
        Fri, 01 Jul 2022 08:45:07 -0700 (PDT)
Received: from sewookseo1.c.googlers.com.com (174.71.80.34.bc.googleusercontent.com. [34.80.71.174])
        by smtp.gmail.com with ESMTPSA id r20-20020a170902c7d400b001678898ad06sm15514141pla.47.2022.07.01.08.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 08:45:06 -0700 (PDT)
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
Subject: [PATCH v2] net-tcp: Find dst with sk's xfrm policy not ctl_sk
Date:   Fri,  1 Jul 2022 15:44:13 +0000
Message-Id: <20220701154413.868096-1-ssewook@gmail.com>
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

Effort: net-tcp
Cc: Maciej Żenczykowski <maze@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Sehee Lee <seheele@google.com>
Signed-off-by: Sewook Seo <sewookseo@google.com>
---
Changelog since v1:
- Remove unnecessary null check of sk at ip_output.c
  Narrow down patch scope: sending RST at SYN_SENT state
  Remove unnecessay condition to call xfrm_sk_free_policy()
  Verified at KASAN build

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
index fda811a5251f..459669f9e13f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -819,6 +819,10 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		ctl_sk->sk_priority = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_priority : sk->sk_priority;
 		transmit_time = tcp_transmit_time(sk);
+#ifdef CONFIG_XFRM
+		if (sk->sk_policy[XFRM_POLICY_OUT] && sk->sk_state == TCP_SYN_SENT)
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
index c72448ba6dc9..453452f87a7c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -952,7 +952,12 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	 * Underlying function will use this to retrieve the network
 	 * namespace
 	 */
-	dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
+#ifdef CONFIG_XFRM
+	if (sk && sk->sk_policy[XFRM_POLICY_OUT] && sk->sk_state == TCP_SYN_SENT && rst)
+		dst = ip6_dst_lookup_flow(net, sk, &fl6, NULL);  /* Get dst with sk's XFRM policy */
+	else
+#endif
+		dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(buff, dst);
 		ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL,
-- 
2.37.0.rc0.161.g10f37bed90-goog

