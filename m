Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2DF6A9452
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 10:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjCCJn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 04:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCCJn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 04:43:28 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2074.outbound.protection.outlook.com [40.107.22.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E2DF97A;
        Fri,  3 Mar 2023 01:43:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5PEvboag3XF1gVBrYvkORvcFH95L83KorA9lh5+xFf9TA9EIDigjZWjAh06Ok4Jei7eiN4g+NbzAKDeAcjGYZwsdR5iE6kyQuK0czIiqcoMHEsL/BuvvGM+QqRmg0cdgYE9uHCWXmsCT9DBNCJjRgfzFumvtqT1FkgBiHZuyt19eHXC2Xw3DoxX1jWTsko5flurqldnjqbOvMkayVwKuhvbUEGBvz0PW4TprHMmXb0sWypA38kjxR0FL4LTBwKHQ3vv3gbezWUT+8mKeyDt3ZatoRIuvwOHvxbtlU321VJKRqWTh+bybbWx+HYRG+A+anEWJOwbpxE9vFB6f5t7aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JelSMZTTMbHSSc1yniB0YKlRbnN+aDwkNXRTBWWhk3s=;
 b=nG7f+Z0gh6UgV3ogOqdVgFnfZEADvKzGudybqZPwCvohK39yvwx5NUmcAbhZWfCZe97iaKFHkXCsDFH0uFVa6Jt1Gv0rUAVMaRBorRXmfjY5FiqS1RN9XXmKmHbiPrKML/wjUTzPrBVQzvCriW2e8F5xFra3oqms0jxsqQxzi5Aoe5+5L9BUCfecGqgzs5rM8VEIJJVSnkr39qm6/WC33Yx9XyaEI68Mj8UegyFfacMBPhoD34oJ8iQ2rJJyxzoMiuskwqU+8cv459Tmpw8G7YdpnVTb8QulysrHa2IcyF/PLjDE0KsC1/TmTbz+CZFEW9PD5+HCjHzoUNa9EfwiFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JelSMZTTMbHSSc1yniB0YKlRbnN+aDwkNXRTBWWhk3s=;
 b=SboOqW1FxnuZxVUyyllt4bQvmnm9/5amSCkcnT+uv40yaI/uUpESyHXoB4Wo3iRG+jm7TQ3InWgdM2uhIR2JarKCO+9IiTdY+G15M8Bl1pBBbnBCD8QvDjJxvvnDE4PhLXZ6IZq870n/VoatQvNz9uZ9o0xefEJVbL0P2jmLO5o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com (2603:10a6:10:30c::10)
 by AM8PR04MB7892.eurprd04.prod.outlook.com (2603:10a6:20b:235::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.22; Fri, 3 Mar
 2023 09:43:21 +0000
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::c1c1:4646:4635:547d]) by DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::c1c1:4646:4635:547d%4]) with mapi id 15.20.6156.018; Fri, 3 Mar 2023
 09:43:21 +0000
