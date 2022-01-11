Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F4948AE21
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 14:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240268AbiAKNE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 08:04:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240265AbiAKNEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 08:04:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641906261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CnoXRZzxHpYZJCWWJWjQzv34cSxRuBzuUNROP7tocqU=;
        b=J7ie4awMUKp0X52WIJ4CV5Qxr2LakL28ytYOoKgQITNXvU9CNe3qs3IDReFf5unlz9AKQB
        Tu1X/N+gH1psYAw3N6kdPipV0FuOAX21+FkZgvnO/OLQN6NpKwpiJDY2n6IejNhWeLpMro
        oLdkfXa7LzoZEmEeIM8JQc6SBxRBv/A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-3p6GPw2YOu-E7cvQ0hTB4Q-1; Tue, 11 Jan 2022 08:04:20 -0500
X-MC-Unique: 3p6GPw2YOu-E7cvQ0hTB4Q-1
Received: by mail-ed1-f70.google.com with SMTP id c8-20020a05640227c800b003fdc1684cdeso5220744ede.12
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 05:04:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CnoXRZzxHpYZJCWWJWjQzv34cSxRuBzuUNROP7tocqU=;
        b=f2AmCAlqK/vZNZ1MgUp3goXnc5wTLfIYQyk8sc9HWpyBpy3fj3XiIbAZA/ZTrT7QOQ
         +u+d6Kk/mxbsgloETZYgM8+bU41x3tyHL5TF/v0e60ZIYgPbNOHTIPCOuAMSryuNGvoh
         0Q27Yllj8gIWcVVAvWK6Oca6hAVjhGuPTBGwxGG0X1SrsGL31nciqnqRVoX6WkkQJa1T
         jN88Dsh7nKGw8DLEEgEY61yy3KedChNTGBN8uzBXhCL70WzQcNq6i/c4+M62yIwZ6dSi
         hpDFSDcHLAOijUwq6/sWtQwjMltnNgBN2MCS2EV6EMJ0yaGKN8snU6GOR0mMonM7ckMJ
         O9Pg==
X-Gm-Message-State: AOAM531Slp1dv88OgseqouholMTZ1gE0pwu4AJP+NjJF4dI7w/P1E30c
        s7n3sXpO7iaqE1L4CkCzimDooXO8WYpZXmP7IS8BQs690eDSuACP7tyOytNklBTXU/FS5+kfuLR
        YZzlhj5IJw6JuHZgI
X-Received: by 2002:a17:906:3707:: with SMTP id d7mr3673132ejc.688.1641906259336;
        Tue, 11 Jan 2022 05:04:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyufWlr/Lw1gvdqS0EUpwg1gh0cWIzsXPiLkrC7aOl+Vt8tOWZrM6glrUNIyzIuktDWyNcriw==
X-Received: by 2002:a17:906:3707:: with SMTP id d7mr3673099ejc.688.1641906259017;
        Tue, 11 Jan 2022 05:04:19 -0800 (PST)
Received: from redhat.com ([2.55.5.100])
        by smtp.gmail.com with ESMTPSA id j5sm3591214ejo.171.2022.01.11.05.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 05:04:18 -0800 (PST)
Date:   Tue, 11 Jan 2022 08:04:10 -0500
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
Message-ID: <20220111080359-mutt-send-email-mst@kernel.org>
References: <20210830141737.181-1-xieyongji@bytedance.com>
 <20220110075546-mutt-send-email-mst@kernel.org>
 <CACycT3v1aEViw7vV4x5qeGVPrSrO-BTDvQshEX35rx_X0Au2vw@mail.gmail.com>
 <20220110100911-mutt-send-email-mst@kernel.org>
 <CACycT3v6jo3-8ATWUzf659vV94a2oRrm-zQtGNDZd6OQr-MENA@mail.gmail.com>
 <20220110103938-mutt-send-email-mst@kernel.org>
 <CACycT3sbJC1Jn7NeWk_ccQ_2_YgKybjugfxmKpfgCP3Ayoju4w@mail.gmail.com>
 <20220111065301-mutt-send-email-mst@kernel.org>
 <CACycT3sdfAbdByKJwg8N-Jb2qVDdgfSqprp_aOp5fpYz4LxmgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACycT3sdfAbdByKJwg8N-Jb2qVDdgfSqprp_aOp5fpYz4LxmgA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 08:57:49PM +0800, Yongji Xie wrote:
