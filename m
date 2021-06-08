Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DC239ED45
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 06:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhFHEFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 00:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhFHEE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 00:04:58 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DA6C061787;
        Mon,  7 Jun 2021 21:02:52 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id a1so20133781lfr.12;
        Mon, 07 Jun 2021 21:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OHFz2XiGKzjMgGqDHw8Ln6pO4vzSXzZficuVDOKNoOo=;
        b=f26c1mSujkUX/ImJQ8SNUPBjZ5RnTP34UeX+xJK66/pAGejZI1PoCE/118wNiB7RFE
         Wd/ASO216UgvyczSNRZ+knpFOAXErUGW5UunOQla+i6ct2bOB2mF31u64LAeIibdQSOX
         C1ygTZl3bQSEDh7DZQRzTm5a0BCOTYhZHdL6YbvC0JKBaq951YfcekTWe8d8SqGUSymb
         XSia+eC+FinqIGjxMV6fJlV2R6OnNc4+9G+IrsJgFAa+CK4yWA/VUYO9ciqhk21CS2YA
         N0BJi7RNKKKGwfpgWZPp1Tpq6ijddtLnkDEPKB5FjtoKZOBwsXtWer//aN3ctX+H5pw/
         Jdxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OHFz2XiGKzjMgGqDHw8Ln6pO4vzSXzZficuVDOKNoOo=;
        b=d3VFQirgCiw3sahAkArvouIcX3n3OJOGghhFv6diJs77Cd3Pa4awAsZRoYjX4Hon8a
         cvLZ6XzgzX1UdMqHzAk67AXcQ/z8XoGFMPjHKOkISu7V6xBcih9asq5fLww8qyUS8xEM
         4lUrz995Gd15iHgH1ZGUNp0mOLDU7u1zbOMyWytrW6vFOKwcsg5QXTI3kZatS7dQaFTp
         Sq5c/YRS9TyglwomGgZDc35OB37iqLl4siOsPB5ukxVnRLhfcqEvVzu8T7moESMpbeBn
         kIody0XbEItMKuwnj53TY1mf8FhSwhtdAhfgGwYSfiRz4joK4/p055q1hhYwFK6d7bwc
         JVXA==
X-Gm-Message-State: AOAM533fdM77YIj2GgAcDG/VpU//tO+SkH8/1AAVo1Ytgdu7gdKTFXEn
        aK3qYwvt0U8HTbV6z+TLAezqQLgj3uc=
X-Google-Smtp-Source: ABdhPJwQJ8edDU0q6xED+wYi1hRWxoziQkwDjPeRu6yHOo+Lc/PEErEU3MdhJoHzJxqqd2hjNtfjOQ==
X-Received: by 2002:a05:6512:32a5:: with SMTP id q5mr13439043lfe.171.1623124971147;
        Mon, 07 Jun 2021 21:02:51 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id l23sm1729096lfj.26.2021.06.07.21.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 21:02:50 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 02/10] wwan_hwsim: add debugfs management interface
Date:   Tue,  8 Jun 2021 07:02:33 +0300
Message-Id: <20210608040241.10658-3-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
References: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wwan_hwsim creates and removes simulated control ports on module loading
and unloading. It would be helpful to be able to create/remove devices
and ports at run-time to trigger wwan port (un-)register actions without
module reloading.

Some simulator objects (e.g. ports) do not have the underling device and
it is not possible to fully manage the simulator via sysfs. wwan_hsim
intend for developers, so implement it as a self-contained debugfs based
management interface.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/wwan_hwsim.c | 186 +++++++++++++++++++++++++++++++++-
 1 file changed, 184 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
index 96d25d7e5bb8..472cae544a2b 100644
--- a/drivers/net/wwan/wwan_hwsim.c
+++ b/drivers/net/wwan/wwan_hwsim.c
@@ -15,6 +15,8 @@
 #include <linux/list.h>
 #include <linux/skbuff.h>
 #include <linux/wwan.h>
+#include <linux/debugfs.h>
+#include <linux/workqueue.h>
 
 static int wwan_hwsim_devsnum = 2;
 module_param_named(devices, wwan_hwsim_devsnum, int, 0444);
