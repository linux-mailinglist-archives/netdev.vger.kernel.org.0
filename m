Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836BC47DC0B
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 01:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhLWAdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 19:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbhLWAdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 19:33:33 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F01C061574;
        Wed, 22 Dec 2021 16:33:33 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id b187so4980495iof.11;
        Wed, 22 Dec 2021 16:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gY9LjUHmpsMeed/h1Vvemd1F4/+mT2RTFdkKZKRXxEs=;
        b=n7b7ROksTDmpt0JaI7ISo8QfsjBA4iiRcJDrw7bb41vHGJmIhlSHvG5UZ29v+MjjF7
         OgH4fieiJC5+S1aBlLRFp9NU/dusuLdga23WV3GBl1K9cK4pgwH1A6AjFPAGW3R91NBH
         01BgYxp4AujHmcnJLxdHCoymuWaJOT5LJGXPoHTBDP6pbkte3zCmfSLydfnlGkWqzuZe
         THnY/ugYigHgtZv9Cr6CzYFIiVt4p8dL2j9b3H70UmchsDYHo46Jivkl/JwfhCPKSJDL
         3nsJVfoKUT2iqfC4HwBUmdX5gJat+gpj0XXkZGTLZ5qowhqi+D61UpN7kcFI/RkBChUI
         mEvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gY9LjUHmpsMeed/h1Vvemd1F4/+mT2RTFdkKZKRXxEs=;
        b=HJ+Kum74uBMJ+OE12zWM9tSZg2dqsiuHLxUQpG5SEsvolW5jCrY0Bn7tHCuz0y2F1v
         n0lp+kfZ3YDS39lgztk15Fjf+FbC7A8D6KO3eBMfIoyHiBQeN9qoS77+XbGNWIE9sV1Z
         3VzzXNfTfipas1sEa7fJgV5bUwTTngpbCScpkGe2zniPEQwO8Euq1Ptq2KJ6VKlGQLti
         e8Lm8+IGg8W6b9y0Kt62+0U7epZTKLMjSdvBIWbviJ4iVnEpvjkfl2Pgag9dkg4aeo6I
         AobZbgGazhzp4TiMa+REor3ui9jxgF1QMFkUwUhJydnkKzkXg9Z8L9evKYrL7pCiFWU3
         nZ4Q==
X-Gm-Message-State: AOAM533GERPzeKERuf4bJaUJBElUrnUOZcXMSuA5W8u2p2+aeqFdTSBW
        WVzSGZ2clvJlnHe1sn2gd4FJgh31FFLXooV+8/4=
X-Google-Smtp-Source: ABdhPJxvqgFbVf1ZFjiP4lQZ4j/FfbadIQssH7vGkJBU3EvlswsNWq03tHWpZ1aTUz9hUJ29QBTUP5a0Qm+qvmNkBJc=
X-Received: by 2002:a5d:9f01:: with SMTP id q1mr83175iot.144.1640219612894;
 Wed, 22 Dec 2021 16:33:32 -0800 (PST)
MIME-Version: 1.0
References: <20211217185654.311609-1-mauricio@kinvolk.io> <20211217185654.311609-3-mauricio@kinvolk.io>
In-Reply-To: <20211217185654.311609-3-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 Dec 2021 16:33:21 -0800
Message-ID: <CAEf4BzbtbxkPZKUEye9=CbOtR-e25cv_5_FyH_Qd8hk9TtsiJQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: Implement changes needed for
 BTFGen in bpftool
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
> Given that BTFGen is a so unique use case, let's expose some of the
> libbpf internal APIs to bpftool. This commit extends libbpf with the
> features that are needed to implement it.
>
> Specifically, this commit introduces the following functions:
> - bpf_object__btf_ext(): Public method to access the BTF.ext section of
> an bpf object.
> - bpf_program__sec_idx(): Public method to get the sec index of a
> program within the elf file.
> - Implement bpf_core_create_cand_cache() and bpf_core_free_cand_cache()
> to handle candidates cache.
> - Expose bpf_core_calc_relo_res() in libbpfinternal.h and add "struct
> bpf_core_spec *targ_spec" parameter.
> - bpf_object_set_vmlinux_override(): Internal function to set
> obj->btf_vmlinux_override.
> - bpf_object__get_nr_programs() and bpf_object__get_program(): To give
> access to the program inside an object. bpf_object__for_each_program
> is not good enough because BTFGen needs to access subprograms too.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/lib/bpf/Makefile          |  2 +-
>  tools/lib/bpf/libbpf.c          | 88 ++++++++++++++++++++++++++-------
>  tools/lib/bpf/libbpf.h          |  3 ++
>  tools/lib/bpf/libbpf.map        |  2 +
>  tools/lib/bpf/libbpf_internal.h | 22 +++++++++
>  tools/lib/bpf/relo_core.c       |  6 +--
>  tools/lib/bpf/relo_core.h       |  4 ++
>  7 files changed, 104 insertions(+), 23 deletions(-)
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index f947b61b2107..dba019ee2832 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -239,7 +239,7 @@ install_lib: all_cmd
>
>  SRC_HDRS :=3D bpf.h libbpf.h btf.h libbpf_common.h libbpf_legacy.h xsk.h=
      \
