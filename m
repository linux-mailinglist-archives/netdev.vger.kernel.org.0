Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D005B330686
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 04:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhCHDpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 22:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbhCHDpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 22:45:16 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAE4C061760
        for <netdev@vger.kernel.org>; Sun,  7 Mar 2021 19:45:15 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id mm21so17360480ejb.12
        for <netdev@vger.kernel.org>; Sun, 07 Mar 2021 19:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=juQbjAznEttYkdsMqemcEvUt5764+jD8IYLf3N7F5J4=;
        b=rxpSYsxTzXxmKyc1nTnhIjBIOlemfEu/YRAGVUyrnC/ejhjIKanR3c6oWUG73fMYTt
         DNoEbpRYDZcxCcQ6LilbJ7sHx3+AeBNwgoy5giLsvL9jLEDL1SmABM/42xQnm2NChnQR
         +obCmJAu7HyM0tmqf/OYxtPGuCjtfu5NZIXgYOL3BefSUhBt0Zs+wWP9MiI99yVvMv7A
         1Xj66PtkM/Yjq+oZ0pnrcaL+Qx4ZDUJBrqm34bBlK8LcNLl3EEwJbKk0eqcQzjBAmALz
         kGErGD9k+fDXk4X7c00d4Tg0BDy8Gh7WWD8vEI2LW48BA8Fy71fwC4R1wkHWb2L8rIDi
         rUQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=juQbjAznEttYkdsMqemcEvUt5764+jD8IYLf3N7F5J4=;
        b=WJ/XKokbFY7+JbgiK264QkrDky9Cc3JQHPDfbOAfc0FiNCHorE0BH+lZF812SrKizH
         fqp1KlBJ7j0RVluVnnGHcW1gRO0Ryo1bkeveurse8u/8MnKlrXMXLUqdlsk/DDrR3gUV
         o+/U79cMfdsCc9MX5peMNpK3KtS4IGjgInPVz3KWbmCyH0gx/8UpkCjhi8zOhZRsYsTd
         lg9zNGaSEi2oIoFpt94Cb4l9b8VJxp0B7T4aEE+hpqQkbrW6U14C5UxMi0yIYa77QehY
         X5nEdANBnWRDplOxWeZEFB/MmysJGYe6MloH9TTI6hNjasvgD4R3khXSwkl8EaOouB+J
         aukQ==
X-Gm-Message-State: AOAM530wHfLUEp0a1K93GkZXZ1SJYEIp2NXm5EqRJjTQQszSwc6o/PnA
        r1s/GWe4XCyEYuVOxwwX1509bzrmTFXKxmH98etd
X-Google-Smtp-Source: ABdhPJz1J2vzr7NkIywXYXq30CbRz3ox+VOUiT6UK+g+NllwyuN7V0Xs5uAmvwtqu5cMoTeEPeu3HYX0lspZ+AVfrhQ=
X-Received: by 2002:a17:906:2a8b:: with SMTP id l11mr13178144eje.1.1615175114348;
 Sun, 07 Mar 2021 19:45:14 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-7-xieyongji@bytedance.com>
 <573ab913-55ce-045a-478f-1200bd78cf7b@redhat.com> <CACycT3sVhDKKu4zGbt1Lw-uWfKDAWs=O=C7kXXcuSnePohmBdQ@mail.gmail.com>
 <c173b7ec-8c90-d0e3-7272-a56aa8935e64@redhat.com> <CACycT3vb=WyrMpiOOdVDGEh8cEDb-xaj1esQx2UEQpJnOOWhmw@mail.gmail.com>
 <4db35f8c-ee3a-90fb-8d14-5d6014b4f6fa@redhat.com> <CACycT3sUJNmi2BdLsi3W72+qTKQaCo_nQYu-fdxg9y4pAvBMow@mail.gmail.com>
 <2652f696-faf7-26eb-a8b2-c4cfe3aaed15@redhat.com> <CACycT3uMV9wg5yVKmEJpbZrs3x0b4+b9eNcUTh3+CjxsG7x2LA@mail.gmail.com>
 <d4681614-bd1e-8fe7-3b03-72eb2011c3c2@redhat.com>
