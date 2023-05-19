Return-Path: <netdev+bounces-4001-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A6CF70A032
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 21:57:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 394F1281DC3
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A0517ADF;
	Fri, 19 May 2023 19:56:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF48E17AD9
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 19:56:12 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2139.outbound.protection.outlook.com [40.107.6.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E285F1B4;
	Fri, 19 May 2023 12:56:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jn6XX/OZYFQe1Rfjdm0oKgDpIMIAkvoOiw3h7brbWfvkRr4XcmwovvwYy+XYubaj1PNKb3mwsKfpGgh7a9FxIY8OdbatTf9ui0YZiCMpLg5ku2cSCXqF0gI2BE5aPs5Axt8gLtA+URbtgQQe6OOLd0KTxpR/EC7xvkGjGlro22UF/LF498ZuuyEB8YsC1AMvOaBKNuPTJOmr3kznht0HzPBjn/8lIu620YowcoT5B5OJw3dqIVLDZ6XNqcbejHEdeD19QlvaTcNfi9bAtF6wbn/oMUh+bp2wEGwGNCMr8AgsFh7TOjqGQ1UQHZujyzAfo93EwruxFdP9O+xdmRymfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7u7MfbXXxyu+oHfti46b3fZL16UY7l36bKmbY8pMT6Q=;
 b=fSWNYS2DlJILTYvmvIptCIu+tOL8a0WxUiw+107sMVn9CraZp8jeXG2G/EVxPiVKzPFr8j4o//pX9V+I4r3uYz7roJOrLCdvu54RnQvr+qUql0WfkwrqcDdQGdFvmMLYtoygaEJx8ebYqb5TnrkK706aGslhJZYtUwKoPeeVeJQPjgSS0oOdTynCn1YzDSPwAfHrMlrkKcKHssqGEKpGGhvICf5D0VWwt59aRacfQknvZTsqaY3+78bteaBypOeqFrmj8bOQ1mFIEhe/YsrGb/lnktV1pS73BuSZ3fMfP7HQdeFrcWgsYh85jrMYVRc8Jb5bW1xRl4DNx1GAR7vl/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7u7MfbXXxyu+oHfti46b3fZL16UY7l36bKmbY8pMT6Q=;
 b=KiBjCYOhY6/gIy7SCRf/fQjUFyyWzzym/MRnFet2hX5zLaNa7bGA4qZY27vUyb7Ibmz90HR4L2JZq5k5Ryr6WnhoL0tBpVE799d1GXad945qkspKo/adjRQ55V3gT6iu0qq9YHEmN1M9giuKIK5XYB3jV/eEQ8aVkKQRszB3daA=
Received: from FR3P281CA0174.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a0::17)
 by DB9PR03MB8282.eurprd03.prod.outlook.com (2603:10a6:10:309::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 19:56:05 +0000
Received: from VI1EUR06FT049.eop-eur06.prod.protection.outlook.com
 (2603:10a6:d10:a0:cafe::af) by FR3P281CA0174.outlook.office365.com
 (2603:10a6:d10:a0::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.7 via Frontend
 Transport; Fri, 19 May 2023 19:56:05 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT049.mail.protection.outlook.com (10.13.6.72) with Microsoft SMTP
 Server id 15.20.6411.21 via Frontend Transport; Fri, 19 May 2023 19:56:05
 +0000
Received: from esd-s20.esd.local (jenkins.esd [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id E69A47C16CD;
	Fri, 19 May 2023 21:56:03 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id DF0D72E1807; Fri, 19 May 2023 21:56:03 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v2 5/6] can: esd_usb: Replace hardcoded message length given to USB commands
Date: Fri, 19 May 2023 21:55:59 +0200
Message-Id: <20230519195600.420644-6-frank.jungclaus@esd.eu>
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
X-MS-TrafficTypeDiagnostic: VI1EUR06FT049:EE_|DB9PR03MB8282:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 50b0d34f-c5ec-4652-025a-08db58a3149d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	43gQtSN//dtmBFPPqBF3Qm+4URxBv1TPBWdRHRKbcfoeoBZn/8s4vq5U3UOfLnpxpjzBa7cng0JP1KWucy8PSfdQ2/HYPjHDVIkLRAj2VfAsfL6dIFLcjqyZa7r3bZPB0JjvYoG9I6cvFU0kpGf91XII+mm9mJcBxY/IIWCfD+3qgWmQOQjt7a+SeOQeI1hVWxfmeCBNb9q0PzajE/tMidfIoVHRhC6ENTs5AuCWic8oXS2o9ZFB1NWZqz7bMcNa+vOL6oEukzL1UWGu9vaa6PwcqMsczM090EriscW1aATkmB1NON/cy3a7JkKHjrxEvuvJFcZN+kw+6u1JbNVP/sUbR8oHFbTjoIRg2SE0AyxIF73Lsds5T/3yc+S/dW9y19Pemdfw1K2y8sINqjtymiqJjyMrZHm5j/UksNC3B4PmjDwJXIlFah1mdTO11rsikBGHpLhr1oqt9Wi3rWXJHWgI6ZLZz9W5O2fIAIM4KVaPks/pNoGJYFG+5EXhb735VEWGYPK5zlwscTLZQr7beGufCZ4vQg+8jTtJiORmezayKFbtvo/MC+bX2nr9T8hUpy5aAMg0bAG/Anv4WLu0WaV9vwYHMwY1QKw1BRa1MJYWkvY/jCLe1CKtu7KmVq0AFQ6aBkjoYHmGfaCXNHk5oo+pv59hwa7+XY6xU0cmDRlhvU2Rt+lPxyENy/I/A2MRgXu8kR5EXuOnJ9tAarx9xh5EJb88NsFhN3OahOsPg/M=
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(346002)(39840400004)(451199021)(36840700001)(46966006)(2906002)(316002)(15650500001)(42186006)(478600001)(41300700001)(8936002)(8676002)(4326008)(110136005)(54906003)(5660300002)(44832011)(6666004)(70586007)(70206006)(966005)(26005)(1076003)(81166007)(186003)(6266002)(356005)(83380400001)(36860700001)(40480700001)(47076005)(43170500006)(36756003)(2616005)(82310400005)(86362001)(336012);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 19:56:05.0867
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b0d34f-c5ec-4652-025a-08db58a3149d
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	VI1EUR06FT049.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB8282
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Replace all hardcoded values supplied to the len element of
esd_usb_msg (and its siblings) by more readable expressions, based on
sizeof(), offsetof(), etc.
Also spend documentation / comments that the len element of esd_usb_msg
is in multiples of 32bit words and not in bytes.

Link: https://lore.kernel.org/all/CAMZ6RqLaDNy-fZ2G0+QMhUEckkXLL+ZyELVSDFmqpd++aBzZQg@mail.gmail.com/
Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 40 ++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 24eebb7ee5f1..a6a3ecb6eac6 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -90,13 +90,13 @@ MODULE_LICENSE("GPL v2");
 #define ESD_USB_MAX_TX_URBS		16 /* must be power of 2 */
 
 struct esd_usb_header_msg {
-	u8 len; /* len is always the total message length in 32bit words */
+	u8 len; /* total message length in 32bit words */
 	u8 cmd;
 	u8 rsvd[2];
 };
 
 struct esd_usb_version_msg {
-	u8 len;
+	u8 len; /* total message length in 32bit words */
 	u8 cmd;
 	u8 rsvd;
 	u8 flags;
@@ -104,7 +104,7 @@ struct esd_usb_version_msg {
 };
 
 struct esd_usb_version_reply_msg {
-	u8 len;
+	u8 len; /* total message length in 32bit words */
 	u8 cmd;
 	u8 nets;
 	u8 features;
@@ -115,7 +115,7 @@ struct esd_usb_version_reply_msg {
 };
 
 struct esd_usb_rx_msg {
-	u8 len;
+	u8 len; /* total message length in 32bit words */
 	u8 cmd;
 	u8 net;
 	u8 dlc;
@@ -133,7 +133,7 @@ struct esd_usb_rx_msg {
 };
 
 struct esd_usb_tx_msg {
-	u8 len;
+	u8 len; /* total message length in 32bit words */
 	u8 cmd;
 	u8 net;
 	u8 dlc;
@@ -143,7 +143,7 @@ struct esd_usb_tx_msg {
 };
 
 struct esd_usb_tx_done_msg {
-	u8 len;
+	u8 len; /* total message length in 32bit words */
 	u8 cmd;
 	u8 net;
 	u8 status;
@@ -152,15 +152,15 @@ struct esd_usb_tx_done_msg {
 };
 
 struct esd_usb_id_filter_msg {
-	u8 len;
+	u8 len; /* total message length in 32bit words */
 	u8 cmd;
 	u8 net;
 	u8 option;
-	__le32 mask[ESD_USB_MAX_ID_SEGMENT + 1];
+	__le32 mask[ESD_USB_MAX_ID_SEGMENT + 1]; /* +1 for 29bit extended IDs */
 };
 
 struct esd_usb_set_baudrate_msg {
-	u8 len;
+	u8 len; /* total message length in 32bit words */
 	u8 cmd;
 	u8 net;
 	u8 rsvd;
@@ -438,7 +438,7 @@ static void esd_usb_read_bulk_callback(struct urb *urb)
 			break;
 		}
 
-		pos += msg->hdr.len << 2;
+		pos += msg->hdr.len * sizeof(u32); /* convert to # of bytes */
 
 		if (pos > urb->actual_length) {
 			dev_err(dev->udev->dev.parent, "format error\n");
@@ -532,7 +532,7 @@ static int esd_usb_send_msg(struct esd_usb *dev, union esd_usb_msg *msg)
 	return usb_bulk_msg(dev->udev,
 			    usb_sndbulkpipe(dev->udev, 2),
 			    msg,
-			    msg->hdr.len << 2,
+			    msg->hdr.len * sizeof(u32), /* convert to # of bytes */
 			    &actual_length,
 			    1000);
 }
@@ -648,7 +648,7 @@ static int esd_usb_start(struct esd_usb_net_priv *priv)
 	 * field followed by only some bitmasks.
 	 */
 	msg->hdr.cmd = ESD_USB_CMD_IDADD;
-	msg->hdr.len = 2 + ESD_USB_MAX_ID_SEGMENT;
+	msg->hdr.len = sizeof(struct esd_usb_id_filter_msg) / sizeof(u32); /* # of 32bit words */
 	msg->filter.net = priv->index;
 	msg->filter.option = ESD_USB_ID_ENABLE; /* start with segment 0 */
 	for (i = 0; i < ESD_USB_MAX_ID_SEGMENT; i++)
@@ -759,7 +759,8 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 
 	msg = (union esd_usb_msg *)buf;
 
-	msg->hdr.len = 3; /* minimal length */
+	/* minimal length as # of 32bit words */
+	msg->hdr.len = offsetof(struct esd_usb_tx_msg, data) / sizeof(u32);
 	msg->hdr.cmd = ESD_USB_CMD_CAN_TX;
 	msg->tx.net = priv->index;
 	msg->tx.dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
@@ -774,7 +775,8 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 	for (i = 0; i < cf->len; i++)
 		msg->tx.data[i] = cf->data[i];
 
-	msg->hdr.len += (cf->len + 3) >> 2;
+	/* round up, then divide by 4 to add the payload length as # of 32bit words */
+	msg->hdr.len += DIV_ROUND_UP(cf->len, sizeof(u32));
 
 	for (i = 0; i < ESD_USB_MAX_TX_URBS; i++) {
 		if (priv->tx_contexts[i].echo_index == ESD_USB_MAX_TX_URBS) {
@@ -797,7 +799,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 	msg->tx.hnd = 0x80000000 | i; /* returned in TX done message */
 
 	usb_fill_bulk_urb(urb, dev->udev, usb_sndbulkpipe(dev->udev, 2), buf,
-			  msg->hdr.len << 2,
+			  msg->hdr.len * sizeof(u32), /* convert to # of bytes */
 			  esd_usb_write_bulk_callback, context);
 
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
@@ -860,7 +862,7 @@ static int esd_usb_close(struct net_device *netdev)
 
 	/* Disable all IDs (see esd_usb_start()) */
 	msg->hdr.cmd = ESD_USB_CMD_IDADD;
-	msg->hdr.len = 2 + ESD_USB_MAX_ID_SEGMENT;
+	msg->hdr.len = sizeof(struct esd_usb_id_filter_msg) / sizeof(u32);/* # of 32bit words */
 	msg->filter.net = priv->index;
 	msg->filter.option = ESD_USB_ID_ENABLE; /* start with segment 0 */
 	for (i = 0; i <= ESD_USB_MAX_ID_SEGMENT; i++)
@@ -869,7 +871,7 @@ static int esd_usb_close(struct net_device *netdev)
 		netdev_err(netdev, "sending idadd message failed\n");
 
 	/* set CAN controller to reset mode */
-	msg->hdr.len = 2;
+	msg->hdr.len = sizeof(struct esd_usb_set_baudrate_msg) / sizeof(u32); /* # of 32bit words */
 	msg->hdr.cmd = ESD_USB_CMD_SETBAUD;
 	msg->setbaud.net = priv->index;
 	msg->setbaud.rsvd = 0;
@@ -947,7 +949,7 @@ static int esd_usb_2_set_bittiming(struct net_device *netdev)
 	if (!msg)
 		return -ENOMEM;
 
-	msg->hdr.len = 2;
+	msg->hdr.len = sizeof(struct esd_usb_set_baudrate_msg) / sizeof(u32); /* # of 32bit words */
 	msg->hdr.cmd = ESD_USB_CMD_SETBAUD;
 	msg->setbaud.net = priv->index;
 	msg->setbaud.rsvd = 0;
@@ -1086,7 +1088,7 @@ static int esd_usb_probe(struct usb_interface *intf,
 
 	/* query number of CAN interfaces (nets) */
 	msg->hdr.cmd = ESD_USB_CMD_VERSION;
-	msg->hdr.len = 2;
+	msg->hdr.len = sizeof(struct esd_usb_version_msg) / sizeof(u32); /* # of 32bit words */
 	msg->version.rsvd = 0;
 	msg->version.flags = 0;
 	msg->version.drv_version = 0;
-- 
2.25.1


