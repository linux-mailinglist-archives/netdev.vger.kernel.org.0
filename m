Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072BD65E2C2
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 02:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjAEB5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 20:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjAEB5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 20:57:37 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2098.outbound.protection.outlook.com [40.107.21.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136DC2F798
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 17:57:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/fC+8iKTvDjQdoOnRICYWJz3akFejNa6wqi+M9T3ZJ0ptOh7WLCRKteQm0S/13loOgEjonO1zUNEmfLOloEv4zIG9io/3JvGpRB3u8GOfqoUMrHljWpaYwMErXcWSvqVUQFcG5x9H4Li3FDIe8l4w5X2ld3S05tby/ICyvUXdlxa1+jZPr8V7Tj6RXRz+d0xv1FNBtBE1OYklHhxMgtQ1dSatkXHjSQ+CMmhtYVw+ijtwNkASwsaOYa2peACKm9U0X/CpZF80gUG3WW4sXrYhUw1Kmxql0F0KL5JTRO5pVKlXw1wL7bAeUyDG2WAbtUwODiakBO2RDNemoJUMYaFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1pWR3540Fql3vOCvpxiI8y6nSm6zcok8Z6lMGrlQO0=;
 b=YOhTl6VwGd5bWpvjFZpLqHNXochZjQq9+33AQ5wqJpKxOUFsP3yAeud2VHR0najEeSQCdpAUi9vmLALlM5O3zDrxrt6rU1UHoR7Lt5j0Ikvs5IfsG5+LY6ZVzQ6HR9OCzaeRkqllSsfskXrrsCbkGWrMSw+dO3AkApeBucsb/mSMDebOR3oEOmMnl6yV/n5BAobG3it1QNWvYzSDk+x/9lpV9v/eEgN4oo6h8yd3aUTEctKS/ioLyPSPXF5JLQtSvM1xVBxj73m7fPG+QkxQtiAgb+K2x3qQduLHeAU5grgveNF05X6Sy3QTXSYBpqE7CFN5VtMDXjl8lFn91om/aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1pWR3540Fql3vOCvpxiI8y6nSm6zcok8Z6lMGrlQO0=;
 b=h4byQuJF7kxB3/tem9DPgEF5D4TNwOgcg4UmdqPxQXxKfvPB0wZSOgRtifGFR1BC75zBdaqZO/a/sPIp2KTZGx6sulLJqat5ExegSFm6MbYNCHEw3W00YNElG+rBw1EFEt6HGAXS1/lmkmo8ADcmngWFMhzo5RV9diArvk/+/cs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by DU0PR05MB9118.eurprd05.prod.outlook.com (2603:10a6:10:35a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 01:57:32 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4%6]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 01:57:32 +0000
From:   Tung Nguyen <tung.q.nguyen@dektech.com.au>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, jmaloy@redhat.com, ying.xue@windriver.com
Subject: [PATCH net 1/1] tipc: fix unexpected link reset due to discovery messages
Date:   Thu,  5 Jan 2023 01:57:17 +0000
Message-Id: <20230105015717.9686-1-tung.q.nguyen@dektech.com.au>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0106.apcprd03.prod.outlook.com
 (2603:1096:4:7c::34) To DB9PR05MB9078.eurprd05.prod.outlook.com
 (2603:10a6:10:36a::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR05MB9078:EE_|DU0PR05MB9118:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e650ace-adf5-4fd9-4403-08daeec034fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SUvhc3ds3vG9CLB7grWX6beVni7Q/Q9FLgdIaytw/rrItZo4DmJYBtsOILLSHmDvjyLswwTlFppuYYDSMOyz1d239hAQ/4F5OAOBo4OjIvHuOB3gRFVNKUEaY5SUMsn18y5/QFm1kxS1kBFC4KWuPCIJx7duNrnjrPEuElvK6VRKJt8l9LLqgfr85ClqolqamB/w5MaNzkL42gc4mTx+33U2rzkpkHRrJHz6EbAGMs0jKcj/O4jID+0Cgv2GtgIpdICcVmGo46mdmR2rVC1QnefOUY4gahiIBsYpBB0XfRNeHiAWTTECdELnCT/LJdpai5AjyVG/5949ZP8pVxPlDNSLmx0/JXI7Gx9I3EzIv80jeMo9I2VFM13gVLwVxm6tBTS4eQJypR/6rvydt2WQvWSs81P+yzzypHL5Y/XvmCzJzmpWvTN1ODrIYXXvFigFHbV/AftRt1BLQPzqhpBphzn6QXj9aAuZE6i8p+ZZYH0VPJtydXGEdX5iMaE+NYcxuwftoisu/8m/a1MFe3YoZQOKRzUuu1fJjxY2OwNhlb+CQhthdVzfWGguLMdKTz6C4Un1QEFeIRUFoO0FQ4J/HAZ8oQO8wLSkFOxDRWU0PDCEr6+ZhNMHWoqZU+YiiikFbbwWMtqpW1zN65FDXvSMzCMG1szt38tvnay7cc0FTjBGNn+FJ2oVR7how/tBhnIfmGHIMePstL0rq0oVdqBEKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39840400004)(136003)(376002)(346002)(451199015)(5660300002)(2906002)(15650500001)(8676002)(41300700001)(4326008)(8936002)(66946007)(66476007)(66556008)(316002)(6916009)(6486002)(52116002)(478600001)(1076003)(2616005)(186003)(6512007)(6506007)(103116003)(83380400001)(26005)(6666004)(38350700002)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e1HVKcOF3v4kXA0hH649Hyhig3lJZsE4gFJLmd2xS7wgXP2OLPSJ8iIiQxPd?=
 =?us-ascii?Q?g5qDmQtZijbikSGm9JpeZuLEfpMk08H1Qs+/71tnZUfzyySHeO7TmvxEAysG?=
 =?us-ascii?Q?U4wR0oTW2v+KBr6NK4Jg0co2exQ+88SXFln7OJDGg+c84ZvwOXsRtXV2M1s5?=
 =?us-ascii?Q?gm7TJbfGW+h8XUMEY6gMe/J1VgM8gjG3pzISPUJfnytTjzFqWEgXt2y7UABQ?=
 =?us-ascii?Q?Uc6Yi5uzR0SAzXnuvjKqJINT4YTdZwrTzbnYgkuU4AQz8248MAIsXqwD15ZF?=
 =?us-ascii?Q?SFF0IDjyqYAc+M3RBmNx+7S0EtqRI8fgNvfucksUAWhu7qkFmN4PTmPD+VSk?=
 =?us-ascii?Q?gnUl8+wSCkApwR3FvXFs8wlYwGztgbKxTz9DEYTbSGisCfJpWC5ao/EV9jVf?=
 =?us-ascii?Q?3FkCZ9acuKBPhZnMUhyyBfBmXrP3jG1BgbZPAuglnz792c7dMLcoE//l2wN+?=
 =?us-ascii?Q?KKRAKqG+J/ZW8UjnJcYXhz73GnhZLpkrD1QDuMnfDkyqtGQY511zvayvnBdt?=
 =?us-ascii?Q?YJatqhOxHgDvtIRaLwgK4vlJJZarGOn7KxIJf+8ZVDl+7QuS1UAT68j/LPB7?=
 =?us-ascii?Q?ATBcWTINw4RdiUzN+OkVMg2JzA1AeU4HCnR9NCXIsq0FC6zlsiVRYyVqIFsU?=
 =?us-ascii?Q?O+qe2tOCC0Nf9eq6NnEwkOcN6HqFBvpAZIfrrssp7vyo9wRkWxtnfotcX0xN?=
 =?us-ascii?Q?zhLkiY7igjpWfc/NXJrsJ4ZT6g1qWTIS8+SNnykh7ae7BSsYjGv1FbjCaNM/?=
 =?us-ascii?Q?NOig1+MAa4+EchjfMaCyFZLHOkbWfnR9xD22cNqKM2chGmsnWqbtFMu0DbIR?=
 =?us-ascii?Q?j1pNkEphaW37Ai/4jgeeJoROdmnogk25piqHvPsvoKJuHWkyrVP+fEdJQezy?=
 =?us-ascii?Q?jJy9UiRfi2IkoBuaSUqXVgvw/5xmRm7mRhyUTeSIUAX70IVxjSZGL8RaPXX3?=
 =?us-ascii?Q?j0QtieO35j6MLmVFrnso9ZyXbmJ1nBc6FSQWeATMHHrUTYus0CvixKj4ejfO?=
 =?us-ascii?Q?P80DhTJD9GLavFsAmP6z+SrRBnz5ZdlYxiTBlJEK69pq+07w45Xp1iple0JE?=
 =?us-ascii?Q?kh5zLMwTPN1XJq6zEB3p0U85JYKvHJzdirRFxPfO0Qvz7RtKiK5yyC6uMR3Y?=
 =?us-ascii?Q?Jnt5K+Na2W61r28s/WM5ye/olU9NwK8NFB6KyYuHpfQCqyyjezfJwqw8cHkv?=
 =?us-ascii?Q?Vkl2GZzqYizGJ0M/hDwV4AOlMMDSc+BVoJhsoTo1d3CyUSz3LIPN6tHys8Ay?=
 =?us-ascii?Q?g0r8dazj1/L0mMiRxk/+cEQj0+0C6mTx4mayD7fsr3ffRYZ3EuVfhI8lhGxz?=
 =?us-ascii?Q?M0lPn8LWWEgPO+55PiYZE2Pehz7F3PIfwaB1FjuJE9YnXd6DiavhoEn8+r2N?=
 =?us-ascii?Q?lorUnYcfApraWJuUgCxt/yWHuJexEL9OeIEdxJxS9UCpdWxDPpWPs4sScAWN?=
 =?us-ascii?Q?/ngP+uFTcr0jiZRl7+tZA4SAA6MH4EG11/8eMepdGig5cTtASnZzjhzJzrMD?=
 =?us-ascii?Q?TWPKqiyrFR8Up1rQsaebjtNbDQEqzyVYmWKjSoz0kwPvpQOO7sKbFfUUWq2n?=
 =?us-ascii?Q?+UWuNd8nTmH25esCmdilKG/Pi5ceiOrUQcmQX1AsXf8RZg2Lv4vNvFk3jGs5?=
 =?us-ascii?Q?sw=3D=3D?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e650ace-adf5-4fd9-4403-08daeec034fc
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 01:57:31.9550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: enepXzMClJyaoxaV/dV92Rpo5PIG/dT/FmsNp7dM51VaQALMx08T6lnEzHyJ6rrJEkCYUz2HwRny3mLGEt0vujewFvK6JCj14qOAj614g8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR05MB9118
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

Fixes: 598411d70f85 ("tipc: make link implementation independent from struct tipc_bearer")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
---
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

