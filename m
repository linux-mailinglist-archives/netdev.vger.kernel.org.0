Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187EE337966
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhCKQbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhCKQah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:30:37 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5214DC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:30:37 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id y124-20020a1c32820000b029010c93864955so13631181wmy.5
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bxXBxC2i77yqZhpCo4UnIPSlubPbZx5nPumHHsmdTXY=;
        b=ujfBT3hx9b7g6XdhEetAPh7j1OjOBNOUkEhLaEEY4PzZN4vo3VGwyUQQUwD/zGYufD
         2S2z+siQForynjlgAfK42hysK8CubF65/1r0CeYbB7V9iZmH+rR91KnnEJ8ST+hmW+SW
         Pke9Cb0ogc8I3PZYoHaQuhKeF7+m4BCTUTneBkkDmuJOLD7xil6aTULw+N3hcbE2RCwl
         NhCZk6dsZpaZN+YsaJtBUjbhqRwm7UfZy/SHm/iHtHQPUH8CNqVBIKBdnjZ5ODO+Pmbo
         R/+a/Tp9sX3U/USiqNJJfzl8cRoITrSIVIL7TbwNiJr6nVB+ffrJlFPahjE7OSYvBfIt
         qGlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bxXBxC2i77yqZhpCo4UnIPSlubPbZx5nPumHHsmdTXY=;
        b=WS9fdfDLQE3jGtj7/y8CemL32zCpgWGo/twRlCM3mlW5krZViBqjL/7oewqw2dCzT3
         oxzeMwL3rl850UvPiOYvrXmWan5Rug4tS2aKcyf/1LsGsd51Rz9m3Y84wJcvcvxvYMl2
         po20raf1Migf4llholILT+rgwd1FiULu80+g3lQkYz3km9et/SrceTEzHngk2coitlKC
         sGa/SFCqTRFBY/foGVy1beG2P6EFBL46tQzCG8RxzMIpGpE9o1ejdmFOQLb2paXwF5Bx
         O/wVLL0neCXef1qU05i2UDkzgIug/ByQILRS32K1SqVk7f36TOl+BoaBkfVKoOVgzx5D
         pf3Q==
X-Gm-Message-State: AOAM533WWGxt98kofGVlws1P9Q6GiEBQrsm+yb0p7dAQyfMhqXmTS8ll
        2LtFN2i4njAOv5cCRwKB9Heqiw==
X-Google-Smtp-Source: ABdhPJxTH8tUwjXORQSBdG2Lm4mrg+b8ErNoHmxQiLHOdZZyNmbcMsXFIHweOjJg7cMzF/IwNc9vxQ==
X-Received: by 2002:a1c:6a05:: with SMTP id f5mr8902047wmc.75.1615480235863;
        Thu, 11 Mar 2021 08:30:35 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:f986:9cd7:bf3d:f6cb])
        by smtp.gmail.com with ESMTPSA id i8sm4790618wrx.43.2021.03.11.08.30.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Mar 2021 08:30:35 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, aleksander@aleksander.es,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        hemantk@codeaurora.org, jhugo@codeaurora.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v4 2/2] net: Add Qcom WWAN control driver
Date:   Thu, 11 Mar 2021 17:39:06 +0100
Message-Id: <1615480746-28518-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1615480746-28518-1-git-send-email-loic.poulain@linaro.org>
References: <1615480746-28518-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MHI WWWAN control driver allows MHI Qcom based modems to expose
different modem control protocols/ports to userspace, so that userspace
modem tools or daemon (e.g. ModemManager) can control WWAN config
and state (APN config, SMS, provider selection...). A Qcom based
modem can expose one or several of the following protocols:
- AT: Well known AT commands interactive protocol (microcom, minicom...)
- MBIM: Mobile Broadband Interface Model (libmbim, mbimcli)
- QMI: Qcom MSM/Modem Interface (libqmi, qmicli)
- QCDM: Qcom Modem diagnostic interface (libqcdm)
- FIREHOSE: XML-based protocol for Modem firmware management
        (qmi-firmware-update)

The different interfaces are exposed as character devices through the
WWAN subsystem, in the same way as for USB modem variants.

