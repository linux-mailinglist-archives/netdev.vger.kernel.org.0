Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEC734FE14
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 12:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbhCaKam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 06:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234830AbhCaKab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 06:30:31 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA81C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 03:30:30 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id c8so19108514wrq.11
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 03:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=4+nGEPK91XLzTVorNXhgLyLGGsriKISFQdHRGmIhwfU=;
        b=DmDQqSVh0ARuN5b/5Ts2AATMnt1BE1bQoSwbiQGrZCq3uUvobWy8hmYx9W21bHmZSz
         L+YyfxhhpHRQpc4l2F01Cg4rU6QG+TJIxa00ZcyoSkm0MtvtZxF5/OujfY/NRmcPtvg3
         r6iHfgaAEBNKxDOi9f24KR5ssgoVwVWwVAjkxe9mEMxySmVvsa1Y8MzooWdxc8qiRhjt
         3Tm2oZSDIaPPA2MdLq+p33Wawc+2r7m14TCs39+PCTQbQ1DoR9A1CT8Aoq7nogN+C/30
         xZJY9jsNM+i1L4Wg9HYGk49pBJoKC/X6jDODspETppJgWl6CoAnNic71dk+1s9XwUQ3/
         buDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4+nGEPK91XLzTVorNXhgLyLGGsriKISFQdHRGmIhwfU=;
        b=cpsJLvmNnVgAcflkUu/asR9S3e/J5AAO1XMmPzYQq4xcRfkjzOubb0O6GI2ufTFks+
         59NVD9DMpQR0xrPbTW5CAqb1cCqhoyXGwQVSwqSwXkySnoBhY+P1mj7NVigutvhfPZFt
         cfVjA7r0WNpaul6zmLBvCtKNvN7G/9fkykHN/aCKG3D69VW2/gtksdh30vXv48hdMH/G
         U5mfuTTAK90fc4W/F9qVYNQfwU3Us0G1ILqySN9D+iqXN97i3WMSvUUVWaoHgozUgyFj
         BRC93t9SzjrV0BmDKsFJDSzKnLpWWQZqZVjyurCC7qvOvq+ERP8anzFcbnc1qymk8CdK
         CAVg==
X-Gm-Message-State: AOAM531W7p6ToNIMrGMuL9IEBFx9wFdE47RN1qDRmNHosoInGUoPhut+
        G9XT47hajxqGLifl5C4PuiD+HQ==
X-Google-Smtp-Source: ABdhPJydujGbH73klrGPVXPUHdOreDy3B669iDzPhl13Tes5m4aoh/a58BhKQdAl4+vozP9VoPNGRw==
X-Received: by 2002:adf:ed46:: with SMTP id u6mr2831028wro.350.1617186628923;
        Wed, 31 Mar 2021 03:30:28 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:8ca0:fa3:7d12:167b])
        by smtp.gmail.com with ESMTPSA id n6sm4385336wmd.27.2021.03.31.03.30.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Mar 2021 03:30:28 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        aleksander@aleksander.es, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v6 1/2] net: Add a WWAN subsystem
Date:   Wed, 31 Mar 2021 12:39:09 +0200
Message-Id: <1617187150-13727-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change introduces initial support for a WWAN subsystem. Given the
complexity and heterogeneity of existing WWAN hardwares and interfaces,
there is no strict definition of what a WWAN device is and how it should
be represented. It's often a collection of multiple devices that perform
the global WWAN feature (netdev, tty, chardev, etc).

One usual way to expose modem controls and configuration is via high
level protocols such as the well known AT command protocol, MBIM or
QMI. The USB modems started to expose that as character devices, and
user daemons such as ModemManager learnt how to deal with them. This
initial version adds the concept of WWAN port, which can be created
by any driver to expose one of these protocols. The WWAN core takes
care of the generic part, including character device creation and lets
the driver implementing access (fops) for the selected protocol.

Since the different components/devices do no necesserarly know about
each others, and can be created/removed in different orders, the
WWAN core ensures that all WAN ports that contribute to the whole
WWAN feature are grouped under the same virtual WWAN device, relying
on the provided parent device (e.g. mhi controller, USB device). It's
a 'trick' I copied from Johannes's earlier WWAN subsystem proposal.

