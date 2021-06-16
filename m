Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA30B3A90C7
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 06:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhFPE4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 00:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhFPEz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 00:55:59 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17ECDC061574;
        Tue, 15 Jun 2021 21:53:53 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c12so1207504pfl.3;
        Tue, 15 Jun 2021 21:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rMc2NeQlKR8tex/GBD0jB00MWYRwG3bByi0VJKEgDBE=;
        b=tA8a2aKbFxR27WDDTm5KEnkGqufCXS6bikvouyIOJJPZix2FYplWOKw88N10HOQxFl
         tWJsn7CPw3qgLfPmAzhLYOaHn6TmzQ2BPJhgDnOrJ1P+9JGC339zx08oz0QEIW6qyRUu
         BdNtOvjwlppILYKV77H9K1l1rLO+SpZBktGu5kj4vsJb1TM4/MkJka6lMMk/0HJkFAso
         kyczASM3cOSlYwXEdokunt8bvbKDbAsDRFWZ+yMEs0E4xb4ficcOVILTMgg2zlwl+/gq
         rW04ojzHxBx+ag5wstVwTIZIDa3f8tvVNJ+sTRRY7cSpP5XmjglyQ9DG2vHHzKJpICv5
         AWTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rMc2NeQlKR8tex/GBD0jB00MWYRwG3bByi0VJKEgDBE=;
        b=oezpzkVqQrwbKDebFVsEPHVCof8b9LRXG98vO627gJmRzzwyMqxM55rRk92jWNtvUG
         u0lZbImRVz84UxXvObFwJRpV5Ma7dE3IN+SI10FcTOUgR+5YqCq6X64UP2Yrc1Cbyh/Q
         yxDuxChBQGP3X8LZUbA38DshQ/G/WBebPDXdkSKev93Bqz/VdcLkMVFsDm7l0LZYGoHB
         WcQulDcgYQiIpL6grQfgIRQ3yOMkgI+SlTnl7/VexGTXKfSKEXFRLAXSYZ/DBufpHzSQ
         uG1sR8p83IBZkUHCPhwDL4VQK1IpSooz8OjUeJTcXWqMROE9TXa5kIpr/CM/m9/aajCA
         RXHA==
X-Gm-Message-State: AOAM533f6IV1+/0Ctnjm8sCQcfBHwj7mmYu8Vgm4NjNQUzj1SEsWcyRt
        1ORxR0pdz4EjStiNQVBe46Q=
X-Google-Smtp-Source: ABdhPJyR5BYyx2oaPrPM0xiQVkgSz6SNUG2S13N6KXrc40jivW97Lrv0yu4J6QSFquJHdhhEe1utgw==
X-Received: by 2002:a63:2a06:: with SMTP id q6mr3090366pgq.131.1623819232352;
        Tue, 15 Jun 2021 21:53:52 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:621])
        by smtp.gmail.com with ESMTPSA id 22sm690714pfo.80.2021.06.15.21.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 21:53:51 -0700 (PDT)
Date:   Tue, 15 Jun 2021 21:53:47 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
Message-ID: <20210616045347.rpxbze7trw7lzrg5@ast-mbp>
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
 <20210611042442.65444-2-alexei.starovoitov@gmail.com>
 <CAM_iQpW=a_ukO574qtZ6m4rqo2FrQifoGC1jcrd7yWK=6WWg1w@mail.gmail.com>
 <20210611184516.tpjvlaxjc4zdeqe6@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpV2fv=MMhf3w+YpGDXCYaMKVO_hoACL0=oXmn_pDUVexg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpV2fv=MMhf3w+YpGDXCYaMKVO_hoACL0=oXmn_pDUVexg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 11:10:46PM -0700, Cong Wang wrote:
> On Fri, Jun 11, 2021 at 11:45 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Jun 10, 2021 at 11:42:24PM -0700, Cong Wang wrote:
> > > On Thu, Jun 10, 2021 at 9:27 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Please stick to one email thread in the future, ok?
> >
> > I'll consolidate them here:
> >
> > > What is your use case to justify your own code? Asking because
> > > you deny mine, so clearly my use case is not yours.
> >
> > I mentioned several use cases in the prior threads.
> > tldr: any periodic event in tracing, networking, security.
> > Garbage collection falls into this category as well, but please internalize
> > that implementing conntrack as it is today in the kernel is an explicit non-goal.
> 
> You need to read my use case again, it is for the conntrack
> in Cilium, not the kernel one.

Cong,

the toxicity in your reply is a bit too much.
Clearly you're very upset with something.
You cannot make peace that your timer patches were rejected?
You realize that they were 'changes requested' with specific
feedback of what you can do?
You've said that it's not possible and came up with reasons to believe so.
I had no choice, but to implement the suggested changes myself.
Why? Because the requests for bpf timers came up many times over the years.
The first time it was in 2013 when bpf didn't even exist upstream.
It was still in RFC stages. Then during XDP development, etc.
Everytime folks who needed timers found a workaround.
Even today the garbage collection can be implemented in the bpf prog
without PROG_RUN cmd and user space. The prog can be attached
to periodic perf event.
If cilium conntrack needed garbage collection they could have
implemented it long ago without user space daemons and kernel additions.

> > > 1. Can t->prog be freed between bpf_timer_init() and bpf_timer_start()?
> >
> > yes.
> 
> Good. So if a program which only initializes the timer and then exits,
> the other program which shares this timer will crash when it calls
> bpf_timer_start(), right?

Correct. There is a discussion about it in a different thread.

> 
> >
> > > If the timer subprog is always in the same prog which installs it, then
> >
> > installs it? I'm not following the quesiton.
> >
> > > this is fine. But then how do multiple programs share a timer?
> >
> > there is only one callback function.
> 
> That's exactly my question. How is one callback function shared
> by multiple eBPF programs which want to share the timer?

callback function is a piece of .text. Inside C program it's written once
and then compiled once into single piece of BPF asm code by llvm.
Later libbpf can copy-paste it into many bpf programs.
The C programmer doesn't see it and doesn't need to worry about it.
From the kernel memory consumption point of view it's a bit inefficient.
In the future we will add support for dynamic linking in the kernel
and in libbpf. The bpf progs will be able to share already loaded subprograms.

> 
> >
> > > In the
> > > case of conntrack, either ingress or egress could install the timer,
> > > it only depends which one gets traffic first. Do they have to copy
> > > the same subprog for the same timer?
> >
> > conntrack is an explicit non-goal.
> 
> I interpret this as you do not want timers to be shared by multiple
> eBPF programs, correct? Weirdly, maps are shared, timers are
> placed in a map, so timers should be shared naturally too.

I only meant that re-implementing kernel conntrack as a bpf program
is an explicit non-goal.
Meaning that people can do it and with this timer api it can be easily done.
But it's explicitly excluded from api requirements.
It doesn't mean that it's hard to do. It means that reimplenting kernel
conntrack as-is with non-scalable garbage collection algorithm
is outside of the scope of this work.

> > > 2. Can t->prog be freed between a timer expiration and bpf_timer_start()
> > > again?
> >
> > If it's already armed with the first bpf_timer_start() it won't be freed.
> 
> Why? I see t->prog is released in your timer callback:

That's another race and there is another thread where it's being discussed.
Please read the whole thread to get on the same page with everyone else.

> 
> Not exactly, they share a same C file but still can be loaded/unloaded
> separately. And logically, whether a timer has been initialized once or
> twice makes a huge difference for programers.

I've looked how kernel is using hrtimer apis and didn't find a single
case where timer function is redefined or more than one timer callback is used
with single hrtimer.

> Sounds like you find a great excuse for a failure of documentation.

I got different feedback regarding documentation that is already present in
the patches, but I'll expand the comments and documentation further
to make it more clear.
