Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDB563971B
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 17:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiKZQWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 11:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiKZQWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 11:22:41 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5017D133;
        Sat, 26 Nov 2022 08:22:39 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id z17so1849424pff.1;
        Sat, 26 Nov 2022 08:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FmB9Jwaiin8tKBRiu/35E9rAp2jafIlqnhIKGIJ7dMk=;
        b=khULKVn7mhBorIgJ9/uSv1GtI9gWeAf7IdoCqRohNUR3WBjwfEG8IRQpjhUFMcy/pF
         bZUfl5luaKyGxgWulR/VhNJE06b6pbsTiAcTuWh2zfW7cBzfeQBnyllksrnct6RuRZbs
         4YejzBFsRwKBoUC8ir9dG4ru0k8JluVmTAqU/ZbCPGwzdPGccBSn+wZNcxsDGhM7lQZG
         k+PbJtI0sAUGEBZsMCTP6WaSfg7Vbkl4umo6qg8T7mEz9QkwpvT1PWDyfkwycKKLOTh/
         MjJqiibil70zUkopTYedSZ7NMce7bCMAFfPTkiA7JQ4guX5sFdEcB4GQ/kspK0PkWaZ5
         JwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FmB9Jwaiin8tKBRiu/35E9rAp2jafIlqnhIKGIJ7dMk=;
        b=1EOziRpsfVc7Cr3G+akDuRslHTKyyYDmQYrYgzu2OY3c3PbZVuQ8ma4SUgiD1c5A3i
         lRU4gMFmmtAM4m5k52FF6Yn/wZxJHlrNTn9mixzLJ6yr8zN8d4bYIHQUs1dt1nKlO71b
         v8B7C65XknCtOQHPu1WMd45aCDY2Z/11vMiImElDd4JdLHmH4qibnarqZBgDczgSjQ/V
         s3+9IzgLDiL4bTMv5MCAUJEGhD8ft21z99VDZQzVjW931o3CBE3xrzk4QWa9RypbC9Xq
         AbPjY0SFuE06PRNQShLL5KrbBPFTwi+XzdhpNmFUzmTxAORVMULFSFcOrvY4aHEVE4bS
         okUA==
X-Gm-Message-State: ANoB5pl6voL9R3Z7EW5stRWpdivMddQlOrmQCGlxs3Zaepq/zjf3adEI
        WGCrP5dSA/3w0i1eISZ9ayQvjDGOF+REdw==
X-Google-Smtp-Source: AA0mqf7akjIjMCphTmSxxnnBmxi9wciY15SqpAYixyIBB/XT6sXM2NQhkloK/fTYG/BtfblF55IISw==
X-Received: by 2002:a63:1f63:0:b0:460:ec46:3645 with SMTP id q35-20020a631f63000000b00460ec463645mr40054183pgm.92.1669479758992;
        Sat, 26 Nov 2022 08:22:38 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id y14-20020a63e24e000000b00460ea630c1bsm4169601pgj.46.2022.11.26.08.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Nov 2022 08:22:38 -0800 (PST)
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
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 2/6] can: etas_es58x: add devlink support
Date:   Sun, 27 Nov 2022 01:22:07 +0900
Message-Id: <20221126162211.93322-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic support for devlink. The callbacks of struct devlink_ops
will be implemented next.

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
index 4c97102202bf..c6e598e4800c 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/usb.h>
+#include <net/devlink.h>
 
 #include "es58x_core.h"
 
@@ -2174,6 +2175,7 @@ static struct es58x_device *es58x_init_es58x_dev(struct usb_interface *intf,
 {
 	struct device *dev = &intf->dev;
 	struct es58x_device *es58x_dev;
+	struct devlink *devlink;
 	const struct es58x_parameters *param;
 	const struct es58x_operators *ops;
 	struct usb_device *udev = interface_to_usbdev(intf);
@@ -2196,11 +2198,12 @@ static struct es58x_device *es58x_init_es58x_dev(struct usb_interface *intf,
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
@@ -2247,6 +2250,8 @@ static int es58x_probe(struct usb_interface *intf,
 	if (ret)
 		return ret;
 
+	devlink_register(priv_to_devlink(es58x_dev));
+
 	for (ch_idx = 0; ch_idx < es58x_dev->num_can_ch; ch_idx++) {
 		ret = es58x_init_netdev(es58x_dev, ch_idx);
 		if (ret) {
@@ -2272,8 +2277,10 @@ static void es58x_disconnect(struct usb_interface *intf)
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

