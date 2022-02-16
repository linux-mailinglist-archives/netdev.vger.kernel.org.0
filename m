Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD4E4B7C8E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 02:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245455AbiBPBYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 20:24:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245444AbiBPBYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 20:24:20 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9486813CDD;
        Tue, 15 Feb 2022 17:24:08 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id r8so578603ioc.8;
        Tue, 15 Feb 2022 17:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+9LhJn76Q9nH2bIX/iWRsnqiaFBi51Iwt1vsLl/mpUo=;
        b=UOq/6oD9sOFFgKiyBOFs9yj1aHL5qAp8nzOFJJLeG/xJngtsZKXlaktz9cAjazCFJ+
         qc66wRH0Nm7t1D53jbhFK/AcPVfureBVAV5h5I13pKTjJMfRP2Ac40ByQtPVTdRiXIfC
         dUFXhdN4lP3KSSSC7id9CbuPdnmEM6kOaV3sKc6RICEyMV8HEOQWHQZAFzk0bu15RnU7
         reRYvBLeTHgDTqF659vXm47ac0k9OFGWZWS8T/UbSehyC3D5zzTfJwpySiTQEA0Q16Rr
         cyoxOpypUTrW6cfaMh3UawLAMw3F6E21yftO6ESxeZ/o7I0n+fUJwjIteguZZ+saNV56
         37Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+9LhJn76Q9nH2bIX/iWRsnqiaFBi51Iwt1vsLl/mpUo=;
        b=GqhWoOsq2cr8OdJA6EO7dR2DfKWJEHsHkTMxxlT7EVets4Pl6Fzfv49/mZDvrxUs6M
         cY9jUm4/QH/559Z0IyeI4CWO3mSDYIRWePpS4WhOlS1RDgk/J19epowpl1mnW46wxICT
         KVfgsLMPkJhSQgrf5fAFAMAB7FHYRtbpT7vUSeaO1iPRt0TttTD6hKlmt6faRlr56oRC
         u8XFPXVpXocQvVNfsOeP5i68wUzotDValdTDSmcTs/ix9pD/9Zxm9tC4CopTTz00Om3V
         yP2CkYJNsv5RGSqDR3TJaqqH0x4bca3F1aTiuIUFJ9doTlXCxUapW9OSxwYTbM4wlmrU
         r7hw==
X-Gm-Message-State: AOAM530ZqnikKHzvo/sOvJzNnKvJgKR2EBZ66cKt1UYkHElgoXNYiezG
        xeLxISxLhrcnJJvjVQjuIMZ+/5UH7Sc7lEpJ60Y=
X-Google-Smtp-Source: ABdhPJwclw6bg/uoWRHMI5oeO/w6XeJBpXVmSUYpLL8Yt+oODrnJaC6r1/y/k8jPsP3uQBoNVFZJWE5wF2NYtyMfVDU=
X-Received: by 2002:a5e:860c:0:b0:5ed:1c25:df3f with SMTP id
 z12-20020a5e860c000000b005ed1c25df3fmr359795ioj.144.1644974647875; Tue, 15
 Feb 2022 17:24:07 -0800 (PST)
MIME-Version: 1.0
References: <20220209222646.348365-1-mauricio@kinvolk.io> <20220209222646.348365-5-mauricio@kinvolk.io>
 <CAEf4BzZaVTdsQbFhStzNavHMhkv4yVm=yc2vqsgFQnZqKZfXpg@mail.gmail.com> <CAHap4zswzgkJYTxYcmvnokEwfT2=XtJ46x5sjxFc3_PJ01YQcA@mail.gmail.com>
In-Reply-To: <CAHap4zswzgkJYTxYcmvnokEwfT2=XtJ46x5sjxFc3_PJ01YQcA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Feb 2022 17:23:56 -0800
Message-ID: <CAEf4BzYs=0BLAhNuJz=arN2VqWCc+L+nv7HqNaFV-bLYMP_1rw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 4/7] bpftool: Implement minimize_btf() and
 relocations recording for BTFGen
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
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

