Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1D767F285
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 00:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjA0X5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 18:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjA0X5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 18:57:49 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17A986B2
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 15:57:46 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-4fda31c3351so87720827b3.11
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 15:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OhvzF4Mt0/3ilJlZV0Eoro3eFKUhVC9tzpeGW/lUioA=;
        b=inu9CmgELZHVh+LKoal42clI2N1/xAtsPGEkDPbi9fsLY75SyWsgoAOWJli+VKoavt
         FTYx7RgSyWCZ2sAq6xt6OYOWRn15ZZOpiYO3MlXGChwaI+nH8dK4BwUkDBPaKN5OoYDi
         zcyrPWwhJpL6V4QFCiukZgTQZS8loeywEvqmcuz+U6i5l0yVfpDQGoHg7Kd/nmZ6mgnm
         ZpHnKJnPKi9D69Dzgzc2ojYfaEqUmrHJ3BM3sBvFnNYlgUZaLiQt81WTmPMDiBmR4j1t
         hpwGymi6WcvJEyKIj4htADX1hEcDsCkt9WRGmKAyJUHaWf+F9t5OmSyNzm3eh8zBeUGI
         tovA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OhvzF4Mt0/3ilJlZV0Eoro3eFKUhVC9tzpeGW/lUioA=;
        b=OIwVllPUV9elLsLfO9OGAKbCH9KOEuX5B1GmADYBSEVOzz0fE/XyRljNMrMU1oxLrD
         Wk1B++hlIURrzIk+z6L43wWXIuWGOGq+YSdCh9H5kIkNlP4Fe9iN5B+Z9ItNKmQTI4/W
         7HFdBm50QPO8slwgokArbxUXR+TBUAnuMVFTswNvkofzJAzA8o/vNJEiAEX+z0rPOlpt
         CPNE2MONn3ULtOKUVwo0pACSZHtWT9JrPfW9Y7YYIHzHMbYJ9hK3brNsdOI5bwxnacap
         EOOL/rz3qrD7H2N/8De5naOhPkCs8AWnGBvpMn2p/AIQ2oKMvbn2v4AHcWbH74n7OqqX
         dYhQ==
X-Gm-Message-State: AFqh2kqeRAjQih6ckRYxzpmF3JGyvlzYvPJuExqgLh2EJv9vGnb+27WB
        kZ1fFm6P3KWdneYHbBTVMJ3SrMgUUF8kPxJsAw/3wQ==
X-Google-Smtp-Source: AMrXdXt3pehnC+h6txv9NBAVe2zQ+V4+NzG3lHWGM6FjwJm+Fr6q+iWKG2mpvhSLZOywIykP33sppiVoGBOSpaEGeGg=
X-Received: by 2002:a0d:c983:0:b0:39f:ddab:af27 with SMTP id
 l125-20020a0dc983000000b0039fddabaf27mr4651648ywd.17.1674863866077; Fri, 27
 Jan 2023 15:57:46 -0800 (PST)
MIME-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
 <Y9QXWSaAxl7Is0yz@nanopsycho> <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <b47d1950-add0-6449-4160-d5e2f7a8d7f7@iogearbox.net>
In-Reply-To: <b47d1950-add0-6449-4160-d5e2f7a8d7f7@iogearbox.net>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 27 Jan 2023 18:57:34 -0500
Message-ID: <CAM0EoMnxXi+LpbLGhW3L60ehw6PwD43U+DVAGbCahaQCbUQN4w@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jamal Hadi Salim <hadi@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 6:02 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/27/23 9:04 PM, Jamal Hadi Salim wrote:
> > On Fri, Jan 27, 2023 at 1:26 PM Jiri Pirko <jiri@resnulli.us> wrote:
> >> Fri, Jan 27, 2023 at 12:30:22AM CET, kuba@kernel.org wrote:
> >>> On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:
> >>>> There have been many discussions and meetings since about 2015 in regards to
> >>>> P4 over TC and now that the market has chosen P4 as the datapath specification
> >>>> lingua franca
> >>>
> >>> Which market?
> >>>

[..]
> >
> > Our rule in TC is: _if you want to offload using TC you must have a
> > s/w equivalent_.
> > We enforced this rule multiple times (as you know).
> > P4TC has a sw equivalent to whatever the hardware would do. We are pushing that
> > first. Regardless, it has value on its own merit:
> > I can run P4 equivalent in s/w in a scriptable (as in no compilation
> > in the same spirit as u32 and pedit),
>
> `62001 insertions(+), 45 deletions(-)` and more to come for a software
> datapath which in the end no-one will use (assuming you'll have the hw
> offloads) is a pretty heavy lift..

I am not sure i fully parsed what you said - but the sw stands on its own
merit. The consumption of P4 specification is one - but ability to define
arbitrary pipelines without changing the kernel code (u32/pedit like, etc) is
of value.
Note (in case i misunderstood what you are saying):
As mentioned there is commitment to support; its clean standalone and
can be compiled out
and even when compiled in has no effect on the rest of the code performance
or otherwise.

> imo the layer of abstraction is wrong
> here as Stan hinted. What if tomorrow P4 programming language is not the
> 'lingua franca' anymore and something else comes along? Then all of it is
> still baked into uapi instead of having a generic/versatile intermediate
> later.

Match-action pipeline as an approach to defining datapaths is what we
implement here.
It is what P4 defines. I dont think P4 covers everything that is
needed under the shining sun
but a lot of effort has gone into standardizing common things. And if
there are gaps we fill them.
That is a solid, well understood way to build hardware and sw (TC has
been around all these
years implementing that paradigm). So that is the intended abstraction
being implemented.
The interface is designed to be scriptable to remove the burden of
making kernel (and btw user space
as well to iproute2) changes for new processing functions (whether in
s/w or hardware).

cheers,
jamal
