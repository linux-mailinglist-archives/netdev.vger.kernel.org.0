Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB49395555
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 08:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhEaGVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 02:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhEaGV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 02:21:29 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686C5C061761
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 23:19:50 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id t15so1981066eju.3
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 23:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7bEMlb5GJnKoHl8SpkOQX3JFXjx8ZQxpVkCFt5EoYmw=;
        b=Ls9LQv0i3iJbU1z5UJZXY6AeHd3GDC4esNjbcR20048Z7nj5bPUHKS3EBTeOdf3fF3
         SRWQE3AE3hpFGPSdIl2RCG7cPt0IhAYm+7LP7gcGyOwrwi/klUcnBjy1Q2O10MW0Yxlm
         f9Z0L0DK1/28QjUCRiXR2oOS4gy63oyvXVR2BIw9foi02cZsa7eQrN6Y8FjwlfA8eN9q
         0W9VTFMJtY02a1p+DN7MJSfqywy7fMmGldlzcWvxU5R2+fwMiLWNC68FKxkusUyBG7D0
         nhe25POF/9pIY4y1ip/yYUrD9WOenEZ4gQ8Xs15XAlOVPWdsmGByT9luAj4SrY+s80V9
         /RIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7bEMlb5GJnKoHl8SpkOQX3JFXjx8ZQxpVkCFt5EoYmw=;
        b=B0UoDi44BCQf/UqB/NrriHjNqpbjNyHnM1YNaUQ1v4T6IqR8m7BEBU2BHjtScYfYyw
         3TvLWXoXJxhFEpvac+4OKP8DiqqjyZIS9GadHfm83frS8V9BdJS0a0NopTiVpc5YQglX
         6wXV3O97VJnyZeG0PMt750pQVAArg6WAygren62xpYTH1pt1mlxjDzo8TF34M0569h9T
         LBYniRgDExefyyIh341N+f9pLBN31wRRgvDGCLQ+YljiOhJgvW/EY3f+aUp7aAfNHFAY
         LK1yNqoFag6d/d1sb5zXycX/+tAaNPnYobZaT2GvJDeqk8owmwPmZOQA533qaYODOG/d
         zEBg==
X-Gm-Message-State: AOAM5324IZ4NtkIShqcFcVLIHWoTyGRWkyoDRinskB0KiyEigeTYx+1k
        w4NxvGoeB946YzunBx2eq2mgTCkveZV2Dh8FvutY
X-Google-Smtp-Source: ABdhPJwuBhBc2sqonaY7g3Uw2ldI0Yl0ApoGOit6DAeP/9k9jTaa1Mal+z2O20b6FoR+z3L/o/96desbl15o3ZcaXic=
X-Received: by 2002:a17:906:b84f:: with SMTP id ga15mr8450191ejb.372.1622441988884;
 Sun, 30 May 2021 23:19:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210517095513.850-1-xieyongji@bytedance.com> <20210517095513.850-12-xieyongji@bytedance.com>
 <YLRsehBRAiCJEDl0@kroah.com>
In-Reply-To: <YLRsehBRAiCJEDl0@kroah.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 31 May 2021 14:19:37 +0800
Message-ID: <CACycT3vRHPfOGxmy1Uv=8_dqqq8iG4YTZHUizo+y8EYKGS5g8g@mail.gmail.com>
Subject: Re: Re: [PATCH v7 11/12] vduse: Introduce VDUSE - vDPA Device in Userspace
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

Hi Greg,

Thanks a lot for the review!

