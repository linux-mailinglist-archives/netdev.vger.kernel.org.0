Return-Path: <netdev+bounces-6194-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 796927152CE
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:06:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FAF51C20AD8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ECE77EC;
	Tue, 30 May 2023 01:06:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB75636
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:06:22 +0000 (UTC)
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130A5D9
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685408779; x=1716944779;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E77WX/6HdKZpEX0vfss39cz39lQsP1vXdU09My/mGRs=;
  b=I4u/RlB3pNkTRIuJJfxksA/mmEwlyYrvXH9HOTwDqdEHDMWz6Zn20YXK
   11cBYSjrwZU/wcThVKVqnketU59E4AZEFJliUKibFPn/lWnMSlx8Yp9QG
   tZ7QrAwHfTi3vFs81S8QuH2tf5upL5zG7UNiTQyVcKTWVdE4ccjN8+ekG
   s=;
X-IronPort-AV: E=Sophos;i="6.00,201,1681171200"; 
   d="scan'208";a="6647964"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 01:06:16 +0000
Received: from EX19MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com (Postfix) with ESMTPS id 882A3A0583;
	Tue, 30 May 2023 01:06:15 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:06:14 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:06:12 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 05/14] udp: Remove UDP-Lite SNMP stats.
Date: Mon, 29 May 2023 18:03:39 -0700
Message-ID: <20230530010348.21425-6-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230530010348.21425-1-kuniyu@amazon.com>
References: <20230530010348.21425-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.39]
X-ClientProxiedBy: EX19D046UWB004.ant.amazon.com (10.13.139.164) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We stored UDP-Lite stats in udplite_statistics and udplite_stats_in6
of struct netns_mib.

Since UDP and UDP-Lite share code, UDP_INC_STATS() always has to
check if the socket is UDP-Lite.  However, we no longer increment
UDP-Lite stats.

Let's remove the stats and save one protocol test.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/netns/mib.h |  5 ---
 include/net/udp.h       | 43 +++++++++--------------
 net/ipv4/af_inet.c      |  6 ----
 net/ipv4/proc.c         | 13 -------
 net/ipv4/udp.c          | 76 ++++++++++++++++++-----------------------
 net/ipv6/af_inet6.c     |  6 ----
 net/ipv6/proc.c         | 14 --------
 net/ipv6/udp.c          | 48 +++++++++++---------------
 8 files changed, 69 insertions(+), 142 deletions(-)

diff --git a/include/net/netns/mib.h b/include/net/netns/mib.h
index 7e373664b1e7..dce05f8e6a33 100644
--- a/include/net/netns/mib.h
+++ b/include/net/netns/mib.h
@@ -28,11 +28,6 @@ struct netns_mib {
 	DEFINE_SNMP_STAT(struct mptcp_mib, mptcp_statistics);
 #endif
 
-	DEFINE_SNMP_STAT(struct udp_mib, udplite_statistics);
-#if IS_ENABLED(CONFIG_IPV6)
-	DEFINE_SNMP_STAT(struct udp_mib, udplite_stats_in6);
-#endif
-
 	DEFINE_SNMP_STAT(struct icmp_mib, icmp_statistics);
 	DEFINE_SNMP_STAT_ATOMIC(struct icmpmsg_mib, icmpmsg_statistics);
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/include/net/udp.h b/include/net/udp.h
index bfe62e73552a..d00509873f6f 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -390,37 +390,28 @@ static inline int copy_linear_skb(struct sk_buff *skb, int len, int off,
 }
 
 /*
- * 	SNMP statistics for UDP and UDP-Lite
+ * 	SNMP statistics for UDP
  */
-#define UDP_INC_STATS(net, field, is_udplite)		      do { \
-	if (is_udplite) SNMP_INC_STATS((net)->mib.udplite_statistics, field);       \
-	else		SNMP_INC_STATS((net)->mib.udp_statistics, field);  }  while(0)
-#define __UDP_INC_STATS(net, field, is_udplite) 	      do { \
-	if (is_udplite) __SNMP_INC_STATS((net)->mib.udplite_statistics, field);         \
-	else		__SNMP_INC_STATS((net)->mib.udp_statistics, field);    }  while(0)
-
-#define __UDP6_INC_STATS(net, field, is_udplite)	    do { \
-	if (is_udplite) __SNMP_INC_STATS((net)->mib.udplite_stats_in6, field);\
-	else		__SNMP_INC_STATS((net)->mib.udp_stats_in6, field);  \
-} while(0)
-#define UDP6_INC_STATS(net, field, __lite)		    do { \
-	if (__lite) SNMP_INC_STATS((net)->mib.udplite_stats_in6, field);  \
-	else	    SNMP_INC_STATS((net)->mib.udp_stats_in6, field);      \
-} while(0)
+#define __UDP_INC_STATS(net, field)				\
+	__SNMP_INC_STATS((net)->mib.udp_statistics, field)
+#define UDP_INC_STATS(net, field)				\
+	SNMP_INC_STATS((net)->mib.udp_statistics, field)
+
+#define __UDP6_INC_STATS(net, field)				\
+	__SNMP_INC_STATS((net)->mib.udp_stats_in6, field)
+#define UDP6_INC_STATS(net, field)				\
+	SNMP_INC_STATS((net)->mib.udp_stats_in6, field)
 
 #if IS_ENABLED(CONFIG_IPV6)
