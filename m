Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10C14C63CA
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 08:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233626AbiB1H3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 02:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiB1H3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 02:29:49 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5855B0F
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:29:10 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2d310db3812so97430667b3.3
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iEbYeIM+ArxLGrLUe33Qse2UoB8fQ/8BjtAibrA6p9w=;
        b=IoUHA/EBARBOTbzUIzbFoW6ZGSIpzMFLQb7dGuohEcepjAk6m2sIccTaeE7hqPN/BT
         +7xiJncNm+mpDn7QJhKnl+PEK6zKq5ixCl26cIc6I/n3EmwZy46dNS5WGO0bbXAgAk2f
         /hH0SDm80Uhwakxi+MkNJMzcEY8G9PgjT+oKLDQuU06N6MSmz9FlLLlotiI40W/Ru1SV
         xogEa1DcUiwJavDCEWzFnDiKNneYVr4v0kkx1a26q/Vvn7J8g0/XOjYsd3W5uSaQDlL3
         vwH+wxDrQ+ue5exrf8BrqgwmFdP12uRwuJGm/fqDnhWGW6dPmw5YCOo07cYhydi4BGlA
         qyyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iEbYeIM+ArxLGrLUe33Qse2UoB8fQ/8BjtAibrA6p9w=;
        b=M7J/1p73zZZMzMQUdaf2fCG7iEmgOZujwJ8byeAhCaz+YEpj5qeBLUDfvddMsKk/Hz
         DlUmwu10UCbWWrfWLZhJY1kzSQtsNxMVUWIX/snJ7fpypo6JCnexD/kE1TeSOv9lvjp5
         c+I0s4ezpu7L0GWtz6YygYC6I5H/fgyf14nK6cAv8n/nPFeZLIl2tVHCPyb3p353peMS
         o2KtQfikqvb+a9q5z8fXudPf7T7/q8y36HwMhZEUZnTFMnmwq4rg8uyeB/Nijanq2H74
         AcMhYWoMJY9Xe8SzfbTkmV36sAZP4mARS27e298CHuruTkbfW8bxOuqENibsz7FrKFIS
         kIbQ==
X-Gm-Message-State: AOAM531tvtSkLUBfy5NQ629O8nmu9Ogk1wMsiachkNzZAYnvrPsTzkuc
        C+PWFLCZAVFv0eLx0+SHlPj/Efe548Md4cmaZlxbbA==
X-Google-Smtp-Source: ABdhPJwdE9Tgpet1D3MzzBA3SyQZpi/kAgCtRWQfovtM/qY/N9k5nsPSDZ0/JgvYYsyqnfXngU331Y9qwyZS8wmRyQs=
X-Received: by 2002:a0d:fa01:0:b0:2d6:595d:81d4 with SMTP id
 k1-20020a0dfa01000000b002d6595d81d4mr19236682ywf.86.1646033350105; Sun, 27
 Feb 2022 23:29:10 -0800 (PST)
MIME-Version: 1.0
References: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
 <1645810914-35485-2-git-send-email-jdamato@fastly.com> <8bcd9a94-6fb9-15ab-5a91-0b9d71cfa688@redhat.com>
In-Reply-To: <8bcd9a94-6fb9-15ab-5a91-0b9d71cfa688@redhat.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Mon, 28 Feb 2022 09:28:33 +0200
Message-ID: <CAC_iWjKnHt+PFsxxSXvWskHsVqB=bSzjfADdpbuviCgdz5BmOw@mail.gmail.com>
Subject: Re: [net-next v7 1/4] page_pool: Add allocation stats
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 at 09:07, Jesper Dangaard Brouer <jbrouer@redhat.com> wrote:
>
>
> On 25/02/2022 18.41, Joe Damato wrote:
> > Add per-pool statistics counters for the allocation path of a page pool.
> > These stats are incremented in softirq context, so no locking or per-cpu
> > variables are needed.
> >
> > This code is disabled by default and a kernel config option is provided for
> > users who wish to enable them.
> >
> > The statistics added are:
> >       - fast: successful fast path allocations
> >       - slow: slow path order-0 allocations
> >       - slow_high_order: slow path high order allocations
> >       - empty: ptr ring is empty, so a slow path allocation was forced.
> >       - refill: an allocation which triggered a refill of the cache
> >       - waive: pages obtained from the ptr ring that cannot be added to
> >         the cache due to a NUMA mismatch.
> >
> > Signed-off-by: Joe Damato<jdamato@fastly.com>
> > ---
> >   include/net/page_pool.h | 18 ++++++++++++++++++
> >   net/Kconfig             | 13 +++++++++++++
> >   net/core/page_pool.c    | 24 ++++++++++++++++++++----
> >   3 files changed, 51 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index 97c3c19..1f27e8a4 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -84,6 +84,19 @@ struct page_pool_params {
> >       void *init_arg;
> >   };
> >
> > +#ifdef CONFIG_PAGE_POOL_STATS
> > +struct page_pool_alloc_stats {
> > +     u64 fast; /* fast path allocations */
> > +     u64 slow; /* slow-path order 0 allocations */
> > +     u64 slow_high_order; /* slow-path high order allocations */
> > +     u64 empty; /* failed refills due to empty ptr ring, forcing
> > +                 * slow path allocation
> > +                 */
> > +     u64 refill; /* allocations via successful refill */
> > +     u64 waive;  /* failed refills due to numa zone mismatch */
> > +};
> > +#endif
> > +
> >   struct page_pool {
> >       struct page_pool_params p;
> >
> > @@ -96,6 +109,11 @@ struct page_pool {
> >       unsigned int frag_offset;
> >       struct page *frag_page;
> >       long frag_users;
> > +
> > +#ifdef CONFIG_PAGE_POOL_STATS
> > +     /* these stats are incremented while in softirq context */
> > +     struct page_pool_alloc_stats alloc_stats;
> > +#endif
> >       u32 xdp_mem_id;
>
> I like the cache-line placement.
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
