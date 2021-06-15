Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9703A829C
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhFOOWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbhFOOUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:20:47 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFF6C0610CB
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 07:14:41 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id v7so2815689pgl.2
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 07:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=muuPBKMMRoHsteALA0MSISB9nQhfFONjAplR9RQm2vE=;
        b=sOKta2eTgQPAWv0wTtHmLqpmdwrIHlt5ZRIpdf04RP+ckeaFiWPpCYGIl/y/0nsYU3
         FDsTtObzYTsw3GTNwD3WO1aTiXm5VYeftg9mPbAQITv2T8tQ3QLxQIvYqexXGb2w6+9A
         NZW9l5yNozQ86OorZ6qzrHXuDdemEmEnd81prOOStAVU1IwEXtRoFXasd36qeq+YLllH
         Ix9itpjpp2xoITDYSGEpr1MdVIB79PNjoI+xbeY2XQVtHUGRyoqbWd2fs0ffydnymirj
         CWyfLjTYv9qOJIo4wtZuYQ64PYG08G+9YdX7i2OgKeCDRSFlBOQCieqUuHsreUWwtR+V
         SFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=muuPBKMMRoHsteALA0MSISB9nQhfFONjAplR9RQm2vE=;
        b=rl7Ec6TfPmUXQesL0iskAOiVsqNoVrOLIFPmD38dvDDmvotbPlvG4cxvBzvS0hmSEs
         DHAYVDBhz4eZ80WJJOaIQ22Kil7oyVAKHcUWqcAR3KVeGE4NiBkAlYmI+EeJkL/paA2e
         OlzKYbmWurC7BXGJnnpjzAnH1CKFAsWZXwiW8UkuCYp9igFmk2LQAIJMdMqjriKuuaw0
         Lkog/x8fc8ZQLVYT7AKTJmeprza/ILmoAt0zZwcAEiyR6Mel9dnyhjB9yOTvrHVw1vpZ
         zc4Sn8GX4Lr6e6a76ujfHxzo6anRdC3W85xKj76hfz8arqHKswLWzHW22UKRTUVZGQBP
         7gxQ==
X-Gm-Message-State: AOAM533uFzsSrOX08hZvR8tHHI5sLBGPTh+dqNzm+3o5lkZTvEBl4cwU
        tyTUrceYxyUY6/CTYrHu/kho
X-Google-Smtp-Source: ABdhPJwe+4++061oAxP5Uk90bQPawN+eFuSh4VWexi1jhoK7flquuoVHZrE/zE0dabo+ZmoZKUoGVw==
X-Received: by 2002:a63:4465:: with SMTP id t37mr8582231pgk.342.1623766480653;
        Tue, 15 Jun 2021 07:14:40 -0700 (PDT)
Received: from localhost ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id t1sm14985152pjo.33.2021.06.15.07.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:14:40 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 10/10] Documentation: Add documentation for VDUSE
Date:   Tue, 15 Jun 2021 22:13:31 +0800
Message-Id: <20210615141331.407-11-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210615141331.407-1-xieyongji@bytedance.com>
References: <20210615141331.407-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VDUSE (vDPA Device in Userspace) is a framework to support
implementing software-emulated vDPA devices in userspace. This
document is intended to clarify the VDUSE design and usage.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 Documentation/userspace-api/index.rst |   1 +
 Documentation/userspace-api/vduse.rst | 222 ++++++++++++++++++++++++++++++++++
 2 files changed, 223 insertions(+)
 create mode 100644 Documentation/userspace-api/vduse.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index 0b5eefed027e..c432be070f67 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -27,6 +27,7 @@ place where this information is gathered.
    iommu
    media/index
    sysfs-platform_profile
+   vduse
 
 .. only::  subproject and html
 
