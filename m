Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0542E7E81
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 07:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgLaGxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 01:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgLaGxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 01:53:00 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC13AC061573
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 22:52:19 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id u19so17444610edx.2
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 22:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sznl824M0Nw944kUYPe3flzJfHkuN/dATIsqpEJOt8U=;
        b=fAtjFSBT2iNAerjoMyuQzTVXAOAqIfrGUGDUV7KfRgtycTsGQY6YCDK+HBxbKlKaS8
         a4eY72W/fsNko+SzxN5Y3nkLdj+3Zqcb4aQtYUHnHpmVSksNlG6+TqddBy+szOBEsLyU
         XRDkue12HliuHSjfXs9R92c+8FLGgJFOFOSd8TTO08AWPkjAT1jOKpMFIpRZ1lOHzfVS
         Kz6tYAbl01rno/ojdtCjoI4S4gSX7pCIRIl85fxRJXgLmFWzzKX7KMrn2y7Gi3X32Z7r
         WypKo6V1g2qeiWiqoEGMunOWRPhez6ZhcOIhijsgsfiGj/BxFmWMC8qHX5CH6VtYaFEn
         Jwyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sznl824M0Nw944kUYPe3flzJfHkuN/dATIsqpEJOt8U=;
        b=Smk9nFtcmgR6BtuRGilRTNq+v/W/SU106JDIU1i79yGB+61whf1/J6Qg6qN3jlYTaZ
         vKbPUtnSKZxX1CaXkLdFNnGgJtq8Srs6Q3Xdhq8noOZTUT2odPawV3aYzV0uWp++gVah
         qrrMeJnmfZ1GRpuCBZPE7qkBOiNGZPotNQiMsxOErhYrnnNK2X9I3T1JIdN6Of7GKZSJ
         jzyLmzIQT9yIEcqTte5O8wz/6clzP7Wxz93f1KsA9r3EMGCAx2IEg2yXC8ySVGn2gKY4
         9AqG7BXZU6u8pbCY5Tj/Iqpoyhe/CvoiuBi+Lts69zLy1YSaWrIpe5MLh+LL8op7nAeC
         qVUg==
X-Gm-Message-State: AOAM533DCDrLAv5ATZ07fYA32M4QQ19yongp7mFXFOw592aNtEQ/XpQ5
        BZoQ4nixJ9y12+GZLj5NBPppOQaUwPxE8dTleRR0
X-Google-Smtp-Source: ABdhPJyxyzPhSMno3pdSEfff92sRiyV1A3LMNVnusj8BACRM6YWwv2wiuMeIm+NU0ippz3o1f7VPfNkwwBMzkvAXZro=
X-Received: by 2002:a05:6402:407:: with SMTP id q7mr53770192edv.312.1609397538325;
 Wed, 30 Dec 2020 22:52:18 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <CACycT3s=m=PQb5WFoMGhz8TNGme4+=rmbbBTtrugF9ZmNnWxEw@mail.gmail.com>
 <0e6faf9c-117a-e23c-8d6d-488d0ec37412@redhat.com> <CACycT3uwXBYvRbKDWdN3oCekv+o6_Lc=-KTrxejD=fr-zgibGw@mail.gmail.com>
 <2b24398c-e6d9-14ec-2c0d-c303d528e377@redhat.com> <CACycT3uDV43ecScrMh1QVpStuwDETHykJzzY=pkmZjP2Dd2kvg@mail.gmail.com>
 <e77c97c5-6bdc-cdd0-62c0-6ff75f6dbdff@redhat.com> <CACycT3soQoX5avZiFBLEGBuJpdni6-UxdhAPGpWHBWVf+dEySg@mail.gmail.com>
 <1356137727.40748805.1609233068675.JavaMail.zimbra@redhat.com>
 <CACycT3sg61yRdupnD+jQEkWKsVEvMWfhkJ=5z_bYZLxCibDiHw@mail.gmail.com>
 <b1aef426-29c7-7244-5fc9-56d52e86abb4@redhat.com> <CACycT3vZ7V5WWhCFLBK6FuvVNmPmMj_yc=COOB4cjjC13yHUwg@mail.gmail.com>
 <3fc6a132-9fc2-c4e2-7fb1-b5a8bfb771fa@redhat.com> <CACycT3tD3zyvV6Zy5NT4x=02hBgrRGq35xeTsRXXx-_wPGJXpQ@mail.gmail.com>
 <e0e693c3-1871-a410-c3d5-964518ec939a@redhat.com> <CACycT3vwMU5R7N8dZFBYX4-bxe2YT7EfK_M_jEkH8wzfH_GkBw@mail.gmail.com>
 <0885385c-ae46-158d-eabf-433ef8ecf27f@redhat.com>
