Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD468357BD4
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 07:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbhDHF1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 01:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhDHF1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 01:27:50 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9E5C061762
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 22:27:39 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g17so76722edm.6
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 22:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XBsyg95HvfPCaEnZTpjOKu7MER6UdAU2kaoMscYQi8Y=;
        b=jYfsBh72CrskhMRxL/8IYLk38hnv+O5xRQIsaEaOfaaGv6MA8Js14HzL5sJZWiXhNL
         4vVpaQx4FKRolEe2JaiSI737LSOgjNz70Wvign3n/6dEKYvnmoPeu52M1I5KN3rVRfLG
         u59LSRgb//zUFWs2xHSFXUj1fBed9EJiD23RGbQPzNO7GCwrI4OzqIv3lwF2Ya3yiC5K
         9YkKazmFV9NsHEmi7KI74lApFXX+jGWDjYqn0qG2qumU3w1xUFkkVJ/sFXvkGbZInEuR
         +dN7BY7FKVBwQWkVQzQwf41tAO9mQAY3/9eMYlEMJTt86hRFkrs3jS+jvTfJ8IeS/IZI
         j7dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XBsyg95HvfPCaEnZTpjOKu7MER6UdAU2kaoMscYQi8Y=;
        b=Pum1oOqGjzfpMkMMAiKGT8O7DnMSmr24Xr2lC7mGeppocYTIq1ZMzKkeExrNlas4mX
         p0wPxLnabE4iTG5/j9NYqmTFHnK5Qc05M5EDby604PqZ32F5lfSPWytl4UmjnAfjm2JT
         XrS1oKEooFQnGPYrxr/WOFiotRqrWPMLw0rQyYCCaLNbB6pcaZpfNWgyHYMD7I3rc6Nx
         hbUDQ2DEfOXrnNN8tTcrHMP8INCpIC+HSCf/CwN/mjvtjkClsPCOzVwYqDOCT8IyxUp5
         4qEvX1gMXoncoxeGF4DwvAV8DNnTFKc6gNv3/l8g0XZEuzU2rsCHeuYEWXUDxNPljRSS
         tglg==
X-Gm-Message-State: AOAM532vE7EQ8g6efv9iEMYa0n/3sCZYxCryCjc5z0Ee6nhNz6R+I2v/
        dzDiWYLUyx9F1jYQ+smUG/Fob40t18LItIf10PFm
X-Google-Smtp-Source: ABdhPJw3cYEhtTY5BHRxiZkL1RHpeWMZaV4LAjqbpGDcn482YygWtNBA4BmOQyKwYeeY/hJkcq9H4uHf1KkDuCYwyek=
X-Received: by 2002:a05:6402:6ca:: with SMTP id n10mr8976690edy.312.1617859657831;
 Wed, 07 Apr 2021 22:27:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210331080519.172-9-xieyongji@bytedance.com>
 <30862242-293b-f42f-d8ce-2c31a52e3697@redhat.com>
In-Reply-To: <30862242-293b-f42f-d8ce-2c31a52e3697@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 8 Apr 2021 13:27:27 +0800
Message-ID: <CACycT3t+nAWtHDzWxWRvVdcinQdmTx-PL8Rk7yfBt2RXiQCn6Q@mail.gmail.com>
Subject: Re: Re: [PATCH v6 08/10] vduse: Implement an MMU-based IOMMU driver
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
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

On Thu, Apr 8, 2021 at 11:26 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/3/31 =E4=B8=8B=E5=8D=884:05, Xie Yongji =E5=86=99=E9=81=93=
:
> > This implements an MMU-based IOMMU driver to support mapping
> > kernel dma buffer into userspace. The basic idea behind it is
> > treating MMU (VA->PA) as IOMMU (IOVA->PA). The driver will set
> > up MMU mapping instead of IOMMU mapping for the DMA transfer so
> > that the userspace process is able to use its virtual address to
> > access the dma buffer in kernel.
> >
> > And to avoid security issue, a bounce-buffering mechanism is
> > introduced to prevent userspace accessing the original buffer
> > directly.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>
>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> With some nits:
>
>
> > ---
> >   drivers/vdpa/vdpa_user/iova_domain.c | 521 ++++++++++++++++++++++++++=
+++++++++
> >   drivers/vdpa/vdpa_user/iova_domain.h |  70 +++++
> >   2 files changed, 591 insertions(+)
> >   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
> >   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
>
>
> [...]
>
>
> > +static void vduse_domain_bounce(struct vduse_iova_domain *domain,
> > +                             dma_addr_t iova, size_t size,
> > +                             enum dma_data_direction dir)
> > +{
> > +     struct vduse_bounce_map *map;
> > +     unsigned int offset;
> > +     void *addr;
> > +     size_t sz;
> > +
> > +     while (size) {
> > +             map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];
> > +             offset =3D offset_in_page(iova);
> > +             sz =3D min_t(size_t, PAGE_SIZE - offset, size);
> > +
> > +             if (WARN_ON(!map->bounce_page ||
> > +                         map->orig_phys =3D=3D INVALID_PHYS_ADDR))
> > +                     return;
> > +
> > +             addr =3D page_address(map->bounce_page) + offset;
> > +             do_bounce(map->orig_phys + offset, addr, sz, dir);
> > +             size -=3D sz;
> > +             iova +=3D sz;
> > +     }
> > +}
> > +
> > +static struct page *
> > +vduse_domain_get_mapping_page(struct vduse_iova_domain *domain, u64 io=
va)
>
>
> It's better to rename this as "vduse_domain_get_coherent_page?".
>

OK.

>
> > +{
> > +     u64 start =3D iova & PAGE_MASK;
> > +     u64 last =3D start + PAGE_SIZE - 1;
> > +     struct vhost_iotlb_map *map;
> > +     struct page *page =3D NULL;
> > +
> > +     spin_lock(&domain->iotlb_lock);
> > +     map =3D vhost_iotlb_itree_first(domain->iotlb, start, last);
> > +     if (!map)
> > +             goto out;
> > +
> > +     page =3D pfn_to_page((map->addr + iova - map->start) >> PAGE_SHIF=
T);
> > +     get_page(page);
> > +out:
> > +     spin_unlock(&domain->iotlb_lock);
> > +
> > +     return page;
> > +}
> > +
>
>
> [...]
>
>
> > +
> > +static dma_addr_t
> > +vduse_domain_alloc_iova(struct iova_domain *iovad,
> > +                     unsigned long size, unsigned long limit)
> > +{
> > +     unsigned long shift =3D iova_shift(iovad);
> > +     unsigned long iova_len =3D iova_align(iovad, size) >> shift;
> > +     unsigned long iova_pfn;
> > +
> > +     if (iova_len < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
> > +             iova_len =3D roundup_pow_of_two(iova_len);
>
>
> Let's add a comment as what has been done in dma-iommu.c?
>

Fine.

> (In the future, it looks to me it's better to move them to
> alloc_iova_fast()).
>

Agree.

Thanks,
Yongji
