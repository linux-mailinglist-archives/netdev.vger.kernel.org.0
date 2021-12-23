Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A6D47DC0D
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 01:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbhLWAdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 19:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbhLWAdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 19:33:38 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9A4C061574;
        Wed, 22 Dec 2021 16:33:38 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id o7so3200081ioo.9;
        Wed, 22 Dec 2021 16:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T7TDR+rBDs36WUAy25gQk92HXXkSG9z80Fet8bRwtzM=;
        b=F/2p+EV4t07ly6zlat2oVSrKPXmE3zf87Ps364/sRqi+TAnOZoxKAAjfD7zQSz8X9S
         YXYyZjhsORBCaEN8OBlmWIyWrS7129/RtW1k1M72eWCn2yFq/kTF2toBVOrzH9rP8/4v
         q2MFMi+zPtKAgnVAc+wbJJvAogSO1thH3dXpoRrny+87RRAKQk+5Y1pZcteHKr56LMRA
         u/elGrY1LtOyB+Mh5o2hJvwS07Kvh1j0VJ8Q9bDKtQeBb3JbbwrKJFXWKv6go/r7Jobe
         WtYFaBo1KqSGkTytVpOo5TQ+MuzceAMJIqgsrGF5vy6Imy5JWbNmuJ5S/a7XYLm8SYMq
         u7Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T7TDR+rBDs36WUAy25gQk92HXXkSG9z80Fet8bRwtzM=;
        b=4DUT3JIP0yJ5pXe/wmyta4qbOt+m8NVcpJHRPYR0LUQzEhylT8DiIvUhUp05t2SDQU
         G7sxgA1GE+1bGKKCwM0cTlqSFTR0ZmFRWndr3It1vLPoOIF9TVT/cL4Tiy9YwkrO6864
         PJDs6v2Ngy41tKqCEX+cB35bhxp+VYDdXBJjwpTZEti/p1buAu9H4oC1ptQDZrkXUPgW
         pJGi6j1QA7G88+t2GitUGRF4PZRC2+H9W5IPXAmylBp9/k79PUAdcCx3p2j7M7suhAHz
         gQlE7C0FZVx+JjUUIiiBv9gN/8rwlrdxHkxkrA76n5KNJVRYXHBTJTXKQEZbWmDtVYkn
         3FBA==
X-Gm-Message-State: AOAM530o+T96vasW4FmBeWrBkTGjLUhaNC4+/88zJeEn5cmlKXw4fgrZ
        HTgvv2FK8/tKMYEgECscrKn7BpgibyEYFoo1zLQ=
X-Google-Smtp-Source: ABdhPJzgS9tN/KXZAVoyR+P9zcqhUo0uw8o18klYT3SNmIn0v7/m2FSbxwQqHvtC5ODKhT650hXQv0LPMefL9ugUOkU=
X-Received: by 2002:a02:c6a5:: with SMTP id o5mr3037802jan.145.1640219617371;
 Wed, 22 Dec 2021 16:33:37 -0800 (PST)
MIME-Version: 1.0
References: <20211217185654.311609-1-mauricio@kinvolk.io> <20211217185654.311609-2-mauricio@kinvolk.io>
In-Reply-To: <20211217185654.311609-2-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 Dec 2021 16:33:26 -0800
Message-ID: <CAEf4BzZw2RBPSxE0j8uQd8-75qOfq=iPnhB73ONErsHYUaF+pg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] libbpf: split bpf_core_apply_relo()
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

