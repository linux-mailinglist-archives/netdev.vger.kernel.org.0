Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE831EC0F7
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 19:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgFBRcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 13:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgFBRcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 13:32:21 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152FAC05BD1E
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 10:32:21 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id g5so5364657pfm.10
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 10:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q08UfGLMMG7XFfg1k0wEiAbk7/5yGFfsLQvkxh/Y50Y=;
        b=P+AFpEytkQuzECixNF5NEV9T2aTSGfCaYAzpZvFEHKXRe1yvLgxkIcVF9lrouST597
         5MH28omNSKOVKFvC3Swd6dBINGg5IK4an5lC1cbS5WAA78xKkezSZGypfpehzfutiROU
         i3EPdUcpQaebx8WwAXLhiuL0ec4bVdawS2Iy4R3OY2bRSx29MF3BswSSjtHaVKk3tL7S
         5hOS/hCXDoeSIfc8ta9TuKfSOM6jfV6dGKp7rF+JCIeBrdYHvQuqNjGrx16+awPdT0PU
         qf7OpWWm+nWSpJoG5n2koCZNk2bc/jgyPPWXMgRyKAVgvbZ3zFTaUklHfSUBX/cBYtML
         d5iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q08UfGLMMG7XFfg1k0wEiAbk7/5yGFfsLQvkxh/Y50Y=;
        b=bMi4dFFrg954TYkMAi2rjgEN4GhaUsOdhm88i0Qr36rZCQ2WIwEL3euh/MbYi/lAYG
         6mwcZo0m0BvtcCvOliGq86BLMvnMKMrqjj9UleVIbjw4Bs44QT7pP5TWIUKVk8eKbPGM
         ujfzqqeQQ4EpLx+kBVQfZsGRnYwkyU8+wzc+oegCMqCTj6e0RO/x9gtoGpyA2N+JV3eY
         wzTyqvJ6svVH7NRGjXiLQ2YdcmiRVEwVWdYhMnYWbyDENQ6dghieYOp6zyjRW7HebhS5
         oNKluirnkY2LtCuV4B/sTHa/zxyMJt5MMgPkVOfs9BgLnINNVo/rH49lFOChiKco8CTY
         vJVw==
X-Gm-Message-State: AOAM5322FVvNw6YoWGFrxc3MWmaswBpJkbV5LoQ2jgcaON7v0der6U0O
        CD59dWvBGxrJHKFOdWidTLYSaWRL
X-Google-Smtp-Source: ABdhPJynStie0RUTDMnrjC7wZHVcEtR3k7l0RGK7ERgPxnV9q7k+A0BEI/Oldp2Sg1BByiNWVtUzhg==
X-Received: by 2002:a62:ee02:: with SMTP id e2mr25587128pfi.161.1591119140497;
        Tue, 02 Jun 2020 10:32:20 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:514a])
        by smtp.gmail.com with ESMTPSA id 10sm2901032pfn.6.2020.06.02.10.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 10:32:19 -0700 (PDT)
Date:   Tue, 2 Jun 2020 10:32:16 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alexander Potapenko <glider@google.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Alexei Starovoitov <ast@kernel.org>,
        Dmitriy Vyukov <dvyukov@google.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: Self-XORing BPF registers is undefined behavior
Message-ID: <20200602173216.jrcvzgjhrkvlphew@ast-mbp.dhcp.thefacebook.com>
References: <CAG_fn=W_BCW5OvP2tayQLcrTuiXCXDBYDYSJ7U6xHftDFyLu3A@mail.gmail.com>
 <CAADnVQ+GFuDkx+xW42wL60=W4bz5C8Q-pNNP+f2txy_hY-TeUA@mail.gmail.com>
 <CAG_fn=WfQ4KG5FCwYQPbHX6PJ1f8wvJYq+Q9fBugyCbMBdiB6Q@mail.gmail.com>
 <CAADnVQLxnjrnxFhXEKDaXBgVZeRauAr8F4N+ZwuKdTnONUkt7A@mail.gmail.com>
 <CAG_fn=Uvp2HmqHUZqEHtAWj8dG4j5ifqbGFQ2A3Jzv10bf-b9Q@mail.gmail.com>
 <CAADnVQ+2eLKh-s34ciNue-Jt5yL1MrS=LL8Zjfo0gkUkk8dDug@mail.gmail.com>
 <984adc13-568e-8195-da1a-05135dbf954f@solarflare.com>
 <CAG_fn=WaYz5LOyuteF5LAkgFbj8cpgNQyO1ReORTAiCbyGuNQg@mail.gmail.com>
 <38ff5e15-bf76-2d17-f524-3f943a5b8846@solarflare.com>
 <CAG_fn=XR_dRG4vpo-jDS1L-LFD8pkuL8yWaTWbJAAQ679C3big@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=XR_dRG4vpo-jDS1L-LFD8pkuL8yWaTWbJAAQ679C3big@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 03:31:40PM +0200, Alexander Potapenko wrote:
> 
> So we're back to the question how much people care about the
> interpreter performance.

No. The question is whether people care about UB fuzzing.

> 
> > > I don't have evidence that such a transformation is currently possible
> > > for the BPF code in question, but all the building blocks are there,
> > > so it's probably just a matter of time.
> > I'm not so sure.  Consider the following sequence of BPF instructions:
> >     xor r0, r0
> >     ld r0, 42
> >     xor r0, r0
> >     exit
> > I hope you'll agree that at entry to the second XOR, the value of r0 is
> >  not indeterminate.  So any optimisation the compiler does for the first
> >  XOR ("oh, we don't need to fill the existing regs[] values, we can just
> >  use whatever's already in whichever register we allocate") will need to
> >  be predicated on something that makes it only happen for the first XOR.
> > But the place it's doing this optimisation is in the interpreter, which
> >  is a big fetch-execute loop.  I don't think even Clang is smart enough
> >  to figure out "BPF programs always start with a prologue, I'll stick in
> >  something that knows which prologue the prog uses and branches to a
> >  statically compiled, optimised version thereof".
> > (If Clang *is* that smart, then it's too clever by half...)
> 
> I don't think Clang does this at the moment, but I can certainly
> imagine it unrolling the first two iterations of the interpretation
> loop (since the prologue instructions are known at compile time) and
> replacing them with explicit XOR instructions.
> 
> I however suggest we get to the practical question of how to deal with
> this issue in the long run.
> Currently these error reports prevent us from testing BPF with syzbot,
> so we're using https://github.com/google/kmsan/commit/69b987d53462a7f3b5a41c62eb731340b53165f8
> to work around them.
> This seems to be the easiest fix that doesn't affect JIT performance
> and removes the UB.
> 
> Once KMSAN makes it to the mainline, we'll need to either come up with
> a similar fix, or disable fuzzing BPF, which isn't what we want.

Disabling fuzzing altogether would be unfortunate,
but disabling UB fuzzing is perfectly fine.
I don't think UB fuzzer scratched the surface yet.
See fixup_bpf_calls() for example. It's the same UB due to uninit regs.
And I have to add the same Nack on messing with it.
There could be other places in bpf codegen. We're not going to
chase them one by one because standard says it's UB and interpreter
is written in C. The target for bpf codegen is JITs. JITs on some arch
optimize mov r,0 into xor. Some dont. bpf interpreter is simulating hw.
If gcc/clang will ever mess it with it to the point that this UB
will become an issue we will rewrite certain pieces of interpreter in asm.
For now if you want UB fuzzer running in your environment please add
_out_of_tree_ patch that inits all interpreter registers to zero.
