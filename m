Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F859336A22
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 03:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhCKC3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 21:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhCKC25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 21:28:57 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E377C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 18:28:57 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id e19so43112705ejt.3
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 18:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nGcG4vIt8aK8XQYHFfVsg5ZilyuH9KX5JCZmjoZKMsA=;
        b=bJFaB7w2p1VmRWq7tx9CxGxY3HG7DINc80iCJrafg+N0T0fIpXcxAoRLUhZsrZnkHt
         Li+G0KV/JQX5TdIQxf37qh2Yh8LnfZPN/iDVu1Wl6OQR9hFnk23cnOM0oiD2tEnQ89T9
         XM0l6SErGC3jeogkdBxN1tzHYTiSG+OKvV36N+3Lc6TJL8YSDu8TguWfBvbVQGHctCtt
         pvZgbIR96nCZ85xunUrkBEdeR8PN4Wpg7gQgxEIYuMa45vei3621A6dP4TDWpGvUIMs0
         bMz74FHMW5d9Q5QDgyt+facrntknlie1x4j9Cc6p3TXqkvVu44bycD9Yd4KnJXHRbxSA
         yH9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nGcG4vIt8aK8XQYHFfVsg5ZilyuH9KX5JCZmjoZKMsA=;
        b=qfMEqTkI/Tbz06ycdViFphJKQpIVWapxat1nrFwMvRwd2JRU7nT8JLIihs7GcF7lUX
         +0MKtyi0IQ5Yes1YTQhX5ftIVIjsog1Uliz3zKYb+wyZ5qrWh/hUS0LsP5qMuYeo1bOa
         1IM2DGOVq1muUOuAJ0Bgb8arcoyona7fiAXATWwdgsKa+uFmsfcG9+8cDwkjaz0+jFHw
         UoHbfKBSAbzREHVrT4QrMyYELj1wk/k/7w+rVpzd0pucCedvFIOTeWl7MnxcsUPwAR+q
         XBrUbnVYONDbfh6LPVs6rVottmrAoOZTlrrWZw38/2jANQnH1vHoAJuJ939IOS5JWiEN
         RGUg==
X-Gm-Message-State: AOAM531VHdV525ii0Ji9XPj0FTckppZyXG6M78G6iLpWnxnwFcPMDsBi
        AUw/fyXhZpAlq6ZC/RwDBQMxMpBzR8gBbUzkj/Ux
X-Google-Smtp-Source: ABdhPJwETmRnZq0PVHiftngf3TWvad/EGIWbau++w4aXQxStI2INxttwkESh3Zs0S3paI2zoVX/YMR2WB71SMvc7KXM=
X-Received: by 2002:a17:906:18f1:: with SMTP id e17mr825050ejf.372.1615429736001;
 Wed, 10 Mar 2021 18:28:56 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-8-xieyongji@bytedance.com>
 <2c7446dd-38f8-a06a-e423-6744c6a7207f@redhat.com>
In-Reply-To: <2c7446dd-38f8-a06a-e423-6744c6a7207f@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 11 Mar 2021 10:28:45 +0800
Message-ID: <CACycT3vYPHNrgVTrtMegQu6VdbaOGvCcxP+w8oUK5kPt6XLPUw@mail.gmail.com>
Subject: Re: Re: [RFC v4 07/11] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 8:58 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/2/23 7:50 =E4=B8=8B=E5=8D=88, Xie Yongji wrote:
> > +
> > +     switch (cmd) {
> > +     case VDUSE_IOTLB_GET_FD: {
> > +             struct vduse_iotlb_entry entry;
> > +             struct vhost_iotlb_map *map;
> > +             struct vdpa_map_file *map_file;
> > +             struct file *f =3D NULL;
> > +
> > +             ret =3D -EFAULT;
> > +             if (copy_from_user(&entry, argp, sizeof(entry)))
> > +                     break;
> > +
> > +             spin_lock(&dev->iommu_lock);
> > +             map =3D vhost_iotlb_itree_first(dev->iommu, entry.start,
> > +                                           entry.last);
> > +             if (map) {
> > +                     map_file =3D (struct vdpa_map_file *)map->opaque;
> > +                     f =3D get_file(map_file->file);
> > +                     entry.offset =3D map_file->offset;
> > +                     entry.start =3D map->start;
> > +                     entry.last =3D map->last;
> > +                     entry.perm =3D map->perm;
> > +             }
> > +             spin_unlock(&dev->iommu_lock);
> > +             if (!f) {
> > +                     ret =3D -EINVAL;
> > +                     break;
> > +             }
> > +             if (copy_to_user(argp, &entry, sizeof(entry))) {
> > +                     fput(f);
> > +                     ret =3D -EFAULT;
> > +                     break;
> > +             }
> > +             ret =3D get_unused_fd_flags(perm_to_file_flags(entry.perm=
));
> > +             if (ret < 0) {
> > +                     fput(f);
> > +                     break;
> > +             }
> > +             fd_install(ret, f);
>
>
> So at least we need to use receice_fd_user() here to give a chance to be
> hooked into security module.
>

Good point. Will do it in v5.

Thanks,
Yongji
