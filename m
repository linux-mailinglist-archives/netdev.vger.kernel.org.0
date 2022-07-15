Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1B9576973
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbiGOWD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbiGOWCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:02:43 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50080.outbound.protection.outlook.com [40.107.5.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BD387212;
        Fri, 15 Jul 2022 15:01:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hi4ikhz2Ot8fc2TcbuwPbK6278945VSf+otN2WecWItekaNiTGUWNZBK9EHyaXlU81M8YAFqK68uNqdCmRBw2t67onhBuF4kzPHKD+kAcOc80a62v3Bj59c0hKdPRO8RIeD9asLz84jK+72vnTlxevXwkVS/pkI23MoPjYcBGT9GdDhffiBHVQjZZCExi34Sn55q/T6XDD3VsRsTGRmpz0Onp68+bNnRFvXodEvuoQnDoBOM6x/K8cjCXy/hbJ8sCQrW0Ik2aQ0P7MNuRiTvSO8LvLwdo8Nbdpnh/yF3dCkkSx0gjZ6JQ3Jwie3notulTv8aw8p2OBqfRTysQaHTCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9L6FnTqvCduyYhxu+YFwE1dDeiGhnmXGiGrEHy0sXGs=;
 b=LeBm+LGE1bFsSraF4R4HSTr9GnMRO1bRWlSVTUfzmO2RfVd+P+4kdDrFhyeemysh6UI3IKaR3djb1E8gBXZsl+kW1gsbHq2D8t1EP+X2bH60Y9zfPA8Xd578oBFe0/Dj9F3vgbP4krHXjfue9BxNYCfgm/lc0Oe1igqNZCSrOR4GKpzXj8tjL2P1cOR79SfVAgnuTsfu8sEBMJujOiT/OV1KE6Yz8D7zMOVw6lA/B1H3CC13exhR9yCBmB01wztwCG5fJcsVUHYnuay3lhQSdHEuzkQyytgr2PKOlD2OLtIPYhmYO/oHnAooW7+VPwZiNrfaD7TcJZ4WOxOcUUj9qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9L6FnTqvCduyYhxu+YFwE1dDeiGhnmXGiGrEHy0sXGs=;
 b=XYd6ExJ3ChGAQcJukQcMNbDZklaUT1Ady2axEXgUfIwRmjCrRfvwKJpEwrIZh1BBrdjkG/YhYXL1n6nv2ZrVmJkUUGdQ2eEBrDTnAYpGbMXY309iM258w79/M9uAH67lrJHfuvkasxeaxdcbo7hloc6roCEoWGtFx8Wp3WKe83SbpEwM7XDgGvM35eaej3RfqLpRrtu/7Dn8eJORsbQrYeZZZMJ+WshWc6HJ+E5tiunN6sR5PB8XLt6TvhMchaoXhaa1duzancnzwpxA9N/iuCnz9fp/8eaf19atKI7s4T0oThYi6SB92GyJZ3+Qfnyy50SDOqdmRo3n989Chcvaag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by GV2PR03MB8607.eurprd03.prod.outlook.com (2603:10a6:150:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 22:00:55 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:55 +0000
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
Subject: [PATCH net-next v3 18/47] net: fman: dtsec: Always gracefully stop/start
Date:   Fri, 15 Jul 2022 17:59:25 -0400
Message-Id: <20220715215954.1449214-19-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7bd32d37-79d5-4e7b-61c9-08da66ad7dc9
X-MS-TrafficTypeDiagnostic: GV2PR03MB8607:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uXRKQnbTVb6UwW3YC3pUQiYTqvDMSXUoNk7RETCxUgWRQi6dSXahmuqYlyOWtDBPXvOEN6Qy7xJiUKJnfPEevSb6QekzmrEbdRCYJzBy+nmshyQmU/3SxjSy2sKkkpxnIy/7a7TEQWH7gfn6jRlD2V9qlIVBR54qpAJrdtPQa825uGyuONrvUWXSC2HVhSQb19OHNbSdaFYhklfqnEGis+OWRmAlFnT+vKmy2r3BLkdyZdVUe/7IK/piPybrFYhp4RVPIuLWCGdcJ9fvrswpx0elL+LpVG/w08sHDwcUoS6v2l7M1+BfYEBzXoffGW97yVhMi9aK47oqvZmMG58QW+mZsL5TP4JLsRVLPud6xz4SkSwHGGACr4Lfwd/px/degaAZd/pLPll52ECTxDUvdQFQjzPZPEMjsI0ISC9DWLEyVUvTXYs4JYujxtrpUoa6SRnsqeNYCSDLP4oHhgnuh535rdLVxnbxoqpT/2tvWe72zk2+NYMgWGddRIOI/l5rNqilM10iPOmNKSJUD8K9iW64/q+oyKTYcUIaH1wgK7iiTlokHtjkEcZpwpI1yThzLrP77yHV+YJLku9xG8nULFRoS6FXdk64ewFAdOF4QLrHNwowYZW6RgZB+RYXC73xg41V2+QlieykBye/IC2GctFJuOAaJxiW7Y47IM4AuxeaimP3/ovERL4+rzWF5tu3vQ0qhcg2bXDoO3XtAEfdFxrwEWHs0Ff1k/U6Q1MVnM+6bjuShn95+KG+UhNxTKlvzRaya4p5FygzXRFtKiFDycEUxiS8IIX2FuF+Wujw//0Sf4OIKMIVNR7lx0eOW6BM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(39850400004)(376002)(346002)(186003)(38350700002)(7416002)(66556008)(83380400001)(38100700002)(66946007)(110136005)(316002)(66476007)(36756003)(8676002)(4326008)(1076003)(2616005)(8936002)(86362001)(44832011)(6486002)(478600001)(6506007)(52116002)(6666004)(41300700001)(5660300002)(54906003)(6512007)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pOlBmKYi6Hj4WHdLgfHWTa283obB5drntCYW18yKooP+JeAyh5Mz8RFA4kmg?=
 =?us-ascii?Q?28pSId0TjH7PzAXxZzs8jiQCJiuJht0QlZ20AaFRNzsVGJprTS/wVBCjdKw9?=
 =?us-ascii?Q?/h3C5EonL99/hjNX1iOh8sfHyFBDbvO308AHjS7DAVd28SbbbUM1BXi0Su+p?=
 =?us-ascii?Q?KGQcitJ96cb+rTkqON8Z2OKmqu/J6CF5dv6fHo9ddmV8WxwIP+nbvPYqpf5J?=
 =?us-ascii?Q?bpEX+kXdM9Dks8i6SzpKNzM1U4ky1Pg5RwClQN4jwGGQ+v5LzjcoY7EZxb6O?=
 =?us-ascii?Q?nT59/crQ/R1C3wg6cM5dsqqaWdXjOU4GPQ3gZoxRxJyT6HWsgeqvnKZBVFxJ?=
 =?us-ascii?Q?HtXru8yDeS86hvsCtfvYkDAEn8/R2ZkiJb+kQcL/gvZ7x7kiWNfY8SvR60D6?=
 =?us-ascii?Q?cA5TxnO6LYGjkHZVPuXTMO1gdQZVXJL0XQW4aCwI4mD/Qqw4uNGiMK7368cf?=
 =?us-ascii?Q?PmVPCZQchzLPb6t+wK3YmOkOJN3nv+KG9tPSd1HcD+Hc77f/T4LtDMkHXb4E?=
 =?us-ascii?Q?AesiXRKZAVeFvdHBSYmsb2sDO/CsfvOtJw9PGz7jNpKpdqgORJIyomsh7P0j?=
 =?us-ascii?Q?QaHnySfA52f5j0WB0b4CgcpPOCE46wZC0VYH6SKVYAO26EEqRd3B71jII+XN?=
 =?us-ascii?Q?sO08f1U6jT7Q+Ls/wHIOr1RsXwLVyH9ltTNO/ZvKb/xeqq/DmPjTGArIKUbv?=
 =?us-ascii?Q?9K6vOneBr8VQBTaLnpzc6o2FLtB1rsWpHde3UpgZynQWuxzNQj5ibp+sXPuv?=
 =?us-ascii?Q?H6YLmGmAdiUo1z9de25zfsc5SILgQGY/s7rAgTnMer18lpqh0RmpgckVxCP+?=
 =?us-ascii?Q?4vTQOjBAi7CNTz+fPbCtH922vqi+hnhBwHhxfsnewNWtMj3nvd7flbyWvkQY?=
 =?us-ascii?Q?pAnq32RfyXSDA5hJ3hJGEgHi5TTrMpwu5VsltHSFQr1McMHr+9Z+dAnNkVCU?=
 =?us-ascii?Q?L/iddzmTGbmh1HQRIXA4m1pMxb1EmOYe2V5f46iTDKtVVwDZmvUlky98XDOl?=
 =?us-ascii?Q?f6UIQarffL6qb9YiXKMIz492Qdo6kKu14aJmUWYKy37kr6hV6M0i1+75h0b3?=
 =?us-ascii?Q?q+ReJV9i0mhc/nG/UFcFKKtLJoVAzXIXFX+4S2T4iER7EbwjmERmufaUc3+L?=
 =?us-ascii?Q?7ZmpnMoJbym6W8DJ3ZRA7GPwPph+Jg08+JjkqihHTlGLSVAqrT+NxTKH3aSm?=
 =?us-ascii?Q?B8ilC4TYz2sAxAA6xXJY2g1zlVIAFqBLR6fXp0kUZGchJQZr2ZMb0g55wk90?=
 =?us-ascii?Q?dYGmbXPdE3Tg9WCAvbPJo4Unv9pw81DE1KATvt8DYCWJnogbAmWlcRdeBAyi?=
 =?us-ascii?Q?oJ2e5u/C4mXR7V65xsvDpU9YmTCqSYxD7LOfWel9vMts0AG2dbG2QusJegnd?=
 =?us-ascii?Q?5liqoktoB3rm7WUWPSsejSdSa53SrHwHcEHBibYQbsS1nngR9IAHwCvDMsKg?=
 =?us-ascii?Q?ef++48v3Z9eQ1gMlvU0nV8JzuLkwbp6a+CJ2M3kgtrWzlKszMw+alt6sfJPW?=
 =?us-ascii?Q?qUouk6BdMOzOlyCmqgtkDUiErzAkQghoU9qRId3wmEJjrA2NO9fvDfSdXPKg?=
 =?us-ascii?Q?H2moIW/U1R1LkvZwrfJ51G6tnlr/qPIKtExQ0F+s9jua5iFtQQ9CwVBtMkwo?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd32d37-79d5-4e7b-61c9-08da66ad7dc9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:55.4727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rK6Ygszv6GI29LF7qMiM4SuUL+9GRuDjmIVhcxIUjmzun8nnPpL3Wkjm9XRyHJwjNeJAuRnE6BUU3HY7XUKqOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR03MB8607
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

