Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C16F4ED3C5
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 08:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiCaGMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 02:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiCaGME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 02:12:04 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FA939B9D;
        Wed, 30 Mar 2022 23:10:17 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id e22so27444192ioe.11;
        Wed, 30 Mar 2022 23:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6XSVjejkLMWuJGJDJ8har4+74Zsm9rbOA8GE9gYlSBo=;
        b=f1mNuuDCuEjum0gc+TN+LTMRGPqv9VSxYTxN+Weza38PFZsaDw6XwiOmGzey41a+uh
         qhY/p6iE23TddDWOYOCxPYXwzK76xwr9tFbdKJWUE73qJ1G/0d7SsbtyWnjRAJTD9eSv
         2fD5hHcxuAzdjB+6nj1zqt71KIfcg0wbOHlT1YWWH9/pJjMkITTBoTcubSYvQsx3RW++
         EIfkFuwlvkvpBP7J4+e54WGxIAN6Izd0vr1BLP4WSMXguylcLHgZ1+ViuaHtrlEMfSWl
         kFM3TvkCrsoXb2EQPuPAx3vAE4b+B+IlAmFX5ib6Otgq195X00VBXmo6VFeHyrT4WplX
         TwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6XSVjejkLMWuJGJDJ8har4+74Zsm9rbOA8GE9gYlSBo=;
        b=UfG6z0drwu6qBnyrNOuuqEQ3BLREpa4qAPFWm9bAlrSbKP3zhZfM3QSDkRGXdkz4vR
         RnQ8y2Z2dJUUKrrvHLEDRI5fn+SVjWlUT31pxWqH2QTyOoeJeclAu8bRWLAs5GBr+cuW
         4gDkzJEfhBmTFtsFnJ5uycrJPnsszZZTavFFWHiub7Zt/haSKTa8tf8tuSLEOGN5abBF
         RA3KubHgRnnX/Wc9Lth+/Go32h+v9t0dgnS+TBpWXTP/PiVuD7f/BJYcQen56ZkIKOGd
         Vxu2bnZfW2b7VxNqypiW6EmK30CyxPJGHwARD84I2jCgm/B2a09tDAKCWIIny4/wsJA/
         efDw==
X-Gm-Message-State: AOAM531+ehMuq/3Gwy71eMXIq9QlIsrGwNzVT6JxWc/TaiX09lBQ1gJb
        kyfNQ31yiUK2cquRNKB7IYMTJA+XJDmGEyO7WRA=
X-Google-Smtp-Source: ABdhPJwGveqZEvWygCT5hlAQaZQ4o6Lttzhy8EHErPagLxG9vaBy8WG0Bnfe3Jt3p9zZNfEMGxcfj8AK183XqmLADqQ=
X-Received: by 2002:a05:6638:2642:b0:323:756f:42a7 with SMTP id
 n2-20020a056638264200b00323756f42a7mr2174798jat.145.1648707017288; Wed, 30
 Mar 2022 23:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220329231854.3188647-1-song@kernel.org> <CAEf4BzZCLwzrZPTOBEg88i1Tki6uPL73ujSE-SCSSU16HENUHA@mail.gmail.com>
 <53E87B8F-6BB1-42AB-965B-096C86236926@fb.com> <CAEf4BzbVqM_akAGsHkf4QJdwcA2M-Lg6MF6xLu72rRS8gUjPKw@mail.gmail.com>
 <A68BDAD9-A4D9-48D0-ACAF-7AF6AD38F27B@fb.com> <0BCC6E9C-90E1-4B56-8829-12D180520D71@fb.com>
In-Reply-To: <0BCC6E9C-90E1-4B56-8829-12D180520D71@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 30 Mar 2022 23:10:06 -0700
Message-ID: <CAEf4BzYkoKv45H4Np6OWMDhYj7GLf19YLfP=V9g1+g0Sq9VU5w@mail.gmail.com>
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

