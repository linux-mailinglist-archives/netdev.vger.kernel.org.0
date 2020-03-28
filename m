Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B2F19690C
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 21:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgC1UBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 16:01:22 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35919 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbgC1UBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 16:01:22 -0400
Received: by mail-qt1-f196.google.com with SMTP id m33so11767162qtb.3;
        Sat, 28 Mar 2020 13:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VZzCjb9q+eLm/MFNwpd1q7LlfqoQEdzpIA7cxtVJw24=;
        b=iay/TbK68+z2P3L+hg4XUSfLy7Vjui2vv2P7OYDynyKXjWOXt6j/AtwHUUzNEDVDuw
         481CLVx6q0SywOAAoLY7qpl/X1Gf62W4U78cqTb3Zdjkwc121DEWV+n1EtFMHJIRJJeH
         ygm1ZQ15PVWvEZvso9i5jWr0Lbl5JDn9PwyeVzxB8acL+t0q8Ov7Od0T2UjUzpEdGIvg
         vy/pDNvlF5Jf5EqEolXhJNSc14P00eIY5O42FsmWJDKDH6VA+1wti0uCIEM2MdcJteCh
         Ka6jvHHuZ3ximaVnCnuRkMreW01y/XQA7VNKF3Z5s3Sro3vJQN4mjpm0RVC6VXQJ2REW
         4log==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VZzCjb9q+eLm/MFNwpd1q7LlfqoQEdzpIA7cxtVJw24=;
        b=gZq/7hYA0SO9m5LsN8zbVU7Ig1TsYq5NdWBYqc1e3F4RLJ1GlNsS+u0P+3HycIWJcG
         w1C9uOfGgLfQFw4N8TgQBNAmRoi+2lurZekH0fTjmL1Npmt5/GXF/Npjvil6JgqpaJ3V
         xbwSqFtl9MhXB3A7++/iW4JltHuLBMvU+to9g6yeQe+8/ctK6OBLf4Oa/x0eUj6GfpGg
         YNXPH2aBzjRqVqqet8j2uB4avzoKHiKFSUHHXxDBK62dVElI0QHXcPPM6tMo0hN9S5Jl
         5itxOjxYcF5VFwFnOEWrBtRNpc8E230WtzvhV+g/4bjvm4eRPcgv7iB+z2KWm9qyxP4g
         cFfw==
X-Gm-Message-State: ANhLgQ3HNZlA2Py1llTRz4xq2Y4vUMUq8mQ2nR0ZX/au/DdZAhtFroLl
        f5YNr+yreau6iTGiMuWvdWpf5VklGwQy4Wq6HQ3Wbl1h
X-Google-Smtp-Source: ADFU+vuy6oRooaYic1esN0Dmi4VXfSabbGIC3SzRTGYTrgjrK7Lhx2METzUSMpXjmu9SFGurTRkugCrLSUqauHSS9IU=
X-Received: by 2002:ac8:1865:: with SMTP id n34mr4957820qtk.93.1585425679099;
 Sat, 28 Mar 2020 13:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200327125818.155522-1-toke@redhat.com> <20200328182834.196578-1-toke@redhat.com>
In-Reply-To: <20200328182834.196578-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 28 Mar 2020 13:01:08 -0700
Message-ID: <CAEf4BzaN5s_quON_pvPsoretOGSvFVffzCrSve+=7A_bw94asQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] libbpf: Add setter for initial value for internal maps
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 28, 2020 at 11:29 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> For internal maps (most notably the maps backing global variables), libbp=
f
> uses an internal mmaped area to store the data after opening the object.
> This data is subsequently copied into the kernel map when the object is
> loaded.
>
> This adds a function to set a new value for that data, which can be used =
to
> before it is loaded into the kernel. This is especially relevant for RODA=
TA
> maps, since those are frozen on load.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
> v3:
>   - Add a setter for the initial value instead of a getter for the pointe=
r to it
>   - Add selftest
> v2:
>   - Add per-map getter for data area instead of a global rodata getter fo=
r bpf_obj
>
>  tools/lib/bpf/libbpf.c   | 11 +++++++++++
>  tools/lib/bpf/libbpf.h   |  2 ++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 14 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 085e41f9b68e..f9953a8ffcfa 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6756,6 +6756,17 @@ void *bpf_map__priv(const struct bpf_map *map)
>         return map ? map->priv : ERR_PTR(-EINVAL);
>  }
>
> +int bpf_map__set_initial_value(struct bpf_map *map,
> +                              void *data, size_t size)

nit: const void *


> +{
> +       if (!map->mmaped || map->libbpf_type =3D=3D LIBBPF_MAP_KCONFIG ||
> +           size !=3D map->def.value_size)
> +               return -EINVAL;
> +

How about also checking that bpf_map wasn't yet created? Checking
map->fd >=3D 0 should be enough.

> +       memcpy(map->mmaped, data, size);
> +       return 0;
> +}
> +
>  bool bpf_map__is_offload_neutral(const struct bpf_map *map)
>  {
>         return map->def.type =3D=3D BPF_MAP_TYPE_PERF_EVENT_ARRAY;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index d38d7a629417..ee30ed487221 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -407,6 +407,8 @@ typedef void (*bpf_map_clear_priv_t)(struct bpf_map *=
, void *);
>  LIBBPF_API int bpf_map__set_priv(struct bpf_map *map, void *priv,
>                                  bpf_map_clear_priv_t clear_priv);
>  LIBBPF_API void *bpf_map__priv(const struct bpf_map *map);
> +LIBBPF_API int bpf_map__set_initial_value(struct bpf_map *map,
> +                                         void *data, size_t size);
>  LIBBPF_API int bpf_map__reuse_fd(struct bpf_map *map, int fd);
>  LIBBPF_API int bpf_map__resize(struct bpf_map *map, __u32 max_entries);
>  LIBBPF_API bool bpf_map__is_offload_neutral(const struct bpf_map *map);
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 5129283c0284..f46873b9fe5e 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -243,5 +243,6 @@ LIBBPF_0.0.8 {
>                 bpf_link__pin;
>                 bpf_link__pin_path;
>                 bpf_link__unpin;
> +               bpf_map__set_initial_value;
>                 bpf_program__set_attach_target;
>  } LIBBPF_0.0.7;
> --
> 2.26.0
>
