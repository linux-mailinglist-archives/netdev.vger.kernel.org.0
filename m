Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8752760E1C4
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbiJZNQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbiJZNQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:16:37 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548118306F;
        Wed, 26 Oct 2022 06:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1666790196; x=1698326196;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rmV74reOQIhMVx3wfFt0WNHhPTZ+EE2t0X4nueZsE3E=;
  b=lwV9B2/GGH8BD3LR4e9svhvvx7RNQizqm6gj1u8lWwh2uS3mbd2h7m77
   fFIeenw0jw/sk36Jn7aB0/3WrSp0hL8FXfH2ZmWULWIKn+xthB/wfu0o+
   ZBsxG0dMlFqe2vKriIiEh9HpznGjM3EH8yUW1KIryzddTvbzCcTwpW7MJ
   NF7GBKeuu/1t0Cinlw6WPO1PYp5Jvbv9lpEOZkAP0uBqIMbpc0lL3Rk4I
   dZlsGK1d153gvSVyeNXgRCb1NPTwDbtBfJtG0cofHZfv5BNuWtn0A0PW5
   f7weVBgDd80tPnUa8YQLJgSzJCqUt9KtMF+Wg70X6SeXKVXrXJCCscCTv
   A==;
X-IronPort-AV: E=Sophos;i="5.95,214,1661810400"; 
   d="scan'208";a="26988469"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 26 Oct 2022 15:16:31 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 26 Oct 2022 15:16:31 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 26 Oct 2022 15:16:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1666790191; x=1698326191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rmV74reOQIhMVx3wfFt0WNHhPTZ+EE2t0X4nueZsE3E=;
  b=FXDp8xAAIqGd6/RL9y8KrOnNq0i/vgBaqMYdKGbnkXh0qoMQa68LPoQ3
   5JBbE5FQHNkEgB0edF+VAwEUnlpvFXIynS+aBvLjzFu9ClGKITol5aLab
   Ndh6731IPrB2/3d+OG5sVUbsWvU1m+RVoRpmf0Te2jM0r7qI/AbPip9n6
   vIT5zrl4QaS8x9eUdclxXUnA52znNWj8c64Y1PODYEuhDJQbzJxOyxBEb
   sfl/JUUIDDL5qJ9wr+Wo2UCO8p3YPG5kx2eclsonv9VPs9hEOMxZnvT44
   CD2caRrZVFM8riiFR/i0e115nWeWRJjm7jJyc6udD37yC8gx/F7vDMAyU
   g==;
X-IronPort-AV: E=Sophos;i="5.95,214,1661810400"; 
   d="scan'208";a="26988468"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 26 Oct 2022 15:16:31 +0200
Received: from localhost.localdomain (SCHIFFERM-M2.tq-net.de [10.121.49.14])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 21BFC280072;
        Wed, 26 Oct 2022 15:16:30 +0200 (CEST)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux@ew.tq-group.com,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [RFC 1/5] misc: introduce notify-device driver
Date:   Wed, 26 Oct 2022 15:15:30 +0200
Message-Id: <db30127ab4741d4e71b768881197f4791174f545.1666786471.git.matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1666786471.git.matthias.schiffer@ew.tq-group.com>
References: <cover.1666786471.git.matthias.schiffer@ew.tq-group.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A notify-device is a synchronization facility that allows to query
"readiness" across drivers, without creating a direct dependency between
the driver modules. The notify-device can also be used to trigger deferred
probes.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/misc/Kconfig          |   4 ++
 drivers/misc/Makefile         |   1 +
 drivers/misc/notify-device.c  | 109 ++++++++++++++++++++++++++++++++++
 include/linux/notify-device.h |  33 ++++++++++
 4 files changed, 147 insertions(+)
 create mode 100644 drivers/misc/notify-device.c
 create mode 100644 include/linux/notify-device.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 358ad56f6524..63559e9f854c 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -496,6 +496,10 @@ config VCPU_STALL_DETECTOR
 
 	  If you do not intend to run this kernel as a guest, say N.
 
