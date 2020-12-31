Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D1B2E7E0B
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 06:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgLaFQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 00:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgLaFQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 00:16:41 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3326AC061575
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 21:16:00 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r5so17246746eda.12
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 21:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Fr8GvN1+YBA2/bLMNNrkP+yQOBmzJ011p/HaCmEdZ/0=;
        b=XFJR6OoQ+EmCp4AYfNhOZ40sV2hBUq3MgIvdfNJv2GH3YoziryLKY7EKtuAQ3ppvpw
         8CHRbGH2ANTsgrVBzf/5gUEtQjS8ZDlwgrZDmGoV9Vn85UL3c7oZm8nonYHld1evL+6W
         5jZLPoVtG3MPLwDTX6tb9J2tiELJYjP6I3kENz/SrFDfehbLXe+K3mfpADKo/B/+3qOY
         M+CrYPZY27Or6LYTB5Gb8yktbZ/V8D1BVEMN+eMeGFYo7jMMKV65YjqZSjB4YWvN/tDm
         U2KIacSuYf+BaBXdXdoBaf53Z8T7eMDfTY7nYKXbcPsx9qScSB8HDWK8U3z76WDaVYs1
         rnJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Fr8GvN1+YBA2/bLMNNrkP+yQOBmzJ011p/HaCmEdZ/0=;
        b=pNWgxPI1TXG5gaLWVAFSiD8L28moUkWP6jzyZa4TeQV0c6Sk1kDH2pI8RWmCHSfuoM
         AZ5lQuEsWtI1Lyqj//ZiZGYkcsVUXUp/oUsti6wFVIAHMx04iOUk7R+bksM94oEbVeLX
         25e60qkIeiooDZ4sTgAFZgUxoKa0ijRtDkVxFpLMnchcDBVlfz+A+zSRt/CS9L2E7rIh
         ohHsAYMvWKURvBs9mXAvsdoYe96XAJwZhJDTsfeTc4tboljja17GMMVO/I5n/94mIS0I
         Q3fykU6DqZFWgZDHozasIMNP1Bm0FpZJPLpFNcBhhnAupGtltOelByCWGjVC99SFqbPG
         BjLA==
X-Gm-Message-State: AOAM533CF+fmBob/Hqa2Slf0cSz6V5Euc39B0q6IL1y6uCOYHXYdU32y
        QJ3/V17hiGe/WLDN7t0VJn5IjASWeyn9MW2T+k/D
X-Google-Smtp-Source: ABdhPJyDGyU+tI3srMa1F+hq5E4g0RZOH5eSzzR9KpND7TxAz97zJun+r+t0BDMFiLqvI0IkVgAgyXV5X8tcVzK4uSc=
X-Received: by 2002:a50:f40e:: with SMTP id r14mr52010730edm.5.1609391758773;
 Wed, 30 Dec 2020 21:15:58 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <CACycT3s=m=PQb5WFoMGhz8TNGme4+=rmbbBTtrugF9ZmNnWxEw@mail.gmail.com>
 <0e6faf9c-117a-e23c-8d6d-488d0ec37412@redhat.com> <CACycT3uwXBYvRbKDWdN3oCekv+o6_Lc=-KTrxejD=fr-zgibGw@mail.gmail.com>
 <2b24398c-e6d9-14ec-2c0d-c303d528e377@redhat.com> <CACycT3uDV43ecScrMh1QVpStuwDETHykJzzY=pkmZjP2Dd2kvg@mail.gmail.com>
 <e77c97c5-6bdc-cdd0-62c0-6ff75f6dbdff@redhat.com> <CACycT3soQoX5avZiFBLEGBuJpdni6-UxdhAPGpWHBWVf+dEySg@mail.gmail.com>
 <1356137727.40748805.1609233068675.JavaMail.zimbra@redhat.com>
 <CACycT3sg61yRdupnD+jQEkWKsVEvMWfhkJ=5z_bYZLxCibDiHw@mail.gmail.com>
 <b1aef426-29c7-7244-5fc9-56d52e86abb4@redhat.com> <CACycT3vZ7V5WWhCFLBK6FuvVNmPmMj_yc=COOB4cjjC13yHUwg@mail.gmail.com>
 <3fc6a132-9fc2-c4e2-7fb1-b5a8bfb771fa@redhat.com> <CACycT3tD3zyvV6Zy5NT4x=02hBgrRGq35xeTsRXXx-_wPGJXpQ@mail.gmail.com>
 <e0e693c3-1871-a410-c3d5-964518ec939a@redhat.com>
