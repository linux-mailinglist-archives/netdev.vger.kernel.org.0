Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D0D503711
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 16:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbiDPOXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 10:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbiDPOXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 10:23:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCDB2CC81;
        Sat, 16 Apr 2022 07:21:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B1FD60F52;
        Sat, 16 Apr 2022 14:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4151AC385A1;
        Sat, 16 Apr 2022 14:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650118869;
        bh=tdkaG+9kosN+V7ncXVMKU8UTBd3pKo/eqmLPeP1OWgU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iY1CcdV3umoK6WRz4nCbnu4PbsFiJaPTe2v+PTBDghUaVha55vpk3s2P4WGk19Sb2
         ceV1fjCeouPPxlhZOYqm7Qq7e8qxU2pjDw3ufy0bJQYZ9AbOlwVil0Yw1OqCBKUBkZ
         Zn3s5TRssBnufgR06lZw9RoyhTv6NrWFeZWRnk6zEqYmkJuQHuEbnzHZk3FP1DoRvD
         wsM5qYrIV5XOZuQrbeFSE+dCKi6f1RahN2E3VsnYtgJgh15YI9QW6kjnaZVUJEUmzS
         aH5fokOb74x74GXuGweUOiYz8dllkuCkKNkqDfDeQ7iRKfi703GD4iSxEaHwQ9SJ9f
         j3zmHIHgRKz0A==
Date:   Sat, 16 Apr 2022 23:21:03 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 4/4] selftests/bpf: Add attach bench test
Message-Id: <20220416232103.c0b241c2ec7f2b3b985a2f99@kernel.org>
In-Reply-To: <CAEf4BzaQRcZGMqq5wqHo3wSHZAAVvY6AhizDk_dV_GtnwHuxLQ@mail.gmail.com>
References: <20220407125224.310255-1-jolsa@kernel.org>
        <20220407125224.310255-5-jolsa@kernel.org>
        <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com>
        <20220412094923.0abe90955e5db486b7bca279@kernel.org>
        <CAEf4BzaQRcZGMqq5wqHo3wSHZAAVvY6AhizDk_dV_GtnwHuxLQ@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 12 Apr 2022 15:51:43 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Mon, Apr 11, 2022 at 5:49 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > On Mon, 11 Apr 2022 15:15:40 -0700
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > > > +#define DEBUGFS "/sys/kernel/debug/tracing/"
> > > > +
> > > > +static int get_syms(char ***symsp, size_t *cntp)
> > > > +{
> > > > +       size_t cap = 0, cnt = 0, i;
> > > > +       char *name, **syms = NULL;
> > > > +       struct hashmap *map;
> > > > +       char buf[256];
> > > > +       FILE *f;
> > > > +       int err;
> > > > +
> > > > +       /*
> > > > +        * The available_filter_functions contains many duplicates,
> > > > +        * but other than that all symbols are usable in kprobe multi
> > > > +        * interface.
> > > > +        * Filtering out duplicates by using hashmap__add, which won't
> > > > +        * add existing entry.
> > > > +        */
> > > > +       f = fopen(DEBUGFS "available_filter_functions", "r");
> > >
> > > I'm really curious how did you manage to attach to everything in
> > > available_filter_functions because when I'm trying to do that I fail.
> > > available_filter_functions has a bunch of functions that should not be
> > > attachable (e.g., notrace functions). Look just at __bpf_tramp_exit:
> > >
> > >   void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);
> >
> > Hmm, this sounds like a bug in ftrace side. IIUC, the
> > "available_filter_functions" only shows the functions which is NOT
> > instrumented by mcount, we should not see any notrace functions on it.
> >
> > Technically, this is done by __no_instrument_function__ attribute.
> >
> > #if defined(CC_USING_HOTPATCH)
> > #define notrace                 __attribute__((hotpatch(0, 0)))
> > #elif defined(CC_USING_PATCHABLE_FUNCTION_ENTRY)
> > #define notrace                 __attribute__((patchable_function_entry(0, 0)))
> > #else
> > #define notrace                 __attribute__((__no_instrument_function__))
> > #endif
> >
> > >
> > > So first, curious what I am doing wrong or rather why it succeeds in
> > > your case ;)
> > >
> > > But second, just wanted to plea to "fix" available_filter_functions to
> > > not list stuff that should not be attachable. Can you please take a
> > > look and checks what's going on there and why do we have notrace
> > > functions (and what else should *NOT* be there)?
> >
> > Can you share how did you reproduce the issue? I'll check it.
> >
> 
> $ sudo cat /sys/kernel/debug/tracing/available_filter_functions | grep
> __bpf_tramp
> __bpf_tramp_image_release
> __bpf_tramp_image_put_rcu_tasks
> __bpf_tramp_image_put_rcu
> __bpf_tramp_image_put_deferred
> __bpf_tramp_exit
> 
> 
> __bpf_tramp_exit is notrace function, so shouldn't be here. Notice
> that __bpf_tramp_enter (which is also notrace) are not in
> available_filter_functions.

OK, I also confirmed that __bpf_tramp_exit is listed. (others seems no notrace)

/sys/kernel/tracing # cat available_filter_functions | grep __bpf_tramp
__bpf_tramp_image_release
__bpf_tramp_image_put_rcu
__bpf_tramp_image_put_rcu_tasks
__bpf_tramp_image_put_deferred
__bpf_tramp_exit

My gcc is older one.
gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1) 

But it seems that __bpf_tramp_exit() doesn't call __fentry__. (I objdump'ed) 

ffffffff81208270 <__bpf_tramp_exit>:
ffffffff81208270:       55                      push   %rbp
ffffffff81208271:       48 89 e5                mov    %rsp,%rbp
ffffffff81208274:       53                      push   %rbx
ffffffff81208275:       48 89 fb                mov    %rdi,%rbx
ffffffff81208278:       e8 83 70 ef ff          callq  ffffffff810ff300 <__rcu_read_lock>
ffffffff8120827d:       31 d2                   xor    %edx,%edx


> 
> So it's quite bizarre and inconsistent.

Indeed. I guess there is a bug in scripts/recordmcount.pl.

Thank you,

> 
> > Thank you,
> >
> >
> > --
> > Masami Hiramatsu <mhiramat@kernel.org>


-- 
Masami Hiramatsu <mhiramat@kernel.org>
