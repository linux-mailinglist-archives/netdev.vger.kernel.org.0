Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E62598877
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344547AbiHRQR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245699AbiHRQRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:14 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70070.outbound.protection.outlook.com [40.107.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E5DBD094;
        Thu, 18 Aug 2022 09:17:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=InDH2jUFdfMYbH/R3HPzYOpE1hzMMrfpAtfNSKg6unlCZEltCKo4ejojbjBDuyEoAditjtYHn7NdLmDesF0QbSL0oBexo8f9eXLq3qR+HOq7CHwJbNnLzhaLUL0NaCW+I8UaNrTd1DoXqSaiz8jed5/Z8nEqfWmRc2lncut+PJAhCZkEBLXeV35S3sSKmLgCE0qxxde048uL0s3kzW/ESzHHGAZLsIwUyCwDu779rWdpAVj2A5T8OgMtDKsFogOnGtjNCY/PPnhv1TeVwoBqldSY+U4oKcM20YwuAf8FR32jvH3z2opPHv/ew8X7fsQmdO8PZTdLPMA0xsVu5oVTFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxl5ypHVF2yTjwLwhCMIKk+7ahbMUu0knhMwR6YqOck=;
 b=miZOBtrp6ljmpBOe003/+nlrMeqz4wI4tbSntufJiNV+QUOB1z0O3GGaAkH1p17u3lWBIyfiq+GjoKRBJsYyTaNeH2iwpi+vtbntaPqU+WdJjenxuEU4Q7Qf2a7ib5ueRL9QcznE+F7n0zbuzFIgO9/F5hq/nbM5jWXMPIN1nitgTuXe/B91gdYYDZzLNZ/Ip0WeZrLOm5dqSHKBi/KKNZ4HPcgNVKfyRjsExx1h3/lIHesDMChSPMy16clSfFd6/Ell04hNToZWfsKDjj5qUVVPl9AtEpEJqCU4ugBCVQYOyl3LL8FP9fuT7QCwGjEv3MdVkN6Rkus9HdAuRmg6xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxl5ypHVF2yTjwLwhCMIKk+7ahbMUu0knhMwR6YqOck=;
 b=10y6/FsSE7SNzWXdZEAxCm54EPFPaWY3rM6v6JPeLxE7jQpzAxFldgbwh23ZCgRtXlYn+petYeS7JxoELGoT7YUV1sXTeifyaFD+GeO/aY8TIFTeF1q9kTEmzgBuzVMH0tIoUPGWjx1i2bvucNx8rRcBlE0wztwTcX/DYC4UvvyTIR8ryIARqgA2w2352EnXYTbcEPuCih7+HvZHNIlkOcTh/ehdpaL3z5T6OU/ioCgPVib0NRB05HfVYDgNEV5YNu7nCFTssh8YEV19MUnx1bNvHDJsTilixONlxhKKQ8VngYTudQX6uP+ynHhrxVnxidvTeytAUnAw3/E5zJ09nQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB3PR0302MB3211.eurprd03.prod.outlook.com (2603:10a6:8:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:17:12 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:12 +0000
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
Subject: [RESEND PATCH net-next v4 03/25] net: fman: Don't pass comm_mode to enable/disable
Date:   Thu, 18 Aug 2022 12:16:27 -0400
Message-Id: <20220818161649.2058728-4-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6f793a05-aa62-4a78-5b8b-08da81351b60
X-MS-TrafficTypeDiagnostic: DB3PR0302MB3211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PqmqR/aKr6IgQ87l3CE4lG/CL+bmob2BzNrXkTxwJ5ALzL3X63vu4O8jAQMSys82Z9R9pSLxqON5H7zH30oYNtMjtejEUcBbqUbZ+2A5QzHBn/OxveEtjBx3soV/sFc6htYGal76SJXlVaS3j6gMQHNjc1FqLq/Sa21bA7/VLLF6rYD2iI1uXWpWma7LLTK//GfvEFTEmN9AmmxDX8OJS9risngEGytRXyXFfHhvrMNHhlijf+mksSp/ZR+nP1gFKtE2cGghcFjgLIOtTsJ0IWIicArOya9SY9gtwwWkoLNQKHpFvrtAFOhFuMe0KJvPyONnirSaArzNuAYwAEPEiXhHllGX428aLHv/iuysyeSp0QjkiYjUXriBCSSTKAAQPAqtB2MrjJNyYCTU1ZcLWEqdc5bXQiENwyq13690NETykeZYnfoov+5SECKOniopETBIwLIiW1R4m5hPAMDxV5PiMzpAYIrmo0kvV5vAwE9rRJCL97XJczkpYqTpLwr9eI7v0zAVOahuG2KGDXnQRqjJFkQVIYFh6QjWDRzV2VNJK06bmItS1VUstQ5peEN7ozsWsI7lxc5UOOviRl1LnrqfBY9H/1aBupSs6+VClnPQ2wBpZRmMrfAx9SjgqVemIVOIqorc2SyznWzbAvDlpmMXP3nYRe9h3BVTT/E/sr1ndzan4mx+W2JKo5N228/euu1cx/DmnPdC/NOju8uVxqdcHhiOzET0g604m3FXSn7226g0B6JFu7hWkSCQyk4jB+9AfrfrHIuO6HI7CdzRtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39840400004)(136003)(366004)(376002)(2616005)(38350700002)(8936002)(38100700002)(4326008)(6512007)(26005)(6506007)(52116002)(6666004)(2906002)(8676002)(36756003)(66556008)(1076003)(66946007)(66476007)(54906003)(110136005)(44832011)(478600001)(86362001)(41300700001)(6486002)(316002)(107886003)(83380400001)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IfKJhn3K1z+CHVo1nQuOoKJ3rjkpFS5/ay52lpdHHeqRQbTG91uf4rprSzA2?=
 =?us-ascii?Q?uj1m9kV8omeOmwNd+fWVM7VyO72MxSz+y664MVps0mLYlleHGF03r0tf3lYB?=
 =?us-ascii?Q?EyDzFhKp/VbFKVToSVCPyLr/0W0JorTsEPhtaA98kPxByUXlpoV7P7fsNJqI?=
 =?us-ascii?Q?M9wqtHzEp5VGZrIGQfwzRywzjPCDt9H0cctal90+pH8ym4hWylSGPoseYssV?=
 =?us-ascii?Q?TOXtVYrhvCqYvujgpA+2byl3blxYCLOMWUY8OYQJNuCY5qisf3XFoXJGdaN+?=
 =?us-ascii?Q?swAUllpUzBCKoM6vS7bvoDytwLUtXyJ+OHEbf3ftFaclj+XZmfGClhAhWgel?=
 =?us-ascii?Q?DoLCesjyUpBWOXlkPvxGJlUpZvXyI1obfNuBNtcZZgKv55e0eauZBHsirshC?=
 =?us-ascii?Q?l+I/ZBG9ZW3b/x2omwwFpVXwdXUpEYDN32JwU1VwO7/QCx+svtUuIcb+pOY0?=
 =?us-ascii?Q?x1xYlDpcOzgnvIXcrkOgKGbyg91VVEhYoURy57eyoWGB/uVGEG5vYq3Vizxh?=
 =?us-ascii?Q?ksSd+Z6fHdMwnwu1YTpx1CBf8Rwrjy8A+6EFAF2vAYRYn+JtSmCmhXnWQ50A?=
 =?us-ascii?Q?hmUbEVPeB1R0Yf3AN/AVIWRkGhEmpMPmBFr/PNjaNNr6aNq+LpyhvXhIbZrh?=
 =?us-ascii?Q?t3fYUuF3dfuijE0j7R0AIflPJ+HFGh5FscPQ7+3xt+bCbUBwqYG8uuIkOAmE?=
 =?us-ascii?Q?G2xOvAPg35T4e9etK7DP4IVvLaEMXTMdaeFyMnirzzxTM2D4MFll4GMhwbtH?=
 =?us-ascii?Q?hCmpsz1iPBDMwR3rgnzHsj7Ps3z/GVhmAH9HKjR4q0oOs3xR2D87V6gNSGen?=
 =?us-ascii?Q?j8PZBKA1N0VAovJ5Of8Bvge/Xq61gkvm1SwC7fAwtYKCg49pimjbmq1Vqo5h?=
 =?us-ascii?Q?6UAmbphyma9FegXuUIsIgdhJC+ZiCit7xvAyrtKNiyhmeeirIdy2mj2dKjkx?=
 =?us-ascii?Q?hZDANMaHxSS7yZTheQxs453JzOFelovviVJ9hcj1cTQ6ZBzogYW2UpQTTjWS?=
 =?us-ascii?Q?S8dMZFDK+2PyDoNiRa1LGgN+b4do5Ntskhe5Ips2Y0Oja3WQdZux9+TjkxMy?=
 =?us-ascii?Q?5T4+uSwyOtdHjljlWKHLDbKzCYpjQEGjRXDNYbe5FUtWWbzY2SFKeQUY1vDY?=
 =?us-ascii?Q?qjhfV/gS9rl39pz5W35CxuNonXMO8U7e0ZKrrgkXmakZRiumYmUDZf4tUqdI?=
 =?us-ascii?Q?V2p1/J8ENoBJ5L0gMu0xVTRe7PCYhtDy48iWhnRmR9pYtVJhIpSWgb1d15GY?=
 =?us-ascii?Q?Rf1mogTKVPNqsa+DIMnLWj/bdxxqwHgjewqiAl70bCMI3IMHQ8fdDOPmO/+X?=
 =?us-ascii?Q?0BWfnLEFBaUUwIcBvbKfpf34IPbXe6WI4cBiTn7TAxwsQoWi6osI+afLZ58n?=
 =?us-ascii?Q?U/Oz126/jq+MB48CPJ4e15A9FStk2UtRu8TY/fqBvgIq8BB2AJ+DS5JgtYjI?=
 =?us-ascii?Q?TaxMMV2UVyQlt7Rro0NQQTRLsPWxtDr0Pbjdjz1HTTa9w9NwAguxMVq/aEZ1?=
 =?us-ascii?Q?OHOsxAUGVmI6wTxRhoeJ4TKc9t812OofQnmY2ThnMXgMiAVARFVXY+0GhQW2?=
 =?us-ascii?Q?rxi1lsLByI4iGZe/EWFOmul+0AT2hEcXwOoDzSeffcMU8xLMbHNRg0NUpPXa?=
 =?us-ascii?Q?pA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f793a05-aa62-4a78-5b8b-08da81351b60
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:11.9989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: waJvisb9La8gqLDllD7SeXv3F7E5YdnS4whZJVR40IqQF0Aq7HMGXQjmt8HbNOcmS4SKt+pOaLWvjT4xOVhMIw==
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

mac_priv_s->enable() and ->disable() are always called with
a comm_mode of COMM_MODE_RX_AND_TX. Remove this parameter, and refactor
the macs appropriately.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
Tested-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 20 ++++++-------------
 .../net/ethernet/freescale/fman/fman_dtsec.h  |  4 ++--
 .../net/ethernet/freescale/fman/fman_memac.c  | 16 ++++-----------
 .../net/ethernet/freescale/fman/fman_memac.h  |  4 ++--
 .../net/ethernet/freescale/fman/fman_tgec.c   | 14 ++++---------
 .../net/ethernet/freescale/fman/fman_tgec.h   |  4 ++--
 drivers/net/ethernet/freescale/fman/mac.c     |  8 ++++----
 7 files changed, 24 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index a39d57347d59..167843941fa4 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -879,7 +879,7 @@ static void graceful_stop(struct fman_mac *dtsec, enum comm_mode mode)
 	}
 }
 
