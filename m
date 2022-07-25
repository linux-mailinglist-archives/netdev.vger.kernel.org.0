Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB1B580135
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbiGYPLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235679AbiGYPLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:11:07 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10078.outbound.protection.outlook.com [40.107.1.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834F9DF11;
        Mon, 25 Jul 2022 08:11:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYatifGoqMtnlMxi0s2IZct3O95m6wUdneqWgsB5An53oAspJ2YVo2uibtBR+uEMcXP92kSuwfpW/olJCGc8LCv7C3xg11nVkzs6BQ98EODwKFXKJ5RkjuwDrA0cSb4YyFxaNhEDQ3Rkd/x0hiI6E3ey1fbK4pFeI1ebMZyyZtIs9LqwkCnCgOI1gOVK2QQ6gtMHuEkcXxG6hHWUmezT0uUWG/n4O5ftnXrkibGjk+szcxllgwcZyRBmzrZNOvrW5dYvLDrP3AcQM2hsVnIHSDBFqWjhaSO4o/INTBthk7VvTuf/gKCiWopQBOM+pxGOQBZPkHut1eh0fMV30gSYRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxl5ypHVF2yTjwLwhCMIKk+7ahbMUu0knhMwR6YqOck=;
 b=lafAiOh3r5TqZPVW123ldK4bgNFLY/6bpDZcF4ZZFYGTOiR7s56Yara47m2NelZvyFKPJu89qy/rLPgw7cepJVDHiryLma4YjyFgYZNnSZrm7SRHQMpw8iIJ3m7kBlHbwXnDQ24XL9y7brR+Vwx/wTndESGOTdbjCrfT5KTAQx4xOY8SsK0KJugLPD13BfNIjYIW6Sel0/lQl0N4hQ2H/to9yCHLlBRhdwDbJV7s7hWC/47EShW5lqY+e6NvRLv5c0CkTEj5FPDH+YCXmf/dCwCpIk6lzkIR22hlA3CaeFo4ju4qGbg450PkVOA/FExTIV8KaQBsjH5OL5mnF2fdHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxl5ypHVF2yTjwLwhCMIKk+7ahbMUu0knhMwR6YqOck=;
 b=yAdJkoUW3YrbWfMzxB5bMb9yAmcxOTRwLeuSvSaHT5HzQDw9TH+oIvRWBQj46mq/k1C9hA6MlGLsKzWC9rArMQtfwlK6BeOIU8XxnMKt9L84WCJC6YtWXB8EGnRblAR3x9uQP6B4VdeRXOnQQeW9L7Qozwwik9MZxaatF0xf1wmkXpp9EGmv2WL/hci48Vh90NT2NxaJX9JQfN1zkOAwuVyppDxF0to6RUDelorCDuYFljcndO7wHVR78KxQulbgcbISxN72pHS1eG6BGue07RL0usNO391tPBcN7Ec/jGzMRpecv7JkrdVr4Wwg0nqcfw9d2Q7ryE51e8Qw6V5U7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB7817.eurprd03.prod.outlook.com (2603:10a6:20b:415::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:11:03 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:03 +0000
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
Subject: [PATCH v4 03/25] net: fman: Don't pass comm_mode to enable/disable
Date:   Mon, 25 Jul 2022 11:10:17 -0400
Message-Id: <20220725151039.2581576-4-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2b6b1b73-b9f7-4a8c-b0c4-08da6e4fe3e5
X-MS-TrafficTypeDiagnostic: AM9PR03MB7817:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cvb87LqvSTY4ZHwG+FtXxDRiGRe6amNoKZRScJ4CqNUFoLJ0NuClTGHXBf4shBh2BKYq/uO7zlO+1K9J4lA9la15pwZDQNXCiT+Hf22XhjpUo7eYQreUK0grxTmHms66kCa6ITdrAvFhoFKgT059882wkt64O5mQnDiwC2s0j8uz+oQ6piJ55HHWlNk3+eUoMNZX2RtTBnaCX8+jDbidnYh2uQde0iLbpRdya7KP6GslQOvMa507FUTnmQB1BjEzO5aeiTCs7JTOnMScUDPhL0wLMpQw8WdNGyBPiE+PHCxCOaCkKd6AqbSR4oR+MoP5jiTxREj2eNUT3T0W76RDakUMyCdQAiPAMC/Cey/rRtUoEcJsuzAIuP/Ifr8Zb0e+1rfR90ZU1UtzTk7lyy8KVt6TAjmclpcodRMFLnEXtafU5BlTyRre1w8pzwNgxkrmuzmIfFPYzmtofGudzoPqieQXEg4riuUVMijh8YEPbFUn0K8FqJhQfrVhrUJWJeZMtif7EKzlE8aP8U10ua1wigEVO5PZxpwENe24c1eEoSDi8DL+OJfVkEWW5xoR5RV7Qx9+apJ30gVpbeAANLclwm/VEPnxDq0Mj2mIg1WqfrPBMR7SL5Q4CbTaikZcnQjgnlttoXvt/iPgm512jSK1BsjQcuxNcj6rBStbfObXQRbkXwKzd4hWzFs2199hSG784+x1B6TqflV+QD4YsSj7eO5XOeh5LsVJk2HPkHF6IQoCc3x8nRLuT9GO8hs9QX5+98vmwa5H8/UDcKxAp6GNkkJhk2UexXMG7Aimyf5cUX8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(6666004)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(26005)(6512007)(52116002)(107886003)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T/DbuLZisGfNhi58UGTdny1lvcxufvI2zeFKuhDRK84/552fwpdBe6qMAEPu?=
 =?us-ascii?Q?X2UVng9tcOvU+e7LnCi3SoP47kDMKtkIsWVIy65be+Xg1mdqC6x4gB5H6+gi?=
 =?us-ascii?Q?z9uwFH+N0t3IXOnRkyakyOjNJ75QNsVf4gtk6zBk1CcWyl3l9ITAYUujAjOm?=
 =?us-ascii?Q?Lkl2ob0Nm3QXeOGELt1Nf2lHwacwucKIuTCyzjtxEDD1Znw0PJRF5z4GZIf7?=
 =?us-ascii?Q?cqkISQz73TbmqnyvLGgoHD++S64QW/H8EV+sMr1Gob2a60U5onQ4McnW2ALa?=
 =?us-ascii?Q?J7aJKMZ0tzCUZt7NrOfNnE82NoFdVvrKnNXNGtAa3GJG5629MTwIlNZEO1BH?=
 =?us-ascii?Q?6zh82LyL5yj5843CHwPQDjUq9S9Xv38sYWlixyLQ4XNHoJt8r7aDtwNPFAHJ?=
 =?us-ascii?Q?OX6whRuSBxoCdxxIxG2GdV+ArEffvf7Nnao+h088RUVdMmU1olLXBllFUnfO?=
 =?us-ascii?Q?i4RL9V+wsJk59msv+aern5U+k8FNqQvrnRiMr6pmnVqelMykzDUZcO7HmJKs?=
 =?us-ascii?Q?jhx8lMv4DfKRHAR/MqFMDz6zp1j9tz9FB7wQaVapwGV2AZeGLGNLDwSG76R3?=
 =?us-ascii?Q?J4UNq1kuAEktGekuVXIm79Naxb89nVdWPWMQxTpRdiB7l/QE1gGZKfJpk7vX?=
 =?us-ascii?Q?UTuoZWa/zakXVRqVBFN51/9sHaCBVClWf1bLERtYb8bn9SgDdhmmxAwS2L6y?=
 =?us-ascii?Q?WaeZYFI7+W+jZYa/sHKqRz+lmGw7QC6nH9eaHdOa8uoQit4wEZrlNzWdvRHS?=
 =?us-ascii?Q?yedI4oYcXukDu9TDgnEegztLAMgQAl00I3rNGO89ESKon+LXNYLdfhk+qdze?=
 =?us-ascii?Q?IFXTlTJhbjrQRIT2d7AKUb4pF1XIF7oN//NRXKEjUJ+l8OjRDVvoah8OmpO6?=
 =?us-ascii?Q?6lswM9PFfrOfTBJLWnK8o0KSawu00YqPayDZJ0JlZw8AkgscPb3GwLer6ygf?=
 =?us-ascii?Q?DTjkK3rUdX8SGltK6fgc++ckWzAQMPp835iOJtsciF4LDlWlJ3i+gIZkIijT?=
 =?us-ascii?Q?ktC5nFreEUmtTB7I1Byuxz2tKNExB6QibWyUV2fKIvvOdB1/2XZBoxI+zIdM?=
 =?us-ascii?Q?K/CYFqaKnqG9opeKmB2vboq3L+xoF12P32LOwfudNYJgc/DHA/zWwRa2EZuP?=
 =?us-ascii?Q?NBX73sLWrh9ZUbqmD842NKPee7RNppj+LFlXI/vi37EI8yhw37/YnRINhiQx?=
 =?us-ascii?Q?BhKtmyK1viVuSyqJODbjzvF0pc2aCdCZJAUzH8kZLjylsEZbXTLFD4iU0/wu?=
 =?us-ascii?Q?0iO1ofHrEPt7TtlOvnSrEcdGUQojLmQtRv6W9YopuzlX00iJ3OJOtjZdhmeq?=
 =?us-ascii?Q?uxsFc4nnnLFoNcsNpWFP+PFszqLSJyyt2peqvYR5BiCvzNZ6DBKkvfEzC2iQ?=
 =?us-ascii?Q?2DpRfD2ZW6/dC66Q/MIYPkwjp6giHdERvy/7HyJBv/xzMOTQ6wb74HdoJ8ll?=
 =?us-ascii?Q?0QdY+MLcIdyPQWfJqt8le/3CI/3yvxPwT1upYp84EX+/GU0mDzTf6EtI07Q3?=
 =?us-ascii?Q?9AmwZNfNtZBo+jw8p+tpkI1y4KvgON9E3CznVdoh705uTZkPxkBRUmDAYJbp?=
 =?us-ascii?Q?6LexcQ3UZptatBB4AEp6maWYFkkzcwSQB0QUBk+sL1vCu/mcrTm3fIxgvD/v?=
 =?us-ascii?Q?rw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b6b1b73-b9f7-4a8c-b0c4-08da6e4fe3e5
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:03.2861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BOvJ2BQ7P75h/EieoJWyzLo3+dL7bRw1sQ+oSfznG/oDKxW0o1CBbNG+E+3yBDc2/rfWvzRlpYi8Soai9mFdvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7817
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

