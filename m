Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D9635EEDD
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 10:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349103AbhDNHzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 03:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbhDNHzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 03:55:24 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3336C06175F
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 00:55:03 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g17so21792417edm.6
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 00:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fsahu37Y9/zL9oMkhbhBb4dx/NliRzgzOHM8isOmQ2c=;
        b=z2bybWOetPXB3jsL3na6wHIjbhGwOFP4FlYyvjARRQ1zuln9Lg+pL/kY6otUTEnO/g
         lmz71dHcX7tKWEiSE99JfBpy0QPoIkirIF0HR4SxhOuk6U5ekM+uU2utMNHwOx3cCbcq
         bCu1H5WIWPAi2qO/R+8sNYMXhnOVoGZsu+injmNkkTjSwg2SZp+RIgyPkSAgjGaugyob
         gEGTc8F9Bmf0SfFBYHjbLcueTejwnl3jiJTW2tF1CJ6lHx/ZbegmpfL7n+XHH9NGvEyA
         QB4Qq51ZR8J5qZqX8ZmsBgnY0lAv6Uis+Ylxce/zXDy/3QHC7GyNvd235IoyuHn9vUiM
         MXwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fsahu37Y9/zL9oMkhbhBb4dx/NliRzgzOHM8isOmQ2c=;
        b=gPusgQ6YcVmiNLVVv/ywWS88SXVClwoB3DqbswS32H+jRv91fKPKkYf0yPBbGC4IOw
         RvMuQbZlk+lO6sfSfLyMB5xtp+AdzRlDNUXTwriL5bHAGTd/+T4sD/cZRdQx9aaHRGZc
         dyhLXjgVZQj1iLs1bdqIsnVWb+shl1IjN3GNCkRkhxDtOXa7LU224z+Bx2sLiTQmsAJf
         JT2d+a1XFbQJRhqMnZ7kRfsUIGUSWKLK/rAIxRRXsarjY3z1vjfi3vERlc9mI5krw/33
         uHL/9Q0ztwxn72hzhaVZ0e2DTQI8hTG1QlbRJs7/3Bnz8W7zBLd+jTWpuQe9S/VMCZlL
         PHlQ==
X-Gm-Message-State: AOAM531O47GFYteDbxY7oQVcQTcJF5WmAeilGIFdb3bpQeN9/2G+L5kj
        F5V+GjyMWaMW0uf8gjNGZdT/skziE7ZL82XO1nbK
X-Google-Smtp-Source: ABdhPJymgoRaZS3OHeEHzYqRFfSPikKe+INgr5Ie+JbVLw+hozOq1xXj6dKOG0EeaiMEyL5Q6pe0Af2kIWIy/wVn3cY=
X-Received: by 2002:a05:6402:4314:: with SMTP id m20mr38627332edc.5.1618386902328;
 Wed, 14 Apr 2021 00:55:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210414032909-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210414032909-mutt-send-email-mst@kernel.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 14 Apr 2021 15:54:51 +0800
Message-ID: <CACycT3tRjTRJr1aQhtHK_K1MJd07ki8bnR9mYPRb8oQ8vVuxDQ@mail.gmail.com>
Subject: Re: Re: [PATCH v6 00/10] Introduce VDUSE - vDPA Device in Userspace
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 3:35 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Mar 31, 2021 at 04:05:09PM +0800, Xie Yongji wrote:
> > This series introduces a framework, which can be used to implement
> > vDPA Devices in a userspace program. The work consist of two parts:
> > control path forwarding and data path offloading.
> >
> > In the control path, the VDUSE driver will make use of message
> > mechnism to forward the config operation from vdpa bus driver
> > to userspace. Userspace can use read()/write() to receive/reply
> > those control messages.
> >
> > In the data path, the core is mapping dma buffer into VDUSE
> > daemon's address space, which can be implemented in different ways
> > depending on the vdpa bus to which the vDPA device is attached.
> >
> > In virtio-vdpa case, we implements a MMU-based on-chip IOMMU driver wit=
h
> > bounce-buffering mechanism to achieve that. And in vhost-vdpa case, the=
 dma
> > buffer is reside in a userspace memory region which can be shared to th=
e
> > VDUSE userspace processs via transferring the shmfd.
> >
> > The details and our user case is shown below:
> >
> > ------------------------    -------------------------   ---------------=
-------------------------------
> > |            Container |    |              QEMU(VM) |   |              =
                 VDUSE daemon |
> > |       ---------      |    |  -------------------  |   | -------------=
------------ ---------------- |
> > |       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | | vDPA device=
 emulation | | block driver | |
> > ------------+-----------     -----------+------------   -------------+-=
---------------------+---------
> >             |                           |                            | =
                     |
> >             |                           |                            | =
                     |
> > ------------+---------------------------+----------------------------+-=
---------------------+---------
> > |    | block device |           |  vhost device |            | vduse dr=
iver |          | TCP/IP |    |
> > |    -------+--------           --------+--------            -------+--=
------          -----+----    |
> > |           |                           |                           |  =
                     |        |
> > | ----------+----------       ----------+-----------         -------+--=
-----                |        |
> > | | virtio-blk driver |       |  vhost-vdpa driver |         | vdpa dev=
ice |                |        |
> > | ----------+----------       ----------+-----------         -------+--=
-----                |        |
> > |           |      virtio bus           |                           |  =
                     |        |
> > |   --------+----+-----------           |                           |  =
                     |        |
> > |                |                      |                           |  =
                     |        |
> > |      ----------+----------            |                           |  =
                     |        |
> > |      | virtio-blk device |            |                           |  =
                     |        |
> > |      ----------+----------            |                           |  =
                     |        |
> > |                |                      |                           |  =
                     |        |
> > |     -----------+-----------           |                           |  =
                     |        |
> > |     |  virtio-vdpa driver |           |                           |  =
                     |        |
> > |     -----------+-----------           |                           |  =
                     |        |
> > |                |                      |                           |  =
  vdpa bus           |        |
> > |     -----------+----------------------+---------------------------+--=
----------           |        |
> > |                                                                      =
                  ---+---     |
> > -----------------------------------------------------------------------=
------------------| NIC |------
> >                                                                        =
                  ---+---
> >                                                                        =
                     |
> >                                                                        =
            ---------+---------
> >                                                                        =
            | Remote Storages |
> >                                                                        =
            -------------------
>
> This all looks quite similar to vhost-user-block except that one
> does not need any kernel support at all.
>
> So I am still scratching my head about its advantages over
> vhost-user-block.
>

It plays the same role as vhost-user-block in VM user cases.

>
> > We make use of it to implement a block device connecting to
> > our distributed storage, which can be used both in containers and
> > VMs. Thus, we can have an unified technology stack in this two cases.
>
> Maybe the container part is the answer. How does that stack look?
>

Yes, it enables containers to reuse virtio software stack. We can have
one daemon that provides service to both containers and virtual
machines.

Thanks=EF=BC=8C
Yongji