-#define __UDPX_MIB(sk, ipv4)						\
-({									\
-	ipv4 ? (IS_UDPLITE(sk) ? sock_net(sk)->mib.udplite_statistics :	\
-				 sock_net(sk)->mib.udp_statistics) :	\
-		(IS_UDPLITE(sk) ? sock_net(sk)->mib.udplite_stats_in6 :	\
-				 sock_net(sk)->mib.udp_stats_in6);	\
+#define __UDPX_MIB(sk, ipv4)				\
+({							\
+	ipv4 ? sock_net(sk)->mib.udp_statistics :	\
+		sock_net(sk)->mib.udp_stats_in6;	\
 })
 #else
-#define __UDPX_MIB(sk, ipv4)						\
-({									\
-	IS_UDPLITE(sk) ? sock_net(sk)->mib.udplite_statistics :		\
-			 sock_net(sk)->mib.udp_statistics;		\
+#define __UDPX_MIB(sk, ipv4)				\
+({							\
+	sock_net(sk)->mib.udp_statistics;		\
 })
 #endif
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index bf9fdce5bd05..332a01ffd550 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1769,9 +1769,6 @@ static __net_init int ipv4_mib_init_net(struct net *net)
 	net->mib.udp_statistics = alloc_percpu(struct udp_mib);
 	if (!net->mib.udp_statistics)
 		goto err_udp_mib;
-	net->mib.udplite_statistics = alloc_percpu(struct udp_mib);
-	if (!net->mib.udplite_statistics)
-		goto err_udplite_mib;
 	net->mib.icmp_statistics = alloc_percpu(struct icmp_mib);
 	if (!net->mib.icmp_statistics)
 		goto err_icmp_mib;
@@ -1786,8 +1783,6 @@ static __net_init int ipv4_mib_init_net(struct net *net)
 err_icmpmsg_mib:
 	free_percpu(net->mib.icmp_statistics);
 err_icmp_mib:
-	free_percpu(net->mib.udplite_statistics);
-err_udplite_mib:
 	free_percpu(net->mib.udp_statistics);
 err_udp_mib:
 	free_percpu(net->mib.net_statistics);
@@ -1803,7 +1798,6 @@ static __net_exit void ipv4_mib_exit_net(struct net *net)
 {
 	kfree(net->mib.icmpmsg_statistics);
 	free_percpu(net->mib.icmp_statistics);
-	free_percpu(net->mib.udplite_statistics);
 	free_percpu(net->mib.udp_statistics);
 	free_percpu(net->mib.net_statistics);
 	free_percpu(net->mib.ip_statistics);
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 7cf33b1763ed..d27e92fc45c1 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -34,7 +34,6 @@
 #include <net/tcp.h>
 #include <net/mptcp.h>
 #include <net/udp.h>
-#include <net/udplite.h>
 #include <linux/bottom_half.h>
 #include <linux/inetdevice.h>
 #include <linux/proc_fs.h>
@@ -434,18 +433,6 @@ static int snmp_seq_show_tcp_udp(struct seq_file *seq, void *v)
 	for (i = 0; snmp4_udp_list[i].name; i++)
 		seq_printf(seq, " %lu", buff[i]);
 
-	memset(buff, 0, TCPUDP_MIB_MAX * sizeof(unsigned long));
-
-	/* the UDP and UDP-Lite MIBs are the same */
-	seq_puts(seq, "\nUdpLite:");
-	snmp_get_cpu_field_batch(buff, snmp4_udp_list,
-				 net->mib.udplite_statistics);
-	for (i = 0; snmp4_udp_list[i].name; i++)
-		seq_printf(seq, " %s", snmp4_udp_list[i].name);
-	seq_puts(seq, "\nUdpLite:");
-	for (i = 0; snmp4_udp_list[i].name; i++)
-		seq_printf(seq, " %lu", buff[i]);
-
 	seq_putc(seq, '\n');
 	return 0;
 }
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 2e966ce4a41b..9d836604562a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -981,13 +981,13 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
 	err = ip_send_skb(sock_net(sk), skb);
 	if (err) {
 		if (err == -ENOBUFS && !inet->recverr) {
-			UDP_INC_STATS(sock_net(sk),
-				      UDP_MIB_SNDBUFERRORS, is_udplite);
+			UDP_INC_STATS(sock_net(sk), UDP_MIB_SNDBUFERRORS);
 			err = 0;
 		}
-	} else
-		UDP_INC_STATS(sock_net(sk),
-			      UDP_MIB_OUTDATAGRAMS, is_udplite);
+	} else {
+		UDP_INC_STATS(sock_net(sk), UDP_MIB_OUTDATAGRAMS);
+	}
+
 	return err;
 }
 
@@ -1313,10 +1313,9 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	 * things).  We could add another new stat but at least for now that
 	 * seems like overkill.
 	 */
-	if (err == -ENOBUFS || test_bit(SOCK_NOSPACE, &sk->sk_socket->flags)) {
-		UDP_INC_STATS(sock_net(sk),
-			      UDP_MIB_SNDBUFERRORS, is_udplite);
-	}
+	if (err == -ENOBUFS || test_bit(SOCK_NOSPACE, &sk->sk_socket->flags))
+		UDP_INC_STATS(sock_net(sk), UDP_MIB_SNDBUFERRORS);
+
 	return err;
 
 do_confirm:
@@ -1630,10 +1629,10 @@ static struct sk_buff *__first_packet_length(struct sock *sk,
 
 	while ((skb = skb_peek(rcvq)) != NULL) {
 		if (udp_lib_checksum_complete(skb)) {
-			__UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS,
-					IS_UDPLITE(sk));
-			__UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS,
-					IS_UDPLITE(sk));
+			struct net *net = sock_net(sk);
+
+			__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS);
+			__UDP_INC_STATS(net, UDP_MIB_INERRORS);
 			atomic_inc(&sk->sk_drops);
 			__skb_unlink(skb, rcvq);
 			*total += skb->truesize;
@@ -1787,11 +1786,10 @@ int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 		return err;
 
 	if (udp_lib_checksum_complete(skb)) {
-		int is_udplite = IS_UDPLITE(sk);
 		struct net *net = sock_net(sk);
 
-		__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS, is_udplite);
-		__UDP_INC_STATS(net, UDP_MIB_INERRORS, is_udplite);
+		__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS);
+		__UDP_INC_STATS(net, UDP_MIB_INERRORS);
 		atomic_inc(&sk->sk_drops);
 		kfree_skb(skb);
 		goto try_again;
