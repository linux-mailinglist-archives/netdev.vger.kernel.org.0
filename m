Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6E16C3668
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 16:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbjCUP7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 11:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjCUP7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 11:59:19 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2084.outbound.protection.outlook.com [40.107.247.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBBE521FD;
        Tue, 21 Mar 2023 08:59:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6VK+wEuST+nfCSTeoOjG02G2ndWzZI4TGTgFfPTiyaE6DE2qW3MHoht+ctyt/XCf8Fm1btnvTELQi9iNtCzJEyGcpAME0/Prb220uBKG0xrVlURklce88/cBVIZ4wBVNTKbdJj7+AgelWfX7g1/huB/7IwB2GYd+tA6hU5rr01lvh1FH8M1bMs7AZqFU0iBx47vlRbWqSo1l6an+oBGXYyz6vl0IkVpQzDNQGVdbsvhf7xJycjTygz/P620+x7fGOFcLLRXQcwvO1OLFti1QoykDrNc8mRL+f2llQxiSW74WT8oPNRTl1SAGG8bKZ5ErXeHy7Pic69oW+0eUnGd1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qw0vIxf1nCFao5Ygn3La51BBTNBP7RDLqOdJg0VK+YQ=;
 b=KkC9QSwtK0Hjchm4MG+sReNED/448TweErL5ltM1T/vcCOfXwBFo5Qtu4QHxQnSewb2qdpT3v+edkbbP9a8eWD3g00BdDB5ww0IqKDq2E/0snNAVBDSRK6Aar8lbDP2ke7Ug6IMdszOJ2nK1WJnAiPsBEUcZlIBaRguHLEQwAi783FtT6y5HEeUBs1Lnu/UIbslX7PQmyIH5ucAQaQTa+h5j7xi6txBu1n+ZWKCmILKOqdldE2Vm7U7BcniwpH17xTuvs1jiM+99mNWGf6sBNlr+tXhvx1IH0NP5/e2vlfKs0AcFIRv29ZhzqAzFAkVMTGN1pZOofCez32+4mh6Dmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qw0vIxf1nCFao5Ygn3La51BBTNBP7RDLqOdJg0VK+YQ=;
 b=nlIvRLCE8b22SF9ZasOfyxj6dhSUr7/p/JB9u9IG3iGQjG7GhhIvTe47V9nAr63iIOnskqrRNLWzpij7Z4i+SoiYgXf2Cq5C54ZlnOwv8NNL0t3vB1x5TKiT1Pp1jFsjeOmxlMxWjX5e5Kv0FGdqgTAHEQplXux9bEj9FQxDYRM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com (2603:10a6:10:30c::10)
 by DB9PR04MB9989.eurprd04.prod.outlook.com (2603:10a6:10:4ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Tue, 21 Mar
 2023 15:59:00 +0000
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::c1c1:4646:4635:547d]) by DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::c1c1:4646:4635:547d%9]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 15:59:00 +0000
From:   Madhu Koriginja <madhu.koriginja@nxp.com>
To:     netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org, vani.namala@nxp.com,
        Madhu Koriginja <madhu.koriginja@nxp.com>
