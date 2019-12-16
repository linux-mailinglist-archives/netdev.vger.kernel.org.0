Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA0B12157E
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 19:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732211AbfLPSVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 13:21:11 -0500
Received: from mail-eopbgr150070.outbound.protection.outlook.com ([40.107.15.70]:38819
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732201AbfLPSVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 13:21:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRrmRNd7GhZfTR92wbYb3lNIU0MIWgwfvwxhbAqGuJ+HAtnZNXw6KQjpltA4XkZnIbq527N+SsfWAaLI+2G6PK30Ub8eAYqcWbmbjJqpdIb373EZ1JvGfLN4v+LssHl4k9BQRYD+2Qct2Q8lEMb3FnBBWtPpBOPkAT5AqAP50BLqO+qYEEPctVQ7AclQOMAorZlN9t7E9+pFkUbLJPcJMhjOViobbqUlCXEWtaJCO+04POLmKxHlTIa8Wjq1wbTNnGGQOpTlv+eiMy244lj0SOwnEDLM0eo9QkdabLwBwbEr9/tG2Oyi24WNHPuDqvhnYM9JXYzI/6SE6c7hcEy9Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=viW1qYbB+yvk+GkmYZ9uaxzzjMfMZlaX24nPPfw7+NU=;
 b=Bw9QczbJAuffcxI9NqvPx1l9GtWJmFc4S1NHiWks9+WQ78y8xdjMz81qLYn4mYaSGZCJN3QGbMGorR+PHZWZnVDvBuV8GQ8hMxAl6mqVbjn2WEJI7FzyI2Rt6J+f6rnLy83y3v8OE2PFCB5ZinxrvF7zp1YOTdO+3qQzWVTOEoAeuj/PKwiwOC9sH77eIYFUixPgdqwsB40JYbYl1a1qPG+3SEp0xxe21jS3Rk9lrYRIPatgfvVUZXA+/e+xo1d4KiGGBRFpasGNJW7Z6pEDzq8MTP0hAs5nMS221PC+QAu/UVio9Dvws4eja3TTKOLME/H9Lo7pxpOHyMs+acGAUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.176.1.74) smtp.rcpttodomain=davemloft.net smtp.mailfrom=ericsson.com;
 dmarc=pass (p=reject sp=none pct=100) action=none header.from=ericsson.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=viW1qYbB+yvk+GkmYZ9uaxzzjMfMZlaX24nPPfw7+NU=;
 b=ilopCXwV3uiGX0lV/pcSxOtj4HNz6VNJ7IoizS0Ct/nT7pmeo+CebnNMKcJJ+i5MBNPSWWhwhXbL3MKOGLNvBokQB3W7JjlaN64GUHIKwOgF+hguoINOy3sIyCz6g5+AKaXN8Qu48IGj+AV2GIdI8326sQUbsGxlZMde2GF0hW4=