@@ -1814,6 +1812,7 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 	int off, err, peeking = flags & MSG_PEEK;
 	struct inet_sock *inet = inet_sk(sk);
 	int is_udplite = IS_UDPLITE(sk);
+	struct net *net = sock_net(sk);
 	bool checksum_valid = false;
 	unsigned int ulen, copied;
 	struct sk_buff *skb;
@@ -1863,16 +1862,14 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 	if (unlikely(err)) {
 		if (!peeking) {
 			atomic_inc(&sk->sk_drops);
-			UDP_INC_STATS(sock_net(sk),
-				      UDP_MIB_INERRORS, is_udplite);
+			UDP_INC_STATS(net, UDP_MIB_INERRORS);
 		}
 		kfree_skb(skb);
 		return err;
 	}
 
 	if (!peeking)
-		UDP_INC_STATS(sock_net(sk),
-			      UDP_MIB_INDATAGRAMS, is_udplite);
+		UDP_INC_STATS(net, UDP_MIB_INDATAGRAMS);
 
 	sock_recv_cmsgs(msg, sk, skb);
 
@@ -1904,8 +1901,8 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 csum_copy_err:
 	if (!__sk_queue_drop_skb(sk, &udp_sk(sk)->reader_queue, skb, flags,
 				 udp_skb_destructor)) {
-		UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS, is_udplite);
-		UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
+		UDP_INC_STATS(net, UDP_MIB_CSUMERRORS);
+		UDP_INC_STATS(net, UDP_MIB_INERRORS);
 	}
 	kfree_skb(skb);
 
