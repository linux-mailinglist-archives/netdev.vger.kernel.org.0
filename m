Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A1D30E8FB
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbhBDAx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbhBDAxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 19:53:50 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B78C061786
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 16:52:55 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id a12so2051594lfb.1
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 16:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z0j8u/cgjNk63BrE1ROiiO7WIMH6hW9ZaraaxN/GjSE=;
        b=gVr/bTGSubf6YnOvvpVG//iNim87v02Skx3jR2rMxXBTcD+HF8G3xEAnQQx+0Q+npP
         pqDCNmdgNk9JsEEyyZ8pGBqPuhB0LWAtXIXpCnbR2QYDJ+XTkBpqezeM0VhEQL870N4F
         uJkM0MIlJHoRCuuzrpOOrJtOOSiKWEnnBpQbw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z0j8u/cgjNk63BrE1ROiiO7WIMH6hW9ZaraaxN/GjSE=;
        b=JSfifGE0jpAmtIM7bPx+1e9GnMV7tucbRhuty0nMAAP8pxZTV75sYDdac255WrxeNJ
         DAf75BFDVcJ/RPs8ty1fuFoWGDiCz7V9KzWrB2v7sNBZTZXYBJmhMr6+JwMH0Dll0pyP
         pEf0WlWFNXQh+pWEWiS5dtYxOPvvps2AkyoTRk9t+W6xrs8V/ilUwOUhvjHvFYKpwRNr
         HyS9xZ4Aa81YXk8RzbG2/hVPu9w9DSQvvVw333EvrbJW1E7Q2vRXR/6eQbqNSQooKoOY
         CaGCX2QUg2r3PG5JlUYjeXbeddigNnG2xreXPrGeUNPYAeRU/kY+OkV6J4A9DWq+dSUP
         y5qw==
X-Gm-Message-State: AOAM5337jUlzrfsBVRjGsw+xsEzd0u/xps5WntbDoGBTFCDHW0jR92hU
        p/rNZoh41/7flNo0a4PEPAGM7oDlTuLRESC3B20XKA==
X-Google-Smtp-Source: ABdhPJzSprHSC/hLTMNA1akLup57Be6R1Xs+6lZxUgJvmJt7gToshQ1KQ2TSXBrV4DDz+jJi75zB2VS7Nf0bWHH7qGc=
X-Received: by 2002:a05:6512:3190:: with SMTP id i16mr3254379lfe.200.1612399973566;
 Wed, 03 Feb 2021 16:52:53 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
 <CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
 <YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net> <CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
 <20210203190518.nlwghesq75enas6n@treble> <CABWYdi1ya41Ju9SsHMtRQaFQ=s8N23D3ADn6OV6iBwWM6H8=Zw@mail.gmail.com>
 <20210203232735.nw73kugja56jp4ls@treble> <CABWYdi1zd51Jb35taWeGC-dR9SChq-4ixvyKms3KOKgV0idfPg@mail.gmail.com>
 <20210204001700.ry6dpqvavcswyvy7@treble>
In-Reply-To: <20210204001700.ry6dpqvavcswyvy7@treble>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Wed, 3 Feb 2021 16:52:42 -0800
Message-ID: <CABWYdi0p91Y+TDUu38eey-p2GtxL6f=VHicTxS629VCMmrNLpQ@mail.gmail.com>
Subject: Re: BUG: KASAN: stack-out-of-bounds in unwind_next_frame+0x1df5/0x2650
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Ignat Korchagin <ignat@cloudflare.com>,
        Hailong liu <liu.hailong6@zte.com.cn>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Julien Thierry <jthierry@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Robert Richter <rric@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 4:17 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Wed, Feb 03, 2021 at 03:30:35PM -0800, Ivan Babrou wrote:
> > > > > Can you recreate with this patch, and add "unwind_debug" to the cmdline?
> > > > > It will spit out a bunch of stack data.
> > > >
> > > > Here's the three I'm building:
> > > >
> > > > * https://github.com/bobrik/linux/tree/ivan/static-call-5.9
> > > >
> > > > It contains:
> > > >
> > > > * v5.9 tag as the base
> > > > * static_call-2020-10-12 tag
> > > > * dm-crypt patches to reproduce the issue with KASAN
> > > > * x86/unwind: Add 'unwind_debug' cmdline option
> > > > * tracepoint: Fix race between tracing and removing tracepoint
> > > >
> > > > The very same issue can be reproduced on 5.10.11 with no patches,
> > > > but I'm going with 5.9, since it boils down to static call changes.
> > > >
> > > > Here's the decoded stack from the kernel with unwind debug enabled:
> > > >
> > > > * https://gist.github.com/bobrik/ed052ac0ae44c880f3170299ad4af56b
> > > >
> > > > See my first email for the exact commands that trigger this.
> > >
> > > Thanks.  Do you happen to have the original dmesg, before running it
> > > through the post-processing script?
> >
> > Yes, here it is:
> >
> > * https://gist.github.com/bobrik/8c13e6a02555fb21cadabb74cdd6f9ab
>
> It appears the unwinder is getting lost in crypto code.  No idea what
> this has to do with static calls though.  Or maybe you're seeing
> multiple issues.
>
> Does this fix it?

It does for the dm-crypt case! But so does the following commit in
5.11 (and 5.10.12):

* https://github.com/torvalds/linux/commit/ce8f86ee94?w=1

The reason I stuck to dm-crypt reproduction is that it reproduces reliably.

We also have the following stack that doesn't touch any crypto:

* https://gist.github.com/bobrik/40e2559add2f0b26ae39da30dc451f1e

I cannot reproduce this one, and it took 2 days of uptime for it to
happen. Is there anything I can do to help diagnose it?

My goal is to enable multishot KASAN in our pre-production
environment, but currently it sometimes starves TX queues on the NIC
due to multiple reports in a row in an interrupt about
unwind_next_frame, which disables network interface, which is not
something we can tolerate.
