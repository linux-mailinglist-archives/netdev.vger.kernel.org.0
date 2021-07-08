Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48913C1A69
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 22:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhGHUOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 16:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbhGHUOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 16:14:55 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD521C061574;
        Thu,  8 Jul 2021 13:12:11 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id r132so10971814yba.5;
        Thu, 08 Jul 2021 13:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qUoXmgfDRIrE6Sw3Tl89d1vioc1YaayPXy4rZv3UWRo=;
        b=pNGlv9A03iEGqOI7nFxjk986edB4FHSPI/YaXzIN17jptYryb0ruRbUSb9OGU+FoLV
         sdL4dfHaiOxeRb/3gnV0yuYJUrkkg4p89NAZjzF82fTlycNZbbLUyh3agS526NjBIldm
         RXma8HUSKuyZUFPxRLlT7VRTe4BJQ+1bO2UiB4DsMTFUUuU6zDZdMW1OPujnfc+XU718
         CL4aa1XvEKn6DlVXYJQ+dJ2O9VR5bNytuRS0RdSbwlYXGx3MqaDZjG366G246y8kCNLl
         s4Dm7c9tIT3YGzfj5D8MkTSiGLxm0KhClPhXGPtKugTtusgDpEL9s3zjZioRRFU1qG9F
         kLoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qUoXmgfDRIrE6Sw3Tl89d1vioc1YaayPXy4rZv3UWRo=;
        b=j99e0OnCslzttx+Z6YJhx0YyCZCfnzGJF4aoOqMv01YTMWAS9AyZWbGn0ECWX2aie7
         oImYvyWLnyzfaE/7ntMSqO0k8v22i0aFPuJVD7u33tWl2mKx9duAAZhsG49hHlA09hW+
         UxF6+WscUoEHMGTUHgCMbwWSmQ9t1yn/f7GRCOMux1mzWvFXYsfBRWgOhKEhijjij5sW
         bO8OlVd8RWe7nBvwY9hXaGY45XoXVY9QCuy0yaGsgd1d3GWUiN43pjm387NaCXKssWxc
         tkKSk3ZOVb4XUkgjFz0zPES+On38zfdrBL1yEAS2pRoeqwaJ8vDU/WlVHC71g18Aa31n
         8E/A==
X-Gm-Message-State: AOAM533J/00ly5CP9xOiY1FNaQyk+JC0eV5BNrZvE09pBneKw6a4Avou
        KvrwMdhoUd+wv7ldowJ+v5xsoW+Bu4BqtdfstZc=
X-Google-Smtp-Source: ABdhPJzxHJlvWIHyHGB0D5J9kresjZ08/xf5Mnaz1iibS3BMPbE9EPqDqd2Vo4d/nsLbEOAItlDvqa/0tla8avcgEHg=
X-Received: by 2002:a25:b741:: with SMTP id e1mr42982364ybm.347.1625775130988;
 Thu, 08 Jul 2021 13:12:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210629095543.391ac606@oasis.local.home> <CAEf4BzZPb=cPf9V1Bz+USiq+b5opUTNkj4+CRjXdHcmExW3jVg@mail.gmail.com>
 <20210707184518.618ae497@rorschach.local.home> <CAEf4BzZ=hFZw1RNx0Pw=kMNq2xRrqHYCQQ_TY_pt86Zg9HFJfA@mail.gmail.com>
 <20210707200544.1fbfd42b@rorschach.local.home> <CAEf4BzYRxRW8qR3oENuVEMBYtcvK0bUDEkoq+e4TRT5Hh0pV_Q@mail.gmail.com>
 <12904992.10404.1625765442490.JavaMail.zimbra@efficios.com>
In-Reply-To: <12904992.10404.1625765442490.JavaMail.zimbra@efficios.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 8 Jul 2021 13:11:59 -0700
Message-ID: <CAEf4BzZAO59HDw1+YRj+bN9fU1b183a+6dRUp+NNuhdnnYA=AQ@mail.gmail.com>
Subject: Re: [PATCH] tracepoint: Add tracepoint_probe_register_may_exist() for
 BPF tracing
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        syzbot+721aa903751db87aa244@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 10:30 AM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> ----- On Jul 7, 2021, at 8:23 PM, Andrii Nakryiko andrii.nakryiko@gmail.com wrote:
>
> > On Wed, Jul 7, 2021 at 5:05 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >>
> >> On Wed, 7 Jul 2021 16:49:26 -0700
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >>
> >> > As for why the user might need that, it's up to the user and I don't
> >> > want to speculate because it will always sound contrived without a
> >> > specific production use case. But people are very creative and we try
> >> > not to dictate how and what can be done if it doesn't break any
> >> > fundamental assumption and safety.
> >>
> >> I guess it doesn't matter, because if they try to do it, the second
> >> attachment will simply fail to attach.
> >>
> >
> > But not for the kprobe case.
> >
> > And it might not always be possible to know that the same BPF program
> > is being attached. It could be attached by different processes that
> > re-use pinned program (without being aware of each other). Or it could
> > be done from some generic library that just accepts prog_fd and
> > doesn't really know the exact BPF program and whether it was already
> > attached.
> >
> > Not sure why it doesn't matter that attachment will fail where it is
> > expected to succeed. The question is rather why such restriction?
>
> Before eBPF came to exist, all in-kernel users of the tracepoint API never
> required multiple registrations for a given (tracepoint, probe, data) tuple.
>
> This allowed us to expose an API which can consider that the (tracepoint, probe, data)
> tuple is unique for each registration/unregistration pair, and therefore use that same
> tuple for unregistration. Refusing multiple registrations for a given tuple allows us to
> forgo the complexity of reference counting for duplicate registrations, and provide
> immediate feedback to misbehaving tracers which have duplicate registration or
> unbalanced registration/unregistration pairs.
>
> From the perspective of a ring buffer tracer, the notion of multiple instances of
> a given (tracepoint, probe, data) tuple is rather silly: it would mean that a given
> tracepoint hit would generate many instances of the exact same event into the
> same trace buffer.
>
> AFAIR, having the WARN_ON_ONCE() within the tracepoint code to highlight this kind of misuse
> allowed Steven to find a few unbalanced registration/unregistration issues while developing
> ftrace in the past. I vaguely recall that it triggered for blktrace at some point as well.
>
> Considering that allowing duplicates would add complexity to the tracepoint code,
> what is the use-case justifying allowing many instances of the exact same callback
> and data for a given tracepoint ?

It wasn't clear to me if supporting this would cause any added
complexity, which is why I asked.

>
> One key difference I notice here between eBPF and ring buffer tracers is what eBPF
> considers a "program". AFAIU (please let me know if I'm mistaken), the "callback"
> argument provided by eBPF to the tracepoint API is a limited set of trampoline routines.
> The bulk of the eBPF "program" is provided in the "data" argument. So this means the
> "program" is both the eBPF code and some context.
>
> So I understand that a given eBPF code could be loaded more than once for a given

No, it turns out it can't, I was just surprised to learn that.
Surprised, because AFAIK we don't have such restrictions on uniqueness
of attached BPF programs anywhere else where multiple BPF programs are
allowed.

> tracepoint, but I would expect that each registration on a given tracepoint be
> provided with its own "context", otherwise we end up in a similar situation as the
> ring buffer's duplicated events scenario I explained above.
>
> Also, we should discuss whether kprobes might benefit from being more strict by
> rejecting duplicated (instrumentation site, probe, data) tuples.
>
> Thanks,
>
> Mathieu
>
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
