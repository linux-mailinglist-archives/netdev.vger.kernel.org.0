Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E0D4A7873
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 20:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346840AbiBBTDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 14:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346837AbiBBTC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 14:02:59 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8802EC061714;
        Wed,  2 Feb 2022 11:02:59 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id n17so285207iod.4;
        Wed, 02 Feb 2022 11:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uwXHiBGbuLmRTKRidoI2aqOeMISRowJ06l2S15+H4b4=;
        b=nqAS29A0lzttcdCxMgeWvZYneGCXqEEERQnZwQ5btsQ93vLja70rmNNi4LFpeWgHmX
         E2EzWhX8wMKNxam8mthglufqGHCqhZlceMfCtXHijYsD8Xto7bSUnIDiKgOIzUfVmQMS
         +GCfggUm504XbdEmCgWvIcEorS/ckFHFPU105uvhl9/9PK2KEJQzYyjb0hFd8nBMOd3q
         nIDjNslK/OHZJk4uU+S2haBrjknU88lodg66QFrt9gRf3cKejx0+eCX7V3NfgW8yJ8RY
         vLAUcQl3SFuvMC0VBtYaEC0i0HGk4mvJavCWHGMTl/0+3PedwEpCuBrC1ByCSUtvtEtF
         534w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uwXHiBGbuLmRTKRidoI2aqOeMISRowJ06l2S15+H4b4=;
        b=7KLOaILmsWHeZ+BWUOFBqMaLVCVLNMwDaR+JnaTy0xXacegXkwsy7AepKyRZwdv8oB
         0h7NyJu4jDG+kye2rGj3GQi4juTO3HyBTZg4R+2mNYoWDfSntrHAglabEaeAkTQvBKa+
         pyKizJH2GSYPQFkL//1ubFXJi5sMQnOBtKMiIEVdGG/Q5i7I58xkoYCrm8pYwhpkzEhm
         Hp1iCUZrIj8YqQbxOWmQ75e+yFLer+SJrQ6OY2jy3Y/D60EdDQNXoKrbRvjW95DmhvkY
         VyG1oJhJQ5tOnywOhSk9bKQZpKi4+rYUpqzxIZq6FEKKRo68vyArcXO7lku/mSFnRP+B
         WHLA==
X-Gm-Message-State: AOAM533AbFi8QBiHfLWU+WuUCvdcVapaylZA8FEUHYr7VGvhB5x63h8T
        QAbMBGI6bJ3rlV7Cn52cRycMsT3al1wTh1TClTY=
X-Google-Smtp-Source: ABdhPJyb2B6/lNZwl5lTQCjiHY+cXdwU6u0wwAjW+iiUhpveSty8bQGeu87LFqUMq/yk7pLI6YAnFPqLxNeioTfpYGQ=
X-Received: by 2002:a05:6638:304d:: with SMTP id u13mr14424326jak.103.1643828578869;
 Wed, 02 Feb 2022 11:02:58 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-2-mauricio@kinvolk.io>
 <CAEf4BzZQeWg25dxzbQRmDQRjuerYe_SCC775wOuPicKanXxHAw@mail.gmail.com>
In-Reply-To: <CAEf4BzZQeWg25dxzbQRmDQRjuerYe_SCC775wOuPicKanXxHAw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Feb 2022 11:02:47 -0800
Message-ID: <CAEf4BzZrXA3a9A=_3U6Nz_dyFVj8GgQmCvk-FasHKb3gv8v73Q@mail.gmail.com>
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

On Wed, Feb 2, 2022 at 10:54 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jan 28, 2022 at 2:33 PM Mauricio V=C3=A1squez <mauricio@kinvolk.i=
o> wrote:
> >
> > This commit extends libbpf with the features that are needed to
> > implement BTFGen:
> >
> > - Implement bpf_core_create_cand_cache() and bpf_core_free_cand_cache()
> > to handle candidates cache.
> > - Expose bpf_core_add_cands() and bpf_core_free_cands to handle
> > candidates list.
> > - Expose bpf_core_calc_relo_insn() to bpftool.

I don't see this in this patch. I also don't see
bpf_core_calc_relo_insn() in current bpf-next either.

> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
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
> >         return n;
> >  }
> >
> > -static void bpf_core_free_cands(struct bpf_core_cand_list *cands)
> > +void bpf_core_free_cands(struct bpf_core_cand_list *cands)
> >  {
> >         free(cands->cands);
> >         free(cands);
> >  }
> >
> > -static int bpf_core_add_cands(struct bpf_core_cand *local_cand,
> > -                             size_t local_essent_len,
> > -                             const struct btf *targ_btf,
> > -                             const char *targ_btf_name,
> > -                             int targ_start_id,
> > -                             struct bpf_core_cand_list *cands)
> > +int bpf_core_add_cands(struct bpf_core_cand *local_cand,
> > +                      size_t local_essent_len,
> > +                      const struct btf *targ_btf,
> > +                      const char *targ_btf_name,
> > +                      int targ_start_id,
> > +                      struct bpf_core_cand_list *cands)
> >  {
> >         struct bpf_core_cand *new_cands, *cand;
> >         const struct btf_type *t, *local_t;
> > @@ -5577,6 +5577,25 @@ static int bpf_core_resolve_relo(struct bpf_prog=
ram *prog,
> >                                        targ_res);
> >  }
> >
> > +struct hashmap *bpf_core_create_cand_cache(void)
> > +{
> > +       return hashmap__new(bpf_core_hash_fn, bpf_core_equal_fn, NULL);
> > +}
> > +
> > +void bpf_core_free_cand_cache(struct hashmap *cand_cache)
> > +{
> > +       struct hashmap_entry *entry;
> > +       int i;
> > +
> > +       if (IS_ERR_OR_NULL(cand_cache))
> > +               return;
> > +
> > +       hashmap__for_each_entry(cand_cache, entry, i) {
> > +               bpf_core_free_cands(entry->value);
> > +       }
> > +       hashmap__free(cand_cache);
> > +}
> > +
> >  static int
> >  bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf=
_path)
> >  {
> > @@ -5584,7 +5603,6 @@ bpf_object__relocate_core(struct bpf_object *obj,=
 const char *targ_btf_path)
> >         struct bpf_core_relo_res targ_res;
> >         const struct bpf_core_relo *rec;
> >         const struct btf_ext_info *seg;
> > -       struct hashmap_entry *entry;
> >         struct hashmap *cand_cache =3D NULL;
> >         struct bpf_program *prog;
> >         struct bpf_insn *insn;
> > @@ -5603,7 +5621,7 @@ bpf_object__relocate_core(struct bpf_object *obj,=
 const char *targ_btf_path)
> >                 }
> >         }
> >
> > -       cand_cache =3D hashmap__new(bpf_core_hash_fn, bpf_core_equal_fn=
, NULL);
> > +       cand_cache =3D bpf_core_create_cand_cache();
> >         if (IS_ERR(cand_cache)) {
> >                 err =3D PTR_ERR(cand_cache);
> >                 goto out;
> > @@ -5694,12 +5712,8 @@ bpf_object__relocate_core(struct bpf_object *obj=
, const char *targ_btf_path)
> >         btf__free(obj->btf_vmlinux_override);
> >         obj->btf_vmlinux_override =3D NULL;
> >
> > -       if (!IS_ERR_OR_NULL(cand_cache)) {
> > -               hashmap__for_each_entry(cand_cache, entry, i) {
> > -                       bpf_core_free_cands(entry->value);
> > -               }
> > -               hashmap__free(cand_cache);
> > -       }
> > +       bpf_core_free_cand_cache(cand_cache);
> > +
> >         return err;
> >  }
> >
> > diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_int=
ernal.h
> > index bc86b82e90d1..686a5654262b 100644
> > --- a/tools/lib/bpf/libbpf_internal.h
> > +++ b/tools/lib/bpf/libbpf_internal.h
> > @@ -529,4 +529,16 @@ static inline int ensure_good_fd(int fd)
> >         return fd;
> >  }
> >
> > +struct hashmap;
> > +
> > +struct hashmap *bpf_core_create_cand_cache(void);
> > +void bpf_core_free_cand_cache(struct hashmap *cand_cache);
>
> looking at patch #5, there is nothing special about this cand_cache,
> it's just a hashmap from u32 to some pointer. There is no need for
> libbpf to expose it to bpftool, you already have hashmap itself and
> also btfgen_hash_fn and equality callback, just do the same thing as
> you do with btfgen_info->types hashmap.
>
>
> > +int bpf_core_add_cands(struct bpf_core_cand *local_cand,
> > +                      size_t local_essent_len,
> > +                      const struct btf *targ_btf,
> > +                      const char *targ_btf_name,
> > +                      int targ_start_id,
> > +                      struct bpf_core_cand_list *cands);
> > +void bpf_core_free_cands(struct bpf_core_cand_list *cands);
> > +
> >  #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
> > --
> > 2.25.1
> >
