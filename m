Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF36B397E5A
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 04:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhFBCCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 22:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbhFBCCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 22:02:20 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED43EC061574;
        Tue,  1 Jun 2021 19:00:36 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id u18so934765pfk.11;
        Tue, 01 Jun 2021 19:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xzyOqcnctFOyPxSc8L2wJ1XR+PmOQ8cJpVzrQFBidtM=;
        b=ICE90dwSoe9eF9YAe6+ZI37Pu27uZO+rxv2Y5eic1Iv9xDvbL9dwNHwoP+ytKVYsgI
         92TgJF3yqoFLZb2dqRB8KmJDwlk52ciTQEWDYIQDUu389Ds46S3fvcwTlYJqHzd8/peZ
         KERVt+l7WTWEAjQSEijePPcJCoTukhWmjkSYJaYaYpT5YjuPeUzu5WruTiMnCQhl+72D
         faxsK9vOzT7lNtKVYO1hRiCDnnRah1S+C3VvJi2CrUnZ/8fyy9qZxkN0jTxBgqOVvyGk
         xIiRwVhCjOcPAF9MNqjfreacuAr1F5Fz/tJEkFmPGze5ccCkP0LuaqLvHBPadsxqND/E
         J1rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xzyOqcnctFOyPxSc8L2wJ1XR+PmOQ8cJpVzrQFBidtM=;
        b=CBSvNvGXMZxHZCzrIKAwd9GCffdHlPAkeG7VXYwA8LfUcMmySjFPlZmZ3qlGlXF70F
         5uLMWv/1jqUJ0LIpFxZ0xhW/GOyM+s0WHoM9HJ5z9xvVB7Z/9Fra0CxEQuMYMTjg+G16
         AZD0a19Gzbfyc428joajJOJm9roCOthEXwDQ6Huk3C6CGQhcEJcMeZXgFknij+PUHc6D
         07KhAIMjinFzON4F4WFdF0ruQ4jcokdCuJoIVP4WFNmqQV8A62jMY+dQyYiLoAC6/fki
         cVNA9xbcyoZH7XYURfw3QmtgYgqEtLXZvWeUstd6Uhk4DU3K3GjPP+KoEbg2C9y9MIcV
         DfXA==
X-Gm-Message-State: AOAM5307GlDCF+2VOU8CrLOdSJsD4dMOowQF9x9hf2jNadep91tKxcEd
        HLCu48nd+qLuCqTKpZLBf+A=
X-Google-Smtp-Source: ABdhPJwPzs/P7uOa3LSkFdUzx2LeqQtzkdPTXJLERQyL1S+sXpiScFjHtaGXP0UaMJ5dVnnf2pFcQw==
X-Received: by 2002:a63:1443:: with SMTP id 3mr31535090pgu.69.1622599236184;
        Tue, 01 Jun 2021 19:00:36 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:bdb9])
        by smtp.gmail.com with ESMTPSA id o14sm1303962pfu.89.2021.06.01.19.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 19:00:35 -0700 (PDT)
Date:   Tue, 1 Jun 2021 19:00:30 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
Message-ID: <20210602020030.igrx5jp45tocekvy@ast-mbp.dhcp.thefacebook.com>
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com>
 <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
 <CAM_iQpU-Cvpf-+9R0ZdZY+5Dv+stfodrH0MhvSgryv_tGiX7pA@mail.gmail.com>
 <CAM_iQpVYBNkjDeo+2CzD-qMnR4-2uW+QdMSf_7ohwr0NjgipaQ@mail.gmail.com>
 <CAADnVQJUHydpLwtj9hRWWNGx3bPbdk-+cQiSe3MDFQpwkKmkSw@mail.gmail.com>
 <CAM_iQpXUBuOirztj3kifdFpvygKb-aoqwuXKkLdG9VFte5nynA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpXUBuOirztj3kifdFpvygKb-aoqwuXKkLdG9VFte5nynA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 29, 2021 at 11:36:08PM -0700, Cong Wang wrote:
> On Tue, May 25, 2021 at 11:21 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, May 24, 2021 at 9:59 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Mon, May 24, 2021 at 8:16 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > On Sun, May 23, 2021 at 9:01 AM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Fri, May 21, 2021 at 2:37 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > >
> > > > > > Hi, Alexei
> > > > > >
> > > > > > On Thu, May 20, 2021 at 11:52 PM Alexei Starovoitov
> > > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > > >
> > > > > > > Introduce 'struct bpf_timer' that can be embedded in most BPF map types
> > > > > > > and helpers to operate on it:
> > > > > > > long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)
> > > > > > > long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> > > > > > > long bpf_timer_del(struct bpf_timer *timer)
> > > > > >
> > > > > > Like we discussed, this approach would make the timer harder
> > > > > > to be independent of other eBPF programs, which is a must-have
> > > > > > for both of our use cases (mine and Jamal's). Like you explained,
> > > > > > this requires at least another program array, a tail call, a mandatory
> > > > > > prog pinning to work.
> > > > >
> > > > > That is simply not true.
> > > >
> > > > Which part is not true? The above is what I got from your explanation.
> > >
> > > I tried to write some code sketches to use your timer to implement
> > > our conntrack logic, below shows how difficult it is to use,
> >
> > Was it difficult because you've used tail_call and over complicated
> > the progs for no good reason?
> 
> Using tail call is what I got from you, here is the quote:
> 
> "Sure. That's trivially achieved with pinning.
> One can have an ingress prog that tailcalls into another prog
> that arms the timer with one of its subprogs.
> Egress prog can tailcall into the same prog as well.
> The ingress and egress progs can be replaced one by one
> or removed both together and middle prog can stay alive
> if it's pinned in bpffs or held alive by FD."

That was in the context of doing auto-cancel of timers.
There is only one choice to make. Either auto-cancel or not.
That quote was during the time when auto-cancel felt as it would fit
the FD model better.
We auto-detach on close(link_fd) and auto-unload on close(prog_fd).
The armed timer would prevent that and that promise felt
necessary to keep. But disappearing timer is a bigger surprise
to users than not auto-unloading progs.
Hence this patch is doing prog_refcnt++ in bpf_timer_start.
Please see other emails threads in v1 patch set.

> >
> > tail_calls are unnecessary. Just call the funcs directly.
> > All lookups and maps are unnecessary as well.
> > Looks like a single global timer will be enough for this use case.
> 
> Hmm? With your design, a timer has to be embedded into a map
> value, you said this is to mimic bpf spinlock.

The global data is a map.
When spin_lock was introduced there was no global data concept.

> >
> > In general the garbage collection in any form doesn't scale.
> > The conntrack logic doesn't need it. The cillium conntrack is a great
> > example of how to implement a conntrack without GC.
> 
> That is simply not a conntrack. We expire connections based on
> its time, not based on the size of the map where it residents.

Sounds like your goal is to replicate existing kernel conntrack
as bpf program by doing exactly the same algorithm and repeating
the same mistakes. Then add kernel conntrack functions to allow list
of kfuncs (unstable helpers) and call them from your bpf progs.
