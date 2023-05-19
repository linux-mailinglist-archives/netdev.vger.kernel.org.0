Return-Path: <netdev+bounces-4002-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19AA970A034
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 21:58:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8FB61C21255
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:58:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E7217AD2;
	Fri, 19 May 2023 19:56:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6194617FF3
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 19:56:15 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2118.outbound.protection.outlook.com [40.107.105.118])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48CCE42;
	Fri, 19 May 2023 12:56:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmY6P4Bxj209077/fBzguKImVJ1qo+Ew95EGR8UTk9BAaRZ67XYMYWU+QJ0M99ZNfHu2drknuCliYlHxTQZ85ZwRC1fiADMkIuMbVTs4iWHqZCgrhBVGEkSA+uUe7AO+L+xLsZ9V02iN2bZFGr9tHSdmrDuRJJrOEalgXiF21clDjBPKvSYN1V1jrl82BVdqPwkGCCOAf4FlYJQCCvarBcuRoC4g3APmFw3zWjoh4iduupQKDnFvqMM/DpHm+2aeq/8XQRnv8Wklzmgti0COWL1aIp0YCuhzzXrmDTw6uOLOagiQXdgEJ0ZkRPlHxD3bR3NnlUN8m350ldLlgWGi3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7j0jzpoGDg6DzhkpgltzqiDUi7NICciClzv4WOIhZyY=;
 b=jUH/jOaa932CtuJRsZlMzvRERBiwOHyoo5oBW9vkffYhTXp6yv8Fe5MUzex3IzxKxtQCnS+jwGMDm2WTxR4UHrGi0cc/3d+DOLMYitrCZbte3bA9lHyukDbR4gGhFOpu0phx2Nu3zjkKpIeJj18vw6pQh/fGUjs9KNSbkR6R2IFzVu+cmc5/5Pbu/ycpWqBPIxbyjUY6qmOYgiGewecevLzneGOvOnwlKchhEkWDkLzLgaA/VYyciwibdmNaodA1h6ZdMuzFqM7SmD4KGXIDUOe+uA+Ka0tS7KOHcAzTQHfz1Od3cqGrP3gJZbfNLUC6hkn5Xs0qnO9RVCTG02vBvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7j0jzpoGDg6DzhkpgltzqiDUi7NICciClzv4WOIhZyY=;
 b=D1ppQuUowdD7D0zD7i8kJnraX4uumOPHvgLPA4gjMSyMubwB5Pk/WkcyhQIp7rLQGiBCs2tRNXqhvsh1mPSAkc3ft1Z9mHdjf4Mu1Q1caT66HXaBBxTqmYJ20Vrs1LG+76U/5z9CXw2MNlHJByu8xIMkaFtkJ1MYhNlcGJ9AG38=
