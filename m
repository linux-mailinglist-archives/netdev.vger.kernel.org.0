Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3A93955D2
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhEaHPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhEaHPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 03:15:10 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DEBC061761
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 00:13:30 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r11so12258189edt.13
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 00:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HsUiQi3ntUxHPOgfLtJZfOJE0YtMnjg4ItjU9q5zMjE=;
        b=pjl+eyiZ3SVuMuplEw97FDWO0PFqcd17F4vwf+if4jHNgPbn1w1mQjgqab4EuyqMH4
         i2yCpgZbMQHteb4eEJfalzc4jiHuoaRyUEnLGscOViLDFU+FaIzY9+FgYY/vzLGLhGwa
         Cl2uBYhAWAGrrML81PUus32wzX3oLmigWxiVFrw0QBv51HciWo8blYjKOHMBj9iDIhBq
         OA8nYaQ7Aw+DzdfB6Pms1I5qeAWNW6gF1ew/EkpajY0jHoLlTYi9BzhksrzBNJSWC4xg
         fhqGEFYXOVa6N6fS6yzpW9wpuwbybGX9qNarvRbYOiESGPy1kA70dU0szyW+EGJSqMkW
         Qvwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HsUiQi3ntUxHPOgfLtJZfOJE0YtMnjg4ItjU9q5zMjE=;
        b=B9ZiMR0OYueqFMBeCfxo751FroaMsYViK95IF7sHDe2uZLB1R3mqEbMQM19kfuBwTq
         LJuBN7F6tbfwmgfdEDhrbpRWUA98uKSwA63MaU8lsVKIuFQrBFEZYhBJbr5aK8RerhZ0
         I7bK4J253k0sjonhg0JvOcc6v+BivhJ4diTmPD/k8roqislyAMYoUMSw0HjbrNjNenm2
         3569ovkfSLqQx/oZ+XFveN24lBUxARmxvLILRAuNpcnLr73sW0az1L0esVMxwF8LkBuW
         BLDx6EhZnM6zn0cDNtdU53n3jHJCKIQ3WMqToHfNpt/mIFWTjHkHZSHHyE/6ci0j/Fgo
         7WsQ==
X-Gm-Message-State: AOAM533o+vE9HZp7/Wqdn1bUYBrO9TmMNEMyyu4B5vYwXRDJQCpVsGxf
        lIUVOK8plotcDxA/UWiWiEbAuNl4myLIbyw38fOH
X-Google-Smtp-Source: ABdhPJxz6zmra41o6Y5jQKsKyQQGK6vr2Kk7000vKI5r+AMsAhkzn/ieUzE/Q93Iok6mSGB/HstZcEDQcLUJcTjE5oM=
X-Received: by 2002:a50:9e8e:: with SMTP id a14mr2295520edf.5.1622445209532;
 Mon, 31 May 2021 00:13:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210517095513.850-1-xieyongji@bytedance.com> <20210517095513.850-12-xieyongji@bytedance.com>
 <YLRsehBRAiCJEDl0@kroah.com> <CACycT3vRHPfOGxmy1Uv=8_dqqq8iG4YTZHUizo+y8EYKGS5g8g@mail.gmail.com>
 <YLSC6AthAl+VeQsv@kroah.com>
