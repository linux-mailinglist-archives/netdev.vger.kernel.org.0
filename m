Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F872359B76
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 12:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbhDIKLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 06:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbhDIKJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 06:09:20 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25804C0613E9;
        Fri,  9 Apr 2021 03:08:29 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so4760353pjb.0;
        Fri, 09 Apr 2021 03:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n7cLDIdYcgU+mE5TUxJG9IpNvG+bT4Z9CaGQY0UABEM=;
        b=eO1g9mHi9rw1lcqt+vPW/flltV4uWv6nPOUvg6TJmcq62yHCCkFDBynbBSmIKt5xGw
         InHhSvkBgKbuJwxbpTuUBD1Ww8lI8Bvf/f6ACS9N9adDcmL0PEcll3eII8hZPIT4u2lM
         SWcLBK+zHMg6Mm3NVjplADrMbDa9/lrQ2J4wdCkOnLkJMPnHhyVSieRV0I+fJWoRS1RP
         Y5vVMC/7qOoINS0zffsOZVYo1QQAHciIJ2ny+AFQfIfrSePxjAHEA/VVX44MFXI5q/1K
         gMzZFUDPpjn1J0pLfCK/7lgzSGgKG9hZRGddg2oBOEQNo67k0Nx9tYCs6g7S58KeFUS4
         opiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n7cLDIdYcgU+mE5TUxJG9IpNvG+bT4Z9CaGQY0UABEM=;
        b=t2mRTRMWlO8k2mDWFms2/YM80IhUPLZacYBWRPCXLsGjPBZ6Vg23Q/SwjDTlci1AFi
         PkNaDXGOnfkKotsEeqikGMAmNS1JLHV7GXs/g6eiGbTVTFd2IJvkDRK8HjADAJTHKzMU
         7tqihTY3duIphtD4P4DCJt0+GdeV0rEIOlqWqrpz6s7KF7nflVchCBQJQo6CTDUl/PKA
         TgB8gIasVOck3Wac/uBUSqGFfJPevF2Zq01e3hxPS7XCqKpOp496rAjKocZuNlDxdAT7
         QsnAfD2O4BmxqRCsBlHlAoMoHdecW2Nx3SH97949RdK+PwZW52fL8l/4flPX+g2bCz3B
         beyQ==
X-Gm-Message-State: AOAM531RsBTktQcKOQLG30Lw7vbyr9WqL7uCx3M/b95oSEo90iaZBULq
        AAMAnJPBFuNxfxjehnusi0GVvyNxA3h3aAwOWCM=
X-Google-Smtp-Source: ABdhPJwPyj4MH1bwqianuKmRYQPS7KJxJKjIvxVO1ksn9/Xhg021RDm2ZdHh3WSHu1AQEegl28yAOLheWOITv4WmkSw=
X-Received: by 2002:a17:90a:28a1:: with SMTP id f30mr13337448pjd.198.1617962908715;
 Fri, 09 Apr 2021 03:08:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAJht_ENNvG=VrD_Z4w+G=4_TCD0Rv--CQAkFUrHWTh4Cz_NT2Q@mail.gmail.com>
 <20210409073046.GI3697@techsingularity.net> <CAJht_EPXS3wVoNyaD6edqLPKvDTG2vg4qxiGuWBgWpFsNhB-4g@mail.gmail.com>
 <20210409084436.GK3697@techsingularity.net> <CAJht_EPrdujG_0QHM1vc2yrgwwKMQiFzUAK2pgR4dS4z9-Xknw@mail.gmail.com>
 <20210409095808.GL3697@techsingularity.net>
In-Reply-To: <20210409095808.GL3697@techsingularity.net>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 9 Apr 2021 03:08:17 -0700
Message-ID: <CAJht_EOfz8EAVA67kOF6cQp6w_enP=hgje_bR4332M3254eS1g@mail.gmail.com>
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

On Fri, Apr 9, 2021 at 2:58 AM Mel Gorman <mgorman@techsingularity.net> wrote:
>
> On Fri, Apr 09, 2021 at 02:14:12AM -0700, Xie He wrote:
> >
> > Do you mean that at the time "sk_memalloc_socks()" changes from "true"
> > to "false", there would be no in-flight skbs currently being received,
> > and all network communications have been paused?
>
> Not all network communication, but communication with swap devices
> should have stopped once sk_memalloc_socks is false.

But all incoming network traffic can be allocated as pfmemalloc skbs,
regardless whether or not it is related to swap devices. My protocols
don't need and cannot handle pfmemalloc skbs, therefore I want to make
sure my protocols never receive pfmemalloc skbs. The current code
doesn't seem to guarantee this.
