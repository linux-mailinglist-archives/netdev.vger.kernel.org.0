Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214264A9E80
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377296AbiBDSAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377295AbiBDSAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:00:44 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827D4C06173D
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:00:43 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id i34so14218669lfv.2
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 10:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ROsAj8F2fWB8BeGhq6UbEY9dTiLKP74SZpubSTkqc+s=;
        b=FnPeVEHXJKh+J53wuRlUgT8pJWPZjX5ALsGbzxKuj4uGF/Df/vqU6+/1uDHbP/jbWu
         Mj1JVn51mfCI+djYhU3L65j6P93GR6neo2CDfHCS1eEe7V1r+ae9fcoyi9rgsQlE1Vc/
         stTznwVvPyHKGowAVsKM3RHz/NMMWf1tWzAzw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ROsAj8F2fWB8BeGhq6UbEY9dTiLKP74SZpubSTkqc+s=;
        b=Ga/lNYRwmoXOLgPwamf7STnJ3Untreqnqw3bR5j/fvQ0+2GbpPJ6V6lsxCfTe+IuC4
         oltcF/2twXIPi+oJgTCfuZ7s8JXsDUmxHntIXNUvB6MldXiPRKcB+GuRirSPHx/uAgIY
         NrxUZMGDpCNXwuSTkC2xsLGb4xVWhj1z8cp3snDb172FVv901n9pwoy4AAkAMfd/PjIv
         aWnGhG/3O03EOqWFMQBgVmSxy+hJBnaYrYG/QZ6Tk6mxBYGxezIePWnE1x5aH1ak+8oy
         2ToK+Pllwg2ta/ceUVOkcD5y4K1hRUyRmGDa0xdKxb4CkmdFtiMuY27goGrPTw1M8Pgq
         9ykA==
X-Gm-Message-State: AOAM53009K8f00bfnJszLzG6AbKEK/w8aqDgcGwrL3yuTB0yWGx+7L9f
        ZhxlrBUwcWIAZypTeSX6cjp+pPGPaBj1H+T5j8sb4g==
X-Google-Smtp-Source: ABdhPJxkLk7wQZMucN70MUeP74OCiMRaMjJnRs4cUX2ZHDFrBxz/VRpLWnY5CW7r6dGgSmecbEwKaDUa/fLHapbYlag=
X-Received: by 2002:a05:6512:b96:: with SMTP id b22mr72634lfv.540.1643997641796;
 Fri, 04 Feb 2022 10:00:41 -0800 (PST)
MIME-Version: 1.0
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
 <1643933373-6590-12-git-send-email-jdamato@fastly.com> <YfzZyL+mnvcFdzYs@hades>
In-Reply-To: <YfzZyL+mnvcFdzYs@hades>
From:   Joe Damato <jdamato@fastly.com>
Date:   Fri, 4 Feb 2022 10:00:30 -0800
Message-ID: <CALALjgwE6ozNjia78RKp=eBwWdWrNQTpkv_c34FN-aFe8LfFew@mail.gmail.com>
Subject: Re: [net-next v4 11/11] page_pool: Add function to batch and return stats
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        hawk@kernel.org, saeed@kernel.org, ttoukan.linux@gmail.com,
        brouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 11:46 PM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> On Thu, Feb 03, 2022 at 04:09:33PM -0800, Joe Damato wrote:
> > Adds a function page_pool_get_stats which can be used by drivers to obtain
> > the batched stats for a specified page pool.
> >
> > Signed-off-by: Joe Damato <jdamato@fastly.com>
> > ---
> >  include/net/page_pool.h |  9 +++++++++
> >  net/core/page_pool.c    | 25 +++++++++++++++++++++++++
> >  2 files changed, 34 insertions(+)
> >
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index bb87706..5257e46 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -153,6 +153,15 @@ struct page_pool_stats {
> >               u64 waive;  /* failed refills due to numa zone mismatch */
> >       } alloc;
> >  };
> > +
> > +/*
> > + * Drivers that wish to harvest page pool stats and report them to users
> > + * (perhaps via ethtool, debugfs, or another mechanism) can allocate a
> > + * struct page_pool_stats and call page_pool_get_stats to get the batched pcpu
> > + * stats.
> > + */
> > +struct page_pool_stats *page_pool_get_stats(struct page_pool *pool,
> > +                                         struct page_pool_stats *stats);
> >  #endif
> >
> >  struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index 0bd084c..076593bb 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -35,6 +35,31 @@
> >               struct page_pool_stats __percpu *s = pool->stats;       \
> >               __this_cpu_inc(s->alloc.__stat);                        \
> >       } while (0)
> > +
> > +struct page_pool_stats *page_pool_get_stats(struct page_pool *pool,
> > +                                         struct page_pool_stats *stats)
> > +{
> > +     int cpu = 0;
> > +
> > +     if (!stats)
> > +             return NULL;
> > +
> > +     for_each_possible_cpu(cpu) {
> > +             const struct page_pool_stats *pcpu =
> > +                     per_cpu_ptr(pool->stats, cpu);
> > +
> > +             stats->alloc.fast += pcpu->alloc.fast;
> > +             stats->alloc.slow += pcpu->alloc.slow;
> > +             stats->alloc.slow_high_order +=
> > +                     pcpu->alloc.slow_high_order;
> > +             stats->alloc.empty += pcpu->alloc.empty;
> > +             stats->alloc.refill += pcpu->alloc.refill;
> > +             stats->alloc.waive += pcpu->alloc.waive;
> > +     }
> > +
> > +     return stats;
> > +}
> > +EXPORT_SYMBOL(page_pool_get_stats);
>
> You don't really need to return a pointer here. Just make the return code a
> bool

OK. Updated page_pool_get_stats to return a bool in my v5 branch.
