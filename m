Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C91D6A60CB
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 21:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjB1U74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 15:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjB1U7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 15:59:54 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997B314E96
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 12:59:53 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-536cb25982eso308877397b3.13
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 12:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H15Wgrg45uphokJUqJE+ge3DLPSULLnvrd4PVO7cLLc=;
        b=fF7yR1zieU4gkviG5qrWrdfSWhtKPGGWlvtMBXv4KHBDu0aJ3gWsucs0SnY/VXu9xI
         98ilQKazhvCJdc/WBewUB+5SWcdhorii7J1pOeAzos6f/dQqHZdg02M4AtOUfeTq8eOO
         f09htTPMG/pkdx7lHQGqeX5kSZIxN5OkkPfc77FKJnyPHYn11vG35NdgnRPHPkAFKcea
         XgImIWOsGyc18s8CqlKSzyo64N6r/4hd/TI5CyRtFIgPb+s+gMlpDT8KVNO9m7c21yRW
         SoYMoaCOLdsdFi4o18FJKo606Yo0hMRNZOz6SykPjzCGVDwzVDiSukBxaNiAwswCzVE4
         k7xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H15Wgrg45uphokJUqJE+ge3DLPSULLnvrd4PVO7cLLc=;
        b=ci3tPe3MKQdpvi8/qEx2Gk3B7ETLMYIwcYlbhPVujusjGBsVy/w+xnKH4CDJIQ5Fc6
         IV913V8OMRZnBIs7z70/QnAgB+IGaCx3beH3prYoBS7pnsXYZfrjPBORYdTf9Xl0RnGr
         MFD68FHiaJSgn2RNHy/uLc51Uk/CoVG79iXDkcVResnNiPwrTzGvTHaPODv4RNEB7NVt
         O8Mxx02WBfQXrCweq2URUhrU295533A75oIoFmR1V5E3fLjQTXXdZ8UQAEJq+xnYjPYk
         XSeHq6u/anZdmvgeHpMX8459IYfR4RfPznNrXuTv3mXCB6ura9gIAW2VvtAFCE1q324m
         sdsQ==
X-Gm-Message-State: AO0yUKXgpXjGzNNXMpW34jzKOgh/wJwYJP0Dr5mGk3kBFIMcCp3YiE0H
        prHbIw7UhlVDNTZfREyVqiIyR9KUUsHooesJGnj+MA==
X-Google-Smtp-Source: AK7set+d6vs4ymgWzsVBho7zIKcb2AoIn1quNMhQ7GG855RnJ+2d+gNas87Vdn9aekeC5XgvBudues+ObsH6EIGw7ZY=
X-Received: by 2002:a5b:8b:0:b0:90d:af77:9ca6 with SMTP id b11-20020a5b008b000000b0090daf779ca6mr2178238ybp.7.1677617992660;
 Tue, 28 Feb 2023 12:59:52 -0800 (PST)
MIME-Version: 1.0
References: <Y8v+qVZ8OmodOCQ9@nvidia.com>
In-Reply-To: <Y8v+qVZ8OmodOCQ9@nvidia.com>
From:   "T.J. Mercier" <tjmercier@google.com>
Date:   Tue, 28 Feb 2023 12:59:41 -0800
Message-ID: <CABdmKX3kJZKsOQSi=4+RE8D3AF=-823B9WV11sC4WH67hjzqSQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF proposal]: Physr discussion
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     lsf-pc@lists.linuxfoundation.org, linux-mm@kvack.org,
        iommu@lists.linux.dev, linux-rdma@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 21, 2023 at 7:03 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> I would like to have a session at LSF to talk about Matthew's
> physr discussion starter:
>
>  https://lore.kernel.org/linux-mm/YdyKWeU0HTv8m7wD@casper.infradead.org/
>
> I have become interested in this with some immediacy because of
> IOMMUFD and this other discussion with Christoph:
>
>  https://lore.kernel.org/kvm/4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com/
>
> Which results in, more or less, we have no way to do P2P DMA
> operations without struct page - and from the RDMA side solving this
> well at the DMA API means advancing at least some part of the physr
> idea.
>
> So - my objective is to enable to DMA API to "DMA map" something that
> is not a scatterlist, may or may not contain struct pages, but can
> still contain P2P DMA data. From there I would move RDMA MR's to use
> this new API, modify DMABUF to export it, complete the above VFIO
> series, and finally, use all of this to add back P2P support to VFIO
> when working with IOMMUFD by allowing IOMMUFD to obtain a safe
> reference to the VFIO memory using DMABUF. From there we'd want to see
> pin_user_pages optimized, and that also will need some discussion how
> best to structure it.
>
> I also have several ideas on how something like physr can optimize the
> iommu driver ops when working with dma-iommu.c and IOMMUFD.
>
> I've been working on an implementation and hope to have something
> draft to show on the lists in a few weeks. It is pretty clear there
> are several interesting decisions to make that I think will benefit
> from a live discussion.
>
> Providing a kernel-wide alternative to scatterlist is something that
> has general interest across all the driver subsystems. I've started to
> view the general problem rather like xarray where the main focus is to
> create the appropriate abstraction and then go about transforming
> users to take advatange of the cleaner abstraction. scatterlist
> suffers here because it has an incredibly leaky API, a huge number of
> (often sketchy driver) users, and has historically been very difficult
> to improve.
>
> The session would quickly go over the current state of whatever the
> mailing list discussion evolves into and an open discussion around the
> different ideas.
>
> Thanks,
> Jason
>

Hi, I'm interested in participating in this discussion!
