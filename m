Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F203576966
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbiGOWDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiGOWBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:01:39 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50084.outbound.protection.outlook.com [40.107.5.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828028C179;
        Fri, 15 Jul 2022 15:00:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QHq2D9SuH5XSWkw7e6qPQWkTJ78fm/SK00ka4sLd6S6Wlt78RXIPKBitbsOfSdd9l63u368WTCchVBkJjJ9iXtXPPREMZ50CzYDq2Djc7iWachVHlq5LgwysWN05YHgzK0ajkE4SaDjdYU1pfSIXR4S1+B9n7MJC46U4t5gNzBKgcAtUxl8FDFLeybdpFg28uKZvR60MEotER71gzZlcja1SXhCpOysbSHkMsnigpS3tcyDqt8l8/IXIX3xVSaS8tiqZEEzBUGc5RkTJrJSTSznDetZ5OO+55XE0xJRM0B9reUcwKB3KLigRpQrkUZJWdJe5bmYcMHQSlM4izXPh5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxl5ypHVF2yTjwLwhCMIKk+7ahbMUu0knhMwR6YqOck=;
 b=eBhUdYOlr1j+mS/tTH64d/PplyFfVMjvCSEKxeEeDiEI5VVv1iwPG20CTAiWXwH90uPNEjLGwpXUfPYE2IbE8rE35H8hP83pZef2QRX4xb3MLmcqe6mqcRMBzo3w1Hgz1tfYCXKvwBjmwCrQ66jGa5RKcY+LPmC+Ex1o4QrYh8bKPwFQZ3j4ZjaSTeXd3sjqKD3QuppeatUSP32zn9vsOuOulprna2WvasRM00aHPLXw5w0QD34gYICIKvypSsxa6VwwOV9LMkt+/qqvSXbY69yMXBP7/HdVctd7WC8oEvB7ZCn7Vj8dAR7NRUFLk1uB0W8DcuSwDgPCyTWZH/6H2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxl5ypHVF2yTjwLwhCMIKk+7ahbMUu0knhMwR6YqOck=;
 b=zh9FFAoJWgEthXj/KRohdW9q9I658AXUy8BafVN85pAUvYP1Iw4fwGlLpRWzUohu16mr5IcimkcSvq0VOigNHFaLkv9VZBjyOqh3bm9tBee35hr4hVYLAjKozi1s1iItgzPWGPHVPxUc+Hg5waRkO+geptpDL04CzqSBnvvHIRDrtbq+ZHDqMIfHzZWiZjZgoUXoQVBt//ls+AvmZ6Uv5o2a3xltsxsWLwyQpebFYRHIHPscxnSRpkmpN1SuiOkxbftN6nFALyfh1ySZiV3VdepIlHxEj+TQhNarQ7X8ScLF+A/JhasIhCc/BbAgul85ISy+grEIyimADiiWbX1+MA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DU0PR03MB8598.eurprd03.prod.outlook.com (2603:10a6:10:3e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Fri, 15 Jul
 2022 22:00:51 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:51 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next v3 16/47] net: fman: Don't pass comm_mode to enable/disable
