Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 544F5124DE3
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfLRQgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:36:20 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44939 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbfLRQgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:36:20 -0500
Received: by mail-qk1-f195.google.com with SMTP id w127so2047243qkb.11;
        Wed, 18 Dec 2019 08:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qUcUkvy5OdyVHj2kjzgSdDC0YHQpFgzhn2oBvlTV6n0=;
        b=Llohs8t77HlYXAlNRqd3omwoiN05ZRedjkdrH5HAqB2nd4iEegOSiBCSgXYX3Sc3GA
         tdq2o0hoIoZAhmKEUThM6/ZeqzeAOQaCE/Qluls4Xy207JUz1FyfsfrB9Z1vlWEOVkFM
         Itf/FD2HoJb9fz0kpBTOYauoJBgfMUc1HDd3TtC5+gzw+Bbfo3eGS0s2wKoWv0aKXp03
         ahY4YFm02lMjxmrVBW/pVo+lTd+I6OSM0sVlY6J5XnifNnhcQCP9HxzEOaXgUf9Vg3k9
         uhWBGt1R9exvXzPHwd4noLTb3nx0l/yZ/GyKvqjmzc/9kWC6e7YxbqxoXTS61R4+ffMG
         8WMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qUcUkvy5OdyVHj2kjzgSdDC0YHQpFgzhn2oBvlTV6n0=;
        b=mGP+eKuhXXPDI6pR3YgY1sP2r/h75z1DVaJ5sw0c0DitMUEuXKGZ055WcaBw4dCqK8
         vzkjLhnLrOJXiMu19ilHAFa+1VkWjnR130pl2mZ+Kt7RkXkc3j8+Bve6cax1qOpkhkxg
         v7W4MnaY/xXnawlK/+sZ4zETl1hxuf3tDEGV2qhznk8ty7MHGCWAcQgZjBJJjZT99X3I
         bV04Ibykp0/f0bMFsAF3Di0tyo+MPHAhm7Lgj3Cx2ma9kB3aRfRkizu64yUVbVttcx8z
         cgxuXGJRp4CqN23VIhujz29j/6QgKGYLMhj/IpctJ8Bv7d7xNuHK6NxNXQRJNH/Xfzby
         iK1w==
X-Gm-Message-State: APjAAAXzGNVitL4oGcrLhWj05MlH+iyw2RTstEfHv+W2z+ua+eCPPOQw
        Qr63PfKyioQh3PAfm1V2EKT/pphYEiA29v+ZKJS9DQ==
X-Google-Smtp-Source: APXvYqzqs3iHMOgJZF8qEvBRSe8UYAcgozGml5xLSHWUZRQWgdjpwYd+7e61Gv5dzGDQftWWLWxcXp2GlhGqIPNxxyM=
X-Received: by 2002:a05:620a:14a2:: with SMTP id x2mr3543596qkj.36.1576686978958;
 Wed, 18 Dec 2019 08:36:18 -0800 (PST)
MIME-Version: 1.0
References: <20191214004737.1652076-1-kafai@fb.com> <20191214004803.1653618-1-kafai@fb.com>
 <CAEf4BzbJoso7A0dn=xhOkFMOcKqZ6wYp=XoqGiL+FO+0VKqh5g@mail.gmail.com>
 <20191218070341.fd2ypexmeca5cefa@kafai-mbp.dhcp.thefacebook.com> <20191218072003.yxilrs4mniy6zgrb@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191218072003.yxilrs4mniy6zgrb@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Dec 2019 08:36:08 -0800
Message-ID: <CAEf4BzZqUQRsGJPx7OGm6_YPBZbK=PVpjOqSK3pF7EMsxuz-Mw@mail.gmail.com>
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

