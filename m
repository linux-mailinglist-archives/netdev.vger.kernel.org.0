Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EA3E112E
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 06:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732604AbfJWEs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 00:48:29 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40337 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731061AbfJWEs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 00:48:28 -0400
Received: by mail-qk1-f193.google.com with SMTP id y81so14720660qkb.7;
        Tue, 22 Oct 2019 21:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QGCatDdqF1V6G+fwU2IG6VijceqBZw9QgREt23lEy44=;
        b=k+kSdnZkm41g1nCPrfy9B5OEnEqyzst9Sxji6x+iXu4t8hi68cSL4qiPCmLTw4BdHy
         9kvkJn+O9GRaPML5PpsQijTXSND/ZEwtIUpN5BPdEwoZK7c02+n1QAKdY3aMt9SwSjoG
         j54T+YKWjF5RS9N+f6qrs8e1WJjPLb3VSQyzw+5a/8wNvTn1CdBmwzn+JdUOXMybtmV7
         WQgAReJLSVl9lENkBWqxHO93GRqal2WVABsH8I3/H9jPE2sn6khuBSfKS79MtLYFsrGA
         ubR9XvyZKAz+ikFr/yKQxW9/6g4wowNnbcQ5nCEYd3uI8SFlcvqMhRBXLBLMJcXTnlDy
         0VYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QGCatDdqF1V6G+fwU2IG6VijceqBZw9QgREt23lEy44=;
        b=feR6m0OJOJ8FWx9gRS1sDRfIcI0M5jcnlraTR3Pj9zyB5gxdvdOVUFOjA/HDP//0/O
         Yt7HcmW0CbTnGh5vn6vh0wcwpDFyKQLSO0Qtr32j1qnQGWqv2j1z+fLFwjA8XeKN4u/u
         pEmv2FvJb9wrptao7gH1Bcmn7gkpm+BpFI/UQGlMCTkNkrWDLML685eCGvaOhTHIM5l3
         RNjyyu5nnfQiaK3Srp4Hef1wlnIc9a5Rh7bLiyDQEXLLL1d4fJfublk6tCW8lG6iMdbx
         qoH4b3+I/jOLh5+evGQ6sRmc5PxR97RVN9fRf95j6bpWnTXkDdeMeR3R9+Vz0qbEe19Z
         xdhg==
X-Gm-Message-State: APjAAAXllDBsHT8YhsPK/jZDytv3IaBFnHUni4VTSgp3XWNTwcwC5HlV
        c2vFezNJUV/uir0mLGJRutU4oUk/eTtNzAGrRzwHT29ae6A=
X-Google-Smtp-Source: APXvYqypcc9338ZTcH3L5++7saigCUhqptQnysx3r+U/K7YQJQmwkbmfoM/wSkodCUv+NDvFIvX8XO0O5tKSbP6KHBo=
X-Received: by 2002:a37:8046:: with SMTP id b67mr2256453qkd.437.1571805626748;
 Tue, 22 Oct 2019 21:40:26 -0700 (PDT)
MIME-Version: 1.0
References: <157175668770.112621.17344362302386223623.stgit@toke.dk>
 <157175668991.112621.14204565208520782920.stgit@toke.dk> <CAEf4BzaM32j4iLhvcuwMS+dPDBd52KwviwJuoAwVVr8EwoRpHA@mail.gmail.com>
 <875zkgobf3.fsf@toke.dk>
In-Reply-To: <875zkgobf3.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Oct 2019 21:40:15 -0700
Message-ID: <CAEf4BzY-buKFadzzAKpCdjAZ+1_UwSpQobdRH7yQn_fFXQYX0w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] libbpf: Support configurable pinning of maps
 from BTF annotations
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 11:57 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Oct 22, 2019 at 9:08 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> This adds support to libbpf for setting map pinning information as par=
t of
> >> the BTF map declaration. We introduce a new pair of functions to pin a=
nd
> >> unpin maps based on this setting, as well as a getter and setter funct=
ion
> >> for the pin information that callers can use after map load.
> >>
> >> The pin_type supports two modes: LOCAL pinning, which requires the cal=
ler
> >> to set a pin path using bpf_object_pin_opts, and a global mode, where =
the
> >> path can still be overridden, but defaults to /sys/fs/bpf. This is ins=
pired
> >> by the two modes supported by the iproute2 map definitions. In particu=
lar,
> >> it should be possible to express the current iproute2 operating mode i=
n
> >> terms of the options introduced here.
> >>
> >> The new pin functions will skip any maps that do not have a pinning ty=
pe
> >> set, unless the 'override_type' option is set, in which case all maps =
will
> >> be pinning using the pin type set in that option. This also makes it
> >> possible to express the old pin_maps and unpin_maps functions in terms=
 of
