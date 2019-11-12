Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA99BF9A0B
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 20:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKLTwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 14:52:31 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38584 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfKLTwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 14:52:30 -0500
Received: by mail-pg1-f195.google.com with SMTP id 15so12545688pgh.5;
        Tue, 12 Nov 2019 11:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=cUlpMy61q2Pu6KeTPm/iG2sryTS8rctkAQSwBwsvI+c=;
        b=cR1++sAlmo6FjIRxio03cxH+bdf4fP/b/xYGdCxsHuvS9KfBogeHXk024phuZifWQ5
         3ft0KBkPQ0qMVbLpo6guX9aaboUxWpVCaiViZQGZy6SdIweiFvh0FFGkhNAnb5+C2gd2
         BHssdxiZdyPz5pIrBPMPg/WH0goaifBdO/JfS1U+pO+iOUxY2+oWV6vP9bBPO07NJqu9
         FKEUAdSgbTnFnIrSyBdEoG+NM31uaMhGpz3kDnv207Ip+lktvY023/m+MFPven+4jPDi
         uGU2B7ujGmay5m8skzvhk1ArO491RYIwCc4uGpdcC/sMJTJoaZuR4qdpjHtjnnkaC55H
         rEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=cUlpMy61q2Pu6KeTPm/iG2sryTS8rctkAQSwBwsvI+c=;
        b=ZCqCRCFo1M0TrJSqx4b+Sxfy+g9N6pB/qL1ZbGKE0KoferKV4gwSJNpl4zEH0f2b0p
         mMB3YIuFa3HJ7OXJJ6a8kwnSxLzNBlw9s1JFOAwRLxVldg7LXN9ljARU3UuenFXqaPeS
         IUwCC90BcLPBtlFiPRKIzLLBCqPx+gHiAX0TsWmpwWF3idI7CmmMgq2F/VeUSCGp1x+6
         ID6RIE4Hs9XnsGcKaVrFtC7P5dmJbZiKFUsphFMSbWeWhWmFpiYHCL/ZVt2y4zNtgSqA
         rGFV5Y0f9tcNdG2yYYMUmIiIe28dXatFKVSCK5zcvu5V1N2/ST6fX/MRL/Kue4+mOCDn
         /KZQ==
X-Gm-Message-State: APjAAAWbMlJrucAPmswWWhkPUfSWXrpNnBrZGoMe5b9z0ryuJCNM19Ct
        5I9WcTSWGnfBHRhddwJneeA=
X-Google-Smtp-Source: APXvYqzj2c0s9z98gXSwHImCEuqkLiNqez6/aug7igwE/Bm+9HAGIzJHg4zvQ6kmzVU3+CIWbPDe8g==
X-Received: by 2002:a63:715d:: with SMTP id b29mr213673pgn.369.1573588349268;
        Tue, 12 Nov 2019 11:52:29 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:e001])
        by smtp.gmail.com with ESMTPSA id p3sm23264542pfb.163.2019.11.12.11.52.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 11:52:27 -0800 (PST)
Date:   Tue, 12 Nov 2019 11:52:26 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
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
Subject: Re: static and dynamic linking. Was: [PATCH bpf-next v3 1/5] bpf:
 Support chain calling multiple BPF
