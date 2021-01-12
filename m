Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E97C2F3DC4
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406947AbhALVhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436916AbhALU1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 15:27:38 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A505C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 12:26:58 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id p187so6872172iod.4
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 12:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oiWOkXc1xI0t8NElnoFoYTlFQTVS3zhw5lONJrLRU9M=;
        b=mHaAJlrQLz+1O9bonKxTL13JZHxSy0YMb3j9mNufAzgzbjrlMoyVSVG61rSQAtp1aC
         gh0EhCe5opEs90pBxa6O1e2CJtbE3kWjeW3yE8YEwme2p5FlYLvAxbtJDMafU8GHDMCS
         aU/kd8irifznfs0MMm5MEf7oG/tgs4ciVOePtzGstwXryo72H6T8RmMR0p0Je2bPyxu1
         3nDKuj9ul/ufZ5gwRGMXsoF+Wq1tQxztBZpTkY9n7bbS6XRxcRQq79k1SfqXstbSAS2U
         OuXdXjxXQw1Lr98YySdp3pXNCFdr9deLKgDrDj8owqNg2rYSXZDL/A2hDdpo18Ei0hoT
         7evQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oiWOkXc1xI0t8NElnoFoYTlFQTVS3zhw5lONJrLRU9M=;
        b=nD+R93qrfB5+SDlXq+TfcKxzJysQwFPsv8VusLcr/20fcfFEmIHTGLxpbhBBOyBlNq
         ikjC8gvDpV+sqhFL6K2b1rr5ZCZPt04r0nt7nZzhzaLqAMPznRJGxpY/F5B7/jBDC0Wf
         1Fw1pZoFNWjQLYNipUIeCxr/els1DGSUuzOlJjj9czqVX7KIrQKxXHw9n4/ypgR3nqR0
         ZXEHL31EYL1jecrwZ9lExFI8lK1ZmRkkM2imo8kR+mCVAC7nO7wRtGjONoV7GM5sJEUX
         P4T/ZTwI6plld81Fkq+9sPk6qjHZouzJlhfxJlLIKwu3u6pdcR4n6Ts2YM8zdYXKrSDz
         NNAg==
X-Gm-Message-State: AOAM530YXnSn8rZ9YZVcj0SFPg3ygt12pkU3XZ5crULtg7pcqSNLiHpR
        EQXWhFyclQwWvw2S6Bbg7/UZDoP9vuWaAkhg5RKvlQ==
X-Google-Smtp-Source: ABdhPJz4ZWJLGUNNpJ9Q7JHz81xV1kNEhCUWH+fUIJCMWv+DpDq+dqDSyOh0HCf3tQ03OkhJSZsWt0bdViiAeOOshk4=
X-Received: by 2002:a05:6e02:42:: with SMTP id i2mr885580ilr.68.1610483217529;
 Tue, 12 Jan 2021 12:26:57 -0800 (PST)
MIME-Version: 1.0
References: <20210111222411.232916-1-hcaldwel@akamai.com> <20210111222411.232916-5-hcaldwel@akamai.com>
 <CANn89iLheJ+a0AZ_JZyitsZK5RCVsadzgsBK=DeHs-7ko5OMuQ@mail.gmail.com>
 <24573.51244.563087.333291@gargle.gargle.HOWL> <CANn89i+1qN6A0vw=unv60VBfxb1SMMErAyfB9jzzHbx49HzE+A@mail.gmail.com>
 <24573.63409.26608.321427@gargle.gargle.HOWL>
In-Reply-To: <24573.63409.26608.321427@gargle.gargle.HOWL>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Jan 2021 21:26:45 +0100
Message-ID: <CANn89iJWkgkF+kKDFnqAO9oMMziZGPe_QYMJvx80AbbTfQFQmQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] tcp: remove limit on initial receive window
To:     Heath Caldwell <hcaldwel@akamai.com>
Cc:     netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Josh Hunt <johunt@akamai.com>, Ji Li <jli@akamai.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 8:25 PM Heath Caldwell <hcaldwel@akamai.com> wrote:
>
> On 2021-01-12 18:05 (+0100), Eric Dumazet <edumazet@google.com> wrote:
> > On Tue, Jan 12, 2021 at 5:02 PM Heath Caldwell <hcaldwel@akamai.com> wrote:
> > >
> > > On 2021-01-12 09:30 (+0100), Eric Dumazet <edumazet@google.com> wrote:
> > > > I think the whole patch series is an attempt to badly break TCP stack.
> > >
> > > Can you explain the concern that you have about how these changes might
> > > break the TCP stack?
> > >
> > > Patches 1 and 3 fix clear bugs.
> >
> > Not clear to me at least.
> >
> > If they were bug fixes, a FIxes: tag would be provided.
>
> The underlying bugs that are addressed in patches 1 and 3 are present in
> 1da177e4c3f4 ("Linux-2.6.12-rc2") which looks to be the earliest parent
> commit in the repository.  What should I do for a Fixes: tag in this
> case?
>
> > You are a first time contributor to linux TCP stack, so better make
> > sure your claims are solid.
>
> I fear that I may not have expressed the problems and solutions in a
> manner that imparted the ideas well.
>
> Maybe I added too much detail in the description for patch 1, which may
> have obscured the problem: val is capped to sysctl_rmem_max *before* it
> is doubled (resulting in the possibility for sk_rcvbuf to be set to
> 2*sysctl_rmem_max, rather than it being capped at sysctl_rmem_max).

This is fine. This has been done forever. Your change might break applications.

I would advise documenting this fact, since existing behavior will be kept
in many linux hosts for years to come.

>
> Maybe I was not explicit enough in the description for patch 3: space is
> expanded into sock_net(sk)->ipv4.sysctl_tcp_rmem[2] and sysctl_rmem_max
> without first shrinking them to discount the overhead.
>
> > > Patches 2 and 4 might be arguable, though.
> >
> > So we have to pick up whatever pleases us ?
>
> I have been treating all of these changes together because they all kind
> of work together to provide a consistent model and configurability for
> the initial receive window.
>
> Patches 1 and 3 address bugs.

Maybe, but will break applications.

> Patch 2 addresses an inconsistency in how overhead is treated specially
> for TCP sockets.
> Patch 4 addresses the 64KB limit which has been imposed.

For very good reasons.

This is going nowhere. I will stop right now.
