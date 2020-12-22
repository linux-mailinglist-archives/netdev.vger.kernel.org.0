Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2AE2E0C31
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgLVOzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727954AbgLVOzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 09:55:12 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E81C0619D7
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:54:08 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 15so8498146pgx.7
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4+Fjebo98WhfRUN3DrQtPHG8mNqX1npOT1+Tn0CjZWw=;
        b=lRXPpJ8trxMdYGEQyvikZh7MHBo6qVFebzTRH2Iw67+yIhqQAKXuAe/PXQz3QmUtnM
         cvuopjkNxS21JL07G6BSQSDgEmFx5xcbz0FP2DPjHK8W2Np5y5zbh+EDa3Iytid8HnZl
         rZIUgpBAluBV9lZ9BZv9D5N+daewxyWU0pBs+fip7zNLbpQ5IZqSBnPufxYkU7rwfWDe
         ZdRbvJdcgno/Txow/JtJ3Bxj8S7UfxnSydZPvyfVJeZFJEjzdeOPH0qM+B0PlrLYR8gD
         n7NVryoFQXZQc5ShZFUtQqmntWjabTAuNwCkR1J48P31+XWCWDy+hHWn2TZ3Z2sVTRUl
         oqNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4+Fjebo98WhfRUN3DrQtPHG8mNqX1npOT1+Tn0CjZWw=;
        b=eDWyKTOiHJnjMbA3MWp1udOZGeD5jBx9nVoFb55q/p3n43Cn0LcSc77gR00AZJ3VlO
         67Xn/vreGzMnrJkMUPzFuxunLlSEljW7F+ry89hrz3runifkNKp6Ywevfql4Ol898nAn
         yxDlJHSh0LdxxdAl7iuh7orRfF0RBipLQ4iJKMkv2d88lMRI5pAzErqwVFAjeY8J2Zek
         W1tuyanM+6Q+dw5xoWuKyYNE+Cm02vMtCzl8UhBNJfvlKhJgSTAQash+ev+y9f0KTp8K
         DtOIsEFO8wt5Y8iCzw6OxAPPSMd1xutu6j27thWr7bVTbn1TUQPTk/d4+89BJlky5WHM
         vHCw==
X-Gm-Message-State: AOAM532syHLiAzOX9aVMHAoiSP35gwGwHhZtS/7x6bj9XFNEp/Np2jc2
        QL7N3goiWnzo2ZvxGXHBZLyF
X-Google-Smtp-Source: ABdhPJxtUNSVl5q3pqx99vDuPEDlkGWR5BEQUY7kaawfKYH1NxQr+mt2TkyzP9M4sO3xRqG1u+OO+Q==
X-Received: by 2002:aa7:9ab7:0:b029:19d:ac89:39aa with SMTP id x23-20020aa79ab70000b029019dac8939aamr20258173pfi.10.1608648847840;
        Tue, 22 Dec 2020 06:54:07 -0800 (PST)
Received: from localhost ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id f9sm20660288pfa.41.2020.12.22.06.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 06:54:07 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, akpm@linux-foundation.org,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC v2 09/13] vduse: Add support for processing vhost iotlb message
Date:   Tue, 22 Dec 2020 22:52:17 +0800
Message-Id: <20201222145221.711-10-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222145221.711-1-xieyongji@bytedance.com>
References: <20201222145221.711-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support vhost-vdpa bus driver, we need a way to share the
vhost-vdpa backend process's memory with the userspace VDUSE process.

This patch tries to make use of the vhost iotlb message to achieve
that. We will get the shm file from the iotlb message and pass it
to the userspace VDUSE process.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 Documentation/driver-api/vduse.rst |  15 +++-
 drivers/vdpa/vdpa_user/vduse_dev.c | 147 ++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/vduse.h         |  11 +++
 3 files changed, 171 insertions(+), 2 deletions(-)

diff --git a/Documentation/driver-api/vduse.rst b/Documentation/driver-api/vduse.rst
index 623f7b040ccf..48e4b1ba353f 100644
--- a/Documentation/driver-api/vduse.rst
+++ b/Documentation/driver-api/vduse.rst
@@ -46,13 +46,26 @@ The following types of messages are provided by the VDUSE framework now:
 
 - VDUSE_GET_CONFIG: Read from device specific configuration space
 
+- VDUSE_UPDATE_IOTLB: Update the memory mapping in device IOTLB
+
+- VDUSE_INVALIDATE_IOTLB: Invalidate the memory mapping in device IOTLB
+
 Please see include/linux/vdpa.h for details.
 
