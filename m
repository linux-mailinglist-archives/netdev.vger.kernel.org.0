Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4AF6AD7F
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 19:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388036AbfGPROj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 13:14:39 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:33404 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728124AbfGPROj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 13:14:39 -0400
Received: by mail-vs1-f67.google.com with SMTP id m8so14489329vsj.0;
        Tue, 16 Jul 2019 10:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K2T5hXZ28GqFjDQWKXNnzayNSQkWAA4ayrA9/eIoHIk=;
        b=ML7ZtHIqMEKlSdOcxsPF6riTTSqgesIeZrKbGD7HrTze3FDhjzRu0lyA0WD/PsVoJC
         5V1ApPny/eRhwmxTsXfDdtoB8ZJ1IOnkyzM1dlSSRhXRozCnWJMgViCjapPaLNiUk8sM
         PEe4Fl7nN786ZlgCTheHo339pxzCOOtLvTpyPosnfDbyzFjsyGY2JWcw51zTkKqcplma
         PP5Ldrkl8+7IcMW6bJCTUpkofmk/m4EzkWeKp7OZ0ax30N3KyTd2COWhM+X8Sm6qP9Fn
         ZvBrrHRiO0iz376Y2iKNFP0/PsTbJPi7xuNOVbuKnM+1PqhJ+5M4q7o56br3LxuUZCYN
         bMGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K2T5hXZ28GqFjDQWKXNnzayNSQkWAA4ayrA9/eIoHIk=;
        b=c5zO7F1/8VZxceI8AHpDT/WjyeeeLg6RcTDCPgQsODu2D6hW1aOsWNSQ9A8pnwHmNL
         egzJO5NcjxT4OhVsBFET1uIY1OlIPgr4tajxDDjh8HIGuZaiUHzJtdpEGrktToDyvasQ
         tYLCN1jcm1cjgUT3fFs7TVOA/Ae/bQmNepu2ogin1aWsDn8hYYg3QcR+tj+mVkawKG62
         nL6Z0/gqR6gEWADQ6HR5cjrz17JiAHrzxOxJWPyEfnEGkOZoK1RWTStQIJnQs03BBGuy
         Uu6IHUQrDW3Bpm8+8HcIQjnn3Piw5CIn90yoD35c2WoNxwOqYPdMmRqwRtK4bKmdSP3k
         nZbQ==
X-Gm-Message-State: APjAAAV7BTpqSOS5zBRQ06jonVzLbO31rYKr2E2oyoWDWZfgoC6w7TWL
        oaI2vD1CkdMOJZdtnepGXwsp/3WqYS84WouklEc=
X-Google-Smtp-Source: APXvYqxXMpdpp/7OzarEqZ8xGCio3PDPPIctuqs1PADOnXX2pUlVTIkJp3otcLCkxittg89fOlESkG1r20Y9Mrv5vzs=
X-Received: by 2002:a67:d082:: with SMTP id s2mr18848597vsi.96.1563297277785;
 Tue, 16 Jul 2019 10:14:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1562359091.git.a.s.protopopov@gmail.com>
 <e183c0af99056f8ea4de06acb358ace7f3a3d6ae.1562359091.git.a.s.protopopov@gmail.com>
 <734dd45a-95b0-a7fd-9e1d-0535ef4d3e12@iogearbox.net> <CAEf4BzaGGVv2z8jB8MnT7=gnn4nG0cp7DGYxfnnnpohOT=ujCA@mail.gmail.com>
 <CAGn_itw=BqWXn7ibg6M7j4r2T5CMo0paBhBoQQv7b+x7D2g2ww@mail.gmail.com> <CAEf4BzYaiH_GhSJJjkGv4dGF7CbBrusTyShPP9DXvXjCLcmK+w@mail.gmail.com>
In-Reply-To: <CAEf4BzYaiH_GhSJJjkGv4dGF7CbBrusTyShPP9DXvXjCLcmK+w@mail.gmail.com>
From:   Anton Protopopov <a.s.protopopov@gmail.com>
Date:   Tue, 16 Jul 2019 13:14:26 -0400
Message-ID: <CAGn_itxPjTEHsnBik+KPxc+EGh5fT670nD=u_xZXBzBZq2jrvQ@mail.gmail.com>
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

