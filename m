Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B859580140
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbiGYPLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235476AbiGYPLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:11:24 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10078.outbound.protection.outlook.com [40.107.1.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAF518E1F;
        Mon, 25 Jul 2022 08:11:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itdSOrI7HJ+EyMk92C5U2Ot3P3qGJGQxn8dy6absoQpjT1sZPFcs80GIDnobmoAOIT/pRMwxKii83CVmyMnfG4tF4+jz5lgYyiI5xSSScf6/oX3QNAHh9gbUMJPqx2KjTT1qfbtGGRFWaZcjKYWdm7plqX9TWGUb3PdqPUnLTZOb5KrVdcZWwzrjEsK/f+5jB7DV27mGIynMUlvOLQi27P4YDkfWyuPgMAth9+RjWHk8urb/BjcqklX5JzirhScT1OH7+7k0w/C+urg6leRDuJSpzCiPxw2PDM35lS1e6RPyPOtfg9OmLR7EvaV95ONfrS6KHNG8d2PbUYf+UXuTEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9L6FnTqvCduyYhxu+YFwE1dDeiGhnmXGiGrEHy0sXGs=;
 b=RpzL6sWw32tnLkux1lS0yluzr511QMU9x/Ca9Zbck0iztTHhd7H+KcigQU6RjJc8SLgCfMqBDrylrVy6IMfdGxAbyyd2xkVsOxlpYi1LcO4eZhsTfiq587BhAx91K0JYGg46PSL8CIMkapuKn+sH4BbKnv3a84oeWufcblUzpvoDp+O+MHCWvL2IH4/nPVXjm6Pm1DQDPXCx18aSxdUZ45Jaa/bUlMJaD1be6c/IxNqNZi6Ziw+9cAb/bnMCq8FYQXduWFasQai1O3Sre7AIvOsW85/0fYAh5BxjpsgRAKT/6kVWjZdFNzjHSYT2frRodK90d7jBT4ZXR6+5GyzrYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9L6FnTqvCduyYhxu+YFwE1dDeiGhnmXGiGrEHy0sXGs=;
 b=KyCv3v9J17MZuK2OtCrzWJULdKW5mS41QihPzi6jQBvqWUJMnLnXa0sc8BqXaE5xH459tcRP5sWFg2Tn33d9nat1g2Ia1raWfzGFLVDxaPOQDV+mHgWF1eN5syrLb82qcQZrETXKjh42U6gg772RzAZDggu3N1qQrCv0NOKT3+IzWBGsKqCk8lMU144ybOExU/Yv85yWtvwHss4oN/7YyVXZc6NsCmzxOzUy9xy/iWaXQAX8hPZSxWhfEXgIlEmKFmscR544TPlYr9wBGRSOJBNr1rC0qIzNnu2F2BsynpEMps6NpRnzZXzkj0df6X9hLkIimjkvlpLYhDePXwQSfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB7817.eurprd03.prod.outlook.com (2603:10a6:20b:415::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:11:07 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:07 +0000
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
Subject: [PATCH v4 05/25] net: fman: dtsec: Always gracefully stop/start
Date:   Mon, 25 Jul 2022 11:10:19 -0400
Message-Id: <20220725151039.2581576-6-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 476b69e1-ed95-4386-52a1-08da6e4fe618
X-MS-TrafficTypeDiagnostic: AM9PR03MB7817:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nHKistol+IvQogE4IXIYSrkxGKQ+eDsHWeEFDmMAvjHOTZcWu8Ra2b6rr+4CWqEvGNGQuWGBho/9DWa7XW2eMAIqdcefaUeUjPmETLuFLxq8/MrdID2gdHJ+0jAtjqnWtI5W+MowcWQyTBMpTo69vmthfgx0uXFz5jD9VjSoHlf3ZpWO+8LRrYpmuY15bQFYOqh1U9K0E10A00xxFkQCaLLex9IxfuFEYEOw8VMzSpQHwOMpADVx0qlBMDEPDCzGMUL5hue20YWYZ1GuhXcAbsKoVFEA3+m87QsiKffSZgWw3+wFlkp7oj8IqofHhgORUDhYwfTYOsyylJrMtX51pUhilRCOYTWmbGw0EaU/CB/Y1aSjUR5Iu/u00K05/Tdds1toQvUlt5QT2n7EnHAd95QkftfCXgPeDGMCcF6+Crz4FnVSjw+6cMOZFa5EB5lLr8JUEYX61WBK5zYrbd+lTI/sbe3L69fPFodTHzk1b2Yixs+PCVX8CtqCkAW5Tmgki9K64ZrsVVEQXbNXowNhcxM23iljG1Pje+CIJ1Hz2j2/XnlT7WvqcVYA8QU2aDGPMO0gbQpadv+nsiIsbiXFYCxbkIK7XLNttFprbOCJCFOx6dOqtnBCbM9fqfJGDOyi1nCcFHy1Jj6rtoqb4CWhe1gT2IING270ReQs4ysKv3WaDK8w2vc5w7bvmdR5G0ol6f8I6Q6g07r9SwE9X73HfqelZSK0ctO7yRCta0W3T/GsJgItYVsOBkDYZWUgs3POyuhWdni3k8ebpa2eoKpCwc1//1594Aq3/5xh9j9GE+8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(6666004)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(26005)(6512007)(52116002)(107886003)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mx+q1kmkmYUKfznfwRl1+tvIU5wZMehMOYmjzabNPu+zswrI6JZTYArHPqWK?=
 =?us-ascii?Q?diqHxs2dQGt73ogNHJKwo4mLY/NeBwyw/HZ0B1yE4Zs5f7kgyd6XNrBjw6qy?=
 =?us-ascii?Q?ssRd0xKE3/pZGjA9hmOqkdrigX7fRJSaRckFlxVF+hoi8x/YlckMQ9jThZoW?=
 =?us-ascii?Q?kUTEOhF42GbYiyGrDAMeTSDdPK8mp6tPGf/3hYnpeQ9eCMR06ibGRKvKZgWS?=
 =?us-ascii?Q?p3vQFnpWzv/Q9RFSxADqC9VLR6Oo7Dve2+MvUtpWWkqwj/oMzVxaUxrLFz5/?=
 =?us-ascii?Q?dXk1YtikCMW3CEyOY0krVi7KOHGaZjc813Pg/7lzmankj7mEC2D7hWpVpSFj?=
 =?us-ascii?Q?V5Rn0x+1x83jfNHIIvcZIUUV3kXo+CeHBedJQ4rM7H89cBKYsRUJ1ASQwjW5?=
 =?us-ascii?Q?fTz3Y7ETM7ojoU5ib5QqZwzwU6UV3eQ5OBrDWKpiimHYOYcaYEtGXapCrMHL?=
 =?us-ascii?Q?RZHTFZT4f5ImSDe8HnsiirrHYlXbAA5QvuwVuw3oEk33TdrtMYJ2LdYNb0nP?=
 =?us-ascii?Q?rmfyEPLB3V4YFwRQ90+27lMEvngugWsqR8csFjKYpE5hp8DBVbOZRPuAveFq?=
 =?us-ascii?Q?zABO3iP93EeYaySb6htVeUeymsU7cY8Be+BAnQfqPvtfDnIA6Sqvcxx6L/gd?=
 =?us-ascii?Q?uG/bvUaHmtpvMAjCgQ4ft19zLbHDNgNEzfVd9nM7cLeLaKYi7E+ZdV45jcFy?=
 =?us-ascii?Q?cOVOxwLyE4gxx7b+eHDF6AHLp2Rzp6G1mGcgOwt5rSMgmyThmX1kuhUchvwi?=
 =?us-ascii?Q?/5H9COkKDdSqrIJ/WczJ+slpuWPJE8v61T/0Sss4eLgqJIOV0nUYWK75jwNk?=
 =?us-ascii?Q?s73V1aVgEBmFcnkk/+4xVMnoP7WYB1dIGAcejWt/AI4u1NiCGB0YA/BEg5ZM?=
 =?us-ascii?Q?R4EqmDAkK3DS3rEl2bbLX5XVHFbmuqKRXT2X5c5gK2Ds+CITvH/LocCOfe3Z?=
 =?us-ascii?Q?dSZE3NJ9Eacv/ltXxb+krEQ0PHefIBXS9SovOGNuIsg5mkKQt6guDL4QwEhX?=
 =?us-ascii?Q?j7ZHf++qVuWMUNSfD+KLhizZh+WLB6zjD6JKnNu0HPsQegPlaekURkGCMmne?=
 =?us-ascii?Q?N4akw175Kz4mobeLH6xo1GHQn8PTDTxsoKZXP1ni5PNW6rVDNt6Ujg201pq1?=
 =?us-ascii?Q?qIAviDbLwGRN512WvPspxD5SgSumrdaynUOV6jfj2lFrjjpeDEqgtPUK3BkC?=
 =?us-ascii?Q?8Ky+6A9/mQIDV+L6dAOeZ3QRfpLd61AobyXeJu2KvyyoL2HyTD6X8JJ1EzUZ?=
 =?us-ascii?Q?XFmvCaJZTytiqN2pZbie8g/jdpBIsDGJrVL6tSWzbo0QkKHWvW5VbLkUYu+b?=
 =?us-ascii?Q?9xwWx2kgpmPDEIAdn87mEfanra/OgJl6dW1X1M6Vmanh+Ul4yvwjHAU5H6VX?=
 =?us-ascii?Q?qf3hBjobaVufyzk0gH04hsGkwcGuwRBMiJan/1mc9Tnp8YiJmygbVbUkx4Hx?=
 =?us-ascii?Q?8c9sr9gjDel3e0yYV7t9hH1mzvQkAs31Y/1+z6oTdL3qrboPHTof9nCWs/Hg?=
 =?us-ascii?Q?8Qt+WWOlk9eGbr8/LKzmAKos1EUKCH7dyAU/bmI2ehtP4XbuOKU09MXBiRRC?=
 =?us-ascii?Q?fwE59F+UGWd9Ka/JOmZkJFyXqYu310cdvRA8/Q+VGtEoX4UaPQm+g2ozZB+Q?=
 =?us-ascii?Q?Dw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 476b69e1-ed95-4386-52a1-08da6e4fe618
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:07.0203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l3ZRsFx2qbGpaBSinImZiS7ZofUBpyHSHy/j8RTPUTvVn7gTVJQOGi4xwCXq80JZoP0CJsxgqMTo/H6DYxqcZg==
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

There are two ways that GRS can be set: graceful_stop and dtsec_isr. It
is cleared by graceful_start. If it is already set before calling
graceful_stop, then that means that dtsec_isr set it. In that case, we
will not set GRS nor will we clear it (which seems like a bug?). For GTS
the logic is similar, except that there is no one else messing with this
bit (so we will always set and clear it). Simplify the logic by always
setting/clearing GRS/GTS. This is less racy that the previous behavior,
and ensures that we always end up clearing the bits. This can of course
clear GRS while dtsec_isr is waiting, but because we have already done
our own waiting it should be fine.

This is the last user of enum comm_mode, so remove it.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
Tested-by: Camelia Groza <camelia.groza@nxp.com>
---
Changes since previous series:
- Fix unused variable warning in dtsec_modify_mac_address

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 94 ++++++-------------
 .../net/ethernet/freescale/fman/fman_mac.h    | 10 --
 2 files changed, 30 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 167843941fa4..7f4f3d797a8d 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -833,49 +833,41 @@ int dtsec_cfg_pad_and_crc(struct fman_mac *dtsec, bool new_val)
 	return 0;
 }
 
-static void graceful_start(struct fman_mac *dtsec, enum comm_mode mode)
+static void graceful_start(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 
-	if (mode & COMM_MODE_TX)
-		iowrite32be(ioread32be(&regs->tctrl) &
-				~TCTRL_GTS, &regs->tctrl);
-	if (mode & COMM_MODE_RX)
-		iowrite32be(ioread32be(&regs->rctrl) &
-				~RCTRL_GRS, &regs->rctrl);
+	iowrite32be(ioread32be(&regs->tctrl) & ~TCTRL_GTS, &regs->tctrl);
+	iowrite32be(ioread32be(&regs->rctrl) & ~RCTRL_GRS, &regs->rctrl);
 }
 
-static void graceful_stop(struct fman_mac *dtsec, enum comm_mode mode)
+static void graceful_stop(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
 
 	/* Graceful stop - Assert the graceful Rx stop bit */
-	if (mode & COMM_MODE_RX) {
-		tmp = ioread32be(&regs->rctrl) | RCTRL_GRS;
-		iowrite32be(tmp, &regs->rctrl);
+	tmp = ioread32be(&regs->rctrl) | RCTRL_GRS;
+	iowrite32be(tmp, &regs->rctrl);
 
-		if (dtsec->fm_rev_info.major == 2) {
-			/* Workaround for dTSEC Errata A002 */
-			usleep_range(100, 200);
-		} else {
-			/* Workaround for dTSEC Errata A004839 */
-			usleep_range(10, 50);
-		}
+	if (dtsec->fm_rev_info.major == 2) {
+		/* Workaround for dTSEC Errata A002 */
+		usleep_range(100, 200);
+	} else {
+		/* Workaround for dTSEC Errata A004839 */
+		usleep_range(10, 50);
 	}
 
 	/* Graceful stop - Assert the graceful Tx stop bit */
-	if (mode & COMM_MODE_TX) {
-		if (dtsec->fm_rev_info.major == 2) {
-			/* dTSEC Errata A004: Do not use TCTRL[GTS]=1 */
-			pr_debug("GTS not supported due to DTSEC_A004 Errata.\n");
-		} else {
-			tmp = ioread32be(&regs->tctrl) | TCTRL_GTS;
-			iowrite32be(tmp, &regs->tctrl);
+	if (dtsec->fm_rev_info.major == 2) {
+		/* dTSEC Errata A004: Do not use TCTRL[GTS]=1 */
+		pr_debug("GTS not supported due to DTSEC_A004 Errata.\n");
+	} else {
+		tmp = ioread32be(&regs->tctrl) | TCTRL_GTS;
+		iowrite32be(tmp, &regs->tctrl);
 
-			/* Workaround for dTSEC Errata A0012, A0014 */
-			usleep_range(10, 50);
-		}
+		/* Workaround for dTSEC Errata A0012, A0014 */
+		usleep_range(10, 50);
 	}
 }
 
@@ -893,7 +885,7 @@ int dtsec_enable(struct fman_mac *dtsec)
 	iowrite32be(tmp, &regs->maccfg1);
 
 	/* Graceful start - clear the graceful Rx/Tx stop bit */
-	graceful_start(dtsec, COMM_MODE_RX_AND_TX);
+	graceful_start(dtsec);
 
 	return 0;
 }
@@ -907,7 +899,7 @@ int dtsec_disable(struct fman_mac *dtsec)
 		return -EINVAL;
 
 	/* Graceful stop - Assert the graceful Rx/Tx stop bit */
-	graceful_stop(dtsec, COMM_MODE_RX_AND_TX);
+	graceful_stop(dtsec);
 
 	tmp = ioread32be(&regs->maccfg1);
 	tmp &= ~(MACCFG1_RX_EN | MACCFG1_TX_EN);
@@ -921,18 +913,12 @@ int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
 			      u16 pause_time, u16 __maybe_unused thresh_time)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
-	enum comm_mode mode = COMM_MODE_NONE;
 	u32 ptv = 0;
 
 	if (!is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
 
-	if ((ioread32be(&regs->rctrl) & RCTRL_GRS) == 0)
-		mode |= COMM_MODE_RX;
-	if ((ioread32be(&regs->tctrl) & TCTRL_GTS) == 0)
-		mode |= COMM_MODE_TX;
-
-	graceful_stop(dtsec, mode);
+	graceful_stop(dtsec);
 
 	if (pause_time) {
 		/* FM_BAD_TX_TS_IN_B_2_B_ERRATA_DTSEC_A003 Errata workaround */
@@ -954,7 +940,7 @@ int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
 		iowrite32be(ioread32be(&regs->maccfg1) & ~MACCFG1_TX_FLOW,
 			    &regs->maccfg1);
 
-	graceful_start(dtsec, mode);
+	graceful_start(dtsec);
 
 	return 0;
 }
@@ -962,18 +948,12 @@ int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
 int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
-	enum comm_mode mode = COMM_MODE_NONE;
 	u32 tmp;
 
 	if (!is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
 
-	if ((ioread32be(&regs->rctrl) & RCTRL_GRS) == 0)
-		mode |= COMM_MODE_RX;
-	if ((ioread32be(&regs->tctrl) & TCTRL_GTS) == 0)
-		mode |= COMM_MODE_TX;
-
-	graceful_stop(dtsec, mode);
+	graceful_stop(dtsec);
 
 	tmp = ioread32be(&regs->maccfg1);
 	if (en)
@@ -982,25 +962,17 @@ int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
 		tmp &= ~MACCFG1_RX_FLOW;
 	iowrite32be(tmp, &regs->maccfg1);
 
-	graceful_start(dtsec, mode);
+	graceful_start(dtsec);
 
 	return 0;
 }
 
 int dtsec_modify_mac_address(struct fman_mac *dtsec, const enet_addr_t *enet_addr)
 {
-	struct dtsec_regs __iomem *regs = dtsec->regs;
-	enum comm_mode mode = COMM_MODE_NONE;
-
 	if (!is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
 
-	if ((ioread32be(&regs->rctrl) & RCTRL_GRS) == 0)
-		mode |= COMM_MODE_RX;
-	if ((ioread32be(&regs->tctrl) & TCTRL_GTS) == 0)
-		mode |= COMM_MODE_TX;
-
-	graceful_stop(dtsec, mode);
+	graceful_stop(dtsec);
 
 	/* Initialize MAC Station Address registers (1 & 2)
 	 * Station address have to be swapped (big endian to little endian
@@ -1008,7 +980,7 @@ int dtsec_modify_mac_address(struct fman_mac *dtsec, const enet_addr_t *enet_add
 	dtsec->addr = ENET_ADDR_TO_UINT64(*enet_addr);
 	set_mac_address(dtsec->regs, (const u8 *)(*enet_addr));
 
-	graceful_start(dtsec, mode);
+	graceful_start(dtsec);
 
 	return 0;
 }
@@ -1226,18 +1198,12 @@ int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val)
 int dtsec_adjust_link(struct fman_mac *dtsec, u16 speed)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
-	enum comm_mode mode = COMM_MODE_NONE;
 	u32 tmp;
 
 	if (!is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
 
-	if ((ioread32be(&regs->rctrl) & RCTRL_GRS) == 0)
-		mode |= COMM_MODE_RX;
-	if ((ioread32be(&regs->tctrl) & TCTRL_GTS) == 0)
-		mode |= COMM_MODE_TX;
-
-	graceful_stop(dtsec, mode);
+	graceful_stop(dtsec);
 
 	tmp = ioread32be(&regs->maccfg2);
 
@@ -1258,7 +1224,7 @@ int dtsec_adjust_link(struct fman_mac *dtsec, u16 speed)
 		tmp &= ~DTSEC_ECNTRL_R100M;
 	iowrite32be(tmp, &regs->ecntrl);
 
-	graceful_start(dtsec, mode);
+	graceful_start(dtsec);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index 19f327efdaff..418d1de85702 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -75,16 +75,6 @@ typedef u8 enet_addr_t[ETH_ALEN];
 #define ETH_HASH_ENTRY_OBJ(ptr)	\
 	hlist_entry_safe(ptr, struct eth_hash_entry, node)
 
-/* Enumeration (bit flags) of communication modes (Transmit,
- * receive or both).
- */
-enum comm_mode {
-	COMM_MODE_NONE = 0,	/* No transmit/receive communication */
-	COMM_MODE_RX = 1,	/* Only receive communication */
-	COMM_MODE_TX = 2,	/* Only transmit communication */
-	COMM_MODE_RX_AND_TX = 3	/* Both transmit and receive communication */
-};
-
 /* FM MAC Exceptions */
 enum fman_mac_exceptions {
 	FM_MAC_EX_10G_MDIO_SCAN_EVENT = 0
-- 
2.35.1.1320.gc452695387.dirty