-int dtsec_enable(struct fman_mac *dtsec, enum comm_mode mode)
+int dtsec_enable(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -889,20 +889,16 @@ int dtsec_enable(struct fman_mac *dtsec, enum comm_mode mode)
 
 	/* Enable */
 	tmp = ioread32be(&regs->maccfg1);
-	if (mode & COMM_MODE_RX)
-		tmp |= MACCFG1_RX_EN;
-	if (mode & COMM_MODE_TX)
-		tmp |= MACCFG1_TX_EN;
-
+	tmp |= MACCFG1_RX_EN | MACCFG1_TX_EN;
 	iowrite32be(tmp, &regs->maccfg1);
 
 	/* Graceful start - clear the graceful Rx/Tx stop bit */
-	graceful_start(dtsec, mode);
+	graceful_start(dtsec, COMM_MODE_RX_AND_TX);
 
 	return 0;
 }
 
-int dtsec_disable(struct fman_mac *dtsec, enum comm_mode mode)
+int dtsec_disable(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -911,14 +907,10 @@ int dtsec_disable(struct fman_mac *dtsec, enum comm_mode mode)
 		return -EINVAL;
 
 	/* Graceful stop - Assert the graceful Rx/Tx stop bit */
-	graceful_stop(dtsec, mode);
+	graceful_stop(dtsec, COMM_MODE_RX_AND_TX);
 
 	tmp = ioread32be(&regs->maccfg1);
-	if (mode & COMM_MODE_RX)
-		tmp &= ~MACCFG1_RX_EN;
-	if (mode & COMM_MODE_TX)
-		tmp &= ~MACCFG1_TX_EN;
-
+	tmp &= ~(MACCFG1_RX_EN | MACCFG1_TX_EN);
 	iowrite32be(tmp, &regs->maccfg1);
 
 	return 0;
diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.h b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
index 3c26b97f8ced..f072cdc560ba 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
@@ -16,8 +16,8 @@ int dtsec_adjust_link(struct fman_mac *dtsec,
 int dtsec_restart_autoneg(struct fman_mac *dtsec);
 int dtsec_cfg_max_frame_len(struct fman_mac *dtsec, u16 new_val);
 int dtsec_cfg_pad_and_crc(struct fman_mac *dtsec, bool new_val);
-int dtsec_enable(struct fman_mac *dtsec, enum comm_mode mode);
-int dtsec_disable(struct fman_mac *dtsec, enum comm_mode mode);
+int dtsec_enable(struct fman_mac *dtsec);
+int dtsec_disable(struct fman_mac *dtsec);
 int dtsec_init(struct fman_mac *dtsec);
 int dtsec_free(struct fman_mac *dtsec);
 int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en);
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index d47e5d282143..c34da49aed31 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -685,7 +685,7 @@ static bool is_init_done(struct memac_cfg *memac_drv_params)
 	return false;
 }
 