In-Reply-To: <e0e693c3-1871-a410-c3d5-964518ec939a@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 31 Dec 2020 13:15:48 +0800
Message-ID: <CACycT3vwMU5R7N8dZFBYX4-bxe2YT7EfK_M_jEkH8wzfH_GkBw@mail.gmail.com>
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

On Thu, Dec 31, 2020 at 10:49 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/30 =E4=B8=8B=E5=8D=886:12, Yongji Xie wrote:
> > On Wed, Dec 30, 2020 at 4:41 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2020/12/30 =E4=B8=8B=E5=8D=883:09, Yongji Xie wrote:
> >>> On Wed, Dec 30, 2020 at 2:11 PM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>>> On 2020/12/29 =E4=B8=8B=E5=8D=886:26, Yongji Xie wrote:
> >>>>> On Tue, Dec 29, 2020 at 5:11 PM Jason Wang <jasowang@redhat.com> wr=
ote:
> >>>>>> ----- Original Message -----
> >>>>>>> On Mon, Dec 28, 2020 at 4:43 PM Jason Wang <jasowang@redhat.com> =
wrote:
> >>>>>>>> On 2020/12/28 =E4=B8=8B=E5=8D=884:14, Yongji Xie wrote:
> >>>>>>>>>> I see. So all the above two questions are because VHOST_IOTLB_=
INVALIDATE
> >>>>>>>>>> is expected to be synchronous. This need to be solved by tweak=
ing the
> >>>>>>>>>> current VDUSE API or we can re-visit to go with descriptors re=
laying
> >>>>>>>>>> first.
> >>>>>>>>>>
> >>>>>>>>> Actually all vdpa related operations are synchronous in current
> >>>>>>>>> implementation. The ops.set_map/dma_map/dma_unmap should not re=
turn
> >>>>>>>>> until the VDUSE_UPDATE_IOTLB/VDUSE_INVALIDATE_IOTLB message is =
replied
> >>>>>>>>> by userspace. Could it solve this problem?
> >>>>>>>>      I was thinking whether or not we need to generate IOTLB_INV=
ALIDATE
> >>>>>>>> message to VDUSE during dma_unmap (vduse_dev_unmap_page).
> >>>>>>>>
> >>>>>>>> If we don't, we're probably fine.
> >>>>>>>>
> >>>>>>> It seems not feasible. This message will be also used in the
> >>>>>>> virtio-vdpa case to notify userspace to unmap some pages during
> >>>>>>> consistent dma unmapping. Maybe we can document it to make sure t=
he
> >>>>>>> users can handle the message correctly.
> >>>>>> Just to make sure I understand your point.
> >>>>>>
> >>>>>> Do you mean you plan to notify the unmap of 1) streaming DMA or 2)
> >>>>>> coherent DMA?
> >>>>>>
> >>>>>> For 1) you probably need a workqueue to do that since dma unmap ca=
n
> >>>>>> be done in irq or bh context. And if usrspace does't do the unmap,=
 it
> >>>>>> can still access the bounce buffer (if you don't zap pte)?
> >>>>>>
> >>>>> I plan to do it in the coherent DMA case.
> >>>> Any reason for treating coherent DMA differently?
> >>>>
> >>> Now the memory of the bounce buffer is allocated page by page in the
> >>> page fault handler. So it can't be used in coherent DMA mapping case
> >>> which needs some memory with contiguous virtual addresses. I can use
> >>> vmalloc() to do allocation for the bounce buffer instead. But it migh=
t
> >>> cause some memory waste. Any suggestion?
> >>
> >> I may miss something. But I don't see a relationship between the
> >> IOTLB_UNMAP and vmalloc().
> >>
> > In the vmalloc() case, the coherent DMA page will be taken from the
> > memory allocated by vmalloc(). So IOTLB_UNMAP is not needed anymore
> > during coherent DMA unmapping because those vmalloc'ed memory which
> > has been mapped into userspace address space during initialization can
> > be reused. And userspace should not unmap the region until we destroy
> > the device.
>
>
> Just to make sure I understand. My understanding is that IOTLB_UNMAP is
> only needed when there's a change the mapping from IOVA to page.
>

Yes, that's true.

> So if we stick to the mapping, e.g during dma_unmap, we just put IOVA to
> free list to be used by the next IOVA allocating. IOTLB_UNMAP could be
> avoided.
>
> So we are not limited by how the pages are actually allocated?
>

In coherent DMA cases, we need to return some memory with contiguous
kernel virtual addresses. That is the reason why we need vmalloc()
here. If we allocate the memory page by page, the corresponding kernel
virtual addresses in a contiguous IOVA range might not be contiguous.
And in streaming DMA cases, there is no limit. So another choice is
using vmalloc'ed memory only for coherent DMA cases.

Not sure if this is clear for you.

Thanks,
Yongji
