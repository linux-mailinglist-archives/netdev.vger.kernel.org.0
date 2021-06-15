Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59CE3A8266
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhFOOSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhFOOQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:16:52 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFB0C061149
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 07:13:54 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id x10so8534710plg.3
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 07:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/6gpQ02X7gBO8pjc42DY/js8aRctYucdCbW6L6v5kow=;
        b=dYRwAWKN2A96134398w/mjn2jG0oZvcCX0VtYPA6DYSpi5gkdOjOmluKYziXbhtEx+
         phKtRTapNBc5jyDIgnmJ70IrlaTujJgoYqwht215PRvRUdSJFR9JvonysplgkLltQBPk
         Dxo2EMjkKUodP7549wef4eUlVm1SdII1yvodX/AxyZkrOyyXVQ5xfgk0NYSl2uuMbElZ
         oM9FEtg8Lz31J8gD0vnyDpzhG/Y3AKU5+9af/KleS8Xv6zsM+yH0vEkHxMY+piRe/E79
         IM/rNEVJbza1Dg3P/oZJlEX3vAA4F0ak1MkFZSRNHMpgaX+zvkm0ibxfVAxTisKdyLCw
         F6AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/6gpQ02X7gBO8pjc42DY/js8aRctYucdCbW6L6v5kow=;
        b=nrUmtLLGeeDlDutyXMgKOBnJInU4YotlxcHbW0hd1i1RiQdSezbJTAlGMTRNLXiXbK
         0osSqoMS1vkwLxpf8Y03iZ2C3t5xWIe2plX7Tx063pwK6L3eXSje9yk2Glm4cO366tbx
         +e7DM0K436XJNjE9/r7AEoBUwg+v6KAbVShmMH0dlbRX4prjkHcdrs9oi/1PsfJk+fMG
         hUlvZSzG2Djn9bgrvPAisYhRYs7BYUtUv3vbC4AYYTUmO/2tvcrc+rRW22Zcn19gLK+7
         oJlAiD4x7gWP9DnXYS5hGM35y+KBTeDOX8wuaFk1viDQwV5XMayGM2clV8Ft30gw0YVk
         VNzQ==
X-Gm-Message-State: AOAM533jB/Qhw0rkk7M7JknJXd24wrsT0FQo9Zu+Ka+U4JsixzZ4Bmpq
        pW0iycUKeqlbydkmeslUmheb
X-Google-Smtp-Source: ABdhPJwkbgtquzUNz+rnnpPJarAojJTuaVzACvyc0OKWpIjl7r+D5LXQddCqzIPANuxSKCSy8dPI6Q==
X-Received: by 2002:a17:902:82c9:b029:104:dd1d:9c51 with SMTP id u9-20020a17090282c9b0290104dd1d9c51mr4356933plz.50.1623766433590;
        Tue, 15 Jun 2021 07:13:53 -0700 (PDT)
Received: from localhost ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id v8sm2817452pff.34.2021.06.15.07.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:13:53 -0700 (PDT)
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
Subject: [PATCH v8 00/10] Introduce VDUSE - vDPA Device in Userspace
Date:   Tue, 15 Jun 2021 22:13:21 +0800
Message-Id: <20210615141331.407-1-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces a framework that makes it possible to implement
software-emulated vDPA devices in userspace. And to make it simple, the
emulated vDPA device's control path is handled in the kernel and only the
data path is implemented in the userspace.

Since the emuldated vDPA device's control path is handled in the kernel,
a message mechnism is introduced to make userspace be aware of the data
path related changes. Userspace can use read()/write() to receive/reply
the control messages.

In the data path, the core is mapping dma buffer into VDUSE daemon's
address space, which can be implemented in different ways depending on
the vdpa bus to which the vDPA device is attached.

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

