Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252E338FB79
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 09:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhEYHNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 03:13:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231539AbhEYHNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 03:13:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621926701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c+jOwuXnrv6w5E8VQc63WP+bAoAy3VD+Yg2CcTHav28=;
        b=fsqFUxoMYH6DL+6ImyHUzGA/YipgwQtcUB5qszK9sKvkscofeDn/raOSmgGcxMzDNPcG4i
        3Jj9SaXTGro8qUhq3hNIDyxuhdp9cn4GF10mRomejj8HRKc0mmvqoQbRnN8Gom6biopose
        oaczF/czb2M3HKcRijJqhv+kWz4FMo0=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-0xrbY87KMOWE4RSX21JN4Q-1; Tue, 25 May 2021 03:11:38 -0400
X-MC-Unique: 0xrbY87KMOWE4RSX21JN4Q-1
Received: by mail-lf1-f69.google.com with SMTP id h82-20020a1985550000b0290298192a54edso294667lfd.7
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 00:11:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c+jOwuXnrv6w5E8VQc63WP+bAoAy3VD+Yg2CcTHav28=;
        b=rxHs+9I3NiZKUDHOW22pGd4XPVZOIgeSrSDfACYsZPiMy/yokpJ1ikJdhaqNke99V0
         mVoETF7FQnJfglE8VBxDoQQjBXmfnRfJu4efLFOKx4mVp/btG9anrWtt0gw3yN78X0IW
         gQJDicCLeEKxiC/XkiSuNnnFE2NiZfwiMdLIcGXGuZ1muiaugKjCT2QYEojFEsE9nFBm
         jdUlM4RrlcsgLvb4BGmvT8IR7tSM3ACiylZ8kocf7z6iip61FlAtASVfWlfGuide+CPv
         Y7J7RohI8F0uVNFSdaD2bzjV3lfdx52yaJTU1mbvyTQhZtClM4kAxukCI4Gk2a5x7b28
         wydw==
X-Gm-Message-State: AOAM530BVn4SDs0Hvf6NDtMn/uUJFUxYaeIGSMnmGt6quRrPmwmPVwx3
        bxaf3+HZJIVJVTCIcY3B6uazHJpoIJaItK43NVWob+eOoGEo4XT4Xm7cOlRySPEYiTCOnTkLm3K
        NWL8Ykv0ES3jNNVrt9Ejuw2eJvBj9RM+E
X-Received: by 2002:a2e:8681:: with SMTP id l1mr19878103lji.494.1621926696932;
        Tue, 25 May 2021 00:11:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyczZMOa2TWeLJ/W/lfSx4o8+fNsMYOICnJsWfNJWAJpdMrk6M2MyFHAccwCNFcVyF65ZRhbqOH/Ioxg4NXiOk=
X-Received: by 2002:a2e:8681:: with SMTP id l1mr19878075lji.494.1621926696622;
 Tue, 25 May 2021 00:11:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210517095513.850-1-xieyongji@bytedance.com> <20210520014349-mutt-send-email-mst@kernel.org>
 <CACycT3tKY2V=dmOJjeiZxkqA3cH8_KF93NNbRnNU04e5Job2cw@mail.gmail.com>
 <2a79fa0f-352d-b8e9-f60a-181960d054ec@redhat.com> <20210525024500-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210525024500-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 25 May 2021 15:11:25 +0800
