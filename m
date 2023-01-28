Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05B967F344
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 01:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbjA1ArY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 19:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjA1ArX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 19:47:23 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9377BBEB
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 16:47:21 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id nm12-20020a17090b19cc00b0022c2155cc0bso6250587pjb.4
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 16:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LIgXwSDgqyCEDWIbU+2fGDKJCi3l2o8G2rmvmU6lAXs=;
        b=sutOMQUr6SbcHm7Z9MQZQvHhiR7aAt68AaklJPyZaaIULnzcxNZogYmhf2+u2NVB5D
         1qAE0cKkMNkVkjQB08hBleUfpQppzPc3SKdKU5ttdyepWiot+QxP7QLIZyZ6+eFqDMzQ
         TYTAkKKa+7dvXCd1Tj44016SryNCAckvVf+7eF7cUrCzDHZEQ0PaRRnWsa3r4LpzvgbU
         mlaNlQTpRLHx6svbHBwWUkn8M3hR6aBrRoEYF2Mpj2GGek3rRJlPDPPBiapxpXoqwwef
         5QzF8zJ2oaYzrlSf1lygNBGE3esjaOv93DUQqVk068J6IVvckTHFzpXvmHb7Aa8fhAIF
         y7tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LIgXwSDgqyCEDWIbU+2fGDKJCi3l2o8G2rmvmU6lAXs=;
        b=IMYCLO71o7IVBqb1EngakMCcfdeNxVx/Fsx+PoSdo6u2iSOoAs64eQtwdufVZ9qkY3
         RaZ08z3KZyATy0pwImkx7iCr93hFOVHZJnIFy7U9zt4Cmm/Spq00S7kAG+/8jr+m8zAH
         IcrdPPbIoddHBK7fRV0A96fz5+EjxU1LBTNCyN1YqUWN0xu2FKnqSba9w3npxCCsGtzc
         4z9t7XAZJKNo+Xdqb0LBEhnoEQzBweedKlU7VzLs8fZGMPNiXxvuaSKF2T671yzLSxUJ
         439Jm/ppoNuKEPuuwOobL+aUAfZfJ8531LwRW6gDosC1emUm7G3HJL6kpZ1FRkxcfUu0
         mM2g==
X-Gm-Message-State: AO0yUKWei7kMGGxescImHe0BJ34iKjldTU2F+obOfajdfT7g9cPWVedd
        18bSDEJlgbbuzEl/yUYpDO9oaUm/1s1Gsrf+dtqqoQ==
X-Google-Smtp-Source: AK7set8yL03KJM9QWaiw1eCkdVa6AQ/w8X80pKruUrzWSAvEhgPSdlE3IMf/vvqzWFIw0ME/4EDwdxQARgEy37DGfp0=
X-Received: by 2002:a17:902:82c6:b0:196:cca:a0b4 with SMTP id
 u6-20020a17090282c600b001960ccaa0b4mr2542485plz.20.1674866841124; Fri, 27 Jan
 2023 16:47:21 -0800 (PST)
MIME-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
 <Y9QXWSaAxl7Is0yz@nanopsycho> <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com> <CAOuuhY-JT5mLKDBDScjyDA5grA2M8E9ECvyC6FJE3Ot-VLKh=w@mail.gmail.com>
In-Reply-To: <CAOuuhY-JT5mLKDBDScjyDA5grA2M8E9ECvyC6FJE3Ot-VLKh=w@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 27 Jan 2023 16:47:09 -0800
Message-ID: <CAKH8qBvmbET6GT_XnuxnoAqzjVZhxCu32poPrC=KTnwhjAAC8A@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Tom Herbert <tom@sipanda.io>
Cc:     Jamal Hadi Salim <hadi@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, pratyush@sipanda.io, xiyou.wangcong@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com, stefanc@marvell.com,
        seong.kim@amd.com, mattyk@nvidia.com, dan.daly@intel.com,
        john.andy.fingerhut@intel.com
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