-In the data path, VDUSE framework implements a MMU-based on-chip IOMMU
+The data path of userspace vDPA device is implemented in different ways
+depending on the vdpa bus to which it is attached.
+
+In virtio-vdpa case, VDUSE framework implements a MMU-based on-chip IOMMU
 driver which supports mapping the kernel dma buffer to a userspace iova
 region dynamically. The userspace iova region can be created by passing
 the userspace vDPA device fd to mmap(2).
 
+In vhost-vdpa case, the dma buffer is reside in a userspace memory region
+which will be shared to the VDUSE userspace processs via the file
+descriptor in VDUSE_UPDATE_IOTLB message. And the corresponding address
+mapping (IOVA of dma buffer <-> VA of the memory region) is also included
+in this message.
+
 Besides, the eventfd mechanism is used to trigger interrupt callbacks and
 receive virtqueue kicks in userspace. The following ioctls on the userspace
 vDPA device fd are provided to support that:
diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index b974333ed4e9..d24aaacb6008 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -34,6 +34,7 @@
 
 struct vduse_dev_msg {
 	struct vduse_dev_request req;
+	struct file *iotlb_file;
 	struct vduse_dev_response resp;
 	struct list_head list;
 	wait_queue_head_t waitq;
@@ -325,12 +326,80 @@ static int vduse_dev_set_vq_state(struct vduse_dev *dev,
 	return ret;
 }
 
+static int vduse_dev_update_iotlb(struct vduse_dev *dev, struct file *file,
+				u64 offset, u64 iova, u64 size, u8 perm)
+{
+	struct vduse_dev_msg *msg;
+	int ret;
+
+	if (!size)
+		return -EINVAL;
+
+	msg = vduse_dev_new_msg(dev, VDUSE_UPDATE_IOTLB);
+	msg->req.size = sizeof(struct vduse_iotlb);
+	msg->req.iotlb.offset = offset;
+	msg->req.iotlb.iova = iova;
+	msg->req.iotlb.size = size;
+	msg->req.iotlb.perm = perm;
+	msg->req.iotlb.fd = -1;
+	msg->iotlb_file = get_file(file);
+
+	ret = vduse_dev_msg_sync(dev, msg);
+	vduse_dev_msg_put(msg);
+	fput(file);
+
+	return ret;
+}
+
+static int vduse_dev_invalidate_iotlb(struct vduse_dev *dev,
+					u64 iova, u64 size)
+{
+	struct vduse_dev_msg *msg;
+	int ret;
+
+	if (!size)
+		return -EINVAL;
+
+	msg = vduse_dev_new_msg(dev, VDUSE_INVALIDATE_IOTLB);
+	msg->req.size = sizeof(struct vduse_iotlb);
+	msg->req.iotlb.iova = iova;
+	msg->req.iotlb.size = size;
+
+	ret = vduse_dev_msg_sync(dev, msg);
+	vduse_dev_msg_put(msg);
+
+	return ret;
+}
+
+static unsigned int perm_to_file_flags(u8 perm)
+{
+	unsigned int flags = 0;
+
+	switch (perm) {
+	case VHOST_ACCESS_WO:
+		flags |= O_WRONLY;
+		break;
+	case VHOST_ACCESS_RO:
+		flags |= O_RDONLY;
+		break;
+	case VHOST_ACCESS_RW:
+		flags |= O_RDWR;
+		break;
+	default:
+		WARN(1, "invalidate vhost IOTLB permission\n");
+		break;
+	}
+
+	return flags;
+}
+
 static ssize_t vduse_dev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
 	struct vduse_dev *dev = file->private_data;
 	struct vduse_dev_msg *msg;
-	int size = sizeof(struct vduse_dev_request);
+	unsigned int flags;
+	int fd, size = sizeof(struct vduse_dev_request);
 	ssize_t ret = 0;
 
 	if (iov_iter_count(to) < size)
@@ -349,6 +418,18 @@ static ssize_t vduse_dev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		if (ret)
 			return ret;
 	}
