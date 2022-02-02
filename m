Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBFE4A78BA
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 20:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346839AbiBBTbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 14:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240428AbiBBTba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 14:31:30 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD6EC061714;
        Wed,  2 Feb 2022 11:31:30 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id 9so400571iou.2;
        Wed, 02 Feb 2022 11:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OMwY2wvMhB1DUTy+ksrjre4+0Cp7BW70VPY8FVvDBuQ=;
        b=KTiQh8MMq4dFPx6Tg3XeOVyNDouee91qkWEzPSdc8AdZZlBfBykqfsDdSZue6Oswgs
         suIbT6RWQ+yuYf0f0OGBSE0YWc2Qv3Mek2B29OEnRjjroX0SPMu9w5HVerUJcpaxW4ts
         D0/aeZttXnGoBjNTYdEk7zQVAJ3IGWozHdxWcW+20huIXIbPDedVDiqk9J9IAhCo7Gjl
         fTYSSXWWv/eMI2DoakwZp9RMMJqvAwP52+mzDJhvN6TZTpAfSrRBYJBE9nmpVwWQjERZ
         K09TDmQxYVqg4xJcbWOGeV7WR/FukoQY0BRElgQJ+LJhBLbOyggcCWDY/0tWJ7OhrM/p
         11hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OMwY2wvMhB1DUTy+ksrjre4+0Cp7BW70VPY8FVvDBuQ=;
        b=H4iyJRSpaaJAMqtcxk2BmpNyolhmjQc8fpvYT/osTT5XIIlhPFu6peHvd+cgyekGtH
         zFmmNJkgKfovAbqpPUwzWOFflReIdt0ojPBHjx1K+CD+FFK/PAzOVXDIs8143n6ITngW
         M3tiN3TBa1jLfAdrWbcGtQ8rkAZXVYKZlTnLkdX7Y3Ue7v5LVb3XjGfKOnHMpYGRKsWY
         pvB3DbPIziPBwpH2AEzOggBjgGloA/B12c4Gt71YU7nEc1R7GZ91SFfMzHVgZ8t/uKJl
         sF2zdAj8ro56uF6qn1OKBPWa7vJYmJdYr6gbdA9aCselMOC0ftW9PyWZv9iDTNKje3iG
         bhiw==
X-Gm-Message-State: AOAM53291cp7gcMfbLjXwRdBaVHoPZGmm0FHTxvVRTN4INMcsdj/ORtv
        IfWVlv4gxTd8zdZb5KNJaylMnRgwSOg121ekRptLq/Rh
X-Google-Smtp-Source: ABdhPJxNi75fc8x9/UorufjmjpEc+kwNQ/0nI6k7Joi7LCUPloTkEKV9h513unRd58bxRIvDvU6l3UjibpG42TfXNJ4=
X-Received: by 2002:a5e:a806:: with SMTP id c6mr16759145ioa.112.1643830290154;
 Wed, 02 Feb 2022 11:31:30 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-7-mauricio@kinvolk.io>
In-Reply-To: <20220128223312.1253169-7-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Feb 2022 11:31:19 -0800
Message-ID: <CAEf4BzZu-u1WXGScPZKVQZc+RGjmnYm45mcOGkzXyFLMKS-5gA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 6/9] bpftool: Implement relocations recording
 for BTFGen
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 2:33 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> This commit implements the logic to record the relocation information
> for the different kind of relocations.
>
> btfgen_record_field_relo() uses the target specification to save all the
> types that are involved in a field-based CO-RE relocation. In this case
> types resolved and added recursively (using btfgen_put_type()).
> Only the struct and union members and their types) involved in the
> relocation are added to optimize the size of the generated BTF file.
>
> On the other hand, btfgen_record_type_relo() saves the types involved in
> a type-based CO-RE relocation. In this case all the members for the

Do I understand correctly that if someone does
bpf_core_type_size(struct task_struct), you'll save not just
task_struct, but also any type that directly and indirectly referenced
from any task_struct's field, even if that is through a pointer. As
in, do you substitute forward declarations for types that are never
directly used? If not, that's going to be very suboptimal for
something like task_struct and any other type that's part of a big
cluster of types.

