Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5993F5B6112
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiILSfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbiILSdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:33:54 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0611.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::611])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1DF42AD4
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:30:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OpuihbT1wePo5Bwf3vQODTmF5kiKUDMjmEgZx5bOZ3lC+anJ39lrL2w62UiQM+u2TFPaITLJ0r+OTTjm49ztdsOaw2Yut/Bls7f81G3qj7QmxgB7lniCCZybo32PChtQ+mtlUt3tFxwZakN1haGIr2wrHM2ixAS2x7vYAJhncIPwUyhE3V2GHWhiB3+Kf3ngOejnu7rh8Y1YA8KmYI2SqiDGpcVuluW4qRV8lSC+YIXLvjt9N+hOvzNbwkQJMmEC8ZuoKAZ6JX5XFMqMOGIlBESiRboVUNr0MkyyBht9RVtSiMtwMkBOo66oRZQ6I9ykKlE1eOTPpmnccdGcvZmW3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LlQsaPy+JqbPGd8lMEIb1Nd5K2mMKunKdG+KaqWEBZ4=;
 b=M+9YE46LV62OxnVQiO/NG9gODkuUQYliHJjn6i88bR4UPGzUYzFpYwK0AuHC/cv/oHXcHqR7dhIdCzGD8f5C1rDOG/SYh/Rcvh9sUo9zVJyT34hQj3L+TXQTuqJbVKuEwN9L9vuAb0L7Ic3TX1jIDjJJaMLYO0WfaNVXAgATMv87LxUSxiP1xdFpBH2ScRJqss/bKcXF7kXlsfNFCG9tfLUIvmleUZRx5WfuecpRy12sqr1aCUWdOfe9SnInM3rq5QDRWppUoFIN47+r+/Pzq2yP74DIwi8/KIjuncntj40ueDpGMepzI3NTKYRmB2DF78C0f0PaUMATKgSfMKUwKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlQsaPy+JqbPGd8lMEIb1Nd5K2mMKunKdG+KaqWEBZ4=;
 b=OeiT8Dyrd0UwBjZFgJu7VPYRASpEc5hB2nsTMxT5f3oxEZBBG3Ff62rmbQ0p+ZMa4Ae9brkfCpkuwmwxcIxZ966OccWbpE/ocKeR77u1TPPS5WCD2kl6jofUCxKYEWkwGOlHh5xHHou9/Wq+wE+BMeB9WqtJe2iRr02kmUtRBu8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8023.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 18:28:52 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 18:28:52 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 01/12] net: dpaa2-eth: add support to query the number of queues through ethtool
