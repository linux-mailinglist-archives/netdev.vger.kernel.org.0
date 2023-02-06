Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA8D68B981
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjBFKJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjBFKJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:09:26 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2076.outbound.protection.outlook.com [40.107.20.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F1F13D45;
        Mon,  6 Feb 2023 02:09:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfUC3k8oQxDSxkdGvFUFIgAH4WrcaAH6Cp7Tvv8XlgR6JiHeRc8qHZClh1GDRY1lOqXVYDKPE3QSVC8mLGx/1gGQtXd2DsVpNIo/bfzMBAwvdlEwu6m8xJZ77tZ5w6nGYc2le7yRDoAI8k3I9Ub3wAGAUDAt7HnVbv2JnunGCiQQxeKdqNx+1OErnWaVQ5YqOmvoEYDpIRzvmBPGr6qdF38UmAbRN1A5go4skGdIS7g7if3fm2qVl8wo32cbcMAxTBSluVZrDurb3731M2oVR/gbi0N7TXQt3dSDmazB/BT+8WAAu58kG77dXYMVgdMKZH35D+z+eHQs7A/WD8VSGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E/v6lLmpQeYFlEtgAIe5Sc1tmdXZPd9iPKdGEgDMruc=;
 b=CO/Kc30DH3wOMmt3SnILZI7ehfVApLNVo5NmpbkJvVbPlS6cVAydkLanxsRR9Z1WVBrTC3PSkKmLsocZVdrCxMz+qgs0KxV3uARPLc2kIsyAInWpvdW3pKGJzEwCaP6idCh0sBCzt6kFozpnqa1eEvd8jr7+EGEEjdLCLMQJog0uNIVLCG5lJpwSU/6rCu+a1U5pIi5bB4E2Kr6QLRyxqAjfDPsflLIheChMLqxyEY/x1apjlzrvUKG5SdProVXvx0qno47X12/5GEPE+jkPEXZp5Xsh14Q0CpxcIbBT8K5KJOKgERp25ta8AMtzYq9hvisnjAcSgxzj0fVPipp0uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/v6lLmpQeYFlEtgAIe5Sc1tmdXZPd9iPKdGEgDMruc=;
 b=DSdTuh6a2gfP1hKTY2ASCBKqM9OT+ybXcHcGXuVi+tsbD9lHu1zEXzvxfFSc85lFtFXmOdjAyRYpGDfMsvC1aUTkYFWQdaXdRI4nmfd6hGjyUxapm+JcKFo6NN75u+6hULAhFtzsIbIKU6frA4DOsYn8m4nb+G7dv/S3R4s3F5Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7735.eurprd04.prod.outlook.com (2603:10a6:20b:2a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 10:09:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:09:07 +0000
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
Subject: [RFC PATCH net-next 06/11] net: enetc: consolidate rx_swbd freeing
Date:   Mon,  6 Feb 2023 12:08:32 +0200
Message-Id: <20230206100837.451300-7-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: deea83af-e018-4c9f-f7da-08db082a2ed8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gw08D3GLmD8iGnfOsd6tzX0DQaJyNBlS3tmXRhzJhREKHIQm02vEyDLN/cMD3/SppckRJEiiP60/p+/1mcNhmBERv0PLrygr49UiUqJPHLgsoFZ4V7+8YxdwClNpcRUWgYUPeslPsnx9Lk7RczbuAAkPSparub7EU5QlJvQ07j5aear840Yzhi0D1W0zN6UiLrDb2Pov0QyYsMDn1NQI30/p+suFu0zHIWMcUmzwkO14o9z52blptTo48MIsYZM6KUfQMdj8kVmXYxZTvfZVpPIVh+S6+Gcsj/Z+JB4Y+cb4u/vfhTSviFF2S5ySH9+wTlzYEWZFB0vgYTrG6c7k7pvWIabiV78fOp5C4UOo6mmcowBT6D7js8u2sX4KscCOUwXWuAPSVcZrnt6htnaWbe4ezO03vSrPH9COANDhjo9PJZMNJEFHUN3NFAoix6lEiqD3S1luGacq6U2g+XBjH0sHpv7/VmlCq5jo6W4HHaVf/J7YqzSWt+f+yohqP4dhJjGwB+2NCVwR3SCDIQPaETPZCw+r4WV3F5kudg8oNr+4mH+cfd4CR+oednWJzd4nJWPe4EVLXoCpTUP/WHWkLMtyiceUrGvGt/gET/+RMYWPrUx3GBEaDKICxWppXct9OQ2ZzfbA5uGvtelq62EQ/F0w8rIw1MkrYdcUmFwiPjFkGXUIllp4ZUFUtgEfHbx680vTSYl5C3shvezLx0W+CA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199018)(86362001)(36756003)(38100700002)(38350700002)(66946007)(66556008)(4326008)(6916009)(41300700001)(8936002)(8676002)(7416002)(5660300002)(54906003)(66476007)(2906002)(44832011)(2616005)(83380400001)(478600001)(6486002)(186003)(52116002)(6512007)(26005)(316002)(6506007)(6666004)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0WtJX6tgoavvK4pO2jkDINkepJ98VhBXTcjYzA/QvNyMpKT/2Kb9aO7bl7jd?=
 =?us-ascii?Q?DilSddDc9HDDUUgoQrj+gnxN4KXgbLRhO3HROATTUsvTtprbOkB0Zolqs+zj?=
 =?us-ascii?Q?Cbb+l7P6Zut8A2JT9c0GnfYtSmV3rE2ZKQJ9lVIPvY7EGqSoJBnjYJqdx9e6?=
 =?us-ascii?Q?WCwOPrOR6eRdmR+YcT18coIrNuA5JrmnhLYKLgo+WQPy+2J0B4Vkq573ofd+?=
 =?us-ascii?Q?UKIX0IcCrz13Kyx+dsEKGy/NbR/joZYUDbnH8rk+YuE8623i5f428DSBeNsa?=
 =?us-ascii?Q?/RZUhd1ltduvQ1Cp4tDRmOAfIs0JqYDpdukDVt6rwch66LBp16B0sA8UjVXU?=
 =?us-ascii?Q?IgBaq6fbC5X6iKaTNOc1unCQQ1RLMSj8CFkcXuQRPOUPXT6YUzP16bz5ywxZ?=
 =?us-ascii?Q?AI9hsQHwM3hJGxiVZ8oJLHYRvZXmCWSqw+OjIcek7R3uxAWUaYOr4s8G4z4J?=
 =?us-ascii?Q?fRfzbDJzCqg80Wj0KBUogTsOgEShgRzgTCUO57mBnHKtDNgXsvn17EUdQ2UK?=
 =?us-ascii?Q?An5rOLDrGb5UOAvQtImbjyJ5Uil+atX3IOiUfYnydLHBY3u+k275w+wW65HO?=
 =?us-ascii?Q?fEFHUGFY/4bVGL2ed07AiXM2EqBT8K3aOZMBAqOvLCO/g8dP+z3M/wmmftGU?=
 =?us-ascii?Q?UetRZXWVMkQOth4BMnyDYhK0rOj+dS3oyi0ltp5nh50NNHmCklsq5aH9XnQh?=
 =?us-ascii?Q?K2y4NVFUZ9yHGmn48YODAReh81jo97Oa12cHmo2Nzbh+x9zo+GyYdjU0OH8L?=
 =?us-ascii?Q?e4Pmml6h798Nw+FiaILmW9fL4A2vnSC1C8YRhsseTT/UruDA6YbuiCQdf9vG?=
 =?us-ascii?Q?rZvj4CtjzCQC9e75R/HK3dbUw/Yob3ri9Axf6dWKhBfy6/l+Cc/nZVrd085j?=
 =?us-ascii?Q?ZhdIUV8ftmcV63L2v8Is1UYPDJ0PPSMUL34c+yMfys8mNZ0xe2Vdf9e0xH4e?=
 =?us-ascii?Q?Pvzlwq+edgILSI71aDfEWozN/IkwbvUgGDFbpS1DTJCLFZGKTSozLUJzSShJ?=
 =?us-ascii?Q?paGMf1MShQk8N3aPs5joM8E+2CLuzF1PeoUfOlKR2r3iRzGdLNZwucjvuqFc?=
 =?us-ascii?Q?HTTR6z8Jc0zazv/cU69eR8HFVa8C5lU7kLngBAeT86t9AGOwvE5BxAtXii56?=
 =?us-ascii?Q?YOv7PtyfxrhVzMjyvnwwDs+luR8oTGLy1TGgRX3ONM6kazxGEdAUGuCNkmzV?=
 =?us-ascii?Q?UnDtSmRhwH4zkfRut9TZtIrE3FCLvnrxbYUiRsG7bSKqaNFewWofU3ExKSP8?=
 =?us-ascii?Q?R2OPY+JL+9q0WJdmPExar1lXsugXac0xg6GWCbF2RbnDAehdXucxyus2GMJZ?=
 =?us-ascii?Q?YNydIKZTfxETFRQqGLbM1GmmFdt9ODhzoFh7j6f5a4f1Sn8qHq1PwcxlKNxJ?=
 =?us-ascii?Q?HIphX57qrSc1W4vSg7fLhSwE7AgRAXpF/wSte73inR1ThGYQuq+ik2f/VlEK?=
 =?us-ascii?Q?xotESlogWAnQgTjkVMzHXqhNW8pXynNbR4KzFDaliYFE4YNnklYjQCmqO+fR?=
 =?us-ascii?Q?p8Dha8J+CmusQfUEYpHFmDt08ODya0aHIqhw039E0eN3AQLcSkstImYSeysY?=
 =?us-ascii?Q?vRVxz0G4QopJYrxnK0JTT9heNRQmp/1yLxLRM7zMAhAqNnZ17tTeGRlKgXjf?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deea83af-e018-4c9f-f7da-08db082a2ed8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:09:07.2864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uili954G+ueKBVREPEZHOOwh/WsPpopmjEVxJYXdkP5URBPBKQdg1iJ7YDnNvuNWQm4r1KKwCKhNP3mAMTCdMg==
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

There are 2 code paths in the driver which DMA unmap and give back to
the allocator the page held by the shadow copy of an RX buffer
descriptor. One is on RX ring teardown, and the other on XDP_TX
recycling failure.

Refactor them to call the same helper function, which will make it
easier to add support for one more RX software BD type in the future
(XSK buffer).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 28 ++++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 37d6ad0576e5..33950c81e53c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -95,6 +95,17 @@ static void enetc_free_tx_frame(struct enetc_bdr *tx_ring,
 	}
 }
 
