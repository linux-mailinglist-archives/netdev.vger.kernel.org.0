Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04D33B6F23
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 10:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhF2IRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 04:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbhF2IRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 04:17:14 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78411C061767
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 01:14:47 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id l24so5563938ejq.11
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 01:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uptPqcgshGnCftIWPnxGiyLOnUUUIP0/+ojiVFO1k00=;
        b=DRDFZWTpGi9GCyTDEZBHK+CH/M843cbtTy9vUm8a5IsHg/jkfiUZbd4xYJX6iZu6cW
         9GFiPjoCONUMKxg5SnLXbhDBJ/pjzDoy1JqsZXHVy8Kr2mESTA8qWpG1fam0YYiIMbhU
         9GQywd2enJcCN300YNcOenjqf+z61wovjpxOBODz/aIV6xIqUGQr1Ssg3Hyiv4mAs1Cc
         kfrvmN8IkAPcaOiP2ZLt/twpqM4r/ihXgA9G7NK7+twdlzhXEEjkO9OxziYqElX+Wri1
         /EcksaYxLEvAl4P9igdr5L643F8OFvKS3ZRNWd9sxRl+uBkLH/YyNWfUL3Qa4HWi9OmH
         NBOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uptPqcgshGnCftIWPnxGiyLOnUUUIP0/+ojiVFO1k00=;
        b=sOLBZ8kk0ZrVPPcq/uwUSMGzXbDrCavu5LJ2ZaRqhGqh7/o6oJrqcNbUZBS6N0kpVg
         X9nGuZbyUqVZmrHv6YddG6hbbZhCh8F8RLo5YGSolDFWD1+kfIIXiXRGk1FOQBgz0dMw
         v+SdagLlADF033xcnArlKq/Iptq8+kUOpCsagtEEJXOIYUa52+uTM/77kXyaQWW876qV
         SjIEpDDWBFIOA7iln2fM9/UGxES/8u7iOnmhP7N/ihEb+kh7muOdWvNuR7Kv+kvPBnlY
         EBedp3r+ute5OaLvtUenGCoD1w/jml2BdTt9/szpNY1LJoiv5/ZX+YjhcX2CGZ/+mGzP
         Rfwg==
X-Gm-Message-State: AOAM532m7+n57y1CUm0r/sBrdre9sqjznSCpQJU7k9/suHECorjRyg2c
        BM/BbsYOYQvYaa6YsuI1NESubHoc+GgagbCw4PVh
X-Google-Smtp-Source: ABdhPJzdlnMCYGA3kLT4t5c8ykTQcQqn/qmqlv/E8TGGEpG2riZ7T0plVIhIHa9FvZNn80TVOmuS6b2nFy6yQNioXsA=
X-Received: by 2002:a17:906:7142:: with SMTP id z2mr28262180ejj.427.1624954486045;
 Tue, 29 Jun 2021 01:14:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <20210628103309.GA205554@storage2.sh.intel.com>
 <bdbe3a79-e5ce-c3a5-4c68-c11c65857377@redhat.com> <BYAPR11MB2662FFF6140A4C634648BB2E8C039@BYAPR11MB2662.namprd11.prod.outlook.com>
 <41cc419e-48b5-6755-0cb0-9033bd1310e4@redhat.com> <BYAPR11MB266276002F42D91FCE6E83CE8C029@BYAPR11MB2662.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB266276002F42D91FCE6E83CE8C029@BYAPR11MB2662.namprd11.prod.outlook.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 29 Jun 2021 16:14:35 +0800
Message-ID: <CACycT3sfZCpWqB+GKQYMi3WjOkU0jAkBPU-u+MHHDCbLUvvu4w@mail.gmail.com>
Subject: Re: RE: [PATCH v8 00/10] Introduce VDUSE - vDPA Device in Userspace
To:     "Liu, Xiaodong" <xiaodong.liu@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "sgarzare@redhat.com" <sgarzare@redhat.com>,
        "parav@nvidia.com" <parav@nvidia.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "christian.brauner@canonical.com" <christian.brauner@canonical.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "willy@infradead.org" <willy@infradead.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "mika.penttila@nextfour.com" <mika.penttila@nextfour.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "songmuchun@bytedance.com" <songmuchun@bytedance.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 3:56 PM Liu, Xiaodong <xiaodong.liu@intel.com> wrot=
