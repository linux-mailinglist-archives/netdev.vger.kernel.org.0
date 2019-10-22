Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36558E0B5B
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbfJVSUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:20:38 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38216 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfJVSUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:20:38 -0400
Received: by mail-qk1-f196.google.com with SMTP id p4so17196322qkf.5;
        Tue, 22 Oct 2019 11:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NgHB3vaf1yADKU8XivOI0GDeG2WM7GFgvNSAcX2nTYM=;
        b=fpnDrl4l7yFHWyu7FGou+V1EVS/B7DU3En8GxyL5gKQCHKm7O2l4KPtH5vPGNwg5BD
         QgjZsxPY6IjUiSdHmyOC+OY2rqji24e/gj8DY88dYsm+SaxUAplf22N5QHKqQ5tYwj5w
         ZXgIoQ7ayEIMh2+IGERm4Q9X2N9rusj/wLl2ib7AO/1WDjWUKyWb5TAzrl8/QbvPHt3x
         q++e7wFfeHwtJrBKFREZsVFgEq98wR8XLHJEiFM/7b9OUuSW1xJm/4GkzDB2WNMhMlBS
         RVRE3y0WJ74SnwCoDMS9QKTJ2N/kZkAhI08rswFxVImh1bFqS2/gI9I0NRKyHOXdSCJh
         pLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NgHB3vaf1yADKU8XivOI0GDeG2WM7GFgvNSAcX2nTYM=;
        b=KJfXeykn1y4oOuN2ZLRc1bXb2+3oW/JWqY24dKJCIiipv2Tl+XIPhGLt3dgd85r7GL
         3YxDYu18jZ+MEfyU+xwCsUXX/zOFf4ZqlrlL3sBQ5YMvbMbeTD7CFCVfVOFrr0Tw2izb
         +yZt+DTsl0aCZatr+8XlCwRTME5grROBbyXWUk1hk5g9vKcPqptS0S08WkBAnyICKt+3
         3TsGTWUFLzBfsoZsvb5supZLF+g2dlDOw1MTSTnvHhCKs/PAsUPyTRpIy+ZtnVfIw5Hz
         l3/76f6lQZ/SGawwH7Unz8BoGU4FL1mR+DBU+WNLpQ81aYg4q6EvK6Ed524WTF3ig5Y5
         cCGw==
X-Gm-Message-State: APjAAAXDb1gNGHuPB8BoJWhbl8vfhY2ML318073gImhpsfzMqBYxnEzp
        VLc5U8yUkINpd5RyMyUJhuCQI1MwiCXOsKywtqY=
X-Google-Smtp-Source: APXvYqytHFeFVpzxYPHNEA1NW/tQMTeLOcMRM84+Ynhk7QCLvhFyC7L4c44ZH/UdQrHXXxLoWscGyYfR+RVFJppqizk=
X-Received: by 2002:a37:b447:: with SMTP id d68mr4425124qkf.437.1571768436248;
 Tue, 22 Oct 2019 11:20:36 -0700 (PDT)
MIME-Version: 1.0
References: <157175668770.112621.17344362302386223623.stgit@toke.dk> <157175668991.112621.14204565208520782920.stgit@toke.dk>
In-Reply-To: <157175668991.112621.14204565208520782920.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Oct 2019 11:20:24 -0700
Message-ID: <CAEf4BzaM32j4iLhvcuwMS+dPDBd52KwviwJuoAwVVr8EwoRpHA@mail.gmail.com>
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

On Tue, Oct 22, 2019 at 9:08 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds support to libbpf for setting map pinning information as part o=
f
> the BTF map declaration. We introduce a new pair of functions to pin and
> unpin maps based on this setting, as well as a getter and setter function
> for the pin information that callers can use after map load.
>
> The pin_type supports two modes: LOCAL pinning, which requires the caller
> to set a pin path using bpf_object_pin_opts, and a global mode, where the
> path can still be overridden, but defaults to /sys/fs/bpf. This is inspir=
ed
> by the two modes supported by the iproute2 map definitions. In particular=
,
> it should be possible to express the current iproute2 operating mode in
> terms of the options introduced here.
>
> The new pin functions will skip any maps that do not have a pinning type
> set, unless the 'override_type' option is set, in which case all maps wil=
l
> be pinning using the pin type set in that option. This also makes it
> possible to express the old pin_maps and unpin_maps functions in terms of
> the new option-based functions.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

