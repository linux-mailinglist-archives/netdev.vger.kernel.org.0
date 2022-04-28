Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0B4513F15
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 01:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353295AbiD1Xfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 19:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbiD1Xfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 19:35:48 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8B283B2B;
        Thu, 28 Apr 2022 16:32:32 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id z26so8125121iot.8;
        Thu, 28 Apr 2022 16:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=axhaogUMsaVTbqMILr1asPaWm5AAZG3aFzuxQbyVLus=;
        b=KH4aDiPMLcKs+DMbKTNKY54Kz9SVKsyB0QMo8LCelG1mQUjJEp/6+G5l14nEq6kLlm
         /XwW/4PBufj3NLw0aVA1fiAIC2sKYv9abSbybdbczMAEU83LduDp0nqkSOja8btSdLcn
         Gh7Ox+d9yTfZM5CCDx+uRDYQkVjVoez5QxylmL7RTrjmL6dIeE0yyb4n6HUnpQ/fv7pw
         OTzzUiR7IgfYELH9SD3Ah/UkBPjx2e3qyRqGTlPKdT0GV1KSpzECeiXml14G1e3p8mSu
         jXbL1u8qgpEGyHN8JJ49xjPEurYjmZjMjap4yOb50dqd2u1+ktqc6VCsgxAc4o02/UbI
         leIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=axhaogUMsaVTbqMILr1asPaWm5AAZG3aFzuxQbyVLus=;
        b=Th/vdYMaldZV02d/rE5QMadv8VV5+450lxfbPSeByDtD9o9j6EnZH2zUnkjIvnytci
         mbw6aKBINM3v/D69Dft5ZNtCYztbUd5BFmJOOcNdkqiglX6uv9BkHqdE9Hyx25URc2DD
         0S+5n5WVDT8LG5VpgQsmsn9n22j7gKRNr+67tulvQM6pN+I56hTPusa0bQqgcodK4x7h
         6OrzG/h8t6k9uMgOds9NtCSKAq4piwWEupqKVgxCbXSjQFXj4g/OyqCdnjti6BdRFTGz
         ENty8Cb2nRDL885rTC44C0fASjaFNk6xeqXbgVvnAMjlAZk2vGUCASOyzi+1Bw7VFSP8
         56DQ==
X-Gm-Message-State: AOAM5330SAsBOssso07QWS6TBxZIpibXM2YAVFAXIxEnPKIxx1nRvXd4
        Lod3HVHRG6lXHPV5vf83sIEdBeBUfcS34bx4xhM=
X-Google-Smtp-Source: ABdhPJzfjpWAv0S/Zxx+OBbDvzr1/DchevZDrPWu+dDM5qDs/brJpBTqx9iJFlB+Fp6OSp+kj8pNYCY8hj6q7mdSzgs=
X-Received: by 2002:a05:6638:16c9:b0:328:5569:fe94 with SMTP id
 g9-20020a05663816c900b003285569fe94mr15849694jat.145.1651188751476; Thu, 28
 Apr 2022 16:32:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220407125224.310255-1-jolsa@kernel.org> <20220407125224.310255-5-jolsa@kernel.org>
 <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com>
 <20220412094923.0abe90955e5db486b7bca279@kernel.org> <CAEf4BzaQRcZGMqq5wqHo3wSHZAAVvY6AhizDk_dV_GtnwHuxLQ@mail.gmail.com>
 <20220416232103.c0b241c2ec7f2b3b985a2f99@kernel.org> <20220428095803.66c17c32@gandalf.local.home>
 <CAADnVQKi+4oBt2C__qz7QoHqTtXYLUjaqwTNFoSE=up9c9k4cA@mail.gmail.com> <20220428160519.04cc40c0@gandalf.local.home>
In-Reply-To: <20220428160519.04cc40c0@gandalf.local.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 Apr 2022 16:32:20 -0700
Message-ID: <CAEf4Bzbu3zuDcPj3ue8D6VCdMTw2PEREJBU42CbR1Pe=5qOrTQ@mail.gmail.com>
Subject: Re: [RFC bpf-next 4/4] selftests/bpf: Add attach bench test
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
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

On Thu, Apr 28, 2022 at 1:05 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 28 Apr 2022 11:59:55 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > > The weak function gets a call to ftrace, but it still gets compiled into
> > > vmlinux but its symbol is dropped due to it being overridden. Thus, the
> > > mcount_loc finds this call to fentry, and maps it to the symbol that is
> > > before it, which just happened to be __bpf_tramp_exit.
> >
> > Ouch. That _is_ a bug in recordmocount.
>
> Exactly HOW is it a bug in recordmcount?
>
> The job of recordmcount is to create a section of all the locations that
> call fentry. That is EXACTLY what it did. No bug there! It did its job.

