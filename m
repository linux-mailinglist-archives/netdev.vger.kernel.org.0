Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6964415261
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 23:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237801AbhIVVIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 17:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237759AbhIVVIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 17:08:18 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6F1C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 14:06:48 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id w8so4109853pgf.5
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 14:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qv9V6JpyQiY/s0BTR68U+rPnVJ5jwhXnd3bbLe2hYms=;
        b=8Te3FHUI0dnSNSDemxgfAaHLdgR/gm23vh9xtpxcklIPjY2abrgRh74qjk4o8KwuVR
         a5s1Bb3c5fNWyIqph9vlk/5+Q0fsBVNBh/9JpYXGIp6J3D3tv3yCx2G2M4NMDzqCSr/2
         adOm2MfJ9bCdcezEabNecECZvfNzfZ9F/laRoekZkq59PRx9YqE8K5pgRY8FC90TspVL
         fBqf2WaMFRiGtegJDN7xyoO1yTqUicVlVTHfwbBW9lI06fJRzJrMfYNbM1b0beQV8rtS
         XNrip3ZG3Q/QHgLRcot9m/kis+FuhfsvPksjW37WVsXRM2oEJ3qYqlH9i3KPbaFPlgZN
         tibw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qv9V6JpyQiY/s0BTR68U+rPnVJ5jwhXnd3bbLe2hYms=;
        b=UDOtEBPH6IhJYjHGxRZoWrQBjfehUw7SrDvrNw468Ojmw8vV8+BzoOrnGBrjIlYtVK
         EYixuoQHfYg0BGYE4wBfIx80/itB1jTC5mkF8t742FRCCYIeg6DW/fuwFUwlM+6Ha6qO
         8I58IyhihsbcyQMut1v9sac/DiFuS4OZ3vy6DwpncWX4Fd5jne5dlscMeCx3eW0ohBMY
         clKll616gsvL6bljWy9oAjDDM5PTqsg3i/5Z59TIN+/SQVhYBltjceRQfQuX6eb0qUzz
         X7SzJAiVZNynQqwbRSGUM1elHOPurdbe9LyrDmzNc75nwKJKcXG2+iMk3Hdu09IcoV8F
         iirw==
X-Gm-Message-State: AOAM531Tx+8modAB1kIP0qERsXlb/FGXpitKO3Qld7khrxDuOo8/d3PG
        Z9GSysYG0wVfFw/VMnccURg3XPMJ9zbIvlL/zRWVQA==
X-Google-Smtp-Source: ABdhPJyc1Det6K9GfrCUrVhpS49Xt/jgnGZLshvau/mMHx65v7i67p5TK/fVBaBiMq6uDxgJ84NikCbwoVjRaLqxqcE=
X-Received: by 2002:a63:1f5b:: with SMTP id q27mr889415pgm.324.1632344807834;
 Wed, 22 Sep 2021 14:06:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210916200041.810-1-felipe@expertise.dev> <CAM_iQpUkdz_EjiuPRF_qKBp_ZHok_c8+pr4skCWGs_QTeLWpwA@mail.gmail.com>
 <YUq1Ez1g8nBvA8Ad@nanopsycho> <CAOuuhY8KA99mV7qBHwX79xP31tqtc9EggSNZ-=j4Z+awJUosdQ@mail.gmail.com>
 <20210922154929.GA31100@corigine.com> <CAOuuhY9NPy+cEkBx3B=74A6ef0xfT_YFLASEOB4uvRn=W-tB5A@mail.gmail.com>
 <20210922180022.GA2168@corigine.com>
