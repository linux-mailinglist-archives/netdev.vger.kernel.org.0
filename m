Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913C74EB874
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 04:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242097AbiC3CtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 22:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236386AbiC3CtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 22:49:13 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C7B170D9A;
        Tue, 29 Mar 2022 19:47:29 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id p21so9349232ioj.4;
        Tue, 29 Mar 2022 19:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fxX+o/81/OXOghFHUsKldyF1Yt6ZGrPzRcjfze93Ug8=;
        b=I50Dwlel4eUuBfPwkQYokzgXMlBuBvsxy0eJwTShQjHrG8ytWKzUMfdmgUPXCZC3Ks
         BlQJV5A8XqWHcL6YxaTVduDYhHp5/uLx8mKwqBTS0jjiBcGrQGLmfyVEyn+DwM2w9JE+
         xNVbriEUNr9F7iSBn3s9gAGUTVEheHRcrgPkC46+Yies7fkmAbxqeL5+7o+D0v5KWvvN
         yPZ8ue79KPz6/vvIusBCD6ie72QLpezPWd6HyB5qUEzklRrojuJsDMt7dwkuimXnuKhH
         SGy7/NEH+gBBpo55AWILmOBqQpMIfakIvFMTAAuWIPHXiFh+SwlXHajomb0mCdMoi0KG
         sj0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fxX+o/81/OXOghFHUsKldyF1Yt6ZGrPzRcjfze93Ug8=;
        b=uJrZ8gIA3BrD1WD6hgczSnnprsTVTf9V+U+6SQ90DMjRaDmyPxH91J8BmKP1yWAzwn
         b2+ROSokH+kxH8ECkXmn42w5YoOIQZVE5L+S8T7rRyopCXfBeHPJus+rv5LQEjF3wMx8
         2L+XgP5nKmgTEwQozoFLDcvcs5qKnWvVpy3xmIonfUowwl0kD8BQ16DBcr2zdZU2Qitd
         JYn1G+EJlB9tBCCpbUwn3qXXiEeiSS7eX4zqIVcf7CI+ADk5pmoCKwFWq9nNXhz/7mWD
         SMdnOkqVKRRdS2LNrKpn4h6d2h7Fp0JJxBgyuHvKvd8ZMljS05Vclc3ovQqTzMAfq2Gu
         5QiA==
X-Gm-Message-State: AOAM5302PhHjcymd5ljDa+GyzdnvlHPI52R8meZIxUdDrfahzC7N0toc
        /86vgtLwnIJPLpdsBkKPlpuhRNIywQBEtBFf388=
X-Google-Smtp-Source: ABdhPJy/MG6DWIdi4YUIC/fT9Q68sZv06a/En/8B7aBeMS8udfkxnhujC03fUJ6sEj2g9FF06TczE21+1qevTG4crI4=
X-Received: by 2002:a05:6638:2105:b0:323:68db:2e4e with SMTP id
 n5-20020a056638210500b0032368db2e4emr8002688jaj.234.1648608447592; Tue, 29
 Mar 2022 19:47:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220329231854.3188647-1-song@kernel.org> <CAEf4BzZCLwzrZPTOBEg88i1Tki6uPL73ujSE-SCSSU16HENUHA@mail.gmail.com>
 <53E87B8F-6BB1-42AB-965B-096C86236926@fb.com>
In-Reply-To: <53E87B8F-6BB1-42AB-965B-096C86236926@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 29 Mar 2022 19:47:16 -0700
Message-ID: <CAEf4BzbVqM_akAGsHkf4QJdwcA2M-Lg6MF6xLu72rRS8gUjPKw@mail.gmail.com>
Subject: Re: [PATCH bpf] tools/runqslower: fix handle__sched_switch for
 updated tp sched_switch
