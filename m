Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B232B176D
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 09:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgKMIjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 03:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgKMIjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 03:39:53 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206A8C0613D1;
        Fri, 13 Nov 2020 00:39:53 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id u2so4231218pls.10;
        Fri, 13 Nov 2020 00:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rKiYlh6ITmwqNaDLO6LyOP0kIZ/gu8XpkF1XgCPmV4U=;
        b=r66mTNttIJkymy7LtqJivJwBRlKNI5EonvaG+MXo+0hzM+YlO1ZkZnjDPSmHrTnZf8
         /9TPNl80hRj8e0dcAu30zIbnGg9Kdkpuadq/fN2rLsyL9oZ5O+TMwYliEg/X+IeJifcu
         uJZ7bwfSh7TReM12kdBUjjSxURLr9j/cV48cv1F84F429EizLDituCRz0lBDu82l89ZB
         ZLoCMWkQ2Odd1pU4n4SPTbS97nvpxyR6EmU1G+5sLkiqU5ObR5jnQgz/ga3ZrsCAdMS1
         b2qJcgzt3oUSebnzAX5qVE5/hNy9aPtURRyh1HpygeDaN2PBFfW4P2hl2JZt4/4ORyuS
         jXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rKiYlh6ITmwqNaDLO6LyOP0kIZ/gu8XpkF1XgCPmV4U=;
        b=o1uCIZSiI8GH7BxzgU9T37KaepJNm9lidUiN5S8m1e8LOHieXjzex5VkU6juTdgxKq
         dcJJR5vRC7ThqDeQs749etMe84sRnwoXiUlCQj3JvypqJhBhGfEHdUPWN4fMK8i2MJhI
         6Q1VlcKFt1zzFyNfNec2Rkrm2qZKz04faPwf2OkkWHytvilmemz9F1ZFs11C9wXwFeQF
         kDcsnilc4MGG0n68bYwgzPCSzreuCwrJtOas+uvZ0JYqPg14/pi8Z5/lBZOzTRW7784t
         HOZEsdslbu3yODqvRw1G6WDdQ1Twnwbtpisk+1ORxu7bBFJAepZZc/9eCKLP7tfnGphd
         DamQ==
X-Gm-Message-State: AOAM531WHGN8d7j6Wah7dcp8ZXfww9Acugl8p4Q9pGgern8eEYVgs1lE
        +/GHcqmrV9UFIc1gIkC13F0UQnHzqsrkQiByQuU=
X-Google-Smtp-Source: ABdhPJx3dg0bPKqtMW16uUQLbo1lfLC4EvAOzwQIrJcqJw8BSgtLS3Uq84ifS401jfvT8o/kc57108nyUQYa1gRUpNE=
X-Received: by 2002:a17:902:9a46:b029:d6:f20a:83e1 with SMTP id
 x6-20020a1709029a46b02900d6f20a83e1mr1102335plv.49.1605256792536; Fri, 13 Nov
 2020 00:39:52 -0800 (PST)
MIME-Version: 1.0
References: <20201112085854.3764-1-mariuszx.dudek@intel.com>
 <20201112085854.3764-2-mariuszx.dudek@intel.com> <CAEf4Bzam8O=tUM-YZ=XHbJPVohYW9SfQL+ynNd5MnFF3mNREhw@mail.gmail.com>