Date:   Mon, 12 Sep 2022 21:28:18 +0300
Message-Id: <20220912182829.160715-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220912182829.160715-1-ioana.ciornei@nxp.com>
References: <20220912182829.160715-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::16) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8023:EE_
X-MS-Office365-Filtering-Correlation-Id: 5be6fb65-4013-4bc8-cf3a-08da94eca4a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xavm/3FfRbBC57PcO3hR0V8bI/7oYpXcXNOd1eHSqGP1j1RLaDZXTpz8G1KGGHjilVieCnZAujkwlp1iHUYRqH8n4Sv2x4RsIikVpKxdYEZF9CEjthftAER4gx6dwPdZEjNlKYEZtbrkuxiQK+MkXZ+cu5BpTS7oF8Kz4Wl72FYPWow7tqz6xZZGyDavJGJNOQsVAplhNyt4DeM9m9dyD4afF4zpbDNsPmR45twp5F24KwFlk7zFS5PQb5R0mfXqj3pxMdr8uG7stJw2o6LCjHKEno0WzbXZmdJ2oLi/qsa/IzSWGqOz0x+3QlqGLVJPuYFwZqRlvCWmJzPu6LUPr4UA+ONzsoRufOHR5ny1wl96ZKakUaQ6n9XE2L1GC7kGxpN8JgZvfaKCO/q7cKhDxN5RtOqCyjoT2fi8g9fAlMH6VyUhtmpT2N8wowGbIbLGT9Rg210J045a+TtQB0cEuJNbKVDM/SbhinTEPFr8r95oRIf8w6DbTYFT+x92OwSrppyVEy+EovUie2iOknkLtAb6hOAYsViID9JVsESeZQMykWKIzFUtjDLYu5tDOM3Rh8EmRY/4hRIkarPP/bkWGL/y1a5cYYQ86+DLyVu702Ll80ePcbzWGNqSFGAUDopEM6T267qa4XgOHMGqER2hbrlfYmKWvxCI7mqAQ42paqRD7A+g3FVi/5Ay1FQhcA2pD118KI51vCmZRzvMej+S+EE0d6hvvXTCf8HOa04+aS7VvV6uRK4vWdPagu06kSCpjqJ2OVLWXzkQyx2SoTYDkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(4326008)(5660300002)(8936002)(2616005)(6486002)(1076003)(2906002)(8676002)(6666004)(316002)(36756003)(41300700001)(86362001)(38350700002)(38100700002)(66476007)(44832011)(6506007)(6512007)(66556008)(186003)(66946007)(52116002)(478600001)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7kKNv02rAhlsty2eg4SCmA4VeOu1mCX06uMsqnISiFZkLvaS0HklqcUMUUJp?=
 =?us-ascii?Q?NdftYvebYVN3LdR1vpIfH7ixlmyafCeKMEUBM7WYI4n4Kz5ATypPQ1pRR+HD?=
 =?us-ascii?Q?wDoHpsQ95budjRWrX0s8v4hPtNIuJPzkQIuH9LV+Az/mYLF7o1O032Ijync1?=
 =?us-ascii?Q?oXGrTDZSxSUJEi3SEMv2xVv8zy13H38AHMHGyqLtL6ctUXrPx0rp/OuhVUkj?=
 =?us-ascii?Q?XF6rFXY9Lgf8G/gaV1ZDzjNKlUfA1I0qdhIta1f7XOJ3aGylfqIbz2DdCqsC?=
 =?us-ascii?Q?rDMPd3zXBkIvgK0fGAQ57SDUCBZiWxSxDwk7EwRBhSSXP76zY4F6D8d2KygO?=
 =?us-ascii?Q?FY40SFS5OFnxgthIDHbnwOj0Zlmwsq5tkZZuxlKDaoyCMDtQWO0WyETZHWym?=
 =?us-ascii?Q?KqsjNBHLvu6kTl2/YGDa6PKCcuA67XB03Weyt3bGuSLyXkw/2hyjzNBpR5FA?=
 =?us-ascii?Q?DWk7VHKC/IN1WK0xsBOO6cVvJOhiy5MigNGq6EoJS5JhDOz6lAk/QlJgq1rw?=
 =?us-ascii?Q?0p9BN2Cg2ULzMKX74gZOCwreQtcL6wrX3ZKOqrTX8jBbZyPuOr/3Y7b4NGKN?=
 =?us-ascii?Q?qbnzWuLagrou2EmxdUEF5lpjjjj3Cxe+pNfq4fbv1tFQ+aOXwz8D4iAZ/nJ+?=
 =?us-ascii?Q?Ih8f0X7K6uEYErhsxLupczzs5wbUUrt8KFFNsMduq7q1hzWbrrGQFmFoFWDQ?=
 =?us-ascii?Q?EnYHl468rDdUoy8qQgrEPseKP64Qx4ZTGCai9fMi/oOXm2GXB6sdyRUtKhfX?=
 =?us-ascii?Q?iR4k5qyf8ZEOsx9fx5BFS0LFamISq2RKytuz8+Jc1LjvEWN1GAHTYabzvU7D?=
 =?us-ascii?Q?Cur28KGHW6zyK9eaAomxuX/aMvxfcccJbHTKblpR5tnc9humpaQkNSU6otMs?=
 =?us-ascii?Q?I/CLznnkTY/qijSp4jlBF66IiCUE0xHEzj8rgUm4k0LQrVYvd7O1Z43ROBc8?=
 =?us-ascii?Q?oIXLQs5/rHeZ948588n/HgW1EVzkMYRkWRUiY/w+NFgz/hcMZ5UlNjru4oy+?=
 =?us-ascii?Q?FBXVEHR8cpJMnzKXGYeg9+YFl0CIMwNVEwJFrYWgcrHHi36engX7gapHPlsu?=
 =?us-ascii?Q?vpEPW6QzV3Ia0hBTna3jVDUW6gTitC2JR0Sz4kwCRUImV45inGgKC9p0xRjo?=
 =?us-ascii?Q?kHmEbNeCkW/D7t/DRAauLcFZRIrB15J8Iwn1qU13B4bhPqcuUeyhKThgt2sS?=
 =?us-ascii?Q?prpx+VuNQFoMjH9W+5qoBxWbFfP7SwCm2ALc8pCu+J43Wtz76kk+W/Lrlwy5?=
 =?us-ascii?Q?CM+EtBHxrCyA3tguK6OVnB4I6USUeePAEJPtE0XFCG8plrSbgi6jamAo5HeH?=
 =?us-ascii?Q?5fgNOzC+b28mBuw+pYv54i/FdS4mHtDNsaL2aTPk3kc8zHXvJrwJNU296Rs7?=
 =?us-ascii?Q?2Sa/+IRPa7jxzs/W2r6yCXGkL/OZdTpsbbbFG0WX5yWVsN7XFdtgaf0pxCkc?=
 =?us-ascii?Q?D4eGjsNwoDmta32y+rBl78944wnpb+ZzIvFlhAHzIdkaAd2A0nvRLe3Opgdw?=
 =?us-ascii?Q?LtXOtgr82Fl/AOUARMkDfOb/hVLck8M6cMKwhmnl4hvdF5j5lfIOhaMZUMfj?=
 =?us-ascii?Q?kvY2Eb20X2Ii2DWoCOrMu+WyTF8att4uRaHAgaLN?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5be6fb65-4013-4bc8-cf3a-08da94eca4a9
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 18:28:52.5736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5OIvyZnFiF9STd0d5fXZjFIP+tjoEamzZlJBTIgkJjJiECXC3LUMDQFy8AxVR9H2CTCsMuaD13N++4LfZvKN5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8023
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

