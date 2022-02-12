Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769D44B321F
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 01:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354463AbiBLAmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 19:42:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349382AbiBLAms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 19:42:48 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A6FC1B;
        Fri, 11 Feb 2022 16:42:45 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id e8so8096550ilm.13;
        Fri, 11 Feb 2022 16:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eEHWfIFM38XneDN9wIgSCDwM3cBT8ZNFBVfOUEsfGx8=;
        b=VftPwOFkMTqB18Wtv958tgvgC0dCy4kRXmaC9cwR06VsGQ9Ba0vDtPCAIG613cLvg5
         +K9cjDh544B6TelNhWxWw5cSVa2c9AeWOV4NXmKxxvRkOVtWeiLVYrne3HbrajwVtMDm
         0o+hfGliw7vhBOcX5bH3vRKEUZjhhMmGzmVndNYDOqi9DiCaUA97G3IJxRJKofDhVI8y
         PLIjsECIBrK/VLsEKPHu324UNf5yHtLI95G/9KmYivKn59EjtEYEr7KP3z7kF9NA3QYQ
         cnE4hHbKGQCi5nh9iKmmUODjtYV43PhFkWNZqU5GTyrNXK8h7GcpOjUKEgHPkst2aiFm
         RnUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eEHWfIFM38XneDN9wIgSCDwM3cBT8ZNFBVfOUEsfGx8=;
        b=bUh4CTn9gPVLeUUwrvdQld1BtDyWSnW6qsUzlM8/GIsTyaiMeyQMapbR6nTId3RnMW
         qJWxReowGaLErKsVck2UG2P16uO5oDpQHV8/sgmPtEExFBJ7YsfH585bcVruJ7APvhe4
         EoMO9tY1jNU7XKLOnjnd83Hb+gAA3CWHKGcaWfYC91ME9XzqA984e2BXt/t8lzrqLHyJ
         8GEsItOyk9cP1WI+rFI8imFHKVjmOcorny5G2sYA9lC2PwUjyt7DQ7i5unXbFr9WmUGQ
         iw6w8v5H6LwFoOpudtzKy/ZvcKVjYzJEaetDyoGRTheBY5aKpuC9GN04F79w4FvKwSjD
         J0bg==
X-Gm-Message-State: AOAM533JoE3t8M4t/8/eZslW0zoYZ4GSwbhdcStd2EZqUeT8POxIHBy7
        rR+DIxMgCv6Tpgu5F4zKCz9ZSglD18N/TDt+Aig=
X-Google-Smtp-Source: ABdhPJxsvhROq8uaPvf/hW++NOKBCU2s4dMN8wlNX2M7jLt4S6O+WAcW8gTEKCjeHXEIGpOLxtNTOfj12XcbdU0hIYo=
X-Received: by 2002:a05:6e02:1565:: with SMTP id k5mr2274074ilu.239.1644626564823;
 Fri, 11 Feb 2022 16:42:44 -0800 (PST)
MIME-Version: 1.0
References: <20220209222646.348365-1-mauricio@kinvolk.io> <20220209222646.348365-5-mauricio@kinvolk.io>
In-Reply-To: <20220209222646.348365-5-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Feb 2022 16:42:33 -0800
Message-ID: <CAEf4BzZaVTdsQbFhStzNavHMhkv4yVm=yc2vqsgFQnZqKZfXpg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 4/7] bpftool: Implement minimize_btf() and
 relocations recording for BTFGen
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 9, 2022 at 2:27 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io> =
wrote:
>

It would be good to shorten the subject line, it's very long.

> minimize_btf() receives the path of a source and destination BTF files
> and a list of BPF objects. This function records the relocations for
> all objects and then generates the BTF file by calling btfgen_get_btf()
> (implemented in the following commit).
>
> btfgen_record_obj() loads the BTF and BTF.ext sections of the BPF
> objects and loops through all CO-RE relocations. It uses
> bpf_core_calc_relo_insn() from libbpf and passes the target spec to
> btfgen_record_reloc(), that calls one of the following functions
> depending on the relocation kind.
>
> btfgen_record_field_relo() uses the target specification to mark all the
> types that are involved in a field-based CO-RE relocation. In this case
> types resolved and marked recursively using btfgen_mark_type().
> Only the struct and union members (and their types) involved in the
> relocation are marked to optimize the size of the generated BTF file.
>
> btfgen_record_type_relo() marks the types involved in a type-based
> CO-RE relocation. In this case no members for the struct and union
> types are marked as libbpf doesn't use them while performing this kind
> of relocation. Pointed types are marked as they are used by libbpf in
> this case.
>
> btfgen_record_enumval_relo() marks the whole enum type for enum-based
> relocations.

It should be enough to leave only used enumerators, but I suppose it
doesn't take much space to record all. We can adjust that later, if
necessary.

>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/bpf/bpftool/Makefile |   8 +-
>  tools/bpf/bpftool/gen.c    | 452 ++++++++++++++++++++++++++++++++++++-
>  2 files changed, 454 insertions(+), 6 deletions(-)
>

Looks good, few nits and concerns, but it feels like it's really close
to being ready.

[...]

