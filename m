Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B277F3E87A1
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 03:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhHKBXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 21:23:10 -0400
Received: from mail-db8eur05on2109.outbound.protection.outlook.com ([40.107.20.109]:51392
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229827AbhHKBXA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 21:23:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXfcbDNr+ZjU4BLtrvubAe0u9ws/2PxqFRy1JqEKSxidj07jeSMMlcL9BkoLiLnSwNDtKGQglmtM6WtrzcgQGSSCegj2mezX25EPkOVnRvpXi91YrbvapKtUoiwOufPt7zH6NXoX2lUCYTdgsBNEUvYtYuEprwjsCq8dxtVGOkb67eTGOQ6TVfaaX0UfP73Mu6bBn7voizvkksRo9mApq/o7i4DRkhBJRO92xwYPKNPJgS6YVuRLhKAQH7rVKpwRWhcbNZEAD1nF20gPwERmRNQhl4FQqqFkPLbkP+WwTzWjF/Km5nI/maHQb6gUqfVKzkJtqBu8Lb1yEpMJIyzasw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sPKvUFHIXJZVOfE4Cl0GSuagq3IEw2bOeYt5+KsOCMQ=;
 b=M1MlkS0fTxJP9PwJTrSZvbCH6AmUDWCfMVQotvmpOcco/vHKktKZVu55KGCW4Xyq2xl9d7jpDJMZjeAUmjyuOuR6LOB5Cxb5Rsd+pLrSwmHfEBYfomAKK9RJI1P9189CAawE39KDFQNDbwxEWmYY7LZxFP/8C/8fsMKMU5lsr+xJwX0HZTqXdiloMyIpp95VWF1FEeqF39FWj8cq4exLZmo6mQC995UYjbHGdiVQgOFsMvl7E1AOQ9sYbhMtQfbkO4gFXx3O7TirCkgdZ1xaEB36M+60klxRagiShaXSZDOq9zMLZv0NN3XC5J9ndZ92fR1bVnY2pyp8mRcw0eMCKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sPKvUFHIXJZVOfE4Cl0GSuagq3IEw2bOeYt5+KsOCMQ=;
 b=a3tTeZ7Zmis2nIznoKBTDGHp6E+0iyEA7HFoqfoQHItp1b6nYz/C325hsZDhUAuUPYDZ+clgSoksfAI3R3QhfAPOa9hsoe11JAPnyC7HsyHS0dNV3M6gPDjHtd5hadlxXpOqtVQr7Uv23+0b2rRc5T+fd/uI4S9ITWeWOApTRY4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=dektech.com.au;
Received: from VE1PR05MB7327.eurprd05.prod.outlook.com (2603:10a6:800:1b0::18)
 by VI1PR05MB4973.eurprd05.prod.outlook.com (2603:10a6:803:60::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Wed, 11 Aug
 2021 01:22:32 +0000
Received: from VE1PR05MB7327.eurprd05.prod.outlook.com
 ([fe80::7c44:79b3:a21a:9c87]) by VE1PR05MB7327.eurprd05.prod.outlook.com
 ([fe80::7c44:79b3:a21a:9c87%7]) with mapi id 15.20.4394.023; Wed, 11 Aug 2021
 01:22:32 +0000
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        zhengyongjun3@huawei.com, tung.q.nguyen@dektech.com.au,
        tipc-discussion@lists.sourceforge.net
Subject: [net] Revert "tipc: Return the correct errno code"
Date:   Wed, 11 Aug 2021 08:22:09 +0700
Message-Id: <20210811012209.4589-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0018.apcprd02.prod.outlook.com
 (2603:1096:3:17::30) To VE1PR05MB7327.eurprd05.prod.outlook.com
 (2603:10a6:800:1b0::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (171.252.154.210) by SG2PR02CA0018.apcprd02.prod.outlook.com (2603:1096:3:17::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15 via Frontend Transport; Wed, 11 Aug 2021 01:22:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e93bc07d-da40-47d9-41c2-08d95c667df1
X-MS-TrafficTypeDiagnostic: VI1PR05MB4973:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4973F277A549C68A49F492E1F1F89@VI1PR05MB4973.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:321;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ycbVNLqhHv993MK0C4CwcgRZq78uKVTdP4J32LO1aDyW0aY47OMo06jZhXswZkwNh6r0Z7EuRwK+7/B2hujGYB6pGmEHHlG7z6fgLgaF4T9Ig4zw5lUVWr8fCuES+6AX7zC85/9VhZh8BKgpIicjfHIv6fCm5wNiPzYzQ/yA9Pe4HyZm2otYs/fGs0+tXVZrC3xFDhaWgfSyALG05NQqwt50B8n1tG3VyMwa4RmHALt01TSXNeW4duJsxf4u78LZkiz4Y8dNVxCfb4o4L3LWIpeFiDSmn7uWuigqycal1QcB9wF8vvXF9dRMbWRWP2sJ1+8Xh/IuySCL4yTLuI6C2zT6u8kV5QhpVutWeYGC89AmBq8i1S1t+26pEos4ysBUqVE1cvVvoxN9SBekI0Bbp1NYyQAIdZiwV9MARMGzVFyZ9PAtOpwpupk/8Y7UIFoT8GZqBhYZ0RWInncR7TtClFiEUv2u71JdLY/lzTHyN1YrJCDZyGL8ssPv5d+R1YtUwxI0pmOAvABxpZrlyeSYTSLdHfEfUD6k89qWAJXNiFILU0IBz42O9mUzxyQEAP8tBXAWsi/QUfcYpO+ONDjwzRMz+MHOmpsRYy1D5w9FQO1EZRDoVWC8eaImaX0ufetYMSDzH1uGUgbJ3yIZuYtRk2BKUheIRSEuQXjVATD/I1byJMCpgUx8zp+WrrOhuyJk9P00Ztg2sT1b9Y6Drwhmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR05MB7327.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39830400003)(55016002)(956004)(2616005)(186003)(2906002)(38350700002)(38100700002)(8676002)(8936002)(1076003)(83380400001)(86362001)(52116002)(5660300002)(478600001)(36756003)(103116003)(6666004)(66946007)(66476007)(66556008)(26005)(7696005)(316002)(55236004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hg9kWDylRbiIUTjAPf0jLlc2U3xtyJjhJhPgI8ozm50EBLanbEbcJ/0PkDck?=
 =?us-ascii?Q?Xqsu2vLQOVJTxkUcDGT4hinhCXir/ug9MnxpIoQkqU5T7hvDUyAloGq7E5xi?=
 =?us-ascii?Q?c/Nu9rwpRYsoSDUlqiB4yugM2n/agk75oRYYq6GehAl49Fka7FQDq3KSqpem?=
 =?us-ascii?Q?DG790a0WcU61Y+sd8uFM395Ip7dYukiYYOGT+Lu+82nbaatea7m1QxA31osU?=
 =?us-ascii?Q?c9g6W7rbOXXZg+YF/NFSUiKa5enAizbNjazuk5O5ZBD8bbbuQyHEeC0cJdDY?=
 =?us-ascii?Q?mZgjJJnNz30OpvBKPNwFzfeAyg4GZ3D3pi43CPyE2z35tZiv1kvMCXAxeX0P?=
 =?us-ascii?Q?ANXOwiLTr8I/aVprbrD2bGCau8oziQLEv1puEY+HZezr9u4xVhzdCTjTcYmM?=
 =?us-ascii?Q?PLVK/phdW26gkoAcoSwju1UIIr5dHMSdCnMo1/UBkaCYMHZHjHi5M6Pxo3u7?=
 =?us-ascii?Q?mQo79aE0uqlzgTVZ+K0FEWdpykqxUKiuQgppUHTT1mE5ZEXreuFcb/BC6Z3m?=
 =?us-ascii?Q?rtj+XUPPtRe3ewv90PBMQftVzktUk4BfudoJY0dSIjmGgRm1zjv16OrjvckB?=
 =?us-ascii?Q?sBpKbcPcnBJUqmp96icLy+OIPtHDcbfOY/yEmfhJbH+B2EhogRjdQqXA6dkQ?=
 =?us-ascii?Q?qCzL+9/trZlMbOHSHOyMTg91RnB/+RHR2rTWg9ls9lHbEIWwzMIjiZAkhc+y?=
 =?us-ascii?Q?rzr9gv3OHpz/UWlZP9PYTv2aOvLGroTygmRndZ1dj9+WQLCSIAQPQet2nWgA?=
 =?us-ascii?Q?zdCXbmg5k5RxFT/7NcqUh2MoV8D3npufJaYA/P0vZWjpa/Yh48TbUY7CppId?=
 =?us-ascii?Q?HrZ/4PbGaGbRNqR/InqBsFcaq9QntbyaPvTyq5du94wk/2StzLFKK6MfLyH4?=
 =?us-ascii?Q?zDMlHH2yW4ekNVPc/6VjHBPYnAJ3EaRQbd+KfCf8aBaTOyrXf6og5Ls7j88E?=
 =?us-ascii?Q?t8ZnUFLjxL1Jl+bkxHErsdI9EaqqHuipAq1yaodlHzyYIho23SwrAeC9mMzY?=
 =?us-ascii?Q?ePUycJLh7ETVoMFZ/fm59LkuU6kKOxcU3/aHOgydt0MdY8G4oSvL1BXyQ8VC?=
 =?us-ascii?Q?NvFBjYMSIxVG4EUZxhTWrdTPK9JUd0wqZ0hKpHNPHrP2RKDqH787P/I7ytVe?=
 =?us-ascii?Q?WdVJ8mYU313N0n9K30Auuxs4JbvojZE1uv40phgJshVQZLDIuVAeNJMVKycs?=
 =?us-ascii?Q?o3lpgubCFlsGHxwTVW82sFIuOpuryNm13kwGADbh9smfcpgZ0pnhLnSRW2Q+?=
 =?us-ascii?Q?X0M8KTBmSaKd0ZOLczHWqfs+0/xr0296YVEDOoHvSfFqtWVZ3kVTyBimi9R4?=
 =?us-ascii?Q?l5+0im3BKYc7tmfut56w4uBB?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: e93bc07d-da40-47d9-41c2-08d95c667df1
X-MS-Exchange-CrossTenant-AuthSource: VE1PR05MB7327.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2021 01:22:32.2383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YNvmBEqqOFeNEWbUF9Z3UD4rB9/jhZN6dMo0PtH0O4lRosttM4BYyLm3us6aeUx8WPjEkTPF0avUJMkoppxyohCSTjqIeFYd6TFSFSl4nLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4973
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 0efea3c649f0 because of:
- The returning -ENOBUF error is fine on socket buffer allocation.
- There is side effect in the calling path
tipc_node_xmit()->tipc_link_xmit() when checking error code returning.

Fixes: 0efea3c649f0 ("tipc: Return the correct errno code")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/link.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index cf586840caeb..1b7a487c8841 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -913,7 +913,7 @@ static int link_schedule_user(struct tipc_link *l, struct tipc_msg *hdr)
 	skb = tipc_msg_create(SOCK_WAKEUP, 0, INT_H_SIZE, 0,
 			      dnode, l->addr, dport, 0, 0);
 	if (!skb)
-		return -ENOMEM;
+		return -ENOBUFS;
 	msg_set_dest_droppable(buf_msg(skb), true);
 	TIPC_SKB_CB(skb)->chain_imp = msg_importance(hdr);
 	skb_queue_tail(&l->wakeupq, skb);
@@ -1031,7 +1031,7 @@ void tipc_link_reset(struct tipc_link *l)
  *
  * Consumes the buffer chain.
  * Messages at TIPC_SYSTEM_IMPORTANCE are always accepted
- * Return: 0 if success, or errno: -ELINKCONG, -EMSGSIZE or -ENOBUFS or -ENOMEM
+ * Return: 0 if success, or errno: -ELINKCONG, -EMSGSIZE or -ENOBUFS
  */
 int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 		   struct sk_buff_head *xmitq)
@@ -1089,7 +1089,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 			if (!_skb) {
 				kfree_skb(skb);
 				__skb_queue_purge(list);
-				return -ENOMEM;
+				return -ENOBUFS;
 			}
 			__skb_queue_tail(transmq, skb);
 			tipc_link_set_skb_retransmit_time(skb, l);
-- 
2.30.2

