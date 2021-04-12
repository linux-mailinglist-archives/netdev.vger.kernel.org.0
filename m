Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BFA35D0E1
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 21:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240294AbhDLTOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 15:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236840AbhDLTOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 15:14:34 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D542CC061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 12:14:15 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id k128so7440291wmk.4
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 12:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=mAIkcfV3e5HsauwY/oZMh7drrnzf3E6TeHuPArlJCX4=;
        b=JczRptRfTSFL+xsGBnl8maPJdjjXe6wgu894p7b5yi1ScXI+LIBM4/387pSPl4/H32
         YsvnS+5x2ngSq769L+9h0FxoKTE7kaWApc1j65GCls6jHgxLy1b69Fv1cvo3GrIq1ML2
         I6nUAYJky09RVCqVGoIwTjL4QP8agbf974sUayPQhTXb76rurZJLNtP7YlaHadwOA9rh
         WrcopAaC5gPfBcOxZDbzw5gXWRIxsUb0/IV3UXQh5x3WCB3fM2DFyqAcThwehcWZHCHT
         H61zjwidF9MZMdcngm1YtPIJ/ntKy6Fpl2XvwY2vvWbJdfIlE01SwEQGEYjo/ZNjCuQV
         ZliA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mAIkcfV3e5HsauwY/oZMh7drrnzf3E6TeHuPArlJCX4=;
        b=kw/bRWtvFAeG85GMjNjS24zC6yfwSmX1g6LxODE1Q75bik0tEMQxc98jGMV3weIrva
         SEEHgu3pzasPQIL+eJV5bLUs3aDPAIkTWRAgaKESkY8UCWIaVnZFtZClfNxPNiohVmEK
         DqBuKekCvolia7GpJFuppraGwPAatiClqcDVlffIA5znpciJtRcHK0rPsRcniZrF6rAA
         v/DBeLsohQk0TnypmpQ7QHVpV5ff1h6uS4XELpQcZ3PPnugSHjc+qop7xnI8LG/kF00L
         yzekdwCk6x3wnQCjh7ydUka4GWqlJssCECGTnuwyPGKi6L8SoqFUXUPpdSbnxYsyKIus
         cwpA==
X-Gm-Message-State: AOAM5319BIoy+hG9UfL3oGWXcYePagRLKGWFZEyGOZzX+SCg18tdIbzA
        NnCae3/6+1p+8KGq62F6u5A04A==
X-Google-Smtp-Source: ABdhPJz8Ct6HO8sSbBEPMX1dm8grsV4POXG9idyUV3yvjhi3Qk9ReK/LVaYh8q0TTeehJ+MnSAv2qQ==
X-Received: by 2002:a1c:80cd:: with SMTP id b196mr592676wmd.30.1618254854368;
        Mon, 12 Apr 2021 12:14:14 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:73ec:b608:68c5:9f78])
        by smtp.gmail.com with ESMTPSA id s20sm245402wmp.48.2021.04.12.12.14.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Apr 2021 12:14:13 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     gregkh@linuxfoundation.org, kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        aleksander@aleksander.es, dcbw@redhat.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v10 1/2] net: Add a WWAN subsystem
Date:   Mon, 12 Apr 2021 21:23:06 +0200
Message-Id: <1618255387-13532-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change introduces initial support for a WWAN framework. Given the
complexity and heterogeneity of existing WWAN hardwares and interfaces,
there is no strict definition of what a WWAN device is and how it should
be represented. It's often a collection of multiple devices that perform
the global WWAN feature (netdev, tty, chardev, etc).

One usual way to expose modem controls and configuration is via high
level protocols such as the well known AT command protocol, MBIM or
QMI. The USB modems started to expose them as character devices, and
user daemons such as ModemManager learnt to use them.

This initial version adds the concept of WWAN port, which is a logical
pipe to a modem control protocol. The protocols are rawly exposed to
user via character device, allowing straigthforward support in existing
tools (ModemManager, ofono...). The WWAN core takes care of the generic
part, including character device management, and relies on port driver
operations to receive/submit protocol data.

