Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7725E4A7844
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 19:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346777AbiBBSyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 13:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346773AbiBBSyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 13:54:51 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5080EC061714;
        Wed,  2 Feb 2022 10:54:51 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id n17so255176iod.4;
        Wed, 02 Feb 2022 10:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+SA8BEDtHaY4DtfsLBJ5GTSOO/RAlGDy3z/jPtVWjh4=;
        b=irZ4ATo093IjNnqgmzkV9UDb5FO8sweEev3HK2Tdp2nXeIRSS4Jsbfyzq9vucsZSdV
         tPt5hZa1l6cafEju0StVQavoFOoNgQ4f58rNStd3miSU7mBVT3D8bQko9qhnUoxt5sY4
         sJuPX12oCSwgRwVZzv3KCElxM+MiCaWWxrZLxqzTwxnhLduLvYNmIHH5Sntz8e57tW2k
         EIa+JLNS3wuOzAc2zqIy1ID4FMIuZOEajcrqo7lchBoN7cGC2F/hmOxuIIVGqacV1Unj
         eIZbaVYgfbGDpF0HgT7JBzHLU/UkB45CEBmk5GKmQiH5d3F7gtpqcXkkAWRd9VktpuvA
         cfug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+SA8BEDtHaY4DtfsLBJ5GTSOO/RAlGDy3z/jPtVWjh4=;
        b=36Yk6sE+4dcslIn9e4x9ihmVB6qbstHwVnW6ILeGJNOenDijDZxqAXpzJfAVP0b5+D
         kSyZvhcr+hyd0oBnIGUVQyjRwUgT5miQaac4oSuq1RNKUyrpy9VvxpVNGhKdJWhStDrN
         Dx5RURGScCb6ZYoKhj1yYbU9x2nF+mrAUVdyh4WlLQ4LWZdHs7mfp0OF87QlSrskhN4S
         hvc6jvPSO/lBdo779fetLu6PTsYohbTi0ExfeBSr874SOXvvvvSzOLnrfpjrYWCT0vKk
         PoAYAnlVfBJrMEf+6lSBTBO0Rhyg1LyvVToGsqx9OJM6rXuLnVxUMmeiCVX5xOLcnBPX
         eglg==
X-Gm-Message-State: AOAM532Bjlnn0j7i+8sxN0zXuTqMWoICmLfXMGTToNQ61Fx2bmKXc3Jl
        pOMlTXJgGIUbn1ZL+Iylgj9FChop4+j2//Y6+dUneSwH2n4=
X-Google-Smtp-Source: ABdhPJzNS70QjI40MlskNX2eQKzAJb9ElBUoMkCuGYQ4MIMrM3DiDN2fPI35+e/gSAd3PpX6NNaT7sZyboG5ryfVP/A=
X-Received: by 2002:a5e:8406:: with SMTP id h6mr17089100ioj.144.1643828090754;
 Wed, 02 Feb 2022 10:54:50 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-2-mauricio@kinvolk.io>
In-Reply-To: <20220128223312.1253169-2-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Feb 2022 10:54:39 -0800
Message-ID: <CAEf4BzZQeWg25dxzbQRmDQRjuerYe_SCC775wOuPicKanXxHAw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/9] libbpf: Implement changes needed for
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

On Fri, Jan 28, 2022 at 2:33 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> This commit extends libbpf with the features that are needed to
> implement BTFGen:
>
> - Implement bpf_core_create_cand_cache() and bpf_core_free_cand_cache()
> to handle candidates cache.
> - Expose bpf_core_add_cands() and bpf_core_free_cands to handle
> candidates list.
> - Expose bpf_core_calc_relo_insn() to bpftool.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/lib/bpf/libbpf.c          | 44 ++++++++++++++++++++++-----------
>  tools/lib/bpf/libbpf_internal.h | 12 +++++++++
>  2 files changed, 41 insertions(+), 15 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 12771f71a6e7..61384d219e28 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -5195,18 +5195,18 @@ size_t bpf_core_essential_name_len(const char *na=
me)
>         return n;
>  }
>
> -static void bpf_core_free_cands(struct bpf_core_cand_list *cands)
> +void bpf_core_free_cands(struct bpf_core_cand_list *cands)
>  {
>         free(cands->cands);
>         free(cands);
>  }
>
> -static int bpf_core_add_cands(struct bpf_core_cand *local_cand,
> -                             size_t local_essent_len,
> -                             const struct btf *targ_btf,
> -                             const char *targ_btf_name,
> -                             int targ_start_id,
> -                             struct bpf_core_cand_list *cands)
> +int bpf_core_add_cands(struct bpf_core_cand *local_cand,
> +                      size_t local_essent_len,
> +                      const struct btf *targ_btf,
> +                      const char *targ_btf_name,
> +                      int targ_start_id,
> +                      struct bpf_core_cand_list *cands)
>  {
>         struct bpf_core_cand *new_cands, *cand;
>         const struct btf_type *t, *local_t;
> @@ -5577,6 +5577,25 @@ static int bpf_core_resolve_relo(struct bpf_progra=
m *prog,
>                                        targ_res);
>  }
>
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
> +       if (IS_ERR_OR_NULL(cand_cache))
> +               return;
> +
> +       hashmap__for_each_entry(cand_cache, entry, i) {
> +               bpf_core_free_cands(entry->value);
> +       }
> +       hashmap__free(cand_cache);
> +}
> +
>  static int
>  bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_p=
ath)
>  {
> @@ -5584,7 +5603,6 @@ bpf_object__relocate_core(struct bpf_object *obj, c=
onst char *targ_btf_path)
>         struct bpf_core_relo_res targ_res;
>         const struct bpf_core_relo *rec;
>         const struct btf_ext_info *seg;
> -       struct hashmap_entry *entry;
>         struct hashmap *cand_cache =3D NULL;
>         struct bpf_program *prog;
>         struct bpf_insn *insn;
> @@ -5603,7 +5621,7 @@ bpf_object__relocate_core(struct bpf_object *obj, c=
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
> @@ -5694,12 +5712,8 @@ bpf_object__relocate_core(struct bpf_object *obj, =
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
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_inter=
nal.h
> index bc86b82e90d1..686a5654262b 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -529,4 +529,16 @@ static inline int ensure_good_fd(int fd)
>         return fd;
>  }
>
> +struct hashmap;
> +
> +struct hashmap *bpf_core_create_cand_cache(void);
> +void bpf_core_free_cand_cache(struct hashmap *cand_cache);

looking at patch #5, there is nothing special about this cand_cache,
it's just a hashmap from u32 to some pointer. There is no need for
libbpf to expose it to bpftool, you already have hashmap itself and
also btfgen_hash_fn and equality callback, just do the same thing as
you do with btfgen_info->types hashmap.


> +int bpf_core_add_cands(struct bpf_core_cand *local_cand,
> +                      size_t local_essent_len,
> +                      const struct btf *targ_btf,
> +                      const char *targ_btf_name,
> +                      int targ_start_id,
> +                      struct bpf_core_cand_list *cands);
> +void bpf_core_free_cands(struct bpf_core_cand_list *cands);
> +
>  #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
> --
> 2.25.1
>
