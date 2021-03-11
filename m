Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7E9337F12
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhCKUdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbhCKUce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 15:32:34 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13C8C061761
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 12:32:33 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id e9so431800wrw.10
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 12:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=b2wIaTSiCWaYVSO004GKU7hpJ8QoMMIfDjc8w0PCKnM=;
        b=Ls8sKZHA4006w6sHlBLrJkU2k5Gyas+6yxYmXbOVh2eyM6T3T0W0yNCa5ss22l4ZaA
         5JNippxHaibb4qhVD4MLC8hgsrJrrDjPk+nfXwwi2LsrCi+HVRNqzpTkNRAdZSbLfgUA
         ZuOlEE1xKUje9XVGHB352wT7PZEpHKXsKzLr3Z6oJFpmWs603HtXpDVOP7UKAttuDD5y
         PGoFhbe48a51hwHfkphNWBNaC2OP9HEXJWz+fS00b/KlUQIocvUXmRncFDEEey9IH8C2
         hpyN+zMdPBcZbq3g8ZdkrS4f62mAPIjNe9Mv/ZCRb1pXmcYS8gTGfkm0J7arYpvKk3PL
         zn2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=b2wIaTSiCWaYVSO004GKU7hpJ8QoMMIfDjc8w0PCKnM=;
        b=oKVv4ayJgW2PvkZ8DH5LRX5QSvXS5x8tx1HRGoDncAG9KZWHUnntBiNdlLlqFP2UnM
         W1FbPpcebOmcJBNezUPzlK4kd7MEm5bBJemHuSBmAuOy15g4ZgHTvoAVinW0vfUtzNOJ
         NbIiAfDLZ3o9KAU4gp5zJ8R2tnPOQ4Bt7ciiIhxEcW0lxeHA95Vzu2cvw6zK9WTww3A3
         afZBXbmV4R8aS73ZUOQRRvGvdotJKWcHmVL+70/NACqCii+WcVz8XOWrUXYlR8Sx6q3/
         xoktbyqWs/Vkp8y8XfflhstdZAt1LrGzgotoJNpCDSdQrDVVilpq4sBC9SY/hlZOpTKL
         SLfg==
X-Gm-Message-State: AOAM533BA1pdoO1NTU2WLUtkzxnNRU0uqj/UPCEWt6QaOVWWGJnWq1CV
        3JznA7+tvFjI8qDrnpPO4gyswQ==
X-Google-Smtp-Source: ABdhPJxDZ+BuKJiCG0sZKWczddG9C3UIutACSFY4Hx7YZtUKC/QzhN4wAqt+TGRR7o18zsEb/J8KrQ==
X-Received: by 2002:a5d:534b:: with SMTP id t11mr10371897wrv.186.1615494752029;
        Thu, 11 Mar 2021 12:32:32 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:f986:9cd7:bf3d:f6cb])
        by smtp.gmail.com with ESMTPSA id h22sm5901077wmb.36.2021.03.11.12.32.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Mar 2021 12:32:31 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, aleksander@aleksander.es,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        hemantk@codeaurora.org, jhugo@codeaurora.org,
        rdunlap@infradead.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v5 1/2] net: Add a WWAN subsystem
Date:   Thu, 11 Mar 2021 21:41:03 +0100
Message-Id: <1615495264-6816-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change introduces initial support for a WWAN subsystem. Given the
complexity and heterogeneity of existing WWAN hardwares and interfaces,
there is no strict definition of what a WWAN device is and how it should
be represented. It's often a collection of multiple components/devices
that perform the global WWAN feature (netdev, tty, chardev, etc).

One usual way to expose modem controls and configuration is via high
level protocols such as the well known AT command protocol, MBIM or
QMI. The USB modems started to expose that as character devices, and
user daemons such as ModemManager learnt how to deal with that. This
initial version adds the concept of WWAN port, which can be registered
by any driver to expose one of these protocols. The WWAN core takes
care of the generic part, including character device creation and lets
the driver implementing access (fops) to the selected protocol.

Since the different components/devices do no necesserarly know about
each others, and can be created/removed in different orders, the
WWAN core ensures that devices being part of the same hardware are
also represented as a unique WWAN device, relying on the provided
parent device (e.g. mhi controller, USB device). It's a 'trick' I
copied from Johannes's earlier WWAN subsystem proposal.