In-Reply-To: <20210922180022.GA2168@corigine.com>
From:   Tom Herbert <tom@sipanda.io>
Date:   Wed, 22 Sep 2021 14:06:37 -0700
Message-ID: <CAOuuhY9oGRgFn_D3TSwvAsMmAnahuPyws8uEZoPtpPiZwJ2GFw@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 0/2] net:sched: Introduce tc flower2
 classifier based on PANDA parser in kernel
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Felipe Magno de Almeida <felipe@sipanda.io>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>, paulb@nvidia.com,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 11:00 AM Simon Horman <simon.horman@corigine.com> wrote:
>
> On Wed, Sep 22, 2021 at 10:28:41AM -0700, Tom Herbert wrote:
> > On Wed, Sep 22, 2021 at 8:49 AM Simon Horman <simon.horman@corigine.com> wrote:
> > >
> > > On Wed, Sep 22, 2021 at 07:42:58AM -0700, Tom Herbert wrote:
> > > > On Tue, Sep 21, 2021 at 9:46 PM Jiri Pirko <jiri@resnulli.us> wrote:
> > > > >
> > > > > Wed, Sep 22, 2021 at 06:38:20AM CEST, xiyou.wangcong@gmail.com wrote:
> > > > > >On Thu, Sep 16, 2021 at 1:02 PM Felipe Magno de Almeida
> > > > > ><felipe@sipanda.io> wrote:
> > > > > >>
> > > > > >> The PANDA parser, introduced in [1], addresses most of these problems
> > > > > >> and introduces a developer friendly highly maintainable approach to
> > > > > >> adding extensions to the parser. This RFC patch takes a known consumer
> > > > > >> of flow dissector - tc flower - and  shows how it could make use of
> > > > > >> the PANDA Parser by mostly cutnpaste of the flower code. The new
> > > > > >> classifier is called "flower2". The control semantics of flower are
> > > > > >> maintained but the flow dissector parser is replaced with a PANDA
> > > > > >> Parser. The iproute2 patch is sent separately - but you'll notice
> > > > > >> other than replacing the user space tc commands with "flower2"  the
> > > > > >> syntax is exactly the same. To illustrate the flexibility of PANDA we
> > > > > >> show a simple use case of the issues described in [2] when flower
> > > > > >> consumes PANDA. The PANDA Parser is part of the PANDA programming
> > > > > >> model for network datapaths, this is described in
> > > > > >> https://github.com/panda-net/panda.
> > > > > >
> > > > > >My only concern is that is there any way to reuse flower code instead
> > > > > >of duplicating most of them? Especially when you specifically mentioned
> > > > > >flower2 has the same user-space syntax as flower, this makes code
> > > > > >reusing more reasonable.
> > > > >
> > > > > Exactly. I believe it is wrong to introduce new classifier which would
> > > > > basically behave exacly the same as flower, only has different parser
> > > > > implementation under the hood.
> > > > >
> > > > > Could you please explore the possibility to replace flow_dissector by
> > > > > your dissector optionally at first (kernel config for example)? And I'm
> > > > > not talking only about flower, but about the rest of the flow_dissector
> > > > > users too.
> > >
> > > +1
> > >
> > > > Hi Jiri,
> > > >
> > > > Yes, the intent is to replace flow dissector with a parser that is
> > > > more extensible, more manageable and can be accelerated in hardware
> > > > (good luck trying to HW accelerate flow dissector as is ;-) ). I did a
> > > > presentation on this topic at the last Netdev conf:
> > > > https://www.youtube.com/watch?v=zVnmVDSEoXc. FIrst introducing this
> > > > with a kernel config is a good idea.
> > >
> > > Can we drop hyperbole? There are several examples of hardware that
> > > offload (a subset of) flower. That the current kernel implementation has
> > > the properties you describe is pretty much irrelevant for current hw
> > > offload use-cases.
> >
> > Simon,
> >
> > "current hw offload use-cases" is the problem; these models offer no
> > extensibility. For instance, if a new protocol appears or a user wants
> > to support their own custom protocol in things like tc-flower there is
> > no feasible way to do this. Unfortunately, as of today it seems, we
> > are still bound by the marketing department at hardware vendors that
> > pick and choose the protocols that they think their customers want and
> > are willing to invest in-- we need to get past this once and for all!
> > IMO, what we need is a common way to extend the kernel, tc, and other
> > applications for new protocols and features, but also be able to apply
> > that method to extend to the hardware which is _offloading_ kernel
> > functionality which in this case is flow dissector. The technology is
> > there to do this as programmable NICs for instance are the rage, but
> > we do need to create common APIs to be able to do that. Note this
> > isn't just tc, but a whole space of features; for instance, XDP hints
> > is nice idea for the NIC to provide information about protocols in a
> > packet, but unless/until there is a way to program the device to pull
> > out arbitrary information that the user cares about like something
> > from their custom protocol, then it's very limited utility...
>
> ... the NIC could run a BPF program if its programmable to that extent.
>
Simon,

True, but that implies that the NIC would just be running code in one
CPU instead of another-- i.e., that is doing offload and not
acceleration. Hardware parses are more likely to be very specialized
and might look something like a parameterized FSM that runs 10x faster
than software in a CPU. In order to be able to accelerate, we need to
start with a parser representation that is more declarative than
imperative. This is what PANDA provides, the user writes a parser in a
declarative representation (but still in C). Given the front end
representation is declarative, we can compile that to a type of byte
code that is digestible to instantiate a reasonably programmable
hardware parser. This fits well with eBPF where the byte code is
domain specific instructions to eBPF, so when the eBPF program runs
they can be JIT compiled into CPU instructions for running on the
host, but they can be given to driver that can translate or JIT
compile the byte code into their hardware parser (coud JIT compile to
P4 backend for instance).

Tom

> But ok, I accept your point that it would be good to facilitate
> more flexible use in both sw and hw.
