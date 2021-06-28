Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8053B585B
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 06:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhF1EiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 00:38:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230203AbhF1EiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 00:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624854934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mnTDFtsoSEiMYILuCVO1PH8F5a59UkbYZZKoDIAh+I8=;
        b=g7kek4/zTlA55XdsEuvPY7DCjbaNpMZMWXjDykz4oSKuV0o8jcIsrKgGdpSwqw3BIVnwVd
        Uh4Q8ym4gD5bPILLkEWRs72CGk+j0XX2VxC9I1/e/2+QUxDPxx9/5khFiQU/nBiov89rxu
        GdkXGcTpFFClvmha/lah5PDajeYrVFw=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-QGuK-8aLPnKoiQd5yTeeeA-1; Mon, 28 Jun 2021 00:35:33 -0400
X-MC-Unique: QGuK-8aLPnKoiQd5yTeeeA-1
Received: by mail-pj1-f70.google.com with SMTP id x2-20020a17090ab002b029016e8b858193so11202926pjq.3
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 21:35:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mnTDFtsoSEiMYILuCVO1PH8F5a59UkbYZZKoDIAh+I8=;
        b=J0b2YgIbax0FTGB3aydoYS5elbceLQbMZRtYT50+wnE1e/XXzddM7O98zbEs6LOgLU
         JE0dX8YS+2TdNT+ugvA9YOxOxWeouvayiqsWbIiHtJDI1nqPQC9c7m1peD7Rnp0Zx6Mb
         7SRAPt3M53tSpbD3wLVBhwQMPOnocAV8UOrtvOQmF71rAK2qoWtfvkpMBbvSl9n9KhLU
         n4YmiTvxCErWQw64akJEihjDK2924BcnWuO1Bky4pyxuDrSB4IYTuk7FX/IvLH29gNcY
         Xqc4Lz4VbMk60frEUpKqHpe58Dp+nWCvTR1HGcAfxOJZIXOt5O0bCFIcptdkWWS5nu1K
         QPbA==
X-Gm-Message-State: AOAM5316W5RFuLLhlNn5+AXlMA9ynUo0+mlPfh3mUszeN63q+V2A5O8m
        7O9OCgg1pZfJgw2mLMDjmKlEJvM7MxVWkq/eCnqZamgMsVnMGgIgsl5XFEM1J63Y9EQ6JzQ/bpV
        GQikENOZucJa1U3Sr
X-Received: by 2002:a17:902:7103:b029:124:72fd:fbd1 with SMTP id a3-20020a1709027103b029012472fdfbd1mr21345292pll.64.1624854932090;
        Sun, 27 Jun 2021 21:35:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx52zTA6pmge2S10uyiK3pEuGZ+MqwPtRdFfD6S42HxmdgC7sLtwit/u9sNWEF4grCOA9w1Iw==
X-Received: by 2002:a17:902:7103:b029:124:72fd:fbd1 with SMTP id a3-20020a1709027103b029012472fdfbd1mr21345275pll.64.1624854931785;
        Sun, 27 Jun 2021 21:35:31 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id lt14sm12902157pjb.47.2021.06.27.21.35.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Jun 2021 21:35:31 -0700 (PDT)
Subject: Re: [PATCH v8 00/10] Introduce VDUSE - vDPA Device in Userspace
To:     Liu Xiaodong <xiaodong.liu@intel.com>,
        Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210628103309.GA205554@storage2.sh.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bdbe3a79-e5ce-c3a5-4c68-c11c65857377@redhat.com>
