Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710824A78CE
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 20:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346937AbiBBThB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 14:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiBBThB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 14:37:01 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B0FC061714;
        Wed,  2 Feb 2022 11:37:01 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id w7so398438ioj.5;
        Wed, 02 Feb 2022 11:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=B1Nrhw+BlYiE7E7WmRuxZJpP8KhLxv9y9+FUzKrhRGQ=;
        b=eREbdTvplXNrDWzyMkvMYYcvXnrTJapx9ADLhA8wpyR38REepNGbmPLtp3se2ZagGs
         d//7BQwp+x6og0nVgO6wHf+QUGm+hvCaLXceHuHqIPogLOyjBT96O3fO9xtB44lHRi7z
         7syuz7Uv32FU2XSdrfDNiybL6AiOOhfP4rH9J8b9i+fu/tXDgoO3QAk9fp2yyNuTW0Nu
         /kTpDoxLjFPep2kJV1rfVir2/+SDPWvjYeBkodPH00xE2FQMgbHljKkmH1IoX2BddoaX
         r7SIfXow6hDO/dbVmGFQ0hyeAejqXr9eQXRKUA64QkvTFCD8sqJRHUzH+L8Y6x87IFxj
         kRcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=B1Nrhw+BlYiE7E7WmRuxZJpP8KhLxv9y9+FUzKrhRGQ=;
        b=LURXiCRJT2XeD5c8cgb35UgN4QNaFxeNYCaGhcKeJ6TDVnDkT6YJb28be/zMxdZGTD
         9BVKp3ELWJsa6QKRD5WHeNnKAtsIECceWC442Gx/t5qc+T9EHqV2/3dDaH2TsaxBCJyf
         zUIb3v6pt9g2lK1Y2h+G/W2O3i8vvM2BcKcRlMt6Z8XOJvz1BYWpOEBMGPtm1aMg5MCQ
         97hU+uES3y6A1Dr16nHGwb7rP6uyZ6cwsmoUI231k/865fLJYsKjiww7rxwnNOlSXh9J
         fsNtFH0yR3fTP6MzSZx9r+SMb/oF319yxtOycDeSrYnP590U1JzvlnU3vGytNGMoIyDP
         dmGg==
X-Gm-Message-State: AOAM531AbwXySU/DmNpLREI8tvFNevqyhj0ndk7cl82icIj3JonebU9v
        uCWWinzPmwaOZOV2QB6N+9sIZ3pLLFIi/1zJJhY=
X-Google-Smtp-Source: ABdhPJxislD3cXxoJshXHyMXKUVjnPq/erpgf3nIl4c8bmdRxQETATVXrCYokp7vibWRFmGlUudEoCGKLDxAIREqOrI=
X-Received: by 2002:a05:6638:304d:: with SMTP id u13mr14475725jak.103.1643830620751;
 Wed, 02 Feb 2022 11:37:00 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-8-mauricio@kinvolk.io>
In-Reply-To: <20220128223312.1253169-8-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Feb 2022 11:36:49 -0800
Message-ID: <CAEf4BzaQ-hwdgqxYro5DjdY_=nnXTJVravt0D9qHW=PQZe-Lfg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 7/9] bpftool: Implement btfgen_get_btf()
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
> The last part of the BTFGen algorithm is to create a new BTF object with
> all the types that were recorded in the previous steps.
>
> This function performs two different steps:
> 1. Add the types to the new BTF object by using btf__add_type(). Some
> special logic around struct and unions is implemented to only add the
> members that are really used in the field-based relocations. The type
> ID on the new and old BTF objects is stored on a map.
> 2. Fix all the type IDs on the new BTF object by using the IDs saved in
> the previous step.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/bpf/bpftool/gen.c | 158 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 157 insertions(+), 1 deletion(-)
>
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index 7413ec808a80..55e6f640cbbb 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -1599,10 +1599,166 @@ static int btfgen_record_obj(struct btfgen_info =
*info, const char *obj_path)
>         return err;
>  }
>
> +static unsigned int btfgen_get_id(struct hashmap *ids, unsigned int old)
> +{
> +       uintptr_t new =3D 0;
> +
> +       /* deal with BTF_KIND_VOID */
> +       if (old =3D=3D 0)
> +               return 0;
> +
> +       if (!hashmap__find(ids, uint_as_hash_key(old), (void **)&new)) {
> +               /* return id for void as it's possible that the ID we're =
looking for is
> +                * the type of a pointer that we're not adding.
> +                */
> +               return 0;
> +       }
> +
> +       return (unsigned int)(uintptr_t)new;
> +}
> +
> +static int btfgen_add_id(struct hashmap *ids, unsigned int old, unsigned=
 int new)