> +}
> +
> +struct btfgen_info {
> +       struct btf *src_btf;
> +       struct btf *marked_btf; // btf structure used to mark used types

C++ comment, please use /* */

> +};
> +
> +static size_t btfgen_hash_fn(const void *key, void *ctx)
> +{
> +       return (size_t)key;
> +}
> +
> +static bool btfgen_equal_fn(const void *k1, const void *k2, void *ctx)
> +{
> +       return k1 =3D=3D k2;
> +}
> +
> +static void *uint_as_hash_key(int x)
> +{
> +       return (void *)(uintptr_t)x;
> +}
> +
> +static void *u32_as_hash_key(__u32 x)
> +{
> +       return (void *)(uintptr_t)x;
> +}
> +
> +static void btfgen_free_info(struct btfgen_info *info)
> +{
> +       if (!info)
> +               return;
> +
> +       btf__free(info->src_btf);
> +       btf__free(info->marked_btf);
> +
> +       free(info);
> +}
> +
> +static struct btfgen_info *
> +btfgen_new_info(const char *targ_btf_path)
> +{
> +       struct btfgen_info *info;
> +       int err;
> +
> +       info =3D calloc(1, sizeof(*info));
> +       if (!info)
> +               return NULL;
> +
> +       info->src_btf =3D btf__parse(targ_btf_path, NULL);
> +       if (!info->src_btf) {
> +               p_err("failed parsing '%s' BTF file: %s", targ_btf_path, =
strerror(errno));
> +               err =3D -errno;

save errno before p_err, it can clobber errno otherwise

> +               goto err_out;
> +       }
> +
> +       info->marked_btf =3D btf__parse(targ_btf_path, NULL);
> +       if (!info->marked_btf) {
> +               p_err("failed parsing '%s' BTF file: %s", targ_btf_path, =
strerror(errno));
> +               err =3D -errno;

same, always save errno first before any non-trivial function/macro call


> +               goto err_out;
> +       }
> +
> +       return info;
> +
> +err_out:
> +       btfgen_free_info(info);
> +       errno =3D -err;
> +       return NULL;
> +}
> +
> +#define MARKED UINT32_MAX
> +
> +static void btfgen_mark_member(struct btfgen_info *info, int type_id, in=
t idx)
> +{
> +       const struct btf_type *t =3D btf__type_by_id(info->marked_btf, ty=
pe_id);
> +       struct btf_member *m =3D btf_members(t) + idx;
> +
> +       m->name_off =3D MARKED;
> +}
> +
> +static int
> +btfgen_mark_type(struct btfgen_info *info, unsigned int id, bool follow_=
pointers)

id is type_id or could be some other id? It's best to be consistent in
naming to avoid second guessing like in this case.

> +{
> +       const struct btf_type *btf_type =3D btf__type_by_id(info->src_btf=
, id);
> +       struct btf_type *cloned_type;
> +       struct btf_param *param;
> +       struct btf_array *array;
> +       int err, i;

[...]

> +       /* tells if some other type needs to be handled */
> +       default:
> +               p_err("unsupported kind: %s (%d)", btf_kind_str(btf_type)=
, id);
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
> +static int btfgen_record_field_relo(struct btfgen_info *info, struct bpf=
_core_spec *targ_spec)
> +{
> +       struct btf *btf =3D (struct btf *) info->src_btf;

why the cast?

> +       const struct btf_type *btf_type;
> +       struct btf_member *btf_member;
> +       struct btf_array *array;
> +       unsigned int id =3D targ_spec->root_type_id;
> +       int idx, err;
> +
> +       /* mark root type */
> +       btf_type =3D btf__type_by_id(btf, id);
> +       err =3D btfgen_mark_type(info, id, false);
> +       if (err)
> +               return err;
> +
> +       /* mark types for complex types (arrays, unions, structures) */
> +       for (int i =3D 1; i < targ_spec->raw_len; i++) {
> +               /* skip typedefs and mods */
> +               while (btf_is_mod(btf_type) || btf_is_typedef(btf_type)) =
{
> +                       id =3D btf_type->type;
> +                       btf_type =3D btf__type_by_id(btf, id);
> +               }
> +
> +               switch (btf_kind(btf_type)) {
> +               case BTF_KIND_STRUCT:
> +               case BTF_KIND_UNION:
> +                       idx =3D targ_spec->raw_spec[i];
> +                       btf_member =3D btf_members(btf_type) + idx;
> +
> +                       /* mark member */
> +                       btfgen_mark_member(info, id, idx);
> +
> +                       /* mark member's type */
> +                       id =3D btf_member->type;
> +                       btf_type =3D btf__type_by_id(btf, id);
> +                       err =3D btfgen_mark_type(info, id, false);

why would it not follow the pointer? E.g., if I have a field defined as

struct blah ***my_field;

You at the very least would need either an empty struct blah or FWD
for struct blah, no?

> +                       if (err)
> +                               return err;
> +                       break;
> +               case BTF_KIND_ARRAY:
> +                       array =3D btf_array(btf_type);
> +                       id =3D array->type;
> +                       btf_type =3D btf__type_by_id(btf, id);
> +                       break;

[...]

> +err_out:
> +       bpf_core_free_cands(cands);
> +       errno =3D -err;
> +       return NULL;
> +}
> +
> +/* Record relocation information for a single BPF object*/

nit: missing space before */

> +static int btfgen_record_obj(struct btfgen_info *info, const char *obj_p=
ath)
> +{
> +       const struct btf_ext_info_sec *sec;
> +       const struct bpf_core_relo *relo;
> +       const struct btf_ext_info *seg;
> +       struct hashmap_entry *entry;
> +       struct hashmap *cand_cache =3D NULL;
> +       struct btf_ext *btf_ext =3D NULL;
> +       unsigned int relo_idx;
> +       struct btf *btf =3D NULL;
> +       size_t i;
> +       int err;
> +
> +       btf =3D btf__parse(obj_path, &btf_ext);
> +       if (!btf) {
> +               p_err("failed to parse BPF object '%s': %s", obj_path, st=
rerror(errno));
> +               return -errno;
> +       }

check that btf_ext is not NULL?

> +
> +       if (btf_ext->core_relo_info.len =3D=3D 0) {
> +               err =3D 0;
> +               goto out;
> +       }
> +

[...]
