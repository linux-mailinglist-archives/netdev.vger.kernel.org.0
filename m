Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E9428C894
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 08:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389200AbgJMGS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 02:18:28 -0400
Received: from mail-eopbgr40129.outbound.protection.outlook.com ([40.107.4.129]:27712
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388527AbgJMGS2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 02:18:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSQzYYSgyElIbIeF+/Tz0lm6YMjXEle7t6mAnhpUCj+6r6l+8IaIoh1sJYaHq3OjHwFVWh/jEmEHXOXx3UAa4/Vq9lXF4Lz+Ugyd1xqYltyfKz3J6fATAtMfXVSy7a1RNdKaWOFcDnPVskCxMiVmV8o4pM8746/8KM7yCaFg+/IGu0Z3J3EXZdP/OTa0qL3XrBsrpAyo0WhddqrB6BZF9Gliz7nyFZU9Y4ZnhGqSOD7HDwxTDvXERylNcLOU2b+rzAxwiLdDg6NUiCsqw5DppwOA9XSCtjDks3EQwIOOO5Z0b2MLTlJYRZey/cqDpSjm2g1OvdIN3Y26D9YWOrnHRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKsa77vm2/lA1ajx+syKbEFyZn5+8r8lmOCkc6QZtRs=;
 b=Npoe8yV4AZPB8elvPM2/aNTGaeFiWvbGegbsH3K2yp9grQcF3WclDaGFilRkXjcy4uYPXRzW8EZN06T1SsaXf1MFLdvOHPwK/SxTEslSndVtwxKHWn1G+jar07PfbJPKJiafHKTpYq4q1rVnoPWMaAtFQcyVGNTxGYbAD4KxVcsIYLZe+WAOU1+E8hvIjV93by6te8e3tf9ZIu2zcRjea/3blVyuC2XGvvjhxRWggrYZWJR6k8s7PJRDVqkB7/egtLHShgIVZUMJ2p4AAs/NT6coY1dpyT8F1gQCaGpvwhN86Ly6xa0XAdSUifdxf08h4l9Ifk5ff7eRIKjU2zENgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKsa77vm2/lA1ajx+syKbEFyZn5+8r8lmOCkc6QZtRs=;
 b=hVN33ff8l4CTuZxSSxNQ0A02a3BLYsgRta3WQ4RgLLxIXRX1u2wz8Kedh90//0SybHYdwmwCzcMKGAnoFMpk95DZ8ZTta8iewomI6wrsJBhe8mlzOFyElfgDc0rQMVuERgIEyW5WH0yO4++HrOHTO5N8VBfdj/yoL/dBh0jBfbc=
Authentication-Results: lists.sourceforge.net; dkim=none (message not signed)
 header.d=none;lists.sourceforge.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR0502MB2942.eurprd05.prod.outlook.com (2603:10a6:800:bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Tue, 13 Oct
 2020 06:18:23 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::2459:8421:b4ec:dcb4]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::2459:8421:b4ec:dcb4%6]) with mapi id 15.20.3455.031; Tue, 13 Oct 2020
 06:18:23 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     tipc-discussion@lists.sourceforge.net, jmaloy@redhat.com,
        maloy@donjonn.com, ying.xue@windriver.com, netdev@vger.kernel.org
