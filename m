Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30F2361821
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 05:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238017AbhDPDTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 23:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237946AbhDPDTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 23:19:08 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26522C061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 20:18:44 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id bx20so29378657edb.12
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 20:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kMTBdobnGznBBjnb2LvClwNVHlGnVjDgSIWsFFu28yQ=;
        b=WAjonFB722TREXzLfTCVhuvydXMMb85vgvrJHt4UkT0QGIDnERyv0eD8T+xRkrYAGW
         q4VuqKaN5S+bSTYCdl8T8QdrRmK1bMEEik5DKZ/HFNybU71CR5OHeP2hYTLqXHYsfcSu
         q01eK6lTpjZhuJ/Y5C8gov5eUizu2B2BKskMdAiRFc21xNsIYFyWOQv7EIxXusT2yRan
         qAz22yuj0S9nYmscZ+4HCd/nUoplfav0/D+6z2JmDcaxOyENGSANqX0TwffPqrbZWCnl
         eeSwznyLZPi1ECB0Mr024s1CVmENVeReQNF9OfXB/DljplAJ7Samqs1/kMwEDf+rbBxV
         Mhbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kMTBdobnGznBBjnb2LvClwNVHlGnVjDgSIWsFFu28yQ=;
        b=AAu6RBV0eHKRw8SX0Bq/b5o9oV/tLwi16Fe3KKXUgZleWYYQS5gGNDexzGFJIgW86q
         FsR9nwnhF7YBGbymzj/Z1u7hfs139YSvJ4rqdUu35ZK3zsA/JjIzhMAuOS7UqHpGtMi8
         LkwPeZpDikk1lZHZQOzETKxi7GJVCeF2lxD22Fgnpbd2hhBbVVH4p/d1FvkyG2Z4f78d
         +dLBYWeZxFUnYgU2H0v8/pa28tnItdSqotUnD+CIkjuij2m9MYXJNdLr80Hs1yme8XK6
         Uvs1LVBWmRE6YpO3KoCefheJzmteFZT2jOynPmyX41dbXhhUODKOq21l11sARBbL9o01
         axKA==
X-Gm-Message-State: AOAM5335BKhWwaIKOBYN3sYlZFLwIrS58gW811LVvvTkcDdMuHAVhRiH
        nViLj1oPLdiadZkRwZS4EnxJ0vr8uki+OsjyA44J
X-Google-Smtp-Source: ABdhPJyviPh03fP+ytnlIi41MB3JRSgflnL3vDluYza5gRZWSuTQgTp+hVgiqOl0vpvzVHR4IUyd6XiaPa1t0Jfsf70=
X-Received: by 2002:a05:6402:4d1:: with SMTP id n17mr7522310edw.118.1618543121371;
 Thu, 15 Apr 2021 20:18:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210331080519.172-11-xieyongji@bytedance.com>
 <YHb44R4HyLEUVSTF@stefanha-x1.localdomain> <CACycT3uNR+nZY5gY0UhPkeOyi7Za6XkX4b=hasuDcgqdc7fqfg@mail.gmail.com>
 <YHfo8pc7dIO9lNc3@stefanha-x1.localdomain> <80b31814-9e41-3153-7efb-c0c2fab44feb@redhat.com>
 <02c19c22-13ea-ea97-d99b-71edfee0b703@redhat.com> <CACycT3tL7URz3n-KhMAwYH+Sn1e1TSyfU+RKcc8jpPDJ7WcZ2w@mail.gmail.com>
 <5beabeaf-52a6-7ee5-b666-f3616ea82811@redhat.com> <CACycT3tyksBYxgbQLFJ-mFCKkaWotucM5_ho_K3q4wMpR0P=gw@mail.gmail.com>
 <17e3312e-686b-c5dd-852d-e9ffb7f4c707@redhat.com>
