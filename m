Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDE828FC6A
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 04:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404135AbgJPCbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 22:31:39 -0400
Received: from mail-vi1eur05on2102.outbound.protection.outlook.com ([40.107.21.102]:4179
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731766AbgJPCbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 22:31:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i9sFESwIxrX2LXpYrlSz4teK/96yxfeZs11d1iUiZtvt5XJyws4e00YKaJuAQl9Q0CxCMULgnhKldEaaUW2Bo17KXE8RrG3ePlL/2n6DDw6fydX6rIVCts+5thJxhV55Lycp71EAtdw8qZ6rjlb7iYLphe/+Y+h/+dte8WFkgnUHLehYeOLvO9h/+yW+rf2jSqoGx6m5tEUUpgNSOJ+erMGCfsbWHvN4Y/S3K+MPWeTmApYvwpffXHXgcv8FEvl7sUI3sCnEOq2z7gMh5+vmaY2x3z7u4qovSqtqdgSMz9F6WMIea0zCHTqyX7+t0Ppp9MtQkva7aWcjPZodpBm0+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKsa77vm2/lA1ajx+syKbEFyZn5+8r8lmOCkc6QZtRs=;
 b=D+6F4jtmAPgHMbWA8kc55vJZw6VoVt1bWfM180KlVM/cJArFekkIA5aBPxunKaSWAmWh+ZpwDH+ro/lOI26NaxftQb5LTqRcauZmdJHxcloBnF7lVsDLVmeMF98THNJv9EruWcR80yM2NU80UR3je7+8x3GV7QXHdX4ch2itJax2h3V5Fnm0VPILHVDzAHGJT2z3Ew8A1UQQ44RiWOxPNHHZz2tswcLwLftS1QdzF29RUgOcaZAirmL7avxBe/2P0dV0s0prOMiEpXIX3f7cMC5FaRdmnthn4eP13moDWGz7LUBchd2BZtElf20xituxqcF1sNqMkspcvheVHoGAyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKsa77vm2/lA1ajx+syKbEFyZn5+8r8lmOCkc6QZtRs=;
 b=SEF4YOsQdX6MFIkwi9cZH9U3T7aaMIkdZwnk5gzXBB+z0PeYLMofdDZnfjArvAIV2jwBQ/6/ASaZZFsQGpTBzguui0GsUOSE82SkURqEsmEq4ulC+GDYI0gms349G4PqFFQOV70hwWyJr/UYRMwRVlzueiPS0jgyZ9f+TCynEeI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR0502MB3040.eurprd05.prod.outlook.com (2603:10a6:800:b3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Fri, 16 Oct
 2020 02:31:34 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::2459:8421:b4ec:dcb4]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::2459:8421:b4ec:dcb4%6]) with mapi id 15.20.3455.031; Fri, 16 Oct 2020
 02:31:33 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, ying.xue@windriver.com, netdev@vger.kernel.org
Subject: [net 1/2] tipc: re-configure queue limit for broadcast link
Date:   Fri, 16 Oct 2020 09:31:18 +0700
Message-Id: <20201016023119.5833-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [14.161.14.188]
X-ClientProxiedBy: SG2PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::26) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SG2PR01CA0100.apcprd01.prod.exchangelabs.com (2603:1096:3:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Fri, 16 Oct 2020 02:31:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 377b2324-f5b6-4ef4-28e2-08d8717b9903
X-MS-TrafficTypeDiagnostic: VI1PR0502MB3040:
X-Microsoft-Antispam-PRVS: <VI1PR0502MB3040E478674C9C3BA9BEEB53F1030@VI1PR0502MB3040.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TPrmPpRSbJmNqFj7cRj52WJlObfCS950k9hJbHxGYc8nunoUT8sreIq04HLOFKK4IYQFPLQhYXNRLa/bUIORYGkUkSi7Kqwc/k+RE3gjJVeo15A/OJdkg76o2NwiWpgsiuvCNGSeVYDgV3qDHZgUYsPY14eb18HEfwgN7N1uUsydh64a1JkeKk4O5K+HF7uFlidl9//CmxHHeTuvoZKem1w4qpuG76dRmQ6xLnSkadguEWEhl9og4Tb635nOAP02iZHjBkmSueK6m4cULrAF/T9It8t5waKZ/t+zJauKyNVdkNvnAjE1cRGZN1Vy2SQVG/YPCTpzdf92SI8+syFHOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(136003)(346002)(396003)(376002)(366004)(36756003)(186003)(2906002)(1076003)(16526019)(8936002)(7696005)(52116002)(5660300002)(66476007)(66946007)(86362001)(66556008)(55016002)(316002)(103116003)(6666004)(83380400001)(26005)(478600001)(2616005)(956004)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 8oXjVRZN7jSjUTzBiMH7kPC7qOFJP8uF87ilHVqcqFbKbdZIMKRj1hGoDgvGqgXBMV6GB8avDlVKUkASedLVbQohBmlVyx2AfDp2gIFmC+ZRVaPnGFDsFEzxtlFzZcTrWTMB8LRInEmbBGvfKfwPfvIAKPpMhi/iQ2DHvv1adH1/UJrT8M6PLiegKEYdVhvCqk/Zj4HIY+KeOxdzkWU6axzFqxVRBl6DTDum33cKGC/hNuDVJbvitThy6NL9N4G3sBh6bnPJfSJFbddk+Ae9vVH30BxWOhmcvwBPg+Cl3+bbKLOOkyD5CV+1x965Lr7jaKbBGTYsY1gXF4eStuOzxECKtQcIn2vhAmTI5AlEMX7gzLBOa/xWY4Oj+/r6rFTNcJbEj8cQp3R/CapOaFY6vCbesMdL0CSbgif2cRWHxzUC2Vtw8z6zuTPqAZJXT8J5JJL7MFpd7WngGCFt0hopONNMUT4BMN8Lq/i+J4XCr0RczxxS1HB4C6cA1brbcgO6vE3S1qKxnauvkQJ2v3N2N3NXn7b7/eiBGY9q7nzyd7yCEWihCl1M1RNYy0UbUJdSg2Gv2Ws6kgWN29R1vJLILuKXhulmIOmuINhdTARZ+wmKxxxHKxC+o/jNxxSf5nEmojHG5f3F/3P9HDny5ZlTeA==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 377b2324-f5b6-4ef4-28e2-08d8717b9903
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2020 02:31:33.7820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rg6Zcy1L1lo2nMVCgjFI01jSY+g8eInVYRH6FizBYpC6t5k3lKJ/1L2dA7rGIdaesi0j7zP3RuYkzP2zIi4Jx7RMaN9A1ldbHRKW1c3+648=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3040
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

