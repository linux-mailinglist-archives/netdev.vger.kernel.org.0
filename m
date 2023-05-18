Return-Path: <netdev+bounces-3674-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94AF770848A
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:04:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FC7E1C20FF9
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0FC421069;
	Thu, 18 May 2023 15:03:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB8019507
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:03:57 +0000 (UTC)
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2057.outbound.protection.outlook.com [40.107.104.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89371718
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 08:03:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B6Sk/1f5du/gDKhZaHVh3xyW7npt6t2xJakWNL1J4FwkQJW+5yB5wcWd0LBNZYNPWkPFoRul9h6NCG/2yCEV8yRU0nk8aSLKnaG4zCUwnV5VCY9a0HEkEbwypSel7Eezb115e7YS/lABxr1u1Og3eRNRmJaSbx5HqiW5ftxAJkMwwDv8hO/X4hpz5LpO2ecA+bOaT7pZdVRSeAsQwG7AweJuIV4fdx5ZB3ReDjzTuVP+b8X4eLbIPuNRHablpbyTno4cf9kK3DYjV5G0Hh8GXQV+dm9AkY4NYmN1ObYG/CD8Sk6HvZrj5hyVCenaLS6hib0d3PJKpD08uJ6C1Pe4Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBG0cBkT1cY+BazwT04hOECXxopwNSQOYd+hjxNw2pw=;
 b=R9lyut6AdNx1wvEk9GpIQcmvYlU8Z0QIOhVpMCb/M3G5XwXoC0MdPujiTCKC5L2QxfCZUNE0zoO/33hs7L5JDOjhwfcuSOzOTT1GtGSpLqHWrTRJaMj/x4xsgEVe/di8D+WUml5ETY5pbRvm1XeHcJYtLS6HCXIhaaMz3kzjgarqpiXghlNcDmz89MWz1VfuXqmG/6gUNC1swx9RxyCxTTKtwgnungkqQBjBsKQ2KCpdErRVjaGMKtd66vvE9Oi4pHoq9wX31CSgzHGa8VYcNoWLoWJ+S90IDZZx7LrNnN68UR5hR11r0mavpWuDndlmyOAm4G1P1DLu7i5WgDUTpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBG0cBkT1cY+BazwT04hOECXxopwNSQOYd+hjxNw2pw=;
 b=SSpR+eC8OzbaASqYEJCDoC63QN+K/6rO0MHmwr8rg8XPYRvNZ13M42Xgzq+7ug3YcrZ8gzaTeyzVse/HmJiemW7GYopxvjsZNe1h8v7+cil61N+qoeCHKXi+AvXPl1xlo39iSzOCw6tTtg++Q0w++hfRP3FBMgS6lJr+YnkhOmY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DB9PR04MB9579.eurprd04.prod.outlook.com (2603:10a6:10:306::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.34; Thu, 18 May
 2023 15:02:16 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6387.034; Thu, 18 May 2023
 15:02:16 +0000
From: Shenwei Wang <shenwei.wang@nxp.com>
To: Wei Fang <wei.fang@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Shenwei Wang <shenwei.wang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	netdev@vger.kernel.org,
	imx@lists.linux.dev
Subject: [PATCH v3 net] net: fec: add dma_wmb to ensure correct descriptor values
Date: Thu, 18 May 2023 10:02:02 -0500
Message-Id: <20230518150202.1920375-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::33) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DB9PR04MB9579:EE_
X-MS-Office365-Filtering-Correlation-Id: 17d52490-fc43-4f60-0dbf-08db57b0de55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QwmluleHd8oSBkAWh6eseBPvKHCjJZgDqT8qvHiOTQiBEG9qkOLry37Q/9DtI/lwgKgickK+T0CGxWugYhSMRFD3dgRO0uCdf9E7r7xIEiyWR0tTRufI06MX7JNiwlMkqqQjUGKdsNpRIi41+KE1MX5K7ozF5wC0wjARI5XVXutQzF1ITHaZUrCnuU/TbCCLJ3zCNRAY0BruUp2cE/duqx/PaogxC1zxWal8s08htDc9dPbEgFr0nTE71DYXesShZlESGfj4iOPnqtg+9gLLku9dOk12cyqiMYoeOwSGGY2vGy9+XOZeAnTJug3bcvq3yqRtkm3IU2NRootZ7X8rEeUYwWB7mBOOqIUB3yfBvNn0D0W5MSSjUBLYLM3fAygmhsk3Hn7yeRdx+vZixXzdpYQf/Kc30Gxgv+uET2Ncd6i7LhsgZGCRXFZ6+4N0a7cjTwjmx+awHbg9PjS6ca3mmdu6OexK/QnuLYdoHtYBuK8URLz4bV23RV/Ft2fsS7z4mPe1mLFpXiBERjaisKhOXhk4tjPmpQ6EYpEJdRfA7pYgAPSOn7XfmCb+6wErW2m1ekaO52knr69UtqdXh4q3w3iPlBfi2omrYt6nqqKH7jh2ONwLGYv2mSh/0+SsDqWI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(451199021)(5660300002)(8936002)(8676002)(2616005)(83380400001)(2906002)(186003)(36756003)(38350700002)(38100700002)(86362001)(44832011)(26005)(55236004)(6506007)(1076003)(110136005)(54906003)(316002)(6512007)(6666004)(66476007)(478600001)(66556008)(4326008)(66946007)(6486002)(52116002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4OCcK5jbAeO6GPZC01bFmWwgFX+AdpmdWWa7eOUfqzHTI63ToCV8FraVTSwg?=
 =?us-ascii?Q?uO9DfARkq339HCyVu48Lq/7LWjUpk+BKyALXxnXayxp1wh52UOM6Su+BmOpW?=
 =?us-ascii?Q?Hpt3ya7n/3xsX1Hoc0+2XTLOtwejCYMvx+vt/ERGsOH80u+GVpeW+cIzYbTR?=
 =?us-ascii?Q?ebIjOkf1odaXRC0tdKEeNT/ad5E/MG9gDWUnx6zT20zZ7IPfGR0gqWuGVOIm?=
 =?us-ascii?Q?t4lsf/ytvP9YdruocF9k5L5290lVy7NsPbtzA3KquVwzyJvwf+aKNHsjBkN8?=
 =?us-ascii?Q?EAE2I5jbQrNpHqvXN3p+ESD64X+79JVFCbfEyh93PhPPuMpQjq39q4fmsa/6?=
 =?us-ascii?Q?16j8WSV7vC4RNEOPDq7oDaKyPPiXF9MYxw/IJ18M/8tjGyVwqjPXAWw2EqDF?=
 =?us-ascii?Q?UuqkX14Fswj5VQATRD0bSaCyzv1sFIPZ0F4GFFoN59cxRAHXAgemoqq+noKg?=
 =?us-ascii?Q?kDrl2KPLZTO5m/4WTqm0+reHYuIwkN/5K2enIdaz8XvrQBDyyrwtokIyuDgi?=
 =?us-ascii?Q?4/l8GTJqCsKKRL+sKDD5n4vvJCDh5QrfyV+wwZDLuG29PoaSFnj7Sj6bp7h/?=
 =?us-ascii?Q?VGZ/BK+3D/r+hI/ENjmIxwQynti2db1gA2MVBpe+Q+OnJgeU/vJZMMxpfpZi?=
 =?us-ascii?Q?ZG40D8etvlEZlxjVUJDN6Lq69cvQf9NG2grYLuOE9Tjn6XsF4WWHfTh0vhqW?=
 =?us-ascii?Q?13vfv9a3TDrwmBr/8RrqNj+j1K4ylTDS1LQBz9PstxcU2osOUi5UO0YXNo7T?=
 =?us-ascii?Q?DxSepdHEJgTKoSnzfrrjUE/k/kZ143fD+lVJykDUmv/hUc38U1kL9pOu6msw?=
 =?us-ascii?Q?n716mUR9NJAHkGbm7fHnIHVCNgB+ar9AYk3EAuiWekxBGRbTSksNa42EpXha?=
 =?us-ascii?Q?ueW8LnyYTO+dmd+6ZMl2f9gGQK8B5XaSVnuN2DMUAPGpaVwZRJ4Lo+4+6nOa?=
 =?us-ascii?Q?+ALRTh+qhfxgSqU3LHqDn7l78PB+lO9d0NFho7sh21gQB/IFL1G+qRfIvSFg?=
 =?us-ascii?Q?yPxLhsd2HdiqV0kPA/kMHUimkwkcXFNg5r/fKuQ1f8WrG71P6L2Ge0FVgQT+?=
 =?us-ascii?Q?gYwalwYEDo+BIbXdbKHsAZtpjOIxdkLZt0ThqWv1nqAGB3cHZoZScPaOZ110?=
 =?us-ascii?Q?AzA8UEAnv+fGtldPJeKQYmsfoJtD2JYU6hl/qFbqR5FOnaUPAPH9teHHIONy?=
 =?us-ascii?Q?wi0cjnSJk+jXiUz9g78XRDmxXivl/B08DpTz8hS2f5d/raRPVGhrEp9Msaj8?=
 =?us-ascii?Q?e+NWA3HyQwP4ekGF/SepW4dLeyy4P2F4+vf0MSPnBTVaj5nsnQE8iMVVAkPr?=
 =?us-ascii?Q?1LCAoS0cISDiqq/nnb4gWQ/AjUL7BlpaDcFEmiRxsPbPGXAluFyGnR7FRmjl?=
 =?us-ascii?Q?3egr6LcG9M1VPoQ8tu4tD4/Iec//DAPhvwnXX4UlvOOTDe8MBcmdMGTwVYq8?=
 =?us-ascii?Q?n/P8vZkeUJjhE/TodwgEvRn3ZJJNYoslpJMSNbAvTNij1x5ARzzMCW1vFECW?=
 =?us-ascii?Q?FRQ9Chhp79TV4YCne1Mp+Tw+G3ZDuaJfJd2TIKaRf2ewxdQZND4MwEn4pBiT?=
 =?us-ascii?Q?SbHAjK3xQ0xkjzDqdnylvefxvEKapG0BlpAgcIea?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17d52490-fc43-4f60-0dbf-08db57b0de55
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 15:02:16.2164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mE31FLdrkuoJHa3eHKcOG/yupc0SRceQN/xoI8yq2K+AzFumimlfxbPM47Ube7okAc47B+iS72N/s1iPjnwI4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9579
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Two dma_wmb() are added in the XDP TX path to ensure proper ordering of
descriptor and buffer updates:
1. A dma_wmb() is added after updating the last BD to make sure
   the updates to rest of the descriptor are visible before
   transferring ownership to FEC.
2. A dma_wmb() is also added after updating the bdp to ensure these
   updates are visible before updating txq->bd.cur.
3. Start the xmit of the frame immediately right after configuring the
   tx descriptor.

Fixes: 6d6b39f180b8 ("net: fec: add initial XDP support")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 v3:
  - use the lightweight memory barrier dma_wmb.

 v2:
  - update the inline comments for 2nd wmb per Wei Fang's review.

 drivers/net/ethernet/freescale/fec_main.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 6d0b46c76924..a5096c3cac01 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3834,6 +3834,11 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	index = fec_enet_get_bd_index(last_bdp, &txq->bd);
 	txq->tx_skbuff[index] = NULL;

+	/* Make sure the updates to rest of the descriptor are performed before
+	 * transferring ownership.
+	 */
+	dma_wmb();
+
 	/* Send it on its way.  Tell FEC it's ready, interrupt when done,
 	 * it's the last BD of the frame, and to put the CRC on the end.
 	 */
@@ -3843,8 +3848,14 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	/* If this was the last BD in the ring, start at the beginning again. */
 	bdp = fec_enet_get_nextdesc(last_bdp, &txq->bd);

+	/* Make sure the update to bdp are performed before txq->bd.cur. */
+	dma_wmb();
+
 	txq->bd.cur = bdp;

+	/* Trigger transmission start */
+	writel(0, txq->bd.reg_desc_active);
+
 	return 0;
 }

@@ -3873,12 +3884,6 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
 		sent_frames++;
 	}

-	/* Make sure the update to bdp and tx_skbuff are performed. */
-	wmb();
-
-	/* Trigger transmission start */
-	writel(0, txq->bd.reg_desc_active);
-
 	__netif_tx_unlock(nq);

 	return sent_frames;
--
2.34.1


