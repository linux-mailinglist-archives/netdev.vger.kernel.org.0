Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADDD2F9F31
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 01:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfKMAVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 19:21:05 -0500
Received: from mail-pg1-f172.google.com ([209.85.215.172]:39464 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKMAVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 19:21:05 -0500
Received: by mail-pg1-f172.google.com with SMTP id 29so114924pgm.6;
        Tue, 12 Nov 2019 16:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PgIcsa8HvQC00/GoMxFhJt5XqCSJnSCWAe8WXUnQOS8=;
        b=hPfuJHNeT0iGFTzl4tKesXFAutQ265Zgg2z6jzPR0c7QJUZZEOKWZgChUg301NuCx1
         S2FFoFB2m+oowBlytfBDvFnwLFNWyf1AnnL1GjuEEG9werEcNistl0ukwB5Di5pulZFc
         NIO3hmlmE9niR7raQKa88rDMauxBCWp3BN4x0h7phrPlij1jGiDH7njPev/iyiAZ65gy
         VRrBqjjtyuWJ4j7nT+qovOl7puifSDu1JuRpBwXy9hHr+eAb50Fqv/ZfiGag9CuNpWXI
         ql2pBiHIdm3i2QYQsMd30VWUMePFNTMocC4hYc8iyvsClQVfVvEzAZXUqzk+stzOOEwf
         1kVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PgIcsa8HvQC00/GoMxFhJt5XqCSJnSCWAe8WXUnQOS8=;
        b=KQaNfXG7ibIW8uug06/yjkjWx7XrIVGINm9MS5oPPpgTfkP1dPbX0lQIgMAjas+dGy
         tK5TbQCzfuaDbimKTt1tmbBoc2a4TqQhsNypI/aLaxxLXu59OuMYyOt1Zj47K/0X+iML
         h/mKja8GJ+fKV6LT3dgs1STsze5/uQhoVcyw+glCbzKsNFHHjmxA1zUEz5yfrJzjvl0f
         73uq7Y7mqAgGzG+PoD9JNl7LwtoSL8Ln2WsmdZegpwJCuW0tHQaUH5Eu56K0mS5GfxA/
         gR+N04faiSLrIoDQ70BPEiaEDFYqXgI7u/fOpar1BUugDXg22zaEmYkRusnXGZVMGJDX
         VOKQ==
X-Gm-Message-State: APjAAAUoXbebD6c1MdhRp4q8WtdqggQz/tSwu4dRYtZgMf8JTTM10vrY
        CDdejfYt9itlM2/Tv13ybmc=
X-Google-Smtp-Source: APXvYqwpVaYDpGBWPRoOBN4/m4W7DOQF24V+1bdjmmnz3tEUl1y7yOny7Bwuums77/1hCFpjZvt6/Q==
X-Received: by 2002:a17:90a:2385:: with SMTP id g5mr735530pje.117.1573604462979;
        Tue, 12 Nov 2019 16:21:02 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:e001])
        by smtp.gmail.com with ESMTPSA id m15sm134711pfh.19.2019.11.12.16.21.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 16:21:01 -0800 (PST)
Date:   Tue, 12 Nov 2019 16:21:00 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
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
Subject: Re: static and dynamic linking. Was: [PATCH bpf-next v3 1/5] bpf:
 Support chain calling multiple BPF
Message-ID: <20191113002058.bkch563wm6vhmn3l@ast-mbp.dhcp.thefacebook.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dcb3f4e8be4_3202ae6af4ec5bcac@john-XPS-13-9370.notmuch>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 03:25:02PM -0800, John Fastabend wrote:
> 
> same question as Ed so we can follow up there. How does static linking help
> verification?

pls see my reply to Ed.

