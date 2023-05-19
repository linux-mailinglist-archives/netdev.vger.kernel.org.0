Return-Path: <netdev+bounces-3999-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D0E570A030
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 21:57:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A49571C21154
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BB2817AC9;
	Fri, 19 May 2023 19:56:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A11617AB1
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 19:56:12 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2091.outbound.protection.outlook.com [40.107.15.91])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8D6E40;
	Fri, 19 May 2023 12:56:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJvWqwmz2dztfcsg6zeJwGIEKGYpbt1YYrP3JRsfPSx4CtwGBlfe5wUpsuKWy864sZdcNB50sQktXbcuINqTwFXkYqcIyFM43TpC+DquW9zKNsxeui7gFltjEVmvTge3NwZkI/6SHrXqG7+M5F1ET7f1WEY5qrfyLJsIhVpanlzH5VKlwoHymkZGGFJvVc6cdgVP7NOttWmaL4YYYXfFwmW11/tx1bHUzUwnhLXhoGnymKCP67FPmdvdz4WMceBq3t3SfLrQ6Zxl+Xs7pS7Kos/Lo+0UJUpQz6NbI+2eJDB+pCn6duIuiLj4Tx8CdIh3HxbWsJA9dsBkoHPQYwDaog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Me2bxWzFtNUGf6d4dfzlSZdH8xuQOhG6KlA10GXHAcQ=;
 b=W2CYlsqR259/qids52Py92ErB4UxvmaKI9iwkkU1lggpl6pOElp5BzjtCTzdBhIDkfb5sRYXteXWMnovfybsY4Pp5VfaLrsNKSaddzBPfo6yPTrUCBSYiKfkjQcZ6IT6rwkhHs3AjNG2kpKMpeIYls9US0Hom+SJi7CWVFcX8zTpX56ngW9b+IX1mSRfWEjtMv/OQd7tcvob0+++PpFAeVwEqSoL9x+4csqUbkiBsJqSBfUVrftkt3RhD/Fr/fCLiNw0BUN0VW+BDLVWIO4CzsJCknaSUOlgRsHmz+Va00+75ekAPDhbP+bKik4emRmTz9gubB3tkdS0P1UmeVGOKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Me2bxWzFtNUGf6d4dfzlSZdH8xuQOhG6KlA10GXHAcQ=;
 b=ge+PElRuON+DUaygmkfIMU8ULedk+XwC6yUeqwvSKJRZbG1wea71Llu0xL3nAYNmk+NdlmE+TErDnngyXirv8DVS4kyo0KYGP26w1dCjDsJCabAMuVgGSjvB8J/IaG4vo/608agtemBK0jbGgAnAg/MWswpqmsmvTGbu5mVyD2I=
