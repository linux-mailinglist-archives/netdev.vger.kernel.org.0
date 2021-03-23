Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573CD3465D7
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 18:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhCWRCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 13:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhCWRB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 13:01:57 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB7FC061763
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 10:01:57 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id y124-20020a1c32820000b029010c93864955so13422256wmy.5
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 10:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=395prUbwI/IfV0JoklEZBoBsZBXXiAGcosueqqFVoGU=;
        b=arSFjkI8NS7BWO4Mgnjs45V4EHoKoaHEFT+Vn0Mt1dc0Cve0UVTM+xcz99Opm49sum
         jYDvL90nVd6IuLycEBXgiS4BpG4ID3m0AdMpm39ufsAD53leRfmLLnuCI4MNtIcgBOx1
         ZC+ezpnTrBn+2B6/lGnWfHNquOrHQn4gW8xH6cUqt99UlRpqMxegq0UlRIh07feJreVn
         Db2wk5w6HF8c2xmzl8j5lOdHThGGFJIC9oWMDRwWEe4jV2XiDYwCaL3wTbA5DINqzp12
         sJvg2cht5mNj4rTdET7L+rneAwsvBIw+eOqR1PmrcOnKZb4MOCN4n7IPh0MMhqmOqDcM
         vTPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=395prUbwI/IfV0JoklEZBoBsZBXXiAGcosueqqFVoGU=;
        b=VAniS8UyTbJnxhJL8UxfCQB9OolctjOtBpSVyn5B/h1K8RpE8+paGfpJDg8JK3n58E
         WZ8eyJnnbEliPtTdnfp32naQx5YOoxq5DZ+VKdbrc7M7ZWUR4c4FC7aMGbA7bUOY+MUh
         3EaJZZ/YkFKJBLb551tCJRCb1eNkiXjaVauVcVdK4WoFdutgTD3gtnaI0Rbj1dpOzBP2
         u8/FA/7itKiqxgqGYP3wkuYjQABPzhQyqsVyDXkYeVv10p8KX7yFuKH632N3hz/CY8i5
         beHeB+IfTXQwq+DrL1te5cjpswOc3C23J1wBujUyAw7Q/G5/eodBITkD8AMUeDwW0dbQ
         3zZA==
X-Gm-Message-State: AOAM533pcnZKFhzk2mGCP3HYVyQN6YS4UTeioXgPMoJDrfEAQSCPovcZ
        jLegxSt3Rw9fX9C5JDllFIAr8g==
X-Google-Smtp-Source: ABdhPJx0uBaBT5ldzR0t8kGnPj2ob5qwxU3qGJOi/Hspvntaz8KIFl6ssBCW4bmZ2j/L3yKzj2W1bQ==
X-Received: by 2002:a1c:2683:: with SMTP id m125mr4257280wmm.178.1616518915892;
        Tue, 23 Mar 2021 10:01:55 -0700 (PDT)
Received: from enceladus (ppp-94-64-113-158.home.otenet.gr. [94.64.113.158])
        by smtp.gmail.com with ESMTPSA id q15sm24087968wrr.58.2021.03.23.10.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 10:01:55 -0700 (PDT)
Date:   Tue, 23 Mar 2021 19:01:52 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 0/6] page_pool: recycle buffers
Message-ID: <YFofANKiR3tD9zgm@enceladus>
References: <20210322170301.26017-1-mcroce@linux.microsoft.com>
 <20210323154112.131110-1-alobakin@pm.me>
 <YFoNoohTULmcpeCr@enceladus>
 <20210323170447.78d65d05@carbon>
 <YFoTBm0mJ4GyuHb6@enceladus>
 <CAFnufp1K+t76n9shfOZB_scV7myUWCTXbB+yf5sr-8ORYQxCEQ@mail.gmail.com>
 <20210323165523.187134-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323165523.187134-1-alobakin@pm.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 04:55:31PM +0000, Alexander Lobakin wrote:
> > > > > >

[...]

> > > > >
> > > > > Thanks for the testing!
> > > > > Any chance you can get a perf measurement on this?
> > > >
> > > > I guess you mean perf-report (--stdio) output, right?
> > > >
> > >
> > > Yea,
> > > As hinted below, I am just trying to figure out if on Alexander's platform the
> > > cost of syncing, is bigger that free-allocate. I remember one armv7 were that
> > > was the case.
> > >
> > > > > Is DMA syncing taking a substantial amount of your cpu usage?
> > > >
> > > > (+1 this is an important question)
> 
> Sure, I'll drop perf tools to my test env and share the results,
> maybe tomorrow or in a few days.
> From what I know for sure about MIPS and my platform,
> post-Rx synching (dma_sync_single_for_cpu()) is a no-op, and
> pre-Rx (dma_sync_single_for_device() etc.) is a bit expensive.
> I always have sane page_pool->pp.max_len value (smth about 1668
> for MTU of 1500) to minimize the overhead.
> 
> By the word, IIRC, all machines shipped with mvpp2 have hardware
> cache coherency units and don't suffer from sync routines at all.
> That may be the reason why mvpp2 wins the most from this series.

Yep exactly. It's also the reason why you explicitly have to opt-in using the
recycling (by marking the skb for it), instead of hiding the feature in the
page pool internals 

Cheers
/Ilias

> 
> > > > > >
> > > > > > [0] https://lore.kernel.org/netdev/20210323153550.130385-1-alobakin@pm.me
> > > > > >
> > > >
> >
> > That would be the same as for mvneta:
> >
> > Overhead  Shared Object     Symbol
> >   24.10%  [kernel]          [k] __pi___inval_dcache_area
> >   23.02%  [mvneta]          [k] mvneta_rx_swbm
> >    7.19%  [kernel]          [k] kmem_cache_alloc
> >
> > Anyway, I tried to use the recycling *and* napi_build_skb on mvpp2,
> > and I get lower packet rate than recycling alone.
> > I don't know why, we should investigate it.
> 
> mvpp2 driver doesn't use napi_consume_skb() on its Tx completion path.
> As a result, NAPI percpu caches get refilled only through
> kmem_cache_alloc_bulk(), and most of skbuff_head recycling
> doesn't work.
> 
> > Regards,
> > --
> > per aspera ad upstream
> 
> Oh, I love that one!
> 
> Al
> 
