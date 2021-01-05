Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D5B2EB346
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730898AbhAETEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729376AbhAETEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:04:39 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A432BC061574;
        Tue,  5 Jan 2021 11:03:59 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id r4so204887pls.11;
        Tue, 05 Jan 2021 11:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3oN4gIUKR6n9m4yAkgGMVU5D5SXCHxMf5VYllGbDYlU=;
        b=gTqYN++gJo23GUfdyR9bqbeaCDlncZI55pkQ1g6A2QFDR8FZj6FC+qwi4na3QI8NCu
         cdoHHysOeFTvZ9AXr+Y+n5LbKdaS3QoH5OvnjRhnGjKE7B64tAd/Z45YxKIK6qh4LCEi
         M7Y18elm72W7Mcz2P/WZWhmaP0o6kRa1wTnoqX69cGXhsjwckPaMJDzbUBVfInn0DBoR
         pePUkhg9HlBEuMwISw+lCp/a3TzEyKPwJwfVCSnavK0EUOPhuNC8kPFeh5re8ccwYN3U
         t7SjaDFey/1ZeR3+amszDleRT2oRUX1Wmmu9KWDS7YO19PGurOG0zN18sSfq4J5tItGR
         uVPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3oN4gIUKR6n9m4yAkgGMVU5D5SXCHxMf5VYllGbDYlU=;
        b=P+zrVOj9P8xRoUeppUtYg/fXozI0XVa8ZzLdShx0LjUe//4aKjdwPws2l0qgZPZS8o
         Ye1xtAEBYAVm5ZCISkMr/KaQvcUMZJbhs4WTAkbcByRIiv8mPxgCye1iKBRgmfNQyyju
         7V6hg8MoQWwWB7cQ2Sg03g6ZyCzghbCcvnBzoUQt5pojMqre4gnpu4PAptqKwdXF/KDr
         SaWUJAoa3SPi+5VjafZLe5b6GxKAIbXMGHmABWvits3bYlOm0tp6XVKhQ8tpaDvDvo+4
         xON833pQ/yys75q0O7hXA2H/x9/YyVarinfsR+o0ufHzcFvY1YdJ6lplRphUQ98PpPfT
         QHNA==
X-Gm-Message-State: AOAM533xPrQf9U2x55xTCbI3plkGsojgAL9qJHz/02R3/TpFh5Pgzl80
        zUe1pzSeQaIxiezjAnWZsUo=
X-Google-Smtp-Source: ABdhPJwkh0dHQPI5Wm2caIz0nCFY3vs1rKB25r+tio2lN2YRWVXR7cf4Cbhea1XX3i7ACz2Zoir6WQ==
X-Received: by 2002:a17:902:9f89:b029:dc:3032:e439 with SMTP id g9-20020a1709029f89b02900dc3032e439mr691730plq.35.1609873439108;
        Tue, 05 Jan 2021 11:03:59 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:5456])
        by smtp.gmail.com with ESMTPSA id dw16sm273504pjb.35.2021.01.05.11.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 11:03:57 -0800 (PST)
Date:   Tue, 5 Jan 2021 11:03:55 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Gilad Reti <gilad.reti@gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add tests for user- and
 non-CO-RE BPF_CORE_READ() variants
Message-ID: <20210105190355.2lbt6vlmi752segx@ast-mbp>
References: <20201218235614.2284956-1-andrii@kernel.org>
 <20201218235614.2284956-4-andrii@kernel.org>
 <20210105034644.5thpans6alifiq65@ast-mbp>
 <CAEf4BzY4qXW_xV+0pcWPQp+Tda6BY69xgJnaA3RFxKc255rP2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY4qXW_xV+0pcWPQp+Tda6BY69xgJnaA3RFxKc255rP2g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 04, 2021 at 09:08:21PM -0800, Andrii Nakryiko wrote:
