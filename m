Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465DA1083FE
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 16:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfKXPHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 10:07:54 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56645 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726948AbfKXPHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 10:07:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574608071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PSXCI+CMdDvaX8GielDO1TjmQgpKxp96CIHYgvBzVeM=;
        b=ROTTeGb81DeODZhyqeC2/WMRNsqnx7oFx/gosoPULNaAXPRMNokhjMy7u/30vQOrZi13wS
        lKYf+XjOfy/mIr4a8FDrz9bNg5Tvts0S++mBt3LmPgh0tzD19RPvr3aTUDqI80vjXMhG+v
        mxnbVPch5mgcnDPSqTGI7HspLbgWcB0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-_OFEZFDtPnKcQj4NIatl0w-1; Sun, 24 Nov 2019 10:07:47 -0500
Received: by mail-qv1-f72.google.com with SMTP id a4so2362188qvn.14
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 07:07:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ShauWqt61/NqBY4b/teHzxmWzNMIjRMQYJYsj6dK7ZI=;
        b=ZIMRzYiDjcVk059/p8bbltzSeGpxdyMyGBJZwe7E1LqwxaiveSTraVpxJNho+dHgX1
         Ph6I1YQ/QJXhby6Ir9FJwuzdd8p3oMpJVdZ+zVf/qLlx5KCJBBwdGc9ia+AYD/IayUed
         SaGu/fSIkv84b3w5+ANmDa+1wknZ43gmwsCdRCG0dQZh3xxKL/HbabnypYYMZZQLExIH
         W6FEsG/g5p3i+7USGA7i7C5dnAYGc+6nAIKC6RRGp1jufcYTMfczWzkMx3IwOX6xgQf1
         xVmAEdLz3K/Frrynd0XIAcv7I8WyVsuqLXK+4/Lk0GYVdmjKZUl2lCM4/XckHFtj7zmj
         VuWQ==
X-Gm-Message-State: APjAAAXXTolFK2OisuPvOt+7Vg1xP2AvoeQX8hh00OBWuhK2SQjLNVBp
        y3FjoYx0PNNZ4myucVNls8LdK1F5n0aBk7BcYY86Y59Nhvs3jUGwUsFcw86QrC1zPE/1OUr28aq
        mdvuFtVVK7R37mn+b
X-Received: by 2002:ac8:d4e:: with SMTP id r14mr7891662qti.349.1574608067517;
        Sun, 24 Nov 2019 07:07:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqw24EAqB//vXJduiUq7B0Javbj+ks76twFbI0AkgfAzyzzGcvAUz4CoXuYNPU3y2xTA86kwYw==
X-Received: by 2002:ac8:d4e:: with SMTP id r14mr7891637qti.349.1574608067252;
        Sun, 24 Nov 2019 07:07:47 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id l45sm2263696qtb.32.2019.11.24.07.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 07:07:46 -0800 (PST)
Date:   Sun, 24 Nov 2019 10:07:40 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191124100610-mutt-send-email-mst@kernel.org>
References: <20191120181108.GJ22515@ziepe.ca>
 <20191120150732.2fffa141@x1.home>
 <20191121030357.GB16914@ziepe.ca>
 <5dcef4ab-feb5-d116-b2a9-50608784a054@redhat.com>
 <20191121141732.GB7448@ziepe.ca>
 <721e49c2-a2e1-853f-298b-9601c32fcf9e@redhat.com>
 <20191122180214.GD7448@ziepe.ca>
 <20191123043951.GA364267@___>
 <20191123230948.GF7448@ziepe.ca>
 <20191124145124.GA374942@___>
MIME-Version: 1.0
In-Reply-To: <20191124145124.GA374942@___>
X-MC-Unique: _OFEZFDtPnKcQj4NIatl0w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 24, 2019 at 10:51:24PM +0800, Tiwei Bie wrote:
> On Sat, Nov 23, 2019 at 07:09:48PM -0400, Jason Gunthorpe wrote:
> > On Sat, Nov 23, 2019 at 12:39:51PM +0800, Tiwei Bie wrote:
> > > On Fri, Nov 22, 2019 at 02:02:14PM -0400, Jason Gunthorpe wrote:
> > > > On Fri, Nov 22, 2019 at 04:45:38PM +0800, Jason Wang wrote:
> > > > > On 2019/11/21 =E4=B8=8B=E5=8D=8810:17, Jason Gunthorpe wrote:
> > > > > > On Thu, Nov 21, 2019 at 03:21:29PM +0800, Jason Wang wrote:
> > > > > > > > The role of vfio has traditionally been around secure devic=
e
> > > > > > > > assignment of a HW resource to a VM. I'm not totally clear =
on what the
> > > > > > > > role if mdev is seen to be, but all the mdev drivers in the=
 tree seem
