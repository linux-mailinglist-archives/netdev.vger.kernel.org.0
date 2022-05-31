Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A72539773
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 22:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347645AbiEaT7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 15:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347573AbiEaT7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 15:59:13 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2052.outbound.protection.outlook.com [40.107.22.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED2D60AB1;
        Tue, 31 May 2022 12:59:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZYa/2quaj2r/MArdKTCQbgMDvnTDgNaMC4ca+UdTKNBaDdG3Kd4G47ncZco/kKUnL8Q+rMHevFif32ltAD69+NCoGVERk5LMh3K2SKfExv413HHKjYp2kSHo5kYWh5ubki0FpotbyAV/06r7eka1vrCCoLn5vyPr3+2xSDKJkahMZxirqS+L5WVsQPoKXE9TFon0B+q2h5HXufDXwCFmXnLlvfn4oPwibeauXTx2WD1diXTWIo3z0+agrvzVqruLObN3XSGg36SVR2TuSO9nQ0N20NOkIRVwkDnGGO9WLd1zd7lHiNgbtQ8jTKX89Fz9QqLsjgCLFawU6NwTk3eGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9erax2U4m0CE0NXLEJJuaDr954gduy2d+VAPXo/oskY=;
 b=PWLX7Km6nh1Ydj4mR1InSwz4wVQfDyVh1/r5CDlGNbjBiRLBJmii5g5lSed/swZ2UAobl5YcMzQItGF3h5T8CU/OodosFcNfVNGzYIA32OioHYGDQV5PmojGxnamcB5jUMMGPLrjA4NkKmiHtTzy2m0Co/gtdPseQAumUDWEV0ELqo6cFHcKUd8tC+hK++setR0lRIMrzW/VKHaFXlRfQaLxQ3xTcp0iJssOYD3rnVkli6zW5RI9ioNld/SiZDhAE7YDoo1ymnRhxWrP/Tj6xeEQ6FYAbs4ur8Rd+iMvpJoohUOaK4Nkp2KnzYgW3qh8If2JV6QxgQVZ90zdhxIP+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9erax2U4m0CE0NXLEJJuaDr954gduy2d+VAPXo/oskY=;
 b=nA3NTb8nO4Uikq2Mem0X3ABKxW/mcbTyY9vgZmfcLbPL8cRkLkkD+9VgVdJEYXrolu/lF/M9KA2aCRVSSXcTt8RO3lishHNtXt2SiwE+KHpsI6vqT7BjOwQRgkGqUatRw6gniOhpZqQqdiJxHV4RaKxoX0r7oex90AhZI48yv7OHtRrBkl5eVlhFcqqC1phu3LoXPKqN7wNG5sc3WJdnIkfbbcMKfcZ91quULhPblcr8V5KA1jFuxkahfY/4sSCZ3d0eM32AaspE5kzyY2UjLFAnDdDPK3azqucie0xaHaBDyhCa7JOI5MWNQPON/p7KKBMiR2Q/x47AvP7Wtnsf3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PA4PR03MB7309.eurprd03.prod.outlook.com (2603:10a6:102:102::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Tue, 31 May
 2022 19:59:07 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::c84e:a022:78f4:a3cf]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::c84e:a022:78f4:a3cf%6]) with mapi id 15.20.5293.019; Tue, 31 May 2022
 19:59:07 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 4/4] net: fman: dtsec: Always gracefully stop/start
