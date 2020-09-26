Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4BC279A5A
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 17:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbgIZPZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 11:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIZPZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 11:25:46 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABECC0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 08:25:45 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id nw23so2596790ejb.4
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 08:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NyijGOIcOg0IQ8xJ7tRK9WXb8VbwFr7joS3ngRxTFtY=;
        b=IgNtiCGTIRw+9Jq9+OugAEUgOtWjA8eNb9N0lGKIZhSzq8+Nq6i8p6dAPgDSw3WCu5
         5zLCQcy1nGd484dN8MEuuVSYHqucVtHjEfU81Ws4/lYX/HOp4JbMrZzXbrOql6BtdQAy
         +hEnD/Pr6tT/viPh9YkxxEEc7eplb0NwJB92c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NyijGOIcOg0IQ8xJ7tRK9WXb8VbwFr7joS3ngRxTFtY=;
        b=Yu68ISbJD4bsmwNpeLpec2nDpoQ7EMFcoE8pL+HzXmZr1yQyvGhkhac5gwxfvdn2sN
         U0OWbdSOesU2ZFYwfE4bo64HRpD98uP/flpVX/Nw5NzZ+Fo1p9OVxyvVTOph4R0x8p7B
         vUatr75ZUHDuZqKeddPVA2ds9kNavmOhqbEGT5mZbJe3bY/Y04tkn9OMP1lxm5aASGua
         +6R2/f1F1tqqLUs0BnppEzr/r/pEzUnz2/9vFWMGAlTZYpUmi4Hhc9HFNeKqTc/sqEli
         2sWJPqod1oXgvZabwt6nuR49ksG5qhc10jGXNOk/WpXak8CwBRVuDmqh7jdDsn72Oo5k
         RtcA==
X-Gm-Message-State: AOAM533Vn/8gMYn7T9W1mpZzZa6VtZGPzdQZflLVbAtweUeLdTBXCefD
        za6bMTArHgT9v3HPYWv/RJrhdV+lkaIS8w==
X-Google-Smtp-Source: ABdhPJyhSvYrDdDDk3Z9CsZlRdpuUpKnsjFKfAMrIIyFeG1fPnHf1IghQgtPx8z9osZ5GpqlxKu9/A==
X-Received: by 2002:a17:906:874f:: with SMTP id hj15mr8220792ejb.539.1601133944396;
        Sat, 26 Sep 2020 08:25:44 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id y9sm4617979edo.37.2020.09.26.08.25.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2020 08:25:44 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id b79so2330294wmb.4
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 08:25:43 -0700 (PDT)
X-Received: by 2002:a7b:c925:: with SMTP id h5mr2968012wml.28.1601133943201;
 Sat, 26 Sep 2020 08:25:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200915155122.1768241-1-hch@lst.de> <20200915155122.1768241-18-hch@lst.de>
 <20200925184622.GB3607091@chromium.org> <20200926141428.GB10379@lst.de>
In-Reply-To: <20200926141428.GB10379@lst.de>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Sat, 26 Sep 2020 17:25:27 +0200
X-Gmail-Original-Message-ID: <CAAFQd5CjSKswdc3qOEZy73cyYJ9kfaXsSFyxkOHA+buh-J12UA@mail.gmail.com>
Message-ID: <CAAFQd5CjSKswdc3qOEZy73cyYJ9kfaXsSFyxkOHA+buh-J12UA@mail.gmail.com>
Subject: Re: [PATCH 17/18] dma-iommu: implement ->alloc_noncoherent
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <iommu@lists.linux-foundation.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 4:14 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Fri, Sep 25, 2020 at 06:46:22PM +0000, Tomasz Figa wrote:
> > > +static void *iommu_dma_alloc_noncoherent(struct device *dev, size_t size,
> > > +           dma_addr_t *handle, enum dma_data_direction dir, gfp_t gfp)
> > > +{
> > > +   if (!gfpflags_allow_blocking(gfp)) {
> > > +           struct page *page;
> > > +
> > > +           page = dma_common_alloc_pages(dev, size, handle, dir, gfp);
> > > +           if (!page)
> > > +                   return NULL;
> > > +           return page_address(page);
> > > +   }
> > > +
> > > +   return iommu_dma_alloc_remap(dev, size, handle, gfp | __GFP_ZERO,
> > > +                                PAGE_KERNEL, 0);
> >
> > iommu_dma_alloc_remap() makes use of the DMA_ATTR_ALLOC_SINGLE_PAGES attribute
> > to optimize the allocations for devices which don't care about how contiguous
> > the backing memory is. Do you think we could add an attrs argument to this
> > function and pass it there?
> >
> > As ARM is being moved to the common iommu-dma layer as well, we'll probably
> > make use of the argument to support the DMA_ATTR_NO_KERNEL_MAPPING attribute to
> > conserve the vmalloc area.
>
> We could probably at it.  However I wonder why this is something the
> drivers should care about.  Isn't this really something that should
> be a kernel-wide policy for a given system?

There are IOMMUs out there which support huge pages and those can
benefit *some* hardware depending on what kind of accesses they
perform, possibly on a per-buffer basis. At the same time, order > 0
allocations can be expensive, significantly affecting allocation
latency, so for devices which don't care about huge pages anyone would
prefer simple single-page allocations. Currently the drivers know the
best on whether the hardware they drive would care. There are some
decision factors listed in the documentation [1].

I can imagine cases where drivers could not be the best to decide
about this - for example, the workload could vary depending on the
userspace or a product decision regarding the performance vs
allocation latency, but we haven't seen such cases in practice yet.

[1] https://www.kernel.org/doc/html/latest/core-api/dma-attributes.html?highlight=dma_attr_alloc_single_pages#dma-attr-alloc-single-pages

Best regards,
Tomasz