> > > > > > > > to make 'and pass it to KVM' a big part of their descriptio=
n.
> > > > > > > >=20
> > > > > > > > So, looking at the virtio patches, I see some intended use =
is to map
> > > > > > > > some BAR pages into the VM.
> > > > > > > Nope, at least not for the current stage. It still depends on=
 the
> > > > > > > virtio-net-pci emulatio in qemu to work. In the future, we wi=
ll allow such
> > > > > > > mapping only for dorbell.
> > > > > > There has been a lot of emails today, but I think this is the m=
ain
> > > > > > point I want to respond to.
> > > > > >=20
> > > > > > Using vfio when you don't even assign any part of the device BA=
R to
> > > > > > the VM is, frankly, a gigantic misuse, IMHO.
> > > > >=20
> > > > > That's not a compelling point.=20
> > > >=20
> > > > Well, this discussion is going nowhere.
> > >=20
> > > You removed JasonW's other reply in above quote. He said it clearly
> > > that we do want/need to assign parts of device BAR to the VM.
> >=20
> > Generally we don't look at patches based on stuff that isn't in them.
>=20
> The hardware is ready, and it's something really necessary (for
> the performance). It was planned to be added immediately after
> current series. If you want, it certainly can be included right now.

It can't hurt, for sure. Can be a separate patch if you feel
review is easier that way.

> >=20
> > > > I mean the library functions in the kernel that vfio uses to implem=
ent
> > > > all the user dma stuff. Other subsystems use them too, it is not
> > > > exclusive to vfio.
> > >=20
> > > IIUC, your point is to suggest us invent new DMA API for userspace to
> > > use instead of leveraging VFIO's well defined DMA API. Even if we don=
't
> > > use VFIO at all, I would imagine it could be very VFIO-like (e.g. cap=
s
> > > for BAR + container/group for DMA) eventually.
> >=20
> > None of the other user dma subsystems seem to have the problems you
> > are imagining here. Perhaps you should try it first?
>=20
> Actually VFIO DMA API wasn't used at the beginning of vhost-mdev. But
> after the discussion in upstream during the RFC stage since the last
> year, the conclusion is that leveraging VFIO's existing DMA API would
> be the better choice and then vhost-mdev switched to that direction.
>=20
> > =20
> > > > > > Further, I do not think it is wise to design the userspace ABI =
around
> > > > > > a simplistict implementation that can't do BAR assignment,
> > > > >=20
> > > > > Again, the vhost-mdev follow the VFIO ABI, no new ABI is invented=
, and
> > > > > mmap() was kept their for mapping device regions.
> > > >=20
> > > > The patches have a new file in include/uapi.
> > >=20
> > > I guess you didn't look at the code. Just to clarify, there is no
> > > new file introduced in include/uapi. Only small vhost extensions to
> > > the existing vhost uapi are involved in vhost-mdev.
> >=20
> > You know, I review alot of patches every week, and sometimes I make
> > mistakes, but not this time. From the ICF cover letter:
> >=20
> > https://lkml.org/lkml/2019/11/7/62
> >=20
> >  drivers/vfio/mdev/mdev_core.c    |  21 ++
> >  drivers/vhost/Kconfig            |  12 +
> >  drivers/vhost/Makefile           |   3 +
> >  drivers/vhost/mdev.c             | 556 +++++++++++++++++++++++++++++++
> >  include/linux/mdev.h             |   5 +
> >  include/uapi/linux/vhost.h       |  21 ++
> >  include/uapi/linux/vhost_types.h |   8 +
> >       ^^^^^^^^^^^^^^
> >=20
> > Perhaps you thought I ment ICF was adding uapi? My remarks cover all
> > three of the series involved here.
>=20
> No, I meant the same thing. Michael helped me explain that.
> https://patchwork.ozlabs.org/patch/1195895/#2311180
>=20
> >=20
> > Jason

