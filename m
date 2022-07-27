Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855B25834DF
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 23:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbiG0VjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 17:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiG0VjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 17:39:06 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BF04F666
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 14:39:03 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id z19so148519plb.1
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 14:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ItSF/+XU/6Bz4xr/gfqbEOOWPHTOiyfAroNPDdNsq4=;
        b=qzphUGDnWH8nDzTpEAZ/31uJsqS8edbVHUP5fkIZwysfpcmIbc1A2VS2Dxg+Hk69mg
         LjuLkIJMGsAJh+JQLuRxKJIEJ6JswgP8BM2zxIpHLaPwRBQ6E/cQ+R4tCGHKZPfWnP7O
         j/+26CEuJGKORtvSBgXn+oCt6oejYyGrOvw/9If2djk4eIc2Vmj/4tUGacl0NoZZ6opN
         qNeDgCLQARfQZ2/t64obuw1+Vz9qbawLM2yDswQwNDZcO1oyLvg5q03J0yKqWkks9gSi
         TnMX6nUPH0Lj4NlXsgercxvHWWqIpORQmPCvSmnh/cSem8q32TR1/7dHZGtA/HOWaepu
         4HOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ItSF/+XU/6Bz4xr/gfqbEOOWPHTOiyfAroNPDdNsq4=;
        b=iUYXJTx+5p22VB7J8ODGcCFphF1YJfC9K29Kx8Eb3lVtQ/6Rqv0BeZesfxlUbzpVla
         ytJl15KG9MvwtQSf4jugFaP8lDtrxyoPGL9A+Y2cfl/tn+vS00er/nXmCgzQEjO4td1Q
         luQmdaDe86uEFZPYQkvLcVNQgZP3lkfClJ3834DVfgD4QXTRwGOemu+lQjqSiUFt9sm7
         ZbuA46Yv3fcz46duF+DvtP0wDLmCkAV1Z9AZMP9DRyIcsCf92Sx/R+nuq70yG69qTi6k
         yoGmlP9HqK1gXzM6e5l8kKaVk3UychKelWIHsY14XJ+3jjx2zG43FlRuTfsoRmxK+zSV
         9xiQ==
X-Gm-Message-State: AJIora8uPqg3czlOxOFbsEeZ0dJQznybCbJHaieNzY0VKPJi+6aM8++E
        ZE5IJV90CmX2bVzwFD9nRy10EXsyl7AEziU7u5Qu6g==
X-Google-Smtp-Source: AGRyM1twDGQt0oLLpkSM8uhOCWJzANIOAfI41nA6tUFrjIYn5gYgEn97phFN0nr6JP5vwLwD3jc1N+WDL4F1iEkA+2s=
X-Received: by 2002:a17:90b:3887:b0:1f2:bc1f:64d7 with SMTP id
 mu7-20020a17090b388700b001f2bc1f64d7mr6902465pjb.31.1658957943150; Wed, 27
 Jul 2022 14:39:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220727060856.2370358-1-kafai@fb.com> <20220727060909.2371812-1-kafai@fb.com>
 <YuFsHaTIu7dTzotG@google.com> <20220727183700.iczavo77o6ubxbwm@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBt5-p24p9AvuEntb=gRFsJ_UQZ_GX8mFsPZZPq7CgL_4A@mail.gmail.com> <20220727212133.3uvpew67rzha6rzp@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220727212133.3uvpew67rzha6rzp@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 27 Jul 2022 14:38:51 -0700
Message-ID: <CAKH8qBs3jp_0gRiHyzm29HaW53ZYpGYpWbmLhwi87xWKi9g=UA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking
 sk lock when called from bpf
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 2:21 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Jul 27, 2022 at 01:39:08PM -0700, Stanislav Fomichev wrote:
> > On Wed, Jul 27, 2022 at 11:37 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Wed, Jul 27, 2022 at 09:47:25AM -0700, sdf@google.com wrote:
> > > > On 07/26, Martin KaFai Lau wrote:
> > > > > Most of the codes in bpf_setsockopt(SOL_SOCKET) are duplicated from
> > > > > the sock_setsockopt().  The number of supported options are
> > > > > increasing ever and so as the duplicated codes.
> > > >
> > > > > One issue in reusing sock_setsockopt() is that the bpf prog
> > > > > has already acquired the sk lock.  sockptr_t is useful to handle this.
> > > > > sockptr_t already has a bit 'is_kernel' to handle the kernel-or-user
> > > > > memory copy.  This patch adds a 'is_bpf' bit to tell if sk locking
> > > > > has already been ensured by the bpf prog.
> > > >
> > > > Why not explicitly call it is_locked/is_unlocked? I'm assuming, at some
> > > > point,
> > > is_locked was my initial attempt.  The bpf_setsockopt() also skips
> > > the ns_capable() check, like in patch 3.  I ended up using
> > > one is_bpf bit here to do both.
> >
> > Yeah, sorry, I haven't read the whole series before I sent my first
> > reply. Let's discuss it here.
> >
> > This reminds me of ns_capable in __inet_bind where we also had to add
> > special handling.
> >
> > In general, not specific to the series, I wonder if we want some new
> > in_bpf() context indication and bypass ns_capable() from those
> > contexts?
> > Then we can do things like:
> >
> >   if (sk->sk_bound_dev_if && !in_bpf() && !ns_capable(net->user_ns,
> > CAP_NET_RAW))
> >     return ...;
> Don't see a way to implement in_bpf() after some thoughts.
> Do you have idea ?

I wonder if we can cheat a bit with the following:

bool setsockopt_capable(struct user_namespace *ns, int cap)
{
       if (!in_task()) {
             /* Running in irq/softirq -> setsockopt invoked by bpf program.
              * [not sure, is it safe to assume no regular path leads
to setsockopt from sirq?]
              */
             return true;
       }

       /* Running in process context, task has bpf_ctx set -> invoked
by bpf program. */
       if (current->bpf_ctx != NULL)
             return true;

       return ns_capable(ns, cap);
}

And then do /ns_capable/setsockopt_capable/ in net/core/sock.c

But that might be more fragile than passing the flag, idk.

> > Or would it make things more confusing?
> >
> >
> >
> > > > we can have code paths in bpf where the socket has been already locked by
> > > > the stack?
> > > hmm... You meant the opposite, like the bpf hook does not have the
> > > lock pre-acquired before the bpf prog gets run and sock_setsockopt()
> > > should do lock_sock() as usual?
> > >
> > > I was thinking a likely situation is a bpf 'sleepable' hook does not
> > > have the lock pre-acquired.  In that case, the bpf_setsockopt() could
> > > always acquire the lock first but it may turn out to be too
> > > pessmissitic for the future bpf_[G]etsockopt() refactoring.
> > >
> > > or we could do this 'bit' break up (into one is_locked bit
> > > for locked and one is_bpf to skip-capable-check).  I was waiting until a real
> > > need comes up instead of having both bits always true now.  I don't mind to
> > > add is_locked now since the bpf_lsm_cgroup may come to sleepable soon.
> > > I can do this in the next spin.
