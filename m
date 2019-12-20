Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1C812817B
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 18:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfLTRez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 12:34:55 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41286 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfLTRez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 12:34:55 -0500
Received: by mail-qk1-f196.google.com with SMTP id x129so8260571qke.8;
        Fri, 20 Dec 2019 09:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=swkzUDNb4MgBQJXkk5We2WzNMKJtiTLO3X1/dpBOZMc=;
        b=Xe9roS+87Jx3UgjYRtlr2HlTOGjQPn7Ro+BL+MiiDuRN2TdmSaZrZnKrYHZaW+IXZW
         Cosy6/h9nlEf4bLVhrSYJOnmsqNUo2uZgQlnYRyQB/HIAZYmgj3bY6z4WaqmuNtaokGe
         b2yfyVla8v2rghrp2IAspE7emtAwq6gy0WsHomnwedS5dtEwnOurtrjUtdxRbHIQOMwE
         xboz3/STV1t3R+yPBpnAIBWJF0GDdHXPbJYIBcoQPjf0F3QLzAHzoAQb8k+GH8+cyFR5
         jXq7TnAYJf/YRT2kT3NhnTFl3CXhb1FihcuoRxcOSK1FjmzrR4erWxrYpjAoIi/tRsB9
         KiMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=swkzUDNb4MgBQJXkk5We2WzNMKJtiTLO3X1/dpBOZMc=;
        b=e1NR9zJ4hKlrVpWFZzmxFLapGTG2xvNz3bft7uslzWP16wSfddv1h0Vc6gZhpTuFDd
         bj/XhCMYosva6MremZjYUkRf5cu6duijxBdBTfJeshxxcIFAmn8cUEy1Q3D1gZOAEdgu
         yPFKE2SmK3fh0gWqi8JHhfb8ubyO7ko9e5K+4+H5JlgflqIicnzeo2B70sfi2z4dS6nw
         DHJcKyhCyJYI/wcZVHCGVEM+At9DaaS9CG49eJLNCe3edRmyTyB2KOWnsarpogdWd0r1
         SgzO1WtkDx3tTqVaYtWi9aeDHy49Oq8pfVeXkQkLaqGcDOuUcHJ0kdzvzsE0dryzpk5e
         QdBQ==
X-Gm-Message-State: APjAAAWNIOqsmyHYymyWx7opPncVbs5tfeuX6+5ZCDQWWaidOps6RDcu
        mJ6U+yv4V5WmnsAZcfZuSJv2q2nO6lZ7fLQ2gorhEZKf
X-Google-Smtp-Source: APXvYqznfk567gykb/EDR5ClnHA8i9cAlEyn0cEWNhMdZNBLFWkVEcvf7cZrSjHiMGHOq2Znf2qee4FgllhPziBRm8Q=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr14859305qkq.437.1576863294058;
 Fri, 20 Dec 2019 09:34:54 -0800 (PST)
MIME-Version: 1.0
References: <20191214004737.1652076-1-kafai@fb.com> <20191214004803.1653618-1-kafai@fb.com>
 <CAEf4BzbJoso7A0dn=xhOkFMOcKqZ6wYp=XoqGiL+FO+0VKqh5g@mail.gmail.com>
 <20191218070341.fd2ypexmeca5cefa@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzaGcM6ose=2DJJO1qkRkiqEPR7gU4GizCvffADo5M29wA@mail.gmail.com>
 <20191218173350.nll5766abgkptjac@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzboyRio_KaQtd2eOqmH+x0FPfYp_CDfnUzv4H698j_wsQ@mail.gmail.com>
 <87fthg4rx5.fsf@toke.dk> <CAEf4BzYr+cBH4r7nmX+2uBTOkaxtp2q3ARqm-Gb9ADA9cdqSgQ@mail.gmail.com>
 <87pngj2tf0.fsf@toke.dk>