In-Reply-To: <CAEf4Bzam8O=tUM-YZ=XHbJPVohYW9SfQL+ynNd5MnFF3mNREhw@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 13 Nov 2020 09:39:41 +0100
Message-ID: <CAJ8uoz1TvGCo0qPi=+B-EOfSzV8DwZCzZ_7LUYAeW+yz16WXjQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/2] libbpf: separate XDP program load with
 xsk socket creation
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Mariusz Dudek <mariusz.dudek@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Mariusz Dudek <mariuszx.dudek@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 8:12 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Nov 12, 2020 at 12:58 AM <mariusz.dudek@gmail.com> wrote:
> >
> > From: Mariusz Dudek <mariuszx.dudek@intel.com>
> >
> > Add support for separation of eBPF program load and xsk socket
> > creation.
> >
> > This is needed for use-case when you want to privide as little
> > privileges as possible to the data plane application that will
> > handle xsk socket creation and incoming traffic.
> >
> > With this patch the data entity container can be run with only
> > CAP_NET_RAW capability to fulfill its purpose of creating xsk
> > socket and handling packages. In case your umem is larger or
> > equal process limit for MEMLOCK you need either increase the
> > limit or CAP_IPC_LOCK capability.
> >
> > To resolve privileges issue two APIs are introduced:
> >
> > - xsk_setup_xdp_prog - prepares bpf program if given and
> > loads it on a selected network interface or loads the built in
> > XDP program, if no XDP program is supplied. It can also return
> > xsks_map_fd which is needed by unprivileged process to update
> > xsks_map with AF_XDP socket "fd"
> >
> > - xsk_socket__update_xskmap - inserts an AF_XDP socket into an xskmap
> > for a particular xsk_socket
> >
> > Signed-off-by: Mariusz Dudek <mariuszx.dudek@intel.com>
> > ---
> >  tools/lib/bpf/libbpf.map |   2 +
> >  tools/lib/bpf/xsk.c      | 160 ++++++++++++++++++++++++++++++++-------
> >  tools/lib/bpf/xsk.h      |  15 ++++
> >  3 files changed, 151 insertions(+), 26 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index 29ff4807b909..73aa12388055 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -336,6 +336,8 @@ LIBBPF_0.2.0 {
> >                 perf_buffer__epoll_fd;
> >                 perf_buffer__consume_buffer;
> >                 xsk_socket__create_shared;
> > +               xsk_setup_xdp_prog;
> > +               xsk_socket__update_xskmap;
> >  } LIBBPF_0.1.0;
>
>
> New APIs have to go into LIBBPF_0.3.0 section now.
>
> >
> >  LIBBPF_0.3.0 {
>
> [...]
>
> > +static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
> > +                               struct bpf_prog_cfg_opts *cfg,
> > +                               bool force_set_map,
> > +                               int *xsks_map_fd)
> >  {
> > +       struct xsk_socket *xsk =3D _xdp;
> >         struct xsk_ctx *ctx =3D xsk->ctx;
> >         __u32 prog_id =3D 0;
> >         int err;
> > @@ -578,14 +633,17 @@ static int xsk_setup_xdp_prog(struct xsk_socket *=
xsk)
> >                 return err;
> >
> >         if (!prog_id) {
> > -               err =3D xsk_create_bpf_maps(xsk);
> > -               if (err)
> > -                       return err;
> > +               if (!cfg || !cfg->insns_cnt) {
>
> you can't do this, use OPTS_GET() macro to access fields of opts struct.
>
> > +                       err =3D xsk_create_bpf_maps(xsk);
> > +                       if (err)
> > +                               return err;
> > +               } else {
> > +                       ctx->xsks_map_fd =3D cfg->xsks_map_fd;
>
> same
>
> > +               }
> >
> > -               err =3D xsk_load_xdp_prog(xsk);
> > +               err =3D xsk_load_xdp_prog(xsk, cfg);
> >                 if (err) {
> > -                       xsk_delete_bpf_maps(xsk);
> > -                       return err;
> > +                       goto err_load_xdp_prog;
> >                 }
> >         } else {
> >                 ctx->prog_fd =3D bpf_prog_get_fd_by_id(prog_id);
>
> [...]
>
> >  int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
> >                               const char *ifname,
> >                               __u32 queue_id, struct xsk_umem *umem,
> > @@ -838,7 +946,7 @@ int xsk_socket__create_shared(struct xsk_socket **x=
sk_ptr,
> >         ctx->prog_fd =3D -1;
> >
> >         if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG=
_LOAD)) {
> > -               err =3D xsk_setup_xdp_prog(xsk);
> > +               err =3D __xsk_setup_xdp_prog(xsk, NULL, false, NULL);
> >                 if (err)
> >                         goto out_mmap_tx;
> >         }
> > diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> > index 1069c46364ff..c852ec742437 100644
> > --- a/tools/lib/bpf/xsk.h
> > +++ b/tools/lib/bpf/xsk.h
> > @@ -201,6 +201,21 @@ struct xsk_umem_config {
> >         __u32 flags;
> >  };
> >
> > +struct bpf_prog_cfg_opts {
>
> The name of this struct doesn't really match an API it's used in, it
> looks to be related to struct bpf_program, which is extremely
> misleading. Why didn't you go with something like
> xdp_setup_xdp_prog_opts?
>
> Also, so far we've been following the convention that non-optional
> parameters are passed directly as function arguments, with all the
> optional things put into opts. Looking at this struct, prog and
> insns_cnt look non-optional. Not sure about the license. Also, it
> seems strange to have xsks_map_fd in opts struct and as an output
> parameter... If that's really in/out param, you can do OPTS_SET() and
> pass it back through the same opts struct.
>
> But in general, I'm also surprised that this API is using the bpf_insn
> array as an input. Do people really construct such a low-level set of
> instructions manually? Seems like a rather painful API.
>
> Bj=C3=B6rn, Magnus, please take a look as well and chime in on API design
> (I have too little context on XSK use cases).

Yes, it is much too macho to write an eBPF program directly using
assembly :-). My suggestion is to get rid of this whole struct
bpf_prog_cfg_opts completely and the parameter in the call. There is
no reason to provide functionality to load your own program in this
API as it is already so easy using the existing libbpf APIs e.g., with
bpf_prog_load_xattr() followed by bpf_set_link_xdp_fd(). So I suggest
the following:

LIBBPF_API int xsk_setup_default_prog(int ifindex, int *xsks_map_fd);

It is strictly a helper function for setting up the default XDP
program from a process that has the privilege to do this.

Thanks Andrii for taking a look at this and thanks Mariusz for taking
a stab at this.

>
> > +       size_t sz; /* size of this struct for forward/backward compatib=
ility */
> > +       struct bpf_insn *prog;
> > +       const char *license;
> > +       size_t insns_cnt;
> > +       int xsks_map_fd;
> > +};
> > +#define bpf_prog_cfg_opts__last_field xsks_map_fd
> > +
> > +LIBBPF_API int xsk_setup_xdp_prog(int ifindex,
> > +                                 struct bpf_prog_cfg_opts *opts,
> > +                                 int *xsks_map_fd);
> > +LIBBPF_API int xsk_socket__update_xskmap(struct xsk_socket *xsk,
> > +                                int xsks_map_fd);
> > +
> >  /* Flags for the libbpf_flags field. */
> >  #define XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD (1 << 0)
> >
> > --
> > 2.20.1
> >