This initial version is purposely minimalist, it's essentially moving
the generic part of the previously proposed mhi_wwan_ctrl driver inside
a common WWAN framework, but the implementation is open and flexible
enough to allow extension for further drivers.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: update copyright (2021)
 v3: Move driver to dedicated drivers/net/wwan directory
 v4: Rework to use wwan framework instead of self cdev management
 v5: Fix errors/typos in Kconfig
 v6: - Move to new wwan interface, No need dedicated call to wwan_dev_create
     - Cleanup code (remove legacy from mhi_uci, unused defines/vars...)
     - Remove useless write_lock mutex
     - Add mhi_wwan_wait_writable and mhi_wwan_wait_dlqueue_lock_irq helpers
     - Rework locking
     - Add MHI_WWAN_TX_FULL flag
     - Add support for NONBLOCK read/write

 drivers/net/Kconfig          |   2 +
 drivers/net/Makefile         |   1 +
 drivers/net/wwan/Kconfig     |  22 +++
 drivers/net/wwan/Makefile    |   7 +
 drivers/net/wwan/wwan_core.c | 317 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/wwan.h         |  73 ++++++++++
 6 files changed, 422 insertions(+)
 create mode 100644 drivers/net/wwan/Kconfig
 create mode 100644 drivers/net/wwan/Makefile
 create mode 100644 drivers/net/wwan/wwan_core.c
 create mode 100644 include/linux/wwan.h

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 5895905..74dc8e24 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -502,6 +502,8 @@ source "drivers/net/wan/Kconfig"
 
 source "drivers/net/ieee802154/Kconfig"
 