-int memac_enable(struct fman_mac *memac, enum comm_mode mode)
+int memac_enable(struct fman_mac *memac)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -694,17 +694,13 @@ int memac_enable(struct fman_mac *memac, enum comm_mode mode)
 		return -EINVAL;
 
 	tmp = ioread32be(&regs->command_config);
-	if (mode & COMM_MODE_RX)
-		tmp |= CMD_CFG_RX_EN;
-	if (mode & COMM_MODE_TX)
-		tmp |= CMD_CFG_TX_EN;
-
+	tmp |= CMD_CFG_RX_EN | CMD_CFG_TX_EN;
 	iowrite32be(tmp, &regs->command_config);
 
 	return 0;
 }
 
-int memac_disable(struct fman_mac *memac, enum comm_mode mode)
+int memac_disable(struct fman_mac *memac)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -713,11 +709,7 @@ int memac_disable(struct fman_mac *memac, enum comm_mode mode)
 		return -EINVAL;
 
 	tmp = ioread32be(&regs->command_config);
-	if (mode & COMM_MODE_RX)
-		tmp &= ~CMD_CFG_RX_EN;
-	if (mode & COMM_MODE_TX)
-		tmp &= ~CMD_CFG_TX_EN;
-
+	tmp &= ~(CMD_CFG_RX_EN | CMD_CFG_TX_EN);
 	iowrite32be(tmp, &regs->command_config);
 
 	return 0;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.h b/drivers/net/ethernet/freescale/fman/fman_memac.h
