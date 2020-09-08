Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE69E261A54
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731841AbgIHSeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731737AbgIHScm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 14:32:42 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6846AC0617BB;
        Tue,  8 Sep 2020 11:24:33 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id h126so90230ybg.4;
        Tue, 08 Sep 2020 11:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SRWPjeh5wOZKPdRn3jxewIK/0dHDoc31s09B3dnlvws=;
        b=L5KOJT6drjugCLK8cSVnNImUIs2YEvrEEZwWTpqB8ELNYp6wAxAnIfueB35u7evSOs
         lf18U4ZDuNP17Zgtbx0w4/iN9OIp3y5AiZczPSQKHlS63cPk/VZ6vOfATZR4QWLj5eyu
         OyDh8nJqoH9a+KhxVilaCkjNK1gCdcJIf93Yth9RkR/JdfGgAlR5gLJfGRPohYdgnZ2j
         Pi+w0ueUlbrzyyWbcBDWT/OqwSjuNvc2mNcCHSjxJZVJ2Y+4oN9Tpb1XMBc4S7E+yVu7
         WcE0QjFk0wPw/LBgkkqRQbOjS1rVHhMt2sJKm7ceQeCsJToQO3NglormfC0B+Xu5XIxe
         G0iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SRWPjeh5wOZKPdRn3jxewIK/0dHDoc31s09B3dnlvws=;
        b=tj6oJUi+SHv6WG0ZJtOlMmTphfW5p9+m5sC8q8H8vZz8CXmNpgqJqHk69UhFOKK8zl
         Z+Vgqk6Yhx/FIopl/GMLcOzHDoSwYPjCYKi6uuSE/f4W4bY/2yHDkl+rs6y4oVUVaHVy
         aea0lM+nazVtvRWil/Q7HV7tca47vpzcnGdsa3bTcYrpS3HQg5qGAaQS3Tq+ja1QZMsx
         UhoSjUfkBaCeyY0oyz9iK+iflKSfBOrVLYY/OEF+K4KK/rRHyc7eaJ6DXo6TjY+KEeO/
         kqEU3+DepcZWk9UVieZq9dtIM2iP+LTfYwJnSPbPde2gpxC4XhdZeAiyav2Irex6RNS3
         hHOA==
X-Gm-Message-State: AOAM5321i+xRk+SSwCNNK6Dc608/IdKsth0s4zv/h0IP4ejRcMS2xEV5
        gLuh2MOSgCywev2jMKT4/1MXTcv0OUkZHe+Re3I=
X-Google-Smtp-Source: ABdhPJwWsgbV9GxUwhkDktkqV7clEDaUC4FES99B8MZcvJbD1sQWVw36GldSCofBEdM16xRumdCcxAVk6AD57VMG4UA=
X-Received: by 2002:a25:cb57:: with SMTP id b84mr175016ybg.425.1599589471961;
 Tue, 08 Sep 2020 11:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com> <20200828193603.335512-4-sdf@google.com>
 <CAEf4BzZtYTyBT=jURkF4RQLHXORooVwXrRRRkoSWDqCemyGQeA@mail.gmail.com>
 <20200904012909.c7cx5adhy5f23ovo@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZp4ODLbjEiv=W7byoR9XzTqAQ052wZM_wD4=aTPmkjbw@mail.gmail.com> <20200908174449.GA34763@rdna-mbp>
