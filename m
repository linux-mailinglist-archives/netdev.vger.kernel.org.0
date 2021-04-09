Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94E53598F2
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 11:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhDIJOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 05:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhDIJOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 05:14:37 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F01C061760;
        Fri,  9 Apr 2021 02:14:23 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id ha17so2584828pjb.2;
        Fri, 09 Apr 2021 02:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zyn0v8VHNSt10C0c79WNCNslEHbK5LS2BgYTYzoSTto=;
        b=Z+EM58uTFZB0WfxWBoZgXm1rV+wqH+MD265vRZGRvBt2lnPXxfpv3Irp+y6P2S+hNc
         MagwcwFP06i2OCwTga7ui4HZh30VjiAMYfo5VGidkItC6EY6hm87PxVxQPq8Et1x/sDd
         CXO65t56bJSN+9VeJOfCHforq2+J7qsG4i2MmZyrvpTHDvYdCtMG1No8KSMHzW0iY6qw
         w6haF4uaIRc2eiQrwwuqsPiiuGigQaLwSK90Nxxy8ApM26Y5aOKS0Y7imjhJ9QyBdLNg
         bvBUDi2SH8tF3Sc0pi5KlaCyphSHlsLXK4BozKHbYa/JlV+aIOkxnKx7gHIYV3RhzlSZ
         vglA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zyn0v8VHNSt10C0c79WNCNslEHbK5LS2BgYTYzoSTto=;
        b=fFqsbF5DNFcu6Pxz4jhcvan/Jx/wy+lT5GYw3PIMvrmsOVXO3240ByV8moOVC2iRVY
         BvKsAM3Hb5BqH/9pLCDvZkCgicdYHea587pgsmguGpZHaR+uz4P6iiSntSwVLWzWTmC7
         d5gVAMeE+O2HAl9zr/NKLPlfG3Ip6cKWxmrddyHQXikSWoSoSPx/aG1TgPlvYR+viTRy
         jae07rz1kH2bT3oDknyVzjwji+RdsEpnv42QeP7hHF5c9iYgwZL7Sv/FYJNNrOSKPLXF
         vSp6fRpTIRj3UAhBXwKiL/moc0ZRceJztWpyE7emGT1XqjAUkSwl0PsWcNfnJTAhMygr
         cF1w==
X-Gm-Message-State: AOAM531XHb84SzBj18RRATTPdX/zJgL/jFO9cezQEVVH/Ww7Ey0ppndz
        yAPaZJxP/sxXesVXtX6lNx9Bf+WRURXegSq05LKQ87EjCuc=
X-Google-Smtp-Source: ABdhPJy/AA3ulhim/XIxjIBhMsExnGf3HeSEWrdBkUtJl31Do2iOAecRggS+i3hLQ9XkgQB+NDJ5CgzU69yLHtaeEMw=
X-Received: by 2002:a17:902:848a:b029:e9:914b:7421 with SMTP id
 c10-20020a170902848ab02900e9914b7421mr7011078plo.78.1617959663079; Fri, 09
 Apr 2021 02:14:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAJht_ENNvG=VrD_Z4w+G=4_TCD0Rv--CQAkFUrHWTh4Cz_NT2Q@mail.gmail.com>
 <20210409073046.GI3697@techsingularity.net> <CAJht_EPXS3wVoNyaD6edqLPKvDTG2vg4qxiGuWBgWpFsNhB-4g@mail.gmail.com>
 <20210409084436.GK3697@techsingularity.net>
In-Reply-To: <20210409084436.GK3697@techsingularity.net>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 9 Apr 2021 02:14:12 -0700
Message-ID: <CAJht_EPrdujG_0QHM1vc2yrgwwKMQiFzUAK2pgR4dS4z9-Xknw@mail.gmail.com>
Subject: Re: Problem in pfmemalloc skb handling in net/core/dev.c
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Mel Gorman <mgorman@suse.de>, jslaby@suse.cz,
        Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
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

On Fri, Apr 9, 2021 at 1:44 AM Mel Gorman <mgorman@techsingularity.net> wrote:
>
> That would imply that the tap was communicating with a swap device to
> allocate a pfmemalloc skb which shouldn't happen. Furthermore, it would
> require the swap device to be deactivated while pfmemalloc skbs still
> existed. Have you encountered this problem?

I'm not a user of swap devices or pfmemalloc skbs. I just want to make
sure the protocols that I'm developing (not IP or IPv6) won't get
pfmemalloc skbs when receiving, because those protocols cannot handle
them.

According to the code, it seems always possible to get a pfmemalloc
skb when a network driver calls "__netdev_alloc_skb". The skb will
then be queued in per-CPU backlog queues when the driver calls
"netif_rx". There seems to be nothing preventing "sk_memalloc_socks()"
from becoming "false" after the skb is allocated and before it is
handled by "__netif_receive_skb".

Do you mean that at the time "sk_memalloc_socks()" changes from "true"
to "false", there would be no in-flight skbs currently being received,
and all network communications have been paused?
