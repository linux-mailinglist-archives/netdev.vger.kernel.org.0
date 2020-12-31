Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7362E7EA7
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 09:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgLaIBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 03:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgLaIBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 03:01:31 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CBDC06179B
        for <netdev@vger.kernel.org>; Thu, 31 Dec 2020 00:00:51 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id g20so24622149ejb.1
        for <netdev@vger.kernel.org>; Thu, 31 Dec 2020 00:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4vZcplAIb41k4LaB6dKNbkRj1W5i0zw8fIZIC7vJy8k=;
        b=og+5JY4E3K4UPnN5TiFOOScjvaN/w5yE7Bg5E5Nk1ufD8N77pqk1f+zRfF9L1FVUkp
         hSBs8/203UT342aufzMtkzaIRltYNmRxuNHFXA6Ydd78Tm+ZTCQ8hseCdHG/H5raSS1j
         RsoMKMpG431hTuvucAo8IC7DYC1qQUyD9NfQDHp9kFHduTTsb65AIoIrSjzWbqgfHk32
         FhvjmZpgYZfv/B03Z2qSK4AG7nsUT99nKz3q8fjSbN05oc+Q7kexg+cejWKyV8PjggCA
         LWC2nofzjR51hoXhTpMqu95zJg9mOz5HjNL8obkBcR6NXOs3e+jtE1ejS1At3Am3N/6k
         5Z2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4vZcplAIb41k4LaB6dKNbkRj1W5i0zw8fIZIC7vJy8k=;
        b=VJEq6vprBY+duFmZcPVFSWC26UIGQNWTWdxTt/YyeNkFwk09wx2OutWCFEsv0bpfN4
         TiS39qfDb32rBA0yYutB6oyGRIQ1qLy4FqiNn+Tbkm3t0yLGEN6uNuBsDah4LOvbdl/a
         Tk8thQjkyDpLaf9U+/nxjHOAUZIUqgc2gUOUS+xwPvsxYdy+d3Erus9tAtDwm6+/dJH6
         5JesAEbmlWIIWAfV6dIknHzXSGOw8nvewWI9rpWEhfrNGLkRQIOrZXvgwgaANTc8iC7l
         cnVcS9fRrXl229rqRpLf45MnblvodvkYl1llrjvb7PI2Uo1Q5aBBvTql/gAc7eAJJs/d
         gixg==
X-Gm-Message-State: AOAM531QBZPzKLrgFSPSobEtbUVadi+uZJ3JgkIAlaYc5+jrH5+3UO/U
        fLr7IR1PKtZGqdxcpoXZTHGDOw0vl2Dsm2ZxMFNJ
X-Google-Smtp-Source: ABdhPJzUYyZKN/oWREBg8SGLRKnYI6sZMmeS65RWsW2GrEDgzsI9LiI+njvKlfqjdSPeAoYGVse9La7+ch/x1AsJ/IQ=
X-Received: by 2002:a17:906:edc8:: with SMTP id sb8mr52668753ejb.247.1609401648958;
 Thu, 31 Dec 2020 00:00:48 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <CACycT3uwXBYvRbKDWdN3oCekv+o6_Lc=-KTrxejD=fr-zgibGw@mail.gmail.com>
 <2b24398c-e6d9-14ec-2c0d-c303d528e377@redhat.com> <CACycT3uDV43ecScrMh1QVpStuwDETHykJzzY=pkmZjP2Dd2kvg@mail.gmail.com>
 <e77c97c5-6bdc-cdd0-62c0-6ff75f6dbdff@redhat.com> <CACycT3soQoX5avZiFBLEGBuJpdni6-UxdhAPGpWHBWVf+dEySg@mail.gmail.com>
 <1356137727.40748805.1609233068675.JavaMail.zimbra@redhat.com>
 <CACycT3sg61yRdupnD+jQEkWKsVEvMWfhkJ=5z_bYZLxCibDiHw@mail.gmail.com>
 <b1aef426-29c7-7244-5fc9-56d52e86abb4@redhat.com> <CACycT3vZ7V5WWhCFLBK6FuvVNmPmMj_yc=COOB4cjjC13yHUwg@mail.gmail.com>
 <3fc6a132-9fc2-c4e2-7fb1-b5a8bfb771fa@redhat.com> <CACycT3tD3zyvV6Zy5NT4x=02hBgrRGq35xeTsRXXx-_wPGJXpQ@mail.gmail.com>
 <e0e693c3-1871-a410-c3d5-964518ec939a@redhat.com> <CACycT3vwMU5R7N8dZFBYX4-bxe2YT7EfK_M_jEkH8wzfH_GkBw@mail.gmail.com>
 <0885385c-ae46-158d-eabf-433ef8ecf27f@redhat.com> <CACycT3tc2P63k6J9ZkWTpPvHk_H8zUq0_Q6WOqYX_dSigUAnzA@mail.gmail.com>
 <79741d5d-0c35-ad1c-951a-41d8ab3b36a0@redhat.com>
In-Reply-To: <79741d5d-0c35-ad1c-951a-41d8ab3b36a0@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 31 Dec 2020 16:00:38 +0800
Message-ID: <CACycT3td8uSZOANdteP89y5NFY6KbaNPdyen3QRX4UP2xKTWnA@mail.gmail.com>
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

