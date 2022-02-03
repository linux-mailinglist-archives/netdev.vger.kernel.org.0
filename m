Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7A24A88BD
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239682AbiBCQkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238360AbiBCQkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:40:45 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE15C06173B
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:40:44 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id o17so4764947ljp.1
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 08:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1d7vceQauPxgcMQJdYYBxrR0oTcgwIsEhaw3FTsxa0E=;
        b=RrnCaitnSiznnP/H4PPlC/9gML/JxHEEZHBWddtKYHwQSrg89w8UrRGPuqPQZKoe9q
         j99LvQbkw7YHQ0RBZXSxm0JNkrE9y4VHzkZn52iiWhguV9ibiQQa/Xl4hhBgiV9zr6o6
         AHCq+8sVXAh4Cb8h/UkFdCTgZKfCzwre1++6A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1d7vceQauPxgcMQJdYYBxrR0oTcgwIsEhaw3FTsxa0E=;
        b=14Hj+STNGMpf3BbyAYavtaih8OGAy8PEmjg6NsI6yAjJcksRNfa+2WAsnPwRlKsR50
         yG64AxMNBH7AIkpmNIFDwVUX94oRwRhcz/sPOX78JG8HF/3TBv2Ym7W+n/yswOWHqK8k
         ZDars1uVMvdoldRMuCRv+YdYQ15dfM0BSiAEYUWriRRmdOwnQLP0A5nhiDKvd7CTdALv
         y4VzWzbMTcoEsZkW5OT5Fb+02KtEjaIweq5oxN2hLZE8vC+CqNNO5MyrWPAOWCJnnpyx
         3bwNW+sdBJYZoi/bDfU6BBdkt9aK1DdrnIg52jKKXSCbiu6tVISrwCypeeOUAif3C9Fj
         rnXQ==
X-Gm-Message-State: AOAM530UYzzgSYSjTpg0ZcZ0mQ4PNKIEKziHwd0z9uoXxEvKL6CPMaCr
        AZKcdqs06qXUv+O1MO2bKu/ljY6wFyaZrOQBRB5D0A==
X-Google-Smtp-Source: ABdhPJwUWAgjS141pLO3lU4cedwREp+ZpOv4zYqPlJmuYG0Vu7ks2QVRrl/jSh8IKiv+ah/0tI4jOXuWfP0YOUaZrSA=
X-Received: by 2002:a2e:7a06:: with SMTP id v6mr23684539ljc.301.1643906443118;
 Thu, 03 Feb 2022 08:40:43 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-7-mauricio@kinvolk.io>
 <CAEf4BzZu-u1WXGScPZKVQZc+RGjmnYm45mcOGkzXyFLMKS-5gA@mail.gmail.com>
In-Reply-To: <CAEf4BzZu-u1WXGScPZKVQZc+RGjmnYm45mcOGkzXyFLMKS-5gA@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Thu, 3 Feb 2022 11:40:31 -0500
Message-ID: <CAHap4zv+bLA4BB9ZJ7RXDCChe6dU0AB3zuCieWskp2OJ5Y-4xw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 6/9] bpftool: Implement relocations recording
 for BTFGen
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Wed, Feb 2, 2022 at 2:31 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jan 28, 2022 at 2:33 PM Mauricio V=C3=A1squez <mauricio@kinvolk.i=
o> wrote:
> >
> > This commit implements the logic to record the relocation information
> > for the different kind of relocations.
> >
> > btfgen_record_field_relo() uses the target specification to save all th=
e
> > types that are involved in a field-based CO-RE relocation. In this case
> > types resolved and added recursively (using btfgen_put_type()).
> > Only the struct and union members and their types) involved in the
> > relocation are added to optimize the size of the generated BTF file.
> >
> > On the other hand, btfgen_record_type_relo() saves the types involved i=
n
> > a type-based CO-RE relocation. In this case all the members for the
>
> Do I understand correctly that if someone does
> bpf_core_type_size(struct task_struct), you'll save not just
> task_struct, but also any type that directly and indirectly referenced
> from any task_struct's field, even if that is through a pointer.

That's correct.

> As
> in, do you substitute forward declarations for types that are never
> directly used? If not, that's going to be very suboptimal for
> something like task_struct and any other type that's part of a big
> cluster of types.
>

We decided to include the whole types and all direct and indirect
types referenced from a structure field for type-based relocations.
Our reasoning is that we don't know if the matching algorithm of
libbpf could be changed to require more information in the future and
type-based relocations are few compared to field based relocations.

If you are confident enough that adding empty structures/unions is ok
then I'll update the algorithm. Actually it'll make our lives easier.

