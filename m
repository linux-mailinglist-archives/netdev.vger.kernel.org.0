Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A11117BD3
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 00:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfLIXwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 18:52:55 -0500
Received: from mail-eopbgr50083.outbound.protection.outlook.com ([40.107.5.83]:48002
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727235AbfLIXwx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 18:52:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AW/9ZYCdFfYLadYWKdfXtw5RlZTT4LNqbFKkegMpwYYg0Iy3gNiRPk3s0Y+idDbNI8MKAlbxWfnxPiO7HQNGcuzFkZIUdFkOts0PB8z7jQHdJofsy+/5PR18QZ6Dm4QleQ2W/tpyg1mHsd5UiwFPHa0wRja1KK9cm/fbSwjVsT5+PHVmkOg5rPzwMVJ5oa2uN0rToEwCoFypoA/gtMNTYdL3w8ix+1B8TZGaYG/3yHoykOEJYi+YEAZMU/DA6dKvLNjx9KT4qenNmRJgwZagpfrAZ/n1PpWr7J4QvNQSxBJ3HVkosB7nuje/B1Xskua7vrCJb/fEswqFSetoveqB2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//L6dAzMb8N1amnab6D6/XUqQEte6SQG8xC9oQtHff0=;
 b=AianXtyCFmeLbp/m4Rf0Jx+n6N/OSTxe5cA1FtrYw8XhfmRsXyZvyZ4JePhVXziOFCZBhh741i9u84YbhH3fVBaFysXDHX9y0mO972aALlJ5TitPG6IMlVy6a3k7lcYkTEmCKWL8UsGTkFfR9BVAyTXtKJrJeRXXJkpeOD2lxb5WpE1GNRXfTzzIdnuxMmAjQsmEW7TCgfl+pW4sIeDckUtiw/jiq5ZIPpWfhWTwTqF370KF1T0Z17coKGCEn59sIKlpVHJvtT1YmDiPLbHiqxpqMI4fCVViQpgPesQlvtjwc0dPr/tdTw7yidX9JbK0EHlIBumZgHHkvRXw0y2hDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.176.1.74) smtp.rcpttodomain=davemloft.net smtp.mailfrom=ericsson.com;
 dmarc=pass (p=reject sp=none pct=100) action=none header.from=ericsson.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//L6dAzMb8N1amnab6D6/XUqQEte6SQG8xC9oQtHff0=;
 b=Y+DnTpCCA7uEyuc5TUH/IYXw1/a6z6XX03KFSKmvt+R1OBQDTagJAPu/SV+IVb9oEdW1G1GNmymXE4wQMRQT/z+ACI/f9zuNZkeCs5XkqIYpBqJ/TSKoVw7YIaQR5UU17M4uF3ekY1TUQJBpInya5vRd5ZISqkbsXXhH4z1UwTE=
