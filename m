Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29C855F14A
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiF1WPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiF1WOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:14:53 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E72377C6;
        Tue, 28 Jun 2022 15:14:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHrFn2zUNznVdkr/QnmQxGNeL0J7psBJ2Epvrda1X5QyDoALtSXrlEO8lR45HWy6ySUaw5zWC70PEIb3Nuj2lLkRIGx1OvWHWisQS/CIfTvY6Yl1kG0iQaj+3J5ffG3sQ9sNU7Ayss2NRw+HCnhPRlhD/ZZHLOE/aK/u0u370DFztKDtjWfDYzmkSD/gnehRe+6Y5z+t8hs9fPBcQ6hqqVhNnUnogwuQsq78Hnau85pbXFbit/nnQyDQBoQHihaZRrfQRzZi9D39+zp3oBLQ+yWY66mHqSNZ4lnGhIOiPANnm2Fda8pfWCQwJKFQt6FU0QvxA6GH2hHxDVOC5fhQTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxl5ypHVF2yTjwLwhCMIKk+7ahbMUu0knhMwR6YqOck=;
 b=RIKFTP3lUYZNtwD8dip8UWEVJMBojri0p+sjaqbtYoMbyr990qfeibEGjOLHyJVIZ7VLfMqDf6XQR6TzI7L+8GuAt+QDt15PDpDd3lEvQJ1y+bcZ3FDjJdvV8TBjHtNJJGBvVU/VXQN1f3ORuvIYWqir6G9t6y32c8NVBmqDomVWE8YkMKEwtl+9IjyVxI9Z+mz86fELNxaGsNGRva1XRQgO/525tbw5arWRS/9icewvbNjlu1VJuS1rgK5zrIDCc2IzUqZx5FeZWWddZjBn14VGwEah6yqwUdit97zVOPVzFgSlUaYnKGVZh6RlCjt3jsy7gTnoQoTGynQ4a7lwpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxl5ypHVF2yTjwLwhCMIKk+7ahbMUu0knhMwR6YqOck=;
 b=JpEK6C9TZdqzhIcO/6ZaIYNdqPcwGENnqLTJWceCabVIklnkiLrdsNvKjy9ttXf6CQS12BE61x/pLkwNvl0xBq6zqnwyojJevRkfmqrJENzWX6LuXEL8B65x+oq9fkKgxrgRlBI6Kzhd3cs5v2PmWejUni3rrPJq3tXbpDPvzwaNyRsv19nwCrWemZ6qrLITgDSeWHQwzHW2Zis0MrgmvzHP7eXsA8YmM7UM7qdQXV80nrKeEubUgHXKvVYAwFSu+eh15hVMsMBTxvc7e2fOjpnr4MwoxCdOjzxrtvflm92ZRBpNZn0/4CHRF8ujiE3ypOf9MI82/EMclFi2maW6+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7399.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:29 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:29 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next v2 06/35] net: fman: Don't pass comm_mode to enable/disable
