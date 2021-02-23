Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3CB322A22
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbhBWL7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 06:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbhBWLzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 06:55:52 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CC3C0611C3
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:52:17 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id a24so9654383plm.11
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PDXwmR+zfUMQh4kl0+Ce33TRDCzTaQ5t8N+mpmSoLXc=;
        b=u5G5XB5qyZqOH8Mzw4gfHFjQYjH9mJkUDu4I4y9AOrknRK3kFJmO/o0JI4Y6ytVWoW
         Df4kZVvcduzlElzZMcpgRtMQqafV10iEnzwbvDTnSTeZ+1gmZp/9t5Hpvwngh/PJ6Ni2
         N4njZBE3FbWpgtUAgtS5wS7gQ+0r9W5DFf7FgZCInETqlvvmas7mqGCKDwkf4WpZPH2h
         Ncl9Hga+Yoxu3QHJUGTNhXaVPI2rhngjoyZTOwwCc8XOy9KnZKfhASo83Z088wUnU5GR
         dzH2+aUF/2ALnw7qB/X8de87yvQOeBXOJK0NpvSynfYdfP6rsYr+2QkF0UU8DO39PGQs
         70Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PDXwmR+zfUMQh4kl0+Ce33TRDCzTaQ5t8N+mpmSoLXc=;
        b=Kh6TfX/g3KoGvhrmSjH82azyRk76LjG4pG3XOrLyZ2v+Jhn/xy2JyDMZvgexBFzgZO
         D4i4Rt42RHJChNZt5V1ccFcj+l/jqwpzR+MIwpkZzLSVCPb3hcwSLv2eqCphTrlFqtSB
         FF/rRqXQlBEXdz9/jp/8QxDzQ5fZIBRx/2bjdcryWKWHhFa9HAnT744ks9WGOiSEcaUD
         854vjj42ws6LwBx7EjAPNUKPlhn8UckK94JEVZCV3XWx+lOSWNzvlYQSSHS2aZr+/9XB
         47MmT9CfVMVgyNNzxiejLGejq9qJrZDoCd5h+rYIoWePmmEgljFthUc/YZI8mRE6f1Ew
         snmQ==
X-Gm-Message-State: AOAM531CjLdPMVfzW7jU9j77aMxiV2sc5vUMeBCNZ1LDhTJzlYumESu2
        JWaIXiaGOoQ3Napoj1dFjhfS
X-Google-Smtp-Source: ABdhPJwHrJOBCxe8WN55gZjE0Jk6w3901Z9CfOeQMD/HUMU3u/qMpB+2Q3e2U10DszPc7cAhQwwQBA==
X-Received: by 2002:a17:90b:390b:: with SMTP id ob11mr29022804pjb.50.1614081137268;
        Tue, 23 Feb 2021 03:52:17 -0800 (PST)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id mp17sm3098678pjb.48.2021.02.23.03.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 03:52:16 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v4 09/11] Documentation: Add documentation for VDUSE
Date:   Tue, 23 Feb 2021 19:50:46 +0800
Message-Id: <20210223115048.435-10-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223115048.435-1-xieyongji@bytedance.com>
References: <20210223115048.435-1-xieyongji@bytedance.com>
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
 Documentation/userspace-api/vduse.rst | 112 ++++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+)
 create mode 100644 Documentation/userspace-api/vduse.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index acd2cc2a538d..f63119130898 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -24,6 +24,7 @@ place where this information is gathered.
    ioctl/index
    iommu
    media/index
+   vduse
 
 .. only::  subproject and html
 
diff --git a/Documentation/userspace-api/vduse.rst b/Documentation/userspace-api/vduse.rst
new file mode 100644
index 000000000000..2a20e686bb59
--- /dev/null
+++ b/Documentation/userspace-api/vduse.rst
@@ -0,0 +1,112 @@
+==================================
+VDUSE - "vDPA Device in Userspace"
+==================================
+
+vDPA (virtio data path acceleration) device is a device that uses a
+datapath which complies with the virtio specifications with vendor
+specific control path. vDPA devices can be both physically located on
+the hardware or emulated by software. VDUSE is a framework that makes it
+possible to implement software-emulated vDPA devices in userspace.
+
+How VDUSE works
+------------
+Each userspace vDPA device is created by the VDUSE_CREATE_DEV ioctl on
+the character device (/dev/vduse/control). Then a device file with the
+specified name (/dev/vduse/$NAME) will appear, which can be used to
+implement the userspace vDPA device's control path and data path.
+
+To implement control path, a message-based communication protocol and some
+types of control messages are introduced in the VDUSE framework:
+
+- VDUSE_SET_VQ_ADDR: Set the vring address of virtqueue.
+
+- VDUSE_SET_VQ_NUM: Set the size of virtqueue
+
+- VDUSE_SET_VQ_READY: Set ready status of virtqueue
+
+- VDUSE_GET_VQ_READY: Get ready status of virtqueue
+
+- VDUSE_SET_VQ_STATE: Set the state for virtqueue
+
+- VDUSE_GET_VQ_STATE: Get the state for virtqueue
+
+- VDUSE_SET_FEATURES: Set virtio features supported by the driver
+
+- VDUSE_GET_FEATURES: Get virtio features supported by the device
+
+- VDUSE_SET_STATUS: Set the device status
+
+- VDUSE_GET_STATUS: Get the device status
+
+- VDUSE_SET_CONFIG: Write to device specific configuration space
+
+- VDUSE_GET_CONFIG: Read from device specific configuration space
+
+- VDUSE_UPDATE_IOTLB: Notify userspace to update the memory mapping in device IOTLB
+
+Those control messages are mostly based on the vdpa_config_ops in
+include/linux/vdpa.h which defines a unified interface to control
+different types of vdpa device. Userspace needs to read()/write()
+on the VDUSE device file to receive/reply those control messages
+from/to VDUSE kernel module as follows:
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
+		resp.request_id = req.unique;
+
+		switch (req.type) {
+
+		/* handle different types of message */
+
+		}
+
+		len = write(dev_fd, &resp, sizeof(resp));
+		if (len != sizeof(resp))
+			return -1;
+
+		return 0;
+	}
+
+In the deta path, vDPA device's iova regions will be mapped into userspace
+with the help of VDUSE_IOTLB_GET_FD ioctl on the VDUSE device file:
+
+- VDUSE_IOTLB_GET_FD: get the file descriptor to iova region. Userspace can
+  access this iova region by passing the fd to mmap().
+
+Besides, the following ioctls on the VDUSE device file are provided to support
+interrupt injection and setting up eventfd for virtqueue kicks:
+
+- VDUSE_VQ_SETUP_KICKFD: set the kickfd for virtqueue, this eventfd is used
+  by VDUSE kernel module to notify userspace to consume the vring.
+
+- VDUSE_INJECT_VQ_IRQ: inject an interrupt for specific virtqueue
+
+- VDUSE_INJECT_CONFIG_IRQ: inject a config interrupt
+
+MMU-based IOMMU Driver
+----------------------
+In virtio-vdpa case, VDUSE framework implements an MMU-based on-chip IOMMU
+driver to support mapping the kernel DMA buffer into the userspace iova
+region dynamically.
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

