Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA80507E82
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 04:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358762AbiDTCCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 22:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346534AbiDTCCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 22:02:54 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C1D12AB1
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 19:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1650420011; x=1681956011;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mPrvkXb+oTlueEMRt8wnMQ48MQqiKwjV/Z7MeVuZJ5g=;
  b=i+2dGykdUDmYmOYSqT8aWRVxPvHNV0ngnehA+0k8rF9sMiK1GSFzodoI
   kLP2MaRm+ph2Sl/hay9guwqFwFZ3JDC2xcL2ItdV2F3oYasFHMTUMg7no
   UQ+RbeVPMWbzF1LOJH90OkGCEAIJ+JSdBXrYZsgkm8CJEWf41Oxndse2o
   4=;
X-IronPort-AV: E=Sophos;i="5.90,274,1643673600"; 
   d="scan'208";a="81167947"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-22c2b493.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 20 Apr 2022 02:00:10 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-22c2b493.us-west-2.amazon.com (Postfix) with ESMTPS id 4D0004102A;
        Wed, 20 Apr 2022 02:00:09 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Wed, 20 Apr 2022 02:00:06 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.236) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Wed, 20 Apr 2022 02:00:03 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 1/2] ipv6: Remove __ipv6_only_sock().
Date:   Wed, 20 Apr 2022 10:58:50 +0900
Message-ID: <20220420015851.50237-2-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220420015851.50237-1-kuniyu@amazon.co.jp>
References: <20220420015851.50237-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.236]
X-ClientProxiedBy: EX13D49UWB001.ant.amazon.com (10.43.163.72) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 9fe516ba3fb2 ("inet: move ipv6only in sock_common"),
ipv6_only_sock() and __ipv6_only_sock() are the same macro.  Let's
remove the one.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/linux/ipv6.h | 4 +---
 net/dccp/ipv6.c      | 2 +-
 net/ipv6/datagram.c  | 4 ++--
 net/ipv6/tcp_ipv6.c  | 2 +-
 net/ipv6/udp.c       | 4 ++--
 net/sctp/ipv6.c      | 4 ++--
 6 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 918bfea4ef5f..ec5ca392eaa3 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -340,8 +340,7 @@ static inline struct raw6_sock *raw6_sk(const struct sock *sk)
 	return (struct raw6_sock *)sk;
 }
 
-#define __ipv6_only_sock(sk)	(sk->sk_ipv6only)
-#define ipv6_only_sock(sk)	(__ipv6_only_sock(sk))
+#define ipv6_only_sock(sk)	(sk->sk_ipv6only)
 #define ipv6_sk_rxinfo(sk)	((sk)->sk_family == PF_INET6 && \
 				 inet6_sk(sk)->rxopt.bits.rxinfo)
 
@@ -358,7 +357,6 @@ static inline int inet_v6_ipv6only(const struct sock *sk)
 	return ipv6_only_sock(sk);
 }
 #else
-#define __ipv6_only_sock(sk)	0
 #define ipv6_only_sock(sk)	0
 #define ipv6_sk_rxinfo(sk)	0
 
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index eab3bd1ee9a0..4d95b6400915 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -892,7 +892,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 		SOCK_DEBUG(sk, "connect: ipv4 mapped\n");
 
-		if (__ipv6_only_sock(sk))
+		if (ipv6_only_sock(sk))
 			return -ENETUNREACH;
 
 		sin.sin_family = AF_INET;
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 206f66310a88..39b2327edc4e 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -145,7 +145,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 	int			err;
 
 	if (usin->sin6_family == AF_INET) {
-		if (__ipv6_only_sock(sk))
+		if (ipv6_only_sock(sk))
 			return -EAFNOSUPPORT;
 		err = __ip4_datagram_connect(sk, uaddr, addr_len);
 		goto ipv4_connected;
@@ -178,7 +178,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 	if (addr_type & IPV6_ADDR_MAPPED) {
 		struct sockaddr_in sin;
 
-		if (__ipv6_only_sock(sk)) {
+		if (ipv6_only_sock(sk)) {
 			err = -ENETUNREACH;
 			goto out;
 		}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 782df529ff69..54277de7474b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -230,7 +230,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 		u32 exthdrlen = icsk->icsk_ext_hdr_len;
 		struct sockaddr_in sin;
 
-		if (__ipv6_only_sock(sk))
+		if (ipv6_only_sock(sk))
 			return -ENETUNREACH;
 
 		sin.sin_family = AF_INET;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index db9449b52dbe..688af6f809fe 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1123,7 +1123,7 @@ static int udpv6_pre_connect(struct sock *sk, struct sockaddr *uaddr,
 	 * bytes that are out of the bound specified by user in addr_len.
 	 */
 	if (uaddr->sa_family == AF_INET) {
-		if (__ipv6_only_sock(sk))
+		if (ipv6_only_sock(sk))
 			return -EAFNOSUPPORT;
 		return udp_pre_connect(sk, uaddr, addr_len);
 	}
@@ -1359,7 +1359,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			msg->msg_name = &sin;
 			msg->msg_namelen = sizeof(sin);
 do_udp_sendmsg:
-			if (__ipv6_only_sock(sk))
+			if (ipv6_only_sock(sk))
 				return -ENETUNREACH;
 			return udp_sendmsg(sk, msg, len);
 		}
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 470dbdc27d58..d081858c2d07 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -926,7 +926,7 @@ static int sctp_inet6_af_supported(sa_family_t family, struct sctp_sock *sp)
 		return 1;
 	/* v4-mapped-v6 addresses */
 	case AF_INET:
-		if (!__ipv6_only_sock(sctp_opt2sk(sp)))
+		if (!ipv6_only_sock(sctp_opt2sk(sp)))
 			return 1;
 		fallthrough;
 	default:
@@ -952,7 +952,7 @@ static int sctp_inet6_cmp_addr(const union sctp_addr *addr1,
 		return 0;
 
 	/* If the socket is IPv6 only, v4 addrs will not match */
-	if (__ipv6_only_sock(sk) && af1 != af2)
+	if (ipv6_only_sock(sk) && af1 != af2)
 		return 0;
 
 	/* Today, wildcard AF_INET/AF_INET6. */
-- 
2.30.2

