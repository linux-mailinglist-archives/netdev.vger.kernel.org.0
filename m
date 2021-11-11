Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB40244D752
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 14:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhKKNi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 08:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbhKKNi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 08:38:56 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73468C061766;
        Thu, 11 Nov 2021 05:36:07 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso4776040pjb.2;
        Thu, 11 Nov 2021 05:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mXQH7YYjzTqKky6WSwmjgG9rVJO6HB2r9vXGljisfm0=;
        b=AqVF7WWiJ+vakptOfG0xEYGWEW4QKOxHUYSc2w8j7c5QaAWI/lQ1xY/AX1KWxzvsM6
         /StFsI6P0hECQfKG/oOjBWjotfbQka6m5r9jdKW7VY2R/i30Vnf/Woeh53b//LBFgixb
         QWpUksL/9rkWeXiR6P94CQlqQ6t6YoqWhZ05EFsNOfpdGi+rqLJpevLitlZp2dPZu8cK
         a3bjw2D9cExK3ewp8SZtn5d66JkmwcXZaBQl8XNrdIWWRJsXPrXa0tljK+gLgzvZ+QDT
         zuzvX/rxitVdJVIX0VD0ht1cGSQXFawfzEmztD7Syims3Pl8QsRPmgc9NJqiAsXNhXze
         2Bww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mXQH7YYjzTqKky6WSwmjgG9rVJO6HB2r9vXGljisfm0=;
        b=KLYSOON9ecxebo5z5UX4Smq4mNFSLpaGdTHc9bdgU4OwqykzSBeUHttk9e4RjBf4Sl
         PR1vaRRmF3b9fE+v+wGpUsvVesJk3tsOoZqRcUBnUcFpWzvUB5fMbf8FkIapQ82jcVZT
         /113HgmGjNJ6+8HiKH7QK6NTeWo28iKx32bt4uJ/T/C5g1K0lpL4hGg1HfV+nRnjVqbV
         O9tJZjOJI4vtfdKINseFVg/IfYTUgLooLaKcg0zpys+RDJPkQd+PGkEiZuVJFMA9QLII
         uvEvS4n6KOwTbuvexOZB0b3JQSmfl3+vuR4U6SnZAkymZ+WL8K02THDY1pq4Jhd+fB11
         fU9g==
X-Gm-Message-State: AOAM5338NFg5UtWg7HCMucLKbko2H3VJbU97/iFEIwAE1CuKqs2WqbCo
        nGBBU5yyKq0Ic0HoqDGskzE=
X-Google-Smtp-Source: ABdhPJxGCZfBRNinzkntcoVuBfKKOZNWjbFOxTJHGoGHkLXkp+g6Cpx0in7vRZViN98QlDB5BFVzVQ==
X-Received: by 2002:a17:902:c204:b0:142:2441:aa26 with SMTP id 4-20020a170902c20400b001422441aa26mr8074945pll.84.1636637767023;
        Thu, 11 Nov 2021 05:36:07 -0800 (PST)
Received: from desktop.cluster.local ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id l11sm3291342pfu.129.2021.11.11.05.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 05:36:06 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, imagedong@tencent.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: snmp: add snmp tracepoint support for udp
Date:   Thu, 11 Nov 2021 21:35:30 +0800
Message-Id: <20211111133530.2156478-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211111133530.2156478-1-imagedong@tencent.com>
References: <20211111133530.2156478-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Add snmp tracepoint support for udp. Here is the new tracepoint:
/sys/kernel/debug/tracing/events/snmp/snmp_udp/

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/udp.h           | 25 +++++++++++++++++++------
 include/trace/events/snmp.h |  5 +++++
 net/core/net-traces.c       |  2 ++
 net/ipv4/udp.c              | 28 +++++++++++++++++-----------
 4 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index 909ecf447e0f..bf39793f2052 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -28,6 +28,7 @@
 #include <linux/seq_file.h>
 #include <linux/poll.h>
 #include <linux/indirect_call_wrapper.h>
+#include <trace/events/snmp.h>
 
 /**
  *	struct udp_skb_cb  -  UDP(-Lite) private variables
@@ -408,12 +409,24 @@ static inline int copy_linear_skb(struct sk_buff *skb, int len, int off,
 /*
  * 	SNMP statistics for UDP and UDP-Lite
  */
-#define UDP_INC_STATS(net, field, is_udplite)		      do { \
-	if (is_udplite) SNMP_INC_STATS((net)->mib.udplite_statistics, field);       \
-	else		SNMP_INC_STATS((net)->mib.udp_statistics, field);  }  while(0)
-#define __UDP_INC_STATS(net, field, is_udplite) 	      do { \
-	if (is_udplite) __SNMP_INC_STATS((net)->mib.udplite_statistics, field);         \
-	else		__SNMP_INC_STATS((net)->mib.udp_statistics, field);    }  while(0)
+#define UDP_INC_STATS(net, field, is_udplite)			do {	\
+	if (is_udplite) {						\
+		SNMP_INC_STATS((net)->mib.udplite_statistics, field);	\
+		TRACE_SNMP(skb, udp, field, 1);				\
+	} else {							\
+		SNMP_INC_STATS((net)->mib.udp_statistics, field);	\
+		TRACE_SNMP(skb, udplite, field, 1);			\
+	}								\
+} while (0)
+#define __UDP_INC_STATS(net, skb, field, is_udplite)		do {	\
+	if (is_udplite) {						\
+		__SNMP_INC_STATS((net)->mib.udplite_statistics, field);	\
+		TRACE_SNMP(skb, udp, field, 1);				\
+	} else {							\
+		__SNMP_INC_STATS((net)->mib.udp_statistics, field);	\
+		TRACE_SNMP(skb, udplite, field, 1);			\
+	}								\
+}  while (0)
 
 #define __UDP6_INC_STATS(net, field, is_udplite)	    do { \
 	if (is_udplite) __SNMP_INC_STATS((net)->mib.udplite_stats_in6, field);\