> > together. The only visible difference dynamic vs static should be that dynamic
> > linking links to already loaded programs that could be executing whereas static
> > counterpart links a set of .o. At that point libbpf may see that some 'extern
> > int prog(...);' referenced in one .o cannot be resolved from another .o. In
> > such case libbpf will try to link it dynamically with progs running in the
> > kernel. We haven't yet defined what 'extern' keyword in the program means.
> > There are a preliminary patches for llvm to support extern variables. Extern
> > functions are not done yet. We have to walk before we run. With dynamic linking
> > I'm proposing an api for the kernel that I think will work regardless of how
> > libbpf and llvm decide to define the meaning of 'extern'.
> > There are two parts to dynamic linking:
> > 1. replace a prog or subprog in the kernel with new prog.
> > 2. from new prog call a prog/subprog that is already loaded.
> > 
> > First case is useful to chain multiple progs together. Second is needed to
> > reuse already present progs instead of loading duplicated coode. Imagine the
> > following scenario:
> > subprog1:
> >   int bpf_packet_parser(struct xdp_md *ctx, struct flow_keys *key)
> >   { /* parses the packet and populates flow_keys */ }
> > subprog2:
> >   int __weak xdp_firewall_placeholder(struct xdp_md *ctx)
> >   { return XDP_PASS; }
> > main prog:
> >   int rootlet(struct xdp_md *ctx)
> >   { ret = xdp_firewall_placeholder(ctx);
> >     switch (ret) { case XDP_PASS: break;...
> >   }
> > 
> > New xdp program might want to replace xdp_firewall_placeholder and it might
> > also want to reuse existing code. It would want to call bpf_packet_parser()
> > subprog. I'm proposing that a pair of (prog_fd, btf_id of subprog) to be used
> > in both cases. To replace the program the new prog needs to specify (prog_fd of
> > rootlet, btf_id of xdp_firewall_placeholder) at load time via
> > attr->attach_prog_fd, attr->attach_btf_id fields that I'm adding as part of
> > trampoline patches. To call bpf_packet_parser() from the new prog the call
> > instruction inside the new prog needs to be annotated with (prog_fd of rootlet,
> > btf_id of bpf_packet_parser). That is similar to how the maps are referenced
> > from the program. I think such interface is nicely symmetrical and should work
> > regardless of how libbpf decides to find 'foo' after seeing 'extern int foo()'.
> > Similarly static linking should be able to do exactly the same linking, but
> > completely in user space. I think libbpf should be able to statically link
> > new_prog.o that calls bpf_packet_parser() with rootlet.o and adjust a call in
> > rootlet.o into new xdp_firewall_placeholder. Conceptually both static and
> > dynamic linking for BPF programs should look very similar to how traditional C
> > programs do it. libbpf will do the magic of specifying (prog_fd, btf_id) in
> > case dynamic is necessary. Otherwise libbpf will do static linking and adjust
> > offsets in call instructions. libbpf is already doing call insn adjustment for
> > subprograms within single .o. Support for static linking in libbpf will be
> > straightforward to do as soon as we define the meaning of 'extern' and add llvm
> > support.
> > 
> > On the kernel side the first part of dynamic linking (replacing the prog or
> > subprog) is a relativly simple follow up to trampoline patches that build most
> > of type checking and connecting apis. The second part of dynamic linking is a
> > bit more work. Every subprog and prog need to be verified independently
> > otherwise the whole thing won't scale beyond simple programs. I would like to
> > build a consensus on the long term plan for dynamic and static linking before
> > implementing the first step.
> 
> Another use case for dynamic linking (long-term) is to reduce verification
> time. By and large many of the programs we (Cilium) load have large
> blocks of repeated code. Currently, verification happens on the entire program
> but would be great to front-load the verification by pre-loading a set of
> library helpers that are validated at load time and generate a call contract
> or set of preconditions needed to satisfy verification and set of postconditions
> upon return. Then when we attach a program (kprobe or networking) the latency
> can be reduced significantly. I think it likely looks similar (the same?) as
> below with a slightly different flow from (2.).
> 
>    // first load shared libraries
>    obj = bpf_object__open("fw2.o", attr)
>    bpf_object__load(obj); // load and verify object could pin/unpin as well
>   
>    // inform open hook of symbols with attributes
>    attr.attach_subprog[0] = libbpf_find__obj_btf_id("foo", obj);
>    attr.attach_subprog[1] = libbpf_find__obj_btf_id("bar", obj);
> 
>    // open and load main program which will now use "foo", "bar"
>    main = bpf_object__open("rootlet.o", attr)
>    bpf_object__load(main)

That sounds very similar to my 2nd case of dynamic linking above, no?
Except that you propose to make it explicit by populating attach_subprog[0|1] ?
I think the amount of explicit libbpf api calls should be brought to minimum.
The .c program should have enough information about what it wants to link to
and what it exposes to outside. imo standard C style should work. If BPF
function is 'static' it cannot be used as helper by other BPF program. If it's
non-static (global) then it can be. The main headache to resolve is the scope
of search for libbpf to do. I think from libbpf api side it should look like:
   obj = bpf_object__open("helpers.o", attr);
   bpf_object__load(obj);
   // kernel loads and verifies all funcs in helpers.o. They are not attached
   // to anything yet.

   main = bpf_object__open("main.o", attr);
   // libbpf needs to figure out what main.o needs to link to.
   // If libbpf can do static linking it should, otherwise it will link
   // into funcs that were loaded as part of helpers.o
   // libbpf will adjust call insns in main.o with
   // (prog_fd_of_helpers, btf_id_of_that_helper_func)
   bpf_object__load(main);


> > Not sure I follow. Both fw1.o and fw2.o will have their own prog ids.
> > fw1_prog->aux->linked_prog == rootlet_prog
> > fw2_prog->aux->linked_prog == rootlet_prog
> > Unloading and detaching fw1.o will make kernel to switch back to placeholder
> > subprog in roolet_prog. I believe roolet_prog should not keep a list of progs
> > that attached to it (or replaced its subprogs) to avoid circular dependency.
> > Due to that detaching roolet_prog from netdev will stop the flow of packets
> > into fw1.o, but refcnt of rootlet_prog will not go to zero, so it will stay in
> > memory until both fw1.o and fw2.o detach from rootlet.o.
> 
> I would expect detaching rootlet prog from netdev to _detach_ the rootlet
> program. Because it happens to be linked to two other object shouldn't
> impact this IMO.
> 
> The first transition is clear,
> 
>   detaching fw1.o -> rootlet runs placeholder
> 
> But second case
> 
>   detach rootlet -> ???
> 
> Both fw1.o and fw2.o in this case are object files with their own lifetime
> which can be pinned/unpinned, etc. I see it makes the implementation a bit
> more difficult but should be doable.

detach rootlet - is simply detaching rootlet. It's no longer executing.
Hence fw1 doesn't see packets anymore. Both rootlet.o and fw1.o stay
in kernel memory, because libxdp.so didn't unload fw1.o yet and fw1
keeps rootlet.o alive in memory, because it tracks it as dependency.
When refcnt drops to zero everywhere all of them gets unloaded and memory freed.
Same thing when fw1.o and fw2.o did bpf_prog_get(rootlet.o) once for each.

> > > What about attaching a third program? Would that work by recursion (as
> > > above, but with the old proglet as old_fd), or should the library build
> > > a whole new sequence from the component programs?
> > 
> > This choice is up to libxdp.so. It can have a number of placeholders
> > ready to be replaced by new progs. Or it can re-generate rootlet.o
> > every time new fwX.o comes along. Short term I would start development
> > with auto-generated roolet.o and static linking done by libbpf
> > while the policy and roolet are done by libxdp.so, since this work
> > doesn't depend on any kernel changes. Long term auto-generation
> > can stay in libxdp.so if it turns out to be sufficient.
> 
> Agreed. Otherwise who/what would have enough information to figure this
> out. But we should allow for multiple levels of dynamic linking. Example:
> 
>    // first load shared libraries
>    obj1 = bpf_object__open("shared1.o", attr)
>    bpf_object__load(obj1); // load and verify object could pin/unpin as well
> 
>    // second shared lib using first libs
>    attr.attach_subprog[0] = libbpf_find__obj_btf_id("foo", obj1);

multi level certainly should be possible.
I think 'multi level' is probably not entirely accurate name.
It's the graph of progs and funcs that exists in the kernel and on disk
that libbpf needs to link to.
It can have any number of dependencies and levels.
Hence my proposal above to keep only uni-directional dependency
when replacing/attaching.

> If you unload obj3 it will have to walk the chain of objects and dereference
> them. Is this the circular dependency?

By circular dependency I meant the case of fw1 and fw2 attaching to rootlet.
I'm proposing that fw1 remembers that it attached to rootlet, and fw2 remembers
that it attached to the same rootlet, but rootlet doesn't track what attached to
it. Otherwise there are bi-directional links and link-lists everywhere.

