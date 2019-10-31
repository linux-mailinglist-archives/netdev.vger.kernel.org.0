Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90404EB604
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 18:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbfJaRWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 13:22:33 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35787 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728686AbfJaRWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 13:22:33 -0400
Received: by mail-qk1-f195.google.com with SMTP id h6so7836198qkf.2;
        Thu, 31 Oct 2019 10:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oMfFzhVvoVWC2f8RdeEKTu5KlcXSKBqQpB/hPjE3vP8=;
        b=YXDM0HyLbZpWaDOVEiyWMcqnSon454PSwOIL3nFeD5GPSo5p0OF0m6/DyabsADznEh
         Ixp/ew78WxijD7Jqyp5eYENipq8QkGAXE0RWDfmR+pHqwwR/sMWJHr6MCQ8aTLiYqAp1
         fMQ+8tWrh3OdNXR37XHNhLRsRPKNy1OZLoG+8WAeGcBIRNhvYJ0DfNyGVx+uAa4q83zu
         jo3zpoJKnFupDMCSDiL6SZ9V9ksSNMYqJxLNSk4LOovrpiaQOMdDbb6LR1rwOYyq4F8K
         Kw3SoHEX556DOj2WizJ/EiF+8cnwivphveUPYZqxpOsJj5d8plO99tSCnBDbabpZeoOy
         Ptsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oMfFzhVvoVWC2f8RdeEKTu5KlcXSKBqQpB/hPjE3vP8=;
        b=K5H75aJ9SigG5yHzinKmhIL6Ub80b6GXj6sbJbltoFAxRVxIRCjXyRU7xH1/iT8fb1
         zQrEbdJqulpTn/1TpRVroQbYIJsrOubRWYni9GQCsVuEPnQuI0SDXw7fmLNzrrspuvY1
         IYNvTyK6wl0xQawitUlqCuzHNZgDgMTy5kDKV6iyaQdlJl4xKFB8wxVKLZ2WF5WSyq/5
         8ohWacW1APXvvLKxO5Z2ZAHKxOjujfvOcojLI/Yg+DvbGkmI4C7a8eQhBXaPHlUUmePz
         cQsQmJRBYNzBmoA3MH3Cp1lz1DjfGz5XNHekzvJXHAQClvg/Gkw4dCKIrg+GtC4Nf1/f
         E68w==
X-Gm-Message-State: APjAAAWEASYR8HUndZFYmVZR9yKCLPg720baWQ+AS9YWYIDs8RBmQCMo
        YY/M3dW601pR8soLGUjYHo8s1W/pdEd4swLnh80=
X-Google-Smtp-Source: APXvYqy+cO/4eyHBNJzJxQ0xbnCh5sxvIivJGzztAH7/0vkYxb07ULI1Mr6HYnMIBgQMw8XMh8L/RPCzGFacmkjP7ZQ=
X-Received: by 2002:a05:620a:1011:: with SMTP id z17mr6323716qkj.39.1572542551388;
 Thu, 31 Oct 2019 10:22:31 -0700 (PDT)
MIME-Version: 1.0
References: <157237796219.169521.2129132883251452764.stgit@toke.dk> <157237796448.169521.1399805620810530569.stgit@toke.dk>
In-Reply-To: <157237796448.169521.1399805620810530569.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 31 Oct 2019 10:22:20 -0700
Message-ID: <CAEf4BzZ4pRLhwX+5Hh1jKsEhBAkrZbC14rBgAVgUt1gf3qJ+KQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/5] libbpf: Store map pin path and status in
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

On Tue, Oct 29, 2019 at 12:39 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Support storing and setting a pin path in struct bpf_map, which can be us=
ed
> for automatic pinning. Also store the pin status so we can avoid attempts
> to re-pin a map that has already been pinned (or reused from a previous
> pinning).
>
> The behaviour of bpf_object__{un,}pin_maps() is changed so that if it is
> called with a NULL path argument (which was previously illegal), it will
> (un)pin only those maps that have a pin_path set.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Looks good, thanks! Just some minor things to fix up below.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/libbpf.c   |  164 +++++++++++++++++++++++++++++++++++-----=
------
>  tools/lib/bpf/libbpf.h   |    8 ++
>  tools/lib/bpf/libbpf.map |    3 +
>  3 files changed, 134 insertions(+), 41 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ce5ef3ddd263..fd11f6aeb32c 100644
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
> @@ -4025,47 +4027,119 @@ int bpf_map__pin(struct bpf_map *map, const char=
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
> +       if (map->pin_path) {
> +               if (path && strcmp(path, map->pin_path)) {
> +                       pr_warn("map '%s' already has pin path '%s' diffe=
rent from '%s'\n",
> +                               bpf_map__name(map), map->pin_path, path);
> +                       return -EINVAL;
> +               } else if (map->pinned) {
> +                       pr_debug("map '%s' already pinned at '%s'; not re=
-pinning\n",
> +                                bpf_map__name(map), map->pin_path);
> +                       return 0;
> +               }

`if (map->pinned)` check is the same in both branches, so I'd do it
first, before this map->pin_path if/else.

> +       } else {
> +               if (!path) {
> +                       pr_warn("missing a path to pin map '%s' at\n",
> +                               bpf_map__name(map));
> +                       return -EINVAL;
> +               } else if (map->pinned) {
> +                       pr_warn("map '%s' already pinned\n", bpf_map__nam=
e(map));
> +                       return -EEXIST;
> +               }
> +
> +               map->pin_path =3D strdup(path);
> +               if (!map->pin_path) {
> +                       err =3D -errno;
> +                       goto out_err;
> +               }
>         }
>

[...]

> +
> +       err =3D check_path(path);
> +       if (err)
> +               return err;
> +
>         err =3D unlink(path);
>         if (err !=3D 0)
>                 return -errno;
> -       pr_debug("unpinned map '%s'\n", path);
> +
> +       map->pinned =3D false;
> +       pr_debug("unpinned map from '%s' from '%s'\n", bpf_map__name(map)=
, path);

typo: extra from before map name?

>
>         return 0;
>  }
>

[...]

>
>         return err;
> @@ -4131,17 +4205,24 @@ int bpf_object__unpin_maps(struct bpf_object *obj=
, const char *path)
>                 return -ENOENT;
>
>         bpf_object__for_each_map(map, obj) {
> +               char *pin_path =3D NULL;
>                 char buf[PATH_MAX];

you can call buf as pin_path and get rid of extra pointer?

> -               int len;
>
> -               len =3D snprintf(buf, PATH_MAX, "%s/%s", path,
> -                              bpf_map__name(map));
> -               if (len < 0)
> -                       return -EINVAL;
> -               else if (len >=3D PATH_MAX)
> -                       return -ENAMETOOLONG;
> +               if (path) {
> +                       int len;
> +
> +                       len =3D snprintf(buf, PATH_MAX, "%s/%s", path,
> +                                      bpf_map__name(map));
> +                       if (len < 0)
> +                               return -EINVAL;
> +                       else if (len >=3D PATH_MAX)
> +                               return -ENAMETOOLONG;
> +                       pin_path =3D buf;
> +               } else if (!map->pin_path) {
> +                       continue;
> +               }
>
> -               err =3D bpf_map__unpin(map, buf);
> +               err =3D bpf_map__unpin(map, pin_path);
>                 if (err)
>                         return err;
>         }

[...]

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

we try to keep this list alphabetically sorted

>  } LIBBPF_0.0.5;
>