Date:   Mon, 28 Jun 2021 12:35:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210628103309.GA205554@storage2.sh.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/28 ÏÂÎç6:33, Liu Xiaodong Ð´µÀ:
> On Tue, Jun 15, 2021 at 10:13:21PM +0800, Xie Yongji wrote:
>> This series introduces a framework that makes it possible to implement
>> software-emulated vDPA devices in userspace. And to make it simple, the
>> emulated vDPA device's control path is handled in the kernel and only the
>> data path is implemented in the userspace.
>>
>> Since the emuldated vDPA device's control path is handled in the kernel,
>> a message mechnism is introduced to make userspace be aware of the data
>> path related changes. Userspace can use read()/write() to receive/reply
>> the control messages.
>>
>> In the data path, the core is mapping dma buffer into VDUSE daemon's
>> address space, which can be implemented in different ways depending on
>> the vdpa bus to which the vDPA device is attached.
>>
>> In virtio-vdpa case, we implements a MMU-based on-chip IOMMU driver with
>> bounce-buffering mechanism to achieve that. And in vhost-vdpa case, the dma
>> buffer is reside in a userspace memory region which can be shared to the
>> VDUSE userspace processs via transferring the shmfd.
>>
>> The details and our user case is shown below:
>>
>> ------------------------    -------------------------   ----------------------------------------------
>> |            Container |    |              QEMU(VM) |   |                               VDUSE daemon |
>> |       ---------      |    |  -------------------  |   | ------------------------- ---------------- |
>> |       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | | vDPA device emulation | | block driver | |
>> ------------+-----------     -----------+------------   -------------+----------------------+---------
>>              |                           |                            |                      |
>>              |                           |                            |                      |
>> ------------+---------------------------+----------------------------+----------------------+---------
>> |    | block device |           |  vhost device |            | vduse driver |          | TCP/IP |    |
>> |    -------+--------           --------+--------            -------+--------          -----+----    |
>> |           |                           |                           |                       |        |
>> | ----------+----------       ----------+-----------         -------+-------                |        |
>> | | virtio-blk driver |       |  vhost-vdpa driver |         | vdpa device |                |        |
>> | ----------+----------       ----------+-----------         -------+-------                |        |
>> |           |      virtio bus           |                           |                       |        |
>> |   --------+----+-----------           |                           |                       |        |
>> |                |                      |                           |                       |        |
>> |      ----------+----------            |                           |                       |        |
>> |      | virtio-blk device |            |                           |                       |        |
>> |      ----------+----------            |                           |                       |        |
>> |                |                      |                           |                       |        |
>> |     -----------+-----------           |                           |                       |        |
>> |     |  virtio-vdpa driver |           |                           |                       |        |
>> |     -----------+-----------           |                           |                       |        |
>> |                |                      |                           |    vdpa bus           |        |
>> |     -----------+----------------------+---------------------------+------------           |        |
>> |                                                                                        ---+---     |
>> -----------------------------------------------------------------------------------------| NIC |------
>>                                                                                           ---+---
>>                                                                                              |
>>                                                                                     ---------+---------
>>                                                                                     | Remote Storages |
>>                                                                                     -------------------
>>
>> We make use of it to implement a block device connecting to
>> our distributed storage, which can be used both in containers and
>> VMs. Thus, we can have an unified technology stack in this two cases.
>>
>> To test it with null-blk:
>>
>>    $ qemu-storage-daemon \
>>        --chardev socket,id=charmonitor,path=/tmp/qmp.sock,server,nowait \
>>        --monitor chardev=charmonitor \
>>        --blockdev driver=host_device,cache.direct=on,aio=native,filename=/dev/nullb0,node-name=disk0 \
>>        --export type=vduse-blk,id=test,node-name=disk0,writable=on,name=vduse-null,num-queues=16,queue-size=128
>>
>> The qemu-storage-daemon can be found at https://github.com/bytedance/qemu/tree/vduse
>>
>> To make the userspace VDUSE processes such as qemu-storage-daemon able to
>> be run by an unprivileged user. We did some works on virtio driver to avoid
>> trusting device, including:
>>
>>    - validating the used length:
>>
>>      * https://lore.kernel.org/lkml/20210531135852.113-1-xieyongji@bytedance.com/
>>      * https://lore.kernel.org/lkml/20210525125622.1203-1-xieyongji@bytedance.com/
>>
>>    - validating the device config:
>>
>>      * https://lore.kernel.org/lkml/20210615104810.151-1-xieyongji@bytedance.com/
>>
>>    - validating the device response:
>>
>>      * https://lore.kernel.org/lkml/20210615105218.214-1-xieyongji@bytedance.com/
>>
>> Since I'm not sure if I missing something during auditing, especially on some
>> virtio device drivers that I'm not familiar with, we limit the supported device
>> type to virtio block device currently. The support for other device types can be
>> added after the security issue of corresponding device driver is clarified or
>> fixed in the future.
>>
>> Future work:
>>    - Improve performance
>>    - Userspace library (find a way to reuse device emulation code in qemu/rust-vmm)
>>    - Support more device types
>>
>> V7 to V8:
>> - Rebased to newest kernel tree
>> - Rework VDUSE driver to handle the device's control path in kernel
>> - Limit the supported device type to virtio block device
>> - Export free_iova_fast()
>> - Remove the virtio-blk and virtio-scsi patches (will send them alone)
>> - Remove all module parameters
>> - Use the same MAJOR for both control device and VDUSE devices
>> - Avoid eventfd cleanup in vduse_dev_release()
>>
>> V6 to V7:
>> - Export alloc_iova_fast()
>> - Add get_config_size() callback
>> - Add some patches to avoid trusting virtio devices
>> - Add limited device emulation
>> - Add some documents
>> - Use workqueue to inject config irq
>> - Add parameter on vq irq injecting
>> - Rename vduse_domain_get_mapping_page() to vduse_domain_get_coherent_page()
>> - Add WARN_ON() to catch message failure
>> - Add some padding/reserved fields to uAPI structure
>> - Fix some bugs
>> - Rebase to vhost.git
>>
>> V5 to V6:
>> - Export receive_fd() instead of __receive_fd()
>> - Factor out the unmapping logic of pa and va separatedly
>> - Remove the logic of bounce page allocation in page fault handler
>> - Use PAGE_SIZE as IOVA allocation granule
>> - Add EPOLLOUT support
>> - Enable setting API version in userspace
>> - Fix some bugs
>>
>> V4 to V5:
>> - Remove the patch for irq binding
>> - Use a single IOTLB for all types of mapping
>> - Factor out vhost_vdpa_pa_map()
>> - Add some sample codes in document
>> - Use receice_fd_user() to pass file descriptor
>> - Fix some bugs
>>
>> V3 to V4:
>> - Rebase to vhost.git
>> - Split some patches
>> - Add some documents
>> - Use ioctl to inject interrupt rather than eventfd
>> - Enable config interrupt support
>> - Support binding irq to the specified cpu
>> - Add two module parameter to limit bounce/iova size
>> - Create char device rather than anon inode per vduse
>> - Reuse vhost IOTLB for iova domain
>> - Rework the message mechnism in control path
>>
>> V2 to V3:
>> - Rework the MMU-based IOMMU driver
>> - Use the iova domain as iova allocator instead of genpool
>> - Support transferring vma->vm_file in vhost-vdpa
>> - Add SVA support in vhost-vdpa
>> - Remove the patches on bounce pages reclaim
>>
>> V1 to V2:
>> - Add vhost-vdpa support
>> - Add some documents
>> - Based on the vdpa management tool
>> - Introduce a workqueue for irq injection
>> - Replace interval tree with array map to store the iova_map
>>
>> Xie Yongji (10):
>>    iova: Export alloc_iova_fast() and free_iova_fast();
>>    file: Export receive_fd() to modules
>>    eventfd: Increase the recursion depth of eventfd_signal()
>>    vhost-iotlb: Add an opaque pointer for vhost IOTLB
>>    vdpa: Add an opaque pointer for vdpa_config_ops.dma_map()
>>    vdpa: factor out vhost_vdpa_pa_map() and vhost_vdpa_pa_unmap()
>>    vdpa: Support transferring virtual addressing during DMA mapping
>>    vduse: Implement an MMU-based IOMMU driver
>>    vduse: Introduce VDUSE - vDPA Device in Userspace
>>    Documentation: Add documentation for VDUSE
>>
>>   Documentation/userspace-api/index.rst              |    1 +
>>   Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
>>   Documentation/userspace-api/vduse.rst              |  222 +++
>>   drivers/iommu/iova.c                               |    2 +
>>   drivers/vdpa/Kconfig                               |   10 +
>>   drivers/vdpa/Makefile                              |    1 +
>>   drivers/vdpa/ifcvf/ifcvf_main.c                    |    2 +-
>>   drivers/vdpa/mlx5/net/mlx5_vnet.c                  |    2 +-
>>   drivers/vdpa/vdpa.c                                |    9 +-
>>   drivers/vdpa/vdpa_sim/vdpa_sim.c                   |    8 +-
>>   drivers/vdpa/vdpa_user/Makefile                    |    5 +
>>   drivers/vdpa/vdpa_user/iova_domain.c               |  545 ++++++++
>>   drivers/vdpa/vdpa_user/iova_domain.h               |   73 +
>>   drivers/vdpa/vdpa_user/vduse_dev.c                 | 1453 ++++++++++++++++++++
>>   drivers/vdpa/virtio_pci/vp_vdpa.c                  |    2 +-
>>   drivers/vhost/iotlb.c                              |   20 +-
>>   drivers/vhost/vdpa.c                               |  148 +-
>>   fs/eventfd.c                                       |    2 +-
>>   fs/file.c                                          |    6 +
>>   include/linux/eventfd.h                            |    5 +-
>>   include/linux/file.h                               |    7 +-
>>   include/linux/vdpa.h                               |   21 +-
>>   include/linux/vhost_iotlb.h                        |    3 +
>>   include/uapi/linux/vduse.h                         |  143 ++
>>   24 files changed, 2641 insertions(+), 50 deletions(-)
>>   create mode 100644 Documentation/userspace-api/vduse.rst
>>   create mode 100644 drivers/vdpa/vdpa_user/Makefile
>>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
>>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
>>   create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
>>   create mode 100644 include/uapi/linux/vduse.h
>>
>> --
>> 2.11.0
> Hi, Yongji
>
> Great work! your method is really wise that implements a software IOMMU
> so that data path gets processed by userspace application efficiently.
> Sorry, I've just realized your work and patches.
>
>
> I was working on a similar thing aiming to get vhost-user-blk device
> from SPDK vhost-target to be exported as local host kernel block device.
> It's diagram is like this:
>
>
>                                  -----------------------------
> ------------------------        |    -----------------      |    ---------------------------------------
> |   <RunC Container>   |     <<<<<<<<| Shared-Memory |>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>        |
> |       ---------      |     v  |    -----------------      |    |                            v        |
> |       |dev/vdx|      |     v  |   <virtio-local-agent>    |    |      <Vhost-user Target>   v        |
> ------------+-----------     v  | ------------------------  |    |  --------------------------v------  |
>              |                v  | |/dev/virtio-local-ctrl|  |    |  | unix socket |   |block driver |  |
>              |                v  ------------+----------------    --------+--------------------v---------
>              |                v              |                            |                    v
> ------------+----------------v--------------+----------------------------+--------------------v--------|
> |    | block device |        v      |  Misc device |                     |                    v        |
> |    -------+--------        v      --------+-------                     |                    v        |
> |           |                v              |                            |                    v        |
> | ----------+----------      v              |                            |                    v        |
> | | virtio-blk driver |      v              |                            |                    v        |
> | ----------+----------      v              |                            |                    v        |
> |           | virtio bus     v              |                            |                    v        |
> |   --------+---+-------     v              |                            |                    v        |
> |               |            v              |                            |                    v        |
> |               |            v              |                            |                    v        |
> |     ----------+----------  v     ---------+-----------                 |                    v        |
> |     | virtio-blk device |--<----| virtio-local driver |----------------<                    v        |
> |     ----------+----------       ----------+-----------                                      v        |
> |                                                                                    ---------+--------|
> -------------------------------------------------------------------------------------| RNIC |--| PCIe |-
>                                                                                       ----+---  | NVMe |
>                                                                                           |     --------
>                                                                                  ---------+---------
>                                                                                  | Remote Storages |
>                                                                                  -------------------
>
>
> I just draft out an initial proof version. When seeing your RFC mail,
> I'm thinking that SPDK target may depends on your work, so I could
> directly drop mine.
> But after a glance of the RFC patches, seems it is not so easy or
> efficient to get vduse leveraged by SPDK.
> (Please correct me, if I get wrong understanding on vduse. :) )
>
> The large barrier is bounce-buffer mapping: SPDK requires hugepages
> for NVMe over PCIe and RDMA, so take some preallcoated hugepages to
> map as bounce buffer is necessary. Or it's hard to avoid an extra
> memcpy from bounce-buffer to hugepage.
> If you can add an option to map hugepages as bounce-buffer,
> then SPDK could also be a potential user of vduse.


Several issues:

- VDUSE needs to limit the total size of the bounce buffers (64M if I 
was not wrong). Does it work for SPDK?
- VDUSE can use hugepages but I'm not sure we can mandate hugepages (or 
we need introduce new flags for supporting this)

Thanks


>
> It would be better if SPDK vhost-target could leverage the datapath of
> vduse directly and efficiently. Even the control path is vdpa based,
> we may work out one daemon as agent to bridge SPDK vhost-target with vduse.
> Then users who already deployed SPDK vhost-target, can smoothly run
> some agent daemon without code modification on SPDK vhost-target itself.
> (It is only better-to-have for SPDK vhost-target app, not mandatory for SPDK) :)
> At least, some small barrier is there that blocked a vhost-target use vduse
> datapath efficiently:
> - Current IO completion irq of vduse is IOCTL based. If add one option
> to get it eventfd based, then vhost-target can directly notify IO
> completion via negotiated eventfd.
>
>
> Thanks
>  From Xiaodong
>
>
>
>
>
> 									
>

