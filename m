Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA7D3B6CB3
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 05:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbhF2DCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 23:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhF2DCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 23:02:30 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E99C061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 20:00:03 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id l24so971763edr.11
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 20:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tC8+eycXVZtpiOsN/AMjjNqu/G/aFD3wjzDfuO22bFA=;
        b=bh0RUiARewsKN3Hk1A5XuOHjErIfF3IJybc5hLJYfbWfR4avSK5I7hdl76VNLcFu7q
         8088kCiIqV50Zrxug6TOBHKzv4OP9W7BbMhVTNhAk6ocCnWhAIqqnTT10FM8YaafrMCS
         fobCNy4GG347XSHq5u7Sf803O0qFzJMLrz+vnGfYFFr/klFuR3RPi3Iak6Rw9TnxzkvS
         jm4cY1IhMqRmgfKwUNeapZTIbX9ZLISiGEUmAI75ltfyEpKq4cYArVE4ODOc/u0hrevV
         InesZfRLmS4f95S2/JcbikR32ocp9dRZ0Fyc+5Csa59s/feSzPNRPU4jOKrG7kq+cB/e
         t+nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tC8+eycXVZtpiOsN/AMjjNqu/G/aFD3wjzDfuO22bFA=;
        b=FfY5T+ye6TI0Q2hy/6zYeLqCfPI7FbsVC+0jwlLbbpMuvNFO6JDK7ALMibvzr+XfxP
         S6vt0lE7XRPOV1Tra7/WdGkkHXrj6sWjV1xkWZ+C6+yocIEUkW+XR0tQjCSA9VXO7zI+
         hFFwn0/yVwho4Qw3hPIMy1ewxC9RL1/Dk410RYgp09sl47mYLYkD6B/dMqrMODhvKMWn
         2VwxfvUrKfOL1OnLS2+R4u5aZDhTv6StORTG2P2uBb+SwjZ+xmc3kSsnOtNEJiwDddvp
         p7owRnpuseOLAqOBwKjBrpf/9pNFEWzNsFeEXVDs4PL7dj8rFtZZZldKR/A22+W+bkzL
         5gAw==
X-Gm-Message-State: AOAM531gjsOrwgBNNz8FOurqMPeSZAWAU33XCBaZZ2N0KJuv8MM8Y9/g
        WnOemk2g8heu3c30FEUNUyobmh7tWJwp90QAxGNy
X-Google-Smtp-Source: ABdhPJzg96tWiFpzAbCVxt+xiS/U5xotludj60TImfwJQUK2KdEwY2E/dV2mAC5D/i1Omtd+LCI76RG3K5V1lZFzRC8=
X-Received: by 2002:a50:ff01:: with SMTP id a1mr36653348edu.253.1624935602535;
 Mon, 28 Jun 2021 20:00:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <20210615141331.407-10-xieyongji@bytedance.com>
 <YNSatrDFsg+4VvH4@stefanha-x1.localdomain>