Subject: [PATCH] net : netfilter: Keep conntrack reference until IPsecv6 policy checks are done
Date:   Tue, 21 Mar 2023 21:28:44 +0530
Message-Id: <20230321155844.3904344-1-madhu.koriginja@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0230.apcprd06.prod.outlook.com
 (2603:1096:4:ac::14) To DB9PR04MB9648.eurprd04.prod.outlook.com
 (2603:10a6:10:30c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB9648:EE_|DB9PR04MB9989:EE_
X-MS-Office365-Filtering-Correlation-Id: c293e06e-8ab0-43d3-7539-08db2a252f5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0XcRryL/WIc2G1YrtF/J49Dagz5YnR511YN416gUgM1qU69sKt66RtrhyxJiMku1rnDk/bVp5lLxm+TVCG1cfbloht0njbLjl16TJ6Tv+ObERd4URD6O7nIWF3Kl2wOmdldFx7+UvEvHgUCbDxaPcPdWRyPQLZ5h5JoVr/57IfdKEY7tBtI34RbhQkVTFd7qTgp0/2kwa2Lz1cfZys9Wxo0arQdNXk1hEFCpZmYRYEiv98A7HJfWUQrkDs+97rA2rVC6zOHM61UIGR0PyOKntaCS9FT/8lsaMmGwIf5kjfto3bY4vxoYLAilzmY02BTP9U2SGRWXjM9jkE2UIglx/9KUZWR2HVGCGOp0+Vjg2ZOUh8MT1SDiHFygPod52PcaAYgks5vgQVek8HYQQPF0uQPOer4tHBTZss7z5rcJeMGvHn8GxJH+InEg8ELB/3j5KsqiPO2fjzW4NChF1TZaYRPn08Romb5l+Ik7q8HSh7FNjO/6LQ0KKgoIaSKSw3LK/XOyC8qxEGr7yqERqVFhcNt6mWHtZfUqXS/j9ttNagnBuzDe13YmI6haOGv9dG4lTCk4hl66cVg8up+dwO0/uOhIF7B7bWbDYfQWa4RVUyaD8QBHw7zoNE86ceB+V/xxTWPoFVC825cdmOXBrrozHD1KMzP9c3Mjk9xsqsYD6mL6ukuGgQcB+duhnpWf+1nBW8+QXu4eE2ikdHQoHyeZ5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB9648.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(451199018)(66556008)(38350700002)(36756003)(66476007)(66946007)(4326008)(38100700002)(8936002)(86362001)(316002)(6916009)(41300700001)(450100002)(8676002)(83380400001)(2616005)(478600001)(5660300002)(44832011)(6512007)(1076003)(2906002)(6506007)(26005)(6666004)(52116002)(186003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZhBFb6Fa/BglZWoLJ1gHsOmyOIZfuUaYg4JGl1p6Qpsw6Lhn6dQlV2AaAgMw?=
 =?us-ascii?Q?Q/ky8jvqIHl6kbNhJrGjHwOwuAImxaOg6L5j6xqGfjNdfpJHw3QhN0LBOb6A?=
 =?us-ascii?Q?F+cDfHUENO6WP88N56bC+k36oETz+GQ5/0sa0uD4T1aRHKUI2DitMBBusxGW?=
 =?us-ascii?Q?9ZhsH8y2NjbWp5bxeB0yqGZAWuuG2ULZA+AtkAuvHaIpnM740/ePTUX1JSl7?=
 =?us-ascii?Q?y0Nu6gNiGtOfs73xMCMqOLBPV8g/h592ZzedteSlG7rPgNcFp9eRgN3e1+wg?=
 =?us-ascii?Q?O46Z6xYj9RE774txOYoBiiHZi33xTZxGMeIRXtB42J2J28xNMaJDEFkqMd2Q?=
 =?us-ascii?Q?HuQJw6cjBz+kP6Tul1JMfmRcI6JbPG3gUD/z0ZgT32LxFJPd24vpRCkivTQK?=
 =?us-ascii?Q?XpLl5h9JfYN14xNIS0jPMJvq3GVp+ZuaHRgf5mKr8nzaqzeMCJQiIJzu05Wz?=
 =?us-ascii?Q?1HCcnlgfEdIDvwsf+8pu/IUF1Kcm+lV994WhlfDCSRCULCYKYLAkrWlTwD+0?=
 =?us-ascii?Q?JLQwd4YBt2FiZOb3Pg5nLDwn0GRsfwJqFCe7NOsj31Xp40c5FA2mSIsNujMB?=
 =?us-ascii?Q?4KeGNE97geMzRIGlMFq5kL3jMksSiYj37E1Z5H13VnbLKiyYqubBYCGCaJ61?=
 =?us-ascii?Q?k2XxnghCpOqGuMXQ48pkLOi/izTaChr/mqrvkk1yOeTqZVevJ5mqzXBixFhX?=
 =?us-ascii?Q?fquePyhP2FKgGqpQlnZNrFDDfxD9HIuZhXePl2KFMDhEQhp+2euZ4j7f6p5y?=
 =?us-ascii?Q?yExuqIqlv97P2fSAfd++JsaF7YA7cgl331gPXPhM0r0NJB01HTuYcwWG9tay?=
 =?us-ascii?Q?JYqYszB/Srn8QNaJ7M+7WWQUUhksz356K8jzCyZjmn03QOdUoZZf1Wqiihfq?=
 =?us-ascii?Q?Ejicod3L1VJGiruimoTH2uUUYudCGof90nnw7Au9okK3D+THZuZp/BPp0eIB?=
 =?us-ascii?Q?hq4vaxIUoJ2TgcYEDlVV3dvooeKCNwvUDXPhlxIdBJi+vGYMcnqz3BZHjMUe?=
 =?us-ascii?Q?umH1V9G0luZOv+cWpoqScc0T+RNNR/kXtPT2kYI8pYPcvrHJdZzypXo9d8is?=
 =?us-ascii?Q?8T01psy9JEV2IMI0H/sIxX/gDPlziv+NTZV6wqVht0f0LBBIepPgH7N0cqXg?=
 =?us-ascii?Q?9+XgGdblcQ+/AIKsalcj0hX4cke7t4jnaiH13g/5P6wBqzO47n0PCcSeUC4l?=
 =?us-ascii?Q?m2y7mj2jF+GBMBO6mDIoAYPz1tBPcm4yPxzz/VgRTGed4/g8saI8/ZyXue+I?=
 =?us-ascii?Q?akWBYGzZLtvPQybM3Ntw/J7CBDQT7UpnllMB/34CEBVi55+cw9OVL6E8pS6e?=
 =?us-ascii?Q?Gn1A7AckU3qhAwVsqsVA5Hh5oUNzaUobkFLh5nz+Vyg3hQYfPA08Heo0tFoc?=
 =?us-ascii?Q?11RgOQqLXGzD/XYT6OLBSuyaHhSaWEJonnIfIu9K2LwidnzjS5YszQR/W33P?=
 =?us-ascii?Q?Y4bki8Xix3hnTBq2PUlryBxd08k7oqi3gBlt7L2QOR8iFwK3RTAZe/nY9Q4P?=
 =?us-ascii?Q?5kAon4V0onuhGBirgjEHjzF3ZmpFU5gJuHcd7GAdkOdoRJiMb5beDSG38KTu?=
 =?us-ascii?Q?vsX/CfQYjJIQXVxL48n3YOnESAzI4BaRWTF7QgDNpPsDW2NvXJAFT6Qgst9y?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c293e06e-8ab0-43d3-7539-08db2a252f5b
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB9648.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 15:59:00.1298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WVRHf9n19djt+7qqxETSjlhqOLvmzQpxDzmeSpviXpBO1dKnqxfi8dKqk/ub7O9ZS5agXIinKw3g9R86U+9UpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9989
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
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
---
 net/dccp/ipv6.c      |  1 +
 net/ipv6/ip6_input.c | 15 ++++++---------
 net/ipv6/raw.c       |  2 +-
 net/ipv6/tcp_ipv6.c  |  2 ++
 net/ipv6/udp.c       |  2 ++
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index b9d7c3dd1cb3..c0fd8f5f3b94 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -783,6 +783,7 @@ static int dccp_v6_rcv(struct sk_buff *skb)
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
+	nf_reset_ct(skb);
 
 	return __sk_receive_skb(sk, skb, 1, dh->dccph_doff * 4,
 				refcounted) ? -1 : 0;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index e1ebf5e42ebe..25249cd3b639 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -404,10 +404,6 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 			/* Only do this once for first final protocol */
 			have_final = true;
 
-			/* Free reference early: we don't need it any more,
-			   and it may hold ip_conntrack module loaded
-			   indefinitely. */
-			nf_reset_ct(skb);
 
 			skb_postpull_rcsum(skb, skb_network_header(skb),
 					   skb_network_header_len(skb));
@@ -430,12 +426,13 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 				goto discard;
 			}
 		}
