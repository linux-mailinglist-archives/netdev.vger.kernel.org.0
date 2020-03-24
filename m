Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA151191D3C
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 00:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgCXXGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 19:06:09 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:38682 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbgCXXGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 19:06:08 -0400
Received: by mail-qv1-f67.google.com with SMTP id p60so32182qva.5;
        Tue, 24 Mar 2020 16:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4pOTjOQ4CSoPPo4R3m6oFz097HCDHa07yFZ3G/jCU5o=;
        b=GWJDDNjgep4dQ0GbncFL2YA5COqLO968gn9y5l4ZLmde6uD/Sg8Hw4Vh8iSKZ+SQE1
         SumjLEZwXMFCMxEJXOJZeI9KCe0thkXnLA+FkgiyK+2mtoEFeQFvy4E2oO6dgUAiMMxB
         RA59qCwIT/1bFpoptvrhuC+4R89RjjsLezZ5HxTjJyK/UOkZRYImugyVqJcyGNDqSRIp
         1QB2UfilbqYyceeTupaBaRz8wyjhO1G9FHaSzqDv65FVuDMdbCVL0tMo/NeLU1mr0oob
         cYuOj8epSLaBoJvpjtUWKjuJ89SrQsh0/AbaEET6r9LA06Y9adh7bJP3lCDZVrYPs/fc
         ZqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4pOTjOQ4CSoPPo4R3m6oFz097HCDHa07yFZ3G/jCU5o=;
        b=aC7w8+AwB0iV13LY2u9svg7iFjijV4VD2WHndZH/Xo5rdjxCOJ8WNksIEgLkFFLICl
         qsLrWTVVnzTht4XKUges8V+wucUtRiZH1wi7n8/wAFXUhgiu0niwsMbqmEh99KHF7lT+
         sxqQDa/kOcUibVujBvJXIpfTdFFn/YLS632gzg9hAgA1wVsyz7ap09Xk/1KG7c1lIaJA
         ZZjnulYjkCq/TS9K16flzp/BJSI514Yf1xmf93Ink5vJtdhBwYHO7tZg8ypIkvaEQTI9
         vnOn6CcJscTLQSma58mDEgmIODhPSN4xCefM2wy6U4AYZEiZDR0EwVRDNFrJnNsukKJh
         AG5A==
X-Gm-Message-State: ANhLgQ1aYluwQTe9qCKlDtHlrwGV3T6HiN+3XoukaYb68Bc4APnVoew1
        Gfj65rIwNy02sUak9xUCb9mTNUNgpI15eZ3zcPc=
X-Google-Smtp-Source: ADFU+vtIjXjAcaLmeV0nxzde93764w9RX27hT/rQo1hoxo/HZak5M33rGGtvhxs04+Qks8WfXK62NNa96PFLfKwJlZQ=
X-Received: by 2002:a0c:bd2a:: with SMTP id m42mr543269qvg.163.1585091166624;
 Tue, 24 Mar 2020 16:06:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200320203615.1519013-1-andriin@fb.com> <20200320203615.1519013-6-andriin@fb.com>
 <87wo7b49mn.fsf@toke.dk> <CAEf4Bzbt7-A+2dH0kSAM11mjwX+ZDV8JBhJZDArAU=Q9+y79mw@mail.gmail.com>
 <87blom3m2w.fsf@toke.dk>
