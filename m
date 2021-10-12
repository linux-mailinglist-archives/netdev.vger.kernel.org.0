Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEE3429EF7
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 09:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbhJLHwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 03:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbhJLHwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 03:52:02 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA14C06161C
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 00:50:01 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g8so77649819edt.7
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 00:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zjhSxsxPmDkUBZgqIoPJCNZSxFw5dwlvuXZheYtUcVg=;
        b=b2cCKTVjViEa00fDBlt1t+X+EnjEbzq3Y9qULPi0IFdRkhvDBXItqS4QyRXhWUHl3q
         +kO9GX5KnfKGMiHNhepZRGx4YXYfjsrj9og/StGshwDBxaxAqcRMkhMeCwuQDspinotB
         QmbT+wYgdIl+WdwiMXvE1b0QjUcxZRYyQR4090lYiA8cnCwIve4rYy9cKsnz7LIzpyy2
         vjAUM6TOb1HYZWRY8qg/nhwuMiaXZKTEx7U25JRIkoYvqBxr33mWA+5tWlhTwqwB07eQ
         RMt8Ofme6aKYl3PKwDk/mrNKgVEH/XjBYTKYowXatH+16kIT3XD4gtEpCi4+pj+aqutl
         /CmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zjhSxsxPmDkUBZgqIoPJCNZSxFw5dwlvuXZheYtUcVg=;
        b=LBGqszMiHQhWy15sYcVomzkyTsxDvfnmg7mcVM4IIuAfcc8MMZSeF5iwy/WLCXDyYv
         Ltt5eRHinJWQ/xfFPkfkbO4DOZ/xzYBbSoNK1fQQPVRRBOqxdqxkiwkUP9H7ifG4SV98
         yuylzTkhnPtR2pTF+yL4YC8L8hKIFcsL+5EKgagTtAcqeMhbKTGE0icXo6WFLqmHHAUe
         9Jfjt+c/Oigv1eQCkjPjSFpIaFdG8mpbTIQ2LM/J2ecm87UMgxLvr23Ht58KF2A9f7Fi
         4B4p/kRUDFJqxRZWVfysucWKHii2NlzIVvJN3DGmuIH9CkiDFjxBnv3m/Ht8nBchAP4Q
         pBnA==
X-Gm-Message-State: AOAM532qJGrMs1vZlTXl2NJ0SLIkv0Wdur7hPj7eeVVcappNbT11N4iK
        7vFhz4J2d52kkSMZT1ydOesoIw==
X-Google-Smtp-Source: ABdhPJwEFW5rMXWCaGXRtspf+k4QIl8RCZntZQkLWKOktRpPjqvjyyL6uimYwSRvt4kCgM75IuJc2Q==
X-Received: by 2002:a17:906:d145:: with SMTP id br5mr26348894ejb.250.1634024999730;
        Tue, 12 Oct 2021 00:49:59 -0700 (PDT)
Received: from Iliass-MacBook-Pro.local ([62.74.11.155])
        by smtp.gmail.com with ESMTPSA id m13sm5295878eda.41.2021.10.12.00.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 00:49:59 -0700 (PDT)
Date:   Tue, 12 Oct 2021 10:49:54 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, brouer@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        akpm@linux-foundation.org, hawk@kernel.org, peterz@infradead.org,
        yuzhao@google.com, will@kernel.org, willy@infradead.org,
        jgg@ziepe.ca, mcroce@microsoft.com, willemb@google.com,
        cong.wang@bytedance.com, pabeni@redhat.com, haokexin@gmail.com,
        nogikh@google.com, elver@google.com, memxor@gmail.com,
        vvs@virtuozzo.com, linux-mm@kvack.org, edumazet@google.com,
        alexander.duyck@gmail.com, dsahern@gmail.com
Subject: Re: [PATCH net-next -v5 3/4] mm: introduce __get_page() and
 __put_page()
Message-ID: <YWU+Ihzmhf+UTnal@Iliass-MacBook-Pro.local>
References: <20211009093724.10539-1-linyunsheng@huawei.com>
 <20211009093724.10539-4-linyunsheng@huawei.com>
 <62106771-7d2a-3897-c318-79578360a88a@nvidia.com>
 <89bcc42a-ad95-e729-0748-bf394bf770be@redhat.com>
 <YWQuRpdJOMyJBBrs@apalos.home>
 <3bba942e-eefd-7ac2-7a8c-b6c349641dd4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bba942e-eefd-7ac2-7a8c-b6c349641dd4@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 03:38:15PM +0800, Yunsheng Lin wrote:
> On 2021/10/11 20:29, Ilias Apalodimas wrote:
> > On Mon, Oct 11, 2021 at 02:25:08PM +0200, Jesper Dangaard Brouer wrote:
> >>
> >>
> >> On 09/10/2021 21.49, John Hubbard wrote:
> >>> So in case it's not clear, I'd like to request that you drop this one
> >>> patch from your series.
> >>
> >> In my opinion as page_pool maintainer, you should also drop patch 4/4 from
> >> this series.
> >>
> >> I like the first two patches, and they should be resend and can be applied
> >> without too much further discussion.
> > 
> > +1
> 
> Ok, it seems there is a lot of contention about how to avoid calling
> compound_head() now.
> 

IMHO compound head is not that heavy.  So you could keep the get/put page
calls as-is and worry about micro optimizations later,  especially since
it's intersecting with folio changes atm.

> Will send out the uncontroversial one first.
> 

Thanks!

> > That's what I hinted on the previous version. The patches right now go way
> > beyond the spec of page pool.  We are starting to change core networking
> > functions and imho we need a lot more people involved in this discussion,
> > than the ones participating already.
> > 
> > As a general note and the reason I am so hesitant,  is that we are starting
> > to violate layers here (at least in my opinion).  When the recycling was
> > added,  my main concern was to keep the network stack unaware (apart from
> > the skb bit).  Now suddenly we need to teach frag_ref/unref internal page
> 
> Maybe the skb recycle bit is a clever way to avoid dealing with the network
> stack directly.
> 
> But that bit might also introduce or hide some problem, like the data race
> as pointed out by Alexander, and the odd using of page pool in mlx5 driver.

Yea.  I was always wondering if unmaping the buffers and let the network stack
deal with them eventually would be a good idea (on those special cases).
There's an obvious disadvantage (which imho is terrible) in this approach.
Any future functions that we add in the core networking code, will need to
keep that in mindxi,  and unmap some random driver memory  if they start
playing tricks with the skb and their fragments. IOW I think this is very
fragile.

> 
> > pool counters and that doesn't feel right.  We first need to prove the race
> > can actually happen, before starting to change things.
> 
> As the network stack is adding a lot of performance improvement, such as
> sockmap for BPF, which may cause problem for them, will dig more to prove
> that.
> 

Ok that's something we need to look at.  Are those buffers freed eventually
by skb_free_head() etc?

Regards
/Ilias
