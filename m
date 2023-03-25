Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8269A6C8F7F
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 17:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbjCYQky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 12:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYQkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 12:40:53 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2109.outbound.protection.outlook.com [40.107.7.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0464EB6C
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 09:40:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crcSUJZK5XHfJp0pTA6ck3A1E8hqQc4Fyv47BzNiJDJxATA1MgyuO2W0a82Q2RP5PUbtG1frptwvcRDlZvHtC64TJqMnNySXXLS4LnJaoA2lpcZUL6YSjQH89hDV9ODkD55Zh2wE+BYwQ6bzb+65PfWMkfzX4/hUDQyxcusXhcWvI8TgJIRgVCcMwLyXSEqxoBXQfiQP7S151fxCzCQI1v47ZPUrVqDLjCPBcvRVzrm19VTXwm46JGMpE/eodpZi12GogQtOUroxs8x6WT/5A44pBqx2N7izEqdlxoaMBow+4aupcLtn3mnliCEqcV3qCy/xG3Q3nhQJE4PlU3bxQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=osZLI9tPtiVSKKCa4Wb3/hfmbob8BTPn30DtBwbLVSw=;
 b=bDxo59Xt618DTrBVyZjAvmXmTlaLKxr0Tvpiyjg86gKmUZlVVFOoVWHkm9+bhUSS7M+hTQekCC1T1sewaWeOupxQAFhh9Ks2K1FloQ2SoVcKmfATKGu21JHAyQk1S9PGD9+JJhrrbtN7XSSBzcN14GffqT0QwxhVoMjXGcQJXTuRVt8XgcjRho1LiP4smC0iIyzqefCwhwtRI15lzjIbjolvOPu04uPtpEnnsl5tNQ7ewaLXhbyvsvHbxeLDmMzNt9cgDFftRmDn3rl9Gv2xCtnEQ+Fw7wMOQDL4tVEnYeepiUeLrrvIBB+Fqzmc4HTVVgG/k9SppiNcdNvY+UP93g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osZLI9tPtiVSKKCa4Wb3/hfmbob8BTPn30DtBwbLVSw=;
 b=jOmfuPXQr/Rae9tIIoOvvRu4rYc0oYNrYVp0E3XtEZfB9Y7vm9UinO7zIjgZ4OvT+WHF8Nqu1jG1fE+J2qnULUYtD1TixcUVhiN2po7V5fcEeVHUXONyiNMDGWUo6SSA1nRPrJSbb3Dg7x3A+UbxRvtbTFR98KanAeakumFiP/w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by DB9PR05MB9413.eurprd05.prod.outlook.com (2603:10a6:10:363::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Sat, 25 Mar
 2023 16:40:49 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%7]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 16:40:42 +0000
Date:   Sat, 25 Mar 2023 17:40:29 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, maxime.chevallier@bootlin.com,
        pabeni@redhat.com
Subject: [PATCH v3 1/3] net: mvpp2: classifier flow fix fragmentation flags
Message-ID: <20230325164029.3lmv4yikyei6yst6@Svens-MacBookPro.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR2P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::9) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|DB9PR05MB9413:EE_
X-MS-Office365-Filtering-Correlation-Id: 0da2afc6-a5b4-403f-ae32-08db2d4fac99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f6kNk5rifPq/QFSSErskMuED7bEAEG78ngOZhIsB6u5O8/X/S7VkrCR6uJ/kenrk0BFOuuTda1P40rs/RHVzn4WBVxmL1/3YH0b3S6RdfsDXMtdusurlNqCNndjlBoNrQ7ofkWyc4OAXR9TflVM3JUlFeuTtr+rtpB72ijw9vJrawYBszz0V9nPAWCL87HGKehqwAuYawZKWT2F77O/gYdn9i9dj+NuEuYqXeOljCAzSrj+ZHJNVcixB6CfIVAalPby9DLSPrWeUhoh9XU/kXaRs5ck4WqWVf1Ym2hMONxGvM1NFLWOQvbzWGEFIrgqXdO7RxZPvP0VcYqpc6j9eVlK864zPfzIy+VUn5y4f3QwFKwFuXKxM5W8iM5Wp7mLh8gDzkZA4cqS61bW4a5CwrvFRVaCceIdU2X2P5RxHIVPDZpraGN2SqSyWBdN6meHSsZpB4ObMLBk9RY129yPR6q+88RS9yDSPFhIKSw/ueNTQf7NHM1RQNxsoiOVjDoMtbFPtpr/M3g6piY9IsVwAwGlii+t2xkOyFoLXh7asncRkIoD+esDxH7O9jZiq+fjJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(136003)(376002)(39840400004)(451199021)(6512007)(41300700001)(186003)(86362001)(316002)(478600001)(66946007)(8936002)(8676002)(4326008)(6486002)(38100700002)(66476007)(6916009)(5660300002)(66556008)(1076003)(26005)(2906002)(44832011)(6666004)(6506007)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a7l0SAB+FcTE+acm6bC2ipx8//QBsUxhbb9zKZgdbUpueEJ9mryAfz4g95WM?=
 =?us-ascii?Q?hXEGrgzGxMvYnpt0pb3Vo14y1EIbQXg2pgG05ogozTEGhbTQzRC0HDSuTiam?=
 =?us-ascii?Q?rNkYW9gtQVhlU/dUP1SlErKJSoSwgUcrj78z8dlfUhvLHJUwVowHrk7LknVL?=
 =?us-ascii?Q?gmQ1CMgTORDDiNTmufHeNfQBmv7ClrtgazycdrXGnRRq5g70YXu9dqL1k/yD?=
 =?us-ascii?Q?/6+vHCudyMMVXuWml3obvSjpQffICJ6UcJReGWj6d9jm/7Si33jEf0QJFTN3?=
 =?us-ascii?Q?6ITHw8lcFUtTb88M1n5FtpVqo15zYf050uSflcIl+35TNyIshhFaM9didpb5?=
 =?us-ascii?Q?UNr0Hg35GIhcuOkrEN/W5sBxBKqt/guigW9wHkq/zSODNWSwCocVodQQPXTe?=
 =?us-ascii?Q?QsV1+NMKHhyrsRLtIDiBLHU050PpUKwUT1ERnzsQcwynjyw0WDX6kzjHi9WG?=
 =?us-ascii?Q?PSg0KkvAUlikCC7izJI7ePjK4lRfUzVqb/EapuAuwUBlC/Ol+R6/Jwd09QC0?=
 =?us-ascii?Q?AEc6xnoRnro1HJFnKlMbtuUeu6NoGao9x6bSgDLhtXYuLOad+ZP5NjVtDVwL?=
 =?us-ascii?Q?x1V5kDBZJl0Vy17/kpOiMq+kVhHZqoAu+6lF0UPOEUpbfpzM+RO+jYNUTY5Z?=
 =?us-ascii?Q?J9JgANjScXJcV2xrFc45qNcnfYh2vQd6oMgRCQ1R+QEfHi3vcimCwa2SKMLk?=
 =?us-ascii?Q?7M07X48XPs7+5wrbqtGPRmfraba2Sao/Nhhll/pRFEBR8lHGZ2lfrh6wqknu?=
 =?us-ascii?Q?C9Qsjx9c46V1z/leT5VxjuZ9dWPEG92lg8F8/bzEZZQLE8QbByoUg3OB5hsF?=
 =?us-ascii?Q?VkkB0jgLfGmUTsUxZllEaOYBxF7wXoJXLVyLsZtmjHgBFNGj/UFdc65vDvPJ?=
 =?us-ascii?Q?3ITRNEbiY7E9vrh3U/tlcLqpHdSzgqnppOI7a4O2VxsnuRQ/b2AV0LlddlT3?=
 =?us-ascii?Q?8xaJ66FLzFX6fYNaLq0HajVG731LUnT6NIOAoD1y4G1G+QOqv2vToEMX008F?=
 =?us-ascii?Q?e0oMRSTWIbeV3b8hTbM3+5u+e1I89qp8hD4cA+hnpcgycmO2dfZiXRd9Mbf/?=
 =?us-ascii?Q?9jdYEXvxbYILllP35vFy1nLLctdxDTmH4F6DIRbwYg4WUaoOInqOnwDgmjv1?=
 =?us-ascii?Q?gYIgQYUX/Vy/PEpOZytGE6J5mRItB6qXWJK5/0JIMh6AIm9lYj+To8aL8bpF?=
 =?us-ascii?Q?cJ+zAf90j80RtncJp0pvOjZCJjVECC22CQ/PxM+paBu1D6t+RMWKq2qL8zKO?=
 =?us-ascii?Q?dAo2AZQrftYyGGLqSr0R7K6b+FA3kzumTqtae6Ej0cBJF3WKXbqtR92YL+Dd?=
 =?us-ascii?Q?OZ3807Bw6JR/RVLvcYjnGpztqaHJLnRWsyN1FgWNew9cfMGSfJ0H7hS60K+s?=
 =?us-ascii?Q?Y6UyM8xy/E8z+fLyGAeA5EEaCae6E/D5RUCcJZmGro59/4b5R/UTUAVgXRWu?=
 =?us-ascii?Q?gUDbDUETlmG3w8VQMhWhJZ4zqT3nl8AEeZxmTcKXyrWvGXSgQafHX8QtC0P8?=
 =?us-ascii?Q?Onv9zADwMoBsPOlCfEkfcJ/kEDAzdlFbj+zQiLhVGHuGBf3yRdK85cY6gvzf?=
 =?us-ascii?Q?Z+7j3IdqbxX7+mRG9k5PVgXNTeQ9PqPp1elE8M7DC1Xs8Pj4SVdnBRBKsBmG?=
 =?us-ascii?Q?Kg=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 0da2afc6-a5b4-403f-ae32-08db2d4fac99
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 16:40:42.6362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: czlhWW9WAHVFP0IkEXQxj4DIQvaV0v2mv0Hoq+nb5QGQF5V6Bs8TpoUBFoMWNWxAtW0qyRmJ+TlYidQdXSqXZHb7MbKN2eY+srk5s+eqIZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB9413
X-Spam-Status: No, score=0.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing IP Fragmentation Flag.

Fixes: f9358e12a0af ("net: mvpp2: split ingress traffic into multiple flows")
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---

Change from v2:
	* Formal fixes

Change from v1:
	* Added the fixes tag
	* Drop the MVPP22_CLS_HEK_TAGGED change from the patch

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 41d935d1aaf6..40aeaa7bd739 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -62,35 +62,38 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
-		       MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT |
-		       MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER |
-		       MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* TCP over IPv4 flows, fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* UDP over IPv4 flows, Not fragmented, no vlan tag */
@@ -132,35 +135,38 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
-		       MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT |
-		       MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER |
-		       MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* UDP over IPv4 flows, fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* TCP over IPv6 flows, not fragmented, no vlan tag */
-- 
2.33.1