Note that this patch is mostly a rework of the earlier MHI UCI
tentative that was a generic interface for accessing MHI bus from
userspace. As suggested, this new version is WWAN specific and is
dedicated to only expose channels used for controlling a modem, and
for which related opensource user support exist. Other MHI channels
not fitting the requirements will request either to be plugged to
the right Linux subsystem (when available) or to be discussed as a
new MHI driver (e.g AI accelerator, WiFi debug channels, etc...).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wwan/Kconfig         |  14 ++
 drivers/net/wwan/Makefile        |   1 +
 drivers/net/wwan/mhi_wwan_ctrl.c | 497 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 512 insertions(+)
 create mode 100644 drivers/net/wwan/mhi_wwan_ctrl.c

diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index b7d58b7..1e8ac0b 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -16,4 +16,18 @@ config WWAN_CORE
 	  Say Y here if you want to use the WWAN driver core. This driver
 	  provides a common framework for WWAN drivers.
 
+config MHI_WWAN_CTRL
+	tristate "MHI WWAN control driver for QCOM based PCIe modems"
+	select WWAN_CORE
+	depends on MHI_BUS
+	help
+	  MHI WWAN CTRL allow QCOM based PCIe modems to expose different modem
+	  control protocols/ports to userspace, including AT, MBIM, QMI, DIAG
+	  and FIREHOSE. These protocols can be accessed directly from userspace
+	  (e.g. AT commands) or via libraries/tools (e.g. libmbim, libqmi,
+	  libqcdm...).
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called mhi_wwan_ctrl.
+
 endif # WWAN
diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
index ca8bb5a..e18ecda 100644
--- a/drivers/net/wwan/Makefile
+++ b/drivers/net/wwan/Makefile
@@ -6,3 +6,4 @@
 obj-$(CONFIG_WWAN_CORE) += wwan.o
 wwan-objs += wwan_core.o wwan_port.o
 