In-Reply-To: <d4681614-bd1e-8fe7-3b03-72eb2011c3c2@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 8 Mar 2021 11:45:03 +0800
Message-ID: <CACycT3uA5y=jcKPwu6rZ83Lqf1ytuPhnxWLCeMpDYrvRodHFVg@mail.gmail.com>
Subject: Re: Re: [RFC v4 06/11] vduse: Implement an MMU-based IOMMU driver
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

On Mon, Mar 8, 2021 at 11:17 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/3/5 3:59 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> > On Fri, Mar 5, 2021 at 3:27 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/3/5 3:13 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>> On Fri, Mar 5, 2021 at 2:52 PM Jason Wang <jasowang@redhat.com> wrote=
:
> >>>> On 2021/3/5 2:15 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>>>
> >>>> Sorry if I've asked this before.
> >>>>
> >>>> But what's the reason for maintaing a dedicated IOTLB here? I think =
we
> >>>> could reuse vduse_dev->iommu since the device can not be used by bot=
h
> >>>> virtio and vhost in the same time or use vduse_iova_domain->iotlb fo=
r
> >>>> set_map().
> >>>>
> >>>> The main difference between domain->iotlb and dev->iotlb is the way =
to
> >>>> deal with bounce buffer. In the domain->iotlb case, bounce buffer
> >>>> needs to be mapped each DMA transfer because we need to get the boun=
ce
> >>>> pages by an IOVA during DMA unmapping. In the dev->iotlb case, bounc=
e
> >>>> buffer only needs to be mapped once during initialization, which wil=
l
> >>>> be used to tell userspace how to do mmap().
> >>>>
> >>>> Also, since vhost IOTLB support per mapping token (opauqe), can we u=
se
> >>>> that instead of the bounce_pages *?
> >>>>
> >>>> Sorry, I didn't get you here. Which value do you mean to store in th=
e
> >>>> opaque pointer=EF=BC=9F
> >>>>
> >>>> So I would like to have a way to use a single IOTLB for manage all k=
inds
> >>>> of mappings. Two possible ideas:
> >>>>
> >>>> 1) map bounce page one by one in vduse_dev_map_page(), in
> >>>> VDUSE_IOTLB_GET_FD, try to merge the result if we had the same fd. T=
hen
> >>>> for bounce pages, userspace still only need to map it once and we ca=
n
> >>>> maintain the actual mapping by storing the page or pa in the opaque
> >>>> field of IOTLB entry.
> >>>>
> >>>> Looks like userspace still needs to unmap the old region and map a n=
ew
> >>>> region (size is changed) with the fd in each VDUSE_IOTLB_GET_FD ioct=
l.
> >>>>
> >>>>
> >>>> I don't get here. Can you give an example?
> >>>>
> >>> For example, userspace needs to process two I/O requests (one page pe=
r
> >>> request). To process the first request, userspace uses
> >>> VDUSE_IOTLB_GET_FD ioctl to query the iova region (0 ~ 4096) and mmap
> >>> it.
> >>
> >> I think in this case we should let VDUSE_IOTLB_GET_FD return the maxim=
um
> >> range as far as they are backed by the same fd.
> >>
> > But now the bounce page is mapped one by one. The second page (4096 ~
> > 8192) might not be mapped when userspace is processing the first
> > request. So the maximum range is 0 ~ 4096 at that time.
> >
> > Thanks,
> > Yongji
>
>
> A question, if I read the code correctly, VDUSE_IOTLB_GET_FD will return
> the whole bounce map range which is setup in vduse_dev_map_page()? So my
> understanding is that usersapce may choose to map all its range via mmap(=
).
>

Yes.

> So if we 'map' bounce page one by one in vduse_dev_map_page(). (Here
> 'map' means using multiple itree entries instead of a single one). Then
> in the VDUSE_IOTLB_GET_FD we can keep traversing itree (dev->iommu)
> until the range is backed by a different file.
>
> With this, there's no userspace visible changes and there's no need for
> the domain->iotlb?
>

In this case, I wonder what range can be obtained if userspace calls
VDUSE_IOTLB_GET_FD when the first I/O (e.g. 4K) occurs. [0, 4K] or [0,
64M]? In current implementation, userspace will map [0, 64M].

Thanks,
Yongji
