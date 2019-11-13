Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390EBFA9AD
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 06:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfKMFd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 00:33:29 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:33976 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfKMFd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 00:33:29 -0500
Received: by mail-io1-f68.google.com with SMTP id q83so1180400iod.1;
        Tue, 12 Nov 2019 21:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Hx3oDWVOc7tf6JLbkMjBmDV3r6RqsuXgKrQXTaqkBtU=;
        b=mBDlh8Ca5P0UVhmJGAYjaDGNyOmLRAvLopSkA2ZPvvqZhj61lPXBA5Ob3Zd6cAhHnN
         qj9YlPGAYjeVvpyMa3gpJpdEJiC/EODSRCx7WBsJCr0JNZyi3nZdW+LgMp6uADwk/8C6
         3L2mSibBaOWWzNCLOISub3BqR3rpAp0fnsguxsYIT4Fl8dfngWPeafiiUqYz5J5spjEj
         VibW25kLof62jIubn6XETSK9zAD0Irywtl64pgWVW0s7InzyvvySX6gmFLnB4aXrF89U
         SxrleScv9vdE/h7hBrYi6Qmwg4ULQaU2IBBNTzqbWrShWHFaPse5XItbXky7UN7ox0oB
         O+sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Hx3oDWVOc7tf6JLbkMjBmDV3r6RqsuXgKrQXTaqkBtU=;
        b=p1y0ap7oBkERcTxJmMYInAbkecXnj2szFE/RvwId3kwCaSYMzTk5r7EBjMpSzWxjlq
         Z4Q++950Q/G9j2d4Tz/2w521j9vyzJtRvO1ewLeb3KBk9BdHlEhOF/dwxjwuVG0FInHu
         JiD563f2p/aA0wdHeZG0OHT6SozjQoiKcgRuelIwKHIwzzToOhAJz548br6CwgWtxDGK
         k0Lgiwuij/OIR6g2WT2sarFuVQEgR5LL3PEpwkWVrssHqsyTdRvrdaDNgMDovWxGxuT/
         6rtxl/NzVBugFAtwgzakzez52jmlb/abCBQFOwvDdHKRO/r+/8chOqKkiZFclDRdFtj+
         OO+g==
X-Gm-Message-State: APjAAAXXD9kEJ910OM8HNQ1jwJIX+b4uPOA5iXyzrSXlnqeo9VNNi9aA
        CMdUnw3MUxQ/QA95qxn7OY4=
X-Google-Smtp-Source: APXvYqzFAVwBxC6Al3QkKMV+RtFLJ3T5f1UI0Qo8nm/t8DQkzeyl2cQrWMS5wjWEHdy7pLEnVRSpNw==
X-Received: by 2002:a05:6638:626:: with SMTP id h6mr1273337jar.113.1573623207874;
        Tue, 12 Nov 2019 21:33:27 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n123sm94447iod.62.2019.11.12.21.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 21:33:26 -0800 (PST)
Date:   Tue, 12 Nov 2019 21:33:18 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Message-ID: <5dcb959eb9d15_6dcc2b08358745c0f9@john-XPS-13-9370.notmuch>
In-Reply-To: <20191113002058.bkch563wm6vhmn3l@ast-mbp.dhcp.thefacebook.com>
References: <f9d5f717-51fe-7d03-6348-dbaf0b9db434@solarflare.com>
 <87r23egdua.fsf@toke.dk>
 <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
 <874l07fu61.fsf@toke.dk>
 <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
 <87eez4odqp.fsf@toke.dk>
 <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
 <87h839oymg.fsf@toke.dk>
 <20191112195223.cp5kcmkko54dsfbg@ast-mbp.dhcp.thefacebook.com>
 <5dcb3f4e8be4_3202ae6af4ec5bcac@john-XPS-13-9370.notmuch>
 <20191113002058.bkch563wm6vhmn3l@ast-mbp.dhcp.thefacebook.com>
Subject: Re: static and dynamic linking. Was: [PATCH bpf-next v3 1/5] bpf:
 Support chain calling multiple BPF
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Tue, Nov 12, 2019 at 03:25:02PM -0800, John Fastabend wrote:
> > 
> > same question as Ed so we can follow up there. How does static linking help
> > verification?
> 
> pls see my reply to Ed.


great will read thansk.

