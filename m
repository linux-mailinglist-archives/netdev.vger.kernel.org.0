Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EF92F53A0
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbhAMTt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 14:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728555AbhAMTt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 14:49:57 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCB5C061575;
        Wed, 13 Jan 2021 11:49:17 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id i24so3233024edj.8;
        Wed, 13 Jan 2021 11:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hum8GyG3YMlF2j+bxEQbnrEJdDI8ZwOXjUuAUt+nY5o=;
        b=nyp9gl2zbAqKPACHRjRmZ6TXdtLeiEsBNMwfT3WGY+fCYVRR+c1leQub87DsLVeJfq
         9NWb113ao8Eu34k9t8uRuezckTJ/iJhhD1vXiY3bq3Z1RUns4FgxxA8vhShVZQC+gFD4
         Xt5UnainWHnatCq2QeBDPdnpIAYN+lFPOpAgok7mZDkcKkwRs+OJWgbEOi+N43JWS3zM
         MROQgfyGprzFpIoKPPOxBqD6sJFKkJwWeN7ckn72dcS/RMONnGn7EaZMHK2PdcBbSyoX
         6kyYuFnIpRCW7mPzT+ptucYB832V5x4L7njN+eCOZUlfHZy/RmkBpy6lCl6LFCShJHSR
         OTsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hum8GyG3YMlF2j+bxEQbnrEJdDI8ZwOXjUuAUt+nY5o=;
        b=PeNZDDLivyIk6KnzkPXb+jHNC1XOMeJRnj4kerDjtuMtSYYJ4Ve74EKpy4ZlBiBF2S
         DoTpRon8gN9f6siSlw3M835MgkwPE14xaee60BFgiVkUix16lYUybYfJrhP/XSwEorog
         9uu4TOnqzu8em9I/YTjKXn83uew/ky1ARvnu4PU7X2KcAkvls89uv3gt5nHjtQ6pq4Zo
         kPtEKmLPWwQoPgjaDqHtpKAUJzz5+ecQ/wpNIxWllI5JgwvyAixKvRzi1DRFzfjY6dQ4
         mjk5O39G4rHgsyQoetQdm2b0TKo+tsnuSr99a71bKKRosta04gxBaYZijSCZ9Kj817uj
         qomQ==
X-Gm-Message-State: AOAM532uXkgvqrCkDDrdLJNn2Nx6yEeFq9aSi8FqOAGVG07MuBRERVo5
        mSuVznt8OXDX+o6qQ0i20IJN7ceQpqI85M6gAukKQK46a2tWog==
X-Google-Smtp-Source: ABdhPJyJaxgJMfUXIfDa3mHs8m3ahoENpeSe735GUb4ZErj5SmpdGwF3yo0BrKjfh5HDkbATF/1dB2+wWsP+ziud/8A=
X-Received: by 2002:a05:6402:1c8a:: with SMTP id cy10mr3106450edb.151.1610567356100;
 Wed, 13 Jan 2021 11:49:16 -0800 (PST)
MIME-Version: 1.0
References: <20210112214105.1440932-1-shakeelb@google.com> <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
 <20210112234822.GA134064@carbon.dhcp.thefacebook.com> <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
 <CALvZod4am_dNcj2+YZmraCj0+BYHB9PnQqKcrhiOnV8gzd+S3w@mail.gmail.com>
 <20210113184302.GA355124@carbon.dhcp.thefacebook.com> <CALvZod4V3M=P8_Z14asBG8bKa=mYic4_OPLeoz5M7J5tsx=Gug@mail.gmail.com>
In-Reply-To: <CALvZod4V3M=P8_Z14asBG8bKa=mYic4_OPLeoz5M7J5tsx=Gug@mail.gmail.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Wed, 13 Jan 2021 11:49:02 -0800
Message-ID: <CAHbLzkrqX9mJb0E_Y4Q76x=bZpg3RNxKa3k8cG_NiU+++1LWsQ@mail.gmail.com>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
To:     Shakeel Butt <shakeelb@google.com>
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

On Wed, Jan 13, 2021 at 11:13 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Wed, Jan 13, 2021 at 10:43 AM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Tue, Jan 12, 2021 at 04:18:44PM -0800, Shakeel Butt wrote:
> > > On Tue, Jan 12, 2021 at 4:12 PM Arjun Roy <arjunroy@google.com> wrote:
> > > >
> > > > On Tue, Jan 12, 2021 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
> > > > >
> > > [snip]
> > > > > Historically we have a corresponding vmstat counter to each charged page.
> > > > > It helps with finding accounting/stastistics issues: we can check that
> > > > > memory.current ~= anon + file + sock + slab + percpu + stack.
> > > > > It would be nice to preserve such ability.
> > > > >
> > > >
> > > > Perhaps one option would be to have it count as a file page, or have a
> > > > new category.
> > > >
> > >
> > > Oh these are actually already accounted for in NR_FILE_MAPPED.
> >
> > Well, it's confusing. Can't we fix this by looking at the new page memcg flag?
>
> Yes we can. I am inclined more towards just using NR_FILE_PAGES (as
> Arjun suggested) instead of adding a new metric.

IMHO I tend to agree with Roman, it sounds confusing. I'm not sure how
people relies on the counter to have ballpark estimation about the
amount of reclaimable memory for specific memcg, but they are
unreclaimable. And, I don't think they are accounted to
NR_ACTIVE_FILE/NR_INACTIVE_FILE, right? So, the disparity between
NR_FILE_PAGES and NR_{IN}ACTIVE_FILE may be confusing either.

>
