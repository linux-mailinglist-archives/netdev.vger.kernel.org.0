Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED898117BD4
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 00:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfLIXw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 18:52:59 -0500
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:37035
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727398AbfLIXw6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 18:52:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5xeEk5vke+CJJblE73GkzQj6e++FB1738Ql66mNp0b85uTxM/4lvV+CCsHlgVaDwq1645h6fg7ZObgDg/MC8Vas2U3Dw+fQyEkaC2eZl4P8eJeznkAK+G1NOz/yRJSrqUaNye9MgELZ6DqBdn3iL4qL9gwMO0SHH8adVjbtiOicWhMZg6vSYBJMk55y88QXayu8YWp3SjLVWdrGS+CGLg4vJMnPY7mJG47tdvuNpTyQYDiwW7ZIASG8x4znOOnQYozLTdRN3KAqiU74/WL83GTBut1s9tBJwaJcGFY5owidf8Ty0oHuaqq5gSICCv4YWFSWjmWl4x4FKCPJxD2Gwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAJcLf318qBcaKn7MHNWFLwU1XWD5LMxX++q3RKSPGU=;
 b=LTx0e9HEIcLCsUhE9W4INeBlI1Q2Z/KR0zpgl1H7Mu+ZMPZEokJbKyVQCurU3VtXzamzsF/fP9TUei072TeRWcMtEMH9iWISL8+n+IBoMjRAvtOtZHrzhESu4bxXX0bKzpIKmdw8iQYHw35UuhxR1LGbRniYxaoqjdpQ7dyfEaY3l/LxL/QCUHBNZEQxpRDN+EoRKH4zwwQCmqyS+n62Z9yXPXSDgseYGP/P3cJA1bi3hlO8n01H05wDqXZ47Rzg9gxyF+4gxU03PZQgA5me1L+kYX6oAGLvLE7ovtYOlvDQiyEI2LdfTafCrd61sFTs1kAmbA3Cw1HdAR9uh9eiSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.176.1.74) smtp.rcpttodomain=davemloft.net smtp.mailfrom=ericsson.com;
 dmarc=pass (p=reject sp=none pct=100) action=none header.from=ericsson.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAJcLf318qBcaKn7MHNWFLwU1XWD5LMxX++q3RKSPGU=;
 b=Sa9whW0Jku8B5JYR2s1+0FLoMOhXj54GWSJF73Gq4YxVsBeIhy9HpIYxprYGgd9UvUxpHmf1ndJSEQgLX5jlyoi8IGSKjh78aFRfkn8gujp4yFXfGXzaR8acHYdq5H7p/O9z/YzV8dYAnmTJXUT5GlOMoNNgQD16BL6jPNX/o5I=