+static void enetc_free_rx_swbd(struct enetc_bdr *rx_ring,
+			       struct enetc_rx_swbd *rx_swbd)
+{
+	if (rx_swbd->page) {
+		dma_unmap_page(rx_ring->dev, rx_swbd->dma, PAGE_SIZE,
+			       rx_swbd->dir);
+		__free_page(rx_swbd->page);
+		rx_swbd->page = NULL;
+	}
+}
+
 /* Let H/W know BD ring has been updated */
 static void enetc_update_tx_ring_tail(struct enetc_bdr *tx_ring)
 {
@@ -796,9 +807,7 @@ static void enetc_recycle_xdp_tx_buff(struct enetc_bdr *tx_ring,
 		 */
 		rx_ring->stats.recycle_failures++;
 
-		dma_unmap_page(rx_ring->dev, rx_swbd.dma, PAGE_SIZE,
-			       rx_swbd.dir);
-		__free_page(rx_swbd.page);
+		enetc_free_rx_swbd(rx_ring, &rx_swbd);
 	}
 
 	rx_ring->xdp.xdp_tx_in_flight--;
@@ -1988,17 +1997,8 @@ static void enetc_free_rx_ring(struct enetc_bdr *rx_ring)
 {
 	int i;
 
-	for (i = 0; i < rx_ring->bd_count; i++) {
-		struct enetc_rx_swbd *rx_swbd = &rx_ring->rx_swbd[i];
-
-		if (!rx_swbd->page)
-			continue;
-
-		dma_unmap_page(rx_ring->dev, rx_swbd->dma, PAGE_SIZE,
-			       rx_swbd->dir);
-		__free_page(rx_swbd->page);
-		rx_swbd->page = NULL;
-	}
+	for (i = 0; i < rx_ring->bd_count; i++)
+		enetc_free_rx_swbd(rx_ring, &rx_ring->rx_swbd[i]);
 }
 
 static void enetc_free_rxtx_rings(struct enetc_ndev_priv *priv)
-- 
2.34.1

