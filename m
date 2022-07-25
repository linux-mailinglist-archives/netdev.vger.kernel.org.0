Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16361580151
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbiGYPNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235944AbiGYPLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:11:44 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130088.outbound.protection.outlook.com [40.107.13.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA23B19C35;
        Mon, 25 Jul 2022 08:11:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NwJEyK80Bu8mawWxQnrVR/XeUJ1wu9RmciNwJwLJTMsaTml0TvErcRESxgOLWH6VP35BNOWBfzTb4AdUIOKIMSgy9Y/rMyQQF/cbzDPRGMFKdM+JwLQMbPGTnIUZ3U4i0wKk5pBf+7kqgTSDqGbFkS7AVq/i0Wuc48MzmBG+tpPPbuAN6TxOiJ8Lm9tsDDFLdAEHm9m+a4sO2bCbWekuA/yBFCtjRqbBxsV9a+IOivDVcGr/c7dvfSP27g+xuBlfbgRtHzSkIpUGTmM7i1ofodHLTodSGQDIwwfJphWnjd14WvS6/0egb4Mk56cdNDDq6v5VooOS5LTOBKq6N93DnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hz6WDFv74EuM8OJ4B+HPhYA66UPtmHjCYXGt6fNkJn4=;
 b=JCxGP9iTDC8i1y0FeuuRY2IhLpyTiuXz1d1Rulh46xEUTlm6LWf41bjuJrU4YVxqI5yVJX+CoMJGvDUS4wy6goR+6bAVKRYWd1QlAOS3KnaZkXe0MEDPzJ8h2DLLMzaNtniBSHli9gSVGIlFA0ty7xwXnxG3HcAr23xYcDl62gKEDHs1MKbpU0cUuTgLtHs2byrTbsbrUSPZPFRFFUfBVG1+Bt7UnJ0YeuMnH5g4wlSDFWcofQ6oUEEGcSuARedZejWZlxriWFcOvQ3OBuK6R/uUmaX12ufMdWOhEVhPX7LtEcixIWscV35vgfxzFpRdA4UTJdjQw+1AsjllJr/OSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hz6WDFv74EuM8OJ4B+HPhYA66UPtmHjCYXGt6fNkJn4=;
 b=uvZIQ2wO3Fv/S1zfL6ZJrz1GBNBV8X4+H79x7ToF8Fuo6eOJO5F4N6j9gOEfeJVymYtoHZR9qnUCH8Y9DLdzoOAK8vAz7GUpvkFz0EOnzbdD22oHl81vvlqTPhqxNzpnDBj2HrkapePTmnuoHzukDrT9QDyC9qo5Rbb/gQR8Pe2C6qMGZ7NUSDq3jl9UbYi1EPSFAMSHQ6M66Xf7iogFVtqoLqJpqlMR1230uybwEu73AQYTpLsCyEwsUk9pJ+JFycW/nr608dBkCVZyiDLuGLdxu+sdijrgGWXpX+ZOp0Xeb35L75iKKnL78JB9ktD7nLSSgaaQM/+k/drjH+nGwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3723.eurprd03.prod.outlook.com (2603:10a6:5:6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Mon, 25 Jul 2022 15:11:22 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:22 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v4 13/25] net: fman: Mark mac methods static
Date:   Mon, 25 Jul 2022 11:10:27 -0400
Message-Id: <20220725151039.2581576-14-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: caa46b96-b26b-4cb2-4cb2-08da6e4fef17
X-MS-TrafficTypeDiagnostic: DB7PR03MB3723:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gpoxwzuFRpXJHnPJ7lwboQYArVmBC58i0VOc+td78qtIDaE6FKLwVuSqVboDufmn3MAfIxxj2EkKDI7VPBkDuiR7wBe9rQJagnDYeUcfwOr0Fn8FMgc0ZHHjj4JVOnYNZjtg25fpgzexZfFdAy/Afqm4a+5nuAVo2I5OUT7ZC98BTPCw+r4xjWTb0i+VDObWjCytCXeRj8Xy8+RZ/vMHBlqUD7ScXhZSL7udISGqE5L1NfgoViInBgb9V3aO+5zFuSEhfTaFu8CIEfQvVcG9UdCaHjabTBJQF3bwFlfMeOlyddLQJyeLRiBss6NzWgbH0M2ew9ibxu3lo0Ad1juxGbtIquKJxT9Td5Tf29NdlMZf25ygBnuB88y7hV107WWN61StzeyyWwQUxIXmvq+4EtgRxTV4xkAHM1LjumohR2qpJIBqVJAzu8YgDMdn8HAHqkTWuSIFMK7wbxZSLFkbvUGn5lpMznQFE49B+NB2qjvvXfMRbZMTWoF+UjyjBKLukPqDddIPFOa1RoCmr2ptRrOwnHW8dPznM4pEFVcWxblL13yAS2J6F9BURaaUAsv5zbVF+jZSwREL85NwsOZM38DrRb4mWkVJtdW4rQZeLu4RKTFo16ucH/x/O3WXT8I23pQXjfhuYEY/K81vIAC3FBg2tSp7Mieedaqihu8puDWcV46akAkmQMUZu+8rsi+UVk57FU0wosyJMwyO4BKXWOFFHpu1dT1bfHuK6cEW/EDJBbniB5tm7MxZB9PqnCoWp4e/Va6g6J6iN9z4uH0HLUI2r3MaoSw+uglBoesEgeE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(39850400004)(376002)(366004)(186003)(6512007)(2616005)(107886003)(66946007)(1076003)(316002)(5660300002)(44832011)(66556008)(4326008)(66476007)(8936002)(6506007)(7416002)(52116002)(54906003)(110136005)(30864003)(26005)(8676002)(6486002)(2906002)(38350700002)(86362001)(83380400001)(38100700002)(36756003)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S3yxjFbVTVP95XxspiDq1tGKOxrJa1hoTgZGv3jeMDpOKFUyD5RmBFMjSc3O?=
 =?us-ascii?Q?7NvfNRhYjqcSwzNAvhSdeUCEZF6zrcfBP3xc9oBfTc6A5gHowrskinOVABfF?=
 =?us-ascii?Q?eihmJh4k6RxWr03TB2HB/32rSS0YUgfTp3A6t4VDsYmUBSB6ReTyY7fCSIog?=
 =?us-ascii?Q?8NsP4m5KK6cytK9pyu49FPXSfahwRVcd3aJd+WEZlkvja44qra8HWDHBajQo?=
 =?us-ascii?Q?lTuKp/+fNYd48gYwW7Ifbi3Pg5jM/tv3M1RRPVgV2k0Qi+bW+uYYje/mt8vl?=
 =?us-ascii?Q?r1LDjpnI+Cy9/8HRwcunzl/hFn+XcFsPKTwmFHTgIt64Got4wT5zEZG4fiNv?=
 =?us-ascii?Q?1Ts1kC0qTTBm7mlc1GrnoQXpHgZI/bRjIFjxdz097Eek4CPjQEka+DmaRrmq?=
 =?us-ascii?Q?mWH36VrpFpotjaHzUrVf8jtSSoFZWzuVtwpqKtb/0QNa361/MF/SxVjadp6M?=
 =?us-ascii?Q?yIsZbNmzoXTmHPdirjaIN8vl/TG9o2ueG3BYy2fhjGRbnAbmzVigTGdMC10B?=
 =?us-ascii?Q?4j8D+eBaH8+EinCSxVS4mLBexSRkUAQuRXVOIjD4HQfrp0hQRUsl37lxyrWw?=
 =?us-ascii?Q?CY1Ku01JHjOsYeXqR/T737aGdfP0LLP27gTuStls8KgoNiW32ZKjvXZG7M8c?=
 =?us-ascii?Q?Y84JXv3SnFoVYdQX6Z0UZ0vmVnqHqyH5lh+7uj2vCtvMLmwPfOMzMJrR+I9u?=
 =?us-ascii?Q?ABqeYKJ2dRvBiIpUv2a9u0InvSoz142JTyTcRBbCFLW4Gjh2m8PpsHPvRHlv?=
 =?us-ascii?Q?A5qd5IlBr6PHsqplDtjz5nrX3hQHxh7HxnDkunlBlKjlouDGDA3ortfPK1+p?=
 =?us-ascii?Q?WdYoA1iZbj81X46fLRXy8u11UZElmI3kJmDGBKPwuu+mpAgX7R2ufjnXg+pT?=
 =?us-ascii?Q?8Fa9fMw7HHNbAq6rGKmYKRRNckDNmnoa19VKkqIZXLXb007fD4stVS/QOOK1?=
 =?us-ascii?Q?1exr/+U1SCAwSN5IfmAfmhQOlsSFhW2uJGVNQqrULgC4lM3ua4ry2gvvLeQf?=
 =?us-ascii?Q?KeKaNXlAtU7ZVPNKp0sDcXXX5LsElvysESy/OAWbDLP1DyAW09XIlVYaHEz9?=
 =?us-ascii?Q?idH/2fiIaCEvvnIPAumfF/a2jJW7mgbhYExmMAtTVQyRuAifbijgQYmvfvU1?=
 =?us-ascii?Q?JV6YiU805RY71lbZ6XRbqRDfpsuh45rASuYw/B/4YvHWsKD8b41F9QWjbNVN?=
 =?us-ascii?Q?b4IQKmoXDeuy5TU9BrE0BxIP05XUi3nOClK9kSCtxuMfOkV8cZIopIXP0xbJ?=
 =?us-ascii?Q?wip+08CPW3gUrjRAAiAJkU1v+JkDQZirkgWeVigtoYsy1a5RGqExaVrMpSpA?=
 =?us-ascii?Q?+UB4a1l91RWtxuvLaI2oyYBhv4+qQw3nfU8sHexd4c60chuykEcaCdDqHiTe?=
 =?us-ascii?Q?IVIdzEnII9jkYUIkBlTn8D+5OsC0AUUZocJs2P/8QmEoecY5TroEIXb2H7yD?=
 =?us-ascii?Q?zOXRc90GLhcaoeM+UOqqvR232yTgR4OKtHaqc6Bh3tdTIzKBwzPzDIkwqvg4?=
 =?us-ascii?Q?BHskUdD5DGEeXE67qFTRDNdT4ElacpB4yOXP10lBd8VFC6cRymvpMpzdV25U?=
 =?us-ascii?Q?FALsCQaaX/W5tQW0u5bA0QZQMHnTnvz5U6Mt0KsQSnbBq8YMN6beRaUjesV4?=
 =?us-ascii?Q?SA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caa46b96-b26b-4cb2-4cb2-08da6e4fef17
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:22.1599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QDwavMGcHhgviTWGGaFG52HYbGVwOWpuOCTCoSq5ZITALCZPz6mej4p/Qaz6MaqFX1K1u00sTY19128nXZMUfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3723
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These methods are no longer accessed outside of the driver file, so mark
them as static.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 48 ++++++++++---------
 .../net/ethernet/freescale/fman/fman_memac.c  | 45 +++++++++--------
 .../net/ethernet/freescale/fman/fman_tgec.c   | 40 +++++++++-------
 3 files changed, 72 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 92c2e35d3b4f..6991586165d7 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -814,7 +814,7 @@ static void free_init_resources(struct fman_mac *dtsec)
 	dtsec->unicast_addr_hash = NULL;
 }
 