From:   Madhu Koriginja <madhu.koriginja@nxp.com>
To:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, edumazet@google.com, dccp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     vani.namala@nxp.com, Madhu Koriginja <madhu.koriginja@nxp.com>
Subject: [PATCH net-next] net: netfilter: Keep conntrack reference until IPsecv6 policy checks are done
Date:   Fri,  3 Mar 2023 15:12:21 +0530
Message-Id: <20230303094221.1501961-1-madhu.koriginja@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0029.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::16) To DB9PR04MB9648.eurprd04.prod.outlook.com
 (2603:10a6:10:30c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB9648:EE_|AM8PR04MB7892:EE_
X-MS-Office365-Filtering-Correlation-Id: 2512eb0f-f50e-477d-6926-08db1bcbb9a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f5cIn0nEuAb6L0V5lpxUFiLkl7Jy2selahGwXVJSam5c887bbceK7HQQtmCdo+Eu2HBuBK0oupUnXku8h9aBvY1wKCAmKn9klNLY3zFPPDf3FeQU8KIg+OVi0Jc4dHBmu1BhzSX33EWhjQNvruCAUGwF3PIr+gR8X4Gc1TSF9tV+GmwkUuc5KHFKeLXbuqDZxKI+38Q3rEJpfacx6XFaFASrBzNkAQUOm9/wz7XZHjTDEylt+KQNBfkFaPQbQHrr6S7RcUEIQH+jH9G9BgjUVzmL6vIZXJnVGNIOUzOKsbOx6+e4Q0qYzqN/Q4hHB+G+M1g1YxW4o0jq4SP0+Qnrm+erEwQjKxNGHK08xVob++qgh/jYSb/enSZ/frJkpWzwwXqWlD+j2SezPb6zTRJwYZzrAVrS8vGt1aMVhx7JDrSvf85CB21vhROSPPguvZeKPWp5pQTVus+4M5FX0OPA+kkPUkTyfNpLKU+/miZLvVnHrCWjiRzRgqZYImu+ZBNepi35/ydSp5pAoMGepkSCPHJ766LkHqOnUgwldNrNmigD95EW3CS8K5tHleK1pZqO4+VF22ZrJFEnbMSb13UVpEMNLQv4pgIQqeKIIIGn2AxMoQ5HLS7/Wkjnio9Tv5acKPC2fVk8BtxgZtvAYwGMQw5i/65daNso8Ap+cJ9Qw9UCNXYrgmFD9/VeusT6bgPjZ6npnPVmgLt6337Fyi6dXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB9648.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199018)(86362001)(316002)(296002)(36756003)(83380400001)(6486002)(66476007)(6512007)(186003)(2906002)(44832011)(5660300002)(4326008)(8676002)(66946007)(41300700001)(2616005)(478600001)(6506007)(1076003)(66556008)(52116002)(26005)(38350700002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OoKwUDpahfKRmDGz04WUWCaeZ1C5YII2oLDGflhP1iGZRcFDJrrX03lrajQ8?=
 =?us-ascii?Q?YNVxHXQ4BqN3hudI2JhSMkeSE5l4314+X9xPtwSy6yB907w5Adom3vF0FZsu?=
 =?us-ascii?Q?b7niOV2aflvUKHZyQW7F5UKxWeJCfOHqGQgMEUgPextOjVK7ajJp41mBQOGd?=
 =?us-ascii?Q?o1Z+NNlPp9XJJKLBK+XkfIrslcg7p2D6GmnN3BlOyAWZHHSbtr+E8gxpW5Hg?=
 =?us-ascii?Q?IaVMF06+soKz+HmwaJRv2+oEVrnbwV3ZvBRX0jzfcWwa67qkXUCQ2smjiVJJ?=
 =?us-ascii?Q?tYvDTS3ETS95IOopnJFDco6Au86y64O/GT+q6xTkpWEujtwR84LETuC6/0fh?=
 =?us-ascii?Q?7uvxrH4mHO2Xlyi3BrdH/10W6aYe42qOa0vQSvSQIlIXWlvc1Xs8NzU2BGEv?=
 =?us-ascii?Q?6F51NLdJDGx5vbfELWgu1mkV/lk1IlghTptva3pPxCr3p2R2EKzgmUY6HaC3?=
 =?us-ascii?Q?fOL2W6n5Tv52TesLpsPsaXP1h+t+VHHJ4HnoCcXBjpfl/5K1pjdQZa75Mb3Q?=
 =?us-ascii?Q?yO369XyBULVNAeUKxpIWf1LIdetUCOYpCgHSDgrKXqsZrVVZr8rf7yguzS4g?=
 =?us-ascii?Q?4sOpXaHowRVGVLkhKDCqCQa57Hr6mEPOeUJK9i4wt6nDF5MBNFeGvRBLWK3k?=
 =?us-ascii?Q?3d2354abtFqvMMFFOJnK0/Crcsh3A1cDsYNCAjZBdQP6bKhk4xOXjkwIMTVB?=
 =?us-ascii?Q?6O1JVeCJWs8ChmT2oSO9gNGtbT9+hLkTVle+XZBghrhKHM7E6oR4bc9lIOck?=
 =?us-ascii?Q?ag11mExSRx331bdZ6FKYrUonEBT9uvEcqIjujOXxKn1gaFeIqr0IiiLh4sbx?=
 =?us-ascii?Q?6kMMlBflTA++JsQEEehKXaH+yFuOd9TswW5/+Z22lf94xNxsLNW2Je/YOpAj?=
 =?us-ascii?Q?IjNioETh18o3y6qja5OKRe1bHdq/jzm2XPMVOCEt1dAevSLEWI1kjsi0e9Rr?=
 =?us-ascii?Q?AVpzerv+FdSeJJpHFGRtn9kdb5246tNK+Cuowjomzb72K0gHeOWz2USnASsf?=
 =?us-ascii?Q?usmm839kJKOIMHFnFVE4ksxqnrCDIeT15pY9S/JYG+LcRQlDiXB9vSe9q+yu?=
 =?us-ascii?Q?ey/ENoQB1coto1GoWnEAISgbMAHq7yRkOLko63ZMAus8TBqqOHaVTAYk08ET?=
 =?us-ascii?Q?5+E/8QtefsKNlXnJ5rI6RJvR6uKx2CSbAuVjFI5ZH1o8SPiQ62lWLDqYm9lr?=
 =?us-ascii?Q?LAEaGv3WyZWD/1UuzQlswvrjOxLuzbjfZMEURGXL3XEFx+6K+/adzt3LTK88?=
 =?us-ascii?Q?zHcuhhR5k3WkB8NtAEB+60MRE3CDKBWjHzNiGsRD43reEPOPlnAcoxAJ5mUh?=
 =?us-ascii?Q?t92IR4Fe0WTUEbobLhBKzqfPOMspGNMn+CAQ1Lx7sheJmHA1EQwAqvEFi40x?=
 =?us-ascii?Q?mqm5aJrZnWD9AJzu5TejK6BgUzP4cAoCQYezYj7ecPZFsakrspuNeGMkU+cI?=
 =?us-ascii?Q?7Vig2E6NX+LDDEEypwIknHVb/Ey6CkvtWwHIpp4oTan/12YhfacbdyUyUTL+?=
 =?us-ascii?Q?B5Fn7S8LdGihRsFDEZq1DYJkDwRYr/6h9/J9Ahv076FBXNghmvlLgIW34psv?=
 =?us-ascii?Q?TAXAapnrB8IcwCKc9mOJLRBSPOkZrurRU0NWfKsbbrZe2Nm9j8QU+ydJYA8Q?=
 =?us-ascii?Q?Yg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2512eb0f-f50e-477d-6926-08db1bcbb9a9
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB9648.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 09:43:21.1661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /jqdEcvCh6saz8REKpgvmG5wCbXSt+WUJZFP7dgu2JPJDOUoYPkWNI6nFNozHJZwRdhovbVpFXOP0LcRRK0UEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7892
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
	V2-V3: replaced nf_reset with nf_reset_ct
---
 net/dccp/ipv6.c      |  1 +
 net/ipv6/ip6_input.c | 12 +++++-------
 net/ipv6/raw.c       |  2 +-
 net/ipv6/tcp_ipv6.c  |  2 ++
 net/ipv6/udp.c       |  2 ++
 5 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 1e5e08cc0..5a3104c7a 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -771,6 +771,7 @@ static int dccp_v6_rcv(struct sk_buff *skb)
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
+	nf_reset_ct(skb);
 
 	return __sk_receive_skb(sk, skb, 1, dh->dccph_doff * 4,
 				refcounted) ? -1 : 0;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 3d71c7d61..25ff89d9f 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -378,10 +378,6 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 			/* Only do this once for first final protocol */
 			have_final = true;
 
-			/* Free reference early: we don't need it any more,
-			   and it may hold ip_conntrack module loaded
-			   indefinitely. */
-			nf_reset_ct(skb);
 
 			skb_postpull_rcsum(skb, skb_network_header(skb),
 					   skb_network_header_len(skb));
@@ -402,10 +398,12 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 			    !ipv6_is_mld(skb, nexthdr, skb_network_header_len(skb)))
 				goto discard;
 		}
