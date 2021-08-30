Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CA43FB7F1
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 16:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbhH3OWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 10:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237027AbhH3OWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 10:22:48 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B93C061764
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 07:21:55 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so13979959pjr.1
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 07:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uulWibS5sEN2Ovi0hofOj7Yx0ifoVSC01yoyPcRCq0g=;
        b=ioejUBlqoCVQj6smYYW8ZF+lEB4w9kHPPKbab2Tmt8y4q75rlVQY31Ml0K7Q9uKjrI
         isHT8SjfSlCdE4l5VXDZVt4ALfhVLzvFnir4DmboJdUmJCC6UmZdGaXNqOx/lhMw9Ju+
         npzlMNDhu8XYLJTYxDjr1lN7Uz7tDSFvKHkp0zEm46QXg8tSlDOgEBbIJ6Mo6tyh7Rde
         Bum8JTmRq6EcyZ8QTstLdUv5A27S4iq07Q0BSHkPodfvb6AYhxN/ljKX4JYVM7BJWT6R
         W/0whMFU3pThq5vAnhxxSEfAl2WKZxXROGPi2/nXW+p4ygQHNIQe4dOhRFfldy2OlXwE
         7ERQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uulWibS5sEN2Ovi0hofOj7Yx0ifoVSC01yoyPcRCq0g=;
        b=m95d4cOsSQcyQwKN2/LM2O0Yzg04RgjW0dTBPqYOke4SE7f3lENC4LBjg3Onz/Dbaj
         gCHFw9thpx+N0NZpiGipq2XNcSMz2xmV/J8Ehgy9j35mqH+OqXCgYiPjI58xPUWvNs3h
         bVsGhwz5myB1qox2HN0tkBhydlRQFGB6JX3QV2wuoihOTcRu5wqusGbk4SCje2lv38/7
         xRu5r/vnP8qNH2r2KlmCSOEigWDbBVPQE8JhxO6fsPBgSA5nlxG5i7Fmk6dg1tuFfTGk
         FpxOzBNdrB/CuUPakT+2rPGd40K6Y90vF1Y86CANI1kBmQ6z3SmgCEyoeGv0tl0X07PC
         ccTA==
X-Gm-Message-State: AOAM530EuPR14u0oTEKdRljCMJdIxUGgVJqau0Vo9ygyNruPE5Jhb7hE
        Xr6b5AdljIWLptqQLgMAkXA9
X-Google-Smtp-Source: ABdhPJxQElBeYt1rYeRcI81eOCWd0UIqF8xBniodVyNdcOqgbq70WS+YPceedu/yIyGELKKy1pBW0w==
X-Received: by 2002:a17:902:e543:b0:134:1c02:285e with SMTP id n3-20020a170902e54300b001341c02285emr21601812plf.43.1630333314406;
        Mon, 30 Aug 2021 07:21:54 -0700 (PDT)
Received: from localhost ([139.177.225.237])
        by smtp.gmail.com with ESMTPSA id w16sm15587032pff.130.2021.08.30.07.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 07:21:53 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        will@kernel.org, john.garry@huawei.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 00/13] Introduce VDUSE - vDPA Device in Userspace
Date:   Mon, 30 Aug 2021 22:17:24 +0800
Message-Id: <20210830141737.181-1-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces a framework that makes it possible to implement
software-emulated vDPA devices in userspace. And to make the device
emulation more secure, the emulated vDPA device's control path is handled
in the kernel and only the data path is implemented in the userspace.

Since the emuldated vDPA device's control path is handled in the kernel,
a message mechnism is introduced to make userspace be aware of the data
path related changes. Userspace can use read()/write() to receive/reply
the control messages.

In the data path, the core is mapping dma buffer into VDUSE daemon's
address space, which can be implemented in different ways depending on
the vdpa bus to which the vDPA device is attached.

In virtio-vdpa case, we implements a MMU-based software IOTLB with
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

To make the userspace VDUSE processes such as qemu-storage-daemon able
to be run by an unprivileged user. We limit the supported device type
to virtio block device currently. The support for other device types
can be added after the security issue of corresponding device driver
is clarified or fixed in the future.

