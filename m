Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42B11124DC0
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfLRQei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:34:38 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44945 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbfLRQei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:34:38 -0500
Received: by mail-qt1-f196.google.com with SMTP id t3so2399372qtr.11;
        Wed, 18 Dec 2019 08:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l9xhPvFpH1pf8qO1T8YyWvCq9UcDgp2KkxolUQXGYUY=;
        b=IzBTWeZtO5WXUOTxk+yL772mUulNWiJphSqbYZ5qP4iu7OL09WVChgOepoOVj7cqTt
         O39H+0kz9j1cpmhU4GIwb2bCDcV2LUlEKcvM3PBjB4yzJgW8/WhF5yqNnuFSdfJKSN6d
         B6wkGj3VeVH4LAqnHLQ4m5B+Cnh7e5LIt7T9s1KLkmodjMOFcIYdESYsmkKhJLGX6dls
         TAOZlcqlO46rIt3JkS8FaCwuZ45I2lCY96NP23qcRI9bw9BZmnXieFSfzKpA/V/p4jvw
         TXxt84HtzYs6Q52UXkPjJ2wtBKIsZAmwx6sNDhvCv3vXeZNs6Q2YHfZh0Xm99pe/AuuJ
         wp+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l9xhPvFpH1pf8qO1T8YyWvCq9UcDgp2KkxolUQXGYUY=;
        b=lWPozP5stzuyOYQY8vLB8XsjAc9vbYHe+/jPizY5eNHNBeNGqZ5E7qTwdtTiqvKQXr
         AhmTGJJ21KunfCAgI3tqBBVwxujipsPoAmKcdHt5t4sZxo3oKUVKv9+vyb4KQrS3QYMX
         4IR41T3AgDgYelzrF+DOT+rep4ly2QvQ+6D6LmfNpMj8PJZ2V6Q5Evq3BP1H/lJLfF2z
         eE0DViqG7HENV9JyxZzReryqBmeYJ++UcBaT5VscnYNlhBq2DAq8xKpjqUesMiRkFZ6c
         kWtxwAGR4QLXzdzPLwJPlNHHlfOcR49b9HG1LapyFBoqMDNniiQka52cEvubeeoX/uXR
         zyDA==
X-Gm-Message-State: APjAAAWswdY1WNj3UyFnVYYo0laDz/5c6e9cDWKbhnfACrsN1f3mkj2S
        cClDMO7lK8vJsK+EPoM65vyIAQi7cWSXAf/GOIc=
X-Google-Smtp-Source: APXvYqwbkYcu/xr5MhOhvIfh0FVkgVZS+57HgcqM7WdjejvLkqomAl7y1IoytCPnIn7eCKeKqlYRj4eaMqGAm1CY4+Y=
X-Received: by 2002:ac8:5457:: with SMTP id d23mr2848735qtq.93.1576686876966;
 Wed, 18 Dec 2019 08:34:36 -0800 (PST)
MIME-Version: 1.0
References: <20191214004737.1652076-1-kafai@fb.com> <20191214004803.1653618-1-kafai@fb.com>
 <CAEf4BzbJoso7A0dn=xhOkFMOcKqZ6wYp=XoqGiL+FO+0VKqh5g@mail.gmail.com> <20191218070341.fd2ypexmeca5cefa@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191218070341.fd2ypexmeca5cefa@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Dec 2019 08:34:25 -0800
