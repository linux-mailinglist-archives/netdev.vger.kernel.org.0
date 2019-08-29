Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D5CA181D
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 13:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbfH2LT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 07:19:26 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43790 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728235AbfH2LTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 07:19:25 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 29 Aug 2019 14:19:19 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7TBJ8v5020002;
        Thu, 29 Aug 2019 14:19:18 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, cohuck@redhat.com, davem@davemloft.net
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>
Subject: [PATCH v2 4/6] mdev: Introduce an API mdev_alias
Date:   Thu, 29 Aug 2019 06:19:02 -0500
Message-Id: <20190829111904.16042-5-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190829111904.16042-1-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
 <20190829111904.16042-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce an API mdev_alias() to provide access to optionally generated
alias.

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/vfio/mdev/mdev_core.c | 12 ++++++++++++
 include/linux/mdev.h          |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index c9bf2ac362b9..5399ed6f1612 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -517,6 +517,18 @@ struct device *mdev_get_iommu_device(struct device *dev)
 }
 EXPORT_SYMBOL(mdev_get_iommu_device);
 
+/**
+ * mdev_alias: Return alias string of a mdev device
+ * @mdev:	Pointer to the mdev device
+ * mdev_alias() returns alias string of a mdev device if alias is present,
+ * returns NULL otherwise.
+ */
+const char *mdev_alias(struct mdev_device *mdev)
+{
+	return mdev->alias;
+}
+EXPORT_SYMBOL(mdev_alias);
+
 static int __init mdev_init(void)
 {
 	int ret;
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index f036fe9854ee..6da82213bc4e 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -148,5 +148,6 @@ void mdev_unregister_driver(struct mdev_driver *drv);
 struct device *mdev_parent_dev(struct mdev_device *mdev);
 struct device *mdev_dev(struct mdev_device *mdev);
 struct mdev_device *mdev_from_dev(struct device *dev);
+const char *mdev_alias(struct mdev_device *mdev);
 
 #endif /* MDEV_H */
-- 
2.19.2

