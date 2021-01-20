Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6A42FC8A0
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbhATDTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730025AbhATCni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 21:43:38 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D336C0613C1
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 18:42:57 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id rv9so12644248ejb.13
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 18:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JR8SOonsoVeZ8kYkjCoOcP9efLU2rmV1xGsQBGl12Mw=;
        b=K/xcQwvp8OcJzvLXD291/b7JN2ZLqodtGv+7Nc0UWpyntg59mfHj33rmittUV2AFnz
         S7ugw2f8IUSpP1WGldlG+cW4o0MhDDed80uoEYHZYt9djdB4HusYu/I3mGpt/JmsmauH
         Gk9NDjKk8lkF3IYBqCcbQHgVWlmTPQbAp7+cInFCQFNmUAAL4/SvH9Yz27CGGa9kuAhd
         Mw6iu9VJyp+G0lYkZKi1sxTBkf8tFYzKNll2ROGtd+e56MbsAIVXbKlBCvfsZEoDdVp8
         LPdC1foVlfmVPp0Lmak81wwlPtFKBdVpq59g0ue/nHkGFbAHHuPHF/cDtYDfuGlpNn+t
         wHQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JR8SOonsoVeZ8kYkjCoOcP9efLU2rmV1xGsQBGl12Mw=;
        b=mJehD3bwdNZMlDGsV0eHlpKiaLOObpFsU+3nky6zhiqxcOm574PEztMceu6cqSeZhu
         NafEckXcd4fYECrJpv0sWp0xBbmToVyro1jOZ5HwVhKSHLhTEW5iiUCam0tVHs2npnp1
         7K2nis/iKEWV1sD6gNj82wfa04MUuuVXdpgLT1RRr9h8TNO5FUYnN4/NGr5Ql466r523
         Wqn5J34KpR8ifyQMB3IiWhOZayVEDuHF6239AfWZbf69C+hTceY7CeE4BV6md5dBGfR8
         A0ZBI4geHP7CJrCQzArFDzeYlDG4HJoXe2JhA4WBlKp6zCBZJ9HZEUJ7wKj/V9wnoT7S
         2CeA==
X-Gm-Message-State: AOAM532ZdUZbySzsnXnTcBzZulUfzc5SNfuG01JTrfZg7ltQdGriAFmY
        jMZTIgnY8ka7M3Z23QV/Ng5M2SnctRaIn7gBlmrA
X-Google-Smtp-Source: ABdhPJwEQPIeZ/X4lntOaNcOvhEGY9W1dEeC5jUwXvKMinslpAWrnkhUJi+jpqR6Zcv4ZbBNsvWC8O9kA6bt7S6H+D8=
X-Received: by 2002:a17:906:d0c2:: with SMTP id bq2mr4751150ejb.1.1611110576230;
 Tue, 19 Jan 2021 18:42:56 -0800 (PST)
MIME-Version: 1.0
References: <20210119045920.447-1-xieyongji@bytedance.com> <20210119050756.600-1-xieyongji@bytedance.com>
 <20210119050756.600-2-xieyongji@bytedance.com> <cfdc418c-7559-c6b1-6d8d-8f3a91a24f2b@infradead.org>
In-Reply-To: <cfdc418c-7559-c6b1-6d8d-8f3a91a24f2b@infradead.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 20 Jan 2021 10:42:45 +0800
Message-ID: <CACycT3vyt24GyF8dcp8NgtaYJ_f17SPHnyzi17TrVG4RoX=cYA@mail.gmail.com>
Subject: Re: Re: [RFC v3 08/11] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 1:54 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Hi,
>
> Documentation comments only:
>

Will fix it.

Thanks,
Yongji