On Wed, Mar 30, 2022 at 2:11 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Mar 29, 2022, at 11:43 PM, Song Liu <songliubraving@fb.com> wrote:
> >
> >
> >
> >> On Mar 29, 2022, at 7:47 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >>
> >> On Tue, Mar 29, 2022 at 5:39 PM Song Liu <songliubraving@fb.com> wrote:
> >>>
> >>>
> >>>
> >>>> On Mar 29, 2022, at 5:00 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >>>>
> >>>> On Tue, Mar 29, 2022 at 4:19 PM Song Liu <song@kernel.org> wrote:
> >>>>>
> >>>>> TP_PROTO of sched_switch is updated with a new arg prev_state, which
> >>>>> causes runqslower load failure:
> >>>>>
> >>>>> libbpf: prog 'handle__sched_switch': BPF program load failed: Permission denied
> >>>>> libbpf: prog 'handle__sched_switch': -- BEGIN PROG LOAD LOG --
> >>>>> R1 type=ctx expected=fp
> >>>>> 0: R1=ctx(off=0,imm=0) R10=fp0
> >>>>> ; int handle__sched_switch(u64 *ctx)
> >>>>> 0: (bf) r7 = r1                       ; R1=ctx(off=0,imm=0) R7_w=ctx(off=0,imm=0)
> >>>>> ; struct task_struct *next = (struct task_struct *)ctx[2];
> >>>>> 1: (79) r6 = *(u64 *)(r7 +16)
> >>>>> func 'sched_switch' arg2 has btf_id 186 type STRUCT 'task_struct'
> >>>>> 2: R6_w=ptr_task_struct(off=0,imm=0) R7_w=ctx(off=0,imm=0)
> >>>>> ; struct task_struct *prev = (struct task_struct *)ctx[1];
> >>>>> 2: (79) r2 = *(u64 *)(r7 +8)          ; R2_w=scalar() R7_w=ctx(off=0,imm=0)
> >>>>> 3: (b7) r1 = 0                        ; R1_w=0
> >>>>> ; struct runq_event event = {};
> >>>>> 4: (7b) *(u64 *)(r10 -8) = r1         ; R1_w=P0 R10=fp0 fp-8_w=00000000
> >>>>> 5: (7b) *(u64 *)(r10 -16) = r1        ; R1_w=P0 R10=fp0 fp-16_w=00000000
> >>>>> 6: (7b) *(u64 *)(r10 -24) = r1        ; R1_w=P0 R10=fp0 fp-24_w=00000000
> >>>>> 7: (7b) *(u64 *)(r10 -32) = r1        ; R1_w=P0 R10=fp0 fp-32_w=00000000
> >>>>> ; if (prev->__state == TASK_RUNNING)
> >>>>> 8: (61) r1 = *(u32 *)(r2 +24)
> >>>>> R2 invalid mem access 'scalar'
> >>>>> processed 9 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
> >>>>> -- END PROG LOAD LOG --
> >>>>> libbpf: failed to load program 'handle__sched_switch'
> >>>>> libbpf: failed to load object 'runqslower_bpf'
> >>>>> libbpf: failed to load BPF skeleton 'runqslower_bpf': -13
> >>>>> failed to load BPF object: -13
> >>>>>
> >>>>> Update runqslower to fix this issue. Also, as we are on this, use BPF_PROG
> >>>>> in runqslower for cleaner code.
> >>>>>
> >>>>> Fixes: fa2c3254d7cf ("sched/tracing: Don't re-read p->state when emitting sched_switch event")
> >>>>> Signed-off-by: Song Liu <song@kernel.org>
> >>>>> ---
> >>>>> tools/bpf/runqslower/runqslower.bpf.c | 19 +++++--------------
> >>>>> 1 file changed, 5 insertions(+), 14 deletions(-)
> >>>>>
> >>>>
> >>>> It would be much less disruptive if that prev_state was added after
> >>>> "next", but oh well...
> >>>
> >>> Maybe we should change that.
> >>>
> >>> +Valentin and Steven, how about we change the order with the attached
> >>> diff (not the original patch in this thread, but the one at the end of
> >>> this email)?
> >>>
> >>>>
> >>>> But anyways, let's handle this in a way that can handle both old
> >>>> kernels and new ones and do the same change in libbpf-tool's
> >>>> runqslower ([0]). Can you please follow up there as well?
> >>>
> >>> Yeah, I will also fix that one.
> >>
> >> Thanks!
> >>
> >>>
> >>>>
> >>>>
> >>>> We can use BPF CO-RE to detect which order of arguments running kernel
> >>>> has by checking prev_state field existence in struct
> >>>> trace_event_raw_sched_switch. Can you please try that? Use
> >>>> bpf_core_field_exists() for that.
> >>>
> >>> Do you mean something like
> >>>
> >>> if (bpf_core_field_exists(ctx->prev_state))
> >>>   /* use ctx[2] and ctx[3] */
> >>> else
> >>>   /* use ctx[1] and ctx[2] */
> >>
> >> yep, that's what I meant, except you don't have ctx->prev_state, you have to do:
> >>
> >> if (bpf_core_field_exists(((struct trace_event_raw_sched_switch
> >> *)0)->prev_state))
>
> Actually, struct trace_event_raw_sched_switch is not the arguments we
> have for tp_btf. For both older and newer kernel, it is the same:
>
> struct trace_event_raw_sched_switch {
>         struct trace_entry ent;
>         char prev_comm[16];
>         pid_t prev_pid;
>         int prev_prio;
>         long int prev_state;
>         char next_comm[16];
>         pid_t next_pid;
>         int next_prio;
>         char __data[0];
> };
>
> So I guess this check won't work?

Ah, you are right, we had prev_state in this struct before. There
seems to be func proto for each raw tracepoint:

typedef void (*btf_trace_sched_switch)(void *, bool, unsigned int,
struct task_struct *, struct task_struct *);

But I'm not sure if we can use that. I'll need to play with it a bit
tomorrow to see if any of bpf_core_xxx() checks can be used.

>
> Thanks,
> Song
>
