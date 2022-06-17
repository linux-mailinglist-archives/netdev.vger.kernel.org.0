Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0EBB54FEA5
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377757AbiFQUeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345025AbiFQUeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:34:14 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2065.outbound.protection.outlook.com [40.107.22.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01F05D648;
        Fri, 17 Jun 2022 13:33:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gys+u4X7JB507S/ObKAcz8pE+DMPgqVZkGRDMOoz/YJfGKZ7QbeGRftNd2cBJzdrEhtsSyuZtAlnsgTLG/6cmyibKHCgJ0XBuoBh6zCZSx4XnPHJmbgdKn5tSKLmPHQGKVsoYyKLWhF//uGcnzdqEVlAERF7Et4a6mtFD7hVGlOOTUFaUm4WHQjZSilennY8iJ+VlF7tpCthXMyUngZgXjq1zRheUJ48n+uDmQq2ZN2eEOJqYR1XGeYrt/oDWrZ14SqkSNBPHwieblulWn2NVBzzmWHTO+oPvMvmfB7mAmI8ROA0h1GSi4uNrqcKZPT98KxTjJ2xvbKRBOQNLvPc8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hpQJ4ZYc9LD38/iU7/XoCwrJL5wGfJ7+2R/WXjNobko=;
 b=W1y31/ZiOIG2FW9h/VuhMFAe3RnGFB0YQYg1d2wo3EClw9W2xecz8mUsbGvQeYhHembz/BqDrz/rWDSk+Uur11BbMyKgVwDd+Z8kjrAayrbqGSrS8hK9mewLOgi0wx6H12AUR+ZKd79EmQMnUljWI23fTMLPmNZhZ2Qxrzj1HXHu3LyzK39Cn/7DhvxMqeax9h5tkFainbsJCKdtDeuTpsvJbYAE3+fEJnt/yPGr55gCusiPrR5kuVRsohqZaaFuBcBt71Mu/KyaiXgi/NjFUv1LTmCmMGii0M3o9k/2J/VEwqxwyJmwhqK3MSoeF/QAIv41kDqHIwIpkx5nFqycZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hpQJ4ZYc9LD38/iU7/XoCwrJL5wGfJ7+2R/WXjNobko=;
 b=pFk69KEh/tVvWqew1vIp0NzZvHdVhYGu1hnmmIgKZ91nQJC6RROZHjrlt+9TBf5qQMAuazG8jykEWUCyMXFm6gZ+RuQbv+QT7FokQ98H0CKhEXsRwsZHzIltZPGY7ZIQ65Atf8kJqJVSTFuhTvQfAbf1ogtpf9IuQPHTqNXPu4z42oXLclnpnDjCzjmmptHTNPOPi3s0/rW4HolDT4mC6V5Vncg69yJkPuilyMPNt/skpJnONFKL+OPOrszOqu1DB1STZhO/4sQ1EhzKA8OsiezWJ1R/5q6SqpTvQxJF6e9R8NdsRCGWIO2nPpTNMyQFyCFNG3a75lfyZlFK451j3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBAPR03MB6438.eurprd03.prod.outlook.com (2603:10a6:10:19f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:33:49 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:33:49 +0000
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
Subject: [PATCH net-next 07/28] net: fman: dtsec: Always gracefully stop/start
Date:   Fri, 17 Jun 2022 16:32:51 -0400
Message-Id: <20220617203312.3799646-8-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3f542c0f-e793-4435-5ba5-08da50a0af28
X-MS-TrafficTypeDiagnostic: DBAPR03MB6438:EE_
X-Microsoft-Antispam-PRVS: <DBAPR03MB643834F67CE58295F23F0D2D96AF9@DBAPR03MB6438.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bl3bxvlb2PwFie6uOQ2qy3dKMqA+lOUZhs60m0OPybOXvrML0hnMfaO92Czx7BVEB5ntHGbUoBce4xjlY6BARu/kKc7D9qHY7lf+qMVsLnOHnV+FuOmcn4YKdaLLwy+d+YkNHyIitfkwSz8g3wwkXrHx4eIv8W+UQtRmmY0MUVW7ilBvif67koiyCVIAoUM9SH38nav8xl8zVmUISdftenecjnT/n5sx9UyDRpsVYKhiaN60I4Rh+dpqsJlalpj/RiyCqYM64sjVd+OwL3HyNh+KwAkz6v+8qt2KpLF88HpEMVK7/vx3GYZUUoNcJP7jw4mJiFIHb/l8hA9bel0T9gZYbsZSmfo0FMFRChPXJbfUB1yCZZXwegbTrAyHEfT62iGL7pvRlSoKXsY1DHbbrm5xgBRaDahJjGnzbueBIvhi32WuJE2kDenxxPo62ottDBaB0F6F1syH6w5NSGAhF0o3LIUCqmdwjc+aFmvOIiadiugDzk4kHyiAIrZqXxiyTKAahiXKCvVSps5IDk5zoDOZHzgDGw4MlzQpyR3VG7Pq5R5zNLbifUEL9iqSISxq/EZ+MhsIysKughFqo1RGjKMtVwXJUumuAabiEmMF182DILcuozdVIVAv+SLbfykJw/Rq6prKpv5ksJN1dt19/DGviwiK0NzFDbaOxiKdQDWsBmo0yJCFvT8oK/atH1bR4koh27LMW31hahnvSMLjmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(38350700002)(86362001)(7416002)(38100700002)(186003)(2616005)(5660300002)(6512007)(6486002)(52116002)(2906002)(6506007)(110136005)(8936002)(54906003)(498600001)(316002)(1076003)(66946007)(6666004)(36756003)(8676002)(26005)(83380400001)(4326008)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rdk2OISv+1TvMbnjRzM84xHnd6XDjAZXOBvR4QXRX8CpK1vuiLWvfEG2dsZq?=
 =?us-ascii?Q?sNyOJjO55wDCpBJ7inMTIdvMI7VGD4truwt2Z0LUQ3pcIsBT9m98M9mV/21x?=
 =?us-ascii?Q?gbPpnuylXroxy8XFm42bD9g3+7/OsWFD8LY614TXmJU59LyE/bDB1rXZssq+?=
 =?us-ascii?Q?Omah2wO847OCH7Aj3yl8Z1ePzuvk8icg/ECSkqy2cTat0wXsHcERmmW226kM?=
 =?us-ascii?Q?1OEOIW6nE7dUAVhztuEtSfHURFheNNCAPcsxCXWhVXz2WmPEDj5Q+qDfBqts?=
 =?us-ascii?Q?Ia23KSSDOsDLfwowxfu1ONnDxZOI89kneYV0Icp3Ysl/CXumQnLRQEUDvOg1?=
 =?us-ascii?Q?LHIo4etBMRvKb/oZTNc/zeXQxVnXYHCX42AC8M/bm1XlNjcxGJex6ZelE90g?=
 =?us-ascii?Q?PF7yidS8rMHYnfHBhLG7mMSs+3JEjVcVFCUoK9ZUck+CzWPkN2/WMBAn+sip?=
 =?us-ascii?Q?9bD0Q2Uktvfq/HLi4w5fsf0HNBx07lotWcKN4ftU1w4Q3qWGd5lT/zjGtJYw?=
 =?us-ascii?Q?0CzYfk8Fc0lCjoNwToTFuuTjby6ZmXKRjumHlbOGglAvCCYXYJ/f47Ps1Sig?=
 =?us-ascii?Q?NmmbOQQFfBeaJ+bP7uGp2lhojkVy0RNxBDJx0b38xippr8TWtbGAKXpUMExD?=
 =?us-ascii?Q?XBVZb/+0TfXUjytKh/mTMw/DnAoECta6YFd9oKBV9yCpxD4ybht1P2dXiFrf?=
 =?us-ascii?Q?NOWxgiSpaw7cFganZ65kvqWKcnsNo4w6r48VYbLVhLLSX/v8OOrOcrORcxpo?=
 =?us-ascii?Q?FkW7LL7RXKz7Ke+VNzXXCmNfB9/29qfOHr+h40E2VlnuWgAq3KnzpwN+sep5?=
 =?us-ascii?Q?3r9p6LutweSlu/ZyZf+RlQRhTH/NgAS+B+W/Zpc9iw26A/+RmwrBVRQRBXoQ?=
 =?us-ascii?Q?XdwR4aKPxeTsQEpnMO30NRcgIB3os9MjqAU7AkfbBm/2U2TH0y1n067NHi0d?=
 =?us-ascii?Q?HX3D0+thdpJktrTZB7VGkfcjsLlpAz/18CEK9L6mPJH0uXokPYGw2CkUrHXw?=
 =?us-ascii?Q?WKzF808pZBlPW6ZkK3A0EvGZzDc3dgVIosKX2vpa6f3kI1xISZwPLqA+PjAa?=
 =?us-ascii?Q?854k2miAgd6MWa/uf1O09rsnZwFS9v9nc0BA30w1C1W7s6mUefWOEIaxZ9pf?=
 =?us-ascii?Q?PWJx4hrlSA5IE8HxNgoHtS7/ut+QJSRrNzQwJNY1igD/4rGscDNXrcgyqeTI?=
 =?us-ascii?Q?dGNnAEeUUcCJsBv8DXaubc0I0ZI6mXawP6y5h4HZKizlMZx4dKtSCt8uwQ7M?=
 =?us-ascii?Q?SQQlUOvVIAEKkT7EypHC7inr6gIZPRtb4Ux0HQSXNUEUCQVjcxU1+FF8CW/B?=
 =?us-ascii?Q?u/a92rv+1bUzqQRy6nDbM9NfyoFVmqiGGVsf4B+UEnCLR6fA9T3PgoIaPBNd?=
 =?us-ascii?Q?jBVSIc358BNh63OJlKJ4R2BrFdiFl1c92QYtBjczOOk/rnJXr9EznxlB9IRG?=
 =?us-ascii?Q?uZIMvCCu1T4jJGVd4iwbE4gOUMzT8Ic+2lmGYK0sTLM5TSqByEOVHbnjQs7y?=
 =?us-ascii?Q?w4ft31BMI05xowXybTPWlhccK7A93XnMWqfUOwFqYoM0ZhjLs/7keup85wDX?=
 =?us-ascii?Q?b/D4XN23bKhe9gQiSLViEE1gIvTI/nx69lHIePhmLmUeOAmQniNXgE29sZZW?=
 =?us-ascii?Q?arvlGnlhppw07daSQ5qLuZEypz9eIggbSqSM9tHKRzzt8RilGVXN7krXSRdM?=
 =?us-ascii?Q?NYaRRFBrvRw4tjilq4RTXaQk9Nq9lQMdIxByX+gBtUDfOqRMtHGHxvMoHtk9?=
 =?us-ascii?Q?GYWnu2cL7wYAXyXTVHWznJ/iejxhhqM=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f542c0f-e793-4435-5ba5-08da50a0af28
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:33:49.2337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a7H0nlxBjJ+IEB9M7cnUc6CTG28E39EU3C8zqDSVvUbXNGXHI9TLtTGzxdGZAh+yIR5oIy7pnLFrcXEiUiAHVw==
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