> On 1/18/21 9:07 PM, Xie Yongji wrote:
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >  Documentation/driver-api/vduse.rst                 |   85 ++
> >
> > diff --git a/Documentation/driver-api/vduse.rst b/Documentation/driver-api/vduse.rst
> > new file mode 100644
> > index 000000000000..9418a7f6646b
> > --- /dev/null
> > +++ b/Documentation/driver-api/vduse.rst
> > @@ -0,0 +1,85 @@
> > +==================================
> > +VDUSE - "vDPA Device in Userspace"
> > +==================================
> > +
> > +vDPA (virtio data path acceleration) device is a device that uses a
> > +datapath which complies with the virtio specifications with vendor
> > +specific control path. vDPA devices can be both physically located on
> > +the hardware or emulated by software. VDUSE is a framework that makes it
> > +possible to implement software-emulated vDPA devices in userspace.
> > +
> > +How VDUSE works
> > +------------
> > +Each userspace vDPA device is created by the VDUSE_CREATE_DEV ioctl on
> > +the VDUSE character device (/dev/vduse). Then a file descriptor pointing
> > +to the new resources will be returned, which can be used to implement the
> > +userspace vDPA device's control path and data path.
> > +
> > +To implement control path, the read/write operations to the file descriptor
> > +will be used to receive/reply the control messages from/to VDUSE driver.
> > +Those control messages are mostly based on the vdpa_config_ops which defines
> > +a unified interface to control different types of vDPA device.
> > +
> > +The following types of messages are provided by the VDUSE framework now:
> > +
> > +- VDUSE_SET_VQ_ADDR: Set the addresses of the different aspects of virtqueue.
> > +
> > +- VDUSE_SET_VQ_NUM: Set the size of virtqueue
> > +
> > +- VDUSE_SET_VQ_READY: Set ready status of virtqueue
> > +
> > +- VDUSE_GET_VQ_READY: Get ready status of virtqueue
> > +
> > +- VDUSE_SET_VQ_STATE: Set the state (last_avail_idx) for virtqueue
> > +
> > +- VDUSE_GET_VQ_STATE: Get the state (last_avail_idx) for virtqueue
> > +
> > +- VDUSE_SET_FEATURES: Set virtio features supported by the driver
> > +
> > +- VDUSE_GET_FEATURES: Get virtio features supported by the device
> > +
> > +- VDUSE_SET_STATUS: Set the device status
> > +
> > +- VDUSE_GET_STATUS: Get the device status
> > +
> > +- VDUSE_SET_CONFIG: Write to device specific configuration space
> > +
> > +- VDUSE_GET_CONFIG: Read from device specific configuration space
> > +
> > +- VDUSE_UPDATE_IOTLB: Notify userspace to update the memory mapping in device IOTLB
> > +
> > +Please see include/linux/vdpa.h for details.
> > +
> > +In the data path, vDPA device's iova regions will be mapped into userspace with
> > +the help of VDUSE_IOTLB_GET_FD ioctl on the userspace vDPA device fd:
> > +
> > +- VDUSE_IOTLB_GET_FD: get the file descriptor to iova region. Userspace can
> > +  access this iova region by passing the fd to mmap(2).
> > +
> > +Besides, the eventfd mechanism is used to trigger interrupt callbacks and
> > +receive virtqueue kicks in userspace. The following ioctls on the userspace
> > +vDPA device fd are provided to support that:
> > +
> > +- VDUSE_VQ_SETUP_KICKFD: set the kickfd for virtqueue, this eventfd is used
> > +  by VDUSE driver to notify userspace to consume the vring.
> > +
> > +- VDUSE_VQ_SETUP_IRQFD: set the irqfd for virtqueue, this eventfd is used
> > +  by userspace to notify VDUSE driver to trigger interrupt callbacks.
> > +
> > +MMU-based IOMMU Driver
> > +----------------------
> > +In virtio-vdpa case, VDUSE framework implements a MMU-based on-chip IOMMU
>
>                                                    an MMU-based
>
> > +driver to support mapping the kernel dma buffer into the userspace iova
>
>                                         DMA
>
> > +region dynamically.
> > +
> > +The basic idea behind this driver is treating MMU (VA->PA) as IOMMU (IOVA->PA).
> > +The driver will set up MMU mapping instead of IOMMU mapping for the DMA transfer
> > +so that the userspace process is able to use its virtual address to access
> > +the dma buffer in kernel.
>
>        DMA
>
> > +
> > +And to avoid security issue, a bounce-buffering mechanism is introduced to
> > +prevent userspace accessing the original buffer directly which may contain other
> > +kernel data. During the mapping, unmapping, the driver will copy the data from
> > +the original buffer to the bounce buffer and back, depending on the direction of
> > +the transfer. And the bounce-buffer addresses will be mapped into the user address
> > +space instead of the original one.
>
>
> thanks.
> --
> ~Randy
>