Date:   Tue, 28 Jun 2022 18:13:35 -0400
Message-Id: <20220628221404.1444200-7-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b42182f-843a-4072-c8fc-08da59539210
X-MS-TrafficTypeDiagnostic: AS8PR03MB7399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wr9YzFBjG0z9mddzj7DU5z6s4rTdMT9FQHNbbTR0g86zhQVKFAtRxOI8aWmXxMVHSABOIxL/CKNb8f0neLTlGloecCRgGkTdN8yc3n1cVRy9j0ifN7TmJoiXOAyf2nkkq8AlcxBlMlsnoFwKbz1LagzZ5FOh0aahfkAUAEHsNwtCXL9IvUrfxAxRLJO/pzIHdqkZPv3b8x+Z7sicAdl6IVCL1Q6M0B/NFBbxTGFu9XZ7XvHy97kN7ifpoOAqOkcbSKjWm+fAXWpje6tTPjelI3YFXLHV2fuPbOgFSkqGdcGoogTCHbmWYfxlYrdZG1l53voohVFygVH4/ULgKK94DnGXwjeOprsg4+xMvByBhRIiRMBw2gRJixbAs51JVsg/bqoMouyhxPyPQ5u+kZuG5KnbNNj5+O6MSxWlQvQedRonmqiQVnSte50z42rxIeIsh+vaR/Kx2d7VTyE6aPdEExKqg1Ga+gq+1BL/SDwPjtn0PYnMHfzC/+7b9ZZ2r7ojk4DGU783yKPZhpaYSWlhji2OqmBOm63YnfB5QcV1je6us7zONT62g9SPaXQQi4a3tJT4ZLbL/5zVq+MOR+jpODVRJrRyNA1k+3ngsPPBrNuDfUTQKclYYLoWSGV/tKqxDySpMarLEa7VUsEgw5noTLmOkMlQs4YoEkeVPUiGHmh5xGQ07V1h3Pz0mfRNjaX4DLyvIOG88/+rYXSPjiF1mC/6R1YSGOl5ec+FoOOcwtLsUE5xxXx61fARxYAcIhNx5o8vM+roHfqmdoXdpR3wre7wCNIOukXvKxgg/hMne5s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(38100700002)(5660300002)(7416002)(44832011)(6512007)(6666004)(186003)(38350700002)(1076003)(83380400001)(86362001)(2906002)(66476007)(8936002)(6486002)(4326008)(41300700001)(8676002)(26005)(52116002)(36756003)(478600001)(66946007)(2616005)(6506007)(316002)(54906003)(66556008)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K20RcOsNu/OXCkSik72rA30wWJiX4uL0i2qbkOIajPqDeKCFt5QrdLmA0UdY?=
 =?us-ascii?Q?0mdQjZzhmx+Cp6VHERT4E1vsMI7UZekI5FDPhDwHT8NM6Q0c+bvr1L4081M1?=
 =?us-ascii?Q?BKT4Whw6K5R4B7fULGSA9yYNoyO5VVqxJiZ3P7z2C2h59ciqIX0pqg3Rp36D?=
 =?us-ascii?Q?oRD0+e3+JdTOHRBBpxp65QsEpJwuTbUf4mg4FhjH9we7OGE6a58NJFgGGIZn?=
 =?us-ascii?Q?pymMFY7JKNUhjShqP80+1j9+BEKliVbaXhydQPHPCdypbUpWR8CstgM7Zx8K?=
 =?us-ascii?Q?L00tTQjPFYKrXDZ9ldSTFTmiGTGIkDfJ7dtA8KZctb6U2wtVucz+BjFn8ysH?=
 =?us-ascii?Q?9WOcVlwe82cOUwtgTJWfv4aon5K0vFdFd7UOcM7CtmQDeBiJ1C8gPMPQVLQe?=
 =?us-ascii?Q?V8Y9Y+PVmLZ5HWroj0xT4zEpmqzFWOot1aEx1D8CMyCg9t+FiJovDre6vv/i?=
 =?us-ascii?Q?5adV+RGgXaNB2kmAx2Dax0ida1gQnpr+1a+yT2vaP5C1jepL10Zw0xmjZ5M/?=
 =?us-ascii?Q?l7fzBkW0Iovmno194DRD5AzC4+NGCcDTU46HGGy5O9UrznRQWiiIaMuzHvWf?=
 =?us-ascii?Q?nmXu/N41SLek0kxchiuYLUPSfpsaYlcnIgaYxc5nl8S/zxexf+ArzPUEaENm?=
 =?us-ascii?Q?ioMCyMnrzpJ4H5znImx2TR7uFGtbhNiZ2B2QveQPgxeY25x5jzMD5jkCHHyB?=
 =?us-ascii?Q?Y9uVUn0kZ/i+QoEaY+0qdR+dyOScPBxFFOExTX53TbFPgjTWx5e21fsYo7+P?=
 =?us-ascii?Q?OhKGEHEiN9ep2O2w2XBjAYCvt84l9SxlsksY4F1Rklh10NzXOWkjqTRYUb/+?=
 =?us-ascii?Q?USFHEG195QZZuAqvi5qWiNM1/dKlGsjP+Bh1eOdKKY8lm05NvW7jRYKR9HK7?=
 =?us-ascii?Q?pUrp9B6crgHTgTJbuTp7kDezGZYdZLsTpuMQ3x2TV/a7w+GcOxbc7sinw8Yf?=
 =?us-ascii?Q?eaaZMRrOVHmcanx7XZtYm6flpc3JAfPFj/+zdnNk8NSw1ViytPJROjKbw8A6?=
 =?us-ascii?Q?4RLfQgGLT4EAFEPed4imGS+mybqD9AbgZtgC5pgR8zV8BuO4fqPt+50K4TAx?=
 =?us-ascii?Q?f0STtjX5oIjg4ZtmKicZWiFULfOBN+MjU4FIm3Os4RmyH/0mcnsnwSYHEYJw?=
 =?us-ascii?Q?nLMgyzfUp2IoMhIxHw+sk9wnk1wO4XfALOt6rbXje+Se4vBJHOowYdt/N6Ln?=
 =?us-ascii?Q?IXHRjL/aLx7Nc+9xmn7B08NFuxl/OkITwKy1j09P59CKx8XFE2ZoJn9Sswtj?=
 =?us-ascii?Q?1sZfxoHUyVeQXaRMCAxfOsogjQq8pAVpv52B4J/1b8gIDWZ+GRSQINsU4rvs?=
 =?us-ascii?Q?AXWtcrMwW8kR87z4nOBAVYPirkCEf3Bc5KC3Pc6GeR/WU4v6Hx6d2V5W3k2x?=
 =?us-ascii?Q?YCfe3Imz4pWO6L3974CpCqLuDuuC7dd8SkZotOghdqh8Wkfnts6+ifwC5My6?=
 =?us-ascii?Q?pWAVA/MRQlXGvNnxxUu6Qf8aPvJuH0G3yxORS6+5utpDxMEZjV1q6hVJ/YuS?=
 =?us-ascii?Q?ow3ymOnVdUv8jSlBvUKF7G1AsKXng2zEsFXVVnyF9r1287JitDFeinGtU9TG?=
 =?us-ascii?Q?IpYo2jmJn3H7f+BlhuS9piT0uQducwmAQ0S0o0WjFNlukDoCW5J6ysUCwsTU?=
 =?us-ascii?Q?Mg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b42182f-843a-4072-c8fc-08da59539210
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:29.5952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3sIHvo97K9/ZExJaQsOBR2+RDEF8FnuSdWJ2BnRsihCpHO3VTwnjD7G+2YSSC5Xv+DzXvfKAZ5g5uqgc/jTS6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7399
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

