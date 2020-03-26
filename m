Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 822C619362A
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 03:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgCZCur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 22:50:47 -0400
Received: from mail-eopbgr150108.outbound.protection.outlook.com ([40.107.15.108]:24262
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727576AbgCZCur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 22:50:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwMZtpoq/YkKAq70V2ZiXMBpBte4tBQDO50KrhzvC7cXaQ9E/vEpMUOim26wQ4oXWBdXrRy8jXMelmIoRKNZ9jQOYjVOYglGA9AqlHvEj55bqDJ7jav9WPxLFwbEJv90BWWi1+vqC8hKCqcohaqs3TWaF3DUjRHXt4gJp6NrSE15obqd8M739dBswvdMWXl0Ueac5leAZdxFWvqiYNag/v3d396xRNl9nY0c6HCi+jUXivInJDgeQzeg/dxnUITGguhpVVieehForaXLHY7KONy40kolC+UhjaxlCaRsAv+c4Fnh/PBGZqTYo4T9W/3u8TBXHhRc+I1WOk09c16k+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XiEaytZ3rLaWBSo/VF8B1bJqIg/K4J4LOvM3SB6aymI=;
 b=kRexMqFSbR4J8qM3MBVDMwB+kOMXCMAgGda/+D1dYYyJREIZ5CPyM7IdDDmao8vptrYAz1AsiO8Vc8l/aNlFQ3D3sthhLkdQ6EtUbzc4Y3/wFEo6R1Gp85xbZGERAnzKKFePDC6lTi0Y2Ibi5qu1Dnp9qerPoR8NY2MupWYJemDhLpQ+ULnyTO2uxkixjKdBdM23GtlIkmPAUUjZM52r28h+JsS51f/oAFNpVhrbLDZSwvruQ3J1MoCRmTQo8wFMIEMZkPgvaVE3Qgk0JOi5xFEPni1T70StzNLXeSteHEmnX3MFkI97Kuk9RfCUrgyvZjGnHFCzdvA9CDdr9mgQeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XiEaytZ3rLaWBSo/VF8B1bJqIg/K4J4LOvM3SB6aymI=;
 b=kc3uIO9frtIKVd3dbDWfGB70J7SCpNkPGySuvTd7ZwCKS+NLVBiox+XTqgZwFIw/91u8LJm+zPkeFr1VeEMNPkAmS3j4ydHOSTH9B7fh7FpV0df0pBA5hisVcFW87XUtRfDCCv2RDBlMBd5cuTlvrZZ+M6ePNPRnpL3u0cvL3dw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=hoang.h.le@dektech.com.au; 
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (20.176.4.149) by
 VI1PR05MB5536.eurprd05.prod.outlook.com (20.177.201.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.19; Thu, 26 Mar 2020 02:50:40 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::31c3:5db4:2b4a:fcec]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::31c3:5db4:2b4a:fcec%5]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 02:50:40 +0000
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     netdev@vger.kernel.org, ying.xue@windriver.com
Cc:     maloy@donjonn.com, jmaloy@redhat.com,
        Tuong Lien <tuong.t.lien@dektech.com.au>