-		if (!(ipprot->flags & INET6_PROTO_NOPOLICY) &&
-		    !xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
-			goto discard;
+		if (!(ipprot->flags & INET6_PROTO_NOPOLICY)) {
+			if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
+				goto discard;
 
+			nf_reset_ct(skb);
+		}
 		ret = INDIRECT_CALL_2(ipprot->handler, tcp_v6_rcv, udpv6_rcv,
 				      skb);
 		if (ret > 0) {
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index dfe5e603f..c13b8e0c4 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -215,7 +215,6 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
 
 			/* Not releasing hash table! */
 			if (clone) {
-				nf_reset_ct(clone);
 				rawv6_rcv(sk, clone);
 			}
 		}
@@ -423,6 +422,7 @@ int rawv6_rcv(struct sock *sk, struct sk_buff *skb)
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
+	nf_reset_ct(skb);
 
 	if (!rp->checksum)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index b42fa41cf..820aa9767 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1586,6 +1586,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	if (tcp_v6_inbound_md5_hash(sk, skb))
 		goto discard_and_relse;
 
+	nf_reset_ct(skb);
+
 	if (tcp_filter(sk, skb))
 		goto discard_and_relse;
 	th = (const struct tcphdr *)skb->data;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index d56698517..2be1364d0 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -604,6 +604,7 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto drop;
+	nf_reset_ct(skb);
 
 	if (static_branch_unlikely(&udpv6_encap_needed_key) && up->encap_type) {
 		int (*encap_rcv)(struct sock *sk, struct sk_buff *skb);
@@ -920,6 +921,7 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 
 	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard;
+	nf_reset_ct(skb);
 
 	if (udp_lib_checksum_complete(skb))
 		goto csum_error;
-- 
2.25.1

