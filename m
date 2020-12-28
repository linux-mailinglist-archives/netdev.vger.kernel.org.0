Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAAC2E3592
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 10:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgL1Jpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 04:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgL1Jpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 04:45:42 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C89C061799;
        Mon, 28 Dec 2020 01:45:17 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z12so5682336pjn.1;
        Mon, 28 Dec 2020 01:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=30hSn2ojDUos0AGlQddFlkdm7fB6sMhemL+O1EPHpA4=;
        b=bjq1jougxrQgctmL9z3hJAdry4/TvISvPQ17j37+UBgpZIea0KfgDu91m/TM6ADHsu
         vLQB/Fl7UK+6YeK0/E1FXk+GtmZNpqtlf9o3coDOEOFIhkgf0Q2UPHnGcGUUzvoTfsbD
         6Bes2FNTtciJChh23OXsr65wtMMM00bO+31Q7gYWvgg4GhPpF1ZDfeKQKWJVkZTSHo2N
         um88RcTBzyOdZgtQrAUn1YYbuUpvB6gKvz4tuTKu3kpzjCiIvlb2CTNn/Kz5tEWpSuzB
         R81jxucfERB8D1B1q/D2nQc5zVwOrQtPBrx0G3EV9cuDeJkBoZIQw5RHXttcfNOiNfa/
         jjEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=30hSn2ojDUos0AGlQddFlkdm7fB6sMhemL+O1EPHpA4=;
        b=jyMrpZXbHJkk+0UOkWCpyU/JzVo43rXT3+Xm5V8gNQk392VKER7PcXAEXEzFDS3KoU
         0hgP34c0qhoq00vugG7gB1ugmAeK4YW57H4Jx6iP1eHgvkBkD8lm8+OP/M5Ff0FSxsbF
         5NtNs8lqg+Vyh/zU9R01P9Mnc3AcxujuAVu+5lhJ7LD2fXRwaG4xlT2jigaMX7CnUQ7L
         XIN5GDnMpJrDXsC+UTIQEXOLk7bmNQaWaXXr6wuD2mwFw+Xjzk4KL27aN/daiISAyY8I
         hliZ4RKaT9z1MF7xwhT5OdLdWDyuYJkJl/Be+QbBQXqzLxf+d5uHN69Wi06xq0RuTr+P
         aD8g==
X-Gm-Message-State: AOAM533kH2iRqIMj9ckBVvOaURBrWHD84zxbNgPGDTHzQxSPGBsHMg+v
        0NS/gGcJVvD1eNRDFRgZF72PPb2c18I=
X-Google-Smtp-Source: ABdhPJxvSlDcm3y/ovASFwIA7wEW/17BWJpiBqqnD6AeUEvTDDoRMaLqh0hzMnaSYZM4ZbXsB2XQVA==
X-Received: by 2002:a17:902:7e85:b029:da:726a:3a4f with SMTP id z5-20020a1709027e85b02900da726a3a4fmr23178236pla.65.1609148716911;
        Mon, 28 Dec 2020 01:45:16 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id l13sm39737019pgq.51.2020.12.28.01.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 01:45:16 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next] nfc: Add a virtual nci device driver
Date:   Mon, 28 Dec 2020 18:45:07 +0900
Message-Id: <20201228094507.32141-1-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

A NCI virtual device can be made to simulate a NCI device in user space.
Using the virtual NCI device, The NCI module and application can be
validated. This driver supports to communicate between the virtual NCI
device and NCI module.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 MAINTAINERS                  |   7 ++
 drivers/nfc/Kconfig          |  11 ++
 drivers/nfc/Makefile         |   1 +
 drivers/nfc/virtual_ncidev.c | 216 +++++++++++++++++++++++++++++++++++
 4 files changed, 235 insertions(+)
 create mode 100644 drivers/nfc/virtual_ncidev.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a355db292486..6479a4754a1e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12431,6 +12431,13 @@ F:	include/net/nfc/
 F:	include/uapi/linux/nfc.h
 F:	net/nfc/
 