-int dtsec_cfg_max_frame_len(struct fman_mac *dtsec, u16 new_val)
+static int dtsec_cfg_max_frame_len(struct fman_mac *dtsec, u16 new_val)
 {
 	if (is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
@@ -824,7 +824,7 @@ int dtsec_cfg_max_frame_len(struct fman_mac *dtsec, u16 new_val)
 	return 0;
 }
 
-int dtsec_cfg_pad_and_crc(struct fman_mac *dtsec, bool new_val)
+static int dtsec_cfg_pad_and_crc(struct fman_mac *dtsec, bool new_val)
 {
 	if (is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
@@ -872,7 +872,7 @@ static void graceful_stop(struct fman_mac *dtsec)
 	}
 }
 
-int dtsec_enable(struct fman_mac *dtsec)
+static int dtsec_enable(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -891,7 +891,7 @@ int dtsec_enable(struct fman_mac *dtsec)
 	return 0;
 }
 
-int dtsec_disable(struct fman_mac *dtsec)
+static int dtsec_disable(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -909,9 +909,10 @@ int dtsec_disable(struct fman_mac *dtsec)
 	return 0;
 }
 
-int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
-			      u8 __maybe_unused priority,
-			      u16 pause_time, u16 __maybe_unused thresh_time)
+static int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
+				     u8 __maybe_unused priority,
+				     u16 pause_time,
+				     u16 __maybe_unused thresh_time)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 ptv = 0;
@@ -946,7 +947,7 @@ int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
 	return 0;
 }
 
