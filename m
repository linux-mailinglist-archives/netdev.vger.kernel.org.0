Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A501442636
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 04:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhKBDzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 23:55:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232746AbhKBDzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 23:55:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635825154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l5JQX7PK3bUB+fO7KCHuTs96kpHZCzUz5hWvhokA8Wo=;
        b=RghOEjDL4afjnzXeL55cWpEv8TQnj+im4Xg6YL8Q9UZ8b7ywZC6RWYaVmoejXVlsUTxjML
        n7dqZkUimmxIM9cufFuSp3odoS4C/14M80PXhaH24MEFexRj+cJBoCu02k9Iibw0XbVwGL
        CZ0oKhiyg3N6AG4OyLVFjVRr3NKzuCU=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-omVXDmTxP36wFoH4v8X3jQ-1; Mon, 01 Nov 2021 23:52:33 -0400
X-MC-Unique: omVXDmTxP36wFoH4v8X3jQ-1
Received: by mail-lj1-f199.google.com with SMTP id n9-20020a2e9049000000b00212acec7473so6605209ljg.22
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 20:52:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l5JQX7PK3bUB+fO7KCHuTs96kpHZCzUz5hWvhokA8Wo=;
        b=KvnB+IgkQ13iEG+t6JI3uhDT0VYzkByoF+KfMBymz26DR4ana4DAQFhpaLdPdoR5JK
         rGrLinGR4Nf3KuiyNIov5JaaQsWGGuVPfY0MydHoOnWptTHLobK+i+XZ+qRN1iCN/Ion
         2/X6+QLqlHzTjml4pcNCO6BE8FpL0gW0V7TkSjIcqhWPmBh5TIpwb8d/deKYFv3Gmh8t
         2LNdcUheZ+tU19qVrBqXfYKEjA7sysGHURwO8UYw6iqcsrHRzuYbxSypqz62H0cWldD/
         LpFTZqq4qu2Ej10tw8df2qIDOEQYnESspZ8YqKamG3NEzqfYVcBfP+05vo+dPWfnqhIo
         zocw==
X-Gm-Message-State: AOAM533cXRNz7zmHwDm+AHhtstFWl+lPVe+fpzRZm41/3T7kBBfscmB+
        OLZHgp2Nbh8LzdSGc+/Ihzopbxe38SepT7FET9JE8f4T9340Xcnl6jedrBFpmjc0zWo1gRGGckk
        d8uzanmssG/Vb3aDQzO27buFTCqp5Kkwb
X-Received: by 2002:a2e:a5c8:: with SMTP id n8mr34920369ljp.307.1635825151459;
        Mon, 01 Nov 2021 20:52:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFQk+sE0CmE+gyBZ9tANj3V6182Ct3x1qzy7cGmMP3hS/SewKac2u33kWWjZYVFWZ9SvqxSnBV3r7bPJN+SIk=
X-Received: by 2002:a2e:a5c8:: with SMTP id n8mr34920347ljp.307.1635825151261;
 Mon, 01 Nov 2021 20:52:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200326140125.19794-1-jasowang@redhat.com> <20200326140125.19794-8-jasowang@redhat.com>
 <20211101141133.GA1073864@nvidia.com>
In-Reply-To: <20211101141133.GA1073864@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 2 Nov 2021 11:52:20 +0800
Message-ID: <CACGkMEtbs3u7J7krpkusfqczTU00+6o_YtZjD8htC=+Un9cNew@mail.gmail.com>
Subject: Re: [PATCH V9 7/9] vhost: introduce vDPA-based backend
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     mst <mst@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>, zhihong.wang@intel.com,
        rob.miller@broadcom.com, Xiao W Wang <xiao.w.wang@intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        eperezma <eperezma@redhat.com>, Cindy Lu <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ariel Adam <aadam@redhat.com>, jiri@mellanox.com,
        shahafs@mellanox.com, Harpreet Singh Anand <hanand@xilinx.com>,
        mhabets@solarflare.com, Gautam Dawar <gdawar@xilinx.com>,
        Saugat Mitra <saugatm@xilinx.com>, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, Tiwei Bie <tiwei.bie@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 10:11 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Thu, Mar 26, 2020 at 10:01:23PM +0800, Jason Wang wrote:
> > From: Tiwei Bie <tiwei.bie@intel.com>
> >
> > This patch introduces a vDPA-based vhost backend. This backend is
> > built on top of the same interface defined in virtio-vDPA and provides
> > a generic vhost interface for userspace to accelerate the virtio
> > devices in guest.
> >
> > This backend is implemented as a vDPA device driver on top of the same
> > ops used in virtio-vDPA. It will create char device entry named
> > vhost-vdpa-$index for userspace to use. Userspace can use vhost ioctls
> > on top of this char device to setup the backend.
> >
> > Vhost ioctls are extended to make it type agnostic and behave like a
> > virtio device, this help to eliminate type specific API like what
> > vhost_net/scsi/vsock did:
> >
> > - VHOST_VDPA_GET_DEVICE_ID: get the virtio device ID which is defined
> >   by virtio specification to differ from different type of devices
> > - VHOST_VDPA_GET_VRING_NUM: get the maximum size of virtqueue
> >   supported by the vDPA device
> > - VHSOT_VDPA_SET/GET_STATUS: set and get virtio status of vDPA device
> > - VHOST_VDPA_SET/GET_CONFIG: access virtio config space
> > - VHOST_VDPA_SET_VRING_ENABLE: enable a specific virtqueue
> >
> > For memory mapping, IOTLB API is mandated for vhost-vDPA which means
> > userspace drivers are required to use
> > VHOST_IOTLB_UPDATE/VHOST_IOTLB_INVALIDATE to add or remove mapping for
> > a specific userspace memory region.
> >
> > The vhost-vDPA API is designed to be type agnostic, but it allows net
> > device only in current stage. Due to the lacking of control virtqueue
> > support, some features were filter out by vhost-vdpa.
> >
> > We will enable more features and devices in the near future.
>
> [..]
>
> > +static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
> > +{
> > +     struct vdpa_device *vdpa = v->vdpa;
> > +     const struct vdpa_config_ops *ops = vdpa->config;
> > +     struct device *dma_dev = vdpa_get_dma_dev(vdpa);
> > +     struct bus_type *bus;
> > +     int ret;
> > +
> > +     /* Device want to do DMA by itself */
> > +     if (ops->set_map || ops->dma_map)
> > +             return 0;
> > +
> > +     bus = dma_dev->bus;
> > +     if (!bus)
> > +             return -EFAULT;
> > +
> > +     if (!iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
> > +             return -ENOTSUPP;
> > +
> > +     v->domain = iommu_domain_alloc(bus);
> > +     if (!v->domain)
> > +             return -EIO;
> > +
> > +     ret = iommu_attach_device(v->domain, dma_dev);
> > +     if (ret)
> > +             goto err_attach;
> >
>
> I've been looking at the security of iommu_attach_device() users, and
> I wonder if this is safe?
>
> The security question is if userspace is able to control the DMA
> address the devices uses? Eg if any of the cpu to device ring's are in
> userspace memory?
>
> For instance if userspace can tell the device to send a packet from an
> arbitrary user controlled address.

The map is validated via pin_user_pages() which guarantees that the
address is not arbitrary and must belong to userspace?

Thanks

>
> Thanks,
> Jason
>

