Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EF21DF626
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 10:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387695AbgEWIzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 04:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387627AbgEWIzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 04:55:44 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823CEC061A0E;
        Sat, 23 May 2020 01:55:43 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f5so4021231wmh.2;
        Sat, 23 May 2020 01:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ip4CdvVdeoliE+WLGXA2mvtdacmG1QBAN4qXqyjKjP0=;
        b=ESbBjCgSnogehYN17cUuf2zXR4yovMUkuQVozbbuLxqQqr2FT4lzO0rs7DuTiUfAF8
         xa9Q/s9EtyKEt21VoYT6cons5fdqLggXx6cIVEq6owmOZTjKOn7iAyDjXOfaHa1+iNTG
         lm6eMaCeVcwJRLAp2s414DsBy7gev0XG+Wdfgv++7UfjUZN9UId7imqygzaZPSSXFrA0
         LF6CVN8Z5hAfY10wDBQSFrk0KrkFEbGKAi6UPpFi6cVc2kq0oCU60O5IW6PScr3vEZjx
         CxdjgoPC5Z4CClMR1s0v+vmlU3vXHL9y7z4UrJs/l7ZYpxMHqH8EOpgnSt424J4aH8S0
         S4ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ip4CdvVdeoliE+WLGXA2mvtdacmG1QBAN4qXqyjKjP0=;
        b=jqNaCMZBtlomfOOIFBsF4VJbzN3CvhH+jQpOv4q4lAbUXs+yEvujpfzXnKYCTLSQkL
         R3SAv1aKL3b6SjZC4NOLkaDc+NhLDe5hzOy/S7GvwJhD0ooupzXh/K33KjivB08HeFz6
         nbB+fJcsN/V/5vaqPd5u0e3o5iHZGchQ+72Vc44nlG5VvR4HZeVanguHqzTdaLKzhf/5
         X3UDW8I2sUu15wvtMmE34GY+9lP9IJ8k4AKClVzLD7i3IgmVd5inmmsI0fJtrRhVA2zZ
         2zlKQCKD9BDEAqcZLyAWEopuqDBxuAuj5svNEgPx0bFjLT9T4aAjLvaf5JKPjOLufiNP
         eqsw==
X-Gm-Message-State: AOAM533hN0UwKcI+tWje513sik+87FGA1hRbxfO1ED/B6ZfpMwNeDk6C
        9iWyZ+fza9iLVm8Z+kv3QERsHkYfkiSy5C/jQ0yxblS4
X-Google-Smtp-Source: ABdhPJwDioVwAOIDpTA60Aana+5GWvVPpzNj89PXIHn759+3usEheL9q0w2oJABjscMv7dPiX1I8h94jNQsv8qWU/Yg=
X-Received: by 2002:a05:600c:2258:: with SMTP id a24mr16365171wmm.111.1590224142285;
 Sat, 23 May 2020 01:55:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200421143149.45108-1-yuehaibing@huawei.com> <20200422125346.27756-1-yuehaibing@huawei.com>
 <0015ec4c-0e9c-a9d2-eb03-4d51c5fbbe86@huawei.com> <20200519085353.GE13121@gauss3.secunet.de>
 <CADvbK_eXW24SkuLUOKkcg4JPa8XLcWpp6RNCrQT+=okaWe+GDA@mail.gmail.com>
 <550a82f1-9cb3-2392-25c6-b2a84a00ca33@huawei.com> <CADvbK_cpXOxbWzHzonrzzrrb+Vh3q8NhXnapz0yc9h4H4gN02A@mail.gmail.com>
 <1c4c5d40-1e35-f9bb-3f17-01bb4675f3aa@huawei.com>