The .get_channels() ethtool_ops callback is implemented and exports the
number of queues: Rx, Tx, Tx conf and Rx err.
The last two ones, Tx confirmation and Rx err, are counted as 'others'.

The .set_channels() callback is not implemented since the DPAA2
software/firmware architecture does not allow the dynamic
reconfiguration of the number of queues.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  | 27 +++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index eea7d7a07c00..97ec2adf5dc5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2014-2016 Freescale Semiconductor Inc.
- * Copyright 2016 NXP
- * Copyright 2020 NXP
+ * Copyright 2016-2022 NXP
  */
 
 #include <linux/net_tstamp.h>
@@ -876,6 +875,29 @@ static int dpaa2_eth_set_coalesce(struct net_device *dev,
 	return err;
 }
 
+static void dpaa2_eth_get_channels(struct net_device *net_dev,
+				   struct ethtool_channels *channels)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	int queue_count = dpaa2_eth_queue_count(priv);
+
+	channels->max_rx = queue_count;
+	channels->max_tx = queue_count;
+	channels->rx_count = queue_count;
+	channels->tx_count = queue_count;
+
+	/* Tx confirmation and Rx error */
+	channels->max_other = queue_count + 1;
+	channels->max_combined = channels->max_rx +
+				 channels->max_tx +
+				 channels->max_other;
+	/* Tx conf and Rx err */
+	channels->other_count = queue_count + 1;
+	channels->combined_count = channels->rx_count +
+				   channels->tx_count +
+				   channels->other_count;
+}
+
 const struct ethtool_ops dpaa2_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
@@ -896,4 +918,5 @@ const struct ethtool_ops dpaa2_ethtool_ops = {
 	.set_tunable = dpaa2_eth_set_tunable,
 	.get_coalesce = dpaa2_eth_get_coalesce,
 	.set_coalesce = dpaa2_eth_set_coalesce,
+	.get_channels = dpaa2_eth_get_channels,
 };
-- 
2.33.1