index 702df2aa43f9..535ecd2b2ab4 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.h
@@ -19,8 +19,8 @@ int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val);
 int memac_cfg_reset_on_init(struct fman_mac *memac, bool enable);
 int memac_cfg_fixed_link(struct fman_mac *memac,
 			 struct fixed_phy_status *fixed_link);
-int memac_enable(struct fman_mac *memac, enum comm_mode mode);
-int memac_disable(struct fman_mac *memac, enum comm_mode mode);
+int memac_enable(struct fman_mac *memac);
+int memac_disable(struct fman_mac *memac);
 int memac_init(struct fman_mac *memac);
 int memac_free(struct fman_mac *memac);
 int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en);
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index a3c6576dd99d..2b38d22c863d 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -392,7 +392,7 @@ static bool is_init_done(struct tgec_cfg *cfg)
 	return false;
 }
 
-int tgec_enable(struct fman_mac *tgec, enum comm_mode mode)
+int tgec_enable(struct fman_mac *tgec)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -401,16 +401,13 @@ int tgec_enable(struct fman_mac *tgec, enum comm_mode mode)
 		return -EINVAL;
 
 	tmp = ioread32be(&regs->command_config);
-	if (mode & COMM_MODE_RX)
-		tmp |= CMD_CFG_RX_EN;
-	if (mode & COMM_MODE_TX)
-		tmp |= CMD_CFG_TX_EN;
+	tmp |= CMD_CFG_RX_EN | CMD_CFG_TX_EN;
 	iowrite32be(tmp, &regs->command_config);
 
 	return 0;
 }
 
