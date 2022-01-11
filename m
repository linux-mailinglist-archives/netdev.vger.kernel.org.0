Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EC548AE04
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 13:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240102AbiAKM6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 07:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236289AbiAKM6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 07:58:02 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E48C061756
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 04:58:02 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id a18so65779855edj.7
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 04:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uz1h5CEIPed2HfgHHUpg29tv2CH2az1LB5lhdw8+vao=;
        b=VCCztgsxzf6eUODoTzV63GaI2hEf+L8SknRatUqlNg/xhQIo6oZ1oSW0kv01emxrk0
         ODYefAJSnBYp/f027rnSV6nDAjopS+C5OD3ll9T0hILqtnTrbeaDVes179ML0/YpZfD7
         xIEhi5WITnIgvFXct/drtY7nX42/s3+mqYX4n0o5BQDrWp4dTgzLIy5hc7IrgkA8+y+N
         fuP76hHyTu/+fhkuABRQnIzannBo1MRv0ZSkVmjbltWKFiZklz1rMrgAtzjPUSXSPzYM
         5TzouUnW0IrsFgBG9btbCRMMdIMndSsS7BBrAE/k3Gde3gacDwaSV2Oi1tXF+v6wTLbw
         a+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uz1h5CEIPed2HfgHHUpg29tv2CH2az1LB5lhdw8+vao=;
        b=fOx66t7Mm5hyyFp8e9xiKVjfVwLOuril1i+KmMJKUOvcBs/xspuilIU+VfycUdvL8A
         aR1k3s0nre5VeXAb/E2UOIIjYQ/lNdLS6bvK8BpjKc+AWPalYi15fsXKwPjz4v7l+TLN
         es1T0w3oV3lGKnwp/JbCKP1GMD7Ti3/QR9C52FN8V8lcdCRFZYdzx/56N2A1J66+cqlu
         5iiHXZCT6zX9HG+yb8BZxRyyYVNdZHDF2ux8YID+706F41epNDStL96X/sNNmhFj5tNu
         h8c3hkcEDRncd1FxgXZMaaebGH+XQUr1YHlEro+/rTdsuwZuFJEp6id3ijyNTJ9BBGm6
         r2nA==
X-Gm-Message-State: AOAM530IMD65CewriUVgPN3FdTv7NYK6yKmP6xaej0VQ5j7O5yJsYaFU
        YjbECyQl+qFMIEGfWTzDL8OYDmnmJ+85cjP0jb0c
X-Google-Smtp-Source: ABdhPJxR3il7T/JRiMnDBqI+LmQ3D6uzJvszq1H9EZPMgpPq8q+tiwynJLLSJLb+eKsmKti56DNWpzGpdfZLIeI85DE=
X-Received: by 2002:a05:6402:124b:: with SMTP id l11mr4141116edw.9.1641905880942;
 Tue, 11 Jan 2022 04:58:00 -0800 (PST)
MIME-Version: 1.0
References: <20210830141737.181-1-xieyongji@bytedance.com> <20220110075546-mutt-send-email-mst@kernel.org>
 <CACycT3v1aEViw7vV4x5qeGVPrSrO-BTDvQshEX35rx_X0Au2vw@mail.gmail.com>
 <20220110100911-mutt-send-email-mst@kernel.org> <CACycT3v6jo3-8ATWUzf659vV94a2oRrm-zQtGNDZd6OQr-MENA@mail.gmail.com>
 <20220110103938-mutt-send-email-mst@kernel.org> <CACycT3sbJC1Jn7NeWk_ccQ_2_YgKybjugfxmKpfgCP3Ayoju4w@mail.gmail.com>
 <20220111065301-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220111065301-mutt-send-email-mst@kernel.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 11 Jan 2022 20:57:49 +0800
Message-ID: <CACycT3sdfAbdByKJwg8N-Jb2qVDdgfSqprp_aOp5fpYz4LxmgA@mail.gmail.com>
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

