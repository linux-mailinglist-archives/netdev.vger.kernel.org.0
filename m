Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0C6513BE9
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 21:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351213AbiD1TDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 15:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346460AbiD1TDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 15:03:24 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16254D81;
        Thu, 28 Apr 2022 12:00:07 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id a11so5025481pff.1;
        Thu, 28 Apr 2022 12:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/2iD6fMIO5OpI4NhHgYR4lTbUFy+soiY1th9nkQv8Ck=;
        b=e21i1X+KfnnWVIfnVWgYIrPG5kjTlM4ZyVjV+kcVGW/4qFvnMdPfe6k0eqKXgmZswW
         O5ngKCfcoMMX4IxUw3tCi6gicyKDAQzx7bWIuQkJDV35a4kRLg6II4P8CQpLrV6+QyVg
         q3BT4acFx0LCUY3GH78wP8KUnmE5YLm6JbZ8TRCwGv1jB2AvogIsJnZVokKPcky0aIcV
         9P7EiNS45vw2tSW1CAyV3YikpX/QwsTX6H4WJe/kxyiDD7VTVftU24TNETSpSySIxA6A
         C8z5MqLgsLaK/aQX0yWu/9t8wix7OM/+TKqgTLWuTrQTyKJVqPa9DlWJ6wN4XKbeXjyC
         p1wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/2iD6fMIO5OpI4NhHgYR4lTbUFy+soiY1th9nkQv8Ck=;
        b=eDN69GhtprWnoXVKt/a34OVfZabgjYNRzmoWjw46bRlAVnKDneuvyfD+j1j9QNY4vS
         jlzUWhHp+LNsUUgF4E2oeTSl9uJvRCnLmonuJTmEib1M1CTiij5yV2O+0XyvDiYlqIpV
         zAAvocToSW1a6Ug0EsCH0UdWlZ9KUOaQ7noWBkb5k/nkR/r8HXKwudpfH4hjT8qIKTzd
         g6/lcE16z3DSWjLUHSCOY+gP8CygWYWqEAhSk4d18PzuayMIgwj1Uv+3agLtCqzmZ+oo
         zVdqv090KpYBx8PIiTSyxCAs0nnu1kh9MNDbLrk83DgPl6ivX3ixrE/oRjYYRESJKjai
         F2og==
X-Gm-Message-State: AOAM532fjcSj/taXGI3P/fCwyKxGPR51I0YuOI40+snjbTPUW8fcA2Xq
        6Ce5NAd0xpO8VHE2irDypoWb4prpeRvtLb8lGm0=
X-Google-Smtp-Source: ABdhPJwT1yvmBUd/guUeVCReEkSXCfoociHMPRqgqSUYda9q8qG6XLY/rFPwIXZe80LCvGxHdIslhCEQT+vFjRnbff4=
X-Received: by 2002:a05:6a00:8c8:b0:4fe:ecb:9b8f with SMTP id
 s8-20020a056a0008c800b004fe0ecb9b8fmr36252185pfu.55.1651172406399; Thu, 28
 Apr 2022 12:00:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220407125224.310255-1-jolsa@kernel.org> <20220407125224.310255-5-jolsa@kernel.org>
 <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com>
 <20220412094923.0abe90955e5db486b7bca279@kernel.org> <CAEf4BzaQRcZGMqq5wqHo3wSHZAAVvY6AhizDk_dV_GtnwHuxLQ@mail.gmail.com>
 <20220416232103.c0b241c2ec7f2b3b985a2f99@kernel.org> <20220428095803.66c17c32@gandalf.local.home>
In-Reply-To: <20220428095803.66c17c32@gandalf.local.home>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 28 Apr 2022 11:59:55 -0700
Message-ID: <CAADnVQKi+4oBt2C__qz7QoHqTtXYLUjaqwTNFoSE=up9c9k4cA@mail.gmail.com>
Subject: Re: [RFC bpf-next 4/4] selftests/bpf: Add attach bench test
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 6:58 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Sat, 16 Apr 2022 23:21:03 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> > OK, I also confirmed that __bpf_tramp_exit is listed. (others seems no notrace)
> >
> > /sys/kernel/tracing # cat available_filter_functions | grep __bpf_tramp
> > __bpf_tramp_image_release
> > __bpf_tramp_image_put_rcu
> > __bpf_tramp_image_put_rcu_tasks
> > __bpf_tramp_image_put_deferred
> > __bpf_tramp_exit
> >
> > My gcc is older one.
> > gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1)
> >
> > But it seems that __bpf_tramp_exit() doesn't call __fentry__. (I objdump'ed)
> >
> > ffffffff81208270 <__bpf_tramp_exit>:
> > ffffffff81208270:       55                      push   %rbp
> > ffffffff81208271:       48 89 e5                mov    %rsp,%rbp
> > ffffffff81208274:       53                      push   %rbx
> > ffffffff81208275:       48 89 fb                mov    %rdi,%rbx
> > ffffffff81208278:       e8 83 70 ef ff          callq  ffffffff810ff300 <__rcu_read_lock>
> > ffffffff8120827d:       31 d2                   xor    %edx,%edx
>
> You need to look deeper ;-)
> >
> >
> > >
> > > So it's quite bizarre and inconsistent.
> >
> > Indeed. I guess there is a bug in scripts/recordmcount.pl.
>
> No there isn't.
>
> I added the addresses it was mapping and found this:
>
> ffffffffa828f680 T __bpf_tramp_exit
>
> (which is relocated, but it's trivial to map it with the actual function).
>
> At the end of that function we have:
>
> ffffffff8128f767:       48 8d bb e0 00 00 00    lea    0xe0(%rbx),%rdi
> ffffffff8128f76e:       48 8b 40 08             mov    0x8(%rax),%rax
> ffffffff8128f772:       e8 89 28 d7 00          call   ffffffff82002000 <__x86_indirect_thunk_array>
>                         ffffffff8128f773: R_X86_64_PLT32        __x86_indirect_thunk_rax-0x4
> ffffffff8128f777:       e9 4a ff ff ff          jmp    ffffffff8128f6c6 <__bpf_tramp_exit+0x46>
> ffffffff8128f77c:       0f 1f 40 00             nopl   0x0(%rax)
> ffffffff8128f780:       e8 8b df dc ff          call   ffffffff8105d710 <__fentry__>
>                         ffffffff8128f781: R_X86_64_PLT32        __fentry__-0x4
> ffffffff8128f785:       b8 f4 fd ff ff          mov    $0xfffffdf4,%eax
> ffffffff8128f78a:       c3                      ret
> ffffffff8128f78b:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
>
>
> Notice the call to fentry!
>
> It's due to this:
>
> void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr)
> {
>         percpu_ref_put(&tr->pcref);
> }
>
> int __weak
> arch_prepare_bpf_trampoline(struct bpf_tramp_image *tr, void *image, void *image_end,
>                             const struct btf_func_model *m, u32 flags,
>                             struct bpf_tramp_progs *tprogs,
>                             void *orig_call)
> {
>         return -ENOTSUPP;
> }
>
> The weak function gets a call to ftrace, but it still gets compiled into
> vmlinux but its symbol is dropped due to it being overridden. Thus, the
> mcount_loc finds this call to fentry, and maps it to the symbol that is
> before it, which just happened to be __bpf_tramp_exit.

Ouch. That _is_ a bug in recordmocount.

> I made that weak function "notrace" and the __bpf_tramp_exit disappeared
> from the available_filter_functions list.

That's a hack. We cannot rely on such hacks for all weak functions.