Received: from FR0P281CA0200.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:ad::11)
 by PA4PR03MB8136.eurprd03.prod.outlook.com (2603:10a6:102:2a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 19:56:04 +0000
Received: from VI1EUR06FT053.eop-eur06.prod.protection.outlook.com
 (2603:10a6:d10:ad:cafe::e9) by FR0P281CA0200.outlook.office365.com
 (2603:10a6:d10:ad::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.6 via Frontend
 Transport; Fri, 19 May 2023 19:56:04 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT053.mail.protection.outlook.com (10.13.6.63) with Microsoft SMTP
 Server id 15.20.6411.21 via Frontend Transport; Fri, 19 May 2023 19:56:04
 +0000
Received: from esd-s20.esd.local (jenkins.esd [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id E5D1E7C16CC;
	Fri, 19 May 2023 21:56:03 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id D716B2E1805; Fri, 19 May 2023 21:56:03 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v2 3/6] can: esd_usb: Use consistent prefixes for macros
Date: Fri, 19 May 2023 21:55:57 +0200
Message-Id: <20230519195600.420644-4-frank.jungclaus@esd.eu>
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
X-MS-TrafficTypeDiagnostic: VI1EUR06FT053:EE_|PA4PR03MB8136:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 9721e9ac-03b5-490e-fb97-08db58a3140c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	scL/7wo6LOVf3akcl1zy4HXVdhWeqQsIVvmCR0F36YpnOXY/YBxKRD9uWEpDDuos9DUE+xFvlDzRvl61CSloU4am6m3sLI7QpexnqY0iJys+eqiPFnTFmedgAkWXQ13F+jrkOdckbaEf830o2AsLzLugHOHickKiTE1GZQMX3a3nJ6RrQ+8ckdpg8bge/moIr1JC9UeNsieNk3ZI0SF8DEH7/608hrZ14uy+1/dAUsQZ8Kt+mxzpT5G1RIZfFnmQlhH4zi/VJ5QoCptPImhpiVbhY86q7s7UTFaUi1pYfDoDuIZTIxE1ArIdFiABBJD6ujpxteqtBCRb2WY9CtQZSda/PjUoOnlSFPbv52s0pA4EG6zGievRPv2SlYX36vIDgFTUMGBxtOspBz4xebdF4gtjkd5e0poOu55Zhf5LbQu6TYt2WpGWoCxypoJawzUn14TRnkR5sV4aNOodqZzUksiMrrcRnQC9p7qF/I6/UC6g8Rgz4STShcTCSPdF6XP2FYs3GEhUSIiecwMciHTlf2jrM2MmK0S3OeDoxw+LB9JSYSvo2FqG+vcZwbYr2+Rkgq947yjbUiaSs8CnHnK/UwFuFEtTCDlP3Ik3JP/sT8LySPFMIurgp1jZqBue/LUW6mwi3mcQA4sl7rVq6NI8MqZ09CTHzU2JEp3Uc02CrZh7wIlFBGBTXX/ueotFlOnY
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(346002)(396003)(136003)(451199021)(36840700001)(46966006)(36860700001)(36756003)(81166007)(356005)(44832011)(5660300002)(8676002)(8936002)(82310400005)(41300700001)(40480700001)(86362001)(4326008)(316002)(70206006)(70586007)(966005)(47076005)(66574015)(336012)(1076003)(26005)(110136005)(30864003)(186003)(2906002)(6666004)(478600001)(6266002)(2616005)(83380400001)(54906003)(42186006);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 19:56:04.1428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9721e9ac-03b5-490e-fb97-08db58a3140c
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	VI1EUR06FT053.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB8136
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add the consistent prefix ESD_USB_ to all macros defined within
esd_usb.c.
For macros specific to esd CAN-USB/2 use ESD_USB_2_ as prefix.
For macros specific to esd CAN-USB/Micro use ESD_USB_M_ as prefix.
Change the macro ESD_USB_3_SAMPLES to ESD_USB_TRIPLE_SAMPLES to not
mix up with the prefix ESD_USB_3_ which will be introduced for the
CAN-USB/3 device.

Link: https://lore.kernel.org/all/CAMZ6RqLaDNy-fZ2G0+QMhUEckkXLL+ZyELVSDFmqpd++aBzZQg@mail.gmail.com/
Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 198 +++++++++++++++++-----------------
 1 file changed, 99 insertions(+), 99 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 2eecf352ec47..9b0ed07911e1 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -23,33 +23,33 @@ MODULE_DESCRIPTION("CAN driver for esd electronics gmbh CAN-USB/2 and CAN-USB/Mi
 MODULE_LICENSE("GPL v2");
 
 /* USB vendor and product ID */
-#define USB_ESDGMBH_VENDOR_ID	0x0ab4
-#define USB_CANUSB2_PRODUCT_ID	0x0010
-#define USB_CANUSBM_PRODUCT_ID	0x0011
+#define ESD_USB_ESDGMBH_VENDOR_ID	0x0ab4
+#define ESD_USB_CANUSB2_PRODUCT_ID	0x0010
+#define ESD_USB_CANUSBM_PRODUCT_ID	0x0011
 
 /* CAN controller clock frequencies */
-#define ESD_USB2_CAN_CLOCK	(60 * MEGA) /* Hz */
-#define ESD_USBM_CAN_CLOCK	(36 * MEGA) /* Hz */
+#define ESD_USB_2_CAN_CLOCK	(60 * MEGA) /* Hz */
+#define ESD_USB_M_CAN_CLOCK	(36 * MEGA) /* Hz */
 
 /* Maximum number of CAN nets */
 #define ESD_USB_MAX_NETS	2
 
 /* USB commands */
-#define CMD_VERSION		1 /* also used for VERSION_REPLY */
-#define CMD_CAN_RX		2 /* device to host only */
-#define CMD_CAN_TX		3 /* also used for TX_DONE */
-#define CMD_SETBAUD		4 /* also used for SETBAUD_REPLY */
-#define CMD_TS			5 /* also used for TS_REPLY */
-#define CMD_IDADD		6 /* also used for IDADD_REPLY */
+#define ESD_USB_CMD_VERSION		1 /* also used for VERSION_REPLY */
+#define ESD_USB_CMD_CAN_RX		2 /* device to host only */
+#define ESD_USB_CMD_CAN_TX		3 /* also used for TX_DONE */
+#define ESD_USB_CMD_SETBAUD		4 /* also used for SETBAUD_REPLY */
+#define ESD_USB_CMD_TS			5 /* also used for TS_REPLY */
+#define ESD_USB_CMD_IDADD		6 /* also used for IDADD_REPLY */
 
 /* esd CAN message flags - dlc field */
 #define ESD_RTR	BIT(4)
 
 
 /* esd CAN message flags - id field */
-#define ESD_EXTID	BIT(29)
-#define ESD_EVENT	BIT(30)
-#define ESD_IDMASK	GENMASK(28, 0)
+#define ESD_USB_EXTID	BIT(29)
+#define ESD_USB_EVENT	BIT(30)
+#define ESD_USB_IDMASK	GENMASK(28, 0)
 
 /* esd CAN event ids */
 #define ESD_EV_CAN_ERROR_EXT	2 /* CAN controller specific diagnostic data */
@@ -59,35 +59,35 @@ MODULE_LICENSE("GPL v2");
 #define ESD_USB_UBR	BIT(31) /* 0x80000000, User Bit Rate (controller BTR) in bits 0..27 */
 #define ESD_USB_NO_BAUDRATE	GENMASK(30, 0) /* bit rate unconfigured */
 
-/* bit timing CAN-USB/2 */
-#define ESD_USB2_TSEG1_SHIFT	16
-#define ESD_USB2_TSEG2_SHIFT	20
-#define ESD_USB2_SJW_SHIFT	14
-#define ESD_USBM_SJW_SHIFT	24
-#define ESD_USB2_3_SAMPLES	BIT(23)
+/* bit timing esd CAN-USB */
+#define ESD_USB_2_TSEG1_SHIFT	16
+#define ESD_USB_2_TSEG2_SHIFT	20
+#define ESD_USB_2_SJW_SHIFT	14
+#define ESD_USB_M_SJW_SHIFT	24
+#define ESD_USB_TRIPLE_SAMPLES	BIT(23)
 
 /* esd IDADD message */
-#define ESD_ID_ENABLE		0x80
-#define ESD_MAX_ID_SEGMENT	64
+#define ESD_USB_ID_ENABLE	0x80
+#define ESD_USB_MAX_ID_SEGMENT	64
 
 /* SJA1000 ECC register (emulated by usb firmware) */
-#define SJA1000_ECC_SEG		0x1F
-#define SJA1000_ECC_DIR		0x20
-#define SJA1000_ECC_ERR		0x06
-#define SJA1000_ECC_BIT		0x00
-#define SJA1000_ECC_FORM	0x40
-#define SJA1000_ECC_STUFF	0x80
-#define SJA1000_ECC_MASK	0xc0
+#define ESD_USB_SJA1000_ECC_SEG		0x1F
+#define ESD_USB_SJA1000_ECC_DIR		0x20
+#define ESD_USB_SJA1000_ECC_ERR		0x06
+#define ESD_USB_SJA1000_ECC_BIT		0x00
+#define ESD_USB_SJA1000_ECC_FORM	0x40
+#define ESD_USB_SJA1000_ECC_STUFF	0x80
+#define ESD_USB_SJA1000_ECC_MASK	0xc0
 
 /* esd bus state event codes */
-#define ESD_BUSSTATE_MASK	0xc0
-#define ESD_BUSSTATE_WARN	0x40
-#define ESD_BUSSTATE_ERRPASSIVE	0x80
-#define ESD_BUSSTATE_BUSOFF	0xc0
+#define ESD_USB_BUSSTATE_MASK	0xc0
+#define ESD_USB_BUSSTATE_WARN	0x40
+#define ESD_USB_BUSSTATE_ERRPASSIVE	0x80
+#define ESD_USB_BUSSTATE_BUSOFF	0xc0
 
-#define RX_BUFFER_SIZE		1024
-#define MAX_RX_URBS		4
-#define MAX_TX_URBS		16 /* must be power of 2 */
+#define ESD_USB_RX_BUFFER_SIZE		1024
+#define ESD_USB_MAX_RX_URBS		4
+#define ESD_USB_MAX_TX_URBS		16 /* must be power of 2 */
 
 struct header_msg {
 	u8 len; /* len is always the total message length in 32bit words */
@@ -156,7 +156,7 @@ struct id_filter_msg {
 	u8 cmd;
 	u8 net;
 	u8 option;
-	__le32 mask[ESD_MAX_ID_SEGMENT + 1];
+	__le32 mask[ESD_USB_MAX_ID_SEGMENT + 1];
 };
 
 struct set_baudrate_msg {
@@ -180,8 +180,8 @@ union __packed esd_usb_msg {
 };
 
 static struct usb_device_id esd_usb_table[] = {
-	{USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSB2_PRODUCT_ID)},
-	{USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSBM_PRODUCT_ID)},
+	{USB_DEVICE(ESD_USB_ESDGMBH_VENDOR_ID, ESD_USB_CANUSB2_PRODUCT_ID)},
+	{USB_DEVICE(ESD_USB_ESDGMBH_VENDOR_ID, ESD_USB_CANUSBM_PRODUCT_ID)},
 	{}
 };
 MODULE_DEVICE_TABLE(usb, esd_usb_table);
@@ -202,8 +202,8 @@ struct esd_usb {
 	int net_count;
 	u32 version;
 	int rxinitdone;
-	void *rxbuf[MAX_RX_URBS];
-	dma_addr_t rxbuf_dma[MAX_RX_URBS];
+	void *rxbuf[ESD_USB_MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[ESD_USB_MAX_RX_URBS];
 };
 
 struct esd_usb_net_priv {
@@ -211,7 +211,7 @@ struct esd_usb_net_priv {
 
 	atomic_t active_tx_jobs;
 	struct usb_anchor tx_submitted;
-	struct esd_tx_urb_context tx_contexts[MAX_TX_URBS];
+	struct esd_tx_urb_context tx_contexts[ESD_USB_MAX_TX_URBS];
 
 	struct esd_usb *usb;
 	struct net_device *netdev;
@@ -226,7 +226,7 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 	struct net_device_stats *stats = &priv->netdev->stats;
 	struct can_frame *cf;
 	struct sk_buff *skb;
-	u32 id = le32_to_cpu(msg->rx.id) & ESD_IDMASK;
+	u32 id = le32_to_cpu(msg->rx.id) & ESD_USB_IDMASK;
 
 	if (id == ESD_EV_CAN_ERROR_EXT) {
 		u8 state = msg->rx.ev_can_err_ext.status;
@@ -255,15 +255,15 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 
 			priv->old_state = state;
 
-			switch (state & ESD_BUSSTATE_MASK) {
-			case ESD_BUSSTATE_BUSOFF:
+			switch (state & ESD_USB_BUSSTATE_MASK) {
+			case ESD_USB_BUSSTATE_BUSOFF:
 				new_state = CAN_STATE_BUS_OFF;
 				can_bus_off(priv->netdev);
 				break;
-			case ESD_BUSSTATE_WARN:
+			case ESD_USB_BUSSTATE_WARN:
 				new_state = CAN_STATE_ERROR_WARNING;
 				break;
-			case ESD_BUSSTATE_ERRPASSIVE:
+			case ESD_USB_BUSSTATE_ERRPASSIVE:
 				new_state = CAN_STATE_ERROR_PASSIVE;
 				break;
 			default:
@@ -285,14 +285,14 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 
 			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
-			switch (ecc & SJA1000_ECC_MASK) {
-			case SJA1000_ECC_BIT:
+			switch (ecc & ESD_USB_SJA1000_ECC_MASK) {
+			case ESD_USB_SJA1000_ECC_BIT:
 				cf->data[2] |= CAN_ERR_PROT_BIT;
 				break;
-			case SJA1000_ECC_FORM:
+			case ESD_USB_SJA1000_ECC_FORM:
 				cf->data[2] |= CAN_ERR_PROT_FORM;
 				break;
-			case SJA1000_ECC_STUFF:
+			case ESD_USB_SJA1000_ECC_STUFF:
 				cf->data[2] |= CAN_ERR_PROT_STUFF;
 				break;
 			default:
@@ -300,11 +300,11 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 			}
 
 			/* Error occurred during transmission? */
-			if (!(ecc & SJA1000_ECC_DIR))
+			if (!(ecc & ESD_USB_SJA1000_ECC_DIR))
 				cf->data[2] |= CAN_ERR_PROT_TX;
 
 			/* Bit stream position in CAN frame as the error was detected */
-			cf->data[3] = ecc & SJA1000_ECC_SEG;
+			cf->data[3] = ecc & ESD_USB_SJA1000_ECC_SEG;
 		}
 
 		if (skb) {
@@ -331,7 +331,7 @@ static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
 
 	id = le32_to_cpu(msg->rx.id);
 
-	if (id & ESD_EVENT) {
+	if (id & ESD_USB_EVENT) {
 		esd_usb_rx_event(priv, msg);
 	} else {
 		skb = alloc_can_skb(priv->netdev, &cf);
@@ -340,11 +340,11 @@ static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
 			return;
 		}
 
-		cf->can_id = id & ESD_IDMASK;
+		cf->can_id = id & ESD_USB_IDMASK;
 		can_frame_set_cc_len(cf, msg->rx.dlc & ~ESD_RTR,
 				     priv->can.ctrlmode);
 
-		if (id & ESD_EXTID)
+		if (id & ESD_USB_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
 
 		if (msg->rx.dlc & ESD_RTR) {
@@ -371,7 +371,7 @@ static void esd_usb_tx_done_msg(struct esd_usb_net_priv *priv,
 	if (!netif_device_present(netdev))
 		return;
 
-	context = &priv->tx_contexts[msg->txdone.hnd & (MAX_TX_URBS - 1)];
+	context = &priv->tx_contexts[msg->txdone.hnd & (ESD_USB_MAX_TX_URBS - 1)];
 
 	if (!msg->txdone.status) {
 		stats->tx_packets++;
@@ -383,7 +383,7 @@ static void esd_usb_tx_done_msg(struct esd_usb_net_priv *priv,
 	}
 
 	/* Release context */
-	context->echo_index = MAX_TX_URBS;
+	context->echo_index = ESD_USB_MAX_TX_URBS;
 	atomic_dec(&priv->active_tx_jobs);
 
 	netif_wake_queue(netdev);
@@ -418,7 +418,7 @@ static void esd_usb_read_bulk_callback(struct urb *urb)
 		msg = (union esd_usb_msg *)(urb->transfer_buffer + pos);
 
 		switch (msg->hdr.cmd) {
-		case CMD_CAN_RX:
+		case ESD_USB_CMD_CAN_RX:
 			if (msg->rx.net >= dev->net_count) {
 				dev_err(dev->udev->dev.parent, "format error\n");
 				break;
@@ -427,7 +427,7 @@ static void esd_usb_read_bulk_callback(struct urb *urb)
 			esd_usb_rx_can_msg(dev->nets[msg->rx.net], msg);
 			break;
 
-		case CMD_CAN_TX:
+		case ESD_USB_CMD_CAN_TX:
 			if (msg->txdone.net >= dev->net_count) {
 				dev_err(dev->udev->dev.parent, "format error\n");
 				break;
@@ -448,7 +448,7 @@ static void esd_usb_read_bulk_callback(struct urb *urb)
 
 resubmit_urb:
 	usb_fill_bulk_urb(urb, dev->udev, usb_rcvbulkpipe(dev->udev, 1),
-			  urb->transfer_buffer, RX_BUFFER_SIZE,
+			  urb->transfer_buffer, ESD_USB_RX_BUFFER_SIZE,
 			  esd_usb_read_bulk_callback, dev);
 
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
@@ -557,7 +557,7 @@ static int esd_usb_setup_rx_urbs(struct esd_usb *dev)
 	if (dev->rxinitdone)
 		return 0;
 
-	for (i = 0; i < MAX_RX_URBS; i++) {
+	for (i = 0; i < ESD_USB_MAX_RX_URBS; i++) {
 		struct urb *urb = NULL;
 		u8 *buf = NULL;
 		dma_addr_t buf_dma;
@@ -569,7 +569,7 @@ static int esd_usb_setup_rx_urbs(struct esd_usb *dev)
 			break;
 		}
 
-		buf = usb_alloc_coherent(dev->udev, RX_BUFFER_SIZE, GFP_KERNEL,
+		buf = usb_alloc_coherent(dev->udev, ESD_USB_RX_BUFFER_SIZE, GFP_KERNEL,
 					 &buf_dma);
 		if (!buf) {
 			dev_warn(dev->udev->dev.parent,
@@ -582,7 +582,7 @@ static int esd_usb_setup_rx_urbs(struct esd_usb *dev)
 
 		usb_fill_bulk_urb(urb, dev->udev,
 				  usb_rcvbulkpipe(dev->udev, 1),
-				  buf, RX_BUFFER_SIZE,
+				  buf, ESD_USB_RX_BUFFER_SIZE,
 				  esd_usb_read_bulk_callback, dev);
 		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 		usb_anchor_urb(urb, &dev->rx_submitted);
@@ -590,7 +590,7 @@ static int esd_usb_setup_rx_urbs(struct esd_usb *dev)
 		err = usb_submit_urb(urb, GFP_KERNEL);
 		if (err) {
 			usb_unanchor_urb(urb);
-			usb_free_coherent(dev->udev, RX_BUFFER_SIZE, buf,
+			usb_free_coherent(dev->udev, ESD_USB_RX_BUFFER_SIZE, buf,
 					  urb->transfer_dma);
 			goto freeurb;
 		}
@@ -612,7 +612,7 @@ static int esd_usb_setup_rx_urbs(struct esd_usb *dev)
 	}
 
 	/* Warn if we've couldn't transmit all the URBs */
-	if (i < MAX_RX_URBS) {
+	if (i < ESD_USB_MAX_RX_URBS) {
 		dev_warn(dev->udev->dev.parent,
 			 "rx performance may be slow\n");
 	}
@@ -647,14 +647,14 @@ static int esd_usb_start(struct esd_usb_net_priv *priv)
 	 * the number of the starting bitmask (0..64) to the filter.option
 	 * field followed by only some bitmasks.
 	 */
-	msg->hdr.cmd = CMD_IDADD;
-	msg->hdr.len = 2 + ESD_MAX_ID_SEGMENT;
+	msg->hdr.cmd = ESD_USB_CMD_IDADD;
+	msg->hdr.len = 2 + ESD_USB_MAX_ID_SEGMENT;
 	msg->filter.net = priv->index;
-	msg->filter.option = ESD_ID_ENABLE; /* start with segment 0 */
-	for (i = 0; i < ESD_MAX_ID_SEGMENT; i++)
+	msg->filter.option = ESD_USB_ID_ENABLE; /* start with segment 0 */
+	for (i = 0; i < ESD_USB_MAX_ID_SEGMENT; i++)
 		msg->filter.mask[i] = cpu_to_le32(0xffffffff);
 	/* enable 29bit extended IDs */
-	msg->filter.mask[ESD_MAX_ID_SEGMENT] = cpu_to_le32(0x00000001);
+	msg->filter.mask[ESD_USB_MAX_ID_SEGMENT] = cpu_to_le32(0x00000001);
 
 	err = esd_usb_send_msg(dev, msg);
 	if (err)
@@ -683,8 +683,8 @@ static void unlink_all_urbs(struct esd_usb *dev)
 
 	usb_kill_anchored_urbs(&dev->rx_submitted);
 
-	for (i = 0; i < MAX_RX_URBS; ++i)
-		usb_free_coherent(dev->udev, RX_BUFFER_SIZE,
+	for (i = 0; i < ESD_USB_MAX_RX_URBS; ++i)
+		usb_free_coherent(dev->udev, ESD_USB_RX_BUFFER_SIZE,
 				  dev->rxbuf[i], dev->rxbuf_dma[i]);
 
 	for (i = 0; i < dev->net_count; i++) {
@@ -693,8 +693,8 @@ static void unlink_all_urbs(struct esd_usb *dev)
 			usb_kill_anchored_urbs(&priv->tx_submitted);
 			atomic_set(&priv->active_tx_jobs, 0);
 
-			for (j = 0; j < MAX_TX_URBS; j++)
-				priv->tx_contexts[j].echo_index = MAX_TX_URBS;
+			for (j = 0; j < ESD_USB_MAX_TX_URBS; j++)
+				priv->tx_contexts[j].echo_index = ESD_USB_MAX_TX_URBS;
 		}
 	}
 }
@@ -760,7 +760,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 	msg = (union esd_usb_msg *)buf;
 
 	msg->hdr.len = 3; /* minimal length */
-	msg->hdr.cmd = CMD_CAN_TX;
+	msg->hdr.cmd = ESD_USB_CMD_CAN_TX;
 	msg->tx.net = priv->index;
 	msg->tx.dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
 	msg->tx.id = cpu_to_le32(cf->can_id & CAN_ERR_MASK);
@@ -769,15 +769,15 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 		msg->tx.dlc |= ESD_RTR;
 
 	if (cf->can_id & CAN_EFF_FLAG)
-		msg->tx.id |= cpu_to_le32(ESD_EXTID);
+		msg->tx.id |= cpu_to_le32(ESD_USB_EXTID);
 
 	for (i = 0; i < cf->len; i++)
 		msg->tx.data[i] = cf->data[i];
 
 	msg->hdr.len += (cf->len + 3) >> 2;
 
-	for (i = 0; i < MAX_TX_URBS; i++) {
-		if (priv->tx_contexts[i].echo_index == MAX_TX_URBS) {
+	for (i = 0; i < ESD_USB_MAX_TX_URBS; i++) {
+		if (priv->tx_contexts[i].echo_index == ESD_USB_MAX_TX_URBS) {
 			context = &priv->tx_contexts[i];
 			break;
 		}
@@ -809,7 +809,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 	atomic_inc(&priv->active_tx_jobs);
 
 	/* Slow down tx path */
-	if (atomic_read(&priv->active_tx_jobs) >= MAX_TX_URBS)
+	if (atomic_read(&priv->active_tx_jobs) >= ESD_USB_MAX_TX_URBS)
 		netif_stop_queue(netdev);
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
@@ -859,18 +859,18 @@ static int esd_usb_close(struct net_device *netdev)
 		return -ENOMEM;
 
 	/* Disable all IDs (see esd_usb_start()) */
-	msg->hdr.cmd = CMD_IDADD;
-	msg->hdr.len = 2 + ESD_MAX_ID_SEGMENT;
+	msg->hdr.cmd = ESD_USB_CMD_IDADD;
+	msg->hdr.len = 2 + ESD_USB_MAX_ID_SEGMENT;
 	msg->filter.net = priv->index;
-	msg->filter.option = ESD_ID_ENABLE; /* start with segment 0 */
-	for (i = 0; i <= ESD_MAX_ID_SEGMENT; i++)
+	msg->filter.option = ESD_USB_ID_ENABLE; /* start with segment 0 */
+	for (i = 0; i <= ESD_USB_MAX_ID_SEGMENT; i++)
 		msg->filter.mask[i] = 0;
 	if (esd_usb_send_msg(priv->usb, msg) < 0)
 		netdev_err(netdev, "sending idadd message failed\n");
 
 	/* set CAN controller to reset mode */
 	msg->hdr.len = 2;
-	msg->hdr.cmd = CMD_SETBAUD;
+	msg->hdr.cmd = ESD_USB_CMD_SETBAUD;
 	msg->setbaud.net = priv->index;
 	msg->setbaud.rsvd = 0;
 	msg->setbaud.baud = cpu_to_le32(ESD_USB_NO_BAUDRATE);
@@ -928,27 +928,27 @@ static int esd_usb2_set_bittiming(struct net_device *netdev)
 	canbtr |= (bt->brp - 1) & (btc->brp_max - 1);
 
 	if (le16_to_cpu(priv->usb->udev->descriptor.idProduct) ==
-	    USB_CANUSBM_PRODUCT_ID)
-		sjw_shift = ESD_USBM_SJW_SHIFT;
+	    ESD_USB_CANUSBM_PRODUCT_ID)
+		sjw_shift = ESD_USB_M_SJW_SHIFT;
 	else
-		sjw_shift = ESD_USB2_SJW_SHIFT;
+		sjw_shift = ESD_USB_2_SJW_SHIFT;
 
 	canbtr |= ((bt->sjw - 1) & (btc->sjw_max - 1))
 		<< sjw_shift;
 	canbtr |= ((bt->prop_seg + bt->phase_seg1 - 1)
 		   & (btc->tseg1_max - 1))
-		<< ESD_USB2_TSEG1_SHIFT;
+		<< ESD_USB_2_TSEG1_SHIFT;
 	canbtr |= ((bt->phase_seg2 - 1) & (btc->tseg2_max - 1))
-		<< ESD_USB2_TSEG2_SHIFT;
+		<< ESD_USB_2_TSEG2_SHIFT;
 	if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
-		canbtr |= ESD_USB2_3_SAMPLES;
+		canbtr |= ESD_USB_TRIPLE_SAMPLES;
 
 	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
 	msg->hdr.len = 2;
-	msg->hdr.cmd = CMD_SETBAUD;
+	msg->hdr.cmd = ESD_USB_CMD_SETBAUD;
 	msg->setbaud.net = priv->index;
 	msg->setbaud.rsvd = 0;
 	msg->setbaud.baud = cpu_to_le32(canbtr);
@@ -994,7 +994,7 @@ static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
 	int err = 0;
 	int i;
 
-	netdev = alloc_candev(sizeof(*priv), MAX_TX_URBS);
+	netdev = alloc_candev(sizeof(*priv), ESD_USB_MAX_TX_URBS);
 	if (!netdev) {
 		dev_err(&intf->dev, "couldn't alloc candev\n");
 		err = -ENOMEM;
@@ -1006,8 +1006,8 @@ static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
 	init_usb_anchor(&priv->tx_submitted);
 	atomic_set(&priv->active_tx_jobs, 0);
 
-	for (i = 0; i < MAX_TX_URBS; i++)
-		priv->tx_contexts[i].echo_index = MAX_TX_URBS;
+	for (i = 0; i < ESD_USB_MAX_TX_URBS; i++)
+		priv->tx_contexts[i].echo_index = ESD_USB_MAX_TX_URBS;
 
 	priv->usb = dev;
 	priv->netdev = netdev;
@@ -1019,10 +1019,10 @@ static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
 		CAN_CTRLMODE_BERR_REPORTING;
 
 	if (le16_to_cpu(dev->udev->descriptor.idProduct) ==
-	    USB_CANUSBM_PRODUCT_ID)
-		priv->can.clock.freq = ESD_USBM_CAN_CLOCK;
+	    ESD_USB_CANUSBM_PRODUCT_ID)
+		priv->can.clock.freq = ESD_USB_M_CAN_CLOCK;
 	else {
-		priv->can.clock.freq = ESD_USB2_CAN_CLOCK;
+		priv->can.clock.freq = ESD_USB_2_CAN_CLOCK;
 		priv->can.ctrlmode_supported |= CAN_CTRLMODE_3_SAMPLES;
 	}
 
@@ -1085,7 +1085,7 @@ static int esd_usb_probe(struct usb_interface *intf,
 	}
 
 	/* query number of CAN interfaces (nets) */
-	msg->hdr.cmd = CMD_VERSION;
+	msg->hdr.cmd = ESD_USB_CMD_VERSION;
 	msg->hdr.len = 2;
 	msg->version.rsvd = 0;
 	msg->version.flags = 0;
-- 
2.25.1