> > > together. The only visible difference dynamic vs static should be that dynamic
> > > linking links to already loaded programs that could be executing whereas static
> > > counterpart links a set of .o. At that point libbpf may see that some 'extern
> > > int prog(...);' referenced in one .o cannot be resolved from another .o. In
> > > such case libbpf will try to link it dynamically with progs running in the
> > > kernel. We haven't yet defined what 'extern' keyword in the program means.
> > > There are a preliminary patches for llvm to support extern variables. Extern
> > > functions are not done yet. We have to walk before we run. With dynamic linking
> > > I'm proposing an api for the kernel that I think will work regardless of how
> > > libbpf and llvm decide to define the meaning of 'extern'.
> > > There are two parts to dynamic linking:
> > > 1. replace a prog or subprog in the kernel with new prog.
> > > 2. from new prog call a prog/subprog that is already loaded.
> > > 
> > > First case is useful to chain multiple progs together. Second is needed to
> > > reuse already present progs instead of loading duplicated coode. Imagine the
> > > following scenario:
> > > subprog1:
> > >   int bpf_packet_parser(struct xdp_md *ctx, struct flow_keys *key)
> > >   { /* parses the packet and populates flow_keys */ }
> > > subprog2:
> > >   int __weak xdp_firewall_placeholder(struct xdp_md *ctx)
> > >   { return XDP_PASS; }
> > > main prog:
> > >   int rootlet(struct xdp_md *ctx)
> > >   { ret = xdp_firewall_placeholder(ctx);
> > >     switch (ret) { case XDP_PASS: break;...
> > >   }
> > > 
> > > New xdp program might want to replace xdp_firewall_placeholder and it might
> > > also want to reuse existing code. It would want to call bpf_packet_parser()
> > > subprog. I'm proposing that a pair of (prog_fd, btf_id of subprog) to be used
> > > in both cases. To replace the program the new prog needs to specify (prog_fd of
> > > rootlet, btf_id of xdp_firewall_placeholder) at load time via
> > > attr->attach_prog_fd, attr->attach_btf_id fields that I'm adding as part of
> > > trampoline patches. To call bpf_packet_parser() from the new prog the call
> > > instruction inside the new prog needs to be annotated with (prog_fd of rootlet,
> > > btf_id of bpf_packet_parser). That is similar to how the maps are referenced
> > > from the program. I think such interface is nicely symmetrical and should work
> > > regardless of how libbpf decides to find 'foo' after seeing 'extern int foo()'.
> > > Similarly static linking should be able to do exactly the same linking, but
> > > completely in user space. I think libbpf should be able to statically link
> > > new_prog.o that calls bpf_packet_parser() with rootlet.o and adjust a call in
> > > rootlet.o into new xdp_firewall_placeholder. Conceptually both static and
> > > dynamic linking for BPF programs should look very similar to how traditional C
> > > programs do it. libbpf will do the magic of specifying (prog_fd, btf_id) in
> > > case dynamic is necessary. Otherwise libbpf will do static linking and adjust
> > > offsets in call instructions. libbpf is already doing call insn adjustment for
> > > subprograms within single .o. Support for static linking in libbpf will be
> > > straightforward to do as soon as we define the meaning of 'extern' and add llvm
> > > support.
> > > 
> > > On the kernel side the first part of dynamic linking (replacing the prog or
> > > subprog) is a relativly simple follow up to trampoline patches that build most
> > > of type checking and connecting apis. The second part of dynamic linking is a
> > > bit more work. Every subprog and prog need to be verified independently
> > > otherwise the whole thing won't scale beyond simple programs. I would like to
> > > build a consensus on the long term plan for dynamic and static linking before
> > > implementing the first step.
> > 
> > Another use case for dynamic linking (long-term) is to reduce verification
> > time. By and large many of the programs we (Cilium) load have large
> > blocks of repeated code. Currently, verification happens on the entire program
> > but would be great to front-load the verification by pre-loading a set of
> > library helpers that are validated at load time and generate a call contract
> > or set of preconditions needed to satisfy verification and set of postconditions
> > upon return. Then when we attach a program (kprobe or networking) the latency
> > can be reduced significantly. I think it likely looks similar (the same?) as
> > below with a slightly different flow from (2.).
> > 
> >    // first load shared libraries
> >    obj = bpf_object__open("fw2.o", attr)
> >    bpf_object__load(obj); // load and verify object could pin/unpin as well
> >   
> >    // inform open hook of symbols with attributes
> >    attr.attach_subprog[0] = libbpf_find__obj_btf_id("foo", obj);
> >    attr.attach_subprog[1] = libbpf_find__obj_btf_id("bar", obj);
> > 
> >    // open and load main program which will now use "foo", "bar"
> >    main = bpf_object__open("rootlet.o", attr)
> >    bpf_object__load(main)
> 
> That sounds very similar to my 2nd case of dynamic linking above, no?

I think it is the same but the order is reversed. First load all the
libraries and then the program that uses them vs loading xdp_main followed
by overwriting the functions. The reason is to reduce the verification
time of the main program because we would have already verified all the
libraries it is using. See below but I believe the proposed API works
for this case?

> Except that you propose to make it explicit by populating attach_subprog[0|1] ?

I don't actually care if its explicit. That could be an internal detail of
libbpf. But if its not exposed it seems the programmer has to tell libbpf
somehow about how to resolve the extern functions? It has to know somehow
to look in obj1, obj2 when loading rootlet.o in my case. So attach_prog_fd
and attach_btf_id would work similarly but I think we still need to be
able to specify multiples of these if the order is reversed. Or alternatively
kernel maintains the table per your additional example below.

Above you had this example,

> 2. Dynamic linking:
>  // assuming libxdp.so manages eth0
>  rootlet_fd = get_xdp_fd(eth0);
>  subprog_btf_id = libbpf_find_prog_btf_id("name_of_placeholder", roolet_fd);
>  //                  ^ this function is in patch 16/18 of trampoline
>  attr.attach_prog_fd = roolet_fd;
>  attr.attach_btf_id = subprog_btf_id;

In my case rootlet_fd hasn't been created yet so we cant use attach_prog_fd here. 

>  // pair (prog_fd, btf_id) needs to be specified at load time
>  obj = bpf_object__open("fw2.o", attr);
>  bpf_object__load(obj);
>  prog = bpf_object__find_program_by_title(obj);
>  link = bpf_program__replace(prog); // similar to bpf_program__attach_trace()
>  // no extra arguments during 'replace'.
>  // Target (prog_fd, btf_id) already known to the kernel and verified

In addition to above flow something like this to load libraries first should
also work?

   // here fw2 is a library its never attached to anything but can be
   // used to pull functions from
   obj = bpf_object__open("fw2.o", attr);
   bpf_object__load(obj);
   prog = bpf_object__find_program_by_title(obj);
   subprog_btf_id0 = libbpf_find_obj_btf_id("name of function", obj);
   subprog_btf_id1 = libbpf_find_obj_btf_id("name of function", obj);

   // all pairs of (prog_fd, btf_id) need to be specified at load time
   attr.attach[0].prog_fd = fw2_fd;
   attr.attach[0].btf_id = subprog_btf_id0;
   attr.attach[1].prog_fd = fw2_fd;
   attr.attach[1].btf_id = subprog_btf_id1;
   obj = bpf_object__open("rootlet.o", attr)
   bpf_object__load(obj)
   prog = bpf_object__find_program_by_title(obj);
   link = bpf_program__replace(prog);
   // attach rootlet.o at this point with subprog_btf_id

I think this is exactly the same just different order? Alternatively to
avoid the array of attach[] the bpf_program__replace() could take the fd/id
like

   link = bpf_program__replace(prog, fw2, subprog_btf_id0))
   prog = bpf_program__from_link(link)
   link = bpf_program__replace(prog, fw2, subprog_btf_id0))

