Return-Path: <netdev+bounces-3440-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 218707071FE
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:23:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16EC31C20D99
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77629449A3;
	Wed, 17 May 2023 19:23:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6654534CFD
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 19:23:12 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2091.outbound.protection.outlook.com [40.107.21.91])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BE159D3;
	Wed, 17 May 2023 12:23:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ln6das9Ry0Bv5+utlbUlA/nRpRBi9/LdWckZyTxIWqr4A9XVmV8SGBh8fR6TBK30rUrnhAPY3paeK0IqT/J7CaIvwZgSa2WIck8A4CTHJ0eihrfAghGVZ4oE+Zcv6VjKJcZw61eWn85cFahgwIg0M03zawxtMJPCfru9YD836UbMvqCGBzwC+z50qEj6SosTbrTm7n7QO1fqVVS9GlPDDZrwl6OSxXv8iEx0RPQAFnkrCn4aeI3L6HQUXI/zazo18kHxC2MNv/D2uY9N8iuAZjVUabuBeMcgRxrw1Y9ANGX199V7eD7Qq54tJ7sZtUqABFCyVxN2kVGlB+hpDrwHHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mE66U+LU5IRRSdyP0mQyFle6mq28ayesMbND/NnSxeI=;
 b=UqgVRpPO1RufxLhxUAh2eTLVCoxKM74dtg0v6pZzCXaPyzQa05aR04vTZAHV2qS8MAyhrQGyFFKpNVHkTbUIYRFFNyn1XVa3zS3F85St5pG5KwOEUtk931hdLFEHZAhplmWGx6bCpYei34k7j0TzSDbEHHdSf9qSE6Y6MAPDgCFqp3CsFd2iWtPKOsxgRe5LEylJ0ccdqr6Asp57tZY6wnP9s0GY2HR0uj88kkHgo4c/nQ2Kx0zEJ64Kg6WlFEh3BTaHhkqpmiC8YdfjPNmGq3yAsZaNfhQK00YjPvdV3SuTJd3NrPcy3qu6KlVubRPcKMGXWc6MpTJ0x8UHswuMPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mE66U+LU5IRRSdyP0mQyFle6mq28ayesMbND/NnSxeI=;
 b=rWNOutRYTAtjwxf0pLKhbTnR01Rh1SkiWj+3nJORHWCED1u4L7HjMwL1DkAipaJYt0mpLNM5ReluiwWK0kFIjrp3n7Sp0yhtayiLuxefMhAXlIuntPcT67AVubhm8rAdIModAG6gZfPw6h1vnC9OXRsM3oKIK66Ry+KvsGJrwkU=