On Tue, Jan 11, 2022 at 7:54 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Jan 11, 2022 at 11:31:37AM +0800, Yongji Xie wrote:
> > On Mon, Jan 10, 2022 at 11:44 PM Michael S. Tsirkin <mst@redhat.com> wr=
ote:
> > >
> > > On Mon, Jan 10, 2022 at 11:24:40PM +0800, Yongji Xie wrote:
> > > > On Mon, Jan 10, 2022 at 11:10 PM Michael S. Tsirkin <mst@redhat.com=
> wrote:
> > > > >
> > > > > On Mon, Jan 10, 2022 at 09:54:08PM +0800, Yongji Xie wrote:
> > > > > > On Mon, Jan 10, 2022 at 8:57 PM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > > > > > >
> > > > > > > On Mon, Aug 30, 2021 at 10:17:24PM +0800, Xie Yongji wrote:
> > > > > > > > This series introduces a framework that makes it possible t=
o implement
> > > > > > > > software-emulated vDPA devices in userspace. And to make th=
e device
> > > > > > > > emulation more secure, the emulated vDPA device's control p=
ath is handled
> > > > > > > > in the kernel and only the data path is implemented in the =
userspace.
> > > > > > > >
> > > > > > > > Since the emuldated vDPA device's control path is handled i=
n the kernel,
> > > > > > > > a message mechnism is introduced to make userspace be aware=
 of the data
> > > > > > > > path related changes. Userspace can use read()/write() to r=
eceive/reply
> > > > > > > > the control messages.
> > > > > > > >
> > > > > > > > In the data path, the core is mapping dma buffer into VDUSE=
 daemon's
> > > > > > > > address space, which can be implemented in different ways d=
epending on
> > > > > > > > the vdpa bus to which the vDPA device is attached.
> > > > > > > >
> > > > > > > > In virtio-vdpa case, we implements a MMU-based software IOT=
LB with
> > > > > > > > bounce-buffering mechanism to achieve that. And in vhost-vd=
pa case, the dma
> > > > > > > > buffer is reside in a userspace memory region which can be =
shared to the
> > > > > > > > VDUSE userspace processs via transferring the shmfd.
> > > > > > > >
> > > > > > > > The details and our user case is shown below:
> > > > > > > >
> > > > > > > > ------------------------    -------------------------   ---=
-------------------------------------------
> > > > > > > > |            Container |    |              QEMU(VM) |   |  =
                             VDUSE daemon |
> > > > > > > > |       ---------      |    |  -------------------  |   | -=
------------------------ ---------------- |
> > > > > > > > |       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | |=
 vDPA device emulation | | block driver | |
> > > > > > > > ------------+-----------     -----------+------------   ---=
----------+----------------------+---------
> > > > > > > >             |                           |                  =
          |                      |
> > > > > > > >             |                           |                  =
          |                      |
> > > > > > > > ------------+---------------------------+------------------=
----------+----------------------+---------
> > > > > > > > |    | block device |           |  vhost device |          =
  | vduse driver |          | TCP/IP |    |
> > > > > > > > |    -------+--------           --------+--------          =
  -------+--------          -----+----    |
> > > > > > > > |           |                           |                  =
         |                       |        |
> > > > > > > > | ----------+----------       ----------+-----------       =
  -------+-------                |        |
> > > > > > > > | | virtio-blk driver |       |  vhost-vdpa driver |       =
  | vdpa device |                |        |
> > > > > > > > | ----------+----------       ----------+-----------       =
  -------+-------                |        |
> > > > > > > > |           |      virtio bus           |                  =
         |                       |        |
> > > > > > > > |   --------+----+-----------           |                  =
         |                       |        |
> > > > > > > > |                |                      |                  =
         |                       |        |
> > > > > > > > |      ----------+----------            |                  =
         |                       |        |
> > > > > > > > |      | virtio-blk device |            |                  =
         |                       |        |
> > > > > > > > |      ----------+----------            |                  =
         |                       |        |
