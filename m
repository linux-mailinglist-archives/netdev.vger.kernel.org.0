Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D3A49666F
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 21:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiAUUlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 15:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiAUUlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 15:41:07 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCED7C06173B
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 12:41:06 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id j14so1742140lja.3
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 12:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tjbu+F1VZQYFupBcuu+/g7s3TQTu1trtkuY28WqEe28=;
        b=Jrt4wgFWh1eGhN706X18g7vjfu0elasm9GVs+Xyi0MQUrA81bwnL3qzmDYQGvujCke
         F5XDiOu43Foqjy/bMZgyZvIw2i0xxCoTWQey3Y7VDIMFPJCR4xTrwRV5edGLsxumuhPC
         kyKwqB3Tz5rbiCrpGlfzMK/VLHXQdP7jepHq0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tjbu+F1VZQYFupBcuu+/g7s3TQTu1trtkuY28WqEe28=;
        b=AJgo/FN4GzXyF8cwza7rAIJk1d3r0Dr9DvxRPCvtIkLN/vzBIi7LRxABb06jhPKoA0
         0XeVdd77cH5kHOdWH5qXKK+oPdiMNdziSzeoITA/oEWbaBKpWMvvgoCeBxJe2ioKym+s
         Sb47sDgeZoXVW9zCdpJfNHVuzI3tUODskgCQkZpd2vZSz+kKJn4kQquu8PkJ88V2IXAd
         hIE115U/C8Kh8TT+ndIypTxFnumetuUhBiR4n6z5odEK5yEfHmFjzDBEM2SKxcYP/EpY
         c0U53Phh47CXcLslpB30M6EILymJ0uVtbzH3gbXSljSSZw1F4QCabzw/OQzY2WPEUR7t
         hQ3Q==
X-Gm-Message-State: AOAM5332MXiEXlDc5Dwl023vvqqBPcne2yeJDjs59tKLBalYb+eA2PCG
        US7rYmA6AkSfKkMAMP0AhL8+6BnDJMQIo5CdA36l9Q==
X-Google-Smtp-Source: ABdhPJxBwnNYKIMqSPjt/i8EoSKZCR1XEAO0WtgcNGnEkRcU+ZQdLnDaLn/DGP6Zcw3wVSqTCdToi64K21KUHVMj3y0=
X-Received: by 2002:a2e:9f41:: with SMTP id v1mr4163097ljk.274.1642797665121;
 Fri, 21 Jan 2022 12:41:05 -0800 (PST)
MIME-Version: 1.0
References: <20220112142709.102423-1-mauricio@kinvolk.io> <20220112142709.102423-2-mauricio@kinvolk.io>
 <CAEf4BzYSz99GTNiKMaVPMpOc4Y7YdZLEH1VDy2X4KJkaKbtYfA@mail.gmail.com>
In-Reply-To: <CAEf4BzYSz99GTNiKMaVPMpOc4Y7YdZLEH1VDy2X4KJkaKbtYfA@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Fri, 21 Jan 2022 15:40:54 -0500
Message-ID: <CAHap4zunMHS_FcOeDwmXv38zX0AHgf2v7Hr8bee9fyRcvah=aQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/8] libbpf: split bpf_core_apply_relo()
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

