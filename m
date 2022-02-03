Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72914A885A
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349421AbiBCQJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiBCQJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:09:09 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF0CC06173B
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:09:08 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id u14so6920074lfo.11
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 08:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tm8cOIT2RMZaJvCrGE0aS5CTgwdbaLEWFyz2wA6Ms38=;
        b=RyMW/3GHR2o2+f8EqylzL45XxO4v0B0ZN7L++cNfNgpuRHLNofoGzAObNz1W7tqmr1
         7z+GYvGdxxHJYSrw+XqK3+pEgcinA2WF4rjhd2Hx9CJxIHFL+49V58iv41whs94Z6W7t
         v7SnyW+TejWEdWRqYAd7x0bg+PfgCIRMfiMik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tm8cOIT2RMZaJvCrGE0aS5CTgwdbaLEWFyz2wA6Ms38=;
        b=eXfwV4GXepwekVW8PuwTiD3UFhNIXGis8k9jYccCu5phcZ5//6Vr7oc1PiFAgntBvv
         CQaw7tNpqIX6YNosiRXXYJkHYNcv89xOZWRKOpbKI+hYNTjy/DzJf7BcjCtjix7UyHYJ
         gn+DBYzU/GT1nafZrc2VC6bBs95uJKKv+hE6zpSe/0M4OE7uqW76sD2gSkEFtGd+Emoj
         8zuom8ndd/vUhiMWOnPgrdnVC1Zkt/Mw3I6bGj9/bkz9hv31X6pUouDeizG5XMGRaLYT
         8E8pBLc8WBIfQn5Tiqw20q6c1AxCWvFwsJtnME4BYsFNc7Q37gRPI92N7/7As8XwaKqk
         AvJQ==
X-Gm-Message-State: AOAM530k9N3+2DDivEF6Xyz+b2qTt3d54u4IQtQLyuZbGSTJYflJgjHF
        mJj5AddqhNhScaJZxZgjc3H5VGcrcDOFU5z1/4BA4A==
X-Google-Smtp-Source: ABdhPJzMI72HU1BhGh9dw/LdYDt4Lq0FUOT+bi6/i42p2vNBn+DoEGNIGxSCaHgKcGjC2fY+QIcYrjE3MlvDYxwuji8=
X-Received: by 2002:a05:6512:3045:: with SMTP id b5mr18823790lfb.346.1643904546685;
 Thu, 03 Feb 2022 08:09:06 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-2-mauricio@kinvolk.io>
 <1b081b16-d91e-01fd-9154-7845782e8715@isovalent.com>
In-Reply-To: <1b081b16-d91e-01fd-9154-7845782e8715@isovalent.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Thu, 3 Feb 2022 11:08:55 -0500
Message-ID: <CAHap4zsrgyBzBdQj2O9xLo5fsi1op9png_3nQRJp=i18Pdn+9A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/9] libbpf: Implement changes needed for
 BTFGen in bpftool
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 1, 2022 at 3:57 PM Quentin Monnet <quentin@isovalent.com> wrote=
:
>
> 2022-01-28 17:33 UTC-0500 ~ Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > This commit extends libbpf with the features that are needed to
> > implement BTFGen:
> >
> > - Implement bpf_core_create_cand_cache() and bpf_core_free_cand_cache()
> > to handle candidates cache.
> > - Expose bpf_core_add_cands() and bpf_core_free_cands to handle
> > candidates list.
> > - Expose bpf_core_calc_relo_insn() to bpftool.
> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
>
> Hi, note that the patchset (or at least, this patch) does not apply
> cleanly. Can you please double-check that it is based on bpf-next?

I missed one commit on this submission...

