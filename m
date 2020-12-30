Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0272B2E77B0
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 11:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgL3KNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 05:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgL3KNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 05:13:32 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A018C06179E
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 02:12:52 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id b9so21381271ejy.0
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 02:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=J5WJPM6JQMx4Jbj6E9atrShfsotzXemKwoPLiDZZeBk=;
        b=rxuHPmrEKQkHWNReHzNXMMVqRLOCJizhg5zmF8EXSiwuAnfVOYbth3/EzLtp5m31bP
         xaanEaEdkEsLiYv5Rw8VhMhbaWSk5vQ6QGR8dPzTgWHKGG7jf5EEaoD46EPhgg3kgKiC
         Sp/iJpU5Lvh0tRAS/oacUHmEZf8ZL1o4KTwZN6hSI7GiJ0NY/YMyfFNt+17zgAV+RezW
         0cl4iyu2wLI9FM79Z7ibczdgISZ80aptDAiWswwdM/Lge9mNEWI4yH1JyLl9xVRY0uEa
         B07wMrk/Vk5tSBA0FQyPUhs64R9GxUaaS6coE2ln9Wz8I5oKwQLjO56qcGvqffzupefC
         1NMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=J5WJPM6JQMx4Jbj6E9atrShfsotzXemKwoPLiDZZeBk=;
        b=qpjf/+pIx/2E6pVEEfSvIe0JErBh8EGhamLz4aUFuFHZSeXsx2qP0fzRp00BXcCytW
         h2a9ZRbzSIsl1sqYPM0r3XOU4eeYPOok5rn9IUo7nXj894YLLKwDpIRftTIV78Op89Xj
         0Y7g98IOko5Abf3Yt+EFFHla3boHKVHkGbbDDw4JnM/ExiZumCFBxHME8w2ssJoBrBp/
         b409gUkytgipT5PshN0+8HxOdKqtXdWf/n/E6T4m5x54AANw7JZ8/eaGkGEENBncOHyv
         pxM4Jvmfzo+JbBn3JiOIQ+zEOhNKEI5TjoqMnGxOvMfwiPRrG0T8MCIjQGfHqgadonAd
         FE9A==
X-Gm-Message-State: AOAM530/GzLCzYehvYt1V2B2gN+9hI81IIP1D2I5erVWaRrzSqj6JLP+
        jSwi3z9Pc3RVd6GH5U6WBJv/rq1hvPxlFPBJ34SV
X-Google-Smtp-Source: ABdhPJzfcf6oYCVKKo5/Wxp79G1FfJjdqXlE5V4OiBdpmsAmSa6Oyi1m1HZCfASuNteTrZena0AnCK+Qcxz5m86DSM4=
X-Received: by 2002:a17:906:878d:: with SMTP id za13mr48518386ejb.395.1609323170757;
 Wed, 30 Dec 2020 02:12:50 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <CACycT3s=m=PQb5WFoMGhz8TNGme4+=rmbbBTtrugF9ZmNnWxEw@mail.gmail.com>
 <0e6faf9c-117a-e23c-8d6d-488d0ec37412@redhat.com> <CACycT3uwXBYvRbKDWdN3oCekv+o6_Lc=-KTrxejD=fr-zgibGw@mail.gmail.com>
 <2b24398c-e6d9-14ec-2c0d-c303d528e377@redhat.com> <CACycT3uDV43ecScrMh1QVpStuwDETHykJzzY=pkmZjP2Dd2kvg@mail.gmail.com>
 <e77c97c5-6bdc-cdd0-62c0-6ff75f6dbdff@redhat.com> <CACycT3soQoX5avZiFBLEGBuJpdni6-UxdhAPGpWHBWVf+dEySg@mail.gmail.com>
 <1356137727.40748805.1609233068675.JavaMail.zimbra@redhat.com>
 <CACycT3sg61yRdupnD+jQEkWKsVEvMWfhkJ=5z_bYZLxCibDiHw@mail.gmail.com>
 <b1aef426-29c7-7244-5fc9-56d52e86abb4@redhat.com> <CACycT3vZ7V5WWhCFLBK6FuvVNmPmMj_yc=COOB4cjjC13yHUwg@mail.gmail.com>
 <3fc6a132-9fc2-c4e2-7fb1-b5a8bfb771fa@redhat.com>
