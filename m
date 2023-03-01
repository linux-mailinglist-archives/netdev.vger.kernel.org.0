Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06766A6EE1
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 15:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjCAO4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 09:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjCAOz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 09:55:59 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2061.outbound.protection.outlook.com [40.107.21.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EFC3B0D9;
        Wed,  1 Mar 2023 06:55:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUgGeQ0H73DY99f84odQbesElzXcaYZ3TaDBeV/ZNXhg2j+OsayVPQjtvWbj0PnUvBjpvyA/xharljf1m261g46JxXqu5MtaXocfSGixNKlOZ9VUDUJjK55CPpVErU89SbQRXLJRYC989pURzGpCXZRRpiHZCioDlXCS74VVNXu7LzHs/MkrSYc7d7OGkvloUjyQFNlN1b+HYzM3emYP4Npg1RLlkUUyvr/MrmFFwBRfJo/2p146gYMXNa+9dENQMAIUvE5XtiRHoh10W46iX/AbfFcMRYCvsbK9XiSElOwSZqYxnJtRNLhClbEd1MNdo6rdJ6GnUCeKTmHrFrF7rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qVUOzVRbI9KIuzUiM5FYYzGdIyLrqxIm2psLdhlz8CE=;
 b=FHbGKFaCAj19NDAPSqRQdim72dsZpRMOfj6vmKBbm45GLg582BdNVNykiUwPqAqSgCCvqe5y3NuyXXR6oWfHenhjhByP2Bei3y3852ZRo2T/1WK8IcuuN0k+s4UJmkhmDjunRJvZjS8wWHf/SZg6EYBY3FuY9+iuWNi/HGZyGUK1+r5gd7GA7Pd4yezcOPY6Wvm6ZnVclXM+ywAVKVrF0xb5SlNxXjoSwtXw0uIw6/r0ouFfUfLUWtSwwXof/pLjTKJ8nRGZ2bncRsSduw+CqIBjRRkxEptd5D1tl96csGZFhD4GKK7oCaH8LhTeIx0M82WPuzQR89qx+6AKYvdv3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVUOzVRbI9KIuzUiM5FYYzGdIyLrqxIm2psLdhlz8CE=;
 b=aREDM/0lqa3Nb5VLoao34JXmJxiHkyKbDJU65dvrz4hshGL+yNJ8Yd3IKsToxaY4ctMm7VCUY7ff7FqlYIk1LS5oOvyUdTmQ/Icj9nJcIYn/J33yXrmem+bAJqFT4mVz/XwgFC1ul5wIzbhCiYCltMR8GXto3hBJckvTHRSz8aE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com (2603:10a6:10:30c::10)
 by AS8PR04MB8499.eurprd04.prod.outlook.com (2603:10a6:20b:342::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Wed, 1 Mar
 2023 14:55:53 +0000
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::c1c1:4646:4635:547d]) by DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::c1c1:4646:4635:547d%4]) with mapi id 15.20.6156.018; Wed, 1 Mar 2023
 14:55:53 +0000