> +{
> +       return hashmap__add(ids, uint_as_hash_key(old), uint_as_hash_key(=
new));
> +}
> +
>  /* Generate BTF from relocation information previously recorded */
>  static struct btf *btfgen_get_btf(struct btfgen_info *info)
>  {
> -       return ERR_PTR(-EOPNOTSUPP);
> +       struct hashmap_entry *entry;
> +       struct btf *btf_new =3D NULL;
> +       struct hashmap *ids =3D NULL;
> +       size_t bkt;
> +       int err =3D 0;
> +
> +       btf_new =3D btf__new_empty();
> +       if (libbpf_get_error(btf_new))
> +               goto err_out;
> +
> +       ids =3D hashmap__new(btfgen_hash_fn, btfgen_equal_fn, NULL);
> +       if (IS_ERR(ids)) {
> +               errno =3D -PTR_ERR(ids);
> +               goto err_out;
> +       }
> +
> +       /* first pass: add all types and add their new ids to the ids map=
 */
> +       hashmap__for_each_entry(info->types, entry, bkt) {
> +               struct btfgen_type *btfgen_type =3D entry->value;
> +               struct btf_type *btf_type =3D btfgen_type->type;
> +               int new_id;
> +
> +               /* we're adding BTF_KIND_VOID to the list but it can't be=
 added to
> +                * the generated BTF object, hence we skip it here.
> +                */
> +               if (btfgen_type->id =3D=3D 0)
> +                       continue;
> +
> +               /* add members for struct and union */
> +               if (btf_is_struct(btf_type) || btf_is_union(btf_type)) {
> +                       struct hashmap_entry *member_entry;
> +                       struct btf_type *btf_type_cpy;
> +                       int nmembers, index;
> +                       size_t new_size;
> +
> +                       nmembers =3D btfgen_type->members ? hashmap__size=
(btfgen_type->members) : 0;
> +                       new_size =3D sizeof(struct btf_type) + nmembers *=
 sizeof(struct btf_member);
> +
> +                       btf_type_cpy =3D malloc(new_size);
> +                       if (!btf_type_cpy)
> +                               goto err_out;
> +
> +                       /* copy header */
> +                       memcpy(btf_type_cpy, btf_type, sizeof(*btf_type_c=
py));
> +
> +                       /* copy only members that are needed */
> +                       index =3D 0;
> +                       if (nmembers > 0) {
> +                               size_t bkt2;
> +
> +                               hashmap__for_each_entry(btfgen_type->memb=
ers, member_entry, bkt2) {
> +                                       struct btfgen_member *btfgen_memb=
er;
> +                                       struct btf_member *btf_member;
> +
> +                                       btfgen_member =3D member_entry->v=
alue;
> +                                       btf_member =3D btf_members(btf_ty=
pe) + btfgen_member->idx;
> +
> +                                       memcpy(btf_members(btf_type_cpy) =
+ index, btf_member,
> +                                              sizeof(struct btf_member))=
;

you know that you are working with btf_type and btf_member, each have
just a few well known fields, why memcpy instead of just setting each
field individually? I think that would make code much easier to follow
and understand what transformations it's doing (and what it doesn't do
either).

> +
> +                                       index++;
> +                               }
> +                       }
> +
> +                       /* set new vlen */
> +                       btf_type_cpy->info =3D btf_type_info(btf_kind(btf=
_type_cpy), nmembers,
> +                                                          btf_kflag(btf_=
type_cpy));
> +
> +                       err =3D btf__add_type(btf_new, info->src_btf, btf=
_type_cpy);
> +                       free(btf_type_cpy);
> +               } else {
> +                       err =3D btf__add_type(btf_new, info->src_btf, btf=
_type);
> +               }
> +
> +               if (err < 0)
> +                       goto err_out;
> +
> +               new_id =3D err;
> +
> +               /* add ID mapping */
> +               err =3D btfgen_add_id(ids, btfgen_type->id, new_id);
> +               if (err)
> +                       goto err_out;
> +       }
> +
> +       /* second pass: fix up type ids */
> +       for (unsigned int i =3D 0; i < btf__type_cnt(btf_new); i++) {
> +               struct btf_member *btf_member;
> +               struct btf_type *btf_type;
> +               struct btf_param *params;
> +               struct btf_array *array;
> +
> +               btf_type =3D (struct btf_type *) btf__type_by_id(btf_new,=
 i);
> +
> +               switch (btf_kind(btf_type)) {
> +               case BTF_KIND_STRUCT:
> +               case BTF_KIND_UNION:
> +                       for (unsigned short j =3D 0; j < btf_vlen(btf_typ=
e); j++) {
> +                               btf_member =3D btf_members(btf_type) + j;
> +                               btf_member->type =3D btfgen_get_id(ids, b=
tf_member->type);
> +                       }
> +                       break;
> +               case BTF_KIND_PTR:
> +               case BTF_KIND_TYPEDEF:
> +               case BTF_KIND_VOLATILE:
> +               case BTF_KIND_CONST:
> +               case BTF_KIND_RESTRICT:
> +               case BTF_KIND_FUNC:
> +               case BTF_KIND_VAR:
> +                       btf_type->type =3D btfgen_get_id(ids, btf_type->t=
ype);
> +                       break;
> +               case BTF_KIND_ARRAY:
> +                       array =3D btf_array(btf_type);
> +                       array->index_type =3D btfgen_get_id(ids, array->i=
ndex_type);
> +                       array->type =3D btfgen_get_id(ids, array->type);
> +                       break;
> +               case BTF_KIND_FUNC_PROTO:
> +                       btf_type->type =3D btfgen_get_id(ids, btf_type->t=
ype);
> +                       params =3D btf_params(btf_type);
> +                       for (unsigned short j =3D 0; j < btf_vlen(btf_typ=
e); j++)
> +                               params[j].type =3D btfgen_get_id(ids, par=
ams[j].type);
> +                       break;

did you try using btf_type_visit_type_ids() instead of this entire loop?

> +               default:
> +                       break;
> +               }
> +       }
> +
> +       hashmap__free(ids);
> +       return btf_new;
> +
> +err_out:
> +       btf__free(btf_new);
> +       hashmap__free(ids);
> +       return NULL;
>  }
>
>  /* Create BTF file for a set of BPF objects.
> --
> 2.25.1
>
