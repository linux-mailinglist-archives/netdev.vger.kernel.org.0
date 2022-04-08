Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E2D4F8FDC
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 09:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiDHHxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 03:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiDHHxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 03:53:17 -0400
Received: from CHE01-GV0-obe.outbound.protection.outlook.com (mail-gv0che01on2130.outbound.protection.outlook.com [40.107.23.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB8F1F99F7;
        Fri,  8 Apr 2022 00:51:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apO973yTrO2blMyohzn6iwBgFLlgyBFrMkHyuSu3/GAM5I+P2LILkKL82+4S02CCSsoIALFp2i/bk+t3a8ar3dSYxUK08pG1AQWIw0WlTVWGR6OFa2Vdi2Y5ZubrfbhOE0EvWq+5q9j99xX7+l3tP2dPdXo/FGDDrkQ5Dcl9fTlshtv6wOhnL4fm6NTK3LWUWGyWKK/8yQI2sSMeVWIpAtQZA1I2JKvb5D0olz3+SUMVLEPb8G6eLdSboQi/7fsYyY0pnnaB+Vqiv5HIq2hDuTE5jzI5WAayT6BXPOc2YefxBMracedY4mIWSD/L6/CdY2kiv5TEEXcmU8EQXrpNVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=izmf8fMfZRV4zrOiR3WyISlwqnT08C3mNn0It/5hIjA=;
 b=leBU7jlfTDgscsUOBHT+AVaPC1dSAAcWnk0pgcHXZSEMaddv3CRHWX/Urmq6NTc/wGmbvBUiiEOuC0nVFRpmIXkR53W8DUbx27zZ2xNNo1Yug1gz+QKhfaeTQnhheeNPsQoHCUSkX9qOaI/htcLWfdD/AoDenUGma66+8VcMma3esOH5/ROOvvSPr8sCW9CI3rqqtoow3clUxu8gRN1m+6086wVr4UkkoNfaCo4NhaifgjhMONvmA8HS/D3/L8iKj5NZGgDh8ptNvLS0GP4S4S5b3duvJVh3+FU1H5PGA7yRuONnpKvPwP15FLc5wx6ZJlL+4cw48KqC4CltiFzATQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izmf8fMfZRV4zrOiR3WyISlwqnT08C3mNn0It/5hIjA=;
 b=gvGVIKaAPags+DFkshnq60ur3EwSofFH7zp+3qIkO4to763wdfzf8OcD8/ubS7kttg7VT6CC+XnPspJd02RKC9Gu0QTQ9Y6Ro+jF0h+7pIIxLQ84tT2VTTYRodeZzmk8+d9T4sVtpcOmB4zy0W3aNLCb2agZElm/gO43+ftfmAI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:57::6) by
 GV0P278MB0001.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:1d::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.25; Fri, 8 Apr 2022 07:51:11 +0000
Received: from GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d03a:14ba:bd9a:e165]) by GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d03a:14ba:bd9a:e165%6]) with mapi id 15.20.5144.025; Fri, 8 Apr 2022
 07:51:11 +0000
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
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        netdev@vger.kernel.org
Subject: [PATCH 2/2] mwifiex: Add SD8997 SDIO-UART firmware
Date:   Fri,  8 Apr 2022 09:51:00 +0200
Message-Id: <20220408075100.10458-3-andrejs.cainikovs@toradex.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408075100.10458-1-andrejs.cainikovs@toradex.com>
References: <20220408075100.10458-1-andrejs.cainikovs@toradex.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0193.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::23) To GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:57::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4819016d-ae0c-4e14-e60e-08da19348ccd
X-MS-TrafficTypeDiagnostic: GV0P278MB0001:EE_
X-Microsoft-Antispam-PRVS: <GV0P278MB0001ADB80A028ED101A998F1E2E99@GV0P278MB0001.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q+sgHa0UYvZM0Ygl/2pC19u3BqB0WhutftWfnsTHr/EE2/ZX4/+ZhvfEAnpYCPbXt3sXIUJBTRlo/myX7foXv+OFeJ046tdNF2Qh9CwoUIwS8l9M/YlMv83wjE+Fo6ceIFIoYMfXd82dtUevslE9kKGW0PRocEMgBleTGeCarynHIU8IlB8UJ0JkDX3ovp8c2lhksID+ijDFDB4EjGqwMrL014c/OpbAGpkW5kQ9FYWh5zXbB31DPamBlya2xuq5fE2A9Y2bStZsAUFAFsfFRVJOje4kzbrEqdNVp35w/oS2ZbTwXIajpgdDWcHc+H78RgQ0qIwdgu3AuYa8IZRXKMOY/QCUGNuYnkWN6CBdVXHOAlOC95WvwQaVnnN+oyz8rkdEEE0Rkvczmz3/HBV1kObAJ5idHQ8A2WAPXskdcYyDQFeR+O51Imgcr7sBDi4pXMM8US2ORLjWYbUJBE+0VtbRgcFLEs7kfg4gRyGLVrwAeMP6AqQQuQOpxmmlgFnTu4ZdTRJSsTYigBoR+Cvenzc/U96XZV4/BtPsKBO9tNeEePxPQtxyZYUqYtpnahoRqCEKFY7oFVhoO4n4Z9+EudpFaqGHaSClJtkYcNCyv1g0wNsQTl0NgwVWlE5Ib5WP9jmxdN2LImQvEz/gWhLFZ/Dg/r88DPqDs814GcYNe/XZD123NYlrrGZK4zDcrVkVXL1+bPzyocQYSTYy0AMIjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(376002)(366004)(396003)(136003)(346002)(39850400004)(6486002)(8936002)(86362001)(2616005)(6666004)(2906002)(52116002)(1076003)(66946007)(6512007)(36756003)(38100700002)(44832011)(26005)(6506007)(186003)(38350700002)(4326008)(5660300002)(508600001)(7416002)(110136005)(66476007)(54906003)(66556008)(83380400001)(316002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sr6YgcxRfMH14Du5Ji446S9HuPAduq19JDZcHE25HoQ8rhIC2rN6E39osaqp?=
 =?us-ascii?Q?ccmVehqi0YHcFtdAj7p4Cu2+dvmLT6PO8HzchtnAYyyTfFjWNh0cCL5lAcfr?=
 =?us-ascii?Q?rQJc1jbzZJOah0ehtT9gxSpCT9Q8KxTMjJ5fu4ruwuWhbVXhal7uXSF+1DJ2?=
 =?us-ascii?Q?Y1781zmtUaJKnCM181QiEOqkRSh1fArIcmGHdGEC2USc/IMzakZ2AKOtDztU?=
 =?us-ascii?Q?J/j8NEjIV16c+IqtyQLiivLQW4BoIW9juRVIE+xo0J2Zdktj/Xvpbe0wgXG1?=
 =?us-ascii?Q?EgY6oqIBibIJBZgGyHxaKlry360ojjB05rk9r+9f0/cCYruYR2sjS73lvqQK?=
 =?us-ascii?Q?S3gXelUEH39Fd4RztS65wlCQJxLYihruMvnB4DWWvPIfbkbDlm59rNOHWycA?=
 =?us-ascii?Q?8wah0IfamypkcXBHHyDso/DG+FSBS3IBGiyZZQa1w90Iam9ufvnhvEBst32O?=
 =?us-ascii?Q?9pT1rxVCc5IL70oINUspKI6rexZriaiZrWagBqi/qjk6Iv57BlgphEu+D6PF?=
 =?us-ascii?Q?NxZ3WMn+sCI78KlDHavhVYhUr3gR5EO2rB9JloKdxl5fo4XrTtCv58tOwsmh?=
 =?us-ascii?Q?HYYmfd3OaBpnurZhpPEw5zWIY3P4iq0XGgqH/ak3884SXaRSXESuXWVI5B/Y?=
 =?us-ascii?Q?+3vVnZlrAnd123tdiTkYYI50DYml5Ap2gDQDAdBrkgaj/B0Njr9sX+c+hA4p?=
 =?us-ascii?Q?yLzqOvks/IK+t77laqNv0EWN0pyMKeNVaMjlL3Pj1SMSQ1DToa1hxpV0YO9b?=
 =?us-ascii?Q?dQ2u4XffmcDWqB7X9VZM8+HK6VFW+c1KczqqXM6S3SrYc+FTfmDTcrrZX6A/?=
 =?us-ascii?Q?i8hcZwBh/6dH20SUSCU8v7g/uwgGWdBybGLSyVuNvybYre6xXNPqE3nmrYgN?=
 =?us-ascii?Q?JY2OmM+N+0Pg4A0iF/XDf/efBj8EL0X0vyNFykvb/qLTV685GUjD9OfdLccF?=
 =?us-ascii?Q?uJ1cpMcdYtL6hXetsryQyb0S/LB9Tg+be1pS3SHxswhu3EJqk5QTdDTnA+eg?=
 =?us-ascii?Q?Jx9qPz6QlSOOBg6SNzX+axQ1TFPe38+GKe+xPbPCBcuXhV/6RU1xEgaps1i4?=
 =?us-ascii?Q?V4dzoRj4pTU5aZLWyaiyl0zgLm/C3p47bJ0AHe+SxzAcnd5XOGAg1+v6DIVb?=
 =?us-ascii?Q?/Hbf60qn50zUnLwYHAyLvf+yQHE27P9lrUWDZmISwFqLuAdhmNGa5QLOtTNJ?=
 =?us-ascii?Q?xAOEncbC+XRXVtmwPH4Nd0UMMtAj8zCR+CPCwkscJM+rFK9VmomRIml1pvAv?=
 =?us-ascii?Q?gpmKaVHcg/aUaW+x9s1Nhllf98pLhCR1XzuVszvg3cPcjksWwFLbGkaY/Aqi?=
 =?us-ascii?Q?YEvC7Wo9mnLgs2t5qs5hTdoH+Z/MTzH9XHcxVrIJU5TkxHbFNjmMZHVOvQyR?=
 =?us-ascii?Q?k/KeISTXNci6LV4nmW9W52XYsxH12ss2vtIh3qbZkfI5ZH546liJlrzSiv3h?=
 =?us-ascii?Q?QKjCIaEl9VpqCyYNeHxrEDf9TZTzORb8XErDN2nmIt69vaNM0/bom4nX7hTR?=
 =?us-ascii?Q?PHorQY44uCGCEBRsj1f2a+vQReuR7UHi3uCQBt2PAdauRpPfmGXDeEhyKP1E?=
 =?us-ascii?Q?tSh03gFyrqLdPiyariNQlfo1JOdOkMOm6xG0X+VVBX4zLBxcmrvjg9yHZW5w?=
 =?us-ascii?Q?X8BR+vI+o+XR6rcNAd0KIS5dCplKcOq5PMAZJj3hL/Iu604UTHiwvQMb6vyq?=
 =?us-ascii?Q?l6XgRSiM0lVXmRPwXUTjvK7wLEoPDjRIZLAFEUBW5QUr5QwwsG3vU3on5g30?=
 =?us-ascii?Q?8QVN7sQsr6D74Ew7WE6I0xbUtTGmSxo=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4819016d-ae0c-4e14-e60e-08da19348ccd
X-MS-Exchange-CrossTenant-AuthSource: GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 07:51:11.8582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d0ZrYCCLAPeqXMqE3WPsgTY3FCRATlXsf3ZCt9FNLeDNlAyPP6b3HYDnVeA4bv4nda9mY77kZu3orehUTpidbF048OHDBlBIOXa7+a2oHAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV0P278MB0001
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
index 23160d179485..dd5eb1a370b0 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -405,6 +405,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8977 = {
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8997 = {
 	.firmware = SD8997_DEFAULT_FW_NAME,
+	.firmware_sdiouart = SD8997_SDIOUART_FW_NAME,
 	.reg = &mwifiex_reg_sd8997,
 	.max_ports = 32,
 	.mp_agg_pkt_limit = 16,
@@ -3173,3 +3174,4 @@ MODULE_FIRMWARE(SD8887_DEFAULT_FW_NAME);
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

