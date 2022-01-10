Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD37D489C1B
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 16:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbiAJPYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 10:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbiAJPYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 10:24:53 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30858C061751
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 07:24:53 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id b13so1639280edn.0
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 07:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Uz7H82wmAArl7fSroH8Zwvc58fiFt6Y8AKx2abF1okU=;
        b=yW+xlYWsp6YuKbRVJ3m+8ZOfhN62/bCBbtGssiGCJB8vlf1fAv0dbmlYPvL6q4n+Ea
         nPb7GrWV6e03Us51Tiw2EhBfVxotFJwxe8ZtQa08HUUv60tnVTPhWWvaEQFW4DZ5dHm+
         SJoOAJbZZ3n/1zAoQBhXAQucdvwdl0IxcroWq70ztUJZvuOS/8uwUqrVsodsfoF0E1hv
         KkT+aOwpAdqwmZ65hsJKPH71UZXw90Y0x1r1Kn9zomGyc+azmAot4Nm6wCYXRa5RNsfK
         fIPgCW+NLG+XuYKch8vx+zqTnfLDdhR93vIscfYKJv8Z7zNOWWFcU/OoamlU+GS7G/9j
         sjMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Uz7H82wmAArl7fSroH8Zwvc58fiFt6Y8AKx2abF1okU=;
        b=CD9+HSwixnZlULVK4/diwsBtkZMGvpxOtlFuiRpdvu9Albbg8jQQCYVfdErVe/5KO0
         f4gBAX0SJMAITR/IqjBAQp4JtyjtceHBOHVa9GY/CnyImVhVEk9gvbB24rUFG3dXdI9j
         rpVv8PXnl9uNt26t1bEEImwdMy/7hZeAktl124StemAhos25RgxYHLs/ClM6qYcJJEf9
         lt+AkDUSQCvcxjpVrdbFI4EX8z4ns5ma1UO+dyGHsoy73fEz40t1DXGvmoD3SVnOA13s
         YRyMOTtHVB/EuNDqG0S2o2cMzgHm0b9zLbAetUZb6QBvF6VvrYZoZmr7ZSwtSMG5/tAt
         T3Xw==
X-Gm-Message-State: AOAM5313edLGEARJh2mSZjwkqRWaTLHNniHS0/9Xw7M8MRMpD+ndoXB9
        /pC+MLSlyIjPp+O0+6J0Lz28il1TGCzOPXYWckvA
X-Google-Smtp-Source: ABdhPJxWc7Bx8VLhIHQS3wJbAlcpFOcvxY2PVIQaF1OaZfuWPMRHUePDwW0PsHzzOXUU3GVAxIYcBiOATO+er4Tf/LI=
X-Received: by 2002:a17:907:1b11:: with SMTP id mp17mr215607ejc.374.1641828291620;
 Mon, 10 Jan 2022 07:24:51 -0800 (PST)
MIME-Version: 1.0
References: <20210830141737.181-1-xieyongji@bytedance.com> <20220110075546-mutt-send-email-mst@kernel.org>
 <CACycT3v1aEViw7vV4x5qeGVPrSrO-BTDvQshEX35rx_X0Au2vw@mail.gmail.com> <20220110100911-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220110100911-mutt-send-email-mst@kernel.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 10 Jan 2022 23:24:40 +0800
Message-ID: <CACycT3v6jo3-8ATWUzf659vV94a2oRrm-zQtGNDZd6OQr-MENA@mail.gmail.com>
Subject: Re: [PATCH v12 00/13] Introduce VDUSE - vDPA Device in Userspace
To:     "Michael S. Tsirkin" <mst@redhat.com>
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
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 11:10 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Jan 10, 2022 at 09:54:08PM +0800, Yongji Xie wrote:
> > On Mon, Jan 10, 2022 at 8:57 PM Michael S. Tsirkin <mst@redhat.com> wro=
te:
> > >
> > > On Mon, Aug 30, 2021 at 10:17:24PM +0800, Xie Yongji wrote:
> > > > This series introduces a framework that makes it possible to implem=
ent
> > > > software-emulated vDPA devices in userspace. And to make the device
> > > > emulation more secure, the emulated vDPA device's control path is h=
andled
> > > > in the kernel and only the data path is implemented in the userspac=
e.
> > > >
> > > > Since the emuldated vDPA device's control path is handled in the ke=
rnel,
> > > > a message mechnism is introduced to make userspace be aware of the =
data
> > > > path related changes. Userspace can use read()/write() to receive/r=
eply
> > > > the control messages.
> > > >
> > > > In the data path, the core is mapping dma buffer into VDUSE daemon'=
s
> > > > address space, which can be implemented in different ways depending=
 on
