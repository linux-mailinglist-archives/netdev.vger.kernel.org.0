Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5744D0DE4
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 03:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241568AbiCHCNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 21:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiCHCNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 21:13:16 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140133.outbound.protection.outlook.com [40.107.14.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D8B22BDF
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 18:12:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Knt8smWoMPnbl0ggmqWxbWUOViKVeaF3siXoJio4Cjh8z4h7mTPOrek9NnUoU9HG3zhT5C411tV1QvcTN6GKNw/XJ9RaGfQ97cXEQUalej1wURSgL8FD05ipJmGOsb9dfbtaTjh5h6k5NlvYV1LsSXdJ0sxKcPkU1bwW+56LQ96AScJInRo4TD/r1DIqVa8tjB4SV4i8xkNsNfm0eIEu0HzxIHJMzofjBcJ3GXc2mqipTl3UWuL+YedhXDeRuGySztjYwMLESd7rMp3kBxkjst+ceNCDDp++bqP3MiEFz0YLgBGgDf6Jp+HDor8I6M/DMbvGsoep0JdNy3CGRxZn6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gu3PdqjqwBQc+041xcgy+r2KgnXgy1EtRAQc9y9ZKNU=;
 b=k0jpr0vsaK3I5hDLhEuXcbMCMq4d1RXH15GKvgDE9IKB5916l5VZHNtIq7Ks+JIU8T+GnjkrFMAhQVLISSATYfPZnODdztVPqlh8KHlsUs0tUArejbSF20en0iv1ZQF93XTYdiyzKwpAFMnNX647nStCxZ/TwAQbud62A47GrjayRLLzeZ/SYD2IF3Esrw3HsDd/XDcbPN269SzAOx8QWty4TwHm5uwBKJCd+fJV11YJ50YJ6kCNobxore26LjtHVCc121A/iteOrbPmBWaBtqNnlsFzGxF852QRoYcY5p/MN+70/1+LKAeWRddWmvBtBCav7rwkFRCExa/5+t3SRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gu3PdqjqwBQc+041xcgy+r2KgnXgy1EtRAQc9y9ZKNU=;
 b=mpi1FQ2ruGk04o9iZKs3GOmwbS+kGNhyjwv1kl1ym4pDKLY1f/gMD1veBs/2ya8cvxpHvbgaie5HCHgk3mvnlkHl4d1z5Hz1LccfCtcSu24fLLgc0Idy3ii08V7h+ivm/WAymZZ/uCwA9EpZv63u6wbY/Bo2Nm8De5svVFnSFPY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by AM6PR05MB4455.eurprd05.prod.outlook.com (2603:10a6:209:4c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Tue, 8 Mar
 2022 02:12:16 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::f19e:3be:670d:9d13]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::f19e:3be:670d:9d13%7]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 02:12:16 +0000
From:   Tung Nguyen <tung.q.nguyen@dektech.com.au>
To:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org, ying.xue@windriver.com,
        Jon Maloy <jmaloy@redhat.com>