In-Reply-To: <20200908174449.GA34763@rdna-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Sep 2020 11:24:21 -0700
Message-ID: <CAEf4Bzb+2xpacSmxF_NqENu8EtP3Z8GOv=amL_e1Q94=YPVhLA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/8] libbpf: Add BPF_PROG_BIND_MAP syscall and
 use it on .metadata section
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 10:45 AM Andrey Ignatov <rdna@fb.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> [Fri, 2020-09-04 16:19 -0700]:
> > On Thu, Sep 3, 2020 at 6:29 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Sep 02, 2020 at 07:31:33PM -0700, Andrii Nakryiko wrote:
> > > > On Fri, Aug 28, 2020 at 12:37 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > > >
> > > > > From: YiFei Zhu <zhuyifei@google.com>
> > > > >
> > > > > The patch adds a simple wrapper bpf_prog_bind_map around the syscall.
> > > > > And when using libbpf to load a program, it will probe the kernel for
> > > > > the support of this syscall, and scan for the .metadata ELF section
> > > > > and load it as an internal map like a .data section.
> > > > >
> > > > > In the case that kernel supports the BPF_PROG_BIND_MAP syscall and
> > > > > a .metadata section exists, the map will be explicitly bound to
> > > > > the program via the syscall immediately after program is loaded.
> > > > > -EEXIST is ignored for this syscall.
> > > >
> > > > Here is the question I have. How important is it that all this
> > > > metadata is in a separate map? What if libbpf just PROG_BIND_MAP all
> > > > the maps inside a single BPF .o file to all BPF programs in that file?
> > > > Including ARRAY maps created for .data, .rodata and .bss, even if the
> > > > BPF program doesn't use any of the global variables? If it's too
> > > > extreme, we could do it only for global data maps, leaving explicit
> > > > map definitions in SEC(".maps") alone. Would that be terrible?
> > > > Conceptually it makes sense, because when you program in user-space,
> > > > you expect global variables to be there, even if you don't reference
> > > > it directly, right? The only downside is that you won't have a special
> > > > ".metadata" map, rather it will be part of ".rodata" one.
> > >
> > > That's an interesting idea.
> > > Indeed. If we have BPF_PROG_BIND_MAP command why do we need to create
> > > another map that behaves exactly like .rodata but has a different name?
> >
> > That was exactly my thought when I re-read this patch set :)
> >
> > > Wouldn't it be better to identify metadata elements some other way?
> > > Like by common prefix/suffix name of the variables or
> > > via grouping them under one structure with standard prefix?
> > > Like:
> > > struct bpf_prog_metadata_blahblah {
> > >   char compiler_name[];
> > >   int my_internal_prog_version;
> > > } = { .compiler_name[] = "clang v.12", ...};
> > >
> > > In the past we did this hack for 'version' and for 'license',
> > > but we did it because we didn't have BTF and there was no other way
> > > to determine the boundaries.
> > > I think libbpf can and should support multiple rodata sections with
> >
> > Yep, that's coming, we already have a pretty common .rodata.str1.1
> > section emitted by Clang for some cases, which libbpf currently
> > ignores, but that should change. Creating a separate map for all such
> > small sections seems excessive, so my plan is to combine them and
> > their BTFs into one, as you assumed below.
> >
> > > arbitrary names, but hardcoding one specific ".metadata" name?
> > > Hmm. Let's think through the implications.
> > > Multiple .o support and static linking is coming soon.
> > > When two .o-s with multiple bpf progs are statically linked libbpf
> > > won't have any choice but to merge them together under single
> > > ".metadata" section and single map that will be BPF_PROG_BIND_MAP-ed
> > > to different progs. Meaning that metadata applies to final elf file
> > > after linking. It's _not_ per program metadata.
> >
> > Right, exactly.
> >
> > > May be we should talk about problem statement and goals.
> > > Do we actually need metadata per program or metadata per single .o
> > > or metadata per final .o with multiple .o linked together?
> > > What is this metadata?
> >
> > Yep, that's a very valid question. I've also CC'ed Andrey.
>
> From my side the problem statement is to be able to save a bunch of
> metadata fields per BPF object file (I don't distinguish "final .o" and
> "multiple .o linked together" since we have only the former in prod).

We don't *yet*. But reading below, you have the entire BPF application
(i.e., a collection of maps, variables and programs) in mind, not
specifically single .c file compiled into a single .o file. So
everything works out, I think.

>
> Specifically things like oncall team who owns the programs in the object
> (the most important info), build info (repository revision, build commit
> time, build time), etc. The plan is to integrate it with build system
> and be able to quickly identify source code and point of contact for any
> particular program.
>
> All these things are always the same for all programs in one object. It
> may change in the future, but at the moment I'm not aware of any
> use-case where these things can be different for different programs in
> the same object.
>
> I don't have strong preferences on the implementation side as long as it
> covers the use-case, e.g. the one in the patch set would work FWIW.
>
> > > If it's just unreferenced by program read only data then no special names or
> > > prefixes are needed. We can introduce BPF_PROG_BIND_MAP to bind any map to any
> > > program and it would be up to tooling to decide the meaning of the data in the
> > > map. For example, bpftool can choose to print all variables from all read only
> > > maps that match "bpf_metadata_" prefix, but it will be bpftool convention only
> > > and not hard coded in libbpf.
> >
> > Agree as well. It feels a bit odd for libbpf to handle ".metadata"
> > specially, given libbpf itself doesn't care about its contents at all.
> >
> > So thanks for bringing this up, I think this is an important discussion to have.
>
> --
> Andrey Ignatov