In-Reply-To: <YNSatrDFsg+4VvH4@stefanha-x1.localdomain>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 29 Jun 2021 10:59:51 +0800
Message-ID: <CACycT3vaXQ4dxC9QUzXXJs7og6TVqqVGa8uHZnTStacsYAiFwQ@mail.gmail.com>
Subject: Re: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 9:02 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Tue, Jun 15, 2021 at 10:13:30PM +0800, Xie Yongji wrote:
> > diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
> > new file mode 100644
> > index 000000000000..f21b2e51b5c8
> > --- /dev/null
> > +++ b/include/uapi/linux/vduse.h
> > @@ -0,0 +1,143 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +#ifndef _UAPI_VDUSE_H_
> > +#define _UAPI_VDUSE_H_
> > +
> > +#include <linux/types.h>
> > +
> > +#define VDUSE_API_VERSION    0
> > +
> > +#define VDUSE_NAME_MAX       256
> > +
> > +/* the control messages definition for read/write */
> > +
> > +enum vduse_req_type {
> > +     /* Get the state for virtqueue from userspace */
> > +     VDUSE_GET_VQ_STATE,
> > +     /* Notify userspace to start the dataplane, no reply */
> > +     VDUSE_START_DATAPLANE,
> > +     /* Notify userspace to stop the dataplane, no reply */
> > +     VDUSE_STOP_DATAPLANE,
> > +     /* Notify userspace to update the memory mapping in device IOTLB */
> > +     VDUSE_UPDATE_IOTLB,
> > +};
> > +
> > +struct vduse_vq_state {
> > +     __u32 index; /* virtqueue index */
> > +     __u32 avail_idx; /* virtqueue state (last_avail_idx) */
> > +};
> > +
> > +struct vduse_iova_range {
> > +     __u64 start; /* start of the IOVA range */
> > +     __u64 last; /* end of the IOVA range */
>
> Please clarify whether this describes a closed range [start, last] or an
> open range [start, last).
>

OK.

> > +};
> > +
> > +struct vduse_dev_request {
> > +     __u32 type; /* request type */
> > +     __u32 request_id; /* request id */
> > +#define VDUSE_REQ_FLAGS_NO_REPLY     (1 << 0) /* No need to reply */
> > +     __u32 flags; /* request flags */
> > +     __u32 reserved; /* for future use */
> > +     union {
> > +             struct vduse_vq_state vq_state; /* virtqueue state */
> > +             struct vduse_iova_range iova; /* iova range for updating */
> > +             __u32 padding[16]; /* padding */
> > +     };
> > +};
> > +
> > +struct vduse_dev_response {
> > +     __u32 request_id; /* corresponding request id */
> > +#define VDUSE_REQ_RESULT_OK  0x00
> > +#define VDUSE_REQ_RESULT_FAILED      0x01
> > +     __u32 result; /* the result of request */
> > +     __u32 reserved[2]; /* for future use */
> > +     union {
> > +             struct vduse_vq_state vq_state; /* virtqueue state */
> > +             __u32 padding[16]; /* padding */
> > +     };
> > +};
> > +
> > +/* ioctls */
> > +
> > +struct vduse_dev_config {
> > +     char name[VDUSE_NAME_MAX]; /* vduse device name */
> > +     __u32 vendor_id; /* virtio vendor id */
> > +     __u32 device_id; /* virtio device id */
> > +     __u64 features; /* device features */
> > +     __u64 bounce_size; /* bounce buffer size for iommu */
> > +     __u16 vq_size_max; /* the max size of virtqueue */
>
> The VIRTIO specification allows per-virtqueue sizes. A device can have
> two virtqueues, where the first one allows up to 1024 descriptors and
> the second one allows only 128 descriptors, for example.
>

Good point! But it looks like virtio-vdpa/virtio-pci doesn't support
that now. All virtqueues have the same maximum size.

> This constant seems to impose the constraint that all virtqueues have
> the same maximum size. Is this really necessary?
>

This will be used by vring_create_virtqueue(). We need to specify the
maximum queue size supported by the device.

> > +     __u16 padding; /* padding */
> > +     __u32 vq_num; /* the number of virtqueues */
> > +     __u32 vq_align; /* the allocation alignment of virtqueue's metadata */
>
> I'm not sure what this is?
>

 This will be used by vring_create_virtqueue() too.

> > +     __u32 config_size; /* the size of the configuration space */
> > +     __u32 reserved[15]; /* for future use */
> > +     __u8 config[0]; /* the buffer of the configuration space */
> > +};
> > +
> > +struct vduse_iotlb_entry {
> > +     __u64 offset; /* the mmap offset on fd */
> > +     __u64 start; /* start of the IOVA range */
> > +     __u64 last; /* last of the IOVA range */
>
> Same here, please specify whether this is an open range or a closed
> range.
>

Sure.

> > +#define VDUSE_ACCESS_RO 0x1
> > +#define VDUSE_ACCESS_WO 0x2
> > +#define VDUSE_ACCESS_RW 0x3
> > +     __u8 perm; /* access permission of this range */
> > +};
> > +
> > +struct vduse_config_update {
> > +     __u32 offset; /* offset from the beginning of configuration space */
> > +     __u32 length; /* the length to write to configuration space */
> > +     __u8 buffer[0]; /* buffer used to write from */
> > +};
> > +
> > +struct vduse_vq_info {
> > +     __u32 index; /* virtqueue index */
> > +     __u32 avail_idx; /* virtqueue state (last_avail_idx) */
> > +     __u64 desc_addr; /* address of desc area */
> > +     __u64 driver_addr; /* address of driver area */
> > +     __u64 device_addr; /* address of device area */
> > +     __u32 num; /* the size of virtqueue */
> > +     __u8 ready; /* ready status of virtqueue */
> > +};
> > +
> > +struct vduse_vq_eventfd {
> > +     __u32 index; /* virtqueue index */
> > +#define VDUSE_EVENTFD_DEASSIGN -1
> > +     int fd; /* eventfd, -1 means de-assigning the eventfd */
> > +};
> > +
> > +#define VDUSE_BASE   0x81
> > +
> > +/* Get the version of VDUSE API. This is used for future extension */
> > +#define VDUSE_GET_API_VERSION        _IOR(VDUSE_BASE, 0x00, __u64)
> > +
> > +/* Set the version of VDUSE API. */
> > +#define VDUSE_SET_API_VERSION        _IOW(VDUSE_BASE, 0x01, __u64)
> > +
> > +/* Create a vduse device which is represented by a char device (/dev/vduse/<name>) */
> > +#define VDUSE_CREATE_DEV     _IOW(VDUSE_BASE, 0x02, struct vduse_dev_config)
> > +
> > +/* Destroy a vduse device. Make sure there are no references to the char device */
> > +#define VDUSE_DESTROY_DEV    _IOW(VDUSE_BASE, 0x03, char[VDUSE_NAME_MAX])
> > +
> > +/*
> > + * Get a file descriptor for the first overlapped iova region,
> > + * -EINVAL means the iova region doesn't exist.
> > + */
> > +#define VDUSE_IOTLB_GET_FD   _IOWR(VDUSE_BASE, 0x04, struct vduse_iotlb_entry)
> > +
> > +/* Get the negotiated features */
> > +#define VDUSE_DEV_GET_FEATURES       _IOR(VDUSE_BASE, 0x05, __u64)
> > +
> > +/* Update the configuration space */
> > +#define VDUSE_DEV_UPDATE_CONFIG      _IOW(VDUSE_BASE, 0x06, struct vduse_config_update)
> > +
> > +/* Get the specified virtqueue's information */
> > +#define VDUSE_VQ_GET_INFO    _IOWR(VDUSE_BASE, 0x07, struct vduse_vq_info)
> > +
> > +/* Setup an eventfd to receive kick for virtqueue */
> > +#define VDUSE_VQ_SETUP_KICKFD        _IOW(VDUSE_BASE, 0x08, struct vduse_vq_eventfd)
> > +
> > +/* Inject an interrupt for specific virtqueue */
> > +#define VDUSE_VQ_INJECT_IRQ  _IOW(VDUSE_BASE, 0x09, __u32)
>
> There is not enough documentation to use this header file. For example,
> which ioctls are used with /dev/vduse and which are used with
> /dev/vduse/<name>?
>
> Please document that ioctl API fully. It will not only help userspace
> developers but also define what is part of the interface and what is an
> implementation detail that can change in the future.

OK, I will try to add more details.

Thanks,
Yongji
