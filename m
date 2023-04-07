Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC226DA6AB
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 02:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjDGAqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 20:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjDGAqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 20:46:09 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DA87282
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 17:46:08 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id bd22so101940ljb.5
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 17:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680828366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VCpn3WG7H6KmNHGScUmrryWWecp3lG8wCaiePQXq9sQ=;
        b=H3clWdZ0/d//TeRtLLXayAJOn/vh2ti2T1xtcF4z5+F8OTUkUIMeXVKqYaYNvukRBG
         QXCWtDOWqcNjuNU9JAREKhWkyKkw9SgjjYtn1mJWzglOiYYwQgIOVHtish5JPkiyekwA
         Blvk94lmt2hrTb1oEQyoq5QjWZfvCJxirOlTemLpEnmWDMy2MB/FG5s1s1bCqid7w52F
         PcqO87k//XWeu1yFly1PdJocWAoHykp2l7n0TqKu3eqT6w4WwXn8BWPh2oYQSnoRJG+j
         0AJMN8OBBiJnK4kEXp+nLO/AB/6YdLOJ0/OgZ2rR+cVR81B7h7E5nXWyY8qantEdsFMO
         1laA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680828366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VCpn3WG7H6KmNHGScUmrryWWecp3lG8wCaiePQXq9sQ=;
        b=MvIENm6UhyyThxUKKwmiR6oEKxlOIn5aq6fhOrBf7g92I3WLIofFt3yrpKtln6Gz/P
         xQA7Hh/36IN811/lVvd6OfvMg6TkShV1rLlTINEIzUGQO+ifGvyPLL/wAHi39JwXNeQQ
         dCsNc7aHVW08MC62NgPZpyTpEMI/r/fKNTdiRlb9GRhZM4aaM4Wpu3gUy3Lqoj1MXXAY
         9rhS2fyq0aUvRVeMyQUwv3LK1q8a6lgMaAzihrKNkNKUsthCJp/U8xzzBFNP0sp4Av4L
         D/wLrVv7F62If2Q78fOlKbeQjCmPIjqBAxnD30No4Z0dyGcStMkleMnE0C378GKSTLjz
         6j+g==
X-Gm-Message-State: AAQBX9fL9qsmL905KEz16B9UfoniH4+LP4M4MABe+D/FNPGWr9TNsFY1
        AibDXgtS7XJoeMeNF2aSBQuGkjDDBj4+5F5NJ4I=
X-Google-Smtp-Source: AKy350asgh616CwqWqrPwmqQImnXlPg3XGzldwoN+dHO9D4C8jsI/m4HJtfyZ8E5j4ttjnUqgSQ1GvcADsiCpJEoB/s=
X-Received: by 2002:a2e:93c3:0:b0:29b:ebfa:765d with SMTP id
 p3-20020a2e93c3000000b0029bebfa765dmr103541ljh.1.1680828366142; Thu, 06 Apr
 2023 17:46:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230404074733.22869-1-liangchen.linux@gmail.com>
 <7331d6d3f9044e386e425e89b1fc32d60b046cf3.camel@gmail.com>
 <20230404182116.5795563c@kernel.org> <CAKhg4tLnSOxB7eeMqna1K3cmOn30cofxH=duOPLRs0h+59j01w@mail.gmail.com>
 <CAKgT0UfPvkiRSqxOjDUsEVapSbtV++AqSLctZHKKs=_gSxtWfA@mail.gmail.com>
 <CAKhg4t+omfRPP3pe4Suq65GiJCT2QtpB=6f+T=dWrmu7_SrZZQ@mail.gmail.com>
 <CANn89iJwMOAD_r+4eUpV65PmhMoSHbr0GOE-WA0APZDh3zpiPQ@mail.gmail.com>
 <CAC_iWjJD-g34ABOhu8f9wMLF0a9YYAZdh_uh2Vq44C-fAU3Nag@mail.gmail.com>
 <CAKhg4tK0D2CqbcCm5TW6LeoBuyQKq7ThrQTS7fLHBUXfoFe1XA@mail.gmail.com> <20230406075908.5ebcb5a0@kernel.org>
In-Reply-To: <20230406075908.5ebcb5a0@kernel.org>
From:   Liang Chen <liangchen.linux@gmail.com>
Date:   Fri, 7 Apr 2023 08:45:53 +0800
Message-ID: <CAKhg4tKT=LqohZi1RHhY1_dJjFbO6WvwZJRtUDM5rrZ7Xuqskw@mail.gmail.com>
Subject: Re: [PATCH] skbuff: Fix a race between coalescing and releasing SKBs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>, hawk@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 6, 2023 at 10:59=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Thu, 6 Apr 2023 19:54:23 +0800 Liang Chen wrote:
> > > > Same feeling on my side.
> > > > I prefer not trying to merge mixed pp_recycle skbs "just because we
> > > > could" at the expense
> > > > of adding more code in a fast path.
> > >
> > > +1 here.  The intention of recycling was to affect the normal path as
> > > less as possible.  On top of that, we've some amount of race
> > > conditions over the years, trying to squeeze more performance with
> > > similar tricks.  I'd much rather be safe here, since recycling by
> > > itself is a great performance boost
> >
> > Sorry, I didn't check my inbox before sending out the v2 patch.
>
> I can discard v2 from patchwork, let's continue the conversation
> here.
>
> > Yeah, It is a bit complicated as we expected. The patch is sent out.
> > Please take a look to see if it is the way to go, or We should stay
> > with the current patch for simplicity reasons. Thanks!
>
> Sounds like you know what Eric and Ilias agreed with, I'm a bit
> confused.. are we basically going back to v1? (hopefully with coding
> style fixed)

Sorry for making the confusion. I just felt the v2 patch complicated
the code a bit.  I am not quite sure if the performance gain justifies
the added complexity, and would really appreciate it if you could make
the decision on which patch to pick up. Thanks a lot!
