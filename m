Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A31E7862
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 19:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404395AbfJ1SY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 14:24:56 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46224 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403837AbfJ1SY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 14:24:56 -0400
Received: by mail-qt1-f194.google.com with SMTP id u22so15943063qtq.13;
        Mon, 28 Oct 2019 11:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3zJwbQM+m0kNvyytSzMYQCGjR91jpmPC53JHF6JCkJw=;
        b=GnWrfbrkLJpI7l0hIshwUUtOh3YnRBzI69WyEMTYgcxyTXSFYWzpL+EwL+Atmncw5+
         VXBRAOcenjJs675QPRnJn7OXxDHnQ6mA3yPwFwA5RMqtkD/X6j/G++97dtJyn0PtuZvy
         MchZBOtNhRsqnp6EzU+/7YPaIVBHA+5wMBRkVE7+77ft3y3yXoU6twYcUHOIaLSRUr1V
         zAid2zAd2OO+T8N+r6+8htpQ8zo6Q2doMDDaMNLqtc7n+YvJ2ZiY1vD97nGVQGRt/qVI
         83DDX9AcXjI/Btl4GFRSVo6dBvOo6WPSDlEmg7NbGYePHLox9G/NQCh+NSF3c+2rDQO5
         UFPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3zJwbQM+m0kNvyytSzMYQCGjR91jpmPC53JHF6JCkJw=;
        b=pT3aZd2PWaVKw4fIb+urJqigDpa1rsH4jaDJU1TTu0NLItdY8euW0gIH98txE18VMq
         bBfGC9TKbRDHHUqrSDxMwE9/mJasTc/kBjbbSEErU4uEtkRoCCR3UFT2KOEsIvuP7CNP
         4giki6iMx8i8exvgiUc1ncD7902KohIob4HoYMsYpA5KwP61sFQF7PU6D2r6ej7SqeZ8
         pxAN4l9tpdUx58WOxGljd3fwAyRfmY62Sec0KKJDnUNfIdhkRgRxis30pa0lNc6dNJmG
         UZev4IBpNWTcm0uQrus6o/7X7+1Uygxcd2HhzVVLpt383hysNqYW4MAz+0Eb33Sr8bhk
         NoFQ==
X-Gm-Message-State: APjAAAXBerwF4b6eMc0P+gT1y0o+1mjw+IEG4MLsF8+1OvIX5Rv2vF29
        FVTPEjbGXjUzXpWTzROgOjC1sdKUpUVRTLps01k=
X-Google-Smtp-Source: APXvYqwVr+pX1yxAjX5Uje0kXjEQ67gHodrRpyfM26K/C7SHVeanTaiYey/X8bEIpgxlJktGQ21l0rT4TMQfcXnzscQ=
X-Received: by 2002:ac8:108e:: with SMTP id a14mr18360542qtj.171.1572287093851;
 Mon, 28 Oct 2019 11:24:53 -0700 (PDT)
MIME-Version: 1.0
References: <157220959547.48922.6623938299823744715.stgit@toke.dk> <157220959873.48922.4763375792594816553.stgit@toke.dk>
In-Reply-To: <157220959873.48922.4763375792594816553.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 28 Oct 2019 11:24:42 -0700
Message-ID: <CAEf4BzYoEPKNFnzOEAhhE2w=U11cYfTN4o_23kjzY4ByEt5y-g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/4] libbpf: Add auto-pinning of maps when
 loading BPF objects
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

On Sun, Oct 27, 2019 at 1:53 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds support to libbpf for setting map pinning information as part o=
f
> the BTF map declaration, to get automatic map pinning (and reuse) on load=
.
> The pinning type currently only supports a single PIN_BY_NAME mode, where
> each map will be pinned by its name in a path that can be overridden, but
> defaults to /sys/fs/bpf.
>
> Since auto-pinning only does something if any maps actually have a
> 'pinning' BTF attribute set, we default the new option to enabled, on the
> assumption that seamless pinning is what most callers want.
>
> When a map has a pin_path set at load time, libbpf will compare the map
> pinned at that location (if any), and if the attributes match, will re-us=
e
> that map instead of creating a new one. If no existing map is found, the
> newly created map will instead be pinned at the location.
>
> Programs wanting to customise the pinning can override the pinning paths
> using bpf_map__set_pin_path() before calling bpf_object__load() (includin=
g
> setting it to NULL to disable pinning of a particular map).
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/bpf_helpers.h |    6 ++
>  tools/lib/bpf/libbpf.c      |  142 +++++++++++++++++++++++++++++++++++++=
+++++-
>  tools/lib/bpf/libbpf.h      |   11 +++
>  3 files changed, 154 insertions(+), 5 deletions(-)
>