-		if (!(ipprot->flags & INET6_PROTO_NOPOLICY) &&
-		    !xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
-			SKB_DR_SET(reason, XFRM_POLICY);
-			goto discard;
+		if (!(ipprot->flags & INET6_PROTO_NOPOLICY)) {
+			if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
+				SKB_DR_SET(reason, XFRM_POLICY);
+				goto discard;
+			}
+			nf_reset_ct(skb);
 		}
-
 		ret = INDIRECT_CALL_2(ipprot->handler, tcp_v6_rcv, udpv6_rcv,
 				      skb);
 		if (ret > 0) {
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index bac9ba747bde..b035e049fb65 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -195,7 +195,6 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
 
 			/* Not releasing hash table! */
 			if (clone) {
-				nf_reset_ct(clone);
 				rawv6_rcv(sk, clone);
 			}
 		}
@@ -391,6 +390,7 @@ int rawv6_rcv(struct sock *sk, struct sk_buff *skb)
 		kfree_skb_reason(skb, SKB_DROP_REASON_XFRM_POLICY);
 		return NET_RX_DROP;
 	}
+	nf_reset_ct(skb);
 
 	if (!rp->checksum)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 1bf93b61aa06..1e747241c771 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1722,6 +1722,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	if (drop_reason)
 		goto discard_and_relse;
 
+	nf_reset_ct(skb);
+
 	if (tcp_filter(sk, skb)) {
 		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		goto discard_and_relse;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 9fb2f33ee3a7..75900564f42a 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -704,6 +704,7 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		goto drop;
 	}
+	nf_reset_ct(skb);
 
 	if (static_branch_unlikely(&udpv6_encap_needed_key) && up->encap_type) {
 		int (*encap_rcv)(struct sock *sk, struct sk_buff *skb);
@@ -1027,6 +1028,7 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 
 	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard;
+	nf_reset_ct(skb);
 
 	if (udp_lib_checksum_complete(skb))
 		goto csum_error;
-- 
2.25.1

