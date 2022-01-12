Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB12E48C5FA
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239105AbiALO1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354114AbiALO1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:27:13 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23F5C061748
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:12 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id o15so8665147lfo.11
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3OWlN+v0uCC1aPr6aV1D6OBPZhLTlZoHcpJjRRFzkk0=;
        b=MPcP1D/QFt3EcB83KLypo8ayZjQheThVnle4nf4TRCOT4GkhaMmJ7f+6ThnU+FFhHv
         iDx/XZaSh8k5LNLHrSQRdCBZuLeX8vjjiTuVr6U2ksgB7M+NUiaIkjDmzJyKQHneOTQs
         p67haofOR0P+iwoUuOCFLGKh6O3Hk1d93K6nc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3OWlN+v0uCC1aPr6aV1D6OBPZhLTlZoHcpJjRRFzkk0=;
        b=puFRgz0lfNhwZcCLzkR+POh1fh2N7/AEVgtPRUyZPq6WQbwoMBLO6JdbekTXzNbmU7
         k+++4yes4nUd2YN58/NYFESj8LYENQFM/Nu9za86rqrCQNne80AG/Z5NrjE7idGpm2xj
         ZJspvu2rUGcSBXkZiM3KxexrNcwdC6kmSaJTcqG1lQumI5op2eH8GtwWsnoUslxaF+/R
         17fJeNfOj7et56C2KbWEGdGBvL647tga05LXEPLFor8MQ3zHM/9OvvGCpK7Iv0WfiIPq
         bl6vWXAfH0oML7/kQOJm7/DO+m89YVzL6mu3h5zEWARbOWPqczAGinJJ9NOF0Ue7vtsW
         WlEg==
X-Gm-Message-State: AOAM530K0jkjsKD8Fhs3VPx/j83iXLK22nzLT9ccO32QnI+CN56ple6M
        g+heHHv3Vy97Z2odxECUT/WoreIns6v/CzRVpHFs5Q==
X-Google-Smtp-Source: ABdhPJw5CBYnz0RVpMECgsACQdL0N2XQGxt5g/5HzZf/4nFUxPnSLtm6qwF22UqKrIZkeLCaMVVtkHT+4hmCf8VyR4o=
X-Received: by 2002:a2e:bba1:: with SMTP id y33mr674327lje.274.1641997629647;
 Wed, 12 Jan 2022 06:27:09 -0800 (PST)
MIME-Version: 1.0
References: <20211217185654.311609-1-mauricio@kinvolk.io> <20211217185654.311609-4-mauricio@kinvolk.io>
 <CAEf4BzZ6E_iRT-pBon5G6xA0kK=EYKSZQ3zDLVKQmTT8A12J_Q@mail.gmail.com>
In-Reply-To: <CAEf4BzZ6E_iRT-pBon5G6xA0kK=EYKSZQ3zDLVKQmTT8A12J_Q@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Wed, 12 Jan 2022 09:26:58 -0500
Message-ID: <CAHap4zs9yZFx-z2h=vsqgdzfNgVssNvoWZ3VWswtwREZ0DnHsw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/3] bpftool: Implement btfgen
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

On Wed, Dec 22, 2021 at 7:33 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Dec 17, 2021 at 10:57 AM Mauricio V=C3=A1squez <mauricio@kinvolk.=
io> wrote:
> >
> > The BTFGen's goal is to produce a BTF file that contains **only** the
> > information that is needed by an eBPF program. This algorithm does a
> > first step collecting the types involved for each relocation present on
> > the object and "marking" them as needed. Types are collected in
> > different ways according to the type relocation, for field based
> > relocations only the union and structures members involved are
> > considered, for type based relocations the whole types are added, enum
> > field relocations are not supported in this iteration yet.
> >
> > A second step generates a BTF file from the "marked" types. This step
> > accesses the original BTF file extracting the types and their members
> > that were "marked" as needed in the first step.
> >
> > This command is implemented under the "gen" command in bpftool and the
> > syntax is the following:
> >
> > $ bpftool gen btf INPUT OUTPUT OBJECT(S)
> >
> > INPUT can be either a single BTF file or a folder containing BTF files,
> > when it's a folder, a BTF file is generated for each BTF file contained
> > in this folder. OUTPUT is the file (or folder) where generated files ar=
e
> > stored and OBJECT(S) is the list of bpf objects we want to generate the
> > BTF file(s) for (each generated BTF file contains all the types needed
> > by all the objects).
> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > ---
> >  tools/bpf/bpftool/gen.c | 892 ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 892 insertions(+)
> >
>
> I haven't looked through details of stripping BTF itself, let's
> finalize CO-RE relocation parts first. Maybe for the next revision you
> could split bpftool changes in two in some reasonable way so that each
> patch concentrates on different steps of the process a bit more? E.g.,
> first patch might set up new command and BTF stripping parts but leave
> the CO-RE relocation logic unimplemented, and the second path fills in
> that part. Should make it easier to review this big patch.

I totally agree. Will send v4 with more granular commits.

> Please also cc Quentin Monnet to review bpftool parts as well.

He's already there.

> > +static int btf_reloc_info_gen_type(struct btf_reloc_info *info, struct=
 bpf_core_spec *targ_spec)
