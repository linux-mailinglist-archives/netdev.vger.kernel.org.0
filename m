Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43EAF121975
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 19:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfLPSyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 13:54:11 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40866 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbfLPSyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 13:54:11 -0500
Received: by mail-qk1-f193.google.com with SMTP id c17so5303045qkg.7;
        Mon, 16 Dec 2019 10:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tCKouFVACPZoqxWQGv/oZIozyfyBdYhG/AqTTByALEc=;
        b=Sd1XXri5MqSafcYNHI0DpZBt1CHpreG1UuIMQnt7gFnjgtkZ6O8L3BoF0vIoFyWxHz
         rloi6kN+pPmpKT6dimaiRMIqsAi+IjccX9RpEudxnFiemHON1W8IX04/ChWRqC8bmX01
         B4onlFizTmKiWX0NiRN/18N64yL5XhJDYbl0SxFPIqYIomniCDM5G+IGRs646xGH+CFH
         oo8kO/Cg7CjUUAp5WvSCB89vGWgHwbv38uTpX21qMuzee4AuiNmlGqSvHn1SRSbbU+hy
         4JPlfPKuzBTW/AfEwMhmQLB9feOwwu5FERj/IIczw8cx1cU4uS/SPcZsa6mDdvf3OJK3
         WSRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tCKouFVACPZoqxWQGv/oZIozyfyBdYhG/AqTTByALEc=;
        b=unZvq1L7tiOLylE2OEdAbSVz7D15z4J/vWLD2FBBVomEUDnPWgwGvARspROW5MxFgd
         a0t1EyQ3KJQMEmejbH56yVq9J8dd53r/arw2XfeatVaD1D9W23EArnSRiCWtpYnT7jYI
         hSzppyYddF9IcABE/Db2ewP7FHDvizgur6Uv5pTIsIj8b9rYWvXHMCCrJ0dS2AMUpToD
         4JEMOaeQSCBloGNpeG8FAWayVHc6Edj2sI5ofTOqwIxpNptNfT2xjXqGRzMo9u++q69e
         7mDX07Po4gwb0BJqxOmoq5agfcAsBz1q9xrfRqb/Vc4uJv/knqT604rbEQYKwgWpgpcH
         /t/A==
X-Gm-Message-State: APjAAAVWfIKvJ69IvIo5tQy6tqf9L5f2aR8qxAuSSyG19EprnpdAmZRA
        OlIit/7zvI9rLSndKfbbLu3gZxA+N5MiStb6/AG+nR5U
X-Google-Smtp-Source: APXvYqxsIYRpYHldkoEGAGfciIzXWGFd48suSpkSH1ieEwzAWM9npZjTGVxZ+YyZYFlcfZLSWfUxy9c5HoqppDVsDHo=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr782744qkq.437.1576522449658;
 Mon, 16 Dec 2019 10:54:09 -0800 (PST)
MIME-Version: 1.0
References: <20191210011438.4182911-1-andriin@fb.com> <20191210011438.4182911-12-andriin@fb.com>
 <20191216141608.GE14887@linux.fritz.box>
