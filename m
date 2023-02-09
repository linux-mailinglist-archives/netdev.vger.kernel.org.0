Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19C568FC38
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 01:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjBIAyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 19:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjBIAyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 19:54:18 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C2E12061
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 16:54:16 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id x4so595773ybp.1
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 16:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HA3fnt3w/WkldBLqUixquvviOvTsBAQjIdHUUjb56M0=;
        b=sBenSKQ7FVZf9KJQB47/1z3eFo5uPqCWNUETrOZxLzOJtcLUPNVIZaxX+GVCS8uFqv
         iwRXjPWW2bB7JalEf8dr+4OdWdJW799KnVv5wR3Re1phRxVIyLFcHw8DCeqrZtz8wpVy
         XIQufLeg9mKvB3udTuoMH/+0CfFZbJdy/ZyhssQ4fqr17mtOH/3uHYHZZM4TwzEBnk1c
         ETarg2Djh7AnXFAKIXF7pYXNcN+vvceHsCfOFtij66RhDNrLMs1FODaLt+CFqesZPH49
         wQnMqvfxtvRKT7lRAJvvjBs1NxndyUcfpXc7Mg5lNSVf9hg2QrUDTpTa+8R2UV3OhcvX
         IYYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HA3fnt3w/WkldBLqUixquvviOvTsBAQjIdHUUjb56M0=;
        b=rJe67v/QW6ekjhLG2XtOBKvLE2JR3L/CudmAD5fcNYT++KvKq6JC6T0rRoLc7OLBwz
         aDbcfi0EJScdZW3xQ1GkU6zg7K3V3/yw2HvD90K6/m8vqfaiHUFadNFvgP+lFsCmN3cU
         l/D9gtxTYNtrzIoM8pNmKCGouLdy9lSqo6Vwj+JdD2yVVKtaD4p9nWDZKYCQHjm6LDCD
         hefb4hyGniG7/c7EGYOmOWAFj3FYZBHznFYIVOFgK309DBQi29ph+AB6cebcpnOOvtjR
         SN+YWlbLH6TzaxK1O/6xu6sSZHjqs8GKVY7mtIcIJzU0x4z3kFRIk16EN/z1m9gkL5uN
         Xqig==
X-Gm-Message-State: AO0yUKXb8jtCtB/c7iZW6p3nNKKmw4HPx6xK9AeTbTll8ctQNv8bEbFN
        Zhcn4EAN9DW7m6iBADiBQnSCZlDZOZJbUHNoniNr
X-Google-Smtp-Source: AK7set9ZNH349+n5tqrkBZ3G/4EXSKW8hwOrbG7RXJtrVdxo+rv0LsXkOz6w3KeCd3ROkx+iQMrf5PG0n+BJqgs4m/M=
X-Received: by 2002:a5b:b87:0:b0:8b6:6ae:3bbe with SMTP id l7-20020a5b0b87000000b008b606ae3bbemr1101327ybq.340.1675904055502;
 Wed, 08 Feb 2023 16:54:15 -0800 (PST)
MIME-Version: 1.0
References: <20211120112738.45980-1-laoar.shao@gmail.com> <20211120112738.45980-8-laoar.shao@gmail.com>
 <Y+QaZtz55LIirsUO@google.com> <CAADnVQ+nf8MmRWP+naWwZEKBFOYr7QkZugETgAVfjKcEVxmOtg@mail.gmail.com>
In-Reply-To: <CAADnVQ+nf8MmRWP+naWwZEKBFOYr7QkZugETgAVfjKcEVxmOtg@mail.gmail.com>
From:   John Stultz <jstultz@google.com>
Date:   Wed, 8 Feb 2023 16:54:03 -0800
Message-ID: <CANDhNCo_=Q3pWc7h=ruGyHdRVGpsMKRY=C2AtZgLDwtGzRz8Kw@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded 16
 with TASK_COMM_LEN
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Qais Yousef <qyousef@google.com>,
        Daniele Di Proietto <ddiproietto@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 8, 2023 at 4:11 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Feb 8, 2023 at 2:01 PM John Stultz <jstultz@google.com> wrote:
