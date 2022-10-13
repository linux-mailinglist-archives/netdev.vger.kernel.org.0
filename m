Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749A05FD3E0
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 06:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiJMEgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 00:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiJMEgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 00:36:49 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB3011C27D
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 21:36:47 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-354c7abf786so7798197b3.0
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 21:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MYZC/ZZhrwfqeSKJS7iWNQa4xs9BkuJYpmdkhZqDO3E=;
        b=bD3BNclyP9ltZIweT1HDKFuXx6eb7hOiLH9JVviEPYPhB0sOYPnOgSU66gdF5d75+3
         TlT4HyKkoVhHJB9h5halO2XpqS8djMcIXY4706siHzr/PLKnv112E/jabXR193uN3VcJ
         Q4R2PquNN4OCA4stpjgToiAixsItpkw4Wf/g8xxe6JpEyWsj43y9KYMVQ7VVW1MKEkWD
         MW2SYxDHdUMKQZv2bqCPYKIN999RCky76DYbu1YcIVUDt+yDL3z5STwfNhL9Z+AfZMeT
         aMVhDpXfyfPVhRgip9XUGbp9hhNLyveS8nWaOZwTZWsFXiNOKv9T/2UxcbCCZzKIE1Mm
         UQmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MYZC/ZZhrwfqeSKJS7iWNQa4xs9BkuJYpmdkhZqDO3E=;
        b=zfUXG8PMkDABkNY2ubutFiHNdcsFFtIxNyknvc4ldxPgBVkSWS2iVGQvGJ05sWNBm1
         y0kc48TZ2JwMZQpEAATD58PUlEBsQk1BGJpM1vFiNcpx2ugUg4MTVSCuLfhL1DWR52jw
         3fl/4LhTCVKjscoO4mB7avlwRpCrw336anQm+GONT8yUHdUEyIusOLBCWmLwsa4rfsaG
         ICIEAyG0VePqI+yB3Uo3gqdAL6xotQ9raRRGcOQBF9XZ5FuFwrhh7qr3jlj+dPfRtDw0
         /ka7lPnoDikEefc2U9hB5GPvvvmEEFS723fEH7Nps1N6bLu4mDJtwyaxa642GGDD2kgg
         /ogg==
X-Gm-Message-State: ACrzQf0tx58Y5Rpqt673Gv3N+Hjn/GNDy8WkOojsHL4zex5F63lG5Mg1
        r3xhyW1JTy99SNj1XfMmvhxu/fpB0AGUswEdsMujJvqg4ds=
X-Google-Smtp-Source: AMsMyM4JwARt2gsfW3ADYilWDn1NFUBx3KE68DKqvT23RO3GiX4CqATZEILY6t09XMVmV61nBv6lrhFaSEPDN4pinJk=
X-Received: by 2002:a81:892:0:b0:355:a4c8:f310 with SMTP id
 140-20020a810892000000b00355a4c8f310mr29362922ywi.486.1665635806604; Wed, 12
 Oct 2022 21:36:46 -0700 (PDT)
MIME-Version: 1.0
References: <CANOLnON11vzvVdyJfW+QJ36siWR4-s=HJ2aRKpRy7CP=aRPoSw@mail.gmail.com>
 <CANOLnOPeOi0gxYwd5+ybdv5w=RZEh5JakJPE9xgrSL1cecZHbw@mail.gmail.com>
 <Yv0h1PFxmK7rVWpy@cmpxchg.org> <CALvZod5_LVkOkF+gmefnctmx+bRjykSARm2JA9eqKJx85NYBGQ@mail.gmail.com>
 <CAEA6p_BhAh6f_kAHEoEJ38nunY=c=4WqxhJQUjT+dCSAr_rm8g@mail.gmail.com> <CANOLnONQaHXOp1z1rNum74N2b=Ub7t5NsGHqPdHUQL4+4YYEQg@mail.gmail.com>