=D0=B2=D1=82, 9 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 13:40, Andrii Nakry=
iko <andrii.nakryiko@gmail.com>:
>
> On Mon, Jul 8, 2019 at 1:37 PM Anton Protopopov
> <a.s.protopopov@gmail.com> wrote:
> >
> > =D0=BF=D0=BD, 8 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 13:54, Andrii N=
akryiko <andrii.nakryiko@gmail.com>:
> > >
> > > On Fri, Jul 5, 2019 at 2:53 PM Daniel Borkmann <daniel@iogearbox.net>=
 wrote:
> > > >
> > > > On 07/05/2019 10:44 PM, Anton Protopopov wrote:
> > > > > Add a new API bpf_object__reuse_maps() which can be used to repla=
ce all maps in
> > > > > an object by maps pinned to a directory provided in the path argu=
ment.  Namely,
> > > > > each map M in the object will be replaced by a map pinned to path=
/M.name.
> > > > >
> > > > > Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
> > > > > ---
> > > > >  tools/lib/bpf/libbpf.c   | 34 ++++++++++++++++++++++++++++++++++
> > > > >  tools/lib/bpf/libbpf.h   |  2 ++
> > > > >  tools/lib/bpf/libbpf.map |  1 +
> > > > >  3 files changed, 37 insertions(+)
> > > > >
> > > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > > index 4907997289e9..84c9e8f7bfd3 100644
> > > > > --- a/tools/lib/bpf/libbpf.c
> > > > > +++ b/tools/lib/bpf/libbpf.c
> > > > > @@ -3144,6 +3144,40 @@ int bpf_object__unpin_maps(struct bpf_obje=
ct *obj, const char *path)
> > > > >       return 0;
> > > > >  }
> > > > >
> > > > > +int bpf_object__reuse_maps(struct bpf_object *obj, const char *p=
ath)
> > >
> > > As is, bpf_object__reuse_maps() can be easily implemented by user
> > > applications, as it's only using public libbpf APIs, so I'm not 100%
> > > sure we need to add method like that to libbpf.
> >
> > The bpf_object__reuse_maps() can definitely be implemented by user
> > applications, however, to use it a user also needs to re-implement the
> > bpf_prog_load_xattr funciton, so it seemed to me that adding this
> > functionality to the library is a better way.
>
> I'm still not convinced. Looking at bpf_prog_load_xattr, I think some
> of what it's doing should be part of bpf_object__object_xattr anyway
> (all the expected type setting for programs).
>
> Besides that, there isn't much more than just bpf_object__open and
> bpf_object__load, to be honest. By doing open and load explicitly,
> user gets an opportunity to do whatever adjustment they need: reuse
> maps, adjust map sizes, etc. So I think we should improve
> bpf_object__open to "guess" program attach types and add map
> definition flags to allow reuse declaratively.
>
>
> >
> > >
> > > > > +{
> > > > > +     struct bpf_map *map;
> > > > > +
> > > > > +     if (!obj)
> > > > > +             return -ENOENT;
> > > > > +
> > > > > +     if (!path)
> > > > > +             return -EINVAL;
> > > > > +
> > > > > +     bpf_object__for_each_map(map, obj) {
> > > > > +             int len, err;
> > > > > +             int pinned_map_fd;
> > > > > +             char buf[PATH_MAX];
> > > >
> > > > We'd need to skip the case of bpf_map__is_internal(map) since they =
are always
> > > > recreated for the given object.
> > > >
> > > > > +             len =3D snprintf(buf, PATH_MAX, "%s/%s", path, bpf_=
map__name(map));
> > > > > +             if (len < 0) {
> > > > > +                     return -EINVAL;
> > > > > +             } else if (len >=3D PATH_MAX) {
> > > > > +                     return -ENAMETOOLONG;
> > > > > +             }
> > > > > +
> > > > > +             pinned_map_fd =3D bpf_obj_get(buf);
> > > > > +             if (pinned_map_fd < 0)
> > > > > +                     return pinned_map_fd;
> > > >
> > > > Should we rather have a new map definition attribute that tells to =
reuse
> > > > the map if it's pinned in bpf fs, and if not, we create it and late=
r on
> > > > pin it? This is what iproute2 is doing and which we're making use o=
f heavily.
> > >
> > > I'd like something like that as well. This would play nicely with
> > > recently added BTF-defined maps as well.
> > >
> > > I think it should be not just pin/don't pin flag, but rather pinning
> > > strategy, to accommodate various typical strategies of handling maps
> > > that are already pinned. So something like this:
> > >
> > > 1. BPF_PIN_NOTHING - default, don't pin;
> > > 2. BPF_PIN_EXCLUSIVE - pin, but if map is already pinned - fail;
> > > 3. BPF_PIN_SET - pin; if existing map exists, reset its state to be
> > > exact state of object's map;
> > > 4. BPF_PIN_MERGE - pin, if map exists, fill in NULL entries only (thi=
s
> > > is how Cilium is pinning PROG_ARRAY maps, if I understand correctly);
> > > 5. BPF_PIN_MERGE_OVERWRITE - pin, if map exists, overwrite non-NULL v=
alues.
> > >
> > > This list is only for illustrative purposes, ideally people that have
> > > a lot of experience using pinning for real-world use cases would chim=
e
> > > in on what strategies are useful and make sense.
> >
> > My case was simply to reuse existing maps when reloading a program.
> > Does it make sense for you to add only the simplest cases of listed abo=
ve?
>
> Of course, it's enum, so we can start with few clearly useful ones and
> then expand more if we ever have a need. But I think we still need a
> bit wider discussion and let people who use pinning to chime in.
>
> >
> > Also, libbpf doesn't use standard naming conventions for pinning maps.
>
> We talked about this in another thread related to BTF-defined maps. I
> think the way to go with this is to actually define a default pinning
> root path, but allow to override it on bpf_object__open, if user needs
> a different one.
>
> > Does it make sense to provide a list of already open maps to the
> > bpf_prog_load_xattr function as an attribute? In this case a user
> > can execute his own policy on pinning, but still will have an option
> > to reuse, reset, and merge maps.
>
> As explained above, I don't think there isn't much added value in
> bpf_prog_load, so I'd advise to just switch to explicit
> bpf_object__open + bpf_object__load and get maximum control and
> flexibility.

Thanks for your comments. I can see now that using
bpf_object__open/bpf_object__load makes better sense.

>
> >
> > >
> > > > In bpf_object__reuse_maps() bailing out if bpf_obj_get() fails is p=
erhaps
> > > > too limiting for a generic API as new version of an object file may=
 contain
> > > > new maps which are not yet present in bpf fs at that point.
> > > >
> > > > > +             err =3D bpf_map__reuse_fd(map, pinned_map_fd);
> > > > > +             if (err)
> > > > > +                     return err;
> > > > > +     }
> > > > > +
> > > > > +     return 0;
> > > > > +}
> > > > > +
> > > > >  int bpf_object__pin_programs(struct bpf_object *obj, const char =
*path)
> > > > >  {
> > > > >       struct bpf_program *prog;
> > > > > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > > > > index d639f47e3110..7fe465a1be76 100644
> > > > > --- a/tools/lib/bpf/libbpf.h
> > > > > +++ b/tools/lib/bpf/libbpf.h
> > > > > @@ -82,6 +82,8 @@ int bpf_object__variable_offset(const struct bp=
f_object *obj, const char *name,
> > > > >  LIBBPF_API int bpf_object__pin_maps(struct bpf_object *obj, cons=
t char *path);
> > > > >  LIBBPF_API int bpf_object__unpin_maps(struct bpf_object *obj,
> > > > >                                     const char *path);
> > > > > +LIBBPF_API int bpf_object__reuse_maps(struct bpf_object *obj,
> > > > > +                                   const char *path);
> > > > >  LIBBPF_API int bpf_object__pin_programs(struct bpf_object *obj,
> > > > >                                       const char *path);
> > > > >  LIBBPF_API int bpf_object__unpin_programs(struct bpf_object *obj=
,
> > > > > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > > > > index 2c6d835620d2..66a30be6696c 100644
> > > > > --- a/tools/lib/bpf/libbpf.map
> > > > > +++ b/tools/lib/bpf/libbpf.map
> > > > > @@ -172,5 +172,6 @@ LIBBPF_0.0.4 {
> > > > >               btf_dump__new;
> > > > >               btf__parse_elf;
> > > > >               bpf_object__load_xattr;
> > > > > +             bpf_object__reuse_maps;
> > > > >               libbpf_num_possible_cpus;
> > > > >  } LIBBPF_0.0.3;
> > > > >
> > > >