Message-ID: <CACGkMEsg1X95nmnVsm9x8vML7EUOE195gQrvRdr+3woOEcNBeA@mail.gmail.com>
Subject: Re: [PATCH v7 00/12] Introduce VDUSE - vDPA Device in Userspace
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yongji Xie <xieyongji@bytedance.com>,
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
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 2:48 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, May 25, 2021 at 02:40:57PM +0800, Jason Wang wrote:
> >
> > =E5=9C=A8 2021/5/20 =E4=B8=8B=E5=8D=885:06, Yongji Xie =E5=86=99=E9=81=
=93:
> > > On Thu, May 20, 2021 at 2:06 PM Michael S. Tsirkin <mst@redhat.com> w=
rote:
> > > > On Mon, May 17, 2021 at 05:55:01PM +0800, Xie Yongji wrote:
> > > > > This series introduces a framework, which can be used to implemen=
t
> > > > > vDPA Devices in a userspace program. The work consist of two part=
s:
> > > > > control path forwarding and data path offloading.
> > > > >
> > > > > In the control path, the VDUSE driver will make use of message
> > > > > mechnism to forward the config operation from vdpa bus driver
> > > > > to userspace. Userspace can use read()/write() to receive/reply
> > > > > those control messages.
> > > > >
> > > > > In the data path, the core is mapping dma buffer into VDUSE
> > > > > daemon's address space, which can be implemented in different way=
s
> > > > > depending on the vdpa bus to which the vDPA device is attached.
> > > > >
> > > > > In virtio-vdpa case, we implements a MMU-based on-chip IOMMU driv=
er with
> > > > > bounce-buffering mechanism to achieve that. And in vhost-vdpa cas=
e, the dma
> > > > > buffer is reside in a userspace memory region which can be shared=
 to the
> > > > > VDUSE userspace processs via transferring the shmfd.
> > > > >
> > > > > The details and our user case is shown below:
> > > > >
> > > > > ------------------------    -------------------------   ---------=
-------------------------------------
> > > > > |            Container |    |              QEMU(VM) |   |        =
                       VDUSE daemon |
> > > > > |       ---------      |    |  -------------------  |   | -------=
------------------ ---------------- |
> > > > > |       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | | vDPA =
device emulation | | block driver | |
> > > > > ------------+-----------     -----------+------------   ---------=
----+----------------------+---------
> > > > >              |                           |                       =
     |                      |
> > > > >              |                           |                       =
     |                      |
> > > > > ------------+---------------------------+------------------------=
----+----------------------+---------
> > > > > |    | block device |           |  vhost device |            | vd=
use driver |          | TCP/IP |    |
> > > > > |    -------+--------           --------+--------            ----=
---+--------          -----+----    |
> > > > > |           |                           |                        =
   |                       |        |
> > > > > | ----------+----------       ----------+-----------         ----=
---+-------                |        |
> > > > > | | virtio-blk driver |       |  vhost-vdpa driver |         | vd=
pa device |                |        |
> > > > > | ----------+----------       ----------+-----------         ----=
---+-------                |        |
> > > > > |           |      virtio bus           |                        =
   |                       |        |
> > > > > |   --------+----+-----------           |                        =
   |                       |        |
> > > > > |                |                      |                        =
   |                       |        |
> > > > > |      ----------+----------            |                        =
   |                       |        |
> > > > > |      | virtio-blk device |            |                        =
   |                       |        |
> > > > > |      ----------+----------            |                        =
   |                       |        |
> > > > > |                |                      |                        =
   |                       |        |
> > > > > |     -----------+-----------           |                        =
   |                       |        |
> > > > > |     |  virtio-vdpa driver |           |                        =
   |                       |        |
> > > > > |     -----------+-----------           |                        =
   |                       |        |
> > > > > |                |                      |                        =
   |    vdpa bus           |        |
> > > > > |     -----------+----------------------+------------------------=
---+------------           |        |
> > > > > |                                                                =
                        ---+---     |
> > > > > -----------------------------------------------------------------=
------------------------| NIC |------
> > > > >                                                                  =
                         ---+---
> > > > >                                                                  =
                            |
> > > > >                                                                  =
                   ---------+---------
> > > > >                                                                  =
                   | Remote Storages |
> > > > >                                                                  =
                   -------------------
> > > > >
> > > > > We make use of it to implement a block device connecting to
> > > > > our distributed storage, which can be used both in containers and
> > > > > VMs. Thus, we can have an unified technology stack in this two ca=
ses.
> > > > >
> > > > > To test it with null-blk:
> > > > >
> > > > >    $ qemu-storage-daemon \
> > > > >        --chardev socket,id=3Dcharmonitor,path=3D/tmp/qmp.sock,ser=
ver,nowait \
> > > > >        --monitor chardev=3Dcharmonitor \
> > > > >        --blockdev driver=3Dhost_device,cache.direct=3Don,aio=3Dna=
tive,filename=3D/dev/nullb0,node-name=3Ddisk0 \
> > > > >        --export type=3Dvduse-blk,id=3Dtest,node-name=3Ddisk0,writ=
able=3Don,name=3Dvduse-null,num-queues=3D16,queue-size=3D128
> > > > >
> > > > > The qemu-storage-daemon can be found at https://github.com/byteda=
nce/qemu/tree/vduse
> > > > >
> > > > > To make the userspace VDUSE processes such as qemu-storage-daemon=
 able to
