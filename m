Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDDD2CED5A
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 12:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388170AbgLDLnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 06:43:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728721AbgLDLnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 06:43:49 -0500
Date:   Fri, 4 Dec 2020 12:44:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607082188;
        bh=fq/9ik6SfqapT/k/I6QzVE0S1KeSa8ddttOC6wf8sP8=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=k10zOjlHjxusAPfYissHzBSFO43kto7VEIXNsGmUC0OjchoyvsaKGNdVZshTT0Jxy
         mK7Yi+BabyG/oLIBm/zVdriuU/I8pg8YFVWokUXqkLmwB4XxiYZWlkkzerUhEjbTSh
         RDjaWA925XCOiE4CZGO/2+NJzSLp7zlszoucdtoA=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     broonie@kernel.org, lgirdwood@gmail.com, davem@davemloft.net,
        kuba@kernel.org, jgg@nvidia.com,
        Kiran Patil <kiran.patil@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        Martin Habets <mhabets@solarflare.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] driver core: auxiliary bus: minor coding style tweaks
Message-ID: <X8ohGE8IBKiafzka@kroah.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com>
 <X8og8xi3WkoYXet9@kroah.com>
 <X8ohB1ks1NK7kPop@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8ohB1ks1NK7kPop@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

For some reason, the original aux bus patch had some really long lines
in a few places, probably due to it being a very long-lived patch in
development by many different people.  Fix that up so that the two files
all have the same length lines and function formatting styles.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/Kconfig     |  2 +-
 drivers/base/auxiliary.c | 58 ++++++++++++++++++++++------------------
 2 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 040be48ce046..ba52b2c40202 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -2,7 +2,7 @@
 menu "Generic Driver Options"
 
 config AUXILIARY_BUS
-	bool
+	tristate "aux bus!"
 
 config UEVENT_HELPER
 	bool "Support for uevent helper"
diff --git a/drivers/base/auxiliary.c b/drivers/base/auxiliary.c
index c44e85802b43..f303daadf843 100644
--- a/drivers/base/auxiliary.c
+++ b/drivers/base/auxiliary.c
@@ -50,8 +50,8 @@ static int auxiliary_uevent(struct device *dev, struct kobj_uevent_env *env)
 	name = dev_name(dev);
 	p = strrchr(name, '.');
 