Date:   Tue, 31 May 2022 15:58:50 -0400
Message-Id: <20220531195851.1592220-5-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 819288ab-0a29-4e0d-73e9-08da434004fd
X-MS-TrafficTypeDiagnostic: PA4PR03MB7309:EE_
X-Microsoft-Antispam-PRVS: <PA4PR03MB730908EFD39C3A1979BDB9C696DC9@PA4PR03MB7309.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C2FHu91/psTXVZj7K3krgcapfL8pr440NQPyCNhu9VqN/iy7TIFya9A37OLrNAOf8HPx01kcnwVhpxuLHcDkCGRrhW455WtN0uh0VSclsXhjTk60vTAUXhMxLd0ZghrpcMVRI94cC88XQ28yVbl0iumG3oYyHzV7NEk/FswAi49Da1fBeQGrHK2oiuxK8HxKdso+CBDD1RHQZx+1Ukw2/FDq2uJhNuBv/4d0eigvRz73IK2WnWYC2+VjjUlvQ9YY8weyeaaxKXFs0kzLGF1s5iQTt3y85iZYxY/Pb72ka6sCo+veugNXBfMEv5PBhWetY2PeU1ZojzliYXFjZL8MDHM7905dUF+pyev+B1jYP65YChbnqJh9nbYJ13Ih7cnV5hNTxx6vpcKJQzzQtsu3xOBgdvo9l2akgfHoW6jkft6Gi+HOwqKl3jmROJEv1H3dRPFrIBaTeyZiwV0vW3vrGftbZ8sWg2TDIMuglYxDn3nptyxQmczCH6IfNP+f1itV9hJE9xH/b0cg0ooa/Jqsm+cEwjy6um3KlTm4c0K0Pi0oL0jMc7+PtNZA2TJupetVwb+o4DcIlpISr0VO2sVnCnlmCXzr//PsQcYgua76MmwOetCYMBFpLbW13p+0NPcMei3yQAP0koiSfSdiuj2xUTAru2/dvzn27a4cH5HUDr48BzXhNz8n+0/yatbmKvpfDNsHNgmr4bVHby9NbeOn94zwpVTT+V/x/siuYJY/UZoAdAetI85b6x12zSrj2HnO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(186003)(1076003)(107886003)(2616005)(38350700002)(110136005)(54906003)(36756003)(316002)(4326008)(8676002)(66476007)(66556008)(66946007)(83380400001)(8936002)(508600001)(6506007)(86362001)(6486002)(52116002)(44832011)(5660300002)(6512007)(26005)(6666004)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6WRUe3u8A7AF8b7Ol8UMcHa/+ibnt9r4f0Lu+mn8gsGtF3Ft3IBYw9u/EPvN?=
 =?us-ascii?Q?tmWQwDZz/a195IRHRPXGpYLGx/FRDzYTJCDlUrwHjKLKbYOUTMVNZayHo9qN?=
 =?us-ascii?Q?j1Q8K0A7XPYme8GByfwHCc2nRd+Wxx/pBfMhHHFnG/3y2eona9Tllr6AbG9o?=
 =?us-ascii?Q?lpxW2KC0Q2weXZUUgZCBFa9a3gkLtq95ae3iEcawmG+9D2/9SqjvQVIIjeEr?=
 =?us-ascii?Q?td56VbyAhpHfBRBAK1dcCYjoi3W3Fm+uAmeJ+jGZk4xwTSxlwu3qm9Qku5g0?=
 =?us-ascii?Q?o7zUNfP38bqeBcfw+fUZhbjN/OmGCh277R99PI0Sr18YMDVpJdQ7Zq3Rqkgm?=
 =?us-ascii?Q?hMikUw5mAHMKP9JxvI4figUXagwnnt6qVgXwRFjdYeQnDD36jHCTgmzlQyBM?=
 =?us-ascii?Q?gTDIrYWAPje9gv//0BD5QYqxyksDTCG8VFGlqQL95F3wXMl05IwMg65zyglR?=
 =?us-ascii?Q?+o8zk8bgtJWg7UqlfDgQjpL2I5uSe5STaEdX5WzvuFI3CUZqG7yYm9iu7SWD?=
 =?us-ascii?Q?KjtA9x9ZQ3hx1IZCBu5aFtNWlBtWMOxRffRIu/uMBnwgD2/R7tutA/Xd2w8w?=
 =?us-ascii?Q?yE3tNHUALoFc7A+IjE83+yFi/Z3NZbPRCMpFnxF+b/q2H8a9pPduv0Ue7N1A?=
 =?us-ascii?Q?4iqqMeyziYhzSTJJPZuXshrB2oWCiYQ2HeQotMbJGCy4NqNeitkjqYTDdiV9?=
 =?us-ascii?Q?zO2BZVjswAfDo+GhsnSIBGKH4NejVbXlQ3ssDf8AphFcZd4ZCqI09o4vMhSy?=
 =?us-ascii?Q?3UAXYF04SG6VFMAthLy2Qujs6V0e/Hiat7z/+8hAFP4KFE1Eugg5sXD6XIn2?=
 =?us-ascii?Q?yoiOgb87tal6Lc2Ow6YMERA/7hNdL86ez9TT2kGAhlkKavDEHTUaHDw0ZTB9?=
 =?us-ascii?Q?XeOyBIAUVknljflPXnHEbeh08bIj199bIEQMVgA7ApTiQv3RZtOANOS8EFmO?=
 =?us-ascii?Q?4cIBMfvMOsxYl6rTcRjpddn7oY7UOrt9WLiNrFgJUDEXgCOnzc4E4WAEIrfq?=
 =?us-ascii?Q?qvrPHoOK10nAFms2IGWISXzLfbBXBIdPqZawoFj6Gk7DbHZTkajEsigULrga?=
 =?us-ascii?Q?WnZHu6ScDA8Q4QhFDt2svFAmo26ddvQdikwUJmtYV+lil75k7++NWjdu+e8c?=
 =?us-ascii?Q?3vB/iWAAMkSgHTUiCvtHnqJW6e+wpGJPooGMUgGlEVrRGkwLzDihRuwvwc28?=
 =?us-ascii?Q?PYOip9jNeueglcJaZHSDFofOw1dkYfBqndrM/cAERUpU7taPrQH6uSjohEXr?=
 =?us-ascii?Q?MOIbvxtEWbqb9HabO7Z5oJg+LHspTmkSaLX7JhUoZCrjZWZVv8bPsCLst3Wh?=
 =?us-ascii?Q?kzYINdUR/n2IKUh+kCqTRd6ie6vP1vmQgSfbCp95zMLhkdvtRZVkYZJ1wKxz?=
 =?us-ascii?Q?2nWdIV6HacUBpL9DOwvnFy0mYtWoDD8p3dvSbU4obuALznhdgGSQiRyIHVcr?=
 =?us-ascii?Q?AJ77j2aUhyJzafIzzDUsQDeGooCIGlyu+tW8NuJ5DQatlkQGCLU+yYTfuJ/v?=
 =?us-ascii?Q?JC8LXw2jIgChnWlgfiAz9kWgm3QuiNZSimsolfqdq8GoU2bhyfZk90wGK0Lx?=
 =?us-ascii?Q?nsS/ZjgVMEXnVUag7huazXyqSfdLpEbg+duFAm4hWXVZfBB2KpnnZnXI4Inp?=
 =?us-ascii?Q?cPRXNv8axywqqMyFA74AtONL61EPAD1Bxbgs1BN4jFKnppruB8wlM8424X6e?=
 =?us-ascii?Q?Gioq852Qq7CgOIZfewHAea6n/QPivqDvnVsc9HdOl87HRoCP+5xVBMd8ikbH?=
 =?us-ascii?Q?IPS85zU8r9okFbgEvhAyDbbhVJuevPE=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 819288ab-0a29-4e0d-73e9-08da434004fd
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 19:59:06.9845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sreyum443rGtAwkQd5q+TE6uivB7XRDDxoifNUOzCdIhEhj3YoXriApE+NYdYWQ3ykPBDaQXji5sA1BVX94EEg==
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
---

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 92 ++++++-------------
 .../net/ethernet/freescale/fman/fman_mac.h    | 10 --
 2 files changed, 30 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index cebdbdd0ce59..746fb1cd59e5 100644
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
@@ -982,7 +962,7 @@ int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
 		tmp &= ~MACCFG1_RX_FLOW;
 	iowrite32be(tmp, &regs->maccfg1);
 
-	graceful_start(dtsec, mode);
+	graceful_start(dtsec);
 
 	return 0;
 }
@@ -990,17 +970,11 @@ int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
 int dtsec_modify_mac_address(struct fman_mac *dtsec, enet_addr_t *enet_addr)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
-	enum comm_mode mode = COMM_MODE_NONE;
 
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
@@ -1008,7 +982,7 @@ int dtsec_modify_mac_address(struct fman_mac *dtsec, enet_addr_t *enet_addr)
 	dtsec->addr = ENET_ADDR_TO_UINT64(*enet_addr);
 	set_mac_address(dtsec->regs, (u8 *)(*enet_addr));
 
-	graceful_start(dtsec, mode);
+	graceful_start(dtsec);
 
 	return 0;
 }
@@ -1226,18 +1200,12 @@ int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val)
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
 
@@ -1258,7 +1226,7 @@ int dtsec_adjust_link(struct fman_mac *dtsec, u16 speed)
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

