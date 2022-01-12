Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369F948C5F8
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354111AbiALO1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354104AbiALO1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:27:09 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF73C061748
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:08 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id u13so8649711lff.12
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x3HJv/pEqARSKtBofANRE2qy4M28SMpjR4sz8P8/Ko4=;
        b=PYgC/cV+Ih0E5U+0tXhCv4maehV+fYZQJV1GpEkp2dqnzAIxoeIL25Nyfg/N0XmTKg
         IIRtuVonVbJe5yU11XLfOdlfyUqwkghFzIvTR/gevV7IPFbZMWMUh5enuLsXGRbAwmSZ
         gor2wk9KY+h5zaUeyJYfrGOc8tlz+zaLwdNpc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x3HJv/pEqARSKtBofANRE2qy4M28SMpjR4sz8P8/Ko4=;
        b=LNj7byk+3ip57d4+5Ljbkr382b0KGKdBq2Q1wxQRljy8+A18mp9SK4nKu4KLBpvsre
         LHnNg0CEUQ8W6z36h1ep6YAC4nHQTHqRa/DSxuHcNleQ/sLsdtn3TivTrj9EqGAXb/jK
         ancqudTboBfRLUPTrLApNgcgKDtjxtGeQHFn/WPCkEt8Kc70XP4NOQ9xA+SyZcHLaW9K
         VUyc7hEhMUDeSPnoOeORX/u7z4lespPpqD6jD67jbfGKcju654NldnX1qsyxvK3VWJb4
         eE+yfz4O+fcCs+RuEgu6svgim/P9y85QmVnUSiNZKkm/eM3M0CQKfkEH2k4WwzK1gZuE
         p6mw==
X-Gm-Message-State: AOAM5324MUovBC7Ug0tuvWMK/DAwEXUap3R3t1N7cwsyhnK8AoAI8UtG
        oY769+wF6e4x8ueTyxkHzY+KARkFSo2vrU1JON7Rjg==
X-Google-Smtp-Source: ABdhPJxI84S9kRWywA1cD6UjRUbjy8gRW/wkEzOyr/WdY5PMA9NtZg0Y8iNd2oaO6aGV+Im5etyfQtzrLGk7lMEXD3A=
X-Received: by 2002:a05:651c:4cc:: with SMTP id e12mr6370967lji.310.1641997626372;
 Wed, 12 Jan 2022 06:27:06 -0800 (PST)
MIME-Version: 1.0
References: <20211217185654.311609-1-mauricio@kinvolk.io> <20211217185654.311609-3-mauricio@kinvolk.io>
 <CAEf4BzbtbxkPZKUEye9=CbOtR-e25cv_5_FyH_Qd8hk9TtsiJQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbtbxkPZKUEye9=CbOtR-e25cv_5_FyH_Qd8hk9TtsiJQ@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Wed, 12 Jan 2022 09:26:55 -0500
Message-ID: <CAHap4zsy39sGWvW8-aXt3kZweDxXK6gmaFjy28W4qCp1fvywhw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: Implement changes needed for
 BTFGen in bpftool
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -5498,12 +5498,13 @@ static int record_relo_core(struct bpf_program *prog,
> >         return 0;
> >  }
> >
> > -static int bpf_core_calc_relo_res(struct bpf_program *prog,
> > -                                 const struct bpf_core_relo *relo,
> > -                                 int relo_idx,
> > -                                 const struct btf *local_btf,
> > -                                 struct hashmap *cand_cache,
> > -                                 struct bpf_core_relo_res *targ_res)
> > +int bpf_core_calc_relo_res(struct bpf_program *prog,
> > +                          const struct bpf_core_relo *relo,
> > +                          int relo_idx,
> > +                          const struct btf *local_btf,
> > +                          struct hashmap *cand_cache,
> > +                          struct bpf_core_relo_res *targ_res,
> > +                          struct bpf_core_spec *targ_spec)
>
> maybe let's add targ_spec and local_spec into bpf_core_relo_res? that
> way bpf_core_relo_res contains all the relevant information around
> CO-RE relo resolution?
>

It's not needed anymore now that we're using bpf_core_calc_relo_insn()
directly in bpftool.