In-Reply-To: <87pngj2tf0.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Dec 2019 09:34:42 -0800
Message-ID: <CAEf4Bzaa1p9z_N3=fVfba_Ukck6ch4gUhjR7JN8KuN3A7r_0xw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 11/13] bpf: libbpf: Add STRUCT_OPS support
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Martin Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 2:16 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Thu, Dec 19, 2019 at 12:54 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Wed, Dec 18, 2019 at 9:34 AM Martin Lau <kafai@fb.com> wrote:
> >> >>
> >> >> On Wed, Dec 18, 2019 at 08:34:25AM -0800, Andrii Nakryiko wrote:
> >> >> > On Tue, Dec 17, 2019 at 11:03 PM Martin Lau <kafai@fb.com> wrote:
> >> >> > >
> >> >> > > On Tue, Dec 17, 2019 at 07:07:23PM -0800, Andrii Nakryiko wrote=
:
> >> >> > > > On Fri, Dec 13, 2019 at 4:48 PM Martin KaFai Lau <kafai@fb.co=
m> wrote:
> >> >> > > > >
> >> >> > > > > This patch adds BPF STRUCT_OPS support to libbpf.
> >> >> > > > >
> >> >> > > > > The only sec_name convention is SEC("struct_ops") to identi=
fy the
> >> >> > > > > struct ops implemented in BPF, e.g.
> >> >> > > > > SEC("struct_ops")
> >> >> > > > > struct tcp_congestion_ops dctcp =3D {
> >> >> > > > >         .init           =3D (void *)dctcp_init,  /* <-- a b=
pf_prog */
> >> >> > > > >         /* ... some more func prts ... */
> >> >> > > > >         .name           =3D "bpf_dctcp",
> >> >> > > > > };
> >> >> > > > >
> >> >> > > > > In the bpf_object__open phase, libbpf will look for the "st=
ruct_ops"
> >> >> > > > > elf section and find out what is the btf-type the "struct_o=
ps" is
> >> >> > > > > implementing.  Note that the btf-type here is referring to
> >> >> > > > > a type in the bpf_prog.o's btf.  It will then collect (thro=
ugh SHT_REL)
> >> >> > > > > where are the bpf progs that the func ptrs are referring to=
.
> >> >> > > > >
> >> >> > > > > In the bpf_object__load phase, the prepare_struct_ops() wil=
l load
> >> >> > > > > the btf_vmlinux and obtain the corresponding kernel's btf-t=
ype.
> >> >> > > > > With the kernel's btf-type, it can then set the prog->type,
> >> >> > > > > prog->attach_btf_id and the prog->expected_attach_type.  Th=
us,
> >> >> > > > > the prog's properties do not rely on its section name.
> >> >> > > > >
> >> >> > > > > Currently, the bpf_prog's btf-type =3D=3D> btf_vmlinux's bt=
f-type matching
> >> >> > > > > process is as simple as: member-name match + btf-kind match=
 + size match.
> >> >> > > > > If these matching conditions fail, libbpf will reject.
> >> >> > > > > The current targeting support is "struct tcp_congestion_ops=
" which
> >> >> > > > > most of its members are function pointers.
> >> >> > > > > The member ordering of the bpf_prog's btf-type can be diffe=
rent from
> >> >> > > > > the btf_vmlinux's btf-type.
> >> >> > > > >
> >> >> > > > > Once the prog's properties are all set,
> >> >> > > > > the libbpf will proceed to load all the progs.
> >> >> > > > >
> >> >> > > > > After that, register_struct_ops() will create a map, finali=
ze the
> >> >> > > > > map-value by populating it with the prog-fd, and then regis=
ter this
> >> >> > > > > "struct_ops" to the kernel by updating the map-value to the=
 map.
