Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838A867DAA0
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjA0ATD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbjA0ASe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:18:34 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2067.outbound.protection.outlook.com [40.107.21.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E0A53549
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:17:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHdTTM8lwrI/8jV+xWCGMm8ZwL6tYaAKguMqijQbXcSIxd4aUdSBs7Xgn5tnC0v3L/Qdo3qQHK8XUEPpbRoXSUh0Rvsz2fmWz3ZYZedsIhA7XMc/L0Av7eBKqQFFZ3nZTKQ5bZoQ+GZ0LRDWMWEoUNTYvlAv5+bML9dnnoArYpjYOXGw7XM72LDHbv/AemrIUobL9BrwrjRh26nsCrsXt2n8k9EAcRHIVPVeJwuWgSivu8rF4r+Nbn+EXapiiaOEvGp3B+TTMDfdZALBEPfTyr9wALc8Sy5KNg/pfvo7xMI2vqHQU76Rp3glVcTBnxKTzMeuOwIntbRUFBFKl5SrDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7cjaZ0QaulU4AXNDPB/I60hoNmNLmo9hipJlRv0I90=;
 b=azwaYSPY8lgW/lgL9p7FmGwSQ+cIjQoLqBzLLYdll+XeYkLSYknuBidED2EXMCKF5uGfHqxwSTTlLHH2dU6mvj9SK/e+wtuFI0fZt1Fd6fccx6NWEJzBmMautx8tA+BMXvkB0CPOE+9DNmAosrl6+W5172P5rXBqW/lUbaaYCI9zCo/7hxM/KeGeseWp22jYFXsl0hcM0rm16k/JqpQx9ez8DFSsiSgxGJ6AAhmSrH9RfVtaasvHp71QPqfg1jKQiHQGoCoyv7EKCm+QkH9fIkHWUp/UJYEY8fHTcuWf+ESSC8zxAUDlq5U3Sa+dr+tDDMoAaQo4O8autp6LLDE4fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7cjaZ0QaulU4AXNDPB/I60hoNmNLmo9hipJlRv0I90=;
 b=nsvRyVhOZ0iXqNuU9+5yZJ9YCI0Xi9rL/Na3ci6el1qrSOK1ErJfuythGUjlQEn9L9ASA9R3g98vM82q8VGTd08M2KZU/pflG1BTUEUGj/YQL/pqd9fbdSnORcC5DCqV/OCf2wANrmAFBWReeg+Vkfj5umgsHUjdurzLg8wioOk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 00:16:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Fri, 27 Jan 2023
 00:16:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v3 net-next 13/15] net: enetc: act upon mqprio queue config in taprio offload
