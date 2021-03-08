Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FEE330711
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 06:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhCHFFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 00:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhCHFFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 00:05:38 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBC5C061760
        for <netdev@vger.kernel.org>; Sun,  7 Mar 2021 21:05:38 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id c10so17594634ejx.9
        for <netdev@vger.kernel.org>; Sun, 07 Mar 2021 21:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U9i5hJKZHEDQ9s5oCqXQ1ESfIvIrxn1WeIspzrScC9U=;
        b=QUvoUWYDMWPjl3s4eUS+psdEu1frwjV33fbBe8PYtO4N/7rvwojIh/Atm84CDeeha9
         nvWgzCDqflFFKSKgtSmCj3rA6hjlNCYZJEDaL4gx950dEILIJueYNgtJfxNevewKpkLN
         8zCOtOjKqThpHhCptj2r4l6DQ+Es9nGeatqJbMQCa7Eoxk9rPvU2cdMWDnbXwC/rXPuZ
         CIxncjgrPqGmkTHuYpQjf14UEN17yemaOEbrn/xKpiPKmWueNkvWCJjOgsPJ8JQQWPNi
         nGgDYHwedErEFQkFGm9M4QLz98Qw/IP1mgrZKaWy1NgrCHLlbXKarbvLgqkQhDcKSyn/
         I7SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U9i5hJKZHEDQ9s5oCqXQ1ESfIvIrxn1WeIspzrScC9U=;
        b=TA4fDbFoe6uIrDXNEVB1F4QbHN34HXG9ZgC4G+1LZev+2oT+IlppKEE6YQ8VqqOWAE
         m0o1FxPrdUk3Y9yAh8ywU1Eq7c3bDnbZM1S8nfDZWHQZdhQDqu1Qvx0IipMjakHTUeOu
         9TUlv8hOKnvMQkY9o4uRS/iyAYsRhYc7KM7V0v4WKFYa0+YpkZYg7xX4oKF91pd26eJ1
         Nh0FzOukuseZzpwtYhgV+jvH8cfxwhiTf84+yJHfinZv6TmRIODue2BNEBZdxRV65+0F
         1mVlwR8NZ401npg4HfHBusKaiJTQKucqBHmD0aTXAn0NhA3bLvhd8++M0iCM3SLSmozI
         Moqg==
X-Gm-Message-State: AOAM531WrvuSPthMugEHr1MpKrfGSWGJpSgnNgJTErHtXDsWxHP2tcXM
        gASjRW3dKYxtjdKDn78SlLVuGiSYudbyXLCbSB98
X-Google-Smtp-Source: ABdhPJzArI4nQUDbllLNwaDXzEUsWPSCVR7LD8mTcQ1y9O47fIB9CgHOQD162B2SFhKuNPY+4vqsTCYH/lt2EO68VF8=
X-Received: by 2002:a17:906:7b8d:: with SMTP id s13mr13488428ejo.247.1615179936950;
 Sun, 07 Mar 2021 21:05:36 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-7-xieyongji@bytedance.com>
 <573ab913-55ce-045a-478f-1200bd78cf7b@redhat.com> <CACycT3sVhDKKu4zGbt1Lw-uWfKDAWs=O=C7kXXcuSnePohmBdQ@mail.gmail.com>
 <c173b7ec-8c90-d0e3-7272-a56aa8935e64@redhat.com> <CACycT3vb=WyrMpiOOdVDGEh8cEDb-xaj1esQx2UEQpJnOOWhmw@mail.gmail.com>
 <4db35f8c-ee3a-90fb-8d14-5d6014b4f6fa@redhat.com> <CACycT3sUJNmi2BdLsi3W72+qTKQaCo_nQYu-fdxg9y4pAvBMow@mail.gmail.com>
 <2652f696-faf7-26eb-a8b2-c4cfe3aaed15@redhat.com> <CACycT3uMV9wg5yVKmEJpbZrs3x0b4+b9eNcUTh3+CjxsG7x2LA@mail.gmail.com>
 <d4681614-bd1e-8fe7-3b03-72eb2011c3c2@redhat.com> <CACycT3uA5y=jcKPwu6rZ83Lqf1ytuPhnxWLCeMpDYrvRodHFVg@mail.gmail.com>
 <0b671aef-f2b2-6162-f407-7ca5178dbebb@redhat.com>
In-Reply-To: <0b671aef-f2b2-6162-f407-7ca5178dbebb@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 8 Mar 2021 13:05:26 +0800
Message-ID: <CACycT3tnd0SziHVpH=yUZFYpeG3c0V+vcGRNT19cp0q9b1GH2Q@mail.gmail.com>
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

