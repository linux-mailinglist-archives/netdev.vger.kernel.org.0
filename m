Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C915988AE
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344686AbiHRQSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344598AbiHRQRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:46 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70085.outbound.protection.outlook.com [40.107.7.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1CABD112;
        Thu, 18 Aug 2022 09:17:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ub9l+sFd6XKFnvbkjUZiVch1ZLARkUdJgLkjstQq51xNuWlE99UWpT+5wgFGdITiREUhm3a7sAbWGjUpyl004leWs7ZO1qKuREMfx5tDGG9LM2pKdESTmrcbdQ8yAqBmEB37MxkFv22bXRCEbwpCEhaTGHIIKrkADuj4xh2Bl06ZOcH3KvVcitvW+xGxpndhNk4A2D0tkSHVQnbZM5gg741cN/+EfAwZPljQiSWSPJGcaDDT3TltfKAq+NqGypRruurrRl6NAQ51XF0SSQu7IwaxYE0Eg4gmJRT7p8vmVLdbZu6Opp2OvPRpxqyYv6/AY1uwFKF006SxmiYPyhk53A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hz6WDFv74EuM8OJ4B+HPhYA66UPtmHjCYXGt6fNkJn4=;
 b=OfEUAQ+qPBKTCM+OmzdPVlUG74fWy1R9y8eIoQ8FBnn0IezgezAKGbSxQa9m4qOAgK2PBrZJ/MxeC6mVjS3fQeRPW88xwLjHfxGDL9g/+dOh/in0GqNh3X+VieGrfDE+ZfbzD/wB0pXpg29ealEGxhGzLNhk98kyDhMIAVGeNmfB9kkYmf5MWOY6GgXWODrCs3QaC9u0U9HJEAWsYs3o3THaSZPAEbFdqd7DKmcT05gl9FVW6O68nudvMhtrHYHfaHfGrUCbhOAKy7G4QX79uWNBn0B0YawlCHvoc8Nob15bm8sBXeHekjCp+teEIAgqtPH9WpgToGN+v+CDpHEQEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hz6WDFv74EuM8OJ4B+HPhYA66UPtmHjCYXGt6fNkJn4=;
 b=1VEXVt23rK2rikyzcLZ2u7+Pi5hUgn2al+AOQ1r59i9rwYJ7WLNL7C5evGFxp0acYj7NzUN2m5kJBDxoSvy4mXpkZtd0rvpjVRBLUniNQ3a7H+qaHq9MJNiFH2lNoTjfA2eqHeFl6f/enpwNelX9kF+sb28bruWQGhFsBuiM12L9mFLwgkjSp0spuHb7qhgE8mkeC/fCkaNpd2lM5DmOEeYqC4XSPmeZIN0ZIlMhggfpQV0GYvhh60HilbxvyGXVOVOnG8SCVejonuK30rvCdpHvdVA9A6Y+v+jcWx+y1KyUKInyJeOPgiOtd7D33IJSbm2ySavhqXXQEymtsmM3OQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB3PR0302MB3211.eurprd03.prod.outlook.com (2603:10a6:8:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:17:26 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:26 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RESEND PATCH net-next v4 13/25] net: fman: Mark mac methods static
Date:   Thu, 18 Aug 2022 12:16:37 -0400
Message-Id: <20220818161649.2058728-14-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 258fd6e6-10d5-4f09-f6dd-08da813523ff
X-MS-TrafficTypeDiagnostic: DB3PR0302MB3211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v1GpMh585OvMXU8B5FL+SsXpCAPAHYO/jw63NZY8n0rGTeoEBscbn26Mevhdj63CsYNG9MpXkznf+AgkFLPk147DSvHk1kJoZG7p8zhTSHtJAekYcgK0l5ZrLxVM8BbfiestaBuFVf8j8t3qzp5lpqsaVhQC7sB3xjWiN8kgDRlWfLM+xhsAk/TzSkfEytMxTy+F0wxKrjEEyFe+2z//jrSwiNGyPMipllCzWRp6WxmHuZdhiN+UTVAfqkmanMzgV0tFfsBluuzhSZnkqxde+mxyZMFbBkE3PSE6fiOisMOmmD687ZXth0QSduxEVCsExrojxJ3sYajYihRqPaGhJf6PyCMIvbe5ZnDbD0Kk0oeMPD1YD+pelRuse5SeEhPoaFvkklUwPq1xw1WWxQcW0kPDd1ATvE3Vp0Hs7qwNyz0m4yAew1hIK25U8pS64SM7EHvhYn0RG+xno8/CrpMULG+FhnwUX+P6zEX8nE4Ty0zXHcbqdHIdM60lXbqKS/+qlIhRaV9k0yrPYRlQqP1ocgP4b4WBC1AnE5tA05CUrE81JyHr87KTarxZIJqMjxzw299DCtY7IBpZZxpZv51W3hpySUn5wlcnVSHWOaF+de+eDMSwJAnxZLy8eO5RaalbAEq8Aea5Ps99Ag2NImvEhq4Dqnn6A1suZThFdYDhO2hJowtckyZk/VLbjhrJiyLGLxTSWp75HOS6ODMMCOeM9lsnGXp8zIzHrvamyteGza1EX3dzA0cuYdsxDFiowr6Vnhz42EUzlPtahUIDkcul+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39840400004)(136003)(366004)(376002)(2616005)(38350700002)(8936002)(38100700002)(4326008)(6512007)(26005)(30864003)(6506007)(52116002)(6666004)(2906002)(8676002)(36756003)(66556008)(1076003)(66946007)(66476007)(54906003)(110136005)(44832011)(478600001)(86362001)(41300700001)(6486002)(316002)(107886003)(83380400001)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xvUVqbXsLuVKdku4a2Ob67yA2A1onVd1wTL5Qzb7bnGDsy23P5jPbEVNTIv9?=
 =?us-ascii?Q?hBOU/V06TvBAiDPul2rVPD+0n1aBQ5LfYV0Ou7DSPrLdUucHlE25ClNm0w4A?=
 =?us-ascii?Q?nxpNgjagSpDeBK1jueQsXz+EH0xqdAMq979kehMV083At4uBIkFtcdSbclWA?=
 =?us-ascii?Q?XeD+TkQVi3pi3WhyoySl574DcT0ZcDaeIVQmOJAN2LawIaF0gTCLD3TZyB11?=
 =?us-ascii?Q?NfdU4YIuUVu1ja0EXTm3y2lurdJxPqQYbYOc4LM4khEeysHC3IOD4Syd+AL/?=
 =?us-ascii?Q?WH0UgaX+UaxnG7lnEGWUGMpB3TIAMHPQDg6QQRbsKcComUJ1XWKnrdtYufin?=
 =?us-ascii?Q?P1mL95KtN8JNyq2idIjRVfnTaKAGwu9ejPqxw4amtAhuxNMXM3D1bmQKAJQK?=
 =?us-ascii?Q?i5PAA+U4ieCuC9/Q8q1vheFrYpdSgFEMZeM5758hWboHbtx5C/paNORlLulv?=
 =?us-ascii?Q?UqEeV2X3lH7Guo4sJqUpV1AKpJF2cza42w17nViEbWT3XkSmMmO2VroXqXOC?=
 =?us-ascii?Q?p7AZ17E4EL54rKM6Rfyr0MaUwKPQOMjao88MExO+ElngIlPiVwKt7XrcMSvE?=
 =?us-ascii?Q?rfjXBhR0KTSBwiyX8k83ggbfXd5mwm9DPdtg4WVeMPBLTIoUf31SSJPuaHP7?=
 =?us-ascii?Q?j6EhNZ0s52EF6qgZNpbhFdxAsH5VzrTZS0XysJc+SzEacfF9Jfol/4b+1eKa?=
 =?us-ascii?Q?MHSTxjupZZolIMyeKRz9QdoxXsr+5R4YgoO9EpjV694yRGMbsEdLDGhD+htt?=
 =?us-ascii?Q?qR9KdieG4x3EoB+lFBL0165ychnDpuV7Bixg8idb+fRe68hIxoSr9shmtnZR?=
 =?us-ascii?Q?ljjQpnJ4ADiMTEajLi/5G14BrMJbavQc61942ejiPMSG/bguj0UiXFqttrtW?=
 =?us-ascii?Q?o/OX2eHI8t5QUiYI2OyGklHGC7lcfJ2/qKGsL5U4wFeu59LtTE5krL6oFfRj?=
 =?us-ascii?Q?wQ+pOlgr7NJvhrrl8MoUPGA/rcuc7gZy8jsJcDA5DKLCjIX2ZcinuUvu8Tdb?=
 =?us-ascii?Q?bHBYWyOeJxaby2blNLlCLgMugV74uaZuoZKYw8HJ7Fe3FBn4iCLZwNx7gAw4?=
 =?us-ascii?Q?N2Zp4L04aAFzareCUah1sQ/z/ba38Xgcmom8xRmxs2edXuhRShEG4XNkNgc9?=
 =?us-ascii?Q?4ZOV6My0doomEjfQLa+r5QpobkgWrfIrTzIMlhbJM7AXUWnWfEkNW5U2e0Hr?=
 =?us-ascii?Q?+ydWkh6NCaapiK80igwB0BRqkFfQq/P8lzk7ORv3F0ssepvlXjeRrfoylmPY?=
 =?us-ascii?Q?WkiwdZD7FdOe3kcdKX/FXmGOpJzJlOHfksl9R2iM9c6v3BA2LNAH/frfmyGD?=
 =?us-ascii?Q?RrPiyse0C5SDhGOqwmrFXZ6tC+5D4xk01x1cuLcA9ysHwuu5m3MOhN5Fhs1l?=
 =?us-ascii?Q?QwYZdCuqsxPg3eZ/9tXNjO6Yc17veWHbpc1UKgUFj48SB+I2xgFswhhyLBCQ?=
 =?us-ascii?Q?PtWHoTjrslA8Jxh0Dd861siff5aEWplQ+mcHFTJa/UL14n4+LddXUBbwICf/?=
 =?us-ascii?Q?v6E7x1WiS3pUa6RkA03F4fFya0O9sDZGb+VucwH9uA0Td4uGmd7gyzsPts5w?=
 =?us-ascii?Q?7vpZxciNGKNCE+aukIOoWNb5q9s9f4JmIOt8/oR/jb6MjiK9yarNFyXAyAOG?=
 =?us-ascii?Q?5w=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 258fd6e6-10d5-4f09-f6dd-08da813523ff
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:26.6542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9wDKEfLPiNhDqjmmdaApAeVxqRhQAQz28Caw2x7/BhiX3PyiicXiuBz0GHLEelMI9ByS5Kho0831AdqykmC9yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0302MB3211
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

