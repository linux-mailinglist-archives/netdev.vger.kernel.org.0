Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67AB853976C
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 21:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347522AbiEaT7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 15:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238617AbiEaT7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 15:59:07 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2052.outbound.protection.outlook.com [40.107.22.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605EA60059;
        Tue, 31 May 2022 12:59:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ub/VwAhZ6JAWjDQ6PBZej4XClSJgfufvEsIKPxpUV7S/6+yZYwTdsPhrA5aJ5yqEOd6HR+iKvmAuORfbyO8mzFbQeSexIIdht2TBHMe9jeBJkAXdW7K84otSKIIQFJoZZ+oZjsdc4c3FPoysXcvQW549AxzAZfYm/Ivg0IQCqanCHPVlSmDHRzRmRKKWz4tR5L8uRffLzaZG6XopL8rhV/k37Ish7tvHH+L8b9NuJMYkbbDDebFtWncBTndZmUIh/3ktfa7yNqPbWfGO4KjO+V5bUgc1LPRpQJRiK4kOHDKUljOKqgifCcBJiyw2MztEg81faQB5jx04Kx3pVptF2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B5mH/UZ1qBnxqfYc2zkN13wFTSzi95vmeuby34wjWq4=;
 b=aazz7SPRvxlWfN2mhd8pLxLodg3ACnxc8ZJSbkHJT84lF/PGqr7elqzIy/1l+isJZWIC2SCcCmbSlxjp9HyvdRdrb8+E9xBiu8vHZEZF3MfEioEb+kdA8mbtVkFxZX5SW7gKAsq9hPIG7QZ56Pf2m9YSVbThu44ZGorWhBJ1Qcg8hx5ZdLKKQN5U/RCXtJBerK3sY78NSr3WndhUpZziZyX9y4wSLOlfKCImwnU/s8InwVqSjM087YzjH8f7iLvzwurTSXCBcPqvkC9bfYXVilgs3v9TUBhRNTGJCpAy5JY1S5VLTbB6kjFrYwlfb8coW0WvHge7glRm/KxerQfb1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B5mH/UZ1qBnxqfYc2zkN13wFTSzi95vmeuby34wjWq4=;
 b=w+M/5U5IqdMWXZ12TOl55YxDdcfbwHle7s18f29VZ0fsbZ9duzha5hYCS1oDw9kOyw1EQR998VlBMhG/lDhfGCtq5HqULNMOmcn9L4j2qafaSd+luLZ4kMfdzjPsuWYvYKazf0WR1G8ku2b0SvSwz1rqsXkRbvUB0hgWDQ+777BJWZbHdlxovdEPGfNHJRwc7mbGUHebr04ht/f4tfeb+q+OaLfFUUkGC2X3R+icPBRlOEBpWAmV/RLrT5D5k5qcZlk2ssvMeg5CgOVyamNEMnV9NJEOEN+9v0TwNZy1YFNhQrLAtIdy8H1JGLXkyrLOECM6sbTEOfT0ft4HALz+0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PA4PR03MB7309.eurprd03.prod.outlook.com (2603:10a6:102:102::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Tue, 31 May
 2022 19:59:04 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::c84e:a022:78f4:a3cf]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::c84e:a022:78f4:a3cf%6]) with mapi id 15.20.5293.019; Tue, 31 May 2022
 19:59:04 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 2/4] net: fman: Don't pass comm_mode to enable/disable
