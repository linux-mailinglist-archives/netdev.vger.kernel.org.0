Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC832BAB3F
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgKTNdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728225AbgKTNdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:33 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3E7C0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:32 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6Xa-0006Fn-R7; Fri, 20 Nov 2020 14:33:30 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 22/25] can: kvaser_usb: Add new Kvaser Leaf v2 devices
Date:   Fri, 20 Nov 2020 14:33:15 +0100
Message-Id: <20201120133318.3428231-23-mkl@pengutronix.de>
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

Add new Kvaser Leaf v2 devices.

Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/r/20201115163027.16851-4-jimmyassarsson@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/Kconfig                      | 2 ++
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
index bcb331b0c958..161f15e5218d 100644
--- a/drivers/net/can/usb/Kconfig
+++ b/drivers/net/can/usb/Kconfig
@@ -52,7 +52,9 @@ config CAN_KVASER_USB
 	    - Kvaser Leaf Light "China"
 	    - Kvaser BlackBird SemiPro
 	    - Kvaser USBcan R
+	    - Kvaser USBcan R v2
 	    - Kvaser Leaf Light v2
+	    - Kvaser Leaf Light R v2
 	    - Kvaser Mini PCI Express HS
 	    - Kvaser Mini PCI Express 2xHS
 	    - Kvaser USBcan Light 2xHS
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index 1dffcd19c456..ad66a3b1a29d 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -58,8 +58,11 @@
 #define USB_LEAF_LIGHT_HS_V2_OEM_PRODUCT_ID	290
 #define USB_USBCAN_LIGHT_2HS_PRODUCT_ID		291
 #define USB_MINI_PCIE_2HS_PRODUCT_ID		292
+#define USB_USBCAN_R_V2_PRODUCT_ID		294
+#define USB_LEAF_LIGHT_R_V2_PRODUCT_ID		295
+#define USB_LEAF_LIGHT_HS_V2_OEM2_PRODUCT_ID	296
 #define USB_LEAF_PRODUCT_ID_END \
-	USB_MINI_PCIE_2HS_PRODUCT_ID
+	USB_LEAF_LIGHT_HS_V2_OEM2_PRODUCT_ID
 
 /* Kvaser USBCan-II devices product ids */
 #define USB_USBCAN_REVB_PRODUCT_ID		2
@@ -157,6 +160,9 @@ static const struct usb_device_id kvaser_usb_table[] = {
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_HS_V2_OEM_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_LIGHT_2HS_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MINI_PCIE_2HS_PRODUCT_ID) },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_R_V2_PRODUCT_ID) },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_R_V2_PRODUCT_ID) },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_HS_V2_OEM2_PRODUCT_ID) },
 
 	/* USBCANII USB product IDs */
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN2_PRODUCT_ID),
-- 
2.29.2

