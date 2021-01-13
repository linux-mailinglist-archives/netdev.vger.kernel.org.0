Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97672F53B8
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbhAMT4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 14:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728450AbhAMT4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 14:56:04 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F081C061795
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 11:55:24 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id n8so3936105ljg.3
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 11:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V0bs1fi/eE8isvmmJjMQkUZIf1rb+BYIcBHJLO1oqcE=;
        b=fU8xQWv0qAos49JfkFhq/SvSl9DKk4R3hCOQ4ZYyfA3JjIvM9fSyygUqQVtmaCvUzT
         O02v3DcrsaONKGxXgfUbBgPNgmFjvw9UrWHP+BT4AjzOrGrt/vGx+rxIEnYp/JjOFSsf
         8cCMDfNLPbBE4L6R+FHyQBO4n/+akvzeZSp1rYbjjaAfNWmetJ+OPJz40voyNp+rxEKM
         YNd5erKC9LZ3UfjpbuWOFRFIy1I4p9ki2KTunusZzgU6DEAyjCNvmyMOi3ZKUyHVswc0
         rSPFYJd779xIcQOtVoL5Cp0NZZZK9bK59dRQ9lBsm0masjFs4u3FVlh2SUw7SCXNb3Ox
         0jcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V0bs1fi/eE8isvmmJjMQkUZIf1rb+BYIcBHJLO1oqcE=;
        b=iEYzcQuehTrLT+PZ+PgpsuM1yJmRIWWqCnlMk9+uXe90GtXM+3/3+0Qbmf59OLd8A+
         MMPf+ePsTvYsKtx8PVaCXAdx6pc71MK+J2IaSBh6ygsc8eGJurqTVeMO9i6aFLmlaTgl
         2OZrXqU6Z6wHi3YVVHz4VpB5vinazFO1y92YgbrHWEjUJKyhWKTjSzuKb0ctnOn2Vcqr
         AqfhFK1QBsRnc2+/7g3m6p3M1ainVlJMhaghR5/+eELqNJQ+PlFzRp7CfjnnoiF3S0jP
         n62phAiG6t2j1UYQRu7b0vPbwuVqniO2JpbV5yIlc3WlyIrx1JYr2p2m73WTL+sro2/K
         H0+A==
X-Gm-Message-State: AOAM531yDJcJ4D3JoLmHqiqPlm9o63r8SF0oQF1uyNtE/8f6KIr0qbqk
        /V7/xLzK24+S7hhurhfG7jL6ZLDOUyhPYax6dXbfCA==
X-Google-Smtp-Source: ABdhPJzpKHbnFV0lFf5tfz8ktI8u8IjUm7QAokZ+THXeZEzaW2cWimQTsgN22rWUbtrNTtMpaJrNsDZ2I7PV4RQ3cA0=
X-Received: by 2002:a2e:9a84:: with SMTP id p4mr1506293lji.160.1610567722324;
 Wed, 13 Jan 2021 11:55:22 -0800 (PST)
MIME-Version: 1.0
References: <20210112214105.1440932-1-shakeelb@google.com> <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
 <20210112234822.GA134064@carbon.dhcp.thefacebook.com> <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
 <CALvZod4am_dNcj2+YZmraCj0+BYHB9PnQqKcrhiOnV8gzd+S3w@mail.gmail.com>
 <20210113184302.GA355124@carbon.dhcp.thefacebook.com> <CALvZod4V3M=P8_Z14asBG8bKa=mYic4_OPLeoz5M7J5tsx=Gug@mail.gmail.com>
 <CAHbLzkrqX9mJb0E_Y4Q76x=bZpg3RNxKa3k8cG_NiU+++1LWsQ@mail.gmail.com>
In-Reply-To: <CAHbLzkrqX9mJb0E_Y4Q76x=bZpg3RNxKa3k8cG_NiU+++1LWsQ@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 13 Jan 2021 11:55:11 -0800
Message-ID: <CALvZod4Ncf4H8VWgetWoRnOWPT4h+QDK_CY+oK11Q4akcs4Eqw@mail.gmail.com>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
To:     Yang Shi <shy828301@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>, Arjun Roy <arjunroy@google.com>,
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

On Wed, Jan 13, 2021 at 11:49 AM Yang Shi <shy828301@gmail.com> wrote:
>
> On Wed, Jan 13, 2021 at 11:13 AM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > On Wed, Jan 13, 2021 at 10:43 AM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > On Tue, Jan 12, 2021 at 04:18:44PM -0800, Shakeel Butt wrote:
> > > > On Tue, Jan 12, 2021 at 4:12 PM Arjun Roy <arjunroy@google.com> wrote:
> > > > >
> > > > > On Tue, Jan 12, 2021 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
> > > > > >
> > > > [snip]
> > > > > > Historically we have a corresponding vmstat counter to each charged page.
> > > > > > It helps with finding accounting/stastistics issues: we can check that
> > > > > > memory.current ~= anon + file + sock + slab + percpu + stack.
> > > > > > It would be nice to preserve such ability.
> > > > > >
> > > > >
> > > > > Perhaps one option would be to have it count as a file page, or have a
> > > > > new category.
> > > > >
> > > >
> > > > Oh these are actually already accounted for in NR_FILE_MAPPED.
> > >
> > > Well, it's confusing. Can't we fix this by looking at the new page memcg flag?
> >
> > Yes we can. I am inclined more towards just using NR_FILE_PAGES (as
> > Arjun suggested) instead of adding a new metric.
>
> IMHO I tend to agree with Roman, it sounds confusing. I'm not sure how
> people relies on the counter to have ballpark estimation about the
> amount of reclaimable memory for specific memcg, but they are
> unreclaimable. And, I don't think they are accounted to
> NR_ACTIVE_FILE/NR_INACTIVE_FILE, right? So, the disparity between
> NR_FILE_PAGES and NR_{IN}ACTIVE_FILE may be confusing either.
>

Please note that due to shmem/tmpfs there is already disparity between
NR_FILE_PAGES and NR_{IN}ACTIVE_FILE.

BTW I don't have a strong opinion against adding a new metric. If
there is consensus we can add one.