Date:   Fri, 27 Jan 2023 02:15:14 +0200
Message-Id: <20230127001516.592984-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127001516.592984-1-vladimir.oltean@nxp.com>
References: <20230127001516.592984-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f280516-31d9-41e0-a9a4-08dafffbb16d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FV/cZ2qK7ncVf6RgNL5GWaIMSJmAcgQkZ5HdG6nsUSL2txoAqyQfnJMOm3HT9lk7GcuOq5lSjEUcEBJnakrliSntQlBVThBd15g4UEoARzyUPThzva7oLdfn8xr5OIK4Vo5nerrZkVKFqfSOuGKMbOfWdanxcvCy+KHhUeekBB4wtnZj4sO4LhbLvv+AWrtyL6lEOkgE8uGVz5VcAndvMZOVnIcZBdtO33wpUlow3MA6tbHzzF16GudkRIN+XJplTxb4sbrdcdvdnv3tW/6Zh7gHfUPC8xdupcOMSwsNthE2HiWRRqmbCJgeOzQVKMw7berYn/BWj1mLLk1kB02DjyNsx7im5SWVPZHDB6/mlclhYZf1TiiB0t0AdeRih4Wa37Z93YiGUpT9LPf2kqU/V4EiBQBR5Jlp7vBHtNPsbIZczgkYLgKcrYp4BejkJ+DQX1eZUrd9PF3az3B6pw5eNW4lVeAtf1w4IzOuXiLM/Bcw9U/stTzphUJSHHULYbn19dHk8gnnYxxoRYKT0+BdD2+Opgku3Bsq49G76NmV5qlfP1S3Vq5n2224NWf1ifxp6WaN8ZXfjEYW7aeDt2vQ7EcEBiP2oCDR7xmrYMs8/9JaHUpO4p77H45e/GRL83cjE6jyrhkKliGltNPUGw18Wwrs5bWumFZoaP8NTSFocxxxlRjUukfAuUOA3M1j/KLN7BVXN0d1s1o0orDqdjBc/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(7416002)(44832011)(2906002)(36756003)(83380400001)(52116002)(6506007)(38100700002)(26005)(6512007)(186003)(478600001)(6486002)(2616005)(1076003)(86362001)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(6916009)(41300700001)(54906003)(316002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qIdfPHoJmLRoZZR+GLmnZphGlwxANbyAF6u6k+vvmoqe/rJFAE3hAsVMnRdw?=
 =?us-ascii?Q?xQ0cfl4vYpV/tLVuWrDxxnRSJcRYi5nukbebpBmnEwqBG2Bp6iHiUX2wAIvE?=
 =?us-ascii?Q?LDVgA8c4t/ebdEsxRwABTtD9s+Af6goiykn1EoVyoouv5hjWAMH0fa7Mjg2B?=
 =?us-ascii?Q?XQgOQBT/0bqjkG9DebljTr8cTfJVzrzD+zqp07aZ/yqh6lU6RfHpZ/NPoL3p?=
 =?us-ascii?Q?aexx84C3y/yqBaFkZwPGeYyQuuZRmCwBmWuO4hJd7Gc8yCLQwVWKm71aNMeN?=
 =?us-ascii?Q?E/OMk+AiBFrAzHTbTCYEF1rA0Tu1qe4bgSgz4/4SsOAcBJ8FUQrL8mXVyKMR?=
 =?us-ascii?Q?PeXNCa/HkSCPzM/KyFTevqEq2bwEU7S/W2rJfYsarnX1alP03BCPAIRie5Zf?=
 =?us-ascii?Q?fmKTkRqGrQ6RpAVYaMfr30KookA1qs2P3zKqPIGoIli71pgmDVOE1/qhj+Ra?=
 =?us-ascii?Q?JpK5RMEF7CLl0TkVeFSUOiXj57RqHo7+uhk/t0H+1+OhF/2DNQgVdz2xwI58?=
 =?us-ascii?Q?u7R80rXExcx37dSXmfuiLxhVgde5TSb3sa+FYSJ8WTFjZTSLvvv2v6Nszond?=
 =?us-ascii?Q?cLE/iE2X6E5+M6MjcdC1lRF2rn3QN3PTyVAJ3ZUCuIBIEfWbUxM38Kx6TlL7?=
 =?us-ascii?Q?hN+X18l77hr+LJdEcNqsuhhC5hOAFeOtVKB8JS/TcG9Wydb0zosa12VVsWE0?=
 =?us-ascii?Q?ZMFVRXo86snCKFO2xsO45PXMn+d4fXquCUDk4U8Qo5isq1OgbtU67wmnoK57?=
 =?us-ascii?Q?B6i8dZagxMieMop4j7Yh/5NUYwRK255Cepwf+BUPstv+kDqUixPRHZinkLXM?=
 =?us-ascii?Q?IDh2CsJRM2V83LKCtJ5D2aD54Kuqe2l27YY9Yo6dDZEpxq2yX0aDSnNujjDT?=
 =?us-ascii?Q?XeyjAVNfxH1kaJiXMk8xh1ba/bIgEbzaeRDnLl3YYBDgjP/WJYobmdDpfKwX?=
 =?us-ascii?Q?XTe2Vp8dh0mMfVk5OC+THpNtQkcbtHw8/1qt2DpaAwtpejZboLo1lTKTSduN?=
 =?us-ascii?Q?cQyMCpGwMHiSAht2clOOyiWyuO/FgvHeJlpzHvp7nzXOv7BQPK3h5te9B9TK?=
 =?us-ascii?Q?+Le4nc+KU7FBKiQDNHhspy1hU1mO5FXbxJf1iP/K0QXTaSZsM3wWqaVGv7/m?=
 =?us-ascii?Q?uE06xV12D5WxHno2eG4FWYzahDJJcS31ZJ+e9llSQLd5pY1iZcjP6E69A6Va?=
 =?us-ascii?Q?exxPEjEFLRSngCw6rJsSLOWO1fB1T7XLGhLcU2qFsfSlGEAV5LRoqUTC0Aq4?=
 =?us-ascii?Q?dZ6iKrQ0P50EMWP0r1BlzLnuNteZgb0x5wy+HIVjAq5kZVY17BLWU1E0QVoP?=
 =?us-ascii?Q?+GAwblLp08s/BM1zDXQoZuIAKC4tIegtfIv787dgiok9Z9ii5krZJvus/rfn?=
 =?us-ascii?Q?pTcps1UmAzI+qcqpTZE4Gtovt9QQE+5ye6e2dmpc2v4Fwi+FpoNN4duw4Ejt?=
 =?us-ascii?Q?6iR9YfzIHAVrA76ji+qFrhwjxlM9/h/6cBiUgqYPSoMI/bdSzk9Kd6akw0wm?=
 =?us-ascii?Q?+wd1oze3mE0cOHJgTvCb0dZ9VS8eVB7auoEH4hM8/2sYJzfk0pplCWmXXIYi?=
 =?us-ascii?Q?vL506kW2+5P+9G1euV0lA2NRWMpWUndi1hG3Pflhw+jDQJO+WMejEaqvs5Kl?=
 =?us-ascii?Q?xw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f280516-31d9-41e0-a9a4-08dafffbb16d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 00:16:10.6380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M5qV4S4cNtNgZ8108dIaxIpaKmUe+XCh7BAKrc3rYbB8px55h5oI0rG1I4qysXL12Da7NP4PkElw0BcLB3Xpag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We assume that the mqprio queue configuration from taprio has a simple
1:1 mapping between prio and traffic class, and one TX queue per TC.
That might not be the case. Actually parse and act upon the mqprio
config.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v1->v3: none

 .../net/ethernet/freescale/enetc/enetc_qos.c  | 20 ++++++-------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 6e0b4dd91509..130ebf6853e6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -136,29 +136,21 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 {
 	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct enetc_hw *hw = &priv->si->hw;
-	struct enetc_bdr *tx_ring;
-	int err;
-	int i;
+	int err, i;
 
 	/* TSD and Qbv are mutually exclusive in hardware */
 	for (i = 0; i < priv->num_tx_rings; i++)
 		if (priv->tx_ring[i]->tsd_enable)
 			return -EBUSY;
 
-	for (i = 0; i < priv->num_tx_rings; i++) {
-		tx_ring = priv->tx_ring[i];
-		tx_ring->prio = taprio->enable ? i : 0;
-		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
-	}
+	err = enetc_setup_tc_mqprio(ndev, &taprio->mqprio);
+	if (err)
+		return err;
 
 	err = enetc_setup_taprio(ndev, taprio);
 	if (err) {
-		for (i = 0; i < priv->num_tx_rings; i++) {
-			tx_ring = priv->tx_ring[i];
-			tx_ring->prio = taprio->enable ? 0 : i;
-			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
-		}
+		taprio->mqprio.qopt.num_tc = 0;
+		enetc_setup_tc_mqprio(ndev, &taprio->mqprio);
 	}
 
 	return err;
-- 
2.34.1

