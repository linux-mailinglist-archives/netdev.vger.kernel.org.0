Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A541935A6C9
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbhDITNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbhDITNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 15:13:21 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BC0C061762;
        Fri,  9 Apr 2021 12:13:08 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id q5so4847760pfh.10;
        Fri, 09 Apr 2021 12:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D0A/Cc8hdMaD+El6MEJZ9FzF6kVCbUYdGbS7BSYWv4w=;
        b=Zom8TnsCmt9waqDyDmehlMdo3U/FtzgiQHC1r1S7grbrvnJuz8G5m2PNhFdOm1QPc7
         dJ8h4uGx3FD+mYPEGLbRcZgUUBH+FtQEwXG7PjHXrDFU4IovGHCj1YNEqmbA2QS9xcpv
         cg7S5oF59hLwyXRR84MfO9THrcHMIjm6db/EK6wdM4fcMwcl6nkVVwHsvfKFGpCp0v50
         az4YNuig+5iK0DhFCHu9Ll83O8wKwOmQIUKYVQs2+/Bb+1GgjgxkjTXKUL9trdwceAI8
         Y+7ZA6/8SuZYmolCpOCCZAA5GE6cqFLul0rwYrS3iprAuk794crgpHY3vFL2Tb75A2XR
         JZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D0A/Cc8hdMaD+El6MEJZ9FzF6kVCbUYdGbS7BSYWv4w=;
        b=QJKq5EF8GpQH27va8/COkFctP2K/H6ScNge+MpqrovF5eNFdcjSxcyXBbHl+0OR4xf
         Fuo7lT5s0Q+RpbWOpwtMYFDbjroJt2x8HqS5tVRVd0MlHRzM7UM+Lg20BWeTPeBfT1wJ
         nBb0C/qgbimIHoOVzYyfcr30654dT/XoTMeWEs+rBpQkgHynql8ChJKlpAC5oyt53esQ
         OHo8TODbKvrKmO0iJRka0gKyLYf8RYMh5vx6bSLArnZ+i+JmdqXhYfIjdnuXgEzVh2hC
         YKL65iyaHggNGarnWC2T/FEzunkZD6eI3EoxujVeH3IXrrrkI8Z1J7LoWAz8f5sziwJ4
         OUOg==
X-Gm-Message-State: AOAM531GMYQRD3+KXwkmtsxWXLQQ5Nb5gH3YAKxOXmfr5Rbp3AfVNEBl
        coGvbs8rzNwSSuJmqZTURn3eJnXJtITehOsNKvE=
X-Google-Smtp-Source: ABdhPJy7X8xEM0mRN216J13+4z5ETcTQ82rtD13krpuxydWpZkgJfC//7QPJuvw7BKq2lXMejWyUIb5z9RE1nXzeb+A=
X-Received: by 2002:a63:fd44:: with SMTP id m4mr14939217pgj.233.1617995587894;
 Fri, 09 Apr 2021 12:13:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAJht_ENNvG=VrD_Z4w+G=4_TCD0Rv--CQAkFUrHWTh4Cz_NT2Q@mail.gmail.com>
 <20210409073046.GI3697@techsingularity.net> <CAJht_EPXS3wVoNyaD6edqLPKvDTG2vg4qxiGuWBgWpFsNhB-4g@mail.gmail.com>
 <20210409084436.GK3697@techsingularity.net> <CAJht_EPrdujG_0QHM1vc2yrgwwKMQiFzUAK2pgR4dS4z9-Xknw@mail.gmail.com>
 <87ab3d13-f95d-07c5-fc6a-fb33e32685e5@gmail.com> <CAJht_EOmcOdKGKnoUQDJD-=mnHOK0MKiV0+4Epty5H5DMED-qw@mail.gmail.com>
 <3c79924f-3603-b259-935a-2e913dc3afcd@gmail.com>
In-Reply-To: <3c79924f-3603-b259-935a-2e913dc3afcd@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 9 Apr 2021 12:12:57 -0700
Message-ID: <CAJht_EN_N=H8xwVkTT7WiwmdRTeD-L+tM3Z6hu86ebbT_JpBDw@mail.gmail.com>
Subject: Re: Problem in pfmemalloc skb handling in net/core/dev.c
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Mel Gorman <mgorman@suse.de>, jslaby@suse.cz,
        Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 9, 2021 at 4:50 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> On 4/9/21 12:14 PM, Xie He wrote:
>
> Then simply copy the needed logic.

No, there's no such thing as "sockets" in some of the protocols. There
is simply no way to copy "the needed logic".

> > Also, I think this is a problem in net/core/dev.c, there are a lot of
> > old protocols that are not aware of pfmemalloc skbs. I don't think
> > it's a good idea to fix them one by one.
> >
>
> I think you are mistaken.
>
> There is no problem in net/core/dev.c really, it uses
> skb_pfmemalloc_protocol()

This is exactly what I'm talking about. "skb_pfmemalloc_protocol"
cannot guarantee pfmemalloc skbs are not delivered to unrelated
protocols, because "__netif_receive_skb" will sometimes treat
pfmemalloc skbs as normal skbs.

> pfmemalloc is best effort really.
>
> If a layer store packets in many long living queues, it has to drop pfmemalloc packets,
> unless these packets are used for swapping.

Yes, the code of "net/core/dev.c" has exactly this problem. It doesn't
drop pfmemalloc skbs in some situations, and instead deliver them to
unrelated protocols, which clearly have nothing to do with swapping.

I'm not sure if you understand what I'm saying. Please look at the
code of "__netif_receive_skb" and see what will happen when
"sk_memalloc_socks()" is false and "skb_pfmemalloc(skb)" is true.
