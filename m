Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD1AE785C
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 19:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404377AbfJ1SYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 14:24:31 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41516 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403849AbfJ1SYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 14:24:31 -0400
Received: by mail-qt1-f196.google.com with SMTP id o3so15982956qtj.8;
        Mon, 28 Oct 2019 11:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zr9P1o4/O3fVm0M+OQi3P7XrncV2O46QblwhEEemxH0=;
        b=YkIrS7uq/8ASI/M81rbU50sGOElERR+lAtQgI/+dhUqIFkSXXqcEBch6UyGWmESCAZ
         awuXTBuQGQCXKqCVVCtrCMvY1frLP1EcFd47mVDaAfwWe41vaq/RaYpXbjeACvWGAlHB
         iacK5ztk7oz6xYo77qqIekQMigaIWCY00XHvJ5+tyZuDMPiBWrRnisNmF+egzplrCE7M
         DF/dZB95ZoAMN5y+uoDy7GbPnn4s/x/xD8Clx929IBj/kSYlFkLJuxJ+bj7ijT8R/FgD
         cjBDDhsni3lJU3LDAVJk+5RVDEmf2blMdObMXURIyxSLq4PcDOvdVUATGYX7c8bf8Lmx
         YOKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zr9P1o4/O3fVm0M+OQi3P7XrncV2O46QblwhEEemxH0=;
        b=rEyqQ79l02pzIempXf5K9WZy2hX0H1eDKDE0wVqHTpaHiqZsBd6PxkFMJucVmwgTJd
         r7H5t3dyevXrZT4oUqqBnuLuWUEeRHI5xp0nYt2LVnc6uNBtX/w5rFGxUVXZOsWsw3bY
         0XRK5JHXjeN33u7vJCQ5dSF14juJHg0LZLxxEjCBpyHyDJSyYS7ZlGPzXuyOI1kixQlN
         v8NO6jE5qDFW3/7dRz3GyExZI48xCPwoyq+UyNiNTscUq4QUSQ1XYG62DAfL6vdsKwI4
         MgW6OzfVqmpDKHSE7cTPCZGjnMw6MFI7S7KLyVbOTL3KGryQ0buZdhq7x+X1HH3sRkHi
         MCdg==
X-Gm-Message-State: APjAAAXyWHCUE5ws8NaCV41MXAxaY5Y5Kmsdp85kn38xgxMpotSfh3C1
        UAXsz9OONO9jT31ubyUIPybmU+y8Ef7Qsvvf+80QsX5s
X-Google-Smtp-Source: APXvYqx+2sA9nX87rpi9o/SuexLIvMgKvfHw9VRA1zbf9t9VtoK39dldD9vaWTyq8KFKTMalD/ET2WuDaYfYcg6dck8=
X-Received: by 2002:a05:6214:2aa:: with SMTP id m10mr16816216qvv.224.1572287069969;
 Mon, 28 Oct 2019 11:24:29 -0700 (PDT)
