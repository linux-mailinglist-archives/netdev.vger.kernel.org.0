Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692B054FEE2
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378880AbiFQUfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354086AbiFQUeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:34:31 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150052.outbound.protection.outlook.com [40.107.15.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0515C854;
        Fri, 17 Jun 2022 13:34:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzPwRWCXCCKQYnBTAFHn9y778cZwRN6NDU5bW9IbQ39/SkEBdjSjNYX1wODONGUdYarCYySyDpSygjpW5pA9dEzrShTMukCur9396rzby5eL9jc+sxLX4Ywij2VL90+sColXOjthblQOKO4ajwqttZ0MWdYMQLKBeG7R0oNogQj+TYR0RL8QENrFNf6jq+7s+phN7AvSgbfNAKr4i92su/6v6GoF5KpUigOl3PMt0FhySTXb1qDxnYEd3V/D4iDLfVP/4K4h3X8++P1Hq/xiZIhXgDE602sQeSVoQCxvppE1dTm4xO7KrpP1Ir8oJd5jSzwy0yKK0PbijxpO96V9Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipUC+c918Zso68HKWEYX+QniP/yvO2IgSxtYTfLrRBw=;
 b=nEG43+XfpKEClpuFdMgqw61ZeNS69QymRGDkCWcp9yRgLrkNs/d/kOYcJP0r9oMnEmlnB7HKYLjJx7Q+0HKPPJaLR/mZXL/tLJwYfIASoieVjAp/PKQAabyPAJEj+apKmQ6bR8I8iUp4hm9kwJ6ULrXChJmG/+aIeosS9UIGSZ7w5C8TMKP5FtyKL3/26YeFOfFZC8wDbv7KMwI0Q9ZMm8TKpSUP+WJs4ktQ0HvRTT/WnSoAU2UXdXhvlAtiGQMZt1Bxj3TKOGPKgsgMnYKQVqH8xeNYQlRdJjWOUPR9JMCv5953vgz46IKp9z/ci3/3NTQUM4qUhLTC6ZNLXYz5XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipUC+c918Zso68HKWEYX+QniP/yvO2IgSxtYTfLrRBw=;
 b=ZgHAlVby5pS2DvohHvPeQ9riPWSrzB2yC0+hlZ6dZitR8+wcFVp23R83biuaBWuVL3f0q8J+bUP8SecnXyhBj286jq0GJCmrB7q3mud55jD0StH0PpqzDkt9HvMudgwcwBCoXA3DJE4UE33URKOaHvVc1HYRzGrUoNEt7MeHLPVWgRtpQpR76hqXF9/rgIv2acIhDtdit4k8WyjJTef0T+ws4wqrrLifu7bWRl/5R3uwBLyb61pFzQuF2P2edw90Mi9fixYzbMzrob3xAna1edsp1vCpK5oTwIiqUi10azqVNbqj85qAUkJ/7ly2DbNUdHn/5a8sH15T4pJbFlkZmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS8PR03MB6838.eurprd03.prod.outlook.com (2603:10a6:20b:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:34:04 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:34:04 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 15/28] net: fman: Mark mac methods static
Date:   Fri, 17 Jun 2022 16:32:59 -0400
Message-Id: <20220617203312.3799646-16-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f0db102-3207-44e8-fa68-08da50a0b843
X-MS-TrafficTypeDiagnostic: AS8PR03MB6838:EE_
X-Microsoft-Antispam-PRVS: <AS8PR03MB683811B03F14D65F925975EB96AF9@AS8PR03MB6838.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WjHlsOGk7VyODW2bd4M/rP/wGpssJ6hZmpKnZbGDV0wfzJZPPNkDFFqZkVAXlS/z/CSxviv5SN6E7mSd4TEclGdGdqpPcFSWvDqsx+kTd9Ip3MeTGjHtdlVMeeq/8BQxEBSVpXXxdatE2X+Gr7Yi6qKx4W9jcgmhRjt/z9ewRTlTipxcU8MwLJYoL9h+HcGG7Ug99wtcsQwoV/NcJnDecrruAbmg2pGy/3M3HtZOY+Cmi3Z1LhqFawuinuDadhIKG0VgmxjBkCm0iGbEO8mQAR7yxlufuOgkxMhRcMNo6kpRcGf3TkMdeld4GiGXG5CGrGGRTbZXxdnqDwyD5dErnOtagpysz2s8NGzWpqVtm2qwlSrKFdaLrET3bEgdzkZHnPZEpmW8rYOLXG3qd0N8KMmd04CYmJgYY6SU0spWk4gudXSi9ZO4ATwBW/JpqZlFiIJgx2rFM9rXy6Mo6CAPby27unGcFr7Km2VF4/Y9Y28Z0XJqoLuk2b777Wk0ESWc0nOkNJn+eU/O9f/5YacB7E+rAO6pkORIko0qOb1aBRBozl1zuoRPOjLAMKTJFffBbdmq2d0pVqrsLzYrsEaSRKdlQOt/omIUGnVbiEGEDsN0Vac2feDLjBd/EXDZNxnIW+K18viAKLXci++eXxD0tjn6NupCRX8Ar0GSd1fbF1BI9EZqsngn8xXrHeRAZ+ERtnc0rSUdS2/z1NmZ+iyOzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(2616005)(38100700002)(38350700002)(8936002)(52116002)(26005)(316002)(36756003)(6512007)(30864003)(2906002)(4326008)(66476007)(6486002)(66556008)(6506007)(5660300002)(107886003)(83380400001)(8676002)(86362001)(186003)(66946007)(6666004)(1076003)(54906003)(110136005)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G0hcHhi13iiIxX2v7zz6QzmBCyNoXLT8vFjR79l79/8AuorEE3gKxlnSmzGl?=
 =?us-ascii?Q?Fmu4VvOXeRf3qJzVOk2lLY9E+8jaOnZmcR1xR8Lyz3Z9FreLDgs6aQHd6Blu?=
 =?us-ascii?Q?/A84u4q64sYbq65vl3QRfTjCeR+DDevJbLcSXXUtVM3TmufweggEHgo8vgPo?=
 =?us-ascii?Q?DXAChoTvNlss1HT5Wf0q9izwLpKZr5mDJ/EhrRedL/l5mXOaqKqQz0Bf092o?=
 =?us-ascii?Q?vbHSyrRBitRJoFGUsKcpye+OskRdOtW05AtX9LkaNTwHCLHMJb6QNoi8YknS?=
 =?us-ascii?Q?F0+HPF++9sfOPVzzrXhUCxN+xy0cWDRZkT+9XCbfIibHFERPCIYxIZ/vL9hS?=
 =?us-ascii?Q?zl4loEuEu9xeE2IX4swcUuil/CikKkjGXLPr2UPPD+bHqm2iHJh95tTgKdnQ?=
 =?us-ascii?Q?iz44i/N6uKfCTb+RGPfZVuvBS7oJMD7bbMuFFUrtUsOwSsdmjV8iqCsYRx+T?=
 =?us-ascii?Q?CXhBU9svHh5OiZxV0WbZwQOAHdhxeLHzFIYPHXi98STFF0nMnT31VFCttQOe?=
 =?us-ascii?Q?QwAT+qUMrmIpUz5Ve16YBXgIl0dlhmp0DoNydK9ChzVlgpODN9gVL4q64whC?=
 =?us-ascii?Q?9kOCWY44NsU/xkjgI8oB8DivKHBtrPbZDNLC5m4fj9rblpbk0Mym6WsYE7nS?=
 =?us-ascii?Q?yE+FkZUwLDwpJ1mvnn2zn+rRPFppyTOz8lCxZ0PjLlBXvy4Zb1jwA4aimy6J?=
 =?us-ascii?Q?B8svbBvBPiOQk8nDQlbI4ABOAE11pGYppwJzKEuPBaEq0zWBNt3eI/RrFz3O?=
 =?us-ascii?Q?fseE2lMB/o2DC9M01mF0aNkfO5CRle2Yat4UMzthd2saWSgnm5msNgDapper?=
 =?us-ascii?Q?oyqthYueXDFPD0l169iy+IEXFDGgLLoatd8Dd8wjbsYw5wY/HoFpq/AOkJ3Q?=
 =?us-ascii?Q?S4f4EfAKXlceTfQMllbWy94h9EucIRhepelO6PXSTlaCOcCeaCgEs4eWz8W8?=
 =?us-ascii?Q?gAiNPEiSHo2uBt1wvLyRMttZ1D8Xa8tb35QsgwXn5KsjnNFpT1VJAHplZDfY?=
 =?us-ascii?Q?gzPwjc442rpouA5Wn4ejyBYy4mPOaXy29hAJrymO1QmmstspV95Xp6Fa7/0Q?=
 =?us-ascii?Q?ZvWy4IEbKHCufJdyAOCGM+SA4rHOD4KTBLzZQaaxs6DRo9vaEP5CjZUglGLo?=
 =?us-ascii?Q?a8DIDVVW8p2u1Rq5Ueovyxzi2k3xQsKF6++2bPnJcMoX5BRl4HzBRzdE7zYG?=
 =?us-ascii?Q?kAKbjGKeYggbrELP/b/PSpT51y5k5ilJ8qpQZZfE+WpOnBDtsYbYSHjR8oXr?=
 =?us-ascii?Q?DdcspqJTnTw29E1fLwkLjM4F0yJF9paOBjkU7/3cbCYTHQgNtgCMRIOpZM88?=
 =?us-ascii?Q?lxDX3fqL0kXSbI60ZOw/BzH/kp0MWr/eCOZTcTR/tcPkYsilXUPAqGoDrX9h?=
 =?us-ascii?Q?eQ3EG2AIIJPzy7IFznKbIU/cLnDpMQsRtkh88fMscBKDaunD7SECgzRMF6yq?=
 =?us-ascii?Q?dHb9rfzQycw28GHZA8GcHYct7bDFStXaygj/jTHZYO6f8QVPk1WqSxVI/uFD?=
 =?us-ascii?Q?Agy9ZIV+Ty8T3wl8wzIvpZsvxx41khzm45p3ep5tZayVBMJ5yG1K3e0dXxoX?=
 =?us-ascii?Q?JlWMoXSkxvQRswbLV4+m27d8AWpG5+c/hlWzaM9g2n2bFblF34ekC0peHfWC?=
 =?us-ascii?Q?9yzf/LM7MYDDGCZbPSsBtJwMd0qQsUwI1amavO0PZmMbQpIG3UfmN77dQCDe?=
 =?us-ascii?Q?PDffC4C4TgigpHC2OYggL7V4LbCnJAJehFu15YP4zxbdDoiy1L8HSAHUJWym?=
 =?us-ascii?Q?G3FYjX9oWqutSTStD8LfdnTR5QdSz3I=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f0db102-3207-44e8-fa68-08da50a0b843
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:34:04.4204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mBHWE/YKUUtJmr5PA8lMemJwMzFuYX0g8TwhYBv6/urW5lOb4ZurqnbOaUy7AV0F9ccdoAQkuHoMtoPdObK1DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6838
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These methods are no longer accessed outside of the driver file, so mark
them as static.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 48 ++++++++++---------
 .../net/ethernet/freescale/fman/fman_memac.c  | 45 +++++++++--------
 .../net/ethernet/freescale/fman/fman_tgec.c   | 40 +++++++++-------
 3 files changed, 72 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 12ce079a356d..8da50c56c440 100644
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
index 4300a21a553b..2b4df8f3a27a 100644
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