+
+	if (msg->req.type == VDUSE_UPDATE_IOTLB && msg->req.iotlb.fd == -1) {
+		flags = perm_to_file_flags(msg->req.iotlb.perm);
+		fd = get_unused_fd_flags(flags);
+		if (fd < 0) {
+			vduse_dev_enqueue_msg(dev, msg, &dev->send_list);
+			return fd;
+		}
+		fd_install(fd, get_file(msg->iotlb_file));
+		msg->req.iotlb.fd = fd;
+	}
+
 	ret = copy_to_iter(&msg->req, size, to);
 	if (ret != size) {
 		vduse_dev_enqueue_msg(dev, msg, &dev->send_list);
@@ -565,6 +646,69 @@ static void vduse_vdpa_set_config(struct vdpa_device *vdpa, unsigned int offset,
 	vduse_dev_set_config(dev, offset, buf, len);
 }
 
+static void vduse_vdpa_invalidate_iotlb(struct vduse_dev *dev,
+					struct vhost_iotlb_msg *msg)
+{
+	vduse_dev_invalidate_iotlb(dev, msg->iova, msg->size);
+}
+
+static int vduse_vdpa_update_iotlb(struct vduse_dev *dev,
+					struct vhost_iotlb_msg *msg)
+{
+	u64 uaddr = msg->uaddr;
+	u64 iova = msg->iova;
+	u64 size = msg->size;
+	u64 offset;
+	struct vm_area_struct *vma;
+	int ret;
+
+	while (uaddr < msg->uaddr + msg->size) {
+		vma = find_vma(current->mm, uaddr);
+		ret = -EINVAL;
+		if (!vma)
+			goto err;
+
+		size = min(msg->size, vma->vm_end - uaddr);
+		offset = (vma->vm_pgoff << PAGE_SHIFT) + uaddr - vma->vm_start;
+		if (vma->vm_file && (vma->vm_flags & VM_SHARED)) {
+			ret = vduse_dev_update_iotlb(dev, vma->vm_file, offset,
+							iova, size, msg->perm);
+			if (ret)
+				goto err;
+		}
+		iova += size;
+		uaddr += size;
+	}
+	return 0;
+err:
+	vduse_dev_invalidate_iotlb(dev, msg->iova, iova - msg->iova);
+	return ret;
+}
+
+static int vduse_vdpa_process_iotlb_msg(struct vdpa_device *vdpa,
+					struct vhost_iotlb_msg *msg)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+	int ret = 0;
+
+	switch (msg->type) {
+	case VHOST_IOTLB_UPDATE:
+		ret = vduse_vdpa_update_iotlb(dev, msg);
+		break;
+	case VHOST_IOTLB_INVALIDATE:
+		vduse_vdpa_invalidate_iotlb(dev, msg);
+		break;
+	case VHOST_IOTLB_BATCH_BEGIN:
+	case VHOST_IOTLB_BATCH_END:
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
 static void vduse_vdpa_free(struct vdpa_device *vdpa)
 {
 	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
@@ -597,6 +741,7 @@ static const struct vdpa_config_ops vduse_vdpa_config_ops = {
 	.set_status		= vduse_vdpa_set_status,
 	.get_config		= vduse_vdpa_get_config,
 	.set_config		= vduse_vdpa_set_config,
+	.process_iotlb_msg	= vduse_vdpa_process_iotlb_msg,
 	.free			= vduse_vdpa_free,
 };
 
diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
index 873305dfd93f..c5080851f140 100644
--- a/include/uapi/linux/vduse.h
+++ b/include/uapi/linux/vduse.h
@@ -21,6 +21,8 @@ enum vduse_req_type {
 	VDUSE_GET_STATUS,
 	VDUSE_SET_CONFIG,
 	VDUSE_GET_CONFIG,
+	VDUSE_UPDATE_IOTLB,
+	VDUSE_INVALIDATE_IOTLB,
 };
 
 struct vduse_vq_num {
@@ -51,6 +53,14 @@ struct vduse_dev_config_data {
 	__u8 data[VDUSE_CONFIG_DATA_LEN];
 };
 
+struct vduse_iotlb {
+	__u32 fd;
+	__u64 offset;
+	__u64 iova;
+	__u64 size;
+	__u8 perm;
+};
+
 struct vduse_dev_request {
 	__u32 type; /* request type */
 	__u32 unique; /* request id */
@@ -62,6 +72,7 @@ struct vduse_dev_request {
 		struct vduse_vq_ready vq_ready; /* virtqueue ready status */
 		struct vduse_vq_state vq_state; /* virtqueue state */
 		struct vduse_dev_config_data config; /* virtio device config space */
+		struct vduse_iotlb iotlb; /* iotlb message */
 		__u64 features; /* virtio features */
 		__u8 status; /* device status */
 	};
-- 
2.11.0

