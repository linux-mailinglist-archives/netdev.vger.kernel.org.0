Return-Path: <netdev+bounces-3437-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21B367071EB
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C4C01C20F86
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C871831F17;
	Wed, 17 May 2023 19:23:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B417C31F15
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 19:23:11 +0000 (UTC)
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2101.outbound.protection.outlook.com [40.107.249.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18CE213D;
	Wed, 17 May 2023 12:22:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjxqSBOebbgTYWGZHwnZPFsGq3V0IFhkR0CrQ916+cJ2tw5JDOfDYXFwmd+WpH+ytWHNtOkNl8vizLI7CIjmmr8yASA5WzZoQLFr3ji83tpu1zSDKhpE9xkdfzR61rAw8knintjREhqj0RrNHnByIbp4v0u1JSvPocW5qBA90QDijkG1Ssaak5zDpLKGK0yA4nBJYL2iAxWyII7pIsvSnG2Wc4w+4kUg+1IIMtGJewekh4CGbf9XsFNRfli1oyIeeE+I5sIPt0lnSD3Na0nI2ZDpLZZz3kmo7hsTSOHqnpdu8LlySUo9qpkoiSRmnUpH5S/T179oJWTtU3/yhnmkOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=horHWuD8f8DxBUMvfRNXeJlSNKc3GL59fOr/axIf0g8=;
 b=V1DNf468IOOml1juPczcl0PXAoS1BZ2yrdP75thN85HRhTt5tuisTVWpNlGaCbnZ+DlAnvRfLCmtMP/YVynqTZ2IknQk2eMYue1n7FLdtspxzLUSBI0g6LkFTgcfE04iKOhCCmE5IqoYhX91AAbDhjwoFyQBr8CWIfGB2yYNgJgiA56ID0gySwXo024rv2eZ1wMTHEQdA0jeaQBH7LiSjrlkMQLS3oAnM5yyxNCot7ZM+oBVmXkKTr8rwkw1Edj7QNRsmJ3s+0nz1aUpkuhWHt+A6LvZDja3CvFTIhWZCD+x40vEMVh2JDmXaTdVF9mmZGoBIfvP3UjuizXAOj6oMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=horHWuD8f8DxBUMvfRNXeJlSNKc3GL59fOr/axIf0g8=;
 b=b2cJ2Z1X6pWBYo0H5GWinahFxLjA1p1Jf8c4+cD9X6to0EXFSXJNV70/1qme/w3ZMeZJJ7UThEsN1JoROmE7v27qGDHixc9qxwgyzRtF/P5MC3FEJPszTmtpWIDyZn+MltXWlf5pm35xII/nHRUPHu6gFnBVJwVNjbe6PwqSIa8=
Received: from AS8PR04CA0058.eurprd04.prod.outlook.com (2603:10a6:20b:312::33)
 by DB8PR03MB6140.eurprd03.prod.outlook.com (2603:10a6:10:135::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 19:22:56 +0000
Received: from AM7EUR06FT058.eop-eur06.prod.protection.outlook.com
 (2603:10a6:20b:312:cafe::a3) by AS8PR04CA0058.outlook.office365.com
 (2603:10a6:20b:312::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17 via Frontend
 Transport; Wed, 17 May 2023 19:22:56 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 AM7EUR06FT058.mail.protection.outlook.com (10.233.254.161) with Microsoft
 SMTP Server id 15.20.6411.17 via Frontend Transport; Wed, 17 May 2023
 19:22:56 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id DFBAC7C16CB;
	Wed, 17 May 2023 21:22:55 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id D35D52E1804; Wed, 17 May 2023 21:22:55 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 2/6] can: esd_usb: Replace initializer macros used for struct can_bittiming_const
Date: Wed, 17 May 2023 21:22:47 +0200
Message-Id: <20230517192251.2405290-3-frank.jungclaus@esd.eu>
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
X-MS-TrafficTypeDiagnostic: AM7EUR06FT058:EE_|DB8PR03MB6140:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 45921b95-17e2-40f3-3177-08db570c1e3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8pHjqK++phOyEhXMGQWS04POoxuQZQtnC+hq8V8Eds5RCpCMe4TIEWuTIkTaBgzoVTdmSwPKukzoqXjuTFFB/ycJQV4L+wWi9HjtCrmVtk68LE2/wsMQO2NHv7Hnpmvw8ZW/lSzp6g1Mq6WC05/2B4rOWAirZoHc8HfzR/eqVsQdv5FO9XY7/7wyEtYS3IXSUAdi0m2izxiJHfZtgvD3ovRQ0oqpOK9iWd1W/SxHZIMpv3MGR9ahL96kHptaYN7RWscN+Cr6aLRzjup7Y2IXFJwY9j7j2YVoJ7WA7cuiIH5XmOaV33GMPmrGKq3iAzdiV1WKHD19Lj3oMpsJkCnPsO6DE5AMxeKZORcykB42yOGIe0QoEaPlTpwp642AXUpAGi7dzrLgWxUC7cL/r7bngTxrbsWf8UbM3JmcFpEvqs5KbRQHZkk9CrKU4vQGaD7F7iS7xTWuOR3McdAWJL2Xjw578MkakoM7JEDUc2RbI8lQ4VNd2t8nuhRVhtcqAbdLgNNfQRmNYIDi3IP2nKCsbOAwWINeNakQndHmni062UGJx/6HwrFchHtlc4cUH/+5+IgTjSombK6XqLaoTT3HQgFlrXgaBQuNkH9MMndRx1Go1GGxmh/Lq0ar8j3BwdoyR8Fw2z4EXAiqyRCh1fthxV7lY8P2f/uQMNUicx+sywyXAr4G59slvNsCE6V80x2m
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(346002)(39840400004)(451199021)(46966006)(36840700001)(4326008)(54906003)(42186006)(70586007)(110136005)(70206006)(478600001)(2906002)(6266002)(8676002)(6666004)(966005)(8936002)(40480700001)(316002)(82310400005)(5660300002)(26005)(1076003)(44832011)(41300700001)(86362001)(81166007)(356005)(36756003)(336012)(83380400001)(2616005)(186003)(66574015)(36860700001)(47076005);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 19:22:56.0695
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45921b95-17e2-40f3-3177-08db570c1e3b
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR06FT058.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB6140
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As suggested by Vincent Mailhol replace the macros used to initialize
the members of struct can_bittiming_const with direct values. Then
also use those struct members to do the calculations in
esd_usb2_set_bittiming().

Link: https://lore.kernel.org/all/CAMZ6RqLaDNy-fZ2G0+QMhUEckkXLL+ZyELVSDFmqpd++aBzZQg@mail.gmail.com/
Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 042dda98b3db..194aa1cf37b5 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -60,18 +60,10 @@ MODULE_LICENSE("GPL v2");
 #define ESD_USB_NO_BAUDRATE	0x7fffffff /* bit rate unconfigured */
 
 /* bit timing CAN-USB/2 */
-#define ESD_USB2_TSEG1_MIN	1
-#define ESD_USB2_TSEG1_MAX	16
 #define ESD_USB2_TSEG1_SHIFT	16
-#define ESD_USB2_TSEG2_MIN	1
-#define ESD_USB2_TSEG2_MAX	8
 #define ESD_USB2_TSEG2_SHIFT	20
-#define ESD_USB2_SJW_MAX	4
 #define ESD_USB2_SJW_SHIFT	14
 #define ESD_USBM_SJW_SHIFT	24
-#define ESD_USB2_BRP_MIN	1
-#define ESD_USB2_BRP_MAX	1024
-#define ESD_USB2_BRP_INC	1
 #define ESD_USB2_3_SAMPLES	0x00800000
 
 /* esd IDADD message */
@@ -909,19 +901,20 @@ static const struct ethtool_ops esd_usb_ethtool_ops = {
 
 static const struct can_bittiming_const esd_usb2_bittiming_const = {
 	.name = "esd_usb2",
-	.tseg1_min = ESD_USB2_TSEG1_MIN,
-	.tseg1_max = ESD_USB2_TSEG1_MAX,
-	.tseg2_min = ESD_USB2_TSEG2_MIN,
-	.tseg2_max = ESD_USB2_TSEG2_MAX,
-	.sjw_max = ESD_USB2_SJW_MAX,
-	.brp_min = ESD_USB2_BRP_MIN,
-	.brp_max = ESD_USB2_BRP_MAX,
-	.brp_inc = ESD_USB2_BRP_INC,
+	.tseg1_min = 1,
+	.tseg1_max = 16,
+	.tseg2_min = 1,
+	.tseg2_max = 8,
+	.sjw_max = 4,
+	.brp_min = 1,
+	.brp_max = 1024,
+	.brp_inc = 1,
 };
 
 static int esd_usb2_set_bittiming(struct net_device *netdev)
 {
 	struct esd_usb_net_priv *priv = netdev_priv(netdev);
+	const struct can_bittiming_const *btc = priv->can.bittiming_const;
 	struct can_bittiming *bt = &priv->can.bittiming;
 	union esd_usb_msg *msg;
 	int err;
@@ -932,7 +925,7 @@ static int esd_usb2_set_bittiming(struct net_device *netdev)
 	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
 		canbtr |= ESD_USB_LOM;
 
-	canbtr |= (bt->brp - 1) & (ESD_USB2_BRP_MAX - 1);
+	canbtr |= (bt->brp - 1) & (btc->brp_max - 1);
 
 	if (le16_to_cpu(priv->usb->udev->descriptor.idProduct) ==
 	    USB_CANUSBM_PRODUCT_ID)
@@ -940,12 +933,12 @@ static int esd_usb2_set_bittiming(struct net_device *netdev)
 	else
 		sjw_shift = ESD_USB2_SJW_SHIFT;
 
-	canbtr |= ((bt->sjw - 1) & (ESD_USB2_SJW_MAX - 1))
+	canbtr |= ((bt->sjw - 1) & (btc->sjw_max - 1))
 		<< sjw_shift;
 	canbtr |= ((bt->prop_seg + bt->phase_seg1 - 1)
-		   & (ESD_USB2_TSEG1_MAX - 1))
+		   & (btc->tseg1_max - 1))
 		<< ESD_USB2_TSEG1_SHIFT;
-	canbtr |= ((bt->phase_seg2 - 1) & (ESD_USB2_TSEG2_MAX - 1))
+	canbtr |= ((bt->phase_seg2 - 1) & (btc->tseg2_max - 1))
 		<< ESD_USB2_TSEG2_SHIFT;
 	if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
 		canbtr |= ESD_USB2_3_SAMPLES;
-- 
2.25.1


