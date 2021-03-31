Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A927434FB14
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbhCaIGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbhCaIGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:06:19 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4859FC06174A
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 01:06:18 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so760998pjc.2
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 01:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4N6n75HqbevIF9P31f/wL6cRPYdbdVgQRyq4EjDa+KI=;
        b=tCWBRhkJ+EMcbHANy2T6J/ODxrDT3eHPzebAt+W99iL0z7gvXjr48gyg9qUrY139C2
         5eDG6B4sUzPt56VJiOE+FaH1N17gORJp/oo5tKe3M7lzZFYVw/t7wciBddhPOnZOQWtC
         LAZWYSlVDKcL6rvBWxeTUjWw+l09aCIfcgzIqJ0TBjD7cNcXivLhdHyDcmIlDCB1GjYO
         L6CbDMLkz6QhZGZm3/4LTAWxrsNh6fb9y7Rmhvs5IDPTPwG+yBt6moLP2iWKVgLoDZSd
         EX0FqybXvVmaUAKcJcLct764h//QocjnI69D5oC1ZIUUcEwQcL0uGvx2/WZlUQ7zucjQ
         JNJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4N6n75HqbevIF9P31f/wL6cRPYdbdVgQRyq4EjDa+KI=;
        b=rO1UH+UW7H/osdjb0NN5A9TyRdYwtDfPWwpZt3pcbQz5Lc81lOyTvPd/Ry+NlKXHPW
         3N8pHQT3I63V6aYA22CeC3nMcMtcLQ66v6aftnIeAnUnwP5pwp6+RwBzZK6LRggF3TQM
         tIe1n/qey24/UDgAeXLuEBIfYfdQ2lAdOQnoKzLb7uMIxGLXUPMJzxHBL4ikUzSXGAl+
         7i6i/T3vJqsyZ0TD7w0kCCcXYRRE4Hiwe4kQY7Ez1tmH+st234ujGVTk1GwU+2OkQddG
         fAs0BH5TUaijsmAbfnxE4TVZBaGhaHh3oDf8Ack4dzVbhjrPzbLK+84btzi97CdZdRY3
         S/2A==
X-Gm-Message-State: AOAM531pXHP8rwxIgR9CFwg87b1L2HNzSjzE4c25ibe0pzT5QBKrUE+/
        FfYn4rOjDP/5auXFTYzvYTBg
X-Google-Smtp-Source: ABdhPJwXQhHmzbJYidBqa/tnGY3/zsxMlrVA/10Pbl0dBxMOuwslgXGwHsV1vdv1saXvtLPHhYcpmQ==
X-Received: by 2002:a17:903:22c1:b029:e7:1f29:b848 with SMTP id y1-20020a17090322c1b02900e71f29b848mr2100012plg.53.1617177977718;
        Wed, 31 Mar 2021 01:06:17 -0700 (PDT)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id a22sm1731081pgw.52.2021.03.31.01.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 01:06:17 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 00/10] Introduce VDUSE - vDPA Device in Userspace
Date:   Wed, 31 Mar 2021 16:05:09 +0800
Message-Id: <20210331080519.172-1-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces a framework, which can be used to implement
vDPA Devices in a userspace program. The work consist of two parts:
control path forwarding and data path offloading.

In the control path, the VDUSE driver will make use of message
mechnism to forward the config operation from vdpa bus driver
to userspace. Userspace can use read()/write() to receive/reply
those control messages.

In the data path, the core is mapping dma buffer into VDUSE
daemon's address space, which can be implemented in different ways
depending on the vdpa bus to which the vDPA device is attached.

In virtio-vdpa case, we implements a MMU-based on-chip IOMMU driver with
bounce-buffering mechanism to achieve that. And in vhost-vdpa case, the dma
buffer is reside in a userspace memory region which can be shared to the
VDUSE userspace processs via transferring the shmfd.

The details and our user case is shown below:

------------------------    -------------------------   ----------------------------------------------
|            Container |    |              QEMU(VM) |   |                               VDUSE daemon |
|       ---------      |    |  -------------------  |   | ------------------------- ---------------- |
|       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | | vDPA device emulation | | block driver | |
------------+-----------     -----------+------------   -------------+----------------------+---------
            |                           |                            |                      |
            |                           |                            |                      |
------------+---------------------------+----------------------------+----------------------+---------
|    | block device |           |  vhost device |            | vduse driver |          | TCP/IP |    |
|    -------+--------           --------+--------            -------+--------          -----+----    |
|           |                           |                           |                       |        |
| ----------+----------       ----------+-----------         -------+-------                |        |
| | virtio-blk driver |       |  vhost-vdpa driver |         | vdpa device |                |        |
| ----------+----------       ----------+-----------         -------+-------                |        |
|           |      virtio bus           |                           |                       |        |
|   --------+----+-----------           |                           |                       |        |
|                |                      |                           |                       |        |
|      ----------+----------            |                           |                       |        |
|      | virtio-blk device |            |                           |                       |        |
|      ----------+----------            |                           |                       |        |
|                |                      |                           |                       |        |
|     -----------+-----------           |                           |                       |        |
|     |  virtio-vdpa driver |           |                           |                       |        |
|     -----------+-----------           |                           |                       |        |
|                |                      |                           |    vdpa bus           |        |
|     -----------+----------------------+---------------------------+------------           |        |
|                                                                                        ---+---     |
-----------------------------------------------------------------------------------------| NIC |------
                                                                                         ---+---
                                                                                            |
                                                                                   ---------+---------
                                                                                   | Remote Storages |
                                                                                   -------------------