-int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
+static int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -968,7 +969,8 @@ int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
 	return 0;
 }
 
-int dtsec_modify_mac_address(struct fman_mac *dtsec, const enet_addr_t *enet_addr)
+static int dtsec_modify_mac_address(struct fman_mac *dtsec,
+				    const enet_addr_t *enet_addr)
 {
 	if (!is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
@@ -986,7 +988,8 @@ int dtsec_modify_mac_address(struct fman_mac *dtsec, const enet_addr_t *enet_add
 	return 0;
 }
 
-int dtsec_add_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
+static int dtsec_add_hash_mac_address(struct fman_mac *dtsec,
+				      enet_addr_t *eth_addr)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	struct eth_hash_entry *hash_entry;
@@ -1052,7 +1055,7 @@ int dtsec_add_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
 	return 0;
 }
 
-int dtsec_set_allmulti(struct fman_mac *dtsec, bool enable)
+static int dtsec_set_allmulti(struct fman_mac *dtsec, bool enable)
 {
 	u32 tmp;
 	struct dtsec_regs __iomem *regs = dtsec->regs;
@@ -1071,7 +1074,7 @@ int dtsec_set_allmulti(struct fman_mac *dtsec, bool enable)
 	return 0;
 }
 
-int dtsec_set_tstamp(struct fman_mac *dtsec, bool enable)
+static int dtsec_set_tstamp(struct fman_mac *dtsec, bool enable)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 rctrl, tctrl;
@@ -1096,7 +1099,8 @@ int dtsec_set_tstamp(struct fman_mac *dtsec, bool enable)
 	return 0;
 }
 