Subject: [net-next] tipc: Add a missing case of TIPC_DIRECT_MSG type
Date:   Thu, 26 Mar 2020 09:50:29 +0700
Message-Id: <20200326025029.5292-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0018.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::31) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (115.77.48.208) by AM0PR06CA0018.eurprd06.prod.outlook.com (2603:10a6:208:ab::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.18 via Frontend Transport; Thu, 26 Mar 2020 02:50:38 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [115.77.48.208]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3ca2716-975b-4092-78fa-08d7d130780c
X-MS-TrafficTypeDiagnostic: VI1PR05MB5536:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB553695CAEBE225FBA069D02CF1CF0@VI1PR05MB5536.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:538;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(346002)(136003)(39850400004)(376002)(396003)(2616005)(956004)(508600001)(55016002)(2906002)(86362001)(36756003)(5660300002)(1076003)(316002)(81156014)(81166006)(26005)(66476007)(8676002)(6666004)(8936002)(16526019)(4326008)(66946007)(107886003)(52116002)(7696005)(66556008)(186003)(103116003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: dektech.com.au does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p8+Cq35PNfvU1oi6XSix8l8mKvkG9Y9J+sL6ktSVFwtdrWMOp3JjLh5y1V5kv1B5ueZniam3s2nH4vcuFEM6c3LhwKEd1NjU9AG6K4c18MJ8lqSLxwsjAAYUHaSMyQCBfsik8327dgSjm2czk59vilniIOv+blxdtNWzY87swxb0JBxnMKjkFGajrk2IhpRyydZZoiKNle++M4Km/yNXFfoxHohOOfWDQGMbvgaxaMv/+0qLWTjWvlHFU8PtCpFQLMp9tN4JeF01k3rvJqnkPcBgnH/L9rYGKKQPyxpf6+cPYIQ9/gJ9cf+5Hj/A5g4im0fGkotcJeKiSDGMB33jU6SDPJ8sABD2UohsyujB/ARlJw9dCdPLdpV/Ap3C5MlacWduRdvDxnQZbofQN0ddZJh+aui042CSSj+7v9E2MHqu5ODZVXSeEOR5xFaT3L4K
X-MS-Exchange-AntiSpam-MessageData: dSHRtXINZ55lTOFt7jhY+3wXZf1m/LmKmxpXniFbc+hEmYmDCKXkL2nXLy0Cs6uhbWENYw9spnRuzs96Lbd7xclf+OA7e6b5wEzJtH8PraxxnWC5uL+FQ8SwCG9z6/I70tvsaPMbf/RVKH38gHxzfA==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: a3ca2716-975b-4092-78fa-08d7d130780c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 02:50:40.2071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5uAFi2RvmuREYioh34k7DMdMng7BMJvpx2HEe5UD4SsnGj4x3THSF2mMcsoGdCtCZsI3yZY8lKw3z060d4sY4S4LY9/uPjNycy5mhzSNQo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5536
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the commit f73b12812a3d
("tipc: improve throughput between nodes in netns"), we're missing a check
to handle TIPC_DIRECT_MSG type, it's still using old sending mechanism for
this message type. So, throughput improvement is not significant as
expected.

Besides that, when sending a large message with that type, we're also
handle wrong receiving queue, it should be enqueued in socket receiving
instead of multicast messages.

Fix this by adding the missing case for TIPC_DIRECT_MSG.

Fixes: f73b12812a3d ("tipc: improve throughput between nodes in netns")
Reported-by: Tuong Lien <tuong.t.lien@dektech.com.au>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/msg.h    | 5 +++++
 net/tipc/node.c   | 3 ++-
 net/tipc/socket.c | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 6d466ebdb64f..871feadbbc19 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -394,6 +394,11 @@ static inline u32 msg_connected(struct tipc_msg *m)
 	return msg_type(m) == TIPC_CONN_MSG;
 }
 
+static inline u32 msg_direct(struct tipc_msg *m)
+{
+	return msg_type(m) == TIPC_DIRECT_MSG;
+}
+
 static inline u32 msg_errcode(struct tipc_msg *m)
 {
 	return msg_bits(m, 1, 25, 0xf);
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 0c88778c88b5..10292c942384 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1586,7 +1586,8 @@ static void tipc_lxc_xmit(struct net *peer_net, struct sk_buff_head *list)
 	case TIPC_MEDIUM_IMPORTANCE:
 	case TIPC_HIGH_IMPORTANCE:
 	case TIPC_CRITICAL_IMPORTANCE:
-		if (msg_connected(hdr) || msg_named(hdr)) {
+		if (msg_connected(hdr) || msg_named(hdr) ||
+		    msg_direct(hdr)) {
 			tipc_loopback_trace(peer_net, list);
 			spin_lock_init(&list->lock);
 			tipc_sk_rcv(peer_net, list);
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 693e8902161e..87466607097f 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1461,7 +1461,7 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 	}
 
 	__skb_queue_head_init(&pkts);
-	mtu = tipc_node_get_mtu(net, dnode, tsk->portid, false);
+	mtu = tipc_node_get_mtu(net, dnode, tsk->portid, true);
 	rc = tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
 	if (unlikely(rc != dlen))
 		return rc;
-- 
2.20.1

