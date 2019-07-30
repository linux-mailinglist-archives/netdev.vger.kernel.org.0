Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D576A7B3BE
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 21:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfG3T7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 15:59:37 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:50821 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfG3T7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 15:59:35 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MlNYj-1idxpR0fT3-00lq2h; Tue, 30 Jul 2019 21:58:28 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Sterba <dsterba@suse.com>,
        Darren Hart <dvhart@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-scsi@vger.kernel.org, tee-dev@lists.linaro.org,
        linux-usb@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v5 13/29] compat_ioctl: move more drivers to compat_ptr_ioctl
Date:   Tue, 30 Jul 2019 21:55:29 +0200
Message-Id: <20190730195819.901457-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190730192552.4014288-1-arnd@arndb.de>
References: <20190730192552.4014288-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:KQUqUqBgZXK84qipVJwaeqta//BlZhUjlVWQ5Gx//kuw9hhHom8
 X+1H8bc6fzWCwnWDRAE4IJ3pqdqmFI3hhOZFIpQFMbg9gyruWUhxE6KFC+H52nGdYOCuJgE
 FKLOChgo9hQtnYOaprg+VGYMmTiFvwkWA5fW1ZGm6hb16OHoOzesgwVKD/9dMT+ax04tubE
 etPGFMERNQ4wf+OqoWwIQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:paNFdAJVA1A=:nLjMCmfOZGXU5MF7JvwZU6
 Nnqyunyf4/CyR9xuZwFf7zvbqFyHrkVgk1Akfs/OQ1g/iRTHv74b3NA0DnQryIdxTjbxXXtaL
 iRvHpoipq3Rm3k2yHEbuaVPYNzOOr2SN6k7riGfXVCOfflpilpv/1wU7i41xt+RVozeL5g9Sg
 1OBjQUkPWbIGhIah3rsbiFVQnCzg6GDHuG1ksrEcDAzmegRVmW5zLaahJIPiZVviqdDwvhDpn
 1sG3LaPmgNeA3TjSpVtTnePeaWcHnEn3bB+WH9D039hb4gBkR4hG4FyycnlXQR9S7Z8uW+fTc
 mtlIwaDMS33l7jW3K3CptcsT8cswSkKYZfrXlW4ZNq35+/VvXKKozJswZ76X3sTpnTKYaTndl
 U0iyypM3IywuwkVuV86/BmjG5VxoA58l/8DmU1U9VVcsDqUZcPn0dm4rg+PL4alFr5Bz8E4Ag
 WayuofUXsUWjjEh32+lIjnSsGuNuJlEXGbYIRKCHEN/g/k5avBCvaP/bqyHsvFd37nLRmxn1v
 X5xxVl7LjzK+qiIK1CCMbYqDwZkQ6PZAGmzWi+KBdIAerncTu8BI+m26N54CJoXm95j86kbQ7
 wUoOj/9Fp/j4w1cwarz103GZ43NE1WoeGcwlEQetDcpqNq3xoimerHYq2Md3HhIILTtaViFY4
 br5IvxSQMOuW3BQbqWgEWIILZQxRCp2AsfF5cqqpUFIpZknFefc50+GU8Hs8L2daqPUMWNuKW
 S9jKx+nC+h5UXPwXazQBr06LHtMv0/cW6nxI9g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The .ioctl and .compat_ioctl file operations have the same prototype so
they can both point to the same function, which works great almost all
the time when all the commands are compatible.

One exception is the s390 architecture, where a compat pointer is only
31 bit wide, and converting it into a 64-bit pointer requires calling
compat_ptr(). Most drivers here will never run in s390, but since we now
have a generic helper for it, it's easy enough to use it consistently.

I double-checked all these drivers to ensure that all ioctl arguments
are used as pointers or are ignored, but are not interpreted as integer
values.