-int dtsec_del_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
+static int dtsec_del_hash_mac_address(struct fman_mac *dtsec,
+				      enet_addr_t *eth_addr)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	struct list_head *pos;
@@ -1167,7 +1171,7 @@ int dtsec_del_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
 	return 0;
 }
 
-int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val)
+static int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -1196,7 +1200,7 @@ int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val)
 	return 0;
 }
 
-int dtsec_adjust_link(struct fman_mac *dtsec, u16 speed)
+static int dtsec_adjust_link(struct fman_mac *dtsec, u16 speed)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -1230,7 +1234,7 @@ int dtsec_adjust_link(struct fman_mac *dtsec, u16 speed)
 	return 0;
 }
 
-int dtsec_restart_autoneg(struct fman_mac *dtsec)
+static int dtsec_restart_autoneg(struct fman_mac *dtsec)
 {
 	u16 tmp_reg16;
 
@@ -1270,7 +1274,7 @@ static void adjust_link_dtsec(struct mac_device *mac_dev)
 			err);
 }
 
-int dtsec_get_version(struct fman_mac *dtsec, u32 *mac_version)
+static int dtsec_get_version(struct fman_mac *dtsec, u32 *mac_version)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 
@@ -1282,8 +1286,8 @@ int dtsec_get_version(struct fman_mac *dtsec, u32 *mac_version)
 	return 0;
 }
 
