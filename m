Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F62E9BF6
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 14:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfJ3NAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 09:00:54 -0400
Received: from mail-eopbgr130074.outbound.protection.outlook.com ([40.107.13.74]:25287
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726124AbfJ3NAx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 09:00:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOv4f8d9cTxFM57b+fJZ/1v1UKS5Q4dlA2mpolxRr1RVPFYfY0OCo5cG6romYdVTnYtOr4E4PwG6ApYdzLLcGT+rMt6MeDXaI2hTIy9Yojpv3DbKwivBsDZmxdsBaBWuKRY9ObBEDCvgul+2MMCe1zFCOIa+nzNZlKdGr53Q2iiFE2c6USAwzQZq6a3hTUFxGP0sUKS7KLuKZ+Ut0EdWiLEux6NN8TEB67yEQsAi+sCy5t65KXuNcNnceHO8TUCeREjVTr8wn6LATnkzZG9Ct/T1F0gxmx+m9MB9XmQfIGF9Xl7OW/xLYe6HQZbzUXDRHYO6z0yPNi0+iVjMGHLn5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeoDW5QMTRMvLU3uLIrmu5/He+L9oUpmnMG0siuyJZ4=;
 b=kdMFRJvgioSTtEGeFWdqI5saFu4x5daEptdsEAysTbcd9/DXnYxFcNtLQu8YLaVTeqN7+FGFe/hCpwfVLeUVjpBmEcLmMBwvb/aW2/zNWqnrwFqKEchpRbtDB65TFB7aLCUYA29uO0OiCt6rDnBtS7MM7GqzxP06gisBWxR6bCKxgr6LY61qDSp6cT1a7icgP34VYiyMCIHS4WrzupzPqQkgKhulmoEzQOIFPpoyLz3GKBUdo5aRkSB81lUazH19YlmdKWHJ5v7SoHIehrJTBI1E2P8nkKBB74Wpxcwfu6Xj2r+XiL4m/4Lz2j4qcNDiQ+CIFsiDRTJ9x6Q385PcUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.176.1.74) smtp.rcpttodomain=davemloft.net smtp.mailfrom=ericsson.com;
 dmarc=pass (p=reject sp=none pct=100) action=none header.from=ericsson.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeoDW5QMTRMvLU3uLIrmu5/He+L9oUpmnMG0siuyJZ4=;
 b=ev0C3f8B5XQ/lHLyjIY2pWEIK4hqyUb0RPFJa6yMpAiBaYA2klWHKiy4IkFEcjWN+5FrRmREJAUcSXlDQq91FBBQq6FLR8XbFx3+oIvvy9danE+8V/ZJGj/6XRL1TR+Im8/XBMLvl2AgyeG5KhhzKdktVyusUbSoNhuXJlBmHG8=
