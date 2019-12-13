Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A101B11DE52
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 07:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfLMGsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 01:48:24 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34204 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfLMGsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 01:48:23 -0500
Received: by mail-qk1-f196.google.com with SMTP id d202so1289297qkb.1;
        Thu, 12 Dec 2019 22:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bjP8jFWb2EV8x3iinz6Te7KLIihZhn048SfrYs4j+EA=;
        b=QsMq3OspKC5jzloNEl9GNKVNO5gyBjsp/p6fMc80+D/Cv2nAI9mKywOG0N9yHI1Nfh
         DRAvPyEGMxruKwaTmqLSYzvYv7NhyABMWZ98QMAcJP26kUUp5Mi4QQa1jFOsR1UulBpe
         N8esfOr9EnPFvPPf0pjV5e5CN6O0fnKn+nHCLEndEgk8ydZsWR3LdI0l61JxaurxrTSV
         YGFZ8BQ/8U3LpNu2kI/wie6Y/xh5mL0Fyf6Tk9hvEY0J+WNgb1/lGnrH81iGmCfO+wTO
         ebPkLj625Vf2OHktBwVgLafhQn16MzEwoNzlldszz8T/RGl7pr4FjHFFeFlZRQUquRm9
         EoLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bjP8jFWb2EV8x3iinz6Te7KLIihZhn048SfrYs4j+EA=;
        b=URfj+Gf52BDVh2fyCvjomTw2RKKgXUNnAxDBILZgdqyq3GmKeDBjd8+NmMH1TjQAVj
         UmLJEM6vGLg56hZvBRU/QJMo5aWUk1XOYMGhjcWi7KSLrDjkKVewEiGg3wy2yF50qjxW
         jZ0dYRRrWIM2Qq9sqpaEkE4FbBtG0wyUQsA1IKlv8mb7MdZ9tZpffyXH7Ogk2PqKg5Mi
         stsBzJvDVuo0hswgy6jn9pd4swTPgBv17jw6tSdobdsDwaGF3YJsMmXJ+ApUgc68iCRm
         2xE+ZIZzU9ra2Dy+/8ZsXkdKsOjFT+SySqbKsqwSw6SDDVawMUN42YdUdKoxdCQuGt91
         bXaw==
X-Gm-Message-State: APjAAAW1hEfnc7g6p72suwhtTJaGajyZjuAu7fBJAhlv2vMeZ+CMXltC
        k7t7XNNvnAcA6YH4dDFDjEQl0fe89QFqep9/wEE=
X-Google-Smtp-Source: APXvYqx/SHtno2Lw4KMEL8ORxi8wjOO2kqv+TD2GpVnxbnTlYeWxHBSSFprNvoF5REe7AhvlGZ/jAd1f9G7DUBUgoYI=
X-Received: by 2002:a05:620a:14a2:: with SMTP id x2mr12304829qkj.36.1576219702042;
 Thu, 12 Dec 2019 22:48:22 -0800 (PST)
MIME-Version: 1.0
References: <CAEf4Bzb+3b-ypP8YJVA=ogQgp1KXx2xPConOswA0EiGXsmfJow@mail.gmail.com>
 <20191211191518.GD3105713@mini-arch> <CAEf4BzYofFFjSAO3O-G37qyeVHE6FACex=yermt8bF8mXksh8g@mail.gmail.com>
 <20191211200924.GE3105713@mini-arch> <CAEf4BzaE0Q7LnPOa90p1RX9qSbOA_8hkT=6=7peP9C88ErRumQ@mail.gmail.com>
 <20191212025735.GK3105713@mini-arch> <CAEf4BzY2KHK4h5e40QgGt4GzJ6c+rm-vtbyEdM41vUSqcs=txA@mail.gmail.com>
 <20191212162953.GM3105713@mini-arch> <CAEf4BzYJHvuFbBM-xvCCsEa+Pg-bG1tprGMbCDtsbGHdv7KspA@mail.gmail.com>
 <20191212104334.222552a1@cakuba.netronome.com> <20191212195415.ubnuypco536rp6mu@ast-mbp.dhcp.thefacebook.com>
 <20191212122115.612bb13b@cakuba.netronome.com>
