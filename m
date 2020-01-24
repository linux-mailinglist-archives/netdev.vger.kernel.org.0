Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B15147EF2
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 11:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731616AbgAXKo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 05:44:26 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41284 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgAXKo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 05:44:26 -0500
Received: by mail-qk1-f196.google.com with SMTP id s187so1539960qke.8
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 02:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V97jUf+bWpjoq1UnX/MqEvf1aslGGrvEAvh2eN6ByfY=;
        b=F9rbuxvJausgVIyNlYGX5CZhEBcw/vXq8/jPLn0g1Z9Rgv+kfxtsslCWk0j+VOX54S
         D0v6wZ2aWE/QMboSrmC4V7dFsX/+dpFmt7eb3HQr9y7qlxM7iNdC7HVVRPkw5MSzePar
         2OpH3q/MT6Y6qZxiubcft6PkVii0D9N7eDc1uR1coSqSqfeMhoi6qLTSzkfqjDOGU1vW
         8nhmz959kCmQweACAKFCyrgHxhk8D9E5tSGWIva5ZQ90zFQPXpWRmCpIGcUBQYHjEW4d
         3Gbte9+Cj95H78d19T9ZrGyKcoBlfC89jWazrVaUVjauEbCLCNmg+Nh3Yh96x3NzMxQQ
         UA0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V97jUf+bWpjoq1UnX/MqEvf1aslGGrvEAvh2eN6ByfY=;
        b=lPEXZkLJsn9/e/qRe1vvyloQBgn5EOO7YfS5XqZgDs+1ERR9uEZ3f9Bt3r/qxSS6Dl
         04KFQ/MD0ew1VAeV3NT2qI+I7v/Ze0IU+suIJjahk/vw2ZhVam6f9aHK2Th4dlykAFbA
         5wbU7drcxHDt6jR2bhlWqriF0W4MGgv5cS1r8MrSSmQbMtvY+ugwHl/e1Hw5E6dYU1d6
         HcHXEXyEuFpm1EKd3IwC8PKC5tGtxbznH47CjPEp7HkVuJ6PF0gQtK4n0sxt2zYvOqKD
         uREPUfS/twC4hYRBMeUYTXV1K9rVz6/DhqOxbHHZs9IRJaKQBjI9Hp+FnP9KlCBMl87q
         zlfw==
X-Gm-Message-State: APjAAAX85iaBoUIlxTP0UFCRcJFq/zAKhaSannpw4IzJb9vR+/0RzFL9
        oj5j2c5UC3cWYg8IzSiXPSuCxK9lO93f/PjS99yPAQ==
X-Google-Smtp-Source: APXvYqwb6/QOg4tOSE7XM1J/vLzeU2KOG/13MZFwVCAp7btlGEz5Ger1ejK9QvSdeczBxSt226fUJJZC4K5KYzKhOS0=
X-Received: by 2002:ae9:e50c:: with SMTP id w12mr1684238qkf.407.1579862664841;
 Fri, 24 Jan 2020 02:44:24 -0800 (PST)
MIME-Version: 1.0
References: <0000000000001b2259059c654421@google.com> <20200121180255.1c98b54c@gandalf.local.home>
 <20200122055314.GD1847@kadam>
In-Reply-To: <20200122055314.GD1847@kadam>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 24 Jan 2020 11:44:13 +0100
Message-ID: <CACT4Y+ZP-7np20GVRu3p+eZys9GPtbu+JpfV+HtsufAzvTgJrg@mail.gmail.com>
Subject: Re: WARNING in tracing_func_proto
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        syzbot <syzbot+0c147ca7bd4352547635@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 6:54 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Tue, Jan 21, 2020 at 06:02:55PM -0500, Steven Rostedt wrote:
> > On Fri, 17 Jan 2020 23:47:11 -0800
> > syzbot <syzbot+0c147ca7bd4352547635@syzkaller.appspotmail.com> wrote:
> >
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    428cd523 sfc/ethtool_common: Make some function to static
> > > git tree:       net-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=10483421e00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=66d8660c57ff3c98
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=0c147ca7bd4352547635
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > >
> > > Unfortunately, I don't have any reproducer for this crash yet.
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+0c147ca7bd4352547635@syzkaller.appspotmail.com
> > >
> > > ------------[ cut here ]------------
> > > Could not allocate percpu trace_printk buffer
> > > WARNING: CPU: 1 PID: 11733 at kernel/trace/trace.c:3112 alloc_percpu_trace_buffer kernel/trace/trace.c:3112 [inline]
> > > WARNING: CPU: 1 PID: 11733 at kernel/trace/trace.c:3112 trace_printk_init_buffers+0x5b/0x60 kernel/trace/trace.c:3126
> > > Kernel panic - not syncing: panic_on_warn set ...
> >
> > So it failed to allocate memory for the buffer (must be running low on
> > memory, or allocated a really big buffer?), and that triggered a
> > warning. As you have "panic_on_warn" set, the warning triggered the
> > panic.
> >
> > The only solution to this that I can see is to remove the WARN_ON and
> > replace it with a pr_warn() message. There's a lot of WARN_ON()s in the
> > kernel that need this conversion too, and I will postpone this change
> > to that effort.
> >
>
> I bet the syzbot folk have changed to lot of WARN_ON()s.  Maybe they
> just comment them out on their local tree?

FWIW this is invalid use of WARN macros:
https://elixir.bootlin.com/linux/v5.5-rc7/source/include/asm-generic/bug.h#L72
This should be replaced with pr_err (if really necessary, kernel does
not generally spew stacks on every ENOMEM/EINVAL).

There are no _lots_ such wrong uses of WARN in the kernel. There were
some, all get fixed over time, we are still discovering long tail, but
it's like one per months at most. Note: syzbot reports each and every
WARNING. If there were lots, you would notice :)

Sorting this out is critical for just any kernel testing. Otherwise no
testing system will be able to say if a test triggers something bad in
kernel or not.

FWIW there are no local trees for syzbot. It only tests public trees
as is. Doing otherwise would not work/scale as a process.
