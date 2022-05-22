Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3969E53032D
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 14:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345440AbiEVMxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 08:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345407AbiEVMxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 08:53:21 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60072.outbound.protection.outlook.com [40.107.6.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05F0248EC
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 05:53:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T9qqFKNSjzMX2mslYMzPWhW3wIfAr5yObU/jyGum2g6tS05nXPpzCJL4LWk1ySNfFanMfnlO9BK33wKkjRFQY5x7srQNQlQas8gABt49w/uUAsqa69LChiERJIHzBYSz9Rh1j+ObBkaC3TDmTNXh/my2CNRtw/C9Yzs7rKczwybXiU846jWDAQ9n/6zyJCxkBNFxFuJVJ+zWwPEwdT3wjT73MsTeAlm3aT5mbc+b5Va+RVetxkgpQ4BRwnJrOXIaW2GkeO3WmHFXu+7m3yd8k1iPRA6gsgaUl1qzRbk9BCbnP+9ayqnnU5+sc3fVFVuQ+6QDvmmWSBLU/BqX+RZ2HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejblSvaw5L7bP9z3b6YJIZ+yvbCijbT+rusXU3NcDws=;
 b=aj0r5+K/kLsBBAbShcn9dTn2it+6L8InuBkw0HUG+yijHMbHgpSj9KuBNboMAvXMGZm24O8F/sKnvJBqi1pA4wZCMt53wRizCYv3GiSdy1poDB6ehV4V+IqRe08aiik9EQEMU70+SD2YWBPPR5Icawrq9jEsRka2fgDiVyv7xyIxGtgVvcr8EeVKqupBn13yHHMHc4C9+X+F9oY9k2I4Fhp4rS2tgeZ1phjvs3zZPEvNQDK2EPzzFDyxUm02F1yryk194qcP13ZjIomrUMnEWCwHSJke5sUWBv/H3/yi7j6UidTaKKulviDLQc3ZAh9hmVrT62CFgvS3t0uPhdjlwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejblSvaw5L7bP9z3b6YJIZ+yvbCijbT+rusXU3NcDws=;
 b=PQ1QZ4IBxrecZLpeqqI3ANYkVnxjlSKrdeSbhjlCzfrU1ILntRPrz2K4pi7cR7NZGuq53cbNh5/MoK8bXpyARfiL2aRMzIiBvvE2nAzyx2c4ZAKvM++sfoLTcOtTEB+7zkUZfrZqkIMIzAMmcDcPXKSWB+fY9hzn7ig3Ly/IAy4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AM0PR04MB4385.eurprd04.prod.outlook.com (2603:10a6:208:74::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Sun, 22 May
 2022 12:53:15 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd%5]) with mapi id 15.20.5186.021; Sun, 22 May 2022
 12:53:15 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net 3/3] dpaa2-eth: unmap the SGT buffer before accessing its contents