-	return add_uevent_var(env, "MODALIAS=%s%.*s", AUXILIARY_MODULE_PREFIX, (int)(p - name),
-			      name);
+	return add_uevent_var(env, "MODALIAS=%s%.*s", AUXILIARY_MODULE_PREFIX,
+			      (int)(p - name), name);
 }
 
 static const struct dev_pm_ops auxiliary_dev_pm_ops = {
@@ -113,16 +113,18 @@ static struct bus_type auxiliary_bus_type = {
  * auxiliary_device_init - check auxiliary_device and initialize
  * @auxdev: auxiliary device struct
  *
- * This is the first step in the two-step process to register an auxiliary_device.
+ * This is the first step in the two-step process to register an
+ * auxiliary_device.
  *
- * When this function returns an error code, then the device_initialize will *not* have
- * been performed, and the caller will be responsible to free any memory allocated for the
- * auxiliary_device in the error path directly.
+ * When this function returns an error code, then the device_initialize will
+ * *not* have been performed, and the caller will be responsible to free any
+ * memory allocated for the auxiliary_device in the error path directly.
  *
- * It returns 0 on success.  On success, the device_initialize has been performed.  After this
- * point any error unwinding will need to include a call to auxiliary_device_uninit().
- * In this post-initialize error scenario, a call to the device's .release callback will be
- * triggered, and all memory clean-up is expected to be handled there.
+ * It returns 0 on success.  On success, the device_initialize has been
+ * performed.  After this point any error unwinding will need to include a call
+ * to auxiliary_device_uninit().  In this post-initialize error scenario, a call
+ * to the device's .release callback will be triggered, and all memory clean-up
+ * is expected to be handled there.
  */
 int auxiliary_device_init(struct auxiliary_device *auxdev)
 {
@@ -149,16 +151,19 @@ EXPORT_SYMBOL_GPL(auxiliary_device_init);
  * @auxdev: auxiliary bus device to add to the bus
  * @modname: name of the parent device's driver module
  *
- * This is the second step in the two-step process to register an auxiliary_device.
+ * This is the second step in the two-step process to register an
+ * auxiliary_device.
  *
- * This function must be called after a successful call to auxiliary_device_init(), which
- * will perform the device_initialize.  This means that if this returns an error code, then a
- * call to auxiliary_device_uninit() must be performed so that the .release callback will
- * be triggered to free the memory associated with the auxiliary_device.
+ * This function must be called after a successful call to
+ * auxiliary_device_init(), which will perform the device_initialize.  This
+ * means that if this returns an error code, then a call to
+ * auxiliary_device_uninit() must be performed so that the .release callback
+ * will be triggered to free the memory associated with the auxiliary_device.
  *
- * The expectation is that users will call the "auxiliary_device_add" macro so that the caller's
- * KBUILD_MODNAME is automatically inserted for the modname parameter.  Only if a user requires
- * a custom name would this version be called directly.
+ * The expectation is that users will call the "auxiliary_device_add" macro so
+ * that the caller's KBUILD_MODNAME is automatically inserted for the modname
+ * parameter.  Only if a user requires a custom name would this version be
+ * called directly.
  */
 int __auxiliary_device_add(struct auxiliary_device *auxdev, const char *modname)
 {
@@ -166,13 +171,13 @@ int __auxiliary_device_add(struct auxiliary_device *auxdev, const char *modname)
 	int ret;
 
 	if (!modname) {
-		pr_err("auxiliary device modname is NULL\n");
+		dev_err(dev, "auxiliary device modname is NULL\n");
 		return -EINVAL;
 	}
 
 	ret = dev_set_name(dev, "%s.%s.%d", modname, auxdev->name, auxdev->id);
 	if (ret) {
-		pr_err("auxiliary device dev_set_name failed: %d\n", ret);
+		dev_err(dev, "auxiliary device dev_set_name failed: %d\n", ret);
 		return ret;
 	}
 
@@ -197,9 +202,9 @@ EXPORT_SYMBOL_GPL(__auxiliary_device_add);
  * if it does.  If the callback returns non-zero, this function will
  * return to the caller and not iterate over any more devices.
  */
-struct auxiliary_device *
-auxiliary_find_device(struct device *start, const void *data,
-		      int (*match)(struct device *dev, const void *data))
+struct auxiliary_device *auxiliary_find_device(struct device *start,
+					       const void *data,
+					       int (*match)(struct device *dev, const void *data))
 {
 	struct device *dev;
 
@@ -217,14 +222,15 @@ EXPORT_SYMBOL_GPL(auxiliary_find_device);
  * @owner: owning module/driver
  * @modname: KBUILD_MODNAME for parent driver
  */
-int __auxiliary_driver_register(struct auxiliary_driver *auxdrv, struct module *owner,
-				const char *modname)
+int __auxiliary_driver_register(struct auxiliary_driver *auxdrv,
+				struct module *owner, const char *modname)
 {
 	if (WARN_ON(!auxdrv->probe) || WARN_ON(!auxdrv->id_table))
 		return -EINVAL;
 
 	if (auxdrv->name)
-		auxdrv->driver.name = kasprintf(GFP_KERNEL, "%s.%s", modname, auxdrv->name);
+		auxdrv->driver.name = kasprintf(GFP_KERNEL, "%s.%s", modname,
+						auxdrv->name);
 	else
 		auxdrv->driver.name = kasprintf(GFP_KERNEL, "%s", modname);
 	if (!auxdrv->driver.name)
-- 
2.29.2

