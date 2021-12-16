Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378F44768F3
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 05:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhLPEGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 23:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbhLPEGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 23:06:37 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B810C061574;
        Wed, 15 Dec 2021 20:06:37 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id x32so60955410ybi.12;
        Wed, 15 Dec 2021 20:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3OChzfLXWJUKSc6lAArF7YrO3Lj8rLF54C6O9wKrR48=;
        b=L6Fbif68sn2Q2slnFz+6Xj+dLgFjqTIMUS8mgtpg2GXGiQpDPWBgMNycw+PqCayK0F
         9hm1P2dCASVP+ArjqsvCEF6SHPeBlvIROTbdOXQVTifDE2ZIDIWc34UVvHL71P69mgWn
         z/d5rakfuWbVPRNi31dPwBNgW6YzEhncmngXWPfJYxIn8JDxqnuA44JxmSA/iq50pZ5F
         pmgKIyataAHI9Vm/yABz8Bzt9964COeGKH6Uu3GiNyj14j1eqmIF6HdyT9BOckmakYep
         BsO22/GMytmnndDdIxKoFLLVvyHeaHQqEdazvQyJhg489TFLGSowuMpQD279FK0SHV8v
         RkFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3OChzfLXWJUKSc6lAArF7YrO3Lj8rLF54C6O9wKrR48=;
        b=49iCCiSiAfcCJ1wOcmjB7QUK7C3mZSQY3QyV/PQFAtoE52NLtq8LTP43ECwS+yij3b
         93AGirRytRHoLjG3WtW7QD7/s4FK/CuWKPxi+qO2pwwssEVj1IAaS4fdnMLf1+7zHi4c
         FXfMiYQe7ckjV1sLGopnO20hZAPmIhOFcWzWqkUYjR2KBKPw4EpEH7ZKn0lqfIKKhvjA
         zkVZ73vXsv6udP8uc38P+zfaU4+bFwsmvDnH3f1spa+7xlcjoarjE1jlRfdzyMOZ2mmO
         IP5Tg6mvbpx3Zgij9HrO9gcbjftpdZr3F4gILaYMD8rgdqR6k75eLs7UH8dfFeCw5BDN
         BuUQ==
X-Gm-Message-State: AOAM531zVhRotN/HsPGwlaTLkk8DKROFVEhJgihhGlYgqFu9bWLO9Cew
        rqSMMA+9DX0VcC18RnOgSA7EqPnTLrmGD907GwQ=
X-Google-Smtp-Source: ABdhPJwU23HHgeDAXxPP2z19rK3WDqzJheAQL1/Ob4GmrEk8pheviCFvLPIBsS9hQv1InPm0GsBSafoCjgljC+ueGgg=
X-Received: by 2002:a25:e90a:: with SMTP id n10mr10274669ybd.180.1639627596650;
 Wed, 15 Dec 2021 20:06:36 -0800 (PST)
MIME-Version: 1.0
References: <20211214135555.125348-1-pulehui@huawei.com>
In-Reply-To: <20211214135555.125348-1-pulehui@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Dec 2021 20:06:25 -0800
Message-ID: <CAEf4BzaQcHV3iY5XqEbt3ptw+KejVVEZ8gSmW7u46=xHnsTaPA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix building error when using
 userspace pt_regs
To:     Pu Lehui <pulehui@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 5:54 AM Pu Lehui <pulehui@huawei.com> wrote:
>
> When building bpf selftests on arm64, the following error will occur:
>
> progs/loop2.c:20:7: error: incomplete definition of type 'struct
> user_pt_regs'
>
> Some archs, like arm64 and riscv, use userspace pt_regs in
> bpf_tracing.h, which causes build failure when bpf prog use
> macro in bpf_tracing.h. So let's use vmlinux.h directly.

We could probably also extend bpf_tracing.h to work with
kernel-defined pt_regs, just like we do for x86 (see __KERNEL__ and
__VMLINUX_H__ checks). It's more work, but will benefit other end
users, not just selftests.

>
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> ---
>  tools/testing/selftests/bpf/progs/loop1.c     |  8 ++------
>  tools/testing/selftests/bpf/progs/loop2.c     |  8 ++------
>  tools/testing/selftests/bpf/progs/loop3.c     |  8 ++------
>  tools/testing/selftests/bpf/progs/loop6.c     | 20 ++++++-------------
>  .../selftests/bpf/progs/test_overhead.c       |  8 ++------
>  .../selftests/bpf/progs/test_probe_user.c     |  6 +-----
>  6 files changed, 15 insertions(+), 43 deletions(-)
>

[...]
