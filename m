Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07392EA4A9
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 06:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbhAEFJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 00:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbhAEFJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 00:09:12 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F02C061574;
        Mon,  4 Jan 2021 21:08:32 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id d37so28149883ybi.4;
        Mon, 04 Jan 2021 21:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T6mM3BxitTzzXQ9DkEXjG2bjFmDN5NUBc6wDjeyrbkk=;
        b=mJAXQODAANHFVKIEmCZCRQn5yJPkhtEg+1G/Wny2IEKXhwf81APvRC5rzntbzpQ+Z7
         Dk8ONRlj/R+6DFCjxcQsSpA2ljFgAGDwPutHJDaXGD6B4WHqi/LEy1QEsbGmWWy0JTMi
         ZrWIzWYWzf1AZQrWm/QaM9ruR510S9blrgM4MRqWh73ehx4rpXGkxtaowBHcma4SdVjV
         f1c6SyfniUh7MNwzcY00wQly2OasmaN6PdbcX9gCuxly6nLp1sv7yjcgIwA0csPWNYfV
         RfI6cC513Z0w0RcnuXILfONA95OsKYsYktZ6Fs4cgnXYc5DQkLbU1cApxP1opRnaShlI
         zm2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T6mM3BxitTzzXQ9DkEXjG2bjFmDN5NUBc6wDjeyrbkk=;
        b=tv0l4YTF+1B3LCUdv3qip16re6A4iVx7RqpCpQ/CTpN3EBrdjsysTaU3jvESXTOuaX
         +/kuJnOz1yFwvysQAB4drliOghWbUbHAtz3zyNpZ3IZGlTlD0tC2Nt4KVUgkgGcrF/8E
         xOPBx486T92K12eQ4D1BANkbZmK3CwX2tofL9iEcQbtwrmsNsEDXZy9uN916qwyQNhwz
         7ILrwEnID1PRhG3G5CNAZ6yz0NG2qiTbiyaLjITY77EZPvPI+6OAej2eabyb9PrZf2Yn
         1tE9pqcHrqbwVrvVhU6AGWcu1559KP5xzAJpc2d/UYeJRgZ926D5NH1o1ugVve6IG9u+
         5qkw==
X-Gm-Message-State: AOAM533XO8N4KgtEoR8zflZ0Xtm1qz3Ug/k+QReibo4k57zRarcwAq4D
        e48S+H5hGu6RbhlB89JRG+cHopTJ7fTHkjcQnMk=
X-Google-Smtp-Source: ABdhPJwU68yxqAHdB9WF8Z9yzUyKjAY56UwcCKyYneWgMNUavs+g7FeNeHPsRTtoYe7vVothW5EWovcoigtmG2JSUnY=
X-Received: by 2002:a25:2c4c:: with SMTP id s73mr90532492ybs.230.1609823311741;
 Mon, 04 Jan 2021 21:08:31 -0800 (PST)
MIME-Version: 1.0
References: <20201218235614.2284956-1-andrii@kernel.org> <20201218235614.2284956-4-andrii@kernel.org>
 <20210105034644.5thpans6alifiq65@ast-mbp>
In-Reply-To: <20210105034644.5thpans6alifiq65@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 4 Jan 2021 21:08:21 -0800
Message-ID: <CAEf4BzY4qXW_xV+0pcWPQp+Tda6BY69xgJnaA3RFxKc255rP2g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add tests for user- and
 non-CO-RE BPF_CORE_READ() variants
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Gilad Reti <gilad.reti@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 4, 2021 at 7:46 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Dec 18, 2020 at 03:56:14PM -0800, Andrii Nakryiko wrote:
> > +
> > +/* shuffled layout for relocatable (CO-RE) reads */
> > +struct callback_head___shuffled {
> > +     void (*func)(struct callback_head___shuffled *head);
> > +     struct callback_head___shuffled *next;
> > +};
> > +
> > +struct callback_head k_probe_in = {};
> > +struct callback_head___shuffled k_core_in = {};
> > +
> > +struct callback_head *u_probe_in = 0;
> > +struct callback_head___shuffled *u_core_in = 0;
> > +
> > +long k_probe_out = 0;
> > +long u_probe_out = 0;
> > +
> > +long k_core_out = 0;
> > +long u_core_out = 0;
> > +
> > +int my_pid = 0;
> > +
> > +SEC("raw_tracepoint/sys_enter")
> > +int handler(void *ctx)
> > +{
> > +     int pid = bpf_get_current_pid_tgid() >> 32;
> > +
> > +     if (my_pid != pid)
> > +             return 0;
> > +
> > +     /* next pointers for kernel address space have to be initialized from
> > +      * BPF side, user-space mmaped addresses are stil user-space addresses
> > +      */
> > +     k_probe_in.next = &k_probe_in;
> > +     __builtin_preserve_access_index(({k_core_in.next = &k_core_in;}));
> > +
> > +     k_probe_out = (long)BPF_PROBE_READ(&k_probe_in, next, next, func);
> > +     k_core_out = (long)BPF_CORE_READ(&k_core_in, next, next, func);
> > +     u_probe_out = (long)BPF_PROBE_READ_USER(u_probe_in, next, next, func);
> > +     u_core_out = (long)BPF_CORE_READ_USER(u_core_in, next, next, func);
>
> I don't understand what the test suppose to demonstrate.
> co-re relocs work for kernel btf only.
> Are you saying that 'struct callback_head' happened to be used by user space
> process that allocated it in user memory. And that is the same struct as
> being used by the kernel? So co-re relocs that apply against the kernel
> will sort-of work against the data of user space process because
> the user space is using the same struct? That sounds convoluted.

The test itself just tests that bpf_probe_read_user() is executed, not
bpf_probe_read_kernel(). But yes, the use case is to read kernel data
structures from the user memory address space. See [0] for the last
time this was requested and justifications. It's not the first time
someone asked about the user-space variant of BPF_CORE_READ(), though
I won't be able to find the reference at this time.

  [0] https://lore.kernel.org/bpf/CANaYP3GetBKUPDfo6PqWnm3xuGs2GZjLF8Ed51Q1=Emv2J-dKg@mail.gmail.com/

> I struggle to see the point of patch 1:
> +#define bpf_core_read_user(dst, sz, src)                                   \
> +       bpf_probe_read_user(dst, sz, (const void *)__builtin_preserve_access_index(src))
>
> co-re for user structs? Aren't they uapi? No reloc is needed.

The use case in [0] above is for reading UAPI structs, passed as input
arguments to syscall. It's a pretty niche use case, but there are at
least two more-or-less valid benefits to use CO-RE with "stable" UAPI
structs:

  - handling 32-bit vs 64-bit UAPI structs uniformly;
  - handling UAPI fields that were added in later kernels, but are
missing on the earlier ones.

For the former, you'd need to compile two variants of the BPF program
(or do convoluted and inconvenient 32-bit UAPI struct re-definition
for 64-bit BPF target). For the latter... I guess you can do if/else
dance based on the kernel version. Which sucks and is inconvenient
(and kernel version checks are discouraged, it's more reliable to
detect availability of specific types and fields).

So all in all, while pretty rare and niche, seemed like a valid use
case. And easy to support while reusing all the macro logic almost
without any changes.
