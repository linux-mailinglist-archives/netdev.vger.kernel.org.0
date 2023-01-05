Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C26E65E55C
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 07:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjAEGDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 01:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjAEGDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 01:03:14 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2109.outbound.protection.outlook.com [40.107.247.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430C85132E
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 22:03:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmVXgw1DYPPbr8pq9EWnBAJ+bhBtp+6Vvv41W53N5jxYlIItiVQCE8WYRq19Bb03yhDorBUDm5Nhs0OR6dR7ZRraAnS7TfYH8t9GlSM9f93zkp+XY58enF/lL923kAT/JnvOtzEdLrAYFiSDU9gixOXyfHR+29aEzQ6Ulw/GRFS6hzZlGkojSbiJwq7/36Hd75XagIDux2R6usUBr7cAeDsOpPGNqjKcB00xeap9IJYJYSSQ5b+zxtQXjFml7DZDaWsg46HAgs2FOKtPIAxq5WSopP+RQIrK5AqNNY3HmcS4W3cY6kgGPx0o8n8AbJi0tVhzKkzybcu+B10ykbwO+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tocTYB2BUQkwxopEEK9wBgoYMsTFF6MbW8AqbPvCk24=;
 b=HwBXY7r0/Y52EXkRSixmXq+Yq0e2e4f6RKw9wESpygedYqjZYNDxQGJOAQHGpdORYeZevoeraaxKFbZcsHgQN3zwxbmuXmepKmvpZXpHpSuGHoN5vUe7JS/4NEApM+VKYec/ipRzfUOlTu5XNJmagkHNe6GQZuwaWFg7p27Lsu4EMpoyyFAGPbZDEE5P9FwPgcLGGuhC8HIVl31pggNa99/7ClumdfbZ5BxbRPzApcU2b/VXPiIiB+30EA00ZQL9cR3btySFXdIlHYEwmVns+OGYhOn1m3I6nrif/wcnqlNfYE81EZ0c5ffOdPiJDKNSt9TkclaoxC9VWsSaIbx4cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tocTYB2BUQkwxopEEK9wBgoYMsTFF6MbW8AqbPvCk24=;
 b=s3BG4rG1pamDyVvz7BSuutMH3tHJxNhGuSTL/GXysc9X0FkquuGWHGT/icdj9iWhB+pAZ966UrSNgwJhlSFRKcYn0SvuAHKT0gWYU8wNjAQJeWH1yOjC3Rsc8vhBNUwgYmoVUkLxGDDUOjTrmb8LGme3Ljb4Yjw5OQ2LeDonJms=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by DB3PR0502MB9923.eurprd05.prod.outlook.com (2603:10a6:10:42a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 06:03:04 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4%6]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 06:03:04 +0000
From:   Tung Nguyen <tung.q.nguyen@dektech.com.au>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, jmaloy@redhat.com, ying.xue@windriver.com
Subject: [PATCH v2 net 1/1] tipc: fix unexpected link reset due to discovery messages
Date:   Thu,  5 Jan 2023 06:02:51 +0000
Message-Id: <20230105060251.144515-1-tung.q.nguyen@dektech.com.au>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0031.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::11) To DB9PR05MB9078.eurprd05.prod.outlook.com
 (2603:10a6:10:36a::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR05MB9078:EE_|DB3PR0502MB9923:EE_
X-MS-Office365-Filtering-Correlation-Id: 97d08bf3-b1b1-4dd4-578b-08daeee28236
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4/j4zrrWhocAFj2G2+hdouMemh+Ekku7czuSxCBl8GY8h/nC+uwDd8IREhldO/MN2Rc5WrT56a3/u6ci0SxxlTkjM1dcXqF0nNn/3PD8UrDrdXHMCyOZQkVU3mtucaZjfBm6Pp7/aIvnmI2qCMdAs85jPn3uM8k5T0v19li7vp7pBPsgKHdNjMR61CDlp8UqcPKEc60W9ErVXcRwUpLV3cW+Tve2FdzRoseI2M/8kY9/qlNuEOAjZ8PFLlZHYHlaBDEgpfDb5jVS/KbjI39CuS1UqWDQUMAEt4G8FHyIIm70MwIN4oEyL0u+LMXPwUuXX4mLYOVwPvZJbqnVRkhT2uUccmGZkE/FmVWlS4QewvAqhLlQCjX0Kjwq2upF92nSdNOepNlnXT/BwVZ+cfB9lY6UAR4Qxi1nUymLAJwt12c/4J1uax+wmpfkMVqou+ocz7va3pWfFCrEeE/jznGvNYsIf9WstpHBoy20jHDKMoazrSTHYuhXHgeVbfsp9XFFtDmt8ZgB+htZYqvIZr9UX9Y+zrSY0eddqLnopW8xN0kLJBKLl1dZNazDahfyGiI8EZGR9lenqH+3yukU1vtYM5POyr636jf+4oUl8EbsTXeqr6v3M5U77LigMyw6DB0Eo6G3nCWF9kR8BF4nhYcHjC44igHfhZXfv1bzmG3btRESOI6oWzkhI+LJ9G1P1AlF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(366004)(396003)(39840400004)(451199015)(103116003)(36756003)(38350700002)(38100700002)(2906002)(8936002)(15650500001)(5660300002)(41300700001)(83380400001)(86362001)(66946007)(6916009)(52116002)(6486002)(66556008)(478600001)(6666004)(4326008)(66476007)(316002)(1076003)(26005)(6512007)(8676002)(186003)(6506007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+UB9LRPu/9Imq+1s1S7/AzSkSzKNT6VjhG8Q2K4vwjD8dkU6XlfVCEno3i/N?=
 =?us-ascii?Q?4G98WPrIZVHZItWzhiUZOhDROGXHdHQZi3nFKBQQ32s3TJNf5qeL/Rlrkf+K?=
 =?us-ascii?Q?bxwoOilVHD6E+VcT4Og6bd03wnLR2S1iD/JmH+qpXkHAO7FcwtPv4pg1WDG7?=
 =?us-ascii?Q?pJloZbvgSbf4igzyljtrDvVjP9gCZQBVjdt81E4+ONWV3butfdCxzXnbaYbo?=
 =?us-ascii?Q?u7s2QQpAUBwLI89AiABL3qJTsIhehLTTUf7LFequ8XBzddhlPc+jRKzpKjDs?=
 =?us-ascii?Q?cMDwN4FA4UWtuhZzV7bCisK8/JQKxFjIBgtWzK3ToiaiA9fe8ASACuKJzWCO?=
 =?us-ascii?Q?RMQjDpppBq6Sxz2lL8qB2k73613DKB+SpRDr0mj1aXhZtY9YG+SDhXZ2N9op?=
 =?us-ascii?Q?TsNKjH+CPeY2JsGlU/d41QPqDadGKNW21xVDciVhESrg+RC1JEI/XYXK2T9M?=
 =?us-ascii?Q?GaBcQpMB11NdLGgsDGfxU0+8fb/RooXIdrKmfZaYam8UAtMiHswT2vIZZ6V/?=
 =?us-ascii?Q?/aZrnWhtLdTHn/CK33x5S0AE5Y82XwNjKslkRS6rtK34pTdbFu+1NjR3CKN1?=
 =?us-ascii?Q?dJ7q+q6NYisEk73/jwlSihxlwxfpJDqsbyOfw8GqjI2EdixLccKB7dzNj1NB?=
 =?us-ascii?Q?VVZQD95UGf5cU5I4aDSyP2S3F8UFTT5/Zw6/i4RarPbB9isMSvR/x4GjOgC5?=
 =?us-ascii?Q?eeRRpD6ARlJYKskLCiuYPgt7XXexbh388oYeE17YRMUfjPnjPsPRV2J81Q3o?=
 =?us-ascii?Q?N8+eliCgN6NAoEs43d7YTVUk/8tKK5MkfGSjWAL/LUJpNFdUuVw0lBzU+8dH?=
 =?us-ascii?Q?KkGZVtmMEILgLQ73FXgGk5SGY/yNOUfODsVYsKEqgfiKGCn28ldHBoWqByRE?=
 =?us-ascii?Q?ReXrkcwkMQrU49zavoaRwY4071C0m0DOMekIDT0aV57ejuos2qCKwSiiK9gh?=
 =?us-ascii?Q?hEEeekrzc1EZVkxS+mP1e5yEdXA0cUvVI7cuZ2TIj3Cegs/+QODj87dBovVT?=
 =?us-ascii?Q?oP2f0qLUCQcfKbvT1/wm401WmgcNSCe1HiY79mJKq2zHmCOBw7CMGyq9Vz3J?=
 =?us-ascii?Q?uT+oZ984AX+2CxKLHLiWiHXvigqsLYeP2dSgP1ZWS7mVxjsmYw6QfHFWndof?=
 =?us-ascii?Q?5fxljBdyASNAntkhx3+BzO5oYq/BukZZv6oAXoqJ2cylBY+VhmjOzZWDH4xu?=
 =?us-ascii?Q?LAsH4aU0tS43NYjo+fYsMG8TTg38RthQTk9drYoA1dqhCEE8OBOoM6/qIg3m?=
 =?us-ascii?Q?4C5/GhvmhSdBostQhxTLb6tPOqE5FHYh8ww3S5kjI6Mw4ymLyFlem2qcPlpB?=
 =?us-ascii?Q?ye+X0XU88EsUabELXmsSHn4EzzOXKKrIB+Rwqpeh+UiyglbOm536nDXu5WRT?=
 =?us-ascii?Q?aTMJp8/TDM7ihdq7pfFvsaoW2N3WiaOaBtE0bGqRwH7Cj1/CG4BtsHXGXk0Q?=
 =?us-ascii?Q?3YY5SaeSMWcMZOGJGqv/PAWNvfRkEwItKQd397h6pPOF/XmaJm1n3R7TZIf9?=
 =?us-ascii?Q?+9Wp4b87X4Mylbj7hBDMbTgffEvICXhvB8sy5XCCWy0DOnz12xExQQclc8wA?=
 =?us-ascii?Q?Tcs0cPPxH6ki1ZhLFf5++sWQsYT/YTTjy/1bwSQAe+EIWmN3TMXc2jDoJBlF?=
 =?us-ascii?Q?xA=3D=3D?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 97d08bf3-b1b1-4dd4-578b-08daeee28236
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 06:03:04.5040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rg2Dd+zKT8Vj8pCxDvSRnSCD/YS0MG/QOwUXmdwnYWPlefq11IGBieR+63qx+uaKxxUm+WXEk3yIojp87iImffsLkXLpirPMeKchuJm8Ez8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0502MB9923
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This unexpected behavior is observed:

node 1                    | node 2
------                    | ------
link is established       | link is established
reboot                    | link is reset
up                        | send discovery message
receive discovery message |
link is established       | link is established
send discovery message    |
                          | receive discovery message
                          | link is reset (unexpected)
                          | send reset message
link is reset             |

It is due to delayed re-discovery as described in function
tipc_node_check_dest(): "this link endpoint has already reset
and re-established contact with the peer, before receiving a
discovery message from that node."

However, commit 598411d70f85 has changed the condition for calling
tipc_node_link_down() which was the acceptance of new media address.

This commit fixes this by restoring the old and correct behavior.

Fixes: 598411d70f85 ("tipc: make resetting of links non-atomic")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
---
v2: Correct mismatching Fixes tag

 net/tipc/node.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 49ddc484c4fe..5e000fde8067 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1179,8 +1179,9 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 	bool addr_match = false;
 	bool sign_match = false;
 	bool link_up = false;
+	bool link_is_reset = false;
 	bool accept_addr = false;
-	bool reset = true;
+	bool reset = false;
 	char *if_name;
 	unsigned long intv;
 	u16 session;
@@ -1200,14 +1201,14 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 	/* Prepare to validate requesting node's signature and media address */
 	l = le->link;
 	link_up = l && tipc_link_is_up(l);
+	link_is_reset = l && tipc_link_is_reset(l);
 	addr_match = l && !memcmp(&le->maddr, maddr, sizeof(*maddr));
 	sign_match = (signature == n->signature);
 
 	/* These three flags give us eight permutations: */
 
 	if (sign_match && addr_match && link_up) {
-		/* All is fine. Do nothing. */
-		reset = false;
+		/* All is fine. Ignore requests. */
 		/* Peer node is not a container/local namespace */
 		if (!n->peer_hash_mix)
 			n->peer_hash_mix = hash_mixes;
@@ -1232,6 +1233,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		 */
 		accept_addr = true;
 		*respond = true;
+		reset = true;
 	} else if (!sign_match && addr_match && link_up) {
 		/* Peer node rebooted. Two possibilities:
 		 *  - Delayed re-discovery; this link endpoint has already
@@ -1263,6 +1265,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		n->signature = signature;
 		accept_addr = true;
 		*respond = true;
+		reset = true;
 	}
 
 	if (!accept_addr)
@@ -1291,6 +1294,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		tipc_link_fsm_evt(l, LINK_RESET_EVT);
 		if (n->state == NODE_FAILINGOVER)
 			tipc_link_fsm_evt(l, LINK_FAILOVER_BEGIN_EVT);
+		link_is_reset = tipc_link_is_reset(l);
 		le->link = l;
 		n->link_cnt++;
 		tipc_node_calculate_timer(n, l);
@@ -1303,7 +1307,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 	memcpy(&le->maddr, maddr, sizeof(*maddr));
 exit:
 	tipc_node_write_unlock(n);
-	if (reset && l && !tipc_link_is_reset(l))
+	if (reset && !link_is_reset)
 		tipc_node_link_down(n, b->identity, false);
 	tipc_node_put(n);
 }
-- 
2.34.1