> > > > > > > > |                |                      |                  =
         |                       |        |
> > > > > > > > |     -----------+-----------           |                  =
         |                       |        |
> > > > > > > > |     |  virtio-vdpa driver |           |                  =
         |                       |        |
> > > > > > > > |     -----------+-----------           |                  =
         |                       |        |
> > > > > > > > |                |                      |                  =
         |    vdpa bus           |        |
> > > > > > > > |     -----------+----------------------+------------------=
---------+------------           |        |
> > > > > > > > |                                                          =
                              ---+---     |
> > > > > > > > -----------------------------------------------------------=
------------------------------| NIC |------
> > > > > > > >                                                            =
                              ---+---
> > > > > > > >                                                            =
                                 |
> > > > > > > >                                                            =
                        ---------+---------
> > > > > > > >                                                            =
                        | Remote Storages |
> > > > > > > >                                                            =
                        -------------------
> > > > > > > >
> > > > > > > > We make use of it to implement a block device connecting to
> > > > > > > > our distributed storage, which can be used both in containe=
rs and
> > > > > > > > VMs. Thus, we can have an unified technology stack in this =
two cases.
> > > > > > > >
> > > > > > > > To test it with null-blk:
> > > > > > > >
> > > > > > > >   $ qemu-storage-daemon \
> > > > > > > >       --chardev socket,id=3Dcharmonitor,path=3D/tmp/qmp.soc=
k,server,nowait \
> > > > > > > >       --monitor chardev=3Dcharmonitor \
> > > > > > > >       --blockdev driver=3Dhost_device,cache.direct=3Don,aio=
=3Dnative,filename=3D/dev/nullb0,node-name=3Ddisk0 \
> > > > > > > >       --export type=3Dvduse-blk,id=3Dtest,node-name=3Ddisk0=
,writable=3Don,name=3Dvduse-null,num-queues=3D16,queue-size=3D128
> > > > > > > >
> > > > > > > > The qemu-storage-daemon can be found at https://github.com/=
bytedance/qemu/tree/vduse
> > > > > > >
> > > > > > > It's been half a year - any plans to upstream this?
> > > > > >
> > > > > > Yeah, this is on my to-do list this month.
> > > > > >
> > > > > > Sorry for taking so long... I've been working on another projec=
t
> > > > > > enabling userspace RDMA with VDUSE for the past few months. So =
I
> > > > > > didn't have much time for this. Anyway, I will submit the first
> > > > > > version as soon as possible.
> > > > > >
> > > > > > Thanks,
> > > > > > Yongji
> > > > >
> > > > > Oh fun. You mean like virtio-rdma? Or RDMA as a backend for regul=
ar
> > > > > virtio?
> > > > >
> > > >
> > > > Yes, like virtio-rdma. Then we can develop something like userspace
> > > > rxe=E3=80=81siw or custom protocol with VDUSE.
> > > >
> > > > Thanks,
> > > > Yongji
> > >
> > > Would be interesting to see the spec for that.
> >
> > Will send it ASAP.
> >
> > > The issues with RDMA revolved around the fact that current
> > > apps tend to either use non-standard propocols for connection
> > > establishment or use UD where there's IIRC no standard
> > > at all. So QP numbers are hard to virtualize.
> > > Similarly many use LIDs directly with the same effect.
> > > GUIDs might be virtualizeable but no one went to the effort.
> > >
> >
> > Actually we aimed at emulating a soft RDMA with normal NIC (not use
> > RDMA capability) rather than virtualizing a physical RDMA NIC into
> > several vRDMA devices. If so, I think we won't have those issues,
> > right?
>
> Right, maybe you won't.
>
> > > To say nothing about the interaction with memory overcommit.
> > >
> >
> > I don't get you here. Could you give me more details?
> >
> > Thanks,
> > Yongji
>
> RDMA devices tend to want to pin the memory under DMA.
>

I see. Maybe something like dm or odp could be helpful.

Thanks,
Yongji
