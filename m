Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4B067D0DC
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjAZQFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjAZQF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:05:29 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74272E825
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:05:27 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id rl14so6381295ejb.2
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4R9VU7bgL5VkiFaNTYPtp+i7Hh4kaXEyBrwYrOQBvfc=;
        b=ol3iP/xq8sEzOSy+Z1cXt6oIE9M1M59gr96RAckN1R3bx79eetaxqKNT6lqmLxR9M8
         04UdMFUrwpASv7HA+VENgH2+u2RPraMHswI4CBDMLHhBIhBJK6pLIMWewgwz4Lual96E
         A9aOJgwzjiZiTPZ9VGEBnVcsG8ipj2Uky3b+xbVYgZItSCkDrkrm5aOuMMyTT/NaSaKw
         ffpYMr/qZGrVnC9gEC3XrArgqlnLWtvbQUwrl6TO7f40q2jSnRcfYtGp/zbDkgyRX6Lo
         aIAvdDOd2YReEwwfwZhJTUNML8oJdJDBJ9t/BtP5dRjQf+9uTVTuuVey/VTXenHAfg1D
         RDhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4R9VU7bgL5VkiFaNTYPtp+i7Hh4kaXEyBrwYrOQBvfc=;
        b=hGLwQY6BK4wLAhFvVCsUtcoecwqzy/bkJT0FNDEI/Tk/Xmzzwc1lIjfx/ewvpV0IPq
         Yx/ckUNTIjoZOzkpUaWIK+uMHvFZ/SAR/lIqlryqmtvksLi64K0oMMVCNTpy8pTqHL9z
         ICAeqs0gIuSwd4Q8NPb2x2UYnwDYaIURpv9qqeHx5LmEqgYNZNQNqetLaEQOMWjTVcVa
         ocoB+w+7jM+YtDenwRrHuQbilLbTUAyRot88CO4AMZxy40viXbV7KTQzL0zNK6pnqBd1
         LSmJSqp5hawXNBY2JwHsrYgvYZ3ZjEVu73vOGzUP7SBJeNnqGYOQPgYGtxPltxfOWc0p
         N0cw==
X-Gm-Message-State: AO0yUKXOEslip62SmJnAUrqj2YvpWpQTb9nJ+YhUHCiC01lRAOHR3dN+
        1Iyl98KUKRSBZQiWsAMnLJ9iJ8skSKgFCTBe
X-Google-Smtp-Source: AK7set9vT3e8xRrM8+HlTJnRfef9PkTmEpxaDgupkI1udw/5Y94RvjgPnTZMRq/8IaIAD9XfN6P1Og==
X-Received: by 2002:a17:906:840f:b0:878:6675:d07c with SMTP id n15-20020a170906840f00b008786675d07cmr2335544ejx.37.1674749126317;
        Thu, 26 Jan 2023 08:05:26 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id t18-20020a1709063e5200b007e0e2e35205sm786866eji.143.2023.01.26.08.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 08:05:25 -0800 (PST)
Date:   Thu, 26 Jan 2023 18:05:18 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented
 allocation
Message-ID: <Y9Kkvp8qwgbp3w1C@hera>
References: <20230124124300.94886-1-nbd@nbd.name>
 <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
 <f3d079ce930895475f307de3fdaed0b85b4f2671.camel@gmail.com>
 <Y9JWniFQmcc7m5Ey@hera>
 <CAKgT0UcSD5N7A4Bu1V3ue_+RVfiMqN+e8TQwn0FtAL_sXE3bkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UcSD5N7A4Bu1V3ue_+RVfiMqN+e8TQwn0FtAL_sXE3bkA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 07:41:15AM -0800, Alexander Duyck wrote:
> On Thu, Jan 26, 2023 at 2:32 AM Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
> >
> > Hi Alexander,
> >
> > Sorry for being late to the party,  was overloaded...
> >
> > On Tue, Jan 24, 2023 at 07:57:35AM -0800, Alexander H Duyck wrote:
> > > On Tue, 2023-01-24 at 16:11 +0200, Ilias Apalodimas wrote:
> > > > Hi Felix,
> > > >
> > > > ++cc Alexander and Yunsheng.
> > > >
> > > > Thanks for the report
> > > >
> > > > On Tue, 24 Jan 2023 at 14:43, Felix Fietkau <nbd@nbd.name> wrote:
> > > > >
> > > > > While testing fragmented page_pool allocation in the mt76 driver, I was able
> > > > > to reliably trigger page refcount underflow issues, which did not occur with
> > > > > full-page page_pool allocation.
> > > > > It appears to me, that handling refcounting in two separate counters
> > > > > (page->pp_frag_count and page refcount) is racy when page refcount gets
> > > > > incremented by code dealing with skb fragments directly, and
> > > > > page_pool_return_skb_page is called multiple times for the same fragment.
> > > > >
> > > > > Dropping page->pp_frag_count and relying entirely on the page refcount makes
> > > > > these underflow issues and crashes go away.
> > > > >
> > > >
> > > > This has been discussed here [1].  TL;DR changing this to page
> > > > refcount might blow up in other colorful ways.  Can we look closer and
> > > > figure out why the underflow happens?
> > > >
> > > > [1] https://lore.kernel.org/netdev/1625903002-31619-4-git-send-email-linyunsheng@huawei.com/
> > > >
> > > > Thanks
> > > > /Ilias
> > > >
> > > >
> > >
> > > The logic should be safe in terms of the page pool itself as it should
> > > be holding one reference to the page while the pp_frag_count is non-
> > > zero. That one reference is what keeps the two halfs in sync as the
> > > page shouldn't be able to be freed until we exhaust the pp_frag_count.
> >
> > Do you remember why we decided to go with the fragment counter instead of
> > page references?
>
> The issue has to do with when to destroy the mappings. Basically with
> the fragment counter we destroy the mappings and remove the page from
> the pool when the count hits 0. The reference count is really used for
> the page allocator to do its tracking. If we end up trying to merge
> the two the problem becomes one of lifetimes as we wouldn't know when
> to destroy the DMA mappings as they would have to live the full life
> of the page.

Ah yes thanks! We need that on a comment somewhere,  I keep forgetting...
Basically the pp_frag_count is our number of outstanding dma mappings.

>
> > >
> > > To have an underflow there are two possible scenarios. One is that
> > > either put_page or free_page is being called somewhere that the
> > > page_pool freeing functions should be used.
> >
> > Wouldn't that affect the non fragmented path as well? IOW the driver that
> > works with a full page would crash as well.
>
> The problem is the non-fragmented path doesn't get as noisy. Also
> there aren't currently any wireless drivers making use of the page
> pool, or at least that is my understanding. I'm suspecting something
> like the issue we saw in 1effe8ca4e34c ("skbuff: fix coalescing for
> page_pool fragment recycling"). We likely have some corner case where
> we should be taking a page reference and clearing a pp_recycle flag.

Yea, same thinking here. I'll have another closer look tomorrow, but
looking at the wireless internals what happens is
1. They alloc a fragment
2. They create a new SKB, without the recycle bit and refer to the existing
fragments.  Since the recyle bit is off *that* skb will never try to
decrease the frag counter.  Instead it bumps the page refcnt which should be
properly decremented one that SKB is freed. I guess somehow an SKB ends up with
the recycle bit set, when it shouldn't.

Regards
/Ilias