+config NOTIFY_DEVICE
+	tristate "Notify device"
+	depends on OF
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index ac9b3e757ba1..1e8012112b43 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -62,3 +62,4 @@ obj-$(CONFIG_HI6421V600_IRQ)	+= hi6421v600-irq.o
 obj-$(CONFIG_OPEN_DICE)		+= open-dice.o
 obj-$(CONFIG_GP_PCI1XXXX)	+= mchp_pci1xxxx/
 obj-$(CONFIG_VCPU_STALL_DETECTOR)	+= vcpu_stall_detector.o
+obj-$(CONFIG_NOTIFY_DEVICE)	+= notify-device.o
diff --git a/drivers/misc/notify-device.c b/drivers/misc/notify-device.c
new file mode 100644
index 000000000000..42e0980394ea
--- /dev/null
+++ b/drivers/misc/notify-device.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/device/class.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/notify-device.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+static void notify_device_release(struct device *dev)
+{
+	of_node_put(dev->of_node);
+	kfree(dev);
+}
+
+static struct class notify_device_class = {
+	.name = "notify-device",
+	.owner = THIS_MODULE,
+	.dev_release = notify_device_release,
+};
+
+static struct platform_driver notify_device_driver = {
+	.driver = {
+		.name = "notify-device",
+	},
+};
+
+struct device *notify_device_create(struct device *parent, const char *child)
+{
+	struct device_node *node;
+	struct device *dev;
+	int err;
+
+	if (!parent->of_node)
+		return ERR_PTR(-EINVAL);
+
+	node = of_get_child_by_name(parent->of_node, child);
+	if (!node)
+		return NULL;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		of_node_put(node);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	dev_set_name(dev, "%s:%s", dev_name(parent), child);
+	dev->class = &notify_device_class;
+	dev->parent = parent;
+	dev->of_node = node;
+	err = device_register(dev);
+	if (err) {
+		put_device(dev);
+		return ERR_PTR(err);
+	}
+
+	dev->driver = &notify_device_driver.driver;
+	err = device_bind_driver(dev);
+	if (err) {
+		device_unregister(dev);
+		return ERR_PTR(err);
+	}
+
+	return dev;
+}
+EXPORT_SYMBOL_GPL(notify_device_create);
+
+void notify_device_destroy(struct device *dev)
+{
+	if (!dev)
+		return;
+
+	device_release_driver(dev);
+	device_unregister(dev);
+}
+EXPORT_SYMBOL_GPL(notify_device_destroy);
+
+struct device *notify_device_find_by_of_node(struct device_node *node)
+{
+	return class_find_device_by_of_node(&notify_device_class, node);
+}
+EXPORT_SYMBOL_GPL(notify_device_find_by_of_node);
+
+static int __init notify_device_init(void)
+{
+	int err;
+
+	err = class_register(&notify_device_class);
+	if (err)
+		return err;
+
+	err = platform_driver_register(&notify_device_driver);
+	if (err) {
+		class_unregister(&notify_device_class);
+		return err;
+	}
+
+	return 0;
+}
+
+static void __exit notify_device_exit(void)
+{
+	platform_driver_unregister(&notify_device_driver);
+	class_unregister(&notify_device_class);
+}
+
+module_init(notify_device_init);
+module_exit(notify_device_exit);
+MODULE_LICENSE("GPL");
diff --git a/include/linux/notify-device.h b/include/linux/notify-device.h
new file mode 100644
index 000000000000..f8c3e15d3b8f
--- /dev/null
+++ b/include/linux/notify-device.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_NOTIFY_DEVICE_H
+#define _LINUX_NOTIFY_DEVICE_H
+#include <linux/device.h>
+#include <linux/of.h>
+
+#ifdef CONFIG_NOTIFY_DEVICE
+
+struct device *notify_device_create(struct device *parent, const char *child);
+void notify_device_destroy(struct device *dev);
+struct device *notify_device_find_by_of_node(struct device_node *node);
+
+#else
+
+static inline struct device *notify_device_create(struct device *parent,
+						  const char *child)
+{
+	return NULL;
+}
+
+static inline void notify_device_destroy(struct device *dev)
+{
+}
+
+static inline struct device *notify_device_find_by_of_node(struct device_node *node)
+{
+	return NULL;
+}
+
+#endif
+
+#endif /* _LINUX_NOTIFY_DEVICE_H */
-- 
2.25.1