> > @@ -8190,6 +8211,11 @@ struct btf *bpf_object__btf(const struct bpf_object *obj)
> >         return obj ? obj->btf : NULL;
> >  }
> >
> > +struct btf_ext *bpf_object__btf_ext(const struct bpf_object *obj)
> > +{
> > +       return obj ? obj->btf_ext : NULL;
>
> just return obj->btf_ext, no one should be passing NULL for those getters

I dropped this function as we don't need it now.

>
> > +}
> > +
> >  int bpf_object__btf_fd(const struct bpf_object *obj)
> >  {
> >         return obj->btf ? btf__fd(obj->btf) : -1;
> > @@ -8281,6 +8307,20 @@ bpf_object__next_program(const struct bpf_object *obj, struct bpf_program *prev)
> >         return prog;
> >  }
> >
> > +size_t bpf_object__get_nr_programs(const struct bpf_object *obj)
> > +{
> > +       return obj->nr_programs;
> > +}
> > +
> > +struct bpf_program *
> > +bpf_object__get_program(const struct bpf_object *obj, unsigned int i)
> > +{
> > +       if (i >= obj->nr_programs)
> > +               return NULL;
> > +
> > +       return &obj->programs[i];
> > +}
> > +
> >  struct bpf_program *
> >  bpf_program__prev(struct bpf_program *next, const struct bpf_object *obj)
> >  {
> > @@ -8360,6 +8400,11 @@ int bpf_program__set_autoload(struct bpf_program *prog, bool autoload)
> >         return 0;
> >  }
> >
> > +int bpf_program__sec_idx(const struct bpf_program *prog)
> > +{
> > +       return prog->sec_idx;
> > +}
> > +
> >  static int bpf_program_nth_fd(const struct bpf_program *prog, int n);
> >
> >  int bpf_program__fd(const struct bpf_program *prog)
> > @@ -11779,3 +11824,8 @@ void bpf_object__destroy_skeleton(struct bpf_object_skeleton *s)
> >         free(s->progs);
> >         free(s);
> >  }
> > +
> > +void bpf_object_set_vmlinux_override(struct bpf_object *obj, struct btf *btf)
> > +{
> > +       obj->btf_vmlinux_override = btf;
> > +}
>
> I don't think we need this, see comments in next patch
>
>
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index 42b2f36fd9f0..2b048ee5a9b2 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -225,6 +225,8 @@ LIBBPF_API int bpf_object__set_kversion(struct bpf_object *obj, __u32 kern_versi
> >
> >  struct btf;
> >  LIBBPF_API struct btf *bpf_object__btf(const struct bpf_object *obj);
> > +struct btf_ext;
> > +LIBBPF_API struct btf_ext *bpf_object__btf_ext(const struct bpf_object *obj);
> >  LIBBPF_API int bpf_object__btf_fd(const struct bpf_object *obj);
> >
> >  LIBBPF_DEPRECATED_SINCE(0, 7, "use bpf_object__find_program_by_name() instead")
> > @@ -290,6 +292,7 @@ LIBBPF_API LIBBPF_DEPRECATED("BPF program title is confusing term; please use bp
> >  const char *bpf_program__title(const struct bpf_program *prog, bool needs_copy);
> >  LIBBPF_API bool bpf_program__autoload(const struct bpf_program *prog);
> >  LIBBPF_API int bpf_program__set_autoload(struct bpf_program *prog, bool autoload);
> > +LIBBPF_API int bpf_program__sec_idx(const struct bpf_program *prog);
> >
> >  /* returns program size in bytes */
> >  LIBBPF_DEPRECATED_SINCE(0, 7, "use bpf_program__insn_cnt() instead")
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index b3938b3f8fc9..15da4075e0b5 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -392,6 +392,7 @@ LIBBPF_0.6.0 {
> >                 bpf_map__map_extra;
> >                 bpf_map__set_map_extra;
> >                 bpf_map_create;
> > +               bpf_object__btf_ext;
> >                 bpf_object__next_map;
> >                 bpf_object__next_program;
> >                 bpf_object__prev_map;
> > @@ -401,6 +402,7 @@ LIBBPF_0.6.0 {
> >                 bpf_program__flags;
> >                 bpf_program__insn_cnt;
> >                 bpf_program__insns;
> > +               bpf_program__sec_idx;
> >                 bpf_program__set_flags;
> >                 btf__add_btf;
> >                 btf__add_decl_tag;
> > diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> > index 5dbe4f463880..b1962adb110c 100644
> > --- a/tools/lib/bpf/libbpf_internal.h
> > +++ b/tools/lib/bpf/libbpf_internal.h
> > @@ -524,4 +524,26 @@ static inline int ensure_good_fd(int fd)
> >         return fd;
> >  }
> >
> > +struct hashmap;
> > +
> > +int bpf_core_calc_relo_res(struct bpf_program *prog,
> > +                          const struct bpf_core_relo *relo,
> > +                          int relo_idx,
> > +                          const struct btf *local_btf,
> > +                          struct hashmap *cand_cache,
> > +                          struct bpf_core_relo_res *targ_res,
> > +                          struct bpf_core_spec *targ_spec);
> > +void bpf_object_set_vmlinux_override(struct bpf_object *obj, struct btf *btf);
> > +struct hashmap *bpf_core_create_cand_cache(void);
> > +void bpf_core_free_cand_cache(struct hashmap *cand_cache);
> > +
> > +struct bpf_program *find_prog_by_sec_insn(const struct bpf_object *obj,
> > +                                         size_t sec_idx, size_t insn_idx);
> > +
> > +size_t bpf_object__get_nr_programs(const struct bpf_object *obj);
> > +
> > +struct bpf_program *
> > +bpf_object__get_program(const struct bpf_object *obj, unsigned int n);
> > +
>
> that's too much, I don't think you need bpf_program and all the things
> around it (sec_idx, look up, etc). As for core_relo_is_field_based and
> co, bpftool can do those simple checks on their own, no need to make
> all the "internal API", don't overdo it with "let's expose internals
> of libbpf to bpftool".
>
>
> > +
> >  #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
> > diff --git a/tools/lib/bpf/relo_core.c b/tools/lib/bpf/relo_core.c
> > index 4f3552468624..66dfb7fa89a2 100644
> > --- a/tools/lib/bpf/relo_core.c
> > +++ b/tools/lib/bpf/relo_core.c
> > @@ -102,7 +102,7 @@ static const char *core_relo_kind_str(enum bpf_core_relo_kind kind)
> >         }
> >  }
> >
> > -static bool core_relo_is_field_based(enum bpf_core_relo_kind kind)
> > +bool core_relo_is_field_based(enum bpf_core_relo_kind kind)
> >  {
> >         switch (kind) {
> >         case BPF_CORE_FIELD_BYTE_OFFSET:
> > @@ -117,7 +117,7 @@ static bool core_relo_is_field_based(enum bpf_core_relo_kind kind)
> >         }
> >  }
> >
> > -static bool core_relo_is_type_based(enum bpf_core_relo_kind kind)
> > +bool core_relo_is_type_based(enum bpf_core_relo_kind kind)
> >  {
> >         switch (kind) {
> >         case BPF_CORE_TYPE_ID_LOCAL:
> > @@ -130,7 +130,7 @@ static bool core_relo_is_type_based(enum bpf_core_relo_kind kind)
> >         }
> >  }
> >
> > -static bool core_relo_is_enumval_based(enum bpf_core_relo_kind kind)
> > +bool core_relo_is_enumval_based(enum bpf_core_relo_kind kind)
> >  {
> >         switch (kind) {
> >         case BPF_CORE_ENUMVAL_EXISTS:
> > diff --git a/tools/lib/bpf/relo_core.h b/tools/lib/bpf/relo_core.h
> > index a28bf3711ce2..e969dfb032f4 100644
> > --- a/tools/lib/bpf/relo_core.h
> > +++ b/tools/lib/bpf/relo_core.h
> > @@ -84,4 +84,8 @@ int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
> >                         int insn_idx, const struct bpf_core_relo *relo,
> >                         int relo_idx, const struct bpf_core_relo_res *res);
> >
> > +bool core_relo_is_field_based(enum bpf_core_relo_kind kind);
> > +bool core_relo_is_type_based(enum bpf_core_relo_kind kind);
> > +bool core_relo_is_enumval_based(enum bpf_core_relo_kind kind);
> > +
> >  #endif
> > --
> > 2.25.1
> >