Date:   Sun, 22 May 2022 15:52:51 +0300
Message-Id: <20220522125251.444477-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220522125251.444477-1-ioana.ciornei@nxp.com>
References: <20220522125251.444477-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0008.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::21) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 242b1aa0-dad6-4dd2-64fa-08da3bf2095f
X-MS-TrafficTypeDiagnostic: AM0PR04MB4385:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB438585DCC74AFF72997E74DCE0D59@AM0PR04MB4385.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H3uznQQOlD2rKJfLnYqI1XKVZkdnPmpf1PHF6k0NixLBZiSi7DhB/IKn7EAscqqq2l0VZjDLL2U3jSr7lO8UMBzAIu8ctMF3GMWEWpvX56NiRi/StVr8kVlAYHPlbp9NUVBwfmuXom8DR/D5lPgdwIj88k5nqduJyWJ1pkjm/pLbkWZFMU102u7VAjmpeFcTWP0HMZj0hCoLD/Plu9Mq33JAEWw3NrIk78SZHTNSVRCGj6vixC59jdWsA3iUe2o5T7NOo6vp7ya4VcdvHgbFEQJQsVlvTPrPBKMClu9NC7wJGCgwxyngTdFWIOD4IgL1z6egjAUpoH3G+/mAa48AHKR3NxY5HQtAZbNVxy0ZyNBp4Cm+EA2TV85ej06dicvTKIsPooyorvkWQnw0yojq5AYDU35utc9AATIYd9Z48eegYUIqS4xdwxV43eWpfW8+oVXX8LxTvmiYg4pskPkwCahztqQM836Rb0FOzAiTuqdc2kOFYo/cm3rGX9dW8ecLwYa6VqzOuBvLEgolOAwOc0ugAhLpt/HseNLkCSq7lhn1iqXtnm5Cdlvgy6OD5Ef/XULiQUkCs9GgLitbqiJZEBg47qnJrj9O/By5JWTpHzt0qCXSJwvroE2V/K2hEZe/7f4q4IJu127MRC3Fguok1T4BIeBYcze3aURlmfEFNgqg3zWtAwObd5dxmfgPCpeAvLORMGF17biqc+AhCq6tZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(44832011)(186003)(5660300002)(4326008)(2616005)(1076003)(38350700002)(38100700002)(83380400001)(2906002)(6506007)(6512007)(26005)(52116002)(36756003)(6666004)(6486002)(8936002)(316002)(8676002)(508600001)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aLslLcr0vQL9Gu3VINMDfHjyNaGnvSEDcmPbJG9yDf/8nAMi7xI1qyIKLPBC?=
 =?us-ascii?Q?9877GbPpPE4M+qd5Owb2syk8IS2sP0EOmTIwD2KcuX8HIFiFmHBRq+7JYOZA?=
 =?us-ascii?Q?b5XZtTYbJ2OB0H1wmWLnLMBSbiemorJLOlgW6fcKbs66T3SMhAl18if/miqZ?=
 =?us-ascii?Q?x6nFvStkPPNk4rocawae8Tw4nz3yREsdt+5vqfS9tkOaP8X/btStds2ihkzy?=
 =?us-ascii?Q?qqhCidsHp2iwA3Mo537xX80sGr//ke7XxNz3/1EVfzmzXMaEiE/DzznO3K1t?=
 =?us-ascii?Q?/Ij3ES5wsbpSOQ/uula3vMeB+5Qi1YT0YjwCfnXn+wJ632yIjsB5/Bwn8OGe?=
 =?us-ascii?Q?pt6Qp0m0D6eEin2EmiFb7RHkx24KLKL9wy1n17s/gY/YWPRngiE5QlKRKJHo?=
 =?us-ascii?Q?7lM0f0vQi9JyH/wQOWHRbBLrUnqyAQzRHtdxF0d4JKRP/7j934ON0kgCFm99?=
 =?us-ascii?Q?EO9f8xaWA3GAtfV4ZiN1ohazTGEBV+BFkl/y8MAuehKM93+pLYrJkXU7JCim?=
 =?us-ascii?Q?uy5zDe11p81DFPJiFYpOD07eiA69jgGY2uqG/V60hGlsGgC8DIxKOIsL3lFy?=
 =?us-ascii?Q?x7/3R7Jq8i3gIl2wsUcOOpBhNz6X2M43p2ZvHj3x3RAU7M6mhnOXt7SGWYPQ?=
 =?us-ascii?Q?wiqIKMQei/IsB3Mz0RrfXvxv20OQ90fD5Z/x4NJySowgvVBRdWdciZQ3noXG?=
 =?us-ascii?Q?BUt64EdOTU26VmSt783VUGztDfLHV8ZnBvLuL+indP2+If1/2j1qXrzX0Jb9?=
 =?us-ascii?Q?pfy4OqcYEwqOF/V1M5dHwTAo8VkSJeQrUC/EVZDPS4T/+7rLlju5n2hYOt3X?=
 =?us-ascii?Q?iACe1meFmhZ9yx0ZzdHOgv4fd1UCyKkzFUwguMMgvy+z0jYd6qwVu4MzqUNP?=
 =?us-ascii?Q?1VBHKWoixi55X9ByVxcZWTtpaew8z4YmIKuPkdqxhjcy1XYrPBYN23Kv0prE?=
 =?us-ascii?Q?WdDW9T1iIbuSaC6eLP1MRlNDoLwIUdKQb4X24BMBjwY65uWGzNgLYoFugc8Q?=
 =?us-ascii?Q?lYnIVpJvOLgyASSeBPrdHiQRpGKQ41EXBw9kcirTD4PIVm1jfDH4w1c7PUW/?=
 =?us-ascii?Q?MKv7uon26LqStux/RngtyfiKboGgOxFVpwawMSf0b/K2Rp32fM/xrKOEzvER?=
 =?us-ascii?Q?jjHs4vZKLgcGXQf8jUbKecjNZ/l2gm7Ky4uQEHhnjYfGOdvKPUq60z9eQWrZ?=
 =?us-ascii?Q?nlFB6VOF+kDSs/qJnCgwLjr/hnVBzq34D0jsrUNdsI+FEWlO8SqlRg6yE5nl?=
 =?us-ascii?Q?WVZ6up50MZx+cSvvHJPHYVvMtS+EDvVM+JkQUTCwVfUfQHG7zsD+QdHKUHBW?=
 =?us-ascii?Q?cBq9dQ7+fTtlgoQ+ZiTgfQ+p+Zpk0P2Kz+L5eO2REEzJ2+i+5qANLhis1pN7?=
 =?us-ascii?Q?VN2AizpaNqvuMnB5LnT6JkK11AryC8Qx0QQeUWUwXvwKvsVVmuBCdtmZgXiM?=
 =?us-ascii?Q?jtpFgHuSuuWTsQ/ObtOR+YF6i5dw4V5htx8DW4aG5KsN2leQmCXKctKU8Nmy?=
 =?us-ascii?Q?kl4I37AxbB1EGLWnHoIsbUy5MqDJHG7URB8xRffzXf9VPrCyAMtiVsqeR/m1?=
 =?us-ascii?Q?fPRNt+CvubzQfJ/OZamCTRMTynhfWgdDqDZqFXhdnYVPJ7jtj8LWw2E3Uo6x?=
 =?us-ascii?Q?Sn/XR/2H5bRqv3WiDxadnjew6dVDJjbqccXtLSKKrqGcOws6dpmBcn48xlgS?=
 =?us-ascii?Q?4PvEyN2JYmSWadl0cR4ad3lInaQ8b2WmKngU4Vk3+nhE9wBzBtULDvPHe5cP?=
 =?us-ascii?Q?UsirtIlVfGlFHGgq0nRD4hjYTStSMV8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 242b1aa0-dad6-4dd2-64fa-08da3bf2095f
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2022 12:53:15.3435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3Ntw7O0O7A5eE+QCoViVuafzvovyVQmxc5fR8Bel9cK51Ir6YdPRDNEnCuc+3okY9poUffancRM5JmHk3HV/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4385
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DMA unmap the Scatter/Gather table before going through the array to
unmap and free each of the header and data chunks. This is so we do not
touch the data between the dma_map and dma_unmap calls.

Fixes: 3dc709e0cd47 ("dpaa2-eth: add support for software TSO")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index f1f140277184..cd9ec80522e7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1136,6 +1136,10 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 			sgt = (struct dpaa2_sg_entry *)(buffer_start +
 							priv->tx_data_offset);
 
+			/* Unmap the SGT buffer */
+			dma_unmap_single(dev, fd_addr, swa->tso.sgt_size,
+					 DMA_BIDIRECTIONAL);
+
 			/* Unmap and free the header */
 			tso_hdr = dpaa2_iova_to_virt(priv->iommu_domain, dpaa2_sg_get_addr(sgt));
 			dma_unmap_single(dev, dpaa2_sg_get_addr(sgt), TSO_HEADER_SIZE,
@@ -1147,10 +1151,6 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 				dma_unmap_single(dev, dpaa2_sg_get_addr(&sgt[i]),
 						 dpaa2_sg_get_len(&sgt[i]), DMA_TO_DEVICE);
 
-			/* Unmap the SGT buffer */
-			dma_unmap_single(dev, fd_addr, swa->tso.sgt_size,
-					 DMA_BIDIRECTIONAL);
-
 			if (!swa->tso.is_last_fd)
 				should_free_skb = 0;
 		} else {
-- 
2.33.1