>             bpf_helpers.h bpf_tracing.h bpf_endian.h bpf_core_read.h     =
    \
> -           skel_internal.h libbpf_version.h
> +           skel_internal.h libbpf_version.h relo_core.h libbpf_internal.=
h
>  GEN_HDRS :=3D $(BPF_GENERATED)
>
>  INSTALL_PFX :=3D $(DESTDIR)$(prefix)/include/bpf
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 77e2df13715a..7c8f8797475f 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4027,8 +4027,8 @@ static bool prog_contains_insn(const struct bpf_pro=
gram *prog, size_t insn_idx)
>                insn_idx < prog->sec_insn_off + prog->sec_insn_cnt;
>  }
>
> -static struct bpf_program *find_prog_by_sec_insn(const struct bpf_object=
 *obj,
> -                                                size_t sec_idx, size_t i=
nsn_idx)
> +struct bpf_program *find_prog_by_sec_insn(const struct bpf_object *obj,
> +                                         size_t sec_idx, size_t insn_idx=
)
>  {
>         int l =3D 0, r =3D obj->nr_programs - 1, m;
>         struct bpf_program *prog;
> @@ -5498,12 +5498,13 @@ static int record_relo_core(struct bpf_program *p=
rog,
>         return 0;
>  }
>
> -static int bpf_core_calc_relo_res(struct bpf_program *prog,
> -                                 const struct bpf_core_relo *relo,
> -                                 int relo_idx,
> -                                 const struct btf *local_btf,
> -                                 struct hashmap *cand_cache,
> -                                 struct bpf_core_relo_res *targ_res)
> +int bpf_core_calc_relo_res(struct bpf_program *prog,
> +                          const struct bpf_core_relo *relo,
> +                          int relo_idx,
> +                          const struct btf *local_btf,
> +                          struct hashmap *cand_cache,
> +                          struct bpf_core_relo_res *targ_res,
> +                          struct bpf_core_spec *targ_spec)

maybe let's add targ_spec and local_spec into bpf_core_relo_res? that
way bpf_core_relo_res contains all the relevant information around
CO-RE relo resolution?

>  {
>         struct bpf_core_spec specs_scratch[3] =3D {};
>         const void *type_key =3D u32_as_hash_key(relo->type_id);
> @@ -5548,8 +5549,32 @@ static int bpf_core_calc_relo_res(struct bpf_progr=
am *prog,
>                 }
>         }
>
> -       return bpf_core_calc_relo_insn(prog_name, relo, relo_idx, local_b=
tf, cands,
> -                                      specs_scratch, targ_res);
> +       err =3D bpf_core_calc_relo_insn(prog_name, relo, relo_idx, local_=
btf, cands,
> +                                     specs_scratch, targ_res);
> +       if (err)
> +               return err;
> +
> +       if (targ_spec)
> +               *targ_spec =3D specs_scratch[2];

and then we'll avoid this ugliness

> +       return 0;
> +}
> +
> +struct hashmap *bpf_core_create_cand_cache(void)
> +{
> +       return hashmap__new(bpf_core_hash_fn, bpf_core_equal_fn, NULL);
> +}
> +
> +void bpf_core_free_cand_cache(struct hashmap *cand_cache)
> +{
> +       struct hashmap_entry *entry;
> +       int i;
> +
> +       if (!IS_ERR_OR_NULL(cand_cache)) {
> +               hashmap__for_each_entry(cand_cache, entry, i) {
> +                       bpf_core_free_cands(entry->value);
> +               }
> +               hashmap__free(cand_cache);
> +       }
>  }
>
>  static int
> @@ -5559,7 +5584,6 @@ bpf_object__relocate_core(struct bpf_object *obj, c=
onst char *targ_btf_path)
>         struct bpf_core_relo_res targ_res;
>         const struct bpf_core_relo *rec;
>         const struct btf_ext_info *seg;
> -       struct hashmap_entry *entry;
>         struct hashmap *cand_cache =3D NULL;
>         struct bpf_program *prog;
>         struct bpf_insn *insn;
> @@ -5578,7 +5602,7 @@ bpf_object__relocate_core(struct bpf_object *obj, c=
onst char *targ_btf_path)
>                 }
>         }
>
> -       cand_cache =3D hashmap__new(bpf_core_hash_fn, bpf_core_equal_fn, =
NULL);
> +       cand_cache =3D bpf_core_create_cand_cache();
>         if (IS_ERR(cand_cache)) {
>                 err =3D PTR_ERR(cand_cache);
>                 goto out;
> @@ -5627,7 +5651,8 @@ bpf_object__relocate_core(struct bpf_object *obj, c=
onst char *targ_btf_path)
>                         if (!prog->load)
>                                 continue;
>
> -                       err =3D bpf_core_calc_relo_res(prog, rec, i, obj-=
>btf, cand_cache, &targ_res);
> +                       err =3D bpf_core_calc_relo_res(prog, rec, i, obj-=
>btf, cand_cache, &targ_res,
> +                                                    NULL);
>                         if (err) {
>                                 pr_warn("prog '%s': relo #%d: failed to r=
elocate: %d\n",
>                                         prog->name, i, err);
> @@ -5660,12 +5685,8 @@ bpf_object__relocate_core(struct bpf_object *obj, =
const char *targ_btf_path)
>         btf__free(obj->btf_vmlinux_override);
>         obj->btf_vmlinux_override =3D NULL;
>
> -       if (!IS_ERR_OR_NULL(cand_cache)) {
> -               hashmap__for_each_entry(cand_cache, entry, i) {
> -                       bpf_core_free_cands(entry->value);
> -               }
> -               hashmap__free(cand_cache);
> -       }
> +       bpf_core_free_cand_cache(cand_cache);
> +
>         return err;
>  }
>
> @@ -8190,6 +8211,11 @@ struct btf *bpf_object__btf(const struct bpf_objec=
t *obj)
>         return obj ? obj->btf : NULL;
>  }
>
> +struct btf_ext *bpf_object__btf_ext(const struct bpf_object *obj)
> +{
> +       return obj ? obj->btf_ext : NULL;

just return obj->btf_ext, no one should be passing NULL for those getters

> +}
> +
>  int bpf_object__btf_fd(const struct bpf_object *obj)
>  {
>         return obj->btf ? btf__fd(obj->btf) : -1;
> @@ -8281,6 +8307,20 @@ bpf_object__next_program(const struct bpf_object *=
obj, struct bpf_program *prev)
>         return prog;
>  }
>
> +size_t bpf_object__get_nr_programs(const struct bpf_object *obj)
> +{
> +       return obj->nr_programs;
> +}
> +
> +struct bpf_program *
> +bpf_object__get_program(const struct bpf_object *obj, unsigned int i)
> +{
> +       if (i >=3D obj->nr_programs)
> +               return NULL;
> +
> +       return &obj->programs[i];
> +}
> +
>  struct bpf_program *
>  bpf_program__prev(struct bpf_program *next, const struct bpf_object *obj=
)
>  {
> @@ -8360,6 +8400,11 @@ int bpf_program__set_autoload(struct bpf_program *=
prog, bool autoload)
>         return 0;
>  }
>
> +int bpf_program__sec_idx(const struct bpf_program *prog)
> +{
> +       return prog->sec_idx;
> +}
> +
>  static int bpf_program_nth_fd(const struct bpf_program *prog, int n);
>
>  int bpf_program__fd(const struct bpf_program *prog)
> @@ -11779,3 +11824,8 @@ void bpf_object__destroy_skeleton(struct bpf_obje=
ct_skeleton *s)
>         free(s->progs);
>         free(s);
>  }
> +
> +void bpf_object_set_vmlinux_override(struct bpf_object *obj, struct btf =
*btf)
> +{
> +       obj->btf_vmlinux_override =3D btf;
> +}