> > struct and union types are added. This is not strictly required since
> > libbpf doesn't use them while performing this kind of relocation,
> > however that logic could change on the future. Additionally, we expect
> > that the number of this kind of relocations in an BPF object to be very
> > low, hence the impact on the size of the generated BTF should be
> > negligible.
> >
> > Finally, btfgen_record_enumval_relo() saves the whole enum type for
> > enum-based relocations.
> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > ---
> >  tools/bpf/bpftool/gen.c | 260 +++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 257 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > index bb9c56401ee5..7413ec808a80 100644
> > --- a/tools/bpf/bpftool/gen.c
> > +++ b/tools/bpf/bpftool/gen.c
> > @@ -1119,9 +1119,17 @@ static int btf_save_raw(const struct btf *btf, c=
onst char *path)
> >         return err;
> >  }
> >
> > +struct btfgen_member {
> > +       struct btf_member *member;
> > +       int idx;
> > +};
> > +
> >  struct btfgen_type {
> >         struct btf_type *type;
> >         unsigned int id;
> > +       bool all_members;
> > +
> > +       struct hashmap *members;
> >  };
> >
> >  struct btfgen_info {
> > @@ -1151,6 +1159,19 @@ static void *u32_as_hash_key(__u32 x)
> >
> >  static void btfgen_free_type(struct btfgen_type *type)
> >  {
> > +       struct hashmap_entry *entry;
> > +       size_t bkt;
> > +
> > +       if (!type)
> > +               return;
> > +
> > +       if (!IS_ERR_OR_NULL(type->members)) {
> > +               hashmap__for_each_entry(type->members, entry, bkt) {
> > +                       free(entry->value);
> > +               }
> > +               hashmap__free(type->members);
> > +       }
> > +
> >         free(type);
> >  }
> >
> > @@ -1199,19 +1220,252 @@ btfgen_new_info(const char *targ_btf_path)
> >         return info;
> >  }
> >
> > +static int btfgen_add_member(struct btfgen_type *btfgen_type,
> > +                            struct btf_member *btf_member, int idx)
> > +{
> > +       struct btfgen_member *btfgen_member;
> > +       int err;
> > +
> > +       /* create new members hashmap for this btfgen type if needed */
> > +       if (!btfgen_type->members) {
> > +               btfgen_type->members =3D hashmap__new(btfgen_hash_fn, b=
tfgen_equal_fn, NULL);
> > +               if (IS_ERR(btfgen_type->members))
> > +                       return PTR_ERR(btfgen_type->members);
> > +       }
> > +
> > +       btfgen_member =3D calloc(1, sizeof(*btfgen_member));
> > +       if (!btfgen_member)
> > +               return -ENOMEM;
> > +       btfgen_member->member =3D btf_member;
> > +       btfgen_member->idx =3D idx;
> > +       /* add btf_member as member to given btfgen_type */
> > +       err =3D hashmap__add(btfgen_type->members, uint_as_hash_key(btf=
gen_member->idx),
> > +                          btfgen_member);
> > +       if (err) {
> > +               free(btfgen_member);
> > +               if (err !=3D -EEXIST)
>
> why not check that such a member exists before doing btfgen_member alloca=
tion?
>

I thought that it could be more efficient calling hashmap__add()
directly without checking and then handling the case when it was
already there. Having a second thought it seems to me that it's not
always true and depends on how many times the code follows each path,
what we don't know. I'll change it to check if it's there before.

> > +                       return err;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static struct btfgen_type *btfgen_get_type(struct btfgen_info *info, i=
nt id)
> > +{
> > +       struct btfgen_type *type =3D NULL;
> > +
> > +       hashmap__find(info->types, uint_as_hash_key(id), (void **)&type=
);
>
> if (!hashmap__find(...))
>    return NULL;
>
> > +
> > +       return type;
> > +}
> > +
> > +static struct btfgen_type *
> > +_btfgen_put_type(struct btf *btf, struct btfgen_info *info, struct btf=
_type *btf_type,
> > +                unsigned int id, bool all_members)
> > +{
> > +       struct btfgen_type *btfgen_type, *tmp;
> > +       struct btf_array *array;
> > +       unsigned int child_id;
> > +       struct btf_member *m;
> > +       int err, i, n;
> > +
> > +       /* check if we already have this type */
> > +       if (hashmap__find(info->types, uint_as_hash_key(id), (void **) =
&btfgen_type)) {
> > +               if (!all_members || btfgen_type->all_members)
> > +                       return btfgen_type;
> > +       } else {
> > +               btfgen_type =3D calloc(1, sizeof(*btfgen_type));
> > +               if (!btfgen_type)
> > +                       return NULL;
> > +
> > +               btfgen_type->type =3D btf_type;
> > +               btfgen_type->id =3D id;
> > +
> > +               /* append this type to the types list before anything e=
lse */
>
> what do you mean by "before anything else"?

Add this before starting the recursion below. I'll update the comment
to make it more clear.

>
> > +               err =3D hashmap__add(info->types, uint_as_hash_key(btfg=
en_type->id), btfgen_type);
> > +               if (err) {
> > +                       free(btfgen_type);
> > +                       return NULL;
> > +               }
> > +       }
> > +
> > +       /* avoid infinite recursion and yet be able to add all
> > +        * fields/members for types also managed by this function
> > +        */
> > +       btfgen_type->all_members =3D all_members;
> > +
> > +       /* recursively add other types needed by it */
> > +       switch (btf_kind(btfgen_type->type)) {
> > +       case BTF_KIND_UNKN:
> > +       case BTF_KIND_INT:
> > +       case BTF_KIND_FLOAT:
> > +       case BTF_KIND_ENUM:
> > +               break;
> > +       case BTF_KIND_STRUCT:
> > +       case BTF_KIND_UNION:
> > +               /* doesn't need resolution if not adding all members */
> > +               if (!all_members)
> > +                       break;
> > +
> > +               n =3D btf_vlen(btf_type);
> > +               m =3D btf_members(btf_type);
> > +               for (i =3D 0; i < n; i++, m++) {
> > +                       btf_type =3D (struct btf_type *) btf__type_by_i=
d(btf, m->type);
>
> why `const struct btf_type *` doesn't work everywhere? You are not
> modifying btf_type itself, no?

Yes, `const struct btf_type *` works fine everywhere.

>
> > +
> > +                       /* add all member types */
> > +                       tmp =3D _btfgen_put_type(btf, info, btf_type, m=
->type, all_members);
> > +                       if (!tmp)
> > +                               return NULL;
> > +
> > +                       /* add all members */
> > +                       err =3D btfgen_add_member(btfgen_type, m, i);
> > +                       if (err)
> > +                               return NULL;
> > +               }
> > +               break;
> > +       case BTF_KIND_PTR:
> > +               if (!all_members)
> > +                       break;
> > +       /* fall through */
> > +       /* Also add the type it's pointing to when adding all members *=
/
> > +       case BTF_KIND_CONST:
> > +       case BTF_KIND_VOLATILE:
> > +       case BTF_KIND_TYPEDEF:
> > +               child_id =3D btf_type->type;
> > +               btf_type =3D (struct btf_type *) btf__type_by_id(btf, c=
hild_id);
> > +
> > +               tmp =3D _btfgen_put_type(btf, info, btf_type, child_id,=
 all_members);
> > +               if (!tmp)
> > +                       return NULL;
> > +               break;
> > +       case BTF_KIND_ARRAY:
> > +               array =3D btf_array(btfgen_type->type);
> > +
> > +               /* add type for array type */
> > +               btf_type =3D (struct btf_type *) btf__type_by_id(btf, a=
rray->type);
> > +               tmp =3D _btfgen_put_type(btf, info, btf_type, array->ty=
pe, all_members);
> > +               if (!tmp)
> > +                       return NULL;
> > +
> > +               /* add type for array's index type */
> > +               btf_type =3D (struct btf_type *) btf__type_by_id(btf, a=
rray->index_type);
> > +               tmp =3D _btfgen_put_type(btf, info, btf_type, array->in=
dex_type, all_members);
> > +               if (!tmp)
> > +                       return NULL;
> > +               break;
> > +       /* tells if some other type needs to be handled */
> > +       default:
> > +               p_err("unsupported kind: %s (%d)",
> > +                     btf_kind_str(btfgen_type->type), btfgen_type->id)=
;
> > +               errno =3D EINVAL;
> > +               return NULL;
> > +       }
> > +
> > +       return btfgen_type;
> > +}
> > +
> > +/* Put type in the list. If the type already exists it's returned, oth=
erwise a
> > + * new one is created and added to the list. This is called recursivel=
y adding
> > + * all the types that are needed for the current one.
> > + */
> > +static struct btfgen_type *
> > +btfgen_put_type(struct btf *btf, struct btfgen_info *info, struct btf_=
type *btf_type,
> > +               unsigned int id)
> > +{
> > +       return _btfgen_put_type(btf, info, btf_type, id, false);
> > +}
> > +
> > +/* Same as btfgen_put_type, but adding all members, from given complex=
 type, recursively */
> > +static struct btfgen_type *
> > +btfgen_put_type_all(struct btf *btf, struct btfgen_info *info,
> > +                   struct btf_type *btf_type, unsigned int id)
> > +{
> > +       return _btfgen_put_type(btf, info, btf_type, id, true);
> > +}
>
> these wrappers seem unnecessary, just pass false/true in 5 call sites
> below without extra wrapping of _btfgen_put_type (and call it
> btfgen_put_type then)
>
> > +
> >  static int btfgen_record_field_relo(struct btfgen_info *info, struct b=
pf_core_spec *targ_spec)
> >  {
> > -       return -EOPNOTSUPP;
> > +       struct btf *btf =3D (struct btf *) info->src_btf;
> > +       struct btfgen_type *btfgen_type;
> > +       struct btf_member *btf_member;
> > +       struct btf_type *btf_type;
> > +       struct btf_array *array;
> > +       unsigned int id;
> > +       int idx, err;
> > +
> > +       btf_type =3D (struct btf_type *) btf__type_by_id(btf, targ_spec=
->root_type_id);
> > +
> > +       /* create btfgen_type for root type */
> > +       btfgen_type =3D btfgen_put_type(btf, info, btf_type, targ_spec-=
>root_type_id);
> > +       if (!btfgen_type)
> > +               return -errno;
> > +
> > +       /* add types for complex types (arrays, unions, structures) */
> > +       for (int i =3D 1; i < targ_spec->raw_len; i++) {
> > +               /* skip typedefs and mods */
> > +               while (btf_is_mod(btf_type) || btf_is_typedef(btf_type)=
) {
> > +                       id =3D btf_type->type;
> > +                       btfgen_type =3D btfgen_get_type(info, id);
> > +                       if (!btfgen_type)
> > +                               return -ENOENT;
> > +                       btf_type =3D (struct btf_type *) btf__type_by_i=
d(btf, id);
> > +               }
> > +
> > +               switch (btf_kind(btf_type)) {
> > +               case BTF_KIND_STRUCT:
> > +               case BTF_KIND_UNION:
> > +                       idx =3D targ_spec->raw_spec[i];
> > +                       btf_member =3D btf_members(btf_type) + idx;
> > +                       btf_type =3D (struct btf_type *) btf__type_by_i=
d(btf, btf_member->type);
> > +
> > +                       /* add member to relocation type */
> > +                       err =3D btfgen_add_member(btfgen_type, btf_memb=
er, idx);
> > +                       if (err)
> > +                               return err;
> > +                       /* put btfgen type */
> > +                       btfgen_type =3D btfgen_put_type(btf, info, btf_=
type, btf_member->type);
> > +                       if (!btfgen_type)
> > +                               return -errno;
> > +                       break;
> > +               case BTF_KIND_ARRAY:
> > +                       array =3D btf_array(btf_type);
> > +                       btfgen_type =3D btfgen_get_type(info, array->ty=
pe);
> > +                       if (!btfgen_type)
> > +                               return -ENOENT;
> > +                       btf_type =3D (struct btf_type *) btf__type_by_i=
d(btf, array->type);
>
> should index_type be added as well?

This is added in _btfgen_put_type(). Here we're just updating
`btf_type` with the array's type for the next iteration of this loop.

>
> > +                       break;
> > +               default:
> > +                       p_err("unsupported kind: %s (%d)",
> > +                             btf_kind_str(btf_type), btf_type->type);
> > +                       return -EINVAL;
> > +               }
> > +       }
> > +
> > +       return 0;
> >  }
> >
> >  static int btfgen_record_type_relo(struct btfgen_info *info, struct bp=
f_core_spec *targ_spec)
> >  {
> > -       return -EOPNOTSUPP;
> > +       struct btf *btf =3D (struct btf *) info->src_btf;
> > +       struct btfgen_type *btfgen_type;
> > +       struct btf_type *btf_type;
> > +
> > +       btf_type =3D (struct btf_type *) btf__type_by_id(btf, targ_spec=
->root_type_id);
> > +
> > +       btfgen_type =3D btfgen_put_type_all(btf, info, btf_type, targ_s=
pec->root_type_id);
> > +       return btfgen_type ? 0 : -errno;
> >  }
> >
> >  static int btfgen_record_enumval_relo(struct btfgen_info *info, struct=
 bpf_core_spec *targ_spec)
> >  {
> > -       return -EOPNOTSUPP;
> > +       struct btf *btf =3D (struct btf *) info->src_btf;
> > +       struct btfgen_type *btfgen_type;
> > +       struct btf_type *btf_type;
> > +
> > +       btf_type =3D (struct btf_type *) btf__type_by_id(btf, targ_spec=
->root_type_id);
> > +
> > +       btfgen_type =3D btfgen_put_type_all(btf, info, btf_type, targ_s=
pec->root_type_id);
> > +       return btfgen_type ? 0 : -errno;
> >  }
> >
> >  static int btfgen_record_reloc(struct btfgen_info *info, struct bpf_co=
re_spec *res)
> > --
> > 2.25.1
> >