Date:   Fri, 15 Jul 2022 17:59:23 -0400
Message-Id: <20220715215954.1449214-17-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef859db5-0efe-4823-af92-08da66ad7b26
X-MS-TrafficTypeDiagnostic: DU0PR03MB8598:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AnJnPC12UKimLLWVXOmqmjQlbfY/RSoiW7yy4qk0hVoGmKfKEcQ4B9B4c7sCOyshXHmlZLu0XTDEnmX0e9KTn5vBRsOq5Rcdqe7VALkCwZ8JU2sSpljB6wbyneqt6Mab6jU3lm4PtXNNQPh1B+7afU6Epe8scmSLsn58tjWlVJhNAyBlniYeGdILmh6Gc2jBUz5pG4nN87aYlRG7QofaCu1Hsoc7MuB/rUwYxcCwuMloAehNKobRP18JS8kP9H8mE9O+Knk9Am3jgoyqLHQnfPPiF4wUw93MRVkx8paOwfLq+QCHfIvDOtViDUxvS3veR8SvhqpIRVatOYXBanWjOWJoCYDCk1+yNlCbexF9TZwVc9yqMHGs3OoZraDUx6L5cPT/bb+Y121DCndJgeLNtzbSRPJA0AlMqSALAyBiX9jr+MFahPoBC0bRLnF8RmVbJW1IptfkK4hMoP/cU7B7WCzI4VEdk5HYnCg/vO8y+pQvHe7j/aT2Z1QQk/NN2jY01MjwzMmEoZgxG12pjBQsSHwWLLcuFlB1ksOFhC4gVdkczqGDyPaZbXLzcvCbSTOw9lyQlyC2o7n4YwOY73aQVuO+GZm2y8cKhb7T5EtylqbnImuZlR7v+pB6Dt8hHfsVO6kkO0nPg6crZqyA35y8IjTzW0u4nMDjBiEI32F9XVeei2etuVFMvDOwYfMqEKG3a6WKErXHxwWO0pgbEHXcZcb4Zm6IamFD3sd7Z8sS72yjRXfwCp7FfQw/ItSi+F6A6Qw/wexC8FeDiIrHZLCBxUDHQPKmISzsol07TdqIZIZXS+e5EkUylspxSHSaopfV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39850400004)(376002)(346002)(396003)(5660300002)(8936002)(44832011)(7416002)(2906002)(54906003)(66556008)(4326008)(8676002)(66476007)(66946007)(110136005)(86362001)(316002)(186003)(2616005)(26005)(38350700002)(52116002)(36756003)(6666004)(41300700001)(478600001)(6486002)(1076003)(6506007)(83380400001)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jwJEAE53QShLtU+e8XYxbt3BSoWmIRiBzkESyoZp5+xsF4dgIoS/RNpOcrzD?=
 =?us-ascii?Q?koBiOakqL/rG0Byfm2GAjrOwcGq5ejKXjdKNOqSzlcjPZoJqUp4vkRxPc8Mp?=
 =?us-ascii?Q?MrAENmOuNzKRJGXjko4Nq/b+8fT9g6f16FWjZA/pCURbe6IenQJoqccZPgz7?=
 =?us-ascii?Q?nJ44rh5W+ncpy1y3USPvhpVptCNDQUB4BkuKUAdYW8edf9+wdr9tHnEKC3KO?=
 =?us-ascii?Q?NrK17GVotj+9hHfomPDls/R/K/WP2Ms+5FYMCygW01RQnA4f0pmNPnapAN6a?=
 =?us-ascii?Q?JFrVMRCKjCCn0Y74Sg4TtavpOz7uyKsR1wjSg/NHjuUBIAwe9BA43eKXhDWA?=
 =?us-ascii?Q?IRvGp91OA8VhqyMcyyVz2YlLWicI9q4uGj5If4YZcmGQDB+f9rpDi/nktf9N?=
 =?us-ascii?Q?Wwc9ArS3hXnNzS+1BSZWQsercp0Gg39uoP8LQpmuXrj2HHGt7vpg4KzCWwWu?=
 =?us-ascii?Q?xH4A7UHAgRfczslQqPpoWEPZ/d2eRPGW92tj5cVrWMASd1+zAUWYP1HwUcyx?=
 =?us-ascii?Q?mS5+5xMyGLWU8/7R2osv4tCr7K8EUNZGe7Sj0qZWIdpPgLPQBzEqx5VqYYqZ?=
 =?us-ascii?Q?/xMEK9Z1kovw/PDqo017ekG2H/x/tx8pyXOFkYBiCEDCQcSUjnH6BOtLkcgY?=
 =?us-ascii?Q?xFPhppuM2EZN6ln3zNDJ5dwU2JPR9a64zzSqJayStQPks/V5sENKqNoHoSxj?=
 =?us-ascii?Q?aywc6wNyE+sXw0jhwkN4prP2c22xL1OZyIKyXIGVyJTpRIsPaQstfrHi/m3w?=
 =?us-ascii?Q?GRzrBOQ+lxu0jxGUwsMnBrv/u82/oVW2dY3NcP+1AadbB+KCf9k/mSDMuzvu?=
 =?us-ascii?Q?2QPByI/4trupWRfoO1gKViyILLMlaTOJAHO8cHl0W0KCHdaynCGFtey7wDxr?=
 =?us-ascii?Q?E/hDWnXceSOkjezSW8uzndFuegnbF7Saaw8Z7jzJxy98AxQZBJhyb0Ad7QYG?=
 =?us-ascii?Q?n9Ka+RY/6Lrt5RsYaO/m1YBUKCqbTJmwsMZC00pwYH44kRO54U0RT+kfgAef?=
 =?us-ascii?Q?V1ffL2b6YwgOBH3i4bglohKuOb0SNY9739PgrXBfNrFqVtmsA7RA6HvYQ2YQ?=
 =?us-ascii?Q?IYaHA0mStThdevkP6xOxcdxlEc6vnyAGOYri+y2ycivA16ndAp45CplUaAqg?=
 =?us-ascii?Q?xeDkTVlc0VK/81sX5srAf1XoKUk0eufT182X24czoY//y5hWbJA1UQaJkeKg?=
 =?us-ascii?Q?q+RuG+V37rXDYY/8SKM3yY5F/c4gG8qkjlWH4PeIxH69rU5WDC3UMOJb3GPA?=
 =?us-ascii?Q?Yha/Hxv0XRj8E5LQYFVKuo9PTK4JGNEPoTq5g9km4bUXvslSZZK/wwYyHNwG?=
 =?us-ascii?Q?3mASUSJ2AVlKVSo41NHVeBxw/2Fqfvk805VdH8XmSwX8Uj2dMDMUh3KQv9wZ?=
 =?us-ascii?Q?Ta8ncBjsaErijDCI/kA/UPAGVZmqXl9KQMwHmCSrmFoI7XJhquncK4o+m7N1?=
 =?us-ascii?Q?VrCLphge6105PwsxYtYUIbUHuRSkeDFdfeMniPJYMUv+MwqoTVrsdHLZ1Z+j?=
 =?us-ascii?Q?LYM7Pk/G1s6iRiiM4MC375jqIxVz9YXyFCYl770cORNEJ1urkphwxwWeU3Eb?=
 =?us-ascii?Q?ITkDu2fq8W85d6IKE1eslt9fxaOQx7xnK+JHphJA4eoB/r4FXVdv7dsyTKVg?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef859db5-0efe-4823-af92-08da66ad7b26
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:50.9104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJUvhdJ+wzUw9neMBXWhItmPkp5Rfid03+R1z1UQZ08XaQyKtaLnAz/E2c1oB/56wnUr4favUN8IsMZz5gAH8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8598
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