To:     Song Liu <songliubraving@fb.com>
Cc:     Valentin Schneider <valentin.schneider@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 5:39 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Mar 29, 2022, at 5:00 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Mar 29, 2022 at 4:19 PM Song Liu <song@kernel.org> wrote:
> >>
> >> TP_PROTO of sched_switch is updated with a new arg prev_state, which
> >> causes runqslower load failure:
> >>
> >> libbpf: prog 'handle__sched_switch': BPF program load failed: Permission denied
> >> libbpf: prog 'handle__sched_switch': -- BEGIN PROG LOAD LOG --
> >> R1 type=ctx expected=fp
> >> 0: R1=ctx(off=0,imm=0) R10=fp0
> >> ; int handle__sched_switch(u64 *ctx)
> >> 0: (bf) r7 = r1                       ; R1=ctx(off=0,imm=0) R7_w=ctx(off=0,imm=0)
> >> ; struct task_struct *next = (struct task_struct *)ctx[2];
> >> 1: (79) r6 = *(u64 *)(r7 +16)
> >> func 'sched_switch' arg2 has btf_id 186 type STRUCT 'task_struct'
> >> 2: R6_w=ptr_task_struct(off=0,imm=0) R7_w=ctx(off=0,imm=0)
> >> ; struct task_struct *prev = (struct task_struct *)ctx[1];
> >> 2: (79) r2 = *(u64 *)(r7 +8)          ; R2_w=scalar() R7_w=ctx(off=0,imm=0)
> >> 3: (b7) r1 = 0                        ; R1_w=0
> >> ; struct runq_event event = {};
> >> 4: (7b) *(u64 *)(r10 -8) = r1         ; R1_w=P0 R10=fp0 fp-8_w=00000000
> >> 5: (7b) *(u64 *)(r10 -16) = r1        ; R1_w=P0 R10=fp0 fp-16_w=00000000
> >> 6: (7b) *(u64 *)(r10 -24) = r1        ; R1_w=P0 R10=fp0 fp-24_w=00000000
> >> 7: (7b) *(u64 *)(r10 -32) = r1        ; R1_w=P0 R10=fp0 fp-32_w=00000000
> >> ; if (prev->__state == TASK_RUNNING)
> >> 8: (61) r1 = *(u32 *)(r2 +24)
> >> R2 invalid mem access 'scalar'
> >> processed 9 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
> >> -- END PROG LOAD LOG --
> >> libbpf: failed to load program 'handle__sched_switch'
> >> libbpf: failed to load object 'runqslower_bpf'
> >> libbpf: failed to load BPF skeleton 'runqslower_bpf': -13
> >> failed to load BPF object: -13
> >>
> >> Update runqslower to fix this issue. Also, as we are on this, use BPF_PROG
> >> in runqslower for cleaner code.
> >>
> >> Fixes: fa2c3254d7cf ("sched/tracing: Don't re-read p->state when emitting sched_switch event")
> >> Signed-off-by: Song Liu <song@kernel.org>
> >> ---
> >> tools/bpf/runqslower/runqslower.bpf.c | 19 +++++--------------
> >> 1 file changed, 5 insertions(+), 14 deletions(-)
> >>
> >
> > It would be much less disruptive if that prev_state was added after
> > "next", but oh well...
>
> Maybe we should change that.
>
> +Valentin and Steven, how about we change the order with the attached
> diff (not the original patch in this thread, but the one at the end of
> this email)?
>
> >
> > But anyways, let's handle this in a way that can handle both old
> > kernels and new ones and do the same change in libbpf-tool's
> > runqslower ([0]). Can you please follow up there as well?
>
> Yeah, I will also fix that one.

Thanks!

>
> >
> >
> > We can use BPF CO-RE to detect which order of arguments running kernel
> > has by checking prev_state field existence in struct
> > trace_event_raw_sched_switch. Can you please try that? Use
> > bpf_core_field_exists() for that.
>
> Do you mean something like
>
> if (bpf_core_field_exists(ctx->prev_state))
>     /* use ctx[2] and ctx[3] */
> else
>     /* use ctx[1] and ctx[2] */

yep, that's what I meant, except you don't have ctx->prev_state, you have to do:

if (bpf_core_field_exists(((struct trace_event_raw_sched_switch
*)0)->prev_state))

>
> ? I think we will need BTF for the arguments, which doesn't exist yet.
> Did I miss something?

Probably :) struct trace_event_raw_sched_switch is in vmlinux.h
already for non-raw sched:sched_switch tracepoint. We just use that
type information for feature probing. From BPF verifier's perspective,
ctx[1] or ctx[2] will have proper BTF information (task_struct) during
program validation.

>
> I was thinking about adding something like struct tp_sched_switch_args
> for all the raw tracepoints, but haven't got time to look into how.
>
> Thanks,
> Song
>
> >
> >
> >  [0] https://github.com/iovisor/bcc/blob/master/libbpf-tools/runqslower.bpf.c
> >
> >
> >> diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
> >> index 9a5c1f008fe6..30e491d8308f 100644
> >> --- a/tools/bpf/runqslower/runqslower.bpf.c
> >> +++ b/tools/bpf/runqslower/runqslower.bpf.c
> >> @@ -2,6 +2,7 @@
> >> // Copyright (c) 2019 Facebook
> >> #include "vmlinux.h"
> >> #include <bpf/bpf_helpers.h>
> >> +#include <bpf/bpf_tracing.h>
> >> #include "runqslower.h"
> >>

[...]
