Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82C5205AFE
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 20:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733224AbgFWSmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 14:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733170AbgFWSmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 14:42:06 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BCAC061573;
        Tue, 23 Jun 2020 11:42:05 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id j80so8488772qke.0;
        Tue, 23 Jun 2020 11:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t7MvO0YdqXBHz7/my2KwAic/d907Z4KkB8tqAMCBS6Y=;
        b=hBxGNazLGPGiCSmjFnc2ZZrMXY0uX5zE1UnA98zuPxMduYTZm2VV3vbdO2x4KIrkHz
         Q0UlZBTffZu7smJDaYDhoKFn0Dbc2Vy6syxhXUJ2bjDMxngSWtTYXh0IVOB5+rNVghY0
         F6MKmRVEUp6HIckptBkbabBLYJIU39fvTchLFZQF5sE6P8JxzYe9UoFSBE+qaLkJU6R7
         GYQql8BzygfSp8V9C8oQdqWRY1oIjLM7JpXKpY5OF/kJaqXenspfWd6US9fn6Xdlp7Ls
         a8B2xnI6BvkJHe4BMbltotxbmGukHkVyiLwlBocsZe1b3m4mi4y5kQSxIEZgoPAadW3u
         Lq/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t7MvO0YdqXBHz7/my2KwAic/d907Z4KkB8tqAMCBS6Y=;
        b=bwr4p43raXeN1Qj5BYwJb+hlS8rLSnKyBDBg3KD/qEU8PURd7lDuGq4/0rTaGXLpv3
         HwF2dOiXghPAJJOp0FJKlakSiF4wvyIybbmkh+VzpIic0qhoPgCWDK1QJdNkYy9/kWiE
         RFbk0R72g8GAyUSAHb6SevHVvCQ+5TJanP8uztQGiSdYNRDfZG8+o2y8z4qnNiKZYS6m
         NsHlV4D+qoeD+DJYV3KmiHQv7ygeh3sTmTo1mBBWjDPVFog0yQGWNoWxxg2N7b3Xrak1
         999b9HfLu1qxkwAe1O+iIrJHqQn1SqC8dfLgc8RzN3U1tGi0bbICAFkJQ8Cs3b5jgJ7Y
         tTzQ==
X-Gm-Message-State: AOAM533KnYzxDYkujWTaVQjPNMgJVkFxovSbkAy5oFlDvtB5SW/Z8CvU
        ra9+Lp4GraUKeXf79BHF2yEk7zcI26T7Y8zwtlg=
X-Google-Smtp-Source: ABdhPJxCPX2fbx6uY41f/rwL3YEd4GBv3jKv/8lOffI1bQRZNANNYqFwvdHOgbyhB+oRryHeI1l4YnmBtyD0AEm5las=
X-Received: by 2002:a05:620a:b84:: with SMTP id k4mr21853927qkh.39.1592937724906;
 Tue, 23 Jun 2020 11:42:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200623070802.2310018-1-songliubraving@fb.com>
 <20200623070802.2310018-2-songliubraving@fb.com> <CAADnVQJxinR1fY69hf_rLShdbi947DjGXAH+55eZQDTtm4VBRg@mail.gmail.com>
 <FF92494E-D1EB-4B84-9D2F-8CD43FEAB164@fb.com>
In-Reply-To: <FF92494E-D1EB-4B84-9D2F-8CD43FEAB164@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 11:41:53 -0700
Message-ID: <CAEf4BzaJutuzLigcOPym76iL3d4+y2FVGXEkNdAdbYqDGxDryg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: introduce helper bpf_get_task_stack_trace()
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 10:00 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jun 23, 2020, at 8:19 AM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Jun 23, 2020 at 12:08 AM Song Liu <songliubraving@fb.com> wrote:
> >>
>
> [...]
>
> >>
> >> +BPF_CALL_3(bpf_get_task_stack_trace, struct task_struct *, task,
> >> +          void *, entries, u32, size)
> >> +{
> >> +       return stack_trace_save_tsk(task, (unsigned long *)entries, size, 0);
> >> +}
> >> +
> >> +static int bpf_get_task_stack_trace_btf_ids[5];
> >> +static const struct bpf_func_proto bpf_get_task_stack_trace_proto = {
> >> +       .func           = bpf_get_task_stack_trace,
> >> +       .gpl_only       = true,
> >
> > why?
>
> Actually, I am not sure when we should use gpl_only = true.
>
> >
> >> +       .ret_type       = RET_INTEGER,
> >> +       .arg1_type      = ARG_PTR_TO_BTF_ID,
> >> +       .arg2_type      = ARG_PTR_TO_MEM,
> >> +       .arg3_type      = ARG_CONST_SIZE_OR_ZERO,
> >
> > OR_ZERO ? why?
>
> Will fix.

I actually think it's a good idea, because it makes writing code that
uses variable-sized buffers easier. Remember how we had
bpf_perf_event_output() forcing size > 0? That was a major PITA and
required unnecessary code gymnastics to prove verifier it's OK (even
if zero size was never possible). Yonghong eventually fixed that to be
_OR_ZERO.

So if this is not causing any problems, please leave it as _OR_ZERO.
Thank you from everyone who had to suffer through dealing with
anything variable-sized in BPF!

>
> >
> >> +       .btf_id         = bpf_get_task_stack_trace_btf_ids,
> >> +};
> >> +
> >> static const struct bpf_func_proto *
> >> raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >> {
> >> @@ -1521,6 +1538,10 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >>                return prog->expected_attach_type == BPF_TRACE_ITER ?
> >>                       &bpf_seq_write_proto :
> >>                       NULL;
> >> +       case BPF_FUNC_get_task_stack_trace:
> >> +               return prog->expected_attach_type == BPF_TRACE_ITER ?
> >> +                       &bpf_get_task_stack_trace_proto :
> >
> > why limit to iter only?
>
> I guess it is also useful for other types. Maybe move to bpf_tracing_func_proto()?
>
> >
> >> + *
> >> + * int bpf_get_task_stack_trace(struct task_struct *task, void *entries, u32 size)
> >> + *     Description
> >> + *             Save a task stack trace into array *entries*. This is a wrapper
> >> + *             over stack_trace_save_tsk().
> >
> > size is not documented and looks wrong.
> > the verifier checks it in bytes, but it's consumed as number of u32s.
>
> I am not 100% sure, but verifier seems check it correctly. And I think it is consumed
> as u64s?
>
> Thanks,
> Song
>
