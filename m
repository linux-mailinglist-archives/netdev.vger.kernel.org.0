Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8232117BD2
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 00:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfLIXwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 18:52:54 -0500
Received: from mail-eopbgr120048.outbound.protection.outlook.com ([40.107.12.48]:51833
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727357AbfLIXwx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 18:52:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WtX3THwnh7AQ4HNRCD2DvuvV0BdnGJXEWaYJEjc3nYkIYh+SnoYtosx/iIAdfG4gE0dVZR507Rwy3I2tLcWoP6WUaxviCeGKuiJxFgma4CT3UsQVw9BzuQTgxFHbVhZHjqnMHuhof6wtkUqDu7Sg3PvulVSjWMCPXz14BIyvRLBoVWe3vHBUjlUCGC3irHyXSbCGmpw1r19LD/txFbvNa9jRgGd1BEN0b7SmeMRoZfg7WQa/u0VDpeJKqJJQC36uH7LgKiaA9p9rkqtu+9OobDCk4vfkg8H37G2pVhpod+BjXNM/+ZUF74WNARhu/DpOcOpERIuYWrE9FxdPhzAUlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgQxG6TlrgICAKQV4NCXrJtKEc4zaEH2oRmpMH2Pue4=;
 b=Rcrlxgg+wy1FLQLDiiWYAirP1Ty27oDV/6/CPYlCfhaGXhle5tu2+ru+mRmX2gIZHVQRx7/QFfdKebK2RUUViexl9+Y7Drh9mT9RbvBVdtBHLczXf5wnrXCcYvDPKfD8u4DRjJtNJ9kLDOwTl8ZES4dlBQH/b5tkWOxER3jV7H2EuFRmhgnmXUgkc1P3VQAlaWvXR1g2EePZpsOpu06s0+B6AjeGsoK9mjrxEb/yR9+l0R5RrasHJfjXKmOI9rzH6dghKRm+ROHRKqFvx4zDztv11TMV11StqP0DCwpgYFAN6AY2U2e54BvqpkrYbXV0GQlVUQ5FJV/xforL85jaXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.176.1.74) smtp.rcpttodomain=davemloft.net smtp.mailfrom=ericsson.com;
 dmarc=pass (p=reject sp=none pct=100) action=none header.from=ericsson.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgQxG6TlrgICAKQV4NCXrJtKEc4zaEH2oRmpMH2Pue4=;
 b=IZKWKkZedhYurAQtyNsJeMHDFcm9hYcCRQHt5Nt8XpUQbAKYPh5O3j9Nn1kpymh8TuXmokYzbH5V/fMn0MhMPrjhjNAcYXXqCCNC7iUd9GwkQ3Cmnq6uh3YWm1lMy00GrI7VKdjoFDZdx32hBWaY9Tj+OwvFz4i9csInqwaNuII=