On Tue, Dec 17, 2019 at 11:20 PM Martin Lau <kafai@fb.com> wrote:
>
> On Tue, Dec 17, 2019 at 11:03:45PM -0800, Martin Lau wrote:
> > On Tue, Dec 17, 2019 at 07:07:23PM -0800, Andrii Nakryiko wrote:
> > > On Fri, Dec 13, 2019 at 4:48 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > This patch adds BPF STRUCT_OPS support to libbpf.
> > > >
> > > > The only sec_name convention is SEC("struct_ops") to identify the
> > > > struct ops implemented in BPF, e.g.
> > > > SEC("struct_ops")
> > > > struct tcp_congestion_ops dctcp = {
> > > >         .init           = (void *)dctcp_init,  /* <-- a bpf_prog */
> > > >         /* ... some more func prts ... */
> > > >         .name           = "bpf_dctcp",
> > > > };
> > > >
> > > > In the bpf_object__open phase, libbpf will look for the "struct_ops"
> > > > elf section and find out what is the btf-type the "struct_ops" is
> > > > implementing.  Note that the btf-type here is referring to
> > > > a type in the bpf_prog.o's btf.  It will then collect (through SHT_REL)
> > > > where are the bpf progs that the func ptrs are referring to.
> > > >
> > > > In the bpf_object__load phase, the prepare_struct_ops() will load
> > > > the btf_vmlinux and obtain the corresponding kernel's btf-type.
> > > > With the kernel's btf-type, it can then set the prog->type,
> > > > prog->attach_btf_id and the prog->expected_attach_type.  Thus,
> > > > the prog's properties do not rely on its section name.
> > > >
> > > > Currently, the bpf_prog's btf-type ==> btf_vmlinux's btf-type matching
> > > > process is as simple as: member-name match + btf-kind match + size match.
> > > > If these matching conditions fail, libbpf will reject.
> > > > The current targeting support is "struct tcp_congestion_ops" which
> > > > most of its members are function pointers.
> > > > The member ordering of the bpf_prog's btf-type can be different from
> > > > the btf_vmlinux's btf-type.
> > > >
> > > > Once the prog's properties are all set,
> > > > the libbpf will proceed to load all the progs.
> > > >
> > > > After that, register_struct_ops() will create a map, finalize the
> > > > map-value by populating it with the prog-fd, and then register this
> > > > "struct_ops" to the kernel by updating the map-value to the map.
> > > >
> > > > By default, libbpf does not unregister the struct_ops from the kernel
> > > > during bpf_object__close().  It can be changed by setting the new
> > > > "unreg_st_ops" in bpf_object_open_opts.
> > > >
> > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > ---
> > >
> > > This looks pretty good to me. The big two things is exposing structops
> > > as real struct bpf_map, so that users can interact with it using
> > > libbpf APIs, as well as splitting struct_ops map creation and
> > > registration. bpf_object__load() should only make sure all maps are
> > > created, progs are loaded/verified, but none of BPF program can yet be
> > > called. Then attach is the phase where registration happens.
> > Thanks for the review.
> >
> > [ ... ]
> >
> > > >  static inline __u64 ptr_to_u64(const void *ptr)
> > > >  {
> > > >         return (__u64) (unsigned long) ptr;
> > > > @@ -233,6 +239,32 @@ struct bpf_map {
> > > >         bool reused;
> > > >  };
> > > >
> > > > +struct bpf_struct_ops {
> > > > +       const char *var_name;
> > > > +       const char *tname;
> > > > +       const struct btf_type *type;
> > > > +       struct bpf_program **progs;
> > > > +       __u32 *kern_func_off;
> > > > +       /* e.g. struct tcp_congestion_ops in bpf_prog's btf format */
> > > > +       void *data;
> > > > +       /* e.g. struct __bpf_tcp_congestion_ops in btf_vmlinux's btf
> > >
> > > Using __bpf_ prefix for this struct_ops-specific types is a bit too
> > > generic (e.g., for raw_tp stuff Alexei used btf_trace_). So maybe make
> > > it btf_ops_ or btf_structops_?
> > Is it a concern on name collision?
> >
> > The prefix pick is to use a more representative name.
> > struct_ops use many bpf pieces and btf is one of them.
> > Very soon, all new codes will depend on BTF and btf_ prefix
> > could become generic also.
> >
> > Unlike tracepoint, there is no non-btf version of struct_ops.
> May be bpf_struct_ops_?
>
> It was my early pick but it read quite weird,
> bpf_[struct]_<ops>_[tcp_congestion]_<ops>.
>
> Hence, I go with __bpf_<actual-name-of-the-kernel-struct> in this series.

bpf_struct_ops_ is much better, IMO, but given this struct serves only
the purpose of providing type information to kernel, I think
btf_struct_ops_ is more justified.
And this <ops>_xxx_<ops> duplication doesn't bother me at all, again,
because it's not directly used in C code. But believe me, having
unique prefix is so good, even in the simples case of grepping through
vmlinux.h.
