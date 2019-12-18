Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89A9C125068
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfLRSOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:14:21 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:38543 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbfLRSOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:14:21 -0500
Received: by mail-qv1-f66.google.com with SMTP id t6so1126912qvs.5;
        Wed, 18 Dec 2019 10:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RH10Qe8cx0EuLc20y+XtctT6T3Rl5//EZ8OPK1uxpAU=;
        b=p3LlgiYolCT6Huks2XJJm3qPFBKj2RCmyr9cdUJgXvkbTEC10QUbqdMaYmR+488yc/
         UKHZtITLLs7en6LvWJ3sHsLQWyHgHTSHlnOXLOj8FQGtOu77mPFGfDyu0M3oKGJ/VVoK
         ihDhJdMqO8LxOcSoUWbOfuvJDjAvshFojt4dlBuVPbvPLCWt5JZ4iggLcj4m796+m7g5
         Jc2lTELu6NEYFqBoy7GIRS2CCBMsTnm5xeqs0i3lVORQWcjvnLdoM5NS1j1eVH79giOe
         PAJxGYMKzdL9Tr6fl1i8a9aE06UDJgI2mVexvgQky+IJKiLSdGKtyagHkCch7AVuTL+B
         cN+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RH10Qe8cx0EuLc20y+XtctT6T3Rl5//EZ8OPK1uxpAU=;
        b=LJ54ImbGlkr9qRqY0gg5EYld14s43R1IbMIpnM4mYwNA6uZOP4qwuVSnw76MEjbZQU
         SmxicrMo7gXXJj9sUAQKtAAlmMJxIMi2i5E9Lm+xptAhpRIsNlFIyWTeSxO5BsxGyn9X
         JxZlq4VaVIhXqRSfrvkKUi+CMT25IASOChiQ9idwivOKgQ/2Wv5sZsblmnpAuzWZRXqj
         MvSFPLWStAuZaXHhn016/iWme7xg3n5GjT00HrGMMLj2e1cl7GSyacWhPdz0O/QzGn78
         2A1Wi6i6iPmSUB7DL4E2EpXP8ywQvif07n3RCh7X12+eqkvEsyf8J7b7RlsruO9oDyJj
         QPuQ==
X-Gm-Message-State: APjAAAU2CuUO45CABNhzpFgxj2lYsw2VBi6QvU4Mrlow1c+wBXOREAGc
        grCks+c18PlJSIF83Ld1wmvOCNRnvshdB709MwIjrg==
X-Google-Smtp-Source: APXvYqxExV/Rido71uGSb/Pk+c2clEJ0EAxiiyeW3CnJ6OUorZHyf+t0hZASb6cuOWs3ALGmZNCWo6MbtKRKjuMez4A=
X-Received: by 2002:ad4:4e34:: with SMTP id dm20mr3669526qvb.163.1576692859783;
 Wed, 18 Dec 2019 10:14:19 -0800 (PST)
MIME-Version: 1.0
References: <20191214004737.1652076-1-kafai@fb.com> <20191214004803.1653618-1-kafai@fb.com>
 <CAEf4BzbJoso7A0dn=xhOkFMOcKqZ6wYp=XoqGiL+FO+0VKqh5g@mail.gmail.com>
 <20191218070341.fd2ypexmeca5cefa@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzaGcM6ose=2DJJO1qkRkiqEPR7gU4GizCvffADo5M29wA@mail.gmail.com> <20191218173350.nll5766abgkptjac@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191218173350.nll5766abgkptjac@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Dec 2019 10:14:04 -0800
Message-ID: <CAEf4BzboyRio_KaQtd2eOqmH+x0FPfYp_CDfnUzv4H698j_wsQ@mail.gmail.com>
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

