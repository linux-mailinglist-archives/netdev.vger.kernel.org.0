Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A793B63DC53
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiK3RrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiK3RrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:47:16 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BBD5217D;
        Wed, 30 Nov 2022 09:47:15 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so2970165pjd.5;
        Wed, 30 Nov 2022 09:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3MR3h+En6xAnYa/nGayyjwsy00Mwh4XUedfM8z4JVpY=;
        b=jxMSYixhM7Ngh5a62kfk/HGeGLa1WwkfLaNM4Bpm3xLEpuBQz0s1SKEmd3zgYrxyxc
         a5AQ0xotP+kkQoB2ExHx3E3j1cN6mS2v4vvOKqQS2EWE+wJQYw/uLEDkp66Wbyv3m7tn
         IHuSVL+hJXcOmqbWlHUEqRbv5k6BKzMAjnS6UY0T2Zj2/MHX9m/OMxfJJj+2K33AWx2V
         ZQ7Bu4/BtEWMAKNyAKnfifIps9NX+mmvktnY/hh/L3iWr2sQpr5Qu2u/lKw4GumpoS8l
         xwkxxN3Dld/wHhJejycoz9zBWvSkcnuh0EwClZMdykRNvd3pRm6LmurN1TJn0v5HfT8v
         scnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3MR3h+En6xAnYa/nGayyjwsy00Mwh4XUedfM8z4JVpY=;
        b=i1R6QQJQmfLZbPydW4Gi3WQnJxSvbinhgX+p1Z8AV1HWO1y8hLzUHS4ig+s2+aPyR4
         HdRpQGRcJXf+o7mAnLv6f1lMw/gGaW078O01oGh/0fDg126yY6S10FjBuc8SqRpbCuVG
         veUdvD0YFk8xldsnsfJCLICriYGee+wGdE5mIwivSRZyIWXqC6gE7oNm6+r3gBGqVPLI
         LSwkPHa2hADDr5Is8oBh6NzgAKJEPZU2KG/K1Ty2Vm4lQGusMY9IxAe5b9HtIpb478Ta
         ma6r2yJ4I7pjqTlO5ssgzxju9g6Q7hiUozQlb1jwP6LGjOCL2yeasEtAiuQ7V5dCYFFP
         o+8w==
X-Gm-Message-State: ANoB5plcobYXhs/xCeQ7qIyb8PBCP4zEZLWfQOSUzZQrZkTLnHG2ssmC
        MVrkwVQnuKhqVsgNBab3qH0zKWQTu+CnAA==
X-Google-Smtp-Source: AA0mqf7YOYrxOXP0JssPpNsQ8ePia+E5j4wwsBmgO+xnQgqprxpia9JnbI+fDRk5vzyN8OAXAbbp/g==
X-Received: by 2002:a17:90a:4615:b0:218:8f4:bad5 with SMTP id w21-20020a17090a461500b0021808f4bad5mr72721002pjg.55.1669830435020;
        Wed, 30 Nov 2022 09:47:15 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id p3-20020aa79e83000000b00574cdb63f03sm1714505pfq.144.2022.11.30.09.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 09:47:14 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-can@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 1/7] can: etas_es58x: add devlink support
Date:   Thu,  1 Dec 2022 02:46:52 +0900
Message-Id: <20221130174658.29282-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221130174658.29282-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221130174658.29282-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic support for devlink at the device level. The callbacks of
struct devlink_ops will be implemented next.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
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
2.37.4