@@ -2056,20 +2053,18 @@ static int __udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 
 	rc = __udp_enqueue_schedule_skb(sk, skb);
 	if (rc < 0) {
-		int is_udplite = IS_UDPLITE(sk);
+		struct net *net = sock_net(sk);
 		int drop_reason;
 
 		/* Note that an ENOMEM error is charged twice */
 		if (rc == -ENOMEM) {
-			UDP_INC_STATS(sock_net(sk), UDP_MIB_RCVBUFERRORS,
-					is_udplite);
+			UDP_INC_STATS(net, UDP_MIB_RCVBUFERRORS);
 			drop_reason = SKB_DROP_REASON_SOCKET_RCVBUFF;
 		} else {
-			UDP_INC_STATS(sock_net(sk), UDP_MIB_MEMERRORS,
-				      is_udplite);
+			UDP_INC_STATS(net, UDP_MIB_MEMERRORS);
 			drop_reason = SKB_DROP_REASON_PROTO_MEM;
 		}
-		UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
+		UDP_INC_STATS(net, UDP_MIB_INERRORS);
 		kfree_skb_reason(skb, drop_reason);
 		trace_udp_fail_queue_rcv_skb(rc, sk);
 		return -1;
@@ -2090,7 +2085,7 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 {
 	int drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	struct udp_sock *up = udp_sk(sk);
-	int is_udplite = IS_UDPLITE(sk);
+	struct net *net = sock_net(sk);
 
 	/*
 	 *	Charge it to the socket, dropping if the queue is full.
@@ -2126,9 +2121,7 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 
 			ret = encap_rcv(sk, skb);
 			if (ret <= 0) {
-				__UDP_INC_STATS(sock_net(sk),
-						UDP_MIB_INDATAGRAMS,
-						is_udplite);
+				__UDP_INC_STATS(net, UDP_MIB_INDATAGRAMS);
 				return -ret;
 			}
 		}
@@ -2187,9 +2180,9 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 
 csum_error:
 	drop_reason = SKB_DROP_REASON_UDP_CSUM;
-	__UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS, is_udplite);
+	__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS);
 drop:
-	__UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
+	__UDP_INC_STATS(net, UDP_MIB_INERRORS);
 	atomic_inc(&sk->sk_drops);
 	kfree_skb_reason(skb, drop_reason);
 	return -1;
@@ -2279,10 +2272,8 @@ static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 
 		if (unlikely(!nskb)) {
 			atomic_inc(&sk->sk_drops);
-			__UDP_INC_STATS(net, UDP_MIB_RCVBUFERRORS,
-					IS_UDPLITE(sk));
-			__UDP_INC_STATS(net, UDP_MIB_INERRORS,
-					IS_UDPLITE(sk));
+			__UDP_INC_STATS(net, UDP_MIB_RCVBUFERRORS);
+			__UDP_INC_STATS(net, UDP_MIB_INERRORS);
 			continue;
 		}
 		if (udp_queue_rcv_skb(sk, nskb) > 0)
@@ -2300,8 +2291,7 @@ static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 			consume_skb(skb);
 	} else {
 		kfree_skb(skb);
-		__UDP_INC_STATS(net, UDP_MIB_IGNOREDMULTI,
-				proto == IPPROTO_UDPLITE);
+		__UDP_INC_STATS(net, UDP_MIB_IGNOREDMULTI);
 	}
 	return 0;
 }
@@ -2447,7 +2437,7 @@ static int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 		goto csum_error;
 
 	drop_reason = SKB_DROP_REASON_NO_SOCKET;
-	__UDP_INC_STATS(net, UDP_MIB_NOPORTS, proto == IPPROTO_UDPLITE);
+	__UDP_INC_STATS(net, UDP_MIB_NOPORTS);
 	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
 
 	/*
@@ -2476,9 +2466,9 @@ static int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 			    proto == IPPROTO_UDPLITE ? "Lite" : "",
 			    &saddr, ntohs(uh->source), &daddr, ntohs(uh->dest),
 			    ulen);
-	__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS, proto == IPPROTO_UDPLITE);
+	__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS);
 drop:
-	__UDP_INC_STATS(net, UDP_MIB_INERRORS, proto == IPPROTO_UDPLITE);
+	__UDP_INC_STATS(net, UDP_MIB_INERRORS);
 	kfree_skb_reason(skb, drop_reason);
 	return 0;
 }
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index ca360680fae0..16df217be69d 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -899,9 +899,6 @@ static int __net_init ipv6_init_mibs(struct net *net)
 	net->mib.udp_stats_in6 = alloc_percpu(struct udp_mib);
 	if (!net->mib.udp_stats_in6)
 		return -ENOMEM;
-	net->mib.udplite_stats_in6 = alloc_percpu(struct udp_mib);
-	if (!net->mib.udplite_stats_in6)
-		goto err_udplite_mib;
 	net->mib.ipv6_statistics = alloc_percpu(struct ipstats_mib);
 	if (!net->mib.ipv6_statistics)
 		goto err_ip_mib;
@@ -927,8 +924,6 @@ static int __net_init ipv6_init_mibs(struct net *net)
 err_icmp_mib:
 	free_percpu(net->mib.ipv6_statistics);
 err_ip_mib:
-	free_percpu(net->mib.udplite_stats_in6);
-err_udplite_mib:
 	free_percpu(net->mib.udp_stats_in6);
 	return -ENOMEM;
 }
@@ -936,7 +931,6 @@ static int __net_init ipv6_init_mibs(struct net *net)
 static void ipv6_cleanup_mibs(struct net *net)
 {
 	free_percpu(net->mib.udp_stats_in6);
-	free_percpu(net->mib.udplite_stats_in6);
 	free_percpu(net->mib.ipv6_statistics);
 	free_percpu(net->mib.icmpv6_statistics);
 	kfree(net->mib.icmpv6msg_statistics);
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index 91bcd4525494..5b431057969c 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -129,18 +129,6 @@ static const struct snmp_mib snmp6_udp6_list[] = {
 	SNMP_MIB_SENTINEL
 };
 
-static const struct snmp_mib snmp6_udplite6_list[] = {
-	SNMP_MIB_ITEM("UdpLite6InDatagrams", UDP_MIB_INDATAGRAMS),
-	SNMP_MIB_ITEM("UdpLite6NoPorts", UDP_MIB_NOPORTS),
-	SNMP_MIB_ITEM("UdpLite6InErrors", UDP_MIB_INERRORS),
-	SNMP_MIB_ITEM("UdpLite6OutDatagrams", UDP_MIB_OUTDATAGRAMS),
-	SNMP_MIB_ITEM("UdpLite6RcvbufErrors", UDP_MIB_RCVBUFERRORS),
-	SNMP_MIB_ITEM("UdpLite6SndbufErrors", UDP_MIB_SNDBUFERRORS),
-	SNMP_MIB_ITEM("UdpLite6InCsumErrors", UDP_MIB_CSUMERRORS),
-	SNMP_MIB_ITEM("UdpLite6MemErrors", UDP_MIB_MEMERRORS),
-	SNMP_MIB_SENTINEL
-};
-
 static void snmp6_seq_show_icmpv6msg(struct seq_file *seq, atomic_long_t *smib)
 {
 	char name[32];
@@ -222,8 +210,6 @@ static int snmp6_seq_show(struct seq_file *seq, void *v)
 	snmp6_seq_show_icmpv6msg(seq, net->mib.icmpv6msg_statistics->mibs);
 	snmp6_seq_show_item(seq, net->mib.udp_stats_in6,
 			    NULL, snmp6_udp6_list);
-	snmp6_seq_show_item(seq, net->mib.udplite_stats_in6,
-			    NULL, snmp6_udplite6_list);
 	return 0;
 }
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index bc3f7ac8c28a..161686aa0dbe 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -666,20 +666,18 @@ static int __udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 
 	rc = __udp_enqueue_schedule_skb(sk, skb);
 	if (rc < 0) {
-		int is_udplite = IS_UDPLITE(sk);
 		enum skb_drop_reason drop_reason;
+		struct net *net = sock_net(sk);
 
 		/* Note that an ENOMEM error is charged twice */
 		if (rc == -ENOMEM) {
-			UDP6_INC_STATS(sock_net(sk),
-					 UDP_MIB_RCVBUFERRORS, is_udplite);
+			UDP6_INC_STATS(net, UDP_MIB_RCVBUFERRORS);
 			drop_reason = SKB_DROP_REASON_SOCKET_RCVBUFF;
 		} else {
-			UDP6_INC_STATS(sock_net(sk),
-				       UDP_MIB_MEMERRORS, is_udplite);
+			UDP6_INC_STATS(net, UDP_MIB_MEMERRORS);
 			drop_reason = SKB_DROP_REASON_PROTO_MEM;
 		}
-		UDP6_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
+		UDP6_INC_STATS(net, UDP_MIB_INERRORS);
 		kfree_skb_reason(skb, drop_reason);
 		return -1;
 	}
@@ -699,7 +697,7 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 {
 	enum skb_drop_reason drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	struct udp_sock *up = udp_sk(sk);
-	int is_udplite = IS_UDPLITE(sk);
+	struct net *net = sock_net(sk);
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb)) {
 		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
@@ -732,9 +730,7 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 
 			ret = encap_rcv(sk, skb);
 			if (ret <= 0) {
-				__UDP6_INC_STATS(sock_net(sk),
-						 UDP_MIB_INDATAGRAMS,
-						 is_udplite);
+				__UDP6_INC_STATS(net, UDP_MIB_INDATAGRAMS);
 				return -ret;
 			}
 		}