Received: from VI1PR0701CA0053.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::15) by DB7PR07MB5077.eurprd07.prod.outlook.com
 (2603:10a6:10:59::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2387.17; Wed, 30 Oct
 2019 13:00:44 +0000
Received: from VE1EUR02FT031.eop-EUR02.prod.protection.outlook.com
 (2a01:111:f400:7e06::208) by VI1PR0701CA0053.outlook.office365.com
 (2603:10a6:800:5f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2408.10 via Frontend
 Transport; Wed, 30 Oct 2019 13:00:43 +0000
Authentication-Results: spf=pass (sender IP is 192.176.1.74)
 smtp.mailfrom=ericsson.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=ericsson.com;
Received-SPF: Pass (protection.outlook.com: domain of ericsson.com designates
 192.176.1.74 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.176.1.74; helo=oa.msg.ericsson.com;
Received: from oa.msg.ericsson.com (192.176.1.74) by
 VE1EUR02FT031.mail.protection.outlook.com (10.152.12.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.20.2387.20 via Frontend Transport; Wed, 30 Oct 2019 13:00:42 +0000
Received: from ESESSMB503.ericsson.se (153.88.183.164) by
 ESESSMR506.ericsson.se (153.88.183.128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 30 Oct 2019 14:00:41 +0100
Received: from ESESBMB501.ericsson.se (153.88.183.168) by
 ESESSMB503.ericsson.se (153.88.183.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 30 Oct 2019 14:00:41 +0100
Received: from tipsy.lab.linux.ericsson.se (153.88.183.153) by
 smtp.internal.ericsson.com (153.88.183.184) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 30 Oct 2019 14:00:41 +0100
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <tung.q.nguyen@dektech.com.au>, <hoang.h.le@dektech.com.au>,
        <jon.maloy@ericsson.com>, <lxin@redhat.com>, <shuali@redhat.com>,
        <ying.xue@windriver.com>, <edumazet@google.com>,
        <tipc-discussion@lists.sourceforge.net>
Subject: [net-next  1/1] tipc: add smart nagle feature
Date:   Wed, 30 Oct 2019 14:00:41 +0100
Message-ID: <1572440441-474-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.176.1.74;IPV:NLI;CTRY:SE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(376002)(136003)(189003)(199004)(8936002)(50466002)(478600001)(30864003)(2906002)(316002)(16586007)(26005)(14444005)(36756003)(8676002)(50226002)(110136005)(246002)(48376002)(54906003)(70206006)(106002)(305945005)(126002)(5660300002)(86362001)(7636002)(426003)(356004)(476003)(44832011)(956004)(2616005)(47776003)(336012)(70586007)(51416003)(486006)(4326008)(186003)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR07MB5077;H:oa.msg.ericsson.com;FPR:;SPF:Pass;LANG:en;PTR:office365.se.ericsson.net;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82056f1b-52f8-4409-3fca-08d75d392c1b
X-MS-TrafficTypeDiagnostic: DB7PR07MB5077:
X-LD-Processed: 92e84ceb-fbfd-47ab-be52-080c6b87953f,ExtAddr
X-Microsoft-Antispam-PRVS: <DB7PR07MB5077CDB6DEDF2D7FA3C7A42F9A600@DB7PR07MB5077.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 02065A9E77
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oHHjZFa7zMP7y8D2hUEAOMRaZKkdKseNu4+WbuXcL58t4CUPItQqpL0kPZn/IjobLQJm8sU2VqA4+ll8hxWbRcmD/2PlGBXPfdF/yxLTSjnrVXRyGzz16KHbln/k+BXORdpeYW90a45F+8vUTxf9cny0oN7YSMUWJ8jdgP8CSJCqubwcalJYp7X0wBT/iB8C3/4qGIq4j7D6MXSYZLyW9iVFuI8J2ggVlF6LlInRpS5K5TTbGrAbKMeDf8lJhEx1nrndSiB5hBNzoyFUm4X+vSrUI1ad1q5vBj7WCgbeuydc+2PoZyfs9t27czd9dEFJ8FE3hVJJxxC0U+3I2KYxxTLMol4+jHFcmrGFVpfFMhSZuUwQ947+5EHG9S/u9K2rk964m9rezUSD/kgQQFLLqCVeGOuUaPyBR1XIqkp9qk4gKDtXcgToYdd0D2j7z3wt
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2019 13:00:42.9976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82056f1b-52f8-4409-3fca-08d75d392c1b
X-MS-Exchange-CrossTenant-Id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=92e84ceb-fbfd-47ab-be52-080c6b87953f;Ip=[192.176.1.74];Helo=[oa.msg.ericsson.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR07MB5077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We introduce a feature that works like a combination of TCP_NAGLE and
TCP_CORK, but without some of the weaknesses of those. In particular,
we will not observe long delivery delays because of delayed acks, since
the algorithm itself decides if and when acks are to be sent from the
receiving peer.

- The nagle property as such is determined by manipulating a new
  'maxnagle' field in struct tipc_sock. If certain conditions are met,
  'maxnagle' will define max size of the messages which can be bundled.
  If it is set to zero no messages are ever bundled, implying that the
  nagle property is disabled.
- A socket with the nagle property enabled enters nagle mode when more
  than 4 messages have been sent out without receiving any data message
  from the peer.
- A socket leaves nagle mode whenever it receives a data message from
  the peer.

In nagle mode, messages smaller than 'maxnagle' are accumulated in the
socket write queue. The last buffer in the queue is marked with a new
'ack_required' bit, which forces the receiving peer to send a CONN_ACK
message back to the sender upon reception.

The accumulated contents of the write queue is transmitted when one of
the following events or conditions occur.

- A CONN_ACK message is received from the peer.
- A data message is received from the peer.
- A SOCK_WAKEUP pseudo message is received from the link level.
- The write queue contains more than 64 1k blocks of data.
- The connection is being shut down.
- There is no CONN_ACK message to expect. I.e., there is currently
  no outstanding message where the 'ack_required' bit was set. As a
  consequence, the first message added after we enter nagle mode
  is always sent directly with this bit set.

This new feature gives a 50-100% improvement of throughput for small
(i.e., less than MTU size) messages, while it might add up to one RTT
to latency time when the socket is in nagle mode.

Acked-by: Ying Xue <ying.xue@windreiver.com>
Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
---
 include/uapi/linux/tipc.h |   1 +
 net/tipc/msg.c            |  53 +++++++++++++++++++++
 net/tipc/msg.h            |  12 +++++
 net/tipc/node.h           |   7 ++-
 net/tipc/socket.c         | 117 +++++++++++++++++++++++++++++++++++++++-------
 5 files changed, 170 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/tipc.h b/include/uapi/linux/tipc.h
index 7df026e..76421b8 100644
--- a/include/uapi/linux/tipc.h
+++ b/include/uapi/linux/tipc.h
@@ -191,6 +191,7 @@ struct sockaddr_tipc {
 #define TIPC_GROUP_JOIN         135     /* Takes struct tipc_group_req* */
 #define TIPC_GROUP_LEAVE        136     /* No argument */
 #define TIPC_SOCK_RECVQ_USED    137     /* Default: none (read only) */
+#define TIPC_NODELAY            138     /* Default: false */
 
 /*
  * Flag values
diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 922d262..973795a 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -190,6 +190,59 @@ int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf)
 	return 0;
 }
 
+/**
+ * tipc_msg_append(): Append data to tail of an existing buffer queue
+ * @hdr: header to be used
+ * @m: the data to be appended
+ * @mss: max allowable size of buffer
+ * @dlen: size of data to be appended
+ * @txq: queue to appand to
+ * Returns the number og 1k blocks appended or errno value
+ */
+int tipc_msg_append(struct tipc_msg *_hdr, struct msghdr *m, int dlen,
+		    int mss, struct sk_buff_head *txq)
+{
+	struct sk_buff *skb, *prev;
+	int accounted, total, curr;
+	int mlen, cpy, rem = dlen;
+	struct tipc_msg *hdr;
+
+	skb = skb_peek_tail(txq);
+	accounted = skb ? msg_blocks(buf_msg(skb)) : 0;
+	total = accounted;
+
+	while (rem) {
+		if (!skb || skb->len >= mss) {
+			prev = skb;
+			skb = tipc_buf_acquire(mss, GFP_KERNEL);
+			if (unlikely(!skb))
+				return -ENOMEM;
+			skb_orphan(skb);
+			skb_trim(skb, MIN_H_SIZE);
+			hdr = buf_msg(skb);
+			skb_copy_to_linear_data(skb, _hdr, MIN_H_SIZE);
+			msg_set_hdr_sz(hdr, MIN_H_SIZE);
+			msg_set_size(hdr, MIN_H_SIZE);
+			__skb_queue_tail(txq, skb);
+			total += 1;
+			if (prev)
+				msg_set_ack_required(buf_msg(prev), 0);
+			msg_set_ack_required(hdr, 1);
+		}
+		hdr = buf_msg(skb);
+		curr = msg_blocks(hdr);
+		mlen = msg_size(hdr);
+		cpy = min_t(int, rem, mss - mlen);
+		if (cpy != copy_from_iter(skb->data + mlen, cpy, &m->msg_iter))
+			return -EFAULT;
+		msg_set_size(hdr, mlen + cpy);
+		skb_put(skb, cpy);
+		rem -= cpy;
+		total += msg_blocks(hdr) - curr;
+	}
+	return total - accounted;
+}
+
 /* tipc_msg_validate - validate basic format of received message
  *
  * This routine ensures a TIPC message has an acceptable header, and at least
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 2d7cb66..0435dda 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -290,6 +290,16 @@ static inline void msg_set_src_droppable(struct tipc_msg *m, u32 d)
 	msg_set_bits(m, 0, 18, 1, d);
 }
 
+static inline int msg_ack_required(struct tipc_msg *m)
+{
+	return msg_bits(m, 0, 18, 1);
+}
+
+static inline void msg_set_ack_required(struct tipc_msg *m, u32 d)
+{
+	msg_set_bits(m, 0, 18, 1, d);
+}
+
 static inline bool msg_is_rcast(struct tipc_msg *m)
 {
 	return msg_bits(m, 0, 18, 0x1);
@@ -1079,6 +1089,8 @@ int tipc_msg_fragment(struct sk_buff *skb, const struct tipc_msg *hdr,
 		      int pktmax, struct sk_buff_head *frags);
 int tipc_msg_build(struct tipc_msg *mhdr, struct msghdr *m,
 		   int offset, int dsz, int mtu, struct sk_buff_head *list);
+int tipc_msg_append(struct tipc_msg *hdr, struct msghdr *m, int dlen,
+		    int mss, struct sk_buff_head *txq);
 bool tipc_msg_lookup_dest(struct net *net, struct sk_buff *skb, int *err);
 bool tipc_msg_assemble(struct sk_buff_head *list);
 bool tipc_msg_reassemble(struct sk_buff_head *list, struct sk_buff_head *rcvq);
diff --git a/net/tipc/node.h b/net/tipc/node.h
index 30563c4..c39cd86 100644
--- a/net/tipc/node.h
+++ b/net/tipc/node.h
@@ -54,7 +54,8 @@ enum {
 	TIPC_LINK_PROTO_SEQNO = (1 << 6),
 	TIPC_MCAST_RBCTL      = (1 << 7),
 	TIPC_GAP_ACK_BLOCK    = (1 << 8),
-	TIPC_TUNNEL_ENHANCED  = (1 << 9)
+	TIPC_TUNNEL_ENHANCED  = (1 << 9),
+	TIPC_NAGLE            = (1 << 10)
 };
 
 #define TIPC_NODE_CAPABILITIES (TIPC_SYN_BIT           |  \
@@ -66,7 +67,9 @@ enum {
 				TIPC_LINK_PROTO_SEQNO  |   \
 				TIPC_MCAST_RBCTL       |   \
 				TIPC_GAP_ACK_BLOCK     |   \
-				TIPC_TUNNEL_ENHANCED)
+				TIPC_TUNNEL_ENHANCED   |   \
+				TIPC_NAGLE)
+
 #define INVALID_BEARER_ID -1
 
 void tipc_node_stop(struct net *net);
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 2bcacd6..3e99a12 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -75,6 +75,7 @@ struct sockaddr_pair {
  * @conn_instance: TIPC instance used when connection was established
  * @published: non-zero if port has one or more associated names
  * @max_pkt: maximum packet size "hint" used when building messages sent by port
+ * @maxnagle: maximum size of msg which can be subject to nagle
  * @portid: unique port identity in TIPC socket hash table
  * @phdr: preformatted message header used when sending messages
  * #cong_links: list of congested links
@@ -97,6 +98,7 @@ struct tipc_sock {
 	u32 conn_instance;
 	int published;
 	u32 max_pkt;
+	u32 maxnagle;
 	u32 portid;
 	struct tipc_msg phdr;
 	struct list_head cong_links;
@@ -116,6 +118,10 @@ struct tipc_sock {
 	struct tipc_mc_method mc_method;
 	struct rcu_head rcu;
 	struct tipc_group *group;
+	u32 oneway;
+	u16 snd_backlog;
+	bool expect_ack;
+	bool nodelay;
 	bool group_is_open;
 };
 
@@ -137,6 +143,7 @@ static int tipc_sk_insert(struct tipc_sock *tsk);
 static void tipc_sk_remove(struct tipc_sock *tsk);
 static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dsz);
 static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dsz);
+static void tipc_sk_push_backlog(struct tipc_sock *tsk);
 
 static const struct proto_ops packet_ops;
 static const struct proto_ops stream_ops;
@@ -227,6 +234,26 @@ static u16 tsk_inc(struct tipc_sock *tsk, int msglen)
 	return 1;
 }
 
+/* tsk_set_nagle - enable/disable nagle property by manipulating maxnagle
+ */
+static void tsk_set_nagle(struct tipc_sock *tsk)
+{
+	struct sock *sk = &tsk->sk;
+
+	tsk->maxnagle = 0;
+	if (sk->sk_type != SOCK_STREAM)
+		return;
+	if (tsk->nodelay)
+		return;
+	if (!(tsk->peer_caps & TIPC_NAGLE))
+		return;
+	/* Limit node local buffer size to avoid receive queue overflow */
+	if (tsk->max_pkt == MAX_MSG_SIZE)
+		tsk->maxnagle = 1500;
+	else
+		tsk->maxnagle = tsk->max_pkt;
+}
+
 /**
  * tsk_advance_rx_queue - discard first buffer in socket receive queue
  *
@@ -446,6 +473,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 
 	tsk = tipc_sk(sk);
 	tsk->max_pkt = MAX_PKT_DEFAULT;
+	tsk->maxnagle = 0;
 	INIT_LIST_HEAD(&tsk->publications);
 	INIT_LIST_HEAD(&tsk->cong_links);
 	msg = &tsk->phdr;
@@ -512,8 +540,12 @@ static void __tipc_shutdown(struct socket *sock, int error)
 	tipc_wait_for_cond(sock, &timeout, (!tsk->cong_link_cnt &&
 					    !tsk_conn_cong(tsk)));
 
-	/* Remove any pending SYN message */
-	__skb_queue_purge(&sk->sk_write_queue);
+	/* Push out unsent messages or remove if pending SYN */
+	skb = skb_peek(&sk->sk_write_queue);
+	if (skb && !msg_is_syn(buf_msg(skb)))
+		tipc_sk_push_backlog(tsk);
+	else
+		__skb_queue_purge(&sk->sk_write_queue);
 
 	/* Reject all unreceived messages, except on an active connection
 	 * (which disconnects locally & sends a 'FIN+' to peer).
@@ -1208,6 +1240,27 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 	tipc_sk_rcv(net, inputq);
 }
 
+/* tipc_sk_push_backlog(): send accumulated buffers in socket write queue
+ *                         when socket is in Nagle mode
+ */
+static void tipc_sk_push_backlog(struct tipc_sock *tsk)
+{
+	struct sk_buff_head *txq = &tsk->sk.sk_write_queue;
+	struct net *net = sock_net(&tsk->sk);
+	u32 dnode = tsk_peer_node(tsk);
+	int rc;
+
+	if (skb_queue_empty(txq) || tsk->cong_link_cnt)
+		return;
+
+	tsk->snt_unacked += tsk->snd_backlog;
+	tsk->snd_backlog = 0;
+	tsk->expect_ack = true;
+	rc = tipc_node_xmit(net, txq, dnode, tsk->portid);
+	if (rc == -ELINKCONG)
+		tsk->cong_link_cnt = 1;
+}
+
 /**
  * tipc_sk_conn_proto_rcv - receive a connection mng protocol message
  * @tsk: receiving socket
@@ -1221,7 +1274,7 @@ static void tipc_sk_conn_proto_rcv(struct tipc_sock *tsk, struct sk_buff *skb,
 	u32 onode = tsk_own_node(tsk);
 	struct sock *sk = &tsk->sk;
 	int mtyp = msg_type(hdr);
-	bool conn_cong;
+	bool was_cong;
 
 	/* Ignore if connection cannot be validated: */
 	if (!tsk_peer_msg(tsk, hdr)) {
@@ -1254,11 +1307,13 @@ static void tipc_sk_conn_proto_rcv(struct tipc_sock *tsk, struct sk_buff *skb,
 			__skb_queue_tail(xmitq, skb);
 		return;
 	} else if (mtyp == CONN_ACK) {
-		conn_cong = tsk_conn_cong(tsk);
+		was_cong = tsk_conn_cong(tsk);
+		tsk->expect_ack = false;
+		tipc_sk_push_backlog(tsk);
 		tsk->snt_unacked -= msg_conn_ack(hdr);
 		if (tsk->peer_caps & TIPC_BLOCK_FLOWCTL)
 			tsk->snd_win = msg_adv_win(hdr);
-		if (conn_cong)
+		if (was_cong && !tsk_conn_cong(tsk))
 			sk->sk_write_space(sk);
 	} else if (mtyp != CONN_PROBE_REPLY) {
 		pr_warn("Received unknown CONN_PROTO msg\n");
@@ -1437,15 +1492,15 @@ static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dlen)
 	struct sock *sk = sock->sk;
 	DECLARE_SOCKADDR(struct sockaddr_tipc *, dest, m->msg_name);
 	long timeout = sock_sndtimeo(sk, m->msg_flags & MSG_DONTWAIT);
+	struct sk_buff_head *txq = &sk->sk_write_queue;
 	struct tipc_sock *tsk = tipc_sk(sk);
 	struct tipc_msg *hdr = &tsk->phdr;
 	struct net *net = sock_net(sk);
-	struct sk_buff_head pkts;
 	u32 dnode = tsk_peer_node(tsk);
+	int maxnagle = tsk->maxnagle;
+	int maxpkt = tsk->max_pkt;
 	int send, sent = 0;
-	int rc = 0;
-
-	__skb_queue_head_init(&pkts);
+	int blocks, rc = 0;
 
 	if (unlikely(dlen > INT_MAX))
 		return -EMSGSIZE;
@@ -1467,21 +1522,35 @@ static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dlen)
 					 tipc_sk_connected(sk)));
 		if (unlikely(rc))
 			break;
-
 		send = min_t(size_t, dlen - sent, TIPC_MAX_USER_MSG_SIZE);
-		rc = tipc_msg_build(hdr, m, sent, send, tsk->max_pkt, &pkts);
-		if (unlikely(rc != send))
-			break;
-
-		trace_tipc_sk_sendstream(sk, skb_peek(&pkts),
+		blocks = tsk->snd_backlog;
+		if (tsk->oneway++ >= 4 && send <= maxnagle) {
+			rc = tipc_msg_append(hdr, m, send, maxnagle, txq);
+			if (unlikely(rc < 0))
+				break;
+			blocks += rc;
+			if (blocks <= 64 && tsk->expect_ack) {
+				tsk->snd_backlog = blocks;
+				sent += send;
+				break;
+			}
+			tsk->expect_ack = true;
+		} else {
+			rc = tipc_msg_build(hdr, m, sent, send, maxpkt, txq);
+			if (unlikely(rc != send))
+				break;
+			blocks += tsk_inc(tsk, send + MIN_H_SIZE);
+		}
+		trace_tipc_sk_sendstream(sk, skb_peek(txq),
 					 TIPC_DUMP_SK_SNDQ, " ");
-		rc = tipc_node_xmit(net, &pkts, dnode, tsk->portid);
+		rc = tipc_node_xmit(net, txq, dnode, tsk->portid);
 		if (unlikely(rc == -ELINKCONG)) {
 			tsk->cong_link_cnt = 1;
 			rc = 0;
 		}
 		if (likely(!rc)) {
-			tsk->snt_unacked += tsk_inc(tsk, send + MIN_H_SIZE);
+			tsk->snt_unacked += blocks;
+			tsk->snd_backlog = 0;
 			sent += send;
 		}
 	} while (sent < dlen && !rc);
@@ -1528,6 +1597,7 @@ static void tipc_sk_finish_conn(struct tipc_sock *tsk, u32 peer_port,
 	tipc_node_add_conn(net, peer_node, tsk->portid, peer_port);
 	tsk->max_pkt = tipc_node_get_mtu(net, peer_node, tsk->portid, true);
 	tsk->peer_caps = tipc_node_get_capabilities(net, peer_node);
+	tsk_set_nagle(tsk);
 	__skb_queue_purge(&sk->sk_write_queue);
 	if (tsk->peer_caps & TIPC_BLOCK_FLOWCTL)
 		return;
@@ -1848,6 +1918,7 @@ static int tipc_recvstream(struct socket *sock, struct msghdr *m,
 	bool peek = flags & MSG_PEEK;
 	int offset, required, copy, copied = 0;
 	int hlen, dlen, err, rc;
+	bool ack = false;
 	long timeout;
 
 	/* Catch invalid receive attempts */
@@ -1892,6 +1963,7 @@ static int tipc_recvstream(struct socket *sock, struct msghdr *m,
 
 		/* Copy data if msg ok, otherwise return error/partial data */
 		if (likely(!err)) {
+			ack = msg_ack_required(hdr);
 			offset = skb_cb->bytes_read;
 			copy = min_t(int, dlen - offset, buflen - copied);
 			rc = skb_copy_datagram_msg(skb, hlen + offset, m, copy);
@@ -1919,7 +1991,7 @@ static int tipc_recvstream(struct socket *sock, struct msghdr *m,
 
 		/* Send connection flow control advertisement when applicable */
 		tsk->rcv_unacked += tsk_inc(tsk, hlen + dlen);
-		if (unlikely(tsk->rcv_unacked >= tsk->rcv_win / TIPC_ACK_RATE))
+		if (ack || tsk->rcv_unacked >= tsk->rcv_win / TIPC_ACK_RATE)
 			tipc_sk_send_ack(tsk);
 
 		/* Exit if all requested data or FIN/error received */
@@ -1990,6 +2062,7 @@ static void tipc_sk_proto_rcv(struct sock *sk,
 		smp_wmb();
 		tsk->cong_link_cnt--;
 		wakeup = true;
+		tipc_sk_push_backlog(tsk);
 		break;
 	case GROUP_PROTOCOL:
 		tipc_group_proto_rcv(grp, &wakeup, hdr, inputq, xmitq);
@@ -2029,6 +2102,7 @@ static bool tipc_sk_filter_connect(struct tipc_sock *tsk, struct sk_buff *skb)
 
 	if (unlikely(msg_mcast(hdr)))
 		return false;
+	tsk->oneway = 0;
 
 	switch (sk->sk_state) {
 	case TIPC_CONNECTING:
@@ -2074,6 +2148,8 @@ static bool tipc_sk_filter_connect(struct tipc_sock *tsk, struct sk_buff *skb)
 			return true;
 		return false;
 	case TIPC_ESTABLISHED:
+		if (!skb_queue_empty(&sk->sk_write_queue))
+			tipc_sk_push_backlog(tsk);
 		/* Accept only connection-based messages sent by peer */
 		if (likely(con_msg && !err && pport == oport && pnode == onode))
 			return true;
@@ -2959,6 +3035,7 @@ static int tipc_setsockopt(struct socket *sock, int lvl, int opt,
 	case TIPC_SRC_DROPPABLE:
 	case TIPC_DEST_DROPPABLE:
 	case TIPC_CONN_TIMEOUT:
+	case TIPC_NODELAY:
 		if (ol < sizeof(value))
 			return -EINVAL;
 		if (get_user(value, (u32 __user *)ov))
@@ -3007,6 +3084,10 @@ static int tipc_setsockopt(struct socket *sock, int lvl, int opt,
 	case TIPC_GROUP_LEAVE:
 		res = tipc_sk_leave(tsk);
 		break;
+	case TIPC_NODELAY:
+		tsk->nodelay = !!value;
+		tsk_set_nagle(tsk);
+		break;
 	default:
 		res = -EINVAL;
 	}
-- 
2.1.4