I slightly prefer using multiple replace() calls it feels somewhat similar
to the for each map loops I use today to replace map fds. If multiple replace()
calls are allowed it seems that it would work in original example and in the
case where fw1.o and fw2.o are loaded first.

Was that more clear?

> I think the amount of explicit libbpf api calls should be brought to minimum.

Sounds good to me. On my TODO list to see if some of the map handling
parts we have make sense in libbpf context. For example we have
routines to do map fd replacement which, as noted above, feels
similar to replacing functions.

> The .c program should have enough information about what it wants to link to
> and what it exposes to outside. imo standard C style should work. If BPF
> function is 'static' it cannot be used as helper by other BPF program. If it's
> non-static (global) then it can be. The main headache to resolve is the scope
> of search for libbpf to do. I think from libbpf api side it should look like:
>
>    obj = bpf_object__open("helpers.o", attr);
>    bpf_object__load(obj);
>    // kernel loads and verifies all funcs in helpers.o. They are not attached
>    // to anything yet.
> 
>    main = bpf_object__open("main.o", attr);
>    // libbpf needs to figure out what main.o needs to link to.
>    // If libbpf can do static linking it should, otherwise it will link
>    // into funcs that were loaded as part of helpers.o
>    // libbpf will adjust call insns in main.o with
>    // (prog_fd_of_helpers, btf_id_of_that_helper_func)
>    bpf_object__load(main);

