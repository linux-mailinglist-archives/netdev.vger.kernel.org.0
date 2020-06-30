Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3F620EC65
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 06:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgF3ESs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 00:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgF3ESr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 00:18:47 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6236DC061755;
        Mon, 29 Jun 2020 21:18:47 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id h22so13666733lji.9;
        Mon, 29 Jun 2020 21:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fIcivcJQm44ONQGpWrUS/jOeJybp0T780H6n/rm2fZc=;
        b=N19+uZB48xp0cwgT5xnjyce4SK6Ic2JBWjaCBUGZ+HB1erClgyvCRQQGME8Erdnjq5
         P8m3Tha1AEs6GY4r3KNqG+5LVDeDeuYZBCEFDGN7rmuf1YRXsRn6jDr4+lrzvg66OCe/
         wxkdH9jex/voPd3e7Cg6aLrmR76QdQsR10xQlZO9B2n82zQ4a0IB2jkQWqGKhTd1x9Ii
         liluWW6XIqYwyFOOQli0PAB2EB3t/DvpZOf/6Bh5pCnJc/57aqwhBWszHkk+KfUMuZta
         vQ7v5qF3P7u+tU33w1Y2XLFgm1tjkyZwJnrQYABmFSD2sAG2IvNnfiDlrC45Hw2gC27c
         3Dqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fIcivcJQm44ONQGpWrUS/jOeJybp0T780H6n/rm2fZc=;
        b=ESJwZgunABf5JARIMQqNrajKIBQemGzdKgN291UQIWH7EcgUfc9fqTwdZd/ZxVLR+P
         vK6zNmu9epd0YsRy+AtukguAl1NSEaV7QgcRGMclTJWjTuKQulC/kp/Jo2Ia6pZ3r1HY
         jEbRwnYVqmnrQ5G+JZawWmYDi01sankkvL5DwwpOr7mzLF2+rzBW7zzIZETvdDYRhNkN
         AKPpxNidfWndZVmwttxlQ2S6ccsIYweI0ag8+JzW1KfUuCV1LzTSXe4IMAoo36fM2/+Z
         jtVGUV3KTPOwUUHaBDx9/jFxC7GOcP+WYlSO4ye/NOMyxIk+evx27u03AovtU/Y9FuVy
         bJYg==
X-Gm-Message-State: AOAM530dUlYIBO5uq9pNqlf6uHS1rBjtfCX+WyYv3LxFinbzqZDMMaVm
        RafyGmh1tJiqXuHOdRkYXv29ttTTCMwmITqP/322pFu/
X-Google-Smtp-Source: ABdhPJy1uSSn6ryRl/N7NTdXm1Jmvx8sPoRiOi17vk97WqIHzuWzpubZl6FlSTjB+E+m4ZGKnju0ToazsxBFWSg1y+A=
X-Received: by 2002:a2e:8744:: with SMTP id q4mr9691671ljj.91.1593490724369;
 Mon, 29 Jun 2020 21:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200629055530.3244342-1-songliubraving@fb.com> <20200629055530.3244342-3-songliubraving@fb.com>
In-Reply-To: <20200629055530.3244342-3-songliubraving@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 29 Jun 2020 21:18:33 -0700
Message-ID: <CAADnVQJUdLKmdMu_eAX3ZGjf5K8GMkow+KoBSTTqy6CftgmdTw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: introduce helper bpf_get_task_stack()
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 28, 2020 at 10:58 PM Song Liu <songliubraving@fb.com> wrote:
>
> Introduce helper bpf_get_task_stack(), which dumps stack trace of given
> task. This is different to bpf_get_stack(), which gets stack track of
> current task. One potential use case of bpf_get_task_stack() is to call
> it from bpf_iter__task and dump all /proc/<pid>/stack to a seq_file.
>
> bpf_get_task_stack() uses stack_trace_save_tsk() instead of
> get_perf_callchain() for kernel stack. The benefit of this choice is that
> stack_trace_save_tsk() doesn't require changes in arch/. The downside of
> using stack_trace_save_tsk() is that stack_trace_save_tsk() dumps the
> stack trace to unsigned long array. For 32-bit systems, we need to
> translate it to u64 array.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>

It doesn't apply:
Applying: bpf: Introduce helper bpf_get_task_stack()
Using index info to reconstruct a base tree...
error: patch failed: kernel/bpf/stackmap.c:471
error: kernel/bpf/stackmap.c: patch does not apply
error: Did you hand edit your patch?
It does not apply to blobs recorded in its index.
Patch failed at 0002 bpf: Introduce helper bpf_get_task_stack()
