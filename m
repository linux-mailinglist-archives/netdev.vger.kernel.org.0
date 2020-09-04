Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8933C25E418
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 01:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgIDXS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 19:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728215AbgIDXS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 19:18:28 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95987C061244;
        Fri,  4 Sep 2020 16:18:25 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id q3so5470142ybp.7;
        Fri, 04 Sep 2020 16:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ENXTbqjXuzEWzJ7wo9iMOFK6SqCiRQuIbNC0UplGefA=;
        b=BDkdC7gf8ikT2BBpYBzzXSVDrCupuhZ2IFThuvqZv0leMI1UIDMZVzRJjMm3SM2J8c
         pms0HLLlvDpGTwD0wtiMJXUpM85m2H2hiawumzh/Hv3Ke+XmF1Cb6pjK5SfOLY8iwM5a
         9G5J4KAxj0CakZO6bPwyYpfq4yNdl2Gw1gLJNHowyNBzKjNuGO6WL/1mB/fcWUtAEtVA
         uOzU66yTUUsjQ3RJ967x13kFf+JmKxlGa+Jpzx+as/hih4caxAwmxX5hhNSA1p53bbAS
         Njugo5M0hPhg28ng5KUOOjnX/c1zRpbI7tDoYI/LRvSpv8xoHU+xgHe8MuwjC32EgPj6
         7OJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ENXTbqjXuzEWzJ7wo9iMOFK6SqCiRQuIbNC0UplGefA=;
        b=E/BCMYeZFZGsmy6q/I5XyiLdUiiYrS5YabNZIWi9ElR6+sKuMTNDES4iZ/gjdpMgXP
         wyd4GR49TttSvdB/lQJjKfRghDGGrGUUMBCEgxUeqFrhpSWtQrP13rRDdwork2NQwBAq
         8kuJK+vvrju6CEuN9g080Ouzy70fjMIKkjpKQrGUvQoGInCQe7W3+FZct98a76ThyNXo
         XtDhZiz23iTXm8ZJmIOZQpJiedA9C9Yp1yESCqyyQgO0fmLpWEIoLTMWjaAOBWBqwmtQ
         UXiCxmyMGfZpyJCRUd2GrXgHXoRLcHPOxeu/dYw3bfq6X4qTF9rS3dEJPk96W8xEw09Z
         bF7w==
X-Gm-Message-State: AOAM530qZrpbRh/8+/im8khV+3b4vXNKVW8V8CG2gRUpJ1FHT6hymDQS
        cXTb2xeufWEI2WtPR1rUkHAfsHY5hSRo8PWwkuA=
X-Google-Smtp-Source: ABdhPJzri1waQMCAgd+FOR7HpzPr8N9zT4y9yv/xmdmEd5YA+EksN/3HQrAAhs/wuVxBONLFI80hPCuQQ7Iiot6i4H4=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr12672481ybe.510.1599261504613;
 Fri, 04 Sep 2020 16:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com> <20200828193603.335512-4-sdf@google.com>
 <CAEf4BzZtYTyBT=jURkF4RQLHXORooVwXrRRRkoSWDqCemyGQeA@mail.gmail.com> <20200904012909.c7cx5adhy5f23ovo@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200904012909.c7cx5adhy5f23ovo@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Sep 2020 16:18:13 -0700
Message-ID: <CAEf4BzZp4ODLbjEiv=W7byoR9XzTqAQ052wZM_wD4=aTPmkjbw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/8] libbpf: Add BPF_PROG_BIND_MAP syscall and
 use it on .metadata section
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 3, 2020 at 6:29 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Sep 02, 2020 at 07:31:33PM -0700, Andrii Nakryiko wrote:
> > On Fri, Aug 28, 2020 at 12:37 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > From: YiFei Zhu <zhuyifei@google.com>
> > >
> > > The patch adds a simple wrapper bpf_prog_bind_map around the syscall.
> > > And when using libbpf to load a program, it will probe the kernel for
> > > the support of this syscall, and scan for the .metadata ELF section
> > > and load it as an internal map like a .data section.
> > >
> > > In the case that kernel supports the BPF_PROG_BIND_MAP syscall and
> > > a .metadata section exists, the map will be explicitly bound to
> > > the program via the syscall immediately after program is loaded.
> > > -EEXIST is ignored for this syscall.
> >
> > Here is the question I have. How important is it that all this
> > metadata is in a separate map? What if libbpf just PROG_BIND_MAP all
> > the maps inside a single BPF .o file to all BPF programs in that file?
> > Including ARRAY maps created for .data, .rodata and .bss, even if the
> > BPF program doesn't use any of the global variables? If it's too
> > extreme, we could do it only for global data maps, leaving explicit
> > map definitions in SEC(".maps") alone. Would that be terrible?
> > Conceptually it makes sense, because when you program in user-space,
> > you expect global variables to be there, even if you don't reference
> > it directly, right? The only downside is that you won't have a special
> > ".metadata" map, rather it will be part of ".rodata" one.
>
> That's an interesting idea.
> Indeed. If we have BPF_PROG_BIND_MAP command why do we need to create
> another map that behaves exactly like .rodata but has a different name?

That was exactly my thought when I re-read this patch set :)

> Wouldn't it be better to identify metadata elements some other way?
> Like by common prefix/suffix name of the variables or
> via grouping them under one structure with standard prefix?
> Like:
> struct bpf_prog_metadata_blahblah {
>   char compiler_name[];
>   int my_internal_prog_version;
> } = { .compiler_name[] = "clang v.12", ...};
>
> In the past we did this hack for 'version' and for 'license',
> but we did it because we didn't have BTF and there was no other way
> to determine the boundaries.
> I think libbpf can and should support multiple rodata sections with

Yep, that's coming, we already have a pretty common .rodata.str1.1
section emitted by Clang for some cases, which libbpf currently
ignores, but that should change. Creating a separate map for all such
small sections seems excessive, so my plan is to combine them and
their BTFs into one, as you assumed below.

> arbitrary names, but hardcoding one specific ".metadata" name?
> Hmm. Let's think through the implications.
> Multiple .o support and static linking is coming soon.
> When two .o-s with multiple bpf progs are statically linked libbpf
> won't have any choice but to merge them together under single
> ".metadata" section and single map that will be BPF_PROG_BIND_MAP-ed
> to different progs. Meaning that metadata applies to final elf file
> after linking. It's _not_ per program metadata.

Right, exactly.

> May be we should talk about problem statement and goals.
> Do we actually need metadata per program or metadata per single .o
> or metadata per final .o with multiple .o linked together?
> What is this metadata?

Yep, that's a very valid question. I've also CC'ed Andrey.

> If it's just unreferenced by program read only data then no special names or
> prefixes are needed. We can introduce BPF_PROG_BIND_MAP to bind any map to any
> program and it would be up to tooling to decide the meaning of the data in the
> map. For example, bpftool can choose to print all variables from all read only
> maps that match "bpf_metadata_" prefix, but it will be bpftool convention only
> and not hard coded in libbpf.

Agree as well. It feels a bit odd for libbpf to handle ".metadata"
specially, given libbpf itself doesn't care about its contents at all.

So thanks for bringing this up, I think this is an important discussion to have.
