Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32B32FB046
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 06:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388819AbhASFU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 00:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbhASFFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 00:05:15 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78C0C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 21:04:34 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id n7so12304334pgg.2
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 21:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8jWaaLZ6u+//lYSPDVEE3dbvuuSNRm/3gTqtS9kbnx0=;
        b=ji14BKRL8km3ujzp9UXDrCdLxYqio1bJdNPB8i24chKWjS842AG68AXO7EXyNe4GOy
         tN7mQEJa6LUIT8EwlVa84DC9oYeQTUFIjbRBN+VgJ6RWzfhdp3ykNONliiDnxzkhDppT
         4Zr9/ylh3jUWmyUJiSC+s8pxZcrSkDNUmVGCtMq0N9o7yfnw8KKfL4eHBPLKScP7vOyl
         OT9Rd6r6vHjAhX9YeMznm0doniZwc6cnT+2mdrKp7IL0QoAtQIUQq4lRetEogSRL5Ua4
         Xvd5N8keEi8DwbTw5+y0Ai3RWeC2+Ua7Omu4/KSKGnp+HRBRXJMBEFxnryorxyaf+0lw
         yiEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8jWaaLZ6u+//lYSPDVEE3dbvuuSNRm/3gTqtS9kbnx0=;
        b=faTXovmItooClg5nrK88odZX1hBC57xruWqOdEqa3KUd/iDUuMpIMNiHypinhQ5CyY
         VwMfRghNNiquIp1UjQHUfJqVy1lMHIShpaPRhdxBh9gQpAK/HViUWmQdZvy/EagM6Lfu
         ZxmcOUQREa44w8FqG42Syil0Q9VcsdsSEFuD/l2A9gdgIxBhi1sWfnf44FeNnIwNtxZp
         qedfm7NQqvH3KDI1P7yjnlQPPtL0AXhWHNkL7Ek/G6oX4GMNbAoffRvw6DgcVs7mqjCY
         0ItXQiQAyHaCl1h0bB9iDLtcqiwnF4dNmi7wppiW7OCP5ZzrTpFapNddY0AO6M6r8ZrY
         n7GA==
X-Gm-Message-State: AOAM533kE+j3PxKcrRogo9DWgLphOfdv1o9OuwlyK3X0iAgltvUIE16D
        aG7aIG6RkbxgTkogXULFHYOi
X-Google-Smtp-Source: ABdhPJyFpBRTz/MrkTBJo4nBAwtDEt9Gy16vrdty4l78WVcz2wkkIZh+z2RUkx80eIw41g+lZuUNbg==
X-Received: by 2002:a62:8fca:0:b029:1a9:39bc:ed37 with SMTP id n193-20020a628fca0000b02901a939bced37mr2632663pfd.61.1611032674277;
        Mon, 18 Jan 2021 21:04:34 -0800 (PST)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id m27sm641344pgn.62.2021.01.18.21.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 21:04:33 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v3 00/11] Introduce VDUSE - vDPA Device in Userspace
Date:   Tue, 19 Jan 2021 12:59:09 +0800
Message-Id: <20210119045920.447-1-xieyongji@bytedance.com>
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

Xie Yongji (11):
  eventfd: track eventfd_signal() recursion depth separately in different cases
  eventfd: Increase the recursion depth of eventfd_signal()
  vdpa: Remove the restriction that only supports virtio-net devices
  vhost-vdpa: protect concurrent access to vhost device iotlb
  vdpa: shared virtual addressing support
  vhost-vdpa: Add an opaque pointer for vhost IOTLB
  vdpa: Pass the netlink attributes to ops.dev_add()
  vduse: Introduce VDUSE - vDPA Device in Userspace
  vduse: Add VDUSE_GET_DEV ioctl
  vduse: grab the module's references until there is no vduse device
  vduse: Introduce a workqueue for irq injection

 Documentation/driver-api/vduse.rst                 |   85 ++
 Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
 drivers/vdpa/Kconfig                               |    7 +
 drivers/vdpa/Makefile                              |    1 +
 drivers/vdpa/ifcvf/ifcvf_main.c                    |    2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |    2 +-
 drivers/vdpa/vdpa.c                                |    7 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   17 +-
 drivers/vdpa/vdpa_user/Makefile                    |    5 +
 drivers/vdpa/vdpa_user/eventfd.c                   |  229 ++++
 drivers/vdpa/vdpa_user/eventfd.h                   |   48 +
 drivers/vdpa/vdpa_user/iova_domain.c               |  426 +++++++
 drivers/vdpa/vdpa_user/iova_domain.h               |   68 ++
 drivers/vdpa/vdpa_user/vduse.h                     |   62 +
 drivers/vdpa/vdpa_user/vduse_dev.c                 | 1249 ++++++++++++++++++++
 drivers/vhost/iotlb.c                              |    5 +-
 drivers/vhost/vdpa.c                               |  130 +-
 drivers/vhost/vhost.c                              |    4 +-
 fs/aio.c                                           |    3 +-
 fs/eventfd.c                                       |   20 +-
 include/linux/eventfd.h                            |    5 +-
 include/linux/vdpa.h                               |   17 +-
 include/linux/vhost_iotlb.h                        |    8 +-
 include/uapi/linux/vdpa.h                          |    1 +
 include/uapi/linux/vduse.h                         |  126 ++
 25 files changed, 2458 insertions(+), 70 deletions(-)
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