On Wed, Dec 18, 2019 at 9:34 AM Martin Lau <kafai@fb.com> wrote:
>
> On Wed, Dec 18, 2019 at 08:34:25AM -0800, Andrii Nakryiko wrote:
> > On Tue, Dec 17, 2019 at 11:03 PM Martin Lau <kafai@fb.com> wrote:
> > >
> > > On Tue, Dec 17, 2019 at 07:07:23PM -0800, Andrii Nakryiko wrote:
> > > > On Fri, Dec 13, 2019 at 4:48 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > This patch adds BPF STRUCT_OPS support to libbpf.
> > > > >
> > > > > The only sec_name convention is SEC("struct_ops") to identify the
> > > > > struct ops implemented in BPF, e.g.
> > > > > SEC("struct_ops")
> > > > > struct tcp_congestion_ops dctcp = {
> > > > >         .init           = (void *)dctcp_init,  /* <-- a bpf_prog */
> > > > >         /* ... some more func prts ... */
> > > > >         .name           = "bpf_dctcp",
> > > > > };
> > > > >
> > > > > In the bpf_object__open phase, libbpf will look for the "struct_ops"
> > > > > elf section and find out what is the btf-type the "struct_ops" is
> > > > > implementing.  Note that the btf-type here is referring to
> > > > > a type in the bpf_prog.o's btf.  It will then collect (through SHT_REL)
> > > > > where are the bpf progs that the func ptrs are referring to.
> > > > >
> > > > > In the bpf_object__load phase, the prepare_struct_ops() will load
> > > > > the btf_vmlinux and obtain the corresponding kernel's btf-type.
> > > > > With the kernel's btf-type, it can then set the prog->type,
> > > > > prog->attach_btf_id and the prog->expected_attach_type.  Thus,
> > > > > the prog's properties do not rely on its section name.
> > > > >
> > > > > Currently, the bpf_prog's btf-type ==> btf_vmlinux's btf-type matching
> > > > > process is as simple as: member-name match + btf-kind match + size match.
> > > > > If these matching conditions fail, libbpf will reject.
> > > > > The current targeting support is "struct tcp_congestion_ops" which
> > > > > most of its members are function pointers.
> > > > > The member ordering of the bpf_prog's btf-type can be different from
> > > > > the btf_vmlinux's btf-type.
> > > > >
> > > > > Once the prog's properties are all set,
> > > > > the libbpf will proceed to load all the progs.
> > > > >
> > > > > After that, register_struct_ops() will create a map, finalize the
> > > > > map-value by populating it with the prog-fd, and then register this
> > > > > "struct_ops" to the kernel by updating the map-value to the map.
> > > > >
> > > > > By default, libbpf does not unregister the struct_ops from the kernel
> > > > > during bpf_object__close().  It can be changed by setting the new
> > > > > "unreg_st_ops" in bpf_object_open_opts.
> > > > >
> > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > ---
> > > >
> > > > This looks pretty good to me. The big two things is exposing structops
> > > > as real struct bpf_map, so that users can interact with it using
> > > > libbpf APIs, as well as splitting struct_ops map creation and
> > > > registration. bpf_object__load() should only make sure all maps are
> > > > created, progs are loaded/verified, but none of BPF program can yet be
> > > > called. Then attach is the phase where registration happens.
> > > Thanks for the review.
> > >
> > > [ ... ]
> > >
> > > > >  static inline __u64 ptr_to_u64(const void *ptr)
> > > > >  {
> > > > >         return (__u64) (unsigned long) ptr;
> > > > > @@ -233,6 +239,32 @@ struct bpf_map {
> > > > >         bool reused;
> > > > >  };
> > > > >
> > > > > +struct bpf_struct_ops {
> > > > > +       const char *var_name;
> > > > > +       const char *tname;
> > > > > +       const struct btf_type *type;
> > > > > +       struct bpf_program **progs;
> > > > > +       __u32 *kern_func_off;
> > > > > +       /* e.g. struct tcp_congestion_ops in bpf_prog's btf format */
> > > > > +       void *data;
> > > > > +       /* e.g. struct __bpf_tcp_congestion_ops in btf_vmlinux's btf
> > > >
> > > > Using __bpf_ prefix for this struct_ops-specific types is a bit too
> > > > generic (e.g., for raw_tp stuff Alexei used btf_trace_). So maybe make
> > > > it btf_ops_ or btf_structops_?
> > > Is it a concern on name collision?
> > >
> > > The prefix pick is to use a more representative name.
> > > struct_ops use many bpf pieces and btf is one of them.
> > > Very soon, all new codes will depend on BTF and btf_ prefix
> > > could become generic also.
> > >
> > > Unlike tracepoint, there is no non-btf version of struct_ops.
> >
> > Not so much name collision, as being able to immediately recognize
> > that it's used to provide type information for struct_ops. Think about
> > some automated tooling parsing vmlinux BTF and trying to create some
> > derivative types for those btf_trace_xxx and __bpf_xxx types. Having
> > unique prefix that identifies what kind of type-providing struct it is
> > is very useful to do generic tool like that. While __bpf_ isn't
> > specifying in any ways that it's for struct_ops.
> >
> > >
> > > >
> > > >
> > > > > +        * format.
> > > > > +        * struct __bpf_tcp_congestion_ops {
> > > > > +        *      [... some other kernel fields ...]
> > > > > +        *      struct tcp_congestion_ops data;
> > > > > +        * }
> > > > > +        * kern_vdata in the sizeof(struct __bpf_tcp_congestion_ops).
> > > >
> > > > Comment isn't very clear.. do you mean that data pointed to by
> > > > kern_vdata is of sizeof(...) bytes?
> > > >
> > > > > +        * prepare_struct_ops() will populate the "data" into
> > > > > +        * "kern_vdata".
> > > > > +        */
> > > > > +       void *kern_vdata;
> > > > > +       __u32 type_id;
> > > > > +       __u32 kern_vtype_id;
> > > > > +       __u32 kern_vtype_size;
> > > > > +       int fd;
> > > > > +       bool unreg;
> > > >
> > > > This unreg flag (and default behavior to not unregister) is bothering
> > > > me a bit.. Shouldn't this be controlled by map's lifetime, at least.
> > > > E.g., if no one pins that map - then struct_ops should be unregistered
> > > > on map destruction. If application wants to keep BPF programs
> > > > attached, it should make sure to pin map, before userspace part exits?
> > > > Is this problematic in any way?
> > > I don't think it should in the struct_ops case.  I think of the
> > > struct_ops map is a set of progs "attach" to a subsystem (tcp_cong
> > > in this case) and this map-progs stay (or keep attaching) until it is
> > > detached.  Like other attached bpf_prog keeps running without
> > > caring if the bpf_prog is pinned or not.
> >
> > I'll let someone else comment on how this behaves for cgroup, xdp,
> > etc,
> > but for tracing, for example, we have FD-based BPF links, which
> > will detach program automatically when FD is closed. I think the idea
> > is to extend this to other types of BPF programs as well, so there is
> > no risk of leaving some stray BPF program running after unintended
> Like xdp_prog, struct_ops does not have another fd-based-link.
> This link can be created for struct_ops, xdp_prog and others later.
> I don't see a conflict here.

My point was that default behavior should be conservative: free up
resources automatically on process exit, unless specifically pinned by
user.
But this discussion made me realize that we miss one thing from
general bpf_link framework. See below.

>
> > crash of userspace program. When application explicitly needs BPF
> > program to outlive its userspace control app, then this can be
> > achieved by pinning map/program in BPFFS.
> If the concern is about not leaving struct_ops behind,
> lets assume there is no "detach" and only depends on the very
> last userspace's handles (FD/pinned) of a map goes away,
> what may be an easy way to remove bpf_cubic from the system:

Yeah, I think this "last map FD close frees up resources/detaches" is
a good behavior.

Where we do have problem is with bpf_link__destroy() unconditionally
also detaching whatever was attached (tracepoint, kprobe, or whatever
was done to create bpf_link in the first place). Now,
bpf_link__destroy() has to be called by user (or skeleton) to at least
free up malloc()'ed structs. But it appears that it's not always
desirable that upon bpf_link destruction underlying BPF program gets
detached. I think this will be the case for xdp and others as well.

I think the good and generic way to go about this is to have this as a
general concept of destroying the link without detaching BPF programs.
E.g., what if we have new API call `void bpf_link__unlink()`, which
will mark that link as not requiring to detach underlying BPF program.
When bpf_link__destroy() is called later, it will just free resources
allocated to maintain bpf_link itself, but won't detach any BPF
programs/resources.

With this, user will have to explicitly specify that he doesn't want
to detach even when skeleton/link is destroyed. If we get consensus on
this, I can add support for this to all the existing bpf_links and you
can build on that?

>
> [root@arch-fb-vm1 bpf]# sysctl -a | egrep congestion
>     net.ipv4.tcp_allowed_congestion_control = reno cubic bpf_cubic
>     net.ipv4.tcp_available_congestion_control = reno bic cubic bpf_cubic
>     net.ipv4.tcp_congestion_control = bpf_cubic
>
> >
> > >
> > > About the "bool unreg;", the default can be changed to true if
> > > it makes more sense.
> > >