Message-ID: <CAEf4BzaGcM6ose=2DJJO1qkRkiqEPR7gU4GizCvffADo5M29wA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 11/13] bpf: libbpf: Add STRUCT_OPS support
To:     Martin Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 11:03 PM Martin Lau <kafai@fb.com> wrote:
>
> On Tue, Dec 17, 2019 at 07:07:23PM -0800, Andrii Nakryiko wrote:
> > On Fri, Dec 13, 2019 at 4:48 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This patch adds BPF STRUCT_OPS support to libbpf.
> > >
> > > The only sec_name convention is SEC("struct_ops") to identify the
> > > struct ops implemented in BPF, e.g.
> > > SEC("struct_ops")
> > > struct tcp_congestion_ops dctcp = {
> > >         .init           = (void *)dctcp_init,  /* <-- a bpf_prog */
> > >         /* ... some more func prts ... */
> > >         .name           = "bpf_dctcp",
> > > };
> > >
> > > In the bpf_object__open phase, libbpf will look for the "struct_ops"
> > > elf section and find out what is the btf-type the "struct_ops" is
> > > implementing.  Note that the btf-type here is referring to
> > > a type in the bpf_prog.o's btf.  It will then collect (through SHT_REL)
> > > where are the bpf progs that the func ptrs are referring to.
> > >
> > > In the bpf_object__load phase, the prepare_struct_ops() will load
> > > the btf_vmlinux and obtain the corresponding kernel's btf-type.
> > > With the kernel's btf-type, it can then set the prog->type,
> > > prog->attach_btf_id and the prog->expected_attach_type.  Thus,
> > > the prog's properties do not rely on its section name.
> > >
> > > Currently, the bpf_prog's btf-type ==> btf_vmlinux's btf-type matching
> > > process is as simple as: member-name match + btf-kind match + size match.
> > > If these matching conditions fail, libbpf will reject.
> > > The current targeting support is "struct tcp_congestion_ops" which
> > > most of its members are function pointers.
> > > The member ordering of the bpf_prog's btf-type can be different from
> > > the btf_vmlinux's btf-type.
> > >
> > > Once the prog's properties are all set,
> > > the libbpf will proceed to load all the progs.
> > >
> > > After that, register_struct_ops() will create a map, finalize the
> > > map-value by populating it with the prog-fd, and then register this
> > > "struct_ops" to the kernel by updating the map-value to the map.
> > >
> > > By default, libbpf does not unregister the struct_ops from the kernel
> > > during bpf_object__close().  It can be changed by setting the new
> > > "unreg_st_ops" in bpf_object_open_opts.
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> >
> > This looks pretty good to me. The big two things is exposing structops
> > as real struct bpf_map, so that users can interact with it using
> > libbpf APIs, as well as splitting struct_ops map creation and
> > registration. bpf_object__load() should only make sure all maps are
> > created, progs are loaded/verified, but none of BPF program can yet be
> > called. Then attach is the phase where registration happens.
> Thanks for the review.
>
> [ ... ]
>
> > >  static inline __u64 ptr_to_u64(const void *ptr)
> > >  {
> > >         return (__u64) (unsigned long) ptr;
> > > @@ -233,6 +239,32 @@ struct bpf_map {
> > >         bool reused;
> > >  };
> > >
> > > +struct bpf_struct_ops {
> > > +       const char *var_name;
> > > +       const char *tname;
> > > +       const struct btf_type *type;
> > > +       struct bpf_program **progs;
> > > +       __u32 *kern_func_off;
> > > +       /* e.g. struct tcp_congestion_ops in bpf_prog's btf format */
> > > +       void *data;
> > > +       /* e.g. struct __bpf_tcp_congestion_ops in btf_vmlinux's btf
> >
> > Using __bpf_ prefix for this struct_ops-specific types is a bit too
> > generic (e.g., for raw_tp stuff Alexei used btf_trace_). So maybe make
> > it btf_ops_ or btf_structops_?
> Is it a concern on name collision?
>
> The prefix pick is to use a more representative name.
> struct_ops use many bpf pieces and btf is one of them.
> Very soon, all new codes will depend on BTF and btf_ prefix
> could become generic also.
>
> Unlike tracepoint, there is no non-btf version of struct_ops.

Not so much name collision, as being able to immediately recognize
that it's used to provide type information for struct_ops. Think about
some automated tooling parsing vmlinux BTF and trying to create some
derivative types for those btf_trace_xxx and __bpf_xxx types. Having
unique prefix that identifies what kind of type-providing struct it is
is very useful to do generic tool like that. While __bpf_ isn't
specifying in any ways that it's for struct_ops.

>
> >
> >
> > > +        * format.
> > > +        * struct __bpf_tcp_congestion_ops {
> > > +        *      [... some other kernel fields ...]
> > > +        *      struct tcp_congestion_ops data;
> > > +        * }
> > > +        * kern_vdata in the sizeof(struct __bpf_tcp_congestion_ops).
> >
> > Comment isn't very clear.. do you mean that data pointed to by
> > kern_vdata is of sizeof(...) bytes?
> >
> > > +        * prepare_struct_ops() will populate the "data" into
> > > +        * "kern_vdata".
> > > +        */
> > > +       void *kern_vdata;
> > > +       __u32 type_id;
> > > +       __u32 kern_vtype_id;
> > > +       __u32 kern_vtype_size;
> > > +       int fd;
> > > +       bool unreg;
> >
> > This unreg flag (and default behavior to not unregister) is bothering
> > me a bit.. Shouldn't this be controlled by map's lifetime, at least.
> > E.g., if no one pins that map - then struct_ops should be unregistered
> > on map destruction. If application wants to keep BPF programs
> > attached, it should make sure to pin map, before userspace part exits?
> > Is this problematic in any way?
> I don't think it should in the struct_ops case.  I think of the
> struct_ops map is a set of progs "attach" to a subsystem (tcp_cong
> in this case) and this map-progs stay (or keep attaching) until it is
> detached.  Like other attached bpf_prog keeps running without
> caring if the bpf_prog is pinned or not.

I'll let someone else comment on how this behaves for cgroup, xdp,
etc, but for tracing, for example, we have FD-based BPF links, which
will detach program automatically when FD is closed. I think the idea
is to extend this to other types of BPF programs as well, so there is
no risk of leaving some stray BPF program running after unintended
crash of userspace program. When application explicitly needs BPF
program to outlive its userspace control app, then this can be
achieved by pinning map/program in BPFFS.

>
> About the "bool unreg;", the default can be changed to true if
> it makes more sense.
>
> [ ... ]
>
> >
> > > +
> > > +               kern_data = st_ops->kern_vdata + st_ops->kern_func_off[i];
> > > +               *(unsigned long *)kern_data = prog_fd;
> > > +       }
> > > +
> > > +       map_attr.map_type = BPF_MAP_TYPE_STRUCT_OPS;
> > > +       map_attr.key_size = sizeof(unsigned int);
> > > +       map_attr.value_size = st_ops->kern_vtype_size;
> > > +       map_attr.max_entries = 1;
> > > +       map_attr.btf_fd = btf__fd(obj->btf);
> > > +       map_attr.btf_vmlinux_value_type_id = st_ops->kern_vtype_id;
> > > +       map_attr.name = st_ops->var_name;
> > > +
> > > +       fd = bpf_create_map_xattr(&map_attr);
> >
> > we should try to reuse bpf_object__init_internal_map(). This will add
> > struct bpf_map which users can iterate over and look up by name, etc.
> > We had similar discussion when Daniel was adding  global data maps,
> > and we conclusively decided that these special maps have to be
> > represented in libbpf as struct bpf_map as well.
> I will take a look.
>
> >
> > > +       if (fd < 0) {
> > > +               err = -errno;
> > > +               pr_warn("struct_ops register %s: Error in creating struct_ops map\n",
> > > +                       tname);
> > > +               return err;
> > > +       }
> > > +
> > > +       err = bpf_map_update_elem(fd, &zero, st_ops->kern_vdata, 0);
