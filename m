Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91153686AF
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238438AbhDVSla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVSl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 14:41:29 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCD5C06174A;
        Thu, 22 Apr 2021 11:40:54 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id 82so52698828yby.7;
        Thu, 22 Apr 2021 11:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yRGWe8cy3lSmMEo0AAnmgNmy4yCW+CV5r5L8Zh4NUGk=;
        b=h8I3vFzM26y/4dBYgZGRewIkDZRzmJuFQt3UqGA4LFeLc+k0vigY0oWU9tCIVEXxk/
         kUEYKMz+IvdnMTvoX1+CfOGrKKCRuck02bLDXtZ/MV8ZZL284qq1Is0muD6X8tV4tsjH
         w+9HlWCXau+Lu5qo+MLbjpncRpN7nRxDk9k7xiOJxYWgOVahFxzSnm4EeipePIEB3N9+
         7DrTubvRWUvQLfz7kms3hCFoTQ77rm22B5nrafNo2kzMwRbdkh+wN2bkqoria+FdLCsF
         bI/XUNB1S0M8i0OqNy+gXFIezUym0Bv0dQXgbELkLog4IugHFAyc+znNmcRzDAyT8vBU
         cGNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yRGWe8cy3lSmMEo0AAnmgNmy4yCW+CV5r5L8Zh4NUGk=;
        b=Os1OY/CHiQnzdGeK+eMDbszqCTgXNbuvxp/SdacXIfYA809I8cYxMSlG3Y4cjTH4cu
         hxtX/tJ+cXteYWSlMgGf4tSfogTR7CsmntE4ADu4vpe54wQr8nEm66CGja3jXNUDV/LB
         WqHWvDpSeHXjmZzXdFbBbjqtwyGSb6Wy6PElUcROHEdKRo/e53EWW68ODrlBp2sR2ONC
         GyX7mAFcSLVKfn02w8cz2gVHDZSTR2lwlXvxe8EqHewaXaqFnn7qzQk5Q61xRWdkknjb
         47bqZZbedn03yaMOnoWN4Z2XOA//PXW0BaYRpOiwdGRgCfKt6w8ZEN/hZXGG4BEifK47
         UT8w==
X-Gm-Message-State: AOAM532QIq/32o9Cglk/9FIf2kfhMfNXG2fVOEQ/+f05bj0W8mBIllrr
        9yAswSk2CKs66OwfR5ASmq5IpCYhDKp622A8UNE=
X-Google-Smtp-Source: ABdhPJywENPU7512El5EjpPGXAOJ/bpG9hiXvlay9amQ6S3NgycZaV2wzyShxOjYhcY1lvmmdvp+NuByugbE429Uwbw=
X-Received: by 2002:a25:dc46:: with SMTP id y67mr61794ybe.27.1619116853737;
 Thu, 22 Apr 2021 11:40:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-7-andrii@kernel.org>
 <0ae37c13-e8d9-b0ca-00ca-1750dc2799c9@fb.com>