Received: from HE1PR0701CA0048.eurprd07.prod.outlook.com (2603:10a6:3:9e::16)
 by DB6PR07MB3078.eurprd07.prod.outlook.com (2603:10a6:6:25::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.4; Mon, 9 Dec
 2019 23:52:49 +0000
Received: from VE1EUR02FT047.eop-EUR02.prod.protection.outlook.com
 (2a01:111:f400:7e06::201) by HE1PR0701CA0048.outlook.office365.com
 (2603:10a6:3:9e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.6 via Frontend
 Transport; Mon, 9 Dec 2019 23:52:49 +0000
Authentication-Results: spf=pass (sender IP is 192.176.1.74)
 smtp.mailfrom=ericsson.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=ericsson.com;
Received-SPF: Pass (protection.outlook.com: domain of ericsson.com designates
 192.176.1.74 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.176.1.74; helo=oa.msg.ericsson.com;
Received: from oa.msg.ericsson.com (192.176.1.74) by
 VE1EUR02FT047.mail.protection.outlook.com (10.152.13.237) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.20.2495.18 via Frontend Transport; Mon, 9 Dec 2019 23:52:47 +0000
Received: from ESESSMB505.ericsson.se (153.88.183.166) by
 ESESSMR502.ericsson.se (153.88.183.110) with Microsoft SMTP Server
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
Subject: [net-next 2/3] tipc: eliminate more unnecessary nacks and retransmissions
Date:   Tue, 10 Dec 2019 00:52:45 +0100
Message-ID: <1575935566-18786-3-git-send-email-jon.maloy@ericsson.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1575935566-18786-1-git-send-email-jon.maloy@ericsson.com>
References: <1575935566-18786-1-git-send-email-jon.maloy@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.176.1.74;IPV:NLI;CTRY:SE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(346002)(189003)(199004)(26005)(956004)(426003)(316002)(336012)(110136005)(2616005)(44832011)(70206006)(70586007)(246002)(5660300002)(356004)(4326008)(36756003)(2906002)(478600001)(8936002)(186003)(7636002)(305945005)(86362001)(54906003)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR07MB3078;H:oa.msg.ericsson.com;FPR:;SPF:Pass;LANG:en;PTR:office365.se.ericsson.net;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f9a0099-7a5f-4b62-4082-08d77d02e4ee
X-MS-TrafficTypeDiagnostic: DB6PR07MB3078:
X-LD-Processed: 92e84ceb-fbfd-47ab-be52-080c6b87953f,ExtAddr
X-Microsoft-Antispam-PRVS: <DB6PR07MB30787D62106F92506AEABBBF9A580@DB6PR07MB3078.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 02462830BE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ub+MNmCTzZpveHlKGL6BWJlrBIKvyIoO8YqGHfy4+wivs35gw2uqv5fIZE/ORg0VhSwcFMVE+RavLnyKrwWa08tp9kYIj6eSS2z9Hux8bGg7kKE0NWcLIueq/21tfR1/akRb6MvfyNOW7yNpmPJSopKd3GmKkBgVAa0kYwDidkDsysQ8gMemAVjAAqmSxLoHuJNedS0dg4aMVDOqwhLbwjGVBm5bT2DT22nW6x56RaSGD0jzbi8FrvFZqtvnyJKwuRSiL2LFCzRR39bod4QbBRrPIZVyYTPQlrfcfNP8nNPs0+bU/FZIlrDez9FQ5qAs0ZXQpnZW9CV4DcJ6P+CK8auX9Je9VgsYTlZ8RDzUrTnt1w27UFVOopk48D9nc4rvNthOYv7Es6oipgPcpHWPWb8RNotlI44py5YUp0SYX2fQAGmZMkF54I7KgkZt+sA
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2019 23:52:47.9719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f9a0099-7a5f-4b62-4082-08d77d02e4ee
X-MS-Exchange-CrossTenant-Id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=92e84ceb-fbfd-47ab-be52-080c6b87953f;Ip=[192.176.1.74];Helo=[oa.msg.ericsson.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR07MB3078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we increase the link tranmsit window we often observe the following
scenario:

1) A STATE message bypasses a sequence of traffic packets and arrives
   far ahead of those to the receiver. STATE messages contain a
   'peers_nxt_snt' field to indicate which was the last packet sent
   from the peer. This mechanism is intended as a last resort for the
   receiver to detect missing packets, e.g., during very low traffic
   when there is no packet flow to help early loss detection.
3) The receiving link compares the 'peer_nxt_snt' field to its own
   'rcv_nxt', finds that there is a gap, and immediately sends a
   NACK message back to the peer.
4) When this NACKs arrives at the sender, all the requested
   retransmissions are performed, since it is a first-time request.

Just like in the scenario described in the previous commit this leads
to many redundant retransmissions, with decreased throughput as a
consequence.

We fix this by adding two more conditions before we send a NACK in
this sitution. First, the deferred queue must be empty, so we cannot
assume that the potential packet loss has already been detected by
other means. Second, we check the 'peers_snd_nxt' field only in probe/
probe_reply messages, thus turning this into a true mechanism of last
resort as it was really meant to be.

Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
---
 net/tipc/link.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 6d86446..3528181 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -2079,8 +2079,12 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 			     &l->mon_state, l->bearer_id);
 
 		/* Send NACK if peer has sent pkts we haven't received yet */
-		if (more(peers_snd_nxt, rcv_nxt) && !tipc_link_is_synching(l))
+		if ((reply || msg_is_keepalive(hdr)) &&
+		    more(peers_snd_nxt, rcv_nxt) &&
+		    !tipc_link_is_synching(l) &&
+		    skb_queue_empty(&l->deferdq))
 			rcvgap = peers_snd_nxt - l->rcv_nxt;
+
 		if (rcvgap || reply)
 			tipc_link_build_proto_msg(l, STATE_MSG, 0, reply,
 						  rcvgap, 0, 0, xmitq);
-- 
2.1.4