> > > > > run unprivileged. We did some works on virtio driver to avoid tru=
sting
> > > > > device, including:
> > > > >
> > > > >    - validating the device status:
> > > > >
> > > > >      * https://lore.kernel.org/lkml/20210517093428.670-1-xieyongj=
i@bytedance.com/
> > > > >
> > > > >    - validating the used length:
> > > > >
> > > > >      * https://lore.kernel.org/lkml/20210517090836.533-1-xieyongj=
i@bytedance.com/
> > > > >
> > > > >    - validating the device config:
> > > > >
> > > > >      * patch 4 ("virtio-blk: Add validation for block size in con=
fig space")
> > > > >
> > > > >    - validating the device response:
> > > > >
> > > > >      * patch 5 ("virtio_scsi: Add validation for residual bytes f=
rom response")
> > > > >
> > > > > Since I'm not sure if I missing something during auditing, especi=
ally on some
> > > > > virtio device drivers that I'm not familiar with, now we only sup=
port emualting
> > > > > a few vDPA devices by default, including: virtio-net device, virt=
io-blk device,
> > > > > virtio-scsi device and virtio-fs device. This limitation can help=
 to reduce
> > > > > security risks.
> > > > I suspect there are a lot of assumptions even with these 4.
> > > > Just what are the security assumptions and guarantees here?
> >
> >
> > Note that VDUSE is not the only device that may suffer from this, here'=
re
> > two others:
> >
> > 1) Encrypted VM
>
> Encrypted VMs are generally understood not to be fully
> protected from attacks by a malicious hypervisor. For example
> a DoS by a hypervisor is currently trivial.

Right, but I mainly meant the emulated virtio-net device in the case
of an encrypted VM. We should not leak information to the
device/hypervisor.

>
> > 2) Smart NICs
>
> More or less the same thing.

In my opinion, this is more similar to VDUSE. Without an encrypted VM,
we trust the hypervisor but not the device so DOS from a device should
be eliminated.

Thanks

>
>
> >
> > > The attack surface from a virtio device is limited with IOMMU enabled=
.
> > > It should be able to avoid security risk if we can validate all data
> > > such as config space and used length from device in device driver.
> > >
> > > > E.g. it seems pretty clear that exposing a malformed FS
> > > > to a random kernel config can cause untold mischief.
> > > >
> > > > Things like virtnet_send_command are also an easy way for
> > > > the device to DOS the kernel.
> >
> >
> > I think the virtnet_send_command() needs to use interrupt instead of
> > polling.
> >
> > Thanks
> >
> >
> > > > And before you try to add
> > > > an arbitrary timeout there - please don't,
> > > > the fix is moving things that must be guaranteed into kernel
> > > > and making things that are not guaranteed asynchronous.
> > > > Right now there are some things that happen with locks taken,
> > > > where if we don't wait for device we lose the ability to report fai=
lures
> > > > to userspace. E.g. all kind of netlink things are like this.
> > > > One can think of a bunch of ways to address this, this
> > > > needs to be discussed with the relevant subsystem maintainers.
> > > >
> > > >
> > > > If I were you I would start with one type of device, and as simple =
one
> > > > as possible.
> > > >
> > > Make sense to me. The virtio-blk device might be a good start. We
> > > already have some existing interface like NBD to do similar things.
> > >
> > > >
> > > > > When a sysadmin trusts the userspace process enough, it can relax
> > > > > the limitation with a 'allow_unsafe_device_emulation' module para=
meter.
> > > > That's not a great security interface. It's a global module specifi=
c knob
> > > > that just allows any userspace to emulate anything at all.
> > > > Coming up with a reasonable interface isn't going to be easy.
> > > > For now maybe just have people patch their kernels if they want to
> > > > move fast and break things.
> > > >
> > > OK. A reasonable interface can be added if we need it in the future.
> > >
> > > Thanks,
> > > Yongji
>

