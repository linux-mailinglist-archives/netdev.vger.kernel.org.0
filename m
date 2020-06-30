Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739BC210031
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 00:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgF3Ws5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 18:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgF3Ws4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 18:48:56 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4E4C03E97B
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 15:48:56 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id d15so17816009edm.10
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 15:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s3xaSnjPwOz/gfRv2/K99Xg/qf7pM+PnO4Lm4xuaoC0=;
        b=ASbXZJLtG8XUPSKV+h/SVuJS8yIbMCdkYnwmz9GVGBHSAM+DAluDsY/UItNHh5PPjN
         ojeIFIQdrQrB5TO+YJ4T17S3IX4uNxtZRu3ECARMr+8G3RfHGY0MFD8NQQoegMH9WYgw
         DplT/XHY6xm7t+KEUlRVK5cBeygKp2aVxTDa84GvXZysfxGk/Hd43n9zJJmazHKD3iF7
         MSte5VrVqWlbM/EjzGkN8q90OIsCct0GzstiUZJV+IHJlsi4kupmFdqViSPPqCacYpia
         CJDgVFsqebVGLJTdh2JQ2zFzHI2FGtHwawNpHLQReD555gWw11/dCwr4oRXqFYgLWD0/
         0J0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s3xaSnjPwOz/gfRv2/K99Xg/qf7pM+PnO4Lm4xuaoC0=;
        b=SyBshK92SaE1O2ltSuX/EdPJPFQicVvA31hAw8ClB9ww0puDB2WQVCtE9HBLsEPNKk
         JQQzHFVWCofNbwP7UWsZQlebC1rc3mqvV3kFb5M/+2pUFDpskJ380LCwgtJu761amGTA
         2G+DKUJq3glEHRytMsS9AiAiHi81nMNy2cTMmh2g3lqfx+TAUfvDzOsmoiNVI9gIK+BM
         9YZIavCtxSpbl7U89qxZ9sewQ5W8jtiISqHbFDejE7EBjaFtc/WatLF1tqkQ7jl04Crj
         JNlnAM0j5OOcynxqufJMWh9OyTgcK+i2Jhl1WgAYRX/zJf+5ArQDJ86gJFUgfhpxo/Wa
         lq6A==
X-Gm-Message-State: AOAM530JRocPTMBdf+z/dtktgTfcNBFwhCUoUTSETxiN+OPXHu9xZ3c+
        u8lWPI+XrpZATkeRXYyKkX2jf+1GWjap0+YO2YWdDiECy2g=
X-Google-Smtp-Source: ABdhPJwdBVIhV+aZ5jKNHZ7ssWSX+SueBydRHGEF9sWtuWG2VuYiEFyUS9TQX3p7Jbl+uP6IBTsIxp0Q6Z8QAuI+cho=
X-Received: by 2002:aa7:d5cd:: with SMTP id d13mr691466eds.370.1593557334562;
 Tue, 30 Jun 2020 15:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200630184922.455439-1-haoluo@google.com> <49df8306-ecc7-b979-d887-b023275e4842@fb.com>
In-Reply-To: <49df8306-ecc7-b979-d887-b023275e4842@fb.com>
From:   Hao Luo <haoluo@google.com>
Date:   Tue, 30 Jun 2020 15:48:43 -0700
Message-ID: <CA+khW7iJu2tzcz36XzL6gBq4poq+5Qt0vbrmPRdYuvC-c5U4_A@mail.gmail.com>
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

On Tue, Jun 30, 2020 at 1:37 PM Yonghong Song <yhs@fb.com> wrote:
>
> On 6/30/20 11:49 AM, Hao Luo wrote:
> > The test_vmlinux test uses hrtimer_nanosleep as hook to test tracing
> > programs. But it seems Clang may have done an aggressive optimization,
> > causing fentry and kprobe to not hook on this function properly on a
> > Clang build kernel.
>
> Could you explain why it does not on clang built kernel? How did you
> build the kernel? Did you use [thin]lto?
>
> hrtimer_nanosleep is a global function who is called in several
> different files. I am curious how clang optimization can make
> function disappear, or make its function signature change, or
> rename the function?
>

Yonghong,

We didn't enable LTO. It also puzzled me. But I can confirm those
fentry/kprobe test failures via many different experiments I've done.
After talking to my colleague on kernel compiling tools (Bill, cc'ed),
we suspected this could be because of clang's aggressive inlining. We
also noticed that all the callsites of hrtimer_nanosleep() are tail
calls.

For a better explanation, I can reach out to the people who are more
familiar to clang in the compiler team to see if they have any
insights. This may not be of high priority for them though.

Hao
