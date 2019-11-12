Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCC92F9E27
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 00:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKLXZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 18:25:14 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:39058 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKLXZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 18:25:13 -0500
Received: by mail-io1-f66.google.com with SMTP id k1so344126ioj.6;
        Tue, 12 Nov 2019 15:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=CR66TCUIBmdX0WY1ZB9yKV06stZ85ZtwG4Z8BzXdTqM=;
        b=hyqNERnrV9SthOw9fNUIGZ1BkjNDX/e6y2COIcNI/2/YRoFgTCPi0irFyujNoBHXvV
         yLfzmfiXkE+Src2IRWGFrNKe6ZjocjMOwol3hFf4o7mTzABsy21Ro+mTb7iuR66XUHWb
         oocva5qIYiBs/gc+qz5NQN/bz3DTuei9nvKN6fYI88r2IayaTSPzy1M0AM6N9MrQZiSs
         A0fua2/aFISABC3CBLQcJVeu2pS++XuiI26oyUKNeTJlVUQ48asqufToE4BD3EPcP/a3
         H5zhzHeF2UNb8ZYbt/8IcIGDhrQJ44JLwbnEKpZv4SV8UDrxeALMAtvNUQ0yAOFdm2Qz
         1zFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=CR66TCUIBmdX0WY1ZB9yKV06stZ85ZtwG4Z8BzXdTqM=;
        b=CGZh18qQps9gHTzrcmaaYAFAT9afq9Y7VdYTXlV8ieJvM9c+9hMkCY6zX6c4kWTzLj
         C2qxmCuEe1xyXv4cDPaH7sRRjJQ3f83olKDgZ4kNau9bRCYwFcwRj0jcTygnYmmkP9Tc
         +Vgl4TQXHd5eLLp1CSxSu/vZhj7DMnHps5GIppDjeGpFUNlRcPipDX4S/QX7Ajn2h1Sk
         hRm+cdrBbNxOdCcyji9yyVxjl1yvG40NfVQWAYy3RkTs57Fq8mrJaAo5cx14N0fA71h9
         2VxDFsFZrYpEM7HSFRv+tW97/6e3IFpPrCxmDa9EuTaHpLebNkrsY4PUVpvFOQegcbIE
         XirA==
X-Gm-Message-State: APjAAAVVnSYlJSboSCtU0H1MX3ivUiWOzLzWI6j8fhW4rXwZB6MSSPdp
        goiCrptS/grm0Pj6sqfcy3M=
X-Google-Smtp-Source: APXvYqyPNDx2REXULpggrVSfsDzGPg2G/aSRElzoKhvZn88M8Q0zewCt0HZ1ynZsXr5e1HWtI8vZaQ==
X-Received: by 2002:a5d:9ecd:: with SMTP id a13mr503272ioe.270.1573601112239;
        Tue, 12 Nov 2019 15:25:12 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f2sm24481iog.30.2019.11.12.15.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 15:25:11 -0800 (PST)
Date:   Tue, 12 Nov 2019 15:25:02 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
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
Message-ID: <5dcb3f4e8be4_3202ae6af4ec5bcac@john-XPS-13-9370.notmuch>
In-Reply-To: <20191112195223.cp5kcmkko54dsfbg@ast-mbp.dhcp.thefacebook.com>
References: <5da4ab712043c_25f42addb7c085b83b@john-XPS-13-9370.notmuch>
 <87eezfi2og.fsf@toke.dk>
 <f9d5f717-51fe-7d03-6348-dbaf0b9db434@solarflare.com>
 <87r23egdua.fsf@toke.dk>
 <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
 <874l07fu61.fsf@toke.dk>
 <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
 <87eez4odqp.fsf@toke.dk>
 <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
 <87h839oymg.fsf@toke.dk>
 <20191112195223.cp5kcmkko54dsfbg@ast-mbp.dhcp.thefacebook.com>
Subject: Re: static and dynamic linking. Was: [PATCH bpf-next v3 1/5] bpf:
 Support chain calling multiple BPF
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Tue, Nov 12, 2019 at 05:20:07PM +0100, Toke H=C3=B8iland-J=C3=B8rgen=
sen wrote:
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > =

> > > On Tue, Oct 22, 2019 at 08:07:42PM +0200, Toke H=C3=B8iland-J=C3=B8=
rgensen wrote:
> > >> =