In-Reply-To: <20191212122115.612bb13b@cakuba.netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 12 Dec 2019 22:48:10 -0800
Message-ID: <CAEf4BzaG95dxgSBSm7m8c3gJ-XeL97=N4srS5fR7JRfcjaMwTw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 12:21 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Thu, 12 Dec 2019 11:54:16 -0800, Alexei Starovoitov wrote:
> > On Thu, Dec 12, 2019 at 10:43:34AM -0800, Jakub Kicinski wrote:
> > > On Thu, 12 Dec 2019 08:53:22 -0800, Andrii Nakryiko wrote:
> > > > > > > Btw, how hard it would be to do this generation with a new python
> > > > > > > script instead of bpftool? Something along the lines of
> > > > > > > scripts/bpf_helpers_doc.py that parses BTF and spits out this C header
> > > > > > > (shouldn't be that hard to write custom BTF parser in python, right)?
> > > > > > >
> > > > > >
> > > > > > Not impossible, but harder than I'd care to deal with. I certainly
> > > > > > don't want to re-implement a good chunk of ELF and BTF parsing (maps,
> > > > > > progs, in addition to datasec stuff). But "it's hard to use bpftool in
> > > > > > our build system" doesn't seem like good enough reason to do all that.
> > > > > You can replace "our build system" with some other project you care about,
> > > > > like systemd. They'd have the same problem with vendoring in recent enough
> > > > > bpftool or waiting for every distro to do it. And all this work is
> > > > > because you think that doing:
> > > > >
> > > > >         my_obj->rodata->my_var = 123;
> > > > >
> > > > > Is easier / more type safe than doing:
> > > > >         int *my_var = bpf_object__rodata_lookup(obj, "my_var");
> > > > >         *my_var = 123;
> > > >
> > > > Your arguments are confusing me. Did I say that we shouldn't add this
> > > > type of "dynamic" interface to variables? Or did I say that every
> > > > single BPF application has to adopt skeleton and bpftool? I made no
> > > > such claims and it seems like discussion is just based around where I
> > > > have to apply my time and efforts... You think it's not useful - don't
> > > > integrate bpftool into your build system, simple as that. Skeleton is
> > > > used for selftests, but it's up to maintainers to decide whether to
> > > > keep this, similar to all the BTF decisions.
> > >
> > > Since we have two people suggesting this functionality to be a separate
> > > tool could you please reconsider my arguments from two days ago?
> > >
> > >   There absolutely nothing this tool needs from [bpftool], no
> > >   JSON needed, no bpffs etc.
> >
> > To generate vmlinux.h bpftool doesn't need json and doesn't need bpffs.
>
> At least for header generation it pertains to the running system.
> And bpftool was (and still is AFAICT) about interacting with the BPF
> state on the running system.

As Alexei already mentioned, `bpftool btf dump file
<elf-file-with-BTF-section>` has as much to do with running system,
as, say, `readelf -x .BTF <elf-file-with-BTF-section>`. So if
bpftool's only goal is to interact with BPF state of running system,
as opposed to be, you know, the "all things BPF" multitool, then that
ship has sailed when we added `bpftool btf` subcommand, which I don't
remember hearing too much objections about at that time (which
happened quite a while ago, btw).