> >> >> > > > >
> >> >> > > > > By default, libbpf does not unregister the struct_ops from =
the kernel
> >> >> > > > > during bpf_object__close().  It can be changed by setting t=
he new
> >> >> > > > > "unreg_st_ops" in bpf_object_open_opts.
> >> >> > > > >
> >> >> > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> >> >> > > > > ---
> >> >> > > >
> >> >> > > > This looks pretty good to me. The big two things is exposing =
structops
> >> >> > > > as real struct bpf_map, so that users can interact with it us=
ing
> >> >> > > > libbpf APIs, as well as splitting struct_ops map creation and
> >> >> > > > registration. bpf_object__load() should only make sure all ma=
ps are
> >> >> > > > created, progs are loaded/verified, but none of BPF program c=
an yet be
> >> >> > > > called. Then attach is the phase where registration happens.
> >> >> > > Thanks for the review.
> >> >> > >
> >> >> > > [ ... ]
> >> >> > >
> >> >> > > > >  static inline __u64 ptr_to_u64(const void *ptr)
> >> >> > > > >  {
> >> >> > > > >         return (__u64) (unsigned long) ptr;
> >> >> > > > > @@ -233,6 +239,32 @@ struct bpf_map {
> >> >> > > > >         bool reused;
> >> >> > > > >  };
> >> >> > > > >
> >> >> > > > > +struct bpf_struct_ops {
> >> >> > > > > +       const char *var_name;
> >> >> > > > > +       const char *tname;
> >> >> > > > > +       const struct btf_type *type;
> >> >> > > > > +       struct bpf_program **progs;
> >> >> > > > > +       __u32 *kern_func_off;
> >> >> > > > > +       /* e.g. struct tcp_congestion_ops in bpf_prog's btf=
 format */
> >> >> > > > > +       void *data;
> >> >> > > > > +       /* e.g. struct __bpf_tcp_congestion_ops in btf_vmli=
nux's btf
> >> >> > > >
> >> >> > > > Using __bpf_ prefix for this struct_ops-specific types is a b=
it too
> >> >> > > > generic (e.g., for raw_tp stuff Alexei used btf_trace_). So m=
aybe make
> >> >> > > > it btf_ops_ or btf_structops_?
> >> >> > > Is it a concern on name collision?
> >> >> > >
> >> >> > > The prefix pick is to use a more representative name.
> >> >> > > struct_ops use many bpf pieces and btf is one of them.
> >> >> > > Very soon, all new codes will depend on BTF and btf_ prefix
> >> >> > > could become generic also.
> >> >> > >
> >> >> > > Unlike tracepoint, there is no non-btf version of struct_ops.
> >> >> >
> >> >> > Not so much name collision, as being able to immediately recogniz=
e
> >> >> > that it's used to provide type information for struct_ops. Think =
about
> >> >> > some automated tooling parsing vmlinux BTF and trying to create s=
ome
> >> >> > derivative types for those btf_trace_xxx and __bpf_xxx types. Hav=
ing
> >> >> > unique prefix that identifies what kind of type-providing struct =
it is
> >> >> > is very useful to do generic tool like that. While __bpf_ isn't
> >> >> > specifying in any ways that it's for struct_ops.
> >> >> >
> >> >> > >
> >> >> > > >
> >> >> > > >
> >> >> > > > > +        * format.
> >> >> > > > > +        * struct __bpf_tcp_congestion_ops {
> >> >> > > > > +        *      [... some other kernel fields ...]
> >> >> > > > > +        *      struct tcp_congestion_ops data;
> >> >> > > > > +        * }
> >> >> > > > > +        * kern_vdata in the sizeof(struct __bpf_tcp_conges=
tion_ops).
> >> >> > > >
> >> >> > > > Comment isn't very clear.. do you mean that data pointed to b=
y
> >> >> > > > kern_vdata is of sizeof(...) bytes?
> >> >> > > >
> >> >> > > > > +        * prepare_struct_ops() will populate the "data" in=
to
> >> >> > > > > +        * "kern_vdata".
> >> >> > > > > +        */
> >> >> > > > > +       void *kern_vdata;
> >> >> > > > > +       __u32 type_id;
> >> >> > > > > +       __u32 kern_vtype_id;
> >> >> > > > > +       __u32 kern_vtype_size;
> >> >> > > > > +       int fd;
> >> >> > > > > +       bool unreg;
> >> >> > > >
> >> >> > > > This unreg flag (and default behavior to not unregister) is b=
othering
> >> >> > > > me a bit.. Shouldn't this be controlled by map's lifetime, at=
 least.
> >> >> > > > E.g., if no one pins that map - then struct_ops should be unr=
egistered
> >> >> > > > on map destruction. If application wants to keep BPF programs
> >> >> > > > attached, it should make sure to pin map, before userspace pa=
rt exits?
> >> >> > > > Is this problematic in any way?
> >> >> > > I don't think it should in the struct_ops case.  I think of the
> >> >> > > struct_ops map is a set of progs "attach" to a subsystem (tcp_c=
ong
> >> >> > > in this case) and this map-progs stay (or keep attaching) until=
 it is
> >> >> > > detached.  Like other attached bpf_prog keeps running without
> >> >> > > caring if the bpf_prog is pinned or not.
> >> >> >
> >> >> > I'll let someone else comment on how this behaves for cgroup, xdp=
,
> >> >> > etc,
> >> >> > but for tracing, for example, we have FD-based BPF links, which
> >> >> > will detach program automatically when FD is closed. I think the =
idea
> >> >> > is to extend this to other types of BPF programs as well, so ther=
e is
> >> >> > no risk of leaving some stray BPF program running after unintende=
d
> >> >> Like xdp_prog, struct_ops does not have another fd-based-link.
> >> >> This link can be created for struct_ops, xdp_prog and others later.
> >> >> I don't see a conflict here.
> >> >
> >> > My point was that default behavior should be conservative: free up
> >> > resources automatically on process exit, unless specifically pinned =
by
> >> > user.
> >> > But this discussion made me realize that we miss one thing from
> >> > general bpf_link framework. See below.
> >> >
> >> >>
> >> >> > crash of userspace program. When application explicitly needs BPF
> >> >> > program to outlive its userspace control app, then this can be
> >> >> > achieved by pinning map/program in BPFFS.
> >> >> If the concern is about not leaving struct_ops behind,
> >> >> lets assume there is no "detach" and only depends on the very
> >> >> last userspace's handles (FD/pinned) of a map goes away,
> >> >> what may be an easy way to remove bpf_cubic from the system:
> >> >
> >> > Yeah, I think this "last map FD close frees up resources/detaches" i=
s
> >> > a good behavior.
> >> >
> >> > Where we do have problem is with bpf_link__destroy() unconditionally
> >> > also detaching whatever was attached (tracepoint, kprobe, or whateve=
r
> >> > was done to create bpf_link in the first place). Now,
> >> > bpf_link__destroy() has to be called by user (or skeleton) to at lea=
st
> >> > free up malloc()'ed structs. But it appears that it's not always
> >> > desirable that upon bpf_link destruction underlying BPF program gets
> >> > detached. I think this will be the case for xdp and others as well.
> >>
> >> For XDP the model has thus far been "once attached, the program stays
> >> until explicitly detached". Changing that would certainly be surprisin=
g,
> >> so I agree that splitting the API is best (not that I'm sure how many
> >> XDP programs will end up using that API, but that's a different
> >> concern)...
> >
> > This would be a new FD-based API for XDP, I don't think we can change
> > existing API. But I think default behavior should still be to
> > auto-detach, unless explicitly "pinned" in whatever way. That would
> > prevent surprising "leakage" of BPF programs for unsuspecting users.
>
> But why do we need a new API for attaching XDP programs? Also, what are
> the use cases where it makes sense to have this kind of "transient" XDP
> program? The only one I can think about is something like xdpdump, which

During development, for instance, when you buggy userspace program
crashes? I think by default all those attached BPF programs should be
auto-detachable, if possible. That's the direction that worked out
really well with kprobes/tracepoints/perf_events. Previously, using
old APIs, you'd attach kprobe and if userspace doesn't clean up, that
kprobe would stay attached in the system, consuming resources without
users noticing this (which is especially critical in production).
Switching to auto-detachable FD-based interface greatly improved that
experience. I think this is a good model going forward.

In practice, for production use cases, it will be just a trivial piece
of code to keep it attached:

struct bpf_link *xdp_link =3D bpf_program__attach_xdp(...);
bpf_link__disconnect(xdp_link); /* now if userspace program crashes,
xdp BPF program will stay connected */

> moves packets to userspace (and should stop doing that when the
> userspace listener goes away). But with bpf-to-bpf tracing, xdpdump
> won't actually be an XDP program, so what's left? The system firewall
> rules don't go away when the program that installed them exits either;
> why should an XDP program?

See above, I'm not saying that it shouldn't be possible to keep it
attached. I'm just arguing it's not a good default, because it can
catch developers off guard and cause problems, especially in
production environments. In the end, it is a resource leak, unless you
want and expect it.

>
> -Toke
>
