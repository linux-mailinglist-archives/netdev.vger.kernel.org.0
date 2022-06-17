Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0D554FECE
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354930AbiFQUec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354726AbiFQUeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:34:02 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2065.outbound.protection.outlook.com [40.107.22.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0915D1A2;
        Fri, 17 Jun 2022 13:33:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWAuz/bbjlARNcSU2dGkkNo7PQIVsepr06Smn8fHTfrUno3lwu+kTuelEkVsJmkfqIF+1YPrubOHSwxkgtqe2jQmBHk2dYzD3GldVTTeTc0a89HphqE62nvXhT2hWWuT5X7iqDkgduMBEuaAlDOElfGelmL2hQqBvIJfanvspLH7DFHK3NRf9Rvu0aTLNONTd0I5nr3NxtC+CCf2X3F+g0NCVed4GGHuAjTIIF5VtBf5oC4yiXYNumlSLKa5+zIe8/vTqBir0z2JkczrVSS5OVv2IlDQp0rLW/hWlIG717Zqv6IuiaZd6SWPJS6OEKbO/Dybwqi3tX+HaT6ZTnTA8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iidGnLzSwApv0XUHFdSQpezBG/BqcsIZZhqiqq10upU=;
 b=K5iM5RZMvdzBengvk3KzBEqXfERHFj8zNFfedKKhBj/OHKuev6r0sCh5j+Smm+OssgLKHUBQ71z/eXN6bGHZkmYvAuxs9QPnbHw9l76fb1x3UL38YikQ+tYLle5y6dXdwKRVXV1WYNLrNuGYRW9V6bWbBH73Ust4MXtrCTKqTcEBrnKjO/bsnkGD7LIHnO5Q4kzziOdpCfansdlAiQOOa0YyI0sO112mdGYM0S5PGWmHdJ7jOoaJgz3dhXdahOkUciA3clg1FPOcdsBhpGx2Qga0foC8BGG7UqGZWQ7G2C/EenBOE6NyxgT09WV7+YPcesDzmT89BnTDNv/D2B0k7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iidGnLzSwApv0XUHFdSQpezBG/BqcsIZZhqiqq10upU=;
 b=EGCfhORR2X/W8WrIAY5sZPeXeFwGC7HQ9U8yM6+/mB5dqYfjEmoFddJnwTl2nzJpc337KL4ibeAGYW8MxtVxgFo5e1cVrpYJQOQjYebVeX3+2ohnmS/1nhJ+Bxn4TXFhoZTcIiV6yjx4byBNqSsdUYpq4duUBsODSX+SxYNmuGBdSZD3GDFHWh6I/K2phE7+wVTcjPRjdDb7ZLGKBPIV2nzvX48y0Q5dazcUU4viypegj+oRZolCV9IKB7UejJIUn/2LhD+nCOowywyZ2pfQ2VfNpc95rMsP90/C57aL2RAFucaTLZiNfyIM8SyMkIcgT7FVlD3R6n+YCwr69difKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBAPR03MB6438.eurprd03.prod.outlook.com (2603:10a6:10:19f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:33:45 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:33:45 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next 05/28] net: fman: Don't pass comm_mode to enable/disable
Date:   Fri, 17 Jun 2022 16:32:49 -0400
Message-Id: <20220617203312.3799646-6-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: bd9ff0f2-fc2a-4924-1bbe-08da50a0acd9
X-MS-TrafficTypeDiagnostic: DBAPR03MB6438:EE_
X-Microsoft-Antispam-PRVS: <DBAPR03MB6438424798AA263812121A3E96AF9@DBAPR03MB6438.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TiCOFbSaNr7qYRGGyKDbTeczeZtodgVTuOv62THsffhA5PfI8nkY6hU5tSV+w8S6Gneiurh9RbcTk2VTMO2GeaZAdfljhHxcasGhA7WJbWk2cdLrJ350Gy2U7EIVVZf0UvYE5ythIr3TfMhofyxToK0IbojDSt/UaTURuiufVyiii7gMjIMWEbXLOcR/dsjJbWZPgYRLz6hKBAMypmQCpTvXBOF3nVDvSgAfVUM84b7Hut3FHYWmO1u6KoplOQDvzY03rp6nJprPphjRWqH3M1uyfHAQCAXMglkzMUvTtgsDeif7aQSRw7Rq6hOGMloFi5ENR6/VbaYn5k/lHdDFTdZtC+cJ31Lry34eJZJzROJuNJYeMH3zEFAFdyB3zamhT9eIEzmReSYwgZEjbVO9dceuPKGq7NeUzmuVr+Wanfzvs9aJ+PLew6IUjdf7KYvOnz399EuqN8lblt0DDwFnEb0y4mkLpvtKPivIVlxRkWxv3MVTFYEoA5uZLnheHGYMDBuSG204Z5ChTU33dhuVTimT8HfFk0JPOyerLc8adHwDvichzm7MIMdTb6IvZulysq6juClmWtochqCC+YwgAl8nvZE7g0kuNPJ438oXwKenlM6dPTQF0q3UKdlBezKoXtBmsBjFT2y1+1/TJvRNJdh++XX0pfqTxPsX8XdiVjHW+jSwnQiDU9k/dq6il9WUrbgvxYfuhP5GE2gAN8+nvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(38350700002)(86362001)(7416002)(38100700002)(186003)(2616005)(5660300002)(6512007)(6486002)(52116002)(2906002)(6506007)(110136005)(8936002)(54906003)(498600001)(316002)(1076003)(66946007)(36756003)(8676002)(26005)(83380400001)(4326008)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?29+VnHHRMbV4nzOKbZqtTfNrmUnt5qB02j5VoJwjuEGD5Ei8xSuysZ7ipwV3?=
 =?us-ascii?Q?B6JVHXL6FUpCCBSP1UTw9IfR/uUc/mLaIrFDgUNEQ+8dKJHtl05lRNMF6jdx?=
 =?us-ascii?Q?R2m6GCuamA/zXYa5WW2tC587KMYUJjlhnJAp8H8Lm8OaFjpg5oTcoJAbkIwn?=
 =?us-ascii?Q?FH4buygZ3dCvBLPVmO4YPbR9ORUZn8WW5+v7FxOc7AzTtmcVKN9eNyh48BqD?=
 =?us-ascii?Q?5qCfMsfCJ9lZIy69GLiBBd3LvQVhY/sC17AwT4ZV38dnmvKNbnqQg8vKm7nX?=
 =?us-ascii?Q?++Qt11BsV5MDQN6gQt3D8d70wa+/1iDnqBta2hhYRQyCaqUorF8JojLMmnE+?=
 =?us-ascii?Q?Igm2N2j2Iq5twRF/DLgL9X2ZGpUl/xXcZuiHlDvrzVn1TGgNxqo1zC3juJvS?=
 =?us-ascii?Q?Ivv7AJoOzHZTMJT6cPbpsAGVoCZFrdsUxJfRjcvpNNIBZD79byVSwDeXBBgt?=
 =?us-ascii?Q?GQXuS0Lv+DeE+8FgOKhILPoGq2kFZdQNdq5bODcXS5+8dnOCXm4lhEcUmjkq?=
 =?us-ascii?Q?yg1pNYOz5ysyJY67zndtAl5wszO7e3i6szJStP6wIPmPsdAyLLsT3rloRpZY?=
 =?us-ascii?Q?6TPknp/h2PUiEMoqDkDhjFfXS+me2vbF38qdrGB1XmNFma5/jF2wXLcjUiaV?=
 =?us-ascii?Q?RjUGalc3uYJD5PNq0wQkw/h23mUs0fEBDYWsRdzUHS/lYeiz+zz0FMVGuDlc?=
 =?us-ascii?Q?fxdJjaR83gk2SnabozS5gnmmfViHLwDjPXxeWOcQxrzdNVYMG3Ia6ssbsEIb?=
 =?us-ascii?Q?sUbCoM3cfxBPRS+pGaL1gu3FIpdxwbhBO7HbsgbMaDbIfFrnElMRFnY2LUym?=
 =?us-ascii?Q?R5WGvAP2YKlA78hMZkKfLSfEX0FEECjNAE3lO9y7m5L1H8cJgsnyB2ZxBI7Z?=
 =?us-ascii?Q?y1BC6TgFlNisfCE3qIqp0fq+zulXgHRs7tFKlljrfiqRf/uQsDxaWdaAlE9A?=
 =?us-ascii?Q?EUCNvkPQN6uUhpPUBleKUDCHO7flbjxWl53fP5sIkV5hqGPan0+pqmOi2TXo?=
 =?us-ascii?Q?ubxTM6Q0uawjrzgDNXJcpQaocWxdqPmLGLHxAcXD8W9OnvVhj9phvRo9+6pv?=
 =?us-ascii?Q?uib3mTmfDmckN8J/Zt1qA09MUsMa4bxGK/gV4OkpIZNBeWJvd1ASMpw7GQPx?=
 =?us-ascii?Q?+kos+XTktISNoRl52J/vzgBd1cAtQofnEpTUFndu84jHQmL85GnZdhFgX0F+?=
 =?us-ascii?Q?aW7P0D6a0c806uZ/EU58MF1RCcohivbnFwstASSoy9js0spgbiuBR6YPJUIm?=
 =?us-ascii?Q?2wMNsQtHbRr36k14hT/ZSpBgpf7JtdmAqSpo7LRBbUVmOUs61noxKtERU1Md?=
 =?us-ascii?Q?uyO18fna27KdYtS7ze8FXnYUBs0jRTG5miuwkTRFZG6iYAfW2nrIGeFQPqYm?=
 =?us-ascii?Q?hzIs60HX4DXWamPxR+lkgK0PWd6DAWXFJrHoqN2Lz+UatEc4cC5riLiXWmoA?=
 =?us-ascii?Q?07Qv11L74iem/XnI8bDFsVpPGQu3km1J/GoLOSpqkyn3azQwGBE5I8ihNBEn?=
 =?us-ascii?Q?WIbEwNqPzcCs+uSwa1LQ8QrMVNNP7fw/pOb16mChaDHKp9UTnTL8QOYuB74A?=
 =?us-ascii?Q?xGiPEubi3PMNrzF0ACNavrEzp3YN19FJDmzxdwMvtBS5DjfyiSX/YTAPV9/0?=
 =?us-ascii?Q?3M0FiW7kdWrKiwPnMB1NpMxTd/SN4ptLYBob3DZAns5lMii1KSneWdgx6z38?=
 =?us-ascii?Q?1Lm90wRttzgBBD0UPom7acHiq8/MIixFu3bKMqaV3n+TDkB/KTFfu+04annB?=
 =?us-ascii?Q?mNIo5D0dmrzXvBoI3dIng+srH1C8OZ8=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd9ff0f2-fc2a-4924-1bbe-08da50a0acd9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:33:45.2495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tKc7DWAVT4SomV7DCfowXvA2/8SNc+2KtSMYmqKLDsR3qR3h0BbJMJKqD5P+FXs0u0jzqVw62QcdMDgda3J2DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6438
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

