Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8D4394FDC
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 08:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhE3GiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 02:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhE3GiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 02:38:20 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15824C061574;
        Sat, 29 May 2021 23:36:20 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ot16so4834674pjb.3;
        Sat, 29 May 2021 23:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NNL+qDCrDIa0joZ0DYEBARugQVtjVC8kImQPhRJdgbI=;
        b=HaN9suZnSjU8hSNClvCEjrrEvAk/otnDVjSyly67lUuRlxX0VAh0ZnubzbO1LBNBj3
         KuT1lvamatl2uqzpwuz0CeEU+PHi81C4/4cCunvFigmhC9ahsWlONQJz4NVuzcQJpxdS
         g43DGxZ8jC9eixBPmA7nL5NlnxXB1A7Pq8ZfwzVCxNqwmOeLv0dobfnquSpZsZPhdLs8
         D6tR1XU4DWCiPxieEF01FLO/wBvyHB5JuCX/nGRlPJwZfNjPtbAVd5P0/pA/hRyznVqO
         hXhzA+A3zz1GDDa5RQ0RfKa5tPLN4rBNFSUS8YkiyUY3AFTNYt25ea1wS3l4UGXpL0Kl
         45pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NNL+qDCrDIa0joZ0DYEBARugQVtjVC8kImQPhRJdgbI=;
        b=MFOpK6RC8mZmVJL2l2QeIlx0ynCjK7PDhT7zzDo5VD1+kCWp9EDjZBeIQyIP9EuVn0
         JVZp43AvBs8kBDX6TrRpJXZJ4+Q69ESCs38KIjJ1YXOLpcvIkTIcc8cl6bQHiu9rET5L
         6KpAYUrVNv/RpnJusfYNsxwTMbOuC/t7e93SizxV2kOs0aQ+gqSBN44eFL1w3b2DYVnO
         oD+4SLQXZD4+RFJPlh0oJHce//+gbpZBNOrhXouQStPCxMZ6UVza8vxwTbuoJdemU8ml
         10nwSNkay+FV82eXmDe3QFD8QfOnqv100l/e9wb+6ULrQUkb9cZ6G/+SeqJFNa/ODYIq
         AXbg==
X-Gm-Message-State: AOAM5314QUfvAYGi5bB6ewqQuqWVvbVAP0n6dER5stWhQ3FWD+7/bkes
        qnUkBoXzzEUmkqL0L+3SEndvXVBJjunf/G4yRSg=
X-Google-Smtp-Source: ABdhPJykxIw04QZzjECK6roH4Maji5aF2IBev6tmhiUr7sjs8xPdbsVYg+ZxFSf1Diz1jk+9DS/8tBItoXhqkyijRJU=
X-Received: by 2002:a17:90b:190a:: with SMTP id mp10mr10395885pjb.145.1622356579541;
 Sat, 29 May 2021 23:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com>
 <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
 <CAM_iQpU-Cvpf-+9R0ZdZY+5Dv+stfodrH0MhvSgryv_tGiX7pA@mail.gmail.com>
 <CAM_iQpVYBNkjDeo+2CzD-qMnR4-2uW+QdMSf_7ohwr0NjgipaQ@mail.gmail.com> <CAADnVQJUHydpLwtj9hRWWNGx3bPbdk-+cQiSe3MDFQpwkKmkSw@mail.gmail.com>
In-Reply-To: <CAADnVQJUHydpLwtj9hRWWNGx3bPbdk-+cQiSe3MDFQpwkKmkSw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 29 May 2021 23:36:08 -0700
Message-ID: <CAM_iQpXUBuOirztj3kifdFpvygKb-aoqwuXKkLdG9VFte5nynA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 11:21 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, May 24, 2021 at 9:59 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Mon, May 24, 2021 at 8:16 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Sun, May 23, 2021 at 9:01 AM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Fri, May 21, 2021 at 2:37 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > Hi, Alexei
> > > > >
> > > > > On Thu, May 20, 2021 at 11:52 PM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > Introduce 'struct bpf_timer' that can be embedded in most BPF map types
> > > > > > and helpers to operate on it:
> > > > > > long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)
> > > > > > long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> > > > > > long bpf_timer_del(struct bpf_timer *timer)
> > > > >
> > > > > Like we discussed, this approach would make the timer harder
> > > > > to be independent of other eBPF programs, which is a must-have
> > > > > for both of our use cases (mine and Jamal's). Like you explained,
> > > > > this requires at least another program array, a tail call, a mandatory
> > > > > prog pinning to work.
> > > >
> > > > That is simply not true.
> > >
> > > Which part is not true? The above is what I got from your explanation.
> >
> > I tried to write some code sketches to use your timer to implement
> > our conntrack logic, below shows how difficult it is to use,
>
> Was it difficult because you've used tail_call and over complicated
> the progs for no good reason?

Using tail call is what I got from you, here is the quote:

"Sure. That's trivially achieved with pinning.
One can have an ingress prog that tailcalls into another prog
that arms the timer with one of its subprogs.
Egress prog can tailcall into the same prog as well.
The ingress and egress progs can be replaced one by one
or removed both together and middle prog can stay alive
if it's pinned in bpffs or held alive by FD."

Here is the link:
https://lore.kernel.org/bpf/CAADnVQK9BgguVorziWgpMktLHuPCgEaKa4fz-KCfhcZtT46teQ@mail.gmail.com/


>
> > SEC("ingress")
> > void ingress(struct __sk_buff *skb)
> > {
> >         struct tuple tuple;
> >         // extract tuple from skb
> >
> >         if (bpf_map_lookup_elem(&timers, &key) == NULL)
> >                 bpf_tail_call(NULL, &jmp_table, 0);
> >                 // here is not reachable unless failure
> >         val = bpf_map_lookup_elem(&conntrack, &tuple);
> >         if (val && val->expires < now) {
> >                 bpf_tail_call(NULL, &jmp_table, 1);
> >                 // here is not reachable unless failure
> >         }
> > }
> >
> > SEC("egress")
> > void egress(struct __sk_buff *skb)
> > {
> >         struct tuple tuple;
> >         // extract tuple from skb
> >
> >         if (bpf_map_lookup_elem(&timers, &key) == NULL)
> >                 bpf_tail_call(NULL, &jmp_table, 0);
> >                 // here is not reachable unless failure
> >         val = bpf_map_lookup_elem(&conntrack, &tuple);
> >         if (val && val->expires < now) {
> >                 bpf_tail_call(NULL, &jmp_table, 1);
> >                 // here is not reachable unless failure
>
> tail_calls are unnecessary. Just call the funcs directly.
> All lookups and maps are unnecessary as well.
> Looks like a single global timer will be enough for this use case.

Hmm? With your design, a timer has to be embedded into a map
value, you said this is to mimic bpf spinlock.

>
> In general the garbage collection in any form doesn't scale.
> The conntrack logic doesn't need it. The cillium conntrack is a great
> example of how to implement a conntrack without GC.

That is simply not a conntrack. We expire connections based on
its time, not based on the size of the map where it residents.

Thanks.