@@ -22,6 +24,9 @@ MODULE_PARM_DESC(devices, "Number of simulated devices");
 
 static struct class *wwan_hwsim_class;
 
+static struct dentry *wwan_hwsim_debugfs_topdir;
+static struct dentry *wwan_hwsim_debugfs_devcreate;
+
 static DEFINE_SPINLOCK(wwan_hwsim_devs_lock);
 static LIST_HEAD(wwan_hwsim_devs);
 static unsigned int wwan_hwsim_dev_idx;
@@ -30,6 +35,9 @@ struct wwan_hwsim_dev {
 	struct list_head list;
 	unsigned int id;
 	struct device dev;
+	struct work_struct del_work;
+	struct dentry *debugfs_topdir;
+	struct dentry *debugfs_portcreate;
 	spinlock_t ports_lock;	/* Serialize ports creation/deletion */
 	unsigned int port_idx;
 	struct list_head ports;
@@ -40,6 +48,8 @@ struct wwan_hwsim_port {
 	unsigned int id;
 	struct wwan_hwsim_dev *dev;
 	struct wwan_port *wwan;
+	struct work_struct del_work;
+	struct dentry *debugfs_topdir;
 	enum {			/* AT command parser state */
 		AT_PARSER_WAIT_A,
 		AT_PARSER_WAIT_T,
@@ -48,6 +58,12 @@ struct wwan_hwsim_port {
 	} pstate;
 };
 
+static const struct file_operations wwan_hwsim_debugfs_portdestroy_fops;
+static const struct file_operations wwan_hwsim_debugfs_portcreate_fops;
+static const struct file_operations wwan_hwsim_debugfs_devdestroy_fops;
+static void wwan_hwsim_port_del_work(struct work_struct *work);
+static void wwan_hwsim_dev_del_work(struct work_struct *work);
+
 static int wwan_hwsim_port_start(struct wwan_port *wport)
 {
 	struct wwan_hwsim_port *port = wwan_port_get_drvdata(wport);
@@ -139,6 +155,7 @@ static const struct wwan_port_ops wwan_hwsim_port_ops = {
 static struct wwan_hwsim_port *wwan_hwsim_port_new(struct wwan_hwsim_dev *dev)
 {
 	struct wwan_hwsim_port *port;
+	char name[0x10];
 	int err;
 
 	port = kzalloc(sizeof(*port), GFP_KERNEL);
@@ -159,6 +176,13 @@ static struct wwan_hwsim_port *wwan_hwsim_port_new(struct wwan_hwsim_dev *dev)
 		goto err_free_port;
 	}
 
+	INIT_WORK(&port->del_work, wwan_hwsim_port_del_work);
+
+	snprintf(name, sizeof(name), "port%u", port->id);
+	port->debugfs_topdir = debugfs_create_dir(name, dev->debugfs_topdir);
+	debugfs_create_file("destroy", 0200, port->debugfs_topdir, port,
+			    &wwan_hwsim_debugfs_portdestroy_fops);
+
 	return port;
 
 err_free_port:
@@ -169,10 +193,34 @@ static struct wwan_hwsim_port *wwan_hwsim_port_new(struct wwan_hwsim_dev *dev)
 
 static void wwan_hwsim_port_del(struct wwan_hwsim_port *port)
 {
+	debugfs_remove(port->debugfs_topdir);
+
+	/* Make sure that there is no pending deletion work */
+	if (current_work() != &port->del_work)
+		cancel_work_sync(&port->del_work);
+
 	wwan_remove_port(port->wwan);
 	kfree(port);
 }
 
+static void wwan_hwsim_port_del_work(struct work_struct *work)
+{
+	struct wwan_hwsim_port *port =
+				container_of(work, typeof(*port), del_work);
+	struct wwan_hwsim_dev *dev = port->dev;
+
+	spin_lock(&dev->ports_lock);
+	if (list_empty(&port->list)) {
+		/* Someone else deleting port at the moment */
+		spin_unlock(&dev->ports_lock);
+		return;
+	}
+	list_del_init(&port->list);
+	spin_unlock(&dev->ports_lock);
+
+	wwan_hwsim_port_del(port);
+}
+
 static void wwan_hwsim_dev_release(struct device *sysdev)
 {
 	struct wwan_hwsim_dev *dev = container_of(sysdev, typeof(*dev), dev);
@@ -204,6 +252,17 @@ static struct wwan_hwsim_dev *wwan_hwsim_dev_new(void)
 	if (err)
 		goto err_free_dev;
 
+	INIT_WORK(&dev->del_work, wwan_hwsim_dev_del_work);
+
+	dev->debugfs_topdir = debugfs_create_dir(dev_name(&dev->dev),
+						 wwan_hwsim_debugfs_topdir);
+	debugfs_create_file("destroy", 0200, dev->debugfs_topdir, dev,
+			    &wwan_hwsim_debugfs_devdestroy_fops);
+	dev->debugfs_portcreate =
+		debugfs_create_file("portcreate", 0200,
+				    dev->debugfs_topdir, dev,
+				    &wwan_hwsim_debugfs_portcreate_fops);
+
 	return dev;
 
 err_free_dev:
@@ -214,23 +273,136 @@ static struct wwan_hwsim_dev *wwan_hwsim_dev_new(void)
 
 static void wwan_hwsim_dev_del(struct wwan_hwsim_dev *dev)
 {
+	debugfs_remove(dev->debugfs_portcreate);	/* Avoid new ports */
+
 	spin_lock(&dev->ports_lock);
 	while (!list_empty(&dev->ports)) {
 		struct wwan_hwsim_port *port;
 
 		port = list_first_entry(&dev->ports, struct wwan_hwsim_port,
 					list);
-		list_del(&port->list);
+		list_del_init(&port->list);
 		spin_unlock(&dev->ports_lock);
 		wwan_hwsim_port_del(port);
 		spin_lock(&dev->ports_lock);
 	}
 	spin_unlock(&dev->ports_lock);
 
+	debugfs_remove(dev->debugfs_topdir);
+
+	/* Make sure that there is no pending deletion work */
+	if (current_work() != &dev->del_work)
+		cancel_work_sync(&dev->del_work);
+
 	device_unregister(&dev->dev);
 	/* Memory will be freed in the device release callback */
 }
 
+static void wwan_hwsim_dev_del_work(struct work_struct *work)
+{
+	struct wwan_hwsim_dev *dev = container_of(work, typeof(*dev), del_work);
+
+	spin_lock(&wwan_hwsim_devs_lock);
+	if (list_empty(&dev->list)) {
+		/* Someone else deleting device at the moment */
+		spin_unlock(&wwan_hwsim_devs_lock);
+		return;
+	}
+	list_del_init(&dev->list);
+	spin_unlock(&wwan_hwsim_devs_lock);
+
+	wwan_hwsim_dev_del(dev);
+}
+
+static ssize_t wwan_hwsim_debugfs_portdestroy_write(struct file *file,
+						    const char __user *usrbuf,
+						    size_t count, loff_t *ppos)
+{
+	struct wwan_hwsim_port *port = file->private_data;
+
+	/* We can not delete port here since it will cause a deadlock due to
+	 * waiting this callback to finish in the debugfs_remove() call. So,
+	 * use workqueue.
+	 */
+	schedule_work(&port->del_work);
+
+	return count;
+}
+
+static const struct file_operations wwan_hwsim_debugfs_portdestroy_fops = {
+	.write = wwan_hwsim_debugfs_portdestroy_write,
+	.open = simple_open,
+	.llseek = noop_llseek,
+};
+
+static ssize_t wwan_hwsim_debugfs_portcreate_write(struct file *file,
+						   const char __user *usrbuf,
+						   size_t count, loff_t *ppos)
+{
+	struct wwan_hwsim_dev *dev = file->private_data;
+	struct wwan_hwsim_port *port;
+
+	port = wwan_hwsim_port_new(dev);
+	if (IS_ERR(port))
+		return PTR_ERR(port);
+
+	spin_lock(&dev->ports_lock);
+	list_add_tail(&port->list, &dev->ports);
+	spin_unlock(&dev->ports_lock);
+
+	return count;
+}
+
+static const struct file_operations wwan_hwsim_debugfs_portcreate_fops = {
+	.write = wwan_hwsim_debugfs_portcreate_write,
+	.open = simple_open,
+	.llseek = noop_llseek,
+};
+
+static ssize_t wwan_hwsim_debugfs_devdestroy_write(struct file *file,
+						   const char __user *usrbuf,
+						   size_t count, loff_t *ppos)
+{
+	struct wwan_hwsim_dev *dev = file->private_data;
+
+	/* We can not delete device here since it will cause a deadlock due to
+	 * waiting this callback to finish in the debugfs_remove() call. So,
+	 * use workqueue.
+	 */
+	schedule_work(&dev->del_work);
+
+	return count;
+}
+
+static const struct file_operations wwan_hwsim_debugfs_devdestroy_fops = {
+	.write = wwan_hwsim_debugfs_devdestroy_write,
+	.open = simple_open,
+	.llseek = noop_llseek,
+};
+
+static ssize_t wwan_hwsim_debugfs_devcreate_write(struct file *file,
+						  const char __user *usrbuf,
+						  size_t count, loff_t *ppos)
+{
+	struct wwan_hwsim_dev *dev;
+
+	dev = wwan_hwsim_dev_new();
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+
+	spin_lock(&wwan_hwsim_devs_lock);
+	list_add_tail(&dev->list, &wwan_hwsim_devs);
+	spin_unlock(&wwan_hwsim_devs_lock);
+
+	return count;
+}
+
+static const struct file_operations wwan_hwsim_debugfs_devcreate_fops = {
+	.write = wwan_hwsim_debugfs_devcreate_write,
+	.open = simple_open,
+	.llseek = noop_llseek,
+};
+
 static int __init wwan_hwsim_init_devs(void)
 {
 	struct wwan_hwsim_dev *dev;
@@ -272,7 +444,7 @@ static void wwan_hwsim_free_devs(void)
 	while (!list_empty(&wwan_hwsim_devs)) {
 		dev = list_first_entry(&wwan_hwsim_devs, struct wwan_hwsim_dev,
 				       list);
-		list_del(&dev->list);
+		list_del_init(&dev->list);
 		spin_unlock(&wwan_hwsim_devs_lock);
 		wwan_hwsim_dev_del(dev);
 		spin_lock(&wwan_hwsim_devs_lock);
@@ -291,6 +463,12 @@ static int __init wwan_hwsim_init(void)
 	if (IS_ERR(wwan_hwsim_class))
 		return PTR_ERR(wwan_hwsim_class);
 
+	wwan_hwsim_debugfs_topdir = debugfs_create_dir("wwan_hwsim", NULL);
+	wwan_hwsim_debugfs_devcreate =
+			debugfs_create_file("devcreate", 0200,
+					    wwan_hwsim_debugfs_topdir, NULL,
+					    &wwan_hwsim_debugfs_devcreate_fops);
+
 	err = wwan_hwsim_init_devs();
 	if (err)
 		goto err_clean_devs;
@@ -299,6 +477,7 @@ static int __init wwan_hwsim_init(void)
 
 err_clean_devs:
 	wwan_hwsim_free_devs();
+	debugfs_remove(wwan_hwsim_debugfs_topdir);
 	class_destroy(wwan_hwsim_class);
 
 	return err;
@@ -306,7 +485,10 @@ static int __init wwan_hwsim_init(void)
 
 static void __exit wwan_hwsim_exit(void)
 {
+	debugfs_remove(wwan_hwsim_debugfs_devcreate);	/* Avoid new devs */
 	wwan_hwsim_free_devs();
+	flush_scheduled_work();		/* Wait deletion works completion */
+	debugfs_remove(wwan_hwsim_debugfs_topdir);
 	class_destroy(wwan_hwsim_class);
 }
 
-- 
2.26.3