> struct and union types are added. This is not strictly required since
> libbpf doesn't use them while performing this kind of relocation,
> however that logic could change on the future. Additionally, we expect
> that the number of this kind of relocations in an BPF object to be very
> low, hence the impact on the size of the generated BTF should be
> negligible.
>
> Finally, btfgen_record_enumval_relo() saves the whole enum type for
> enum-based relocations.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/bpf/bpftool/gen.c | 260 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 257 insertions(+), 3 deletions(-)
>
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index bb9c56401ee5..7413ec808a80 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -1119,9 +1119,17 @@ static int btf_save_raw(const struct btf *btf, con=
st char *path)
>         return err;
>  }
>
> +struct btfgen_member {
> +       struct btf_member *member;
> +       int idx;
> +};
> +
>  struct btfgen_type {
>         struct btf_type *type;
>         unsigned int id;
> +       bool all_members;
> +
> +       struct hashmap *members;
>  };
>
>  struct btfgen_info {
> @@ -1151,6 +1159,19 @@ static void *u32_as_hash_key(__u32 x)
>
>  static void btfgen_free_type(struct btfgen_type *type)
>  {
> +       struct hashmap_entry *entry;
> +       size_t bkt;
> +
> +       if (!type)
> +               return;
> +
> +       if (!IS_ERR_OR_NULL(type->members)) {
> +               hashmap__for_each_entry(type->members, entry, bkt) {
> +                       free(entry->value);
> +               }
> +               hashmap__free(type->members);
> +       }
> +
>         free(type);
>  }
>
> @@ -1199,19 +1220,252 @@ btfgen_new_info(const char *targ_btf_path)
>         return info;
>  }
>
> +static int btfgen_add_member(struct btfgen_type *btfgen_type,
> +                            struct btf_member *btf_member, int idx)
> +{
> +       struct btfgen_member *btfgen_member;
> +       int err;
> +
> +       /* create new members hashmap for this btfgen type if needed */
> +       if (!btfgen_type->members) {
> +               btfgen_type->members =3D hashmap__new(btfgen_hash_fn, btf=
gen_equal_fn, NULL);
> +               if (IS_ERR(btfgen_type->members))
> +                       return PTR_ERR(btfgen_type->members);
> +       }
> +
> +       btfgen_member =3D calloc(1, sizeof(*btfgen_member));
> +       if (!btfgen_member)
> +               return -ENOMEM;
> +       btfgen_member->member =3D btf_member;
> +       btfgen_member->idx =3D idx;
> +       /* add btf_member as member to given btfgen_type */
> +       err =3D hashmap__add(btfgen_type->members, uint_as_hash_key(btfge=
n_member->idx),
> +                          btfgen_member);
> +       if (err) {
> +               free(btfgen_member);
> +               if (err !=3D -EEXIST)

why not check that such a member exists before doing btfgen_member allocati=
on?

> +                       return err;
> +       }
> +
> +       return 0;
> +}
> +
> +static struct btfgen_type *btfgen_get_type(struct btfgen_info *info, int=
 id)