Received: from AM5PR0701CA0067.eurprd07.prod.outlook.com (2603:10a6:203:2::29)
 by AM6PR07MB6087.eurprd07.prod.outlook.com (2603:10a6:20b:9f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.6; Mon, 9 Dec
 2019 23:52:51 +0000
Received: from HE1EUR02FT012.eop-EUR02.prod.protection.outlook.com
 (2a01:111:f400:7e05::200) by AM5PR0701CA0067.outlook.office365.com
 (2603:10a6:203:2::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.6 via Frontend
 Transport; Mon, 9 Dec 2019 23:52:51 +0000
Authentication-Results: spf=pass (sender IP is 192.176.1.74)
 smtp.mailfrom=ericsson.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=ericsson.com;
Received-SPF: Pass (protection.outlook.com: domain of ericsson.com designates
 192.176.1.74 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.176.1.74; helo=oa.msg.ericsson.com;
Received: from oa.msg.ericsson.com (192.176.1.74) by
 HE1EUR02FT012.mail.protection.outlook.com (10.152.10.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.20.2495.18 via Frontend Transport; Mon, 9 Dec 2019 23:52:49 +0000
Received: from ESESSMB505.ericsson.se (153.88.183.166) by
 ESESSMR503.ericsson.se (153.88.183.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 10 Dec 2019 00:52:47 +0100
Received: from tipsy.lab.linux.ericsson.se (153.88.183.153) by
 smtp.internal.ericsson.com (153.88.183.193) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 10 Dec 2019 00:52:47 +0100
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <tung.q.nguyen@dektech.com.au>, <hoang.h.le@dektech.com.au>,
        <jon.maloy@ericsson.com>, <lxin@redhat.com>, <shuali@redhat.com>,
        <ying.xue@windriver.com>, <edumazet@google.com>,
        <tipc-discussion@lists.sourceforge.net>
Subject: [net-next 3/3] tipc: introduce variable window congestion control
Date:   Tue, 10 Dec 2019 00:52:46 +0100
Message-ID: <1575935566-18786-4-git-send-email-jon.maloy@ericsson.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1575935566-18786-1-git-send-email-jon.maloy@ericsson.com>
References: <1575935566-18786-1-git-send-email-jon.maloy@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.176.1.74;IPV:NLI;CTRY:SE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(39860400002)(189003)(199004)(51234002)(305945005)(8676002)(26005)(4326008)(70206006)(5660300002)(246002)(36756003)(7636002)(70586007)(478600001)(2906002)(956004)(44832011)(86362001)(426003)(110136005)(316002)(336012)(186003)(30864003)(54906003)(8936002)(2616005)(356004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR07MB6087;H:oa.msg.ericsson.com;FPR:;SPF:Pass;LANG:en;PTR:office365.se.ericsson.net;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9043fe8-d6fe-4ac2-aa8c-08d77d02e612
X-MS-TrafficTypeDiagnostic: AM6PR07MB6087:
X-LD-Processed: 92e84ceb-fbfd-47ab-be52-080c6b87953f,ExtAddr
X-Microsoft-Antispam-PRVS: <AM6PR07MB6087AF32D3A2F9FEC8FFB5DF9A580@AM6PR07MB6087.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 02462830BE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YX7drxT2RJCM9CNtD6rUSyKnl8Psc9DuFz/jikzWCsB7+VYHGHbAPJJLaj/dWtt7V4yYnVlltnzGSc+vO4Evqe9nbRDUASmyW/zKJYLybA2lSeYroVEpw6dWNZ7nk4qTly5l7BthPMzd+l8A0t8pFSiUCJMENUdYyVVjj5Ue6F4GGC9iO7qoEs27EcMlN48hOim+UOtfwDVZgyfiwuazS0j5TmizM3sWuwpbbPjnmzQfMY0HO/tbi1dCggh78/NMD82z1usU0lq/Ipsr8TIdil7p4tM2cchvIo4qzIsOS3XCIaIqSRKWyPcafjtHxj2Co5ORjDCvpM56ux6PXNFZTndJuf4TDNfUflvqZ2GhSeYwHYyJdudI9OLF6f5FVgOUp8moNSnzPjel0J/ufYsvYlP/ZnBVA5/RZatFgLZI6jJ6VoHdOg1myiZndpP/KUwS4syA2I4wq+x1cppvYApE5Jcnj58uYY8vJPkf2EMK+6kEO8timaNxiWUjeXg5twcZ
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2019 23:52:49.6771
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9043fe8-d6fe-4ac2-aa8c-08d77d02e612
X-MS-Exchange-CrossTenant-Id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=92e84ceb-fbfd-47ab-be52-080c6b87953f;Ip=[192.176.1.74];Helo=[oa.msg.ericsson.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR07MB6087
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We introduce a simple variable window congestion control for links.
The algorithm is inspired by the Reno algorithm, covering both 'slow
start', 'congestion avoidance', and 'fast recovery' modes.

- We introduce hard lower and upper window limits per link, still
  different and configurable per bearer type.

- We introduce a 'slow start theshold' variable, initially set to
  the maximum window size.

- We let a link start at the minimum congestion window, i.e. in slow
  start mode, and then let is grow rapidly (+1 per rceived ACK) until
  it reaches the slow start threshold and enters congestion avoidance
  mode.

- In congestion avoidance mode we increment the congestion window for
  each window-size number of acked packets, up to a possible maximum
  equal to the configured maximum window.

- For each non-duplicate NACK received, we drop back to fast recovery
  mode, by setting the both the slow start threshold to and the
  congestion window to (current_congestion_window / 2).

- If the timeout handler finds that the transmit queue has not moved
  since the previous timeout, it drops the link back to slow start
  and forces a probe containing the last sent sequence number to the
  sent to the peer, so that this can discover the stale situation.

This change does in reality have effect only on unicast ethernet
transport, as we have seen that there is no room whatsoever for
increasing the window max size for the UDP bearer.
For now, we also choose to keep the limits for the broadcast link
unchanged and equal.

This algorithm seems to give a 50-100% throughput improvement for
messages larger than MTU.

Suggested-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
---
 net/tipc/bcast.c     |  11 ++--
 net/tipc/bearer.c    |  11 ++--
 net/tipc/bearer.h    |   6 +-
 net/tipc/eth_media.c |   3 +-
 net/tipc/ib_media.c  |   5 +-
 net/tipc/link.c      | 175 +++++++++++++++++++++++++++++++++++----------------
 net/tipc/link.h      |   9 +--
 net/tipc/node.c      |  16 ++---
 net/tipc/udp_media.c |   3 +-
 9 files changed, 160 insertions(+), 79 deletions(-)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index 55aeba6..42e01e9 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -562,18 +562,18 @@ int tipc_bclink_reset_stats(struct net *net)
 	return 0;
 }
 
-static int tipc_bc_link_set_queue_limits(struct net *net, u32 limit)
+static int tipc_bc_link_set_queue_limits(struct net *net, u32 max_win)
 {
 	struct tipc_link *l = tipc_bc_sndlink(net);
 
 	if (!l)
 		return -ENOPROTOOPT;
-	if (limit < BCLINK_WIN_MIN)
-		limit = BCLINK_WIN_MIN;
-	if (limit > TIPC_MAX_LINK_WIN)
+	if (max_win < BCLINK_WIN_MIN)
+		max_win = BCLINK_WIN_MIN;
+	if (max_win > TIPC_MAX_LINK_WIN)
 		return -EINVAL;
 	tipc_bcast_lock(net);
-	tipc_link_set_queue_limits(l, limit);
+	tipc_link_set_queue_limits(l, BCLINK_WIN_MIN, max_win);
 	tipc_bcast_unlock(net);
 	return 0;
 }
@@ -683,6 +683,7 @@ int tipc_bcast_init(struct net *net)
 	if (!tipc_link_bc_create(net, 0, 0,
 				 FB_MTU,
 				 BCLINK_WIN_DEFAULT,
+				 BCLINK_WIN_DEFAULT,
 				 0,
 				 &bb->inputq,
 				 NULL,
diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index d7ec26b..34ca7b7 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -311,7 +311,8 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 
 	b->identity = bearer_id;
 	b->tolerance = m->tolerance;
-	b->window = m->window;
+	b->min_win = m->min_win;
+	b->max_win = m->max_win;
 	b->domain = disc_domain;
 	b->net_plane = bearer_id + 'A';
 	b->priority = prio;
@@ -796,7 +797,7 @@ static int __tipc_nl_add_bearer(struct tipc_nl_msg *msg,
 		goto prop_msg_full;
 	if (nla_put_u32(msg->skb, TIPC_NLA_PROP_TOL, bearer->tolerance))
 		goto prop_msg_full;
-	if (nla_put_u32(msg->skb, TIPC_NLA_PROP_WIN, bearer->window))
+	if (nla_put_u32(msg->skb, TIPC_NLA_PROP_WIN, bearer->max_win))
 		goto prop_msg_full;
 	if (bearer->media->type_id == TIPC_MEDIA_TYPE_UDP)
 		if (nla_put_u32(msg->skb, TIPC_NLA_PROP_MTU, bearer->mtu))
@@ -1088,7 +1089,7 @@ int __tipc_nl_bearer_set(struct sk_buff *skb, struct genl_info *info)
 		if (props[TIPC_NLA_PROP_PRIO])
 			b->priority = nla_get_u32(props[TIPC_NLA_PROP_PRIO]);
 		if (props[TIPC_NLA_PROP_WIN])
-			b->window = nla_get_u32(props[TIPC_NLA_PROP_WIN]);
+			b->max_win = nla_get_u32(props[TIPC_NLA_PROP_WIN]);
 		if (props[TIPC_NLA_PROP_MTU]) {
 			if (b->media->type_id != TIPC_MEDIA_TYPE_UDP)
 				return -EINVAL;
@@ -1142,7 +1143,7 @@ static int __tipc_nl_add_media(struct tipc_nl_msg *msg,
 		goto prop_msg_full;
 	if (nla_put_u32(msg->skb, TIPC_NLA_PROP_TOL, media->tolerance))
 		goto prop_msg_full;
-	if (nla_put_u32(msg->skb, TIPC_NLA_PROP_WIN, media->window))
+	if (nla_put_u32(msg->skb, TIPC_NLA_PROP_WIN, media->max_win))
 		goto prop_msg_full;
 	if (media->type_id == TIPC_MEDIA_TYPE_UDP)
 		if (nla_put_u32(msg->skb, TIPC_NLA_PROP_MTU, media->mtu))
@@ -1275,7 +1276,7 @@ int __tipc_nl_media_set(struct sk_buff *skb, struct genl_info *info)
 		if (props[TIPC_NLA_PROP_PRIO])
 			m->priority = nla_get_u32(props[TIPC_NLA_PROP_PRIO]);
 		if (props[TIPC_NLA_PROP_WIN])
-			m->window = nla_get_u32(props[TIPC_NLA_PROP_WIN]);
+			m->max_win = nla_get_u32(props[TIPC_NLA_PROP_WIN]);
 		if (props[TIPC_NLA_PROP_MTU]) {
 			if (m->type_id != TIPC_MEDIA_TYPE_UDP)
 				return -EINVAL;
diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
index d0c79cc..bc00231 100644
--- a/net/tipc/bearer.h
+++ b/net/tipc/bearer.h
@@ -119,7 +119,8 @@ struct tipc_media {
 			char *raw);
 	u32 priority;
 	u32 tolerance;
-	u32 window;
+	u32 min_win;
+	u32 max_win;
 	u32 mtu;
 	u32 type_id;
 	u32 hwaddr_len;
@@ -158,7 +159,8 @@ struct tipc_bearer {
 	struct packet_type pt;
 	struct rcu_head rcu;
 	u32 priority;
-	u32 window;
+	u32 min_win;
+	u32 max_win;
 	u32 tolerance;
 	u32 domain;
 	u32 identity;
diff --git a/net/tipc/eth_media.c b/net/tipc/eth_media.c
index f69a2fd..8b0bb60 100644
--- a/net/tipc/eth_media.c
+++ b/net/tipc/eth_media.c
@@ -92,7 +92,8 @@ struct tipc_media eth_media_info = {
 	.raw2addr	= tipc_eth_raw2addr,
 	.priority	= TIPC_DEF_LINK_PRI,
 	.tolerance	= TIPC_DEF_LINK_TOL,
-	.window		= TIPC_DEF_LINK_WIN,
+	.min_win	= TIPC_DEF_LINK_WIN,
+	.max_win	= TIPC_MAX_LINK_WIN,
 	.type_id	= TIPC_MEDIA_TYPE_ETH,
 	.hwaddr_len	= ETH_ALEN,
 	.name		= "eth"
diff --git a/net/tipc/ib_media.c b/net/tipc/ib_media.c
index e8c1671..7aa9ff8 100644
--- a/net/tipc/ib_media.c
+++ b/net/tipc/ib_media.c
@@ -42,6 +42,8 @@
 #include "core.h"
 #include "bearer.h"
 
+#define TIPC_MAX_IB_LINK_WIN 500
+
 /* convert InfiniBand address (media address format) media address to string */
 static int tipc_ib_addr2str(struct tipc_media_addr *a, char *str_buf,
 			    int str_size)
@@ -94,7 +96,8 @@ struct tipc_media ib_media_info = {
 	.raw2addr	= tipc_ib_raw2addr,
 	.priority	= TIPC_DEF_LINK_PRI,
 	.tolerance	= TIPC_DEF_LINK_TOL,
-	.window		= TIPC_DEF_LINK_WIN,
+	.min_win	= TIPC_DEF_LINK_WIN,
+	.max_win	= TIPC_MAX_IB_LINK_WIN,
 	.type_id	= TIPC_MEDIA_TYPE_IB,
 	.hwaddr_len	= INFINIBAND_ALEN,
 	.name		= "ib"
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 3528181..94dd48c 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -164,7 +164,6 @@ struct tipc_link {
 		struct sk_buff *target_bskb;
 	} backlog[5];
 	u16 snd_nxt;
-	u16 window;
 
 	/* Reception */
 	u16 rcv_nxt;
@@ -175,6 +174,12 @@ struct tipc_link {
 
 	/* Congestion handling */
 	struct sk_buff_head wakeupq;
+	u16 window;
+	u16 min_win;
+	u16 ssthresh;
+	u16 max_win;
+	u16 cong_acks;
+	u16 checkpoint;
 
 	/* Fragmentation/reassembly */
 	struct sk_buff *reasm_buf;
@@ -244,12 +249,13 @@ static int tipc_link_build_nack_msg(struct tipc_link *l,
 				    struct sk_buff_head *xmitq);
 static void tipc_link_build_bc_init_msg(struct tipc_link *l,
 					struct sk_buff_head *xmitq);
-static bool tipc_link_release_pkts(struct tipc_link *l, u16 to);
+static int tipc_link_release_pkts(struct tipc_link *l, u16 to);
 static u16 tipc_build_gap_ack_blks(struct tipc_link *l, void *data);
 static int tipc_link_advance_transmq(struct tipc_link *l, u16 acked, u16 gap,
 				     struct tipc_gap_ack_blks *ga,
 				     struct sk_buff_head *xmitq);
-
+static void tipc_link_update_cwin(struct tipc_link *l, int released,
+				  bool retransmitted);
 /*
  *  Simple non-static link routines (i.e. referenced outside this file)
  */
@@ -308,9 +314,14 @@ u32 tipc_link_id(struct tipc_link *l)
 	return l->peer_bearer_id << 16 | l->bearer_id;
 }
 
-int tipc_link_window(struct tipc_link *l)
+int tipc_link_min_win(struct tipc_link *l)
 {
-	return l->window;
+	return l->min_win;
+}
+
+int tipc_link_max_win(struct tipc_link *l)
+{
+	return l->max_win;
 }
 
 int tipc_link_prio(struct tipc_link *l)
@@ -436,7 +447,8 @@ u32 tipc_link_state(struct tipc_link *l)
  * @net_plane: network plane (A,B,c..) this link belongs to
  * @mtu: mtu to be advertised by link
  * @priority: priority to be used by link
- * @window: send window to be used by link
+ * @min_win: minimal send window to be used by link
+ * @max_win: maximal send window to be used by link
  * @session: session to be used by link
  * @ownnode: identity of own node
  * @peer: node id of peer node
@@ -451,7 +463,7 @@ u32 tipc_link_state(struct tipc_link *l)
  */
 bool tipc_link_create(struct net *net, char *if_name, int bearer_id,
 		      int tolerance, char net_plane, u32 mtu, int priority,
-		      int window, u32 session, u32 self,
+		      u32 min_win, u32 max_win, u32 session, u32 self,
 		      u32 peer, u8 *peer_id, u16 peer_caps,
 		      struct tipc_link *bc_sndlink,
 		      struct tipc_link *bc_rcvlink,
@@ -495,7 +507,7 @@ bool tipc_link_create(struct net *net, char *if_name, int bearer_id,
 	l->advertised_mtu = mtu;
 	l->mtu = mtu;
 	l->priority = priority;
-	tipc_link_set_queue_limits(l, window);
+	tipc_link_set_queue_limits(l, min_win, max_win);
 	l->ackers = 1;
 	l->bc_sndlink = bc_sndlink;
 	l->bc_rcvlink = bc_rcvlink;
@@ -523,7 +535,7 @@ bool tipc_link_create(struct net *net, char *if_name, int bearer_id,
  * Returns true if link was created, otherwise false
  */
 bool tipc_link_bc_create(struct net *net, u32 ownnode, u32 peer,
-			 int mtu, int window, u16 peer_caps,
+			 int mtu, u32 min_win, u32 max_win, u16 peer_caps,
 			 struct sk_buff_head *inputq,
 			 struct sk_buff_head *namedq,
 			 struct tipc_link *bc_sndlink,
@@ -531,9 +543,9 @@ bool tipc_link_bc_create(struct net *net, u32 ownnode, u32 peer,
 {
 	struct tipc_link *l;
 
-	if (!tipc_link_create(net, "", MAX_BEARERS, 0, 'Z', mtu, 0, window,
-			      0, ownnode, peer, NULL, peer_caps, bc_sndlink,
-			      NULL, inputq, namedq, link))
+	if (!tipc_link_create(net, "", MAX_BEARERS, 0, 'Z', mtu, 0, min_win,
+			      max_win, 0, ownnode, peer, NULL, peer_caps,
+			      bc_sndlink, NULL, inputq, namedq, link))
 		return false;
 
 	l = *link;
@@ -772,6 +784,8 @@ bool tipc_link_too_silent(struct tipc_link *l)
 	return (l->silent_intv_cnt + 2 > l->abort_limit);
 }
 
+static int tipc_link_bc_retrans(struct tipc_link *l, struct tipc_link *r,
+				u16 from, u16 to, struct sk_buff_head *xmitq);
 /* tipc_link_timeout - perform periodic task as instructed from node timeout
  */
 int tipc_link_timeout(struct tipc_link *l, struct sk_buff_head *xmitq)
@@ -804,6 +818,11 @@ int tipc_link_timeout(struct tipc_link *l, struct sk_buff_head *xmitq)
 		probe |= l->silent_intv_cnt;
 		if (probe || mstate->monitoring)
 			l->silent_intv_cnt++;
+		if (l->snd_nxt == l->checkpoint) {
+			tipc_link_update_cwin(l, 0, 0);
+			probe = true;
+		}
+		l->checkpoint = l->snd_nxt;
 		break;
 	case LINK_RESET:
 		setup = l->rst_cnt++ <= 4;
@@ -959,7 +978,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 	int pkt_cnt = skb_queue_len(list);
 	int imp = msg_importance(hdr);
 	unsigned int mss = tipc_link_mss(l);
-	unsigned int maxwin = l->window;
+	unsigned int cwin = l->window;
 	unsigned int mtu = l->mtu;
 	bool new_bundle;
 	int rc = 0;
@@ -988,7 +1007,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 
 	/* Prepare each packet for sending, and add to relevant queue: */
 	while ((skb = __skb_dequeue(list))) {
-		if (likely(skb_queue_len(transmq) < maxwin)) {
+		if (likely(skb_queue_len(transmq) < cwin)) {
 			hdr = buf_msg(skb);
 			msg_set_seqno(hdr, seqno);
 			msg_set_ack(hdr, ack);
@@ -1035,17 +1054,61 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 	return rc;
 }
 
+static void tipc_link_update_cwin(struct tipc_link *l, int released,
+				  bool retransmitted)
+{
+	int bklog_len = skb_queue_len(&l->backlogq);
+	struct sk_buff_head *txq = &l->transmq;
+	int txq_len = skb_queue_len(txq);
+	u16 cwin = l->window;
+
+	/* Enter fast recovery */
+	if (unlikely(retransmitted)) {
+		l->ssthresh = max_t(u16, l->window / 2, 300);
+		l->window = l->ssthresh;
+		return;
+	}
+	/* Enter slow start */
+	if (unlikely(!released)) {
+		l->ssthresh = max_t(u16, l->window / 2, 300);
+		l->window = l->min_win;
+		return;
+	}
+	/* Don't increase window if no pressure on the transmit queue */
+	if (txq_len + bklog_len < cwin)
+		return;
+
+	/* Don't increase window if there are holes the transmit queue */
+	if (txq_len && l->snd_nxt - buf_seqno(skb_peek(txq)) != txq_len)
+		return;
+
+	l->cong_acks += released;
+
+	/* Slow start  */
+	if (cwin <= l->ssthresh) {
+		l->window = min_t(u16, cwin + released, l->max_win);
+		return;
+	}
+	/* Congestion avoidance */
+	if (l->cong_acks < cwin)
+		return;
+	l->window = min_t(u16, ++cwin, l->max_win);
+	l->cong_acks = 0;
+}
+
 static void tipc_link_advance_backlog(struct tipc_link *l,
 				      struct sk_buff_head *xmitq)
 {
+	u16 bc_ack = l->bc_rcvlink->rcv_nxt - 1;
+	struct sk_buff_head *txq = &l->transmq;
 	struct sk_buff *skb, *_skb;
-	struct tipc_msg *hdr;
-	u16 seqno = l->snd_nxt;
 	u16 ack = l->rcv_nxt - 1;
-	u16 bc_ack = l->bc_rcvlink->rcv_nxt - 1;
+	u16 seqno = l->snd_nxt;
+	struct tipc_msg *hdr;
+	u16 cwin = l->window;
 	u32 imp;
 
-	while (skb_queue_len(&l->transmq) < l->window) {
+	while (skb_queue_len(txq) < cwin) {
 		skb = skb_peek(&l->backlogq);
 		if (!skb)
 			break;
@@ -1141,6 +1204,7 @@ static int tipc_link_bc_retrans(struct tipc_link *l, struct tipc_link *r,
 	struct sk_buff *_skb, *skb = skb_peek(&l->transmq);
 	u16 bc_ack = l->bc_rcvlink->rcv_nxt - 1;
 	u16 ack = l->rcv_nxt - 1;
+	int retransmitted = 0;
 	struct tipc_msg *hdr;
 	int rc = 0;
 
@@ -1160,7 +1224,6 @@ static int tipc_link_bc_retrans(struct tipc_link *l, struct tipc_link *r,
 			continue;
 		if (more(msg_seqno(hdr), to))
 			break;
-
 		if (time_before(jiffies, TIPC_SKB_CB(skb)->nxt_retr))
 			continue;
 		TIPC_SKB_CB(skb)->nxt_retr = TIPC_BC_RETR_LIM;
@@ -1173,11 +1236,12 @@ static int tipc_link_bc_retrans(struct tipc_link *l, struct tipc_link *r,
 		_skb->priority = TC_PRIO_CONTROL;
 		__skb_queue_tail(xmitq, _skb);
 		l->stats.retransmitted++;
-
+		retransmitted++;
 		/* Increase actual retrans counter & mark first time */
 		if (!TIPC_SKB_CB(skb)->retr_cnt++)
 			TIPC_SKB_CB(skb)->retr_stamp = jiffies;
 	}
+	tipc_link_update_cwin(l, 0, retransmitted);
 	return 0;
 }
 
@@ -1338,9 +1402,9 @@ static int tipc_link_tnl_rcv(struct tipc_link *l, struct sk_buff *skb,
 	return rc;
 }
 
-static bool tipc_link_release_pkts(struct tipc_link *l, u16 acked)
+static int tipc_link_release_pkts(struct tipc_link *l, u16 acked)
 {
-	bool released = false;
+	int released = 0;
 	struct sk_buff *skb, *tmp;
 
 	skb_queue_walk_safe(&l->transmq, skb, tmp) {
@@ -1348,7 +1412,7 @@ static bool tipc_link_release_pkts(struct tipc_link *l, u16 acked)
 			break;
 		__skb_unlink(skb, &l->transmq);
 		kfree_skb(skb);
-		released = true;
+		released++;
 	}
 	return released;
 }
@@ -1417,8 +1481,10 @@ static int tipc_link_advance_transmq(struct tipc_link *l, u16 acked, u16 gap,
 	struct sk_buff *skb, *_skb, *tmp;
 	struct tipc_msg *hdr;
 	u16 bc_ack = l->bc_rcvlink->rcv_nxt - 1;
+	bool retransmitted = false;
 	u16 ack = l->rcv_nxt - 1;
 	bool passed = false;
+	u16 released = 0;
 	u16 seqno, n = 0;
 	int rc = 0;
 
@@ -1430,6 +1496,7 @@ static int tipc_link_advance_transmq(struct tipc_link *l, u16 acked, u16 gap,
 			/* release skb */
 			__skb_unlink(skb, &l->transmq);
 			kfree_skb(skb);
+			released++;
 		} else if (less_eq(seqno, acked + gap)) {
 			/* First, check if repeated retrans failures occurs? */
 			if (!passed && link_retransmit_failure(l, l, &rc))
@@ -1449,7 +1516,7 @@ static int tipc_link_advance_transmq(struct tipc_link *l, u16 acked, u16 gap,
 			_skb->priority = TC_PRIO_CONTROL;
 			__skb_queue_tail(xmitq, _skb);
 			l->stats.retransmitted++;
-
+			retransmitted = true;
 			/* Increase actual retrans counter & mark first time */
 			if (!TIPC_SKB_CB(skb)->retr_cnt++)
 				TIPC_SKB_CB(skb)->retr_stamp = jiffies;
@@ -1463,7 +1530,10 @@ static int tipc_link_advance_transmq(struct tipc_link *l, u16 acked, u16 gap,
 			goto next_gap_ack;
 		}
 	}
-
+	if (released || retransmitted)
+		tipc_link_update_cwin(l, released, retransmitted);
+	if (released)
+		tipc_link_advance_backlog(l, xmitq);
 	return 0;
 }
 
@@ -1487,7 +1557,6 @@ int tipc_link_build_state_msg(struct tipc_link *l, struct sk_buff_head *xmitq)
 		l->snd_nxt = l->rcv_nxt;
 		return TIPC_LINK_SND_STATE;
 	}
-
 	/* Unicast ACK */
 	l->rcv_unacked = 0;
 	l->stats.sent_acks++;
@@ -1553,6 +1622,7 @@ int tipc_link_rcv(struct tipc_link *l, struct sk_buff *skb,
 	struct sk_buff_head *defq = &l->deferdq;
 	struct tipc_msg *hdr = buf_msg(skb);
 	u16 seqno, rcv_nxt, win_lim;
+	int released = 0;
 	int rc = 0;
 
 	/* Verify and update link state */
@@ -1571,21 +1641,17 @@ int tipc_link_rcv(struct tipc_link *l, struct sk_buff *skb,
 		if (unlikely(!link_is_up(l))) {
 			if (l->state == LINK_ESTABLISHING)
 				rc = TIPC_LINK_UP_EVT;
-			goto drop;
+			kfree_skb(skb);
+			break;
 		}
 
 		/* Drop if outside receive window */
 		if (unlikely(less(seqno, rcv_nxt) || more(seqno, win_lim))) {
 			l->stats.duplicates++;
-			goto drop;
-		}
-
-		/* Forward queues and wake up waiting users */
-		if (likely(tipc_link_release_pkts(l, msg_ack(hdr)))) {
-			tipc_link_advance_backlog(l, xmitq);
-			if (unlikely(!skb_queue_empty(&l->wakeupq)))
-				link_prepare_wakeup(l);
+			kfree_skb(skb);
+			break;
 		}
+		released += tipc_link_release_pkts(l, msg_ack(hdr));
 
 		/* Defer delivery if sequence gap */
 		if (unlikely(seqno != rcv_nxt)) {
@@ -1608,9 +1674,13 @@ int tipc_link_rcv(struct tipc_link *l, struct sk_buff *skb,
 			break;
 	} while ((skb = __tipc_skb_dequeue(defq, l->rcv_nxt)));
 
-	return rc;
-drop:
-	kfree_skb(skb);
+	/* Forward queues and wake up waiting users */
+	if (released) {
+		tipc_link_update_cwin(l, released, 0);
+		tipc_link_advance_backlog(l, xmitq);
+		if (unlikely(!skb_queue_empty(&l->wakeupq)))
+			link_prepare_wakeup(l);
+	}
 	return rc;
 }
 
@@ -2084,17 +2154,13 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 		    !tipc_link_is_synching(l) &&
 		    skb_queue_empty(&l->deferdq))
 			rcvgap = peers_snd_nxt - l->rcv_nxt;
-
 		if (rcvgap || reply)
 			tipc_link_build_proto_msg(l, STATE_MSG, 0, reply,
 						  rcvgap, 0, 0, xmitq);
-		rc |= tipc_link_advance_transmq(l, ack, gap, ga, xmitq);
 
-		/* If NACK, retransmit will now start at right position */
+		rc |= tipc_link_advance_transmq(l, ack, gap, ga, xmitq);
 		if (gap)
 			l->stats.recv_nacks++;
-
-		tipc_link_advance_backlog(l, xmitq);
 		if (unlikely(!skb_queue_empty(&l->wakeupq)))
 			link_prepare_wakeup(l);
 	}
@@ -2313,15 +2379,18 @@ int tipc_link_bc_nack_rcv(struct tipc_link *l, struct sk_buff *skb,
 	return 0;
 }
 
-void tipc_link_set_queue_limits(struct tipc_link *l, u32 win)
+void tipc_link_set_queue_limits(struct tipc_link *l, u32 min_win, u32 max_win)
 {
 	int max_bulk = TIPC_MAX_PUBL / (l->mtu / ITEM_SIZE);
 
-	l->window = win;
-	l->backlog[TIPC_LOW_IMPORTANCE].limit      = max_t(u16, 50, win);
-	l->backlog[TIPC_MEDIUM_IMPORTANCE].limit   = max_t(u16, 100, win * 2);
-	l->backlog[TIPC_HIGH_IMPORTANCE].limit     = max_t(u16, 150, win * 3);
-	l->backlog[TIPC_CRITICAL_IMPORTANCE].limit = max_t(u16, 200, win * 4);
+	l->min_win = min_win;
+	l->ssthresh = max_win;
+	l->max_win = max_win;
+	l->window = min_win;
+	l->backlog[TIPC_LOW_IMPORTANCE].limit      = min_win * 2;
+	l->backlog[TIPC_MEDIUM_IMPORTANCE].limit   = min_win * 4;
+	l->backlog[TIPC_HIGH_IMPORTANCE].limit     = min_win * 6;
+	l->backlog[TIPC_CRITICAL_IMPORTANCE].limit = min_win * 8;
 	l->backlog[TIPC_SYSTEM_IMPORTANCE].limit   = max_bulk;
 }
 
@@ -2374,10 +2443,10 @@ int tipc_nl_parse_link_prop(struct nlattr *prop, struct nlattr *props[])
 	}
 
 	if (props[TIPC_NLA_PROP_WIN]) {
-		u32 win;
+		u32 max_win;
 
-		win = nla_get_u32(props[TIPC_NLA_PROP_WIN]);
-		if ((win < TIPC_MIN_LINK_WIN) || (win > TIPC_MAX_LINK_WIN))
+		max_win = nla_get_u32(props[TIPC_NLA_PROP_WIN]);
+		if (max_win < TIPC_DEF_LINK_WIN || max_win > TIPC_MAX_LINK_WIN)
 			return -EINVAL;
 	}
 
@@ -2613,7 +2682,7 @@ int tipc_nl_add_bc_link(struct net *net, struct tipc_nl_msg *msg)
 	prop = nla_nest_start_noflag(msg->skb, TIPC_NLA_LINK_PROP);
 	if (!prop)
 		goto attr_msg_full;
-	if (nla_put_u32(msg->skb, TIPC_NLA_PROP_WIN, bcl->window))
+	if (nla_put_u32(msg->skb, TIPC_NLA_PROP_WIN, bcl->max_win))
 		goto prop_msg_full;
 	if (nla_put_u32(msg->skb, TIPC_NLA_PROP_BROADCAST, bc_mode))
 		goto prop_msg_full;
diff --git a/net/tipc/link.h b/net/tipc/link.h
index c09e9d4..d3c1c3f 100644
--- a/net/tipc/link.h
+++ b/net/tipc/link.h
@@ -73,7 +73,7 @@ enum {
 
 bool tipc_link_create(struct net *net, char *if_name, int bearer_id,
 		      int tolerance, char net_plane, u32 mtu, int priority,
-		      int window, u32 session, u32 ownnode,
+		      u32 min_win, u32 max_win, u32 session, u32 ownnode,
 		      u32 peer, u8 *peer_id, u16 peer_caps,
 		      struct tipc_link *bc_sndlink,
 		      struct tipc_link *bc_rcvlink,
@@ -81,7 +81,7 @@ bool tipc_link_create(struct net *net, char *if_name, int bearer_id,
 		      struct sk_buff_head *namedq,
 		      struct tipc_link **link);
 bool tipc_link_bc_create(struct net *net, u32 ownnode, u32 peer,
-			 int mtu, int window, u16 peer_caps,
+			 int mtu, u32 min_win, u32 max_win, u16 peer_caps,
 			 struct sk_buff_head *inputq,
 			 struct sk_buff_head *namedq,
 			 struct tipc_link *bc_sndlink,
@@ -115,7 +115,8 @@ char *tipc_link_name_ext(struct tipc_link *l, char *buf);
 u32 tipc_link_state(struct tipc_link *l);
 char tipc_link_plane(struct tipc_link *l);
 int tipc_link_prio(struct tipc_link *l);
-int tipc_link_window(struct tipc_link *l);
+int tipc_link_min_win(struct tipc_link *l);
+int tipc_link_max_win(struct tipc_link *l);
 void tipc_link_update_caps(struct tipc_link *l, u16 capabilities);
 bool tipc_link_validate_msg(struct tipc_link *l, struct tipc_msg *hdr);
 unsigned long tipc_link_tolerance(struct tipc_link *l);
@@ -124,7 +125,7 @@ void tipc_link_set_tolerance(struct tipc_link *l, u32 tol,
 void tipc_link_set_prio(struct tipc_link *l, u32 prio,
 			struct sk_buff_head *xmitq);
 void tipc_link_set_abort_limit(struct tipc_link *l, u32 limit);
-void tipc_link_set_queue_limits(struct tipc_link *l, u32 window);
+void tipc_link_set_queue_limits(struct tipc_link *l, u32 min_win, u32 max_win);
 int __tipc_nl_add_link(struct net *net, struct tipc_nl_msg *msg,
 		       struct tipc_link *link, int nlflags);
 int tipc_nl_parse_link_prop(struct nlattr *prop, struct nlattr *props[]);
diff --git a/net/tipc/node.c b/net/tipc/node.c
index ab04e00..99b28b6 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1139,7 +1139,8 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		snd_l = tipc_bc_sndlink(net);
 		if (!tipc_link_bc_create(net, tipc_own_addr(net),
 					 addr, U16_MAX,
-					 tipc_link_window(snd_l),
+					 tipc_link_min_win(snd_l),
+					 tipc_link_max_win(snd_l),
 					 n->capabilities,
 					 &n->bc_entry.inputq1,
 					 &n->bc_entry.namedq, snd_l,
@@ -1233,7 +1234,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		get_random_bytes(&session, sizeof(u16));
 		if (!tipc_link_create(net, if_name, b->identity, b->tolerance,
 				      b->net_plane, b->mtu, b->priority,
-				      b->window, session,
+				      b->min_win, b->max_win, session,
 				      tipc_own_addr(net), addr, peer_id,
 				      n->capabilities,
 				      tipc_bc_sndlink(n->net), n->bc_entry.link,
@@ -2360,8 +2361,7 @@ int tipc_nl_node_set_link(struct sk_buff *skb, struct genl_info *info)
 	if (attrs[TIPC_NLA_LINK_PROP]) {
 		struct nlattr *props[TIPC_NLA_PROP_MAX + 1];
 
-		err = tipc_nl_parse_link_prop(attrs[TIPC_NLA_LINK_PROP],
-					      props);
+		err = tipc_nl_parse_link_prop(attrs[TIPC_NLA_LINK_PROP], props);
 		if (err) {
 			res = err;
 			goto out;
@@ -2380,10 +2380,12 @@ int tipc_nl_node_set_link(struct sk_buff *skb, struct genl_info *info)
 			tipc_link_set_prio(link, prio, &xmitq);
 		}
 		if (props[TIPC_NLA_PROP_WIN]) {
-			u32 win;
+			u32 max_win;
 
-			win = nla_get_u32(props[TIPC_NLA_PROP_WIN]);
-			tipc_link_set_queue_limits(link, win);
+			max_win = nla_get_u32(props[TIPC_NLA_PROP_WIN]);
+			tipc_link_set_queue_limits(link,
+						   tipc_link_min_win(link),
+						   max_win);
 		}
 	}
 
diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index ed11373..d6620ad5 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -828,7 +828,8 @@ struct tipc_media udp_media_info = {
 	.msg2addr	= tipc_udp_msg2addr,
 	.priority	= TIPC_DEF_LINK_PRI,
 	.tolerance	= TIPC_DEF_LINK_TOL,
-	.window		= TIPC_DEF_LINK_WIN,
+	.min_win	= TIPC_DEF_LINK_WIN,
+	.max_win	= TIPC_DEF_LINK_WIN,
 	.mtu		= TIPC_DEF_LINK_UDP_MTU,
 	.type_id	= TIPC_MEDIA_TYPE_UDP,
 	.hwaddr_len	= 0,
-- 
2.1.4

