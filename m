Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DB92FC90E
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbhATDdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730450AbhATDcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 22:32:43 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427D6C0613D3
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 19:32:03 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id g3so11762930plp.2
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 19:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fdl7GPtsxeMh7s7EVrXO7P1C9iXb8ZW1ZclmtoYnKZY=;
        b=XRj0OR0yGsv+epSl7d7M4vSTDzOw8TE2P27nx2xkX1druNKB/zY1MLIhPX5bW6xzLD
         9gt4WvlLpPI2Z1J2sD18aHWuVfycYVSh/xRV0qIJClEPF/Fs1mNtP15zXbVLKzFC1e9K
         45o705TxRDXsjPcu12SPKb+4/0hp56TX2USuvEdw6bnS1dAbR2HhTGsf8elVBFPFKkJ0
         sWZ9SbFx/0guJ+yAHlvOGObJoBhPFVMMmZhIDFKy7zgegHpmlReufMXCd9ULz/FaelBU
         yO1xZKXX2wwPO5S9NaDeEUWiMMAycQ4BL2I3G6GpPwiK+S23Q4F4d8MZFA2YOlUFpGO4
         C6mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fdl7GPtsxeMh7s7EVrXO7P1C9iXb8ZW1ZclmtoYnKZY=;
        b=Sl7yXihFd4UyZpquTiThZHfknF2tN4RVp/WIEmVh5U6ejsf292ZmGrZBe5dLUXL/rh
         amkEvJKDwI+y4mSb1NoRkQXhKR7NLRK+S09Ejn9QBgr6XjW3nj3DrsjyvjsTUWnH2x8B
         xVcjgz60IGFhcM9zH7pnw+mpYwvxL/HnDbokevPWvsTeilp3+Qij7r+PtfwyJiK5WNhU
         YtP3QWAKm7hWhNE6VCus/7jbtnmr/p/LHyFFB+2UVaPGr2K5eWnVs836LnewqP5qyDhh
         kpsv4DSfBJERNpNi+8BCB5Jms4Tb9aL27a+GS02XUz1dR6WQNGcZrR/e8hB1tSMI+0nA
         GhKQ==
X-Gm-Message-State: AOAM530hHRJAD1CwSG3l44STja+E2LhncvuEf4NWI1HBiY32GGTceuvi
        suZDU2iidnjheV1jpgyu+aQ8vrbfdDzp5IRke/wHyg==
X-Google-Smtp-Source: ABdhPJyH7oIaEQKW71m8AcdSV/0MkHA8p+HIJbkVuXa4DFarZGJjRUnv3DcyKqny6axTQffACbeml2kgR+geUdLomYE=
X-Received: by 2002:a17:90b:e8f:: with SMTP id fv15mr3298625pjb.178.1611113522609;
 Tue, 19 Jan 2021 19:32:02 -0800 (PST)
MIME-Version: 1.0
References: <20210112214105.1440932-1-shakeelb@google.com> <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
 <20210112234822.GA134064@carbon.dhcp.thefacebook.com> <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
 <CALvZod4am_dNcj2+YZmraCj0+BYHB9PnQqKcrhiOnV8gzd+S3w@mail.gmail.com>
 <20210113184302.GA355124@carbon.dhcp.thefacebook.com> <CALvZod4V3M=P8_Z14asBG8bKa=mYic4_OPLeoz5M7J5tsx=Gug@mail.gmail.com>
 <CAHbLzkrqX9mJb0E_Y4Q76x=bZpg3RNxKa3k8cG_NiU+++1LWsQ@mail.gmail.com> <CALvZod4Ncf4H8VWgetWoRnOWPT4h+QDK_CY+oK11Q4akcs4Eqw@mail.gmail.com>
In-Reply-To: <CALvZod4Ncf4H8VWgetWoRnOWPT4h+QDK_CY+oK11Q4akcs4Eqw@mail.gmail.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Tue, 19 Jan 2021 19:31:51 -0800
Message-ID: <CAOFY-A2C4=fWQB69rmP1Ff1Sh=NLCPKT1kD-Lpq29342YJvaWA@mail.gmail.com>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Yang Shi <shy828301@gmail.com>, Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 11:55 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Wed, Jan 13, 2021 at 11:49 AM Yang Shi <shy828301@gmail.com> wrote:
> >
> > On Wed, Jan 13, 2021 at 11:13 AM Shakeel Butt <shakeelb@google.com> wrote:
> > >
> > > On Wed, Jan 13, 2021 at 10:43 AM Roman Gushchin <guro@fb.com> wrote:
> > > >
> > > > On Tue, Jan 12, 2021 at 04:18:44PM -0800, Shakeel Butt wrote:
> > > > > On Tue, Jan 12, 2021 at 4:12 PM Arjun Roy <arjunroy@google.com> wrote:
> > > > > >
> > > > > > On Tue, Jan 12, 2021 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
> > > > > > >
> > > > > [snip]
> > > > > > > Historically we have a corresponding vmstat counter to each charged page.
> > > > > > > It helps with finding accounting/stastistics issues: we can check that
> > > > > > > memory.current ~= anon + file + sock + slab + percpu + stack.
> > > > > > > It would be nice to preserve such ability.
> > > > > > >
> > > > > >
> > > > > > Perhaps one option would be to have it count as a file page, or have a
> > > > > > new category.
> > > > > >
> > > > >
> > > > > Oh these are actually already accounted for in NR_FILE_MAPPED.
> > > >
> > > > Well, it's confusing. Can't we fix this by looking at the new page memcg flag?
> > >
> > > Yes we can. I am inclined more towards just using NR_FILE_PAGES (as
> > > Arjun suggested) instead of adding a new metric.
> >
> > IMHO I tend to agree with Roman, it sounds confusing. I'm not sure how
> > people relies on the counter to have ballpark estimation about the
> > amount of reclaimable memory for specific memcg, but they are
> > unreclaimable. And, I don't think they are accounted to
> > NR_ACTIVE_FILE/NR_INACTIVE_FILE, right? So, the disparity between
> > NR_FILE_PAGES and NR_{IN}ACTIVE_FILE may be confusing either.
> >
>
> Please note that due to shmem/tmpfs there is already disparity between
> NR_FILE_PAGES and NR_{IN}ACTIVE_FILE.
>
> BTW I don't have a strong opinion against adding a new metric. If
> there is consensus we can add one.

Just wanted to see if there were any thoughts/consensus on what the
best way to proceed is - should there be a v2 patch with specific
changes? Or is NR_FILE_PAGES alright?

And similar query, for pre-charging vs. post charging.

Thanks,
-Arjun