On Fri, Jan 27, 2023 at 3:06 PM Tom Herbert <tom@sipanda.io> wrote:
>
> On Fri, Jan 27, 2023 at 2:26 PM <sdf@google.com> wrote:
> >
> > On 01/27, Jamal Hadi Salim wrote:
> > > On Fri, Jan 27, 2023 at 1:26 PM Jiri Pirko <jiri@resnulli.us> wrote:
> > > >
> > > > Fri, Jan 27, 2023 at 12:30:22AM CET, kuba@kernel.org wrote:
> > > > >On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:
> > > > >> There have been many discussions and meetings since about 2015 in
> > > regards to
> > > > >> P4 over TC and now that the market has chosen P4 as the datapath
> > > specification
> > > > >> lingua franca
> > > > >
> > > > >Which market?
> > > > >
> > > > >Barely anyone understands the existing TC offloads. We'd need strong,
> > > > >and practical reasons to merge this. Speaking with my "have suffered
> > > > >thru the TC offloads working for a vendor" hat on, not the "junior
> > > > >maintainer" hat.
> > > >
> > > > You talk about offload, yet I don't see any offload code in this RFC.
> > > > It's pure sw implementation.
> > > >
> > > > But speaking about offload, how exactly do you plan to offload this
> > > > Jamal? AFAIK there is some HW-specific compiler magic needed to generate
> > > > HW acceptable blob. How exactly do you plan to deliver it to the driver?
> > > > If HW offload offload is the motivation for this RFC work and we cannot
> > > > pass the TC in kernel objects to drivers, I fail to see why exactly do
> > > > you need the SW implementation...
> >
> > > Our rule in TC is: _if you want to offload using TC you must have a
> > > s/w equivalent_.
> > > We enforced this rule multiple times (as you know).
> > > P4TC has a sw equivalent to whatever the hardware would do. We are
> > > pushing that
> > > first. Regardless, it has value on its own merit:
> > > I can run P4 equivalent in s/w in a scriptable (as in no compilation
> > > in the same spirit as u32 and pedit),
> > > by programming the kernel datapath without changing any kernel code.
> >
> > Not to derail too much, but maybe you can clarify the following for me:
> > In my (in)experience, P4 is usually constrained by the vendor
> > specific extensions. So how real is that goal where we can have a generic
> > P4@TC with an option to offload? In my view, the reality (at least
> > currently) is that there are NIC-specific P4 programs which won't have
> > a chance of running generically at TC (unless we implement those vendor
> > extensions).
> >
> > And regarding custom parser, someone has to ask that 'what about bpf
> > question': let's say we have a P4 frontend at TC, can we use bpfilter-like
> > usermode helper to transparently compile it to bpf (for SW path) instead
> > inventing yet another packet parser? Wrestling with the verifier won't be
> > easy here, but I trust it more than this new kParser.
>
> Yes, wrestling with the verifier is tricky, however we do have a
> solution to compile arbitrarily complex parsers into eBFP. We
> presented this work at Netdev 0x15
> https://netdevconf.info/0x15/session.html?Replacing-Flow-Dissector-with-PANDA-Parser.

Thanks Tom, I'll check it out. I've yet to go through the netdev recordings :-(

> Of course this has the obvious advantage that we don't have to change
> the kernel (however, as we talk about in the presentation, this method
> actually produces a faster more extensible parser than flow dissector,
> so it's still on my radar to replace flow dissector itself with an
> eBPF parser :-) )

Since there is already a bpf flow dissector, I'm assuming you're
talking about replacing the existing C flow dissector with a
PANDA-based one?
I was hoping that at some point, we can have a BPF flow dissector
program that supports everything the existing C-one does, and maybe we
can ship this program with the kernel and load it by default. We can
keep the C-based one for some minimal non-bpf configurations. But idk,
the benefit is not 100% clear to me; except maybe bpf-based flow
dissector can be treated as more "secure" due to all verifier
constraints...

> The value of kParser is that it is not compiled code, but dynamically
> scriptable. It's much easier to change on the fly and depends on a CLI
> interface which works well with P4TC. The front end is the same as
> what we are using for PANDA parser, that is the same parser frontend
> (in C code or other) can be compiled into XDP/eBPF, kParser CLI, or
> other targets (this is based on establishing a IR which we talked
> about in https://myfoobar2022.sched.com/event/1BhCX/high-performance-programmable-parsers

That seems like a technicality? A BPF-based parser can also be driven
by maps/tables; or, worst case, can be recompiled and replaced on the
fly without any downtime.


> Tom
>
> >
> >
> > > To answer your question in regards to what the interfaces "P4
> > > speaking" hardware or drivers
> > > are going to be programmed, there are discussions going on right now:
> > > There is a strong
> > > leaning towards devlink for the hardware side loading.... The idea
> > > from the driver side is to
> > > reuse the tc ndos.
> > > We have biweekly meetings which are open. We do have Nvidia folks, but
> > > would be great if
> > > we can have you there. Let me find the link and send it to you.
> > > Do note however, our goal is to get s/w first as per tradition of
> > > other offloads with TC .
> >
> > > cheers,
> > > jamal