+NFC VIRTUAL NCI DEVICE DRIVER
+M:	Bongsu Jeon <bongsu.jeon@samsung.com>
+L:	netdev@vger.kernel.org
+L:	linux-nfc@lists.01.org (moderated for non-subscribers)
+S:	Supported
+F:	drivers/nfc/virtual_ncidev.c
+
 NFS, SUNRPC, AND LOCKD CLIENTS
 M:	Trond Myklebust <trond.myklebust@hammerspace.com>
 M:	Anna Schumaker <anna.schumaker@netapp.com>
diff --git a/drivers/nfc/Kconfig b/drivers/nfc/Kconfig
index 75c65d339018..d32c3a8937ed 100644
--- a/drivers/nfc/Kconfig
+++ b/drivers/nfc/Kconfig
@@ -49,6 +49,17 @@ config NFC_PORT100
 
 	  If unsure, say N.
 
+config NFC_VIRTUAL_NCI
+	tristate "NCI device simulator driver"
+	depends on NFC_NCI
+	help
+	  A NCI virtual device can be made to simulate a NCI device in user
+	  level. Using the virtual NCI device, The NCI module and application
+	  can be validated. This driver supports to communicate between the
+	  virtual NCI device and NCI module.
+
+	  If unsure, say N.
+
 source "drivers/nfc/fdp/Kconfig"
 source "drivers/nfc/pn544/Kconfig"
 source "drivers/nfc/pn533/Kconfig"
diff --git a/drivers/nfc/Makefile b/drivers/nfc/Makefile
index 5393ba59b17d..7b1bfde1d971 100644
--- a/drivers/nfc/Makefile
+++ b/drivers/nfc/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_NFC_ST_NCI)	+= st-nci/
 obj-$(CONFIG_NFC_NXP_NCI)	+= nxp-nci/
 obj-$(CONFIG_NFC_S3FWRN5)	+= s3fwrn5/
 obj-$(CONFIG_NFC_ST95HF)	+= st95hf/