But that __fentry__ call is not part of __bpf_tramp_exit, actually.
Whether to call it a bug or limitation is secondary. It marks
__bpf_tramp_exit as attachable through kprobe/ftrace while it really
isn't.

Below you are saying there is only user confusion. It's not just
confusion. You'll get an error when you try to attach to
__bpf_tramp_exit because __bpf_tramp_exit doesn't really have
__fentry__ preamble and thus the kernel itself will reject it as a
target. So when you build a generic tracing tool that fetches all the
attachable kprobes, filters out all the blacklisted ones, you still
end up with kprobe targets that are not attachable. It's definitely
more than an inconvenience which I experienced first hand.

Can recordmcount or whoever does this be taught to use proper FUNC
symbol size to figure out boundaries of the function?

$ readelf -s ~/linux-build/default/vmlinux | rg __bpf_tramp_exit
129408: ffffffff811b2ba0    63 FUNC    GLOBAL DEFAULT    1 __bpf_tramp_exit

So only the first 63 bytes of instruction after __bpf_tramp_exit
should be taken into account. Everything else doesn't belong to
__bpf_tramp_exit. So even though objdump pretends that call __fentry__
is part of __bpf_tramp_exit, it's not.

ffffffff811b2ba0 <__bpf_tramp_exit>:
ffffffff811b2ba0:       53                      push   %rbx
ffffffff811b2ba1:       48 89 fb                mov    %rdi,%rbx
ffffffff811b2ba4:       e8 97 d2 f2 ff          call
ffffffff810dfe40 <__rcu_read_lock>
ffffffff811b2ba9:       48 8b 83 e0 00 00 00    mov    0xe0(%rbx),%rax
ffffffff811b2bb0:       a8 03                   test   $0x3,%al
ffffffff811b2bb2:       75 0a                   jne
ffffffff811b2bbe <__bpf_tramp_exit+0x1e>
ffffffff811b2bb4:       65 48 ff 08             decq   %gs:(%rax)
ffffffff811b2bb8:       5b                      pop    %rbx
ffffffff811b2bb9:       e9 d2 0e f3 ff          jmp
ffffffff810e3a90 <__rcu_read_unlock>
ffffffff811b2bbe:       48 8b 83 e8 00 00 00    mov    0xe8(%rbx),%rax
ffffffff811b2bc5:       f0 48 83 28 01          lock subq $0x1,(%rax)
ffffffff811b2bca:       75 ec                   jne
ffffffff811b2bb8 <__bpf_tramp_exit+0x18>
ffffffff811b2bcc:       48 8b 83 e8 00 00 00    mov    0xe8(%rbx),%rax
ffffffff811b2bd3:       48 8d bb e0 00 00 00    lea    0xe0(%rbx),%rdi
ffffffff811b2bda:       ff 50 08                call   *0x8(%rax)
ffffffff811b2bdd:       eb d9                   jmp
ffffffff811b2bb8 <__bpf_tramp_exit+0x18>
ffffffff811b2bdf:       90                      nop

^^^ ffffffff811b2ba0 + 63 = ffffffff811b2bdf -- this is the end of
__bpf_tramp_exit

ffffffff811b2be0:       e8 3b 9c e9 ff          call
ffffffff8104c820 <__fentry__>
ffffffff811b2be5:       b8 f4 fd ff ff          mov    $0xfffffdf4,%eax
ffffffff811b2bea:       c3                      ret
ffffffff811b2beb:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)


>
> In fact, recordmcount probably didn't even get called. If you see this on
> x86 with gcc version greater than 8 (which I do), recordmcount is not even
> used. gcc creates this section internally instead.
>
> >
> > > I made that weak function "notrace" and the __bpf_tramp_exit disappeared
> > > from the available_filter_functions list.
> >
> > That's a hack. We cannot rely on such hacks for all weak functions.
>
> Then don't do anything. The only thing this bug causes is perhaps some
> confusion, because functions before weak functions that are overridden will
> be listed incorrectly in the available_filter_functions file. And that's
> because of the way it is created with respect to kallsyms.
>
> If you enable __bpf_tramp_exit, it will not do anything to that function.
> What it will do is enable the location inside of the weak function that no
> longer has its symbol shown.
>
> One solution is to simply get the end of the function that is provided by
> kallsyms to make sure the fentry call location is inside the function, and
> if it is not, then not show that function in available_filter_functions but
> instead show something like "** unnamed function **" or whatever.
>
> I could write a patch to do that when I get the time. But because the only
> issue that this causes is some confusion among the users and does not cause
> any issue with functionality, then it is low priority.
>
> -- Steve