> > >
> > > I think what Ed is proposing with static linking is the best generi=
c solution.
> > > The chaining policy doesn't belong in the kernel. A user space can =
express the
> > > chaining logic in the form of BPF program. Static linking achieves =
that. There
> > > could be a 'root' bpf program (let's call it rootlet.o) that looks =
like:
> > > int xdp_firewall_placeholder1(struct xdp_md *ctx)

+1 static linking seems the clear winner here to me.

[...]

> =

> I think long term the set of features supported by static and dynamic l=
inking
> should be the same. Partial verification should be available regardless=
 of
> whether kernel performs dynamic linking or libbpf staticly links multip=
le .o

same question as Ed so we can follow up there. How does static linking he=
lp
verification?

> together. The only visible difference dynamic vs static should be that =
dynamic
> linking links to already loaded programs that could be executing wherea=
s static
> counterpart links a set of .o. At that point libbpf may see that some '=
extern
> int prog(...);' referenced in one .o cannot be resolved from another .o=
. In
> such case libbpf will try to link it dynamically with progs running in =
the
> kernel. We haven't yet defined what 'extern' keyword in the program mea=
ns.
> There are a preliminary patches for llvm to support extern variables. E=
xtern
> functions are not done yet. We have to walk before we run. With dynamic=
 linking
> I'm proposing an api for the kernel that I think will work regardless o=
f how
> libbpf and llvm decide to define the meaning of 'extern'.
> There are two parts to dynamic linking:
> 1. replace a prog or subprog in the kernel with new prog.
> 2. from new prog call a prog/subprog that is already loaded.
> =

> First case is useful to chain multiple progs together. Second is needed=
 to
> reuse already present progs instead of loading duplicated coode. Imagin=
e the
> following scenario:
> subprog1:
>   int bpf_packet_parser(struct xdp_md *ctx, struct flow_keys *key)
>   { /* parses the packet and populates flow_keys */ }
> subprog2:
>   int __weak xdp_firewall_placeholder(struct xdp_md *ctx)
>   { return XDP_PASS; }
> main prog:
>   int rootlet(struct xdp_md *ctx)
>   { ret =3D xdp_firewall_placeholder(ctx);
>     switch (ret) { case XDP_PASS: break;...
>   }
> =

> New xdp program might want to replace xdp_firewall_placeholder and it m=
ight
> also want to reuse existing code. It would want to call bpf_packet_pars=
er()
> subprog. I'm proposing that a pair of (prog_fd, btf_id of subprog) to b=
e used
> in both cases. To replace the program the new prog needs to specify (pr=
og_fd of
> rootlet, btf_id of xdp_firewall_placeholder) at load time via
> attr->attach_prog_fd, attr->attach_btf_id fields that I'm adding as par=
t of
> trampoline patches. To call bpf_packet_parser() from the new prog the c=
all
> instruction inside the new prog needs to be annotated with (prog_fd of =
rootlet,
> btf_id of bpf_packet_parser). That is similar to how the maps are refer=
enced
> from the program. I think such interface is nicely symmetrical and shou=
ld work
> regardless of how libbpf decides to find 'foo' after seeing 'extern int=
 foo()'.
> Similarly static linking should be able to do exactly the same linking,=
 but
> completely in user space. I think libbpf should be able to statically l=
ink
> new_prog.o that calls bpf_packet_parser() with rootlet.o and adjust a c=
all in
> rootlet.o into new xdp_firewall_placeholder. Conceptually both static a=
nd
> dynamic linking for BPF programs should look very similar to how tradit=
ional C
> programs do it. libbpf will do the magic of specifying (prog_fd, btf_id=
) in
> case dynamic is necessary. Otherwise libbpf will do static linking and =
adjust
> offsets in call instructions. libbpf is already doing call insn adjustm=
ent for
> subprograms within single .o. Support for static linking in libbpf will=
 be
> straightforward to do as soon as we define the meaning of 'extern' and =
add llvm
> support.
> =

> On the kernel side the first part of dynamic linking (replacing the pro=
g or
> subprog) is a relativly simple follow up to trampoline patches that bui=
ld most
> of type checking and connecting apis. The second part of dynamic linkin=
g is a
> bit more work. Every subprog and prog need to be verified independently=

> otherwise the whole thing won't scale beyond simple programs. I would l=
ike to
> build a consensus on the long term plan for dynamic and static linking =
before
> implementing the first step.

Another use case for dynamic linking (long-term) is to reduce verificatio=
n
time. By and large many of the programs we (Cilium) load have large
blocks of repeated code. Currently, verification happens on the entire pr=
ogram
but would be great to front-load the verification by pre-loading a set of=

library helpers that are validated at load time and generate a call contr=
act
or set of preconditions needed to satisfy verification and set of postcon=
ditions
upon return. Then when we attach a program (kprobe or networking) the lat=
ency
can be reduced significantly. I think it likely looks similar (the same?)=
 as
below with a slightly different flow from (2.).

   // first load shared libraries
   obj =3D bpf_object__open("fw2.o", attr)
   bpf_object__load(obj); // load and verify object could pin/unpin as we=
ll
  =

   // inform open hook of symbols with attributes
   attr.attach_subprog[0] =3D libbpf_find__obj_btf_id("foo", obj);
   attr.attach_subprog[1] =3D libbpf_find__obj_btf_id("bar", obj);

   // open and load main program which will now use "foo", "bar"
   main =3D bpf_object__open("rootlet.o", attr)
   bpf_object__load(main)

   // finally attach it, load it into xdp, load into tc, etc  ...
   prog =3D bpf_object__find_program_by_title(main, "main")
   bpf_program__attach_*(prog);

> =

> 2. Dynamic linking:
>   // assuming libxdp.so manages eth0
>   rootlet_fd =3D get_xdp_fd(eth0);
>   subprog_btf_id =3D libbpf_find_prog_btf_id("name_of_placeholder", roo=
let_fd);
>   //                  ^ this function is in patch 16/18 of trampoline
>   attr.attach_prog_fd =3D roolet_fd;
>   attr.attach_btf_id =3D subprog_btf_id;
>   // pair (prog_fd, btf_id) needs to be specified at load time
>   obj =3D bpf_object__open("fw2.o", attr);
>   bpf_object__load(obj);
>   prog =3D bpf_object__find_program_by_title(obj);
>   link =3D bpf_program__replace(prog); // similar to bpf_program__attac=
h_trace()
>   // no extra arguments during 'replace'.
>   // Target (prog_fd, btf_id) already known to the kernel and verified
> =


I'll post the code I talked about at LPC that generates pre/post conditio=
ns
as a possible example. Although initially the pre/post conditions could b=
e
simple, e.g. arg1 is 'struct xdp_md *' and on return register/stack state=

are unknown. Basically no change from whats proposed here but with a path=

to arbitrary calls.

> =

> Back to your question of how fw2 will get loaded.. I'm thinking the fol=
lowing:
> 1. Static linking:
>   obj =3D bpf_object__open("rootlet.o", "fw1.o", "fw2.o");
>   // libbpf adjusts call offsets and links into single loadable bpf_obj=
ect
>   bpf_object__load(obj);
>   bpf_set_link_xdp_fd()
> No kernel changes are necessary to support program chaining via static =
linking.

Nice thing here is it will work on any recent kernels.

> =

> 2. Dynamic linking:
>   // assuming libxdp.so manages eth0
>   rootlet_fd =3D get_xdp_fd(eth0);
>   subprog_btf_id =3D libbpf_find_prog_btf_id("name_of_placeholder", roo=
let_fd);
>   //                  ^ this function is in patch 16/18 of trampoline
>   attr.attach_prog_fd =3D roolet_fd;
>   attr.attach_btf_id =3D subprog_btf_id;
>   // pair (prog_fd, btf_id) needs to be specified at load time
>   obj =3D bpf_object__open("fw2.o", attr);
>   bpf_object__load(obj);
>   prog =3D bpf_object__find_program_by_title(obj);
>   link =3D bpf_program__replace(prog); // similar to bpf_program__attac=
h_trace()
>   // no extra arguments during 'replace'.
>   // Target (prog_fd, btf_id) already known to the kernel and verified
> =

> > So the two component programs would still exist as kernel objects,
> > right? =

> =

> yes. Both fw1.o and fw2.o will be loaded and running instead of placeho=
lders.
> =

> > And the trampolines would keep individual stats for each one (if
> > BPF stats are enabled)? =

> =

> In case of dynamic linking both fw1.o and fw2.o will be seen as individ=
ual
> programs from 'bpftool p s' point of view. And both will have individua=
l stats.
> =

> > Could userspace also extract the prog IDs being
> > referenced by the "glue" proglet? =

> =

> Not sure I follow. Both fw1.o and fw2.o will have their own prog ids.
> fw1_prog->aux->linked_prog =3D=3D rootlet_prog
> fw2_prog->aux->linked_prog =3D=3D rootlet_prog
> Unloading and detaching fw1.o will make kernel to switch back to placeh=
older
> subprog in roolet_prog. I believe roolet_prog should not keep a list of=
 progs
> that attached to it (or replaced its subprogs) to avoid circular depend=
ency.
> Due to that detaching roolet_prog from netdev will stop the flow of pac=
kets
> into fw1.o, but refcnt of rootlet_prog will not go to zero, so it will =
stay in
> memory until both fw1.o and fw2.o detach from rootlet.o.

I would expect detaching rootlet prog from netdev to _detach_ the rootlet=

program. Because it happens to be linked to two other object shouldn't
impact this IMO.

The first transition is clear,

  detaching fw1.o -> rootlet runs placeholder

But second case

  detach rootlet -> ???

Both fw1.o and fw2.o in this case are object files with their own lifetim=
e
which can be pinned/unpinned, etc. I see it makes the implementation a bi=
t
more difficult but should be doable.

> =

> > What about attaching a third program? Would that work by recursion (a=
s
> > above, but with the old proglet as old_fd), or should the library bui=
ld
> > a whole new sequence from the component programs?
> =

> This choice is up to libxdp.so. It can have a number of placeholders
> ready to be replaced by new progs. Or it can re-generate rootlet.o
> every time new fwX.o comes along. Short term I would start development
> with auto-generated roolet.o and static linking done by libbpf
> while the policy and roolet are done by libxdp.so, since this work
> doesn't depend on any kernel changes. Long term auto-generation
> can stay in libxdp.so if it turns out to be sufficient.

Agreed. Otherwise who/what would have enough information to figure this
out. But we should allow for multiple levels of dynamic linking. Example:=


   // first load shared libraries
   obj1 =3D bpf_object__open("shared1.o", attr)
   bpf_object__load(obj1); // load and verify object could pin/unpin as w=
ell

   // second shared lib using first libs
   attr.attach_subprog[0] =3D libbpf_find__obj_btf_id("foo", obj1);
   obj2 =3D bpf_object__open("shared2.o", attr)
   bpf_object__load(obj2); // load and verify object could pin/unpin as w=
ell
  =

   // open and load main program which will now use "bar" in obj2.
   attr.attach_subprog[0] =3D libbpf_find__obj_btf_id("bar", obj2);
   main =3D bpf_object__open("rootlet.o", attr)
   bpf_object__load(main)

   // now we have a main object with main -> obj2 -> obj1

If we can unload obj1 but its refcnt will not go to zero because of
obj2. However unloading main is OK.

Is the circular dependency case you are woried about the following then?

   load obj2             obj2(refcnt 1)
   load obj1->obj2       obj2(refcnt 2) obj1(refcnt 1)
   load obj3->obj1->obj2 obj2(refcnt 3) obj1(refcnt 2) obj3(refcnt 1)
            ->obj2

If you unload obj3 it will have to walk the chain of objects and derefere=
nce
them. Is this the circular dependency?
 =

> =

> > Finally, what happens if someone where to try to attach a retprobe to=

> > one of the component programs? Could it be possible to do that even
> > while program is being run from proglet dispatch? That way we can sti=
ll
> > debug an individual XDP program even though it's run as part of a cha=
in.
> =

> Right. The fentry/fexit tracing is orthogonal to static/dynamic linking=
.
> It will be available for all prog types after trampoline patches land.
> See fexit_bpf2bpf.c example in the last 18/18 patch.
> We will be able to debug XDP program regardless whether it's a rootlet
> or a subprogram. Doesn't matter whether linking was static or dynamic.
> With fentry/fexit we will be able to do different stats too.
> Right now bpf program stats are limited to cycles and I resisted a lot
> of pressure to add more hard coded stats. With fentry/fexit we can
> collect arbitrary counters per program. Like number of L1-cache misses
> or number of TLB misses in a given XDP prog.
> =

> > Sounds reasonable. Any reason libxdp.so couldn't be part of libbpf?
> =

> libxdp.so is a policy specifier while libbpf is a tool. It makes more s=
ense for
> them to be separate. libbpf has strong api compatibility guarantees. Wh=
ile I
> don't think anyone knows at this point how libxdp api should look and i=
t will
> take some time for it to mature.

Agree separate makes more sense to me. Seems you may end up with a policy=

language and rpm packaging details, etc. in this. Probably not libbpf.
Could be in ./tools/lib/xdp though.

> =

> > =

> > > If in the future we figure out how to do two load-balancers libxdp.=
so
> > > will be able to accommodate that new policy.
> > =

> > Yeah, it would be cool if we could move things across CPUs; like with=

> > cpumap, but executing another XDP program on the target CPU.
> =

> You mean like different load balancers for different nic rx queues?
> Hmm. I guess that's possible. Another reason to keep libxdp policy
> flexible at early stages of development.
> =