Received: from DB6PR0202CA0043.eurprd02.prod.outlook.com (2603:10a6:4:a5::29)
 by PAWPR03MB10135.eurprd03.prod.outlook.com (2603:10a6:102:343::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 19:22:56 +0000
Received: from DB8EUR06FT020.eop-eur06.prod.protection.outlook.com
 (2603:10a6:4:a5:cafe::96) by DB6PR0202CA0043.outlook.office365.com
 (2603:10a6:4:a5::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.34 via Frontend
 Transport; Wed, 17 May 2023 19:22:56 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 DB8EUR06FT020.mail.protection.outlook.com (10.233.253.6) with Microsoft SMTP
 Server id 15.20.6411.17 via Frontend Transport; Wed, 17 May 2023 19:22:56
 +0000
Received: from esd-s20.esd.local (jenkins.esd [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id DD08B7C16C5;
	Wed, 17 May 2023 21:22:55 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id CFDAC2E1802; Wed, 17 May 2023 21:22:55 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 1/6] can: esd_usb: Make use of existing kernel macros
Date: Wed, 17 May 2023 21:22:46 +0200
Message-Id: <20230517192251.2405290-2-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230517192251.2405290-1-frank.jungclaus@esd.eu>
References: <20230517192251.2405290-1-frank.jungclaus@esd.eu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8EUR06FT020:EE_|PAWPR03MB10135:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 07925482-eb81-412e-5413-08db570c1e5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	C3KapAIPw9vnLoup7EEsXVfq7zQURJewJggkkPKd4+fqYGYtFYeMqtK161vuFfh/VC6qd2qbkzyHWyljZFxxNc9YXh86kObFnmKIj8x77/XxL+n8SBVAnE9ahLJd7hWPVNn9W7IYu+xxAxCq59mx+q7DzKTmf2k3O19laaoCfMUBIr3KLm+S1n/3SY89SdRzEH/ur0HZLV/CIrVcbx7ZGnpM7K46UZekGxyBYDHL3ygUmKFKw9KUWG/2va2ZScAX25rTbBb8eFQ7zDMOOPQOb1ab6ibNA1AYsOpCELpkpqUz7mp7+jIz2jBvaf4QV4QpgI5unG7JgZXMl6BrOJAH6e8vIg7UpCYjGXHYxMhB31tO7xlI53roFLFftjk/u+IjZVoApCki/5ddiO009RYGJmrpzxIlvYaYzPyRNr1gYxvON2NORkCWXkQGBuYWAIOlNpQ9TfA1gq6+usY3mhCRe1PKzGkzc93QB5P1Y1++DVUvzuPXEREhW3wjxooVU0fLkmcnHGiIh8QKdNWAbBg4dNFLnt0Gh50Iiu9eEhlduWv0BfC8uhT09Tgitd5sImvQt/IRS9eBme6HLdNjEcTdGQE6aebWbzpNv3/tNLpe4AzBnEVXnXgS7tqoxNLai6E2XcSsGeM7pTSkeUH+4INnTszwegFilj6nMgLNM9DCwl/co+3MIMi9efbB0kXbsSSfGBeIuzfmbcpNw+j6u99Uug==
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(136003)(39840400004)(451199021)(36840700001)(46966006)(36756003)(86362001)(110136005)(54906003)(42186006)(966005)(4326008)(70586007)(316002)(70206006)(478600001)(6666004)(356005)(82310400005)(2906002)(8936002)(5660300002)(41300700001)(8676002)(40480700001)(44832011)(81166007)(336012)(36860700001)(26005)(6266002)(186003)(2616005)(83380400001)(47076005)(1076003);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 19:22:56.2685
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07925482-eb81-412e-5413-08db570c1e5e
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR06FT020.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR03MB10135
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As suggested by Vincent Mailhol make use of existing kernel macros:
- Use the unit suffixes from linux/units.h for the controller clock
frequencies
- Use the BIT() macro to set specific bits in some constants
- Use CAN_MAX_DLEN (instead of directly using the value 8) for the
maximum CAN payload length

Additionally:
- Spend some commenting for the previously changed constants
- Add the current year to the copyright notice
- While adding the header linux/units.h to the list of include files
also sort that list alphabetically

Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/CAMZ6RqLaDNy-fZ2G0+QMhUEckkXLL+ZyELVSDFmqpd++aBzZQg@mail.gmail.com/
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 38 ++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index d33bac3a6c10..042dda98b3db 100644
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
+#define ESD_RTR	BIT(4) /* 0x10 */
+
 
 /* esd CAN message flags - id field */
-#define ESD_EXTID		0x20000000
-#define ESD_EVENT		0x40000000
-#define ESD_IDMASK		0x1fffffff
+#define ESD_EXTID	BIT(29) /* 0x20000000 */
+#define ESD_EVENT	BIT(30) /* 0x40000000 */
+#define ESD_IDMASK	0x1fffffff
 
 /* esd CAN event ids */
 #define ESD_EV_CAN_ERROR_EXT	2 /* CAN controller specific diagnostic data */
 
 /* baudrate message flags */
-#define ESD_USB_UBR		0x80000000
-#define ESD_USB_LOM		0x40000000
-#define ESD_USB_NO_BAUDRATE	0x7fffffff
+#define ESD_USB_LOM	BIT(30) /* 0x40000000, Listen Only Mode */
+#define ESD_USB_UBR	BIT(31) /* 0x80000000, User Bit Rate (controller BTR) in bits 0..27 */
+#define ESD_USB_NO_BAUDRATE	0x7fffffff /* bit rate unconfigured */
 
 /* bit timing CAN-USB/2 */
 #define ESD_USB2_TSEG1_MIN	1
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


