Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06FD3A3235
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhFJRhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhFJRhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:37:25 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED9EC0617AD
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:35:12 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id o3so3212919wri.8
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tK7BBqG80DJ06ghXPAOY/BIw/HfI/PBfRT17vmAuWq0=;
        b=EEE6+duOQ5jiXuYJqQD09LfuA6L+C+iHjslwKmiueOhdrC5OO2AEATmUz6MPiyGOgg
         oPOH+M+UKIDqWAD7oafUjBGpzTTyMCmrLPJsn1txPqaX9G8pPpAbqlOIEY/H5bYA9TPB
         xTdNGcPsKJ4Y2fd+BXccJG/JM66nAqHZeDqKWAcrdy35U0FbthGCEDEpTrEWd3tY9Oc3
         uoWHNXaQxqAB2+zE1OBHcDE3Oc0XPn/IZA2M8FotjQmx+cx+RfYzvFJv/8JlJBrr7iK+
         mZKB3ShsUviouPPwxII4+2O7WJKdwuDR/PgOVMgb0DhJeG5+MJ/egrfdR1EItX3sr1DI
         rK8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tK7BBqG80DJ06ghXPAOY/BIw/HfI/PBfRT17vmAuWq0=;
        b=YEva5JiuT4YmneKrkcLC6DsG9qLSadiTY4Wn1VA/Le8OkxDseaxCsEv4kcWZ8Bwr6e
         ILOVQkIqUOAsZfgB7s39uL65ecfCy8/E3qO6uLOnVecz2GOJQcOIYaqrKDIry2riUvhc
         ZRzGhA1AqQl1ZD1sSqlaqJ2hVb+rJJSk/16lPzpFZTSKdMtCBccGaeIu42QwYFDscl1m
         MYdKlT/CiVfm10p7i772WBtZw4YztYVfbwrC5hLtJbq7BtV5hP4uGFjmAueUDX0Q+II+
         uBalISnWGt8aMctaDCLnKAlnKVhpZTdq7TnH5rUKMMAO/Jjym8fGJEDBdJTC+vuNDMpw
         zXHg==
X-Gm-Message-State: AOAM53351fAOKUfK6eO8XISU552DJJQGK9HYeSqC4hOvX/qtrVPOyNYY
        FDhiKwbEjXJ5XARWUw/w7eQiodEN8+NE+By0
X-Google-Smtp-Source: ABdhPJy1b04TN5OYymf0Zu1eQCwCyWsa3VSFhvLDJj6nFlsmQMDMKgzNbAT0rfYc0vpFo+FtjhFqBQ==
X-Received: by 2002:a5d:4dd0:: with SMTP id f16mr6774605wru.192.1623346511167;
        Thu, 10 Jun 2021 10:35:11 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:85ed:406e:1bc4:a268])
        by smtp.gmail.com with ESMTPSA id x3sm9921356wmj.30.2021.06.10.10.35.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jun 2021 10:35:10 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, johannes.berg@intel.com, leon@kernel.org,
        m.chetan.kumar@intel.com, parav@nvidia.com,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v2 3/3] wwan: add interface creation support
Date:   Thu, 10 Jun 2021 19:44:49 +0200
Message-Id: <1623347089-28788-3-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623347089-28788-1-git-send-email-loic.poulain@linaro.org>
References: <1623347089-28788-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add support to create (and destroy) interfaces via a new
rtnetlink kind "wwan". The responsible driver has to use
the new wwan_register_ops() to make this possible.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: no change

 drivers/net/wwan/wwan_core.c | 231 +++++++++++++++++++++++++++++++++++++++++--
 include/linux/wwan.h         |  38 +++++++
 include/uapi/linux/wwan.h    |  16 +++
 3 files changed, 278 insertions(+), 7 deletions(-)
 create mode 100644 include/uapi/linux/wwan.h

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 45a41ae..125426d 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -14,6 +14,8 @@
 #include <linux/types.h>
 #include <linux/termios.h>
 #include <linux/wwan.h>
