Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642C8195E7A
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbgC0TSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:18:09 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:37550 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgC0TSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 15:18:09 -0400
Received: by mail-qv1-f67.google.com with SMTP id n1so5493387qvz.4;
        Fri, 27 Mar 2020 12:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VwCdC8pByNVHAX48x87PIRqfh9CGcN030y6wF8AKKEY=;
        b=idvSSnanBbaoWYK4bFRkKb3OA3h+26oo9paWJgbbz1z1GDnYXXmDz7c84+c3LqnBDG
         CyTiarQmxK0ASWiHKtk2PYO/pmHp7I3EP56J46eL1QtPp6xsiJmZ/OkZMeh4g+yXt3rn
         aOAlLC7j+fe+3MI1PX+Oy24jbUvKlCAsLwU5MCccLBS8KpQCeDCoNEtS3xz7+xb/dbuM
         +xmbTdzUPiIAZOHBVgCTqR9OB7sEJ7fydpl2zwJW+/7D+aAgOUQs6sVW7xZCdF7O3xcf
         DilZtktAYR6NwV+rJ+IZb3RK/ZG7InzdKYz4Qjr43ptD777/IdTmZHtgDGnDiKVXDDfT
         9jgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VwCdC8pByNVHAX48x87PIRqfh9CGcN030y6wF8AKKEY=;
        b=A6eyUmjVfcCg0MrDuz3AnCkb0WiS5lVDb9ENmkixLTaXVpAT3sIBKErNGbPp8GSL/m
         WZUO6eA3tkuMKecPDjEMUiVbBJY+rlZWF1VK28QHudA8f1nmkpLL1mPEwDiAWlxvS1al
         Iac3gexqjQAuHCKlLOndpmPy9E5S80Rqi+G3OiHp35K2CMVhTydzx7p8Ycb7Sdx4PzYA
         83qmbhyuXpM7ndHmF8rnNA9i4DMDupRTS2hRBY9Kk3rcDhtjpwuRbYqx46Dtnk0HG29b
         0+4qYjPMt/9K19faKPT8vIEBgQ0u7UBJyGBePWkDsi0YpAk88uyfLqqylmFX0jkeiud7
         DlgA==
X-Gm-Message-State: ANhLgQ1C5BIbrMwVpLgrpqAiQ9zsTlPtJwV6cEG/5WTRcSBW7ywPXnH7
        WTYDU60w9vktKmeUBIIsWEsVosCoqnx/vce3688=
X-Google-Smtp-Source: ADFU+vtiy2P2DXmmmtuqoeWJz2V5ww0YBj0CCPa9zN84HdGJ8O3WhEwcSXiLjvhLvSYv3lYhoGldN40Ebbm31GJPmNU=
X-Received: by 2002:a0c:8525:: with SMTP id n34mr789046qva.224.1585336686901;
 Fri, 27 Mar 2020 12:18:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200326151741.125427-1-toke@redhat.com> <20200327125818.155522-1-toke@redhat.com>
In-Reply-To: <20200327125818.155522-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 27 Mar 2020 12:17:56 -0700
Message-ID: <CAEf4BzbEyYQeLEsw0tzYYHeKi+q7a+vxavya9O3jykwsH3ki9g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: Add getter for pointer to data area
 for internal maps
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

On Fri, Mar 27, 2020 at 5:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> For internal maps (most notably the maps backing global variables), libbp=
f
> uses an internal mmaped area to store the data after opening the object.
> This data is subsequently copied into the kernel map when the object is
> loaded.
>
> This adds a getter for the pointer to that internal data store. This can =
be
> used to modify the data before it is loaded into the kernel, which is
> especially relevant for RODATA, which is frozen on load. This same pointe=
r
> is already exposed to the auto-generated skeletons, so access to it is
> already API; this just adds a way to get at it without pulling in the ful=
l
> skeleton infrastructure.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
> v2:
>   - Add per-map getter for data area instead of a global rodata getter fo=
r bpf_obj
>
> tools/lib/bpf/libbpf.c   | 9 +++++++++
>  tools/lib/bpf/libbpf.h   | 1 +
>  tools/lib/bpf/libbpf.map | 1 +
>  3 files changed, 11 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 085e41f9b68e..a0055f8908fd 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6756,6 +6756,15 @@ void *bpf_map__priv(const struct bpf_map *map)
>         return map ? map->priv : ERR_PTR(-EINVAL);
>  }
>
> +void *bpf_map__data_area(const struct bpf_map *map, size_t *size)

I'm not entirely thrilled about "data_area" name. This is entirely for
providing initial value for maps, so maybe something like
bpf_map__init_value() or something along those lines?

Actually, how about a different API altogether:

bpf_map__set_init_value(struct bpf_map *map, void *data, size_t size)?

Application will have to prepare data of correct size, which will be
copied to libbpf's internal storage. It also doesn't expose any of
internal pointer. I don't think extra memcopy is a big deal here.
Thoughts?


> +{
> +       if (map->mmaped && map->libbpf_type !=3D LIBBPF_MAP_KCONFIG) {
> +               *size =3D map->def.value_size;
> +               return map->mmaped;
> +       }
> +       return NULL;
> +}
> +
>  bool bpf_map__is_offload_neutral(const struct bpf_map *map)
>  {
>         return map->def.type =3D=3D BPF_MAP_TYPE_PERF_EVENT_ARRAY;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index d38d7a629417..baef0d2f3205 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -407,6 +407,7 @@ typedef void (*bpf_map_clear_priv_t)(struct bpf_map *=
, void *);
>  LIBBPF_API int bpf_map__set_priv(struct bpf_map *map, void *priv,
>                                  bpf_map_clear_priv_t clear_priv);
>  LIBBPF_API void *bpf_map__priv(const struct bpf_map *map);
> +LIBBPF_API void *bpf_map__data_area(const struct bpf_map *map, size_t *s=
ize);
>  LIBBPF_API int bpf_map__reuse_fd(struct bpf_map *map, int fd);
>  LIBBPF_API int bpf_map__resize(struct bpf_map *map, __u32 max_entries);
>  LIBBPF_API bool bpf_map__is_offload_neutral(const struct bpf_map *map);
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 5129283c0284..258528045a85 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -243,5 +243,6 @@ LIBBPF_0.0.8 {
>                 bpf_link__pin;
>                 bpf_link__pin_path;
>                 bpf_link__unpin;
> +               bpf_map__data_area;
>                 bpf_program__set_attach_target;
>  } LIBBPF_0.0.7;
> --
> 2.26.0
>
