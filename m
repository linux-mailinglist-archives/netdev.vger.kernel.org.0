Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACAFB6A80F4
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 12:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjCBLXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 06:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjCBLXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 06:23:48 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2056.outbound.protection.outlook.com [40.107.249.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE47E193FF;
        Thu,  2 Mar 2023 03:23:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maUWpCo4FwCP4s8BxnrHGHn2GMZMDAySQeOsDd7llcYOLIcUl/BAA9bFnTCWS3wyvuTyL2G2HK1uvQaeoXagLhzoWAnGfXZlaacE2Y/jB+R63pnc4RiLVxWm5df05ayQzPeojLO+yNNu3wLwUSd8hTB3C0l25GK/okzCeBbywUfyr7tzY5PNAVjpR1fRAo2ZAwXvK0F8nLVBqv4RPVLGpbFr4oAvmg4H9nl6TIng4zK4TGquZrZH50N6x6rbP9nYZrCqqKm/QA0248w8JD8MF8MUYxBZp5RSXdRid3/UxIZTKYiBCGQ69usYfa4GXghScjlAanKzDx7XJSfs/GDneg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DGmF1sNtA8Qma9diNgVIvyLCJLykoDhDanZaBqObGWI=;
 b=nvd+C9XGXm9lOT3ALSc0MwnZMCS9PdzxzZjGIUnMxL3g6NOCopypavbhgDJWW4zRq//bJDIthjy0KkpXwp936xpDgjAL1mqdvzpKST2ISj3dSntVRy2xOCiJwVU9i+137k4cmTfMI0Xwx2La/pVsbzDgZacr1znyiVDsvVl3hZwTE5Sb7opzNvqFM2dtZK/4Cw+enyvSQxeSOE0Sp3bxp8G1i4rP93/aV3qasi0U8eVgW2Br1QFbcrLVbg8amAtObQ5B+Atir17SjwGVmbe/CZ1/g6G4s4xB/NiVFCG+zQDoDluIHZtRXfX9E5mOd77V77sxTCL4VdaA7VA9LqYEig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGmF1sNtA8Qma9diNgVIvyLCJLykoDhDanZaBqObGWI=;
 b=TnBXvkApGfEH9HWpTpORFWY/5kUTtFd5fcC4JXs/H3UHLQ/Bbnie3befTo5zw9xxZyiO4J15dsYAIjojQURnYUrla/3/4rVx9h+HqGQiQVl7u05xRCIEsSITFCeMfkVuc6c1eOIjSuU1mhBw4vRcWM3v9CapbSej4CMsmCtu26k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com (2603:10a6:10:30c::10)
 by PAXPR04MB8991.eurprd04.prod.outlook.com (2603:10a6:102:20e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Thu, 2 Mar
 2023 11:23:40 +0000
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::c1c1:4646:4635:547d]) by DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::c1c1:4646:4635:547d%4]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 11:23:40 +0000
From:   Madhu Koriginja <madhu.koriginja@nxp.com>
To:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, edumazet@google.com, dccp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     vani.namala@nxp.com, Madhu Koriginja <madhu.koriginja@nxp.com>
Subject: [PATCH] [net:netfilter]: Keep conntrack reference until IPsecv6 policy checks are done
Date:   Thu,  2 Mar 2023 16:53:24 +0530
Message-Id: <20230302112324.906365-1-madhu.koriginja@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0045.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::19) To DB9PR04MB9648.eurprd04.prod.outlook.com
 (2603:10a6:10:30c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB9648:EE_|PAXPR04MB8991:EE_
X-MS-Office365-Filtering-Correlation-Id: 22f212a6-6d40-4ca9-b79f-08db1b109338
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pB7uSgNl11lZVUV+GR/C/gSjW7AbWe1fod50j3qloGmMCZSAxzKDhTM055jtQHZEfsQSy+bDWDy/LsPDNvV6qQvo4RiJPBeHzabNgN/pEnUHBda7cA0RoKNSIk8+LOxvqJTJTi3pHMTBiqJCeIQ8DSXR3Ws8lDe7A9Ui1tSRegLGi4x9FWatO7DVulJnhYPYIbHIyYjG1+Z4uKxHcaeuMDV5N0BCJQhEB62HMcz07zQj7rsCJtQbCGRpNe5WvyvgHFXZupHmaLCukztoH922zFhrevWxZt4/sU7aVEzK9an3k+xc2myBrY8quSDxcbKngsf/NdHzPqySBSXayHhobm9DpLMr+xdVWkhgeeAvvVWc33gh8DiouQwFqRXqPZyDYD0Cj0B1OALpVZBeEtQG5C7XOQb4oDVdqD/60ygZtf4Oy70BHnxV854DD5pHPAi38RR8ThJdWVbSm0O7YS2t9QqYBSowE4QJWygAHmUub7YNSUwgazudtV2dfyeMfuUJi8QCC+9iHIF0F47kGFnKdFHQPBxT+CwR5xjlucWvM8JfioWPT/kNvv8EF3J8HpJcxoeuw/v9I4wDjxzScNLWqlxp54vywomV0n/1JHtXedyGjyFtwFB3q+DZf7PSA2i1QV206kt4O04F+oGphI6CKQGDVrnBx9I0erZzhurVrmMuFbwnp97Wt/0x1WHa1HFI7oD6fRxBdfcztxwQMzI3Mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB9648.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(451199018)(5660300002)(8936002)(4326008)(41300700001)(36756003)(83380400001)(2616005)(316002)(296002)(66946007)(66476007)(8676002)(2906002)(66556008)(44832011)(6486002)(38350700002)(38100700002)(1076003)(26005)(52116002)(186003)(6506007)(6512007)(6666004)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hOyoM0tbhwIPbKlKoUp8Pe2O5Xuarg16NUlH2qEMT6ir+c2Pj6DRgzxTqDKA?=
 =?us-ascii?Q?DpbjC4NeLqaHiaHZmWTG6wTsjDy3jhqlbrEIdh/xHEHwis8WkIfAc4rFoBu/?=
 =?us-ascii?Q?J0apEtq8PjEgOvS81DdfcjHNci3jld3HfRgZaIzmLo3173QByZ/YErD19rat?=
 =?us-ascii?Q?tj4PCMsw8WiFzmE5KMWEiNcWXGVT+t5n6O9q1yyMptt81/Lybs3cfh64Sn4L?=
 =?us-ascii?Q?Ly3SforC1Ef3yDcPSlXyWgzNf1xeaZdU2y/qja7ApEp4Etfd4ZshhhhL6bVd?=
 =?us-ascii?Q?c2AulgNo9NMN9z5MWMQt7OfjJMR8GnTVg5k/QrEvm1waY3aTlOrkcOZHk4ox?=
 =?us-ascii?Q?6epnExtlb8v1whuRSRfYwFqhzDaOBxzPzwHHmKoGbspkP4HMXaaKPm8o2VyL?=
 =?us-ascii?Q?lnORXlpvizHJSsxfkV1s1Qkh9rXcPBOwXyjxg26lmClHTVor7HNUjhY5a+CE?=
 =?us-ascii?Q?f+h3tJ3Izm7zZMYvS0LdUlmOaMc9B+jNZw1nn9rZIaOF66RhC+s2SPXdV5CY?=
 =?us-ascii?Q?sMQyWpxByA+ES43ggJ+0jGtHb+qhTJKn/KE5bk6XZO/8NAuFxYyh7Q/O3YQW?=
 =?us-ascii?Q?7TV4eOdefH8NIJ6XwEuJHwnFkIOxE5eIUstItTHklZfRuq0HckRCR+tnHSJV?=
 =?us-ascii?Q?t+KjeBF5oihBJfJmR5A0Q/cBJAhEYVJx+HcUWlDV2ztTGN94cexbQn83hxuF?=
 =?us-ascii?Q?oT3RxSFTsSDekvgd+r5XvE738opz8WHw2576E0B7hEE9Lx7JPRJfWML2kAS/?=
 =?us-ascii?Q?w28e5up9BvAyIaXt5vknsqHGCI7TA3aRXcm7BK/50YdMIoIhQ/J3v3ZeI/bH?=
 =?us-ascii?Q?20uqavtCzCrefUKCxVRd8i1q86dgBkpaHGQHJckGTOk9jYn4E1Q1+NsIUK6O?=
 =?us-ascii?Q?FvMJxva4EbG4ziRhEgB4smhIKVVAc8R8EEbFYEcAM4PkKwABCXUmqOsCiQv1?=
 =?us-ascii?Q?QqFDkbr+EMkN/aRUhDcmlesGmxeWzA2/r12ZEt8piDcn4zYMIHUtDc7YiPai?=
 =?us-ascii?Q?rKlnhG52CguKik6WTm6tzt04WCExolH9rs2bVBp1G3LmhofTQvt9PtYh8vyy?=
 =?us-ascii?Q?G9pq3yFi83rvRaSynSp+ISavCUzQVLHyWkOCOyFgRsBiZ1y4wZFVHetFNU9K?=
 =?us-ascii?Q?fbRP3QW5NZqtaMZ6BB9leheGRScGJmv1fWRJDJNYG2MZgHDUCA0AXRHDohs9?=
 =?us-ascii?Q?wBPy76owihAgC6LOJTC3U3EZBn2UxxGWdCFbQhvGIxbXNQcUGkf8e7/OGEyn?=
 =?us-ascii?Q?0HlFhE3Zi5VsPzLfOVp4nurNJe40/8yN/yQNrS7QL3r2iK5PvLrhhfO+8kI0?=
 =?us-ascii?Q?4lQMKoJ46k5XBNlPicfS8yF6mZnpEGb03uhZvScKJNWOgMZUVm2jQPhTt2ov?=
 =?us-ascii?Q?v1c9DGtIfOjVS1q2QuxzfPFu0AHsY35ojApv+l50+YvwIl8M07xGzDrmUcFr?=
 =?us-ascii?Q?mvRyKB52ANBsGQR6qeCvKNpc5QGegzY11ia+e40ihcUwP0/LL03YLaiYeQrh?=
 =?us-ascii?Q?74kiWW9orJ2OeGR9f401gXki2CPycylsBkOBKjPdy3zpjIdGe+Yytnp2XbBB?=
 =?us-ascii?Q?WNIA4m9BPsYVPJ8NGwmtTussyI6sLeL4VZ/c91Bh3MF7Mj3inmCKA4pCHOm6?=
 =?us-ascii?Q?Qw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f212a6-6d40-4ca9-b79f-08db1b109338
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB9648.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 11:23:40.8327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zB3VwYtXkUd4Sgj7VVkwBymhiF4vt16siOi//9SKMEAK1dJYmotYKZ/XxQJPVYN8v/dkwBDTQy4sSX2u6wWKSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8991
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keep the conntrack reference until policy checks have been performed for
IPsec V6 NAT support. The reference needs to be dropped before a packet is
queued to avoid having the conntrack module unloadable.

Signed-off-by: Madhu Koriginja <madhu.koriginja@nxp.com>
	V1-V2: added missing () in ip6_input.c in below condition
	if (!(ipprot->flags & INET6_PROTO_NOPOLICY))
---
 net/dccp/ipv6.c      |  1 +
 net/ipv6/ip6_input.c | 14 +++++++-------
 net/ipv6/raw.c       |  2 +-
 net/ipv6/tcp_ipv6.c  |  2 ++
 net/ipv6/udp.c       |  2 ++
 5 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 58a401e9cf09..eb503096db6c 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -771,6 +771,7 @@ static int dccp_v6_rcv(struct sk_buff *skb)
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
+	nf_reset(skb);
 
 	return __sk_receive_skb(sk, skb, 1, dh->dccph_doff * 4,
 				refcounted) ? -1 : 0;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index acf0749ee5bb..10d9c33cbdda 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -374,10 +374,6 @@ static int ip6_input_finish(struct net *net, struct sock *sk, struct sk_buff *sk
 			/* Only do this once for first final protocol */
 			have_final = true;
 
-			/* Free reference early: we don't need it any more,
-			   and it may hold ip_conntrack module loaded
-			   indefinitely. */
-			nf_reset(skb);
 
 			skb_postpull_rcsum(skb, skb_network_header(skb),
 					   skb_network_header_len(skb));
@@ -388,9 +384,13 @@ static int ip6_input_finish(struct net *net, struct sock *sk, struct sk_buff *sk
 			    !ipv6_is_mld(skb, nexthdr, skb_network_header_len(skb)))
 				goto discard;
 		}
-		if (!(ipprot->flags & INET6_PROTO_NOPOLICY) &&
-		    !xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
-			goto discard;
+
+		if (!(ipprot->flags & INET6_PROTO_NOPOLICY)) {
+			if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
+				goto discard;
+
+			nf_reset(skb);
+		}
 
 		ret = ipprot->handler(skb);
 		if (ret > 0) {
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 4856d9320b28..cf68c9418897 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -220,7 +220,6 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
 
 			/* Not releasing hash table! */
 			if (clone) {
-				nf_reset(clone);
 				rawv6_rcv(sk, clone);
 			}
 		}
@@ -428,6 +427,7 @@ int rawv6_rcv(struct sock *sk, struct sk_buff *skb)
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
+	nf_reset(skb);
 
 	if (!rp->checksum)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 9a117a79af65..0bc959cfbea4 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1534,6 +1534,8 @@ static int tcp_v6_rcv(struct sk_buff *skb)
 	if (tcp_v6_inbound_md5_hash(sk, skb))
 		goto discard_and_relse;
 
+	nf_reset(skb);
+
 	if (tcp_filter(sk, skb))
 		goto discard_and_relse;
 	th = (const struct tcphdr *)skb->data;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 72b2e7809af6..aacb48e977cb 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -567,6 +567,7 @@ static int udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto drop;
+	nf_reset(skb);
 
 	if (static_branch_unlikely(&udpv6_encap_needed_key) && up->encap_type) {
 		int (*encap_rcv)(struct sock *sk, struct sk_buff *skb);
@@ -860,6 +861,7 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 
 	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard;
+	nf_reset(skb);
 
 	if (udp_lib_checksum_complete(skb))
 		goto csum_error;
-- 
2.25.1

