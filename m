Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887FA2E0C0F
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgLVOxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbgLVOxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 09:53:45 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA41C061793
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:53:05 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id z21so8499420pgj.4
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uiVGkob1gIqqC6Yzdq61jcy8JuwOajeN/SctQX1aUtg=;
        b=ZTxAYCSGC8X1EFhnSJtDZlZc174+Df9IOXG7cK889ItQ/qcEeVbeGRpDqSwh9Z9Mfr
         N7Gb9xP8GDJT4GlkK+Ri/ln1/loWzNHiRlMzzNZgYCqEvqbgkMSlDOmawzAaH7XTXxIp
         +SQd2zkvD9Yxj4r5QKWJuyRD3AJ6mO6D78sXrL3RskvTd+c9Lu4vAjAkPYX9a8zxilIP
         UGfVd70ao7V/bffzBmsyfKOBRctU7PRbHNNWQy9JIjeIzWkscNjH9qWcbnsaB6kpPOVs
         1LDVEgnXfA1dccGSSikvEyIABwt0nwbGSZ2/uOr7efuhnnTOjHcx9WMr52IpTjdRv22O
         TlLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uiVGkob1gIqqC6Yzdq61jcy8JuwOajeN/SctQX1aUtg=;
        b=S/C1iT6lxQe24a2ggackg1tFIA/Bzw6TLf1Xq/czX8HwNwBGZdo4Q6oALc60mD32x0
         HwpUZy6DFxFLxkkgLpqmTTEJpLveIIEWkBes00oHXKCJwZWfIfVC+RS+uI21JQ2/PaNN
         CW9nCX/VRR9AR9eAjuuIu9Sxi0ZVjWggOK/75b2CQqeZGcJRjatSg8GrGvAQmuC1ZiA4
         kMgsFaaKsNMv+iXWJ+DT0/ZqLzqUwxCLI0LHOgfPtkHg9wO0FXCA1EuCyUXkRNmyZa+7
         uEzYJuoiGdcTeWVeeiOnbwQ7fGrYUhe2QWrNeFUN+KljZHrQ6me8OPqu41/JcF/PpylO
         iwwg==
X-Gm-Message-State: AOAM533NFxBH3jUKV0YM21TD9DaFnj4UMsJcHZYtBhjzmdESRnDLihFq
        5aabAETMuRarUmnReinyv+5r
X-Google-Smtp-Source: ABdhPJwOMZhlfbC+XRg0aWjA1Uit6jsytMTGwMgMGXRmVCuqrlGhh91ghHicYK7Hi8vTgPn0PDTGfw==
X-Received: by 2002:a63:9dcf:: with SMTP id i198mr19940882pgd.242.1608648784515;
        Tue, 22 Dec 2020 06:53:04 -0800 (PST)
Received: from localhost ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id u1sm19156507pjr.51.2020.12.22.06.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 06:53:03 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, akpm@linux-foundation.org,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC v2 00/13] Introduce VDUSE - vDPA Device in Userspace
Date:   Tue, 22 Dec 2020 22:52:08 +0800
Message-Id: <20201222145221.711-1-xieyongji@bytedance.com>
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
      --export vduse-blk,id=test,node-name=disk0,writable=on,vduse-id=1,num-queues=16,queue-size=128

The qemu-storage-daemon can be found at https://github.com/bytedance/qemu/tree/vduse

Future work:
  - Improve performance (e.g. zero copy implementation in datapath)
  - Config interrupt support
  - Userspace library (find a way to reuse device emulation code in qemu/rust-vmm)

This is now based on below series:
https://lore.kernel.org/netdev/20201112064005.349268-1-parav@nvidia.com/

V1 to V2:
- Add vhost-vdpa support
- Add some documents
- Based on the vdpa management tool
- Introduce a workqueue for irq injection
- Replace interval tree with array map to store the iova_map

Xie Yongji (13):
  mm: export zap_page_range() for driver use
  eventfd: track eventfd_signal() recursion depth separately in different cases
  eventfd: Increase the recursion depth of eventfd_signal()
  vdpa: Remove the restriction that only supports virtio-net devices
  vdpa: Pass the netlink attributes to ops.dev_add()
  vduse: Introduce VDUSE - vDPA Device in Userspace
  vduse: support get/set virtqueue state
  vdpa: Introduce process_iotlb_msg() in vdpa_config_ops
  vduse: Add support for processing vhost iotlb message
  vduse: grab the module's references until there is no vduse device
  vduse/iova_domain: Support reclaiming bounce pages
  vduse: Add memory shrinker to reclaim bounce pages
  vduse: Introduce a workqueue for irq injection

 Documentation/driver-api/vduse.rst                 |   91 ++
 Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
 drivers/vdpa/Kconfig                               |    8 +
 drivers/vdpa/Makefile                              |    1 +
 drivers/vdpa/vdpa.c                                |    2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |    3 +-
 drivers/vdpa/vdpa_user/Makefile                    |    5 +
 drivers/vdpa/vdpa_user/eventfd.c                   |  229 ++++
 drivers/vdpa/vdpa_user/eventfd.h                   |   48 +
 drivers/vdpa/vdpa_user/iova_domain.c               |  517 ++++++++
 drivers/vdpa/vdpa_user/iova_domain.h               |  103 ++
 drivers/vdpa/vdpa_user/vduse.h                     |   59 +
 drivers/vdpa/vdpa_user/vduse_dev.c                 | 1373 ++++++++++++++++++++
 drivers/vhost/vdpa.c                               |   34 +-
 fs/aio.c                                           |    3 +-
 fs/eventfd.c                                       |   20 +-
 include/linux/eventfd.h                            |    5 +-
 include/linux/vdpa.h                               |   11 +-
 include/uapi/linux/vdpa.h                          |    1 +
 include/uapi/linux/vduse.h                         |  119 ++
 mm/memory.c                                        |    1 +
 21 files changed, 2598 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/driver-api/vduse.rst
 create mode 100644 drivers/vdpa/vdpa_user/Makefile
 create mode 100644 drivers/vdpa/vdpa_user/eventfd.c
 create mode 100644 drivers/vdpa/vdpa_user/eventfd.h
 create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
 create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
 create mode 100644 drivers/vdpa/vdpa_user/vduse.h
 create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
 create mode 100644 include/uapi/linux/vduse.h

-- 
2.11.0