-int dtsec_set_exception(struct fman_mac *dtsec,
-			enum fman_mac_exceptions exception, bool enable)
+static int dtsec_set_exception(struct fman_mac *dtsec,
+			       enum fman_mac_exceptions exception, bool enable)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 bit_mask = 0;
@@ -1336,7 +1340,7 @@ int dtsec_set_exception(struct fman_mac *dtsec,
 	return 0;
 }
 
-int dtsec_init(struct fman_mac *dtsec)
+static int dtsec_init(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	struct dtsec_cfg *dtsec_drv_param;
@@ -1430,7 +1434,7 @@ int dtsec_init(struct fman_mac *dtsec)
 	return 0;
 }
 
-int dtsec_free(struct fman_mac *dtsec)
+static int dtsec_free(struct fman_mac *dtsec)
 {
 	free_init_resources(dtsec);
 
@@ -1441,7 +1445,7 @@ int dtsec_free(struct fman_mac *dtsec)
 	return 0;
 }
 
-struct fman_mac *dtsec_config(struct fman_mac_params *params)
+static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 {
 	struct fman_mac *dtsec;
 	struct dtsec_cfg *dtsec_drv_param;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index b2a592a77a2a..d3f4c3ec58c5 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -686,7 +686,7 @@ static bool is_init_done(struct memac_cfg *memac_drv_params)
 	return false;
 }
 
-int memac_enable(struct fman_mac *memac)
+static int memac_enable(struct fman_mac *memac)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -701,7 +701,7 @@ int memac_enable(struct fman_mac *memac)
 	return 0;
 }
 
-int memac_disable(struct fman_mac *memac)
+static int memac_disable(struct fman_mac *memac)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -716,7 +716,7 @@ int memac_disable(struct fman_mac *memac)
 	return 0;
 }
 
-int memac_set_promiscuous(struct fman_mac *memac, bool new_val)
+static int memac_set_promiscuous(struct fman_mac *memac, bool new_val)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -735,7 +735,7 @@ int memac_set_promiscuous(struct fman_mac *memac, bool new_val)
 	return 0;
 }
 
-int memac_adjust_link(struct fman_mac *memac, u16 speed)
+static int memac_adjust_link(struct fman_mac *memac, u16 speed)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -792,7 +792,7 @@ static void adjust_link_memac(struct mac_device *mac_dev)
 			err);
 }
 
-int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val)
+static int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val)
 {
 	if (is_init_done(memac->memac_drv_param))
 		return -EINVAL;
@@ -802,7 +802,7 @@ int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val)
 	return 0;
 }
 
-int memac_cfg_reset_on_init(struct fman_mac *memac, bool enable)
+static int memac_cfg_reset_on_init(struct fman_mac *memac, bool enable)
 {
 	if (is_init_done(memac->memac_drv_param))
 		return -EINVAL;
@@ -812,8 +812,8 @@ int memac_cfg_reset_on_init(struct fman_mac *memac, bool enable)
 	return 0;
 }
 
-int memac_cfg_fixed_link(struct fman_mac *memac,
-			 struct fixed_phy_status *fixed_link)
+static int memac_cfg_fixed_link(struct fman_mac *memac,
+				struct fixed_phy_status *fixed_link)
 {
 	if (is_init_done(memac->memac_drv_param))
 		return -EINVAL;
@@ -823,8 +823,8 @@ int memac_cfg_fixed_link(struct fman_mac *memac,
 	return 0;
 }
 
-int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
-			      u16 pause_time, u16 thresh_time)
+static int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
+				     u16 pause_time, u16 thresh_time)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -861,7 +861,7 @@ int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
 	return 0;
 }
 
-int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en)
+static int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -880,7 +880,8 @@ int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en)
 	return 0;
 }
 
