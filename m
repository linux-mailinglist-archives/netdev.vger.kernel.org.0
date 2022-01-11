Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDCEE48A654
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 04:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346968AbiAKDbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 22:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345038AbiAKDbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 22:31:50 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE05EC06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 19:31:49 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id x15so13298257ilc.5
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 19:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WjJwUUWZ/BCy26tG6i0H8TGwk6V985nqQvOicOWTZ4M=;
        b=Kt/SXme2spmF1Q4vRsvS4pG+rCHvAFzpHY6/g+ah9uXn8dEf8B+SiQy74uNTNlfzu+
         fI86pnBPd36ytsLrsYVt+JYuMg4mD2Cbjr+zRIvUoEFk42um/CGgPgZzAJVesTcyceDW
         1k2nbgWOrjiVu2NGqqueDgsqMN4JvUiPUeB/ILX3mxmPSGxrFW0bZhC7osF093nslXUD
         dQcVO1MjKr7QrGgG6xYLmU9DOzNGYxeQhnk4tBkDGumVMH/auGCVkA/4RWUFHbCLqwcy
         LfvGZ2RjfROO0lVZu8VzzhE+dY1i+pIfTo3kWazj3HlFXLJjk0xUNbsrRXnZytjoJ/tY
         C1gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WjJwUUWZ/BCy26tG6i0H8TGwk6V985nqQvOicOWTZ4M=;
        b=fucw2vOwZHAWa6FKH2GE0JUFv/JyHlIdOsOhr6m0GUpNoJxN08ns7Oq0UkV2MWqlX6
         f6+HzUcPsudUFnJ2LrRRhSTJkPWpdc1jwSVNRgHLPJ4nkpvbMHyM9EzQCWaF6bI+605D
         N3U6aCZdbebsC+/o+eNHqxolvg3wyZ9Ehc39QACfUcjPv58787E+DJ6fPyNiz+cyLNI5
         mw1WhU/uKF9/JbAZuELgzkNLYyIWTn+UqlsHwM7rZXfLtbuy9//JhIfp2zjDlpvcAE2B
         dVs5wOQ0LaZgy7nyJReUp3MDBcTF/fv7DxEUlI56RLAf//hI9yp+9lzGbOG/1YY6x4tz
         wEDg==
X-Gm-Message-State: AOAM532/kpvHbS9l/xXptX7QkbgB68nTt/kyNDiKQvAqXp/Q3OlOXiyW
        zjfB6tbUEm9zADchT+3EVtDWmA0E+5J/5P31thK7
X-Google-Smtp-Source: ABdhPJzAm1xFKAL/SDZlyq0Folm6Knaez8RQjNeQ6v1fXaBZB6Z4O8nf2/JHKKIjXLTJDZb9MJQc9tdaDTRaMZwQSZ4=
X-Received: by 2002:a05:6e02:1e08:: with SMTP id g8mr1423993ila.270.1641871909341;
 Mon, 10 Jan 2022 19:31:49 -0800 (PST)
MIME-Version: 1.0
References: <20210830141737.181-1-xieyongji@bytedance.com> <20220110075546-mutt-send-email-mst@kernel.org>
 <CACycT3v1aEViw7vV4x5qeGVPrSrO-BTDvQshEX35rx_X0Au2vw@mail.gmail.com>
 <20220110100911-mutt-send-email-mst@kernel.org> <CACycT3v6jo3-8ATWUzf659vV94a2oRrm-zQtGNDZd6OQr-MENA@mail.gmail.com>
 <20220110103938-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220110103938-mutt-send-email-mst@kernel.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 11 Jan 2022 11:31:37 +0800
Message-ID: <CACycT3sbJC1Jn7NeWk_ccQ_2_YgKybjugfxmKpfgCP3Ayoju4w@mail.gmail.com>
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

On Mon, Jan 10, 2022 at 11:44 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Jan 10, 2022 at 11:24:40PM +0800, Yongji Xie wrote:
> > On Mon, Jan 10, 2022 at 11:10 PM Michael S. Tsirkin <mst@redhat.com> wr=
ote:
> > >
> > > On Mon, Jan 10, 2022 at 09:54:08PM +0800, Yongji Xie wrote:
> > > > On Mon, Jan 10, 2022 at 8:57 PM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
> > > > >
> > > > > On Mon, Aug 30, 2021 at 10:17:24PM +0800, Xie Yongji wrote:
> > > > > > This series introduces a framework that makes it possible to im=
plement
> > > > > > software-emulated vDPA devices in userspace. And to make the de=
vice
> > > > > > emulation more secure, the emulated vDPA device's control path =
is handled
> > > > > > in the kernel and only the data path is implemented in the user=
space.
> > > > > >
> > > > > > Since the emuldated vDPA device's control path is handled in th=
e kernel,
> > > > > > a message mechnism is introduced to make userspace be aware of =
the data
> > > > > > path related changes. Userspace can use read()/write() to recei=
ve/reply
> > > > > > the control messages.
> > > > > >
> > > > > > In the data path, the core is mapping dma buffer into VDUSE dae=
mon's
> > > > > > address space, which can be implemented in different ways depen=
ding on
> > > > > > the vdpa bus to which the vDPA device is attached.
> > > > > >
> > > > > > In virtio-vdpa case, we implements a MMU-based software IOTLB w=
ith
> > > > > > bounce-buffering mechanism to achieve that. And in vhost-vdpa c=
ase, the dma
> > > > > > buffer is reside in a userspace memory region which can be shar=
ed to the
> > > > > > VDUSE userspace processs via transferring the shmfd.
> > > > > >
> > > > > > The details and our user case is shown below:
> > > > > >
> > > > > > ------------------------    -------------------------   -------=
---------------------------------------
> > > > > > |            Container |    |              QEMU(VM) |   |      =
                         VDUSE daemon |
