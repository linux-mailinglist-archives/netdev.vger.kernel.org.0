Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE663F74ED
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 14:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240602AbhHYMS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240649AbhHYMSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:18:55 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6B7C0613CF
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 05:18:09 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id s25so23934516edw.0
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 05:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tFbYUBxT5F02ETxWPNYnDT/IzVXwtvTQ/hB2M/j5I40=;
        b=S1Gv6G7NlFrvneSYqnBSOeyE66l/w2OvgLtQGyc2ete205Cc/K9titvobBEHOkV7Jd
         LF+IGAbQBYCZgtY/Oc+VQjeSILHfyY0qY86cKKFbFI9eKSjibGyEMQbH+ejgmKSjcgC5
         7Ky78pwYl3ckT1x+pt8+vBGkO34Qu9FkKuJyYOZHJxs8JFezX8A9akOzr4r+RFN6WG3I
         Ku/K/lCbctjWFcI5f456bKKJQs0YE9FPfHmoAitDy6E/v21XOApT6h0Cwzr8rwCnMRdX
         GH00tomNPmmrq5p2YIaWuULxkUShxdgVCD8W5xkwuXFKP/V/+9cDwXz5fK1Dz7KM8amN
         GWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tFbYUBxT5F02ETxWPNYnDT/IzVXwtvTQ/hB2M/j5I40=;
        b=dSdNVvM1cONefApq4wFbM2XLEbI31mBJzPX6zo0UhzFXHNgcVIj3aUtB2jGB30X0ms
         dXGC+h0WGejw1MJN9EV0oCropikJR02MPq9f1M2OEBT1EcuC74RHMicTESiQKNh3IUf1
         b8nqNleXnoyIKMEtnpKl1rdggtiD1G8+KLLaE2CsmHST2WRnSy4EhCUdK5hJqKjx16Ul
         /sgcy08pNTrIy/nABachqnLDoHIA6HSkWiiMxjPmNe4Cz4aMq3H1qvkocySG+Lir5+4z
         I0hCDo82b+cexuy5hCk6XqQZvPw21vn3n8/TqDgqqAzyPG/gYNQfOcRqbjIO18cRFyiU
         rqXg==
X-Gm-Message-State: AOAM5335hiGSQAurQNfzDtsgAK4Tsqt9W7JZdUWqQdeMprO8iEqx87De
        yInhwV6rf9cZL+A+Jm479MfC1Wb6owMLTGMRBtp9
X-Google-Smtp-Source: ABdhPJxiDpOcq8C+5T5VQdj2MSQ986LjNwq+2D/7Hfzk3BtSiet2580JVQtXlr3OiUAX1rd9+hgAp9kuHH1qjNotBK4=
X-Received: by 2002:a05:6402:705:: with SMTP id w5mr15141991edx.344.1629893888145;
 Wed, 25 Aug 2021 05:18:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210818120642.165-1-xieyongji@bytedance.com> <20210818120642.165-2-xieyongji@bytedance.com>
 <20210824140758-mutt-send-email-mst@kernel.org> <20210825095540.GA24546@willie-the-truck>
 <5f4eadda-5500-9bac-4368-48cfca6d0a4d@huawei.com>
In-Reply-To: <5f4eadda-5500-9bac-4368-48cfca6d0a4d@huawei.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 25 Aug 2021 20:17:57 +0800
Message-ID: <CACycT3uWyhNNK_YbfEAEhTk-V9CoxFg1tzVjJnXeKBFpkndnfg@mail.gmail.com>
Subject: Re: [PATCH v11 01/12] iova: Export alloc_iova_fast() and free_iova_fast()
To:     John Garry <john.garry@huawei.com>
Cc:     Will Deacon <will@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        songmuchun@bytedance.com, Jens Axboe <axboe@kernel.dk>,
        He Zhe <zhe.he@windriver.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, bcrl@kvack.org,
        netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        Robin Murphy <robin.murphy@arm.com>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 6:35 PM John Garry <john.garry@huawei.com> wrote:
>
> On 25/08/2021 10:55, Will Deacon wrote:
> > On Tue, Aug 24, 2021 at 02:08:33PM -0400, Michael S. Tsirkin wrote:
> >> On Wed, Aug 18, 2021 at 08:06:31PM +0800, Xie Yongji wrote:
> >>> Export alloc_iova_fast() and free_iova_fast() so that
> >>> some modules can make use of the per-CPU cache to get
> >>> rid of rbtree spinlock in alloc_iova() and free_iova()
> >>> during IOVA allocation.
> >>>
> >>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>
> >>
> >> This needs ack from iommu maintainers. Guys?
> >
> > Looks fine to me:
> >
> > Acked-by: Will Deacon <will@kernel.org>
> >
> > Will
> > _______________________________________________
> > iommu mailing list
> > iommu@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/iommu
> > .
> >
>
> JFYI, There was a preliminary discussion to move the iova rcache code
> (which the iova fast alloc and free functions are based on) out of the
> iova code and maybe into dma-iommu (being the only user). There was
> other motivation.
>

Would it be better to move the code into ./lib as a general library?

> https://lore.kernel.org/linux-iommu/83de3911-145d-77c8-17c1-981e4ff825d3@arm.com/
>
> Having more users complicates that...
>

Do we have some plan for this work? From our test [1],
iova_alloc_fast() is much better than iova_alloc(). So I'd like to use
it as much as possible

[1] https://lore.kernel.org/kvm/CACycT3steXFeg7NRbWpo2J59dpYcumzcvM2zcPJAVe40-EvvEg@mail.gmail.com/

Thanks,
Yongji
