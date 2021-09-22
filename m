Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247C74153BA
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 01:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238338AbhIVXGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 19:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238293AbhIVXGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 19:06:41 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1050C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 16:05:10 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id me1so3143776pjb.4
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 16:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O7Zio6oQZAXSF3Pf8dccht3lCgJqQPzlNLFT10MyAvI=;
        b=Y3RWIZnhcZtmyIf7+nEOWbmB7kVBZF3BOztDYARYxOx0IBiCPc+eXHiVftkkgmYxW5
         G+efMB7Y3jpvKHL/V/S+z3TY1TZMgIxtbGcUSwOLM++bMja86UiY0RXfoXeh//DTmSR2
         xUcxegwryN0YRTE9GhGU5VbcUE9PJwgcHq48JSaAt834QiJLv57sgiqRpY0Nro1cIJi5
         tHUJuT5cOP/H1IeWft6fRp5I/hdVxUH59zMCbDenLRYykZoKuvNTFnIqbmJgpm9ud3oD
         5UXKv6zSw+3D9HbhA2lEKW2HuJALUoPAjPzxvJ8gZfoEQx6tJe3MEm5OARkj1AinTpoz
         V6dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O7Zio6oQZAXSF3Pf8dccht3lCgJqQPzlNLFT10MyAvI=;
        b=5qKdy+adgbieZU3FcGFbQbGhl+tE6QLGanul6xPmz6dEyB05K20kyCunIGHAdqT1l+
         Rfkwa4iL4CJ8VsnEK33ekozwwWeHuFy+EBB06JaVrl4GRyr58buk9yqmCDAMZ9HRVgmu
         sQkum+j6nMx/X2XgGDSO63fVPPj0+L/xrHrWJidKKr9qX54Yor5ItAHLf+iDWjxELQJ/
         3njl3NlWg0ztzt5o7FSN2+FYZZjzj5Ijy6NMC67bBUfYm53otxgvsp2LIliMmtkrikrM
         eeU8F3qro7SWhORurXtoalRR9/bQQ4W1pVolZ2K7o0Vpt/w8g7x5P8iwF0oK+TW8N/tY
         tf0w==
X-Gm-Message-State: AOAM533cxk0dvbMgRd0adL25eAJh8BL3txCDxNE0wXsMKOrlfxAHI6Li
        Gl0yTyZYdmNSaQ/TJk+EarEjMGRJBfI8GC67AV2/7w==
X-Google-Smtp-Source: ABdhPJyFoRK3yMSGexRq6/21UvzzaD8KOKEgO6OWmo5wyzsX5dfCwq7V9p503IEBxuZv/2aRJWv/OEhpjDkryd3ZQj4=
X-Received: by 2002:a17:902:780f:b0:13a:3919:e365 with SMTP id
 p15-20020a170902780f00b0013a3919e365mr1099060pll.63.1632351910137; Wed, 22
 Sep 2021 16:05:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210916200041.810-1-felipe@expertise.dev> <CAM_iQpUkdz_EjiuPRF_qKBp_ZHok_c8+pr4skCWGs_QTeLWpwA@mail.gmail.com>
 <YUq1Ez1g8nBvA8Ad@nanopsycho> <CAOuuhY8KA99mV7qBHwX79xP31tqtc9EggSNZ-=j4Z+awJUosdQ@mail.gmail.com>
 <20210922154929.GA31100@corigine.com> <CAOuuhY9NPy+cEkBx3B=74A6ef0xfT_YFLASEOB4uvRn=W-tB5A@mail.gmail.com>
 <YUuRUa67muprw7jS@t14s.localdomain>
In-Reply-To: <YUuRUa67muprw7jS@t14s.localdomain>
From:   Tom Herbert <tom@sipanda.io>
Date:   Wed, 22 Sep 2021 16:04:59 -0700
Message-ID: <CAOuuhY_PEE62_yjEQOKKrmn+cjPDz+imE4JNX30XT6-sP4jRLw@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 0/2] net:sched: Introduce tc flower2
 classifier based on PANDA parser in kernel
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Jiri Pirko <jiri@resnulli.us>,
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
        Amritha Nambiar <amritha.nambiar@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 3:32 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
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
>
> Not that I don't agree with this, but I'm having a hard time seeing
> how flower2 would be more flexible than current approach in this
> sense. Say that someone wants to add support for IPv64. AFAICS it
> would still require changes to iproute, cls_flower2, panda and
> drivers, which is the complain that I usually hear about cls_flower
> extensibility.
>
Yes, flower2 is not sufficient and neither would be replacing the flow
dissector with PANDA. In order to make this tc-flower truly extensible
we need "generic tc-flower" which I touched upon in the Netdev. This
really means that we need to coordinate three actors of TC
application, kernel, and hardware for offloads. Adding a new protocol
means that we have to be able to parse the packet before match rules
can be created, so that means the parser is a first class citizen in
making this work.

> TCP options too, for example. The 1st patch has code like:
>
> +#define PANDA_METADATA_tcp_options                                     \
> +       struct {                                                        \
> +               __u16 mss;                                              \
> +               __u8 window_scaling;                                    \
> +               struct {                                                \
> +                       __u32 value;                                    \
> +                       __u32 echo;                                     \
> +               } timestamp;                                            \
> +               struct {                                                \
> +                       __u32 left_edge;                                \
> +                       __u32 right_edge;                               \
> +               } sack[PANDA_TCP_MAX_SACKS];                                    \
> +       } tcp_options
>
> ...
>
> +#define PANDA_METADATA_TEMP_tcp_option_mss(NAME, STRUCT)               \
> +static void NAME(const void *vopt, void *iframe,                       \
> +                struct panda_ctrl_data ctrl)                           \
> +{                                                                      \
> +       const struct tcp_opt_union *opt = vopt;                         \
> +       struct STRUCT *frame = iframe;                                  \
> +                                                                       \
> +       frame->tcp_options.mss = ntohs(opt->mss);                       \
> +}
>
> So if we have a new option on the game, what will need updating?
>
It's a matter of adding new options to the parser program and then
downloading the parser either to kernel or hardware for offload (again
they really should be running identical programs). Given that we need
to be able to set up rules for matching fields in the protocols which
can be done by using offsets as the keys in an abstract way. The
kernel and the user space application then need to be tightly
coordinated such that they have agreement that they are talking about
the same fields for a given value (BTF might help here). The last part
of the equation is to dynamically create a TC CLI for the new fields,
this could be derived from the input parser program that is annotated
with human readable names for protocols and fields.

Thanks,
Tom


>   Marcelo
>
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
> >
> > Tom