In-Reply-To: <CANOLnONQaHXOp1z1rNum74N2b=Ub7t5NsGHqPdHUQL4+4YYEQg@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 12 Oct 2022 21:36:34 -0700
Message-ID: <CALvZod6VaQXrs1x7ff=RRWWP+CgD0hQkTROfZ9XowQ_Zo3SO3Q@mail.gmail.com>
Subject: Re: UDP rx packet loss in a cgroup with a memory limit
To:     =?UTF-8?Q?Gra=C5=BEvydas_Ignotas?= <notasas@gmail.com>
Cc:     Wei Wang <weiwan@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, Aug 17, 2022 at 1:12 PM Gra=C5=BEvydas Ignotas <notasas@gmail.com> =
wrote:
>
> On Wed, Aug 17, 2022 at 9:16 PM Wei Wang <weiwan@google.com> wrote:
> >
> > On Wed, Aug 17, 2022 at 10:37 AM Shakeel Butt <shakeelb@google.com> wro=
te:
> > >
> > > + Eric and netdev
> > >
> > > On Wed, Aug 17, 2022 at 10:13 AM Johannes Weiner <hannes@cmpxchg.org>=
 wrote:
> > > >
> > > > This is most likely a regression caused by this patch:
> > > >
> > > > commit 4b1327be9fe57443295ae86fe0fcf24a18469e9f
> > > > Author: Wei Wang <weiwan@google.com>
> > > > Date:   Tue Aug 17 12:40:03 2021 -0700
> > > >
> > > >     net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()
> > > >
> > > >     Add gfp_t mask as an input parameter to mem_cgroup_charge_skmem=
(),
> > > >     to give more control to the networking stack and enable it to c=
hange
> > > >     memcg charging behavior. In the future, the networking stack ma=
y decide
> > > >     to avoid oom-kills when fallbacks are more appropriate.
> > > >
> > > >     One behavior change in mem_cgroup_charge_skmem() by this patch =
is to
> > > >     avoid force charging by default and let the caller decide when =
and if
> > > >     force charging is needed through the presence or absence of
> > > >     __GFP_NOFAIL.
> > > >
> > > >     Signed-off-by: Wei Wang <weiwan@google.com>
> > > >     Reviewed-by: Shakeel Butt <shakeelb@google.com>
> > > >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > > >
> > > > We never used to fail these allocations. Cgroups don't have a
> > > > kswapd-style watermark reclaimer, so the network relied on
> > > > force-charging and leaving reclaim to allocations that can block.
> > > > Now it seems network packets could just fail indefinitely.
> > > >
> > > > The changelog is a bit terse given how drastic the behavior change
> > > > is. Wei, Shakeel, can you fill in why this was changed? Can we reve=
rt
> > > > this for the time being?
> > >
> > > Does reverting the patch fix the issue? However I don't think it will=
.
> > >
> > > Please note that we still have the force charging as before this
> > > patch. Previously when mem_cgroup_charge_skmem() force charges, it
> > > returns false and __sk_mem_raise_allocated takes suppress_allocation
> > > code path. Based on some heuristics, it may allow it or it may
> > > uncharge and return failure.
> >
> > The force charging logic in __sk_mem_raise_allocated only gets
> > considered on tx path for STREAM socket. So it probably does not take
> > effect on UDP path. And, that logic is NOT being altered in the above
> > patch.
> > So specifically for UDP receive path, what happens in
> > __sk_mem_raise_allocated() BEFORE the above patch is:
> > - mem_cgroup_charge_skmem() gets called:
> >     - try_charge() with GFP_NOWAIT gets called and  failed
> >     - try_charge() with __GFP_NOFAIL
> >     - return false
> > - goto suppress_allocation:
> >     - mem_cgroup_uncharge_skmem() gets called
> > - return 0 (which means failure)
> >
> > AFTER the above patch, what happens in __sk_mem_raise_allocated() is:
> > - mem_cgroup_charge_skmem() gets called:
> >     - try_charge() with GFP_NOWAIT gets called and failed
> >     - return false
> > - goto suppress_allocation:
> >     - We no longer calls mem_cgroup_uncharge_skmem()
> > - return 0
> >
> > So I agree with Shakeel, that this change shouldn't alter the behavior
> > of the above call path in such a situation.
> > But do let us know if reverting this change has any effect on your test=
.
>
> The problem is still there (the kernel wasn't compiling after revert,
> had to adjust another seemingly unrelated callsite). It's hard to tell
> if it's better or worse since it happens so randomly.
>

Hello everyone, we have a better understanding why the patch pointed
out by Johannes might have exposed this issue. See
https://lore.kernel.org/all/20221013041833.rhifxw4gqwk4ofi2@google.com/.

To summarize, the old code was depending on a subtle interaction of
force-charge and percpu charge caches which this patch removed. The
fix I am proposing is for the network stack to be explicit of its need
(i.e. use GFP_ATOMIC) instead of depending on a subtle behavior.