+obj-$(CONFIG_NFC_VIRTUAL_NCI)	+= virtual_ncidev.o
diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
new file mode 100644
index 000000000000..163d0b2dda2e
--- /dev/null
+++ b/drivers/nfc/virtual_ncidev.c
@@ -0,0 +1,216 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Virtual NCI device simulation driver
+ *
+ * Copyright (C) 2020 Samsung Electrnoics
+ * Bongsu Jeon <bongsu.jeon@samsung.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/mutex.h>
+#include <net/nfc/nci_core.h>
+
+enum virtual_ncidev_mode {
+	virtual_ncidev_enabled,
+	virtual_ncidev_disabled,
+	virtual_ncidev_disabling,
+};
+
+#define VIRTUAL_NFC_PROTOCOLS	(NFC_PROTO_JEWEL_MASK | \
+				 NFC_PROTO_MIFARE_MASK | \
+				 NFC_PROTO_FELICA_MASK | \
+				 NFC_PROTO_ISO14443_MASK | \
+				 NFC_PROTO_ISO14443_B_MASK | \
+				 NFC_PROTO_ISO15693_MASK)
+
+static enum virtual_ncidev_mode state;
+static struct mutex nci_send_mutex;
+static struct miscdevice miscdev;
+static struct sk_buff *send_buff;
+static struct mutex nci_mutex;
+static struct nci_dev *ndev;
+static bool full_txbuff;
+
+static bool virtual_ncidev_check_enabled(void)
+{
+	bool ret = true;
+
+	mutex_lock(&nci_mutex);
+	if (state != virtual_ncidev_enabled)
+		ret = false;
+	mutex_unlock(&nci_mutex);
+
+	return ret;
+}
+
+static int virtual_nci_open(struct nci_dev *ndev)
+{
+	return 0;
+}
+
+static int virtual_nci_close(struct nci_dev *ndev)
+{
+	mutex_lock(&nci_send_mutex);
+	if (full_txbuff)
+		kfree_skb(send_buff);
+	full_txbuff = false;
+	mutex_unlock(&nci_send_mutex);
+
+	return 0;
+}
+
+static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
+{
+	if (virtual_ncidev_check_enabled() == false)
+		return 0;
+
+	mutex_lock(&nci_send_mutex);
+	if (full_txbuff) {
+		mutex_unlock(&nci_send_mutex);
+		return -1;
+	}
+	send_buff = skb_copy(skb, GFP_KERNEL);
+	full_txbuff = true;
+	mutex_unlock(&nci_send_mutex);
+
+	return 0;
+}
+
+static struct nci_ops virtual_nci_ops = {
+	.open = virtual_nci_open,
+	.close = virtual_nci_close,
+	.send = virtual_nci_send
+};
+
+static ssize_t virtual_ncidev_read(struct file *file, char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	size_t actual_len;
+
+	mutex_lock(&nci_send_mutex);
+	if (!full_txbuff) {
+		mutex_unlock(&nci_send_mutex);
+		return 0;
+	}
+
+	actual_len = count > send_buff->len ? send_buff->len : count;
+
+	if (copy_to_user(buf, send_buff->data, actual_len)) {
+		mutex_unlock(&nci_send_mutex);
+		return -EFAULT;
+	}
+
+	skb_pull(send_buff, actual_len);
+	if (send_buff->len == 0) {
+		kfree_skb(send_buff);
+		full_txbuff = false;
+	}
+	mutex_unlock(&nci_send_mutex);
+
+	return actual_len;
+}
+
+static ssize_t virtual_ncidev_write(struct file *file,
+				    const char __user *buf,
+				    size_t count, loff_t *ppos)
+{
+	struct sk_buff *skb;
+
+	skb = alloc_skb(count, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	if (copy_from_user(skb_put(skb, count), buf, count))
+		return -EFAULT;
+
+	nci_recv_frame(ndev, skb);
+
+	return count;
+}
+
+static int virtual_ncidev_open(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+
+	mutex_lock(&nci_mutex);
+	if (state != virtual_ncidev_disabled) {
+		mutex_unlock(&nci_mutex);
+		return -EBUSY;
+	}
+
+	mutex_init(&nci_send_mutex);
+
+	ndev = nci_allocate_device(&virtual_nci_ops, VIRTUAL_NFC_PROTOCOLS,
+				   0, 0);
+	if (!ndev) {
+		mutex_unlock(&nci_mutex);
+		return -ENOMEM;
+	}
+
+	ret = nci_register_device(ndev);
+	if (ret < 0) {
+		nci_free_device(ndev);
+		mutex_unlock(&nci_mutex);
+		return ret;
+	}
+	state = virtual_ncidev_enabled;
+	mutex_unlock(&nci_mutex);
+
+	return 0;
+}
+
+static int virtual_ncidev_close(struct inode *inode, struct file *file)
+{
+	mutex_lock(&nci_mutex);
+
+	if (state == virtual_ncidev_enabled) {
+		state = virtual_ncidev_disabling;
+		mutex_unlock(&nci_mutex);
+
+		nci_unregister_device(ndev);
+		nci_free_device(ndev);
+
+		mutex_lock(&nci_mutex);
+	}
+
+	state = virtual_ncidev_disabled;
+	mutex_unlock(&nci_mutex);
+
+	return 0;
+}
+
+static const struct file_operations virtual_ncidev_fops = {
+	.owner = THIS_MODULE,
+	.read = virtual_ncidev_read,
+	.write = virtual_ncidev_write,
+	.open = virtual_ncidev_open,
+	.release = virtual_ncidev_close,
+};
+
+static int __init virtual_ncidev_init(void)
+{
+	int ret;
+
+	mutex_init(&nci_mutex);
+	state = virtual_ncidev_disabled;
+	miscdev.minor = MISC_DYNAMIC_MINOR;
+	miscdev.name = "virtual_nci";
+	miscdev.fops = &virtual_ncidev_fops;
+	ret = misc_register(&miscdev);
+
+	return ret;
+}
+
+static void __exit virtual_ncidev_exit(void)
+{
+	misc_deregister(&miscdev);
+}
+
+module_init(virtual_ncidev_init);
+module_exit(virtual_ncidev_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Virtual NCI device simulation driver");
+MODULE_AUTHOR("Bongsu Jeon <bongsu.jeon@samsung.com>");
-- 
2.17.1

