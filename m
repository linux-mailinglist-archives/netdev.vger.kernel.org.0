Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F8168B986
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjBFKJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjBFKJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:09:26 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2076.outbound.protection.outlook.com [40.107.20.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525C71043F;
        Mon,  6 Feb 2023 02:09:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioCCbDBbEyu2x4T2FTHriSS3KgMiLSTFvdNBS4GTF4kdYfcu1NN3dRhcNDAlWXSAWBWgH1OEUxjWIhqYww/9ksx2gzIY6i86kGnoQTyeFOsWbsA33wBLfw/FvVhsrWREsN9e6Nv7o3xMwDiMk9W3OyZqfm2n/qu7WmiHCpHd9LqAIaTwmZR+HDHjxd7Pw5WVUAsb7z7VZOdb6KHH+qSZLCLRBPwR4/iJ33yXq1wSjdHjl8AfLD5VlzjV1yia1peMM8rnRTK5UVhQBU7vlCp7xoDEpoYyZPdjnPIIOb+pOXD7NaKhfarWQZ5Z8h/klZ6bnNFp+HoZmIAx95702wYI6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8CjEZ3qPqjoAGnJWcglwbUA8p9Q13/ucOiN10ijM2Bs=;
 b=ipH4ZqU2b03EPUTCmtV+fW9fZDpB/vdKSG7TmFQabVwCUwXo/wr/A85EpNHB6ELEu5gRmgrfO1c66WOqrSzTwDXUKjIS/WCzW007xxBBpBRa/BtBJNB1RGAEF9mSRf6a7cDUC9C0mUZJQ8dzwy5gtt2LRYwkI7OpxlQri/ghXYqWalTZLLHal+vGUO/vWQgUmouZ9wMiqfEkLGYxuS+N8V3n/JqOHoRC+Gp0wAGL7amttK6FaECwOewmxOBXluscOaV+5uCZRu8I5Ab93mo0j2Z0HO8NWdTR/jbZPIWkrFmKWpSg/VHuBnntLWqELcNFYbGsAF82RWUY8e+7GgGvTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8CjEZ3qPqjoAGnJWcglwbUA8p9Q13/ucOiN10ijM2Bs=;
 b=XWajIViRiu9cm6DS2OA0xo9P/7sZoBuD0HewQ+FulspW2vNDgZy8LNxsucDsWtjJ1by3biDHjNxCXVvin6vne7In9gDcjLFtlJVrSV3Bu91rNRpcWoi8gGGixezz3/AyHy+LJT/TKk3JWMgHgyrsUha00mgsvLpwClQ5kR/beo8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7735.eurprd04.prod.outlook.com (2603:10a6:20b:2a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 10:09:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:09:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 07/11] net: enetc: rename enetc_free_tx_frame() to enetc_free_tx_swbd()
Date:   Mon,  6 Feb 2023 12:08:33 +0200
Message-Id: <20230206100837.451300-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230206100837.451300-1-vladimir.oltean@nxp.com>
References: <20230206100837.451300-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0019.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7735:EE_
X-MS-Office365-Filtering-Correlation-Id: dbb61087-c5c3-41c1-ac8b-08db082a2fd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8DDQa73QHUqNWYPL9DizMsoHDRH+s1z3unOvxsY8As1DwZ2dAMeuCma0XSAg2TBQwb38d5iRvjIDovpORIfYOy+fdJOIZy/xa8rNIm+1TlwyY7DkCgAPQp5Z6MVtmJ3w9Q8kquNZPd0PEXnMbEQcyUDCz2xjB94/MYEbYLmk1ZeYAoynD4J2W2gDnhwiRIo31v9NWlAiNzjixvcSdUlSSAw8iyiFWTvAMDsuNygIi7WXw/j5ZHj6o1Y7hUch/WHpmQ+OWgewnNTCoMSBNZ5McVkTQn5J+LeCmf2V4/QQiG2mYYSXFiSc1TpXYCJIZgdD8mUV9oxUIzXKlrUDJkG52Ww3H3Y34pPn2FZzMVaUmuPBO9maXp1FSopWcARsEsg62BUZkVllFqjOpGTH8PmmuVjqHodNnBoJ/niYw2zvJIU3BZrUhNE9attVZyEVV9Z7QQAlpqygjC2V61D5X1nCc+NKQ2mbUkkQs7Vq0pc0oHQw3xjx+BMNJf4wvXp6ULnfxVZOq6mLHMDn0uIsEtwMcCECCSB67VHeW6S0OfXg+L322WPYBJnum7mv6l7+9tltLJNWyBE4Vn5H16oIws8i1MIVh1rH33UGq7Z8bkZu6iQlTVMQHS6dZ7KMR0f3mpIZ8d2JaDIO58JMBgzpB7bYjTitPWM2v51URyRT8wUdkHFqeM/AgvBPLLbHrRPcItCf1FOPYTzgjrePyNyeOTqObg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199018)(86362001)(36756003)(38100700002)(38350700002)(66946007)(66556008)(4326008)(6916009)(41300700001)(8936002)(8676002)(7416002)(5660300002)(54906003)(66476007)(2906002)(44832011)(2616005)(83380400001)(478600001)(6486002)(186003)(52116002)(6512007)(26005)(316002)(6506007)(6666004)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ihj5yC7QGVM4q2vo0/wvwU0/p50SjaD5sFDviuZIQJi9Kl51hcNj2Mo4NtJc?=
 =?us-ascii?Q?3mToJ8MHM3EvM56qzb0iZC2yWFhj3LiSddFqjPKoyy1uzOdGsYCxJeehNV4c?=
 =?us-ascii?Q?PMbArzBVzTL+FQEBUAu5yh5dj4LBRumdD6GnDnRQW64qMs1s3fmKRvvoGmxl?=
 =?us-ascii?Q?c3BBnwiBMucU2BPjh+N1bBAQgZUlVsAigZTFm5BsMEOW6k4I3ADhe36kL7h/?=
 =?us-ascii?Q?03AonXqHaRgkR87BLgqNY5NqZsIo44Ox8hQncrT52rt40NMG8bU5orWuop7I?=
 =?us-ascii?Q?UeGdWZ+zoC2FzwtVbsnVb6padd64y94JrWZJ5xqyVxwu/+02nlkE+R+unDyQ?=
 =?us-ascii?Q?sRsCTlMiFlqc4LtxHKpQs+tjAGcd6iM3hL6HTs4y7nA/Ec9BkdKOxr2NPEVY?=
 =?us-ascii?Q?6lLF5ACj3CfnC1QwHzS/O66BLB+Boo9kyjXKpG2Qabu4I2tADFEwssCnDZ65?=
 =?us-ascii?Q?VgtlJn34VV380J3QQCGTXyl4R6LERkYvw2NRLWlU3R+Y2qRTvfftjBt4Q9yi?=
 =?us-ascii?Q?oGLhYT0XQupZblTmST+lUtaJPC/VHhC0ixIlDURFtQM4f5y9XPvWfCuQ3gxV?=
 =?us-ascii?Q?ukK7Ti/twt7xtLU5H8+jLK+MrBQnZD5bGc96DPyhVL6cw+3JE6rlG5BZzlJS?=
 =?us-ascii?Q?O4YwduervTI/TrK6F0zpXslIkPhEz+2pX9ExnsagJ6jrdnlite5q+Am3bAXV?=
 =?us-ascii?Q?wpA/hvyTUxOpvUY/rBIiAvTw2wDZkYdLAplE2WgH4Cyxc4qr2KIbkukTPY4I?=
 =?us-ascii?Q?n9CBpS1H/XC4ecqGLUxNDbCrgsUfZJqTz/sXdNBU2s7HUI8/0wybr6Q/IVe+?=
 =?us-ascii?Q?WECtfkUFlNkuQKRlK5KZJ2nHlnnyjAgtQl5luHXVOmZMKZwwazZGmWH5kv58?=
 =?us-ascii?Q?FtBhicGl5iTq4uGy+RC92kjN1zrNCQWC5vnRUPVic4dHfDxELDVp/KR4Z578?=
 =?us-ascii?Q?xn4cjdIK6vXbbDevpxpifn6d1aqiUMtgg1bzD3QMh826s1oc5l9Epicg7tXf?=
 =?us-ascii?Q?VXisHHzBdbKUnKeOsHjE70ncNSKQ3YEjEYO8a0OrqfkwWvHPhe3WAIkHcM4i?=
 =?us-ascii?Q?nBDfAiQ61yBbG3Hq17W0HRulZSw41YKaQZwvE+2IGqJejjOOx8cO/11Sqb1g?=
 =?us-ascii?Q?za2cw7wd48IwEbHgNeTAKDWNEmmGb6KulT4vBl4wC90RD7BvmHoxhgZ5iQWy?=
 =?us-ascii?Q?lyjLivBLGQOfiIIK7TyaufAcL8Bhux++RqvfuamJWIkE3W7TE/B/m7bf7SkB?=
 =?us-ascii?Q?QPgWnl3oH7ZTOtkj1rQPh0hC2XBCZIF38f5fl/lHsH7O0CPl9hujj8xCUq6p?=
 =?us-ascii?Q?jRAEaf3mR4Sxj82sC8YwpQ4MxkBnm7Oegw/2V8UVzScO8d7qzj7y/P94Lqcw?=
 =?us-ascii?Q?vqHmrA1koel7SP9rYtNNzCAzZPwxpWG/Vvy09kufBXPrPP0nvNZ0SMyQoJMb?=
 =?us-ascii?Q?HhkdXa1IwOxdl5btDEHuZaHhb37TzQblrwt9mKFuf2zZbQIfuf4B4EyR4Onu?=
 =?us-ascii?Q?ow59TSneh7G/T+fWrvz5lmxHcx7hph8v5+HxkIIz/ruIfXtLiGpPKo8+PQZ1?=
 =?us-ascii?Q?PIdiFYybHoL4w2SQZ4/JMJQ2S0HSI5F51ELIL/EKJ+VQ3dNJnRMBAgJo9cSa?=
 =?us-ascii?Q?Ew=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbb61087-c5c3-41c1-ac8b-08db082a2fd5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:09:08.9425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ku7GWQ/pri5E3lFcRdB58Akh00shgqAYk6bMJBOHLW7ES/QE0phgn2910kHUoeikjXYcw9QkFB2n1mdtg+6ONQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7735
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create naming consistency between the free procedures for a TX and an RX
software BD.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 33950c81e53c..fe6a3a531a0a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -77,8 +77,8 @@ static void enetc_unmap_tx_buff(struct enetc_bdr *tx_ring,
 	tx_swbd->dma = 0;
 }
 
