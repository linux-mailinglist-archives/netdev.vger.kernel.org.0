Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACB52F0642
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 11:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbhAJKEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 05:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbhAJKEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 05:04:46 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B445AC061786
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 02:04:04 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id lt17so20555592ejb.3
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 02:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ntHLah0q+SvwKSjeDWR+MVFLLttqY1N89uUPbqPMpiA=;
        b=ZGwx+oiiGqvNDB+EaNh7KH6pXXDJEN6Q1ZH/kdatn05h3TURc1jdAQPJK2Hd1dt3y9
         oX9qanMfO/pXUBOO5CoyFgf6lRFCoVfxQ3mFPJHZnlvUdkDjlt0GIj245r6osobCwOlt
         rV7pJn8gsCpRiAAnmMLALjrtwokfqMai7FP927XnZ5UzVr16916CyigDjon5TNvYTytQ
         cn9l6tUn9hlp6zO8JVbySRHAx75MxIw0hNpWAiOdFrdHTMSmNqGtIFyqUALoWPUJdkEf
         eeYy6crslJzT0GNwXexlvaM5HjhSavw0e4FhTYttSXZE+kdUSJspWEvV5UqgUW+OpJNe
         OdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ntHLah0q+SvwKSjeDWR+MVFLLttqY1N89uUPbqPMpiA=;
        b=MZDSSAZ/MDTaZvloNhbwwKEa6ecm3rur45PqJbtlrefaMMGR9dy1b4ce9dZl8ib1uG
         cvbN9R/yPEz/STWHFtRJDt7J4U61M0hWtAfoIAMbkLrpl/oxkzJ5khPmaQF+3CEs2d1A
         K82dSPNHPSPiyEbJGbDw9UGxEkTreC0NYKs70RsWmhn0x83aUDuMamQ4Y8Z8G9Tu7O+y
         zhdhNJqdkh9Dq6xJRx9xOsd5vMxoYuzPBjDga6J40hG4Deps8KBthFnRx0k/bENGoZaE
         gH5/TEJqCQBIl3YZPkXoXqDrJnT2wKqFwGVNenfQGkwI61JFrR7HGZIk7m7HDjNSQ+uN
         Z7zg==
X-Gm-Message-State: AOAM531gTplmjAMcGNnRZ6ec9JHj4vT02MSkTOPEEPMym8GEMUTUzMVQ
        dwyw+sj1uy7poXo8HK+kxIAjTUxVWukV7tssSm91
X-Google-Smtp-Source: ABdhPJxxW/yAqeYuRuPessHdacKwHtFahI0Eg6d90J6rPXonweRKhqtq6PPHcOf9f2M6pT+y8/HK7s5rhlXTDDVOoNY=
X-Received: by 2002:a17:907:1629:: with SMTP id hb41mr7211587ejc.197.1610273043284;
 Sun, 10 Jan 2021 02:04:03 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <20201222145221.711-7-xieyongji@bytedance.com>
 <f8dcb8d0-0024-1f78-d1a7-e487ca3deda7@oracle.com>
In-Reply-To: <f8dcb8d0-0024-1f78-d1a7-e487ca3deda7@oracle.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Sun, 10 Jan 2021 18:03:52 +0800
Message-ID: <CACycT3u859hX5ChcxVS2EMmF4-vu5H+io_CcNWSKaN8NFA9cXg@mail.gmail.com>
Subject: Re: Re: [RFC v2 06/13] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Bob Liu <bob.liu@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 9:32 PM Bob Liu <bob.liu@oracle.com> wrote:
>
> On 12/22/20 10:52 PM, Xie Yongji wrote:
> > This VDUSE driver enables implementing vDPA devices in userspace.
> > Both control path and data path of vDPA devices will be able to
> > be handled in userspace.
> >
> > In the control path, the VDUSE driver will make use of message
> > mechnism to forward the config operation from vdpa bus driver
> > to userspace. Userspace can use read()/write() to receive/reply
> > those control messages.
> >
> > In the data path, the VDUSE driver implements a MMU-based on-chip
> > IOMMU driver which supports mapping the kernel dma buffer to a
> > userspace iova region dynamically. Userspace can access those
> > iova region via mmap(). Besides, the eventfd mechanism is used to
> > trigger interrupt callbacks and receive virtqueue kicks in userspace
> >
> > Now we only support virtio-vdpa bus driver with this patch applied.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >  Documentation/driver-api/vduse.rst                 |   74 ++
> >  Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
> >  drivers/vdpa/Kconfig                               |    8 +
> >  drivers/vdpa/Makefile                              |    1 +
> >  drivers/vdpa/vdpa_user/Makefile                    |    5 +
> >  drivers/vdpa/vdpa_user/eventfd.c                   |  221 ++++
> >  drivers/vdpa/vdpa_user/eventfd.h                   |   48 +
> >  drivers/vdpa/vdpa_user/iova_domain.c               |  442 ++++++++
> >  drivers/vdpa/vdpa_user/iova_domain.h               |   93 ++
> >  drivers/vdpa/vdpa_user/vduse.h                     |   59 ++
> >  drivers/vdpa/vdpa_user/vduse_dev.c                 | 1121 ++++++++++++++++++++
> >  include/uapi/linux/vdpa.h                          |    1 +
> >  include/uapi/linux/vduse.h                         |   99 ++
> >  13 files changed, 2173 insertions(+)
> >  create mode 100644 Documentation/driver-api/vduse.rst
> >  create mode 100644 drivers/vdpa/vdpa_user/Makefile
> >  create mode 100644 drivers/vdpa/vdpa_user/eventfd.c
> >  create mode 100644 drivers/vdpa/vdpa_user/eventfd.h
> >  create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
> >  create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
> >  create mode 100644 drivers/vdpa/vdpa_user/vduse.h
> >  create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
> >  create mode 100644 include/uapi/linux/vduse.h
> >
> > diff --git a/Documentation/driver-api/vduse.rst b/Documentation/driver-api/vduse.rst
> > new file mode 100644
> > index 000000000000..da9b3040f20a
> > --- /dev/null
> > +++ b/Documentation/driver-api/vduse.rst
> > @@ -0,0 +1,74 @@
> > +==================================
> > +VDUSE - "vDPA Device in Userspace"
> > +==================================
> > +
> > +vDPA (virtio data path acceleration) device is a device that uses a
> > +datapath which complies with the virtio specifications with vendor
> > +specific control path. vDPA devices can be both physically located on
> > +the hardware or emulated by software. VDUSE is a framework that makes it
> > +possible to implement software-emulated vDPA devices in userspace.
> > +
>
> Could you explain a bit more why need a VDUSE framework?

This can be used to implement a userspace I/O (such as storage,
network and so on) solution (virtio-based) for both container and VM.

> Software emulated vDPA devices is more likely used by debugging only when
> don't have real hardware.

I think software emulated vDPA devices should be also useful in other
cases, just like FUSE does.

> Do you think do the emulation in kernel space is not enough?
>

Doing the emulation in userspace should be more flexible.

Thanks,
Yongji
