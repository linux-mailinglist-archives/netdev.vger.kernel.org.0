Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789A95BE21C
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiITJab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiITJaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:30:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEDA65F2
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:29:36 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oaZZO-0005o6-8N
        for netdev@vger.kernel.org; Tue, 20 Sep 2022 11:29:34 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C73AAE7338
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 09:29:22 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6A012E72B8;
        Tue, 20 Sep 2022 09:29:18 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a85dc3c5;
        Tue, 20 Sep 2022 09:29:17 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jimmy Assarsson <extja@kvaser.com>,
        stable@vger.kernel.org, Anssi Hannula <anssi.hannula@bitwise.fi>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 16/17] can: kvaser_usb: Add struct kvaser_usb_busparams
Date:   Tue, 20 Sep 2022 11:29:14 +0200
Message-Id: <20220920092915.921613-17-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920092915.921613-1-mkl@pengutronix.de>
References: <20220920092915.921613-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jimmy Assarsson <extja@kvaser.com>

Add struct kvaser_usb_busparams containing the busparameters used in
CMD_{SET,GET}_BUSPARAMS* commands.

Cc: stable@vger.kernel.org
Tested-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20220903182559.189-14-extja@kvaser.com
[mkl: mark struct kvaser_usb_busparams as packed]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  8 +++++
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 32 +++++++------------
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 18 ++++-------
 3 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
index d9c5dd5da908..778b61c90c2b 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -76,6 +76,14 @@ struct kvaser_usb_tx_urb_context {
 	u32 echo_index;
 };
 
+struct kvaser_usb_busparams {
+	__le32 bitrate;
+	u8 tseg1;
+	u8 tseg2;
+	u8 sjw;
+	u8 nsamples;
+} __packed;
+
 struct kvaser_usb {
 	struct usb_device *udev;
 	struct usb_interface *intf;
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 3abfaa77e893..b8ae29872217 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -196,17 +196,9 @@ struct kvaser_cmd_chip_state_event {
 #define KVASER_USB_HYDRA_BUS_MODE_CANFD_ISO	0x01
 #define KVASER_USB_HYDRA_BUS_MODE_NONISO	0x02
 struct kvaser_cmd_set_busparams {
-	__le32 bitrate;
-	u8 tseg1;
-	u8 tseg2;
-	u8 sjw;
-	u8 nsamples;
+	struct kvaser_usb_busparams busparams_arb;
 	u8 reserved0[4];
-	__le32 bitrate_d;
-	u8 tseg1_d;
-	u8 tseg2_d;
-	u8 sjw_d;
-	u8 nsamples_d;
+	struct kvaser_usb_busparams busparams_data;
 	u8 canfd_mode;
 	u8 reserved1[7];
 } __packed;
@@ -1538,11 +1530,11 @@ static int kvaser_usb_hydra_set_bittiming(struct net_device *netdev)
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_BUSPARAMS_REQ;
-	cmd->set_busparams_req.bitrate = cpu_to_le32(bt->bitrate);
-	cmd->set_busparams_req.sjw = (u8)sjw;
-	cmd->set_busparams_req.tseg1 = (u8)tseg1;
-	cmd->set_busparams_req.tseg2 = (u8)tseg2;
-	cmd->set_busparams_req.nsamples = 1;
+	cmd->set_busparams_req.busparams_arb.bitrate = cpu_to_le32(bt->bitrate);
+	cmd->set_busparams_req.busparams_arb.sjw = (u8)sjw;
+	cmd->set_busparams_req.busparams_arb.tseg1 = (u8)tseg1;
+	cmd->set_busparams_req.busparams_arb.tseg2 = (u8)tseg2;
+	cmd->set_busparams_req.busparams_arb.nsamples = 1;
 
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
@@ -1572,11 +1564,11 @@ static int kvaser_usb_hydra_set_data_bittiming(struct net_device *netdev)
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_BUSPARAMS_FD_REQ;
-	cmd->set_busparams_req.bitrate_d = cpu_to_le32(dbt->bitrate);
-	cmd->set_busparams_req.sjw_d = (u8)sjw;
-	cmd->set_busparams_req.tseg1_d = (u8)tseg1;
-	cmd->set_busparams_req.tseg2_d = (u8)tseg2;
-	cmd->set_busparams_req.nsamples_d = 1;
+	cmd->set_busparams_req.busparams_data.bitrate = cpu_to_le32(dbt->bitrate);
+	cmd->set_busparams_req.busparams_data.sjw = (u8)sjw;
+	cmd->set_busparams_req.busparams_data.tseg1 = (u8)tseg1;
+	cmd->set_busparams_req.busparams_data.tseg2 = (u8)tseg2;
+	cmd->set_busparams_req.busparams_data.nsamples = 1;
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
 		if (priv->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO)
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 3e31a9ebea88..bb59ee01a093 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -164,11 +164,7 @@ struct usbcan_cmd_softinfo {
 struct kvaser_cmd_busparams {
 	u8 tid;
 	u8 channel;
-	__le32 bitrate;
-	u8 tseg1;
-	u8 tseg2;
-	u8 sjw;
-	u8 no_samp;
+	struct kvaser_usb_busparams busparams;
 } __packed;
 
 struct kvaser_cmd_tx_can {
@@ -1725,15 +1721,15 @@ static int kvaser_usb_leaf_set_bittiming(struct net_device *netdev)
 	cmd->len = CMD_HEADER_LEN + sizeof(struct kvaser_cmd_busparams);
 	cmd->u.busparams.channel = priv->channel;
 	cmd->u.busparams.tid = 0xff;
-	cmd->u.busparams.bitrate = cpu_to_le32(bt->bitrate);
-	cmd->u.busparams.sjw = bt->sjw;
-	cmd->u.busparams.tseg1 = bt->prop_seg + bt->phase_seg1;
-	cmd->u.busparams.tseg2 = bt->phase_seg2;
+	cmd->u.busparams.busparams.bitrate = cpu_to_le32(bt->bitrate);
+	cmd->u.busparams.busparams.sjw = bt->sjw;
+	cmd->u.busparams.busparams.tseg1 = bt->prop_seg + bt->phase_seg1;
+	cmd->u.busparams.busparams.tseg2 = bt->phase_seg2;
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
-		cmd->u.busparams.no_samp = 3;
+		cmd->u.busparams.busparams.nsamples = 3;
 	else
-		cmd->u.busparams.no_samp = 1;
+		cmd->u.busparams.busparams.nsamples = 1;
 
 	rc = kvaser_usb_send_cmd(dev, cmd, cmd->len);
 
-- 
2.35.1


