Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A1923CCC7
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 19:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgHERBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 13:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbgHERAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:00:21 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C56C06174A
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 10:00:18 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o5so6774743pgb.2
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 10:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G4DbSMP4s0KjqjCan6W9KS0glhbgg9IjBH8ScNTbzmc=;
        b=TcYCkFinQMAmeGEbggt+P/zVipBJP9sUzymkh/0UP7qWpBP0wJxrUmmpwnZkwKfCQs
         1ZTu1iB15ld0Bhyrq87BeyrwUclEJzRw8XYHcOhGxIrzfMkYboWY+oFCCzhSMexuEvHR
         kUqbqgJULFZlvUvwMfQ4YQ5A662brkmIo/NGcoxMmQ1RMan9EySwSx+qwQ3A6EhusfTC
         2PpK8fj5TgtrqBvA1adGDdtwm62MLhVb9PASfqcPX/cAc8jBIAOPQwbtV71D6kEFWUSX
         pEHLs/MsocS7WJ9o6KomQqb+wODk/8MeK36XlG0sqT/PApoyC+U7nN8vGWw0RsfgNV0p
         Vqnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G4DbSMP4s0KjqjCan6W9KS0glhbgg9IjBH8ScNTbzmc=;
        b=HGT9TDSl/b65prAu8qVGPF4iv2H1x06YhBcVgfbZA9Rj7O9eVW226aHW7teaYPzoQx
         XdG/jIqQzhE8+pQPZ4d0L1o0C1UPI4opiUaafFudiUn5BshhhVVGKs/jd1VvNVvjtG15
         uvG5auHtU1uk+PT5fZAXiZ9vXABPVZpUsiemRsGDuxe5arPJtt93Ikj5TMlNWR5DsERN
         GYDdruVtF3rvIb8nhlJy6OmEpMLLWpna/SQk3pZ3zEBAmOGUS5T4ztRE350TDIuzamQ2
         iYLlq/nYOhs2Lp8fLXFgvfENdYh5e84L2JhBlbWnA/kAwN6ikXX6oAvgaPp+ODKaLzSa
         EshA==
X-Gm-Message-State: AOAM530gz6gJahYel1jiahZUyhTFpuwt4e6PoRejn1kmiMfxtKX7rc4L
        XgjbpAGyUNgo4qGdzuAU0Cim17rvu6YB43drn3s4mQ==
X-Google-Smtp-Source: ABdhPJxyrDwOYA4hiJxh0WZeOnWjCsjtUjmSKRmwF8SWkAGXvKq4kBpieblfCx/y1SmwwZt8QYpg8abb4dQVxRCVJyk=
X-Received: by 2002:aa7:8a4d:: with SMTP id n13mr4581156pfa.143.1596646817583;
 Wed, 05 Aug 2020 10:00:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200805162713.16386-1-songmuchun@bytedance.com> <20200805125056.1dfe74b5@oasis.local.home>
In-Reply-To: <20200805125056.1dfe74b5@oasis.local.home>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Thu, 6 Aug 2020 00:59:41 +0800
Message-ID: <CAMZfGtW2LJTUB6OaixF-V0tVPXt5kEzVvUvOSbO551r0vvZGbg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v2] kprobes: fix NULL pointer dereference
 at kprobe_ftrace_handler
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     naveen.n.rao@linux.ibm.com, anil.s.keshavamurthy@intel.com,
        davem@davemloft.net, mhiramat@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, sfr@canb.auug.org.au, mingo@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 12:51 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu,  6 Aug 2020 00:27:13 +0800
> Muchun Song <songmuchun@bytedance.com> wrote:
>
> > We found a case of kernel panic on our server. The stack trace is as
> > follows(omit some irrelevant information):
> >
> >   BUG: kernel NULL pointer dereference, address: 0000000000000080
> >   RIP: 0010:kprobe_ftrace_handler+0x5e/0xe0
> >   RSP: 0018:ffffb512c6550998 EFLAGS: 00010282
> >   RAX: 0000000000000000 RBX: ffff8e9d16eea018 RCX: 0000000000000000
> >   RDX: ffffffffbe1179c0 RSI: ffffffffc0535564 RDI: ffffffffc0534ec0
> >   RBP: ffffffffc0534ec1 R08: ffff8e9d1bbb0f00 R09: 0000000000000004
> >   R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> >   R13: ffff8e9d1f797060 R14: 000000000000bacc R15: ffff8e9ce13eca00
> >   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   CR2: 0000000000000080 CR3: 00000008453d0005 CR4: 00000000003606e0
> >   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >   Call Trace:
> >    <IRQ>
> >    ftrace_ops_assist_func+0x56/0xe0
> >    ftrace_call+0x5/0x34
> >    tcpa_statistic_send+0x5/0x130 [ttcp_engine]
> >
> > The tcpa_statistic_send is the function being kprobed. After analysis,
> > the root cause is that the fourth parameter regs of kprobe_ftrace_handler
> > is NULL. Why regs is NULL? We use the crash tool to analyze the kdump.
> >
> >   crash> dis tcpa_statistic_send -r
> >          <tcpa_statistic_send>: callq 0xffffffffbd8018c0 <ftrace_caller>
> >
> > The tcpa_statistic_send calls ftrace_caller instead of ftrace_regs_caller.
> > So it is reasonable that the fourth parameter regs of kprobe_ftrace_handler
> > is NULL. In theory, we should call the ftrace_regs_caller instead of the
> > ftrace_caller. After in-depth analysis, we found a reproducible path.
> >
> >   Writing a simple kernel module which starts a periodic timer. The
> >   timer's handler is named 'kprobe_test_timer_handler'. The module
> >   name is kprobe_test.ko.
> >
> >   1) insmod kprobe_test.ko
> >   2) bpftrace -e 'kretprobe:kprobe_test_timer_handler {}'
> >   3) echo 0 > /proc/sys/kernel/ftrace_enabled
> >   4) rmmod kprobe_test
> >   5) stop step 2) kprobe
> >   6) insmod kprobe_test.ko
> >   7) bpftrace -e 'kretprobe:kprobe_test_timer_handler {}'
> >
> > We mark the kprobe as GONE but not disarm the kprobe in the step 4).
> > The step 5) also do not disarm the kprobe when unregister kprobe. So
> > we do not remove the ip from the filter. In this case, when the module
> > loads again in the step 6), we will replace the code to ftrace_caller
> > via the ftrace_module_enable(). When we register kprobe again, we will
> > not replace ftrace_caller to ftrace_regs_caller because the ftrace is
> > disabled in the step 3). So the step 7) will trigger kernel panic. Fix
> > this problem by disarming the kprobe when the module is going away.
> >
> > Fixes: ae6aa16fdc16 ("kprobes: introduce ftrace based optimization")
> > Acked-by: Song Liu <songliubraving@fb.com>
> > Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
> > Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> > ---
> > changelogs in v2:
> >  1) fix compiler warning for !CONFIG_KPROBES_ON_FTRACE.
>
> The original patch has already been pulled into the queue and tested.
> Please make a new patch that adds this update, as if your original
> patch has already been accepted.

Will do, thanks!

>
> Feel free to base it off of:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git  for-next
>
> -- Steve



-- 
Yours,
Muchun