> >
> > On Sat, Nov 20, 2021 at 11:27:38AM +0000, Yafang Shao wrote:
> > > As the sched:sched_switch tracepoint args are derived from the kernel,
> > > we'd better make it same with the kernel. So the macro TASK_COMM_LEN is
> > > converted to type enum, then all the BPF programs can get it through BTF.
> > >
> > > The BPF program which wants to use TASK_COMM_LEN should include the header
> > > vmlinux.h. Regarding the test_stacktrace_map and test_tracepoint, as the
> > > type defined in linux/bpf.h are also defined in vmlinux.h, so we don't
> > > need to include linux/bpf.h again.
> > >
> > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > > Acked-by: David Hildenbrand <david@redhat.com>
> > > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > > Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> > > Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > > Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > Cc: Matthew Wilcox <willy@infradead.org>
> > > Cc: David Hildenbrand <david@redhat.com>
> > > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Cc: Petr Mladek <pmladek@suse.com>
> > > ---
> > >  include/linux/sched.h                                   | 9 +++++++--
> > >  tools/testing/selftests/bpf/progs/test_stacktrace_map.c | 6 +++---
> > >  tools/testing/selftests/bpf/progs/test_tracepoint.c     | 6 +++---
> > >  3 files changed, 13 insertions(+), 8 deletions(-)
> >
> > Hey all,
> >   I know this is a little late, but I recently got a report that
> > this change was causiing older versions of perfetto to stop
> > working.
> >
> > Apparently newer versions of perfetto has worked around this
> > via the following changes:
> >   https://android.googlesource.com/platform/external/perfetto/+/c717c93131b1b6e3705a11092a70ac47c78b731d%5E%21/
> >   https://android.googlesource.com/platform/external/perfetto/+/160a504ad5c91a227e55f84d3e5d3fe22af7c2bb%5E%21/
> >
> > But for older versions of perfetto, reverting upstream commit
> > 3087c61ed2c4 ("tools/testing/selftests/bpf: replace open-coded 16
> > with TASK_COMM_LEN") is necessary to get it back to working.
> >
> > I haven't dug very far into the details, and obviously this doesn't
> > break with the updated perfetto, but from a high level this does
> > seem to be a breaking-userland regression.
> >
> > So I wanted to reach out to see if there was more context for this
> > breakage? I don't want to raise a unnecessary stink if this was
> > an unfortuante but forced situation.
>
> Let me understand what you're saying...
>
> The commit 3087c61ed2c4 did
>
> -/* Task command name length: */
> -#define TASK_COMM_LEN                  16
> +/*
> + * Define the task command name length as enum, then it can be visible to
> + * BPF programs.
> + */
> +enum {
> +       TASK_COMM_LEN = 16,
> +};
>
>
> and that caused:
>
> cat /sys/kernel/debug/tracing/events/task/task_newtask/format
>
> to print
> field:char comm[TASK_COMM_LEN];    offset:12;    size:16;    signed:0;
> instead of
> field:char comm[16];    offset:12;    size:16;    signed:0;
>
> so the ftrace parsing android tracing tool had to do:
>
> -  if (Match(type_and_name.c_str(), R"(char [a-zA-Z_]+\[[0-9]+\])")) {
> +  if (Match(type_and_name.c_str(),
> +            R"(char [a-zA-Z_][a-zA-Z_0-9]*\[[a-zA-Z_0-9]+\])")) {
>
> to workaround this change.
> Right?

I believe so.

> And what are you proposing?

I'm not proposing anything. I was just wanting to understand more
context around this, as it outwardly appears to be a user-breaking
change, and that is usually not done, so I figured it was an issue
worth raising.

If the debug/tracing/*/format output is in the murky not-really-abi
space, that's fine, but I wanted to know if this was understood as
something that may require userland updates or if this was a
unexpected side-effect.

thanks
-john