Subject: [PATCH net 1/1] tipc: fix incorrect order of state message data sanity check
Date:   Tue,  8 Mar 2022 02:11:59 +0000
Message-Id: <20220308021200.9245-1-tung.q.nguyen@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:4:194::21) To DB9PR05MB9078.eurprd05.prod.outlook.com
 (2603:10a6:10:36a::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20c39ce9-cc45-4a3b-a0ad-08da00a91097
X-MS-TrafficTypeDiagnostic: AM6PR05MB4455:EE_
X-Microsoft-Antispam-PRVS: <AM6PR05MB44556F8FE0539D303A273ACE88099@AM6PR05MB4455.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KWbtz6oE4M15b4XHHUxe3+AWSFsF9tvdMVqQ/OlfGd5YeqG7obmVQXWjsSiFVpdc1RcAY2s7xphKGWONQNSE8PpPlA1djLXsB4FlQuuX1Ik5lY1sKDR5J9VX8isoW/IiVejo4Dm2PrvcB0lwd/jm35CG+5qH4MRHUMiII4lbxYRVcmE0YQ0DLBrgmWjUsKFY2kFfJJM0oH55mwnNzc+5We7ES7IKrC+ynUnSSYBIZo9BuplLn0cpOsPbEWRJYdJHtnnMTAxCcB4DgUTsPEy7brb88mx71GHo/PET8iKojDoDlw57DGbCfJoUwOQ7/jyojUZ4+2JuZ3xEyCCT3w7+AI/Cif9QcXv59N57Csox2xyuRY3oR24fBYLp4iKnc59KxDxq5w2QPYVA35N01yFqRy5bi4rmIJgbue2ZsLsJi1jxHuRvk3xF1iLkUD2P5zvjvjMh286quyOAzxM7up1zJFZGyz4lUuLgBGY/LZKS06Vhz0wupgG42TJ1mmIovUUBwq0BAS3Tvj5h6Ra7GzH1Cg+lG+arizUkYTqGu3+osRbATVTkiGHkrcW3TQn6TYmS4Ziexx9uAFDhwwNEnXRNg1s0eXNdUNNF3ZaQap0R8gwZhd59YMcWqXe72eEywW46sEHkX8X8uw3WlfnsgZPq5KbUYndpld1QXyvWjes3IgGjAf1/zfmm1WXKXxsKPOxHBgNk3eg+m1+mpqThKMogtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(376002)(39850400004)(346002)(396003)(52116002)(36756003)(5660300002)(6486002)(186003)(26005)(2616005)(83380400001)(1076003)(6506007)(6512007)(6666004)(103116003)(508600001)(2906002)(86362001)(4326008)(15650500001)(66476007)(66946007)(66556008)(8936002)(38100700002)(38350700002)(8676002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9XCRG2DRzL4Gr5K/aTC1OD4NSpl+G0g5Ct9ZV9a5/aronYRP+c5EJw1ADrr6?=
 =?us-ascii?Q?L3kpLvobyMaINiaatn6H5RfdKnhM7sIDvCXV8yokTvAv1WS3UcZeILaVPiVX?=
 =?us-ascii?Q?XflatkycAeN6nWNxVEiHiOIJGmyR97nxbgbEYReiZwHLWnM6a7oGW3v6aUM1?=
 =?us-ascii?Q?UeseIb0jqYqdcCaMZsNSJOTdwvQ031kox6lkXxWwlt9n9r2wzPwxiDh7qRT2?=
 =?us-ascii?Q?sbaHtOn2MUfLNr9CBj74gn6qWzRZ3CYrgzvJ9dYJXU5eFzHz2xfQWHd/S+fG?=
 =?us-ascii?Q?FcMcibneRrhzcDL281/QJvJFgx5A+rT0pMbBhGqrv0wPmzcYD/77d5M3KvXq?=
 =?us-ascii?Q?6s72IHOXjkjkHkS/wwxKuz7kEDKPOyBBktI5zuBPnmyLko6YT1+EgbX/RgBv?=
 =?us-ascii?Q?c6VLjuPovrOMsoTmXuwljsIMudcA2C5/cr3FDrCCxhEgaFOqAwR/3StHerUK?=
 =?us-ascii?Q?cnvBDkduReb1V4nRJAbGrUVo0k1SiQLQMxD20g+9QcAbuXHpdBBwv4EF0k+u?=
 =?us-ascii?Q?suUB+ia+PKMWovm3O02kZxgNR3qQZdLvyt6BtMXvmt0VmRBZTnTO6QsfbWoZ?=
 =?us-ascii?Q?dj9AdcdTtATs0jA4XCdOhe2cqVJ9mkOG4drTgtODF+lcR84WeI7d75G8Y3h1?=
 =?us-ascii?Q?RoT35ZRhxnQbqlJwDK9vm1mL4xGJNZqzO4BHyA4TSIA+cjYRtTS2G7XwOVZX?=
 =?us-ascii?Q?9zrkX08RKBwoc9/ONt71gmKz9AfjLch3CQEfN7F+RD791hiPradaXKCneqhD?=
 =?us-ascii?Q?AsYc6yysncsFntNoWqcTZg86IyolglNtj9k3QlOwUAt3bG0LtBXwYOb8XxZH?=
 =?us-ascii?Q?7q4qKNF2dbtFm8KRi0RFSV7IDSF/uqWI2cJ6eJirLq19AVyDnMw+m/dRL4+Z?=
 =?us-ascii?Q?JuLCfb1E3AznIMqA9XSSa7SnDJeLaHGcLHCjoMFwjzbC2CHgWDqWKXmrQbMn?=
 =?us-ascii?Q?CRlYYLzYKqaJTv1oP9xE0lCikkUK/GO4tOU11r2O94Xsx2OuWJF783ZyK5X6?=
 =?us-ascii?Q?hVln3hA8g0KYbF2FEcK20LK+hbrWDpDsH1C8Eaju6FnvqO1grzxTxAs9nV1q?=
 =?us-ascii?Q?ayb3w4VwbDgjlqanymgP7McFy5nR0zefhnrRh1bjSJ7EexHi0wRUWqBhoXd+?=
 =?us-ascii?Q?dWSoYdzrFsinJ9OaIUPIP19MTv2bvRGwhuWCxrhExJyzC6bcmdjXV1lWcWhA?=
 =?us-ascii?Q?IhUD/ycr0jAWMEvLWOpzqY3NvilnOvTvhVCINjn3jdnHtr5h2U00FkNVpp74?=
 =?us-ascii?Q?8loBbmNEDMLvDtQZuf51e4CbztT1Dw7Uqrs61wffibUvOCKe7r3iG0ltbD6J?=
 =?us-ascii?Q?wMOA9btMKQVHxxN8IBqqcx/se5OtbbvyvlXHQzSAL1zigQ6Bwly1Qu9Dd9uw?=
 =?us-ascii?Q?y8AkEHyMpb1S2AvjBTnPgm+01f6jexv7ZEmoLYKTLK4J+Kkbp3PypmH65dS2?=
 =?us-ascii?Q?ftMEbcz7H67AJMKg5LSHYPoBW0AZgOcWGrnoGFhvCMI8zS+C4Ai8d0bMmHBH?=
 =?us-ascii?Q?Eu4xy0eh8UqkHLMWHfkPDGu3nLMMMy6+tjhZSd3zAIakMrSB496VTL7cOPYX?=
 =?us-ascii?Q?iz8MKvA90oEf4W9cZQUFe8cdstRBc0ncrIWBc7XvWpdMf0zM9OYIOuo4Sr5b?=
 =?us-ascii?Q?NKejrQ3KxVgqikojv0atHrHM1VFeEm/UATtc2HPRIcgqctUo/wSo3JVljd8f?=
 =?us-ascii?Q?4L1MzA=3D=3D?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 20c39ce9-cc45-4a3b-a0ad-08da00a91097
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 02:12:15.7941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dFOKiSECpMlp7ht8I7BWVotuitr3rSUtS55GLxiXBOEnkk5Bm2BnNHI004DccmkzyRwPf/I7oHaxaO7HpzXVbw64c5tUALamZ+QS998nTxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4455
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When receiving a state message, function tipc_link_validate_msg()
is called to validate its header portion. Then, its data portion
is validated before it can be accessed correctly. However, current
data sanity  check is done after the message header is accessed to
update some link variables.

This commit fixes this issue by moving the data sanity check to
the beginning of state message handling and right after the header
sanity check.

Fixes: 9aa422ad3266 ("tipc: improve size validations for received domain records")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
---
 net/tipc/link.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 1e14d7f8f28f..e260c0d557f5 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -2286,6 +2286,11 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 		break;
 
 	case STATE_MSG:
+		/* Validate Gap ACK blocks, drop if invalid */
+		glen = tipc_get_gap_ack_blks(&ga, l, hdr, true);
+		if (glen > dlen)
+			break;
+
 		l->rcv_nxt_state = msg_seqno(hdr) + 1;
 
 		/* Update own tolerance if peer indicates a non-zero value */
@@ -2311,10 +2316,6 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 			break;
 		}
 
-		/* Receive Gap ACK blocks from peer if any */
-		glen = tipc_get_gap_ack_blks(&ga, l, hdr, true);
-		if(glen > dlen)
-			break;
 		tipc_mon_rcv(l->net, data + glen, dlen - glen, l->addr,
 			     &l->mon_state, l->bearer_id);
 
-- 
2.25.1

