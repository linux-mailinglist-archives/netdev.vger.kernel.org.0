Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27EBF19475E
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 20:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgCZTVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 15:21:00 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34037 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgCZTVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 15:21:00 -0400
Received: by mail-qt1-f194.google.com with SMTP id 10so6497275qtp.1;
        Thu, 26 Mar 2020 12:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HAjvIejxKmNjPK8xaE5pZZ0JnF4kYI7QIVLserAjHe4=;
        b=Z3LIuYZt+n7S92gF/IP6Km1xRIyvFde9v4VcFkGdnUmtz3xpDoDu9/tNbJsPL2U+Ce
         +eSGAJx/fn3KnYdf+oA9PnyGzy31ALruOjZF2NfzxdiYzo8CMaYJr3kv8C2xdzG18l1B
         z3dtkap3c9vm8Na/4qn0qtfnPR/ec7ktm6pFGuCBU1HOe+Bcle+we5hPwmsTPML9a6Jz
         LHqvF3VkRE5U7ZW/L9y46ixQsQgPCLb8T9L1pRuhls4Tq6XwFvP/dXQxna46NkK50s4Y
         NuQkKKb5NwIActV26JQ/0wLv62QFmp73ZZtV/pbUB472FsnGDGnAeTqg9AyJPnTkf9rQ
         uDBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HAjvIejxKmNjPK8xaE5pZZ0JnF4kYI7QIVLserAjHe4=;
        b=dgS0n3A20Iihn2+tg16zlTXjQvt7T/ekaXKHe0u+lbv2qAHBly9Z3CdwSvbOfmHSw8
         +31fi5w7hOr/Nb0ekRVspbLp4xMRADDTH3SzpvXR68PMAYyu78YCnzVj6cF2Ry1CvYnz
         pg/MoMkx+GPalmb+qdumxUnVFy9FNnQSZAz3RL7NlBFz1PTyhOe1vsPFRtqPvKsnW8V5
         Do0tE8Hg0hzs28JcgCRNxdAsliZ8ZOV8KvGN/r27Ql2UdGhEEeovRS/GbHLutQmF0l1o
         olMld7DXzlSFUOFhUfKpx5tZkK2kHwTsxkkTlhcSml7EFxLrJTddKWlxGM9qas8ID93R
         9/fA==
X-Gm-Message-State: ANhLgQ1TEiexfFlZFHhxScJME6Ti+P/a0X/ySfe8T5SqmHcJo4sQQY/x
        CR6BCqmuK/MOAJuhwHHMG0yOOMvdMDcn7Eq9KlU=
X-Google-Smtp-Source: ADFU+vuNnjZ2a5OdwG7PjuUrIK6WMCdJ3kwlkxBlXaB89rEhz5miSw3VsBBHuezfVqFhFox1bfdoY04FQHh4nAXlWcs=
X-Received: by 2002:ac8:6f1b:: with SMTP id g27mr10090888qtv.117.1585250459173;
 Thu, 26 Mar 2020 12:20:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200326151741.125427-1-toke@redhat.com>
In-Reply-To: <20200326151741.125427-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 26 Mar 2020 12:20:47 -0700
Message-ID: <CAEf4BzYxJjJygu_ZqJJB03n=ZetxhuUE7eLD9dsbkbvzQ5M08w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Add bpf_object__rodata getter function
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

On Thu, Mar 26, 2020 at 8:18 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> This adds a new getter function to libbpf to get the rodata area of a bpf
> object. This is useful if a program wants to modify the rodata before
> loading the object. Any such modification needs to be done before loading=
,
> since libbpf freezes the backing map after populating it (to allow the
> kernel to do dead code elimination based on its contents).
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/libbpf.c   | 13 +++++++++++++
>  tools/lib/bpf/libbpf.h   |  1 +
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 15 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 085e41f9b68e..d3e3bbe12f78 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1352,6 +1352,19 @@ bpf_object__init_internal_map(struct bpf_object *o=
bj, enum libbpf_map_type type,
>         return 0;
>  }
>
> +void *bpf_object__rodata(const struct bpf_object *obj, size_t *size)

We probably don't want to expose this API. It just doesn't scale,
especially if/when we add support for custom sections names for global
variables. Also checking for map->mmaped is too restrictive. See how
BPF skeleton solves this problem and still allows .rodata
initialization even on kernels that don't support memory-mapping
global variables.

But basically, why can't you use BPF skeleton? Also, application can
already find that map by looking at name.

> +{
> +       struct bpf_map *map;
> +
> +       bpf_object__for_each_map(map, obj) {
> +               if (map->libbpf_type =3D=3D LIBBPF_MAP_RODATA && map->mma=
ped) {
> +                       *size =3D map->def.value_size;
> +                       return map->mmaped;
> +               }
> +       }
> +       return NULL;
> +}
> +
>  static int bpf_object__init_global_data_maps(struct bpf_object *obj)
>  {
>         int err;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index d38d7a629417..d2a9beed7b8a 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -166,6 +166,7 @@ typedef void (*bpf_object_clear_priv_t)(struct bpf_ob=
ject *, void *);
>  LIBBPF_API int bpf_object__set_priv(struct bpf_object *obj, void *priv,
>                                     bpf_object_clear_priv_t clear_priv);
>  LIBBPF_API void *bpf_object__priv(const struct bpf_object *prog);
> +LIBBPF_API void *bpf_object__rodata(const struct bpf_object *obj, size_t=
 *size);
>
>  LIBBPF_API int
>  libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type=
,
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 5129283c0284..a248f4ff3a40 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -243,5 +243,6 @@ LIBBPF_0.0.8 {
>                 bpf_link__pin;
>                 bpf_link__pin_path;
>                 bpf_link__unpin;
> +               bpf_object__rodata;
>                 bpf_program__set_attach_target;
>  } LIBBPF_0.0.7;
> --
> 2.26.0
>