e:
>
>
>
> >-----Original Message-----
> >From: Jason Wang <jasowang@redhat.com>
> >Sent: Tuesday, June 29, 2021 12:11 PM
> >To: Liu, Xiaodong <xiaodong.liu@intel.com>; Xie Yongji
> ><xieyongji@bytedance.com>; mst@redhat.com; stefanha@redhat.com;
> >sgarzare@redhat.com; parav@nvidia.com; hch@infradead.org;
> >christian.brauner@canonical.com; rdunlap@infradead.org; willy@infradead.=
org;
> >viro@zeniv.linux.org.uk; axboe@kernel.dk; bcrl@kvack.org; corbet@lwn.net=
;
> >mika.penttila@nextfour.com; dan.carpenter@oracle.com; joro@8bytes.org;
> >gregkh@linuxfoundation.org
> >Cc: songmuchun@bytedance.com; virtualization@lists.linux-foundation.org;
> >netdev@vger.kernel.org; kvm@vger.kernel.org; linux-fsdevel@vger.kernel.o=
rg;
> >iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> >Subject: Re: [PATCH v8 00/10] Introduce VDUSE - vDPA Device in Userspace
> >
> >
> >=E5=9C=A8 2021/6/28 =E4=B8=8B=E5=8D=881:54, Liu, Xiaodong =E5=86=99=E9=
=81=93:
> >>> Several issues:
> >>>
> >>> - VDUSE needs to limit the total size of the bounce buffers (64M if I=
 was not
> >>> wrong). Does it work for SPDK?
> >> Yes, Jason. It is enough and works for SPDK.
> >> Since it's a kind of bounce buffer mainly for in-flight IO, so limited=
 size like
> >> 64MB is enough.
> >
> >
> >Ok.
> >
> >
> >>
> >>> - VDUSE can use hugepages but I'm not sure we can mandate hugepages (=
or
> >we
> >>> need introduce new flags for supporting this)
> >> Same with your worry, I'm afraid too that it is a hard for a kernel mo=
dule
> >> to directly preallocate hugepage internal.
> >> What I tried is that:
> >> 1. A simple agent daemon (represents for one device)  `preallocates` a=
nd maps
> >>      dozens of 2MB hugepages (like 64MB) for one device.
> >> 2. The daemon passes its mapping addr&len and hugepage fd to kernel
> >>      module through created IOCTL.
> >> 3. Kernel module remaps the hugepages inside kernel.
> >
> >
> >Such model should work, but the main "issue" is that it introduce
> >overheads in the case of vhost-vDPA.
> >
> >Note that in the case of vhost-vDPA, we don't use bounce buffer, the
> >userspace pages were shared directly.
> >
> >And since DMA is not done per page, it prevents us from using tricks
> >like vm_insert_page() in those cases.
> >
>
> Yes, really, it's a problem to handle vhost-vDPA case.
> But there are already several solutions to get VM served, like vhost-user=
,
> vfio-user, so at least for SPDK, it won't serve VM through VDUSE. If a us=
er
> still want to do that, then the user should tolerate Introduced overhead.
>
> In other words, software backend like SPDK, will appreciate the virtio
> datapath of VDUSE to serve local host instead of VM. That's why I also dr=
afted
> a "virtio-local" to bridge vhost-user target and local host kernel virtio=
-blk.
>
> >
> >> 4. Vhost user target gets and maps hugepage fd from kernel module
> >>      in vhost-user msg through Unix Domain Socket cmsg.
> >> Then kernel module and target map on the same hugepage based
> >> bounce buffer for in-flight IO.
> >>
> >> If there is one option in VDUSE to map userspace preallocated memory, =
then
> >> VDUSE should be able to mandate it even it is hugepage based.
> >>
> >
> >As above, this requires some kind of re-design since VDUSE depends on
> >the model of mmap(MAP_SHARED) instead of umem registering.
>
> Got it, Jason, this may be hard for current version of VDUSE.
> Maybe we can consider these options after VDUSE merged later.
>
> Since if VDUSE datapath could be directly leveraged by vhost-user target,
> its value will be propagated immediately.
>

Agreed=EF=BC=81

Thanks,
Yongji
