Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3521569F0B
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 12:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbiGGKCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 06:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233004AbiGGKCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 06:02:13 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB144F1AE
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 03:02:12 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id g4so17589846pgc.1
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 03:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G8LqfIwmX0KVqykESRh2eYWw/y6SCPPm5x+a8wmY5Qg=;
        b=mFgVMmZZeaBzSub0zx1+ptEqxUuzvF5ngkk+vYSJHNBAtrm2bjvmFtq0FFfkyUxZ34
         Wc/IS84uL86iZXrj+D0GI94HMCARKr1kPDBmizHPDw73wWCx5nE7NEvW2hUSKtk2bEAW
         ghxQMXqlx70HgwWCDrAjwYWCzye3ORi1SiQenbWpb4ZkUN3862g/0huU7YqZaBjczcvD
         96XhBHYV+oeWL0eyiXzrPXopD9kkOimSLYcmpKgfLviea6G012V47vTDw0rnGjX80i1n
         fwx56hlSqk7gnHQAZtXRBRC6nioDit1cfVGmDCMLrk6BkZY1Rh+UKZwTVxn8I8R+b/m0
         aRbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G8LqfIwmX0KVqykESRh2eYWw/y6SCPPm5x+a8wmY5Qg=;
        b=2fdbFwT8sAdnQosCC96ZPnfiE+UE6J19GD2snXYrHF8fC7YhLXlf4cr00QPM3mIh/I
         sXTE3nWyZZJqB1NEhi78WCBGjPWKQY2WTrADnYhgjAEb/dfGOD8I7RldrP94d73syPly
         LD2CU0hPxg+5b/JsSsO3ifKzGZIIO6W0zQN+z7DFFRl3zUozFsS+KIkgU32oBelJWSeq
         UXYMePuVFJodBAZ4O1BR4sN6IrSPegaIgnfPJSBJRAg+AOQFp4ewSADsMiE5JZbDgmEp
         7Ea3Gnv7mZJAwVJQM70mGelhDu9DaQesPAQMH8lUi2nQpvqUBsQ5fJpmzpR2vq3ShkfL
         qEIA==
X-Gm-Message-State: AJIora+sZthhWhSh4msWfESamHIbRYb3jtKD/LbFMaZB5+ZHZW0swgtH
        LZxHXrpV9hd427yQ+nPqS7c=
X-Google-Smtp-Source: AGRyM1sIrfAA3StQFQs483RRK/cGThJqhe+aoy9qbqQur33Z3PyXw0elLtJcu25GNbHFvr3Vz+LGIw==
X-Received: by 2002:a17:90b:17c6:b0:1ec:dcc8:370a with SMTP id me6-20020a17090b17c600b001ecdcc8370amr4073205pjb.63.1657188131966;
        Thu, 07 Jul 2022 03:02:11 -0700 (PDT)
Received: from sewookseo1.c.googlers.com.com (174.71.80.34.bc.googleusercontent.com. [34.80.71.174])
        by smtp.gmail.com with ESMTPSA id z15-20020a6553cf000000b003fadd680908sm25626986pgr.83.2022.07.07.03.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 03:02:11 -0700 (PDT)
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
Subject: [PATCH v5 net-next] net: Find dst with sk's xfrm policy not ctl_sk
Date:   Thu,  7 Jul 2022 10:01:39 +0000
Message-Id: <20220707100139.3748417-1-ssewook@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220707054008.3471371-1-ssewook@gmail.com>
References: <20220707054008.3471371-1-ssewook@gmail.com>
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
Changelog since v4:
- tcp_ipv6.c Using net instead of sock_net(ctl_sk) for consistency.

Changelog since v3:
- avoid to use ifdef directives for CONFIG_XFRM

Changelog since v2:
- condition check with sk_fullsock() instead of SYN_SENT state

Changelog since v1:
- Remove unnecessary null check of sk at ip_output.c
  Narrow down patch scope: sending RST at SYN_SENT state
  Remove unnecessay condition to call xfrm_sk_free_policy()
---

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
index c72448ba6dc9..70d4890d8d2f 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -952,7 +952,10 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	 * Underlying function will use this to retrieve the network
 	 * namespace
 	 */
-	dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
+	if (sk && sk->sk_state != TCP_TIME_WAIT)
+		dst = ip6_dst_lookup_flow(net, sk, &fl6, NULL); /*sk's xfrm_policy can be referred*/
+	else
+		dst = ip6_dst_lookup_flow(net, ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(buff, dst);
 		ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL,
-- 
2.37.0.rc0.161.g10f37bed90-goog