Acked-by: Jason Gunthorpe <jgg@mellanox.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: David Sterba <dsterba@suse.com>
Acked-by: Darren Hart (VMware) <dvhart@infradead.org>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/android/binder.c                    | 2 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c | 2 +-
 drivers/dma-buf/dma-buf.c                   | 4 +---
 drivers/dma-buf/sw_sync.c                   | 2 +-
 drivers/dma-buf/sync_file.c                 | 2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c    | 2 +-
 drivers/hid/hidraw.c                        | 4 +---
 drivers/iio/industrialio-core.c             | 2 +-
 drivers/infiniband/core/uverbs_main.c       | 4 ++--
 drivers/media/rc/lirc_dev.c                 | 4 +---
 drivers/mfd/cros_ec_dev.c                   | 4 +---
 drivers/misc/vmw_vmci/vmci_host.c           | 2 +-
 drivers/nvdimm/bus.c                        | 4 ++--
 drivers/nvme/host/core.c                    | 2 +-
 drivers/pci/switch/switchtec.c              | 2 +-
 drivers/platform/x86/wmi.c                  | 2 +-
 drivers/rpmsg/rpmsg_char.c                  | 4 ++--
 drivers/sbus/char/display7seg.c             | 2 +-
 drivers/sbus/char/envctrl.c                 | 4 +---
 drivers/scsi/3w-xxxx.c                      | 4 +---
 drivers/scsi/cxlflash/main.c                | 2 +-
 drivers/scsi/esas2r/esas2r_main.c           | 2 +-
 drivers/scsi/pmcraid.c                      | 4 +---
 drivers/staging/android/ion/ion.c           | 4 +---
 drivers/staging/vme/devices/vme_user.c      | 2 +-
 drivers/tee/tee_core.c                      | 2 +-
 drivers/usb/class/cdc-wdm.c                 | 2 +-
 drivers/usb/class/usbtmc.c                  | 4 +---
 drivers/virt/fsl_hypervisor.c               | 2 +-
 fs/btrfs/super.c                            | 2 +-
 fs/fuse/dev.c                               | 2 +-
 fs/notify/fanotify/fanotify_user.c          | 2 +-
 fs/userfaultfd.c                            | 2 +-
 net/rfkill/core.c                           | 2 +-
 34 files changed, 37 insertions(+), 55 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index dc1c83eafc22..79955e82544a 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -6043,7 +6043,7 @@ const struct file_operations binder_fops = {
 	.owner = THIS_MODULE,
 	.poll = binder_poll,
 	.unlocked_ioctl = binder_ioctl,
-	.compat_ioctl = binder_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 	.mmap = binder_mmap,
 	.open = binder_open,
 	.flush = binder_flush,
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index abc7a7f64d64..ef0e482ee04f 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -68,7 +68,7 @@ static long adf_ctl_ioctl(struct file *fp, unsigned int cmd, unsigned long arg);
 static const struct file_operations adf_ctl_ops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = adf_ctl_ioctl,
-	.compat_ioctl = adf_ctl_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 };
 
 struct adf_ctl_drv_info {
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index f45bfb29ef96..f6d9047b7a69 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -415,9 +415,7 @@ static const struct file_operations dma_buf_fops = {
 	.llseek		= dma_buf_llseek,
 	.poll		= dma_buf_poll,
 	.unlocked_ioctl	= dma_buf_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= dma_buf_ioctl,
-#endif
+	.compat_ioctl	= compat_ptr_ioctl,
 	.show_fdinfo	= dma_buf_show_fdinfo,
 };
 
diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 051f6c2873c7..51026cb08801 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -410,5 +410,5 @@ const struct file_operations sw_sync_debugfs_fops = {
 	.open           = sw_sync_debugfs_open,
 	.release        = sw_sync_debugfs_release,
 	.unlocked_ioctl = sw_sync_ioctl,
-	.compat_ioctl	= sw_sync_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
 };
diff --git a/drivers/dma-buf/sync_file.c b/drivers/dma-buf/sync_file.c
index ee4d1a96d779..85b96757fc76 100644
--- a/drivers/dma-buf/sync_file.c
+++ b/drivers/dma-buf/sync_file.c
@@ -480,5 +480,5 @@ static const struct file_operations sync_file_fops = {
 	.release = sync_file_release,
 	.poll = sync_file_poll,
 	.unlocked_ioctl = sync_file_ioctl,
-	.compat_ioctl = sync_file_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 };
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 26b15cc56c31..ea933d2444bb 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -49,7 +49,7 @@ static const char kfd_dev_name[] = "kfd";
 static const struct file_operations kfd_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = kfd_ioctl,
-	.compat_ioctl = kfd_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 	.open = kfd_open,
 	.mmap = kfd_mmap,
 };
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 006bd6f4f653..923edc650f46 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -468,9 +468,7 @@ static const struct file_operations hidraw_ops = {
 	.release =      hidraw_release,
 	.unlocked_ioctl = hidraw_ioctl,
 	.fasync =	hidraw_fasync,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl   = hidraw_ioctl,
-#endif
+	.compat_ioctl   = compat_ptr_ioctl,
 	.llseek =	noop_llseek,
 };
 
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 524a686077ca..9dd687534035 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1610,7 +1610,7 @@ static const struct file_operations iio_buffer_fileops = {
 	.owner = THIS_MODULE,
 	.llseek = noop_llseek,
 	.unlocked_ioctl = iio_ioctl,
-	.compat_ioctl = iio_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 };
 
 static int iio_check_unique_scan_index(struct iio_dev *indio_dev)
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 11c13c1381cf..d6d2f6c0cd01 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -1135,7 +1135,7 @@ static const struct file_operations uverbs_fops = {
 	.release = ib_uverbs_close,
 	.llseek	 = no_llseek,
 	.unlocked_ioctl = ib_uverbs_ioctl,
-	.compat_ioctl = ib_uverbs_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 };
 
 static const struct file_operations uverbs_mmap_fops = {
@@ -1146,7 +1146,7 @@ static const struct file_operations uverbs_mmap_fops = {
 	.release = ib_uverbs_close,
 	.llseek	 = no_llseek,
 	.unlocked_ioctl = ib_uverbs_ioctl,
-	.compat_ioctl = ib_uverbs_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 };
 
 static int ib_uverbs_get_nl_info(struct ib_device *ibdev, void *client_data,
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index f078f8a3aec8..9a8c1cf54ac4 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -720,9 +720,7 @@ static const struct file_operations lirc_fops = {
 	.owner		= THIS_MODULE,
 	.write		= ir_lirc_transmit_ir,
 	.unlocked_ioctl	= ir_lirc_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= ir_lirc_ioctl,
-#endif
+	.compat_ioctl	= compat_ptr_ioctl,
 	.read		= ir_lirc_read,
 	.poll		= ir_lirc_poll,
 	.open		= ir_lirc_open,
diff --git a/drivers/mfd/cros_ec_dev.c b/drivers/mfd/cros_ec_dev.c
index 41dccced5026..db1eefcd770b 100644
--- a/drivers/mfd/cros_ec_dev.c
+++ b/drivers/mfd/cros_ec_dev.c
@@ -239,9 +239,7 @@ static const struct file_operations fops = {
 	.release = ec_device_release,
 	.read = ec_device_read,
 	.unlocked_ioctl = ec_device_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl = ec_device_ioctl,
-#endif
+	.compat_ioctl = compat_ptr_ioctl,
 };
 
 static void cros_ec_class_release(struct device *dev)
diff --git a/drivers/misc/vmw_vmci/vmci_host.c b/drivers/misc/vmw_vmci/vmci_host.c
index 833e2bd248a5..903e321e8e87 100644
--- a/drivers/misc/vmw_vmci/vmci_host.c
+++ b/drivers/misc/vmw_vmci/vmci_host.c
@@ -961,7 +961,7 @@ static const struct file_operations vmuser_fops = {
 	.release	= vmci_host_close,
 	.poll		= vmci_host_poll,
 	.unlocked_ioctl	= vmci_host_unlocked_ioctl,
-	.compat_ioctl	= vmci_host_unlocked_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
 };
 
 static struct miscdevice vmci_host_miscdev = {
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 798c5c4aea9c..6ca142d833ab 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -1229,7 +1229,7 @@ static const struct file_operations nvdimm_bus_fops = {
 	.owner = THIS_MODULE,
 	.open = nd_open,
 	.unlocked_ioctl = bus_ioctl,
-	.compat_ioctl = bus_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 	.llseek = noop_llseek,
 };
 
@@ -1237,7 +1237,7 @@ static const struct file_operations nvdimm_fops = {
 	.owner = THIS_MODULE,
 	.open = nd_open,
 	.unlocked_ioctl = dimm_ioctl,
-	.compat_ioctl = dimm_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 	.llseek = noop_llseek,
 };
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 8f3fbe5ca937..be07bd1f6654 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2813,7 +2813,7 @@ static const struct file_operations nvme_dev_fops = {
 	.owner		= THIS_MODULE,
 	.open		= nvme_dev_open,
 	.unlocked_ioctl	= nvme_dev_ioctl,
-	.compat_ioctl	= nvme_dev_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
 };
 
 static ssize_t nvme_sysfs_reset(struct device *dev,
diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index 8c94cd3fd1f2..66610f04d76d 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -1025,7 +1025,7 @@ static const struct file_operations switchtec_fops = {
 	.read = switchtec_dev_read,
 	.poll = switchtec_dev_poll,
 	.unlocked_ioctl = switchtec_dev_ioctl,
-	.compat_ioctl = switchtec_dev_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 };
 
 static void link_event_work(struct work_struct *work)
diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 784cea8572c2..d9a0dd94ee62 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -913,7 +913,7 @@ static const struct file_operations wmi_fops = {
 	.read		= wmi_char_read,
 	.open		= wmi_char_open,
 	.unlocked_ioctl	= wmi_ioctl,
-	.compat_ioctl	= wmi_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
 };
 
 static int wmi_dev_probe(struct device *dev)
diff --git a/drivers/rpmsg/rpmsg_char.c b/drivers/rpmsg/rpmsg_char.c
index eea5ebbb5119..507bfe163883 100644
--- a/drivers/rpmsg/rpmsg_char.c
+++ b/drivers/rpmsg/rpmsg_char.c
@@ -290,7 +290,7 @@ static const struct file_operations rpmsg_eptdev_fops = {
 	.write_iter = rpmsg_eptdev_write_iter,
 	.poll = rpmsg_eptdev_poll,
 	.unlocked_ioctl = rpmsg_eptdev_ioctl,
-	.compat_ioctl = rpmsg_eptdev_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 };
 
 static ssize_t name_show(struct device *dev, struct device_attribute *attr,
@@ -451,7 +451,7 @@ static const struct file_operations rpmsg_ctrldev_fops = {
 	.open = rpmsg_ctrldev_open,
 	.release = rpmsg_ctrldev_release,
 	.unlocked_ioctl = rpmsg_ctrldev_ioctl,
-	.compat_ioctl = rpmsg_ctrldev_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 };
 
 static void rpmsg_ctrldev_release_device(struct device *dev)
diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index 971fe074d7c9..fad936eb845f 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -156,7 +156,7 @@ static long d7s_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 static const struct file_operations d7s_fops = {
 	.owner =		THIS_MODULE,
 	.unlocked_ioctl =	d7s_ioctl,
-	.compat_ioctl =		d7s_ioctl,
+	.compat_ioctl =		compat_ptr_ioctl,
 	.open =			d7s_open,
 	.release =		d7s_release,
 	.llseek = noop_llseek,
diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
index a63d5e402ff2..12d66aa61ede 100644
--- a/drivers/sbus/char/envctrl.c
+++ b/drivers/sbus/char/envctrl.c
@@ -715,9 +715,7 @@ static const struct file_operations envctrl_fops = {
 	.owner =		THIS_MODULE,
 	.read =			envctrl_read,
 	.unlocked_ioctl =	envctrl_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl =		envctrl_ioctl,
-#endif
+	.compat_ioctl =		compat_ptr_ioctl,
 	.open =			envctrl_open,
 	.release =		envctrl_release,
 	.llseek =		noop_llseek,
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 2b1e0d503020..fb6444d0409c 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1049,9 +1049,7 @@ static int tw_chrdev_open(struct inode *inode, struct file *file)
 static const struct file_operations tw_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= tw_chrdev_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl   = tw_chrdev_ioctl,
-#endif
+	.compat_ioctl   = compat_ptr_ioctl,
 	.open		= tw_chrdev_open,
 	.release	= NULL,
 	.llseek		= noop_llseek,
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index b1f4724efde2..6927654792b0 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -3585,7 +3585,7 @@ static const struct file_operations cxlflash_chr_fops = {
 	.owner          = THIS_MODULE,
 	.open           = cxlflash_chr_open,
 	.unlocked_ioctl	= cxlflash_chr_ioctl,
-	.compat_ioctl	= cxlflash_chr_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
 };
 
 /**
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index fdbda5c05aa0..80c5a235d193 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -613,7 +613,7 @@ static int __init esas2r_init(void)
 
 /* Handle ioctl calls to "/proc/scsi/esas2r/ATTOnode" */
 static const struct file_operations esas2r_proc_fops = {
-	.compat_ioctl	= esas2r_proc_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
 	.unlocked_ioctl = esas2r_proc_ioctl,
 };
 
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 71ff3936da4f..12c4487cb9f6 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3973,9 +3973,7 @@ static const struct file_operations pmcraid_fops = {
 	.open = pmcraid_chr_open,
 	.fasync = pmcraid_chr_fasync,
 	.unlocked_ioctl = pmcraid_chr_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl = pmcraid_chr_ioctl,
-#endif
+	.compat_ioctl = compat_ptr_ioctl,
 	.llseek = noop_llseek,
 };
 
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 92c2914239e3..1663c163edca 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -567,9 +567,7 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 static const struct file_operations ion_fops = {
 	.owner          = THIS_MODULE,
 	.unlocked_ioctl = ion_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= ion_ioctl,
-#endif
+	.compat_ioctl	= compat_ptr_ioctl,
 };
 
 static int debug_shrink_set(void *data, u64 val)
diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 6a33aaa1a49f..fd0ea4dbcb91 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -494,7 +494,7 @@ static const struct file_operations vme_user_fops = {
 	.write = vme_user_write,
 	.llseek = vme_user_llseek,
 	.unlocked_ioctl = vme_user_unlocked_ioctl,
-	.compat_ioctl = vme_user_unlocked_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 	.mmap = vme_user_mmap,
 };
 
diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index 0f16d9ffd8d1..37d22e39fd8d 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -675,7 +675,7 @@ static const struct file_operations tee_fops = {
 	.open = tee_open,
 	.release = tee_release,
 	.unlocked_ioctl = tee_ioctl,
-	.compat_ioctl = tee_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 };
 
 static void tee_release_device(struct device *dev)
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index a7824a51f86d..3234dc539873 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -724,7 +724,7 @@ static const struct file_operations wdm_fops = {
 	.release =	wdm_release,
 	.poll =		wdm_poll,
 	.unlocked_ioctl = wdm_ioctl,
-	.compat_ioctl = wdm_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 	.llseek =	noop_llseek,
 };
 
diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 4942122b2346..bbd0308b13f5 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -2220,9 +2220,7 @@ static const struct file_operations fops = {
 	.release	= usbtmc_release,
 	.flush		= usbtmc_flush,
 	.unlocked_ioctl	= usbtmc_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= usbtmc_ioctl,
-#endif
+	.compat_ioctl	= compat_ptr_ioctl,
 	.fasync         = usbtmc_fasync,
 	.poll           = usbtmc_poll,
 	.llseek		= default_llseek,
diff --git a/drivers/virt/fsl_hypervisor.c b/drivers/virt/fsl_hypervisor.c
index 93d5bebf9572..1b0b11b55d2a 100644
--- a/drivers/virt/fsl_hypervisor.c
+++ b/drivers/virt/fsl_hypervisor.c
@@ -706,7 +706,7 @@ static const struct file_operations fsl_hv_fops = {
 	.poll = fsl_hv_poll,
 	.read = fsl_hv_read,
 	.unlocked_ioctl = fsl_hv_ioctl,
-	.compat_ioctl = fsl_hv_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 };
 
 static struct miscdevice fsl_hv_misc_dev = {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 78de9d5d80c6..f4f792b7379d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2305,7 +2305,7 @@ static const struct super_operations btrfs_super_ops = {
 static const struct file_operations btrfs_ctl_fops = {
 	.open = btrfs_control_open,
 	.unlocked_ioctl	 = btrfs_control_ioctl,
-	.compat_ioctl = btrfs_control_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 	.owner	 = THIS_MODULE,
 	.llseek = noop_llseek,
 };
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ea8237513dfa..5bb93a3c397e 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2354,7 +2354,7 @@ const struct file_operations fuse_dev_operations = {
 	.release	= fuse_dev_release,
 	.fasync		= fuse_dev_fasync,
 	.unlocked_ioctl = fuse_dev_ioctl,
-	.compat_ioctl   = fuse_dev_ioctl,
+	.compat_ioctl   = compat_ptr_ioctl,
 };
 EXPORT_SYMBOL_GPL(fuse_dev_operations);
 
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 91006f47e420..3f494c8eaf2b 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -523,7 +523,7 @@ static const struct file_operations fanotify_fops = {
 	.fasync		= NULL,
 	.release	= fanotify_release,
 	.unlocked_ioctl	= fanotify_ioctl,
-	.compat_ioctl	= fanotify_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
 	.llseek		= noop_llseek,
 };
 
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index ccbdbd62f0d8..6ec18e0492e6 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1920,7 +1920,7 @@ static const struct file_operations userfaultfd_fops = {
 	.poll		= userfaultfd_poll,
 	.read		= userfaultfd_read,
 	.unlocked_ioctl = userfaultfd_ioctl,
-	.compat_ioctl	= userfaultfd_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
 	.llseek		= noop_llseek,
 };
 
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index f9b08a6d8dbe..c4be6a94ba97 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -1311,7 +1311,7 @@ static const struct file_operations rfkill_fops = {
 	.release	= rfkill_fop_release,
 #ifdef CONFIG_RFKILL_INPUT
 	.unlocked_ioctl	= rfkill_fop_ioctl,
-	.compat_ioctl	= rfkill_fop_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
 #endif
 	.llseek		= no_llseek,
 };
-- 
2.20.0

