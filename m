Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E91C62A74
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 22:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405078AbfGHUhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 16:37:55 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:34093 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728778AbfGHUhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 16:37:54 -0400
Received: by mail-vs1-f65.google.com with SMTP id m23so9147528vso.1;
        Mon, 08 Jul 2019 13:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Xoa10/Gq2LsbDcHbD/zmcjTEfAiOzl03k2kvaddEK8I=;
        b=If51vIsL7yPZW21MtnWt+bTp4RSPcdYSmTPezAYqyAmyKdGplWPwpjHGv/R17U4DRl
         wbulsoepnOHaV+pXXYLHOM+7mPS9+nWIZ7kYqin7Whau62E3xp5ub0m0wOhNzsLq7KPK
         jQ+FrWq+chu4WuY6k/J9N3/4LgbFu9xQuX6Uq6cWu2MWtZL2sidO+jh65yhSy5QgM2xb
         AM3iPXxAf6w0QTYFoYERB0MjMNF27QBC+Si0+aU0CoFIWxnjLK2M40F5hlyePRzitUAo
         LuMkEkfYjvONaLhN1MV1l/q8wrQx1DOCz83IUlGKqT79Gm3QyxocY1q8HinLy52/w5cc
         pNKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Xoa10/Gq2LsbDcHbD/zmcjTEfAiOzl03k2kvaddEK8I=;
        b=TbaRMyBB9pNqFFmwSbP8UB+fneUzCgNERXdoVDLfqz8pyrzR7bUg0yIuKk3bi27k+J
         imy/NyqSszL4P1VwzykSeBS1LmhbY18Ij/41ha0K85XPXFjxxyEKA+74Z0AJf6E3QPpQ
         /j6WXDl+wleBtSjpdBTLo5eT4R2EejlebgWsSHIHOvBdUWwmiLSrzYKnvQSKlyAWIvkc
         BZUzzEVh4oIIPcAtJ9Bz++aOKxTiR6gKC7X89/dyfoR5wLteTXzpzzEJv0YkiPTZ7Pby
         PInTsPqGu9WCszS62M2TBgedDSExdoaAgJmwtsnmZCkHYpBqDyAOCxQHpX0TeBF93hJ0
         3oWw==
X-Gm-Message-State: APjAAAVexHnF6rC/sy5EUDSEe7WW5kKAiXkf6R1bDGHZzmj+AIU/VWpl
        3xeHRWHVsE8Ol75dRfQrQT0ELqIA9Ge2kvwCFIE=
X-Google-Smtp-Source: APXvYqyKUAyDAUmKtQRJrzk8olKBT8tNX2An90vKRAXEJbU4YNiOrXP7FJ+rifu8ESxHw5/FbEjihG9YUmIZnnfWuzA=
X-Received: by 2002:a67:eb19:: with SMTP id a25mr11726259vso.109.1562618273573;
 Mon, 08 Jul 2019 13:37:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1562359091.git.a.s.protopopov@gmail.com>
 <e183c0af99056f8ea4de06acb358ace7f3a3d6ae.1562359091.git.a.s.protopopov@gmail.com>
 <734dd45a-95b0-a7fd-9e1d-0535ef4d3e12@iogearbox.net> <CAEf4BzaGGVv2z8jB8MnT7=gnn4nG0cp7DGYxfnnnpohOT=ujCA@mail.gmail.com>
In-Reply-To: <CAEf4BzaGGVv2z8jB8MnT7=gnn4nG0cp7DGYxfnnnpohOT=ujCA@mail.gmail.com>
From:   Anton Protopopov <a.s.protopopov@gmail.com>
Date:   Mon, 8 Jul 2019 16:37:42 -0400
Message-ID: <CAGn_itw=BqWXn7ibg6M7j4r2T5CMo0paBhBoQQv7b+x7D2g2ww@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf, libbpf: add a new API bpf_object__reuse_maps()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=D0=BF=D0=BD, 8 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 13:54, Andrii Nakry=
iko <andrii.nakryiko@gmail.com>:
>
> On Fri, Jul 5, 2019 at 2:53 PM Daniel Borkmann <daniel@iogearbox.net> wro=
te:
> >
> > On 07/05/2019 10:44 PM, Anton Protopopov wrote:
> > > Add a new API bpf_object__reuse_maps() which can be used to replace a=
ll maps in
> > > an object by maps pinned to a directory provided in the path argument=
.  Namely,
> > > each map M in the object will be replaced by a map pinned to path/M.n=
ame.
> > >
> > > Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
> > > ---
> > >  tools/lib/bpf/libbpf.c   | 34 ++++++++++++++++++++++++++++++++++
> > >  tools/lib/bpf/libbpf.h   |  2 ++
> > >  tools/lib/bpf/libbpf.map |  1 +
> > >  3 files changed, 37 insertions(+)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 4907997289e9..84c9e8f7bfd3 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -3144,6 +3144,40 @@ int bpf_object__unpin_maps(struct bpf_object *=
obj, const char *path)
> > >       return 0;
> > >  }
> > >
> > > +int bpf_object__reuse_maps(struct bpf_object *obj, const char *path)
>
> As is, bpf_object__reuse_maps() can be easily implemented by user
> applications, as it's only using public libbpf APIs, so I'm not 100%
> sure we need to add method like that to libbpf.

