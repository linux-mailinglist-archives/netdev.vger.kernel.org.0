Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A3D30E767
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbhBCXbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbhBCXbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 18:31:38 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22929C0613ED
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 15:30:48 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id a12so1801706lfb.1
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 15:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hocG39X+tz3ResWtWHRihYuESyyVfrOSMJOVeII1Yr4=;
        b=B2166ME1KxF1tjOfSskWGSBW8hJ+RS3FE8tEbGM4Lr3PUwGWeSJovyx+hQNe9qBQI9
         rT7r7WGKmmoaUsz66RLyIyeLDsYSL4yrpDHUMNecfmB3bkhRfiLjReBu7lU0fHABvFHw
         8ZBL9rWHyJ85CiiAU569/ODbFCVhWqu25t0X0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hocG39X+tz3ResWtWHRihYuESyyVfrOSMJOVeII1Yr4=;
        b=UCPheG5DcrmmFi8l6lhbyYZWQT95DyWpwNdgY9xmUyFS3BqAMshET2ZAFsBr/OeWXZ
         2psaFsSGBZGk1IU6CbdU4iABqMV6u46vJ3+X0a4HySusRw0nEhcVjBtcKL+wmmkuUZ4P
         Qm3R0fAKQ0S98cCiFnr5E8y+pavvERIPwN3zsExyLdWlRIA5WhShxdt4I08KrMSwdrgw
         II5zpIz3m0d2bM0cq9jRgZg7pYCYIyhCCEtU8cgvF41zF8ZsgZmJ4mYyapSzvn1HRrx5
         P98kYXRe6lo/iH1+84/eAwQS220MorRU7w+B7BqKJtenb3QtkOPGgxobRpMYdZRmZsvc
         5jkg==
X-Gm-Message-State: AOAM533u2hakODxWi+4PBg3iIyDkAbXWin0DbE4O60gDZUAVa6rNisir
        qv17DFgpCCNuuo+W6C30slW/nVCTwHKZIvplQWNY1Q==
X-Google-Smtp-Source: ABdhPJzbFmqPihDILaKPbxSIRixPFUKsm+fHSPEx84ybzWmcQv7Bntw5LfHY0c2uhOLwPSkdaL1onJaSKOpKqElh5Uo=
X-Received: by 2002:a05:6512:3904:: with SMTP id a4mr2912750lfu.340.1612395046510;
 Wed, 03 Feb 2021 15:30:46 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
 <CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
 <YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net> <CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
 <20210203190518.nlwghesq75enas6n@treble> <CABWYdi1ya41Ju9SsHMtRQaFQ=s8N23D3ADn6OV6iBwWM6H8=Zw@mail.gmail.com>
 <20210203232735.nw73kugja56jp4ls@treble>
In-Reply-To: <20210203232735.nw73kugja56jp4ls@treble>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Wed, 3 Feb 2021 15:30:35 -0800
Message-ID: <CABWYdi1zd51Jb35taWeGC-dR9SChq-4ixvyKms3KOKgV0idfPg@mail.gmail.com>
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

On Wed, Feb 3, 2021 at 3:28 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Wed, Feb 03, 2021 at 02:41:53PM -0800, Ivan Babrou wrote:
> > On Wed, Feb 3, 2021 at 11:05 AM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > >
> > > On Wed, Feb 03, 2021 at 09:46:55AM -0800, Ivan Babrou wrote:
> > > > > Can you pretty please not line-wrap console output? It's unreadable.
> > > >
> > > > GMail doesn't make it easy, I'll send a link to a pastebin next time.
> > > > Let me know if you'd like me to regenerate the decoded stack.
> > > >
> > > > > > edfd9b7838ba5e47f19ad8466d0565aba5c59bf0 is the first bad commit
> > > > > > commit edfd9b7838ba5e47f19ad8466d0565aba5c59bf0
> > > > >
> > > > > Not sure what tree you're on, but that's not the upstream commit.
> > > >
> > > > I mentioned that it's a rebased core-static_call-2020-10-12 tag and
> > > > added a link to the upstream hash right below.
> > > >
> > > > > > Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > > > > > Date:   Tue Aug 18 15:57:52 2020 +0200
> > > > > >
> > > > > >     tracepoint: Optimize using static_call()
> > > > > >
> > > > >
> > > > > There's a known issue with that patch, can you try:
> > > > >
> > > > >   http://lkml.kernel.org/r/20210202220121.435051654@goodmis.org
> > > >
> > > > I've tried it on top of core-static_call-2020-10-12 tag rebased on top
> > > > of v5.9 (to make it reproducible), and the patch did not help. Do I
> > > > need to apply the whole series or something else?
> > >
> > > Can you recreate with this patch, and add "unwind_debug" to the cmdline?
> > > It will spit out a bunch of stack data.
> >
> > Here's the three I'm building:
> >
> > * https://github.com/bobrik/linux/tree/ivan/static-call-5.9
> >
> > It contains:
> >
> > * v5.9 tag as the base
> > * static_call-2020-10-12 tag
> > * dm-crypt patches to reproduce the issue with KASAN
> > * x86/unwind: Add 'unwind_debug' cmdline option
> > * tracepoint: Fix race between tracing and removing tracepoint
> >
> > The very same issue can be reproduced on 5.10.11 with no patches,
> > but I'm going with 5.9, since it boils down to static call changes.
> >
> > Here's the decoded stack from the kernel with unwind debug enabled:
> >
> > * https://gist.github.com/bobrik/ed052ac0ae44c880f3170299ad4af56b
> >
> > See my first email for the exact commands that trigger this.
>
> Thanks.  Do you happen to have the original dmesg, before running it
> through the post-processing script?

Yes, here it is:

* https://gist.github.com/bobrik/8c13e6a02555fb21cadabb74cdd6f9ab

> I assume you're using decode_stacktrace.sh?  It could use some
> improvement, it's stripping the function offset.
>
> Also spaces are getting inserted in odd places, messing the alignment.
>
> [  137.291837][    C0] ffff88809c409858: d7c4f3ce817a1700 (0xd7c4f3ce817a1700)
> [  137.291837][    C0] ffff88809c409860: 0000000000000000 (0x0)
> [  137.291839][    C0] ffff88809c409868: 00000000ffffffff (0xffffffff)
> [ 137.291841][ C0] ffff88809c409870: ffffffffa4f01a52 unwind_next_frame (arch/x86/kernel/unwind_orc.c:380 arch/x86/kernel/unwind_orc.c:553)
> [ 137.291843][ C0] ffff88809c409878: ffffffffa4f01a52 unwind_next_frame (arch/x86/kernel/unwind_orc.c:380 arch/x86/kernel/unwind_orc.c:553)
> [  137.291844][    C0] ffff88809c409880: ffff88809c409ac8 (0xffff88809c409ac8)
> [  137.291845][    C0] ffff88809c409888: 0000000000000086 (0x86)
>
> --
> Josh
>
