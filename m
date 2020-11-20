Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDB92BAB32
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgKTNdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbgKTNde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9105BC061A47
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:33 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6Xb-0006Fn-L2; Fri, 20 Nov 2020 14:33:31 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 24/25] can: kvaser_usb: Add new Kvaser hydra devices
Date:   Fri, 20 Nov 2020 14:33:17 +0100
Message-Id: <20201120133318.3428231-25-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120133318.3428231-1-mkl@pengutronix.de>
References: <20201120133318.3428231-1-mkl@pengutronix.de>
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

Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/r/20201115163027.16851-6-jimmyassarsson@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/Kconfig                      | 3 +++
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
index 161f15e5218d..c1e5d5b570b6 100644
--- a/drivers/net/can/usb/Kconfig
+++ b/drivers/net/can/usb/Kconfig
@@ -74,6 +74,9 @@ config CAN_KVASER_USB
 	    - Kvaser USBcan Light 4xHS
 	    - Kvaser USBcan Pro 2xHS v2
 	    - Kvaser USBcan Pro 5xHS
+	    - Kvaser U100
+	    - Kvaser U100P
+	    - Kvaser U100S
 	    - ATI Memorator Pro 2xHS v2
 	    - ATI USBcan Pro 2xHS v2
 
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index ad66a3b1a29d..e2d58846c40c 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -83,8 +83,11 @@
 #define USB_ATI_USBCAN_PRO_2HS_V2_PRODUCT_ID	268
 #define USB_ATI_MEMO_PRO_2HS_V2_PRODUCT_ID	269
 #define USB_HYBRID_PRO_CANLIN_PRODUCT_ID	270
+#define USB_U100_PRODUCT_ID			273
+#define USB_U100P_PRODUCT_ID			274
+#define USB_U100S_PRODUCT_ID			275
 #define USB_HYDRA_PRODUCT_ID_END \
-	USB_HYBRID_PRO_CANLIN_PRODUCT_ID
+	USB_U100S_PRODUCT_ID
 
 static inline bool kvaser_is_leaf(const struct usb_device_id *id)
 {
@@ -187,6 +190,9 @@ static const struct usb_device_id kvaser_usb_table[] = {
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_ATI_USBCAN_PRO_2HS_V2_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_ATI_MEMO_PRO_2HS_V2_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_PRO_CANLIN_PRODUCT_ID) },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100_PRODUCT_ID) },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100P_PRODUCT_ID) },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100S_PRODUCT_ID) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, kvaser_usb_table);
-- 
2.29.2

