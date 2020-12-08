Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569DD2D359D
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 22:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbgLHVvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 16:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgLHVvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 16:51:54 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74173C061794
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 13:51:14 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id t33so152250ybd.0
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 13:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IrbuLHfafjz+sRlDO0dkJ2IAH5+0Wj03472Zc1a6OJ4=;
        b=Tl/4/Zhf27fYFL7rAyDBESVlL4Q3CGlmerSiuHMF4GeZ4qzGE7dj3ywsWH0X/dP/sG
         Uc9e8WbnArfok3EJ0riaKf7emj3hgHtF5c4hehEVcJ6udOFQEbGwrsEJeZvr6fNlwiaR
         inCtPkAlF9QSExExS08oGpCmIUTUfnUOn5qd67kd0V5Z618NAXk6Cx65FI6juTwAWW0u
         wrrTvzmTxwZw73p2vdJpklpwrvg5BqUddEEJKu2dc0HEnX/3oCv7QjbOQ9djeIQB3Y4A
         HNdxeIczJvG/AptGvia3JgqfxaxiZ1UUa4mHVCMPUD/FQ6j+Uaxzk2mm3s9eultRpJSY
         W++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IrbuLHfafjz+sRlDO0dkJ2IAH5+0Wj03472Zc1a6OJ4=;
        b=M+3skn63LFdhXCmS0elOTvP4/oW+O8Oirr4X9n56EXUN9b6KMZjHyNPuP2kYuwgheI
         5zNF62jgPc4Hg0teThzuv/X3VfxcYYw63/Y/RcP3BnT2balWjdHvdW0qkAj4OZTxLIrD
         ILCSzwcDvXXephPRsJINbkYT9pci0c3ZPL9iv/8Cz9A0x0BQ4CwSV6tJHH12CBgTYRkW
         5LboC1TwiYbhW7MG2cJDnWLU63Y9zX2i8xhwYwWaxMuIv8RxbOp/FzBO1fDZ9ggzLSJW
         vc93XXQRRFPMC2vvVujpsp12HOlaFcBHBuK5fSh1ae+c2JmJ5pmkAQNjy9phSj78OfR3
         fzNw==
X-Gm-Message-State: AOAM531MouOShKqM4QrRUnGyr3UxPRR4zkRSl2Syn51NqhV1RvhX1ssi
        9SfJkDQGUayE9r6Dx0ijahgN6gVenC3HT2hfVWM49w==
X-Google-Smtp-Source: ABdhPJytY4O/tksopFX4PtEEcyVxOau41uhnLsk52VZ6aSjrLTV/onzexuvQpge0idCE1mglg3bNmSL4sZRO7ZOCHIs=
X-Received: by 2002:a25:a4a1:: with SMTP id g30mr34109488ybi.195.1607464273599;
 Tue, 08 Dec 2020 13:51:13 -0800 (PST)
MIME-Version: 1.0
References: <ca64de092db5a2ac80d22eaa9d662520@codeaurora.org>
 <56e72b72-685f-925d-db2d-d245c1557987@gmail.com> <CAEA6p_D+diS7jnpoGk6cncWL8qiAGod2EAp=Vcnc-zWNPg04Jg@mail.gmail.com>
 <307c2de1a2ddbdcd0a346c57da88b394@codeaurora.org>
In-Reply-To: <307c2de1a2ddbdcd0a346c57da88b394@codeaurora.org>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 8 Dec 2020 13:51:03 -0800
Message-ID: <CAEA6p_ArQdNp=hQCjrsnAo-Xy22d44b=2KdLp7zO7E7XDA4Fog@mail.gmail.com>
Subject: Re: Refcount mismatch when unregistering netdevice from kernel
To:     stranche@codeaurora.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 8, 2020 at 11:13 AM <stranche@codeaurora.org> wrote:
>
> Hi Wei and Eric,
>
> Thanks for the replies.
>
> This was reported to us on the 5.4.61 kernel during a customer
> regression suite, so we don't have an exact reproducer unfortunately.
>  From the trace logs we've added it seems like this is happening during
> IPv6 transport mode XFRM data transfer and the device is unregistered in
> the middle of it, but we've been unable to reproduce it ourselves..
> We're open to trying out and sharing debug patches if needed though.
>

I double checked 5.4.61, and I didn't find any missing fixes in this
area AFAICT.

> > rt6_uncached_list_flush_dev() actually tries to replace the inet6_dev
> > with loopback_dev, and release the reference to the previous inet6_dev
> > by calling in6_dev_put(), which is actually doing the same thing as
> > ip6_dst_ifdown(). I don't understand why you say " a reference to the
> > inet6_dev is simply dropped".
>
> Fair. I was going off the semantics used by the dst_dev_put() function
> which calls dst_ops->ifdown() explicitly. At least in the case of
> xfrm6_dst_ifdown() this swap of the loopback device and putting the
> refcount seems like it could be missing a few things.
>

Looking more into the xfrm code, I think the major difference between
xfrm dst and non-xfrm dst is that, xfrm code creates a list of dst
entries in one dst_entry linked by xfrm_dst_child().
In xfrm_bundle_create(), which I believe is the main function to
create xfrm dst bundles, it allocates the main dst entry and its
children, and it calls xfrm_fill_dst() for each of them. So I think
each dst in the list (including all the children) are added into the
uncached_list.
The difference between the current code in
rt6_uncached_list_flush_dev() vs dst_ops->ifdown() is that, the
current code only releases the refcnt to inet6_dev associated with the
main dst, while xfrm6_dst_ifdown() tries to release inet6_dev
associated with every dst linked by xfrm_dst_child(). However, since
xfrm_bundle_create() anyway adds each child dst to the uncached list,
I don't see how the current code could miss any refcnt.
BTW, have you tried your previous proposed patch and confirmed it
would fix the issue?

> > The additional refcount to the DST is also released by doing the
> > following:
> >                         if (rt_dev == dev) {
> >                                 rt->dst.dev = blackhole_netdev;
> >                                 dev_hold(rt->dst.dev);
> >                                 dev_put(rt_dev);
> >                         }
> > Am I missing something?
>
> That dev_put() is on the actual netdevice struct, not the inet6_dev
> associated with it. We're seeing many calls to icmp6_dst_alloc() and
> xfrm6_fill_dst() here, both of which seem to associate a reference to
> the inet6_dev struct with the DST in addition to the standard dev_hold()
> on the netdevice during the dst_alloc()/dst_init().
>

Could we further distinguish between dst added to the uncached list by
icmp6_dst_alloc() and xfrm6_fill_dst(), and confirm which ones are the
ones leaking reference?
I suspect it would be the xfrm ones, but I think it is worth verifying.


> Thanks,
> Sean
