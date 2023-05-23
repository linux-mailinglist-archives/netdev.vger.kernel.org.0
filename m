Return-Path: <netdev+bounces-4779-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A19170E2C5
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:32:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5434F1C20C85
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2B7721062;
	Tue, 23 May 2023 17:32:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04D121CC2
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 17:32:24 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2108.outbound.protection.outlook.com [40.107.20.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07255E7C;
	Tue, 23 May 2023 10:31:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIMVMM599AGJQSfCOxSodiFz3x0RIkv7AdDrImkirxRadin5j7CNRC4zxFr6vHRnSyHhtgzCffvgXodOmTEWLfVyBkjQB/LjV7qe7Tktq6rljjgKuzT439L3E7CyeGFIG/RC30/myDw66yF+oLYPm3qWZN2CFyzATZIhiIEB+uZYWpI7cTfww9lTm4phllKGFiNvwebGQVRqaV+8eqBDmnXYe0po5bulfEaGia3Ogwreyc1mCmRJSGm01O6gtyP1yvgm5mBZ2gVzEWUridNeuhShuLaICOZh5V7fBFHpj554Xr/Mw3c7K7LNN6SoWkaebV86H1vWjBae2a1cQhyfWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJANENL85gsGC2hfqCVR4IXN7gKgfp43J7J0EGCtheI=;
 b=eWfUp2/mVm57dig7AkHPERY3xwnXLJFM2ONCRKwicivxPVlyQSa0KvqdEllUw9dHvFSGlXSzTG1FyYe3LYIRe0Daa14Gc5CLuGRBZbsucQf36i5jXt533AfXm0oY6YtV01tKJQtS9joO3SwMvfPrTO1/eXpr06uS43S2xjIKyBGizzAIxJC+3qE/wL0q4/SzTbu0qNVLCotGlA5Re3AKsQNzUqI1yZZ7mFmkHNoRAXi0d7s37eNZVYYKTPRQ0x2KOaHvSstkd8CW2yHCWBH9gh8+Ja3QRnK01C6tgnCYTf6Ib46+maZu+bIWQTACjkbnyaZfO6W2cbP5FNtPKEOW7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJANENL85gsGC2hfqCVR4IXN7gKgfp43J7J0EGCtheI=;
 b=bvw6s9+LK0ilJvRIu0JvNoOHAmLBjNlUNR3QxXmqYTIijDBAUG1v7+9hsJrO5TdEFY7G8jHwYmuO0v16b2WCcdNEdLiCd+7R07HS0s3G6yh7Ff5iyo/JqNAP+wlUzQZbZKGfXEumisnQSy69zzZWLNmXIHC1mhYxVZC2oGsq8q8=
Received: from FR0P281CA0054.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:48::16)
 by AS8PR03MB8737.eurprd03.prod.outlook.com (2603:10a6:20b:538::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Tue, 23 May
 2023 17:31:07 +0000
Received: from VI1EUR06FT029.eop-eur06.prod.protection.outlook.com
 (2603:10a6:d10:48:cafe::b5) by FR0P281CA0054.outlook.office365.com
 (2603:10a6:d10:48::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14 via Frontend
 Transport; Tue, 23 May 2023 17:31:07 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT029.mail.protection.outlook.com (10.13.7.190) with Microsoft SMTP
 Server id 15.20.6433.14 via Frontend Transport; Tue, 23 May 2023 17:31:07
 +0000
Received: from esd-s20.esd.local (jenkins.esd.local [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id 030307C16D8;
	Tue, 23 May 2023 19:31:07 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id E86DA2E1805; Tue, 23 May 2023 19:31:06 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 1/2] can: esd_usb: Make use of kernel macros BIT() and GENMASK()
Date: Tue, 23 May 2023 19:31:04 +0200
Message-Id: <20230523173105.3175086-2-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230523173105.3175086-1-frank.jungclaus@esd.eu>
References: <20230523173105.3175086-1-frank.jungclaus@esd.eu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT029:EE_|AS8PR03MB8737:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: a33d73f2-8373-47c3-459f-08db5bb37df1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8p+kTB5F2ZyBSk1MU/Byy9UR04VQ2NVXQHX9e8brm5tRSB2+G3YX0l6kM3aK4+7cD3O4j0F1zAt80DERzBoz+lYyWWFoWX2bcj1yB6zsbbgg4Fq7f6CljG9uf04GKKt8ajmFILyZ1gN70W+4pTNTpOOvstW9oWUwARIwIMaBMmHiC2k8lrr9QXgMLL1qNCTmaghS8srUJDrfwcKkSdJG7pgZBOvnUE6J76kANfVpNey/nuXDRjgI2SQkcAd7Jl5QZuNt3Jbvk3PH5HT2uLVAC5nAmBE+sLJPvHN7LfFy6ZTJX5HUxV8CMRHzAS0kcxgmzZKJ7uZEaH2hym0nXWJGHchuKvtMIkEElJDYj4OOpl8c9T1oawkTSR++cLQ2bVzXKWNYbrys8184ADtmi2uzHG0E1udjkAvr+flGAuAwBQh24qHoR+AX4buWnRlJXHScCmxv8TYO1+Y6h06hyVbIHUyIZ7gS+W9IXRIhP8R6n2mUhnh86KZK+Twl4uxXaPj4vTw2w22SPv7MwbgI30DHfexYjt0X3I376RxddN7eEvDLyMoIZPGpmuOk5yuVQ+scjHIWmtIa4Vl1zXCRSQtoCmKYBJI8EiYIDir4ONPKqS7g3QnP0bC+vY0msb8aOWVb/sjE8Xyix6PQQJaf+X4xG0OEMOuxYFXLQzd3JoiAb1TghUKGcN1QfzF4AHI+RdyKaxyCu2/Lrhhp8q/paAz8XQ==
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39840400004)(396003)(376002)(451199021)(36840700001)(46966006)(82310400005)(70206006)(70586007)(478600001)(41300700001)(110136005)(54906003)(42186006)(316002)(4326008)(86362001)(8936002)(8676002)(5660300002)(44832011)(356005)(6266002)(26005)(186003)(81166007)(1076003)(83380400001)(2906002)(40480700001)(336012)(2616005)(36756003)(36860700001)(47076005);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 17:31:07.2513
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a33d73f2-8373-47c3-459f-08db5bb37df1
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	VI1EUR06FT029.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB8737
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make use of kernel macros BIT() and GENMASK().

Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 1399b832ea3f..d40a04db7458 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -67,23 +67,23 @@ MODULE_LICENSE("GPL v2");
 #define ESD_USB_TRIPLE_SAMPLES	BIT(23)
 
 /* esd IDADD message */
-#define ESD_USB_ID_ENABLE	0x80
+#define ESD_USB_ID_ENABLE	BIT(7)
 #define ESD_USB_MAX_ID_SEGMENT	64
 
 /* SJA1000 ECC register (emulated by usb firmware) */
-#define ESD_USB_SJA1000_ECC_SEG		0x1F
-#define ESD_USB_SJA1000_ECC_DIR		0x20
-#define ESD_USB_SJA1000_ECC_ERR		0x06
+#define ESD_USB_SJA1000_ECC_SEG		GENMASK(4, 0)
+#define ESD_USB_SJA1000_ECC_DIR		BIT(5)
+#define ESD_USB_SJA1000_ECC_ERR		BIT(2, 1)
 #define ESD_USB_SJA1000_ECC_BIT		0x00
-#define ESD_USB_SJA1000_ECC_FORM	0x40
-#define ESD_USB_SJA1000_ECC_STUFF	0x80
-#define ESD_USB_SJA1000_ECC_MASK	0xc0
+#define ESD_USB_SJA1000_ECC_FORM	BIT(6)
+#define ESD_USB_SJA1000_ECC_STUFF	BIT(7)
+#define ESD_USB_SJA1000_ECC_MASK	GENMASK(7, 6)
 
 /* esd bus state event codes */
-#define ESD_USB_BUSSTATE_MASK	0xc0
-#define ESD_USB_BUSSTATE_WARN	0x40
-#define ESD_USB_BUSSTATE_ERRPASSIVE	0x80
-#define ESD_USB_BUSSTATE_BUSOFF	0xc0
+#define ESD_USB_BUSSTATE_MASK	GENMASK(7, 6)
+#define ESD_USB_BUSSTATE_WARN	BIT(6)
+#define ESD_USB_BUSSTATE_ERRPASSIVE	BIT(7)
+#define ESD_USB_BUSSTATE_BUSOFF	GENMASK(7, 6)
 
 #define ESD_USB_RX_BUFFER_SIZE		1024
 #define ESD_USB_MAX_RX_URBS		4
@@ -652,9 +652,9 @@ static int esd_usb_start(struct esd_usb_net_priv *priv)
 	msg->filter.net = priv->index;
 	msg->filter.option = ESD_USB_ID_ENABLE; /* start with segment 0 */
 	for (i = 0; i < ESD_USB_MAX_ID_SEGMENT; i++)
-		msg->filter.mask[i] = cpu_to_le32(0xffffffff);
+		msg->filter.mask[i] = cpu_to_le32(GENMASK(31, 0));
 	/* enable 29bit extended IDs */
-	msg->filter.mask[ESD_USB_MAX_ID_SEGMENT] = cpu_to_le32(0x00000001);
+	msg->filter.mask[ESD_USB_MAX_ID_SEGMENT] = cpu_to_le32(BIT(0));
 
 	err = esd_usb_send_msg(dev, msg);
 	if (err)
@@ -796,7 +796,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 	context->echo_index = i;
 
 	/* hnd must not be 0 - MSB is stripped in txdone handling */
-	msg->tx.hnd = 0x80000000 | i; /* returned in TX done message */
+	msg->tx.hnd = BIT(31) | i; /* returned in TX done message */
 
 	usb_fill_bulk_urb(urb, dev->udev, usb_sndbulkpipe(dev->udev, 2), buf,
 			  msg->hdr.len * sizeof(u32), /* convert to # of bytes */
-- 
2.25.1