-int tgec_disable(struct fman_mac *tgec, enum comm_mode mode)
+int tgec_disable(struct fman_mac *tgec)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -419,10 +416,7 @@ int tgec_disable(struct fman_mac *tgec, enum comm_mode mode)
 		return -EINVAL;
 
 	tmp = ioread32be(&regs->command_config);
-	if (mode & COMM_MODE_RX)
-		tmp &= ~CMD_CFG_RX_EN;
-	if (mode & COMM_MODE_TX)
-		tmp &= ~CMD_CFG_TX_EN;
+	tmp &= ~(CMD_CFG_RX_EN | CMD_CFG_TX_EN);
 	iowrite32be(tmp, &regs->command_config);
 
 	return 0;
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.h b/drivers/net/ethernet/freescale/fman/fman_tgec.h
index 8df90054495c..5b256758cbec 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.h
@@ -12,8 +12,8 @@ struct fman_mac *tgec_config(struct fman_mac_params *params);
 int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val);
 int tgec_modify_mac_address(struct fman_mac *tgec, const enet_addr_t *enet_addr);
 int tgec_cfg_max_frame_len(struct fman_mac *tgec, u16 new_val);
-int tgec_enable(struct fman_mac *tgec, enum comm_mode mode);
-int tgec_disable(struct fman_mac *tgec, enum comm_mode mode);
+int tgec_enable(struct fman_mac *tgec);
+int tgec_disable(struct fman_mac *tgec);
 int tgec_init(struct fman_mac *tgec);
 int tgec_free(struct fman_mac *tgec);
 int tgec_accept_rx_pause_frames(struct fman_mac *tgec, bool en);
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 2b3c6cbefef6..a8d521760ffc 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -40,8 +40,8 @@ struct mac_priv_s {
 	u16				speed;
 	u16				max_speed;
 
-	int (*enable)(struct fman_mac *mac_dev, enum comm_mode mode);
-	int (*disable)(struct fman_mac *mac_dev, enum comm_mode mode);
+	int (*enable)(struct fman_mac *mac_dev);
+	int (*disable)(struct fman_mac *mac_dev);
 };
 
 struct mac_address {
@@ -247,7 +247,7 @@ static int start(struct mac_device *mac_dev)
 	struct phy_device *phy_dev = mac_dev->phy_dev;
 	struct mac_priv_s *priv = mac_dev->priv;
 
-	err = priv->enable(mac_dev->fman_mac, COMM_MODE_RX_AND_TX);
+	err = priv->enable(mac_dev->fman_mac);
 	if (!err && phy_dev)
 		phy_start(phy_dev);
 
@@ -261,7 +261,7 @@ static int stop(struct mac_device *mac_dev)
 	if (mac_dev->phy_dev)
 		phy_stop(mac_dev->phy_dev);
 
-	return priv->disable(mac_dev->fman_mac, COMM_MODE_RX_AND_TX);
+	return priv->disable(mac_dev->fman_mac);
 }
 
 static int set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
-- 
2.35.1.1320.gc452695387.dirty

