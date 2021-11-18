Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF8E455BDD
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 13:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344859AbhKRMwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 07:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244060AbhKRMv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 07:51:59 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD62C061200;
        Thu, 18 Nov 2021 04:48:41 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id u11so5151345plf.3;
        Thu, 18 Nov 2021 04:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ksWSGJgeVNus0Ooytt9o/CsyB2300W+L01WiAzLLh2c=;
        b=XGKT2t+CF9UWugQ5eGgQWulZA3YZspw9sydRG1jnBqMgdzMfnVxupNQ0/jBaBlmqiB
         42fKBj3zuZ0iO981eJnTriYA8diM9lMy94Yi9nFGiWVQD2X24yvGX4TVpUspoiLuQhpn
         e0HwblkwFfQDU8WYRC3BaFFeiF94ky1e+/tgrhnFhPe8BaGnlcmw0qi3LNI6yU33gCIy
         Dhb1YM1QSf68eS7hgatgjh15wLqc578cB2ouP9cWgV3dv4F3zb2FrveC6jhc7YDzK2I6
         wCbi4YgVm5sM3vjUrzat5BjTgxxI76yjdd4ISVNXRK2pELiLlfmhYBUxY9lTrEDPy50C
         pMUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ksWSGJgeVNus0Ooytt9o/CsyB2300W+L01WiAzLLh2c=;
        b=rEF6XU4jhu8D9hduj2eRzdudd47vEewoyo/lGjxp19QueSZI4EtnGwRCPpBHkHeBY+
         ncuLhjnuEZOBrIVIjKMYFnllWlsjosvoawfS1fQNAXk2+DcfnOKmCJ5L5rasfuJw5yTd
         7jXprTI7GCHeeM/IDdmzZPgiKXu4avzvTFX2jB16VzI85UHzYTAG54PD+2KundgUHTK8
         x7vSqAxXLLfTwu6UdiayznxuUf9eLwNlZmYvPuj0jO5PhfVAqIR0CrTVMMIxaPGtEjlT
         OxhgUqR0yHxDQ6TP7mKK1288xymvBMN6FHGeCN+Aqm1WPvp/YFVa8yzDjudVYYTwJ0kv
         Aejg==
X-Gm-Message-State: AOAM530cfWmkr3KXpzAyPRQqYBtJG9hbSRvO+PZoJZOyxIRqFkltguB4
        LZ+Nw/hyTT9ASHM5BjjAgsI=
X-Google-Smtp-Source: ABdhPJwq4N9iEx2sodE0IM5PxTgHLmb388G0DCf0P/puykZEVAyzbZB94eBGceDKvwOPMN2m6jFHhw==
X-Received: by 2002:a17:90b:1d0f:: with SMTP id on15mr10380734pjb.144.1637239721346;
        Thu, 18 Nov 2021 04:48:41 -0800 (PST)
Received: from desktop.cluster.local ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id j16sm3679404pfj.16.2021.11.18.04.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 04:48:40 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org, rostedt@goodmis.org
Cc:     davem@davemloft.net, mingo@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, imagedong@tencent.com, ycheng@google.com,
        kuniyu@amazon.co.jp, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 2/2] net: snmp: add snmp tracepoint support for udp
Date:   Thu, 18 Nov 2021 20:48:12 +0800
Message-Id: <20211118124812.106538-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211118124812.106538-1-imagedong@tencent.com>
References: <20211118124812.106538-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Add snmp tracepoint support for udp.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/udp.h | 25 +++++++++++++++++++------
 net/ipv4/udp.c    | 28 +++++++++++++++++-----------
 2 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index f1c2a88c9005..6cf11e0d75b0 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -28,6 +28,7 @@
 #include <linux/seq_file.h>
 #include <linux/poll.h>
 #include <linux/indirect_call_wrapper.h>
+#include <trace/events/snmp.h>
 
 /**
  *	struct udp_skb_cb  -  UDP(-Lite) private variables
@@ -384,12 +385,24 @@ static inline int copy_linear_skb(struct sk_buff *skb, int len, int off,
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
+		trace_snmp(skb, TRACE_MIB_UDPLITE, field, 1);				\
+	} else {							\
+		SNMP_INC_STATS((net)->mib.udp_statistics, field);	\
+		trace_snmp(skb, TRACE_MIB_UDP, field, 1);			\
+	}								\
+} while (0)
+#define __UDP_INC_STATS(net, skb, field, is_udplite)		do {	\
+	if (is_udplite) {						\
+		__SNMP_INC_STATS((net)->mib.udplite_statistics, field);	\
+		trace_snmp(skb, TRACE_MIB_UDPLITE, field, 1);				\
+	} else {							\
+		__SNMP_INC_STATS((net)->mib.udp_statistics, field);	\
+		trace_snmp(skb, TRACE_MIB_UDP, field, 1);			\
+	}								\
+}  while (0)
 
 #define __UDP6_INC_STATS(net, field, is_udplite)	    do { \
 	if (is_udplite) __SNMP_INC_STATS((net)->mib.udplite_stats_in6, field);\
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 7101e6d892d6..66ae9eea65c7 100644
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

