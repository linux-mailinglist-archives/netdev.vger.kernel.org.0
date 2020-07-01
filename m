Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311AE2100DA
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 02:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgGAAG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 20:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgGAAGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 20:06:55 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBD0C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 17:06:55 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id r5so12265122vso.11
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 17:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ljeanCVomM9pm7YqGsm40u2yOhEfwYZjVfL5sMIeFvE=;
        b=oIi2JFEv5Rzvgj01VOi5im5BDpG8PBOTCR2Gw/jkmGUZ56w9OrfB3MYqilO6LH+HiZ
         Ou+iBDqd+74Fl6JYiVdYj6rV7qyR/n915XQ347lsXgEzS4pUKmAv+OfxvXRfj/LT3TF3
         LwIZ9VJhGFcPgKdG1BgMRIxMKKb06K6GGJjD7MHwML0XQJtVI3Hl2+RcdgGk9kurlx7K
         5MOgJOMav82M89YEaW7Q6XwOAY0uIdZWuTjcxn48Qj/rCAkvP6kT6PqXkPQS22NXM9QD
         nnlNuJx67KyNukV7ztxVjj8VLzxPjetLaUKP+l8Vx4Aevz1XCpFO/EBxgexS679k/Bjt
         ll2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ljeanCVomM9pm7YqGsm40u2yOhEfwYZjVfL5sMIeFvE=;
        b=MMZm/Jrs/45rG6AhbsxMYCbS3Hm6siTGVVjmGkAHLJNioCyp1UPkZmdE4qoI+28h6w
         HelNcxxV6dKRjFxleKxO9FDMhCN0zDE3BR1TwFxcve81hbQOPjSJdyy76joSWlmvJSWA
         isWuTIldozgvl5MQJD0MamGRTwwKgaNlCeI+OJ/YwbUuyIDY+qb9KPnjaP6FWmjQEAJR
         /1MU+7bpXSiqm3FSER691LNpkZ3MaE432FRCqEcdswJMyR8bgZhGhWySRvrYAKOLZ/jT
         ju60ux308TjQnYTOqbnx0kthlvpe2UIgK19wcxrqI0kcUlNAfOr7y8cp+5KhsEcwLHL3
         LaTw==
X-Gm-Message-State: AOAM531eQ8ObtoPc3JAB4phnRfb3fVTdsT7m9khFxGa0zk5xDilMKnZs
        UPQDhLchPX5E9s3MFU4QwwgkJCRCqymOvaLvhqiCND3Meg==
X-Google-Smtp-Source: ABdhPJzAqs6cElenC01gUzsDtsvwsJx2nGOZyUnKLNyoFEReEJBd3v4RZOf8Kpet7WG3DkYwTUeEJgqFnJo+tuGZ3pM=
X-Received: by 2002:a67:f04:: with SMTP id 4mr17254670vsp.112.1593562014487;
 Tue, 30 Jun 2020 17:06:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200630184922.455439-1-haoluo@google.com> <49df8306-ecc7-b979-d887-b023275e4842@fb.com>
 <CA+khW7iJu2tzcz36XzL6gBq4poq+5Qt0vbrmPRdYuvC-c5U4_A@mail.gmail.com>
In-Reply-To: <CA+khW7iJu2tzcz36XzL6gBq4poq+5Qt0vbrmPRdYuvC-c5U4_A@mail.gmail.com>
From:   Bill Wendling <morbo@google.com>
Date:   Tue, 30 Jun 2020 17:06:43 -0700
Message-ID: <CAGG=3QWo9J4LVePVH4JVD+Y364q-R-BwpR5rxemXzBR6SqbnVg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Switch test_vmlinux to use hrtimer_range_start_ns.
To:     Hao Luo <haoluo@google.com>
Cc:     Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-kselftest@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 3:48 PM Hao Luo <haoluo@google.com> wrote:
>
> On Tue, Jun 30, 2020 at 1:37 PM Yonghong Song <yhs@fb.com> wrote:
> >
> > On 6/30/20 11:49 AM, Hao Luo wrote:
> > > The test_vmlinux test uses hrtimer_nanosleep as hook to test tracing
> > > programs. But it seems Clang may have done an aggressive optimization,
> > > causing fentry and kprobe to not hook on this function properly on a
> > > Clang build kernel.
> >
> > Could you explain why it does not on clang built kernel? How did you
> > build the kernel? Did you use [thin]lto?
> >
> > hrtimer_nanosleep is a global function who is called in several
> > different files. I am curious how clang optimization can make
> > function disappear, or make its function signature change, or
> > rename the function?
> >
>
> Yonghong,
>
> We didn't enable LTO. It also puzzled me. But I can confirm those
> fentry/kprobe test failures via many different experiments I've done.
> After talking to my colleague on kernel compiling tools (Bill, cc'ed),
> we suspected this could be because of clang's aggressive inlining. We
> also noticed that all the callsites of hrtimer_nanosleep() are tail
> calls.
>
> For a better explanation, I can reach out to the people who are more
> familiar to clang in the compiler team to see if they have any
> insights. This may not be of high priority for them though.
>
Hi Yonghong,

Clang is generally more aggressive at inlining than gcc. So even
though hrtimer_nanosleep is a global function, clang goes ahead and
inlines it into the "nanosleep" syscall, which is in the same file.
(We're not currently using {Thin}LTO, so this won't happen in
functions outside of kernel/time/hrtimer.c.) Note that if gcc were to
change it's inlining heuristics so that it inlined more aggressively,
you would be faced with a similar issue.

If you would like to test that it calls hrtimer_nanosleep() and not
another function, it might be best to call a syscall not defined in
hrtimer.c, e.g. clock_nanosleep().

-bw
