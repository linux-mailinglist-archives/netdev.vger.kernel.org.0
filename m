Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3628D1FD85
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 03:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfEPBqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 21:46:24 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:35948 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbfEPAEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 20:04:12 -0400
Received: by mail-it1-f196.google.com with SMTP id e184so3199398ite.1
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 17:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/JDvbTuMFEOXpcV6Dw+/iWLzASapBTlNDimfsMGWVCA=;
        b=QJl+u6llA75GBoCObJ4mt7eAWL+/V/sXveEk4/plVQlViLMJgia4vtx6NXCPHWLwm9
         NEcrECwQTJKALWMX6HnOyrpNyDXRWQUtRLUWgXbm+fOlvLFaL0IGodNeXMXjKjHcQiSg
         ZCweKOhzs/6jrANfSBJ7yIvtkv8oSdFv6qnwieinMTBI2DsNMhTLwphkarouJNusncYt
         eFxKiU/gcvMgcKjYV1FpQWkWaAcHgW2m+hoBtNjl3F1zcOdU0B8V8kttAFNRgEghcQuL
         dLX8p352lBit9VOKzUTEoNYQQm4+PTbCGN1l32NEriB6tdOsjuvFnlnzIKb6eZUr2jBK
         2chg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/JDvbTuMFEOXpcV6Dw+/iWLzASapBTlNDimfsMGWVCA=;
        b=oimDaUg/Q76wAyt843FrIsXidwc9odzNVN+3c15CMAoDkSuv5XkfL3KztO09RrrS9u
         0F7Cuc78eY63iBNOWS/9MG4Yh8HXUnLczfUAH53oLPpWXxYSLx3YC1jFqsMyCWG9YADo
         J4ssgS9c6/RY6qMgaKi5h8fbyWubH5dxSg5vyNiGrRLXZ3/RtfzHLn0iKh6fYXV0VGFu
         m28PT6/H3zaN7woUKEKot/naXN6ol03fevgjOG75bPASKEWtW+lIJw/gychJLrSz8l77
         OYirJZVYe/NstlTjLbUHsDM6qw8l+QcsUV6xH8svQ9QUdnIL/Ok6KiQTNavuSJOlpHop
         vVbA==
X-Gm-Message-State: APjAAAV8lESPAy+al0b46cmunxMqCc0pPK5mK5fXGxUuJ076hjLJauNm
        ruAzWfRC4y6A9cfmWG+J8sMKg5BmIiIYqTP+R4/0Vjgwwwi2yw==
X-Google-Smtp-Source: APXvYqythdIyTkrqvVg/JUjmiHiQldV9zXFqb/uUHVnSuUcS23oSWxNdyYMG0ZtCf0/wr8aQVPUlcwOSb90ibtaB+XQ=
X-Received: by 2002:a24:5fc2:: with SMTP id r185mr11739281itb.43.1557965050797;
 Wed, 15 May 2019 17:04:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190515004610.102519-1-tracywwnj@gmail.com> <20190515215052.vqku4gohestbkldj@kafai-mbp>