> > > > the vdpa bus to which the vDPA device is attached.
> > > >
> > > > In virtio-vdpa case, we implements a MMU-based software IOTLB with
> > > > bounce-buffering mechanism to achieve that. And in vhost-vdpa case,=
 the dma
> > > > buffer is reside in a userspace memory region which can be shared t=
o the
> > > > VDUSE userspace processs via transferring the shmfd.
> > > >
> > > > The details and our user case is shown below:
> > > >
> > > > ------------------------    -------------------------   -----------=
-----------------------------------
> > > > |            Container |    |              QEMU(VM) |   |          =
                     VDUSE daemon |
> > > > |       ---------      |    |  -------------------  |   | ---------=
---------------- ---------------- |
> > > > |       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | | vDPA de=
vice emulation | | block driver | |
> > > > ------------+-----------     -----------+------------   -----------=
--+----------------------+---------
> > > >             |                           |                          =
  |                      |
> > > >             |                           |                          =
  |                      |
> > > > ------------+---------------------------+--------------------------=
--+----------------------+---------
> > > > |    | block device |           |  vhost device |            | vdus=
e driver |          | TCP/IP |    |
> > > > |    -------+--------           --------+--------            ------=
-+--------          -----+----    |
> > > > |           |                           |                          =
 |                       |        |
> > > > | ----------+----------       ----------+-----------         ------=
-+-------                |        |
> > > > | | virtio-blk driver |       |  vhost-vdpa driver |         | vdpa=
 device |                |        |
> > > > | ----------+----------       ----------+-----------         ------=
-+-------                |        |
> > > > |           |      virtio bus           |                          =
 |                       |        |
> > > > |   --------+----+-----------           |                          =
 |                       |        |
> > > > |                |                      |                          =
 |                       |        |
> > > > |      ----------+----------            |                          =
 |                       |        |
> > > > |      | virtio-blk device |            |                          =
 |                       |        |
> > > > |      ----------+----------            |                          =
 |                       |        |
> > > > |                |                      |                          =
 |                       |        |
> > > > |     -----------+-----------           |                          =
 |                       |        |
> > > > |     |  virtio-vdpa driver |           |                          =
 |                       |        |
> > > > |     -----------+-----------           |                          =
 |                       |        |
> > > > |                |                      |                          =
 |    vdpa bus           |        |
> > > > |     -----------+----------------------+--------------------------=
-+------------           |        |
> > > > |                                                                  =
                      ---+---     |
> > > > -------------------------------------------------------------------=
----------------------| NIC |------
> > > >                                                                    =
                      ---+---
> > > >                                                                    =
                         |
> > > >                                                                    =
                ---------+---------
> > > >                                                                    =
                | Remote Storages |
> > > >                                                                    =
                -------------------
> > > >
> > > > We make use of it to implement a block device connecting to
> > > > our distributed storage, which can be used both in containers and
> > > > VMs. Thus, we can have an unified technology stack in this two case=
s.
> > > >
> > > > To test it with null-blk:
> > > >
> > > >   $ qemu-storage-daemon \
> > > >       --chardev socket,id=3Dcharmonitor,path=3D/tmp/qmp.sock,server=
,nowait \
> > > >       --monitor chardev=3Dcharmonitor \
> > > >       --blockdev driver=3Dhost_device,cache.direct=3Don,aio=3Dnativ=
e,filename=3D/dev/nullb0,node-name=3Ddisk0 \
> > > >       --export type=3Dvduse-blk,id=3Dtest,node-name=3Ddisk0,writabl=
e=3Don,name=3Dvduse-null,num-queues=3D16,queue-size=3D128
> > > >
> > > > The qemu-storage-daemon can be found at https://github.com/bytedanc=
e/qemu/tree/vduse
> > >
> > > It's been half a year - any plans to upstream this?
> >
> > Yeah, this is on my to-do list this month.
> >
> > Sorry for taking so long... I've been working on another project
> > enabling userspace RDMA with VDUSE for the past few months. So I
> > didn't have much time for this. Anyway, I will submit the first
> > version as soon as possible.
> >
> > Thanks,
> > Yongji
>
> Oh fun. You mean like virtio-rdma? Or RDMA as a backend for regular
> virtio?
>

Yes, like virtio-rdma. Then we can develop something like userspace
rxe=E3=80=81siw or custom protocol with VDUSE.

Thanks,
Yongji
