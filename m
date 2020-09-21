Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3F1272636
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgIUNrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbgIUNqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:46:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF0DC0613E8
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:46:13 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kKM8w-0003ED-DI; Mon, 21 Sep 2020 15:46:10 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 21/38] can: pcan_usb: Document the commands sent to the device
Date:   Mon, 21 Sep 2020 15:45:40 +0200
Message-Id: <20200921134557.2251383-22-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921134557.2251383-1-mkl@pengutronix.de>
References: <20200921134557.2251383-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

This patch documents the functions and numbers of the commands sent by the
driver to the PCAN-USB CAN device from PEAK-System GmbH.

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Link: https://lore.kernel.org/r/20191206153803.17725-2-s.grosjean@peak-system.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c | 33 +++++++++++++++++++------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 66d0198e7834..76468250cabf 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -34,6 +34,22 @@ MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB adapter");
 #define PCAN_USB_CMD_LEN		(PCAN_USB_CMD_ARGS + \
 					 PCAN_USB_CMD_ARGS_LEN)
 
+/* PCAN-USB commands */
+#define PCAN_USB_CMD_BITRATE	1
+#define PCAN_USB_CMD_SET_BUS	3
+#define PCAN_USB_CMD_DEVID	4
+#define PCAN_USB_CMD_SN		6
+#define PCAN_USB_CMD_REGISTER	9
+#define PCAN_USB_CMD_EXT_VCC	10
+
+/* PCAN_USB_CMD_SET_BUS number arg */
+#define PCAN_USB_BUS_XCVER		2
+#define PCAN_USB_BUS_SILENT_MODE	3
+
+/* PCAN_USB_CMD_xxx functions */
+#define PCAN_USB_GET		1
+#define PCAN_USB_SET		2
+
 /* PCAN-USB command timeout (ms.) */
 #define PCAN_USB_COMMAND_TIMEOUT	1000
 
@@ -172,7 +188,8 @@ static int pcan_usb_set_sja1000(struct peak_usb_device *dev, u8 mode)
 		[1] = mode,
 	};
 
-	return pcan_usb_send_cmd(dev, 9, 2, args);
+	return pcan_usb_send_cmd(dev, PCAN_USB_CMD_REGISTER, PCAN_USB_SET,
+				 args);
 }
 
 static int pcan_usb_set_bus(struct peak_usb_device *dev, u8 onoff)
@@ -181,7 +198,8 @@ static int pcan_usb_set_bus(struct peak_usb_device *dev, u8 onoff)
 		[0] = !!onoff,
 	};
 
-	return pcan_usb_send_cmd(dev, 3, 2, args);
+	return pcan_usb_send_cmd(dev, PCAN_USB_CMD_SET_BUS, PCAN_USB_BUS_XCVER,
+				 args);
 }
 
 static int pcan_usb_set_silent(struct peak_usb_device *dev, u8 onoff)
@@ -190,7 +208,8 @@ static int pcan_usb_set_silent(struct peak_usb_device *dev, u8 onoff)
 		[0] = !!onoff,
 	};
 
-	return pcan_usb_send_cmd(dev, 3, 3, args);
+	return pcan_usb_send_cmd(dev, PCAN_USB_CMD_SET_BUS,
+				 PCAN_USB_BUS_SILENT_MODE, args);
 }
 
 static int pcan_usb_set_ext_vcc(struct peak_usb_device *dev, u8 onoff)
@@ -199,7 +218,7 @@ static int pcan_usb_set_ext_vcc(struct peak_usb_device *dev, u8 onoff)
 		[0] = !!onoff,
 	};
 
-	return pcan_usb_send_cmd(dev, 10, 2, args);
+	return pcan_usb_send_cmd(dev, PCAN_USB_CMD_EXT_VCC, PCAN_USB_SET, args);
 }
 
 /*
@@ -223,7 +242,7 @@ static int pcan_usb_set_bittiming(struct peak_usb_device *dev,
 	args[0] = btr1;
 	args[1] = btr0;
 
-	return pcan_usb_send_cmd(dev, 1, 2, args);
+	return pcan_usb_send_cmd(dev, PCAN_USB_CMD_BITRATE, PCAN_USB_SET, args);
 }
 
 /*
@@ -307,7 +326,7 @@ static int pcan_usb_get_serial(struct peak_usb_device *dev, u32 *serial_number)
 	u8 args[PCAN_USB_CMD_ARGS_LEN];
 	int err;
 
-	err = pcan_usb_wait_rsp(dev, 6, 1, args);
+	err = pcan_usb_wait_rsp(dev, PCAN_USB_CMD_SN, PCAN_USB_GET, args);
 	if (err) {
 		netdev_err(dev->netdev, "getting serial failure: %d\n", err);
 	} else if (serial_number) {
@@ -328,7 +347,7 @@ static int pcan_usb_get_device_id(struct peak_usb_device *dev, u32 *device_id)
 	u8 args[PCAN_USB_CMD_ARGS_LEN];
 	int err;
 
-	err = pcan_usb_wait_rsp(dev, 4, 1, args);
+	err = pcan_usb_wait_rsp(dev, PCAN_USB_CMD_DEVID, PCAN_USB_GET, args);
 	if (err)
 		netdev_err(dev->netdev, "getting device id failure: %d\n", err);
 	else if (device_id)
-- 
2.28.0