> >> the new option-based functions.
> >>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >
> > So few high-level thoughts.
> >
> > 1. I'd start with just NONE and GLOBAL as two pinning modes. It might
> > be worth-while to name GLOBAL something different just to specify that
> > it is just pinning, either to default /sys/fs/bpf root or some other
> > user-provided root path.
> > 1a. LOCAL seems to behave exactly like GLOBAL, just uses separate
> > option for a path. So we effectively have two GLOBAL modes, one with
> > default (but overrideable) /sys/fs/bpf, another with user-provided
> > mandatory path. The distinction seem rather small and arbitrary.
> > What's the use case?
>
> Supporting iproute2, mostly :)
>
> Don't terribly mind dropping LOCAL, though; I don't have any particular
> use case in mind for it myself.
>
> > 2. When is pin type override useful? Either specify it once
> > declaratively in map definition, or just do pinning programmatically?
>
> Dunno if it's really useful, actually.

Ok then, let's add minimal amount of new stuff that satisfies known
use cases. If we need more, thankfully, BTF-based stuff is easily
extendable.

>
> > 3. I think we should make pinning path override into
> > bpf_object_open_opts and keep bpf_object__pin_maps simple. We are
> > probably going to make map pinning/sharing automatic anyway, so that
> > will need to happen as part of either open or load operation.
>
> I actually started with just writing automatic map pinning logic for
> open(), but found myself re-implementing most of the logic in map_pin().
> So figured I might as well expose it to that as well.
>
> For open/load I think the logic should be that we parse the pinning
> attribute on open and set map->pin_path from that. Then load() looks at
> pin_path and does the reuse/create dance. That way, an application can
> set its own pin_paths between open and load to support legacy formats
> (like iproute2 needs to).

Yeah, makes sense. That's impression I got from reading the code as well.

>
> > 4. Once pinned, map knows its pinned path, just use that, I don't see
> > any reasonable use case where you'd want to override path just for
> > unpinning.
>
> Well, unpinning may need to re-construct the pin path. E.g.,
> applications that exit after loading and are re-run after unloading,
> such as iproute2, probably want to be able to unpin maps. Unfortunately
> I don't think there is a way to get the pin path(s) of an object from
> the kernel, though, is there? That would be kinda neat for implementing
> something like `ip link set dev eth0 xdp off unpin`.

Hm... It seems to me that if application exits and another instance
starts, it should generate pin path using the same logic, then check
if map is already pinned. Then based on settings, either reuse or
unpin first. Either way, pin_path needs to be calculated from map
attributes, not "guessed" by application.