I think this is better than my proposal above. I didn't just delete my
example because I think if we allow multiple replace() calls then we get
extra flexibility without really creating much extra complexity. The
open/load helpers.o case would be the normal flow for using dynamic
linking and if folks want to replace/remove functions they can use above.

One question, in this case if helpers.o is removed after main what happens?
Will main.o also be removed because it will no longer have helpers.o or will
it somehow keep a reference to helpers.o which would break the
uni-directional graph below. FWIW it makes sense to me to just tear the
entire thing down. That is a clear rule user space can follow and organize
as needed it also avoids any strange case where things get stuck with ref
counts.

So I think you have two APIs, the case where the kernel handles it and
the other case where user uses replace() calls to do the dynamic linking
as in original example.

> 
> 
> > > Not sure I follow. Both fw1.o and fw2.o will have their own prog ids.
> > > fw1_prog->aux->linked_prog == rootlet_prog
> > > fw2_prog->aux->linked_prog == rootlet_prog
> > > Unloading and detaching fw1.o will make kernel to switch back to placeholder
> > > subprog in roolet_prog. I believe roolet_prog should not keep a list of progs
> > > that attached to it (or replaced its subprogs) to avoid circular dependency.
> > > Due to that detaching roolet_prog from netdev will stop the flow of packets
> > > into fw1.o, but refcnt of rootlet_prog will not go to zero, so it will stay in
> > > memory until both fw1.o and fw2.o detach from rootlet.o.
> > 
> > I would expect detaching rootlet prog from netdev to _detach_ the rootlet
> > program. Because it happens to be linked to two other object shouldn't
> > impact this IMO.
> > 
> > The first transition is clear,
> > 
> >   detaching fw1.o -> rootlet runs placeholder
> > 
> > But second case
> > 
> >   detach rootlet -> ???
> > 
> > Both fw1.o and fw2.o in this case are object files with their own lifetime
> > which can be pinned/unpinned, etc. I see it makes the implementation a bit
> > more difficult but should be doable.
> 
> detach rootlet - is simply detaching rootlet. It's no longer executing.
> Hence fw1 doesn't see packets anymore. Both rootlet.o and fw1.o stay
> in kernel memory, because libxdp.so didn't unload fw1.o yet and fw1
> keeps rootlet.o alive in memory, because it tracks it as dependency.
> When refcnt drops to zero everywhere all of them gets unloaded and memory freed.
> Same thing when fw1.o and fw2.o did bpf_prog_get(rootlet.o) once for each.

OK this makes sense now thanks.

> 
> > > > What about attaching a third program? Would that work by recursion (as
> > > > above, but with the old proglet as old_fd), or should the library build
> > > > a whole new sequence from the component programs?
> > > 
> > > This choice is up to libxdp.so. It can have a number of placeholders
> > > ready to be replaced by new progs. Or it can re-generate rootlet.o
> > > every time new fwX.o comes along. Short term I would start development
> > > with auto-generated roolet.o and static linking done by libbpf
> > > while the policy and roolet are done by libxdp.so, since this work
> > > doesn't depend on any kernel changes. Long term auto-generation
> > > can stay in libxdp.so if it turns out to be sufficient.
> > 
> > Agreed. Otherwise who/what would have enough information to figure this
> > out. But we should allow for multiple levels of dynamic linking. Example:
> > 
> >    // first load shared libraries
> >    obj1 = bpf_object__open("shared1.o", attr)
> >    bpf_object__load(obj1); // load and verify object could pin/unpin as well
> > 
> >    // second shared lib using first libs
> >    attr.attach_subprog[0] = libbpf_find__obj_btf_id("foo", obj1);
> 
> multi level certainly should be possible.
> I think 'multi level' is probably not entirely accurate name.
> It's the graph of progs and funcs that exists in the kernel and on disk
> that libbpf needs to link to.
> It can have any number of dependencies and levels.
> Hence my proposal above to keep only uni-directional dependency
> when replacing/attaching.

I'm convinced +1

> 
> > If you unload obj3 it will have to walk the chain of objects and dereference
> > them. Is this the circular dependency?
> 
> By circular dependency I meant the case of fw1 and fw2 attaching to rootlet.
> I'm proposing that fw1 remembers that it attached to rootlet, and fw2 remembers
> that it attached to the same rootlet, but rootlet doesn't track what attached to
> it. Otherwise there are bi-directional links and link-lists everywhere.
> 

Got it. And if you don't have a weak func for this to allow fw1 to remove just
remove the rootlet as well.
