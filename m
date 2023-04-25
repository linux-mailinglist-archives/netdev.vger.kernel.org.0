Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382B16EE2A8
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 15:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbjDYNQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 09:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbjDYNQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 09:16:42 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2081.outbound.protection.outlook.com [40.107.241.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3011C14447;
        Tue, 25 Apr 2023 06:16:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=haW8GZBw/zTC9YRht+rZ4u5xWujsB9/d2HAV2BhN/4PQjEQTzwMSbyWbjrcA/ilPgE016r6s8xwS2ji5g+RKYl169TV+D82fe/YtNg1m9e+7QmiAZ+JQ8sPxxWve8pIykck2LFrZCaLlv2VBwpsQbikDUXVsD6lJbOQlbNOpxh6XoIk+xGIQI29Soe33ke2Ym7iBGW8f0I0FwGEYiz+vX6+cS4aFCZMQHfkoe6dEeyDGMZMwn9tGlg3LbSyCDnw4XJMY7OQoQByrV1XbIOYSkPneR5IIJYz9M6AOHx9uDw5mhEJ5iGeVEumrQukTnwMcHZoGACp8o0p/cnnl6/7fxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lqhGZXrFEE9u/scI3abIICUsC7OHqQmjIZ+GqxgrOk4=;
 b=cXfcjNAZa7apN4D0FnkAnRth9pR/ym3x6KsSapWEuKgOP65sTrHigEqcqcqoenatDpRF4bc2H/IBsOiyR7mY+hFFtt9yHwzB/fDuvDmLmB1o72XkvWlZDJwC1QdSKAzr2YcEJt96EYXw4BoI002mTtr20hHk4+iHHDuzs9lUyT+l7RepcGEnRT2P51KV+1SF/UCvh9KzlPHz8mY85kGvtulhXnCMEwVJ/pIGteN7UsGDdm9kNk+pujfVNAPx3ZE1LlkCRShIpDKWbAYQiv0CAsSvD9+Yw94UD+BNz0n9XywXIibqwdQuLjIJn+8HNpERj2oOGp1AaV6tFiAX0LQIIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqhGZXrFEE9u/scI3abIICUsC7OHqQmjIZ+GqxgrOk4=;
 b=oqrnzIa67p1wPN4OwUXFhBuOLOA0tnC1AdvSNyIHOgWysUYoxXcth489SXxdoUHWKwwH/IprEGYj/RDtP/9gcTCb+a0dj0sykS6MjROqK5RrhMj6q5bc7cQXN9J2JjMbcLGb1wZpV5pyMHDWQ7N0GT6BiAs9Y8nmgiIANmy563c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com (2603:10a6:10:30c::10)
 by AM7PR04MB6901.eurprd04.prod.outlook.com (2603:10a6:20b:10b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Tue, 25 Apr
 2023 13:16:32 +0000
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::762c:3b53:2350:dd71]) by DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::762c:3b53:2350:dd71%5]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 13:16:32 +0000
From:   Madhu Koriginja <madhu.koriginja@nxp.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vani.namala@nxp.com, Madhu Koriginja <madhu.koriginja@nxp.com>
Subject: [PATCH 4.19] net: netfilter: Keep conntrack reference until IPsecv6 policy checks are done
Date:   Tue, 25 Apr 2023 18:46:05 +0530
Message-Id: <20230425131605.2576011-1-madhu.koriginja@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:196::7) To DB9PR04MB9648.eurprd04.prod.outlook.com
 (2603:10a6:10:30c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB9648:EE_|AM7PR04MB6901:EE_
X-MS-Office365-Filtering-Correlation-Id: fa90b2a5-1236-488a-a4d9-08db458f4999
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W0XQeTRmVsZwSyr1GDZbh06HfTln8hGJbhLpYDOFu3Vfwb7ktG8lGYNbUArQJFEUSShxPuEMnEp0uf0sffNlBvV2ZurgXDsgYTQ5BkWSIdgaG3hXjouABFN4zYjcdtaAKsALo045D5i/a860nLnbJPanM3PAONmd3N7NhyAUvHIKomzCKOUUTWTY33eVNZUQbvvYUVroo5QdOYn3Mfz3aXNiHbPWmHiJsEEqtVaEBeVhiEiBrojPBnm6EL+LKEPBNFxwr/gql4tv+RUV7G9pC6TIUaYwVGoCqTXKU37pgkIJwWDHKAW338tuRe5VPODXpouqgHTfpST8AMSy/qaocBUE51AhqwFMDblgjY6C1UtxYviysYj4YPz6Q4U6z9OWpGaqA52Rcpl7CbrByzhwKjfSnZvHVyA17b/PIpHXmQRaxfFlamJV4EzkHYZAOdvctHYZqWEcpTmf2BxB4tJ7h5r4+w2pLbvnlAFGZldQBU28iuwZ5RsswHLoe6fBzhXWaRYqw73PI0Sfr4LMDhOs3rYWHYWxrnGBXQkyPGLL+sdKyFKiEN7NhBcR/n0+nFJJzghloAhw8Rx0udSzpJbeue0A6ulxcLb+fbtbgWG+3Eh3wzMatPdVsSXrv3dUw5v0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB9648.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(451199021)(316002)(44832011)(4326008)(38100700002)(38350700002)(41300700001)(5660300002)(8936002)(8676002)(36756003)(86362001)(2906002)(66476007)(66556008)(6486002)(6666004)(52116002)(6512007)(6506007)(1076003)(26005)(478600001)(2616005)(83380400001)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5263tvSAFpygdA028+Npciqsuj8K9m6skes+KH3Mba9jD4Yf9tx5kcfoLjxc?=
 =?us-ascii?Q?WzW2llqMJB7X4QQ6WNA93lNaoYg9aEioB0G4uXheZSocaLzG2zzuNDE63K6n?=
 =?us-ascii?Q?jY5QDqy3fc3p8uMYfH+VL1AslG0fAmZcf1kk6d/sgK1vSv8fYaTjXJCdXkLu?=
 =?us-ascii?Q?VlZIwGn/SiLy8CQg1TklBhTNdP84KGd31cGHXJegcDB5nAeJ8WUhJR76Ergd?=
 =?us-ascii?Q?Xy6sVTrx5ADu/9fqbtqt+l2sxmf7EkhSnB7QMzDP03AesagIWAttgEVn67mE?=
 =?us-ascii?Q?Z+SnxiPx2WqEzxN4eKTINYFdY0THJ4FU4H0VYRpVZYoTLMzRWFK5KPUYMUpk?=
 =?us-ascii?Q?BVeQGP4WuMcQkreCvrA8Da5xx50NUwfUjMggTKUHZ0ovz6qk+7Vc6vFnUtcu?=
 =?us-ascii?Q?wWZCKrc+JST8R2XEOq+vHkJsSYhYVRrMF6hJa17TnruiMaBTAIEbFk1hfggo?=
 =?us-ascii?Q?SsWqZggeRnZMZCUGTwlECVVAEjoDni/N+/oibTOF1o0zY2RTaeXoYJ4irqde?=
 =?us-ascii?Q?6nFiRqDyMvj4Cp2MTy0qMqajboeL1uwyVQe2uo9ZSbo9Djr04K9AOj6Y6W4l?=
 =?us-ascii?Q?Q6iRwKNMlzUj8gO2j9L4CrD/zeu4y86opnyNbXU1DT92EWa4wziTnS+EIrWa?=
 =?us-ascii?Q?EgbyNLBUBc7A9Dx9C4GhgCzCRY9GAVlINGbTO/5VtzGmVskhcgd/uGXDYOi7?=
 =?us-ascii?Q?3KqeGPwCKvi0L2otSUSi7uJ/FhkPqZPTGxWFbcu4RsdOBNmmy3eGRgA6XjZf?=
 =?us-ascii?Q?XZpVTBgAH9QselN10+o/HqUbb6PuK93sDZPgg/6ja1Bdr1SDA2IFB8VLNzua?=
 =?us-ascii?Q?W2sBtqv5r+vI16JdxStZa25R+Stm76U0KqP2ZqUpe1ZaovshDiG8ktP+Xx41?=
 =?us-ascii?Q?5K7/ma2Wc+1mmJbhPim/e8BJzf7NQjUz0nwm+CaWQOUK57/HWUDlBwt0AUU5?=
 =?us-ascii?Q?n3knO8rRSnLgamCHWAuRZsge0AsmZmFDC838+cm8sjHijagP7CyesmH/jbzX?=
 =?us-ascii?Q?LE/wVC9EXxODQnECzRi/yp4tEmDDXljri3lLMGhmL40xzY6J66+UlEjWdsIp?=
 =?us-ascii?Q?ZT4i8pOWt3+MOzVeOR8IhsWtRhOgSG0pBUnHvARbe58tDBCT0TFBLGc3jPQY?=
 =?us-ascii?Q?M7yQxxIp+Kc1tbuDfb0XH92GvcRO6+4L0yBe5RJS5vv+LW6u+6cgSDF83YPK?=
 =?us-ascii?Q?2SkFMZDV0nVgPtSaQbNFCfpe1I1h+07KmgTSD4WMPTrbW7KMGdkGjE4vVfxK?=
 =?us-ascii?Q?236/Gc/Q5ZatfZllcLkBGrERJauItidUMc+s+tepTwbl/XZcOrltpWE18+gp?=
 =?us-ascii?Q?xtdLREr5RUAzxwx5rVuL5KYUvYh1clb0rUS7GjzESfGLwhvSx1XGA3cXGIfp?=
 =?us-ascii?Q?LJHbh8A2zahVjsYe04iAijLb/cXXG28qikG5Yv/Xg1NKU8UdhlYIUsNZ6Uzz?=
 =?us-ascii?Q?f25AbOJ8O6Qf2zXJkJqlZ4aXt6/lh6PnL2HleXsVDg76V2K7bKaUzl7XsAsr?=
 =?us-ascii?Q?7GGVSJSaDIbo6NJZb7x9BQj7yWDEkBHlJM5NqTxCEbGWVjRGrqpFe/gtDTVu?=
 =?us-ascii?Q?SICsmOUVzZp36RGKL50mAfDWGn3pNIcR6heCVig6L7TJX9BSZO2hJl7aApxW?=
 =?us-ascii?Q?lA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa90b2a5-1236-488a-a4d9-08db458f4999
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB9648.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 13:16:32.1914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yna3RGUff0Zno2WcNOIwIM+VdkUaY//6kuNiLu0OAxKy7wruac61L83uIdwBzJfexa7Y0SRTapytF95+212mFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6901
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 net/ipv6/ip6_input.c | 14 +++++++-------
 net/ipv6/raw.c       |  2 +-
 net/ipv6/tcp_ipv6.c  |  2 ++
 net/ipv6/udp.c       |  2 ++
 5 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index b2a26e41f932..f953b5b5613d 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -773,6 +773,7 @@ static int dccp_v6_rcv(struct sk_buff *skb)
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
+	nf_reset(skb);
 
 	return __sk_receive_skb(sk, skb, 1, dh->dccph_doff * 4,
 				refcounted) ? -1 : 0;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 2bdb03a45baf..6a9a1e637506 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -371,10 +371,6 @@ static int ip6_input_finish(struct net *net, struct sock *sk, struct sk_buff *sk
 			/* Only do this once for first final protocol */
 			have_final = true;
 
-			/* Free reference early: we don't need it any more,
-			   and it may hold ip_conntrack module loaded
-			   indefinitely. */
-			nf_reset(skb);
 
 			skb_postpull_rcsum(skb, skb_network_header(skb),
 					   skb_network_header_len(skb));
@@ -385,9 +381,13 @@ static int ip6_input_finish(struct net *net, struct sock *sk, struct sk_buff *sk
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
index 44e9a240d607..e7180cd8ac70 100644
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
index f69c1b83403b..2b5b6e208947 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1568,6 +1568,8 @@ static int tcp_v6_rcv(struct sk_buff *skb)
 	if (tcp_v6_inbound_md5_hash(sk, skb))
 		goto discard_and_relse;
 
+	nf_reset(skb);
+
 	if (tcp_filter(sk, skb))
 		goto discard_and_relse;
 	th = (const struct tcphdr *)skb->data;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 16c98a2a5c36..59c5ee9d9d32 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -570,6 +570,7 @@ static int udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto drop;
+	nf_reset(skb);
 
 	if (static_branch_unlikely(&udpv6_encap_needed_key) && up->encap_type) {
 		int (*encap_rcv)(struct sock *sk, struct sk_buff *skb);
@@ -861,6 +862,7 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 
 	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard;
+	nf_reset(skb);
 
 	if (udp_lib_checksum_complete(skb))
 		goto csum_error;
-- 
2.25.1

