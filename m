Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E043B8DDE
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 08:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbhGAGwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 02:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234306AbhGAGwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 02:52:47 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC4DC061756
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 23:50:15 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id hr1so5226475ejc.1
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 23:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j02ToljqO7cRBUGAX2kOb5odUf1+MulKZRF56vB9XJw=;
        b=szPt3yjQkK/eOHnZmjZxK4k+ezfPy7N6CPhm+x7EICOpDhKGVX0SiYPkZ71JWWvZoa
         8pTmz5fIarGaEdAOZPXlqb3Ft+IEB/7WrLziKTUMgfJwbxqKu7WpgOrDt2jDUDrJtIWr
         cbeLlyv90jBAQgkaG5PcPMpKIESF32ydtpd5t9BVRkR/UxOzB7/03fJbEeEofSeS0xm4
         nBRhtXHTm/IybqaRL0yZyrTa8PU3gB2gMQ79/soCsEBZSt5m98thaMV4L8/9brwhRN7o
         B363iYyE78ClSv8CfWaatXdNXexk42WbsmRlR9FUB8yp+pkqine3MzByepxq/Xp9WTk6
         QDZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j02ToljqO7cRBUGAX2kOb5odUf1+MulKZRF56vB9XJw=;
        b=VTKXDTNTnj6XZqYD4mugwITCDzqDdnvrjqnh3iunjKGa1kgpKLUzrRbfWqrhLUR517
         4wzQD3nxsJEQ+ssBYgTQKdnxr1lCHJrvSZfzOUlCSWQQNGcCUnS0xE6uXgF4hLn9UGm+
         ply3n0T3TFgnUeQb3nOmrSBN9C7WOIdeWsphSejUG8wM2ELzkrWC27rPdP8kViK0I2HV
         oIgdUf72hrx/cMijJiKNe2fqSH/mTvYGHf4CgkFGAv6ou7iHHrx8Dkag8tH5fHHPFF7F
         KZrH+eP5ZUBEU2hkOPscgdVoe9Dh2Oybd5TK+K//i0Zu2gWcMO5Lz+xGJn20lrrqmzP8
         xm3Q==
X-Gm-Message-State: AOAM531npB5DgeBFzwp1q5NLnQc/emaG9wudtdaNOOKF5dUG4YG9vVD0
        9WIbu6KSZSWWcHa63weT8FAwXGKqDd+JUwwxlncg
X-Google-Smtp-Source: ABdhPJw5rO5qehXjBGvgudrN3VY1PB04pXHwf1f+BSEDIJShRRuy3gy/c2hvero6OzD/zDnU0PCg34TMpYMSKS1otIo=
X-Received: by 2002:a17:907:1b11:: with SMTP id mp17mr39880031ejc.1.1625122214373;
 Wed, 30 Jun 2021 23:50:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <20210615141331.407-10-xieyongji@bytedance.com>
 <YNSatrDFsg+4VvH4@stefanha-x1.localdomain> <CACycT3vaXQ4dxC9QUzXXJs7og6TVqqVGa8uHZnTStacsYAiFwQ@mail.gmail.com>
 <YNw+q/ADMPviZi6S@stefanha-x1.localdomain>
In-Reply-To: <YNw+q/ADMPviZi6S@stefanha-x1.localdomain>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 1 Jul 2021 14:50:03 +0800
Message-ID: <CACycT3t6M5i0gznABm52v=rdmeeLZu8smXAOLg+WsM3WY1fgTw@mail.gmail.com>
Subject: Re: Re: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
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
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 5:51 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Tue, Jun 29, 2021 at 10:59:51AM +0800, Yongji Xie wrote:
> > On Mon, Jun 28, 2021 at 9:02 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > >
> > > On Tue, Jun 15, 2021 at 10:13:30PM +0800, Xie Yongji wrote:
> > > > +/* ioctls */
> > > > +
> > > > +struct vduse_dev_config {
> > > > +     char name[VDUSE_NAME_MAX]; /* vduse device name */
> > > > +     __u32 vendor_id; /* virtio vendor id */
> > > > +     __u32 device_id; /* virtio device id */
> > > > +     __u64 features; /* device features */
> > > > +     __u64 bounce_size; /* bounce buffer size for iommu */
> > > > +     __u16 vq_size_max; /* the max size of virtqueue */
> > >
> > > The VIRTIO specification allows per-virtqueue sizes. A device can have
> > > two virtqueues, where the first one allows up to 1024 descriptors and
> > > the second one allows only 128 descriptors, for example.
> > >
> >
> > Good point! But it looks like virtio-vdpa/virtio-pci doesn't support
> > that now. All virtqueues have the same maximum size.
>
> I see struct vpda_config_ops only supports a per-device max vq size:
> u16 (*get_vq_num_max)(struct vdpa_device *vdev);
>
> virtio-pci supports per-virtqueue sizes because the struct
> virtio_pci_common_cfg->queue_size register is per-queue (controlled by
> queue_select).
>

Oh, yes. I miss queue_select.

> I guess this is a question for Jason: will vdpa will keep this limitation?
> If yes, then VDUSE can stick to it too without running into problems in
> the future.
>
> > > > +     __u16 padding; /* padding */
> > > > +     __u32 vq_num; /* the number of virtqueues */
> > > > +     __u32 vq_align; /* the allocation alignment of virtqueue's metadata */
> > >
> > > I'm not sure what this is?
> > >
> >
> >  This will be used by vring_create_virtqueue() too.
>
> If there is no official definition for the meaning of this value then
> "/* same as vring_create_virtqueue()'s vring_align parameter */" would
> be clearer. That way the reader knows what to research in order to
> understand how this field works.
>

OK.

> I don't remember but maybe it was used to support vrings when the
> host/guest have non-4KB page sizes. I wonder if anyone has an official
> definition for this value?

Not sure. Maybe we might need some alignment which is less than
PAGE_SIZE sometimes.

Thanks,
Yongji