-int memac_modify_mac_address(struct fman_mac *memac, const enet_addr_t *enet_addr)
+static int memac_modify_mac_address(struct fman_mac *memac,
+				    const enet_addr_t *enet_addr)
 {
 	if (!is_init_done(memac->memac_drv_param))
 		return -EINVAL;
@@ -890,7 +891,8 @@ int memac_modify_mac_address(struct fman_mac *memac, const enet_addr_t *enet_add
 	return 0;
 }
 
-int memac_add_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
+static int memac_add_hash_mac_address(struct fman_mac *memac,
+				      enet_addr_t *eth_addr)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	struct eth_hash_entry *hash_entry;
@@ -923,7 +925,7 @@ int memac_add_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
 	return 0;
 }
 
-int memac_set_allmulti(struct fman_mac *memac, bool enable)
+static int memac_set_allmulti(struct fman_mac *memac, bool enable)
 {
 	u32 entry;
 	struct memac_regs __iomem *regs = memac->regs;
@@ -946,12 +948,13 @@ int memac_set_allmulti(struct fman_mac *memac, bool enable)
 	return 0;
 }
 
-int memac_set_tstamp(struct fman_mac *memac, bool enable)
+static int memac_set_tstamp(struct fman_mac *memac, bool enable)
 {
 	return 0; /* Always enabled. */
 }
 
-int memac_del_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
+static int memac_del_hash_mac_address(struct fman_mac *memac,
+				      enet_addr_t *eth_addr)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	struct eth_hash_entry *hash_entry = NULL;
@@ -984,8 +987,8 @@ int memac_del_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
 	return 0;
 }
 
-int memac_set_exception(struct fman_mac *memac,
-			enum fman_mac_exceptions exception, bool enable)
+static int memac_set_exception(struct fman_mac *memac,
+			       enum fman_mac_exceptions exception, bool enable)
 {
 	u32 bit_mask = 0;
 
@@ -1007,7 +1010,7 @@ int memac_set_exception(struct fman_mac *memac,
 	return 0;
 }
 
-int memac_init(struct fman_mac *memac)
+static int memac_init(struct fman_mac *memac)
 {
 	struct memac_cfg *memac_drv_param;
 	u8 i;
@@ -1124,7 +1127,7 @@ int memac_init(struct fman_mac *memac)
 	return 0;
 }
 
-int memac_free(struct fman_mac *memac)
+static int memac_free(struct fman_mac *memac)
 {
 	free_init_resources(memac);
 
@@ -1137,7 +1140,7 @@ int memac_free(struct fman_mac *memac)
 	return 0;
 }
 
-struct fman_mac *memac_config(struct fman_mac_params *params)
+static struct fman_mac *memac_config(struct fman_mac_params *params)
 {
 	struct fman_mac *memac;
 	struct memac_cfg *memac_drv_param;
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 2f2c4ef45f6f..ca0e00386c66 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -393,7 +393,7 @@ static bool is_init_done(struct tgec_cfg *cfg)
 	return false;
 }
 
-int tgec_enable(struct fman_mac *tgec)
+static int tgec_enable(struct fman_mac *tgec)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -408,7 +408,7 @@ int tgec_enable(struct fman_mac *tgec)
 	return 0;
 }
 
-int tgec_disable(struct fman_mac *tgec)
+static int tgec_disable(struct fman_mac *tgec)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -423,7 +423,7 @@ int tgec_disable(struct fman_mac *tgec)
 	return 0;
 }
 
-int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val)
+static int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -441,7 +441,7 @@ int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val)
 	return 0;
 }
 
-int tgec_cfg_max_frame_len(struct fman_mac *tgec, u16 new_val)
+static int tgec_cfg_max_frame_len(struct fman_mac *tgec, u16 new_val)
 {
 	if (is_init_done(tgec->cfg))
 		return -EINVAL;
@@ -451,8 +451,9 @@ int tgec_cfg_max_frame_len(struct fman_mac *tgec, u16 new_val)
 	return 0;
 }
 
-int tgec_set_tx_pause_frames(struct fman_mac *tgec, u8 __maybe_unused priority,
-			     u16 pause_time, u16 __maybe_unused thresh_time)
+static int tgec_set_tx_pause_frames(struct fman_mac *tgec,
+				    u8 __maybe_unused priority, u16 pause_time,
+				    u16 __maybe_unused thresh_time)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 
@@ -464,7 +465,7 @@ int tgec_set_tx_pause_frames(struct fman_mac *tgec, u8 __maybe_unused priority,
 	return 0;
 }
 