diff --git a/Documentation/userspace-api/vduse.rst b/Documentation/userspace-api/vduse.rst
new file mode 100644
index 000000000000..2f9cd1a4e530
--- /dev/null
+++ b/Documentation/userspace-api/vduse.rst
@@ -0,0 +1,222 @@
+==================================
+VDUSE - "vDPA Device in Userspace"
+==================================
+
+vDPA (virtio data path acceleration) device is a device that uses a
+datapath which complies with the virtio specifications with vendor
+specific control path. vDPA devices can be both physically located on
+the hardware or emulated by software. VDUSE is a framework that makes it
+possible to implement software-emulated vDPA devices in userspace. And
+to make it simple, the emulated vDPA device's control path is handled in
+the kernel and only the data path is implemented in the userspace.
+
+Note that only virtio block device is supported by VDUSE framework now,
+which can reduce security risks when the userspace process that implements
+the data path is run by an unprivileged user. The Support for other device
+types can be added after the security issue is clarified or fixed in the future.
+
+Start/Stop VDUSE devices
+------------------------
+
+VDUSE devices are started as follows:
+
+1. Create a new VDUSE instance with ioctl(VDUSE_CREATE_DEV) on
+   /dev/vduse/control.
+
+2. Begin processing VDUSE messages from /dev/vduse/$NAME. The first
+   messages will arrive while attaching the VDUSE instance to vDPA bus.
+
+3. Send the VDPA_CMD_DEV_NEW netlink message to attach the VDUSE
+   instance to vDPA bus.
+
+VDUSE devices are stopped as follows:
+
+1. Send the VDPA_CMD_DEV_DEL netlink message to detach the VDUSE
+   instance from vDPA bus.
+
+2. Close the file descriptor referring to /dev/vduse/$NAME
+
+3. Destroy the VDUSE instance with ioctl(VDUSE_DESTROY_DEV) on
+   /dev/vduse/control
+
+The netlink messages metioned above can be sent via vdpa tool in iproute2
+or use the below sample codes:
+
+.. code-block:: c
+
+	static int netlink_add_vduse(const char *name, enum vdpa_command cmd)
+	{
+		struct nl_sock *nlsock;
+		struct nl_msg *msg;
+		int famid;
+
+		nlsock = nl_socket_alloc();
+		if (!nlsock)
+			return -ENOMEM;
+
+		if (genl_connect(nlsock))
+			goto free_sock;
+
+		famid = genl_ctrl_resolve(nlsock, VDPA_GENL_NAME);
+		if (famid < 0)
+			goto close_sock;
+
+		msg = nlmsg_alloc();
+		if (!msg)
+			goto close_sock;
+
+		if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, famid, 0, 0, cmd, 0))
+			goto nla_put_failure;
+
+		NLA_PUT_STRING(msg, VDPA_ATTR_DEV_NAME, name);
+		if (cmd == VDPA_CMD_DEV_NEW)
+			NLA_PUT_STRING(msg, VDPA_ATTR_MGMTDEV_DEV_NAME, "vduse");
+
+		if (nl_send_sync(nlsock, msg))
+			goto close_sock;
+
+		nl_close(nlsock);
+		nl_socket_free(nlsock);
+
+		return 0;
+	nla_put_failure:
+		nlmsg_free(msg);
+	close_sock:
+		nl_close(nlsock);
+	free_sock:
+		nl_socket_free(nlsock);
+		return -1;
+	}
+
+How VDUSE works
+---------------
+
+Since the emuldated vDPA device's control path is handled in the kernel,
+a message-based communication protocol and few types of control messages
+are introduced by VDUSE framework to make userspace be aware of the data
+path related changes:
+
+- VDUSE_GET_VQ_STATE: Get the state for virtqueue from userspace
+
+- VDUSE_START_DATAPLANE: Notify userspace to start the dataplane
+
+- VDUSE_STOP_DATAPLANE: Notify userspace to stop the dataplane
+
+- VDUSE_UPDATE_IOTLB: Notify userspace to update the memory mapping in device IOTLB
+
+Userspace needs to read()/write() on /dev/vduse/$NAME to receive/reply
+those control messages from/to VDUSE kernel module as follows:
+
+.. code-block:: c
+
+	static int vduse_message_handler(int dev_fd)
+	{
+		int len;
+		struct vduse_dev_request req;
+		struct vduse_dev_response resp;
+
+		len = read(dev_fd, &req, sizeof(req));
+		if (len != sizeof(req))
+			return -1;
+
+		resp.request_id = req.request_id;
+
+		switch (req.type) {
+
+		/* handle different types of message */
+
+		}
+
+		if (req.flags & VDUSE_REQ_FLAGS_NO_REPLY)
+			return 0;
+
+		len = write(dev_fd, &resp, sizeof(resp));
+		if (len != sizeof(resp))
+			return -1;
+
+		return 0;
+	}
+
+After VDUSE_START_DATAPLANE messages is received, userspace should start the
+dataplane processing with the help of some ioctls on /dev/vduse/$NAME:
+
+- VDUSE_IOTLB_GET_FD: get the file descriptor to the first overlapped iova region.
+  Userspace can access this iova region by passing fd and corresponding size, offset,
+  perm to mmap(). For example:
+
+.. code-block:: c
+
+	static int perm_to_prot(uint8_t perm)
+	{
+		int prot = 0;
+
+		switch (perm) {
+		case VDUSE_ACCESS_WO:
+			prot |= PROT_WRITE;
+			break;
+		case VDUSE_ACCESS_RO:
+			prot |= PROT_READ;
+			break;
+		case VDUSE_ACCESS_RW:
+			prot |= PROT_READ | PROT_WRITE;
+			break;
+		}
+
+		return prot;
+	}
+
+	static void *iova_to_va(int dev_fd, uint64_t iova, uint64_t *len)
+	{
+		int fd;
+		void *addr;
+		size_t size;
+		struct vduse_iotlb_entry entry;
+
+		entry.start = iova;
+		entry.last = iova + 1;
+		fd = ioctl(dev_fd, VDUSE_IOTLB_GET_FD, &entry);
+		if (fd < 0)
+			return NULL;
+
+		size = entry.last - entry.start + 1;
+		*len = entry.last - iova + 1;
+		addr = mmap(0, size, perm_to_prot(entry.perm), MAP_SHARED,
+			    fd, entry.offset);
+		close(fd);
+		if (addr == MAP_FAILED)
+			return NULL;
+
+		/* do something to cache this iova region */
+
+		return addr + iova - entry.start;
+	}
+
+- VDUSE_DEV_GET_FEATURES: Get the negotiated features
+
+- VDUSE_DEV_UPDATE_CONFIG: Update the configuration space and inject a config interrupt
+
+- VDUSE_VQ_GET_INFO: Get the specified virtqueue's metadata
+
+- VDUSE_VQ_SETUP_KICKFD: set the kickfd for virtqueue, this eventfd is used
+  by VDUSE kernel module to notify userspace to consume the vring.
+
+- VDUSE_INJECT_VQ_IRQ: inject an interrupt for specific virtqueue
+
+MMU-based IOMMU Driver
+----------------------
+
+VDUSE framework implements an MMU-based on-chip IOMMU driver to support
+mapping the kernel DMA buffer into the userspace iova region dynamically.
+This is mainly designed for virtio-vdpa case (kernel virtio drivers).
+
+The basic idea behind this driver is treating MMU (VA->PA) as IOMMU (IOVA->PA).
+The driver will set up MMU mapping instead of IOMMU mapping for the DMA transfer
+so that the userspace process is able to use its virtual address to access
+the DMA buffer in kernel.
+
+And to avoid security issue, a bounce-buffering mechanism is introduced to
+prevent userspace accessing the original buffer directly which may contain other
+kernel data. During the mapping, unmapping, the driver will copy the data from
+the original buffer to the bounce buffer and back, depending on the direction of
+the transfer. And the bounce-buffer addresses will be mapped into the user address
+space instead of the original one.
-- 
2.11.0