+source "drivers/net/wwan/Kconfig"
+
 config XEN_NETDEV_FRONTEND
 	tristate "Xen network device frontend driver"
 	depends on XEN
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 040e20b..7ffd2d0 100644
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
index 0000000..934590b
--- /dev/null
+++ b/drivers/net/wwan/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the Linux WWAN device drivers.
+#
+
+obj-$(CONFIG_WWAN_CORE) += wwan.o
+wwan-objs += wwan_core.o
diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
new file mode 100644
index 0000000..7d9e2643
--- /dev/null
+++ b/drivers/net/wwan/wwan_core.c
@@ -0,0 +1,317 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021, Linaro Ltd <loic.poulain@linaro.org> */
+
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/idr.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/wwan.h>
+
+#define WWAN_MAX_MINORS 256 /* Allow the whole available cdev range of minors */
+
+static DEFINE_MUTEX(wwan_register_lock); /* WWAN device create|remove lock */
+static DEFINE_IDA(minors); /* minors for WWAN port chardevs */
+static DEFINE_IDA(wwan_dev_ids); /* for unique WWAN device IDs */
+static struct class *wwan_class;
+static int wwan_major;
+
+#define to_wwan_dev(d) container_of(d, struct wwan_device, dev)
+#define to_wwan_port(d) container_of(d, struct wwan_port, dev)
+
+/**
+ * struct wwan_device - The structure that defines a WWAN device
+ *
+ * @id: WWAN device unique ID.
+ * @dev: Underlying device.
+ * @port_id: Current available port ID to pick.
+ */
+struct wwan_device {
+	unsigned int id;
+	struct device dev;
+	atomic_t port_id;
+};
+
+static void wwan_dev_release(struct device *dev)
+{
+	struct wwan_device *wwandev = to_wwan_dev(dev);
+
+	ida_free(&wwan_dev_ids, wwandev->id);
+	kfree(wwandev);
+}
+
+static const struct device_type wwan_dev_type = {
+	.name    = "wwan_dev",
+	.release = wwan_dev_release,
+};
+
+static int wwan_dev_parent_match(struct device *dev, const void *parent)
+{
+	return (dev->type == &wwan_dev_type && dev->parent == parent);
+}
+
+static struct wwan_device *wwan_dev_get_by_parent(struct device *parent)
+{
+	struct device *dev;
+
+	dev = class_find_device(wwan_class, NULL, parent, wwan_dev_parent_match);
+	if (!dev)
+		return ERR_PTR(-ENODEV);
+
+	return to_wwan_dev(dev);
+}
+
+/* This function allocates and registers a new WWAN device OR if a WWAN device
+ * already exist for the given parent, it gets a reference and return it.
+ * This function is not exported (for now), it is called indirectly via
+ * wwan_create_port().
+ */
+static struct wwan_device *wwan_create_dev(struct device *parent)
+{
+	struct wwan_device *wwandev;
+	int err, id;
+
+	/* The 'find-alloc-register' operation must be protected against
+	 * concurrent execution, a WWAN device is possibly shared between
+	 * multiple callers or concurrently unregistered from wwan_remove_dev().
+	 */
+	mutex_lock(&wwan_register_lock);
+
+	/* If wwandev already exist, return it */
+	wwandev = wwan_dev_get_by_parent(parent);
+	if (!IS_ERR(wwandev))
+		goto done_unlock;
+
+	id = ida_alloc(&wwan_dev_ids, GFP_KERNEL);
+	if (id < 0)
+		goto done_unlock;
+
+	wwandev = kzalloc(sizeof(*wwandev), GFP_KERNEL);
+	if (!wwandev) {
+		ida_free(&wwan_dev_ids, id);
+		goto done_unlock;
+	}
+
+	wwandev->dev.parent = parent;
+	wwandev->dev.class = wwan_class;
+	wwandev->dev.type = &wwan_dev_type;
+	wwandev->id = id;
+	dev_set_name(&wwandev->dev, "wwan%d", wwandev->id);
+
+	err = device_register(&wwandev->dev);
+	if (err) {
+		put_device(&wwandev->dev);
+		wwandev = NULL;
+	}
+
+done_unlock:
+	mutex_unlock(&wwan_register_lock);
+
+	return wwandev;
+}
+
+static int is_wwan_child(struct device *dev, void *data)
+{
+	return dev->class == wwan_class;
+}
+
+static void wwan_remove_dev(struct wwan_device *wwandev)
+{
+	int ret;
+
+	/* Prevent concurrent picking from wwan_create_dev */
+	mutex_lock(&wwan_register_lock);
+
+	/* WWAN device is created and registered (get+add) along with its first
+	 * child port, and subsequent port registrations only grab a reference
+	 * (get). The WWAN device must then be unregistered (del+put) along with
+	 * its latest port, and reference simply dropped (put) otherwise.
+	 */
+	ret = device_for_each_child(&wwandev->dev, NULL, is_wwan_child);
+	if (!ret)
+		device_unregister(&wwandev->dev);
+	else
+		put_device(&wwandev->dev);
+
+	mutex_unlock(&wwan_register_lock);
+}
+
+/* ------- WWAN port management ------- */
+
+static void wwan_port_release(struct device *dev)
+{
+	struct wwan_port *port = to_wwan_port(dev);
+
+	ida_free(&minors, MINOR(port->dev.devt));
+	kfree(to_wwan_port(dev));
+}
+
+static const struct device_type wwan_port_dev_type = {
+	.name = "wwan_port",
+	.release = wwan_port_release,
+};
+
+static int wwan_port_minor_match(struct device *dev, const void *minor)
+{
+	return (dev->type == &wwan_port_dev_type &&
+		MINOR(dev->devt) == *(unsigned int *)minor);
+}
+
+static struct wwan_port *wwan_port_get_by_minor(unsigned int minor)
+{
+	struct device *dev;
+
+	dev = class_find_device(wwan_class, NULL, &minor, wwan_port_minor_match);
+	if (!dev)
+		return ERR_PTR(-ENODEV);
+
+	return to_wwan_port(dev);
+}
+
+/* Keep aligned with wwan_port_type enum */
+static const char * const wwan_port_type_str[] = {
+	"AT",
+	"MBIM",
+	"QMI",
+	"QCDM",
+	"FIREHOSE"
+};
+
+struct wwan_port *wwan_create_port(struct device *parent,
+				   enum wwan_port_type type,
+				   const struct file_operations *fops,
+				   void *private_data)
+{
+	struct wwan_device *wwandev;
+	struct wwan_port *port;
+	int minor, err = -ENOMEM;
+
+	if (type >= WWAN_PORT_MAX || !fops)
+		return ERR_PTR(-EINVAL);
+
+	/* A port is always a child of a WWAN device, retrieve (allocate or
+	 * pick) the WWAN device based on the provided parent device.
+	 */
+	wwandev = wwan_create_dev(parent);
+	if (IS_ERR(wwandev))
+		return ERR_PTR(PTR_ERR(wwandev));
+
+	/* A port is exposed as character device, get a minor */
+	minor = ida_alloc_range(&minors, 0, WWAN_MAX_MINORS, GFP_KERNEL);
+	if (minor < 0)
+		goto error_wwandev_remove;
+
+	port = kzalloc(sizeof(*port), GFP_KERNEL);
+	if (!port) {
+		ida_free(&minors, minor);
+		goto error_wwandev_remove;
+	}
+
+	port->type = type;
+	port->fops = fops;
+	port->dev.parent = &wwandev->dev;
+	port->dev.class = wwan_class;
+	port->dev.type = &wwan_port_dev_type;
+	port->dev.devt = MKDEV(wwan_major, minor);
+	dev_set_drvdata(&port->dev, private_data);
+
+	/* create unique name based on wwan device id, port index and type */
+	dev_set_name(&port->dev, "wwan%up%u%s", wwandev->id,
+		     atomic_inc_return(&wwandev->port_id),
+		     wwan_port_type_str[port->type]);
+
+	err = device_register(&port->dev);
+	if (err)
+		goto error_put_device;
+
+	return port;
+
+error_put_device:
+	put_device(&port->dev);
+error_wwandev_remove:
+	wwan_remove_dev(wwandev);
+
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(wwan_create_port);
+
+void wwan_remove_port(struct wwan_port *port)
+{
+	struct wwan_device *wwandev = to_wwan_dev(port->dev.parent);
+
+	dev_set_drvdata(&port->dev, NULL);
+	device_unregister(&port->dev);
+
+	/* Release related wwan device */
+	wwan_remove_dev(wwandev);
+}
+EXPORT_SYMBOL_GPL(wwan_remove_port);
+
+static int wwan_port_open(struct inode *inode, struct file *file)
+{
+	const struct file_operations *new_fops;
+	struct wwan_port *port;
+	int err = 0;
+
+	port = wwan_port_get_by_minor(iminor(inode));
+	if (IS_ERR(port))
+		return PTR_ERR(port);
+
+	/* Place the port private data in the file's private_data so it can
+	 * be used by the file operations, including f_op->open below.
+	 */
+	file->private_data = dev_get_drvdata(&port->dev);
+	stream_open(inode, file);
+
+	/* For now, there is no wwan port ops API, so we simply let the wwan
+	 * port driver implements its own fops.
+	 */
+	new_fops = fops_get(port->fops);
+	replace_fops(file, new_fops);
+	if (file->f_op->open)
+		err = file->f_op->open(inode, file);
+
+	put_device(&port->dev); /* balance wwan_port_get_by_minor */
+
+	return err;
+}
+
+static const struct file_operations wwan_port_fops = {
+	/* these fops will be replaced by registered wwan_port fops */
+	.owner	= THIS_MODULE,
+	.open	= wwan_port_open,
+	.llseek = noop_llseek,
+};
+
+static int __init wwan_init(void)
+{
+	wwan_class = class_create(THIS_MODULE, "wwan");
+	if (IS_ERR(wwan_class))
+		return PTR_ERR(wwan_class);
+
+	/* chrdev used for wwan ports */
+	wwan_major = register_chrdev(0, "wwanport", &wwan_port_fops);
+	if (wwan_major < 0) {
+		class_destroy(wwan_class);
+		return wwan_major;
+	}
+
+	return 0;
+}
+
+static void __exit wwan_exit(void)
+{
+	unregister_chrdev(wwan_major, "wwanport");
+	class_destroy(wwan_class);
+}
+
+module_init(wwan_init);
+module_exit(wwan_exit);
+
+MODULE_AUTHOR("Loic Poulain <loic.poulain@linaro.org>");
+MODULE_DESCRIPTION("WWAN core");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
new file mode 100644
index 0000000..e8f2971
--- /dev/null
+++ b/include/linux/wwan.h
@@ -0,0 +1,73 @@
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
+ * enum wwan_port_type - WWAN port types
+ * @WWAN_PORT_AT: AT commands
+ * @WWAN_PORT_MBIM: Mobile Broadband Interface Model control
+ * @WWAN_PORT_QMI: Qcom modem/MSM interface for modem control
+ * @WWAN_PORT_QCDM: Qcom Modem diagnostic interface
+ * @WWAN_PORT_FIREHOSE: XML based command protocol
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
+ * @type: Port type
+ * @fops: Pointer to file operations
+ * @dev: Underlying device
+ */
+struct wwan_port {
+	enum wwan_port_type type;
+	const struct file_operations *fops;
+	struct device dev;
+};
+
+/**
+ * wwan_create_port - Add a new WWAN port
+ * @parent: Device to use as parent and shared by all WWAN ports
+ * @type: WWAN port type
+ * @fops: File operations
+ * @private_data: Pointer to caller private_data
+ *
+ * Allocate and register a new WWAN port. The port will be automatically exposed
+ * to user as a character device. The port will be automatically attached to the
+ * right WWAN device, based on the parent pointer. The parent pointer is the
+ * device shared by all components of a same WWAN modem (e.g. USB dev, PCI dev,
+ * MHI controller...).
+ *
+ * private_data will be placed in the file's private_data so it can be used by
+ * the port file operations.
+ *
+ * This function must be balanced with a call to wwan_destroy_port().
+ *
+ * Returns a valid pointer to wwan_port on success or PTR_ERR on failure
+ */
+struct wwan_port *wwan_create_port(struct device *parent,
+				   enum wwan_port_type type,
+				   const struct file_operations *fops,
+				   void *private_data);
+
+/**
+ * wwan_remove_port - Remove a WWAN port
+ * @port: WWAN port to remove
+ *
+ * Remove a previously created port.
+ */
+void wwan_remove_port(struct wwan_port *port);
+
+#endif /* __WWAN_H */
-- 
2.7.4

