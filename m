Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AEF2BAB42
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgKTNdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbgKTNdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5326AC0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:32 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6Xa-0006Fn-Ez; Fri, 20 Nov 2020 14:33:30 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 21/25] can: kvaser_usb: Add USB_{LEAF,HYDRA}_PRODUCT_ID_END defines
Date:   Fri, 20 Nov 2020 14:33:14 +0100
Message-Id: <20201120133318.3428231-22-mkl@pengutronix.de>
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

Add USB_{LEAF,HYDRA}_PRODUCT_ID_END defines, representing the last USB PID
entry in respectively family. This removes the need to update the
kvaser_is_{leaf,hydra}() functions whenever new devices are added.

Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/r/20201115163027.16851-3-jimmyassarsson@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index d6e18bcb1a7f..1dffcd19c456 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -58,6 +58,8 @@
 #define USB_LEAF_LIGHT_HS_V2_OEM_PRODUCT_ID	290
 #define USB_USBCAN_LIGHT_2HS_PRODUCT_ID		291
 #define USB_MINI_PCIE_2HS_PRODUCT_ID		292
+#define USB_LEAF_PRODUCT_ID_END \
+	USB_MINI_PCIE_2HS_PRODUCT_ID
 
 /* Kvaser USBCan-II devices product ids */
 #define USB_USBCAN_REVB_PRODUCT_ID		2
@@ -78,13 +80,15 @@
 #define USB_ATI_USBCAN_PRO_2HS_V2_PRODUCT_ID	268
 #define USB_ATI_MEMO_PRO_2HS_V2_PRODUCT_ID	269
 #define USB_HYBRID_PRO_CANLIN_PRODUCT_ID	270
+#define USB_HYDRA_PRODUCT_ID_END \
+	USB_HYBRID_PRO_CANLIN_PRODUCT_ID
 
 static inline bool kvaser_is_leaf(const struct usb_device_id *id)
 {
 	return (id->idProduct >= USB_LEAF_DEVEL_PRODUCT_ID &&
 		id->idProduct <= USB_CAN_R_PRODUCT_ID) ||
 		(id->idProduct >= USB_LEAF_LITE_V2_PRODUCT_ID &&
-		 id->idProduct <= USB_MINI_PCIE_2HS_PRODUCT_ID);
+		 id->idProduct <= USB_LEAF_PRODUCT_ID_END);
 }
 
 static inline bool kvaser_is_usbcan(const struct usb_device_id *id)
@@ -96,7 +100,7 @@ static inline bool kvaser_is_usbcan(const struct usb_device_id *id)
 static inline bool kvaser_is_hydra(const struct usb_device_id *id)
 {
 	return id->idProduct >= USB_BLACKBIRD_V2_PRODUCT_ID &&
-	       id->idProduct <= USB_HYBRID_PRO_CANLIN_PRODUCT_ID;
+	       id->idProduct <= USB_HYDRA_PRODUCT_ID_END;
 }
 
 static const struct usb_device_id kvaser_usb_table[] = {
-- 
2.29.2

