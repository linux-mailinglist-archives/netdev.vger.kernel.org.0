Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA783F68BA
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 20:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239102AbhHXSFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 14:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239001AbhHXSE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 14:04:59 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC787C0612A5;
        Tue, 24 Aug 2021 11:02:14 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id e129so18700839yba.5;
        Tue, 24 Aug 2021 11:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tXuvbx4nZlhmaV4EA6JIVsrb39knE2b2DAiN0VBzugc=;
        b=YG0SPpPvRtbUfxLbb6G8h6QKA4maVVSr7raR6jGdHm2PVCeQbhItoQU2wWDFkyy5/0
         mc4U8e3LPC8N89jnCFlPs9RzBhCfRJsSuySVyTZyQwZ7WuJ/mo1EVoLrTfNjsMbwYo1I
         nTEXahpnCAs5y4x93Pt7AopQI7O1qR4IuJhaL5n5iyK22Pyngf2My3L0TYLVYGuUmcfc
         NSddosDUPym3mLWWIburkpIG3csVKsagKMm9wLlEP4dz1SO1jClhkBj+hl2TG9OhwnfB
         7W5UE/aaki9btGT/8OIR9j0NlUKp+rQR8Z9RsbSpM9/zCLzl5ZVKpOE6h1hlI0gLgmmn
         nHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tXuvbx4nZlhmaV4EA6JIVsrb39knE2b2DAiN0VBzugc=;
        b=ZF3iPE/stRz0iOqfHeshtSDL+kA7LL1IQJkmfC4gOMB/QMFnzujcbePQCsOs9vqW82
         puM7ArLS0qbPxVYUL6Th8FPj3UxEgHHhrCdddi+2DuuJUKjTlMnMS66PclhD809jGyCq
         sVC9Wq7TrPNJIvgkS1gezfLLS7M7yQI4ykUsrUm8VS+8kQV5tWl0EqO3vo9Him3JVjEg
         xuOU1lClm4d81vmKKVh95XKiJYbq7tL14EE/XjOO84Z+vF3ShjdMN3fCL2tCsj8d6bUp
         4MxEj/2zNkuTTv/LbVQzNwKnqp8MBnXy1H9B5Cojh+qBZu2G/ljFF1DZaJgDHFo3QpCR
         2PyA==
X-Gm-Message-State: AOAM53153A34riKOUK1wumC29z/eBREYq9LVxgUKGfcjUF5kGYluSnNe
        7zdUaMMNHDylLexBqRGCRHKpPgLe7TuZk/8gvg0=
X-Google-Smtp-Source: ABdhPJxmDR9Lo2cK81h9/9Zkn7cPV94+y4ntFxPhY7MAmbbtLmwiRNwEcOr1NlXpevQWF9hMp/vjhpocbhyWHa3x8YM=
X-Received: by 2002:a25:bb13:: with SMTP id z19mr54405034ybg.347.1629828134092;
 Tue, 24 Aug 2021 11:02:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210821025837.1614098-1-davemarchevsky@fb.com>
 <20210821025837.1614098-3-davemarchevsky@fb.com> <CAEf4BzYEOzfmwi8n8K_W_6Pc+gC081ncmRCAq8Fz0vr=y7eMcg@mail.gmail.com>
 <CAADnVQLUWHO0EhLhMVATc9-z11H7ROF6DCmJ=sW+-iP1baeWWg@mail.gmail.com>
In-Reply-To: <CAADnVQLUWHO0EhLhMVATc9-z11H7ROF6DCmJ=sW+-iP1baeWWg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 24 Aug 2021 11:02:03 -0700
Message-ID: <CAEf4Bza30Rkg02AzmG7Mw5AyE1wykPBuH6f_fXAQXLu2qH2POA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] bpf: add bpf_trace_vprintk helper
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Dave Marchevsky <davemarchevsky@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Florent Revest <revest@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 10:57 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Aug 23, 2021 at 9:50 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Aug 20, 2021 at 7:59 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
> > >
> > > This helper is meant to be "bpf_trace_printk, but with proper vararg
> >
> > We have bpf_snprintf() and bpf_seq_printf() names for other BPF
> > helpers using the same approach. How about we call this one simply
> > `bpf_printf`? It will be in line with other naming, it is logical BPF
> > equivalent of user-space printf (which outputs to stderr, which in BPF
> > land is /sys/kernel/debug/tracing/trace_pipe). And it will be logical
> > to have a nice and short BPF_PRINTF() convenience macro provided by
> > libbpf.
> >
> > > support". Follow bpf_snprintf's example and take a u64 pseudo-vararg
> > > array. Write to dmesg using the same mechanism as bpf_trace_printk.
> >
> > Are you sure about the dmesg part?... bpf_trace_printk is outputting
> > into /sys/kernel/debug/tracing/trace_pipe.
>
> Actually I like bpf_trace_vprintk() name, since it makes it obvious that

It's the inconsistency with bpf_snprintf() and bpf_seq_printf() that's
mildly annoying (it's f at the end, and no v- prefix). Maybe
bpf_trace_printf() then? Or is it too close to bpf_trace_printk()? But
either way you would be using BPF_PRINTF() macro for this. And we can
make that macro use bpf_trace_printk() transparently for <3 args, so
that new macro works on old kernels.

> it's a flavor of bpf_trace_printk() and its quirks that users learned
> to deal with.
> I would reserve bpf_printf() for the future. We might have standalone
> bpf programs in the future (without user space component) and a better
> equivalent
> of stdin/stdout. clang -target bpf hello_world.c -o a.out; ./a.out
> should print to a terminal. Such future hello world in bpf would be
> using bpf_printf()
> or bpf_dprintf().
