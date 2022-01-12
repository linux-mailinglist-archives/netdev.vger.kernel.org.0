Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D5B48C5F5
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354103AbiALO1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354096AbiALO1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:27:05 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5718BC06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:05 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id x6so8773442lfa.5
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5UtZOgyvwuakH58Xq06yE4+32HeIntaep9LP3R+E2ko=;
        b=l/xe6e+4LQJmbHUVXViKJrUeIB5+8unDy/UQjpwUAbKhl+ZHPveIwWO0hFgXb5nREX
         ZBfEevtPns1nVj83ZpPsm2nc9zJ2DvTb05y8/S3H1jXQwh66UavHrygty/WuedtRc1f0
         Nf7aI+TVWkNG0x7URImsllzoLVFV7ICCYxJi4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5UtZOgyvwuakH58Xq06yE4+32HeIntaep9LP3R+E2ko=;
        b=dTqCBzZh2grerLjtcoJesVHCjOtmUZU6pPWLG339/lFZhb2i1I4DbsA4su4rzo+0Xh
         KQ2F6cWZrCbKAVICiLJLQj+Ar8p/tJ5maDgGDGAsbwnG7P+6xLMti/GGAZD88Q6wLXEh
         T4cq2pT1AfVIxp+sPDmwQEKtad/0gMJq2kDKtu+xPxxEDSHgQdJTVKJznrsFrnWt77PY
         iIif/a9KeTIHU+jY1YyhbWRmbDNSx+07unZZyMTRlP9qspUeF2gYTI6SweZJ4QcV+fyc
         ROQzFzaAt5mQlvVkT0gpI/da9hmikogJB6L5YbdRSH1EWx3xvS2kTCF7lNQOtMzbjf6i
         ZUbw==
X-Gm-Message-State: AOAM531WIp7leiAx43eVflqeYsdxdeDVSsN45JCZm8K7Z4yWgJYE0ph3
        b5RPO2sbIbjB5BC8M4JIn0PYozUAAatJgdCbWiB6tw==
X-Google-Smtp-Source: ABdhPJzCU0g0LCN8M2kWA5P3DLnAvOxJ4bhKxHaDjbYZpOhK1dumbbBuT05gKqojtAX1nnmHdPYHrIPTHKH+YwGdhgM=
X-Received: by 2002:a05:6512:12d5:: with SMTP id p21mr6802838lfg.569.1641997623575;
 Wed, 12 Jan 2022 06:27:03 -0800 (PST)
MIME-Version: 1.0
References: <20211217185654.311609-1-mauricio@kinvolk.io> <20211217185654.311609-2-mauricio@kinvolk.io>
 <CAEf4BzZw2RBPSxE0j8uQd8-75qOfq=iPnhB73ONErsHYUaF+pg@mail.gmail.com>
In-Reply-To: <CAEf4BzZw2RBPSxE0j8uQd8-75qOfq=iPnhB73ONErsHYUaF+pg@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Wed, 12 Jan 2022 09:26:52 -0500
Message-ID: <CAHap4ztB7BWxXX3DerY2AVvV54vdhi+4wgTrrM9RzbiQ9KjhrQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] libbpf: split bpf_core_apply_relo()
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

> > -static int bpf_core_apply_relo(struct bpf_program *prog,
> > -                              const struct bpf_core_relo *relo,
> > -                              int relo_idx,
> > -                              const struct btf *local_btf,
> > -                              struct hashmap *cand_cache)
> > +static int bpf_core_calc_relo_res(struct bpf_program *prog,
>
> bpf_core_calc_relo_res is almost indistinguishable from
> bpf_core_calc_relo... Let's call this one bpf_core_resolve_relo()?
>

That's a much better name! Deciding the name of that function was
probably the most complicated part of this patch.

> > @@ -5636,12 +5627,31 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
> >                         if (!prog->load)
> >                                 continue;
> >
> > -                       err = bpf_core_apply_relo(prog, rec, i, obj->btf, cand_cache);
> > +                       err = bpf_core_calc_relo_res(prog, rec, i, obj->btf, cand_cache, &targ_res);
> >                         if (err) {
> >                                 pr_warn("prog '%s': relo #%d: failed to relocate: %d\n",
> >                                         prog->name, i, err);
> >                                 goto out;
> >                         }
> > +
> > +                       if (rec->insn_off % BPF_INSN_SZ)
> > +                               return -EINVAL;
> > +                       insn_idx = rec->insn_off / BPF_INSN_SZ;
> > +                       /* adjust insn_idx from section frame of reference to the local
> > +                        * program's frame of reference; (sub-)program code is not yet
> > +                        * relocated, so it's enough to just subtract in-section offset
> > +                        */
> > +                       insn_idx = insn_idx - prog->sec_insn_off;
> > +                       if (insn_idx >= prog->insns_cnt)
> > +                               return -EINVAL;
> > +                       insn = &prog->insns[insn_idx];
>
> this is sort of like sanity checks, let's do them before the core_calc
> step, so after that it's a clean sequence of calc_relo + pathc_insn?
>

Makes sense.

> > @@ -1177,18 +1152,18 @@ static void bpf_core_dump_spec(const char *prog_name, int level, const struct bp
> >   *    between multiple relocations for the same type ID and is updated as some
> >   *    of the candidates are pruned due to structural incompatibility.
> >   */
> > -int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
> > -                            int insn_idx,
> > -                            const struct bpf_core_relo *relo,
> > -                            int relo_idx,
> > -                            const struct btf *local_btf,
> > -                            struct bpf_core_cand_list *cands,
> > -                            struct bpf_core_spec *specs_scratch)
> > +int bpf_core_calc_relo_insn(const char *prog_name,
>
> please update the comment for this function, it's not "CO-RE relocate
> single instruction" anymore, it's more like "Calculate CO-RE
> relocation target result" or something along those lines.
>

Updated with your suggestion.

> > @@ -1223,12 +1198,12 @@ int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
> >         /* TYPE_ID_LOCAL relo is special and doesn't need candidate search */
> >         if (relo->kind == BPF_CORE_TYPE_ID_LOCAL) {
> >                 /* bpf_insn's imm value could get out of sync during linking */
> > -               memset(&targ_res, 0, sizeof(targ_res));
> > -               targ_res.validate = false;
> > -               targ_res.poison = false;
> > -               targ_res.orig_val = local_spec->root_type_id;
> > -               targ_res.new_val = local_spec->root_type_id;
> > -               goto patch_insn;
> > +               memset(targ_res, 0, sizeof(*targ_res));
> > +               targ_res->validate = true;
>
> hm.. original code sets it to false here, please don't regress the logic
>

ops, I introduced this by mistake while rebasing.