> > > > > > |       ---------      |    |  -------------------  |   | -----=
-------------------- ---------------- |
> > > > > > |       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | | vDP=
A device emulation | | block driver | |
> > > > > > ------------+-----------     -----------+------------   -------=
------+----------------------+---------
> > > > > >             |                           |                      =
      |                      |
> > > > > >             |                           |                      =
      |                      |
> > > > > > ------------+---------------------------+----------------------=
------+----------------------+---------
> > > > > > |    | block device |           |  vhost device |            | =
vduse driver |          | TCP/IP |    |
> > > > > > |    -------+--------           --------+--------            --=
-----+--------          -----+----    |
> > > > > > |           |                           |                      =
     |                       |        |
> > > > > > | ----------+----------       ----------+-----------         --=
-----+-------                |        |
> > > > > > | | virtio-blk driver |       |  vhost-vdpa driver |         | =
vdpa device |                |        |
> > > > > > | ----------+----------       ----------+-----------         --=
-----+-------                |        |
> > > > > > |           |      virtio bus           |                      =
     |                       |        |
> > > > > > |   --------+----+-----------           |                      =
     |                       |        |
> > > > > > |                |                      |                      =
     |                       |        |
> > > > > > |      ----------+----------            |                      =
     |                       |        |
> > > > > > |      | virtio-blk device |            |                      =
     |                       |        |
> > > > > > |      ----------+----------            |                      =
     |                       |        |
> > > > > > |                |                      |                      =
     |                       |        |
> > > > > > |     -----------+-----------           |                      =
     |                       |        |
> > > > > > |     |  virtio-vdpa driver |           |                      =
     |                       |        |
> > > > > > |     -----------+-----------           |                      =
     |                       |        |
> > > > > > |                |                      |                      =
     |    vdpa bus           |        |
> > > > > > |     -----------+----------------------+----------------------=
-----+------------           |        |
> > > > > > |                                                              =
                          ---+---     |
> > > > > > ---------------------------------------------------------------=
--------------------------| NIC |------
> > > > > >                                                                =
                          ---+---
> > > > > >                                                                =
                             |
> > > > > >                                                                =
                    ---------+---------
> > > > > >                                                                =
                    | Remote Storages |
> > > > > >                                                                =
                    -------------------
> > > > > >
> > > > > > We make use of it to implement a block device connecting to
> > > > > > our distributed storage, which can be used both in containers a=
nd
> > > > > > VMs. Thus, we can have an unified technology stack in this two =
cases.
> > > > > >
> > > > > > To test it with null-blk:
> > > > > >
> > > > > >   $ qemu-storage-daemon \
> > > > > >       --chardev socket,id=3Dcharmonitor,path=3D/tmp/qmp.sock,se=
rver,nowait \
> > > > > >       --monitor chardev=3Dcharmonitor \
> > > > > >       --blockdev driver=3Dhost_device,cache.direct=3Don,aio=3Dn=
ative,filename=3D/dev/nullb0,node-name=3Ddisk0 \
> > > > > >       --export type=3Dvduse-blk,id=3Dtest,node-name=3Ddisk0,wri=
table=3Don,name=3Dvduse-null,num-queues=3D16,queue-size=3D128
> > > > > >
> > > > > > The qemu-storage-daemon can be found at https://github.com/byte=
dance/qemu/tree/vduse
> > > > >
> > > > > It's been half a year - any plans to upstream this?
> > > >
> > > > Yeah, this is on my to-do list this month.
> > > >
> > > > Sorry for taking so long... I've been working on another project
> > > > enabling userspace RDMA with VDUSE for the past few months. So I
> > > > didn't have much time for this. Anyway, I will submit the first
> > > > version as soon as possible.
> > > >
> > > > Thanks,
> > > > Yongji
> > >
> > > Oh fun. You mean like virtio-rdma? Or RDMA as a backend for regular
> > > virtio?
> > >
> >
> > Yes, like virtio-rdma. Then we can develop something like userspace
> > rxe=E3=80=81siw or custom protocol with VDUSE.
> >
> > Thanks,
> > Yongji
>
> Would be interesting to see the spec for that.

Will send it ASAP.

> The issues with RDMA revolved around the fact that current
> apps tend to either use non-standard propocols for connection
> establishment or use UD where there's IIRC no standard
> at all. So QP numbers are hard to virtualize.
> Similarly many use LIDs directly with the same effect.
> GUIDs might be virtualizeable but no one went to the effort.
>

Actually we aimed at emulating a soft RDMA with normal NIC (not use
RDMA capability) rather than virtualizing a physical RDMA NIC into
several vRDMA devices. If so, I think we won't have those issues,
right?

> To say nothing about the interaction with memory overcommit.
>

I don't get you here. Could you give me more details?

Thanks,
Yongji