MIME-Version: 1.0
References: <157220959547.48922.6623938299823744715.stgit@toke.dk> <157220959765.48922.14916417301812812065.stgit@toke.dk>
In-Reply-To: <157220959765.48922.14916417301812812065.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 28 Oct 2019 11:24:18 -0700
Message-ID: <CAEf4Bzb-CewiZhsGEmSNSCGHLKQiXFO3gS+cJgD1Tx_L_gpiMg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/4] libbpf: Store map pin path and status in
 struct bpf_map
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
> Support storing and setting a pin path in struct bpf_map, which can be us=
ed
> for automatic pinning. Also store the pin status so we can avoid attempts
> to re-pin a map that has already been pinned (or reused from a previous
> pinning).
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/libbpf.c   |  115 ++++++++++++++++++++++++++++++++++++----=
------
>  tools/lib/bpf/libbpf.h   |    3 +
>  tools/lib/bpf/libbpf.map |    3 +
>  3 files changed, 97 insertions(+), 24 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ce5ef3ddd263..eb1c5e6ad4a3 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -226,6 +226,8 @@ struct bpf_map {
>         void *priv;
>         bpf_map_clear_priv_t clear_priv;
>         enum libbpf_map_type libbpf_type;
> +       char *pin_path;
> +       bool pinned;
>  };
>
>  struct bpf_secdata {
> @@ -4025,47 +4027,118 @@ int bpf_map__pin(struct bpf_map *map, const char=
 *path)
>         char *cp, errmsg[STRERR_BUFSIZE];
>         int err;
>
> -       err =3D check_path(path);
> -       if (err)
> -               return err;
> -
>         if (map =3D=3D NULL) {
>                 pr_warn("invalid map pointer\n");
>                 return -EINVAL;
>         }
>
> -       if (bpf_obj_pin(map->fd, path)) {
> -               cp =3D libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
> -               pr_warn("failed to pin map: %s\n", cp);
> -               return -errno;
> +       if (map->pinned) {
> +               pr_warn("map already pinned\n");

it would be helpful to print the name of the map, otherwise user will
have to guess

> +               return -EEXIST;
> +       }
> +
> +       if (path && map->pin_path && strcmp(path, map->pin_path)) {
> +               pr_warn("map already has pin path '%s' different from '%s=
'\n",
> +                       map->pin_path, path);

here pin_path probably would be unique enough, but for consistency we
might want to print map name as well

> +               return -EINVAL;
> +       }
> +
> +       if (!map->pin_path && !path) {
> +               pr_warn("missing pin path\n");

and here?

> +               return -EINVAL;
>         }
>
> -       pr_debug("pinned map '%s'\n", path);
> +       if (!map->pin_path) {
> +               map->pin_path =3D strdup(path);
> +               if (!map->pin_path) {
> +                       err =3D -errno;
> +                       goto out_err;
> +               }
> +       }

There is a bit of repetition of if conditions, based on whether we
have map->pin_path set (which is the most critical piece we care
about), so that makes it a bit harder to follow what's going on. How
about this structure, would it make a bit clearer what the error
conditions are? Not insisting, though.

if (map->pin_path) {
  if (path && strcmp(...))
    bad, exit
else { /* no pin_path */
  if (!path)
    very bad, exit
  map->pin_path =3D strdup(..)
  if (!map->pin_path)
    also bad, exit
}


> +
> +       err =3D check_path(map->pin_path);
> +       if (err)
> +               return err;
> +

[...]

>
> +int bpf_map__set_pin_path(struct bpf_map *map, const char *path)
> +{
> +       char *old =3D map->pin_path, *new;
> +
> +       if (path) {
> +               new =3D strdup(path);
> +               if (!new)
> +                       return -errno;
> +       } else {
> +               new =3D NULL;
> +       }
> +
> +       map->pin_path =3D new;
> +       if (old)
> +               free(old);

you don't really need old, just free map->pin_path before setting it
to new. Also assigning new =3D NULL will simplify if above.

> +
> +       return 0;
> +}
> +
> +const char *bpf_map__get_pin_path(struct bpf_map *map)
> +{
> +       return map->pin_path;
> +}
> +
> +bool bpf_map__is_pinned(struct bpf_map *map)
> +{
> +       return map->pinned;
> +}
> +
>  int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
>  {
>         struct bpf_map *map;
> @@ -4106,17 +4179,10 @@ int bpf_object__pin_maps(struct bpf_object *obj, =
const char *path)

I might have missed something the change in some other patch, but
shouldn't pin_maps ignore already pinned maps? Otherwise we'll be
generating unnecessary warnings?

>
>  err_unpin_maps:
>         while ((map =3D bpf_map__prev(map, obj))) {
> -               char buf[PATH_MAX];
> -               int len;
> -
> -               len =3D snprintf(buf, PATH_MAX, "%s/%s", path,
> -                              bpf_map__name(map));
> -               if (len < 0)
> -                       continue;
> -               else if (len >=3D PATH_MAX)
> +               if (!map->pin_path)
>                         continue;
>
> -               bpf_map__unpin(map, buf);
> +               bpf_map__unpin(map, NULL);

so this will unpin auto-pinned maps (from BTF-defined maps). Is that
the desired behavior? I guess it might be ok (if you can't pin all of
your maps, you should probably clean all of them up?), but just
bringing it up.


>         }
>
>         return err;
> @@ -4266,6 +4332,7 @@ void bpf_object__close(struct bpf_object *obj)
>
>         for (i =3D 0; i < obj->nr_maps; i++) {
>                 zfree(&obj->maps[i].name);
> +               zfree(&obj->maps[i].pin_path);
>                 if (obj->maps[i].clear_priv)
>                         obj->maps[i].clear_priv(&obj->maps[i],
>                                                 obj->maps[i].priv);
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index c63e2ff84abc..a514729c43f5 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -385,6 +385,9 @@ LIBBPF_API int bpf_map__resize(struct bpf_map *map, _=
_u32 max_entries);
>  LIBBPF_API bool bpf_map__is_offload_neutral(const struct bpf_map *map);
>  LIBBPF_API bool bpf_map__is_internal(const struct bpf_map *map);
>  LIBBPF_API void bpf_map__set_ifindex(struct bpf_map *map, __u32 ifindex)=
;
> +LIBBPF_API int bpf_map__set_pin_path(struct bpf_map *map, const char *pa=
th);
> +LIBBPF_API const char *bpf_map__get_pin_path(struct bpf_map *map);
> +LIBBPF_API bool bpf_map__is_pinned(struct bpf_map *map);
>  LIBBPF_API int bpf_map__pin(struct bpf_map *map, const char *path);
>  LIBBPF_API int bpf_map__unpin(struct bpf_map *map, const char *path);
>
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index d1473ea4d7a5..c24d4c01591d 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -197,4 +197,7 @@ LIBBPF_0.0.6 {
>                 bpf_object__open_mem;
>                 bpf_program__get_expected_attach_type;
>                 bpf_program__get_type;
> +               bpf_map__get_pin_path;
> +               bpf_map__set_pin_path;
> +               bpf_map__is_pinned;
>  } LIBBPF_0.0.5;
>
