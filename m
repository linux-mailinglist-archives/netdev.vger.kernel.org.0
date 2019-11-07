Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBCA1F345F
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389567AbfKGQKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:10:03 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53581 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389552AbfKGQJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:09:18 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:09:13 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G8d4K007213;
        Thu, 7 Nov 2019 18:09:11 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 10/19] vfio/mdev: Introduce an API mdev_alias
Date:   Thu,  7 Nov 2019 10:08:25 -0600
Message-Id: <20191107160834.21087-10-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191107160834.21087-1-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce an API mdev_alias() to provide access to optionally generated
alias.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/vfio/mdev/mdev_core.c | 12 ++++++++++++
 include/linux/mdev.h          |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index c8cd40366783..9eec556fbdd4 100644
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
index 06e162361df9..2997ce157523 100644
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

