Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4873A69F91F
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 17:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbjBVQiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 11:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjBVQiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 11:38:16 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2126.outbound.protection.outlook.com [40.107.6.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BCC16309;
        Wed, 22 Feb 2023 08:38:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/DaoGmIwKeYbOWcYcZIivhVMWNNOnb5k6+xzXbk17i8vQfeiGUGl0C/+qiSYX6XACpQPjAPA5A/69eO7DjBjotUmDbt92NSZdSfCBerLMXHUg26cDzbOqLLCX4tKtNubBvPV+wvqbmo/Bs8ZkwGUjUOFGZjvR603f7IuavOs7qs7Yb2GyLKrMjSzAcY5QE0VTHXJfPI5gMjHMrTQ13K1xkbf0hNsyQUfPHPR6igzYxGHOc6P8uJHlBNKayju82pOi0ag4GWHWxR4wklDN9BHbkNQCv5ruZKXYGidxAcO23embKjfLD6hy1KXLghsz/6nS2vYlHa/yS8CweXWTOkEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8dcirE+9O/jU7GRJbMnRzgZME93D26XmiGoEno2hWRk=;
 b=JbYN6964iCsnXRrFtXUqOOsxU0bVhZYIbWPv9L3qJuxP5Uerdbmp4hu93U1iPwkDfW4sm9Qa8JZUjXsyhUegSwFqeiWp/awLVmKDmYwv4lizwr0qKblaQNai5AGluI66QRqxdCCtadAzNKkWnLAWJy5z6bd9WZflDaAQRU0ZNihdZRtWzmCRnKQyrRgpeJ3Bbhl3Z5+g96rvJjV9PAdPKWkPCVgS/ZgUG0qKT4dG0MAwPtw9o2EWE/zz+Km0kpp51l3UCGANSm8zbbhpiowMfnkKJMVQI/UtA+dCcdEKp2jVSyhO6xk38v2DUOj7hDImRY8/mkYjpYnv2v5vPW6dPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dcirE+9O/jU7GRJbMnRzgZME93D26XmiGoEno2hWRk=;
 b=lquEB8t8Dqx+jax+brXgorgRXAuyBcsKRixlgAmbLVEpKRDhBhhFGAD93UeqxbU3BTiofQs1JmzanIjDevEEn/Is+WEVxnddy0EeKeDhUdi9YEy3WV5KQUE6HixHdSgkyo5gqS1oAZe1xXV7AlLm/1Ugjd+ZBN4y7wdDSA/QBq0=
Received: from AS9PR06CA0706.eurprd06.prod.outlook.com (2603:10a6:20b:49f::16)
 by DB3PR03MB10129.eurprd03.prod.outlook.com (2603:10a6:10:43c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 16:38:09 +0000
Received: from VI1EUR06FT043.eop-eur06.prod.protection.outlook.com
 (2603:10a6:20b:49f:cafe::c1) by AS9PR06CA0706.outlook.office365.com
 (2603:10a6:20b:49f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.20 via Frontend
 Transport; Wed, 22 Feb 2023 16:38:08 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT043.mail.protection.outlook.com (10.13.6.134) with Microsoft SMTP
 Server id 15.20.6111.20 via Frontend Transport; Wed, 22 Feb 2023 16:38:08
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 432AE7C1635;
        Wed, 22 Feb 2023 17:38:08 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 32FBD2E44BE; Wed, 22 Feb 2023 17:38:08 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH] can: esd_usb: Improve code readability by means of replacing struct esd_usb_msg with a union
Date:   Wed, 22 Feb 2023 17:37:54 +0100
Message-Id: <20230222163754.3711766-1-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT043:EE_|DB3PR03MB10129:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: cdae890b-f10d-4f66-cff8-08db14f32e15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hKhWGya4Awg+KK8O5OnP0asgtq5neqyjiE/2ZNt6HnN3ydTkW9zPu8Nhqxgcuriq6RnOS8L7C2XQ9A69rKFB67wIbu9MJY/mPv3Ivu/47RGr5xdYIVHmr+8Vz+4sLoQbOjwesk35WFQfWlU7iofTWZ8pd6nAL6llSYJf14yq33H2BAj2feI2m6QJYPKpmm9sZ9w7ZyCuiUPRE8GK9Yopoy6iipK+pL5L+FeXZEHsSmAZmMF6FpUirRZkdeb2V2dz4PaZVk2K6IoLteHEAbIMSpwEY6BD+okvOvao8wksfSX4O5BRXnZHs3JTuM4HjNDEIAxv+8/HBLcRR8aPKGyqveVVq2ofuyGJbmfS0f9AWPaDsVZVNhIIKZLmDXkJRfWce4Plf6n6imaPX+6kEdhigecDfh+U9JzJ4sXHbcce6pMYn0vha3TIpsRx83+Alwcl9M5vll3CE0UFLHSdne9tfjRcj+/qaXKeoZ7lc/CBNEJumzUlTm8wQgSBWexKklqbbXIAmBX1s0hVfLPsx1sSPbLBnaCk7xPOJy2vEvB2eCuZRqFlMowxAu2ck7xHJb6dGMWbA5vKxnItBbQyzP0KJgs62tkVka328tPzc1ZI0kQqDnbQv0ZRZ96EWIJmVUagLzHuA7sZ9uNr0ujIC/lqO5k6O14PdERelyEXAFLOySg=
X-Forefront-Antispam-Report: CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(39830400003)(376002)(451199018)(46966006)(36840700001)(81166007)(36860700001)(2906002)(2616005)(8936002)(44832011)(30864003)(5660300002)(82310400005)(54906003)(26005)(6266002)(186003)(83380400001)(47076005)(41300700001)(336012)(8676002)(356005)(36756003)(4326008)(70206006)(70586007)(86362001)(478600001)(6666004)(316002)(966005)(42186006)(40480700001)(110136005)(1076003);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 16:38:08.5065
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdae890b-f10d-4f66-cff8-08db14f32e15
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT043.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR03MB10129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As suggested by Vincent Mailhol, declare struct esd_usb_msg as a union
instead of a struct. Then replace all msg->msg.something constructs,
that make use of esd_usb_msg, with simpler and prettier looking
msg->something variants.

Link: https://lore.kernel.org/all/CAMZ6RqKRzJwmMShVT9QKwiQ5LJaQupYqkPkKjhRBsP=12QYpfA@mail.gmail.com/
Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 166 +++++++++++++++++-----------------
 1 file changed, 82 insertions(+), 84 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 55b36973952d..e78bb468115a 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -174,17 +174,15 @@ struct set_baudrate_msg {
 };
 
 /* Main message type used between library and application */
-struct __packed esd_usb_msg {
-	union {
-		struct header_msg hdr;
-		struct version_msg version;
-		struct version_reply_msg version_reply;
-		struct rx_msg rx;
-		struct tx_msg tx;
-		struct tx_done_msg txdone;
-		struct set_baudrate_msg setbaud;
-		struct id_filter_msg filter;
-	} msg;
+union __packed esd_usb_msg {
+	struct header_msg hdr;
+	struct version_msg version;
+	struct version_reply_msg version_reply;
+	struct rx_msg rx;
+	struct tx_msg tx;
+	struct tx_done_msg txdone;
+	struct set_baudrate_msg setbaud;
+	struct id_filter_msg filter;
 };
 
 static struct usb_device_id esd_usb_table[] = {
@@ -229,22 +227,22 @@ struct esd_usb_net_priv {
 };
 
 static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
-			     struct esd_usb_msg *msg)
+			     union esd_usb_msg *msg)
 {
 	struct net_device_stats *stats = &priv->netdev->stats;
 	struct can_frame *cf;
 	struct sk_buff *skb;
-	u32 id = le32_to_cpu(msg->msg.rx.id) & ESD_IDMASK;
+	u32 id = le32_to_cpu(msg->rx.id) & ESD_IDMASK;
 
 	if (id == ESD_EV_CAN_ERROR_EXT) {
-		u8 state = msg->msg.rx.ev_can_err_ext.status;
-		u8 ecc = msg->msg.rx.ev_can_err_ext.ecc;
-		u8 rxerr = msg->msg.rx.ev_can_err_ext.rec;
-		u8 txerr = msg->msg.rx.ev_can_err_ext.tec;
+		u8 state = msg->rx.ev_can_err_ext.status;
+		u8 ecc = msg->rx.ev_can_err_ext.ecc;
+		u8 rxerr = msg->rx.ev_can_err_ext.rec;
+		u8 txerr = msg->rx.ev_can_err_ext.tec;
 
 		netdev_dbg(priv->netdev,
 			   "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
-			   msg->msg.rx.dlc, state, ecc, rxerr, txerr);
+			   msg->rx.dlc, state, ecc, rxerr, txerr);
 
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 
@@ -322,7 +320,7 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 }
 
 static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
-			       struct esd_usb_msg *msg)
+			       union esd_usb_msg *msg)
 {
 	struct net_device_stats *stats = &priv->netdev->stats;
 	struct can_frame *cf;
@@ -333,7 +331,7 @@ static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
 	if (!netif_device_present(priv->netdev))
 		return;
 
-	id = le32_to_cpu(msg->msg.rx.id);
+	id = le32_to_cpu(msg->rx.id);
 
 	if (id & ESD_EVENT) {
 		esd_usb_rx_event(priv, msg);
@@ -345,17 +343,17 @@ static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
 		}
 
 		cf->can_id = id & ESD_IDMASK;
-		can_frame_set_cc_len(cf, msg->msg.rx.dlc & ~ESD_RTR,
+		can_frame_set_cc_len(cf, msg->rx.dlc & ~ESD_RTR,
 				     priv->can.ctrlmode);
 
 		if (id & ESD_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
 
-		if (msg->msg.rx.dlc & ESD_RTR) {
+		if (msg->rx.dlc & ESD_RTR) {
 			cf->can_id |= CAN_RTR_FLAG;
 		} else {
 			for (i = 0; i < cf->len; i++)
-				cf->data[i] = msg->msg.rx.data[i];
+				cf->data[i] = msg->rx.data[i];
 
 			stats->rx_bytes += cf->len;
 		}
@@ -366,7 +364,7 @@ static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
 }
 
 static void esd_usb_tx_done_msg(struct esd_usb_net_priv *priv,
-				struct esd_usb_msg *msg)
+				union esd_usb_msg *msg)
 {
 	struct net_device_stats *stats = &priv->netdev->stats;
 	struct net_device *netdev = priv->netdev;
@@ -375,9 +373,9 @@ static void esd_usb_tx_done_msg(struct esd_usb_net_priv *priv,
 	if (!netif_device_present(netdev))
 		return;
 
-	context = &priv->tx_contexts[msg->msg.txdone.hnd & (MAX_TX_URBS - 1)];
+	context = &priv->tx_contexts[msg->txdone.hnd & (MAX_TX_URBS - 1)];
 
-	if (!msg->msg.txdone.status) {
+	if (!msg->txdone.status) {
 		stats->tx_packets++;
 		stats->tx_bytes += can_get_echo_skb(netdev, context->echo_index,
 						    NULL);
@@ -417,32 +415,32 @@ static void esd_usb_read_bulk_callback(struct urb *urb)
 	}
 
 	while (pos < urb->actual_length) {
-		struct esd_usb_msg *msg;
+		union esd_usb_msg *msg;
 
-		msg = (struct esd_usb_msg *)(urb->transfer_buffer + pos);
+		msg = (union esd_usb_msg *)(urb->transfer_buffer + pos);
 
-		switch (msg->msg.hdr.cmd) {
+		switch (msg->hdr.cmd) {
 		case CMD_CAN_RX:
-			if (msg->msg.rx.net >= dev->net_count) {
+			if (msg->rx.net >= dev->net_count) {
 				dev_err(dev->udev->dev.parent, "format error\n");
 				break;
 			}
 
-			esd_usb_rx_can_msg(dev->nets[msg->msg.rx.net], msg);
+			esd_usb_rx_can_msg(dev->nets[msg->rx.net], msg);
 			break;
 
 		case CMD_CAN_TX:
-			if (msg->msg.txdone.net >= dev->net_count) {
+			if (msg->txdone.net >= dev->net_count) {
 				dev_err(dev->udev->dev.parent, "format error\n");
 				break;
 			}
 
-			esd_usb_tx_done_msg(dev->nets[msg->msg.txdone.net],
+			esd_usb_tx_done_msg(dev->nets[msg->txdone.net],
 					    msg);
 			break;
 		}
 
-		pos += msg->msg.hdr.len << 2;
+		pos += msg->hdr.len << 2;
 
 		if (pos > urb->actual_length) {
 			dev_err(dev->udev->dev.parent, "format error\n");
@@ -473,7 +471,7 @@ static void esd_usb_write_bulk_callback(struct urb *urb)
 	struct esd_tx_urb_context *context = urb->context;
 	struct esd_usb_net_priv *priv;
 	struct net_device *netdev;
-	size_t size = sizeof(struct esd_usb_msg);
+	size_t size = sizeof(union esd_usb_msg);
 
 	WARN_ON(!context);
 
@@ -529,20 +527,20 @@ static ssize_t nets_show(struct device *d,
 }
 static DEVICE_ATTR_RO(nets);
 
-static int esd_usb_send_msg(struct esd_usb *dev, struct esd_usb_msg *msg)
+static int esd_usb_send_msg(struct esd_usb *dev, union esd_usb_msg *msg)
 {
 	int actual_length;
 
 	return usb_bulk_msg(dev->udev,
 			    usb_sndbulkpipe(dev->udev, 2),
 			    msg,
-			    msg->msg.hdr.len << 2,
+			    msg->hdr.len << 2,
 			    &actual_length,
 			    1000);
 }
 
 static int esd_usb_wait_msg(struct esd_usb *dev,
-			    struct esd_usb_msg *msg)
+			    union esd_usb_msg *msg)
 {
 	int actual_length;
 
@@ -630,7 +628,7 @@ static int esd_usb_start(struct esd_usb_net_priv *priv)
 {
 	struct esd_usb *dev = priv->usb;
 	struct net_device *netdev = priv->netdev;
-	struct esd_usb_msg *msg;
+	union esd_usb_msg *msg;
 	int err, i;
 
 	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
@@ -651,14 +649,14 @@ static int esd_usb_start(struct esd_usb_net_priv *priv)
 	 * the number of the starting bitmask (0..64) to the filter.option
 	 * field followed by only some bitmasks.
 	 */
-	msg->msg.hdr.cmd = CMD_IDADD;
-	msg->msg.hdr.len = 2 + ESD_MAX_ID_SEGMENT;
-	msg->msg.filter.net = priv->index;
-	msg->msg.filter.option = ESD_ID_ENABLE; /* start with segment 0 */
+	msg->hdr.cmd = CMD_IDADD;
+	msg->hdr.len = 2 + ESD_MAX_ID_SEGMENT;
+	msg->filter.net = priv->index;
+	msg->filter.option = ESD_ID_ENABLE; /* start with segment 0 */
 	for (i = 0; i < ESD_MAX_ID_SEGMENT; i++)
-		msg->msg.filter.mask[i] = cpu_to_le32(0xffffffff);
+		msg->filter.mask[i] = cpu_to_le32(0xffffffff);
 	/* enable 29bit extended IDs */
-	msg->msg.filter.mask[ESD_MAX_ID_SEGMENT] = cpu_to_le32(0x00000001);
+	msg->filter.mask[ESD_MAX_ID_SEGMENT] = cpu_to_le32(0x00000001);
 
 	err = esd_usb_send_msg(dev, msg);
 	if (err)
@@ -734,12 +732,12 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 	struct esd_tx_urb_context *context = NULL;
 	struct net_device_stats *stats = &netdev->stats;
 	struct can_frame *cf = (struct can_frame *)skb->data;
-	struct esd_usb_msg *msg;
+	union esd_usb_msg *msg;
 	struct urb *urb;
 	u8 *buf;
 	int i, err;
 	int ret = NETDEV_TX_OK;
-	size_t size = sizeof(struct esd_usb_msg);
+	size_t size = sizeof(union esd_usb_msg);
 
 	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
@@ -761,24 +759,24 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 		goto nobufmem;
 	}
 
-	msg = (struct esd_usb_msg *)buf;
+	msg = (union esd_usb_msg *)buf;
 
-	msg->msg.hdr.len = 3; /* minimal length */
-	msg->msg.hdr.cmd = CMD_CAN_TX;
-	msg->msg.tx.net = priv->index;
-	msg->msg.tx.dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
-	msg->msg.tx.id = cpu_to_le32(cf->can_id & CAN_ERR_MASK);
+	msg->hdr.len = 3; /* minimal length */
+	msg->hdr.cmd = CMD_CAN_TX;
+	msg->tx.net = priv->index;
+	msg->tx.dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
+	msg->tx.id = cpu_to_le32(cf->can_id & CAN_ERR_MASK);
 
 	if (cf->can_id & CAN_RTR_FLAG)
-		msg->msg.tx.dlc |= ESD_RTR;
+		msg->tx.dlc |= ESD_RTR;
 
 	if (cf->can_id & CAN_EFF_FLAG)
-		msg->msg.tx.id |= cpu_to_le32(ESD_EXTID);
+		msg->tx.id |= cpu_to_le32(ESD_EXTID);
 
 	for (i = 0; i < cf->len; i++)
-		msg->msg.tx.data[i] = cf->data[i];
+		msg->tx.data[i] = cf->data[i];
 
-	msg->msg.hdr.len += (cf->len + 3) >> 2;
+	msg->hdr.len += (cf->len + 3) >> 2;
 
 	for (i = 0; i < MAX_TX_URBS; i++) {
 		if (priv->tx_contexts[i].echo_index == MAX_TX_URBS) {
@@ -798,10 +796,10 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 	context->echo_index = i;
 
 	/* hnd must not be 0 - MSB is stripped in txdone handling */
-	msg->msg.tx.hnd = 0x80000000 | i; /* returned in TX done message */
+	msg->tx.hnd = 0x80000000 | i; /* returned in TX done message */
 
 	usb_fill_bulk_urb(urb, dev->udev, usb_sndbulkpipe(dev->udev, 2), buf,
-			  msg->msg.hdr.len << 2,
+			  msg->hdr.len << 2,
 			  esd_usb_write_bulk_callback, context);
 
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
@@ -855,7 +853,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 static int esd_usb_close(struct net_device *netdev)
 {
 	struct esd_usb_net_priv *priv = netdev_priv(netdev);
-	struct esd_usb_msg *msg;
+	union esd_usb_msg *msg;
 	int i;
 
 	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
@@ -863,21 +861,21 @@ static int esd_usb_close(struct net_device *netdev)
 		return -ENOMEM;
 
 	/* Disable all IDs (see esd_usb_start()) */
-	msg->msg.hdr.cmd = CMD_IDADD;
-	msg->msg.hdr.len = 2 + ESD_MAX_ID_SEGMENT;
-	msg->msg.filter.net = priv->index;
-	msg->msg.filter.option = ESD_ID_ENABLE; /* start with segment 0 */
+	msg->hdr.cmd = CMD_IDADD;
+	msg->hdr.len = 2 + ESD_MAX_ID_SEGMENT;
+	msg->filter.net = priv->index;
+	msg->filter.option = ESD_ID_ENABLE; /* start with segment 0 */
 	for (i = 0; i <= ESD_MAX_ID_SEGMENT; i++)
-		msg->msg.filter.mask[i] = 0;
+		msg->filter.mask[i] = 0;
 	if (esd_usb_send_msg(priv->usb, msg) < 0)
 		netdev_err(netdev, "sending idadd message failed\n");
 
 	/* set CAN controller to reset mode */
-	msg->msg.hdr.len = 2;
-	msg->msg.hdr.cmd = CMD_SETBAUD;
-	msg->msg.setbaud.net = priv->index;
-	msg->msg.setbaud.rsvd = 0;
-	msg->msg.setbaud.baud = cpu_to_le32(ESD_USB_NO_BAUDRATE);
+	msg->hdr.len = 2;
+	msg->hdr.cmd = CMD_SETBAUD;
+	msg->setbaud.net = priv->index;
+	msg->setbaud.rsvd = 0;
+	msg->setbaud.baud = cpu_to_le32(ESD_USB_NO_BAUDRATE);
 	if (esd_usb_send_msg(priv->usb, msg) < 0)
 		netdev_err(netdev, "sending setbaud message failed\n");
 
@@ -919,7 +917,7 @@ static int esd_usb2_set_bittiming(struct net_device *netdev)
 {
 	struct esd_usb_net_priv *priv = netdev_priv(netdev);
 	struct can_bittiming *bt = &priv->can.bittiming;
-	struct esd_usb_msg *msg;
+	union esd_usb_msg *msg;
 	int err;
 	u32 canbtr;
 	int sjw_shift;
@@ -950,11 +948,11 @@ static int esd_usb2_set_bittiming(struct net_device *netdev)
 	if (!msg)
 		return -ENOMEM;
 
-	msg->msg.hdr.len = 2;
-	msg->msg.hdr.cmd = CMD_SETBAUD;
-	msg->msg.setbaud.net = priv->index;
-	msg->msg.setbaud.rsvd = 0;
-	msg->msg.setbaud.baud = cpu_to_le32(canbtr);
+	msg->hdr.len = 2;
+	msg->hdr.cmd = CMD_SETBAUD;
+	msg->setbaud.net = priv->index;
+	msg->setbaud.rsvd = 0;
+	msg->setbaud.baud = cpu_to_le32(canbtr);
 
 	netdev_info(netdev, "setting BTR=%#x\n", canbtr);
 
@@ -1065,7 +1063,7 @@ static int esd_usb_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
 	struct esd_usb *dev;
-	struct esd_usb_msg *msg;
+	union esd_usb_msg *msg;
 	int i, err;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
@@ -1087,11 +1085,11 @@ static int esd_usb_probe(struct usb_interface *intf,
 	}
 
 	/* query number of CAN interfaces (nets) */
-	msg->msg.hdr.cmd = CMD_VERSION;
-	msg->msg.hdr.len = 2;
-	msg->msg.version.rsvd = 0;
-	msg->msg.version.flags = 0;
-	msg->msg.version.drv_version = 0;
+	msg->hdr.cmd = CMD_VERSION;
+	msg->hdr.len = 2;
+	msg->version.rsvd = 0;
+	msg->version.flags = 0;
+	msg->version.drv_version = 0;
 
 	err = esd_usb_send_msg(dev, msg);
 	if (err < 0) {
@@ -1105,8 +1103,8 @@ static int esd_usb_probe(struct usb_interface *intf,
 		goto free_msg;
 	}
 
-	dev->net_count = (int)msg->msg.version_reply.nets;
-	dev->version = le32_to_cpu(msg->msg.version_reply.version);
+	dev->net_count = (int)msg->version_reply.nets;
+	dev->version = le32_to_cpu(msg->version_reply.version);
 
 	if (device_create_file(&intf->dev, &dev_attr_firmware))
 		dev_err(&intf->dev,

base-commit: 6ad172748db49deef0da9038d29019aedf991a7e
-- 
2.25.1

