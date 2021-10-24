Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8C2438BEE
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 22:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhJXUrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 16:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbhJXUrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 16:47:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD72C061220
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 13:44:57 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mekMS-0006Po-0N
        for netdev@vger.kernel.org; Sun, 24 Oct 2021 22:44:56 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CADAC69C617
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 20:43:34 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7CF7C69C596;
        Sun, 24 Oct 2021 20:43:31 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4e960999;
        Sun, 24 Oct 2021 20:43:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Roman Valls <brainstorm@nopcode.org>
Subject: [PATCH net-next 12/15] can: gs_usb: use %u to print unsigned values
Date:   Sun, 24 Oct 2021 22:43:22 +0200
Message-Id: <20211024204325.3293425-13-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211024204325.3293425-1-mkl@pengutronix.de>
References: <20211024204325.3293425-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes printf modifier to an unsigned int, as the printed
variables are unsigned.

Link: https://lore.kernel.org/all/20210914101005.84394-1-mkl@pengutronix.de
Cc: Roman Valls <brainstorm@nopcode.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 5e892bef46b0..1b400de00f51 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -352,7 +352,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 	} else { /* echo_id == hf->echo_id */
 		if (hf->echo_id >= GS_MAX_TX_URBS) {
 			netdev_err(netdev,
-				   "Unexpected out of range echo id %d\n",
+				   "Unexpected out of range echo id %u\n",
 				   hf->echo_id);
 			goto resubmit_urb;
 		}
@@ -365,7 +365,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 		/* bad devices send bad echo_ids. */
 		if (!txc) {
 			netdev_err(netdev,
-				   "Unexpected unused echo id %d\n",
+				   "Unexpected unused echo id %u\n",
 				   hf->echo_id);
 			goto resubmit_urb;
 		}
@@ -458,7 +458,7 @@ static void gs_usb_xmit_callback(struct urb *urb)
 	struct net_device *netdev = dev->netdev;
 
 	if (urb->status)
-		netdev_info(netdev, "usb xmit fail %d\n", txc->echo_id);
+		netdev_info(netdev, "usb xmit fail %u\n", txc->echo_id);
 
 	usb_free_coherent(urb->dev,
 			  urb->transfer_buffer_length,
@@ -501,7 +501,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	idx = txc->echo_id;
 
 	if (idx >= GS_MAX_TX_URBS) {
-		netdev_err(netdev, "Invalid tx context %d\n", idx);
+		netdev_err(netdev, "Invalid tx context %u\n", idx);
 		goto badidx;
 	}
 
@@ -964,11 +964,11 @@ static int gs_usb_probe(struct usb_interface *intf,
 	}
 
 	icount = dconf->icount + 1;
-	dev_info(&intf->dev, "Configuring for %d interfaces\n", icount);
+	dev_info(&intf->dev, "Configuring for %u interfaces\n", icount);
 
 	if (icount > GS_MAX_INTF) {
 		dev_err(&intf->dev,
-			"Driver cannot handle more that %d CAN interfaces\n",
+			"Driver cannot handle more that %u CAN interfaces\n",
 			GS_MAX_INTF);
 		kfree(dconf);
 		return -EINVAL;
-- 
2.33.0


