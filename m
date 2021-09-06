Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189F24016BB
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 09:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239937AbhIFHIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 03:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbhIFHIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 03:08:01 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4674C061575
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 00:06:56 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id mf2so11454009ejb.9
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 00:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q3MG6YTB+QzDfQAiZySr2rS0jN8YaIk13obJQJ/stWo=;
        b=lkQZaa6g9ei4zhefeS4/oyNQrJS2xco6ilGBKyKlZ6vC0SUD8QQ+1knPvpyi6IaHac
         GqpF6T/J9e8UZEhbRcxYY2Vqkdxa9S0Mc6OSDQEPV8Lm2RG5xwllvm/ICW7ihxTyN8cQ
         6q8HxGdwJRriwFkXrBLniQ+rOGGSciTVwRPaZN0SjIEyZqVJuZ/w0QfR4/wBg4GuaIvK
         u5g1glJnwNcAurESAAaeIz8Og+r0qqEHDRcUcXNFnSlIosPcpoHpNITG9ICSkR9Z8ltb
         ne8SJRTHipR+XIW/F978DLyiAT4QKN6N8mAAM4madRU69d+NI8I3REMHopnFJfCrL03M
         8PUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q3MG6YTB+QzDfQAiZySr2rS0jN8YaIk13obJQJ/stWo=;
        b=Yx567lUAORUBMNQcfpIvJW9WzT6S08ESdI8M9c+4xgEd2v9TLTM9PkgElN05QGGitc
         /9BTPQVu3fNKAdr+W5K8XrStrBzQTYA6idM8BHUud9aS9A0NQazaWW0LqCPIX8ZDCwM9
         cHz8Lz7E5CDXsBl26++PcvsDD/plzg5dOxde3i+amAwbYD1YZfHxRjaQvWfKamCv2AKV
         +E6tfF2bMjHD0zFZi5Wq0xVmAB6TuG/DM+gbMgBGyHOxJgJxD+saZFIVlixC4jUs8oem
         o+bYAzOZi0xbqrskVy5pYoDW/JQVsUTmKcQ6v2ZDElGXvW3wICnPJTGotovFZmUH7/ML
         n0pw==
X-Gm-Message-State: AOAM530pD47Q/KUPhZAyTjV5KoW7ArUbWGcXxrTJ8mxcQclr2psBcmMw
        ymBcsHENNIOQ8PDKgr721bmBY/KY8SyR8tTmJ0vE
X-Google-Smtp-Source: ABdhPJywBwaaVm3boucqd1sdO/Cfi8IGS0P4Me7y+BCi/2fL1YgT6rXVQRK94JvNPY5a+i9h1dktiuFSZgpWUJHXv74=
X-Received: by 2002:a17:906:8da:: with SMTP id o26mr12057282eje.424.1630912015321;
 Mon, 06 Sep 2021 00:06:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210831103634.33-1-xieyongji@bytedance.com> <20210831103634.33-6-xieyongji@bytedance.com>
 <20210906015524-mutt-send-email-mst@kernel.org> <CACycT3v4ZVnh7DGe_RtAOx4Vvau0km=HWyCM=KzKhD+ahYKafQ@mail.gmail.com>
 <20210906023131-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210906023131-mutt-send-email-mst@kernel.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 6 Sep 2021 15:06:44 +0800
Message-ID: <CACycT3ssC1bhNzY9Pk=LPvKjMrFFavTfCKTJtR2XEiVYqDxT1Q@mail.gmail.com>
Subject: Re: [PATCH v13 05/13] vdpa: Add reset callback in vdpa_config_ops
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
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 6, 2021 at 2:37 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Sep 06, 2021 at 02:09:25PM +0800, Yongji Xie wrote:
> > On Mon, Sep 6, 2021 at 1:56 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Tue, Aug 31, 2021 at 06:36:26PM +0800, Xie Yongji wrote:
> > > > This adds a new callback to support device specific reset
> > > > behavior. The vdpa bus driver will call the reset function
> > > > instead of setting status to zero during resetting.
> > > >
> > > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > >
> > >
> > > This does gloss over a significant change though:
> > >
> > >
> > > > ---
> > > > @@ -348,12 +352,12 @@ static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
> > > >       return vdev->dma_dev;
> > > >  }
> > > >
> > > > -static inline void vdpa_reset(struct vdpa_device *vdev)
> > > > +static inline int vdpa_reset(struct vdpa_device *vdev)
> > > >  {
> > > >       const struct vdpa_config_ops *ops = vdev->config;
> > > >
> > > >       vdev->features_valid = false;
> > > > -     ops->set_status(vdev, 0);
> > > > +     return ops->reset(vdev);
> > > >  }
> > > >
> > > >  static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
> > >
> > >
> > > Unfortunately this breaks virtio_vdpa:
> > >
> > >
> > > static void virtio_vdpa_reset(struct virtio_device *vdev)
> > > {
> > >         struct vdpa_device *vdpa = vd_get_vdpa(vdev);
> > >
> > >         vdpa_reset(vdpa);
> > > }
> > >
> > >
> > > and there's no easy way to fix this, kernel can't recover
> > > from a reset failure e.g. during driver unbind.
> > >
> >
> > Yes, but it should be safe with the protection of software IOTLB even
> > if the reset() fails during driver unbind.
> >
> > Thanks,
> > Yongji
>
> Hmm. I don't see it.
> What exactly will happen? What prevents device from poking at
> memory after reset? Note that dma unmap in e.g. del_vqs happens
> too late.

But I didn't see any problems with touching the memory for virtqueues.
The memory should not be freed after dma unmap?

And the memory for the bounce buffer should also be safe to be
accessed by userspace in this case.

> And what about e.g. interrupts?
> E.g. we have this:
>
>         /* Virtqueues are stopped, nothing can use vblk->vdev anymore. */
>         vblk->vdev = NULL;
>
> and this is no longer true at this point.
>

You're right. But I didn't see where the interrupt handler will use
the vblk->vdev.

So it seems to be not too late to fix it:

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c
b/drivers/vdpa/vdpa_user/vduse_dev.c
index 5c25ff6483ad..ea41a7389a26 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -665,13 +665,13 @@ static void vduse_vdpa_set_config(struct
vdpa_device *vdpa, unsigned int offset,
 static int vduse_vdpa_reset(struct vdpa_device *vdpa)
 {
        struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+       int ret;

-       if (vduse_dev_set_status(dev, 0))
-               return -EIO;
+       ret = vduse_dev_set_status(dev, 0);

        vduse_dev_reset(dev);

-       return 0;
+       return ret;
 }

 static u32 vduse_vdpa_get_generation(struct vdpa_device *vdpa)

Thanks,
Yongji