@@ -777,9 +773,9 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 
 csum_error:
 	drop_reason = SKB_DROP_REASON_UDP_CSUM;
-	__UDP6_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS, is_udplite);
+	__UDP6_INC_STATS(net, UDP_MIB_CSUMERRORS);
 drop:
-	__UDP6_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
+	__UDP6_INC_STATS(net, UDP_MIB_INERRORS);
 	atomic_inc(&sk->sk_drops);
 	kfree_skb_reason(skb, drop_reason);
 	return -1;
@@ -889,10 +885,8 @@ static int __udp6_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 		nskb = skb_clone(skb, GFP_ATOMIC);
 		if (unlikely(!nskb)) {
 			atomic_inc(&sk->sk_drops);
-			__UDP6_INC_STATS(net, UDP_MIB_RCVBUFERRORS,
-					 IS_UDPLITE(sk));
-			__UDP6_INC_STATS(net, UDP_MIB_INERRORS,
-					 IS_UDPLITE(sk));
+			__UDP6_INC_STATS(net, UDP_MIB_RCVBUFERRORS);
+			__UDP6_INC_STATS(net, UDP_MIB_INERRORS);
 			continue;
 		}
 
@@ -911,8 +905,7 @@ static int __udp6_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 			consume_skb(skb);
 	} else {
 		kfree_skb(skb);
-		__UDP6_INC_STATS(net, UDP_MIB_IGNOREDMULTI,
-				 proto == IPPROTO_UDPLITE);
+		__UDP6_INC_STATS(net, UDP_MIB_IGNOREDMULTI);
 	}
 	return 0;
 }