In-Reply-To: <0885385c-ae46-158d-eabf-433ef8ecf27f@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 31 Dec 2020 14:52:07 +0800
Message-ID: <CACycT3tc2P63k6J9ZkWTpPvHk_H8zUq0_Q6WOqYX_dSigUAnzA@mail.gmail.com>
Subject: Re: Re: [RFC v2 09/13] vduse: Add support for processing vhost iotlb message
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 31, 2020 at 1:50 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/31 =E4=B8=8B=E5=8D=881:15, Yongji Xie wrote:
> > On Thu, Dec 31, 2020 at 10:49 AM Jason Wang <jasowang@redhat.com> wrote=
:
> >>
> >> On 2020/12/30 =E4=B8=8B=E5=8D=886:12, Yongji Xie wrote:
> >>> On Wed, Dec 30, 2020 at 4:41 PM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>>> On 2020/12/30 =E4=B8=8B=E5=8D=883:09, Yongji Xie wrote:
> >>>>> On Wed, Dec 30, 2020 at 2:11 PM Jason Wang <jasowang@redhat.com> wr=
ote:
> >>>>>> On 2020/12/29 =E4=B8=8B=E5=8D=886:26, Yongji Xie wrote:
> >>>>>>> On Tue, Dec 29, 2020 at 5:11 PM Jason Wang <jasowang@redhat.com> =
wrote:
> >>>>>>>> ----- Original Message -----
> >>>>>>>>> On Mon, Dec 28, 2020 at 4:43 PM Jason Wang <jasowang@redhat.com=
> wrote:
> >>>>>>>>>> On 2020/12/28 =E4=B8=8B=E5=8D=884:14, Yongji Xie wrote:
> >>>>>>>>>>>> I see. So all the above two questions are because VHOST_IOTL=
B_INVALIDATE
> >>>>>>>>>>>> is expected to be synchronous. This need to be solved by twe=
aking the
> >>>>>>>>>>>> current VDUSE API or we can re-visit to go with descriptors =
relaying
> >>>>>>>>>>>> first.
> >>>>>>>>>>>>
> >>>>>>>>>>> Actually all vdpa related operations are synchronous in curre=
nt
> >>>>>>>>>>> implementation. The ops.set_map/dma_map/dma_unmap should not =
return
> >>>>>>>>>>> until the VDUSE_UPDATE_IOTLB/VDUSE_INVALIDATE_IOTLB message i=
s replied
> >>>>>>>>>>> by userspace. Could it solve this problem?
> >>>>>>>>>>       I was thinking whether or not we need to generate IOTLB_=
INVALIDATE
> >>>>>>>>>> message to VDUSE during dma_unmap (vduse_dev_unmap_page).
> >>>>>>>>>>
> >>>>>>>>>> If we don't, we're probably fine.
> >>>>>>>>>>
> >>>>>>>>> It seems not feasible. This message will be also used in the
> >>>>>>>>> virtio-vdpa case to notify userspace to unmap some pages during
> >>>>>>>>> consistent dma unmapping. Maybe we can document it to make sure=
 the
> >>>>>>>>> users can handle the message correctly.
> >>>>>>>> Just to make sure I understand your point.
> >>>>>>>>
> >>>>>>>> Do you mean you plan to notify the unmap of 1) streaming DMA or =
2)
> >>>>>>>> coherent DMA?
> >>>>>>>>
> >>>>>>>> For 1) you probably need a workqueue to do that since dma unmap =
can
> >>>>>>>> be done in irq or bh context. And if usrspace does't do the unma=
p, it
> >>>>>>>> can still access the bounce buffer (if you don't zap pte)?
> >>>>>>>>
> >>>>>>> I plan to do it in the coherent DMA case.
> >>>>>> Any reason for treating coherent DMA differently?
> >>>>>>
> >>>>> Now the memory of the bounce buffer is allocated page by page in th=
e
> >>>>> page fault handler. So it can't be used in coherent DMA mapping cas=
e
> >>>>> which needs some memory with contiguous virtual addresses. I can us=
e
> >>>>> vmalloc() to do allocation for the bounce buffer instead. But it mi=
ght
> >>>>> cause some memory waste. Any suggestion?
> >>>> I may miss something. But I don't see a relationship between the
> >>>> IOTLB_UNMAP and vmalloc().
> >>>>
> >>> In the vmalloc() case, the coherent DMA page will be taken from the
> >>> memory allocated by vmalloc(). So IOTLB_UNMAP is not needed anymore
> >>> during coherent DMA unmapping because those vmalloc'ed memory which
> >>> has been mapped into userspace address space during initialization ca=
n
> >>> be reused. And userspace should not unmap the region until we destroy
> >>> the device.
> >>
> >> Just to make sure I understand. My understanding is that IOTLB_UNMAP i=
s
> >> only needed when there's a change the mapping from IOVA to page.
> >>
> > Yes, that's true.
> >
> >> So if we stick to the mapping, e.g during dma_unmap, we just put IOVA =
to
> >> free list to be used by the next IOVA allocating. IOTLB_UNMAP could be
> >> avoided.
> >>
> >> So we are not limited by how the pages are actually allocated?
> >>
> > In coherent DMA cases, we need to return some memory with contiguous
> > kernel virtual addresses. That is the reason why we need vmalloc()
> > here. If we allocate the memory page by page, the corresponding kernel
> > virtual addresses in a contiguous IOVA range might not be contiguous.
>
>
> Yes, but we can do that as what has been done in the series
> (alloc_pages_exact()). Or do you mean it would be a little bit hard to
> recycle IOVA/pages here?
>

Yes, it might be hard to reuse the memory. For example, we firstly
allocate 1 IOVA/page during dma_map, then the IOVA is freed during
dma_unmap. Actually we can't reuse this single page if we need a
two-pages area in the next IOVA allocating. So the best way is using
IOTLB_UNMAP to free this single page during dma_unmap too.

Thanks,
Yongji