Message-ID: <20191112195223.cp5kcmkko54dsfbg@ast-mbp.dhcp.thefacebook.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h839oymg.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 05:20:07PM +0100, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Tue, Oct 22, 2019 at 08:07:42PM +0200, Toke Høiland-Jørgensen wrote:
> >> 
> >> I believe this is what Alexei means by "indirect calls". That is
> >> different, though, because it implies that each program lives as a
> >> separate object in the kernel - and so it might actually work. What you
> >> were talking about (until this paragraph) was something that was
> >> entirely in userspace, and all the kernel sees is a blob of the eBPF
> >> equivalent of `cat *.so > my_composite_prog.so`.
> >
> > So I've looked at indirect calls and realized that they're _indirect_ calls.
> > The retpoline overhead will be around, so a solution has to work without them.
> > I still think they're necessary for all sorts of things, but priority shifted.
> >
> > I think what Ed is proposing with static linking is the best generic solution.
> > The chaining policy doesn't belong in the kernel. A user space can express the
> > chaining logic in the form of BPF program. Static linking achieves that. There
> > could be a 'root' bpf program (let's call it rootlet.o) that looks like:
> > int xdp_firewall_placeholder1(struct xdp_md *ctx)
> > {
> >    return XDP_PASS;
> > }
> > int xdp_firewall_placeholder2(struct xdp_md *ctx)
> > {
> >    return XDP_PASS;
> > }
> > int xdp_load_balancer_placeholder1(struct xdp_md *ctx)
> > {
> >    return XDP_PASS;
> > }
> > int main_xdp_prog(struct xdp_md *ctx)
> > {
> >    int ret;
> >
> >    ret = xdp_firewall_placeholder1(ctx);
> >    switch (ret) {
> >    case XDP_PASS: break;
> >    case XDP_PROP: return XDP_DROP;
> >    case XDP_TX: case XDP_REDIRECT:
> >       /* buggy firewall */
> >       bpf_perf_event_output(ctx,...);
> >    default: break; /* or whatever else */
> >    }
> >    
> >    ret = xdp_firewall_placeholder2(ctx);
> >    switch (ret) {
> >    case XDP_PASS: break;
> >    case XDP_PROP: return XDP_DROP;
> >    default: break;
> >    }
> >
> >    ret = xdp_load_balancer_placeholder1(ctx);
> >    switch (ret) {
> >    case XDP_PASS: break;
> >    case XDP_PROP: return XDP_DROP;
> >    case XDP_TX: return XDP_TX;
> >    case XDP_REDIRECT: return XDP_REDIRECT;
> >    default: break; /* or whatever else */
> >    }
> >    return XDP_PASS;
> > }
> >
> > When firewall1.rpm is installed it needs to use either a central daemon or
> > common library (let's call it libxdp.so) that takes care of orchestration. The
> > library would need to keep a state somewhere (like local file or a database).
> > The state will include rootlet.o and new firewall1.o that wants to be linked
> > into the existing program chain. When firewall2.rpm gets installed it calls the
> > same libxdp.so functions that operate on shared state. libxdp.so needs to link
> > firewall1.o + firewall2.o + rootlet.o into one program and attach it to netdev.
> > This is static linking. The existing kernel infrastructure already supports
> > such model and I think it's enough for a lot of use cases. In particular fb's
> > firewall+katran XDP style will fit right in. But bpf_tail_calls are
> > incompatible with bpf2bpf calls that static linking will use and I think
> > cloudlfare folks expressed the interest to use them for some reason even within
> > single firewall ? so we need to improve the model a bit.
> >
> > We can introduce dynamic linking. The second part of 'BPF trampoline'
> > patches allows tracing programs to attach to other BPF programs. The
> > idea of dynamic linking is to replace a program or subprogram instead
> > of attaching to it. The firewall1.rpm application will still use
> > libxdp.so, but instead of statically linking it will ask kernel to
> > replace a subprogram rootlet_fd + btf_id_of_xdp_firewall_placeholder1
> > with new firewall1.o. The same interface is used for attaching tracing
> > prog to networking prog.
> 
> Hmm, let's see if I'm understanding you correctly. In this model, to
> attach program #2 (assuming the first one is already loaded on an
> interface), userspace would need to do something like:
> 
> old_fd = get_xdp_fd(eth0);
> new_fd = load_bpf("newprog.o"); // verifies newprog.o
> proglet = load_bpf("xdp-run-2-progs.o"); // or dynamically generate this
> replace_subprog(proglet, 0, old_fd); // similar to map FD replacement?
> replace_subprog(proglet, 1, new_fd);
> proglet_fd = load_bpf(proglet); // verifier reuses sub-fd prog verdicts

I think long term the set of features supported by static and dynamic linking
should be the same. Partial verification should be available regardless of
whether kernel performs dynamic linking or libbpf staticly links multiple .o
together. The only visible difference dynamic vs static should be that dynamic
linking links to already loaded programs that could be executing whereas static
counterpart links a set of .o. At that point libbpf may see that some 'extern
int prog(...);' referenced in one .o cannot be resolved from another .o. In
such case libbpf will try to link it dynamically with progs running in the
kernel. We haven't yet defined what 'extern' keyword in the program means.
There are a preliminary patches for llvm to support extern variables. Extern
functions are not done yet. We have to walk before we run. With dynamic linking
I'm proposing an api for the kernel that I think will work regardless of how
libbpf and llvm decide to define the meaning of 'extern'.
There are two parts to dynamic linking:
1. replace a prog or subprog in the kernel with new prog.
2. from new prog call a prog/subprog that is already loaded.

First case is useful to chain multiple progs together. Second is needed to
reuse already present progs instead of loading duplicated coode. Imagine the
following scenario:
subprog1:
  int bpf_packet_parser(struct xdp_md *ctx, struct flow_keys *key)
  { /* parses the packet and populates flow_keys */ }
subprog2:
  int __weak xdp_firewall_placeholder(struct xdp_md *ctx)
  { return XDP_PASS; }
main prog:
  int rootlet(struct xdp_md *ctx)
  { ret = xdp_firewall_placeholder(ctx);
    switch (ret) { case XDP_PASS: break;...
  }

New xdp program might want to replace xdp_firewall_placeholder and it might
also want to reuse existing code. It would want to call bpf_packet_parser()
subprog. I'm proposing that a pair of (prog_fd, btf_id of subprog) to be used
in both cases. To replace the program the new prog needs to specify (prog_fd of
rootlet, btf_id of xdp_firewall_placeholder) at load time via
attr->attach_prog_fd, attr->attach_btf_id fields that I'm adding as part of
trampoline patches. To call bpf_packet_parser() from the new prog the call
instruction inside the new prog needs to be annotated with (prog_fd of rootlet,
btf_id of bpf_packet_parser). That is similar to how the maps are referenced
from the program. I think such interface is nicely symmetrical and should work
regardless of how libbpf decides to find 'foo' after seeing 'extern int foo()'.
Similarly static linking should be able to do exactly the same linking, but
completely in user space. I think libbpf should be able to statically link
new_prog.o that calls bpf_packet_parser() with rootlet.o and adjust a call in
rootlet.o into new xdp_firewall_placeholder. Conceptually both static and
dynamic linking for BPF programs should look very similar to how traditional C
programs do it. libbpf will do the magic of specifying (prog_fd, btf_id) in
case dynamic is necessary. Otherwise libbpf will do static linking and adjust
offsets in call instructions. libbpf is already doing call insn adjustment for
subprograms within single .o. Support for static linking in libbpf will be
straightforward to do as soon as we define the meaning of 'extern' and add llvm
support.

On the kernel side the first part of dynamic linking (replacing the prog or
subprog) is a relativly simple follow up to trampoline patches that build most
of type checking and connecting apis. The second part of dynamic linking is a
bit more work. Every subprog and prog need to be verified independently
otherwise the whole thing won't scale beyond simple programs. I would like to
build a consensus on the long term plan for dynamic and static linking before
implementing the first step.

Back to your question of how fw2 will get loaded.. I'm thinking the following:
1. Static linking:
  obj = bpf_object__open("rootlet.o", "fw1.o", "fw2.o");
  // libbpf adjusts call offsets and links into single loadable bpf_object
  bpf_object__load(obj);
  bpf_set_link_xdp_fd()
No kernel changes are necessary to support program chaining via static linking.

2. Dynamic linking:
  // assuming libxdp.so manages eth0
  rootlet_fd = get_xdp_fd(eth0);
  subprog_btf_id = libbpf_find_prog_btf_id("name_of_placeholder", roolet_fd);
  //                  ^ this function is in patch 16/18 of trampoline
  attr.attach_prog_fd = roolet_fd;
  attr.attach_btf_id = subprog_btf_id;
  // pair (prog_fd, btf_id) needs to be specified at load time
  obj = bpf_object__open("fw2.o", attr);
  bpf_object__load(obj);
  prog = bpf_object__find_program_by_title(obj);
  link = bpf_program__replace(prog); // similar to bpf_program__attach_trace()
  // no extra arguments during 'replace'.
  // Target (prog_fd, btf_id) already known to the kernel and verified

> So the two component programs would still exist as kernel objects,
> right? 

yes. Both fw1.o and fw2.o will be loaded and running instead of placeholders.

> And the trampolines would keep individual stats for each one (if
> BPF stats are enabled)? 

In case of dynamic linking both fw1.o and fw2.o will be seen as individual
programs from 'bpftool p s' point of view. And both will have individual stats.

> Could userspace also extract the prog IDs being
> referenced by the "glue" proglet? 

Not sure I follow. Both fw1.o and fw2.o will have their own prog ids.
fw1_prog->aux->linked_prog == rootlet_prog
fw2_prog->aux->linked_prog == rootlet_prog
Unloading and detaching fw1.o will make kernel to switch back to placeholder
subprog in roolet_prog. I believe roolet_prog should not keep a list of progs
that attached to it (or replaced its subprogs) to avoid circular dependency.
Due to that detaching roolet_prog from netdev will stop the flow of packets
into fw1.o, but refcnt of rootlet_prog will not go to zero, so it will stay in
memory until both fw1.o and fw2.o detach from rootlet.o.

> What about attaching a third program? Would that work by recursion (as
> above, but with the old proglet as old_fd), or should the library build
> a whole new sequence from the component programs?

This choice is up to libxdp.so. It can have a number of placeholders
ready to be replaced by new progs. Or it can re-generate rootlet.o
every time new fwX.o comes along. Short term I would start development
with auto-generated roolet.o and static linking done by libbpf
while the policy and roolet are done by libxdp.so, since this work
doesn't depend on any kernel changes. Long term auto-generation
can stay in libxdp.so if it turns out to be sufficient.

> Finally, what happens if someone where to try to attach a retprobe to
> one of the component programs? Could it be possible to do that even
> while program is being run from proglet dispatch? That way we can still
> debug an individual XDP program even though it's run as part of a chain.

Right. The fentry/fexit tracing is orthogonal to static/dynamic linking.
It will be available for all prog types after trampoline patches land.
See fexit_bpf2bpf.c example in the last 18/18 patch.
We will be able to debug XDP program regardless whether it's a rootlet
or a subprogram. Doesn't matter whether linking was static or dynamic.
With fentry/fexit we will be able to do different stats too.
Right now bpf program stats are limited to cycles and I resisted a lot
of pressure to add more hard coded stats. With fentry/fexit we can
collect arbitrary counters per program. Like number of L1-cache misses
or number of TLB misses in a given XDP prog.

> Sounds reasonable. Any reason libxdp.so couldn't be part of libbpf?

libxdp.so is a policy specifier while libbpf is a tool. It makes more sense for
them to be separate. libbpf has strong api compatibility guarantees. While I
don't think anyone knows at this point how libxdp api should look and it will
take some time for it to mature.

> 
> > If in the future we figure out how to do two load-balancers libxdp.so
> > will be able to accommodate that new policy.
> 
> Yeah, it would be cool if we could move things across CPUs; like with
> cpumap, but executing another XDP program on the target CPU.

You mean like different load balancers for different nic rx queues?
Hmm. I guess that's possible. Another reason to keep libxdp policy
flexible at early stages of development.