On Fri, Dec 17, 2021 at 10:57 AM Mauricio V=C3=A1squez <mauricio@kinvolk.io=
> wrote:
>
> BTFGen needs to run the core relocation logic in order to understand
> what are the types in the target BTF that involved in a given
> relocation.
>
> Currently bpf_core_apply_relo() calculates and **applies** a relocation
> to an instruction. Having both operations in the same function makes it
> difficult to only calculate the relocation without patching the
> instruction. This commit splits that logic in two different phases: (1)
> calculate the relocation and (2) patch the instruction.
>
> For the first phase bpf_core_apply_relo() is renamed to
> bpf_core_calc_relo_res() who is now only on charge of calculating the
> relocation, the second phase uses the already existing
> bpf_core_patch_insn(). bpf_object__relocate_core() uses both of them and
> the BTFGen will use only bpf_core_calc_relo_res().
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  kernel/bpf/btf.c          | 11 +++++-
>  tools/lib/bpf/libbpf.c    | 54 ++++++++++++++++-----------
>  tools/lib/bpf/relo_core.c | 77 +++++++++++----------------------------
>  tools/lib/bpf/relo_core.h | 42 ++++++++++++++++++---
>  4 files changed, 99 insertions(+), 85 deletions(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index a17de71abd2e..5a8f6ef6a341 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -6734,6 +6734,7 @@ int bpf_core_apply(struct bpf_core_ctx *ctx, const =
struct bpf_core_relo *relo,
>  {
>         bool need_cands =3D relo->kind !=3D BPF_CORE_TYPE_ID_LOCAL;
>         struct bpf_core_cand_list cands =3D {};
> +       struct bpf_core_relo_res targ_res;
>         struct bpf_core_spec *specs;
>         int err;
>
> @@ -6778,8 +6779,14 @@ int bpf_core_apply(struct bpf_core_ctx *ctx, const=
 struct bpf_core_relo *relo,
>                  */
>         }
>
> -       err =3D bpf_core_apply_relo_insn((void *)ctx->log, insn, relo->in=
sn_off / 8,
> -                                      relo, relo_idx, ctx->btf, &cands, =
specs);
> +       err =3D bpf_core_calc_relo_insn((void *)ctx->log, relo, relo_idx,=
 ctx->btf, &cands, specs,
> +                                     &targ_res);
> +       if (err)
> +               goto out;
> +
> +       err =3D bpf_core_patch_insn((void *)ctx->log, insn, relo->insn_of=
f / 8, relo, relo_idx,
> +                                 &targ_res);
> +
>  out:
>         kfree(specs);
>         if (need_cands) {
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index cf862a19222b..77e2df13715a 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -5498,11 +5498,12 @@ static int record_relo_core(struct bpf_program *p=
rog,
>         return 0;
>  }
>
> -static int bpf_core_apply_relo(struct bpf_program *prog,
> -                              const struct bpf_core_relo *relo,
> -                              int relo_idx,
> -                              const struct btf *local_btf,
> -                              struct hashmap *cand_cache)
> +static int bpf_core_calc_relo_res(struct bpf_program *prog,

bpf_core_calc_relo_res is almost indistinguishable from
bpf_core_calc_relo... Let's call this one bpf_core_resolve_relo()?

> +                                 const struct bpf_core_relo *relo,
> +                                 int relo_idx,
> +                                 const struct btf *local_btf,
> +                                 struct hashmap *cand_cache,
> +                                 struct bpf_core_relo_res *targ_res)

[...]

>  static int
>  bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_p=
ath)
>  {
>         const struct btf_ext_info_sec *sec;
> +       struct bpf_core_relo_res targ_res;
>         const struct bpf_core_relo *rec;
>         const struct btf_ext_info *seg;
>         struct hashmap_entry *entry;
>         struct hashmap *cand_cache =3D NULL;
>         struct bpf_program *prog;
> +       struct bpf_insn *insn;
>         const char *sec_name;
>         int i, err =3D 0, insn_idx, sec_idx;
>
> @@ -5636,12 +5627,31 @@ bpf_object__relocate_core(struct bpf_object *obj,=
 const char *targ_btf_path)
>                         if (!prog->load)
>                                 continue;
>
> -                       err =3D bpf_core_apply_relo(prog, rec, i, obj->bt=
f, cand_cache);
> +                       err =3D bpf_core_calc_relo_res(prog, rec, i, obj-=
>btf, cand_cache, &targ_res);
>                         if (err) {
>                                 pr_warn("prog '%s': relo #%d: failed to r=
elocate: %d\n",
>                                         prog->name, i, err);
>                                 goto out;
>                         }
> +
> +                       if (rec->insn_off % BPF_INSN_SZ)
> +                               return -EINVAL;
> +                       insn_idx =3D rec->insn_off / BPF_INSN_SZ;
> +                       /* adjust insn_idx from section frame of referenc=
e to the local
> +                        * program's frame of reference; (sub-)program co=
de is not yet
> +                        * relocated, so it's enough to just subtract in-=
section offset
> +                        */
> +                       insn_idx =3D insn_idx - prog->sec_insn_off;
> +                       if (insn_idx >=3D prog->insns_cnt)
> +                               return -EINVAL;
> +                       insn =3D &prog->insns[insn_idx];

this is sort of like sanity checks, let's do them before the core_calc
step, so after that it's a clean sequence of calc_relo + pathc_insn?

> +
> +                       err =3D bpf_core_patch_insn(prog->name, insn, ins=
n_idx, rec, i, &targ_res);
> +                       if (err) {
> +                               pr_warn("prog '%s': relo #%d: failed to p=
atch insn #%u: %d\n",
> +                                       prog->name, i, insn_idx, err);
> +                               goto out;
> +                       }
>                 }
>         }
>

[...]

>  {
>         __u32 orig_val, new_val;
>         __u8 class;
> @@ -1177,18 +1152,18 @@ static void bpf_core_dump_spec(const char *prog_n=
ame, int level, const struct bp
>   *    between multiple relocations for the same type ID and is updated a=
s some
>   *    of the candidates are pruned due to structural incompatibility.
>   */
> -int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *ins=
n,
> -                            int insn_idx,
> -                            const struct bpf_core_relo *relo,
> -                            int relo_idx,
> -                            const struct btf *local_btf,
> -                            struct bpf_core_cand_list *cands,
> -                            struct bpf_core_spec *specs_scratch)
> +int bpf_core_calc_relo_insn(const char *prog_name,

please update the comment for this function, it's not "CO-RE relocate
single instruction" anymore, it's more like "Calculate CO-RE
relocation target result" or something along those lines.

> +                           const struct bpf_core_relo *relo,
> +                           int relo_idx,
> +                           const struct btf *local_btf,
> +                           struct bpf_core_cand_list *cands,
> +                           struct bpf_core_spec *specs_scratch,
> +                           struct bpf_core_relo_res *targ_res)
>  {
>         struct bpf_core_spec *local_spec =3D &specs_scratch[0];
>         struct bpf_core_spec *cand_spec =3D &specs_scratch[1];
>         struct bpf_core_spec *targ_spec =3D &specs_scratch[2];
> -       struct bpf_core_relo_res cand_res, targ_res;
> +       struct bpf_core_relo_res cand_res;
>         const struct btf_type *local_type;
>         const char *local_name;
>         __u32 local_id;
> @@ -1223,12 +1198,12 @@ int bpf_core_apply_relo_insn(const char *prog_nam=
e, struct bpf_insn *insn,
>         /* TYPE_ID_LOCAL relo is special and doesn't need candidate searc=
h */
>         if (relo->kind =3D=3D BPF_CORE_TYPE_ID_LOCAL) {
>                 /* bpf_insn's imm value could get out of sync during link=
ing */
> -               memset(&targ_res, 0, sizeof(targ_res));
> -               targ_res.validate =3D false;
> -               targ_res.poison =3D false;
> -               targ_res.orig_val =3D local_spec->root_type_id;
> -               targ_res.new_val =3D local_spec->root_type_id;
> -               goto patch_insn;
> +               memset(targ_res, 0, sizeof(*targ_res));
> +               targ_res->validate =3D true;

hm.. original code sets it to false here, please don't regress the logic

> +               targ_res->poison =3D false;
> +               targ_res->orig_val =3D local_spec->root_type_id;
> +               targ_res->new_val =3D local_spec->root_type_id;
> +               return 0;
>         }
>
>         /* libbpf doesn't support candidate search for anonymous types */

[...]