> On Mon, Jan 4, 2021 at 7:46 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Dec 18, 2020 at 03:56:14PM -0800, Andrii Nakryiko wrote:
> > > +
> > > +/* shuffled layout for relocatable (CO-RE) reads */
> > > +struct callback_head___shuffled {
> > > +     void (*func)(struct callback_head___shuffled *head);
> > > +     struct callback_head___shuffled *next;
> > > +};
> > > +
> > > +struct callback_head k_probe_in = {};
> > > +struct callback_head___shuffled k_core_in = {};
> > > +
> > > +struct callback_head *u_probe_in = 0;
> > > +struct callback_head___shuffled *u_core_in = 0;
> > > +
> > > +long k_probe_out = 0;
> > > +long u_probe_out = 0;
> > > +
> > > +long k_core_out = 0;
> > > +long u_core_out = 0;
> > > +
> > > +int my_pid = 0;
> > > +
> > > +SEC("raw_tracepoint/sys_enter")
> > > +int handler(void *ctx)
> > > +{
> > > +     int pid = bpf_get_current_pid_tgid() >> 32;
> > > +
> > > +     if (my_pid != pid)
> > > +             return 0;
> > > +
> > > +     /* next pointers for kernel address space have to be initialized from
> > > +      * BPF side, user-space mmaped addresses are stil user-space addresses
> > > +      */
> > > +     k_probe_in.next = &k_probe_in;
> > > +     __builtin_preserve_access_index(({k_core_in.next = &k_core_in;}));
> > > +
> > > +     k_probe_out = (long)BPF_PROBE_READ(&k_probe_in, next, next, func);
> > > +     k_core_out = (long)BPF_CORE_READ(&k_core_in, next, next, func);
> > > +     u_probe_out = (long)BPF_PROBE_READ_USER(u_probe_in, next, next, func);
> > > +     u_core_out = (long)BPF_CORE_READ_USER(u_core_in, next, next, func);
> >
> > I don't understand what the test suppose to demonstrate.
> > co-re relocs work for kernel btf only.
> > Are you saying that 'struct callback_head' happened to be used by user space
> > process that allocated it in user memory. And that is the same struct as
> > being used by the kernel? So co-re relocs that apply against the kernel
> > will sort-of work against the data of user space process because
> > the user space is using the same struct? That sounds convoluted.
> 
> The test itself just tests that bpf_probe_read_user() is executed, not
> bpf_probe_read_kernel(). But yes, the use case is to read kernel data
> structures from the user memory address space. See [0] for the last
> time this was requested and justifications. It's not the first time
> someone asked about the user-space variant of BPF_CORE_READ(), though
> I won't be able to find the reference at this time.
> 
>   [0] https://lore.kernel.org/bpf/CANaYP3GetBKUPDfo6PqWnm3xuGs2GZjLF8Ed51Q1=Emv2J-dKg@mail.gmail.com/

That's quite confusing thread.

> > I struggle to see the point of patch 1:
> > +#define bpf_core_read_user(dst, sz, src)                                   \
> > +       bpf_probe_read_user(dst, sz, (const void *)__builtin_preserve_access_index(src))
> >
> > co-re for user structs? Aren't they uapi? No reloc is needed.
> 
> The use case in [0] above is for reading UAPI structs, passed as input
> arguments to syscall. It's a pretty niche use case, but there are at
> least two more-or-less valid benefits to use CO-RE with "stable" UAPI
> structs:
> 
>   - handling 32-bit vs 64-bit UAPI structs uniformly;

what do you mean?
32-bit user space running on 64-bit kernel works through 'compat' syscalls.
If bpf progs are accessing 64-bit uapi structs in such case they're broken
and no amount of co-re can help.

>   - handling UAPI fields that were added in later kernels, but are
> missing on the earlier ones.
> 
> For the former, you'd need to compile two variants of the BPF program
> (or do convoluted and inconvenient 32-bit UAPI struct re-definition
> for 64-bit BPF target). 

No. 32-bit uapi structs should be used by bpf prog.
compat stuff is not only casting pointers from 64-bit to 32.

> For the latter... I guess you can do if/else
> dance based on the kernel version. Which sucks and is inconvenient
> (and kernel version checks are discouraged, it's more reliable to
> detect availability of specific types and fields).

Not really. ifdef based on kernel version is not needed.
bpf_core_field_exists() will work just fine.
No need to bpf_probe_read_user() macros.

> So all in all, while pretty rare and niche, seemed like a valid use
> case. And easy to support while reusing all the macro logic almost
> without any changes.

I think these new macros added with confusing and unclear goals
will do more harm than good.