+obj-$(CONFIG_MHI_WWAN_CTRL) += mhi_wwan_ctrl.o
diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
new file mode 100644
index 0000000..abda4b0
--- /dev/null
+++ b/drivers/net/wwan/mhi_wwan_ctrl.c
@@ -0,0 +1,497 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2018-2021, The Linux Foundation. All rights reserved.*/
+
+#include <linux/kernel.h>
+#include <linux/mhi.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/poll.h>
+
+#include "wwan_core.h"
+
+#define MHI_WWAN_CTRL_DRIVER_NAME "mhi_wwan_ctrl"
+#define MHI_WWAN_CTRL_MAX_MINORS 128
+#define MHI_WWAN_MAX_MTU 0x8000
+
+/* MHI wwan device flags */
+#define MHI_WWAN_DL_CAP		BIT(0)
+#define MHI_WWAN_UL_CAP		BIT(1)
+#define MHI_WWAN_CONNECTED	BIT(2)
+
+struct mhi_wwan_buf {
+	struct list_head node;
+	void *data;
+	size_t len;
+	size_t consumed;
+};
+
+struct mhi_wwan_dev {
+	unsigned int minor;
+	size_t mtu;
+
+	/* Lower level is a mhi dev, upper level is wwan port/device */
+	struct mhi_device *mhi_dev;
+	struct wwan_device *wwan_dev;
+	struct wwan_port wwan_port;
+
+	/* Protect against concurrent MHI device accesses (start, stop, open, close) */
+	struct mutex mhi_dev_lock;
+	unsigned int mhi_dev_open_count;
+
+	wait_queue_head_t ul_wq;
+	wait_queue_head_t dl_wq;
+
+	/* Protect download buf queue against concurent update (read/xfer_cb) */
+	spinlock_t dl_queue_lock;
+	struct list_head dl_queue;
+
+	/* For serializing write/queueing to a same MHI channel */
+	struct mutex write_lock;
+
+	unsigned long flags;
+
+	/* kref is used to safely track and release a mhi_wwan_dev instance,
+	 * shared between mhi device probe/remove and user open/close.
+	 */
+	struct kref ref_count;
+};
+
+static void mhi_wwan_ctrl_dev_release(struct kref *ref)
+{
+	struct mhi_wwan_dev *mhiwwan = container_of(ref, struct mhi_wwan_dev, ref_count);
+	struct mhi_wwan_buf *buf_itr, *tmp;
+
+	/* Release non consumed buffers */
+	list_for_each_entry_safe(buf_itr, tmp, &mhiwwan->dl_queue, node) {
+		list_del(&buf_itr->node);
+		kfree(buf_itr->data);
+	}
+
+	mutex_destroy(&mhiwwan->mhi_dev_lock);
+	mutex_destroy(&mhiwwan->write_lock);
+
+	kfree(mhiwwan);
+}
+
+static int mhi_wwan_ctrl_queue_inbound(struct mhi_wwan_dev *mhiwwan)
+{
+	struct mhi_device *mhi_dev = mhiwwan->mhi_dev;
+	struct device *dev = &mhi_dev->dev;
+	int nr_desc, i, ret = -EIO;
+	struct mhi_wwan_buf *ubuf;
+	void *buf;
+
+	/* skip queuing without error if dl channel is not supported. This
+	 * allows open to succeed for udev, supporting ul only channel.
+	 */
+	if (!mhiwwan->mhi_dev->dl_chan)
+		return 0;
+
+	nr_desc = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
+
+	for (i = 0; i < nr_desc; i++) {
+		buf = kmalloc(mhiwwan->mtu + sizeof(*ubuf), GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+
+		/* save mhi_wwan_buf info at the end of buf */
+		ubuf = buf + mhiwwan->mtu;
+		ubuf->data = buf;
+
+		ret = mhi_queue_buf(mhi_dev, DMA_FROM_DEVICE, buf, mhiwwan->mtu, MHI_EOT);
+		if (ret) {
+			kfree(buf);
+			dev_err(dev, "Failed to queue buffer %d\n", i);
+			return ret;
+		}
+	}
+
+	return ret;
+}
+
+static int mhi_wwan_ctrl_open(struct inode *inode, struct file *filp)
+{
+	struct mhi_wwan_dev *mhiwwan = filp->private_data;
+	int ret = 0;
+
+	kref_get(&mhiwwan->ref_count);
+
+	/* Start MHI channel(s) if not yet started and fill RX queue */
+	mutex_lock(&mhiwwan->mhi_dev_lock);
+	if (!mhiwwan->mhi_dev_open_count++) {
+		ret = mhi_prepare_for_transfer(mhiwwan->mhi_dev);
+		if (!ret)
+			ret = mhi_wwan_ctrl_queue_inbound(mhiwwan);
+		if (ret)
+			mhiwwan->mhi_dev_open_count--;
+	}
+	mutex_unlock(&mhiwwan->mhi_dev_lock);
+
+	return ret;
+}
+
+static int mhi_wwan_ctrl_release(struct inode *inode, struct file *file)
+{
+	struct mhi_wwan_dev *mhiwwan = file->private_data;
+
+	/* Stop the channels, if not already destroyed */
+	mutex_lock(&mhiwwan->mhi_dev_lock);
+	if (!(--mhiwwan->mhi_dev_open_count) && mhiwwan->mhi_dev)
+		mhi_unprepare_from_transfer(mhiwwan->mhi_dev);
+	mutex_unlock(&mhiwwan->mhi_dev_lock);
+
+	kref_put(&mhiwwan->ref_count, mhi_wwan_ctrl_dev_release);
+
+	return 0;
+}
+
+static __poll_t mhi_wwan_ctrl_poll(struct file *file, poll_table *wait)
+{
+	struct mhi_wwan_dev *mhiwwan = file->private_data;
+	__poll_t mask = 0;
+
+	poll_wait(file, &mhiwwan->ul_wq, wait);
+	poll_wait(file, &mhiwwan->dl_wq, wait);
+
+	/* Any buffer in the DL queue ? */
+	spin_lock_bh(&mhiwwan->dl_queue_lock);
+	if (!list_empty(&mhiwwan->dl_queue))
+		mask |= EPOLLIN | EPOLLRDNORM;
+	spin_unlock_bh(&mhiwwan->dl_queue_lock);
+
+	/* If MHI queue is not full, write is possible */
+	mutex_lock(&mhiwwan->mhi_dev_lock);
+	if (!mhiwwan->mhi_dev)
+		mask = EPOLLERR | EPOLLHUP;
+	else if (!mhi_queue_is_full(mhiwwan->mhi_dev, DMA_TO_DEVICE))
+		mask |= EPOLLOUT | EPOLLWRNORM;
+	mutex_unlock(&mhiwwan->mhi_dev_lock);
+
+	return mask;
+}
+
+static ssize_t mhi_wwan_ctrl_write(struct file *file, const char __user *buf,
+				   size_t count, loff_t *offp)
+{
+	struct mhi_wwan_dev *mhiwwan = file->private_data;
+	size_t bytes_xfered = 0;
+	void *kbuf = NULL;
+	int ret;
+
+	if (!test_bit(MHI_WWAN_UL_CAP, &mhiwwan->flags))
+		return -EOPNOTSUPP;
+
+	if (!buf || !count)
+		return -EINVAL;
+
+	/* Serialize MHI queueing */
+	if (mutex_lock_interruptible(&mhiwwan->write_lock))
+		return -EINTR;
+
+	while (count) {
+		size_t xfer_size;
+
+		/* Wait for available transfer descriptor */
+		ret = wait_event_interruptible(mhiwwan->ul_wq,
+				!test_bit(MHI_WWAN_CONNECTED, &mhiwwan->flags) ||
+				!mhi_queue_is_full(mhiwwan->mhi_dev, DMA_TO_DEVICE));
+		if (ret)
+			break;
+
+		if (!test_bit(MHI_WWAN_CONNECTED, &mhiwwan->flags)) {
+			ret = -EPIPE;
+			break;
+		}
+
+		xfer_size = min_t(size_t, count, mhiwwan->mtu);
+		kbuf = kmalloc(xfer_size, GFP_KERNEL);
+		if (!kbuf) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		ret = copy_from_user(kbuf, buf, xfer_size);
+		if (ret)
+			break;
+
+		/* Add buffer to MHI queue */
+		ret = mhi_queue_buf(mhiwwan->mhi_dev, DMA_TO_DEVICE, kbuf,
+				    xfer_size, MHI_EOT);
+		if (ret)
+			break;
+
+		bytes_xfered += xfer_size;
+		count -= xfer_size;
+		buf += xfer_size;
+		kbuf = NULL;
+	}
+
+	mutex_unlock(&mhiwwan->write_lock);
+
+	kfree(kbuf);
+
+	return ret ? ret : bytes_xfered;
+}
+
+static int mhi_wwan_ctrl_recycle_ubuf(struct mhi_wwan_dev *mhiwwan,
+				      struct mhi_wwan_buf *ubuf)
+{
+	int ret;
+
+	mutex_lock(&mhiwwan->mhi_dev_lock);
+
+	if (!mhiwwan->mhi_dev) {
+		ret = -ENODEV;
+		goto exit_unlock;
+	}
+
+	ret = mhi_queue_buf(mhiwwan->mhi_dev, DMA_FROM_DEVICE, ubuf->data,
+			    mhiwwan->mtu, MHI_EOT);
+
+exit_unlock:
+	mutex_unlock(&mhiwwan->mhi_dev_lock);
+
+	return ret;
+}
+
+static ssize_t mhi_wwan_ctrl_read(struct file *file, char __user *buf,
+				  size_t count, loff_t *ppos)
+{
+	struct mhi_wwan_dev *mhiwwan = file->private_data;
+	bool recycle_buf = false;
+	struct mhi_wwan_buf *ubuf;
+	size_t copy_len;
+	char *copy_ptr;
+	int ret = 0;
+
+	if (!test_bit(MHI_WWAN_DL_CAP, &mhiwwan->flags))
+		return -EOPNOTSUPP;
+
+	if (!buf)
+		return -EINVAL;
+
+	spin_lock_irq(&mhiwwan->dl_queue_lock);
+
+	/* Wait for at least one buffer in the dl queue (or device removal) */
+	ret = wait_event_interruptible_lock_irq(mhiwwan->dl_wq,
+				!list_empty(&mhiwwan->dl_queue) ||
+				!test_bit(MHI_WWAN_CONNECTED, &mhiwwan->flags),
+				mhiwwan->dl_queue_lock);
+	if (ret) {
+		goto err_unlock;
+	} else if (!test_bit(MHI_WWAN_CONNECTED, &mhiwwan->flags)) {
+		ret = -EPIPE;
+		goto err_unlock;
+	}
+
+	ubuf = list_first_entry_or_null(&mhiwwan->dl_queue, struct mhi_wwan_buf, node);
+	if (!ubuf) {
+		ret = -EIO;
+		goto err_unlock;
+	}
+
+	/* Consume the buffer */
+	copy_len = min_t(size_t, count, ubuf->len - ubuf->consumed);
+	copy_ptr = ubuf->data + ubuf->consumed;
+	ubuf->consumed += copy_len;
+
+	/* Remove buffer from the DL queue if entirely consumed */
+	if (ubuf->consumed == ubuf->len) {
+		list_del(&ubuf->node);
+		recycle_buf = true;
+	}
+
+	spin_unlock_irq(&mhiwwan->dl_queue_lock);
+
+	ret = copy_to_user(buf, copy_ptr, copy_len);
+	if (ret)
+		return -EFAULT;
+
+	if (recycle_buf) {
+		/* Give the buffer back to MHI queue */
+		ret = mhi_wwan_ctrl_recycle_ubuf(mhiwwan, ubuf);
+		if (ret) /* unable to recycle, release */
+			kfree(ubuf->data);
+	}
+
+	return copy_len;
+
+err_unlock:
+	spin_unlock_irq(&mhiwwan->dl_queue_lock);
+
+	return ret;
+}
+
+static const struct file_operations mhidev_fops = {
+	.owner = THIS_MODULE,
+	.open = mhi_wwan_ctrl_open,
+	.release = mhi_wwan_ctrl_release,
+	.read = mhi_wwan_ctrl_read,
+	.write = mhi_wwan_ctrl_write,
+	.poll = mhi_wwan_ctrl_poll,
+};
+
+static void mhi_ul_xfer_cb(struct mhi_device *mhi_dev,
+			   struct mhi_result *mhi_result)
+{
+	struct mhi_wwan_dev *mhiwwan = dev_get_drvdata(&mhi_dev->dev);
+	struct device *dev = &mhi_dev->dev;
+
+	dev_dbg(dev, "%s: status: %d xfer_len: %zu\n", __func__,
+		mhi_result->transaction_status, mhi_result->bytes_xferd);
+
+	kfree(mhi_result->buf_addr);
+
+	/* Some space available in the 'upload' queue, advertise that */
+	if (!mhi_result->transaction_status)
+		wake_up_interruptible(&mhiwwan->ul_wq);
+}
+
+static void mhi_dl_xfer_cb(struct mhi_device *mhi_dev,
+			   struct mhi_result *mhi_result)
+{
+	struct mhi_wwan_dev *mhiwwan = dev_get_drvdata(&mhi_dev->dev);
+	struct mhi_wwan_buf *ubuf;
+
+	dev_dbg(&mhi_dev->dev, "%s: status: %d receive_len: %zu\n", __func__,
+		mhi_result->transaction_status, mhi_result->bytes_xferd);
+
+	if (mhi_result->transaction_status &&
+	    mhi_result->transaction_status != -EOVERFLOW) {
+		kfree(mhi_result->buf_addr);
+		return;
+	}
+
+	/* ubuf is placed at the end of the buffer (cf mhi_wwan_ctrl_queue_inbound) */
+	ubuf = mhi_result->buf_addr + mhiwwan->mtu;
+
+	/* paranoia, should never happen */
+	if (WARN_ON(mhi_result->buf_addr != ubuf->data)) {
+		kfree(mhi_result->buf_addr);
+		return;
+	}
+
+	ubuf->data = mhi_result->buf_addr;
+	ubuf->len = mhi_result->bytes_xferd;
+	ubuf->consumed = 0;
+
+	spin_lock_bh(&mhiwwan->dl_queue_lock);
+	list_add_tail(&ubuf->node, &mhiwwan->dl_queue);
+	spin_unlock_bh(&mhiwwan->dl_queue_lock);
+
+	wake_up_interruptible(&mhiwwan->dl_wq);
+}
+
+static int mhi_wwan_ctrl_probe(struct mhi_device *mhi_dev,
+			       const struct mhi_device_id *id)
+{
+	struct mhi_controller *cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_wwan_dev *mhiwwan;
+	struct wwan_device *wwan_dev;
+	int err;
+
+	/* Create mhi_wwan data context */
+	mhiwwan = kzalloc(sizeof(*mhiwwan), GFP_KERNEL);
+	if (!mhiwwan)
+		return -ENOMEM;
+
+	/* Create a WWAN device, use mhi controller as parent device which
+	 * represent the modem instance.
+	 */
+	wwan_dev = wwan_create_dev(&cntrl->mhi_dev->dev);
+	if (!wwan_dev) {
+		err = -ENOMEM;
+		goto err_free_mhiwwan;
+	}
+
+	/* Init mhi_wwan data */
+	kref_init(&mhiwwan->ref_count);
+	mutex_init(&mhiwwan->mhi_dev_lock);
+	mutex_init(&mhiwwan->write_lock);
+	init_waitqueue_head(&mhiwwan->ul_wq);
+	init_waitqueue_head(&mhiwwan->dl_wq);
+	spin_lock_init(&mhiwwan->dl_queue_lock);
+	INIT_LIST_HEAD(&mhiwwan->dl_queue);
+	mhiwwan->mhi_dev = mhi_dev;
+	mhiwwan->wwan_dev = wwan_dev;
+	mhiwwan->mtu = MHI_WWAN_MAX_MTU;
+	set_bit(MHI_WWAN_CONNECTED, &mhiwwan->flags);
+
+	if (mhi_dev->dl_chan)
+		set_bit(MHI_WWAN_DL_CAP, &mhiwwan->flags);
+	if (mhi_dev->ul_chan)
+		set_bit(MHI_WWAN_UL_CAP, &mhiwwan->flags);
+
+	dev_set_drvdata(&mhi_dev->dev, mhiwwan);
+
+	/* Register as cdev port */
+	mhiwwan->wwan_port.wwandev = wwan_dev;
+	mhiwwan->wwan_port.fops = &mhidev_fops;
+	mhiwwan->wwan_port.type = id->driver_data;
+	mhiwwan->wwan_port.private_data = mhiwwan;
+	err = wwan_add_port(&mhiwwan->wwan_port);
+	if (err)
+		goto err_destroy_wwan;
+
+	return 0;
+
+err_destroy_wwan:
+	wwan_destroy_dev(wwan_dev);
+err_free_mhiwwan:
+	kfree(mhiwwan);
+	dev_set_drvdata(&mhi_dev->dev, NULL);
+
+	return err;
+};
+
+static void mhi_wwan_ctrl_remove(struct mhi_device *mhi_dev)
+{
+	struct mhi_wwan_dev *mhiwwan = dev_get_drvdata(&mhi_dev->dev);
+
+	dev_set_drvdata(&mhi_dev->dev, NULL);
+
+	clear_bit(MHI_WWAN_CONNECTED, &mhiwwan->flags);
+
+	/* remove wwan port and device */
+	wwan_remove_port(&mhiwwan->wwan_port);
+	wwan_destroy_dev(mhiwwan->wwan_dev);
+
+	/* Unlink mhi_dev from mhi_wwan_dev */
+	mutex_lock(&mhiwwan->mhi_dev_lock);
+	mhiwwan->mhi_dev = NULL;
+	mutex_unlock(&mhiwwan->mhi_dev_lock);
+
+	/* wake up any blocked user */
+	wake_up_interruptible(&mhiwwan->dl_wq);
+	wake_up_interruptible(&mhiwwan->ul_wq);
+
+	kref_put(&mhiwwan->ref_count, mhi_wwan_ctrl_dev_release);
+}
+
+static const struct mhi_device_id mhi_wwan_ctrl_match_table[] = {
+	{ .chan = "DUN", .driver_data = WWAN_PORT_AT },
+	{ .chan = "MBIM", .driver_data = WWAN_PORT_MBIM },
+	{ .chan = "QMI", .driver_data = WWAN_PORT_QMI },
+	{ .chan = "DIAG", .driver_data = WWAN_PORT_QCDM },
+	{ .chan = "FIREHOSE", .driver_data = WWAN_PORT_FIREHOSE },
+	{},
+};
+MODULE_DEVICE_TABLE(mhi, mhi_wwan_ctrl_match_table);
+
+static struct mhi_driver mhi_wwan_ctrl_driver = {
+	.id_table = mhi_wwan_ctrl_match_table,
+	.remove = mhi_wwan_ctrl_remove,
+	.probe = mhi_wwan_ctrl_probe,
+	.ul_xfer_cb = mhi_ul_xfer_cb,
+	.dl_xfer_cb = mhi_dl_xfer_cb,
+	.driver = {
+		.name = MHI_WWAN_CTRL_DRIVER_NAME,
+	},
+};
+
+module_mhi_driver(mhi_wwan_ctrl_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("MHI WWAN CTRL Driver");
+MODULE_AUTHOR("Hemant Kumar <hemantk@codeaurora.org>");
+MODULE_AUTHOR("Loic Poulain <loic.poulain@linaro.org>");
-- 
2.7.4

