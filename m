Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB4850B383
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 11:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445845AbiDVJGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 05:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445817AbiDVJGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 05:06:39 -0400
Received: from CHE01-GV0-obe.outbound.protection.outlook.com (mail-gv0che01on2128.outbound.protection.outlook.com [40.107.23.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B3C53721;
        Fri, 22 Apr 2022 02:03:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mO+50MTHbmuJgBuD3BZ0436VeQULUoc3Fy1LTChHFex0ryqPHVbHgPTKHHqyLrlbyGgE77mH7hOD1J3xmBBVFLtyRN5dKarFeIvLxUGnexN++z5r4h/oozINIAoffpJ5XWJytaEl51fRcvnCg0PksvJljbtgsgbEPPhyLWZmPAbix2/3wkjl8j/MpI+AJXraZaIkkDKGoP9/oMes4aUEDOSb0cn6Hs8G8vEuYRdZQT0wswSqLgqRrFUSCanspdX7U121Ko94oG81WOZzcaJGjQ96Ml1hbEttqPdZCHY2bLwNJ4jXZ1et4jnZHp0dHuCJpoNeQhn5Xpi/FIgJucIy2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZYiG24tOGlyADGlOXcOCJ5qL5JoqvEtCZ3Ax1uT9nhY=;
 b=JhTHt+hA3MCxaa9PzyZ8AasaufxpNz5HfGYhCMPY4g6v7sG7jaGaFW8w/jdI3+9qDmiukzGEbBx6K70fIFgyDW3Qr0g3/FpURxizfo6sKBI8Y1T9eYMLpGR3Xewt0RnPs3MkFB7fdLXHgpu7Nk9AMRFLEWx2N2x4gCmYymTbrOC2YokdJ6UbX/4JbgO4fRGG5XoKIJGt3NOYvXQGWJGTvLOb83S9CHuR5KTYlqqLxQF7y1SFKb7dcwLov9v3qqfGlOkpl9M9zkfE8sdQdFUmHr41efghVt8j7TCS/PhchFFw0UWq39T/A7ewLPBHza3x6LX/6dbBgANMgkAbJc3pSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYiG24tOGlyADGlOXcOCJ5qL5JoqvEtCZ3Ax1uT9nhY=;
 b=k+vhRmwCQfm77hL75UupkUXez9Vr2unlL+ajnDG4vfVOG3y/oE7OG0HZ38TJFNRqoGDcbPOb1TXeMhT8kHYGX7aIM9darQdcP4Uy8lRmI1rnDrYQ8eOD06+U5KR4YbmHoFEkQKfq4znES91Iwp6iNnl2/U900vDnNElSnWI7T6Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:57::6) by
 ZR0P278MB0393.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Fri, 22 Apr 2022 09:03:42 +0000
Received: from GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d03a:14ba:bd9a:e165]) by GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d03a:14ba:bd9a:e165%7]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 09:03:42 +0000
From:   Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
To:     linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Cc:     Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 2/2] mwifiex: Add SD8997 SDIO-UART firmware
Date:   Fri, 22 Apr 2022 11:03:13 +0200
Message-Id: <20220422090313.125857-3-andrejs.cainikovs@toradex.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422090313.125857-1-andrejs.cainikovs@toradex.com>
References: <20220422090313.125857-1-andrejs.cainikovs@toradex.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0151.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::12) To GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:57::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82bc273e-0f4d-4692-f99a-08da243eff7c
X-MS-TrafficTypeDiagnostic: ZR0P278MB0393:EE_
X-Microsoft-Antispam-PRVS: <ZR0P278MB0393DB447E942B9F283E3118E2F79@ZR0P278MB0393.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aggiw/yNJU1pwcyeDxhA9Sd0KbmuGxyMkJ8Oh2BO0+fMlSQRCpLkRuM6gw+EiBP+nbfcMJNRjX8mDZBRx9MK4t7bz608to44OKmbVkTrpJVHFnUF6ZLwgUaRwVMFVHBNUPGGnZh4cfx1MaazLz8SkUyrqT9pdPgg6EvyoigqKToJ4OsCUdZIFZADiwe2IHoJcAha+MSHxPDZ3BcWMdFmTeXJgU8Qm0//nCCf2Fgld0CbXE6wuivajC4brN99c4w1qd2gbIrOjcXiuHyLy0Au0Wrv05ztOoM8Jyxu+ledd+f1GHNAWgY3T3jmKD53QxDkDM0SmPXosBLyl3+J0rou8mIz506eE4hjK4Ta0+Qin1tnimO4vg+c57wcRwOa658EjReZ9n/92RycoiC3hTbdudpwY3nVIEVbVY4JUmArZSSlS29ZugoK1tiBY51O4/T3nI/EZMApCu5GVToGgZsxKjt7bbeKgNADIoCTGCGz1LaIIB+dCTasdwnaFdoyzYKDJAwmRzfh8tnNooXWdfK526mY382TR2R5ypVi2y851ps9g+g8tM2MkxikpRzZJWn/s8h1IOxpCdaUrCoGTNV6kU6O3tD3VIZK7xPh6vL0ABtSXxyGDaojrcx0K8XtNdVeajdxdq9AWt29NUKxY+NW3H7RVcTudSJDlO5SBb9izCyOELd9DnwE4Irizo/AxFKiU9T5aTjcjhh/BegK8lq+Hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(396003)(39850400004)(136003)(346002)(376002)(6506007)(2616005)(6512007)(86362001)(316002)(6666004)(44832011)(2906002)(5660300002)(7416002)(54906003)(26005)(1076003)(8936002)(110136005)(38100700002)(186003)(52116002)(508600001)(38350700002)(6486002)(36756003)(8676002)(4326008)(66476007)(66556008)(66946007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SnMIsQcNd0CrpkoMJ8aySGQfmRXA2gv89s9VL5KWinMx9dbC2Ol6X4tlNb5q?=
 =?us-ascii?Q?C0OSAitQdPV7IJWWTuavZo812kHqo3aYQ6pF6A4zWoqUP9syf+FffHX3eqoy?=
 =?us-ascii?Q?9fMamgXkosWfin3jDZJXwK3AMnXsulBDl7gmL1yXu/gwWldwHAVg8h5Ddd19?=
 =?us-ascii?Q?vUDzaDJ7Gq4jgWiAcfqWS63AvNgBb1quAi2KhTXAinUSpaih6WJIQxE5wkIM?=
 =?us-ascii?Q?16iMwlDJnwwI46GY9k6YEIbeUuehti4y/BU9UW1UPgumIBMxtroo1eaYwyQP?=
 =?us-ascii?Q?ggsR+7MG60utjEY5I5ja5IynZAwdcc7qdu9ziUjB3GXEMuBLhuvMNI9akdYO?=
 =?us-ascii?Q?MnLru5fPAnNJL6yE7TKEb3/smTcQS5ULIv9eH+R3hEagJi2XZcp5b3fSo2dW?=
 =?us-ascii?Q?eyFgqBE/roOljDCSn7j+q+1Itz1x1z02K0gXNdnWmmi0G7Ulcg2d5vBmRRFv?=
 =?us-ascii?Q?cePdDgACjuo1pGEapJvF9kfSqgQ4ev8GJdyNZlL7tOCEtLOYx3pXSX48/Jtr?=
 =?us-ascii?Q?Hy2v5tKh+ozs42gob9gFTFLIdz+SS+Uu1QCrn7kFpQVEkTP4d+AACxk2ZOFt?=
 =?us-ascii?Q?gxTx1nf1icFGNuAtXhpFfjoKYoCWvLrrtIg+19+Ma0JS7AbX277+L7MqX+gc?=
 =?us-ascii?Q?FPfzCw+xOdXdckzs3dAXe5kkMlgMQuKdxOFz0fPvUA3izFhwGXHCfdHQgtkB?=
 =?us-ascii?Q?ne8l3CYNGdEpTgARIpljcXC/WMQOymY2u3F1+jv4gyMmwvItu83LOlSiGodV?=
 =?us-ascii?Q?LgAyApzHKO7A+JGFXT1Iza7mLqoN6r03Me67ZGkxK7bLr2QQW8ScoUIAfNyC?=
 =?us-ascii?Q?p3KMiMd3eBVXfBUJEKsMAyQrF3o19YiZRpuJPz59f+rLpSHUhc9ByaEQVe8r?=
 =?us-ascii?Q?6qPCZazyN/+uEcNyHsqenNGdhsJ4qowD+Xvvn8cvds0scOGemjzoJ/JKCoyx?=
 =?us-ascii?Q?bQSjuUz8fdrWxMT2rbjGApv2s6b6vrZd4/lb1morRGVPMdsxRNMlOhUZEZR6?=
 =?us-ascii?Q?ZjQ69GeX09pbU/GAKFdXFX33r7zbHxCy0vikXpTAUx5nfxD+FLUXD3l/ZBui?=
 =?us-ascii?Q?vsNY2PuIo2wjnESZySnDeawaR6LebBT+V7Gl+hekSaUuFqC4INqc1uCB3SGc?=
 =?us-ascii?Q?8YdDeBhGxFXn/BQG60aBCQDFlNeaGnR4o07CF9XttF0Jm1i2MzFUaX4zR7ar?=
 =?us-ascii?Q?HrLtE74Vte2NN3Y58z3EyrO5e7X/yJRpzLChdlRoynCoMIONcJE5YJuao3eD?=
 =?us-ascii?Q?IHNfW87HNmIeOW3ECp91x8RM6rLtMvcTOLq9Q1BKgx3gnLDvqd+Jpt8ATcoT?=
 =?us-ascii?Q?Gm8vBQPS2uWLTPB7Ttg+2/0j6Mvp7s7bxCFxSgOHFP53MIFqJ5gBgGb0VyNy?=
 =?us-ascii?Q?N+8NXyDeZBke7r7HhT2EvGB0SVv8WSSN829RnmBL8XMNUs8WqqerYOEiQKjl?=
 =?us-ascii?Q?qkIgeJtB3qfXGgTJafNnFF1Mbue62CkaCinZ4PN95MYtd6gfeR933L7+OsOu?=
 =?us-ascii?Q?5sPr5hj7BNKcdQS5zBctml+Izy1y2scm6tnkpe2cMVnbztzyCjK4FqHIOUqT?=
 =?us-ascii?Q?+KCBr1cn/K/h0wbvWyUcAm4UGzDj5UCku71PxpeWg55yZF8bsUNEaRLgkk0x?=
 =?us-ascii?Q?G+CzFfi+A73Tc8U2f+KJm4s5tkM6uNnjeXXS1WbrfYlVyYVPIE5RgriJVAMZ?=
 =?us-ascii?Q?0zdtsCO8HqTrORJxESD8Zjka4T5YKxyW+9eNcIxKyBHTR85R1aYiLCRYy0XM?=
 =?us-ascii?Q?Bv3FJ16h4ESzDP4apveMHc2fLvJpnlc=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82bc273e-0f4d-4692-f99a-08da243eff7c
