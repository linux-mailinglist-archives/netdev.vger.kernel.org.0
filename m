Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 845CC48BF5
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfFQSdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:33:46 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43475 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbfFQSdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:33:45 -0400
Received: by mail-qt1-f195.google.com with SMTP id w17so5577428qto.10;
        Mon, 17 Jun 2019 11:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ntsn6hZX0JPSK+ZgPt0QNm98jn1k7cMIiXnjoGfDZ0o=;
        b=S1ggL30yoWNqwzZu43A6rWt8qGY8SPQLJSsoUCmeXSzW13vSnU0TEq+Rb37quJf/4+
         FFD94VciIXAmgJ2YpOGmadBosIha/8INkEC5sPGAYK2MqL9QhWS/e2DhZEascJmLphSU
         v1xsToXKPJ6kA30rg3olJOn8Vvs2k742qtuNgSZkHjzszNjZ2FD0LQP5OmTfHjN4XjOE
         QfGzvmCWW9TeYvbW+sFWnqHwNkDgGePt+UNu/p5toNhM6sxHksY5pN3oCby/FpY0u8qA
         fFtyZD6IvegejGhPGIrXuNAJGpz3vLzcDEwngfkhGJnSnzVMQOvSu2crUuPXx7ewrtUY
         xLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ntsn6hZX0JPSK+ZgPt0QNm98jn1k7cMIiXnjoGfDZ0o=;
        b=cCia9ak6AQl6P7zbhwhWsQDQMmQihsdAIUnSOdnDJ2DXNf1WeJkYk/GFp5mP5ASp80
         wN9IeTr7JizW6ab36nQOnAH8cX3Yt9bKXzD37efxYMfIRcuwXjA8mDACl36X0SKTCDej
         3hBm/azIVO86CbqtTC7y964NV8kPAKxEzfqwmXgWaheW8AMBHacSrr9P4omBuAgyoFaD
         9zgk2zrEnL+TuQwyiWJTWWqHT+9LGNhPRPfg1dYPABbpq54nYv7PkvWKqVJ1MOS437Ps
         aTZirBrMwf6MsYlwxYVymljBK8zzJA4b72tNIw4+yq2jDRJsSd1UoCwNIpp+LkCt0vL7
         oETg==
X-Gm-Message-State: APjAAAUmYvxASk1RPjxgv6Lc/DWz9uNn88iOZwWFrGzFPFP/MZpwxHH1
        FSx+LijWA3gndgwVXOrTowzGN3TojYGQYUHL1fE=
X-Google-Smtp-Source: APXvYqybazLvGWdPvGtgpM+CHlmU+KgeuBMZCzbjljExu/P6V3mjOKe6g/GpqCPFJud/0ZkENGQu8wQ6gmXyYgECt+U=
X-Received: by 2002:ac8:2fb7:: with SMTP id l52mr71246600qta.93.1560796424473;
 Mon, 17 Jun 2019 11:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190611044747.44839-1-andriin@fb.com> <20190611044747.44839-7-andriin@fb.com>
 <CAPhsuW4-tmiBAji-=zx5gRRweioXTQM__EqaJGTPQ63SLphoUA@mail.gmail.com>
In-Reply-To: <CAPhsuW4-tmiBAji-=zx5gRRweioXTQM__EqaJGTPQ63SLphoUA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 17 Jun 2019 11:33:33 -0700
Message-ID: <CAEf4BzZu6fBsKAsZS5Nmv3HpLsXEoSa-RZE1xvr3LBCWGFJi0g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 15, 2019 at 3:01 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Mon, Jun 10, 2019 at 9:49 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > This patch adds support for a new way to define BPF maps. It relies on
> > BTF to describe mandatory and optional attributes of a map, as well as
> > captures type information of key and value naturally. This eliminates
> > the need for BPF_ANNOTATE_KV_PAIR hack and ensures key/value sizes are
> > always in sync with the key/value type.
> >

<snip>

> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/btf.h    |   1 +
> >  tools/lib/bpf/libbpf.c | 338 +++++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 330 insertions(+), 9 deletions(-)
> >
> > diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> > index ba4ffa831aa4..88a52ae56fc6 100644
> > --- a/tools/lib/bpf/btf.h
> > +++ b/tools/lib/bpf/btf.h
> > @@ -17,6 +17,7 @@ extern "C" {
> >
> >  #define BTF_ELF_SEC ".BTF"
> >  #define BTF_EXT_ELF_SEC ".BTF.ext"
> > +#define MAPS_ELF_SEC ".maps"
>
> How about .BTF.maps? Or maybe this doesn't realy matter?

That's not a good name, because it implies those maps are additional
part of BTF stuff (similar to as .BTF.ext is addition to .BTF). And
it's not, it uses BTF, but is not part of it.

I think .maps is good, because it's short and clear. Existing "maps"
used for bpf_map_def will eventually die out, leaving
"officially-looking" ;) .maps.

>
> >
> >  struct btf;
> >  struct btf_ext;
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 79a8143240d7..60713bcc2279 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -262,6 +262,7 @@ struct bpf_object {
> >                 } *reloc;
> >                 int nr_reloc;
> >                 int maps_shndx;
> > +               int btf_maps_shndx;
> >                 int text_shndx;
> >                 int data_shndx;
> >                 int rodata_shndx;
> > @@ -514,6 +515,7 @@ static struct bpf_object *bpf_object__new(const char *path,
> >         obj->efile.obj_buf = obj_buf;
> >         obj->efile.obj_buf_sz = obj_buf_sz;
> >         obj->efile.maps_shndx = -1;
> > +       obj->efile.btf_maps_shndx = -1;
> >         obj->efile.data_shndx = -1;
> >         obj->efile.rodata_shndx = -1;
> >         obj->efile.bss_shndx = -1;
> > @@ -1012,6 +1014,297 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
> >         return 0;
> >  }
> >
> > +static const struct btf_type *skip_mods_and_typedefs(const struct btf *btf,
> > +                                                    __u32 id)
> > +{
> > +       const struct btf_type *t = btf__type_by_id(btf, id);
> > +
> > +       while (true) {
> > +               switch (BTF_INFO_KIND(t->info)) {
> > +               case BTF_KIND_VOLATILE:
> > +               case BTF_KIND_CONST:
> > +               case BTF_KIND_RESTRICT:
> > +               case BTF_KIND_TYPEDEF:
> > +                       t = btf__type_by_id(btf, t->type);
> > +                       break;
> > +               default:
> > +                       return t;
> > +               }
> > +       }
> > +}
> > +
> > +static bool get_map_attr_int(const char *map_name,
> > +                            const struct btf *btf,
> > +                            const struct btf_type *def,
> > +                            const struct btf_member *m,
> > +                            const void *data, __u32 *res) {
>
> Can we avoid output pointer by return 0 for invalid types?

Zero is valid value, so can't do that.

>
> > +       const struct btf_type *t = skip_mods_and_typedefs(btf, m->type);
> > +       const char *name = btf__name_by_offset(btf, m->name_off);
> > +       __u32 int_info = *(const __u32 *)(const void *)(t + 1);
> > +
> > +       if (BTF_INFO_KIND(t->info) != BTF_KIND_INT) {
> > +               pr_warning("map '%s': attr '%s': expected INT, got %u.\n",
> > +                          map_name, name, BTF_INFO_KIND(t->info));
> > +               return false;
> > +       }
> > +       if (t->size != 4 || BTF_INT_BITS(int_info) != 32 ||
> > +           BTF_INT_OFFSET(int_info)) {
> > +               pr_warning("map '%s': attr '%s': expected 32-bit non-bitfield integer, "
> > +                          "got %u-byte (%d-bit) one with bit offset %d.\n",
> > +                          map_name, name, t->size, BTF_INT_BITS(int_info),
> > +                          BTF_INT_OFFSET(int_info));
> > +               return false;
> > +       }
> > +       if (BTF_INFO_KFLAG(def->info) && BTF_MEMBER_BITFIELD_SIZE(m->offset)) {
> > +               pr_warning("map '%s': attr '%s': bitfield is not supported.\n",
> > +                          map_name, name);
> > +               return false;
> > +       }
> > +       if (m->offset % 32) {
>
> Shall we just do "m->offset > 0" here?

No. m->offset == 0 is OK (first field of a struct), but any
non-aligned int is bad (e.g., bitfields are not supported). I could
have supported byte-aligned integer fields, but don't see much reason
to.

>
> > +               pr_warning("map '%s': attr '%s': unaligned fields are not supported.\n",
> > +                          map_name, name);
> > +               return false;
> > +       }
> > +
> > +       *res = *(const __u32 *)(data + m->offset / 8);
> > +       return true;
> > +}
> > +
> > +static int bpf_object__init_user_btf_map(struct bpf_object *obj,
> > +                                        const struct btf_type *sec,
> > +                                        int var_idx, int sec_idx,
> > +                                        const Elf_Data *data, bool strict)
> > +{
> > +       const struct btf_type *var, *def, *t;
> > +       const struct btf_var_secinfo *vi;
> > +       const struct btf_var *var_extra;
> > +       const struct btf_member *m;
> > +       const void *def_data;
> > +       const char *map_name;
> > +       struct bpf_map *map;
> > +       int vlen, i;
> > +
> > +       vi = (const struct btf_var_secinfo *)(const void *)(sec + 1) + var_idx;
> > +       var = btf__type_by_id(obj->btf, vi->type);
> > +       var_extra = (const void *)(var + 1);
> > +       map_name = btf__name_by_offset(obj->btf, var->name_off);
> > +       vlen = BTF_INFO_VLEN(var->info);
> > +
> > +       if (map_name == NULL || map_name[0] == '\0') {
> > +               pr_warning("map #%d: empty name.\n", var_idx);
> > +               return -EINVAL;
> > +       }
> > +       if ((__u64)vi->offset + vi->size > data->d_size) {
> > +               pr_warning("map '%s' BTF data is corrupted.\n", map_name);
> > +               return -EINVAL;
> > +       }
> > +       if (BTF_INFO_KIND(var->info) != BTF_KIND_VAR) {
> > +               pr_warning("map '%s': unexpected var kind %u.\n",
> > +                          map_name, BTF_INFO_KIND(var->info));
> > +               return -EINVAL;
> > +       }
> > +       if (var_extra->linkage != BTF_VAR_GLOBAL_ALLOCATED &&
> > +           var_extra->linkage != BTF_VAR_STATIC) {
> > +               pr_warning("map '%s': unsupported var linkage %u.\n",
> > +                          map_name, var_extra->linkage);
> > +               return -EOPNOTSUPP;
> > +       }
> > +
> > +       def = skip_mods_and_typedefs(obj->btf, var->type);
> > +       if (BTF_INFO_KIND(def->info) != BTF_KIND_STRUCT) {
> > +               pr_warning("map '%s': unexpected def kind %u.\n",
> > +                          map_name, BTF_INFO_KIND(var->info));
> > +               return -EINVAL;
> > +       }
> > +       if (def->size > vi->size) {
> > +               pr_warning("map '%s': invalid def size.\n", map_name);
> > +               return -EINVAL;
> > +       }
> > +
> > +       map = bpf_object__add_map(obj);
> > +       if (IS_ERR(map))
> > +               return PTR_ERR(map);
> > +       map->name = strdup(map_name);
> > +       if (!map->name) {
> > +               pr_warning("map '%s': failed to alloc map name.\n", map_name);
> > +               return -ENOMEM;
> > +       }
> > +       map->libbpf_type = LIBBPF_MAP_UNSPEC;
> > +       map->def.type = BPF_MAP_TYPE_UNSPEC;
> > +       map->sec_idx = sec_idx;
> > +       map->sec_offset = vi->offset;
> > +       pr_debug("map '%s': at sec_idx %d, offset %zu.\n",
> > +                map_name, map->sec_idx, map->sec_offset);
> > +
> > +       def_data = data->d_buf + vi->offset;
> > +       vlen = BTF_INFO_VLEN(def->info);
> > +       m = (const void *)(def + 1);
> > +       for (i = 0; i < vlen; i++, m++) {
> > +               const char *name = btf__name_by_offset(obj->btf, m->name_off);
> > +
>
> I guess we need to check name == NULL here?

Yep, will check, it can throw off pr_warning below.

>
> > +               if (strcmp(name, "type") == 0) {
> > +                       if (!get_map_attr_int(map_name, obj->btf, def, m,
> > +                                             def_data, &map->def.type))
> > +                               return -EINVAL;
> > +                       pr_debug("map '%s': found type = %u.\n",
> > +                                map_name, map->def.type);
> > +               } else if (strcmp(name, "max_entries") == 0) {
> > +                       if (!get_map_attr_int(map_name, obj->btf, def, m,
> > +                                             def_data, &map->def.max_entries))
> > +                               return -EINVAL;
> > +                       pr_debug("map '%s': found max_entries = %u.\n",
> > +                                map_name, map->def.max_entries);
> > +               } else if (strcmp(name, "map_flags") == 0) {
> > +                       if (!get_map_attr_int(map_name, obj->btf, def, m,
> > +                                             def_data, &map->def.map_flags))
> > +                               return -EINVAL;
> > +                       pr_debug("map '%s': found map_flags = %u.\n",
> > +                                map_name, map->def.map_flags);
> > +               } else if (strcmp(name, "key_size") == 0) {
> > +                       __u32 sz;
> > +
> > +                       if (!get_map_attr_int(map_name, obj->btf, def, m,
> > +                                             def_data, &sz))
> > +                               return -EINVAL;
> > +                       pr_debug("map '%s': found key_size = %u.\n",
> > +                                map_name, sz);
> > +                       if (map->def.key_size && map->def.key_size != sz) {
> > +                               pr_warning("map '%s': conflictling key size %u != %u.\n",
> > +                                          map_name, map->def.key_size, sz);
> > +                               return -EINVAL;
> > +                       }
> > +                       map->def.key_size = sz;
> > +               } else if (strcmp(name, "key") == 0) {
> > +                       __s64 sz;
> > +
> > +                       t = btf__type_by_id(obj->btf, m->type);
> > +                       if (BTF_INFO_KIND(t->info) != BTF_KIND_PTR) {
>
> check t != NULL?

done

>
> > +                               pr_warning("map '%s': key spec is not PTR: %u.\n",
> > +                                          map_name, BTF_INFO_KIND(t->info));
> > +                               return -EINVAL;
> > +                       }
> > +                       sz = btf__resolve_size(obj->btf, t->type);
> > +                       if (sz < 0) {
> > +                               pr_warning("map '%s': can't determine key size for type [%u]: %lld.\n",
> > +                                          map_name, t->type, sz);
> > +                               return sz;
> > +                       }
> > +                       pr_debug("map '%s': found key [%u], sz = %lld.\n",
> > +                                map_name, t->type, sz);
> > +                       if (map->def.key_size && map->def.key_size != sz) {
> > +                               pr_warning("map '%s': conflictling key size %u != %lld.\n",
> > +                                          map_name, map->def.key_size, sz);
> > +                               return -EINVAL;
> > +                       }
> > +                       map->def.key_size = sz;
> > +                       map->btf_key_type_id = t->type;
> > +               } else if (strcmp(name, "value_size") == 0) {
> > +                       __u32 sz;
> > +
> > +                       if (!get_map_attr_int(map_name, obj->btf, def, m,
> > +                                             def_data, &sz))
> > +                               return -EINVAL;
> > +                       pr_debug("map '%s': found value_size = %u.\n",
> > +                                map_name, sz);
> > +                       if (map->def.value_size && map->def.value_size != sz) {
> > +                               pr_warning("map '%s': conflictling value size %u != %u.\n",
> > +                                          map_name, map->def.value_size, sz);
> > +                               return -EINVAL;
> > +                       }
> > +                       map->def.value_size = sz;
> > +               } else if (strcmp(name, "value") == 0) {
> > +                       __s64 sz;
> > +
> > +                       t = btf__type_by_id(obj->btf, m->type);
>
> ditto.

yep

>
> > +                       if (BTF_INFO_KIND(t->info) != BTF_KIND_PTR) {
> > +                               pr_warning("map '%s': value spec is not PTR: %u.\n",
> > +                                          map_name, BTF_INFO_KIND(t->info));
> > +                               return -EINVAL;
> > +                       }

<snip>
