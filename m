Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062341E1ECF
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 11:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388683AbgEZJjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 05:39:00 -0400
Received: from mail-db8eur05on2125.outbound.protection.outlook.com ([40.107.20.125]:25953
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388460AbgEZJi6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 05:38:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYA/e+6fCr9nnMZmzbhMfHtuXPVSYZVG5OkBd0s8tjGJfEKjjicNlEUHvmaCzquNxNAdjpzOC8cupmMwaLc+Z3k7lZE5RO1OFbiHq83KXoronpSDivupu1iQih7B8SR0QWKG0EzHb1+EnDRomFROBhw83/q50MEgyd8ZDfCr8H3dnV2tR4+jTjOG90l+lYZkj5CkaDnLxdYBx5cvHW1GSt7USpMNyt62UA/86ThlMlHlMomAQ0exOCJ44hO8zINHtTXgH8jziu7nNT4nUybpROueoEz+U6rq+fhlsvI8VnB5X8YhxlocwdVds8zP0zTrH0m+QjK3eYEIR2mhgZgytA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6phg+zhC9qNVGaeDEfbLEztptDqWEdI8J21msTcyaJs=;
 b=AfiNhsEmo4/XxBO6T98gL/SHG+Q8FuS/upG8t4AATw2Uo8hNul7Kdii15GHhH3Qi7JaY62M9kdAjg7tZ7iQaxjK6c3THravkLUhBm4UWMwOpif4lnTQOGuQ95v9u4hOvqXl0MdIvI6rpR4wod8HcLsR2SQdqwBI7d24hTwbD5TFNGF6Yq6MQnLXHDZ+ad1OM1FDSvmxXiIQuScOlftfxwqVYxPX9bs10nVjp0vI3gh02xd0m2obXMkAVB6wQbZDBFHuYCJ3Ec7OFNIm/T+3whPtLRTfv86J42E6cJihiunQFkN2y/KCEBS4jS6bLhDaa/uNQLP7FPVZNzkHRBlTAjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6phg+zhC9qNVGaeDEfbLEztptDqWEdI8J21msTcyaJs=;
 b=BHpuSiOqi7vMDFk9seNtIdhsYeKVkHAsfR156c8wnEikleo+ND4x6fXX3+Hn876IS1Nc7ArZ9egX0f8duQIa1vHAJKOZm55sbOIXOWMo7dPQS5HAogFXXfT83mu6CE8MMc1T4pQlCjzHOHq0dxdzzNnhq8irjvO7LqedhugNyKs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
 by AM6PR0502MB3718.eurprd05.prod.outlook.com (2603:10a6:209:11::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Tue, 26 May
 2020 09:38:52 +0000
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf]) by AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 09:38:52 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next 2/5] tipc: add back link trace events
Date:   Tue, 26 May 2020 16:38:35 +0700
Message-Id: <20200526093838.17421-3-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200526093838.17421-1-tuong.t.lien@dektech.com.au>
References: <20200526093838.17421-1-tuong.t.lien@dektech.com.au>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR03CA0060.apcprd03.prod.outlook.com
 (2603:1096:202:17::30) To AM6PR0502MB3925.eurprd05.prod.outlook.com
 (2603:10a6:209:5::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by HK2PR03CA0060.apcprd03.prod.outlook.com (2603:1096:202:17::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3045.8 via Frontend Transport; Tue, 26 May 2020 09:38:49 +0000
X-Mailer: git-send-email 2.13.7
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d715283-219d-4bed-8933-08d801589989
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3718:
X-Microsoft-Antispam-PRVS: <AM6PR0502MB371877B2CCEE9F5580C29595E2B00@AM6PR0502MB3718.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:22;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YR6EoWSA7fRSU4fXRGua8wtlTlS9MyUtIrjJTOgyFyYoBVkWLYACnb9NyONU89atHizT2afFZXVkQz03iyzyEdCWXftZn9IUw0sBcgaTBu4LHo0uwX+wC5A/5saAWhL9cGyjeqfDZTreVfl7mq8UaVUGiIjmH2zFzGWQm06JgPkCUvB294/6bBP8sggKWKys7bOL4OIvciF2FkkFHyajgIHzqsvsV7zoCkbKoTCJjgnLApAOwvICzYBFHAS3//LtbwrNBX1MMtpKH9084q6o+8NKzgJSzRx18E6eFOQrA5TiytAHzntO7Zqf+7s3tuLTtck1wMHU8i1ileCVg2y7GA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0502MB3925.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(366004)(376002)(136003)(39850400004)(8676002)(16526019)(956004)(2616005)(103116003)(55016002)(186003)(6666004)(4326008)(66476007)(66556008)(2906002)(86362001)(36756003)(316002)(5660300002)(26005)(66946007)(8936002)(52116002)(1076003)(478600001)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9vo7JS8Oh/EyWdsEipB3v7MZMDCxPVlMyUyZbVtC+AdZqqmfZCuGL5LhTlfp+hY0/pqb8LZ7Fg1OrHdjP84Qg1aGaHIVoJJQA3JK7ZqBrYFreREcwuIdEGe+hSUkKAtXZfNxTR3AGLCXIr4MSD9IXDiKUvQJMQx5NuM9tzTRN6hRYw2zSzep9zBvCF5KtyGr9O1YHGT9jLTo/reiWBo/k8wS6jb8MhBs2JyfbEt0gy5Lf7B55JB0oglvd33KW5KQCCYZjQx79VR2+Hfw90PgITiJNsErxXUXd54baZGyTrVmu6R2NwhYyvi5Z0n8y7mp3FrmUP9DNFdNhsC1OHilzm1/oHaDHM58QhRH+QEI546+3ugAUYLOVurvw0fZX7IbUbsHn5duH6MkLnuehneCr1JK7Z/8wOKbUL7J9uxFfB+QkWLS4BS+HwZ5hGjAhJBFzcHDXjx7J5plvuv+eO6jGGad0Wkl2/FYEcufdxAMBfc=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d715283-219d-4bed-8933-08d801589989
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 09:38:52.1280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X/wnz3V47bLjAi58AukDMDyeoytXGaza1pu7X+/2esdo5xyAJUBuUITtAEtgYd0/lF+w1NksxtqDrJBtk/UrhLROZsVc2Byi87cLtKu/cX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3718
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the previous commit ("tipc: add Gap ACK blocks support for broadcast
link"), we have removed the following link trace events due to the code
changes:

- tipc_link_bc_ack
- tipc_link_retrans

This commit adds them back along with some minor changes to adapt to
the new code.

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/link.c  |  3 +++
 net/tipc/trace.h | 13 ++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index d29b9c531171..288c5670cfa5 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1504,6 +1504,8 @@ static int tipc_link_advance_transmq(struct tipc_link *l, struct tipc_link *r,
 	bool is_uc = !link_is_bc_sndlink(l);
 	bool bc_has_acked = false;
 
+	trace_tipc_link_retrans(r, acked + 1, acked + gap, &l->transmq);
+
 	/* Determine Gap ACK blocks if any for the particular link */
 	if (ga && is_uc) {
 		/* Get the Gap ACKs, uc part */
@@ -2410,6 +2412,7 @@ int tipc_link_bc_ack_rcv(struct tipc_link *r, u16 acked, u16 gap,
 	if (less(acked, r->acked) || (acked == r->acked && !gap && !ga))
 		return 0;
 
+	trace_tipc_link_bc_ack(r, acked, gap, &l->transmq);
 	tipc_link_advance_transmq(l, r, acked, gap, ga, xmitq, &unused, &rc);
 
 	tipc_link_advance_backlog(l, xmitq);
diff --git a/net/tipc/trace.h b/net/tipc/trace.h
index 4d8e00483afc..e7535ab75255 100644
--- a/net/tipc/trace.h
+++ b/net/tipc/trace.h
@@ -299,8 +299,10 @@ DECLARE_EVENT_CLASS(tipc_link_transmq_class,
 		__entry->from = f;
 		__entry->to = t;
 		__entry->len = skb_queue_len(tq);
-		__entry->fseqno = msg_seqno(buf_msg(skb_peek(tq)));
-		__entry->lseqno = msg_seqno(buf_msg(skb_peek_tail(tq)));
+		__entry->fseqno = __entry->len ?
+				  msg_seqno(buf_msg(skb_peek(tq))) : 0;
+		__entry->lseqno = __entry->len ?
+				  msg_seqno(buf_msg(skb_peek_tail(tq))) : 0;
 	),
 
 	TP_printk("<%s> retrans req: [%u-%u] transmq: %u [%u-%u]\n",
@@ -308,15 +310,16 @@ DECLARE_EVENT_CLASS(tipc_link_transmq_class,
 		  __entry->len, __entry->fseqno, __entry->lseqno)
 );
 
-DEFINE_EVENT(tipc_link_transmq_class, tipc_link_retrans,
+DEFINE_EVENT_CONDITION(tipc_link_transmq_class, tipc_link_retrans,
 	TP_PROTO(struct tipc_link *r, u16 f, u16 t, struct sk_buff_head *tq),
-	TP_ARGS(r, f, t, tq)
+	TP_ARGS(r, f, t, tq),
+	TP_CONDITION(less_eq(f, t))
 );
 
 DEFINE_EVENT_PRINT(tipc_link_transmq_class, tipc_link_bc_ack,
 	TP_PROTO(struct tipc_link *r, u16 f, u16 t, struct sk_buff_head *tq),
 	TP_ARGS(r, f, t, tq),
-	TP_printk("<%s> acked: [%u-%u] transmq: %u [%u-%u]\n",
+	TP_printk("<%s> acked: %u gap: %u transmq: %u [%u-%u]\n",
 		  __entry->name, __entry->from, __entry->to,
 		  __entry->len, __entry->fseqno, __entry->lseqno)
 );
-- 
2.13.7