Received: from VI1PR07CA0171.eurprd07.prod.outlook.com (2603:10a6:802:3e::19)
 by PR1PR07MB4939.eurprd07.prod.outlook.com (2603:10a6:102:1::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.4; Mon, 9 Dec
 2019 23:52:50 +0000
Received: from AM5EUR02FT011.eop-EUR02.prod.protection.outlook.com
 (2a01:111:f400:7e1e::207) by VI1PR07CA0171.outlook.office365.com
 (2603:10a6:802:3e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.6 via Frontend
 Transport; Mon, 9 Dec 2019 23:52:50 +0000
Authentication-Results: spf=pass (sender IP is 192.176.1.74)
 smtp.mailfrom=ericsson.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=ericsson.com;
Received-SPF: Pass (protection.outlook.com: domain of ericsson.com designates
 192.176.1.74 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.176.1.74; helo=oa.msg.ericsson.com;
Received: from oa.msg.ericsson.com (192.176.1.74) by
 AM5EUR02FT011.mail.protection.outlook.com (10.152.8.101) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.20.2495.18 via Frontend Transport; Mon, 9 Dec 2019 23:52:48 +0000
Received: from ESESSMB505.ericsson.se (153.88.183.166) by
 ESESBMR506.ericsson.se (153.88.183.202) with Microsoft SMTP Server
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
Subject: [net-next 1/3] tipc: eliminate gap indicator from ACK messages
Date:   Tue, 10 Dec 2019 00:52:44 +0100
Message-ID: <1575935566-18786-2-git-send-email-jon.maloy@ericsson.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1575935566-18786-1-git-send-email-jon.maloy@ericsson.com>
References: <1575935566-18786-1-git-send-email-jon.maloy@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.176.1.74;IPV:NLI;CTRY:SE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(136003)(346002)(189003)(199004)(356004)(6666004)(956004)(44832011)(305945005)(4326008)(478600001)(15650500001)(2906002)(7636002)(36756003)(26005)(70586007)(336012)(8676002)(86362001)(110136005)(54906003)(2616005)(5660300002)(316002)(426003)(8936002)(70206006)(246002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:PR1PR07MB4939;H:oa.msg.ericsson.com;FPR:;SPF:Pass;LANG:en;PTR:office365.se.ericsson.net;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 099bffaf-0c21-478d-22a1-08d77d02e573
X-MS-TrafficTypeDiagnostic: PR1PR07MB4939:
X-LD-Processed: 92e84ceb-fbfd-47ab-be52-080c6b87953f,ExtAddr
X-Microsoft-Antispam-PRVS: <PR1PR07MB4939A2B5D5BE4FA203E472319A580@PR1PR07MB4939.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 02462830BE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ziOl5t9RE/i2M6i+4s3YltD+qjwZiNYY8v/O+B+Xa5J5rc6iu1J3zNnE7smxxDn5tGeza5Gm5F15JSkNj7wd/V5cbsIbdErqlrLNIH+FkW1qjiMEOE3Mx2ZICHHtUlRSjOajOc9xRk7WQLMVyu8UALG8l0YIc4dslnQ48wxx/HENdjY1MZuShL3P7arA+hX5cyTqe3GoHbSk8Rk6psUC5Wut0arz6ynDX5YCXumquBYeCwTKEMISg18KWs7CAsQtkvYhmnf5Or/cvTrlCjT6XYhaI+TFu5Der0nf8FRXUWCelmbEkpqO2pHk8vBhD+p94EolKR5/6TgyQxG0uH+YWb5sYDdEL0j1dRiG6WnFZLny1CGLhyV77m0M9JuLkBKuCSeJL+nQ6rd9v0tDXEJISt5bInlixrqMKze1iFNs7Cp3dLIqEJuvDSffeA+nyygr
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2019 23:52:48.8568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 099bffaf-0c21-478d-22a1-08d77d02e573
X-MS-Exchange-CrossTenant-Id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=92e84ceb-fbfd-47ab-be52-080c6b87953f;Ip=[192.176.1.74];Helo=[oa.msg.ericsson.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1PR07MB4939
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we increase the link send window we sometimes observe the
following scenario:

1) A packet #N arrives out of order far ahead of a sequence of older
   packets which are still under way. The packet is added to the
   deferred queue.
2) The missing packets arrive in sequence, and for each 16th of them
   an ACK is sent back to the receiver, as it should be.
3) When building those ACK messages, it is checked if there is a gap
   between the link's 'rcv_nxt' and the first packet in the deferred
   queue. This is always the case until packet number #N-1 arrives, and
   a 'gap' indicator is added, effectively turning them into NACK
   messages.
4) When those NACKs arrive at the sender, all the requested
   retransmissions are done, since it is a first-time request.

This sometimes leads to a huge amount of redundant retransmissions,
causing a drop in max throughput. This problem gets worse when we
in a later commit introduce variable window congestion control,
since it drops the link back to 'fast recovery' much more often
than necessary.

We now fix this by not sending any 'gap' indicator in regular ACK
messages. We already have a mechanism for sending explicit NACKs
in place, and this is sufficient to keep up the packet flow.

Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
---
 net/tipc/link.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 24d4d10..6d86446 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1521,7 +1521,8 @@ static int tipc_link_build_nack_msg(struct tipc_link *l,
 				    struct sk_buff_head *xmitq)
 {
 	u32 def_cnt = ++l->stats.deferred_recv;
-	u32 defq_len = skb_queue_len(&l->deferdq);
+	struct sk_buff_head *dfq = &l->deferdq;
+	u32 defq_len = skb_queue_len(dfq);
 	int match1, match2;
 
 	if (link_is_bc_rcvlink(l)) {
@@ -1532,8 +1533,12 @@ static int tipc_link_build_nack_msg(struct tipc_link *l,
 		return 0;
 	}
 
-	if (defq_len >= 3 && !((defq_len - 3) % 16))
-		tipc_link_build_proto_msg(l, STATE_MSG, 0, 0, 0, 0, 0, xmitq);
+	if (defq_len >= 3 && !((defq_len - 3) % 16)) {
+		u16 rcvgap = buf_seqno(skb_peek(dfq)) - l->rcv_nxt;
+
+		tipc_link_build_proto_msg(l, STATE_MSG, 0, 0,
+					  rcvgap, 0, 0, xmitq);
+	}
 	return 0;
 }
 
@@ -1631,7 +1636,7 @@ static void tipc_link_build_proto_msg(struct tipc_link *l, int mtyp, bool probe,
 	if (!tipc_link_is_up(l) && (mtyp == STATE_MSG))
 		return;
 
-	if (!skb_queue_empty(dfq))
+	if ((probe || probe_reply) && !skb_queue_empty(dfq))
 		rcvgap = buf_seqno(skb_peek(dfq)) - l->rcv_nxt;
 
 	skb = tipc_msg_create(LINK_PROTOCOL, mtyp, INT_H_SIZE,
@@ -2079,7 +2084,6 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 		if (rcvgap || reply)
 			tipc_link_build_proto_msg(l, STATE_MSG, 0, reply,
 						  rcvgap, 0, 0, xmitq);
-
 		rc |= tipc_link_advance_transmq(l, ack, gap, ga, xmitq);
 
 		/* If NACK, retransmit will now start at right position */
-- 
2.1.4