On Thu, Dec 31, 2020 at 3:12 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/31 =E4=B8=8B=E5=8D=882:52, Yongji Xie wrote:
> > On Thu, Dec 31, 2020 at 1:50 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2020/12/31 =E4=B8=8B=E5=8D=881:15, Yongji Xie wrote:
> >>> On Thu, Dec 31, 2020 at 10:49 AM Jason Wang <jasowang@redhat.com> wro=
te:
> >>>> On 2020/12/30 =E4=B8=8B=E5=8D=886:12, Yongji Xie wrote:
> >>>>> On Wed, Dec 30, 2020 at 4:41 PM Jason Wang <jasowang@redhat.com> wr=
ote:
> >>>>>> On 2020/12/30 =E4=B8=8B=E5=8D=883:09, Yongji Xie wrote:
> >>>>>>> On Wed, Dec 30, 2020 at 2:11 PM Jason Wang <jasowang@redhat.com> =
wrote:
> >>>>>>>> On 2020/12/29 =E4=B8=8B=E5=8D=886:26, Yongji Xie wrote:
> >>>>>>>>> On Tue, Dec 29, 2020 at 5:11 PM Jason Wang <jasowang@redhat.com=
> wrote:
> >>>>>>>>>> ----- Original Message -----
> >>>>>>>>>>> On Mon, Dec 28, 2020 at 4:43 PM Jason Wang <jasowang@redhat.c=
om> wrote:
> >>>>>>>>>>>> On 2020/12/28 =E4=B8=8B=E5=8D=884:14, Yongji Xie wrote:
> >>>>>>>>>>>>>> I see. So all the above two questions are because VHOST_IO=
TLB_INVALIDATE
> >>>>>>>>>>>>>> is expected to be synchronous. This need to be solved by t=
weaking the
> >>>>>>>>>>>>>> current VDUSE API or we can re-visit to go with descriptor=
s relaying
> >>>>>>>>>>>>>> first.
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>> Actually all vdpa related operations are synchronous in cur=
rent
> >>>>>>>>>>>>> implementation. The ops.set_map/dma_map/dma_unmap should no=
t return
> >>>>>>>>>>>>> until the VDUSE_UPDATE_IOTLB/VDUSE_INVALIDATE_IOTLB message=
 is replied
> >>>>>>>>>>>>> by userspace. Could it solve this problem?
> >>>>>>>>>>>>        I was thinking whether or not we need to generate IOT=
LB_INVALIDATE
> >>>>>>>>>>>> message to VDUSE during dma_unmap (vduse_dev_unmap_page).
> >>>>>>>>>>>>
> >>>>>>>>>>>> If we don't, we're probably fine.
> >>>>>>>>>>>>
> >>>>>>>>>>> It seems not feasible. This message will be also used in the
> >>>>>>>>>>> virtio-vdpa case to notify userspace to unmap some pages duri=
ng
> >>>>>>>>>>> consistent dma unmapping. Maybe we can document it to make su=
re the
> >>>>>>>>>>> users can handle the message correctly.
> >>>>>>>>>> Just to make sure I understand your point.
> >>>>>>>>>>
> >>>>>>>>>> Do you mean you plan to notify the unmap of 1) streaming DMA o=
r 2)
> >>>>>>>>>> coherent DMA?
> >>>>>>>>>>
> >>>>>>>>>> For 1) you probably need a workqueue to do that since dma unma=
p can
> >>>>>>>>>> be done in irq or bh context. And if usrspace does't do the un=
map, it
> >>>>>>>>>> can still access the bounce buffer (if you don't zap pte)?
> >>>>>>>>>>
> >>>>>>>>> I plan to do it in the coherent DMA case.
> >>>>>>>> Any reason for treating coherent DMA differently?
> >>>>>>>>
> >>>>>>> Now the memory of the bounce buffer is allocated page by page in =
the
> >>>>>>> page fault handler. So it can't be used in coherent DMA mapping c=
ase
> >>>>>>> which needs some memory with contiguous virtual addresses. I can =
use
> >>>>>>> vmalloc() to do allocation for the bounce buffer instead. But it =
might
> >>>>>>> cause some memory waste. Any suggestion?
> >>>>>> I may miss something. But I don't see a relationship between the
> >>>>>> IOTLB_UNMAP and vmalloc().
> >>>>>>
> >>>>> In the vmalloc() case, the coherent DMA page will be taken from the
> >>>>> memory allocated by vmalloc(). So IOTLB_UNMAP is not needed anymore
> >>>>> during coherent DMA unmapping because those vmalloc'ed memory which
> >>>>> has been mapped into userspace address space during initialization =
can
> >>>>> be reused. And userspace should not unmap the region until we destr=
oy
> >>>>> the device.
> >>>> Just to make sure I understand. My understanding is that IOTLB_UNMAP=
 is
> >>>> only needed when there's a change the mapping from IOVA to page.
> >>>>
> >>> Yes, that's true.
> >>>
> >>>> So if we stick to the mapping, e.g during dma_unmap, we just put IOV=
A to
> >>>> free list to be used by the next IOVA allocating. IOTLB_UNMAP could =
be
> >>>> avoided.
> >>>>
> >>>> So we are not limited by how the pages are actually allocated?
> >>>>
> >>> In coherent DMA cases, we need to return some memory with contiguous
> >>> kernel virtual addresses. That is the reason why we need vmalloc()
> >>> here. If we allocate the memory page by page, the corresponding kerne=
l
> >>> virtual addresses in a contiguous IOVA range might not be contiguous.
> >>
> >> Yes, but we can do that as what has been done in the series
> >> (alloc_pages_exact()). Or do you mean it would be a little bit hard to
> >> recycle IOVA/pages here?
> >>
> > Yes, it might be hard to reuse the memory. For example, we firstly
> > allocate 1 IOVA/page during dma_map, then the IOVA is freed during
> > dma_unmap. Actually we can't reuse this single page if we need a
> > two-pages area in the next IOVA allocating. So the best way is using
> > IOTLB_UNMAP to free this single page during dma_unmap too.
> >
> > Thanks,
> > Yongji
>
>
> I get you now. Then I agree that let's go with IOTLB_UNMAP.
>

Fine, will do it.

Thanks,
Yongji