In-Reply-To: <3fc6a132-9fc2-c4e2-7fb1-b5a8bfb771fa@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 30 Dec 2020 18:12:40 +0800
Message-ID: <CACycT3tD3zyvV6Zy5NT4x=02hBgrRGq35xeTsRXXx-_wPGJXpQ@mail.gmail.com>
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

On Wed, Dec 30, 2020 at 4:41 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/30 =E4=B8=8B=E5=8D=883:09, Yongji Xie wrote:
> > On Wed, Dec 30, 2020 at 2:11 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2020/12/29 =E4=B8=8B=E5=8D=886:26, Yongji Xie wrote:
> >>> On Tue, Dec 29, 2020 at 5:11 PM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>>>
> >>>> ----- Original Message -----
> >>>>> On Mon, Dec 28, 2020 at 4:43 PM Jason Wang <jasowang@redhat.com> wr=
ote:
> >>>>>> On 2020/12/28 =E4=B8=8B=E5=8D=884:14, Yongji Xie wrote:
> >>>>>>>> I see. So all the above two questions are because VHOST_IOTLB_IN=
VALIDATE
> >>>>>>>> is expected to be synchronous. This need to be solved by tweakin=
g the
> >>>>>>>> current VDUSE API or we can re-visit to go with descriptors rela=
ying
> >>>>>>>> first.
> >>>>>>>>
> >>>>>>> Actually all vdpa related operations are synchronous in current
> >>>>>>> implementation. The ops.set_map/dma_map/dma_unmap should not retu=
rn
> >>>>>>> until the VDUSE_UPDATE_IOTLB/VDUSE_INVALIDATE_IOTLB message is re=
plied
> >>>>>>> by userspace. Could it solve this problem?
> >>>>>>     I was thinking whether or not we need to generate IOTLB_INVALI=
DATE
> >>>>>> message to VDUSE during dma_unmap (vduse_dev_unmap_page).
> >>>>>>
> >>>>>> If we don't, we're probably fine.
> >>>>>>
> >>>>> It seems not feasible. This message will be also used in the
> >>>>> virtio-vdpa case to notify userspace to unmap some pages during
> >>>>> consistent dma unmapping. Maybe we can document it to make sure the
> >>>>> users can handle the message correctly.
> >>>> Just to make sure I understand your point.
> >>>>
> >>>> Do you mean you plan to notify the unmap of 1) streaming DMA or 2)
> >>>> coherent DMA?
> >>>>
> >>>> For 1) you probably need a workqueue to do that since dma unmap can
> >>>> be done in irq or bh context. And if usrspace does't do the unmap, i=
t
> >>>> can still access the bounce buffer (if you don't zap pte)?
> >>>>
> >>> I plan to do it in the coherent DMA case.
> >>
> >> Any reason for treating coherent DMA differently?
> >>
> > Now the memory of the bounce buffer is allocated page by page in the
> > page fault handler. So it can't be used in coherent DMA mapping case
> > which needs some memory with contiguous virtual addresses. I can use
> > vmalloc() to do allocation for the bounce buffer instead. But it might
> > cause some memory waste. Any suggestion?
>
>
> I may miss something. But I don't see a relationship between the
> IOTLB_UNMAP and vmalloc().
>

In the vmalloc() case, the coherent DMA page will be taken from the
memory allocated by vmalloc(). So IOTLB_UNMAP is not needed anymore
during coherent DMA unmapping because those vmalloc'ed memory which
has been mapped into userspace address space during initialization can
be reused. And userspace should not unmap the region until we destroy
the device.

>
> >
> >>> It's true that userspace can
> >>> access the dma buffer if userspace doesn't do the unmap. But the dma
> >>> pages would not be freed and reused unless user space called munmap()
> >>> for them.
> >>
> >> I wonder whether or not we could recycle IOVA in this case to avoid th=
e
> >> IOTLB_UMAP message.
> >>
> > We can achieve that if we use vmalloc() to do allocation for the
> > bounce buffer which can be used in coherent DMA mapping case. But
> > looks like we still have no way to avoid the IOTLB_UMAP message in
> > vhost-vdpa case.
>
>
> I think that's fine. For virtio-vdpa, from VDUSE userspace perspective,
> it works like a driver that is using SWIOTLB in this case.
>

OK, will do it in v3.

Thanks,
Yongji