In-Reply-To: <87blom3m2w.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 24 Mar 2020 16:05:55 -0700
Message-ID: <CAEf4Bzb5=tg+mYs+V6=fTzhxCYmx2qAVSTXAuJud-6Q92au80g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/6] libbpf: add support for bpf_link-based
 cgroup attachment
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 12:31 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Mon, Mar 23, 2020 at 4:02 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andriin@fb.com> writes:
> >>
> >> > Add bpf_program__attach_cgroup(), which uses BPF_LINK_CREATE subcomm=
and to
> >> > create an FD-based kernel bpf_link. Also add low-level bpf_link_crea=
te() API.
> >> >
> >> > If expected_attach_type is not specified explicitly with
> >> > bpf_program__set_expected_attach_type(), libbpf will try to determin=
e proper
> >> > attach type from BPF program's section definition.
> >> >
> >> > Also add support for bpf_link's underlying BPF program replacement:
> >> >   - unconditional through high-level bpf_link__update_program() API;
> >> >   - cmpxchg-like with specifying expected current BPF program throug=
h
> >> >     low-level bpf_link_update() API.
> >> >
> >> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >> > ---
> >> >  tools/include/uapi/linux/bpf.h | 12 +++++++++
> >> >  tools/lib/bpf/bpf.c            | 34 +++++++++++++++++++++++++
> >> >  tools/lib/bpf/bpf.h            | 19 ++++++++++++++
> >> >  tools/lib/bpf/libbpf.c         | 46 +++++++++++++++++++++++++++++++=
+++
> >> >  tools/lib/bpf/libbpf.h         |  8 +++++-
> >> >  tools/lib/bpf/libbpf.map       |  4 +++
> >> >  6 files changed, 122 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/lin=
ux/bpf.h
> >> > index fad9f79bb8f1..fa944093f9fc 100644
> >> > --- a/tools/include/uapi/linux/bpf.h
> >> > +++ b/tools/include/uapi/linux/bpf.h
> >> > @@ -112,6 +112,7 @@ enum bpf_cmd {
> >> >       BPF_MAP_UPDATE_BATCH,
> >> >       BPF_MAP_DELETE_BATCH,
> >> >       BPF_LINK_CREATE,
> >> > +     BPF_LINK_UPDATE,
> >> >  };
> >> >
> >> >  enum bpf_map_type {
> >> > @@ -574,6 +575,17 @@ union bpf_attr {
> >> >               __u32           target_fd;      /* object to attach to=
 */
> >> >               __u32           attach_type;    /* attach type */
> >> >       } link_create;
> >> > +
> >> > +     struct { /* struct used by BPF_LINK_UPDATE command */
> >> > +             __u32           link_fd;        /* link fd */
> >> > +             /* new program fd to update link with */
> >> > +             __u32           new_prog_fd;
> >> > +             __u32           flags;          /* extra flags */
> >> > +             /* expected link's program fd; is specified only if
> >> > +              * BPF_F_REPLACE flag is set in flags */
> >> > +             __u32           old_prog_fd;
> >> > +     } link_update;
> >> > +
> >> >  } __attribute__((aligned(8)));
> >> >
> >> >  /* The description below is an attempt at providing documentation t=
o eBPF
> >> > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> >> > index c6dafe563176..35c34fc81bd0 100644
> >> > --- a/tools/lib/bpf/bpf.c
> >> > +++ b/tools/lib/bpf/bpf.c
> >> > @@ -584,6 +584,40 @@ int bpf_prog_detach2(int prog_fd, int target_fd=
, enum bpf_attach_type type)
> >> >       return sys_bpf(BPF_PROG_DETACH, &attr, sizeof(attr));
> >> >  }
> >> >
> >> > +int bpf_link_create(int prog_fd, int target_fd,
> >> > +                 enum bpf_attach_type attach_type,
> >> > +                 const struct bpf_link_create_opts *opts)
> >> > +{
> >> > +     union bpf_attr attr;
> >> > +
> >> > +     if (!OPTS_VALID(opts, bpf_link_create_opts))
> >> > +             return -EINVAL;
> >> > +
> >> > +     memset(&attr, 0, sizeof(attr));
> >> > +     attr.link_create.prog_fd =3D prog_fd;
> >> > +     attr.link_create.target_fd =3D target_fd;
> >> > +     attr.link_create.attach_type =3D attach_type;
> >> > +
> >> > +     return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
> >> > +}
> >> > +
> >> > +int bpf_link_update(int link_fd, int new_prog_fd,
> >> > +                 const struct bpf_link_update_opts *opts)
> >> > +{
> >> > +     union bpf_attr attr;
> >> > +
> >> > +     if (!OPTS_VALID(opts, bpf_link_update_opts))
> >> > +             return -EINVAL;
> >> > +
> >> > +     memset(&attr, 0, sizeof(attr));
> >> > +     attr.link_update.link_fd =3D link_fd;
> >> > +     attr.link_update.new_prog_fd =3D new_prog_fd;
> >> > +     attr.link_update.flags =3D OPTS_GET(opts, flags, 0);
> >> > +     attr.link_update.old_prog_fd =3D OPTS_GET(opts, old_prog_fd, 0=
);
> >> > +
> >> > +     return sys_bpf(BPF_LINK_UPDATE, &attr, sizeof(attr));
> >> > +}
> >> > +
> >> >  int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 =
query_flags,
> >> >                  __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_c=
nt)
> >> >  {
> >> > diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> >> > index b976e77316cc..46d47afdd887 100644
> >> > --- a/tools/lib/bpf/bpf.h
> >> > +++ b/tools/lib/bpf/bpf.h
> >> > @@ -168,6 +168,25 @@ LIBBPF_API int bpf_prog_detach(int attachable_f=
d, enum bpf_attach_type type);
> >> >  LIBBPF_API int bpf_prog_detach2(int prog_fd, int attachable_fd,
> >> >                               enum bpf_attach_type type);
> >> >
> >> > +struct bpf_link_create_opts {
> >> > +     size_t sz; /* size of this struct for forward/backward compati=
bility */
> >> > +};
> >> > +#define bpf_link_create_opts__last_field sz
> >> > +
> >> > +LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
> >> > +                            enum bpf_attach_type attach_type,
> >> > +                            const struct bpf_link_create_opts *opts=
);
> >> > +
> >> > +struct bpf_link_update_opts {
> >> > +     size_t sz; /* size of this struct for forward/backward compati=
bility */
> >> > +     __u32 flags;       /* extra flags */
> >> > +     __u32 old_prog_fd; /* expected old program FD */
> >> > +};
> >> > +#define bpf_link_update_opts__last_field old_prog_fd
> >> > +
> >> > +LIBBPF_API int bpf_link_update(int link_fd, int new_prog_fd,
> >> > +                            const struct bpf_link_update_opts *opts=
);
> >> > +
> >> >  struct bpf_prog_test_run_attr {
> >> >       int prog_fd;
> >> >       int repeat;
> >> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> > index 085e41f9b68e..8b23c70033d3 100644
> >> > --- a/tools/lib/bpf/libbpf.c
> >> > +++ b/tools/lib/bpf/libbpf.c
> >> > @@ -6951,6 +6951,12 @@ struct bpf_link {
> >> >       bool disconnected;
> >> >  };
> >> >
> >> > +/* Replace link's underlying BPF program with the new one */
> >> > +int bpf_link__update_program(struct bpf_link *link, struct bpf_prog=
ram *prog)
> >> > +{
> >> > +     return bpf_link_update(bpf_link__fd(link), bpf_program__fd(pro=
g), NULL);
> >> > +}
> >>
> >> I would expect bpf_link to keep track of the previous program and
> >> automatically fill it in with this operation. I.e., it should be
> >> possible to do something like:
> >>
> >> link =3D bpf_link__open("/sys/fs/bpf/my_link");
> >> prog =3D bpf_link__get_prog(link);
> >
> > I don't think libbpf is able to construct struct bpf_program from link
> > info. It can get program FD, of course, but struct bpf_program is much
> > more than that and not sure kernel has all the necessary info. Some
> > parts of bpf_program is coming from ELF file, which is gone by this
> > time.
>
> Hmm, sure, maybe, but it could still get enough information (such as the
> prog fd, and everything returned by GET_PROG_INFO) for userspace could
> do something meaningful with the result. So that would turn the above
> into bpf_link__get_prog_fd(), and struct bpf_link would contain the fd
> of the currently-attached program so it can be supplied in any future
> replacement calls.

Yes, at that will probably be implementation if we go with "expected
always required" as a default. But I'm still not sure that's the right
default.

>
> -Toke
>
