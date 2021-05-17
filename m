Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8DE3828E2
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 11:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbhEQJ5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 05:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbhEQJ5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 05:57:13 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC40C061756
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:55:57 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id s4so1281714plg.12
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MouAXVU0J/gA4I5GTy8SeyqWRECXQkyC0TfR7o+Hz5c=;
        b=X0NTR58R14qMnCCKXWSzamLPSdg5ExgcnZ0DImKaOvMCmLt88fIAkwnd6J2goufzIn
         LZOX15kilgG1Dpn4/vP2PG+4Fhi9vZbkrEJqmJZewuKtHtv9oigd8ov8uQnpZhAzXzzZ
         HznvMz8uE0gElfCIgP2ZD95kpy/KRxDkVIqHHTv9FWNUnsQIHKAIXZ4iZfJ5B87lJ3EE
         ls2Ts5Iq15VVio05oK4AXMznPbS+avf5o5+LNh2/OC2v2z84gqMWLsSyQHn35jYspPDH
         Snhgb9KU1Bbc4vtTjC0l7f8i4UFqNtKCOGkMtTUJP80evpQj9KsuMqb0xS+rNEXU/L94
         UBtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MouAXVU0J/gA4I5GTy8SeyqWRECXQkyC0TfR7o+Hz5c=;
        b=jfoYyKNLGjmVYYZMIud3d0O/44IP/qnuadqg9ynw2hfwsrO3hIXzeTdqibk8GbqcAV
         QkZH3QV4G0os57FSc6OM3ucPAQEj1ZDERKBPqJ7QO8RXi2NDOSuXifzggUnDALk9nVfV
         XhLM4gZZTUWafpjv54RJjczPuHHpELQKsW9we/CmoH+k1Zram9xbINMzCNRW0p5j8Fhg
         rhqciaTczyalVngLKO+ep9AFQ+WglVn3mhsgqTzQmXW/RDvCfMlPMon6mQ2DIr5KRokq
         zSm+V/+X6+19nL3xqpLeaU+y8++iXsX8c+PXjBCi0Sg4V+V1PJdRAi6ckJF6bycEKg9X
         gyQg==
X-Gm-Message-State: AOAM531tX6oMwI3D5ohZbTE/qVpqbb5r1b41mZyRtE+uGzOuDAQgYvHZ
        pCUKPLLniWPTQjQPp1ZQYLWM
X-Google-Smtp-Source: ABdhPJy1ehb6Kie4m4QxEvvF1uyhuUm0zgw7klsdTztxYar5dk7+iQLkZ++eK/Arz2ab9Zz4tUZOzQ==
X-Received: by 2002:a17:90a:bc0c:: with SMTP id w12mr26427487pjr.213.1621245356449;
        Mon, 17 May 2021 02:55:56 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id h19sm10062442pgm.40.2021.05.17.02.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 02:55:56 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 00/12] Introduce VDUSE - vDPA Device in Userspace
Date:   Mon, 17 May 2021 17:55:01 +0800
Message-Id: <20210517095513.850-1-xieyongji@bytedance.com>
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

To make the userspace VDUSE processes such as qemu-storage-daemon able to
run unprivileged. We did some works on virtio driver to avoid trusting
device, including:

  - validating the device status:

    * https://lore.kernel.org/lkml/20210517093428.670-1-xieyongji@bytedance.com/

  - validating the used length: 

    * https://lore.kernel.org/lkml/20210517090836.533-1-xieyongji@bytedance.com/

  - validating the device config:
    
    * patch 4 ("virtio-blk: Add validation for block size in config space")

  - validating the device response:

    * patch 5 ("virtio_scsi: Add validation for residual bytes from response")

Since I'm not sure if I missing something during auditing, especially on some
virtio device drivers that I'm not familiar with, now we only support emualting
a few vDPA devices by default, including: virtio-net device, virtio-blk device,
virtio-scsi device and virtio-fs device. This limitaion can help to reduce
security risks. When a sysadmin trusts the userspace process enough, it can relax
the limitation with a 'allow_unsafe_device_emulation' module parameter.

Future work:
  - Improve performance
  - Userspace library (find a way to reuse device emulation code in qemu/rust-vmm)

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

Xie Yongji (12):
  iova: Export alloc_iova_fast()
  file: Export receive_fd() to modules
  eventfd: Increase the recursion depth of eventfd_signal()
  virtio-blk: Add validation for block size in config space
  virtio_scsi: Add validation for residual bytes from response
  vhost-iotlb: Add an opaque pointer for vhost IOTLB
  vdpa: Add an opaque pointer for vdpa_config_ops.dma_map()
  vdpa: factor out vhost_vdpa_pa_map() and vhost_vdpa_pa_unmap()
  vdpa: Support transferring virtual addressing during DMA mapping
  vduse: Implement an MMU-based IOMMU driver
  vduse: Introduce VDUSE - vDPA Device in Userspace
  Documentation: Add documentation for VDUSE

 Documentation/userspace-api/index.rst              |    1 +
 Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
 Documentation/userspace-api/vduse.rst              |  243 ++++
 drivers/block/virtio_blk.c                         |    2 +-
 drivers/iommu/iova.c                               |    1 +
 drivers/scsi/virtio_scsi.c                         |    2 +-
 drivers/vdpa/Kconfig                               |   10 +
 drivers/vdpa/Makefile                              |    1 +
 drivers/vdpa/ifcvf/ifcvf_main.c                    |    2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |    2 +-
 drivers/vdpa/vdpa.c                                |    9 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |    8 +-
 drivers/vdpa/vdpa_user/Makefile                    |    5 +
 drivers/vdpa/vdpa_user/iova_domain.c               |  531 +++++++
 drivers/vdpa/vdpa_user/iova_domain.h               |   70 +
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
 include/uapi/linux/vduse.h                         |  178 +++
 26 files changed, 2681 insertions(+), 52 deletions(-)
 create mode 100644 Documentation/userspace-api/vduse.rst
 create mode 100644 drivers/vdpa/vdpa_user/Makefile
 create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
 create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
 create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
 create mode 100644 include/uapi/linux/vduse.h

-- 
2.11.0