Subject: [net] tipc: re-configure queue limit for broadcast link
Date:   Tue, 13 Oct 2020 13:18:10 +0700
Message-Id: <20201013061810.77866-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [14.161.14.188]
X-ClientProxiedBy: SG2PR02CA0090.apcprd02.prod.outlook.com
 (2603:1096:4:90::30) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SG2PR02CA0090.apcprd02.prod.outlook.com (2603:1096:4:90::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22 via Frontend Transport; Tue, 13 Oct 2020 06:18:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2ae6dbd-e3b8-40e6-6adb-08d86f3fc9ba
X-MS-TrafficTypeDiagnostic: VI1PR0502MB2942:
X-Microsoft-Antispam-PRVS: <VI1PR0502MB2942110C7D87B88F17EEAFD1F1040@VI1PR0502MB2942.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3qbAI9D3wfXRyKWHVp2ZYxF3R9sbupHi8L4e/TICs9l75cP1nPET7M7hYSOVWv0EA0bzFwYbdVY9HZcxTclnhKtmG6rvv5LicaRU2zKg9Q6SD9tUd8cdKflP5FzbymDUrNe/7OQiiJdMBghXndyTLvQZgIgk/3R4+yMfamSwQ4zb649Og0+FcZz69orBgSrThJDY45hf3B8ly5HYASFcEr8prVUryic+4L/vxHRJkvN4onx8bEFC4XNRPT3EV4xJjuXKZ5gpjFE3uxbEq7vozJ7s1eX30IIMsdBBDsBiqX/wwXTKL7gc0t65SGHozNeV2I/iv9/UYX2b5FNMiQBLAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39840400004)(366004)(136003)(346002)(376002)(86362001)(103116003)(83380400001)(16526019)(478600001)(36756003)(55016002)(26005)(186003)(8936002)(2616005)(956004)(8676002)(2906002)(66946007)(66556008)(52116002)(7696005)(66476007)(6666004)(316002)(5660300002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Fc8BbISNyMco+CcqHXqoUP5Anz07ElIwZXgo0UUde5UrHsZH9Il5BaDznVzl7jbPRXQB1N2hOl92hTu87iQapByQRO8posJykrnDbe0gnbdmGF2b6kvKPU3U5PF7zTRMakucvQ7khxHXyhTRJ4vfD0Q6SaN4aFvjZ2ocz4s6+5kz+hqBZXi6kyMNTY8IIQp2fgTHcVHLpZ5pXkdKNhI2ZJYGcJlp3Wq101Lp6tSyGB2nQi8RlBWfHwUcYyM8X7VWwKuW08K7/9SK10V3bC4ZXiC96K6rBL7GE2TG8ECWy4F79c0KVHSaDmcVr2TBuZz8wn83T9xy28h/EUsDzj4Y71EHFBmuZ8mMUSCZWzpD7S14c7Zg46pP6sAFr2BAmodIJ/8Ahtg2YURTh3gZbBh0j5GOP7fSvDEGAEhMQezVpno0rBZf9dbrv8QEP9wtvOiQxRwARsB9tLd2Rs3vVPDGe+VhZr9NXwrJlB2KQN7LbN4xjR1BlUjx3u5Wj8GM/Yo4SxGPaArDTwEzyrUoRHq87Qcq+xzRx9QUsB92KAEpo7SvFP3EKHjyHrMtPnvzRhIuROudZHVbCBscpXhgAH9RQL090PD2eFFWaCExGerEIJBPp1z1icJeEWpRNwLmqjsoogEVp3vaYDe4Re0fyQnpHg==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: d2ae6dbd-e3b8-40e6-6adb-08d86f3fc9ba
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 06:18:23.4023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9+q3G8Yjh94sgBHSwRheeDiuGIptABkP6Cwqf4ATdSCLebas1jWJGzq0Uwn6zlzkOmzDPhZaMKYp+VWdb+XBWoBp6hp4KFDbhy8OmeWxJcM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The queue limit of the broadcast link is being calculated base on initial
MTU. However, when MTU value changed (e.g manual changing MTU on NIC
device, MTU negotiation etc.,) we do not re-calculate queue limit.
This gives throughput does not reflect with the change.

So fix it by calling the function to re-calculate queue limit of the
broadcast link.

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
---
 net/tipc/bcast.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index 940d176e0e87..c77fd13e2777 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -108,6 +108,7 @@ static void tipc_bcbase_select_primary(struct net *net)
 {
 	struct tipc_bc_base *bb = tipc_bc_base(net);
 	int all_dests =  tipc_link_bc_peers(bb->link);
+	int max_win = tipc_link_max_win(bb->link);
 	int i, mtu, prim;
 
 	bb->primary_bearer = INVALID_BEARER_ID;
@@ -121,8 +122,11 @@ static void tipc_bcbase_select_primary(struct net *net)
 			continue;
 
 		mtu = tipc_bearer_mtu(net, i);
-		if (mtu < tipc_link_mtu(bb->link))
+		if (mtu < tipc_link_mtu(bb->link)) {
 			tipc_link_set_mtu(bb->link, mtu);
+			tipc_link_set_queue_limits(bb->link, max_win,
+						   max_win);
+		}
 		bb->bcast_support &= tipc_bearer_bcast_support(net, i);
 		if (bb->dests[i] < all_dests)
 			continue;
-- 
2.25.1

