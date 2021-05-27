Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FD43929E7
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbhE0IuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235608AbhE0Itv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:49:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA970C061343
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:48:18 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lmBgf-00020x-3l
        for netdev@vger.kernel.org; Thu, 27 May 2021 10:48:17 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6637162D4AD
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:45:45 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 0D67A62D406;
        Thu, 27 May 2021 08:45:37 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 69e06ac7;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 15/21] can: kvaser_usb: Add new Kvaser hydra devices
Date:   Thu, 27 May 2021 10:45:26 +0200
Message-Id: <20210527084532.1384031-16-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527084532.1384031-1-mkl@pengutronix.de>
References: <20210527084532.1384031-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jimmy Assarsson <extja@kvaser.com>

Add new Kvaser hydra devices.

Link: https://lore.kernel.org/r/20210429093730.499263-2-extja@kvaser.com
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/Kconfig                      | 2 ++
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
index 3deb9f1cd292..f959215c9d53 100644
--- a/drivers/net/can/usb/Kconfig
+++ b/drivers/net/can/usb/Kconfig
@@ -76,7 +76,9 @@ config CAN_KVASER_USB
 	    - Scania VCI2 (if you have the Kvaser logo on top)
 	    - Kvaser BlackBird v2
 	    - Kvaser Leaf Pro HS v2
+	    - Kvaser Hybrid CAN/LIN
 	    - Kvaser Hybrid 2xCAN/LIN
+	    - Kvaser Hybrid Pro CAN/LIN
 	    - Kvaser Hybrid Pro 2xCAN/LIN
 	    - Kvaser Memorator 2xHS v2
 	    - Kvaser Memorator Pro 2xHS v2
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index b2236bf63b41..0cc0fc866a2a 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -87,8 +87,10 @@
 #define USB_U100P_PRODUCT_ID			274
 #define USB_U100S_PRODUCT_ID			275
 #define USB_USBCAN_PRO_4HS_PRODUCT_ID		276
+#define USB_HYBRID_CANLIN_PRODUCT_ID		277
+#define USB_HYBRID_PRO_CANLIN_PRODUCT_ID	278
 #define USB_HYDRA_PRODUCT_ID_END \
-	USB_USBCAN_PRO_4HS_PRODUCT_ID
+	USB_HYBRID_PRO_CANLIN_PRODUCT_ID
 
 static inline bool kvaser_is_leaf(const struct usb_device_id *id)
 {
@@ -195,6 +197,8 @@ static const struct usb_device_id kvaser_usb_table[] = {
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100P_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100S_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_PRO_4HS_PRODUCT_ID) },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_CANLIN_PRODUCT_ID) },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_PRO_CANLIN_PRODUCT_ID) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, kvaser_usb_table);
-- 
2.30.2


