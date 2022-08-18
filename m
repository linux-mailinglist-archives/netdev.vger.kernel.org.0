Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E44E598888
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344575AbiHRQRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344504AbiHRQR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:26 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70070.outbound.protection.outlook.com [40.107.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFA6BD0B6;
        Thu, 18 Aug 2022 09:17:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4Cx6G3Pv81KqElMfA3jbPCKQKAKo8YrP93bSyBD6TtNVTzJ0hKjO940zQ1aPCreLPfHMOKixa/m1Z6Rv1I17X+2yMqwmEGfhMg21rLW+NOflgpPHjfwx7IAK3bO6zJTXz+naiQnIilp5bWEruFmhUjJz2HKa9tR/yAHWrj8djUKY/AzJBY9a07+N4wCZDF6VzcVm7EgVztGLWcac7jGet9EfxSaM7xQaCIfSYrs7aPECihfitk2VReb2DGNZ+NnwXgoijGa6AmKYiBpsyyfax0XSPhNJP6hdJ2lOyuPGUZblu9y1+HDCNSB3rg2dcpz0O7RJUHleFSNP1gjwy9T4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9L6FnTqvCduyYhxu+YFwE1dDeiGhnmXGiGrEHy0sXGs=;
 b=dIwFLLz27ELJ3ndg2SoQePRchvGsQ5RseYCrh7AsM6DlL4pv5eaY9NEK1dkoyx3LVDlB7gHZLUKHcGhLkOngIzZpIh7hLpdwK1eLU3lVntgQAtr0Lg48bhGNP2FfN3jan6KGp6aPFYJbXM0Y2ZmZdKhpOcxTv2tBobiMUo4wRC3EoNKOC7G3SmZoMVCNJa3uH7EMFrC2RmE43cekpEBEli21S0mGtIDZBHHAJR9Jj+xJkMbKPv04ANCKeM/pwGixTOzAm5OIqbxg3kW4z3txoO4kZ2DCJXCwSJps8XRlX4Kg7z7k9o1gKA9Xdxb1a2TmyF02f6Xpkrf23DK++Aqx3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9L6FnTqvCduyYhxu+YFwE1dDeiGhnmXGiGrEHy0sXGs=;
 b=AVEgVlhFyHSAQpysl63TpSjInRnU0bFYvJe+/LKA6sz2nWitqJNbjVlpA0DyYfXtoau02p25XdWzgAcgMoEZpb20a9te/0N53VUHJULG5pS3MB3Aw6IQ6a107YtOgV3jGboVOI2OAeZ8bHjFUVywc204s/c2eMSl7IlhWyZ3E81qocxlRAysokb6Zw9L2Cr3/m943qPKYaeP3jgyXr9JiX1D+BHfYe4gAqxtPUkeSXpy9klOMzitzuZucghCCZr8SNLHblLPCv5zdbm9sFnQ4D7j3oBQ3P0Sdt6hIyKgGXMjgmgrJvHX8ImTD+lhEHQHHcg+75aVECx9F1gCFBsV1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB3PR0302MB3211.eurprd03.prod.outlook.com (2603:10a6:8:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:17:14 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:14 +0000
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
Subject: [RESEND PATCH net-next v4 05/25] net: fman: dtsec: Always gracefully stop/start
Date:   Thu, 18 Aug 2022 12:16:29 -0400
Message-Id: <20220818161649.2058728-6-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 16f05b4b-684f-4bd9-7b67-08da81351d0d
X-MS-TrafficTypeDiagnostic: DB3PR0302MB3211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ynDqqld0lkFwoKEgBLag23ijSJAH2vWHHd3Ltij056oHEl42dNra9Wz9vWfaEq/+kOyjnh2aqQBt1zwCWO0jWxsHbzK3JdiFxMy24tQUuJGwcKPj3FS+EcXOO/E2j/SnhFH0MNoSZe88U/FwiLOZkzD5KIgBctpGAMRogWV3pEC786KICAE9tGE3tY4C1YJRvpl3kukKcYWuWaxud9qczXI2Y3pUX7BM4AU3hzXgVe603yaA2zqq6GKT1c8SB9k/+Y/YppZdnDMCA6glPoGlvp9/p6Hw6sxMEd0ZRn9CitdhO9fABqIgHAJ8onewviwYDSeNb3ud3bocnPmNGEKMDasoMNUBFt5W4xryzaVHn29N4RMK7/SYLWexcNkIQcPXRPKPKD/+l5s28X2JhAEcrwuOWhTaA22ejpqCV1VVkQfs52TuzNVt8d/NGbNgWoFbOJmUnXQOejkAhu+QXbA794ACUo9SXTEewvZSxTJwk2JTzEVRRnps/OwzkDT0BDnyObIjA4ZywTQa3XN//POAjGyIZBZJ83dSsTu20ZbOsYl/HACleC3NNFttCC7cXROGuQpnDeR7yFY2gUt4MLERnehzYbWFOjnTE+qrpQg0Rtdc1e9yG0gI68qg+BFXZ53f6Q0fa/RgpX0FWJgG9oOasHMLpyznZkwp/UU5EeIExdRhAO2IRSwlegDKhyK6+DZRXB3+QpExlVNHcSFtHPadCXfyx6YHQHxPd4RMciMbfuz9gck0YAitN5Ax2tyaxXXnHEOJf7gJiN1zXXul1moTeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39840400004)(136003)(366004)(376002)(2616005)(38350700002)(8936002)(38100700002)(4326008)(6512007)(26005)(6506007)(52116002)(6666004)(2906002)(8676002)(36756003)(66556008)(1076003)(66946007)(66476007)(54906003)(110136005)(44832011)(478600001)(86362001)(41300700001)(6486002)(316002)(107886003)(83380400001)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bwUeJLkxWWjN3Eq6eQwEZVMdArFQtjWkJxWkoPLLDtFPnxi8Zih8EBWo2Bvd?=
 =?us-ascii?Q?mIFmPcuwZYlHY9LVs4/ivHQgwYfi80ZFujBJ0+jcfODGK9h48n5q81x1ozoE?=
 =?us-ascii?Q?fJEv1B3oW5N6/Di3aMa+B+qWOkS2cXYDV13cO0XzxurNKR20GY+CTEVX9App?=
 =?us-ascii?Q?dukXFCuxR2HcFrpiroY44yRTQ+KLUG4Lt60Glg8XWb+zhS/uBrbDIquhoU6c?=
 =?us-ascii?Q?pMQnmkEtNyXFl52WtOXGdwKNfB5QbOp/HN/ITUwEZ4qNXWBkKe25hZcYoOEn?=
 =?us-ascii?Q?U5I4j0y5KB51uq3F43kF/dYGOlbj/Rpq+WQ9kjYfZRQD2Ksnns8XHNfHiyfP?=
 =?us-ascii?Q?3eC+wZGQ0w0D/M8JF5O3VXGe7W4VzxmLTPbRWPpZ3M2N8WO8ARwtacc0aGaX?=
 =?us-ascii?Q?0jlWsfbVqYqNPkaAJSoyPAmbefFWSuZrYTDq6GXKAqfylNW36yXvXQ+q/MMs?=
 =?us-ascii?Q?NYcYneHJYTqxvcU3R2eB+OG3SYfA5yk/EnrhbWo0qBVNHj9Bmtr1mhH6v0e7?=
 =?us-ascii?Q?6baVYTIgAX7qVpT8CJwmDfgZL15G4ydNcPHcvxBEMkhvo5WGU6wLLy9xOHro?=
 =?us-ascii?Q?+aQqndPrjiOmv0GxOntusTx9RSSbUia7BGCw5KikzvYQ2JXEgFLm0wsnYpDx?=
 =?us-ascii?Q?hcIoSln2ncFupIA7gTNEA7pXVuNZ/0d+Qr74Ohl0y5OmfLJHeJPJtqy9K1Xd?=
 =?us-ascii?Q?GuTRz2zuuYg1yajnsviM07AlxQ72VMGA6izNQyQhFHSm4pLUbusQeTfo8UB3?=
 =?us-ascii?Q?qvQlcLzfogrMVrkmhaQk1maMnDW6aFx2UCAjFXRLYQiKpgiz1VcOKHTzF8Ww?=
 =?us-ascii?Q?9e0IlVBN2LcwfCzIL6w5HgG9GFWXM97yQWKBCvUoW47WDYPwjL2Yf0AuRhB+?=
 =?us-ascii?Q?7UEnYUJSdlR1qphvlVYeLT9bAW/OPUfOfnSlkX5bUKDJfkDVHDn3U/qh5Kie?=
 =?us-ascii?Q?/1fgV9TCtk/De1858QuxgXtiwhO4swnHgcPYbrf7LPOAuwABmn0yp0ebu0ic?=
 =?us-ascii?Q?ns403yCzDbQCDQzr+2C24d1PyhaA9Ig1AxrntsVVqESL6vfhMMlxz1uSr6sc?=
 =?us-ascii?Q?AXCObiZjcAd12FxLF/WQpR+uRidhR0kiwL8S8HFenvgKq78adl7I8oYYD1/t?=
 =?us-ascii?Q?B1RzCe+lc8L1xJbER8G1LBWJs8gyvThctXTTPRqA7+i4mEOa16VWhAcJOAe9?=
 =?us-ascii?Q?ipFoa0w6X/Z4QQrevdVdN9ZwXV2m/fzs8TkUO0J30+P3E/K2wjnAhiKWdNOe?=
 =?us-ascii?Q?fyV4StiH8oGhmAn9tu9jF9eXA46YVKSJqZSoyxoJK1XhGygc2NNGBI3RtTW3?=
 =?us-ascii?Q?+RPUmWlyMXf4R3OjIlJ8WaasYVJEQm/Xz3ltyvvb0k6yPoVsS2tivOt8pulo?=
 =?us-ascii?Q?CeeJbNVPDqsZNWntDs37MwsnLX5DEABPivfVybb28jwG76fa3iMYnDt02Gwn?=
 =?us-ascii?Q?4xp5fqEhUMAh4hxT0DR3NCwtjAAXpw/9DCukEt4z2MQLY81lExfhbre2ASue?=
 =?us-ascii?Q?DgZY61vPuCz+WF8Aot2MJ92DO6fHLLCiBbjR48YW2yJaVkP4aKKj0nifU0s1?=
 =?us-ascii?Q?xSVxXYSlEb4NVWntvJzilFtmPActns0w51epCDirjNGxoYC4mIpxLjZb/bPX?=
 =?us-ascii?Q?MA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16f05b4b-684f-4bd9-7b67-08da81351d0d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:14.9362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bWr8gNcNaueGL03EOyuN0XsC6a0mIE0a+Q1NbydqXkX/BxB4yvQqtonawWLTrphhYsm4KyRHrPm0/fSoEDbbHA==
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