+#include <net/rtnetlink.h>
+#include <uapi/linux/wwan.h>
 
 /* Maximum number of minors in use */
 #define WWAN_MAX_MINORS		(1 << MINORBITS)
@@ -35,10 +37,16 @@ static int wwan_major;
  *
  * @id: WWAN device unique ID.
  * @dev: Underlying device.
+ * @port_id: Current available port ID to pick.
+ * @ops: wwan device ops
+ * @ops_ctxt: context to pass to ops
  */
 struct wwan_device {
 	unsigned int id;
 	struct device dev;
+	atomic_t port_id;
+	const struct wwan_ops *ops;
+	void *ops_ctxt;
 };
 
 /**
@@ -102,7 +110,8 @@ static const struct device_type wwan_dev_type = {
 
 static int wwan_dev_parent_match(struct device *dev, const void *parent)
 {
-	return (dev->type == &wwan_dev_type && dev->parent == parent);
+	return (dev->type == &wwan_dev_type &&
+		(dev->parent == parent || dev == parent));
 }
 
 static struct wwan_device *wwan_dev_get_by_parent(struct device *parent)
@@ -116,6 +125,23 @@ static struct wwan_device *wwan_dev_get_by_parent(struct device *parent)
 	return to_wwan_dev(dev);
 }
 
+static int wwan_dev_name_match(struct device *dev, const void *name)
+{
+	return dev->type == &wwan_dev_type &&
+	       strcmp(dev_name(dev), name) == 0;
+}
+
+static struct wwan_device *wwan_dev_get_by_name(const char *name)
+{
+	struct device *dev;
+
+	dev = class_find_device(wwan_class, NULL, name, wwan_dev_name_match);
+	if (!dev)
+		return ERR_PTR(-ENODEV);
+
+	return to_wwan_dev(dev);
+}
+
 /* This function allocates and registers a new WWAN device OR if a WWAN device
  * already exist for the given parent, it gets a reference and return it.
  * This function is not exported (for now), it is called indirectly via
@@ -180,9 +206,14 @@ static void wwan_remove_dev(struct wwan_device *wwandev)
 	/* WWAN device is created and registered (get+add) along with its first
 	 * child port, and subsequent port registrations only grab a reference
 	 * (get). The WWAN device must then be unregistered (del+put) along with
-	 * its latest port, and reference simply dropped (put) otherwise.
+	 * its last port, and reference simply dropped (put) otherwise. In the
+	 * same fashion, we must not unregister it when the ops are still there.
 	 */
-	ret = device_for_each_child(&wwandev->dev, NULL, is_wwan_child);
+	if (wwandev->ops)
+		ret = 1;
+	else
+		ret = device_for_each_child(&wwandev->dev, NULL, is_wwan_child);
+
 	if (!ret)
 		device_unregister(&wwandev->dev);
 	else
@@ -750,26 +781,212 @@ static const struct file_operations wwan_port_fops = {
 	.llseek = noop_llseek,
 };
 