> > ---
> >  tools/lib/bpf/libbpf.c          | 44 ++++++++++++++++++++++-----------
> >  tools/lib/bpf/libbpf_internal.h | 12 +++++++++
> >  2 files changed, 41 insertions(+), 15 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 12771f71a6e7..61384d219e28 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -5195,18 +5195,18 @@ size_t bpf_core_essential_name_len(const char *=
name)
> >       return n;
> >  }
> >
> > -static void bpf_core_free_cands(struct bpf_core_cand_list *cands)
> > +void bpf_core_free_cands(struct bpf_core_cand_list *cands)
> >  {
> >       free(cands->cands);
> >       free(cands);
> >  }
> >
> > -static int bpf_core_add_cands(struct bpf_core_cand *local_cand,
> > -                           size_t local_essent_len,
> > -                           const struct btf *targ_btf,
> > -                           const char *targ_btf_name,
> > -                           int targ_start_id,
> > -                           struct bpf_core_cand_list *cands)
> > +int bpf_core_add_cands(struct bpf_core_cand *local_cand,
> > +                    size_t local_essent_len,
> > +                    const struct btf *targ_btf,
> > +                    const char *targ_btf_name,
> > +                    int targ_start_id,
> > +                    struct bpf_core_cand_list *cands)
> >  {
> >       struct bpf_core_cand *new_cands, *cand;
> >       const struct btf_type *t, *local_t;
> > @@ -5577,6 +5577,25 @@ static int bpf_core_resolve_relo(struct bpf_prog=
ram *prog,
> >                                      targ_res);
> >  }
> >
> > +struct hashmap *bpf_core_create_cand_cache(void)
> > +{
> > +     return hashmap__new(bpf_core_hash_fn, bpf_core_equal_fn, NULL);
> > +}
> > +
> > +void bpf_core_free_cand_cache(struct hashmap *cand_cache)
> > +{
> > +     struct hashmap_entry *entry;
> > +     int i;
> > +
> > +     if (IS_ERR_OR_NULL(cand_cache))
> > +             return;
> > +
> > +     hashmap__for_each_entry(cand_cache, entry, i) {
> > +             bpf_core_free_cands(entry->value);
> > +     }
> > +     hashmap__free(cand_cache);
> > +}
> > +
> >  static int
> >  bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf=
_path)
> >  {
> > @@ -5584,7 +5603,6 @@ bpf_object__relocate_core(struct bpf_object *obj,=
 const char *targ_btf_path)
> >       struct bpf_core_relo_res targ_res;
> >       const struct bpf_core_relo *rec;
> >       const struct btf_ext_info *seg;
> > -     struct hashmap_entry *entry;
> >       struct hashmap *cand_cache =3D NULL;
> >       struct bpf_program *prog;
> >       struct bpf_insn *insn;
> > @@ -5603,7 +5621,7 @@ bpf_object__relocate_core(struct bpf_object *obj,=
 const char *targ_btf_path)
> >               }
> >       }
> >
> > -     cand_cache =3D hashmap__new(bpf_core_hash_fn, bpf_core_equal_fn, =
NULL);
> > +     cand_cache =3D bpf_core_create_cand_cache();
> >       if (IS_ERR(cand_cache)) {
> >               err =3D PTR_ERR(cand_cache);
> >               goto out;
> > @@ -5694,12 +5712,8 @@ bpf_object__relocate_core(struct bpf_object *obj=
, const char *targ_btf_path)
> >       btf__free(obj->btf_vmlinux_override);
> >       obj->btf_vmlinux_override =3D NULL;
> >
> > -     if (!IS_ERR_OR_NULL(cand_cache)) {
> > -             hashmap__for_each_entry(cand_cache, entry, i) {
> > -                     bpf_core_free_cands(entry->value);
> > -             }
> > -             hashmap__free(cand_cache);
> > -     }
> > +     bpf_core_free_cand_cache(cand_cache);
> > +
> >       return err;
> >  }
> >
> > diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_int=
ernal.h
> > index bc86b82e90d1..686a5654262b 100644
> > --- a/tools/lib/bpf/libbpf_internal.h
> > +++ b/tools/lib/bpf/libbpf_internal.h
> > @@ -529,4 +529,16 @@ static inline int ensure_good_fd(int fd)
> >       return fd;
> >  }
> >
> > +struct hashmap;
> > +
> > +struct hashmap *bpf_core_create_cand_cache(void);
> > +void bpf_core_free_cand_cache(struct hashmap *cand_cache);
> > +int bpf_core_add_cands(struct bpf_core_cand *local_cand,
> > +                    size_t local_essent_len,
> > +                    const struct btf *targ_btf,
> > +                    const char *targ_btf_name,
> > +                    int targ_start_id,
> > +                    struct bpf_core_cand_list *cands);
> > +void bpf_core_free_cands(struct bpf_core_cand_list *cands);
>
> I wonder if these might deserve a comment to mention that they are
> exposed for bpftool? I fear someone might attempt to clean it up and
> remove the unused exports otherwise.

I added a comment there.
