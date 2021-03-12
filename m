Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4960F3397F7
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 21:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbhCLUGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 15:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234635AbhCLUFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 15:05:51 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F47DC061762
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 12:05:50 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id j2so5461229wrx.9
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 12:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QGcOUOWYrtlGEtGtp6CRhZz9BsHqr4gvekeyWTQX/+U=;
        b=qXjLpE1SzOwXL9eMZ4sVgx+Ho7QAI/X5+cU88dH2+5FstbM+imrk9OxnjbVeUcR6YI
         rx0szxhQCI8AwDfNdyCzkSp6a+z9FHIl/SnJa9covZXzclAP8CNUjmxCgD7/534BDM6l
         D5x0bFj0S+9CccUOvMiSnHZUhUyL4Nt9dfbwP5yvfRMnIxL7OfxWIDZJJgqN5xGHElo3
         TzGsWFTFsxG3nrEYYJI+xiF1cTm5NaPZ7HLpKzP+u5x/paqU7X6VgvZCJ0OZpm/IBXfF
         6pwmLJN2F3lsXuNQqTo21sTgShG48HUbToep4zwaSQVJ3Y5HPCcjdZGdYD0SEp5qRrJg
         IczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QGcOUOWYrtlGEtGtp6CRhZz9BsHqr4gvekeyWTQX/+U=;
        b=gyDHxqpQ7qbC1ZDqElEeUl/rSL+aek1KDjbk3ejDq3/jKQa6vFKT6ZXMBDjuR0TEGL
         Rn8KfZ18FnnLjiPVRm9yJQX+vWfTR5CLsmvembnPnYVXrhp5/taefLKtpGkskAE9kpuG
         UUkRQERcpMvhSE15lDagMecTVVoBZbHsDg3wdO8CvH89uKVL16uRP7Jg0z9iX27gvPcj
         gTakd+IkPmq5DBtYA89gymFQ1UWNiWZ7TeFqVzS+Hv5SGQIYRNSofntl9juZuexA3DY/
         jrbz39egJdGvl5IiLDAgyjP2NK28OJ7+jPfU2Q1kNXF0JaRc+WRcyVLXL5aekBRmEmE2
         2U4A==
X-Gm-Message-State: AOAM532sVNVEZTrT9xuJLHgwim9I8b7ImDy0wn/HhJIdLPxawotb4bSZ
        Tusnn+WZFTJpaUGGbM27ybUvHA==
X-Google-Smtp-Source: ABdhPJw8cRrGcaQUUVnqA8Tyww1Pzpw79qa1UHk7Y7H/248bMIaCPg9pzS91Nl7GhXEgRhZp4++izQ==
X-Received: by 2002:adf:f04e:: with SMTP id t14mr15854532wro.100.1615579549084;
        Fri, 12 Mar 2021 12:05:49 -0800 (PST)
Received: from apalos.home (ppp-94-64-113-158.home.otenet.gr. [94.64.113.158])
        by smtp.gmail.com with ESMTPSA id i11sm9148238wro.53.2021.03.12.12.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 12:05:48 -0800 (PST)
Date:   Fri, 12 Mar 2021 22:05:45 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 7/7] net: page_pool: use alloc_pages_bulk in refill code
 path
Message-ID: <YEvJmVrnTzKT1XAY@apalos.home>
References: <20210312154331.32229-1-mgorman@techsingularity.net>
 <20210312154331.32229-8-mgorman@techsingularity.net>
 <CAKgT0UebK=mMwDV+UH8CqBRt0E0Koc7EB42kwgf0hYHDT_2OfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UebK=mMwDV+UH8CqBRt0E0Koc7EB42kwgf0hYHDT_2OfQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[...]
> 6. return last_page
> 
> > +       /* Remaining pages store in alloc.cache */
> > +       list_for_each_entry_safe(page, next, &page_list, lru) {
> > +               list_del(&page->lru);
> > +               if ((pp_flags & PP_FLAG_DMA_MAP) &&
> > +                   unlikely(!page_pool_dma_map(pool, page))) {
> > +                       put_page(page);
> > +                       continue;
> > +               }
> 
> So if you added a last_page pointer what you could do is check for it
> here and assign it to the alloc cache. If last_page is not set the
> block would be skipped.
> 
> > +               if (likely(pool->alloc.count < PP_ALLOC_CACHE_SIZE)) {
> > +                       pool->alloc.cache[pool->alloc.count++] = page;
> > +                       pool->pages_state_hold_cnt++;
> > +                       trace_page_pool_state_hold(pool, page,
> > +                                                  pool->pages_state_hold_cnt);
> > +               } else {
> > +                       put_page(page);
> 
> If you are just calling put_page here aren't you leaking DMA mappings?
> Wouldn't you need to potentially unmap the page before you call
> put_page on it?

Oops, I completely missed that. Alexander is right here.

> 
> > +               }
> > +       }
> > +out:
> >         if ((pp_flags & PP_FLAG_DMA_MAP) &&
> > -           unlikely(!page_pool_dma_map(pool, page))) {
> > -               put_page(page);
> > +           unlikely(!page_pool_dma_map(pool, first_page))) {
> > +               put_page(first_page);
> 
> I would probably move this block up and make it a part of the pp_order
> block above. Also since you are doing this in 2 spots it might make
> sense to look at possibly making this an inline function.
> 
> >                 return NULL;
> >         }
> >
> >         /* Track how many pages are held 'in-flight' */
> >         pool->pages_state_hold_cnt++;
> > -       trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
> > +       trace_page_pool_state_hold(pool, first_page, pool->pages_state_hold_cnt);
> >
> >         /* When page just alloc'ed is should/must have refcnt 1. */
> > -       return page;
> > +       return first_page;
> >  }
> >
> >  /* For using page_pool replace: alloc_pages() API calls, but provide
> > --
> > 2.26.2
> >

Cheers
/Ilias