In-Reply-To: <17e3312e-686b-c5dd-852d-e9ffb7f4c707@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 16 Apr 2021 11:18:30 +0800
Message-ID: <CACycT3vuDN0-niZ2yL3JhEW4fYZWEqYKe-tu7rQWpVEOytcDtw@mail.gmail.com>
Subject: Re: Re: [PATCH v6 10/10] Documentation: Add documentation for VDUSE
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 11:03 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/4/16 =E4=B8=8A=E5=8D=8810:58, Yongji Xie =E5=86=99=E9=81=
=93:
> > On Fri, Apr 16, 2021 at 10:20 AM Jason Wang <jasowang@redhat.com> wrote=
:
> >>
> >> =E5=9C=A8 2021/4/15 =E4=B8=8B=E5=8D=887:17, Yongji Xie =E5=86=99=E9=81=
=93:
> >>> On Thu, Apr 15, 2021 at 5:05 PM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>>> =E5=9C=A8 2021/4/15 =E4=B8=8B=E5=8D=884:36, Jason Wang =E5=86=99=E9=
=81=93:
> >>>>>> Please state this explicitly at the start of the document. Existin=
g
> >>>>>> interfaces like FUSE are designed to avoid trusting userspace.
> >>>>> There're some subtle difference here. VDUSE present a device to ker=
nel
> >>>>> which means IOMMU is probably the only thing to prevent a malicous
> >>>>> device.
> >>>>>
> >>>>>
> >>>>>> Therefore
> >>>>>> people might think the same is the case here. It's critical that p=
eople
> >>>>>> are aware of this before deploying VDUSE with virtio-vdpa.
> >>>>>>
> >>>>>> We should probably pause here and think about whether it's possibl=
e to
> >>>>>> avoid trusting userspace. Even if it takes some effort and costs s=
ome
> >>>>>> performance it would probably be worthwhile.
> >>>>> Since the bounce buffer is used the only attack surface is the
> >>>>> coherent area, if we want to enforce stronger isolation we need to =
use
> >>>>> shadow virtqueue (which is proposed in earlier version by me) in th=
is
> >>>>> case. But I'm not sure it's worth to do that.
> >>>>
> >>>> So this reminds me the discussion in the end of last year. We need t=
o
> >>>> make sure we don't suffer from the same issues for VDUSE at least
> >>>>
> >>>> https://yhbt.net/lore/all/c3629a27-3590-1d9f-211b-c0b7be152b32@redha=
t.com/T/#mc6b6e2343cbeffca68ca7a97e0f473aaa871c95b
> >>>>
> >>>> Or we can solve it at virtio level, e.g remember the dma address ins=
tead
> >>>> of depending on the addr in the descriptor ring
> >>>>
> >>> I might miss something. But VDUSE has recorded the dma address during
> >>> dma mapping, so we would not do bouncing if the addr/length is invali=
d
> >>> during dma unmapping. Is it enough?
> >>
> >> E.g malicous device write a buggy dma address in the descriptor ring, =
so
> >> we had:
> >>
> >> vring_unmap_one_split(desc->addr, desc->len)
> >>       dma_unmap_single()
> >>           vduse_dev_unmap_page()
> >>               vduse_domain_bounce()
> >>
> >> And in vduse_domain_bounce() we had:
> >>
> >>           while (size) {
> >>                   map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];
> >>                   offset =3D offset_in_page(iova);
> >>                   sz =3D min_t(size_t, PAGE_SIZE - offset, size);
> >>
> >> This means we trust the iova which is dangerous and exacly the issue
> >> mentioned in the above link.
> >>
> >>   From VDUSE level need to make sure iova is legal.
> >>
> > I think we already do that in vduse_domain_bounce():
> >
> >      while (size) {
> >          map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];
> >
> >          if (WARN_ON(!map->bounce_page ||
> >              map->orig_phys =3D=3D INVALID_PHYS_ADDR))
> >              return;
>
>
> So you don't check whether iova is legal before using it, so it's at
> least a possible out of bound access of the bounce_maps[] isn't it? (e.g
> what happens if iova is ULLONG_MAX).
>

Oh, yes. Will do it!

>
> >
> >
> >>   From virtio level, we should not truse desc->addr.
> >>
> > We would not touch desc->addr after vring_unmap_one_split(). So I'm
> > not sure what we need to do at the virtio level.
>
>
> I think the point is to record the dma addres/len somewhere instead of
> reading them from descriptor ring.
>

OK, I see.

Thanks,
Yongji