In-Reply-To: <YLSC6AthAl+VeQsv@kroah.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 31 May 2021 15:13:18 +0800
Message-ID: <CACycT3t4OABUoXGjx4Fyf1iMm--OTC8Vdp8rN1ppCs0W15V6iA@mail.gmail.com>
Subject: Re: Re: Re: [PATCH v7 11/12] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
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
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 2:32 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, May 31, 2021 at 02:19:37PM +0800, Yongji Xie wrote:
> > Hi Greg,
> >
> > Thanks a lot for the review!
> >
> > On Mon, May 31, 2021 at 12:56 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, May 17, 2021 at 05:55:12PM +0800, Xie Yongji wrote:
> > > > +struct vduse_dev {
> > > > +     struct vduse_vdpa *vdev;
> > > > +     struct device dev;
> > > > +     struct cdev cdev;
> > >
> > > You now have 2 reference counted devices controling the lifespace of a
> > > single structure.  A mess that is guaranteed to go wrong.  Please never
> > > do this.
> > >
> >
> > These two are both used by cdev_device_add(). Looks like I didn't find
> > any problem. Any suggestions?
>
> Make one of these dynamic and do not have them both control the lifespan
> of the structure.
>

I see some comments in cdev_device_add():

"This function should be used whenever the struct cdev and the struct
device are members of the same structure whose lifetime is managed by
the struct device."

So it seems to be ok here?

> > > > +     struct vduse_virtqueue *vqs;
> > > > +     struct vduse_iova_domain *domain;
> > > > +     char *name;
> > > > +     struct mutex lock;
> > > > +     spinlock_t msg_lock;
> > > > +     atomic64_t msg_unique;
> > >
> > > Why do you need an atomic and a lock?
> > >
> >
> > You are right. We don't need an atomic here.
> >
> > > > +     wait_queue_head_t waitq;
> > > > +     struct list_head send_list;
> > > > +     struct list_head recv_list;
> > > > +     struct list_head list;
> > > > +     struct vdpa_callback config_cb;
> > > > +     struct work_struct inject;
> > > > +     spinlock_t irq_lock;
> > > > +     unsigned long api_version;
> > > > +     bool connected;
> > > > +     int minor;
> > > > +     u16 vq_size_max;
> > > > +     u32 vq_num;
> > > > +     u32 vq_align;
> > > > +     u32 config_size;
> > > > +     u32 device_id;
> > > > +     u32 vendor_id;
> > > > +};
> > > > +
> > > > +struct vduse_dev_msg {
> > > > +     struct vduse_dev_request req;
> > > > +     struct vduse_dev_response resp;
> > > > +     struct list_head list;
> > > > +     wait_queue_head_t waitq;
> > > > +     bool completed;
> > > > +};
> > > > +
> > > > +struct vduse_control {
> > > > +     unsigned long api_version;
> > >
> > > u64?
> > >
> >
> > OK.
> >
> > > > +};
> > > > +
> > > > +static unsigned long max_bounce_size = (64 * 1024 * 1024);
> > > > +module_param(max_bounce_size, ulong, 0444);
> > > > +MODULE_PARM_DESC(max_bounce_size, "Maximum bounce buffer size. (default: 64M)");
> > > > +
> > > > +static unsigned long max_iova_size = (128 * 1024 * 1024);
> > > > +module_param(max_iova_size, ulong, 0444);
> > > > +MODULE_PARM_DESC(max_iova_size, "Maximum iova space size (default: 128M)");
> > > > +
> > > > +static bool allow_unsafe_device_emulation;
> > > > +module_param(allow_unsafe_device_emulation, bool, 0444);
> > > > +MODULE_PARM_DESC(allow_unsafe_device_emulation, "Allow emulating unsafe device."
> > > > +     " We must make sure the userspace device emulation process is trusted."
> > > > +     " Otherwise, don't enable this option. (default: false)");
> > > > +
> > >
> > > This is not the 1990's anymore, please never use module parameters, make
> > > these per-device attributes if you really need them.
> > >
> >
> > These parameters will be used before the device is created. Or do you
> > mean add some attributes to the control device?
>
> You need to do something, as no one can mess with a module parameter
> easily.  Why do you need them at all, shouldn't it "just work" properly
> with no need for userspace interaction?
>

OK, I get you. It works fine with the default value. So I think it
should be ok to remove these parameters before we find a situation
that really needs them.

> > > > +static int vduse_init(void)
> > > > +{
> > > > +     int ret;
> > > > +
> > > > +     if (max_bounce_size >= max_iova_size)
> > > > +             return -EINVAL;
> > > > +
> > > > +     ret = misc_register(&vduse_misc);
> > > > +     if (ret)
> > > > +             return ret;
> > > > +
> > > > +     vduse_class = class_create(THIS_MODULE, "vduse");
> > >
> > > If you have a misc device, you do not need to create a class at the same
> > > time.  Why are you doing both here?  Just stick with the misc device, no
> > > need for anything else.
> > >
> >
> > The misc device is the control device represented by
> > /dev/vduse/control. Then a VDUSE device represented by
> > /dev/vduse/$NAME can be created by the ioctl(VDUSE_CREATE_DEV) on this
> > control device.
>
> Ah.  Then how about using the same MAJOR for all of these, and just have
> the first minor (0) be your control?  That happens for other device
> types (raw, loop, etc.).  Or just document this really well please, as
> it was not obvious what you were doing here.
>

OK, I will reserve the first minor (0) for the control device instead.

Thanks,
Yongji