Received: from VI1PR07CA0234.eurprd07.prod.outlook.com (2603:10a6:802:58::37)
 by AM0PR07MB4980.eurprd07.prod.outlook.com (2603:10a6:208:eb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.11; Mon, 16 Dec
 2019 18:21:04 +0000
Received: from HE1EUR02FT013.eop-EUR02.prod.protection.outlook.com
 (2a01:111:f400:7e05::205) by VI1PR07CA0234.outlook.office365.com
 (2603:10a6:802:58::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.11 via Frontend
 Transport; Mon, 16 Dec 2019 18:21:04 +0000
Authentication-Results: spf=pass (sender IP is 192.176.1.74)
 smtp.mailfrom=ericsson.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=ericsson.com;
Received-SPF: Pass (protection.outlook.com: domain of ericsson.com designates
 192.176.1.74 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.176.1.74; helo=oa.msg.ericsson.com;
Received: from oa.msg.ericsson.com (192.176.1.74) by
 HE1EUR02FT013.mail.protection.outlook.com (10.152.10.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.20.2538.14 via Frontend Transport; Mon, 16 Dec 2019 18:21:03 +0000
Received: from ESESBMB505.ericsson.se (153.88.183.172) by
 ESESBMR503.ericsson.se (153.88.183.135) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Mon, 16 Dec 2019 19:21:02 +0100
Received: from tipsy.lab.linux.ericsson.se (153.88.183.153) by
 smtp.internal.ericsson.com (153.88.183.188) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 16 Dec 2019 19:21:02 +0100
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <tung.q.nguyen@dektech.com.au>, <hoang.h.le@dektech.com.au>,
        <jon.maloy@ericsson.com>, <lxin@redhat.com>, <shuali@redhat.com>,
        <ying.xue@windriver.com>, <edumazet@google.com>,
        <tipc-discussion@lists.sourceforge.net>
Subject: [net-next  1/1] tipc: don't send gap blocks in ACK messages
Date:   Mon, 16 Dec 2019 19:21:02 +0100
Message-ID: <1576520462-25952-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.176.1.74;IPV:;CTRY:SE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(39860400002)(376002)(396003)(199004)(189003)(8936002)(86362001)(8676002)(70206006)(70586007)(15650500001)(110136005)(54906003)(336012)(426003)(4326008)(7636002)(2906002)(36756003)(186003)(44832011)(356004)(5660300002)(316002)(246002)(478600001)(26005)(956004)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR07MB4980;H:oa.msg.ericsson.com;FPR:;SPF:Pass;LANG:en;PTR:office365.se.ericsson.net;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91617536-e22e-4d34-5aa9-08d78254b5dc
X-MS-TrafficTypeDiagnostic: AM0PR07MB4980:
X-LD-Processed: 92e84ceb-fbfd-47ab-be52-080c6b87953f,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR07MB49801567CD679D77738612E69A510@AM0PR07MB4980.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 02530BD3AA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: djFkL+a2LNb/7HdPev+9ladbO2S+V6TbAsMlRixvwiytUFxVLq64rp/xpps/pPBZtO9VKPAqG5mHz8DtbF3v1iLniYZixV/PAMPRMv6mEylS5qvPtDuVps4zgpq5GZPW3cG1LV5mET6Z0OW7fQPuhgwrJaxvhiDSkAWHdAbLUlp8dllD8v2lJ4/VWqhD8pYJ0mpxRv4OcKCTze6RWuefPrqPW8FJZlzXo2rFcyRprUuRFK+kpf1VvHR7Xw+wYvVoCzRLSzdarbNf59KSZJ7ZmENmr9RfJ1Kfb7AAkIEXrjZAPewIZBnlFrY0mRCCOQGR7K+hrZr9ryqZ0aNmmJJjKdXKHy1vYxxPvXQjmPNPTQuT3PzTek4rBXuvh9zAHgj/w1Gu/hG468S7ECYG6RfycoLv6dJPC52oyxLckk1p6qtCJU84fbZKKdiwJdhctg+d
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2019 18:21:03.5925
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91617536-e22e-4d34-5aa9-08d78254b5dc
X-MS-Exchange-CrossTenant-Id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=92e84ceb-fbfd-47ab-be52-080c6b87953f;Ip=[192.176.1.74];Helo=[oa.msg.ericsson.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB4980
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the commit referred to below we eliminated sending of the 'gap'
indicator in regular ACK messages, reserving this to explicit NACK
ditto.

Unfortunately we missed to also eliminate building of the 'gap block'
area in ACK messages. This area is meant to report gaps in the
received packet sequence following the initial gap, so that lost
packets can be retransmitted earlier and received out-of-sequence
packets can be released earlier. However, the interpretation of those
blocks is dependent on a complete and correct sequence of gaps and
acks. Hence, when the initial gap indicator is missing a single gap
block will be interpreted as an acknowledgment of all preceding
packets. This may lead to packets being released prematurely from the
sender's transmit queue, with easily predicatble consequences.

We now fix this by not building any gap block area if there is no
initial gap to report.

Fixes: commit 02288248b051 ("tipc: eliminate gap indicator from ACK messages")
Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
---
 net/tipc/link.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 94dd48c..467c53a 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -250,7 +250,7 @@ static int tipc_link_build_nack_msg(struct tipc_link *l,
 static void tipc_link_build_bc_init_msg(struct tipc_link *l,
 					struct sk_buff_head *xmitq);
 static int tipc_link_release_pkts(struct tipc_link *l, u16 to);
-static u16 tipc_build_gap_ack_blks(struct tipc_link *l, void *data);
+static u16 tipc_build_gap_ack_blks(struct tipc_link *l, void *data, u16 gap);
 static int tipc_link_advance_transmq(struct tipc_link *l, u16 acked, u16 gap,
 				     struct tipc_gap_ack_blks *ga,
 				     struct sk_buff_head *xmitq);
@@ -1423,14 +1423,14 @@ static int tipc_link_release_pkts(struct tipc_link *l, u16 acked)
  *
  * returns the actual allocated memory size
  */
-static u16 tipc_build_gap_ack_blks(struct tipc_link *l, void *data)
+static u16 tipc_build_gap_ack_blks(struct tipc_link *l, void *data, u16 gap)
 {
 	struct sk_buff *skb = skb_peek(&l->deferdq);
 	struct tipc_gap_ack_blks *ga = data;
 	u16 len, expect, seqno = 0;
 	u8 n = 0;
 
-	if (!skb)
+	if (!skb || !gap)
 		goto exit;
 
 	expect = buf_seqno(skb);
@@ -1739,7 +1739,7 @@ static void tipc_link_build_proto_msg(struct tipc_link *l, int mtyp, bool probe,
 		msg_set_probe(hdr, probe);
 		msg_set_is_keepalive(hdr, probe || probe_reply);
 		if (l->peer_caps & TIPC_GAP_ACK_BLOCK)
-			glen = tipc_build_gap_ack_blks(l, data);
+			glen = tipc_build_gap_ack_blks(l, data, rcvgap);
 		tipc_mon_prep(l->net, data + glen, &dlen, mstate, l->bearer_id);
 		msg_set_size(hdr, INT_H_SIZE + glen + dlen);
 		skb_trim(skb, INT_H_SIZE + glen + dlen);
-- 
2.1.4

