Return-Path: <netdev+bounces-3438-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63C527071F3
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:23:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A7B0281766
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF46734CD9;
	Wed, 17 May 2023 19:23:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB94031F1D
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 19:23:11 +0000 (UTC)
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2130.outbound.protection.outlook.com [40.107.241.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583A655A9;
	Wed, 17 May 2023 12:22:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OU/aGNvbNelVtWUwluaBxNNf3WWB7w7DbUUYSYhF/4vCx4WN9HPOWsUFohlJ9th6pOHUyVyvZgNdeyBcKyxX/rbLJ8j8exr1jHfwT95c2LaI3mwB3sBe4e0wX4LvlXWFX2bdsRRX8kPP213qveAOSN99mL6RyKJBN1j2RYtgp8zGGJlMXStXMlnCBSFzTaeqDLvA6sh5PfveLyVfShbb8lz8OUrCEqhBZ9QogSddC3hmx9KVuA58FglfdOg43I474KoDXN/AP62UqwlBVW7+3MCnWWtyDyFlgq5TVc9kOSat6nWzbXEGmyoQFvFeaL3TQ89EwH5DD+jryx1EBvRe7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JQcvexl/oTObPkA5NZsRh+F1iG6lKA3Khz5eprQn41Y=;
 b=PIOnGCn05L8zndZqyPVlrOGba8fMGcfyOR0N2Zl5l5+tIuHeEJXoRmZO0xQNRqmR7GLTvYMgpa0Snpdr3LknlPa8+/pkeE/6fIe0qijQ9D/6UAtIeiZcPXuvrtRceaHOFh/5Ap7+OeRT7sDdzDaUT9Z2Kwcsud593iotNAMftckRnvMJJrSDQlWg+g99eZ8FtIJ/iZkavsDbfslXHgrliUhoWOhZb1RssrBpDZ8Pw/a8IzuN7Puya43P0R3j/f8av2sqF4uC1hqtg8WBRA6Z6sAMVu0VhuiZpccBbsKu+JbTdjosYsc2Fr8qKuD2jlsSy03zDrAxVaT+IDuqdnl1DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQcvexl/oTObPkA5NZsRh+F1iG6lKA3Khz5eprQn41Y=;
 b=FxxlVInNjfzWVpmIdJK0p+DigB39hkMTjZV5W+YRNxQdqA/Yojpog8sH+rj4SkMJnsDCjTJ8ohqVIaH2QXaIJ7vgJ5wipgcc+z1cJFDGGbYOj3QVn+WW0shAON7aSIvlaIY48WPBEzThlw9RgzR7gkC1xJPYdp/gndXPagPEmlI=
Received: from DB8PR06CA0058.eurprd06.prod.outlook.com (2603:10a6:10:120::32)
 by DU2PR03MB8123.eurprd03.prod.outlook.com (2603:10a6:10:2f2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 19:22:56 +0000
Received: from DB8EUR06FT040.eop-eur06.prod.protection.outlook.com
 (2603:10a6:10:120:cafe::5b) by DB8PR06CA0058.outlook.office365.com
 (2603:10a6:10:120::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.34 via Frontend
 Transport; Wed, 17 May 2023 19:22:56 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 DB8EUR06FT040.mail.protection.outlook.com (10.233.253.37) with Microsoft SMTP
 Server id 15.20.6411.17 via Frontend Transport; Wed, 17 May 2023 19:22:56
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id E147C7C16CC;
	Wed, 17 May 2023 21:22:55 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id DE95D2E1801; Wed, 17 May 2023 21:22:55 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 5/6] can: esd_usb: Replace hardcoded message length given to USB commands
Date: Wed, 17 May 2023 21:22:50 +0200
Message-Id: <20230517192251.2405290-6-frank.jungclaus@esd.eu>
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
X-MS-TrafficTypeDiagnostic: DB8EUR06FT040:EE_|DU2PR03MB8123:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: df7e7d4e-bb66-4592-1404-08db570c1e62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IycrqSvzW/X6R0RL/kIgFOv6KoOvCBT87+awgZ4pIXseC6N4uGM3id5nmJ6tPt3aNzfQ2/B+Yi+GufYLf9n1TFQPfNR+5ZkxDq6XbZrVn/7zh3yty9V5jRWKXkHuFal0h8agfv83Jhr2iv5KQirNX7yvIad80KoztD2ya65eVvQvqTcn+jmJk/LcybkOfRsF/8vEVH898Ht7b7vE9M4IT8tjsfWgHQ8Wps9zhsUTQ7gJLBP7FDoWmfdoY7q84d9QWSI0d9SvLNQx6xl0+9y7LvA07hga66X96prhve8I3x+IsHsbCwCRJaxxp7+dM0UdF0MMqcwU2Jedoi7J9qsfkrwAaorybBgm0gsUWggICpLRqWhH2a94/qVLeslV/SRjn39Z25qZP5gCgoSVQNJUQfP/1sXKsV9XlRnWZ6cBhFgm2yK9Z7Hy3eDqgoDet6RA59fmf2rB5D9mB46RtV8Y3rvN5yOTDf/jEcYzbHrFUwaOso6SNbijK2zACFLdU/VJ/JiLX31cK7pQWDq9S8vua14TVZaQDpNlPy42+1m4ITiIBkG/7gDjKFbeQYeE5QaxKUr2xo77K3v05emJSOCVMxfM7xamWb/CfhfviQdpTAvrwVLvk398zQSWqzC1r+oD2IRKTetXzaDj3jF197T4UmlgzzCpthi2Nvc9FWFcGb0idP9dvx9ACMwtXGbmRdKu7JkGQCChRkgtRdBItrZOD437HxcmRLqkl9wlt8x+nZ4=
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(346002)(39830400003)(136003)(376002)(396003)(451199021)(36840700001)(46966006)(5660300002)(41300700001)(336012)(36756003)(2906002)(47076005)(36860700001)(43170500006)(83380400001)(2616005)(15650500001)(81166007)(86362001)(82310400005)(356005)(1076003)(26005)(186003)(6266002)(44832011)(8676002)(8936002)(40480700001)(70586007)(70206006)(478600001)(6666004)(966005)(42186006)(54906003)(316002)(4326008)(110136005);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 19:22:56.2931
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df7e7d4e-bb66-4592-1404-08db570c1e62
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR06FT040.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR03MB8123
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Initiated by comments from Vincent Mailhol replace all hardcoded
values supplied to the len element of esd_usb_msg (and its siblings)
by more readable expressions, based on sizeof(), offsetof(), etc.
Also spend documentation / comments that the len element of esd_usb_msg
is in multiples of 32bit words and not in bytes.

Link: https://lore.kernel.org/all/CAMZ6RqLaDNy-fZ2G0+QMhUEckkXLL+ZyELVSDFmqpd++aBzZQg@mail.gmail.com/
Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 40 ++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 1a51a8541bdd..9053a338eb88 100644
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