Date:   Tue, 31 May 2022 15:58:48 -0400
Message-Id: <20220531195851.1592220-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220531195851.1592220-1-sean.anderson@seco.com>
References: <20220531195851.1592220-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0113.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::28) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04dffae2-2f4b-4d32-8b6d-08da43400389
X-MS-TrafficTypeDiagnostic: PA4PR03MB7309:EE_
X-Microsoft-Antispam-PRVS: <PA4PR03MB730968CDF6327A84B6A740C196DC9@PA4PR03MB7309.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D9m/WS+PtahWi7asTli5qPBgxH8MtK0bEJaKhN+KUsYus4sHgXYM5NPNMO1c8BzuPeXRunnxbVjTGW6UUQqRhSkXwU9a/lqowIrujyIh3zKSKLHtxi1d1gcndBciv56zdzvNqy/0BYswj/NJLcFJhbDq3KHpjp/eD+JY9iNV3Yvk9BxTfoN56d7KWMGAvOe9LcBc3IgHyDDgfRdN5I5FAPT0xIKNofc6uh45eI4Y2h0EF9/TmOtW2DGptvyTJmmwS+WL3r9dQt/3tx1+wVoJQsp0DgoN7qe/Qq2xpZs87c2IJ6FUK1s1wWY2ialTSiA3VrzlJRFmwfubC8XI2axFpVHdJ8rVstx5AhWgYw1pD06A7l4oB08yUG4dUCUlDPh6n3VDq4GyDuTUu/8y30BRn56W89fAwUL1hlhH3LzAPqbl4YU5t0k339V6aMGUNIR89aIVaWLBJ8UamahiRXtu+2dCiuePJpkgrPzE79G8+DhCy3yQdntVso7zY8ztysegQmwLfRqc31KFIfVZ9FOzEeyQ2DHIyFv06upVkjWBKuXi/JuAHuUwuNLuiui6Hk0XeKV1vWjvLhvFk+a+GfnUk8GIbANQgj0c/BrzdxjFp/8r9a9gqQ9H2F3y9FvVXM8g5pQrc0ixjjerCk2+w1Wa79fEfJR7yViErHRT6bNROhowlvWMxEkf7KomVVrXP/zV6byOzEpamOoqGZzwRX/0gpYyF8TC3D5aDwsSW6YEhTl5yN2wNKhPah3yBEEsTcHa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(186003)(1076003)(107886003)(2616005)(38350700002)(110136005)(54906003)(36756003)(316002)(4326008)(8676002)(66476007)(66556008)(66946007)(83380400001)(8936002)(508600001)(6506007)(86362001)(6486002)(52116002)(44832011)(5660300002)(6512007)(26005)(6666004)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W9PqKwgmXD5aC8T7KuD2tZwdkiGb42IcAyAl9Gw6N9tZLNyE9nUTAZvbAsGf?=
 =?us-ascii?Q?XzhnY6VbZ78hdfZ/vo59TZDTraBQaA/TR8cNLOa+sF6N+7Ys46AU5ql2fI1o?=
 =?us-ascii?Q?C/RgWi//cf71WDsDZ7Poav48VUbZ2v5bFanq58XVULGs1Py1fyWgiGxxCZ03?=
 =?us-ascii?Q?WXzAZnyvgNJqWDs5s9wejAR1qlbXEFxZU1rMD5SP1wdnpUcrNxIuVp3PVgUV?=
 =?us-ascii?Q?pXYQfAdXGclwB8rQ/5YIBiOCGrwT39swl899Sa7elxtEvIrXcvrpmiCcc5X+?=
 =?us-ascii?Q?u8udFe0lYrBPUtoDCoAn9KKjngIhjjkObfdNbaOC2X33H2O6kydlWbrSeyVc?=
 =?us-ascii?Q?LY442whUx/3vQzfnh6PfD39wW0J2qkcqQC8wlfkKeLbqBNrEI0xA3MdyG/aX?=
 =?us-ascii?Q?OStQkfu/UzK6qpNoPT6sYyRQ37a5dja3DjcJvJ729/ZiYj6qx9TGLeygUKUG?=
 =?us-ascii?Q?5efIWMXNXd+FOuXBAww8zn+0ta0DyIRX3tSF/5EXLR4l0IeyHdhufO5vcxeW?=
 =?us-ascii?Q?OTjkq/dVx4KCItCXwy+QEMtWnoHbR+prBIMVP3Zs6BE2tPvt9bMcevrwuquY?=
 =?us-ascii?Q?e5O3n58E7bjV9A1z5LnmDCADJkp+2Ru0tV2qHKU+5ieognhl5KvehsH1vF/j?=
 =?us-ascii?Q?o9+4NhpQ3GNIbK8QfE30vw9MOIyfftsavGkKlcB9KtZrcj5tvJgAU/RESRD9?=
 =?us-ascii?Q?Sz5GTaJJzpPcgXwgKGH9wb0sxwV+x2RotrAz+kcmZpHblkRYycOm980Vxh+x?=
 =?us-ascii?Q?QHyY/iwAeNd7dbd541NF48dn/7UP8vwFqohuVE1AsKhkd+Jl6fO3xNQcRl8K?=
 =?us-ascii?Q?Vw8WntnaM/fuRP2wTvhGrtkaF0juwh/azbZ1q3SkWTVKAZquitDBl52YLIff?=
 =?us-ascii?Q?FLkXqrKmOMXcODb5F4TTBqySPpCH5Z7I5E0p2zwfDAQzQXwl6oQyEew8xeln?=
 =?us-ascii?Q?TCdxaCw9Bb6kYMzZMN+JdGjNHjku+lskCUiQJkjCXbmGCVtBmdfB5tC/s3QQ?=
 =?us-ascii?Q?1rbRu1+nyU+OiHDeJ7YQ5seppFeob2ONxxAW8vsBGs5Y4K+tyjGeWcQSiKYC?=
 =?us-ascii?Q?OlfAzCSPZECvS9MNcBMbeAySz1Ha9OV+g1AXRITvyd37OEhAJmI/+8roFzpH?=
 =?us-ascii?Q?hTi26z7ZcLWB8yCLHn0hasddWQ5kfBJft4TwqJubyP1ewbroXcTIyktNemBT?=
 =?us-ascii?Q?X96yt8/4QWB9v7cw3mmB+D2S9KnSirY+oroWxlf3LNRBmCC+0HHeDkj5O64+?=
 =?us-ascii?Q?YN1lhFVqICWabNEoV8pXlAP8JTsgDl9zdPi4bDydu3wKaE7IqkUQMNaMFAMf?=
 =?us-ascii?Q?qDVbCjxKRziS2S7E7ZebwRhUMqhBg9JmcYTI9gV8TmPhene0a3+m2Jtomuen?=
 =?us-ascii?Q?qraGZVH06LVF083NYzObtbOBRZM4dQAZxUhwZQHyw5Z8Q0FodsmkEdF+XFge?=
 =?us-ascii?Q?1AJM3GQUtFx4IjU1mFEYp71qEp+TQ2bOxvXF3TxR6hRRLKhk+qUuaF+xhYJO?=
 =?us-ascii?Q?PKdzV2zz6YgK/JNfWCpXHWxRigp1/kf5HJUsg48Y0fPU7HVW62TV/UmpZpde?=
 =?us-ascii?Q?CyhfB6zV6MUFIDZlhjyeZptMN+alef8lLjGU8ivXe3mVniXdHTNxEKYovliK?=
 =?us-ascii?Q?UlHrDBbb5WLg33HNnY18TW8k1FXi6ZE0Dp9MgefaFw8wKEx18E24e8Zrw1gL?=
 =?us-ascii?Q?SWvn+i857hpQt5NME6cxNNLFBujD/8pq58iMM/YXVAC7jZrPZkhHJZxg2NZI?=
 =?us-ascii?Q?6wUNlqkH9GTu3Y5z8tdzqp050C4Khn4=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04dffae2-2f4b-4d32-8b6d-08da43400389
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 19:59:04.5003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rX/zQvwufTY/jzAVASZSIYqAuUJZC4kxtDaVH6VPvszf6v2fKUrz6wBHKAg2qEvbUFk1wHSVoTJmw86T4nmlnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7309
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mac_priv_s->enable() and ->disable() are always called with
a comm_mode of COMM_MODE_RX_AND_TX. Remove this parameter, and refactor
the macs appropriately.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 20 ++++++-------------
 .../net/ethernet/freescale/fman/fman_dtsec.h  |  4 ++--
 .../net/ethernet/freescale/fman/fman_memac.c  | 16 ++++-----------
 .../net/ethernet/freescale/fman/fman_memac.h  |  4 ++--
 .../net/ethernet/freescale/fman/fman_tgec.c   | 14 ++++---------
 .../net/ethernet/freescale/fman/fman_tgec.h   |  4 ++--
 drivers/net/ethernet/freescale/fman/mac.c     |  8 ++++----
 7 files changed, 24 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 38badacfdada..cebdbdd0ce59 100644
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
index 86f3b74ada03..0dd74972b112 100644
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
index 8b2b4fb411ec..de533d13e20b 100644
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
index e1d62a7df367..4cb9db12de0a 100644
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
index 49930a5f2991..04a19cbe08a8 100644
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
index 3b4ecde09bba..16d53f8dbcb1 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.h
@@ -12,8 +12,8 @@ struct fman_mac *tgec_config(struct fman_mac_params *params);
 int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val);
 int tgec_modify_mac_address(struct fman_mac *tgec, enet_addr_t *enet_addr);
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