> +{
> +       struct btfgen_type *type =3D NULL;
> +
> +       hashmap__find(info->types, uint_as_hash_key(id), (void **)&type);

if (!hashmap__find(...))
   return NULL;

> +
> +       return type;
> +}
> +
> +static struct btfgen_type *
> +_btfgen_put_type(struct btf *btf, struct btfgen_info *info, struct btf_t=
ype *btf_type,
> +                unsigned int id, bool all_members)
> +{
> +       struct btfgen_type *btfgen_type, *tmp;
> +       struct btf_array *array;
> +       unsigned int child_id;
> +       struct btf_member *m;
> +       int err, i, n;
> +
> +       /* check if we already have this type */
> +       if (hashmap__find(info->types, uint_as_hash_key(id), (void **) &b=
tfgen_type)) {
> +               if (!all_members || btfgen_type->all_members)
> +                       return btfgen_type;
> +       } else {
> +               btfgen_type =3D calloc(1, sizeof(*btfgen_type));
> +               if (!btfgen_type)
> +                       return NULL;
> +
> +               btfgen_type->type =3D btf_type;
> +               btfgen_type->id =3D id;
> +
> +               /* append this type to the types list before anything els=
e */

what do you mean by "before anything else"?

> +               err =3D hashmap__add(info->types, uint_as_hash_key(btfgen=
_type->id), btfgen_type);
> +               if (err) {
> +                       free(btfgen_type);
> +                       return NULL;
> +               }
> +       }
> +
> +       /* avoid infinite recursion and yet be able to add all
> +        * fields/members for types also managed by this function
> +        */
> +       btfgen_type->all_members =3D all_members;
> +
> +       /* recursively add other types needed by it */
> +       switch (btf_kind(btfgen_type->type)) {
> +       case BTF_KIND_UNKN:
> +       case BTF_KIND_INT:
> +       case BTF_KIND_FLOAT:
> +       case BTF_KIND_ENUM:
> +               break;
> +       case BTF_KIND_STRUCT:
> +       case BTF_KIND_UNION:
> +               /* doesn't need resolution if not adding all members */
> +               if (!all_members)
> +                       break;
> +
> +               n =3D btf_vlen(btf_type);
> +               m =3D btf_members(btf_type);
> +               for (i =3D 0; i < n; i++, m++) {
> +                       btf_type =3D (struct btf_type *) btf__type_by_id(=
btf, m->type);

why `const struct btf_type *` doesn't work everywhere? You are not
modifying btf_type itself, no?

> +
> +                       /* add all member types */
> +                       tmp =3D _btfgen_put_type(btf, info, btf_type, m->=
type, all_members);
> +                       if (!tmp)
> +                               return NULL;
> +
> +                       /* add all members */
> +                       err =3D btfgen_add_member(btfgen_type, m, i);
> +                       if (err)
> +                               return NULL;
> +               }
> +               break;
> +       case BTF_KIND_PTR:
> +               if (!all_members)
> +                       break;
> +       /* fall through */
> +       /* Also add the type it's pointing to when adding all members */
> +       case BTF_KIND_CONST:
> +       case BTF_KIND_VOLATILE:
> +       case BTF_KIND_TYPEDEF:
> +               child_id =3D btf_type->type;
> +               btf_type =3D (struct btf_type *) btf__type_by_id(btf, chi=
ld_id);
> +
> +               tmp =3D _btfgen_put_type(btf, info, btf_type, child_id, a=
ll_members);
> +               if (!tmp)
> +                       return NULL;
> +               break;
> +       case BTF_KIND_ARRAY:
> +               array =3D btf_array(btfgen_type->type);
> +
> +               /* add type for array type */
> +               btf_type =3D (struct btf_type *) btf__type_by_id(btf, arr=
ay->type);
> +               tmp =3D _btfgen_put_type(btf, info, btf_type, array->type=
, all_members);
> +               if (!tmp)
> +                       return NULL;
> +
> +               /* add type for array's index type */
> +               btf_type =3D (struct btf_type *) btf__type_by_id(btf, arr=
ay->index_type);
> +               tmp =3D _btfgen_put_type(btf, info, btf_type, array->inde=
x_type, all_members);
> +               if (!tmp)
> +                       return NULL;
> +               break;
> +       /* tells if some other type needs to be handled */
> +       default:
> +               p_err("unsupported kind: %s (%d)",
> +                     btf_kind_str(btfgen_type->type), btfgen_type->id);
> +               errno =3D EINVAL;
> +               return NULL;
> +       }
> +
> +       return btfgen_type;
> +}
> +
> +/* Put type in the list. If the type already exists it's returned, other=
wise a
> + * new one is created and added to the list. This is called recursively =
adding
> + * all the types that are needed for the current one.
> + */
> +static struct btfgen_type *
> +btfgen_put_type(struct btf *btf, struct btfgen_info *info, struct btf_ty=
pe *btf_type,
> +               unsigned int id)
> +{
> +       return _btfgen_put_type(btf, info, btf_type, id, false);
> +}
> +
> +/* Same as btfgen_put_type, but adding all members, from given complex t=
ype, recursively */
> +static struct btfgen_type *
> +btfgen_put_type_all(struct btf *btf, struct btfgen_info *info,
> +                   struct btf_type *btf_type, unsigned int id)
> +{
> +       return _btfgen_put_type(btf, info, btf_type, id, true);
> +}

these wrappers seem unnecessary, just pass false/true in 5 call sites
below without extra wrapping of _btfgen_put_type (and call it
btfgen_put_type then)