On Mon, Mar 8, 2021 at 11:52 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/3/8 11:45 =E4=B8=8A=E5=8D=88, Yongji Xie wrote:
> > On Mon, Mar 8, 2021 at 11:17 AM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/3/5 3:59 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>> On Fri, Mar 5, 2021 at 3:27 PM Jason Wang <jasowang@redhat.com> wrote=
:
> >>>> On 2021/3/5 3:13 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>>>> On Fri, Mar 5, 2021 at 2:52 PM Jason Wang <jasowang@redhat.com> wro=
te:
> >>>>>> On 2021/3/5 2:15 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>>>>>
> >>>>>> Sorry if I've asked this before.
> >>>>>>
> >>>>>> But what's the reason for maintaing a dedicated IOTLB here? I thin=
k we
> >>>>>> could reuse vduse_dev->iommu since the device can not be used by b=
oth
> >>>>>> virtio and vhost in the same time or use vduse_iova_domain->iotlb =
for
> >>>>>> set_map().
> >>>>>>
> >>>>>> The main difference between domain->iotlb and dev->iotlb is the wa=
y to
> >>>>>> deal with bounce buffer. In the domain->iotlb case, bounce buffer
> >>>>>> needs to be mapped each DMA transfer because we need to get the bo=
unce
> >>>>>> pages by an IOVA during DMA unmapping. In the dev->iotlb case, bou=
nce
> >>>>>> buffer only needs to be mapped once during initialization, which w=
ill
> >>>>>> be used to tell userspace how to do mmap().
> >>>>>>
> >>>>>> Also, since vhost IOTLB support per mapping token (opauqe), can we=
 use
> >>>>>> that instead of the bounce_pages *?
> >>>>>>
> >>>>>> Sorry, I didn't get you here. Which value do you mean to store in =
the
> >>>>>> opaque pointer=EF=BC=9F
> >>>>>>
> >>>>>> So I would like to have a way to use a single IOTLB for manage all=
 kinds
> >>>>>> of mappings. Two possible ideas:
> >>>>>>
> >>>>>> 1) map bounce page one by one in vduse_dev_map_page(), in
> >>>>>> VDUSE_IOTLB_GET_FD, try to merge the result if we had the same fd.=
 Then
> >>>>>> for bounce pages, userspace still only need to map it once and we =
can
> >>>>>> maintain the actual mapping by storing the page or pa in the opaqu=
e
> >>>>>> field of IOTLB entry.
> >>>>>>
> >>>>>> Looks like userspace still needs to unmap the old region and map a=
 new
> >>>>>> region (size is changed) with the fd in each VDUSE_IOTLB_GET_FD io=
ctl.
> >>>>>>
> >>>>>>
> >>>>>> I don't get here. Can you give an example?
> >>>>>>
> >>>>> For example, userspace needs to process two I/O requests (one page =
per
> >>>>> request). To process the first request, userspace uses
> >>>>> VDUSE_IOTLB_GET_FD ioctl to query the iova region (0 ~ 4096) and mm=
ap
> >>>>> it.
> >>>> I think in this case we should let VDUSE_IOTLB_GET_FD return the max=
imum
> >>>> range as far as they are backed by the same fd.
> >>>>
> >>> But now the bounce page is mapped one by one. The second page (4096 ~
> >>> 8192) might not be mapped when userspace is processing the first
> >>> request. So the maximum range is 0 ~ 4096 at that time.
> >>>
> >>> Thanks,
> >>> Yongji
> >>
> >> A question, if I read the code correctly, VDUSE_IOTLB_GET_FD will retu=
rn
> >> the whole bounce map range which is setup in vduse_dev_map_page()? So =
my
> >> understanding is that usersapce may choose to map all its range via mm=
ap().
> >>
> > Yes.
> >
> >> So if we 'map' bounce page one by one in vduse_dev_map_page(). (Here
> >> 'map' means using multiple itree entries instead of a single one). The=
n
> >> in the VDUSE_IOTLB_GET_FD we can keep traversing itree (dev->iommu)
> >> until the range is backed by a different file.
> >>
> >> With this, there's no userspace visible changes and there's no need fo=
r
> >> the domain->iotlb?
> >>
> > In this case, I wonder what range can be obtained if userspace calls
> > VDUSE_IOTLB_GET_FD when the first I/O (e.g. 4K) occurs. [0, 4K] or [0,
> > 64M]? In current implementation, userspace will map [0, 64M].
>
>
> It should still be [0, 64M). Do you see any issue?
>

Does it mean we still need to map the whole bounce buffer into itree
(dev->iommu) at initialization?

Thanks,
Yongji