> > +{
> > +       struct btf *btf =3D (struct btf *) info->src_btf;
> > +       struct btf_type *btf_type;
> > +       int err =3D 0;
> > +
> > +       btf_type =3D (struct btf_type *) btf__type_by_id(btf, targ_spec=
->root_type_id);
> > +
> > +       return btf_reloc_put_type_all(btf, info, btf_type, targ_spec->r=
oot_type_id);
> > +}
> > +
> > +static int btf_reloc_info_gen_enumval(struct btf_reloc_info *info, str=
uct bpf_core_spec *targ_spec)
> > +{
> > +       p_err("untreated enumval based relocation");
>
> why untreated? what's the problem supporting it?
>

Nothing, we haven't given it any priority. It'll be part of the next iterat=
ion.

> > +static int btf_reloc_info_gen(struct btf_reloc_info *info, struct bpf_=
core_spec *res)
> > +{
> > +       if (core_relo_is_type_based(res->relo_kind))
> > +               return btf_reloc_info_gen_type(info, res);
> > +
> > +       if (core_relo_is_enumval_based(res->relo_kind))
> > +               return btf_reloc_info_gen_enumval(info, res);
> > +
> > +       if (core_relo_is_field_based(res->relo_kind))
> > +               return btf_reloc_info_gen_field(info, res);
>
> you can have a simple switch here instead of exposing libbpf internal hel=
pers
>

Will do.

> > +static int btfgen_obj_reloc_info_gen(struct btf_reloc_info *reloc_info=
, struct bpf_object *obj)
> > +{
> > +       const struct btf_ext_info_sec *sec;
> > +       const struct bpf_core_relo *rec;
> > +       const struct btf_ext_info *seg;
> > +       struct hashmap *cand_cache;
> > +       int err, insn_idx, sec_idx;
> > +       struct bpf_program *prog;
> > +       struct btf_ext *btf_ext;
> > +       const char *sec_name;
> > +       size_t nr_programs;
> > +       struct btf *btf;
> > +       unsigned int i;
> > +
> > +       btf =3D bpf_object__btf(obj);
> > +       btf_ext =3D bpf_object__btf_ext(obj);
> > +
> > +       if (btf_ext->core_relo_info.len =3D=3D 0)
> > +               return 0;
> > +
> > +       cand_cache =3D bpf_core_create_cand_cache();
> > +       if (IS_ERR(cand_cache))
> > +               return PTR_ERR(cand_cache);
> > +
> > +       bpf_object_set_vmlinux_override(obj, reloc_info->src_btf);
> > +
> > +       seg =3D &btf_ext->core_relo_info;
> > +       for_each_btf_ext_sec(seg, sec) {
> > +               bool prog_found;
> > +
> > +               sec_name =3D btf__name_by_offset(btf, sec->sec_name_off=
);
> > +               if (str_is_empty(sec_name)) {
> > +                       err =3D -EINVAL;
> > +                       goto out;
> > +               }
> > +
> > +               prog_found =3D false;
> > +               nr_programs =3D bpf_object__get_nr_programs(obj);
> > +               for (i =3D 0; i < nr_programs; i++)       {
> > +                       prog =3D bpf_object__get_program(obj, i);
> > +                       if (strcmp(bpf_program__section_name(prog), sec=
_name) =3D=3D 0) {
> > +                               prog_found =3D true;
> > +                               break;
> > +                       }
> > +               }
> > +
> > +               if (!prog_found) {
> > +                       pr_warn("sec '%s': failed to find a BPF program=
\n", sec_name);
> > +                       err =3D -EINVAL;
> > +                       goto out;
> > +               }
> > +
> > +               sec_idx =3D bpf_program__sec_idx(prog);
> > +
> > +               for_each_btf_ext_rec(seg, sec, i, rec) {
> > +                       struct bpf_core_relo_res targ_res;
> > +                       struct bpf_core_spec targ_spec;
> > +
> > +                       insn_idx =3D rec->insn_off / BPF_INSN_SZ;
> > +
> > +                       prog =3D find_prog_by_sec_insn(obj, sec_idx, in=
sn_idx);
> > +                       if (!prog) {
> > +                               pr_warn("sec '%s': failed to find progr=
am at insn #%d for CO-RE offset relocation #%d\n",
> > +                                       sec_name, insn_idx, i);
> > +                               err =3D -EINVAL;
> > +                               goto out;
> > +                       }
> > +
> > +                       err =3D bpf_core_calc_relo_res(prog, rec, i, bt=
f, cand_cache, &targ_res,
> > +                                                    &targ_spec);
>
>
> I don't think you need to do *exactly* what libbpf is doing.
> bpf_core_calc_relo_res() doesn't add much on top of
> bpf_core_calc_relo_insn(), if you use bpf_core_calc_relo_insn()
> directly and expose bpf_core_add_cands/bpf_core_free_cands and use
> them directly as well, bypassing bpf_object completely, you won't need
> btf_vmlinux override and make everything less coupled, I think. In the
> future, if you'd like to support BTF module BTFs, you'll have all the
> necessary flexibility to do that, while if you try to reuse every
> single line of bpf_object's code we'll be adding more hacks like your
> bpf_object_set_vmlinux_override().
>
> Fundamentally, you don't care about bpf_object and bpf_programs. All
> you need to do is parse .BTF.ext (you can do that just btf__parse, no
> need to even construct bpf_object!). Construct candidate cache, then
> iterate each CO-RE record, add find/add candidates, calculate
> relocation result, use it for your algorithm.
>
> Yes, there will be a bit of duplication (candidate search), but that's
> better than trying to turn bpf_object inside out with all the custom
> getters/setters that you are exposing (even if it's libbpf internal
> only, still makes it really hard to reasons what's going on and what
> are consequences of manual control over a lot of bpf_object internal
> implementation details).
>

Thanks a lot for this suggestion. We implemented it this way and the
result is much better.