>
> > Does it make sense?
> >
> >>  tools/lib/bpf/bpf_helpers.h |    8 +++
> >>  tools/lib/bpf/libbpf.c      |  123 ++++++++++++++++++++++++++++++++++=
++-------
> >>  tools/lib/bpf/libbpf.h      |   33 ++++++++++++
> >>  tools/lib/bpf/libbpf.map    |    4 +
> >>  4 files changed, 148 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> >> index 2203595f38c3..a23cf55d41b1 100644
> >> --- a/tools/lib/bpf/bpf_helpers.h
> >> +++ b/tools/lib/bpf/bpf_helpers.h
> >> @@ -38,4 +38,12 @@ struct bpf_map_def {
> >>         unsigned int map_flags;
> >>  };
> >>
> >> +enum libbpf_pin_type {
> >> +       LIBBPF_PIN_NONE,
> >> +       /* PIN_LOCAL: pin maps by name in path specified by caller */
> >> +       LIBBPF_PIN_LOCAL,
> >
> > Daniel mentioned in previous discussions that LOCAL mode is never
> > used. I'd like to avoid supporting unnecessary stuff. Is it really
> > useful?
>
> Oh, he did? In that case, let's definitely get rid of it :)
>
> >> +       /* PIN_GLOBAL: pin maps by name in global path (/sys/fs/bpf by=
 default) */
> >> +       LIBBPF_PIN_GLOBAL,
> >> +};
> >> +
> >>  #endif
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index b4fdd8ee3bbd..aea3916de341 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -226,6 +226,7 @@ struct bpf_map {
> >>         void *priv;
> >>         bpf_map_clear_priv_t clear_priv;
> >>         enum libbpf_map_type libbpf_type;
> >> +       enum libbpf_pin_type pinning;
> >>         char *pin_path;
> >>  };
> >>
> >> @@ -1270,6 +1271,22 @@ static int bpf_object__init_user_btf_map(struct=
 bpf_object *obj,
> >>                         }
> >>                         map->def.value_size =3D sz;
> >>                         map->btf_value_type_id =3D t->type;
> >> +               } else if (strcmp(name, "pinning") =3D=3D 0) {
> >> +                       __u32 val;
> >> +
> >> +                       if (!get_map_field_int(map_name, obj->btf, def=
, m,
> >> +                                              &val))
> >> +                               return -EINVAL;
> >> +                       pr_debug("map '%s': found pinning =3D %u.\n",
> >> +                                map_name, val);
> >> +
> >> +                       if (val && val !=3D LIBBPF_PIN_LOCAL &&
> >> +                           val !=3D LIBBPF_PIN_GLOBAL) {
> >
> > let's write out LIBBPF_PIN_NONE explicitly, instead of just `val`?
>
> OK.
>
> >> +                               pr_warning("map '%s': invalid pinning =
value %u.\n",
> >> +                                          map_name, val);
> >> +                               return -EINVAL;
> >> +                       }
> >> +                       map->pinning =3D val;
> >>                 } else {
> >>                         if (strict) {
> >>                                 pr_warning("map '%s': unknown field '%=
s'.\n",
> >> @@ -4055,10 +4072,51 @@ int bpf_map__unpin(struct bpf_map *map, const =
char *path)
> >>         return 0;
> >>  }
> >>
> >> -int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
> >> +static int get_pin_path(char *buf, size_t buf_len,
> >> +                       struct bpf_map *map, struct bpf_object_pin_opt=
s *opts,
> >> +                       bool mkdir)
> >> +{
> >> +       enum libbpf_pin_type type;
> >> +       const char *path;
> >> +       int err, len;
> >> +
> >> +       type =3D OPTS_GET(opts, override_type, 0) ?: map->pinning;
> >> +
> >> +       if (type =3D=3D LIBBPF_PIN_GLOBAL) {
> >> +               path =3D OPTS_GET(opts, path_global, NULL);
> >> +               if (!path)
> >> +                       path =3D "/sys/fs/bpf";
> >> +       } else if (type =3D=3D LIBBPF_PIN_LOCAL) {
> >> +               path =3D OPTS_GET(opts, path_local, NULL);
> >> +               if (!path) {
> >> +                       pr_warning("map '%s' set pinning to PIN_LOCAL,=
 "
> >> +                                  "but no local path provided. Skippi=
ng.\n",
> >> +                                  bpf_map__name(map));
> >> +                       return 0;
> >> +               }
> >> +       } else {
> >> +               return 0;
> >> +       }
> >> +
> >> +       if (mkdir) {
> >> +               err =3D make_dir(path);
> >> +               if (err)
> >> +                       return err;
> >> +       }
> >> +
> >> +       len =3D snprintf(buf, buf_len, "%s/%s", path, bpf_map__name(ma=
p));
> >> +       if (len < 0)
> >> +               return -EINVAL;
> >> +       else if (len >=3D buf_len)
> >> +               return -ENAMETOOLONG;
> >> +       return len;
> >> +}
> >> +
> >> +int bpf_object__pin_maps_opts(struct bpf_object *obj,
> >> +                             struct bpf_object_pin_opts *opts)
> >>  {
> >>         struct bpf_map *map;
> >> -       int err;
> >> +       int err, len;
> >>
> >>         if (!obj)
> >>                 return -ENOENT;
> >> @@ -4068,21 +4126,17 @@ int bpf_object__pin_maps(struct bpf_object *ob=
j, const char *path)
> >>                 return -ENOENT;
> >>         }
> >>
> >> -       err =3D make_dir(path);
> >> -       if (err)
> >> -               return err;
> >> +       if (!OPTS_VALID(opts, bpf_object_pin_opts))
> >> +               return -EINVAL;
> >>
> >>         bpf_object__for_each_map(map, obj) {
> >>                 char buf[PATH_MAX];
> >> -               int len;
> >>
> >> -               len =3D snprintf(buf, PATH_MAX, "%s/%s", path,
> >> -                              bpf_map__name(map));
> >> -               if (len < 0) {
> >> -                       err =3D -EINVAL;
> >> -                       goto err_unpin_maps;
> >> -               } else if (len >=3D PATH_MAX) {
> >> -                       err =3D -ENAMETOOLONG;
> >> +               len =3D get_pin_path(buf, PATH_MAX, map, opts, true);
> >> +               if (len =3D=3D 0) {
> >> +                       continue;
> >> +               } else if (len < 0) {
> >> +                       err =3D len;
> >>                         goto err_unpin_maps;
> >>                 }
> >>
> >> @@ -4104,7 +4158,16 @@ int bpf_object__pin_maps(struct bpf_object *obj=
, const char *path)
> >>         return err;
> >>  }
> >>
> >> -int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
> >> +int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
> >> +{
> >> +       LIBBPF_OPTS(bpf_object_pin_opts, opts,
> >> +                   .path_global =3D path,
> >> +                   .override_type =3D LIBBPF_PIN_GLOBAL);
> >
> > style nit: extra line between declaration and statements
> >
> >> +       return bpf_object__pin_maps_opts(obj, &opts);
> >> +}
> >> +
> >> +int bpf_object__unpin_maps_opts(struct bpf_object *obj,
> >> +                             struct bpf_object_pin_opts *opts)
> >>  {
> >>         struct bpf_map *map;
> >>         int err;
> >> @@ -4112,16 +4175,18 @@ int bpf_object__unpin_maps(struct bpf_object *=
obj, const char *path)
> >>         if (!obj)
> >>                 return -ENOENT;
> >>
> >> +       if (!OPTS_VALID(opts, bpf_object_pin_opts))
> >> +               return -EINVAL;
> >
> > specifying pin options for unpin operation looks cumbersome. We know
> > the pinned path, just use that and keep unpinning simple?
>
> You are right, but see above re: recreating pin paths on re-run.>
>
> -Toke
