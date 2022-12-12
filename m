Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61332649DB7
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbiLLLbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbiLLLbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:06 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AA46582
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:30:59 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1N-0000BV-PS
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:30:57 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id EA4AD13CBBA
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:53 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 3635D13CB7F;
        Mon, 12 Dec 2022 11:30:52 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 01df56a1;
        Mon, 12 Dec 2022 11:30:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 12/39] can: etas_es58x: add devlink support
Date:   Mon, 12 Dec 2022 12:30:18 +0100
Message-Id: <20221212113045.222493-13-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212113045.222493-1-mkl@pengutronix.de>
References: <20221212113045.222493-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Add basic support for devlink at the device level. The callbacks of
struct devlink_ops will be implemented next.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20221130174658.29282-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/Kconfig                    |  1 +
 drivers/net/can/usb/etas_es58x/Makefile        |  2 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c    | 13 ++++++++++---
 drivers/net/can/usb/etas_es58x/es58x_core.h    |  6 ++++++
 drivers/net/can/usb/etas_es58x/es58x_devlink.c | 13 +++++++++++++
 5 files changed, 31 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_devlink.c

diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
index 8c6fea661530..445504ababce 100644
--- a/drivers/net/can/usb/Kconfig
+++ b/drivers/net/can/usb/Kconfig
@@ -30,6 +30,7 @@ config CAN_ESD_USB
 config CAN_ETAS_ES58X
 	tristate "ETAS ES58X CAN/USB interfaces"
 	select CRC16
+	select NET_DEVLINK
 	help
 	  This driver supports the ES581.4, ES582.1 and ES584.1 interfaces
 	  from ETAS GmbH (https://www.etas.com/en/products/es58x.php).
diff --git a/drivers/net/can/usb/etas_es58x/Makefile b/drivers/net/can/usb/etas_es58x/Makefile
index a129b4aa0215..d6667ebe259f 100644
--- a/drivers/net/can/usb/etas_es58x/Makefile
+++ b/drivers/net/can/usb/etas_es58x/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CAN_ETAS_ES58X) += etas_es58x.o
-etas_es58x-y = es58x_core.o es581_4.o es58x_fd.o
+etas_es58x-y = es58x_core.o es58x_devlink.o es581_4.o es58x_fd.o
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 5aba16849603..aeffe61faed8 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/usb.h>
+#include <net/devlink.h>
 
 #include "es58x_core.h"
 
@@ -2177,6 +2178,7 @@ static struct es58x_device *es58x_init_es58x_dev(struct usb_interface *intf,
 {
 	struct device *dev = &intf->dev;
 	struct es58x_device *es58x_dev;
+	struct devlink *devlink;
 	const struct es58x_parameters *param;
 	const struct es58x_operators *ops;
 	struct usb_device *udev = interface_to_usbdev(intf);
@@ -2199,11 +2201,12 @@ static struct es58x_device *es58x_init_es58x_dev(struct usb_interface *intf,
 		ops = &es581_4_ops;
 	}
 
-	es58x_dev = devm_kzalloc(dev, es58x_sizeof_es58x_device(param),
-				 GFP_KERNEL);
-	if (!es58x_dev)
+	devlink = devlink_alloc(&es58x_dl_ops, es58x_sizeof_es58x_device(param),
+				dev);
+	if (!devlink)
 		return ERR_PTR(-ENOMEM);
 
+	es58x_dev = devlink_priv(devlink);
 	es58x_dev->param = param;
 	es58x_dev->ops = ops;
 	es58x_dev->dev = dev;
@@ -2250,6 +2253,8 @@ static int es58x_probe(struct usb_interface *intf,
 	if (ret)
 		return ret;
 
+	devlink_register(priv_to_devlink(es58x_dev));
+
 	for (ch_idx = 0; ch_idx < es58x_dev->num_can_ch; ch_idx++) {
 		ret = es58x_init_netdev(es58x_dev, ch_idx);
 		if (ret) {
@@ -2275,8 +2280,10 @@ static void es58x_disconnect(struct usb_interface *intf)
 	dev_info(&intf->dev, "Disconnecting %s %s\n",
 		 es58x_dev->udev->manufacturer, es58x_dev->udev->product);
 
+	devlink_unregister(priv_to_devlink(es58x_dev));
 	es58x_free_netdevs(es58x_dev);
 	es58x_free_urbs(es58x_dev);
+	devlink_free(priv_to_devlink(es58x_dev));
 	usb_set_intfdata(intf, NULL);
 }
 
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
index 4a082fd69e6f..bf24375580e5 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -674,6 +674,7 @@ static inline enum es58x_flag es58x_get_flags(const struct sk_buff *skb)
 	return es58x_flags;
 }
 
+/* es58x_core.c. */
 int es58x_can_get_echo_skb(struct net_device *netdev, u32 packet_idx,
 			   u64 *tstamps, unsigned int pkts);
 int es58x_tx_ack_msg(struct net_device *netdev, u16 tx_free_entries,
@@ -691,9 +692,14 @@ int es58x_rx_cmd_ret_u32(struct net_device *netdev,
 int es58x_send_msg(struct es58x_device *es58x_dev, u8 cmd_type, u8 cmd_id,
 		   const void *msg, u16 cmd_len, int channel_idx);
 
+/* es58x_devlink.c. */
+extern const struct devlink_ops es58x_dl_ops;
+
+/* es581_4.c. */
 extern const struct es58x_parameters es581_4_param;
 extern const struct es58x_operators es581_4_ops;
 
+/* es58x_fd.c. */
 extern const struct es58x_parameters es58x_fd_param;
 extern const struct es58x_operators es58x_fd_ops;
 
diff --git a/drivers/net/can/usb/etas_es58x/es58x_devlink.c b/drivers/net/can/usb/etas_es58x/es58x_devlink.c
new file mode 100644
index 000000000000..af6ca7ada23f
--- /dev/null
+++ b/drivers/net/can/usb/etas_es58x/es58x_devlink.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Driver for ETAS GmbH ES58X USB CAN(-FD) Bus Interfaces.
+ *
+ * File es58x_devlink.c: report the product information using devlink.
+ *
+ * Copyright (c) 2022 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
+ */
+
+#include <net/devlink.h>
+
+const struct devlink_ops es58x_dl_ops = {
+};
-- 
2.35.1