In-Reply-To: <0ae37c13-e8d9-b0ca-00ca-1750dc2799c9@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Apr 2021 11:40:42 -0700
Message-ID: <CAEf4Bzb40Ki+eZdKJ+QFnzuaburPRC6v4fVPtiWXtj5ZyWLg=A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 06/17] libbpf: refactor BTF map definition parsing
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 8:33 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> > Refactor BTF-defined maps parsing logic to allow it to be nicely reused by BPF
> > static linker. Further, at least for BPF static linker, it's important to know
> > which attributes of a BPF map were defined explicitly, so provide a bit set
> > for each known portion of BTF map definition. This allows BPF static linker to
> > do a simple check when dealing with extern map declarations.
> >
> > The same capabilities allow to distinguish attributes explicitly set to zero
> > (e.g., __uint(max_entries, 0)) vs the case of not specifying it at all (no
> > max_entries attribute at all). Libbpf is currently not utilizing that, but it
> > could be useful for backwards compatibility reasons later.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >   tools/lib/bpf/libbpf.c          | 256 ++++++++++++++++++--------------
> >   tools/lib/bpf/libbpf_internal.h |  32 ++++
> >   2 files changed, 177 insertions(+), 111 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index a0e6d6bc47f3..f6f4126389ac 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -2025,255 +2025,262 @@ static int build_map_pin_path(struct bpf_map *map, const char *path)
> >       return bpf_map__set_pin_path(map, buf);
> >   }
> >
> > -
> > -static int parse_btf_map_def(struct bpf_object *obj,
> > -                          struct bpf_map *map,
> > -                          const struct btf_type *def,
> > -                          bool strict, bool is_inner,
> > -                          const char *pin_root_path)
> > +int parse_btf_map_def(const char *map_name, struct btf *btf,
> > +                   const struct btf_type *def_t, bool strict,
> > +                   struct btf_map_def *map_def, struct btf_map_def *inner_def)
> >   {
> >       const struct btf_type *t;
> >       const struct btf_member *m;
> > +     bool is_inner = inner_def == NULL;
> >       int vlen, i;
> >
> > -     vlen = btf_vlen(def);
> > -     m = btf_members(def);
> > +     vlen = btf_vlen(def_t);
> > +     m = btf_members(def_t);
> >       for (i = 0; i < vlen; i++, m++) {
> > -             const char *name = btf__name_by_offset(obj->btf, m->name_off);
> > +             const char *name = btf__name_by_offset(btf, m->name_off);
> >
> [...]
> >               }
> >               else if (strcmp(name, "values") == 0) {
> > +                     char inner_map_name[128];
> >                       int err;
> >
> >                       if (is_inner) {
> >                               pr_warn("map '%s': multi-level inner maps not supported.\n",
> > -                                     map->name);
> > +                                     map_name);
> >                               return -ENOTSUP;
> >                       }
> >                       if (i != vlen - 1) {
> >                               pr_warn("map '%s': '%s' member should be last.\n",
> > -                                     map->name, name);
> > +                                     map_name, name);
> >                               return -EINVAL;
> >                       }
> > -                     if (!bpf_map_type__is_map_in_map(map->def.type)) {
> > +                     if (!bpf_map_type__is_map_in_map(map_def->map_type)) {
> >                               pr_warn("map '%s': should be map-in-map.\n",
> > -                                     map->name);
> > +                                     map_name);
> >                               return -ENOTSUP;
> >                       }
> > -                     if (map->def.value_size && map->def.value_size != 4) {
> > +                     if (map_def->value_size && map_def->value_size != 4) {
> >                               pr_warn("map '%s': conflicting value size %u != 4.\n",
> > -                                     map->name, map->def.value_size);
> > +                                     map_name, map_def->value_size);
> >                               return -EINVAL;
> >                       }
> > -                     map->def.value_size = 4;
> > -                     t = btf__type_by_id(obj->btf, m->type);
> > +                     map_def->value_size = 4;
> > +                     t = btf__type_by_id(btf, m->type);
> >                       if (!t) {
> >                               pr_warn("map '%s': map-in-map inner type [%d] not found.\n",
> > -                                     map->name, m->type);
> > +                                     map_name, m->type);
> >                               return -EINVAL;
> >                       }
> >                       if (!btf_is_array(t) || btf_array(t)->nelems) {
> >                               pr_warn("map '%s': map-in-map inner spec is not a zero-sized array.\n",
> > -                                     map->name);
> > +                                     map_name);
> >                               return -EINVAL;
> >                       }
> > -                     t = skip_mods_and_typedefs(obj->btf, btf_array(t)->type,
> > -                                                NULL);
> > +                     t = skip_mods_and_typedefs(btf, btf_array(t)->type, NULL);
> >                       if (!btf_is_ptr(t)) {
> >                               pr_warn("map '%s': map-in-map inner def is of unexpected kind %s.\n",
> > -                                     map->name, btf_kind_str(t));
> > +                                     map_name, btf_kind_str(t));
> >                               return -EINVAL;
> >                       }
> > -                     t = skip_mods_and_typedefs(obj->btf, t->type, NULL);
> > +                     t = skip_mods_and_typedefs(btf, t->type, NULL);
> >                       if (!btf_is_struct(t)) {
> >                               pr_warn("map '%s': map-in-map inner def is of unexpected kind %s.\n",
> > -                                     map->name, btf_kind_str(t));
> > +                                     map_name, btf_kind_str(t));
> >                               return -EINVAL;
> >                       }
> >
> > -                     map->inner_map = calloc(1, sizeof(*map->inner_map));
> > -                     if (!map->inner_map)
> > -                             return -ENOMEM;
> > -                     map->inner_map->fd = -1;
> > -                     map->inner_map->sec_idx = obj->efile.btf_maps_shndx;
>
> The refactoring didn't set map->inner_map->sec_idx. I guess since
> inner_map is only used internally by libbpf, so it does not
> have a user visible sec_idx and hence useless? It is worthwhile to
> mention in the commit message for this difference, I think.
>
> > -                     map->inner_map->name = malloc(strlen(map->name) +
> > -                                                   sizeof(".inner") + 1);
> > -                     if (!map->inner_map->name)
> > -                             return -ENOMEM;
> > -                     sprintf(map->inner_map->name, "%s.inner", map->name);
> > -
> > -                     err = parse_btf_map_def(obj, map->inner_map, t, strict,
> > -                                             true /* is_inner */, NULL);
> > +                     snprintf(inner_map_name, sizeof(inner_map_name), "%s.inner", map_name);
> > +                     err = parse_btf_map_def(inner_map_name, btf, t, strict, inner_def, NULL);
> >                       if (err)
> >                               return err;
> > +
> > +                     map_def->parts |= MAP_DEF_INNER_MAP;
> >               } else if (strcmp(name, "pinning") == 0) {
> >                       __u32 val;
> > -                     int err;
> >
> >                       if (is_inner) {
> > -                             pr_debug("map '%s': inner def can't be pinned.\n",
> > -                                      map->name);
> > +                             pr_warn("map '%s': inner def can't be pinned.\n", map_name);
> >                               return -EINVAL;
> >                       }
> > -                     if (!get_map_field_int(map->name, obj->btf, m, &val))
> > +                     if (!get_map_field_int(map_name, btf, m, &val))
> >                               return -EINVAL;
> > -                     pr_debug("map '%s': found pinning = %u.\n",
> > -                              map->name, val);
> > -
> > -                     if (val != LIBBPF_PIN_NONE &&
> > -                         val != LIBBPF_PIN_BY_NAME) {
> > +                     if (val != LIBBPF_PIN_NONE && val != LIBBPF_PIN_BY_NAME) {
> >                               pr_warn("map '%s': invalid pinning value %u.\n",
> > -                                     map->name, val);
> > +                                     map_name, val);
> >                               return -EINVAL;
> >                       }
> > -                     if (val == LIBBPF_PIN_BY_NAME) {
> > -                             err = build_map_pin_path(map, pin_root_path);
> > -                             if (err) {
> > -                                     pr_warn("map '%s': couldn't build pin path.\n",
> > -                                             map->name);
> > -                                     return err;
> > -                             }
> > -                     }
> > +                     map_def->pinning = val;
> > +                     map_def->parts |= MAP_DEF_PINNING;
> >               } else {
> >                       if (strict) {
> > -                             pr_warn("map '%s': unknown field '%s'.\n",
> > -                                     map->name, name);
> > +                             pr_warn("map '%s': unknown field '%s'.\n", map_name, name);
> >                               return -ENOTSUP;
> >                       }
> > -                     pr_debug("map '%s': ignoring unknown field '%s'.\n",
> > -                              map->name, name);
> > +                     pr_debug("map '%s': ignoring unknown field '%s'.\n", map_name, name);
> >               }
> >       }
> >
> > -     if (map->def.type == BPF_MAP_TYPE_UNSPEC) {
> > -             pr_warn("map '%s': map type isn't specified.\n", map->name);
> > +     if (map_def->map_type == BPF_MAP_TYPE_UNSPEC) {
> > +             pr_warn("map '%s': map type isn't specified.\n", map_name);
> >               return -EINVAL;
> >       }
> >
> >       return 0;
> >   }
> >
> > +static void fill_map_from_def(struct bpf_map *map, const struct btf_map_def *def)
> > +{
> [...]
> > +}
> > +
> >   static int bpf_object__init_user_btf_map(struct bpf_object *obj,
> >                                        const struct btf_type *sec,
> >                                        int var_idx, int sec_idx,
> >                                        const Elf_Data *data, bool strict,
> >                                        const char *pin_root_path)
> >   {
> > +     struct btf_map_def map_def = {}, inner_def = {};
> >       const struct btf_type *var, *def;
> >       const struct btf_var_secinfo *vi;
> >       const struct btf_var *var_extra;
> >       const char *map_name;
> >       struct bpf_map *map;
> > +     int err;
> >
> >       vi = btf_var_secinfos(sec) + var_idx;
> >       var = btf__type_by_id(obj->btf, vi->type);
> > @@ -2327,7 +2334,34 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
> >       pr_debug("map '%s': at sec_idx %d, offset %zu.\n",
> >                map_name, map->sec_idx, map->sec_offset);
> >
> > -     return parse_btf_map_def(obj, map, def, strict, false, pin_root_path);
> > +     err = parse_btf_map_def(map->name, obj->btf, def, strict, &map_def, &inner_def);
> > +     if (err)
> > +             return err;
> > +
> > +     fill_map_from_def(map, &map_def);
> > +
> > +     if (map_def.pinning == LIBBPF_PIN_BY_NAME) {
> > +             err = build_map_pin_path(map, pin_root_path);
> > +             if (err) {
> > +                     pr_warn("map '%s': couldn't build pin path.\n", map->name);
> > +                     return err;
> > +             }
> > +     }
> > +
> > +     if (map_def.parts & MAP_DEF_INNER_MAP) {
> > +             map->inner_map = calloc(1, sizeof(*map->inner_map));
> > +             if (!map->inner_map)
> > +                     return -ENOMEM;
> > +             map->inner_map->fd = -1;
>
> missing set map->inner_map->sec_idx here.

I'll add it back here, but it was never really necessary. More for the
completeness sake. sec_idx is used only to match relo to a map, and
this inner_map is never matched and never referenced by a relocation.

>
> > +             map->inner_map->name = malloc(strlen(map_name) + sizeof(".inner") + 1);
> > +             if (!map->inner_map->name)
> > +                     return -ENOMEM;
> > +             sprintf(map->inner_map->name, "%s.inner", map_name);
> > +
> > +             fill_map_from_def(map->inner_map, &inner_def);
> > +     }
> > +
> > +     return 0;
> >   }
> >
> >   static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
> > diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> > index 92b7eae10c6d..17883073710c 100644
> > --- a/tools/lib/bpf/libbpf_internal.h
> > +++ b/tools/lib/bpf/libbpf_internal.h
> > @@ -138,6 +138,38 @@ static inline __u32 btf_type_info(int kind, int vlen, int kflag)
> >       return (kflag << 31) | (kind << 24) | vlen;
> >   }
> >
> [...]
