Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754E92E76C1
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 08:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgL3HJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 02:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgL3HJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 02:09:55 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED0FC061799
        for <netdev@vger.kernel.org>; Tue, 29 Dec 2020 23:09:15 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id w1so20815232ejf.11
        for <netdev@vger.kernel.org>; Tue, 29 Dec 2020 23:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=l8j4LBcYSM3A9J/lyobN/Td5iPDnCHBqIY/lSxbOPoI=;
        b=an2vDV1/CDDLLSUvQH6Uvml6j8CxlkgAoU852XXsrwcYFpo5Ao01qFD5HAOuScQ+qa
         QT3/PEoDuXvZdIc3jQfO05AoGVp8vIC6pI0hZBL+jA0VmErjD1qwAbj8HHm6s0ZO4EWi
         QcYdggbqXxbShmXxf5mFh1jWSRWQe8ZIiP2WbCTnMFvvUFncKOinCVEORK9dYWS7Srq2
         F2tyiD7J/Pq/Dp/lkoub23RdxuPhavSZPsXlGQGJ13t08izTxWrSz97txktHmXo2EqrK
         lwl2krXf/q/AAWhJkgwnSu3ndkhVAy3gtvXeReSa5rG/wgPR/MHX2nNOcHFN5YUyI5Ot
         xfDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=l8j4LBcYSM3A9J/lyobN/Td5iPDnCHBqIY/lSxbOPoI=;
        b=rgjsjQkhcFEarrdF1KMAlM6JZdpYKJSaxfWOEwpmtwtQt7dSI+0ESJ5GjuBrTJCVAG
         m/dYEPH/JwcYBp21CamAqtqFOBv8Df/EeAyAeS6NU/ACUQHS8Kt1V9aO7hojWMMIbxq5
         +idKBJInywnP2FONK0UNlg9GpG7rE5KlkwediydFehxO6FKE7uTocubC7T7KRknpjHXB
         9EV8iiGa2z64bexd6o7xWnS9yMDuoNS3MVdGIULOeOXosHEJcUy6HQ0V9sf/N6dOWpxG
         l8O2bOY17ZhP9sMsRwifzZtGaMNzbzCX/j4dewKYwULzTot5Nc7By/4uvziOvun9elDY
         wc7g==
X-Gm-Message-State: AOAM533zwclJ6WwmidJKxXWqRyMh5u5YENmjxniKNCFJ2+FHUaui/XWa
        PsCyUNTV2+0BCCRiRRzdI0OhQTrKL/VSxae+0iRnIC8TC9rI
X-Google-Smtp-Source: ABdhPJxSggzhnaXhPdSiv6Fgwwsm7jrYKdGJWgqP2yGg8R6DbCqwUHnGXSyfiUFMd9tVV3XFaaGE9JgwBqfN+ujcONk=
X-Received: by 2002:a17:907:961e:: with SMTP id gb30mr46516203ejc.197.1609312154151;
 Tue, 29 Dec 2020 23:09:14 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <CACycT3s=m=PQb5WFoMGhz8TNGme4+=rmbbBTtrugF9ZmNnWxEw@mail.gmail.com>
 <0e6faf9c-117a-e23c-8d6d-488d0ec37412@redhat.com> <CACycT3uwXBYvRbKDWdN3oCekv+o6_Lc=-KTrxejD=fr-zgibGw@mail.gmail.com>
 <2b24398c-e6d9-14ec-2c0d-c303d528e377@redhat.com> <CACycT3uDV43ecScrMh1QVpStuwDETHykJzzY=pkmZjP2Dd2kvg@mail.gmail.com>
 <e77c97c5-6bdc-cdd0-62c0-6ff75f6dbdff@redhat.com> <CACycT3soQoX5avZiFBLEGBuJpdni6-UxdhAPGpWHBWVf+dEySg@mail.gmail.com>
 <1356137727.40748805.1609233068675.JavaMail.zimbra@redhat.com>
 <CACycT3sg61yRdupnD+jQEkWKsVEvMWfhkJ=5z_bYZLxCibDiHw@mail.gmail.com> <b1aef426-29c7-7244-5fc9-56d52e86abb4@redhat.com>
In-Reply-To: <b1aef426-29c7-7244-5fc9-56d52e86abb4@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 30 Dec 2020 15:09:03 +0800
Message-ID: <CACycT3vZ7V5WWhCFLBK6FuvVNmPmMj_yc=COOB4cjjC13yHUwg@mail.gmail.com>
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

On Wed, Dec 30, 2020 at 2:11 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/29 =E4=B8=8B=E5=8D=886:26, Yongji Xie wrote:
> > On Tue, Dec 29, 2020 at 5:11 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >>
> >> ----- Original Message -----
> >>> On Mon, Dec 28, 2020 at 4:43 PM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>>>
> >>>> On 2020/12/28 =E4=B8=8B=E5=8D=884:14, Yongji Xie wrote:
> >>>>>> I see. So all the above two questions are because VHOST_IOTLB_INVA=
LIDATE
> >>>>>> is expected to be synchronous. This need to be solved by tweaking =
the
> >>>>>> current VDUSE API or we can re-visit to go with descriptors relayi=
ng
> >>>>>> first.
> >>>>>>
> >>>>> Actually all vdpa related operations are synchronous in current
> >>>>> implementation. The ops.set_map/dma_map/dma_unmap should not return
> >>>>> until the VDUSE_UPDATE_IOTLB/VDUSE_INVALIDATE_IOTLB message is repl=
ied
> >>>>> by userspace. Could it solve this problem?
> >>>>
> >>>>    I was thinking whether or not we need to generate IOTLB_INVALIDAT=
E
> >>>> message to VDUSE during dma_unmap (vduse_dev_unmap_page).
> >>>>
> >>>> If we don't, we're probably fine.
> >>>>
> >>> It seems not feasible. This message will be also used in the
> >>> virtio-vdpa case to notify userspace to unmap some pages during
> >>> consistent dma unmapping. Maybe we can document it to make sure the
> >>> users can handle the message correctly.
> >> Just to make sure I understand your point.
> >>
> >> Do you mean you plan to notify the unmap of 1) streaming DMA or 2)
> >> coherent DMA?
> >>
> >> For 1) you probably need a workqueue to do that since dma unmap can
> >> be done in irq or bh context. And if usrspace does't do the unmap, it
> >> can still access the bounce buffer (if you don't zap pte)?
> >>
> > I plan to do it in the coherent DMA case.
>
>
> Any reason for treating coherent DMA differently?
>

Now the memory of the bounce buffer is allocated page by page in the
page fault handler. So it can't be used in coherent DMA mapping case
which needs some memory with contiguous virtual addresses. I can use
vmalloc() to do allocation for the bounce buffer instead. But it might
cause some memory waste. Any suggestion?

>
> > It's true that userspace can
> > access the dma buffer if userspace doesn't do the unmap. But the dma
> > pages would not be freed and reused unless user space called munmap()
> > for them.
>
>
> I wonder whether or not we could recycle IOVA in this case to avoid the
> IOTLB_UMAP message.
>

We can achieve that if we use vmalloc() to do allocation for the
bounce buffer which can be used in coherent DMA mapping case. But
looks like we still have no way to avoid the IOTLB_UMAP message in
vhost-vdpa case.

Thanks,
Yongji