@@ -1037,7 +1030,7 @@ static int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	if (udp_lib_checksum_complete(skb))
 		goto csum_error;
 
-	__UDP6_INC_STATS(net, UDP_MIB_NOPORTS, proto == IPPROTO_UDPLITE);
+	__UDP6_INC_STATS(net, UDP_MIB_NOPORTS);
 	icmpv6_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_PORT_UNREACH, 0);
 
 	kfree_skb_reason(skb, reason);
@@ -1058,9 +1051,9 @@ static int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 csum_error:
 	if (reason == SKB_DROP_REASON_NOT_SPECIFIED)
 		reason = SKB_DROP_REASON_UDP_CSUM;
-	__UDP6_INC_STATS(net, UDP_MIB_CSUMERRORS, proto == IPPROTO_UDPLITE);
+	__UDP6_INC_STATS(net, UDP_MIB_CSUMERRORS);
 discard:
-	__UDP6_INC_STATS(net, UDP_MIB_INERRORS, proto == IPPROTO_UDPLITE);
+	__UDP6_INC_STATS(net, UDP_MIB_INERRORS);
 	kfree_skb_reason(skb, reason);
 	return 0;
 }
@@ -1300,13 +1293,11 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 	err = ip6_send_skb(skb);
 	if (err) {
 		if (err == -ENOBUFS && !inet6_sk(sk)->recverr) {
-			UDP6_INC_STATS(sock_net(sk),
-				       UDP_MIB_SNDBUFERRORS, is_udplite);
+			UDP6_INC_STATS(sock_net(sk), UDP_MIB_SNDBUFERRORS);
 			err = 0;
 		}
 	} else {
-		UDP6_INC_STATS(sock_net(sk),
-			       UDP_MIB_OUTDATAGRAMS, is_udplite);
+		UDP6_INC_STATS(sock_net(sk), UDP_MIB_OUTDATAGRAMS);
 	}
 	return err;
 }
@@ -1644,10 +1635,9 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	 * things).  We could add another new stat but at least for now that
 	 * seems like overkill.
 	 */
-	if (err == -ENOBUFS || test_bit(SOCK_NOSPACE, &sk->sk_socket->flags)) {
-		UDP6_INC_STATS(sock_net(sk),
-			       UDP_MIB_SNDBUFERRORS, is_udplite);
-	}
+	if (err == -ENOBUFS || test_bit(SOCK_NOSPACE, &sk->sk_socket->flags))
+		UDP6_INC_STATS(sock_net(sk), UDP_MIB_SNDBUFERRORS);
+
 	return err;
 
 do_confirm:
-- 
2.30.2