Future work:
  - Improve performance
  - Userspace library (find a way to reuse device emulation code in qemu/rust-vmm)
  - Support more device types

V11 to V12:
- Rebased to vhost.git
- Add reset support for all vdpa drivers
- Remove the dependency on other patches
- Export eventfd_wake_count
- Use workqueue for virtqueue kicking in some cases

V10 to V11:
- Rebased to newest kernel tree
- Add a device attribute for message timeout
- Add check for the reserved field of some structures
- Add a reset callback in vdpa_config_ops and handle it in VDUSE case
- Remove the patches that handle virtio-vdpa reset failure
- Document the structures in include/uapi/linux/vduse.h using kernel doc
- Add the reserved field for struct vduse_vq_config

V9 to V10:
- Forbid some userspace operations after a timeout
- Rename VDUSE_DEV_INJECT_IRQ to VDUSE_DEV_INJECT_CONFIG_IRQ
- Use fixed bounce buffer size
- Fix more code indentation issues in include/linux/vdpa.h
- Remove the section describing bounce-buffer mechanism in documentation
- Fix some commit logs and documentation

V8 to V9:
- Add VDUSE_SET_STATUS message to replace VDUSE_START/STOP_DATAPLANE messages
- Support packed virtqueue state
- Handle the reset failure in both virtio-vdpa and vhost-vdpa cases
- Add more details in documentation
- Remove VDUSE_REQ_FLAGS_NO_REPLY flag
- Add VDUSE_VQ_SETUP ioctl to support per-vq configuration
- Separate config interrupt injecting out of config update
- Flush kworker for interrupt inject during resetting
- Validate the config_size in .get_config()

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

Xie Yongji (13):
  iova: Export alloc_iova_fast() and free_iova_fast()
  eventfd: Export eventfd_wake_count to modules
  file: Export receive_fd() to modules
  vdpa: Fix some coding style issues
  vdpa: Add reset callback in vdpa_config_ops
  vhost-vdpa: Handle the failure of vdpa_reset()
  vhost-iotlb: Add an opaque pointer for vhost IOTLB
  vdpa: Add an opaque pointer for vdpa_config_ops.dma_map()
  vdpa: factor out vhost_vdpa_pa_map() and vhost_vdpa_pa_unmap()
  vdpa: Support transferring virtual addressing during DMA mapping
  vduse: Implement an MMU-based software IOTLB
  vduse: Introduce VDUSE - vDPA Device in Userspace
  Documentation: Add documentation for VDUSE

 Documentation/userspace-api/index.rst              |    1 +
 Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
 Documentation/userspace-api/vduse.rst              |  233 +++
 drivers/iommu/iova.c                               |    2 +
 drivers/vdpa/Kconfig                               |   10 +
 drivers/vdpa/Makefile                              |    1 +
 drivers/vdpa/ifcvf/ifcvf_main.c                    |   37 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   42 +-
 drivers/vdpa/vdpa.c                                |    9 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   26 +-
 drivers/vdpa/vdpa_user/Makefile                    |    5 +
 drivers/vdpa/vdpa_user/iova_domain.c               |  545 +++++++
 drivers/vdpa/vdpa_user/iova_domain.h               |   73 +
 drivers/vdpa/vdpa_user/vduse_dev.c                 | 1641 ++++++++++++++++++++
 drivers/vdpa/virtio_pci/vp_vdpa.c                  |   17 +-
 drivers/vhost/iotlb.c                              |   20 +-
 drivers/vhost/vdpa.c                               |  168 +-
 fs/eventfd.c                                       |    1 +
 fs/file.c                                          |    6 +
 include/linux/file.h                               |    7 +-
 include/linux/vdpa.h                               |   62 +-
 include/linux/vhost_iotlb.h                        |    3 +
 include/uapi/linux/vduse.h                         |  306 ++++
 23 files changed, 3112 insertions(+), 104 deletions(-)
 create mode 100644 Documentation/userspace-api/vduse.rst
 create mode 100644 drivers/vdpa/vdpa_user/Makefile
 create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
 create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
 create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
 create mode 100644 include/uapi/linux/vduse.h

-- 
2.11.0

