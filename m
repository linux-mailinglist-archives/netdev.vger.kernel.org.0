Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5757B3E5484
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 09:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbhHJHod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 03:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbhHJHoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 03:44:30 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B99EC0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 00:44:08 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id e19so33717650ejs.9
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 00:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=elqUT9stw2J3iR2l4RxHnGypplqsV8TkYIJkIMW8hsY=;
        b=Dw2anpOlrs9rV2RbKN404Zn18rw9HV6mvfkE8M1kGMV2Ah+OI2rfEhpzsA9qdOawIF
         k8THbB9AABfuNY1MbNdd0AcLrxpPD246ArW/bPUC+pr03hqytJJD7OFvzo3N0q/tpZGO
         tH48kCvdWiYFfAcIV1f5yS5oQiNePxkq4fi3pXrnB2oNtBTWdXNxRQpFSbu0OmyXCusR
         +W05Ly+4a2nE2bv8/HwAQbH8fmJcv8+1juWLj995sdhCvh4wbwIAVnm3NRBqnxRlLOyy
         KEmSTLyK4NbrCSV7j939f/4v7zlRHpFqgOALTvOj2N1xjrfa63r8X64WZ/4zirZ1FwSG
         ug5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=elqUT9stw2J3iR2l4RxHnGypplqsV8TkYIJkIMW8hsY=;
        b=h0NCcf+96eiofw359f0uwJ+Sa8KfwzgrKHtChGQ6zW1k6OEiuxprn8AAdwiPs+mFwN
         wDk0/ZPSvCWSSlhpDCDe6V6634YP5CHNycY805Yr2UsawqJY6QHCUSkIoVcWB9Jg5BQD
         kjzHJYQNzyD1t0HO8TAi/IVpOHBPHPQDwq/U85iSTtAnQWv2UkTeqlm2k5fBF44DWbDw
         le3652lanjEm3mEXQz3qFWw3DxrUxJeI1sHkOHUyCQur32dpfBT0+4Q5QpDb80w/sGOG
         lVHHrt3TFdAJvA8YusOf2wirTjWCwDVhjszvXrJz9ZRn2TLZqPDPh+d458gdbaTca0cN
         F9hw==
X-Gm-Message-State: AOAM532Fg228L1IJGjIijL+uhzyjK2NIQBdtxfJlpkTliotFxWfsf854
        pVB2hTc6QjyfsbYCzAOvSWg9tLhlGdc/Ayy4Sj66
X-Google-Smtp-Source: ABdhPJx/TbMGjhieQzq1YqRjJBN7a9WTaXbFyhJM7EzEX+MXvLMAXR31L8+X5gM3dqLz8GqZFLUy0w3uIoYuvmPOUqE=
X-Received: by 2002:a17:906:8606:: with SMTP id o6mr26642389ejx.247.1628581447154;
 Tue, 10 Aug 2021 00:44:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210729073503.187-1-xieyongji@bytedance.com> <20210729073503.187-2-xieyongji@bytedance.com>
 <43d88942-1cd3-c840-6fec-4155fd544d80@redhat.com> <CACycT3vcpwyA3xjD29f1hGnYALyAd=-XcWp8+wJiwSqpqUu00w@mail.gmail.com>
 <6e05e25e-e569-402e-d81b-8ac2cff1c0e8@arm.com> <CACycT3sm2r8NMMUPy1k1PuSZZ3nM9aic-O4AhdmRRCwgmwGj4Q@mail.gmail.com>
 <417ce5af-4deb-5319-78ce-b74fb4dd0582@arm.com> <CACycT3vARzvd4-dkZhDHqUkeYoSxTa2ty0z0ivE1znGti+n1-g@mail.gmail.com>
 <8c381d3d-9bbd-73d6-9733-0f0b15c40820@redhat.com> <CACycT3steXFeg7NRbWpo2J59dpYcumzcvM2zcPJAVe40-EvvEg@mail.gmail.com>
 <b427cf12-2ff6-e5cd-fe6a-3874d8622a29@redhat.com>
In-Reply-To: <b427cf12-2ff6-e5cd-fe6a-3874d8622a29@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 10 Aug 2021 15:43:56 +0800
Message-ID: <CACycT3vuBdmWdu4X9wjCO0hm+O0xH2Uf0S2ZTk4O_pL2jX6Y5g@mail.gmail.com>
Subject: Re: [PATCH v10 01/17] iova: Export alloc_iova_fast() and free_iova_fast()
To:     Jason Wang <jasowang@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        songmuchun@bytedance.com, Jens Axboe <axboe@kernel.dk>,
        He Zhe <zhe.he@windriver.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, bcrl@kvack.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 11:02 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/8/9 =E4=B8=8B=E5=8D=881:56, Yongji Xie =E5=86=99=E9=81=93:
> > On Thu, Aug 5, 2021 at 9:31 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> =E5=9C=A8 2021/8/5 =E4=B8=8B=E5=8D=888:34, Yongji Xie =E5=86=99=E9=81=
=93:
> >>>> My main point, though, is that if you've already got something else
> >>>> keeping track of the actual addresses, then the way you're using an
> >>>> iova_domain appears to be something you could do with a trivial bitm=
ap
> >>>> allocator. That's why I don't buy the efficiency argument. The main
> >>>> design points of the IOVA allocator are to manage large address spac=
es
> >>>> while trying to maximise spatial locality to minimise the underlying
> >>>> pagetable usage, and allocating with a flexible limit to support
> >>>> multiple devices with different addressing capabilities in the same
> >>>> address space. If none of those aspects are relevant to the use-case=
 -
> >>>> which AFAICS appears to be true here - then as a general-purpose
> >>>> resource allocator it's rubbish and has an unreasonably massive memo=
ry
> >>>> overhead and there are many, many better choices.
> >>>>
> >>> OK, I get your point. Actually we used the genpool allocator in the
> >>> early version. Maybe we can fall back to using it.
> >>
> >> I think maybe you can share some perf numbers to see how much
> >> alloc_iova_fast() can help.
> >>
> > I did some fio tests[1] with a ram-backend vduse block device[2].
> >
> > Following are some performance data:
> >
> >                              numjobs=3D1   numjobs=3D2    numjobs=3D4  =
 numjobs=3D8
> > iova_alloc_fast    145k iops      265k iops      514k iops      758k io=
ps
> >
> > iova_alloc            137k iops     170k iops      128k iops      113k =
iops
> >
> > gen_pool_alloc   143k iops      270k iops      458k iops      521k iops
> >
> > The iova_alloc_fast() has the best performance since we always hit the
> > per-cpu cache. Regardless of the per-cpu cache, the genpool allocator
> > should be better than the iova allocator.
>
>
> I think we see convincing numbers for using iova_alloc_fast() than the
> gen_poll_alloc() (45% improvement on job=3D8).
>

Yes, so alloc_iova_fast() still seems to be the best choice based on
performance considerations.

Hi Robin, any comments?

Thanks,
Yongji