We make use of it to implement a block device connecting to
our distributed storage, which can be used both in containers and
VMs. Thus, we can have an unified technology stack in this two cases.

To test it with null-blk:

  $ qemu-storage-daemon \
      --chardev socket,id=charmonitor,path=/tmp/qmp.sock,server,nowait \
      --monitor chardev=charmonitor \
      --blockdev driver=host_device,cache.direct=on,aio=native,filename=/dev/nullb0,node-name=disk0 \
      --export type=vduse-blk,id=test,node-name=disk0,writable=on,name=vduse-null,num-queues=16,queue-size=128

The qemu-storage-daemon can be found at https://github.com/bytedance/qemu/tree/vduse

Future work:
  - Improve performance
  - Userspace library (find a way to reuse device emulation code in qemu/rust-vmm)

V5 to V6:
- Export receive_fd() instead of __receive_fd()
- Factor out the unmapping logic of pa and va separatedly
- Remove the logic of bounce page allocation in page fault handler
- Use PAGE_SIZE as IOVA allocation granule
- Add EPOLLOUT support
- Enable setting API version in userspace
- Fix some bugs

V4 to V5:
- Remove the patch for irq binding
- Use a single IOTLB for all types of mapping
- Factor out vhost_vdpa_pa_map()
- Add some sample codes in document
- Use receice_fd_user() to pass file descriptor
- Fix some bugs

V3 to V4:
- Rebase to vhost.git
- Split some patches
- Add some documents
- Use ioctl to inject interrupt rather than eventfd
- Enable config interrupt support
- Support binding irq to the specified cpu
- Add two module parameter to limit bounce/iova size
- Create char device rather than anon inode per vduse
- Reuse vhost IOTLB for iova domain
- Rework the message mechnism in control path

V2 to V3:
- Rework the MMU-based IOMMU driver
- Use the iova domain as iova allocator instead of genpool
- Support transferring vma->vm_file in vhost-vdpa
- Add SVA support in vhost-vdpa
- Remove the patches on bounce pages reclaim

V1 to V2:
- Add vhost-vdpa support
- Add some documents
- Based on the vdpa management tool
- Introduce a workqueue for irq injection
- Replace interval tree with array map to store the iova_map

Xie Yongji (10):
  file: Export receive_fd() to modules
  eventfd: Increase the recursion depth of eventfd_signal()
  vhost-vdpa: protect concurrent access to vhost device iotlb
  vhost-iotlb: Add an opaque pointer for vhost IOTLB
  vdpa: Add an opaque pointer for vdpa_config_ops.dma_map()
  vdpa: factor out vhost_vdpa_pa_map() and vhost_vdpa_pa_unmap()
  vdpa: Support transferring virtual addressing during DMA mapping
  vduse: Implement an MMU-based IOMMU driver
  vduse: Introduce VDUSE - vDPA Device in Userspace
  Documentation: Add documentation for VDUSE

 Documentation/userspace-api/index.rst              |    1 +
 Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
 Documentation/userspace-api/vduse.rst              |  212 +++
 drivers/vdpa/Kconfig                               |   10 +
 drivers/vdpa/Makefile                              |    1 +
 drivers/vdpa/ifcvf/ifcvf_main.c                    |    2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |    2 +-
 drivers/vdpa/vdpa.c                                |    9 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |    8 +-
 drivers/vdpa/vdpa_user/Makefile                    |    5 +
 drivers/vdpa/vdpa_user/iova_domain.c               |  521 ++++++++
 drivers/vdpa/vdpa_user/iova_domain.h               |   70 +
 drivers/vdpa/vdpa_user/vduse_dev.c                 | 1362 ++++++++++++++++++++
 drivers/vdpa/virtio_pci/vp_vdpa.c                  |    2 +-
 drivers/vhost/iotlb.c                              |   20 +-
 drivers/vhost/vdpa.c                               |  154 ++-
 fs/eventfd.c                                       |    2 +-
 fs/file.c                                          |    6 +
 include/linux/eventfd.h                            |    5 +-
 include/linux/file.h                               |    7 +-
 include/linux/vdpa.h                               |   21 +-
 include/linux/vhost_iotlb.h                        |    3 +
 include/uapi/linux/vduse.h                         |  175 +++
 23 files changed, 2548 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/userspace-api/vduse.rst
 create mode 100644 drivers/vdpa/vdpa_user/Makefile
 create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
 create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
 create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
 create mode 100644 include/uapi/linux/vduse.h

-- 
2.11.0