X-MS-Exchange-CrossTenant-AuthSource: GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 09:03:42.0080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CrHs5R0QV+RwyyTbQHnZ9gXQf0qXJ6Giqg6OXsLWfeR0bi5flUd9/1I0SH8PuXZoVdZhL9Zv6nYXwEaB+AoX5N7WYYzwfLv17c/g3PWMnmY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0393
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a recent change now it is possible to detect the strapping
option on SD8997, which allows to pick up a correct firmware
for either SDIO-SDIO or SDIO-UART.

This commit enables SDIO-UART firmware on SD8997.

Signed-off-by: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 2 ++
 drivers/net/wireless/marvell/mwifiex/sdio.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index d26efd56be08..76004bda0c02 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -408,6 +408,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8977 = {
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8997 = {
 	.firmware = SD8997_DEFAULT_FW_NAME,
+	.firmware_sdiouart = SD8997_SDIOUART_FW_NAME,
 	.reg = &mwifiex_reg_sd8997,
 	.max_ports = 32,
 	.mp_agg_pkt_limit = 16,
@@ -3176,3 +3177,4 @@ MODULE_FIRMWARE(SD8887_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8977_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8987_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8997_DEFAULT_FW_NAME);
+MODULE_FIRMWARE(SD8997_SDIOUART_FW_NAME);
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
index ad2c28cbb630..28e8f76bdd58 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -39,6 +39,7 @@
 #define SD8977_DEFAULT_FW_NAME "mrvl/sdsd8977_combo_v2.bin"
 #define SD8987_DEFAULT_FW_NAME "mrvl/sd8987_uapsta.bin"
 #define SD8997_DEFAULT_FW_NAME "mrvl/sdsd8997_combo_v4.bin"
+#define SD8997_SDIOUART_FW_NAME "mrvl/sdiouart8997_combo_v4.bin"
 
 #define BLOCK_MODE	1
 #define BYTE_MODE	0
-- 
2.25.1