> +
>  static int btfgen_record_field_relo(struct btfgen_info *info, struct bpf=
_core_spec *targ_spec)
>  {
> -       return -EOPNOTSUPP;
> +       struct btf *btf =3D (struct btf *) info->src_btf;
> +       struct btfgen_type *btfgen_type;
> +       struct btf_member *btf_member;
> +       struct btf_type *btf_type;
> +       struct btf_array *array;
> +       unsigned int id;
> +       int idx, err;
> +
> +       btf_type =3D (struct btf_type *) btf__type_by_id(btf, targ_spec->=
root_type_id);
> +
> +       /* create btfgen_type for root type */
> +       btfgen_type =3D btfgen_put_type(btf, info, btf_type, targ_spec->r=
oot_type_id);
> +       if (!btfgen_type)
> +               return -errno;
> +
> +       /* add types for complex types (arrays, unions, structures) */
> +       for (int i =3D 1; i < targ_spec->raw_len; i++) {
> +               /* skip typedefs and mods */
> +               while (btf_is_mod(btf_type) || btf_is_typedef(btf_type)) =
{
> +                       id =3D btf_type->type;
> +                       btfgen_type =3D btfgen_get_type(info, id);
> +                       if (!btfgen_type)
> +                               return -ENOENT;
> +                       btf_type =3D (struct btf_type *) btf__type_by_id(=
btf, id);
> +               }
> +
> +               switch (btf_kind(btf_type)) {
> +               case BTF_KIND_STRUCT:
> +               case BTF_KIND_UNION:
> +                       idx =3D targ_spec->raw_spec[i];
> +                       btf_member =3D btf_members(btf_type) + idx;
> +                       btf_type =3D (struct btf_type *) btf__type_by_id(=
btf, btf_member->type);
> +
> +                       /* add member to relocation type */
> +                       err =3D btfgen_add_member(btfgen_type, btf_member=
, idx);
> +                       if (err)
> +                               return err;
> +                       /* put btfgen type */
> +                       btfgen_type =3D btfgen_put_type(btf, info, btf_ty=
pe, btf_member->type);
> +                       if (!btfgen_type)
> +                               return -errno;
> +                       break;
> +               case BTF_KIND_ARRAY:
> +                       array =3D btf_array(btf_type);
> +                       btfgen_type =3D btfgen_get_type(info, array->type=
);
> +                       if (!btfgen_type)
> +                               return -ENOENT;
> +                       btf_type =3D (struct btf_type *) btf__type_by_id(=
btf, array->type);

should index_type be added as well?

> +                       break;
> +               default:
> +                       p_err("unsupported kind: %s (%d)",
> +                             btf_kind_str(btf_type), btf_type->type);
> +                       return -EINVAL;
> +               }
> +       }
> +
> +       return 0;
>  }
>
>  static int btfgen_record_type_relo(struct btfgen_info *info, struct bpf_=
core_spec *targ_spec)
>  {
> -       return -EOPNOTSUPP;
> +       struct btf *btf =3D (struct btf *) info->src_btf;
> +       struct btfgen_type *btfgen_type;
> +       struct btf_type *btf_type;
> +
> +       btf_type =3D (struct btf_type *) btf__type_by_id(btf, targ_spec->=
root_type_id);
> +
> +       btfgen_type =3D btfgen_put_type_all(btf, info, btf_type, targ_spe=
c->root_type_id);
> +       return btfgen_type ? 0 : -errno;
>  }
>
>  static int btfgen_record_enumval_relo(struct btfgen_info *info, struct b=
pf_core_spec *targ_spec)
>  {
> -       return -EOPNOTSUPP;
> +       struct btf *btf =3D (struct btf *) info->src_btf;
> +       struct btfgen_type *btfgen_type;
> +       struct btf_type *btf_type;
> +
> +       btf_type =3D (struct btf_type *) btf__type_by_id(btf, targ_spec->=
root_type_id);
> +
> +       btfgen_type =3D btfgen_put_type_all(btf, info, btf_type, targ_spe=
c->root_type_id);
> +       return btfgen_type ? 0 : -errno;
>  }
>
>  static int btfgen_record_reloc(struct btfgen_info *info, struct bpf_core=
_spec *res)
> --
> 2.25.1
>
