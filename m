Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1784D9305
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 04:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344677AbiCOD1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 23:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344657AbiCOD1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 23:27:14 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C70483AE;
        Mon, 14 Mar 2022 20:26:02 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KHdxd4GSsz9sgC;
        Tue, 15 Mar 2022 11:22:13 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 11:26:00 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 11:26:00 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <stefanha@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
        <sgarzare@redhat.com>
CC:     <arei.gonglei@huawei.com>, <yechuan@huawei.com>,
        <huangzhichao@huawei.com>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Longpeng <longpeng2@huawei.com>
Subject: [PATCH v2 2/3] vdpa: change the type of nvqs to u32
Date:   Tue, 15 Mar 2022 11:25:52 +0800
Message-ID: <20220315032553.455-3-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
In-Reply-To: <20220315032553.455-1-longpeng2@huawei.com>
References: <20220315032553.455-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

Change vdpa_device.nvqs and vhost_vdpa.nvqs to use u32

Signed-off-by: Longpeng <longpeng2@huawei.com>
---
 drivers/vdpa/vdpa.c  |  6 +++---
 drivers/vhost/vdpa.c | 10 ++++++----
 include/linux/vdpa.h |  6 +++---
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 1ea5254..2b75c00 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -232,7 +232,7 @@ static int vdpa_name_match(struct device *dev, const void *data)
 	return (strcmp(dev_name(&vdev->dev), data) == 0);
 }
 
-static int __vdpa_register_device(struct vdpa_device *vdev, int nvqs)
+static int __vdpa_register_device(struct vdpa_device *vdev, u32 nvqs)
 {
 	struct device *dev;
 
@@ -257,7 +257,7 @@ static int __vdpa_register_device(struct vdpa_device *vdev, int nvqs)
  *
  * Return: Returns an error when fail to add device to vDPA bus
  */
-int _vdpa_register_device(struct vdpa_device *vdev, int nvqs)
+int _vdpa_register_device(struct vdpa_device *vdev, u32 nvqs)
 {
 	if (!vdev->mdev)
 		return -EINVAL;
@@ -274,7 +274,7 @@ int _vdpa_register_device(struct vdpa_device *vdev, int nvqs)
  *
  * Return: Returns an error when fail to add to vDPA bus
  */
-int vdpa_register_device(struct vdpa_device *vdev, int nvqs)
+int vdpa_register_device(struct vdpa_device *vdev, u32 nvqs)
 {
 	int err;
 
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 605c7ae..0c82eb5 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -42,7 +42,7 @@ struct vhost_vdpa {
 	struct device dev;
 	struct cdev cdev;
 	atomic_t opened;
-	int nvqs;
+	u32 nvqs;
 	int virtio_id;
 	int minor;
 	struct eventfd_ctx *config_ctx;
@@ -158,7 +158,8 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 	u8 status, status_old;
-	int ret, nvqs = v->nvqs;
+	u32 nvqs = v->nvqs;
+	int ret;
 	u16 i;
 
 	if (copy_from_user(&status, statusp, sizeof(status)))
@@ -965,7 +966,8 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	struct vhost_vdpa *v;
 	struct vhost_dev *dev;
 	struct vhost_virtqueue **vqs;
-	int nvqs, i, r, opened;
+	int r, opened;
+	u32 i, nvqs;
 
 	v = container_of(inode->i_cdev, struct vhost_vdpa, cdev);
 
@@ -1018,7 +1020,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
 static void vhost_vdpa_clean_irq(struct vhost_vdpa *v)
 {
-	int i;
+	u32 i;
 
 	for (i = 0; i < v->nvqs; i++)
 		vhost_vdpa_unsetup_vq_irq(v, i);
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index a526919..8943a20 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -83,7 +83,7 @@ struct vdpa_device {
 	unsigned int index;
 	bool features_valid;
 	bool use_va;
-	int nvqs;
+	u32 nvqs;
 	struct vdpa_mgmt_dev *mdev;
 };
 
@@ -338,10 +338,10 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 				       dev_struct, member)), name, use_va), \
 				       dev_struct, member)
 
-int vdpa_register_device(struct vdpa_device *vdev, int nvqs);
+int vdpa_register_device(struct vdpa_device *vdev, u32 nvqs);
 void vdpa_unregister_device(struct vdpa_device *vdev);
 
-int _vdpa_register_device(struct vdpa_device *vdev, int nvqs);
+int _vdpa_register_device(struct vdpa_device *vdev, u32 nvqs);
 void _vdpa_unregister_device(struct vdpa_device *vdev);
 
 /**
-- 
1.8.3.1