On Tue, Feb 15, 2022 at 2:56 PM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> On Fri, Feb 11, 2022 at 7:42 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Feb 9, 2022 at 2:27 PM Mauricio V=C3=A1squez <mauricio@kinvolk.=
io> wrote:
> > >
> >
> > It would be good to shorten the subject line, it's very long.
> >
>
> Will do.
>
> > > minimize_btf() receives the path of a source and destination BTF file=
s
> > > and a list of BPF objects. This function records the relocations for
> > > all objects and then generates the BTF file by calling btfgen_get_btf=
()
> > > (implemented in the following commit).
> > >
> > > btfgen_record_obj() loads the BTF and BTF.ext sections of the BPF
> > > objects and loops through all CO-RE relocations. It uses
> > > bpf_core_calc_relo_insn() from libbpf and passes the target spec to
> > > btfgen_record_reloc(), that calls one of the following functions
> > > depending on the relocation kind.
> > >
> > > btfgen_record_field_relo() uses the target specification to mark all =
the
> > > types that are involved in a field-based CO-RE relocation. In this ca=
se
> > > types resolved and marked recursively using btfgen_mark_type().
> > > Only the struct and union members (and their types) involved in the
> > > relocation are marked to optimize the size of the generated BTF file.
> > >
> > > btfgen_record_type_relo() marks the types involved in a type-based
> > > CO-RE relocation. In this case no members for the struct and union
> > > types are marked as libbpf doesn't use them while performing this kin=
d
> > > of relocation. Pointed types are marked as they are used by libbpf in
> > > this case.
> > >
> > > btfgen_record_enumval_relo() marks the whole enum type for enum-based
> > > relocations.
> >
> > It should be enough to leave only used enumerators, but I suppose it
> > doesn't take much space to record all. We can adjust that later, if
> > necessary.
> >
>
> I think the overhead is really minimal and we can improve later on if we =
want.
>
> > >
> > > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > > ---
> > >  tools/bpf/bpftool/Makefile |   8 +-
> > >  tools/bpf/bpftool/gen.c    | 452 +++++++++++++++++++++++++++++++++++=
+-
> > >  2 files changed, 454 insertions(+), 6 deletions(-)
> > >
> >
> > Looks good, few nits and concerns, but it feels like it's really close
> > to being ready.
> >
> > [...]
> >
> > > +}
> > > +
> > > +struct btfgen_info {
> > > +       struct btf *src_btf;
> > > +       struct btf *marked_btf; // btf structure used to mark used ty=
pes
> >
> > C++ comment, please use /* */
> >
> > > +};
> > > +
> > > +static size_t btfgen_hash_fn(const void *key, void *ctx)
> > > +{
> > > +       return (size_t)key;
> > > +}
> > > +
> > > +static bool btfgen_equal_fn(const void *k1, const void *k2, void *ct=
x)
> > > +{
> > > +       return k1 =3D=3D k2;
> > > +}
> > > +
> > > +static void *uint_as_hash_key(int x)
> > > +{
> > > +       return (void *)(uintptr_t)x;
> > > +}
> > > +
> > > +static void *u32_as_hash_key(__u32 x)
> > > +{
> > > +       return (void *)(uintptr_t)x;
> > > +}
> > > +
> > > +static void btfgen_free_info(struct btfgen_info *info)
> > > +{
> > > +       if (!info)
> > > +               return;
> > > +
> > > +       btf__free(info->src_btf);
> > > +       btf__free(info->marked_btf);
> > > +
> > > +       free(info);
> > > +}
> > > +
> > > +static struct btfgen_info *
> > > +btfgen_new_info(const char *targ_btf_path)
> > > +{
> > > +       struct btfgen_info *info;
> > > +       int err;
> > > +
> > > +       info =3D calloc(1, sizeof(*info));
> > > +       if (!info)
> > > +               return NULL;
> > > +
> > > +       info->src_btf =3D btf__parse(targ_btf_path, NULL);
> > > +       if (!info->src_btf) {
> > > +               p_err("failed parsing '%s' BTF file: %s", targ_btf_pa=
th, strerror(errno));
> > > +               err =3D -errno;
> >
> > save errno before p_err, it can clobber errno otherwise
> >
> > > +               goto err_out;
> > > +       }
> > > +
> > > +       info->marked_btf =3D btf__parse(targ_btf_path, NULL);
> > > +       if (!info->marked_btf) {
> > > +               p_err("failed parsing '%s' BTF file: %s", targ_btf_pa=
th, strerror(errno));
> > > +               err =3D -errno;
> >
> > same, always save errno first before any non-trivial function/macro cal=
l
> >
>
> oh right, thanks!
>
> >
> > > +               goto err_out;
> > > +       }
> > > +
> > > +       return info;
> > > +
> > > +err_out:
> > > +       btfgen_free_info(info);
> > > +       errno =3D -err;
> > > +       return NULL;
> > > +}
> > > +
> > > +#define MARKED UINT32_MAX
> > > +
> > > +static void btfgen_mark_member(struct btfgen_info *info, int type_id=
, int idx)
> > > +{
> > > +       const struct btf_type *t =3D btf__type_by_id(info->marked_btf=
, type_id);
> > > +       struct btf_member *m =3D btf_members(t) + idx;
> > > +
> > > +       m->name_off =3D MARKED;
> > > +}
> > > +
> > > +static int
> > > +btfgen_mark_type(struct btfgen_info *info, unsigned int id, bool fol=
low_pointers)
> >
> > id is type_id or could be some other id? It's best to be consistent in
> > naming to avoid second guessing like in this case.
>
> It's always type_id. Renamed it.
>
> >
> > > +{
> > > +       const struct btf_type *btf_type =3D btf__type_by_id(info->src=
_btf, id);
> > > +       struct btf_type *cloned_type;
> > > +       struct btf_param *param;
> > > +       struct btf_array *array;
> > > +       int err, i;
> >
> > [...]
> >
> > > +       /* tells if some other type needs to be handled */
> > > +       default:
> > > +               p_err("unsupported kind: %s (%d)", btf_kind_str(btf_t=
ype), id);
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +static int btfgen_record_field_relo(struct btfgen_info *info, struct=
 bpf_core_spec *targ_spec)
> > > +{
> > > +       struct btf *btf =3D (struct btf *) info->src_btf;
> >
> > why the cast?
> >
>
> No reason. Will remove it.
>
> > > +       const struct btf_type *btf_type;
> > > +       struct btf_member *btf_member;
> > > +       struct btf_array *array;
> > > +       unsigned int id =3D targ_spec->root_type_id;
> > > +       int idx, err;
> > > +
> > > +       /* mark root type */
> > > +       btf_type =3D btf__type_by_id(btf, id);
> > > +       err =3D btfgen_mark_type(info, id, false);
> > > +       if (err)
> > > +               return err;
> > > +
> > > +       /* mark types for complex types (arrays, unions, structures) =
*/
> > > +       for (int i =3D 1; i < targ_spec->raw_len; i++) {
> > > +               /* skip typedefs and mods */
> > > +               while (btf_is_mod(btf_type) || btf_is_typedef(btf_typ=
e)) {
> > > +                       id =3D btf_type->type;
> > > +                       btf_type =3D btf__type_by_id(btf, id);
> > > +               }
> > > +
> > > +               switch (btf_kind(btf_type)) {
> > > +               case BTF_KIND_STRUCT:
> > > +               case BTF_KIND_UNION:
> > > +                       idx =3D targ_spec->raw_spec[i];
> > > +                       btf_member =3D btf_members(btf_type) + idx;
> > > +
> > > +                       /* mark member */
> > > +                       btfgen_mark_member(info, id, idx);
> > > +
> > > +                       /* mark member's type */
> > > +                       id =3D btf_member->type;
> > > +                       btf_type =3D btf__type_by_id(btf, id);
> > > +                       err =3D btfgen_mark_type(info, id, false);
> >
> > why would it not follow the pointer? E.g., if I have a field defined as
> >
> > struct blah ***my_field;
> >
> > You at the very least would need either an empty struct blah or FWD
> > for struct blah, no?
> >
>
> It's an optimization we do, we don't follow the pointer here because
> it is possible that the definition of the pointed type is not needed.
> For instance, a relocation like:
>
> BPF_CORE_READ(task, nsproxy);
>
> will generate this:
>
> [1] STRUCT 'task_struct' size=3D9472 vlen=3D1
>     'nsproxy' type_id=3D2 bits_offset=3D23040
> [2] PTR '(anon)' type_id=3D0
>
> struct nsproxy is not really accessed, so we don't need it's
> definition. On the other hand, something like
>
> BPF_CORE_READ(task, nsproxy, count);
>
> has two relocations, and nsproxy is actually accessed, so in this case
> the generated BTF includes a nsproxy struct:
>
> [1] STRUCT '(anon)' size=3D4 vlen=3D0
> [2] TYPEDEF 'atomic_t' type_id=3D1
> [3] STRUCT 'task_struct' size=3D9472 vlen=3D1
>     'nsproxy' type_id=3D4 bits_offset=3D23040
> [4] PTR '(anon)' type_id=3D5
> [5] STRUCT 'nsproxy' size=3D72 vlen=3D1
>     'count' type_id=3D2 bits_offset=3D0

Ok, so you are just replacing what would be a pointer to forward
declaration with void *. Ok, I guess that works as well.

>
> > > +                       if (err)
> > > +                               return err;
> > > +                       break;
> > > +               case BTF_KIND_ARRAY:
> > > +                       array =3D btf_array(btf_type);
> > > +                       id =3D array->type;
> > > +                       btf_type =3D btf__type_by_id(btf, id);
> > > +                       break;
> >
> > [...]
> >
> > > +err_out:
> > > +       bpf_core_free_cands(cands);
> > > +       errno =3D -err;
> > > +       return NULL;
> > > +}
> > > +
> > > +/* Record relocation information for a single BPF object*/
> >
> > nit: missing space before */
> >
> > > +static int btfgen_record_obj(struct btfgen_info *info, const char *o=
bj_path)
> > > +{
> > > +       const struct btf_ext_info_sec *sec;
> > > +       const struct bpf_core_relo *relo;
> > > +       const struct btf_ext_info *seg;
> > > +       struct hashmap_entry *entry;
> > > +       struct hashmap *cand_cache =3D NULL;
> > > +       struct btf_ext *btf_ext =3D NULL;
> > > +       unsigned int relo_idx;
> > > +       struct btf *btf =3D NULL;
> > > +       size_t i;
> > > +       int err;
> > > +
> > > +       btf =3D btf__parse(obj_path, &btf_ext);
> > > +       if (!btf) {
> > > +               p_err("failed to parse BPF object '%s': %s", obj_path=
, strerror(errno));
> > > +               return -errno;
> > > +       }
> >
> > check that btf_ext is not NULL?
> >
>
> Done.
>
>
> > > +
> > > +       if (btf_ext->core_relo_info.len =3D=3D 0) {
> > > +               err =3D 0;
> > > +               goto out;
> > > +       }
> > > +
> >
> > [...]