From:   Madhu Koriginja <madhu.koriginja@nxp.com>
To:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, edumazet@google.com, dccp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     vani.namala@nxp.com, Madhu Koriginja <madhu.koriginja@nxp.com>
Subject: [PATCH] [NETFILTER]: Keep conntrack reference until IPsecv6 policy checks are done
Date:   Wed,  1 Mar 2023 20:25:34 +0530
Message-Id: <20230301145534.421569-1-madhu.koriginja@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0002.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::16) To DB9PR04MB9648.eurprd04.prod.outlook.com
 (2603:10a6:10:30c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB9648:EE_|AS8PR04MB8499:EE_
X-MS-Office365-Filtering-Correlation-Id: 50154116-c5bf-4f43-6fae-08db1a650e32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DNvWGL0BcQNqFOxB/XflIegDfiz/ad+8/xat4ajLN/+xM9pwHl4AixDYWOIZuFLjAHqZ92jxJx4lDDtXF6iabUZIXXENhbSHAdFzFb58Dc9uWdIaJulwKFLKQ3PSAV+zy0HAptFYIpoz/B1B7zvaYP2u/axgV7gxmdxR3D1NLRp3rlkhgRUuOWIWgerqh4JoYe3TW1Wk9LHaKYh5DQbwuvBrLioYddPrt5/+V2MXkytWmQQKJq7mAdu3cPWyLJtYDl8vTaFgMfQVB8BI4X/+2XtLzASopaVWkeYwC/Nnskjp2gfhE8N2bQY6qQ0xWDntrQWyflnruzZXojZKMjSB3NBQ/I2+u1iIrUvw8MXmGtVQEQplXaYU9ltoVtBDF9Iw7arBGM1Im6nLda+A+b0u8BRvne77JfNUuExuRxv42lhUSBhMRO2bMvujvjhcLADiXCmZqZvFUjeFnPn4tZb9DEov7Uosx28k1/8KRhRbEU1xSdKBFlCAgkaHtL+jZIehQsAikvXbd4wN0bc/Rn7Tp0Ck2D3si7RLkJKd8fjnR+hnWcQuv7fGlpsfzOMpO8icVzedExhlySYuOIzC8Mxq9rIHugaqlDoJOUZCusaOtbzNRpsugvMKjsik6A0p+y29IiZLlqyLFbrWM/S3o+NdAWAnSvWZ2RHuLwSvZ/5txKfeZczeT5+Tzppi837a2uLL34+3yM0iSupnqqrv5Ix5+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB9648.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199018)(6666004)(6486002)(8936002)(52116002)(2616005)(86362001)(316002)(296002)(41300700001)(83380400001)(6512007)(36756003)(6506007)(186003)(1076003)(26005)(8676002)(66476007)(44832011)(38100700002)(4326008)(66946007)(66556008)(38350700002)(478600001)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YjehmtuhPy7Qg1nWyeILiWtxixjA7Rt0fOuG+RjH+IrJK4FrrzCzGWuPvlOg?=
 =?us-ascii?Q?tLKPNqGzWSr/2SNrA/+ZcZDltXq6QoguDrJXnufpUerVbMLDSloLC5eKdQXP?=
 =?us-ascii?Q?KB+n7DCGDF52L7UMfd0nTdoZfnygXOiauhYBUZ0cYZhFuDo7KHd5aOtfLelm?=
 =?us-ascii?Q?s0FtV8b4WeGEmbiuBiSW8Im4tfD12pg+LAEWAnmbu8y3T4SbulDHzvtudnKI?=
 =?us-ascii?Q?ojdFGuJOeHkAlUK6CFOUeXGGI0A75SXASFCHi2N29Q4W+zCWt08/A2RP2NER?=
 =?us-ascii?Q?/BdpxMcRLfzu4SFitAyFWYE+6Rt4F6/CHb9aNN5t1GGHsymNIdzWw1pDgyly?=
 =?us-ascii?Q?lp4TlDsjHEv2plQjAdm21OKrXuNuYsDSEwqAWWuFSPI5/b2ZDIGVV4RLWg8t?=
 =?us-ascii?Q?d0MyChGyyYrtkFyt25O7Xk1gkw4POWI06cODkVO1p99IHe65LmwGcYd6DI4p?=
 =?us-ascii?Q?ZxJwqiYsjsRoEJRIPpYw8uE+b/XTD647kDdml0hDeeBQ0xmVZ6KieqbEaDgh?=
 =?us-ascii?Q?FjFJhXlLJ4fI3nnJwaCNpjq/W6nGci10/ukEVb0gaEuwcBh5XzYUz5jXWrAk?=
 =?us-ascii?Q?c5WEoLt3LLp2YX0mvpNN0N8IMu3ESkAn5Wfeir0NY8/HwUJI+Q4d028gzoac?=
 =?us-ascii?Q?lvywXWWPnXiPpDFqMhKUCNDZDNpRA5YFHzF3OV8KevIwKyRA2LH/SKtRe8K5?=
 =?us-ascii?Q?ijLZXJa532SbXM82Cxk6sd9ejSa25PT6wUmv92Q2nfyYF+IVx4YMDf9NFpHb?=
 =?us-ascii?Q?NpFmiNYr0XGX8tBYnoNAsq7oKtjCIYJQeDBeAPWaNCjIPDorA7JBcjERawkb?=
 =?us-ascii?Q?lqpPsHC2AaBxRT2CdaEdVBklFU6cz7FesnQ24bVYbEkFFJLA0UaFk+MsqbiN?=
 =?us-ascii?Q?YcKS8HrEo/H2rqVAlYBYov8XHb9LKZUtreBoev6mUX1nHU0vEABgXLRr/jlv?=
 =?us-ascii?Q?7brpziqE+SMl3oMxw2aVIocgdNrVxzzKKWLS2fzX0gtE5S5LYTGKF2tw4spa?=
 =?us-ascii?Q?rxne00Vxp0tmY7Uc2s1KjejOSHEsvzF/qmb9pxSd3S/a5XTX3+9SEMXOjpiz?=
 =?us-ascii?Q?c9Hse1H33FNqUo7tMwUgF/FXAePXS5DV5pQZUm/kftFo3uUMb7kFQFpi3Hj2?=
 =?us-ascii?Q?/uyyvBeSCAMNWwwKKEpDVVOhtp4Ik37tNKSYAa+a7HU26G1aziKXNVCBfo0q?=
 =?us-ascii?Q?SYiFGn2/45YAtM1ifg74Jy1edv4iA4LowJIIbkUt8wmDWLeNoH311WEjKQ30?=
 =?us-ascii?Q?IYzvuSP8d8Py3aGxsvEFldD4Sez+YpgyY61u1eHm6AkMyUBG78EQLe5qjH7z?=
 =?us-ascii?Q?NO0Aactfsg9A6CM9RYZNkocUZNmjJK3v5fSrf+vTZMRh1y0QdDsImPkmqn4n?=
 =?us-ascii?Q?zEHPgtbnXG044JS9ym80Ti0sRixYrHrkBzTfUQ9BC0XxgrR6L8Yre7Psjs2Y?=
 =?us-ascii?Q?Cn6q7FKxIzDP1R0UngpWHVYXXWIfaXb1EJONwZTvNM5rprZMPN9U952GgEEN?=
 =?us-ascii?Q?POJeqElQM0Jx582qX0uDZtFibAIfMotQiZU4BywUuXw9PUUf3Ps1Vc1yAp+4?=
 =?us-ascii?Q?n1x8/gjsKQWDoiQbsnYDeQZkZL5L+Bn7hWuxQLnAjU89glPCIhost4e4Wu3Z?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50154116-c5bf-4f43-6fae-08db1a650e32
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB9648.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 14:55:53.6668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KJGBfrEXDentoV+srrm2NSamjqCi7bhRjVSkMTiPiRDgSzy01Od+SHLD9RJoV9SbuXK3LAKTaTW3sAnQqx/zIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8499
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
index acf0749ee5bb..7dc295b7af8f 100644
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
+		if (!ipprot->flags & INET6_PROTO_NOPOLICY) {
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

