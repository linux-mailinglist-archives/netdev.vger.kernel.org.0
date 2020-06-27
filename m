Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A2F20BD5B
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 02:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgF0AGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 20:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbgF0AGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 20:06:36 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC77C03E979;
        Fri, 26 Jun 2020 17:06:36 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id u17so8862412qtq.1;
        Fri, 26 Jun 2020 17:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=udBllLsYA6lB00cOOJeSI526QRhFyN1UuKw5hU7KkHo=;
        b=febIOE8be8srwpirNRekGtuSASef3Zu8G9ORyVKjmYgcKvf3IAu/EwRI7QJA5s9B/N
         9868iMPjM0OFZaxWhKExEh2ykodEtbpFhCfvumLlH+hRxklCxE8AKH4yhK/gAlwnvMWQ
         kkMhttGQYvOcdHYJis2B87ZT2ajqVkhYVyxFB1GyNfyedwKHVPZT4uWQsNZpAnOfQ5Yc
         0zEmUg5QTLwt1TzOPN+WQTqftA+O8mmi7bczGKtOVT9j9A1U7keM7z9PO/RMzAXwvePf
         b6ZAf+nMvtrtc6lawua5zQLI6kDnEbPrm4ahPvf18ImFrhyqhymGPsYCIwi/gKMwFyiX
         a+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=udBllLsYA6lB00cOOJeSI526QRhFyN1UuKw5hU7KkHo=;
        b=Mxx+SR86CYUPIg5FSiWSE2csxDHwrXoph9uW6en6XAmNlKH1ajvPnx1BwMQdYvstfE
         0I2mtYWqoLtmldPBkihPrEBMswmNS9yZb8T9RMpyH0X/P/MWLU2nrUONIaWSKoi7k4yh
         HnMGCDKDQnLV23Gf/XUWPqdvncHPBIzJO+lQp2L8Fiel4XlALGZwYy4+vV4sqOHRrIiQ
         PtMG3I6bpn7ILseOzTVnErxyByaEnIpDjhvHH7cqwaIB6BCfTbDEO+4sgMOJIlXV5I2P
         KB2nJBlsCId1BmtkRgGyeisJ4kPphaXwM5pYENfxToaMEI2GjJUGOhtctJu42FtZSOHs
         yLCw==
X-Gm-Message-State: AOAM5302MaKWJ8S64nRz55RKec2vrenyO9Jzx6sG0ESKm49CJZtIlUue
        +M4JK7kkPVbpKIw6ZuUEbyy2Y5WWnIPaOh1WG6Y=
X-Google-Smtp-Source: ABdhPJzHtkpQ4mcoJjnIF7AdtA+0kYcRkb2AhTvezqXZVa2Kg9FixR+Q8uqSgoJy7UVMbQkcs3AaFOB12M+mSWc7VA4=
X-Received: by 2002:ac8:1991:: with SMTP id u17mr5271867qtj.93.1593216395389;
 Fri, 26 Jun 2020 17:06:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200626001332.1554603-1-songliubraving@fb.com>
 <20200626001332.1554603-3-songliubraving@fb.com> <CAEf4BzZ6-s-vqp+bLiCAVgS2kmp09a1WdaSvaL_jJySx7s7inA@mail.gmail.com>
 <C3B6DD3E-1B69-4D0C-8A55-4EB81C21C619@fb.com> <CAEf4BzaC1Dqn3PXBJmczPRaUmjKc7pcg6_mjyKymBek-sDKv7Q@mail.gmail.com>
 <AD7AE0B3-94F9-4430-990C-85B9CF431EC7@fb.com>
In-Reply-To: <AD7AE0B3-94F9-4430-990C-85B9CF431EC7@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 17:06:24 -0700
Message-ID: <CAEf4BzZSioccpzc-OXEZqRo-VLP6RE8nEtxXEWEmAOpnmPWWvw@mail.gmail.com>
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

On Fri, Jun 26, 2020 at 4:47 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jun 26, 2020, at 3:51 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Jun 26, 2020 at 3:45 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Jun 26, 2020, at 1:17 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >>>
> >>> On Thu, Jun 25, 2020 at 5:14 PM Song Liu <songliubraving@fb.com> wrote:
> >>>>
> >>>> Introduce helper bpf_get_task_stack(), which dumps stack trace of given
> >>>> task. This is different to bpf_get_stack(), which gets stack track of
> >>>> current task. One potential use case of bpf_get_task_stack() is to call
> >>>> it from bpf_iter__task and dump all /proc/<pid>/stack to a seq_file.
> >>>>
> >>>> bpf_get_task_stack() uses stack_trace_save_tsk() instead of
> >>>> get_perf_callchain() for kernel stack. The benefit of this choice is that
> >>>> stack_trace_save_tsk() doesn't require changes in arch/. The downside of
> >>>> using stack_trace_save_tsk() is that stack_trace_save_tsk() dumps the
> >>>> stack trace to unsigned long array. For 32-bit systems, we need to
> >>>> translate it to u64 array.
> >>>>
> >>>> Signed-off-by: Song Liu <songliubraving@fb.com>
> >>>> ---
> >>>
> >>> Looks great, I just think that there are cases where user doesn't
> >>> necessarily has valid task_struct pointer, just pid, so would be nice
> >>> to not artificially restrict such cases by having extra helper.
> >>>
> >>> Acked-by: Andrii Nakryiko <andriin@fb.com>
> >>
> >> Thanks!
> >>
> >>>
> >>>> include/linux/bpf.h            |  1 +
> >>>> include/uapi/linux/bpf.h       | 35 ++++++++++++++-
> >>>> kernel/bpf/stackmap.c          | 79 ++++++++++++++++++++++++++++++++--
> >>>> kernel/trace/bpf_trace.c       |  2 +
> >>>> scripts/bpf_helpers_doc.py     |  2 +
> >>>> tools/include/uapi/linux/bpf.h | 35 ++++++++++++++-
> >>>> 6 files changed, 149 insertions(+), 5 deletions(-)
> >>>>
> >>>
> >>> [...]
> >>>
> >>>> +       /* stack_trace_save_tsk() works on unsigned long array, while
> >>>> +        * perf_callchain_entry uses u64 array. For 32-bit systems, it is
> >>>> +        * necessary to fix this mismatch.
> >>>> +        */
> >>>> +       if (__BITS_PER_LONG != 64) {
> >>>> +               unsigned long *from = (unsigned long *) entry->ip;
> >>>> +               u64 *to = entry->ip;
> >>>> +               int i;
> >>>> +
> >>>> +               /* copy data from the end to avoid using extra buffer */
> >>>> +               for (i = entry->nr - 1; i >= (int)init_nr; i--)
> >>>> +                       to[i] = (u64)(from[i]);
> >>>
> >>> doing this forward would be just fine as well, no? First iteration
> >>> will cast and overwrite low 32-bits, all the subsequent iterations
> >>> won't even overlap.
> >>
> >> I think first iteration will write zeros to higher 32 bits, no?
> >
> > Oh, wait, I completely misread what this is doing. It up-converts from
> > 32-bit to 64-bit, sorry. Yeah, ignore me on this :)
> >
> > But then I have another question. How do you know that entry->ip has
> > enough space to keep the same number of 2x bigger entries?
>
> The buffer is sized for sysctl_perf_event_max_stack u64 numbers.
> stack_trace_save_tsk() will put at most stack_trace_save_tsk unsigned
> long in it (init_nr == 0). So the buffer is big enough.
>

Awesome, thanks for clarification!

> Thanks,
> Song
