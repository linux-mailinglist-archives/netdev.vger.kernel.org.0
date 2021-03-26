Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7146834A237
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 07:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhCZG4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 02:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhCZG4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 02:56:20 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE0DC0613AA
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 23:56:17 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id l18so5080165edc.9
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 23:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PQypIBjUimiCDVu5dvIjV1qLemMlr0debSxZW75gths=;
        b=r5Ga8+UedSB+p0J/ID7lgruod9NuIbmZYp4duaHkeV+6eGe3KTIBnBr/jUol6MK2xT
         KigRHuLHX4UnrFmjSEkWk30i5s9ySzMlZZpPQ8e+Xl60EuTjkPa4pn23LBvKHhOaWSd4
         ylVF2D9BNswpzd12vlataSJrOoKQxccgyy+5CwCCp6nHKKBTJIyFd3z3o0B0DjwBwCh+
         BSzRyheU2Hdb5mZBGJXAkTce196LeaVm1tw2uwYX/3mHkbnA2xD8woqTfXFT68zWYagU
         JDejzGcDAmUQstHf1XH88WvM/9oi8+CJjN8H6E5xGINYmMzcApiuJNEme9a2ng/xEdsJ
         Usqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PQypIBjUimiCDVu5dvIjV1qLemMlr0debSxZW75gths=;
        b=kFpkyqgQDyL7W/FFrG90kn5KAlJDS9ZMbQXSntOwkuCz1hEC81/B44RKs3nRoVR2Lt
         9wAJs9PXrY+w2OEDB9c4UOtblN2NrmzagtjnHs5zQGdlV1+cU90CxKikWBnLDBTjbOZY
         VmOuDPAAMZ910jJjRRD1NVDO2a+st5MqZsIZCK2yIHTLUw7miNXLkckMy3DXJfE7/BUR
         oef/kFPM96ZfO2VhFCmPUdIQG/RcFf7zv8dE5Mnjf830sS36Ylo1VSIiTiMASTLKwx9i
         X+runjbo9lpM4GVjxUHR6vc71xQfpD125jtVt2rLTrzvYMb77DDgQnGMhhk1ijdLhm4l
         c1Tw==
X-Gm-Message-State: AOAM531he9zXabT8rbNr+4n3Je5TSIaxvBq2H+0VWsTS+WfH/rFjbj+/
        wAdTDoMD5CMMp0Ictu5zAPmyOLSIntn4ygYdsrar
X-Google-Smtp-Source: ABdhPJwVqduG89yOSPZPZH6FO21xukl+7m/AtoIDrk4nR7UoWmIwrzX1T2oEszw1L5x8crslqmePwiOetelHUMIsq14=
X-Received: by 2002:a05:6402:168c:: with SMTP id a12mr13336426edv.344.1616741776081;
 Thu, 25 Mar 2021 23:56:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210315053721.189-1-xieyongji@bytedance.com> <20210315053721.189-9-xieyongji@bytedance.com>
 <ec5b4146-9844-11b0-c9b0-c657d3328dd4@redhat.com> <CACycT3v_-G6ju-poofXEzYt8QPKWNFHwsS7t=KTLgs-=g+iPQQ@mail.gmail.com>
 <7c90754b-681d-f3bf-514c-756abfcf3d23@redhat.com> <CACycT3uS870yy04rw7KBk==sioi+VNunxVz6BQH-Lmxk6m-VSg@mail.gmail.com>
 <2db71996-037e-494d-6ef0-de3ff164d3c3@redhat.com> <CACycT3v6Lj61fafztOuzBNFLs2TbKeqrNLXkzv5RK6-h-iTnvA@mail.gmail.com>
 <75e3b941-dfd2-ebbc-d752-8f25c1f14cab@redhat.com>
In-Reply-To: <75e3b941-dfd2-ebbc-d752-8f25c1f14cab@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 26 Mar 2021 14:56:05 +0800
Message-ID: <CACycT3t+2MC9rQ7iWdWQ4=O3ojCXHvHZ-M7y7AjXoXYZUiAOzQ@mail.gmail.com>
Subject: Re: Re: [PATCH v5 08/11] vduse: Implement an MMU-based IOMMU driver
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
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

On Fri, Mar 26, 2021 at 2:16 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/3/26 =E4=B8=8B=E5=8D=881:14, Yongji Xie =E5=86=99=E9=81=93=
:
>
> +     }
> +     map->bounce_page =3D page;
> +
> +     /* paired with vduse_domain_map_page() */
> +     smp_mb();
>
> So this is suspicious. It's better to explain like, we need make sure A
> must be done after B.
>
> OK. I see. It's used to protect this pattern:
>
>      vduse_domain_alloc_bounce_page:          vduse_domain_map_page:
>      write map->bounce_page                           write map->orig_phy=
s
>      mb()                                                            mb()
>      read map->orig_phys                                 read map->bounce=
_page
>
> Make sure there will always be a path to do bouncing.
>
> Ok.
>
>
> And it looks to me the iotlb_lock is sufficnet to do the synchronization
> here. E.g any reason that you don't take it in
> vduse_domain_map_bounce_page().
>
> Yes, we can. But the performance in multi-queue cases will go down if
> we use iotlb_lock on this critical path.
>
> And what's more, is there anyway to aovid holding the spinlock during
> bouncing?
>
> Looks like we can't. In the case that multiple page faults happen on
> the same page, we should make sure the bouncing is done before any
> page fault handler returns.
>
> So it looks to me all those extra complexitiy comes from the fact that
> the bounce_page and orig_phys are set by different places so we need to
> do the bouncing in two places.
>
> I wonder how much we can gain from the "lazy" boucning in page fault.
> The buffer mapped via dma_ops from virtio driver is expected to be
> accessed by the userspace soon.  It looks to me we can do all those
> stuffs during dma_map() then things would be greatly simplified.
>
> If so, we need to allocate lots of pages from the pool reserved for
> atomic memory allocation requests.
>
> This should be fine, a lot of drivers tries to allocate pages in atomic
> context. The point is to simplify the codes to make it easy to
> determince the correctness so we can add optimization on top simply by
> benchmarking the difference.
>
> OK. I will use this way in the next version.
>
> E.g we have serveral places that accesses orig_phys:
>
> 1) map_page(), write
> 2) unmap_page(), write
> 3) page fault handler, read
>
> It's not clear to me how they were synchronized. Or if it was
> synchronzied implicitly (via iova allocator?), we'd better document it.
>
> Yes.
>
> Or simply use spinlock (which is the preferrable way I'd like to go). We
> probably don't need to worry too much about the cost of spinlock since
> iova allocater use it heavily.
>
> Actually iova allocator implements a per-CPU cache to optimize it.
>
> Thanks,
> Yongji
>
>
> Right, but have a quick glance, I guess what you meant is that usually th=
ere's no lock contention unless cpu hot-plug. This can work but the problem=
 is that such synchornization depends on the internal implementation of IOV=
A allocator which is kind of fragile. I still think we should do that on ou=
r own.
>

I might miss something. Looks like we don't need any synchronization
if the page fault handler is removed as you suggested. We should not
access the same orig_phys concurrently (in map_page() and
unmap_page()) unless we free the iova before accessing.

Thanks,
Yongji