[...]

>
> -static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_ma=
ps)
> +static int bpf_object__build_map_pin_paths(struct bpf_object *obj,
> +                                          const char *path)
> +{
> +       struct bpf_map *map;
> +
> +       if (!path)
> +               path =3D "/sys/fs/bpf";
> +
> +       bpf_object__for_each_map(map, obj) {
> +               char buf[PATH_MAX];
> +               int err, len;
> +
> +               if (map->pinning !=3D LIBBPF_PIN_BY_NAME)
> +                       continue;

still think it's better be done from map definition parsing code
instead of a separate path, which will ignore most of maps anyways (of
course by extracting this whole buffer creation logic into a
function).


> +
> +               len =3D snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map__n=
ame(map));
> +               if (len < 0)
> +                       return -EINVAL;
> +               else if (len >=3D PATH_MAX)

[...]

>         return 0;
>  }
>
> +static bool map_is_reuse_compat(const struct bpf_map *map,
> +                               int map_fd)

nit: this should fit on single line?

> +{
> +       struct bpf_map_info map_info =3D {};
> +       char msg[STRERR_BUFSIZE];
> +       __u32 map_info_len;
> +
> +       map_info_len =3D sizeof(map_info);
> +
> +       if (bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len)) {
> +               pr_warn("failed to get map info for map FD %d: %s\n",
> +                       map_fd, libbpf_strerror_r(errno, msg, sizeof(msg)=
));
> +               return false;
> +       }
> +
> +       return (map_info.type =3D=3D map->def.type &&
> +               map_info.key_size =3D=3D map->def.key_size &&
> +               map_info.value_size =3D=3D map->def.value_size &&
> +               map_info.max_entries =3D=3D map->def.max_entries &&
> +               map_info.map_flags =3D=3D map->def.map_flags &&
> +               map_info.btf_key_type_id =3D=3D map->btf_key_type_id &&
> +               map_info.btf_value_type_id =3D=3D map->btf_value_type_id)=
;

If map was pinned by older version of the same app, key and value type
id are probably gonna be different, even if the type definition itself
it correct. We probably shouldn't check that?

> +}
> +
> +static int
> +bpf_object__reuse_map(struct bpf_map *map)
> +{
> +       char *cp, errmsg[STRERR_BUFSIZE];
> +       int err, pin_fd;
> +
> +       pin_fd =3D bpf_obj_get(map->pin_path);
> +       if (pin_fd < 0) {
> +               if (errno =3D=3D ENOENT) {
> +                       pr_debug("found no pinned map to reuse at '%s'\n"=
,
> +                                map->pin_path);
> +                       return 0;
> +               }
> +
> +               cp =3D libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
> +               pr_warn("couldn't retrieve pinned map '%s': %s\n",
> +                       map->pin_path, cp);
> +               return -errno;

store errno locally


> +       }
> +
> +       if (!map_is_reuse_compat(map, pin_fd)) {
> +               pr_warn("couldn't reuse pinned map at '%s': "
> +                       "parameter mismatch\n", map->pin_path);
> +               close(pin_fd);
> +               return -EINVAL;
> +       }
> +
> +       err =3D bpf_map__reuse_fd(map, pin_fd);
> +       if (err) {
> +               close(pin_fd);
> +               return err;
> +       }
> +       map->pinned =3D true;
> +       pr_debug("reused pinned map at '%s'\n", map->pin_path);
> +
> +       return 0;
> +}
> +

[...]

> +enum libbpf_pin_type {
> +       LIBBPF_PIN_NONE,
> +       /* PIN_BY_NAME: pin maps by name (in /sys/fs/bpf by default) */
> +       LIBBPF_PIN_BY_NAME,
> +};
> +
>  LIBBPF_API int bpf_object__pin_maps(struct bpf_object *obj, const char *=
path);

pin_maps should take into account opts->auto_pin_path, shouldn't it?

Which is why I also think that auto_pin_path is bad name, because it's
not only for auto-pinning, it's a pinning root path, so something like
pin_root_path or just pin_root is better and less misleading name.



>  LIBBPF_API int bpf_object__unpin_maps(struct bpf_object *obj,
>                                       const char *path);
>