In-Reply-To: <1c4c5d40-1e35-f9bb-3f17-01bb4675f3aa@huawei.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 23 May 2020 17:02:38 +0800
Message-ID: <CADvbK_e8ixjGGHRK9A4HcXDGKYcNykneUHzHiE8sQ4ojDz+e-g@mail.gmail.com>
Subject: Re: [PATCH v2] xfrm: policy: Fix xfrm policy match
To:     Yuehaibing <yuehaibing@huawei.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 8:39 PM Yuehaibing <yuehaibing@huawei.com> wrote:
>
> On 2020/5/22 13:49, Xin Long wrote:
> > On Fri, May 22, 2020 at 9:45 AM Yuehaibing <yuehaibing@huawei.com> wrote:
> >>
> >> On 2020/5/21 14:49, Xin Long wrote:
> >>> On Tue, May 19, 2020 at 4:53 PM Steffen Klassert
> >>> <steffen.klassert@secunet.com> wrote:
> >>>>
> >>>> On Fri, May 15, 2020 at 04:39:57PM +0800, Yuehaibing wrote:
> >>>>>
> >>>>> Friendly ping...
> >>>>>
> >>>>> Any plan for this issue?
> >>>>
> >>>> There was still no consensus between you and Xin on how
> >>>> to fix this issue. Once this happens, I consider applying
> >>>> a fix.
> >>>>
> >>> Sorry, Yuehaibing, I can't really accept to do: (A->mark.m & A->mark.v)
> >>> I'm thinking to change to:
> >>>
> >>>  static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
> >>>                                    struct xfrm_policy *pol)
> >>>  {
> >>> -       u32 mark = policy->mark.v & policy->mark.m;
> >>> -
> >>> -       if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
> >>> -               return true;
> >>> -
> >>> -       if ((mark & pol->mark.m) == pol->mark.v &&
> >>> -           policy->priority == pol->priority)
> >>> +       if (policy->mark.v == pol->mark.v &&
> >>> +           (policy->mark.m == pol->mark.m ||
> >>> +            policy->priority == pol->priority))
> >>>                 return true;
> >>>
> >>>         return false;
> >>>
> >>> which means we consider (the same value and mask) or
> >>> (the same value and priority) as the same one. This will
> >>> cover both problems.
> >>
> >>   policy A (mark.v = 0x1011, mark.m = 0x1011, priority = 1)
> >>   policy B (mark.v = 0x1001, mark.m = 0x1001, priority = 1)
> > I'd think these are 2 different policies.
> >
> >>
> >>   when fl->flowi_mark == 0x12341011, in xfrm_policy_match() do check like this:
> >>
> >>         (fl->flowi_mark & pol->mark.m) != pol->mark.v
> >>
> >>         0x12341011 & 0x1011 == 0x00001011
> >>         0x12341011 & 0x1001 == 0x00001001
> >>
> >>  This also match different policy depends on the order of policy inserting.
> > Yes, this may happen when a user adds 2  policies like that.
> > But I think this's a problem that the user doesn't configure it well,
> > 'priority' should be set.
> > and this can not be avoided, also such as:
> >
> >    policy A (mark.v = 0xff00, mark.m = 0x1000, priority = 1)
> >    policy B (mark.v = 0x00ff, mark.m = 0x0011, priority = 1)
> >
> >    try with 0x12341011
> >
> > So just be it, let users decide.
>
> Ok, this make sense.
Thanks Yuehaibing, it's good we're on the same page now.

Just realized the patch I created above won't work for the case:

  policy A (mark.v = 0x10, mark.m = 0, priority = 1)
  policy B (mark.v = 0x1,  mark.m = 0, priority = 2)
  policy C (mark.v = 0x10, mark.m = 0, priority = 2)

when policy C is being added, the warning still occurs.

So I will just check value and priority:
-       u32 mark = policy->mark.v & policy->mark.m;
-
-       if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
-               return true;
-
-       if ((mark & pol->mark.m) == pol->mark.v &&
+       if (policy->mark.v == pol->mark.v &&
            policy->priority == pol->priority)
                return true;

This allows two policies like this exist:

  policy A (mark.v = 0x10, mark.m = 0, priority = 1)
  policy C (mark.v = 0x10, mark.m = 0, priority = 2)

But I don't think it's a problem.
