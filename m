Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157AA3BF1E0
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 00:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhGGWPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 18:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhGGWPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 18:15:21 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76615C061574;
        Wed,  7 Jul 2021 15:12:40 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id p22so5609251yba.7;
        Wed, 07 Jul 2021 15:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MdPt0oq/vKS4ICfv8ZQphtQFxhDUMZFfKRMi4FYddHs=;
        b=RkdfLZsNpHKWdt5fZkzMO6o6r4FmBjDyJSo292xzKLQlVhdGlxlwJbxQOBref2FRu9
         USCF2w7/4pwLYKJMeCHhe8vVMLlWnLS+0b/l2y6lemaCqLnBl2VVTgzbEFl8Lk2ky7Qs
         RdqBXLwPl25T8mz84Ron1ZZxERj5HdR2DpeZAlNYoVBzoZlvhO9oK+/BOyLdC133zI2E
         r/GRIGWFSOYHHC8Q7p4UySmikkNqGpt1zI1tdLu20VKE39pdEM//3A8rOvMxNU0dZzMe
         mktKgRgMGQn/VHfYdvq+/CTWNs6mIG3gQcccUxUEIsniSEZPlTSpgOV3Hnk18dYhF8No
         NT5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MdPt0oq/vKS4ICfv8ZQphtQFxhDUMZFfKRMi4FYddHs=;
        b=ZFAYViAdybNsJGKaBUz15cYsvjD6nOTjPPXKNxcjSIguPM+JIqvmbIy9eKDGngMqsA
         3fgqHQcd/mPmMDNUeVHOUQ9j8sXwmAziK0Yvrfx83PUj51ip80ozbKzqRS7FVBH9YI9c
         Z7FADW3xXml8f+Iz8wAooY9IF/LXgkjlRXVq2KmHk/f+CfWlO39YMiW0OShy5BC2tG4R
         Cg3mFsLjMQQf8u9VaeThGD2RmDEWoOWXbxumE22vbluKeUMhGxra+XicDN0FY/6ZAr3I
         CuLA47PwRj/PicJr4h4Y+rXJcmnsrArjGRpP+XMRQwVJU7HbCMaGD4rhmF0xRr5YoVp7
         jO0g==
X-Gm-Message-State: AOAM531pXatx9rSyunM4yARP8DhnZi+LPubhe7B5X356v8v7ksG7tSRr
        PDOWHtuS2ORvWucaAprs1xxybrE/Qe0sPtbbICw=
X-Google-Smtp-Source: ABdhPJzZwr8pCSLQ9N8a7YQsdKSZRDBgodDVU03Hl/qVSzaWuHLER0vD24i4DPNyN5ltxPC8HPQOLRjS8wA5903Q84k=
X-Received: by 2002:a25:3787:: with SMTP id e129mr34273898yba.459.1625695959718;
 Wed, 07 Jul 2021 15:12:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210629095543.391ac606@oasis.local.home>
In-Reply-To: <20210629095543.391ac606@oasis.local.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Jul 2021 15:12:28 -0700
Message-ID: <CAEf4BzZPb=cPf9V1Bz+USiq+b5opUTNkj4+CRjXdHcmExW3jVg@mail.gmail.com>
Subject: Re: [PATCH] tracepoint: Add tracepoint_probe_register_may_exist() for
 BPF tracing
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        syzbot+721aa903751db87aa244@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 6:55 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> All internal use cases for tracepoint_probe_register() is set to not ever
> be called with the same function and data. If it is, it is considered a
> bug, as that means the accounting of handling tracepoints is corrupted.
> If the function and data for a tracepoint is already registered when
> tracepoint_probe_register() is called, it will call WARN_ON_ONCE() and
> return with EEXISTS.
>
> The BPF system call can end up calling tracepoint_probe_register() with
> the same data, which now means that this can trigger the warning because
> of a user space process. As WARN_ON_ONCE() should not be called because
> user space called a system call with bad data, there needs to be a way to
> register a tracepoint without triggering a warning.
>
> Enter tracepoint_probe_register_may_exist(), which can be called, but will
> not cause a WARN_ON() if the probe already exists. It will still error out
> with EEXIST, which will then be sent to the user space that performed the
> BPF system call.
>
> This keeps the previous testing for issues with other users of the
> tracepoint code, while letting BPF call it with duplicated data and not
> warn about it.

There doesn't seem to be anything conceptually wrong with attaching
the same BPF program twice to the same tracepoint. Is it a hard
requirement to have a unique tp+callback combination, or was it done
mostly to detect an API misuse? How hard is it to support such use
cases?

I was surprised to discover this is not supported (though I never had
a use for this, had to construct a test to see the warning).

>
> Link: https://lore.kernel.org/lkml/20210626135845.4080-1-penguin-kernel@I-love.SAKURA.ne.jp/
> Link: https://syzkaller.appspot.com/bug?id=41f4318cf01762389f4d1c1c459da4f542fe5153 [1]`
>
> Cc: stable@vger.kernel.org
> Fixes: c4f6699dfcb85 ("bpf: introduce BPF_RAW_TRACEPOINT")
> Reported-by: syzbot <syzbot+721aa903751db87aa244@syzkaller.appspotmail.com>
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>
>  include/linux/tracepoint.h | 10 ++++++++++
>  kernel/trace/bpf_trace.c   |  3 ++-
>  kernel/tracepoint.c        | 33 ++++++++++++++++++++++++++++++---
>  3 files changed, 42 insertions(+), 4 deletions(-)
>

[...]