-int tgec_accept_rx_pause_frames(struct fman_mac *tgec, bool en)
+static int tgec_accept_rx_pause_frames(struct fman_mac *tgec, bool en)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -482,7 +483,8 @@ int tgec_accept_rx_pause_frames(struct fman_mac *tgec, bool en)
 	return 0;
 }
 
-int tgec_modify_mac_address(struct fman_mac *tgec, const enet_addr_t *p_enet_addr)
+static int tgec_modify_mac_address(struct fman_mac *tgec,
+				   const enet_addr_t *p_enet_addr)
 {
 	if (!is_init_done(tgec->cfg))
 		return -EINVAL;
@@ -493,7 +495,8 @@ int tgec_modify_mac_address(struct fman_mac *tgec, const enet_addr_t *p_enet_add
 	return 0;
 }
 
-int tgec_add_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr)
+static int tgec_add_hash_mac_address(struct fman_mac *tgec,
+				     enet_addr_t *eth_addr)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	struct eth_hash_entry *hash_entry;
@@ -530,7 +533,7 @@ int tgec_add_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr)
 	return 0;
 }
 
-int tgec_set_allmulti(struct fman_mac *tgec, bool enable)
+static int tgec_set_allmulti(struct fman_mac *tgec, bool enable)
 {
 	u32 entry;
 	struct tgec_regs __iomem *regs = tgec->regs;
@@ -553,7 +556,7 @@ int tgec_set_allmulti(struct fman_mac *tgec, bool enable)
 	return 0;
 }
 
-int tgec_set_tstamp(struct fman_mac *tgec, bool enable)
+static int tgec_set_tstamp(struct fman_mac *tgec, bool enable)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -573,7 +576,8 @@ int tgec_set_tstamp(struct fman_mac *tgec, bool enable)
 	return 0;
 }
 
-int tgec_del_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr)
+static int tgec_del_hash_mac_address(struct fman_mac *tgec,
+				     enet_addr_t *eth_addr)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	struct eth_hash_entry *hash_entry = NULL;
@@ -614,7 +618,7 @@ static void adjust_link_void(struct mac_device *mac_dev)
 {
 }
 
-int tgec_get_version(struct fman_mac *tgec, u32 *mac_version)
+static int tgec_get_version(struct fman_mac *tgec, u32 *mac_version)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 
@@ -626,8 +630,8 @@ int tgec_get_version(struct fman_mac *tgec, u32 *mac_version)
 	return 0;
 }
 
-int tgec_set_exception(struct fman_mac *tgec,
-		       enum fman_mac_exceptions exception, bool enable)
+static int tgec_set_exception(struct fman_mac *tgec,
+			      enum fman_mac_exceptions exception, bool enable)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 bit_mask = 0;
@@ -653,7 +657,7 @@ int tgec_set_exception(struct fman_mac *tgec,
 	return 0;
 }
 
-int tgec_init(struct fman_mac *tgec)
+static int tgec_init(struct fman_mac *tgec)
 {
 	struct tgec_cfg *cfg;
 	enet_addr_t eth_addr;
@@ -736,7 +740,7 @@ int tgec_init(struct fman_mac *tgec)
 	return 0;
 }
 
-int tgec_free(struct fman_mac *tgec)
+static int tgec_free(struct fman_mac *tgec)
 {
 	free_init_resources(tgec);
 
@@ -746,7 +750,7 @@ int tgec_free(struct fman_mac *tgec)
 	return 0;
 }
 
-struct fman_mac *tgec_config(struct fman_mac_params *params)
+static struct fman_mac *tgec_config(struct fman_mac_params *params)
 {
 	struct fman_mac *tgec;
 	struct tgec_cfg *cfg;
-- 
2.35.1.1320.gc452695387.dirty

