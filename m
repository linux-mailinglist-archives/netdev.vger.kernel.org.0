Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDABC27E1A0
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 08:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgI3Gs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 02:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgI3Gs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 02:48:26 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1908CC0613D2
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 23:48:26 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id z13so662941iom.8
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 23:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gbz4zl+cX4IPzKJ6pFWDpkBc0o8tIwNiBdIHCS8F/tg=;
        b=KCZTzVmGKZs6ZzUeiKCFfFb1HBTk9Up4xVNCJ3fFuYRrl+2Ul+YXKAQARER/3TSjyW
         lEiHAOvE7NQxqYd3v1hObzpmfNLRa56e/sbIyCN0X5f8BITASnBdzHN9JJwgNex9GD+1
         nZ5raPPlVYwg0jQYcpRQM9/amuTYKH6gaAMtBJnrl7iAMC/mv0RpTYfP8o1XBa4Ga8au
         D3TbEYaKItQxqePazENNXgoZB/P3cc2gBH0nMo4Ez5vMMoSZxavt/7e9+TXUb/QSSQIo
         8VBDdg3x3gcHEM38goEG2o3CLMHwFO00cNA5pCKtEnJzxcojZ2VFdneyxQxTQjfRSN5L
         K7LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gbz4zl+cX4IPzKJ6pFWDpkBc0o8tIwNiBdIHCS8F/tg=;
        b=Hw7ZcYJbktQBTveQcy70y/OhBXU/E8cBX6nFdvDUyoqUDDcttT72e7iqRmiH+pu4/p
         qfZKOsdWVRj6/kHgz4X5NlKvRNckoPCfwx6qr8XVqDM2O0X0MnveVmNwlfqkxWm/9xZX
         hR9hpHzrUX9We7ANt6Od3E9G5K+Yb9VPRXIGZfzu5W3w3/965JxaT1NRYZd/HPhlHxaZ
         LkvhZETma1S/TnFcoUEtxzIqtzZCTZkpTrbdHew+KXb+iKpB5GxyWOGsZDfclSG56gg9
         GtCjnz9kG/WYf3g+WyJDEDEwJITe7TiEUBdAqoPCY67cZfBqnVQHchrWos1ZLn0oPs0H
         BdNA==
X-Gm-Message-State: AOAM530/zREtYaxt47v+ALcZRUL3hdXgVyXCiXoy9xn8NmxurzgyOD4u
        HQR9Dlzqq2bWjVGYBZj8G8mhrnBIONJYJkFCftdQQw==
X-Google-Smtp-Source: ABdhPJzC3cxXikF0eF7Q5jH1wUchyoBxn4H8NS3LLdJwKaMzk5yTvfidbqER2xnVMkozpPZR/2EDGelL4oskUVja3+U=
X-Received: by 2002:a05:6638:1643:: with SMTP id a3mr861452jat.4.1601448505053;
 Tue, 29 Sep 2020 23:48:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200929235049.2533242-1-haoluo@google.com> <CAADnVQK8XbzDs9hWLYEqkJj+g=1HJ7nrar+0STY5CY8t5nrC=A@mail.gmail.com>
In-Reply-To: <CAADnVQK8XbzDs9hWLYEqkJj+g=1HJ7nrar+0STY5CY8t5nrC=A@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Tue, 29 Sep 2020 23:48:14 -0700
Message-ID: <CA+khW7i4wpvOsJTH4AePVsm4cAOnFoxEwEqv27tEzJrwOWFqxw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/6] bpf: BTF support for ksyms
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ah, this is the bug in pahole described in
https://lkml.org/lkml/2020/8/20/1862. I proposed a fix [1] but it
hasn't reached pahole's master branch. Let me ask Arnaldo to see if he
is OK merging it.

[1] https://www.spinics.net/lists/dwarves/msg00451.html

On Tue, Sep 29, 2020 at 9:36 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 4:50 PM Hao Luo <haoluo@google.com> wrote:
> >
> > v3 -> v4:
> >  - Rebasing
> >  - Cast bpf_[per|this]_cpu_ptr's parameter to void __percpu * before
> >    passing into per_cpu_ptr.
>
> Looks good, but doesn't work:
> ./test_progs -t ksyms_btf
> test_ksyms_btf:PASS:kallsyms_fopen 0 nsec
> test_ksyms_btf:PASS:ksym_find 0 nsec
> test_ksyms_btf:PASS:kallsyms_fopen 0 nsec
> test_ksyms_btf:PASS:ksym_find 0 nsec
> test_ksyms_btf:PASS:btf_exists 0 nsec
> libbpf: extern (ksym) 'bpf_prog_active': incompatible types, expected
> [4] int int, but kernel has [18729] var bpf_user_rnd_state
> libbpf: failed to load object 'test_ksyms_btf'
> libbpf: failed to load BPF skeleton 'test_ksyms_btf': -22
> test_ksyms_btf:FAIL:skel_open failed to open and load skeleton
> #43 ksyms_btf:FAIL
>
> I have the latest pahole from master. Any ideas?