diff --git a/include/trace/events/snmp.h b/include/trace/events/snmp.h
index 9dbd630306dd..799a8b66b438 100644
--- a/include/trace/events/snmp.h
+++ b/include/trace/events/snmp.h
@@ -37,6 +37,11 @@ DEFINE_EVENT(snmp_template, snmp_##proto,			\
 	TP_ARGS(skb, field, val)				\
 )
 
+
+
+DEFINE_SNMP_EVENT(udp);
+DEFINE_SNMP_EVENT(udplite);
+
 #define TRACE_SNMP(skb, proto, field, val) \
 	trace_snmp_##proto(skb, field, val)
 
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index 15ff40b83ca7..c33a86bb2db3 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -62,3 +62,5 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(napi_poll);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_send_reset);
 EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_bad_csum);
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(snmp_udp);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 319dd7bbfe33..d5116971892f 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1648,9 +1648,11 @@ static struct sk_buff *__first_packet_length(struct sock *sk,
 
 	while ((skb = skb_peek(rcvq)) != NULL) {
 		if (udp_lib_checksum_complete(skb)) {
-			__UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS,
+			__UDP_INC_STATS(sock_net(sk), skb,
+					UDP_MIB_CSUMERRORS,
 					IS_UDPLITE(sk));
-			__UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS,
+			__UDP_INC_STATS(sock_net(sk), skb,
+					UDP_MIB_INERRORS,
 					IS_UDPLITE(sk));
 			atomic_inc(&sk->sk_drops);
 			__skb_unlink(skb, rcvq);
@@ -2143,7 +2145,7 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 
 			ret = encap_rcv(sk, skb);
 			if (ret <= 0) {
-				__UDP_INC_STATS(sock_net(sk),
+				__UDP_INC_STATS(sock_net(sk), skb,
 						UDP_MIB_INDATAGRAMS,
 						is_udplite);
 				return -ret;
@@ -2201,9 +2203,10 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 	return __udp_queue_rcv_skb(sk, skb);
 
 csum_error:
-	__UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS, is_udplite);
+	__UDP_INC_STATS(sock_net(sk), skb, UDP_MIB_CSUMERRORS,
+			is_udplite);
 drop:
-	__UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
+	__UDP_INC_STATS(sock_net(sk), skb, UDP_MIB_INERRORS, is_udplite);
 	atomic_inc(&sk->sk_drops);
 	kfree_skb(skb);
 	return -1;
@@ -2290,9 +2293,9 @@ static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 
 		if (unlikely(!nskb)) {
 			atomic_inc(&sk->sk_drops);
-			__UDP_INC_STATS(net, UDP_MIB_RCVBUFERRORS,
+			__UDP_INC_STATS(net, skb, UDP_MIB_RCVBUFERRORS,
 					IS_UDPLITE(sk));
-			__UDP_INC_STATS(net, UDP_MIB_INERRORS,
+			__UDP_INC_STATS(net, skb, UDP_MIB_INERRORS,
 					IS_UDPLITE(sk));
 			continue;
 		}
@@ -2311,7 +2314,7 @@ static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 			consume_skb(skb);
 	} else {
 		kfree_skb(skb);
-		__UDP_INC_STATS(net, UDP_MIB_IGNOREDMULTI,
+		__UDP_INC_STATS(net, skb, UDP_MIB_IGNOREDMULTI,
 				proto == IPPROTO_UDPLITE);
 	}
 	return 0;
@@ -2454,7 +2457,8 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	if (udp_lib_checksum_complete(skb))
 		goto csum_error;
 
-	__UDP_INC_STATS(net, UDP_MIB_NOPORTS, proto == IPPROTO_UDPLITE);
+	__UDP_INC_STATS(net, skb, UDP_MIB_NOPORTS,
+			proto == IPPROTO_UDPLITE);
 	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
 
 	/*
@@ -2481,9 +2485,11 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 			    proto == IPPROTO_UDPLITE ? "Lite" : "",
 			    &saddr, ntohs(uh->source), &daddr, ntohs(uh->dest),
 			    ulen);
-	__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS, proto == IPPROTO_UDPLITE);
+	__UDP_INC_STATS(net, skb, UDP_MIB_CSUMERRORS,
+			proto == IPPROTO_UDPLITE);
 drop:
-	__UDP_INC_STATS(net, UDP_MIB_INERRORS, proto == IPPROTO_UDPLITE);
+	__UDP_INC_STATS(net, skb, UDP_MIB_INERRORS,
+			proto == IPPROTO_UDPLITE);
 	kfree_skb(skb);
 	return 0;
 }
-- 
2.27.0