> On Tue, Jan 11, 2022 at 7:54 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Jan 11, 2022 at 11:31:37AM +0800, Yongji Xie wrote:
> > > On Mon, Jan 10, 2022 at 11:44 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Mon, Jan 10, 2022 at 11:24:40PM +0800, Yongji Xie wrote:
> > > > > On Mon, Jan 10, 2022 at 11:10 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Mon, Jan 10, 2022 at 09:54:08PM +0800, Yongji Xie wrote:
> > > > > > > On Mon, Jan 10, 2022 at 8:57 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Mon, Aug 30, 2021 at 10:17:24PM +0800, Xie Yongji wrote:
> > > > > > > > > This series introduces a framework that makes it possible to implement
> > > > > > > > > software-emulated vDPA devices in userspace. And to make the device
> > > > > > > > > emulation more secure, the emulated vDPA device's control path is handled
> > > > > > > > > in the kernel and only the data path is implemented in the userspace.
> > > > > > > > >
> > > > > > > > > Since the emuldated vDPA device's control path is handled in the kernel,
> > > > > > > > > a message mechnism is introduced to make userspace be aware of the data
> > > > > > > > > path related changes. Userspace can use read()/write() to receive/reply
> > > > > > > > > the control messages.
> > > > > > > > >
> > > > > > > > > In the data path, the core is mapping dma buffer into VDUSE daemon's
> > > > > > > > > address space, which can be implemented in different ways depending on
> > > > > > > > > the vdpa bus to which the vDPA device is attached.
> > > > > > > > >
> > > > > > > > > In virtio-vdpa case, we implements a MMU-based software IOTLB with
> > > > > > > > > bounce-buffering mechanism to achieve that. And in vhost-vdpa case, the dma
> > > > > > > > > buffer is reside in a userspace memory region which can be shared to the
> > > > > > > > > VDUSE userspace processs via transferring the shmfd.
> > > > > > > > >
> > > > > > > > > The details and our user case is shown below:
> > > > > > > > >
> > > > > > > > > ------------------------    -------------------------   ----------------------------------------------
> > > > > > > > > |            Container |    |              QEMU(VM) |   |                               VDUSE daemon |
> > > > > > > > > |       ---------      |    |  -------------------  |   | ------------------------- ---------------- |
> > > > > > > > > |       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | | vDPA device emulation | | block driver | |
> > > > > > > > > ------------+-----------     -----------+------------   -------------+----------------------+---------
> > > > > > > > >             |                           |                            |                      |
> > > > > > > > >             |                           |                            |                      |
> > > > > > > > > ------------+---------------------------+----------------------------+----------------------+---------
> > > > > > > > > |    | block device |           |  vhost device |            | vduse driver |          | TCP/IP |    |
> > > > > > > > > |    -------+--------           --------+--------            -------+--------          -----+----    |
> > > > > > > > > |           |                           |                           |                       |        |
> > > > > > > > > | ----------+----------       ----------+-----------         -------+-------                |        |
> > > > > > > > > | | virtio-blk driver |       |  vhost-vdpa driver |         | vdpa device |                |        |
> > > > > > > > > | ----------+----------       ----------+-----------         -------+-------                |        |
> > > > > > > > > |           |      virtio bus           |                           |                       |        |
> > > > > > > > > |   --------+----+-----------           |                           |                       |        |
> > > > > > > > > |                |                      |                           |                       |        |
> > > > > > > > > |      ----------+----------            |                           |                       |        |
> > > > > > > > > |      | virtio-blk device |            |                           |                       |        |
> > > > > > > > > |      ----------+----------            |                           |                       |        |
> > > > > > > > > |                |                      |                           |                       |        |
> > > > > > > > > |     -----------+-----------           |                           |                       |        |
> > > > > > > > > |     |  virtio-vdpa driver |           |                           |                       |        |
> > > > > > > > > |     -----------+-----------           |                           |                       |        |
> > > > > > > > > |                |                      |                           |    vdpa bus           |        |
> > > > > > > > > |     -----------+----------------------+---------------------------+------------           |        |
> > > > > > > > > |                                                                                        ---+---     |
> > > > > > > > > -----------------------------------------------------------------------------------------| NIC |------
> > > > > > > > >                                                                                          ---+---
> > > > > > > > >                                                                                             |
> > > > > > > > >                                                                                    ---------+---------
> > > > > > > > >                                                                                    | Remote Storages |
> > > > > > > > >                                                                                    -------------------
> > > > > > > > >
> > > > > > > > > We make use of it to implement a block device connecting to
> > > > > > > > > our distributed storage, which can be used both in containers and
> > > > > > > > > VMs. Thus, we can have an unified technology stack in this two cases.
> > > > > > > > >
> > > > > > > > > To test it with null-blk:
> > > > > > > > >
> > > > > > > > >   $ qemu-storage-daemon \
> > > > > > > > >       --chardev socket,id=charmonitor,path=/tmp/qmp.sock,server,nowait \
> > > > > > > > >       --monitor chardev=charmonitor \
> > > > > > > > >       --blockdev driver=host_device,cache.direct=on,aio=native,filename=/dev/nullb0,node-name=disk0 \
> > > > > > > > >       --export type=vduse-blk,id=test,node-name=disk0,writable=on,name=vduse-null,num-queues=16,queue-size=128
> > > > > > > > >
> > > > > > > > > The qemu-storage-daemon can be found at https://github.com/bytedance/qemu/tree/vduse
> > > > > > > >
> > > > > > > > It's been half a year - any plans to upstream this?
> > > > > > >
> > > > > > > Yeah, this is on my to-do list this month.
> > > > > > >
> > > > > > > Sorry for taking so long... I've been working on another project
> > > > > > > enabling userspace RDMA with VDUSE for the past few months. So I
> > > > > > > didn't have much time for this. Anyway, I will submit the first
> > > > > > > version as soon as possible.
> > > > > > >
> > > > > > > Thanks,
> > > > > > > Yongji
> > > > > >
> > > > > > Oh fun. You mean like virtio-rdma? Or RDMA as a backend for regular
> > > > > > virtio?
> > > > > >
> > > > >
> > > > > Yes, like virtio-rdma. Then we can develop something like userspace
> > > > > rxe、siw or custom protocol with VDUSE.
> > > > >
> > > > > Thanks,
> > > > > Yongji
> > > >
> > > > Would be interesting to see the spec for that.
> > >
> > > Will send it ASAP.
> > >
> > > > The issues with RDMA revolved around the fact that current
> > > > apps tend to either use non-standard propocols for connection
> > > > establishment or use UD where there's IIRC no standard
> > > > at all. So QP numbers are hard to virtualize.
> > > > Similarly many use LIDs directly with the same effect.
> > > > GUIDs might be virtualizeable but no one went to the effort.
> > > >
> > >
> > > Actually we aimed at emulating a soft RDMA with normal NIC (not use
> > > RDMA capability) rather than virtualizing a physical RDMA NIC into
> > > several vRDMA devices. If so, I think we won't have those issues,
> > > right?
> >
> > Right, maybe you won't.
> >
> > > > To say nothing about the interaction with memory overcommit.
> > > >
> > >
> > > I don't get you here. Could you give me more details?
> > >
> > > Thanks,
> > > Yongji
> >
> > RDMA devices tend to want to pin the memory under DMA.
> >
> 
> I see. Maybe something like dm or odp could be helpful.
> 
> Thanks,
> Yongji

Yes sure.

-- 
MST