This initial version is purposely minimalist, it's essentially moving
the generic part of the previously proposed mhi_wwan_ctrl driver inside
a common WWAN framework, but the implementation is open and flexible
enough to allow extension for further drivers.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: not part of the series
 v3: not part of the series
 v4: Introduce WWAN framework/subsystem
 v5: Specify WWAN_CORE module name in Kconfig

 drivers/net/Kconfig          |   2 +
 drivers/net/Makefile         |   1 +
 drivers/net/wwan/Kconfig     |  22 +++++++
 drivers/net/wwan/Makefile    |   8 +++
 drivers/net/wwan/wwan_core.c | 150 +++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wwan/wwan_core.h |  20 ++++++
 drivers/net/wwan/wwan_port.c | 136 +++++++++++++++++++++++++++++++++++++++
 include/linux/wwan.h         | 121 ++++++++++++++++++++++++++++++++++
 8 files changed, 460 insertions(+)
 create mode 100644 drivers/net/wwan/Kconfig
 create mode 100644 drivers/net/wwan/Makefile
 create mode 100644 drivers/net/wwan/wwan_core.c
 create mode 100644 drivers/net/wwan/wwan_core.h
 create mode 100644 drivers/net/wwan/wwan_port.c
 create mode 100644 include/linux/wwan.h

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 260f9f4..ec00f92 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -500,6 +500,8 @@ source "drivers/net/wan/Kconfig"
 
 source "drivers/net/ieee802154/Kconfig"
 
+source "drivers/net/wwan/Kconfig"
+
 config XEN_NETDEV_FRONTEND
 	tristate "Xen network device frontend driver"
 	depends on XEN
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index f4990ff..5da6424 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -68,6 +68,7 @@ obj-$(CONFIG_SUNGEM_PHY) += sungem_phy.o
 obj-$(CONFIG_WAN) += wan/
 obj-$(CONFIG_WLAN) += wireless/
 obj-$(CONFIG_IEEE802154) += ieee802154/
+obj-$(CONFIG_WWAN) += wwan/
 
 obj-$(CONFIG_VMXNET3) += vmxnet3/
 obj-$(CONFIG_XEN_NETDEV_FRONTEND) += xen-netfront.o
diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
new file mode 100644
index 0000000..545fe54
--- /dev/null
+++ b/drivers/net/wwan/Kconfig
@@ -0,0 +1,22 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Wireless WAN device configuration
+#
+
+menuconfig WWAN
+	bool "Wireless WAN"
+	help
+	  This section contains Wireless WAN driver configurations.
+
+if WWAN
+
+config WWAN_CORE
+	tristate "WWAN Driver Core"
+	help
+	  Say Y here if you want to use the WWAN driver core. This driver
+	  provides a common framework for WWAN drivers.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called wwan.
+
+endif # WWAN
diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
new file mode 100644
index 0000000..ca8bb5a
--- /dev/null
+++ b/drivers/net/wwan/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the Linux WWAN device drivers.
+#
+
+obj-$(CONFIG_WWAN_CORE) += wwan.o
+wwan-objs += wwan_core.o wwan_port.o
+
diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
new file mode 100644
index 0000000..42ba6c0
--- /dev/null
+++ b/drivers/net/wwan/wwan_core.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021, Linaro Ltd <loic.poulain@linaro.org> */
+
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/wwan.h>
+
+#include "wwan_core.h"
+
+static LIST_HEAD(wwan_list);	/* list of registered wwan devices */
+static DEFINE_IDA(wwan_ida);
+static DEFINE_MUTEX(wwan_global_lock);
+struct class *wwan_class;
+
+static struct wwan_device *__wwan_find_by_parent(struct device *parent)
+{
+	struct wwan_device *wwandev;
+
+	if (!parent)
+		return NULL;
+
+	list_for_each_entry(wwandev, &wwan_list, list) {
+		if (wwandev->dev.parent == parent)
+			return wwandev;
+	}
+
+	return NULL;
+}
+
+static void wwan_dev_release(struct device *dev)
+{
+	struct wwan_device *wwandev = to_wwan_dev(dev);
+
+	kfree(wwandev);
+}
+
+static const struct device_type wwan_type = {
+	.name    = "wwan",
+	.release = wwan_dev_release,
+};
+
+struct wwan_device *wwan_create_dev(struct device *parent)
+{
+	struct wwan_device *wwandev;
+	int err, id;
+
+	mutex_lock(&wwan_global_lock);
+
+	wwandev = __wwan_find_by_parent(parent);
+	if (wwandev) {
+		get_device(&wwandev->dev);
+		wwandev->usage++;
+		goto done_unlock;
+	}
+
+	id = ida_alloc(&wwan_ida, GFP_KERNEL);
+	if (id < 0)
+		goto done_unlock;
+
+	wwandev = kzalloc(sizeof(*wwandev), GFP_KERNEL);
+	if (!wwandev) {
+		ida_free(&wwan_ida, id);
+		goto done_unlock;
+	}
+
+	wwandev->dev.parent = parent;
+	wwandev->dev.class = wwan_class;
+	wwandev->dev.type = &wwan_type;
+	wwandev->id = id;
+	dev_set_name(&wwandev->dev, "wwan%d", wwandev->id);
+	wwandev->usage = 1;
+	INIT_LIST_HEAD(&wwandev->ports);
+
+	err = device_register(&wwandev->dev);
+	if (err) {
+		put_device(&wwandev->dev);
+		ida_free(&wwan_ida, id);
+		wwandev = NULL;
+		goto done_unlock;
+	}
+
+	list_add_tail(&wwandev->list, &wwan_list);
+
+done_unlock:
+	mutex_unlock(&wwan_global_lock);
+
+	return wwandev;
+}
+EXPORT_SYMBOL_GPL(wwan_create_dev);
+
+void wwan_destroy_dev(struct wwan_device *wwandev)
+{
+	mutex_lock(&wwan_global_lock);
+	wwandev->usage--;
+
+	if (wwandev->usage)
+		goto done_unlock;
+
+	/* Someone destroyed the wwan device without removing ports */
+	WARN_ON(!list_empty(&wwandev->ports));
+
+	list_del(&wwandev->list);
+	device_unregister(&wwandev->dev);
+	ida_free(&wwan_ida, wwandev->id);
+	put_device(&wwandev->dev);
+
+done_unlock:
+	mutex_unlock(&wwan_global_lock);
+}
+EXPORT_SYMBOL_GPL(wwan_destroy_dev);
+
+static int __init wwan_init(void)
+{
+	int err;
+
+	wwan_class = class_create(THIS_MODULE, "wwan");
+	if (IS_ERR(wwan_class))
+		return PTR_ERR(wwan_class);
+
+	err = wwan_port_init();
+	if (err)
+		goto err_class_destroy;
+
+	return 0;
+
+err_class_destroy:
+	class_destroy(wwan_class);
+	return err;
+}
+
+static void __exit wwan_exit(void)
+{
+	wwan_port_deinit();
+	class_destroy(wwan_class);
+}
+
+//subsys_initcall(wwan_init);
+module_init(wwan_init);
+module_exit(wwan_exit);
+
+MODULE_AUTHOR("Loic Poulain <loic.poulain@linaro.org>");
+MODULE_DESCRIPTION("WWAN core");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/wwan/wwan_core.h b/drivers/net/wwan/wwan_core.h
new file mode 100644
index 0000000..21d187a
--- /dev/null
+++ b/drivers/net/wwan/wwan_core.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2021, Linaro Ltd <loic.poulain@linaro.org> */
+
+#ifndef __WWAN_CORE_H
+#define __WWAN_CORE_H
+
+#include <linux/device.h>
+#include <linux/wwan.h>
+
+#define to_wwan_dev(d) container_of(d, struct wwan_device, dev)
+
+struct wwan_device *wwan_create_dev(struct device *parent);
+void wwan_destroy_dev(struct wwan_device *wwandev);
+
+int wwan_port_init(void);
+void wwan_port_deinit(void);
+
+extern struct class *wwan_class;
+
+#endif /* WWAN_CORE_H */
diff --git a/drivers/net/wwan/wwan_port.c b/drivers/net/wwan/wwan_port.c
new file mode 100644
index 0000000..b32da8f
--- /dev/null
+++ b/drivers/net/wwan/wwan_port.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021, Linaro Ltd <loic.poulain@linaro.org> */
+
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/wwan.h>
+
+#include "wwan_core.h"
+
+#define WWAN_MAX_MINORS 32
+
+static int wwan_major;
+static DEFINE_IDR(wwan_port_idr);
+static DEFINE_MUTEX(wwan_port_idr_lock);
+
+static const char * const wwan_port_type_str[] = {
+	"AT",
+	"MBIM",
+	"QMI",
+	"QCDM",
+	"FIREHOSE"
+};
+
+int wwan_add_port(struct wwan_port *port)
+{
+	struct wwan_device *wwandev = port->wwandev;
+	struct device *dev;
+	int minor, err;
+
+	if (port->type >= WWAN_PORT_MAX || !port->fops || !wwandev)
+		return -EINVAL;
+
+	mutex_lock(&wwan_port_idr_lock);
+	minor = idr_alloc(&wwan_port_idr, port, 0, WWAN_MAX_MINORS, GFP_KERNEL);
+	mutex_unlock(&wwan_port_idr_lock);
+
+	if (minor < 0)
+		return minor;
+
+	mutex_lock(&wwandev->lock);
+
+	dev = device_create(wwan_class, &wwandev->dev,
+			    MKDEV(wwan_major, minor), port,
+			    "wwan%dp%u%s", wwandev->id, wwandev->port_idx,
+			    wwan_port_type_str[port->type]);
+	if (IS_ERR(dev)) {
+		err = PTR_ERR(dev);
+		mutex_unlock(&wwandev->lock);
+		goto error_free_idr;
+	}
+
+	port->id = wwandev->port_idx++;
+	port->minor = minor;
+
+	list_add(&port->list, &wwandev->ports);
+
+	mutex_unlock(&port->wwandev->lock);
+
+	return 0;
+
+error_free_idr:
+	mutex_lock(&wwan_port_idr_lock);
+	idr_remove(&wwan_port_idr, minor);
+	mutex_unlock(&wwan_port_idr_lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(wwan_add_port);
+
+void wwan_remove_port(struct wwan_port *port)
+{
+	struct wwan_device *wwandev = port->wwandev;
+
+	WARN_ON(!wwandev);
+
+	mutex_lock(&wwandev->lock);
+	device_destroy(wwan_class, MKDEV(wwan_major, port->minor));
+	list_del(&port->list);
+	mutex_unlock(&wwandev->lock);
+
+	mutex_lock(&wwan_port_idr_lock);
+	idr_remove(&wwan_port_idr, port->minor);
+	mutex_unlock(&wwan_port_idr_lock);
+}
+EXPORT_SYMBOL_GPL(wwan_remove_port);
+
+static int wwan_port_open(struct inode *inode, struct file *file)
+{
+	const struct file_operations *new_fops;
+	unsigned int minor = iminor(inode);
+	struct wwan_port *port;
+	int err = 0;
+
+	mutex_lock(&wwan_port_idr_lock);
+	port = idr_find(&wwan_port_idr, minor);
+	if (!port) {
+		mutex_unlock(&wwan_port_idr_lock);
+		return -ENODEV;
+	}
+	mutex_unlock(&wwan_port_idr_lock);
+
+	file->private_data = port->private_data ? port->private_data : port;
+	stream_open(inode, file);
+
+	new_fops = fops_get(port->fops);
+	replace_fops(file, new_fops);
+	if (file->f_op->open)
+		err = file->f_op->open(inode, file);
+
+	return err;
+}
+
+static const struct file_operations wwan_port_fops = {
+	.owner	= THIS_MODULE,
+	.open	= wwan_port_open,
+	.llseek = noop_llseek,
+};
+
+int wwan_port_init(void)
+{
+	wwan_major = register_chrdev(0, "wwanport", &wwan_port_fops);
+	if (wwan_major < 0)
+		return wwan_major;
+
+	return 0;
+}
+
+void wwan_port_deinit(void)
+{
+	unregister_chrdev(wwan_major, "wwanport");
+	idr_destroy(&wwan_port_idr);
+}
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
new file mode 100644
index 0000000..6caca5c
--- /dev/null
+++ b/include/linux/wwan.h
@@ -0,0 +1,121 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2021, Linaro Ltd <loic.poulain@linaro.org> */
+
+#ifndef __WWAN_H
+#define __WWAN_H
+
+#include <linux/device.h>
+#include <linux/kernel.h>
+
+/**
+ * struct wwan_device - The structure that defines a WWAN device
+ *
+ * @id:		WWAN device unique ID.
+ * @usage:	WWAN device usage counter.
+ * @dev:	underlying device.
+ * @list:	list to chain WWAN devices.
+ * @ports:	list of attached wwan_port.
+ * @port_idx:	port index counter.
+ * @lock:	mutex protecting members of this structure.
+ */
+struct wwan_device {
+	int id;
+	unsigned int usage;
+
+	struct device dev;
+	struct list_head list;
+
+	struct list_head ports;
+	unsigned int port_idx;
+
+	struct mutex lock;
+};
+
+/**
+ * enum wwan_port_type - WWAN port types
+ * @WWAN_PORT_AT:	AT commands.
+ * @WWAN_PORT_MBIM:	Mobile Broadband Interface Model control.
+ * @WWAN_PORT_QMI:	Qcom modem/MSM interface for modem control.
+ * @WWAN_PORT_QCDM:	Qcom Modem diagnostic interface.
+ * @WWAN_PORT_FIREHOSE: XML based command protocol.
+ * @WWAN_PORT_MAX
+ */
+enum wwan_port_type {
+	WWAN_PORT_AT,
+	WWAN_PORT_MBIM,
+	WWAN_PORT_QMI,
+	WWAN_PORT_QCDM,
+	WWAN_PORT_FIREHOSE,
+	WWAN_PORT_MAX,
+};
+
+/**
+ * struct wwan_port - The structure that defines a WWAN port
+ *
+ * @wwandev:		WWAN device this port belongs to.
+ * @fops:		Port file operations.
+ * @private_data:	underlying device.
+ * @type:		port type.
+ * @id:			port allocated ID.
+ * @minor:		port allocated minor ID for cdev.
+ * @list:		list to chain WWAN ports.
+ */
+struct wwan_port {
+	struct wwan_device *wwandev;
+	const struct file_operations *fops;
+	void *private_data;
+	enum wwan_port_type type;
+
+	/* private */
+	unsigned int id;
+	int minor;
+	struct list_head list;
+};
+
+#define to_wwan_dev(d) container_of(d, struct wwan_device, dev)
+
+/**
+ * wwan_create_dev - Create a new WWAN device
+ * @parent: parent device of the WWAN device
+ *
+ * If parent is not NULL, WWAN core ensures that only one WWAN device is
+ * allocated for a given parent. If a WWAN device with the specified parent
+ * already exists, a reference is taken and the WWAN device is returned.
+ *
+ * This function must be balanced with a call to wwan_destroy_dev().
+ *
+ * Returns pointer to the wwan_device or NULL.
+ */
+struct wwan_device *wwan_create_dev(struct device *parent);
+
+/**
+ * wwan_create_dev - Destroy a WWAN device
+ * @wwandev: wwan_device to destroy
+ *
+ * This releases a previoulsy created WWAN device.
+ */
+void wwan_destroy_dev(struct wwan_device *wwandev);
+
+/**
+ * wwan_add_port - Add a new WWAN port
+ * @port: WWAN port to add
+ *
+ * Prior calling this function, caller must allocate and fill the wwan_port
+ * with wwandev, fops, and type fields. A port is automatically exposed to
+ * user as character device, and provided file operations will be used.
+ *
+ * This function must be balanced with a call to wwan_remove_port().
+ *
+ * Returns zero on success or a negative error code.
+ */
+int wwan_add_port(struct wwan_port *port);
+
+/**
+ * wwan_remove_port - Remove a WWAN port
+ * @port: WWAN port to remove
+ *
+ * Remove a previously added port.
+ */
+void wwan_remove_port(struct wwan_port *port);
+
+#endif /* __WWAN_H */
-- 
2.7.4

