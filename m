Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B070118F78
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 19:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfLJSFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 13:05:42 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:44276 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbfLJSFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 13:05:42 -0500
Received: by mail-pj1-f68.google.com with SMTP id w5so7691226pjh.11
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 10:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=p250SP6LYYK/01N51GqevSzgn/NOjQ88ERfazogiGtc=;
        b=pAvWc+I5V+HG3QHjPEZN9FO75Z7VXMrY61CNOcY4yRGVAZrItKsNiFDBQ4rOLirN3q
         diGwW+ozhY2J6C4UNCFMhdy9bJTdOjP1NWkVtOiH7KdFQXiFGfyTIfVqloPAp9DPjOeV
         XJ4KbfTgHP0bv3QuIAFaNbkEzof9GzzB/EGrFNc7efRsoX3jVLwSREs5MIN3huRiUdkU
         Hdtnoj36J5m0V5Yi1wWcDRCu8RKqXJ5/R5AEOkVD0YR8/LPDJs5vkbvRyHy3frzmfSe7
         dBl0HaKsG4ltLGxNdojP3Ag+pt6MWd4lPPWFLPwhgHsWUW19XRreetlB/lqEzGkjOh/i
         1gEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=p250SP6LYYK/01N51GqevSzgn/NOjQ88ERfazogiGtc=;
        b=T0h+7BGHaKpJIaFtZtZe51EV2jzQ+yLzntUWFxGIQ2e4NmjSj3KzwrrYS2heADvbti
         ScWrA5SaTC2H3tR8MRU7iLj0tIloPcNJjZCewNYUAED3HRu6fgo/yl+KVxgsvrmFmMAq
         r/jdOaV38wmYJ8G3Iy+M5UkRYzgpAba0o3F6yYL7ASML4x/CrsHHcSMRvQYhlIfMMXj5
         1epYsbjT1MZtoKYbc84s9Tf8ay9QUSv2iQtZofBEdaXxN/kp+phewFqeRXenj8D8Fzku
         fY4UKwQpTrb8OE+5vXEOVRW47WoqE4KCFzwu7XZJ7+tDFFUEnyQHxnZ8f8fbYjSe+75U
         pIgA==
X-Gm-Message-State: APjAAAXxppISr66R2PSkrTnhhySuQRj91nvDwT5X+N26NEbDs5+vTK4w
        P0F87yRrLew6jTdo5Qz6a7dn/g==
X-Google-Smtp-Source: APXvYqyZRXka/z8RR1tKDIEA0XaCqYLuoBjycoYsD7UW/Xfi6vYmVk1cUnYXmJB0mIbHHraF934jZA==
X-Received: by 2002:a17:902:d696:: with SMTP id v22mr36021185ply.66.1576001141079;
        Tue, 10 Dec 2019 10:05:41 -0800 (PST)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::3])
        by smtp.gmail.com with ESMTPSA id o184sm3982442pgo.62.2019.12.10.10.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 10:05:40 -0800 (PST)
Date:   Tue, 10 Dec 2019 10:05:36 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
Message-ID: <20191210100536.7a57d5e1@cakuba.netronome.com>
In-Reply-To: <CAEf4Bzaow7w+TGyiF67pXn42TumxFZb7Q4BOQPPGfRJdyeY-ig@mail.gmail.com>
References: <20191210011438.4182911-1-andriin@fb.com>
        <20191210011438.4182911-12-andriin@fb.com>
        <20191209175745.2d96a1f0@cakuba.netronome.com>
        <CAEf4Bzaow7w+TGyiF67pXn42TumxFZb7Q4BOQPPGfRJdyeY-ig@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 09:11:31 -0800, Andrii Nakryiko wrote:
> On Mon, Dec 9, 2019 at 5:57 PM Jakub Kicinski wrote:
> > On Mon, 9 Dec 2019 17:14:34 -0800, Andrii Nakryiko wrote:  
> > > struct <object-name> {
> > >       /* used by libbpf's skeleton API */
> > >       struct bpf_object_skeleton *skeleton;
> > >       /* bpf_object for libbpf APIs */
> > >       struct bpf_object *obj;
> > >       struct {
> > >               /* for every defined map in BPF object: */
> > >               struct bpf_map *<map-name>;
> > >       } maps;
> > >       struct {
> > >               /* for every program in BPF object: */
> > >               struct bpf_program *<program-name>;
> > >       } progs;
> > >       struct {
> > >               /* for every program in BPF object: */
> > >               struct bpf_link *<program-name>;
> > >       } links;
> > >       /* for every present global data section: */
> > >       struct <object-name>__<one of bss, data, or rodata> {
> > >               /* memory layout of corresponding data section,
> > >                * with every defined variable represented as a struct field
> > >                * with exactly the same type, but without const/volatile
> > >                * modifiers, e.g.:
> > >                */
> > >                int *my_var_1;
> > >                ...
> > >       } *<one of bss, data, or rodata>;
> > > };  
> >
> > I think I understand how this is useful, but perhaps the problem here
> > is that we're using C for everything, and simple programs for which
> > loading the ELF is majority of the code would be better of being
> > written in a dynamic language like python?  Would it perhaps be a
> > better idea to work on some high-level language bindings than spend
> > time writing code gens and working around limitations of C?  
> 
> None of this work prevents Python bindings and other improvements, is
> it? Patches, as always, are greatly appreciated ;)

