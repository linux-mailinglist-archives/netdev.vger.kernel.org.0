Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E6C20BCF0
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgFZWvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgFZWvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 18:51:20 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821F7C03E979;
        Fri, 26 Jun 2020 15:51:20 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id h23so8769276qtr.0;
        Fri, 26 Jun 2020 15:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8HWO0SS+0P6uz8QKcTGg5GM74omnlEcycJKWzTuQqgw=;
        b=JIF9V2neAo3LDYaCCpQHM7tlzFYnCVM6vrrwKOwdygR9cYlw9fFpc1I+ByHQ7ggp1h
         wOxdl5nacpcSjF9pEmq7bohWDFU6y4iO2mY7OVe0vmmdXzht2Mc82LD8/g+5YwqJtVxi
         +xQ5TzaQDkEzOLHLjD/eISW23FIoftXnaueWUrJJ5g8pO36wlOjoc8jAJR3ToOVDlWra
         OBGfbY7vxOZAhaGoPnPkTki3lsaw8JPkFxqLEuKsOys93f0KupsXHS4KFFIKVfM5knYX
         GCia7wp7cLOAa71CK+GTY2RjEXJgQ4tutKVD4H5DRxhCMGMOF3Jr9ViS9dFXHTDtwho0
         BYwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8HWO0SS+0P6uz8QKcTGg5GM74omnlEcycJKWzTuQqgw=;
        b=dR1L4InE+E7pqYtVAIF53O4gON3PUqS7ON6DIeJ0wIzCGIFnp64VmnJbtacEowOMez
         yy+ShEv9LpZNeoHQr3aicnRI4kzs3zJYJsJrJ55mAz+MDqeQAMTUxWJgoT8r7qSTzj3G
         NCfXcOGkNDTWJzFt2FzgUBeruu2LihntoV4w7EdRa8rKualllm+12C0j2DWcGfX8lw1Z
         62xaNCDBAFSO4q2XLqVmEhZ8ja4zJytGytpAHo8ItUEpeh/tmQnT+q8PsTWa+Blg0F0Z
         uUxzj5qrxWkJrCL8OrZua21o8D+WoiN7CyijHbG6UXHAwbUu5zipXWUf7/8jdwHsHaT2
         Qfig==
X-Gm-Message-State: AOAM530KGxC1dQ8Hskk/zgTlOUY+DH/+jxG9/85jWUDd/4VXl1Gh0SVx
        HG1GwZrqKVp2JYOO2Dr1+01ySWCSxtdY9svMeGA=
X-Google-Smtp-Source: ABdhPJzC8dhF/xlo983MA3Zz0/1x7CyKxQWxuD3XyPOv8m23hLlCFcNZQTPGDbdHzFhjd2XIXe4k1f4jPnLztokYdeM=
X-Received: by 2002:ac8:1991:: with SMTP id u17mr5021097qtj.93.1593211879622;
 Fri, 26 Jun 2020 15:51:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200626001332.1554603-1-songliubraving@fb.com>
 <20200626001332.1554603-3-songliubraving@fb.com> <CAEf4BzZ6-s-vqp+bLiCAVgS2kmp09a1WdaSvaL_jJySx7s7inA@mail.gmail.com>
 <C3B6DD3E-1B69-4D0C-8A55-4EB81C21C619@fb.com>
In-Reply-To: <C3B6DD3E-1B69-4D0C-8A55-4EB81C21C619@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 15:51:08 -0700
Message-ID: <CAEf4BzaC1Dqn3PXBJmczPRaUmjKc7pcg6_mjyKymBek-sDKv7Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/4] bpf: introduce helper bpf_get_task_stak()
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 3:45 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jun 26, 2020, at 1:17 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Jun 25, 2020 at 5:14 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >> Introduce helper bpf_get_task_stack(), which dumps stack trace of given
> >> task. This is different to bpf_get_stack(), which gets stack track of
> >> current task. One potential use case of bpf_get_task_stack() is to call
> >> it from bpf_iter__task and dump all /proc/<pid>/stack to a seq_file.
> >>
> >> bpf_get_task_stack() uses stack_trace_save_tsk() instead of
> >> get_perf_callchain() for kernel stack. The benefit of this choice is that
> >> stack_trace_save_tsk() doesn't require changes in arch/. The downside of
> >> using stack_trace_save_tsk() is that stack_trace_save_tsk() dumps the
> >> stack trace to unsigned long array. For 32-bit systems, we need to
> >> translate it to u64 array.
> >>
> >> Signed-off-by: Song Liu <songliubraving@fb.com>
> >> ---
> >
> > Looks great, I just think that there are cases where user doesn't
> > necessarily has valid task_struct pointer, just pid, so would be nice
> > to not artificially restrict such cases by having extra helper.
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> Thanks!
>
> >
> >> include/linux/bpf.h            |  1 +
> >> include/uapi/linux/bpf.h       | 35 ++++++++++++++-
> >> kernel/bpf/stackmap.c          | 79 ++++++++++++++++++++++++++++++++--
> >> kernel/trace/bpf_trace.c       |  2 +
> >> scripts/bpf_helpers_doc.py     |  2 +
> >> tools/include/uapi/linux/bpf.h | 35 ++++++++++++++-
> >> 6 files changed, 149 insertions(+), 5 deletions(-)
> >>
> >
> > [...]
> >
> >> +       /* stack_trace_save_tsk() works on unsigned long array, while
> >> +        * perf_callchain_entry uses u64 array. For 32-bit systems, it is
> >> +        * necessary to fix this mismatch.
> >> +        */
> >> +       if (__BITS_PER_LONG != 64) {
> >> +               unsigned long *from = (unsigned long *) entry->ip;
> >> +               u64 *to = entry->ip;
> >> +               int i;
> >> +
> >> +               /* copy data from the end to avoid using extra buffer */
> >> +               for (i = entry->nr - 1; i >= (int)init_nr; i--)
> >> +                       to[i] = (u64)(from[i]);
> >
> > doing this forward would be just fine as well, no? First iteration
> > will cast and overwrite low 32-bits, all the subsequent iterations
> > won't even overlap.
>
> I think first iteration will write zeros to higher 32 bits, no?

Oh, wait, I completely misread what this is doing. It up-converts from
32-bit to 64-bit, sorry. Yeah, ignore me on this :)

But then I have another question. How do you know that entry->ip has
enough space to keep the same number of 2x bigger entries?

>
> >
> >> +       }
> >> +
> >> +exit_put:
> >> +       put_callchain_entry(rctx);
> >> +
> >> +       return entry;
> >> +}
> >> +
> >
> > [...]
> >
> >> +BPF_CALL_4(bpf_get_task_stack, struct task_struct *, task, void *, buf,
> >> +          u32, size, u64, flags)
> >> +{
> >> +       struct pt_regs *regs = task_pt_regs(task);
> >> +
> >> +       return __bpf_get_stack(regs, task, buf, size, flags);
> >> +}
> >
> >
> > So this takes advantage of BTF and having a direct task_struct
> > pointer. But for kprobes/tracepoint I think it would also be extremely
> > helpful to be able to request stack trace by PID. How about one more
> > helper which will wrap this one with get/put task by PID, e.g.,
> > bpf_get_pid_stack(int pid, void *buf, u32 size, u64 flags)? Would that
> > be a problem?
>
> That should work. Let me add that in a follow up patch.
>