+int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
+		      void *ctxt)
+{
+	struct wwan_device *wwandev;
+
+	if (WARN_ON(!parent || !ops))
+		return -EINVAL;
+
+	wwandev = wwan_create_dev(parent);
+	if (!wwandev)
+		return -ENOMEM;
+
+	if (WARN_ON(wwandev->ops)) {
+		wwan_remove_dev(wwandev);
+		return -EBUSY;
+	}
+
+	if (!try_module_get(ops->owner)) {
+		wwan_remove_dev(wwandev);
+		return -ENODEV;
+	}
+
+	wwandev->ops = ops;
+	wwandev->ops_ctxt = ctxt;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(wwan_register_ops);
+
+void wwan_unregister_ops(struct device *parent)
+{
+	struct wwan_device *wwandev = wwan_dev_get_by_parent(parent);
+	bool has_ops;
+
+	if (WARN_ON(IS_ERR(wwandev)))
+		return;
+
+	has_ops = wwandev->ops;
+
+	/* put the reference obtained by wwan_dev_get_by_parent(),
+	 * we should still have one (that the owner is giving back
+	 * now) due to the ops being assigned, check that below
+	 * and return if not.
+	 */
+	put_device(&wwandev->dev);
+
+	if (WARN_ON(!has_ops))
+		return;
+
+	module_put(wwandev->ops->owner);
+
+	wwandev->ops = NULL;
+	wwandev->ops_ctxt = NULL;
+	wwan_remove_dev(wwandev);
+}
+EXPORT_SYMBOL_GPL(wwan_unregister_ops);
+
+static int wwan_rtnl_validate(struct nlattr *tb[], struct nlattr *data[],
+			      struct netlink_ext_ack *extack)
+{
+	if (!data)
+		return -EINVAL;
+
+	if (!tb[IFLA_PARENT_DEV_NAME])
+		return -EINVAL;
+
+	if (!data[IFLA_WWAN_LINK_ID])
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct device_type wwan_type = { .name = "wwan" };
+
+static struct net_device *wwan_rtnl_alloc(struct nlattr *tb[],
+					  const char *ifname,
+					  unsigned char name_assign_type,
+					  unsigned int num_tx_queues,
+					  unsigned int num_rx_queues)
+{
+	const char *devname = nla_data(tb[IFLA_PARENT_DEV_NAME]);
+	struct wwan_device *wwandev = wwan_dev_get_by_name(devname);
+	struct net_device *dev;
+
+	if (IS_ERR(wwandev))
+		return ERR_CAST(wwandev);
+
+	/* only supported if ops were registered (not just ports) */
+	if (!wwandev->ops) {
+		dev = ERR_PTR(-EOPNOTSUPP);
+		goto out;
+	}
+
+	dev = alloc_netdev_mqs(wwandev->ops->priv_size, ifname, name_assign_type,
+			       wwandev->ops->setup, num_tx_queues, num_rx_queues);
+
+	if (dev) {
+		SET_NETDEV_DEV(dev, &wwandev->dev);
+		SET_NETDEV_DEVTYPE(dev, &wwan_type);
+	}
+
+out:
+	/* release the reference */
+	put_device(&wwandev->dev);
+	return dev;
+}
+
+static int wwan_rtnl_newlink(struct net *src_net, struct net_device *dev,
+			     struct nlattr *tb[], struct nlattr *data[],
+			     struct netlink_ext_ack *extack)
+{
+	struct wwan_device *wwandev = wwan_dev_get_by_parent(dev->dev.parent);
+	u32 link_id = nla_get_u32(data[IFLA_WWAN_LINK_ID]);
+	int ret;
+
+	if (IS_ERR(wwandev))
+		return PTR_ERR(wwandev);
+
+	/* shouldn't have a netdev (left) with us as parent so WARN */
+	if (WARN_ON(!wwandev->ops)) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (wwandev->ops->newlink)
+		ret = wwandev->ops->newlink(wwandev->ops_ctxt, dev,
+					    link_id, extack);
+	else
+		ret = register_netdevice(dev);
+
+out:
+	/* release the reference */
+	put_device(&wwandev->dev);
+	return ret;
+}
+
+static void wwan_rtnl_dellink(struct net_device *dev, struct list_head *head)
+{
+	struct wwan_device *wwandev = wwan_dev_get_by_parent(dev->dev.parent);
+
+	if (IS_ERR(wwandev))
+		return;
+
+	/* shouldn't have a netdev (left) with us as parent so WARN */
+	if (WARN_ON(!wwandev->ops))
+		goto out;
+
+	if (wwandev->ops->dellink)
+		wwandev->ops->dellink(wwandev->ops_ctxt, dev, head);
+	else
+		unregister_netdevice(dev);
+
+out:
+	/* release the reference */
+	put_device(&wwandev->dev);
+}
+
+static const struct nla_policy wwan_rtnl_policy[IFLA_WWAN_MAX + 1] = {
+	[IFLA_WWAN_LINK_ID] = { .type = NLA_U32 },
+};
+
+static struct rtnl_link_ops wwan_rtnl_link_ops __read_mostly = {
+	.kind = "wwan",
+	.maxtype = __IFLA_WWAN_MAX,
+	.alloc = wwan_rtnl_alloc,
+	.validate = wwan_rtnl_validate,
+	.newlink = wwan_rtnl_newlink,
+	.dellink = wwan_rtnl_dellink,
+	.policy = wwan_rtnl_policy,
+};
+
 static int __init wwan_init(void)
 {
+	int err;
+
+	err = rtnl_link_register(&wwan_rtnl_link_ops);
+	if (err)
+		return err;
+
 	wwan_class = class_create(THIS_MODULE, "wwan");
-	if (IS_ERR(wwan_class))
-		return PTR_ERR(wwan_class);
+	if (IS_ERR(wwan_class)) {
+		err = PTR_ERR(wwan_class);
+		goto unregister;
+	}
 
 	/* chrdev used for wwan ports */
 	wwan_major = __register_chrdev(0, 0, WWAN_MAX_MINORS, "wwan_port",
 				       &wwan_port_fops);
 	if (wwan_major < 0) {
-		class_destroy(wwan_class);
-		return wwan_major;
+		err = wwan_major;
+		goto destroy;
 	}
 
 	return 0;
+
+destroy:
+	class_destroy(wwan_class);
+unregister:
+	rtnl_link_unregister(&wwan_rtnl_link_ops);
+	return err;
 }
 
 static void __exit wwan_exit(void)
 {
 	__unregister_chrdev(wwan_major, 0, WWAN_MAX_MINORS, "wwan_port");
+	rtnl_link_unregister(&wwan_rtnl_link_ops);
 	class_destroy(wwan_class);
 }
 
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index fa33cc1..7071f95 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -7,6 +7,7 @@
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
+#include <linux/netlink.h>
 
 /**
  * enum wwan_port_type - WWAN port types
@@ -116,4 +117,41 @@ void wwan_port_txon(struct wwan_port *port);
  */
 void *wwan_port_get_drvdata(struct wwan_port *port);
 
+/**
+ * struct wwan_ops - WWAN device ops
+ * @owner: module owner of the WWAN ops
+ * @priv_size: size of private netdev data area
+ * @setup: set up a new netdev
+ * @newlink: register the new netdev
+ * @dellink: remove the given netdev
+ */
+struct wwan_ops {
+	struct module *owner;
+	unsigned int priv_size;
+	void (*setup)(struct net_device *dev);
+	int (*newlink)(void *ctxt, struct net_device *dev,
+		       u32 if_id, struct netlink_ext_ack *extack);
+	void (*dellink)(void *ctxt, struct net_device *dev,
+			struct list_head *head);
+};
+
+/**
+ * wwan_register_ops - register WWAN device ops
+ * @parent: Device to use as parent and shared by all WWAN ports and
+ *	created netdevs
+ * @ops: operations to register
+ * @ctxt: context to pass to operations
+ *
+ * Returns: 0 on success, a negative error code on failure
+ */
+int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
+		      void *ctxt);
+
+/**
+ * wwan_unregister_ops - remove WWAN device ops
+ * @parent: Device to use as parent and shared by all WWAN ports and
+ *	created netdevs
+ */
+void wwan_unregister_ops(struct device *parent);
+
 #endif /* __WWAN_H */
diff --git a/include/uapi/linux/wwan.h b/include/uapi/linux/wwan.h
new file mode 100644
index 0000000..32a2720
--- /dev/null
+++ b/include/uapi/linux/wwan.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2021 Intel Corporation.
+ */
+#ifndef _UAPI_WWAN_H_
+#define _UAPI_WWAN_H_
+
+enum {
+	IFLA_WWAN_UNSPEC,
+	IFLA_WWAN_LINK_ID, /* u32 */
+
+	__IFLA_WWAN_MAX
+};
+#define IFLA_WWAN_MAX (__IFLA_WWAN_MAX - 1)
+
+#endif /* _UAPI_WWAN_H_ */
-- 
2.7.4