To make the userspace VDUSE processes such as qemu-storage-daemon able to
be run by an unprivileged user. We did some works on virtio driver to avoid
trusting device, including:

  - validating the used length: 

    * https://lore.kernel.org/lkml/20210531135852.113-1-xieyongji@bytedance.com/
    * https://lore.kernel.org/lkml/20210525125622.1203-1-xieyongji@bytedance.com/

  - validating the device config:
    
    * https://lore.kernel.org/lkml/20210615104810.151-1-xieyongji@bytedance.com/

  - validating the device response:

    * https://lore.kernel.org/lkml/20210615105218.214-1-xieyongji@bytedance.com/

Since I'm not sure if I missing something during auditing, especially on some
virtio device drivers that I'm not familiar with, we limit the supported device
type to virtio block device currently. The support for other device types can be
added after the security issue of corresponding device driver is clarified or
fixed in the future.

Future work:
  - Improve performance
  - Userspace library (find a way to reuse device emulation code in qemu/rust-vmm)
  - Support more device types

V7 to V8:
- Rebased to newest kernel tree
- Rework VDUSE driver to handle the device's control path in kernel
- Limit the supported device type to virtio block device
- Export free_iova_fast()
- Remove the virtio-blk and virtio-scsi patches (will send them alone)
- Remove all module parameters
- Use the same MAJOR for both control device and VDUSE devices
- Avoid eventfd cleanup in vduse_dev_release()

V6 to V7:
- Export alloc_iova_fast()
- Add get_config_size() callback
- Add some patches to avoid trusting virtio devices
- Add limited device emulation
- Add some documents
- Use workqueue to inject config irq
- Add parameter on vq irq injecting
- Rename vduse_domain_get_mapping_page() to vduse_domain_get_coherent_page()
- Add WARN_ON() to catch message failure
- Add some padding/reserved fields to uAPI structure
- Fix some bugs
- Rebase to vhost.git

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
  iova: Export alloc_iova_fast() and free_iova_fast();
  file: Export receive_fd() to modules
  eventfd: Increase the recursion depth of eventfd_signal()
  vhost-iotlb: Add an opaque pointer for vhost IOTLB
  vdpa: Add an opaque pointer for vdpa_config_ops.dma_map()
  vdpa: factor out vhost_vdpa_pa_map() and vhost_vdpa_pa_unmap()
  vdpa: Support transferring virtual addressing during DMA mapping
  vduse: Implement an MMU-based IOMMU driver
  vduse: Introduce VDUSE - vDPA Device in Userspace
  Documentation: Add documentation for VDUSE

 Documentation/userspace-api/index.rst              |    1 +
 Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
 Documentation/userspace-api/vduse.rst              |  222 +++
 drivers/iommu/iova.c                               |    2 +
 drivers/vdpa/Kconfig                               |   10 +
 drivers/vdpa/Makefile                              |    1 +
 drivers/vdpa/ifcvf/ifcvf_main.c                    |    2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |    2 +-
 drivers/vdpa/vdpa.c                                |    9 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |    8 +-
 drivers/vdpa/vdpa_user/Makefile                    |    5 +
 drivers/vdpa/vdpa_user/iova_domain.c               |  545 ++++++++
 drivers/vdpa/vdpa_user/iova_domain.h               |   73 +
 drivers/vdpa/vdpa_user/vduse_dev.c                 | 1453 ++++++++++++++++++++
 drivers/vdpa/virtio_pci/vp_vdpa.c                  |    2 +-
 drivers/vhost/iotlb.c                              |   20 +-
 drivers/vhost/vdpa.c                               |  148 +-
 fs/eventfd.c                                       |    2 +-
 fs/file.c                                          |    6 +
 include/linux/eventfd.h                            |    5 +-
 include/linux/file.h                               |    7 +-
 include/linux/vdpa.h                               |   21 +-
 include/linux/vhost_iotlb.h                        |    3 +
 include/uapi/linux/vduse.h                         |  143 ++
 24 files changed, 2641 insertions(+), 50 deletions(-)
 create mode 100644 Documentation/userspace-api/vduse.rst
 create mode 100644 drivers/vdpa/vdpa_user/Makefile
 create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
 create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
 create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
 create mode 100644 include/uapi/linux/vduse.h

-- 
2.11.0