In-Reply-To: <20190515215052.vqku4gohestbkldj@kafai-mbp>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 15 May 2019 17:03:59 -0700
Message-ID: <CAEA6p_AA2Xy==jrEWcWuRN2xk3Wz-MqdPC32HtRP90vPH_KmhQ@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: fix src addr routing with the exception table
To:     Martin Lau <kafai@fb.com>
Cc:     Wei Wang <tracywwnj@gmail.com>, David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 2:51 PM Martin Lau <kafai@fb.com> wrote:
>
> On Tue, May 14, 2019 at 05:46:10PM -0700, Wei Wang wrote:
> > From: Wei Wang <weiwan@google.com>
> >
> > When inserting route cache into the exception table, the key is
> > generated with both src_addr and dest_addr with src addr routing.
> > However, current logic always assumes the src_addr used to generate the
> > key is a /128 host address. This is not true in the following scenarios:
> > 1. When the route is a gateway route or does not have next hop.
> >    (rt6_is_gw_or_nonexthop() == false)
> > 2. When calling ip6_rt_cache_alloc(), saddr is passed in as NULL.
> > This means, when looking for a route cache in the exception table, we
> > have to do the lookup twice: first time with the passed in /128 host
> > address, second time with the src_addr stored in fib6_info.
> >
> > This solves the pmtu discovery issue reported by Mikael Magnusson where
> > a route cache with a lower mtu info is created for a gateway route with
> > src addr. However, the lookup code is not able to find this route cache.
> >
> > Fixes: 2b760fcf5cfb ("ipv6: hook up exception table to store dst cache")
> > Reported-by: Mikael Magnusson <mikael.kernel@lists.m7n.se>
> > Bisected-by: David Ahern <dsahern@gmail.com>
> > Signed-off-by: Wei Wang <weiwan@google.com>
> > Acked-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  net/ipv6/route.c | 33 ++++++++++++++++++++++++++++-----
> >  1 file changed, 28 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> > index 23a20d62daac..c36900a07a78 100644
> > --- a/net/ipv6/route.c
> > +++ b/net/ipv6/route.c
> > @@ -1574,23 +1574,36 @@ static struct rt6_info *rt6_find_cached_rt(const struct fib6_result *res,
> >       struct rt6_exception *rt6_ex;
> >       struct rt6_info *ret = NULL;
> >
> > -     bucket = rcu_dereference(res->f6i->rt6i_exception_bucket);
> > -
> >  #ifdef CONFIG_IPV6_SUBTREES
> >       /* fib6i_src.plen != 0 indicates f6i is in subtree
> >        * and exception table is indexed by a hash of
> >        * both fib6_dst and fib6_src.
> > -      * Otherwise, the exception table is indexed by
> > -      * a hash of only fib6_dst.
> > +      * However, the src addr used to create the hash
> > +      * might not be exactly the passed in saddr which
> > +      * is a /128 addr from the flow.
> > +      * So we need to use f6i->fib6_src to redo lookup
> > +      * if the passed in saddr does not find anything.
> > +      * (See the logic in ip6_rt_cache_alloc() on how
> > +      * rt->rt6i_src is updated.)
> >        */
> >       if (res->f6i->fib6_src.plen)
> >               src_key = saddr;
> > +find_ex:
> >  #endif
> > +     bucket = rcu_dereference(res->f6i->rt6i_exception_bucket);
> >       rt6_ex = __rt6_find_exception_rcu(&bucket, daddr, src_key);
> >
> >       if (rt6_ex && !rt6_check_expired(rt6_ex->rt6i))
> >               ret = rt6_ex->rt6i;
> >
> > +#ifdef CONFIG_IPV6_SUBTREES
> > +     /* Use fib6_src as src_key and redo lookup */
> > +     if (!ret && src_key == saddr) {
> > +             src_key = &res->f6i->fib6_src.addr;
> > +             goto find_ex;
> > +     }
> > +#endif
> > +
> >       return ret;
> >  }
> >
> > @@ -2683,12 +2696,22 @@ u32 ip6_mtu_from_fib6(const struct fib6_result *res,
> >  #ifdef CONFIG_IPV6_SUBTREES
> >       if (f6i->fib6_src.plen)
> >               src_key = saddr;
> > +find_ex:
> >  #endif
> > -
> >       bucket = rcu_dereference(f6i->rt6i_exception_bucket);
> >       rt6_ex = __rt6_find_exception_rcu(&bucket, daddr, src_key);
> >       if (rt6_ex && !rt6_check_expired(rt6_ex->rt6i))
> >               mtu = dst_metric_raw(&rt6_ex->rt6i->dst, RTAX_MTU);
> > +#ifdef CONFIG_IPV6_SUBTREES
> > +     /* Similar logic as in rt6_find_cached_rt().
> > +      * We need to use f6i->fib6_src to redo lookup in exception
> > +      * table if saddr did not yield any result.
> > +      */
> > +     else if (src_key == saddr) {
> > +             src_key = &f6i->fib6_src.addr;
> > +             goto find_ex;
> > +     }
> > +#endif
> Nit.
> Instead of repeating this retry logic,
> can it be consolidated into __rt6_find_exception_xxx()
> by passing fib6_src.addr as a secondary matching
> saddr?
>
Thanks Martin.
Changing __rt6_find_exception_xxx() might not be easy cause other
callers of this function does not really need to back off and use
another saddr.
And the validation of the result is a bit different for different callers.
What about add a new helper for the above 2 cases and just call that
from both places?

> >
> >       if (likely(!mtu)) {
> >               struct net_device *dev = nh->fib_nh_dev;
> > --
> > 2.21.0.1020.gf2820cf01a-goog
> >