-static void enetc_free_tx_frame(struct enetc_bdr *tx_ring,
-				struct enetc_tx_swbd *tx_swbd)
+static void enetc_free_tx_swbd(struct enetc_bdr *tx_ring,
+			       struct enetc_tx_swbd *tx_swbd)
 {
 	struct xdp_frame *xdp_frame = enetc_tx_swbd_get_xdp_frame(tx_swbd);
 	struct sk_buff *skb = enetc_tx_swbd_get_skb(tx_swbd);
@@ -331,7 +331,7 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb)
 
 	do {
 		tx_swbd = &tx_ring->tx_swbd[i];
-		enetc_free_tx_frame(tx_ring, tx_swbd);
+		enetc_free_tx_swbd(tx_ring, tx_swbd);
 		if (i == 0)
 			i = tx_ring->bd_count;
 		i--;
@@ -580,7 +580,7 @@ static int enetc_map_tx_tso_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb
 err_chained_bd:
 	do {
 		tx_swbd = &tx_ring->tx_swbd[i];
-		enetc_free_tx_frame(tx_ring, tx_swbd);
+		enetc_free_tx_swbd(tx_ring, tx_swbd);
 		if (i == 0)
 			i = tx_ring->bd_count;
 		i--;
@@ -1986,11 +1986,8 @@ static void enetc_free_tx_ring(struct enetc_bdr *tx_ring)
 {
 	int i;
 
-	for (i = 0; i < tx_ring->bd_count; i++) {
-		struct enetc_tx_swbd *tx_swbd = &tx_ring->tx_swbd[i];
-
-		enetc_free_tx_frame(tx_ring, tx_swbd);
-	}
+	for (i = 0; i < tx_ring->bd_count; i++)
+		enetc_free_tx_swbd(tx_ring, &tx_ring->tx_swbd[i]);
 }
 
 static void enetc_free_rx_ring(struct enetc_bdr *rx_ring)
-- 
2.34.1

