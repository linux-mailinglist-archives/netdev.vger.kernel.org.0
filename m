Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F11C489BD9
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 16:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiAJPJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 10:09:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40043 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235917AbiAJPJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 10:09:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641827387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pqCR8DvhBxiCC4TzGlm/t/7v2g7znFq4gFV1cmWoEXc=;
        b=FCKL11GeK8lPcrJxi1b6tEdLWm46ya5nKM7YFb8Z9sWP3uxjCqZ/mNgbCnPlkDJgcTKVWb
        Nuto2Wr73jlMPi8sZjr0u5SIjjpAomCwya82EPufuvKsRJVXeeNI7cK44TPp6ZY7zPUFZ2
        +oW1ZO1Vr+a9A68346t8gyfFPjz5yUw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-xARG3aqJPhumozfdfrWVFA-1; Mon, 10 Jan 2022 10:09:45 -0500
X-MC-Unique: xARG3aqJPhumozfdfrWVFA-1
Received: by mail-wm1-f70.google.com with SMTP id i81-20020a1c3b54000000b003467c58cbddso8676829wma.5
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 07:09:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pqCR8DvhBxiCC4TzGlm/t/7v2g7znFq4gFV1cmWoEXc=;
        b=UnYUJHjPcsH5Cq4ru4iGW7/TzcGYGQqx8hUBkelwLBd4JNz+hyjKI/KvvHC6yHTe/D
         KEeagHNIn2KzkEB0w5nlKEyNO9bpMygV5v1XDTNT7cTMMCcq05w1+8MVpW0+8f+9nrVa
         7Sk0GHbmPZZ66PdIzvX0ZyzTP2/s1yrwm2AZaJ/8U/hTIXj8I9SeDdDAkbWN8NhXhA4R
         YFKatqdEAXp3YC2kPoYnq9cqKb9y2/CXnf2DhXTwFg5HUWef6mFCujrMoyCj0O42av5K
         NQfT/bRvaDsHtfCaVkIZiaoknCfyBvMqov481D3tL0oTsg5Z61cq/L//5OfmNuJIoaiX
         7FlQ==
X-Gm-Message-State: AOAM532VE4KV9rwbR/rREiOs9Sd8jMsYORN9Qwk0ai3e/nI8pgyL+wxy
        qq5SdpLR0TvTgT8i43UV0vDoUPolMSM30r2a67tH2flA5YwUqr9t58gAJFh2WsFudTSOBDAF84C
        s50IwgkR8qcuObme7
X-Received: by 2002:a05:6000:1687:: with SMTP id y7mr92670wrd.234.1641827384660;
        Mon, 10 Jan 2022 07:09:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx+Wi7ut3xNdrf+rI6tR7FUH1Wzlso2Na/Gkg81RELF3PPjhams/SaDbGDnPVE94lb71Siqrw==
X-Received: by 2002:a05:6000:1687:: with SMTP id y7mr92655wrd.234.1641827384391;
        Mon, 10 Jan 2022 07:09:44 -0800 (PST)
Received: from redhat.com ([2.55.148.228])
        by smtp.gmail.com with ESMTPSA id m6sm7888102wrx.36.2022.01.10.07.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 07:09:43 -0800 (PST)
Date:   Mon, 10 Jan 2022 10:09:38 -0500
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
Message-ID: <20220110100911-mutt-send-email-mst@kernel.org>
References: <20210830141737.181-1-xieyongji@bytedance.com>
 <20220110075546-mutt-send-email-mst@kernel.org>
 <CACycT3v1aEViw7vV4x5qeGVPrSrO-BTDvQshEX35rx_X0Au2vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACycT3v1aEViw7vV4x5qeGVPrSrO-BTDvQshEX35rx_X0Au2vw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 09:54:08PM +0800, Yongji Xie wrote:
> On Mon, Jan 10, 2022 at 8:57 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Aug 30, 2021 at 10:17:24PM +0800, Xie Yongji wrote:
> > > This series introduces a framework that makes it possible to implement
> > > software-emulated vDPA devices in userspace. And to make the device
> > > emulation more secure, the emulated vDPA device's control path is handled
> > > in the kernel and only the data path is implemented in the userspace.
> > >
> > > Since the emuldated vDPA device's control path is handled in the kernel,
> > > a message mechnism is introduced to make userspace be aware of the data
> > > path related changes. Userspace can use read()/write() to receive/reply
> > > the control messages.
> > >
> > > In the data path, the core is mapping dma buffer into VDUSE daemon's
> > > address space, which can be implemented in different ways depending on
> > > the vdpa bus to which the vDPA device is attached.
> > >
> > > In virtio-vdpa case, we implements a MMU-based software IOTLB with
> > > bounce-buffering mechanism to achieve that. And in vhost-vdpa case, the dma
> > > buffer is reside in a userspace memory region which can be shared to the
> > > VDUSE userspace processs via transferring the shmfd.
> > >
> > > The details and our user case is shown below:
> > >
> > > ------------------------    -------------------------   ----------------------------------------------
> > > |            Container |    |              QEMU(VM) |   |                               VDUSE daemon |
> > > |       ---------      |    |  -------------------  |   | ------------------------- ---------------- |
> > > |       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | | vDPA device emulation | | block driver | |
> > > ------------+-----------     -----------+------------   -------------+----------------------+---------
> > >             |                           |                            |                      |
> > >             |                           |                            |                      |
> > > ------------+---------------------------+----------------------------+----------------------+---------
> > > |    | block device |           |  vhost device |            | vduse driver |          | TCP/IP |    |
> > > |    -------+--------           --------+--------            -------+--------          -----+----    |
> > > |           |                           |                           |                       |        |
> > > | ----------+----------       ----------+-----------         -------+-------                |        |
> > > | | virtio-blk driver |       |  vhost-vdpa driver |         | vdpa device |                |        |
> > > | ----------+----------       ----------+-----------         -------+-------                |        |
> > > |           |      virtio bus           |                           |                       |        |
> > > |   --------+----+-----------           |                           |                       |        |
> > > |                |                      |                           |                       |        |
> > > |      ----------+----------            |                           |                       |        |
> > > |      | virtio-blk device |            |                           |                       |        |
> > > |      ----------+----------            |                           |                       |        |
> > > |                |                      |                           |                       |        |
> > > |     -----------+-----------           |                           |                       |        |
> > > |     |  virtio-vdpa driver |           |                           |                       |        |
> > > |     -----------+-----------           |                           |                       |        |
> > > |                |                      |                           |    vdpa bus           |        |
> > > |     -----------+----------------------+---------------------------+------------           |        |
> > > |                                                                                        ---+---     |
> > > -----------------------------------------------------------------------------------------| NIC |------
> > >                                                                                          ---+---
> > >                                                                                             |
> > >                                                                                    ---------+---------
> > >                                                                                    | Remote Storages |
> > >                                                                                    -------------------
> > >
> > > We make use of it to implement a block device connecting to
> > > our distributed storage, which can be used both in containers and
> > > VMs. Thus, we can have an unified technology stack in this two cases.
> > >
> > > To test it with null-blk:
> > >
> > >   $ qemu-storage-daemon \
> > >       --chardev socket,id=charmonitor,path=/tmp/qmp.sock,server,nowait \
> > >       --monitor chardev=charmonitor \
> > >       --blockdev driver=host_device,cache.direct=on,aio=native,filename=/dev/nullb0,node-name=disk0 \
> > >       --export type=vduse-blk,id=test,node-name=disk0,writable=on,name=vduse-null,num-queues=16,queue-size=128
> > >
> > > The qemu-storage-daemon can be found at https://github.com/bytedance/qemu/tree/vduse
> >
> > It's been half a year - any plans to upstream this?
> 
> Yeah, this is on my to-do list this month.
> 
> Sorry for taking so long... I've been working on another project
> enabling userspace RDMA with VDUSE for the past few months. So I
> didn't have much time for this. Anyway, I will submit the first
> version as soon as possible.
> 
> Thanks,
> Yongji

Oh fun. You mean like virtio-rdma? Or RDMA as a backend for regular
virtio?

-- 
MST