This "do it yourself" shit is not really funny :/

I'll stop providing feedback on BPF patches if you guy keep saying 
that :/ Maybe that's what you want.

> This skeleton stuff is not just to save code, but in general to
> simplify and streamline working with BPF program from userspace side.
> Fortunately or not, but there are a lot of real-world applications
> written in C and C++ that could benefit from this, so this is still
> immensely useful. selftests/bpf themselves benefit a lot from this
> work, see few of the last patches in this series.

Maybe those applications are written in C and C++ _because_ there 
are no bindings for high level languages. I just wish BPF programming
was less weird and adding some funky codegen is not getting us closer
to that goal.

In my experience code gen is nothing more than a hack to work around
bad APIs, but experiences differ so that's not a solid argument.

> > > This provides great usability improvements:
> > > - no need to look up maps and programs by name, instead just
> > >   my_obj->maps.my_map or my_obj->progs.my_prog would give necessary
> > >   bpf_map/bpf_program pointers, which user can pass to existing libbpf APIs;
> > > - pre-defined places for bpf_links, which will be automatically populated for
> > >   program types that libbpf knows how to attach automatically (currently
> > >   tracepoints, kprobe/kretprobe, raw tracepoint and tracing programs). On
> > >   tearing down skeleton, all active bpf_links will be destroyed (meaning BPF
> > >   programs will be detached, if they are attached). For cases in which libbpf
> > >   doesn't know how to auto-attach BPF program, user can manually create link
> > >   after loading skeleton and they will be auto-detached on skeleton
> > >   destruction:
> > >
> > >       my_obj->links.my_fancy_prog = bpf_program__attach_cgroup_whatever(
> > >               my_obj->progs.my_fancy_prog, <whatever extra param);
> > >
> > > - it's extremely easy and convenient to work with global data from userspace
> > >   now. Both for read-only and read/write variables, it's possible to
> > >   pre-initialize them before skeleton is loaded:
> > >
> > >       skel = my_obj__open(raw_embed_data);
> > >       my_obj->rodata->my_var = 123;
> > >       my_obj__load(skel); /* 123 will be initialization value for my_var */
> > >
> > >   After load, if kernel supports mmap() for BPF arrays, user can still read
> > >   (and write for .bss and .data) variables values, but at that point it will
> > >   be directly mmap()-ed to BPF array, backing global variables. This allows to
> > >   seamlessly exchange data with BPF side. From userspace program's POV, all
> > >   the pointers and memory contents stay the same, but mapped kernel memory
> > >   changes to point to created map.
> > >   If kernel doesn't yet support mmap() for BPF arrays, it's still possible to
> > >   use those data section structs to pre-initialize .bss, .data, and .rodata,
> > >   but after load their pointers will be reset to NULL, allowing user code to
> > >   gracefully handle this condition, if necessary.
> > >
> > > Given a big surface area, skeleton is kept as an experimental non-public
> > > API for now, until more feedback and real-world experience is collected.  
> >
> > That makes no sense to me. bpftool has the same backward compat
> > requirements as libbpf. You're just pushing the requirements from
> > one component to the other. Feedback and real-world use cases have
> > to be exercised before code is merged to any project with backward
> > compatibility requirements :(  
> 
> To get this feedback we need to have this functionality adopted. To
> have it adopted, we need it available in tool users already know,
> have, and use. 

Well you claim you have users for it, just talk to them now. I don't
understand how this is not obvious. It's like saying "we can't test
this unless it's in the tree"..!?

> If you feel that "experimental" disclaimer is not enough, I guess we
> can add extra flag to bpftool itself to enable experimental
> functionality, something like:
> 
> bpftool --experimental gen skeleton <bla>

Yeah, world doesn't really work like that. Users start depending on 
a feature, it will break people's scripts/Makefiles if it disappears.
This codegen thing is made to be hard coded in Makefiles.. how do you
expect people not to immediately become dependent on it.

> > Also please run checkpatch on your patches, and fix reverse xmas tree.
> > This is bpftool, not libbpf. Creating a separate tool for this codegen
> > stuff is also an option IMHO.  
> 
> Sure, will fix few small things checkpatch detected.

Running checkpatch should be part of your upstreaming routine, you're
wasting people's time. So stop with the amused tone.

> Will reverse christmas-ize all the variables, of course :)
> 
> As for separate tool just for this, you are not serious, right? If
> bpftool is not right tool for this, I don't know which one is.

I am serious. There absolutely nothing this tool needs from BPF, no
JSON needed, no bpffs etc. It can be a separate tool like
libbpf-skel-gen or libbpf-c-skel or something, distributed with libbpf.
That way you can actually soften the backward compat. In case people
become dependent on it they can carry that little tool on their own.