So few high-level thoughts.

1. I'd start with just NONE and GLOBAL as two pinning modes. It might
be worth-while to name GLOBAL something different just to specify that
it is just pinning, either to default /sys/fs/bpf root or some other
user-provided root path.
1a. LOCAL seems to behave exactly like GLOBAL, just uses separate
option for a path. So we effectively have two GLOBAL modes, one with
default (but overrideable) /sys/fs/bpf, another with user-provided
mandatory path. The distinction seem rather small and arbitrary.
What's the use case?
2. When is pin type override useful? Either specify it once
declaratively in map definition, or just do pinning programmatically?
3. I think we should make pinning path override into
bpf_object_open_opts and keep bpf_object__pin_maps simple. We are
probably going to make map pinning/sharing automatic anyway, so that
will need to happen as part of either open or load operation.
4. Once pinned, map knows its pinned path, just use that, I don't see
any reasonable use case where you'd want to override path just for
unpinning.

Does it make sense?

>  tools/lib/bpf/bpf_helpers.h |    8 +++
>  tools/lib/bpf/libbpf.c      |  123 ++++++++++++++++++++++++++++++++++++-=
------
>  tools/lib/bpf/libbpf.h      |   33 ++++++++++++
>  tools/lib/bpf/libbpf.map    |    4 +
>  4 files changed, 148 insertions(+), 20 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 2203595f38c3..a23cf55d41b1 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -38,4 +38,12 @@ struct bpf_map_def {
>         unsigned int map_flags;
>  };
>
> +enum libbpf_pin_type {
> +       LIBBPF_PIN_NONE,
> +       /* PIN_LOCAL: pin maps by name in path specified by caller */
> +       LIBBPF_PIN_LOCAL,

Daniel mentioned in previous discussions that LOCAL mode is never
used. I'd like to avoid supporting unnecessary stuff. Is it really
useful?

> +       /* PIN_GLOBAL: pin maps by name in global path (/sys/fs/bpf by de=
fault) */
> +       LIBBPF_PIN_GLOBAL,
> +};
> +
>  #endif
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index b4fdd8ee3bbd..aea3916de341 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -226,6 +226,7 @@ struct bpf_map {
>         void *priv;
>         bpf_map_clear_priv_t clear_priv;
>         enum libbpf_map_type libbpf_type;
> +       enum libbpf_pin_type pinning;
>         char *pin_path;
>  };
>
> @@ -1270,6 +1271,22 @@ static int bpf_object__init_user_btf_map(struct bp=
f_object *obj,
>                         }
>                         map->def.value_size =3D sz;
>                         map->btf_value_type_id =3D t->type;
> +               } else if (strcmp(name, "pinning") =3D=3D 0) {
> +                       __u32 val;
> +
> +                       if (!get_map_field_int(map_name, obj->btf, def, m=
,
> +                                              &val))
> +                               return -EINVAL;
> +                       pr_debug("map '%s': found pinning =3D %u.\n",
> +                                map_name, val);
> +
> +                       if (val && val !=3D LIBBPF_PIN_LOCAL &&
> +                           val !=3D LIBBPF_PIN_GLOBAL) {

let's write out LIBBPF_PIN_NONE explicitly, instead of just `val`?

> +                               pr_warning("map '%s': invalid pinning val=
ue %u.\n",
> +                                          map_name, val);
> +                               return -EINVAL;
> +                       }
> +                       map->pinning =3D val;
>                 } else {
>                         if (strict) {
>                                 pr_warning("map '%s': unknown field '%s'.=
\n",
> @@ -4055,10 +4072,51 @@ int bpf_map__unpin(struct bpf_map *map, const cha=
r *path)
>         return 0;
>  }
>
> -int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
> +static int get_pin_path(char *buf, size_t buf_len,
> +                       struct bpf_map *map, struct bpf_object_pin_opts *=
opts,
> +                       bool mkdir)
> +{
> +       enum libbpf_pin_type type;
> +       const char *path;
> +       int err, len;
> +
> +       type =3D OPTS_GET(opts, override_type, 0) ?: map->pinning;
> +
> +       if (type =3D=3D LIBBPF_PIN_GLOBAL) {
> +               path =3D OPTS_GET(opts, path_global, NULL);
> +               if (!path)
> +                       path =3D "/sys/fs/bpf";
> +       } else if (type =3D=3D LIBBPF_PIN_LOCAL) {
> +               path =3D OPTS_GET(opts, path_local, NULL);
> +               if (!path) {
> +                       pr_warning("map '%s' set pinning to PIN_LOCAL, "
> +                                  "but no local path provided. Skipping.=
\n",
> +                                  bpf_map__name(map));
> +                       return 0;
> +               }
> +       } else {
> +               return 0;
> +       }
> +
> +       if (mkdir) {
> +               err =3D make_dir(path);
> +               if (err)
> +                       return err;
> +       }
> +
> +       len =3D snprintf(buf, buf_len, "%s/%s", path, bpf_map__name(map))=
;
> +       if (len < 0)
> +               return -EINVAL;
> +       else if (len >=3D buf_len)
> +               return -ENAMETOOLONG;
> +       return len;
> +}
> +
> +int bpf_object__pin_maps_opts(struct bpf_object *obj,
> +                             struct bpf_object_pin_opts *opts)
>  {
>         struct bpf_map *map;
> -       int err;
> +       int err, len;
>
>         if (!obj)
>                 return -ENOENT;
> @@ -4068,21 +4126,17 @@ int bpf_object__pin_maps(struct bpf_object *obj, =
const char *path)
>                 return -ENOENT;
>         }
>
> -       err =3D make_dir(path);
> -       if (err)
> -               return err;
> +       if (!OPTS_VALID(opts, bpf_object_pin_opts))
> +               return -EINVAL;
>
>         bpf_object__for_each_map(map, obj) {
>                 char buf[PATH_MAX];
> -               int len;
>
> -               len =3D snprintf(buf, PATH_MAX, "%s/%s", path,
> -                              bpf_map__name(map));
> -               if (len < 0) {
> -                       err =3D -EINVAL;
> -                       goto err_unpin_maps;
> -               } else if (len >=3D PATH_MAX) {
> -                       err =3D -ENAMETOOLONG;
> +               len =3D get_pin_path(buf, PATH_MAX, map, opts, true);
> +               if (len =3D=3D 0) {
> +                       continue;
> +               } else if (len < 0) {
> +                       err =3D len;
>                         goto err_unpin_maps;
>                 }
>
> @@ -4104,7 +4158,16 @@ int bpf_object__pin_maps(struct bpf_object *obj, c=
onst char *path)
>         return err;
>  }
>
> -int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
> +int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
> +{
> +       LIBBPF_OPTS(bpf_object_pin_opts, opts,
> +                   .path_global =3D path,
> +                   .override_type =3D LIBBPF_PIN_GLOBAL);

style nit: extra line between declaration and statements

> +       return bpf_object__pin_maps_opts(obj, &opts);
> +}
> +
> +int bpf_object__unpin_maps_opts(struct bpf_object *obj,
> +                             struct bpf_object_pin_opts *opts)
>  {
>         struct bpf_map *map;
>         int err;
> @@ -4112,16 +4175,18 @@ int bpf_object__unpin_maps(struct bpf_object *obj=
, const char *path)
>         if (!obj)
>                 return -ENOENT;
>
> +       if (!OPTS_VALID(opts, bpf_object_pin_opts))
> +               return -EINVAL;

specifying pin options for unpin operation looks cumbersome. We know
the pinned path, just use that and keep unpinning simple?

> +
>         bpf_object__for_each_map(map, obj) {
>                 char buf[PATH_MAX];
>                 int len;
>
> -               len =3D snprintf(buf, PATH_MAX, "%s/%s", path,
> -                              bpf_map__name(map));
> -               if (len < 0)
> -                       return -EINVAL;
> -               else if (len >=3D PATH_MAX)
> -                       return -ENAMETOOLONG;
> +               len =3D get_pin_path(buf, PATH_MAX, map, opts, false);
> +               if (len =3D=3D 0)
> +                       continue;
> +               else if (len < 0)
> +                       return len;

this whole logic should be replaced with just map->pin_path or am I
missing some important use case?

>
>                 err =3D bpf_map__unpin(map, buf);
>                 if (err)
> @@ -4131,6 +4196,14 @@ int bpf_object__unpin_maps(struct bpf_object *obj,=
 const char *path)
>         return 0;
>  }
>
> +int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
> +{
> +       LIBBPF_OPTS(bpf_object_pin_opts, opts,
> +                   .path_global =3D path,
> +                   .override_type =3D LIBBPF_PIN_GLOBAL);

same styling nit

> +       return bpf_object__unpin_maps_opts(obj, &opts);
> +}
> +
>  int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
>  {
>         struct bpf_program *prog;
> @@ -4782,6 +4855,16 @@ void bpf_map__set_ifindex(struct bpf_map *map, __u=
32 ifindex)
>         map->map_ifindex =3D ifindex;
>  }
>
> +void bpf_map__set_pinning(struct bpf_map *map, enum libbpf_pin_type pinn=
ing)
> +{
> +       map->pinning =3D pinning;
> +}
> +
> +enum libbpf_pin_type bpf_map__get_pinning(struct bpf_map *map)
> +{
> +       return map->pinning;
> +}
> +
>  int bpf_map__set_inner_map_fd(struct bpf_map *map, int fd)
>  {
>         if (!bpf_map_type__is_map_in_map(map->def.type)) {
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 53ce212764e0..2131eeafb18d 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -119,9 +119,40 @@ int bpf_object__section_size(const struct bpf_object=
 *obj, const char *name,
>                              __u32 *size);
>  int bpf_object__variable_offset(const struct bpf_object *obj, const char=
 *name,
>                                 __u32 *off);
> +
> +enum libbpf_pin_type {
> +       LIBBPF_PIN_NONE,
> +       /* PIN_LOCAL: pin maps by name in path specified by caller */
> +       LIBBPF_PIN_LOCAL,
> +       /* PIN_GLOBAL: pin maps by name in global path (/sys/fs/bpf by de=
fault) */
> +       LIBBPF_PIN_GLOBAL,
> +};
> +
> +struct bpf_object_pin_opts {
> +       /* size of this struct, for forward/backward compatiblity */
> +       size_t sz;
> +
> +       /* Paths to pin maps setting PIN_GLOBAL and PIN_LOCAL auto-pin op=
tion.
> +        * The global path defaults to /sys/fs/bpf, while the local path =
has
> +        * no default (so the option must be set if that pin type is used=
).
> +        */
> +       const char *path_global;
> +       const char *path_local;
> +
> +       /* If set, the pin type specified in map definitions will be igno=
red,
> +        * and this type used for all maps instead.
> +        */
> +       enum libbpf_pin_type override_type;
> +};
> +#define bpf_object_pin_opts__last_field override_type
> +
>  LIBBPF_API int bpf_object__pin_maps(struct bpf_object *obj, const char *=
path);
>  LIBBPF_API int bpf_object__unpin_maps(struct bpf_object *obj,
>                                       const char *path);
> +LIBBPF_API int bpf_object__pin_maps_opts(struct bpf_object *obj,
> +                                        struct bpf_object_pin_opts *opts=
);
> +LIBBPF_API int bpf_object__unpin_maps_opts(struct bpf_object *obj,
> +                                          struct bpf_object_pin_opts *op=
ts);
>  LIBBPF_API int bpf_object__pin_programs(struct bpf_object *obj,
>                                         const char *path);
>  LIBBPF_API int bpf_object__unpin_programs(struct bpf_object *obj,
> @@ -377,6 +408,8 @@ LIBBPF_API bool bpf_map__is_internal(const struct bpf=
_map *map);
>  LIBBPF_API void bpf_map__set_ifindex(struct bpf_map *map, __u32 ifindex)=
;
>  LIBBPF_API int bpf_map__pin(struct bpf_map *map, const char *path);
>  LIBBPF_API int bpf_map__unpin(struct bpf_map *map, const char *path);
> +LIBBPF_API enum libbpf_pin_type bpf_map__get_pinning(struct bpf_map *map=
);
> +LIBBPF_API void bpf_map__set_pinning(struct bpf_map *map, enum libbpf_pi=
n_type);
>
>  LIBBPF_API int bpf_map__set_inner_map_fd(struct bpf_map *map, int fd);
>
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 4d241fd92dd4..d0aacb3e14fb 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -195,4 +195,8 @@ LIBBPF_0.0.6 {
>         global:
>                 bpf_object__open_file;
>                 bpf_object__open_mem;
> +               bpf_object__pin_maps_opts;
> +               bpf_object__unpin_maps_opts;
> +               bpf_map__get_pinning;
> +               bpf_map__set_pinning;
>  } LIBBPF_0.0.5;
>
