Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B849B449B49
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 19:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhKHSD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 13:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbhKHSD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 13:03:27 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EA1C061570;
        Mon,  8 Nov 2021 10:00:42 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id v138so45819744ybb.8;
        Mon, 08 Nov 2021 10:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TDrGiI4L7RxZNaXJ1B9oCpvhbFjp7zEuBUTa+BV4F04=;
        b=EDiGqXI/tlBUNeIjK/3Wg6Lpr1RkZDyF1yPWZDSukVvs26fl0Y8jld+QM6xlkVQ2KA
         HukINDwEkFEB+D44GZtd+iIUbsBxvBuHxjE+Fnkr1fUjEuiUCJd7HWnl9KslxC5ZnUdl
         zfg6Dett/JVbNHxKp2q7pbsBSuCQAWdC9k5o8iMEH4ZqkJ+Pa8pq3JQX4EhybnRSPn79
         1+I+qi5eKQu0IzpH+XS2hUs7QL0hpLSQj9qOXLEgQLY3+GkrkX6meGg6x737avtaMNap
         jpJUjh3gLdJk8StZG57eSnf+N3lrVM7jMOCpSaOqymaNnCzsn5DWo5baJsKHeWDacGVa
         jOAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TDrGiI4L7RxZNaXJ1B9oCpvhbFjp7zEuBUTa+BV4F04=;
        b=NTAvow+nauvbCKZIXfYqrNx0I5bKIo/2o5UaxAeGyEOJr++8UP1osZz9psy5K79mNP
         4JQQh34szQ0MnebbdAPHeVgkSfRndBu268Ejks53W5k2nKbx7PT2vFlThVGZpBtp0/mx
         vh8Hg1tnV/UgExQBOiThsNA0vj2Ylxq8P+Da0bEGXzPSiWYbTjfftmtyif4hDtN291W4
         qzfa5T1aMl1D34JmfRfb41p5CLtq6FynTsdhvUFi+6hTY3Ac0ZJ+SjTocNCYCK8/ZVZJ
         qav7ywijKi2beXEKf8U4w85ZJndv4okwzAW4Ipq07y54zKerQqxOWUm9lEHraKv/i038
         1krg==
X-Gm-Message-State: AOAM533GM9aA1vFyHZgP5HdLksorIWymbRHyf4TnL9jF64WXE2q7UH4A
        676ggzE53Qg4wQP9Utvefa3/LviTQs/GVPbZd1M=
X-Google-Smtp-Source: ABdhPJwykaxu64mwKDWOim14usaFG7Pu62cTiNOPP7NoVtcR0J9e8Q4cx5SmoCKBr/+PVIGcNMyu7N/jLix8fd9iw3w=
X-Received: by 2002:a25:cec1:: with SMTP id x184mr1171745ybe.455.1636394441825;
 Mon, 08 Nov 2021 10:00:41 -0800 (PST)
MIME-Version: 1.0
References: <20211106132822.1396621-1-houtao1@huawei.com> <20211106132822.1396621-3-houtao1@huawei.com>
 <20211106184307.7gbztgkeprktbohz@ast-mbp.dhcp.thefacebook.com> <c8f473f7-57ec-3161-e634-fc2e6925ec3d@huawei.com>
In-Reply-To: <c8f473f7-57ec-3161-e634-fc2e6925ec3d@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Nov 2021 10:00:30 -0800
Message-ID: <CAEf4BzZpDiMXjk2AqeAGdjHqpMTy5ycEodK7JUtmqCHZ0v_Hew@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/2] selftests/bpf: add benchmark bpf_strcmp
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 8, 2021 at 6:05 AM Hou Tao <houtao1@huawei.com> wrote:
>
> HI,
>
> On 11/7/2021 2:43 AM, Alexei Starovoitov wrote:
> > On Sat, Nov 06, 2021 at 09:28:22PM +0800, Hou Tao wrote:
> >> The benchmark runs a loop 5000 times. In the loop it reads the file name
> >> from kprobe argument into stack by using bpf_probe_read_kernel_str(),
> >> and compares the file name with a target character or string.
> >>
> >> Three cases are compared: only compare one character, compare the whole
> >> string by a home-made strncmp() and compare the whole string by
> >> bpf_strcmp().
> >>
> >> The following is the result:
> >>
> >> x86-64 host:
> >>
> >> one character: 2613499 ns
> >> whole str by strncmp: 2920348 ns
> >> whole str by helper: 2779332 ns
> >>
> >> arm64 host:
> >>
> >> one character: 3898867 ns
> >> whole str by strncmp: 4396787 ns
> >> whole str by helper: 3968113 ns
> >>
> >> Compared with home-made strncmp, the performance of bpf_strncmp helper
> >> improves 80% under x86-64 and 600% under arm64. The big performance win
> >> on arm64 may comes from its arch-optimized strncmp().
> > 80% and 600% improvement?!
> > I don't understand how this math works.
> > Why one char is barely different in total nsec than the whole string?
> > The string shouldn't miscompare on the first char as far as I understand the test.
> Because the result of "one character" includes the overhead of process filtering and
> string read.
> My bad, I should explain the tests results in more details.

Maybe use bench framework for your benchmark? It allows to setup the
benchmark and collect measurements in a more structured way. Check
some existing benchmarks under benchs/ in selftests/bpf directory.

To actually test just bpf_strncmp() don't add
bpf_probe_read_kernel_str() into the loop logic, set your data in
global variable and just search it. This will give you more accurate
microbenchmark data.

>
> Three tests are exercised:
>
> (1) one character
> Filter unexpected caller by bpf_get_current_pid_tgid()
> Use bpf_probe_read_kernel_str() to read the file name into 64-bytes sized-buffer
> in stack
> Only compare the first character of file name
>
> (2) whole str by strncmp
> Filter unexpected caller by bpf_get_current_pid_tgid()
> Use bpf_probe_read_kernel_str() to read the file name into 64-bytes sized-buffer
> in stack
> Compare by using home-made strncmp(): the compared two strings are the same, so
> the whole string is compared
>
> (3) whole str by helper
> Filter unexpected caller by bpf_get_current_pid_tgid()
> Use bpf_probe_read_kernel_str() to read the file name into 64-bytes sized-buffer
> in stack
> Compare by using bpf_strncmp: the compared two strings are the same, so
> the whole string is compared
>
> Now "(1) one character" is used to calculate the overhead of process filtering and
> string read. So under x86-64, the overhead of strncmp() is
>
>   total time of whole str by strncmp  test  - total time of no character test =
> 306849 ns.
>
> The overhead of bpf_strncmp() is:
>   total time of whole str by helper test - total time of no character test =
> 165833 ns
>
> So the performance win is about (306849  / 165833 ) * 100 - 100 = ~85%
>
> And the win under arm64 is about (497920 / 69246) * 100 - 100 = ~600%
