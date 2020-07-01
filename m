Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219702100E4
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 02:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgGAAK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 20:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbgGAAK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 20:10:56 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44738C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 17:10:55 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id dg28so17965402edb.3
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 17:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bjQDKTaJMxV8x+iQcgy2rKRLrj+SFItZBE5zPQLkZuA=;
        b=TCnqJK+trIrn/5gbFdl+LRcqR+V+NQ/I4JtzRoERVHVmT1c3XM3fR70h/kayP3sFZd
         fa5ACr8LbCR/9DpeNYu+hkr9RA8S8Tjtq1J1lOOHnTi1bXP1rfmCXlzos4PP6J9A1ozf
         oFMhOpKsksoFWZM0mJ4FGfSVcOH/XItOcs51LPsNnQ8Hm87LNTnCchAer6u2v1MskKsz
         e795FdyNugjhuXHGt/d1jHHCdSsWjH9sSq8r5kP7nEKtvp3lwfEGnSiPzvQVIjLNZdQh
         Klw7NSpPUdpyZtat3VERb/p/3Nnox2iMmJ1jdbJXIvbQvlZQfY2SSLBgJACiN/UxHUAF
         LHQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bjQDKTaJMxV8x+iQcgy2rKRLrj+SFItZBE5zPQLkZuA=;
        b=X2UrVd1AtsHCjYmTplQyZPQihReq60U/5O4W2nLAqYolYiTm5+UaYmph2hGWOm1r2s
         pR0mabKFrc2khdeG3QYijcCUxSEq7DFyDF8BDxsLEq+7xF5QF0XPqQmFUY5iXBts7ADC
         ap2B36Fdd9oOw6C0HsroBuRUBjWdOPq2nHIbxTURAcP+dnyUipq+h6/c0R5ImP3usLRs
         TUKnFKmiclXds1MgiXcadlnpCEjBEvX3wogGaOtbgUo+W4LFyXzGF+3NSkdp/5/QvzTk
         zLO+TPLAHmR9ujzldhEGyjv1taaJGITapl0iGPWIkV5jw4b3HN8up8pImN++S3JgBbOX
         oJ8Q==
X-Gm-Message-State: AOAM53169z18upFyrWqhBcasQvWbnAv28Cmk1wwOt73SJULOJoJUbhPR
        xYrC814ZCwoXouqeyfT5MCyTwZSpOWG18QYczy66Ng==
X-Google-Smtp-Source: ABdhPJz/ibbuqba+XZZSos++PG7Jnvkrj3UtBw96dwLxmrWYQL1D9CcOu9D+cBPxEA408q8QgWmM8FlQFmBxVdP7nlk=
X-Received: by 2002:aa7:cdca:: with SMTP id h10mr12506937edw.285.1593562253769;
 Tue, 30 Jun 2020 17:10:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200630184922.455439-1-haoluo@google.com> <49df8306-ecc7-b979-d887-b023275e4842@fb.com>
 <CA+khW7iJu2tzcz36XzL6gBq4poq+5Qt0vbrmPRdYuvC-c5U4_A@mail.gmail.com>
In-Reply-To: <CA+khW7iJu2tzcz36XzL6gBq4poq+5Qt0vbrmPRdYuvC-c5U4_A@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Tue, 30 Jun 2020 17:10:42 -0700
Message-ID: <CA+khW7jNqVMqq2dzf6Dy0pWCZYjHrG7Vm_sUEKKLS-L-ptzEtQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Switch test_vmlinux to use hrtimer_range_start_ns.
To:     Yonghong Song <yhs@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        linux-kselftest@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ok, with the help of my colleague Ian Rogers, I think we solved the
mystery. Clang actually inlined hrtimer_nanosleep() inside
SyS_nanosleep(), so there is no call to that function throughout the
path of the nanosleep syscall. I've been looking at the function body
of hrtimer_nanosleep for quite some time, but clearly overlooked the
caller of hrtimer_nanosleep. hrtimer_nanosleep is pretty short and
there are many constants, inlining would not be too surprising.
Sigh...

Hao

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
> Hao