On Fri, Jan 14, 2022 at 9:02 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jan 12, 2022 at 6:27 AM Mauricio V=C3=A1squez <mauricio@kinvolk.i=
o> wrote:
> >
> > BTFGen needs to run the core relocation logic in order to understand
> > what are the types in the target BTF that involved in a given
> > relocation.
> >
> > Currently bpf_core_apply_relo() calculates and **applies** a relocation
> > to an instruction. Having both operations in the same function makes it
> > difficult to only calculate the relocation without patching the
> > instruction. This commit splits that logic in two different phases: (1)
> > calculate the relocation and (2) patch the instruction.
> >
> > For the first phase bpf_core_apply_relo() is renamed to
> > bpf_core_calc_relo_res() who is now only on charge of calculating the
>
> outdated name?
>
> > relocation, the second phase uses the already existing
> > bpf_core_patch_insn(). bpf_object__relocate_core() uses both of them an=
d
> > the BTFGen will use only bpf_core_calc_relo_res().
>
> same?
>
>
> BTW, this patch set breaks CI ([0]), please investigate
>
>   [0] https://github.com/kernel-patches/bpf/runs/4797721812?check_suite_f=
ocus=3Dtrue
>
> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > ---
> >  kernel/bpf/btf.c          | 13 ++++--
> >  tools/lib/bpf/libbpf.c    | 84 ++++++++++++++++++++++++---------------
> >  tools/lib/bpf/relo_core.c | 79 +++++++++++-------------------------
> >  tools/lib/bpf/relo_core.h | 42 +++++++++++++++++---
> >  4 files changed, 122 insertions(+), 96 deletions(-)
> >
>
> [...]
>
> > @@ -5661,12 +5642,53 @@ bpf_object__relocate_core(struct bpf_object *ob=
j, const char *targ_btf_path)
> >                         if (!prog->load)
> >                                 continue;
> >
> > -                       err =3D bpf_core_apply_relo(prog, rec, i, obj->=
btf, cand_cache);
> > +                       if (prog->obj->gen_loader) {
> > +                               const struct btf_type *local_type;
> > +                               const char *local_name, *spec_str;
> > +
> > +                               spec_str =3D btf__name_by_offset(obj->b=
tf, rec->access_str_off);
> > +                               if (!spec_str)
> > +                                       return -EINVAL;
> > +
> > +                               local_type =3D btf__type_by_id(obj->btf=
, rec->type_id);
> > +                               if (!local_type)
> > +                                       return -EINVAL;
> > +
> > +                               local_name =3D btf__name_by_offset(obj-=
>btf, local_type->name_off);
> > +                               if (!local_name)
> > +                                       return -EINVAL;
> > +
> > +                               pr_debug("record_relo_core: prog %td in=
sn[%d] %s %s %s final insn_idx %d\n",
> > +                                       prog - prog->obj->programs, ins=
n_idx,
> > +                                       btf_kind_str(local_type), local=
_name, spec_str, insn_idx);
>
> hmm, maybe let's just drop this pr_debug instead? that's a lot of code
> and checks just to emit this debug info.
>

Makes sense.

> > +                               return record_relo_core(prog, rec, insn=
_idx);

This was the reason why the CI was failing. This should not "return"
but "continue" here, otherwise only a single relocation will be
recorded.

> > +                       }
> > +
> > +                       if (rec->insn_off % BPF_INSN_SZ)
> > +                               return -EINVAL;
> > +                       insn_idx =3D rec->insn_off / BPF_INSN_SZ;
> > +                       /* adjust insn_idx from section frame of refere=
nce to the local
> > +                        * program's frame of reference; (sub-)program =
code is not yet
> > +                        * relocated, so it's enough to just subtract i=
n-section offset
> > +                        */
> > +                       insn_idx =3D insn_idx - prog->sec_insn_off;
> > +                       if (insn_idx >=3D prog->insns_cnt)
> > +                               return -EINVAL;
> > +                       insn =3D &prog->insns[insn_idx];
> > +
>
> This validation probably is better to do before prog->obj->gen_loader
> check so that we don't silently do something bad in record_relo_core()
> if insn_idx is wrong? It doesn't change the rest of the logic, right?
> So there shouldn't be any harm or change of behavior.
>

I agree.


> > +                       err =3D bpf_core_resolve_relo(prog, rec, i, obj=
->btf, cand_cache, &targ_res);
> >                         if (err) {
> >                                 pr_warn("prog '%s': relo #%d: failed to=
 relocate: %d\n",
> >                                         prog->name, i, err);
> >                                 goto out;
> >                         }
> > +
> > +                       err =3D bpf_core_patch_insn(prog->name, insn, i=
nsn_idx, rec, i, &targ_res);
> > +                       if (err) {
> > +                               pr_warn("prog '%s': relo #%d: failed to=
 patch insn #%u: %d\n",
> > +                                       prog->name, i, insn_idx, err);
> > +                               goto out;
> > +                       }
> >                 }
> >         }
> >
>
> [...]