The bpf_object__reuse_maps() can definitely be implemented by user
applications, however, to use it a user also needs to re-implement the
bpf_prog_load_xattr funciton, so it seemed to me that adding this
functionality to the library is a better way.

>
> > > +{
> > > +     struct bpf_map *map;
> > > +
> > > +     if (!obj)
> > > +             return -ENOENT;
> > > +
> > > +     if (!path)
> > > +             return -EINVAL;
> > > +
> > > +     bpf_object__for_each_map(map, obj) {
> > > +             int len, err;
> > > +             int pinned_map_fd;
> > > +             char buf[PATH_MAX];
> >
> > We'd need to skip the case of bpf_map__is_internal(map) since they are =
always
> > recreated for the given object.
> >
> > > +             len =3D snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map_=
_name(map));
> > > +             if (len < 0) {
> > > +                     return -EINVAL;
> > > +             } else if (len >=3D PATH_MAX) {
> > > +                     return -ENAMETOOLONG;
> > > +             }
> > > +
> > > +             pinned_map_fd =3D bpf_obj_get(buf);
> > > +             if (pinned_map_fd < 0)
> > > +                     return pinned_map_fd;
> >
> > Should we rather have a new map definition attribute that tells to reus=
e
> > the map if it's pinned in bpf fs, and if not, we create it and later on
> > pin it? This is what iproute2 is doing and which we're making use of he=
avily.
>
> I'd like something like that as well. This would play nicely with
> recently added BTF-defined maps as well.
>
> I think it should be not just pin/don't pin flag, but rather pinning
> strategy, to accommodate various typical strategies of handling maps
> that are already pinned. So something like this:
>
> 1. BPF_PIN_NOTHING - default, don't pin;
> 2. BPF_PIN_EXCLUSIVE - pin, but if map is already pinned - fail;
> 3. BPF_PIN_SET - pin; if existing map exists, reset its state to be
> exact state of object's map;
> 4. BPF_PIN_MERGE - pin, if map exists, fill in NULL entries only (this
> is how Cilium is pinning PROG_ARRAY maps, if I understand correctly);
> 5. BPF_PIN_MERGE_OVERWRITE - pin, if map exists, overwrite non-NULL value=
s.
>
> This list is only for illustrative purposes, ideally people that have
> a lot of experience using pinning for real-world use cases would chime
> in on what strategies are useful and make sense.

My case was simply to reuse existing maps when reloading a program.
Does it make sense for you to add only the simplest cases of listed above?

Also, libbpf doesn't use standard naming conventions for pinning maps.
Does it make sense to provide a list of already open maps to the
bpf_prog_load_xattr function as an attribute? In this case a user
can execute his own policy on pinning, but still will have an option
to reuse, reset, and merge maps.

>
> > In bpf_object__reuse_maps() bailing out if bpf_obj_get() fails is perha=
ps
> > too limiting for a generic API as new version of an object file may con=
tain
> > new maps which are not yet present in bpf fs at that point.
> >
> > > +             err =3D bpf_map__reuse_fd(map, pinned_map_fd);
> > > +             if (err)
> > > +                     return err;
> > > +     }
> > > +
> > > +     return 0;
> > > +}
> > > +
> > >  int bpf_object__pin_programs(struct bpf_object *obj, const char *pat=
h)
> > >  {
> > >       struct bpf_program *prog;
> > > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > > index d639f47e3110..7fe465a1be76 100644
> > > --- a/tools/lib/bpf/libbpf.h
> > > +++ b/tools/lib/bpf/libbpf.h
> > > @@ -82,6 +82,8 @@ int bpf_object__variable_offset(const struct bpf_ob=
ject *obj, const char *name,
> > >  LIBBPF_API int bpf_object__pin_maps(struct bpf_object *obj, const ch=
ar *path);
> > >  LIBBPF_API int bpf_object__unpin_maps(struct bpf_object *obj,
> > >                                     const char *path);
> > > +LIBBPF_API int bpf_object__reuse_maps(struct bpf_object *obj,
> > > +                                   const char *path);
> > >  LIBBPF_API int bpf_object__pin_programs(struct bpf_object *obj,
> > >                                       const char *path);
> > >  LIBBPF_API int bpf_object__unpin_programs(struct bpf_object *obj,
> > > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > > index 2c6d835620d2..66a30be6696c 100644
> > > --- a/tools/lib/bpf/libbpf.map
> > > +++ b/tools/lib/bpf/libbpf.map
> > > @@ -172,5 +172,6 @@ LIBBPF_0.0.4 {
> > >               btf_dump__new;
> > >               btf__parse_elf;
> > >               bpf_object__load_xattr;
> > > +             bpf_object__reuse_maps;
> > >               libbpf_num_possible_cpus;
> > >  } LIBBPF_0.0.3;
> > >
> >