Received: from FR0P281CA0181.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:ab::8) by
 AS8PR03MB6824.eurprd03.prod.outlook.com (2603:10a6:20b:29c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.21; Fri, 19 May 2023 19:56:05 +0000
Received: from VI1EUR06FT008.eop-eur06.prod.protection.outlook.com
 (2603:10a6:d10:ab:cafe::b3) by FR0P281CA0181.outlook.office365.com
 (2603:10a6:d10:ab::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.6 via Frontend
 Transport; Fri, 19 May 2023 19:56:04 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT008.mail.protection.outlook.com (10.13.6.135) with Microsoft SMTP
 Server id 15.20.6411.19 via Frontend Transport; Fri, 19 May 2023 19:56:04
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id E33B87C16C5;
	Fri, 19 May 2023 21:56:03 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id CFA172E1802; Fri, 19 May 2023 21:56:03 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v2 1/6] can: esd_usb: Make use of existing kernel macros
Date: Fri, 19 May 2023 21:55:55 +0200
Message-Id: <20230519195600.420644-2-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230519195600.420644-1-frank.jungclaus@esd.eu>
References: <20230519195600.420644-1-frank.jungclaus@esd.eu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT008:EE_|AS8PR03MB6824:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 59fd30b4-15f9-4cc8-7103-08db58a3140d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MfYyye/eJ3/dAAJSFV57SWaR67SRTO8lnkC8Qv8J6aOrj8ukhLzjRUI9YdRT+FlNn67QAoItWWN4zms8pxW3RRU9Lnyv6F7d1tRQp0RtrCXG4USJHMGUGidO1saKHm9Mu1UHYi8VEbGQK2CpyiwGWoaA8h1A9EQFHtq/j3x8yJL6Jv1n9KptjJ0PzLy9zkG4MDcfSXNUj/8XWkL8VX5Lxxc+lL9U3DYrObv+kU0HQy/uw6ze2eAQi4KiRzHsqhog5ZIDxXvmeHLPJb6EkMEkCqAkfTiNVLN2t8OCftUpPV8+xwYA/U/EUxjKSBFJb/VBr8kzBCgFbNfo5+xi1OcI7Z9juZ9ES24dJc0SiNg+NRIq19oxcGgIISIdJCwNmgF+qTSF5nFlRQLyahfLnMwQq8N/MCHF/4wBZv5pPnKXnQ2Q+VYRBMrBWEAVZ4jYoyk9ED9XpYKfq9SZfPZZmYXKMk6WYh0dcBwytucyVIr2RBU8zvMYQnWnzG2oioODuVstOCW7utbojVZbTJx/aZZIlRYpLsKZ/F5tAP8OmpqbHiOcaBC39H6csa+RAlMVRrihRbR/AlXmso813z9rYVTai1SB3IzjFQCMJYLKMyb8vPWQ1P4dWRAYYnaVe3/YnrH1SO7dgcsNXjbeanTvBuiwdqihALdITCAsFH2noIitL47ywg3ofkTho0TVVsYQLFMSuvP/9spf0DsMPB9O3O9Iyg==
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(346002)(39840400004)(451199021)(36840700001)(46966006)(36860700001)(83380400001)(47076005)(478600001)(966005)(336012)(6666004)(42186006)(110136005)(54906003)(2616005)(1076003)(2906002)(6266002)(186003)(26005)(8936002)(44832011)(5660300002)(36756003)(356005)(8676002)(4326008)(40480700001)(70586007)(70206006)(82310400005)(86362001)(81166007)(316002)(41300700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 19:56:04.1458
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59fd30b4-15f9-4cc8-7103-08db58a3140d
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	VI1EUR06FT008.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6824
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make use of existing kernel macros:
- Use the unit suffixes from linux/units.h for the controller clock
frequencies
- Use the BIT() and the GENMASK() macro to set specific bits in some
  constants
- Use CAN_MAX_DLEN (instead of directly using the value 8) for the
maximum CAN payload length

Additionally:
- Spend some commenting for the previously changed constants
- Add the current year to the copyright notice
- While adding the header linux/units.h to the list of include files
also sort that list alphabetically

Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/CAMZ6RqLaDNy-fZ2G0+QMhUEckkXLL+ZyELVSDFmqpd++aBzZQg@mail.gmail.com/
Link: https://lore.kernel.org/all/CAMZ6RqKdg5YBufa0C+ttzJvoG=9yuti-8AmthCi4jBbd08JEtw@mail.gmail.com/
Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/all/20230518-grower-film-ea8b5f853f3e-mkl@pengutronix.de/
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 40 ++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index d33bac3a6c10..32354cfdf151 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -3,19 +3,20 @@
  * CAN driver for esd electronics gmbh CAN-USB/2 and CAN-USB/Micro
  *
  * Copyright (C) 2010-2012 esd electronic system design gmbh, Matthias Fuchs <socketcan@esd.eu>
- * Copyright (C) 2022 esd electronics gmbh, Frank Jungclaus <frank.jungclaus@esd.eu>
+ * Copyright (C) 2022-2023 esd electronics gmbh, Frank Jungclaus <frank.jungclaus@esd.eu>
  */
+#include <linux/can.h>
+#include <linux/can/dev.h>
+#include <linux/can/error.h>
+
 #include <linux/ethtool.h>
-#include <linux/signal.h>
-#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/signal.h>
+#include <linux/slab.h>
+#include <linux/units.h>
 #include <linux/usb.h>
 
-#include <linux/can.h>
-#include <linux/can/dev.h>
-#include <linux/can/error.h>
-
 MODULE_AUTHOR("Matthias Fuchs <socketcan@esd.eu>");
 MODULE_AUTHOR("Frank Jungclaus <frank.jungclaus@esd.eu>");
 MODULE_DESCRIPTION("CAN driver for esd electronics gmbh CAN-USB/2 and CAN-USB/Micro interfaces");
@@ -27,8 +28,8 @@ MODULE_LICENSE("GPL v2");
 #define USB_CANUSBM_PRODUCT_ID	0x0011
 
 /* CAN controller clock frequencies */
-#define ESD_USB2_CAN_CLOCK	60000000
-#define ESD_USBM_CAN_CLOCK	36000000
+#define ESD_USB2_CAN_CLOCK	(60 * MEGA) /* Hz */
+#define ESD_USBM_CAN_CLOCK	(36 * MEGA) /* Hz */
 
 /* Maximum number of CAN nets */
 #define ESD_USB_MAX_NETS	2
@@ -42,20 +43,21 @@ MODULE_LICENSE("GPL v2");
 #define CMD_IDADD		6 /* also used for IDADD_REPLY */
 
 /* esd CAN message flags - dlc field */
-#define ESD_RTR			0x10
+#define ESD_RTR	BIT(4)
+
 
 /* esd CAN message flags - id field */
-#define ESD_EXTID		0x20000000
-#define ESD_EVENT		0x40000000
-#define ESD_IDMASK		0x1fffffff
+#define ESD_EXTID	BIT(29)
+#define ESD_EVENT	BIT(30)
+#define ESD_IDMASK	GENMASK(28, 0)
 
 /* esd CAN event ids */
 #define ESD_EV_CAN_ERROR_EXT	2 /* CAN controller specific diagnostic data */
 
 /* baudrate message flags */
-#define ESD_USB_UBR		0x80000000
-#define ESD_USB_LOM		0x40000000
-#define ESD_USB_NO_BAUDRATE	0x7fffffff
+#define ESD_USB_LOM	BIT(30) /* 0x40000000, Listen Only Mode */
+#define ESD_USB_UBR	BIT(31) /* 0x80000000, User Bit Rate (controller BTR) in bits 0..27 */
+#define ESD_USB_NO_BAUDRATE	GENMASK(30, 0) /* bit rate unconfigured */
 
 /* bit timing CAN-USB/2 */
 #define ESD_USB2_TSEG1_MIN	1
@@ -70,7 +72,7 @@ MODULE_LICENSE("GPL v2");
 #define ESD_USB2_BRP_MIN	1
 #define ESD_USB2_BRP_MAX	1024
 #define ESD_USB2_BRP_INC	1
-#define ESD_USB2_3_SAMPLES	0x00800000
+#define ESD_USB2_3_SAMPLES	BIT(23)
 
 /* esd IDADD message */
 #define ESD_ID_ENABLE		0x80
@@ -128,7 +130,7 @@ struct rx_msg {
 	__le32 ts;
 	__le32 id; /* upper 3 bits contain flags */
 	union {
-		u8 data[8];
+		u8 data[CAN_MAX_DLEN];
 		struct {
 			u8 status; /* CAN Controller Status */
 			u8 ecc;    /* Error Capture Register */
@@ -145,7 +147,7 @@ struct tx_msg {
 	u8 dlc;
 	u32 hnd;	/* opaque handle, not used by device */
 	__le32 id; /* upper 3 bits contain flags */
-	u8 data[8];
+	u8 data[CAN_MAX_DLEN];
 };
 
 struct tx_done_msg {
-- 
2.25.1