Since the different devices exposing protocols for a same WWAN hardware
do not necessarily know about each others (e.g. two different USB
interfaces, PCI/MHI channel devices...) and can be created/removed in
different orders, the WWAN core ensures that all WAN ports contributing
to the 'whole' WWAN feature are grouped under the same virtual WWAN
device, relying on the provided parent device (e.g. mhi controller,
USB device). It's a 'trick' I copied from Johannes's earlier WWAN
subsystem proposal.

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
 v6: - Move to unified wwan_core.c file
     - Make wwan_port a device
     - Get rid of useless various dev lists (use wwan class)
     - Get rid of useless wwan dev usage counter and mutex
     - do not expose wwan_create_device, it's indirectly called via create_port
     - Increase minor count to the whole available minor range
     - private_data as wwan_create_port parameter
 v7: Fix change log (mixed up 1/2 and 2/2)
 v8: - Move fops implementation in wwan_core (open/read/write/poll/release)
     - Create wwan_port_ops
     - Add wwan_port_rx, wwan_port_txoff and wwan_port_txon functions
     - Fix code comments
     - skb based TX/RX
 v9: - Move wwan_port definition to wwan_core.c (private)
     - Fix checkpatch + cocci(ERR_CAST) issues
     - Reword commit message
 v10: no change

 drivers/net/Kconfig          |   2 +
 drivers/net/Makefile         |   1 +
 drivers/net/wwan/Kconfig     |  23 ++
 drivers/net/wwan/Makefile    |   7 +
 drivers/net/wwan/wwan_core.c | 552 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/wwan.h         | 111 +++++++++
 6 files changed, 696 insertions(+)
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
index 0000000..fc3f3a1
--- /dev/null
+++ b/drivers/net/wwan/Kconfig
@@ -0,0 +1,23 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Wireless WAN device configuration
+#
+
+menuconfig WWAN
+	bool "Wireless WAN"
+	help
+	  This section contains Wireless WAN configuration for WWAN framework
+	  and drivers.
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
index 0000000..b618b79
--- /dev/null
+++ b/drivers/net/wwan/wwan_core.c
@@ -0,0 +1,552 @@
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
+#include <linux/poll.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/wwan.h>
+
+#define WWAN_MAX_MINORS 256 /* 256 minors allowed with register_chrdev() */
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
+/* WWAN port flags */
+#define WWAN_PORT_TX_OFF	BIT(0)
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
+/**
+ * struct wwan_port - The structure that defines a WWAN port
+ * @type: Port type
+ * @start_count: Port start counter
+ * @flags: Store port state and capabilities
+ * @ops: Pointer to WWAN port operations
+ * @ops_lock: Protect port ops
+ * @dev: Underlying device
+ * @rxq: Buffer inbound queue
+ * @waitqueue: The waitqueue for port fops (read/write/poll)
+ */
+struct wwan_port {
+	enum wwan_port_type type;
+	unsigned int start_count;
+	unsigned long flags;
+	const struct wwan_port_ops *ops;
+	struct mutex ops_lock; /* Serialize ops + protect against removal */
+	struct device dev;
+	struct sk_buff_head rxq;
+	wait_queue_head_t waitqueue;
+};
+
+static void wwan_dev_destroy(struct device *dev)
+{
+	struct wwan_device *wwandev = to_wwan_dev(dev);
+
+	ida_free(&wwan_dev_ids, wwandev->id);
+	kfree(wwandev);
+}
+
+static const struct device_type wwan_dev_type = {
+	.name    = "wwan_dev",
+	.release = wwan_dev_destroy,
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
+	/* If wwandev already exists, return it */
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
+static void wwan_port_destroy(struct device *dev)
+{
+	struct wwan_port *port = to_wwan_port(dev);
+
+	ida_free(&minors, MINOR(port->dev.devt));
+	skb_queue_purge(&port->rxq);
+	mutex_destroy(&port->ops_lock);
+	kfree(port);
+}
+
+static const struct device_type wwan_port_dev_type = {
+	.name = "wwan_port",
+	.release = wwan_port_destroy,
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
+				   const struct wwan_port_ops *ops,
+				   void *drvdata)
+{
+	struct wwan_device *wwandev;
+	struct wwan_port *port;
+	int minor, err = -ENOMEM;
+
+	if (type >= WWAN_PORT_MAX || !ops)
+		return ERR_PTR(-EINVAL);
+
+	/* A port is always a child of a WWAN device, retrieve (allocate or
+	 * pick) the WWAN device based on the provided parent device.
+	 */
+	wwandev = wwan_create_dev(parent);
+	if (IS_ERR(wwandev))
+		return ERR_CAST(wwandev);
+
+	/* A port is exposed as character device, get a minor */
+	minor = ida_alloc_range(&minors, 0, WWAN_MAX_MINORS - 1, GFP_KERNEL);
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
+	port->ops = ops;
+	mutex_init(&port->ops_lock);
+	skb_queue_head_init(&port->rxq);
+	init_waitqueue_head(&port->waitqueue);
+
+	port->dev.parent = &wwandev->dev;
+	port->dev.class = wwan_class;
+	port->dev.type = &wwan_port_dev_type;
+	port->dev.devt = MKDEV(wwan_major, minor);
+	dev_set_drvdata(&port->dev, drvdata);
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
+	mutex_lock(&port->ops_lock);
+	if (port->start_count)
+		port->ops->stop(port);
+	port->ops = NULL; /* Prevent any new port operations (e.g. from fops) */
+	mutex_unlock(&port->ops_lock);
+
+	wake_up_interruptible(&port->waitqueue);
+
+	skb_queue_purge(&port->rxq);
+	dev_set_drvdata(&port->dev, NULL);
+	device_unregister(&port->dev);
+
+	/* Release related wwan device */
+	wwan_remove_dev(wwandev);
+}
+EXPORT_SYMBOL_GPL(wwan_remove_port);
+
+void wwan_port_rx(struct wwan_port *port, struct sk_buff *skb)
+{
+	skb_queue_tail(&port->rxq, skb);
+	wake_up_interruptible(&port->waitqueue);
+}
+EXPORT_SYMBOL_GPL(wwan_port_rx);
+
+void wwan_port_txon(struct wwan_port *port)
+{
+	clear_bit(WWAN_PORT_TX_OFF, &port->flags);
+	wake_up_interruptible(&port->waitqueue);
+}
+EXPORT_SYMBOL_GPL(wwan_port_txon);
+
+void wwan_port_txoff(struct wwan_port *port)
+{
+	set_bit(WWAN_PORT_TX_OFF, &port->flags);
+}
+EXPORT_SYMBOL_GPL(wwan_port_txoff);
+
+void *wwan_port_get_drvdata(struct wwan_port *port)
+{
+	return dev_get_drvdata(&port->dev);
+}
+EXPORT_SYMBOL_GPL(wwan_port_get_drvdata);
+
+static int wwan_port_op_start(struct wwan_port *port)
+{
+	int ret = 0;
+
+	mutex_lock(&port->ops_lock);
+	if (!port->ops) { /* Port got unplugged */
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+
+	/* If port is already started, don't start again */
+	if (!port->start_count)
+		ret = port->ops->start(port);
+
+	if (!ret)
+		port->start_count++;
+
+out_unlock:
+	mutex_unlock(&port->ops_lock);
+
+	return ret;
+}
+
+static void wwan_port_op_stop(struct wwan_port *port)
+{
+	mutex_lock(&port->ops_lock);
+	port->start_count--;
+	if (port->ops && !port->start_count)
+		port->ops->stop(port);
+	mutex_unlock(&port->ops_lock);
+}
+
+static int wwan_port_op_tx(struct wwan_port *port, struct sk_buff *skb)
+{
+	int ret;
+
+	mutex_lock(&port->ops_lock);
+	if (!port->ops) { /* Port got unplugged */
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+
+	ret = port->ops->tx(port, skb);
+
+out_unlock:
+	mutex_unlock(&port->ops_lock);
+
+	return ret;
+}
+
+static bool is_read_blocked(struct wwan_port *port)
+{
+	return skb_queue_empty(&port->rxq) && port->ops;
+}
+
+static bool is_write_blocked(struct wwan_port *port)
+{
+	return test_bit(WWAN_PORT_TX_OFF, &port->flags) && port->ops;
+}
+
+static int wwan_wait_rx(struct wwan_port *port, bool nonblock)
+{
+	if (!is_read_blocked(port))
+		return 0;
+
+	if (nonblock)
+		return -EAGAIN;
+
+	if (wait_event_interruptible(port->waitqueue, !is_read_blocked(port)))
+		return -ERESTARTSYS;
+
+	return 0;
+}
+
+static int wwan_wait_tx(struct wwan_port *port, bool nonblock)
+{
+	if (!is_write_blocked(port))
+		return 0;
+
+	if (nonblock)
+		return -EAGAIN;
+
+	if (wait_event_interruptible(port->waitqueue, !is_write_blocked(port)))
+		return -ERESTARTSYS;
+
+	return 0;
+}
+
+static int wwan_port_fops_open(struct inode *inode, struct file *file)
+{
+	struct wwan_port *port;
+	int err = 0;
+
+	port = wwan_port_get_by_minor(iminor(inode));
+	if (IS_ERR(port))
+		return PTR_ERR(port);
+
+	file->private_data = port;
+	stream_open(inode, file);
+
+	err = wwan_port_op_start(port);
+	if (err)
+		put_device(&port->dev);
+
+	return err;
+}
+
+static int wwan_port_fops_release(struct inode *inode, struct file *filp)
+{
+	struct wwan_port *port = filp->private_data;
+
+	wwan_port_op_stop(port);
+	put_device(&port->dev);
+
+	return 0;
+}
+
+static ssize_t wwan_port_fops_read(struct file *filp, char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	struct wwan_port *port = filp->private_data;
+	struct sk_buff *skb;
+	size_t copied;
+	int ret;
+
+	ret = wwan_wait_rx(port, !!(filp->f_flags & O_NONBLOCK));
+	if (ret)
+		return ret;
+
+	skb = skb_dequeue(&port->rxq);
+	if (!skb)
+		return -EIO;
+
+	copied = min_t(size_t, count, skb->len);
+	if (copy_to_user(buf, skb->data, copied)) {
+		kfree_skb(skb);
+		return -EFAULT;
+	}
+	skb_pull(skb, copied);
+
+	/* skb is not fully consumed, keep it in the queue */
+	if (skb->len)
+		skb_queue_head(&port->rxq, skb);
+	else
+		consume_skb(skb);
+
+	return copied;
+}
+
+static ssize_t wwan_port_fops_write(struct file *filp, const char __user *buf,
+				    size_t count, loff_t *offp)
+{
+	struct wwan_port *port = filp->private_data;
+	struct sk_buff *skb;
+	int ret;
+
+	ret = wwan_wait_tx(port, !!(filp->f_flags & O_NONBLOCK));
+	if (ret)
+		return ret;
+
+	skb = alloc_skb(count, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	if (copy_from_user(skb_put(skb, count), buf, count)) {
+		kfree_skb(skb);
+		return -EFAULT;
+	}
+
+	ret = wwan_port_op_tx(port, skb);
+	if (ret) {
+		kfree_skb(skb);
+		return ret;
+	}
+
+	return count;
+}
+
+static __poll_t wwan_port_fops_poll(struct file *filp, poll_table *wait)
+{
+	struct wwan_port *port = filp->private_data;
+	__poll_t mask = 0;
+
+	poll_wait(filp, &port->waitqueue, wait);
+
+	if (!is_write_blocked(port))
+		mask |= EPOLLOUT | EPOLLWRNORM;
+	if (!is_read_blocked(port))
+		mask |= EPOLLIN | EPOLLRDNORM;
+
+	return mask;
+}
+
+static const struct file_operations wwan_port_fops = {
+	.owner = THIS_MODULE,
+	.open = wwan_port_fops_open,
+	.release = wwan_port_fops_release,
+	.read = wwan_port_fops_read,
+	.write = wwan_port_fops_write,
+	.poll = wwan_port_fops_poll,
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
+	wwan_major = register_chrdev(0, "wwan_port", &wwan_port_fops);
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
+	unregister_chrdev(wwan_major, "wwan_port");
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
index 0000000..f3f3f94
--- /dev/null
+++ b/include/linux/wwan.h
@@ -0,0 +1,111 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2021, Linaro Ltd <loic.poulain@linaro.org> */
+
+#ifndef __WWAN_H
+#define __WWAN_H
+
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/skbuff.h>
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
+struct wwan_port;
+
+/** struct wwan_port_ops - The WWAN port operations
+ * @start: The routine for starting the WWAN port device.
+ * @stop: The routine for stopping the WWAN port device.
+ * @tx: The routine that sends WWAN port protocol data to the device.
+ *
+ * The wwan_port_ops structure contains a list of low-level operations
+ * that control a WWAN port device. All functions are mandatory.
+ */
+struct wwan_port_ops {
+	int (*start)(struct wwan_port *port);
+	void (*stop)(struct wwan_port *port);
+	int (*tx)(struct wwan_port *port, struct sk_buff *skb);
+};
+
+/**
+ * wwan_create_port - Add a new WWAN port
+ * @parent: Device to use as parent and shared by all WWAN ports
+ * @type: WWAN port type
+ * @ops: WWAN port operations
+ * @drvdata: Pointer to caller driver data
+ *
+ * Allocate and register a new WWAN port. The port will be automatically exposed
+ * to user as a character device and attached to the right virtual WWAN device,
+ * based on the parent pointer. The parent pointer is the device shared by all
+ * components of a same WWAN modem (e.g. USB dev, PCI dev, MHI controller...).
+ *
+ * drvdata will be placed in the WWAN port device driver data and can be
+ * retrieved with wwan_port_get_drvdata().
+ *
+ * This function must be balanced with a call to wwan_remove_port().
+ *
+ * Returns a valid pointer to wwan_port on success or PTR_ERR on failure
+ */
+struct wwan_port *wwan_create_port(struct device *parent,
+				   enum wwan_port_type type,
+				   const struct wwan_port_ops *ops,
+				   void *drvdata);
+
+/**
+ * wwan_remove_port - Remove a WWAN port
+ * @port: WWAN port to remove
+ *
+ * Remove a previously created port.
+ */
+void wwan_remove_port(struct wwan_port *port);
+
+/**
+ * wwan_port_rx - Receive data from the WWAN port
+ * @port: WWAN port for which data is received
+ * @skb: Pointer to the rx buffer
+ *
+ * A port driver calls this function upon data reception (MBIM, AT...).
+ */
+void wwan_port_rx(struct wwan_port *port, struct sk_buff *skb);
+
+/**
+ * wwan_port_txoff - Stop TX on WWAN port
+ * @port: WWAN port for which TX must be stopped
+ *
+ * Used for TX flow control, a port driver calls this function to indicate TX
+ * is temporary unavailable (e.g. due to ring buffer fullness).
+ */
+void wwan_port_txoff(struct wwan_port *port);
+
+
+/**
+ * wwan_port_txon - Restart TX on WWAN port
+ * @port: WWAN port for which TX must be restarted
+ *
+ * Used for TX flow control, a port driver calls this function to indicate TX
+ * is available again.
+ */
+void wwan_port_txon(struct wwan_port *port);
+
+/**
+ * wwan_port_get_drvdata - Retrieve driver data from a WWAN port
+ * @port: Related WWAN port
+ */
+void *wwan_port_get_drvdata(struct wwan_port *port);
+
+#endif /* __WWAN_H */
-- 
2.7.4