In-Reply-To: <20191216141608.GE14887@linux.fritz.box>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Dec 2019 10:53:58 -0800
Message-ID: <CAEf4Bzb2=R0+D0XXrH0N1n1X+7i6aFkACS2gb0xAQFwcBHjVQA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 6:16 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Mon, Dec 09, 2019 at 05:14:34PM -0800, Andrii Nakryiko wrote:
> > Add `bpftool gen skeleton` command, which takes in compiled BPF .o object file
> > and dumps a BPF skeleton struct and related code to work with that skeleton.
> > Skeleton itself is tailored to a specific structure of provided BPF object
> > file, containing accessors (just plain struct fields) for every map and
> > program, as well as dedicated space for bpf_links. If BPF program is using
> > global variables, corresponding structure definitions of compatible memory
> > layout are emitted as well, making it possible to initialize and subsequently
> > read/update global variables values using simple and clear C syntax for
> > accessing fields. This skeleton majorly improves usability of
> > opening/loading/attaching of BPF object, as well as interacting with it
> > throughout the lifetime of loaded BPF object.
> >
> > Generated skeleton struct has the following structure:
> >
> > struct <object-name> {
> >       /* used by libbpf's skeleton API */
> >       struct bpf_object_skeleton *skeleton;
> >       /* bpf_object for libbpf APIs */
> >       struct bpf_object *obj;
> >       struct {
> >               /* for every defined map in BPF object: */
> >               struct bpf_map *<map-name>;
> >       } maps;
> >       struct {
> >               /* for every program in BPF object: */
> >               struct bpf_program *<program-name>;
> >       } progs;
> >       struct {
> >               /* for every program in BPF object: */
> >               struct bpf_link *<program-name>;
> >       } links;
> >       /* for every present global data section: */
> >       struct <object-name>__<one of bss, data, or rodata> {
> >               /* memory layout of corresponding data section,
> >                * with every defined variable represented as a struct field
> >                * with exactly the same type, but without const/volatile
> >                * modifiers, e.g.:
> >                */
> >                int *my_var_1;
> >                ...
> >       } *<one of bss, data, or rodata>;
> > };
> >
> > This provides great usability improvements:
> > - no need to look up maps and programs by name, instead just
> >   my_obj->maps.my_map or my_obj->progs.my_prog would give necessary
> >   bpf_map/bpf_program pointers, which user can pass to existing libbpf APIs;
> > - pre-defined places for bpf_links, which will be automatically populated for
> >   program types that libbpf knows how to attach automatically (currently
> >   tracepoints, kprobe/kretprobe, raw tracepoint and tracing programs). On
> >   tearing down skeleton, all active bpf_links will be destroyed (meaning BPF
> >   programs will be detached, if they are attached). For cases in which libbpf
> >   doesn't know how to auto-attach BPF program, user can manually create link
> >   after loading skeleton and they will be auto-detached on skeleton
> >   destruction:
> >
> >       my_obj->links.my_fancy_prog = bpf_program__attach_cgroup_whatever(
> >               my_obj->progs.my_fancy_prog, <whatever extra param);
> >
> > - it's extremely easy and convenient to work with global data from userspace
> >   now. Both for read-only and read/write variables, it's possible to
> >   pre-initialize them before skeleton is loaded:
> >
> >       skel = my_obj__open(raw_embed_data);
> >       my_obj->rodata->my_var = 123;
> >       my_obj__load(skel); /* 123 will be initialization value for my_var */
> >
> >   After load, if kernel supports mmap() for BPF arrays, user can still read
> >   (and write for .bss and .data) variables values, but at that point it will
> >   be directly mmap()-ed to BPF array, backing global variables. This allows to
> >   seamlessly exchange data with BPF side. From userspace program's POV, all
> >   the pointers and memory contents stay the same, but mapped kernel memory
> >   changes to point to created map.
> >   If kernel doesn't yet support mmap() for BPF arrays, it's still possible to
> >   use those data section structs to pre-initialize .bss, .data, and .rodata,
> >   but after load their pointers will be reset to NULL, allowing user code to
> >   gracefully handle this condition, if necessary.
> >
> > Given a big surface area, skeleton is kept as an experimental non-public
> > API for now, until more feedback and real-world experience is collected.
>
> Can you elaborate on the plan here? This is until v5.6 is out and hence a new
> bpftool release implicitly where this becomes frozen / non-experimental?

Yes, I've exposed all those interfaces as public, thus they are going
to stabilize with new release of libbpf/bpftool. I've received some
good usability feedback from Alexei after he tried it out locally, so
I'm going to adjust auto-generated part a bit. Libbpf APIs were
designed with extensibility built in, so we can extend them as any
other APIs, if need be.

>
> There is also tools/bpf/bpftool/Documentation/bpftool-gen.rst missing. Given
> you aim to collect more feedback (?), it would be appropriate to document
> everything in there so users have a clue how to use it for getting started.

sure, will add it

>
> Also, I think at least some more clarification is needed in such document on
> the following topics:
>
> - libbpf and bpftool is both 'GPL-2.0-only' or 'BSD-2-Clause'. Given this
>   is a code generator, what license is the `bpftool gen skeleton` result?
>   In any case, should there also be a header comment emitted via do_skeleton()?

Not a lawyer here, I assumed auto-generated code isn't copyrighted,
but how about I just emit SPDX header with the same license as libbpf
itself:

SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)


>
> - Clear statement that this codegen is an alternative to regular libbpf
>   API usage but that both are always kept feature-complete and hence not
>   disadvantaged in one way or another (to rule out any uncertainties for
>   users e.g. whether they now need to start rewriting their existing code
>   etc); with purpose of the former (codgen) to simplify loader interaction.

ok, will add that as well

>
> Thanks,
> Daniel
