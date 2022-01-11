Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D4F48AD14
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 12:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239238AbiAKLy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 06:54:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53775 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239283AbiAKLy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 06:54:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641902097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L8tUAuU3sx4wnqm2mHqp+w//Djo25ItZNH0jpA9WCOg=;
        b=fqSQLKMmsDReoL19xKfx3Z0fgdD+i0T9pAf5w+PSn4ZggUCSjTJsgxu6+AcTYWB2F3JJCv
        17bOrlDey9RVXgA/xZGljfVF0NmtjCLxAt+SOZhgGwb+lo9W+5r+uu2E664yLkK6KaX3BL
        cySAw/Eexd1NjpV84RLU81wbcXc03B0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-4phqo1gqP5CJupEYaU4Lrw-1; Tue, 11 Jan 2022 06:54:55 -0500
X-MC-Unique: 4phqo1gqP5CJupEYaU4Lrw-1
Received: by mail-wm1-f71.google.com with SMTP id m15-20020a7bce0f000000b003473d477618so1401309wmc.8
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 03:54:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=L8tUAuU3sx4wnqm2mHqp+w//Djo25ItZNH0jpA9WCOg=;
        b=i3D8qi6eO6sriL05FSNQS4fENVh9a/H28h18ULrBwWMeh8aI8hD6qd9O3hoihDpI22
         pBCgvVe9vX1WLZtPt7u/RhscB29sWnEsDBgBrC2o4VwlVUkPECj5ik0DWCLk3wAE10GM
         m0/D7WLfyInox+Y3DCxzyCkA2+Ld9Mr3mAUDre+nDcepKBT753bsSz5g1bcuWbr5zYVq
         wNvURbcXb6nNLXfLubho0kWceCGIEe/Ax1inAMVGuEmas0uCyR6AJnLjVPDAyGuN2VDc
         SWp1K9/l/aM6eDUuQ58mVKG2vbMTV0lMZhKkRAQKK2LBIHZjCma7UvaAL+FAr4R7MUZF
         YUHQ==
X-Gm-Message-State: AOAM530uy0WCnpuRxhK2V3lhM9hkbeOauFkW3tca7jLnyHVed10V/yrz
        8+y2qLRedOwgm+704ZKenCtvg3vCs4X/UbKtzvJ1XG3RRQ4+dJEEb7qinQ3x2YywN/rO4tLo6rS
        4iwOv717cdhvHMcXL
X-Received: by 2002:a05:6000:184f:: with SMTP id c15mr3548874wri.73.1641902094697;
        Tue, 11 Jan 2022 03:54:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxMB9cKDt3oBelm1sFftDwQwVLNcfaNRNRFFSf7NuXogZYA8px0qiu/L2gStlBR5LFyvB4wcw==
X-Received: by 2002:a05:6000:184f:: with SMTP id c15mr3548846wri.73.1641902094469;
        Tue, 11 Jan 2022 03:54:54 -0800 (PST)
Received: from redhat.com ([2.55.5.100])
        by smtp.gmail.com with ESMTPSA id f10sm1710595wmg.43.2022.01.11.03.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 03:54:53 -0800 (PST)
Date:   Tue, 11 Jan 2022 06:54:48 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>,
        John Garry <john.garry@huawei.com>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 00/13] Introduce VDUSE - vDPA Device in Userspace
Message-ID: <20220111065301-mutt-send-email-mst@kernel.org>
References: <20210830141737.181-1-xieyongji@bytedance.com>
 <20220110075546-mutt-send-email-mst@kernel.org>
 <CACycT3v1aEViw7vV4x5qeGVPrSrO-BTDvQshEX35rx_X0Au2vw@mail.gmail.com>
 <20220110100911-mutt-send-email-mst@kernel.org>
 <CACycT3v6jo3-8ATWUzf659vV94a2oRrm-zQtGNDZd6OQr-MENA@mail.gmail.com>
 <20220110103938-mutt-send-email-mst@kernel.org>
 <CACycT3sbJC1Jn7NeWk_ccQ_2_YgKybjugfxmKpfgCP3Ayoju4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACycT3sbJC1Jn7NeWk_ccQ_2_YgKybjugfxmKpfgCP3Ayoju4w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 11:31:37AM +0800, Yongji Xie wrote:
> On Mon, Jan 10, 2022 at 11:44 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Jan 10, 2022 at 11:24:40PM +0800, Yongji Xie wrote:
> > > On Mon, Jan 10, 2022 at 11:10 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Mon, Jan 10, 2022 at 09:54:08PM +0800, Yongji Xie wrote:
> > > > > On Mon, Jan 10, 2022 at 8:57 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Mon, Aug 30, 2021 at 10:17:24PM +0800, Xie Yongji wrote:
> > > > > > > This series introduces a framework that makes it possible to implement
> > > > > > > software-emulated vDPA devices in userspace. And to make the device
> > > > > > > emulation more secure, the emulated vDPA device's control path is handled
> > > > > > > in the kernel and only the data path is implemented in the userspace.
> > > > > > >
> > > > > > > Since the emuldated vDPA device's control path is handled in the kernel,
> > > > > > > a message mechnism is introduced to make userspace be aware of the data
> > > > > > > path related changes. Userspace can use read()/write() to receive/reply
> > > > > > > the control messages.
> > > > > > >
> > > > > > > In the data path, the core is mapping dma buffer into VDUSE daemon's
> > > > > > > address space, which can be implemented in different ways depending on
> > > > > > > the vdpa bus to which the vDPA device is attached.
> > > > > > >
> > > > > > > In virtio-vdpa case, we implements a MMU-based software IOTLB with
> > > > > > > bounce-buffering mechanism to achieve that. And in vhost-vdpa case, the dma
> > > > > > > buffer is reside in a userspace memory region which can be shared to the
> > > > > > > VDUSE userspace processs via transferring the shmfd.
> > > > > > >
> > > > > > > The details and our user case is shown below:
> > > > > > >
> > > > > > > ------------------------    -------------------------   ----------------------------------------------
> > > > > > > |            Container |    |              QEMU(VM) |   |                               VDUSE daemon |
> > > > > > > |       ---------      |    |  -------------------  |   | ------------------------- ---------------- |
> > > > > > > |       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | | vDPA device emulation | | block driver | |
> > > > > > > ------------+-----------     -----------+------------   -------------+----------------------+---------
> > > > > > >             |                           |                            |                      |
> > > > > > >             |                           |                            |                      |
> > > > > > > ------------+---------------------------+----------------------------+----------------------+---------
> > > > > > > |    | block device |           |  vhost device |            | vduse driver |          | TCP/IP |    |
> > > > > > > |    -------+--------           --------+--------            -------+--------          -----+----    |
> > > > > > > |           |                           |                           |                       |        |
> > > > > > > | ----------+----------       ----------+-----------         -------+-------                |        |
> > > > > > > | | virtio-blk driver |       |  vhost-vdpa driver |         | vdpa device |                |        |
> > > > > > > | ----------+----------       ----------+-----------         -------+-------                |        |
> > > > > > > |           |      virtio bus           |                           |                       |        |
> > > > > > > |   --------+----+-----------           |                           |                       |        |
> > > > > > > |                |                      |                           |                       |        |
> > > > > > > |      ----------+----------            |                           |                       |        |
> > > > > > > |      | virtio-blk device |            |                           |                       |        |
> > > > > > > |      ----------+----------            |                           |                       |        |
> > > > > > > |                |                      |                           |                       |        |
> > > > > > > |     -----------+-----------           |                           |                       |        |
> > > > > > > |     |  virtio-vdpa driver |           |                           |                       |        |
> > > > > > > |     -----------+-----------           |                           |                       |        |
> > > > > > > |                |                      |                           |    vdpa bus           |        |
> > > > > > > |     -----------+----------------------+---------------------------+------------           |        |
> > > > > > > |                                                                                        ---+---     |
> > > > > > > -----------------------------------------------------------------------------------------| NIC |------
> > > > > > >                                                                                          ---+---
> > > > > > >                                                                                             |
> > > > > > >                                                                                    ---------+---------
> > > > > > >                                                                                    | Remote Storages |
> > > > > > >                                                                                    -------------------
> > > > > > >
> > > > > > > We make use of it to implement a block device connecting to
> > > > > > > our distributed storage, which can be used both in containers and
> > > > > > > VMs. Thus, we can have an unified technology stack in this two cases.
> > > > > > >
> > > > > > > To test it with null-blk:
> > > > > > >
> > > > > > >   $ qemu-storage-daemon \
> > > > > > >       --chardev socket,id=charmonitor,path=/tmp/qmp.sock,server,nowait \
> > > > > > >       --monitor chardev=charmonitor \
> > > > > > >       --blockdev driver=host_device,cache.direct=on,aio=native,filename=/dev/nullb0,node-name=disk0 \
> > > > > > >       --export type=vduse-blk,id=test,node-name=disk0,writable=on,name=vduse-null,num-queues=16,queue-size=128
> > > > > > >
> > > > > > > The qemu-storage-daemon can be found at https://github.com/bytedance/qemu/tree/vduse
> > > > > >
> > > > > > It's been half a year - any plans to upstream this?
> > > > >
> > > > > Yeah, this is on my to-do list this month.
> > > > >
> > > > > Sorry for taking so long... I've been working on another project
> > > > > enabling userspace RDMA with VDUSE for the past few months. So I
> > > > > didn't have much time for this. Anyway, I will submit the first
> > > > > version as soon as possible.
> > > > >
> > > > > Thanks,
> > > > > Yongji
> > > >
> > > > Oh fun. You mean like virtio-rdma? Or RDMA as a backend for regular
> > > > virtio?
> > > >
> > >
> > > Yes, like virtio-rdma. Then we can develop something like userspace
> > > rxe、siw or custom protocol with VDUSE.
> > >
> > > Thanks,
> > > Yongji
> >
> > Would be interesting to see the spec for that.
> 
> Will send it ASAP.
> 
> > The issues with RDMA revolved around the fact that current
> > apps tend to either use non-standard propocols for connection
> > establishment or use UD where there's IIRC no standard
> > at all. So QP numbers are hard to virtualize.
> > Similarly many use LIDs directly with the same effect.
> > GUIDs might be virtualizeable but no one went to the effort.
> >
> 
> Actually we aimed at emulating a soft RDMA with normal NIC (not use
> RDMA capability) rather than virtualizing a physical RDMA NIC into
> several vRDMA devices. If so, I think we won't have those issues,
> right?

Right, maybe you won't.

> > To say nothing about the interaction with memory overcommit.
> >
> 
> I don't get you here. Could you give me more details?
> 
> Thanks,
> Yongji

RDMA devices tend to want to pin the memory under DMA.

-- 
MST