On Mon, May 31, 2021 at 12:56 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, May 17, 2021 at 05:55:12PM +0800, Xie Yongji wrote:
> > +struct vduse_dev {
> > +     struct vduse_vdpa *vdev;
> > +     struct device dev;
> > +     struct cdev cdev;
>
> You now have 2 reference counted devices controling the lifespace of a
> single structure.  A mess that is guaranteed to go wrong.  Please never
> do this.
>

These two are both used by cdev_device_add(). Looks like I didn't find
any problem. Any suggestions?

> > +     struct vduse_virtqueue *vqs;
> > +     struct vduse_iova_domain *domain;
> > +     char *name;
> > +     struct mutex lock;
> > +     spinlock_t msg_lock;
> > +     atomic64_t msg_unique;
>
> Why do you need an atomic and a lock?
>

You are right. We don't need an atomic here.

> > +     wait_queue_head_t waitq;
> > +     struct list_head send_list;
> > +     struct list_head recv_list;
> > +     struct list_head list;
> > +     struct vdpa_callback config_cb;
> > +     struct work_struct inject;
> > +     spinlock_t irq_lock;
> > +     unsigned long api_version;
> > +     bool connected;
> > +     int minor;
> > +     u16 vq_size_max;
> > +     u32 vq_num;
> > +     u32 vq_align;
> > +     u32 config_size;
> > +     u32 device_id;
> > +     u32 vendor_id;
> > +};
> > +
> > +struct vduse_dev_msg {
> > +     struct vduse_dev_request req;
> > +     struct vduse_dev_response resp;
> > +     struct list_head list;
> > +     wait_queue_head_t waitq;
> > +     bool completed;
> > +};
> > +
> > +struct vduse_control {
> > +     unsigned long api_version;
>
> u64?
>

OK.

> > +};
> > +
> > +static unsigned long max_bounce_size = (64 * 1024 * 1024);
> > +module_param(max_bounce_size, ulong, 0444);
> > +MODULE_PARM_DESC(max_bounce_size, "Maximum bounce buffer size. (default: 64M)");
> > +
> > +static unsigned long max_iova_size = (128 * 1024 * 1024);
> > +module_param(max_iova_size, ulong, 0444);
> > +MODULE_PARM_DESC(max_iova_size, "Maximum iova space size (default: 128M)");
> > +
> > +static bool allow_unsafe_device_emulation;
> > +module_param(allow_unsafe_device_emulation, bool, 0444);
> > +MODULE_PARM_DESC(allow_unsafe_device_emulation, "Allow emulating unsafe device."
> > +     " We must make sure the userspace device emulation process is trusted."
> > +     " Otherwise, don't enable this option. (default: false)");
> > +
>
> This is not the 1990's anymore, please never use module parameters, make
> these per-device attributes if you really need them.
>

These parameters will be used before the device is created. Or do you
mean add some attributes to the control device?

> > +static int vduse_init(void)
> > +{
> > +     int ret;
> > +
> > +     if (max_bounce_size >= max_iova_size)
> > +             return -EINVAL;
> > +
> > +     ret = misc_register(&vduse_misc);
> > +     if (ret)
> > +             return ret;
> > +
> > +     vduse_class = class_create(THIS_MODULE, "vduse");
>
> If you have a misc device, you do not need to create a class at the same
> time.  Why are you doing both here?  Just stick with the misc device, no
> need for anything else.
>

The misc device is the control device represented by
/dev/vduse/control. Then a VDUSE device represented by
/dev/vduse/$NAME can be created by the ioctl(VDUSE_CREATE_DEV) on this
control device.

> > +     if (IS_ERR(vduse_class)) {
> > +             ret = PTR_ERR(vduse_class);
> > +             goto err_class;
> > +     }
> > +     vduse_class->devnode = vduse_devnode;
> > +
> > +     ret = alloc_chrdev_region(&vduse_major, 0, VDUSE_DEV_MAX, "vduse");
>
> Wait, you want a whole major?  What is the misc device for?
>

The misc device is used for controlling. And VDUSE devices are
allocated in a dynamic chardev range. Or do I need to reserve the
first minor for the control device instead?

> > +MODULE_VERSION(DRV_VERSION);
>
> MODULE_VERSION() makes no sense when the code is merged into the kernel
> tree, so you can just drop that.
>

Will do it.

Thanks,
Yongji