>
> > > It can be a separate tool like
> > >   libbpf-skel-gen or libbpf-c-skel or something, distributed with libbpf.
> > >   That way you can actually soften the backward compat. In case people
> > >   become dependent on it they can carry that little tool on their own.
> >
> > Jakub,
> >
> > Could you please consider Andrii's reply to your comment from two days ago:
> > https://lore.kernel.org/bpf/CAEf4BzbeZbmCTOOo2uQXjm0GL0WDu7aLN6fdUk18Nv2g0kfwVg@mail.gmail.com/
> > "we are trying to make users lives easier by having major distributions
> > distribute bpftool and libbpf properly. Adding extra binaries to
> > distribute around doesn't seem to be easing any of users pains."
>
> Last time we argued I heard how GH makes libbpf packaging easier.
> Only to have that dis-proven once the people in Europe who do distro
> packaging woke up:
>
> https://lkml.org/lkml/2019/12/5/101
> https://lkml.org/lkml/2019/12/5/312
>
> I feel I'm justified not to take your opinion on this as fact.
>
> > My opinion is the following.
> > bpftool is necessary to write bpf programs already. It's necessary to produce
> > vmlinux.h for bpf programs to include it. It's part of build process. I can
> > relate to Stan's complains that he needs to update clang and pahole. He missed
> > the fact that he needs to update bpftool too if he wants to use all features of
> > CO-RE. Same thing for skeleton generation. If people need to run the latest
> > selftest/bpf on the latest kernel they need to upgrade to the latest clang,
> > pahole, libbpf, bpftool. Nothing new here.
>
> They have to update libbpf, so why can't the code gen tool be part of
> libbpf? We don't need to build all BPF user space into one binary.
>
> > Backwards compat is the same concern for skeleton generation and for vmlinux.h
> > generation. Obviously no one wants to introduce something that will keep
> > changing. Is vmlinux.h generation stable? I like to believe so. Same with
> > skeleton. I wouldn't want to see it changing, but in both cases such chance
> > exists.
>
> vmlinux.h is pretty stable, there isn't much wiggle room there.
> It's more of a conversion tool, if you will.
>
> Skeleton OTOH is supposed to make people's lives easier, so it's a
> completely different beast. It should be malleable so that users can

Skeleton is also a conversion tool. From compiled BPF object file to
it's "C representation". Just like BTF-to-C converter takes BTF and
creates its C representation. Both make people's lives easier. They
are in the same boat: productivity-enhancing tools, not a system
introspection tools.

> improve and hack on it. Baking it into as system tool is counter
> productive. Users should be able to grab the skel tool single-file
> source and adjust for their project's needs. Distributing your own copy
> of bpftool because you want to adjust skel is a heavy lift.

Skeleton is auto-generated code, it's not supposed to be tweaked or
"adjusted" by hand. Because next time you do tiny change to your BPF
source code (just swap order of two global variables), skeleton
changes. If someone is not satisfied with the way skeleton generation
looks like, they should propose changes and contribute to common
algorithm. Or, of course, they can just go and re-implement it on
their own, if struct bpf_object_skeleton suits them still (which is
what libbpf works with). Then they can do it in Python, Go, Scala,
Java, Perl, whatnot. But somehow I doubt anyone would want to do that.

>
> And maybe one day we do have Python/Go/whatever bindings, and we can
> convert the skel tool to a higher level language with modern templating.

Because high-level implementation is going to be so much simpler and
shorter, really? Is it that complicated in C right now? What's the
real benefit of waiting to be able to do it in "higher level" language
beyond being the contrarian? Apart from \n\ (which is mostly hidden
from view), I don't think high-level templates are going to be much
more clean.

>
> > We cannot and should not adopt kernel-like ABI guarantees to user space
> > code. It will paralyze the development.
>
> Discussion for another time :)

If this "experimental" disclaimer is a real blocker for all of this, I
don't mind making it a public API right now. bpf_object_skeleton is
already designed to be backward/forward compatible with size of struct
itself and all the sub-structs recorded during initialization. I
didn't mean to create impression like this whole approach is so raw
and untried that it will most certainly break and we are still unsure
about it. It's not and it certainly improves set up code for
real-world applications. We might need to add some extra option here
and there, but the stuff that's there already will stay as is.

Would moving all the skeleton-related stuff into libbpf.h and
"stabilizing" it make all this more tolerable for you?

>
> > Now consider if vmlinux.h and skeleton generation is split out of bpftool into
> > new tool. Effectively it would mean a fork of bpftool. Two binaries doing bpf
> > elf file processing without clear distinction between them is going to be very
> > confusing.
>
> To be clear I'm suggesting skel gen is a separate tool, vmlinux and
> Quentin's header gen work on the running system, they are not pure
> build env tools.
