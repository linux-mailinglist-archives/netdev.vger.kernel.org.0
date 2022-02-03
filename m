Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D364A885C
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352123AbiBCQJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiBCQJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:09:24 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40545C06173B
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:09:24 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id i34so7060641lfv.2
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 08:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=I6qSMYdc9y3v4PPovuD0EtmpAeWiCAHll+AngD4+Nwo=;
        b=l353VGtglDc/C4dh6nHpAUXSmHtS/AfhmTOmDmiykTdrWWvcRjtPJpkKdMkQ5LSo/D
         +AGfPVxQj/uj4autJUWF3WB/U3bzTLonlFowhHd7kjUxxEH+gZHORwNNbDvOHbYtc5wc
         S1GW1yR0of8XQyDU+DjsYZ9fx/YdogMP2Tv0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=I6qSMYdc9y3v4PPovuD0EtmpAeWiCAHll+AngD4+Nwo=;
        b=nyTUWQkA0lyttQ6qQvZiGuC+b3L1g7vityFbjshjzOKsAhFjOlmIpMGZsvSYuyc10w
         JPb4seKLiMhSzLHO19OhpOVKOt4QTIclqAWZLV9eG2yhtkqcJYF6XBIl27sJ86vtb9sA
         X4A2d6aQsxAiGbJ7rGtQrSpYLaPkKmcCnLuvBg76M6a6Z/IMp0Y/ftjgIbMf4QILETNr
         dQw0Szlq0eTB27xqZcBZKvDUPC/1XdH3Fu6ZMt4ydtCHDeoQ9xDKZgHswZXGgJBdizMn
         E6/JqkG+mg5M+C/j7Xk0tzW8ZoLP6VZy9cG7wkAnESooRgeltmxr3GZAklMFB6whKFD0
         rH7g==
X-Gm-Message-State: AOAM53132LiLoM6I2reSb/JB0iKfdyG3P2uj4EeGGw0kScUN/kUk59q8
        0gIEfgmc0Ja9ztd42FnPERn85bNqvb+zdwf5QlK4bg==
X-Google-Smtp-Source: ABdhPJxf01JzgRdObn8hlr0sengBgovXfNKFeMgeWne/C+boXhRCYxIkYN8usiMDrTrhOcmTZ5MLSGGFRhJXm3AviS4=
X-Received: by 2002:ac2:4843:: with SMTP id 3mr26363390lfy.193.1643904562491;
 Thu, 03 Feb 2022 08:09:22 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-2-mauricio@kinvolk.io>
 <CAEf4BzZQeWg25dxzbQRmDQRjuerYe_SCC775wOuPicKanXxHAw@mail.gmail.com>
In-Reply-To: <CAEf4BzZQeWg25dxzbQRmDQRjuerYe_SCC775wOuPicKanXxHAw@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Thu, 3 Feb 2022 11:09:11 -0500
Message-ID: <CAHap4zsE41e6Z1uwLpUr0XbX3ONsZFqZw4JRUUH=nXZ6sxJjTA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/9] libbpf: Implement changes needed for
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 1:54 PM Andrii Nakryiko
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

I'll drop them and handle the hashmap directly from bpftool.