I don't think we need this, see comments in next patch


> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 42b2f36fd9f0..2b048ee5a9b2 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -225,6 +225,8 @@ LIBBPF_API int bpf_object__set_kversion(struct bpf_ob=
ject *obj, __u32 kern_versi
>
>  struct btf;
>  LIBBPF_API struct btf *bpf_object__btf(const struct bpf_object *obj);
> +struct btf_ext;
> +LIBBPF_API struct btf_ext *bpf_object__btf_ext(const struct bpf_object *=
obj);
>  LIBBPF_API int bpf_object__btf_fd(const struct bpf_object *obj);
>
>  LIBBPF_DEPRECATED_SINCE(0, 7, "use bpf_object__find_program_by_name() in=
stead")
> @@ -290,6 +292,7 @@ LIBBPF_API LIBBPF_DEPRECATED("BPF program title is co=
nfusing term; please use bp
>  const char *bpf_program__title(const struct bpf_program *prog, bool need=
s_copy);
>  LIBBPF_API bool bpf_program__autoload(const struct bpf_program *prog);
>  LIBBPF_API int bpf_program__set_autoload(struct bpf_program *prog, bool =
autoload);
> +LIBBPF_API int bpf_program__sec_idx(const struct bpf_program *prog);
>
>  /* returns program size in bytes */
>  LIBBPF_DEPRECATED_SINCE(0, 7, "use bpf_program__insn_cnt() instead")
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index b3938b3f8fc9..15da4075e0b5 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -392,6 +392,7 @@ LIBBPF_0.6.0 {
>                 bpf_map__map_extra;
>                 bpf_map__set_map_extra;
>                 bpf_map_create;
> +               bpf_object__btf_ext;
>                 bpf_object__next_map;
>                 bpf_object__next_program;
>                 bpf_object__prev_map;
> @@ -401,6 +402,7 @@ LIBBPF_0.6.0 {
>                 bpf_program__flags;
>                 bpf_program__insn_cnt;
>                 bpf_program__insns;
> +               bpf_program__sec_idx;
>                 bpf_program__set_flags;
>                 btf__add_btf;
>                 btf__add_decl_tag;
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_inter=
nal.h
> index 5dbe4f463880..b1962adb110c 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -524,4 +524,26 @@ static inline int ensure_good_fd(int fd)
>         return fd;
>  }
>
> +struct hashmap;
> +
> +int bpf_core_calc_relo_res(struct bpf_program *prog,
> +                          const struct bpf_core_relo *relo,
> +                          int relo_idx,
> +                          const struct btf *local_btf,
> +                          struct hashmap *cand_cache,
> +                          struct bpf_core_relo_res *targ_res,
> +                          struct bpf_core_spec *targ_spec);
> +void bpf_object_set_vmlinux_override(struct bpf_object *obj, struct btf =
*btf);
> +struct hashmap *bpf_core_create_cand_cache(void);
> +void bpf_core_free_cand_cache(struct hashmap *cand_cache);
> +
> +struct bpf_program *find_prog_by_sec_insn(const struct bpf_object *obj,
> +                                         size_t sec_idx, size_t insn_idx=
);
> +
> +size_t bpf_object__get_nr_programs(const struct bpf_object *obj);
> +
> +struct bpf_program *
> +bpf_object__get_program(const struct bpf_object *obj, unsigned int n);
> +

that's too much, I don't think you need bpf_program and all the things
around it (sec_idx, look up, etc). As for core_relo_is_field_based and
co, bpftool can do those simple checks on their own, no need to make
all the "internal API", don't overdo it with "let's expose internals
of libbpf to bpftool".


> +
>  #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
> diff --git a/tools/lib/bpf/relo_core.c b/tools/lib/bpf/relo_core.c
> index 4f3552468624..66dfb7fa89a2 100644
> --- a/tools/lib/bpf/relo_core.c
> +++ b/tools/lib/bpf/relo_core.c
> @@ -102,7 +102,7 @@ static const char *core_relo_kind_str(enum bpf_core_r=
elo_kind kind)
>         }
>  }
>
> -static bool core_relo_is_field_based(enum bpf_core_relo_kind kind)
> +bool core_relo_is_field_based(enum bpf_core_relo_kind kind)
>  {
>         switch (kind) {
>         case BPF_CORE_FIELD_BYTE_OFFSET:
> @@ -117,7 +117,7 @@ static bool core_relo_is_field_based(enum bpf_core_re=
lo_kind kind)
>         }
>  }
>
> -static bool core_relo_is_type_based(enum bpf_core_relo_kind kind)
> +bool core_relo_is_type_based(enum bpf_core_relo_kind kind)
>  {
>         switch (kind) {
>         case BPF_CORE_TYPE_ID_LOCAL:
> @@ -130,7 +130,7 @@ static bool core_relo_is_type_based(enum bpf_core_rel=
o_kind kind)
>         }
>  }
>
> -static bool core_relo_is_enumval_based(enum bpf_core_relo_kind kind)
> +bool core_relo_is_enumval_based(enum bpf_core_relo_kind kind)
>  {
>         switch (kind) {
>         case BPF_CORE_ENUMVAL_EXISTS:
> diff --git a/tools/lib/bpf/relo_core.h b/tools/lib/bpf/relo_core.h
> index a28bf3711ce2..e969dfb032f4 100644
> --- a/tools/lib/bpf/relo_core.h
> +++ b/tools/lib/bpf/relo_core.h
> @@ -84,4 +84,8 @@ int bpf_core_patch_insn(const char *prog_name, struct b=
pf_insn *insn,
>                         int insn_idx, const struct bpf_core_relo *relo,
>                         int relo_idx, const struct bpf_core_relo_res *res=
);
>
> +bool core_relo_is_field_based(enum bpf_core_relo_kind kind);
> +bool core_relo_is_type_based(enum bpf_core_relo_kind kind);
> +bool core_relo_is_enumval_based(enum bpf_core_relo_kind kind);
> +
>  #endif
> --
> 2.25.1
>
