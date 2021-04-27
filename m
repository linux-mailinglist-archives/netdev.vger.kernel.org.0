Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F69936BD9B
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 05:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhD0DBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 23:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbhD0DBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 23:01:01 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7A9C061574;
        Mon, 26 Apr 2021 20:00:19 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id q2so8407591pfk.9;
        Mon, 26 Apr 2021 20:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CrpNO3O5PJyzDQv5l4I+f817AmeY8AfQl4ai3h//J7E=;
        b=G9TEd/Cbpv9/60ZSLEpvUWNwLN3lwnfMRT6o8Vsq+jRS1zGq5XI7QEqBk8xcVWDPWM
         MkASwRTQYCYu7w7H6FNRxSukoZV9ZFgI2Jhg8h9t8pH+ziPvOL7Xm68EyNwz6J6p7Tr0
         6KC9UIGpUHVfAKfVLYlu8oIMgTboLrQ1gWYJ4I7dk9AG2qc5mSwfhLIzC1BvKI6QO3t1
         G9astYAGsWk0dVGxygXAL6pR/tK6sXui9YHuCEh2MKkDk5C5XO/m7So8XpkVC1fD8nOK
         0o/4x9N9OSvrQoBLAWRwqWWtJco4ArKpWuAFsQTXY+1hkPPTaEjj1UVtYP44Qawfx6Dn
         rJCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CrpNO3O5PJyzDQv5l4I+f817AmeY8AfQl4ai3h//J7E=;
        b=Btl+UpAkxhX36eXWkNZj5rC0NeZl+1WHxMYjMTFavQxzyPvCX7IKt5yIHAp6cAVoVG
         NUDn3rXOZI4XiYA5WwE55t1/X76hZq+SWRTaW/cQltc0P6jLuAhxRA7XnlOj0XQt0pa9
         X/w8ghfM3hI08jlcsVxb9Adse9ahEXpBWMHtBWoAK55i0PIO7RkmNSHDz00umqElJR5p
         HdbXTEI2bLTXZYh0tJrcUcHphKLa3T6xrCl9Qx3Vob2eLXpzizjom7AqATEeZc0qeUiK
         gqVrjrpre7egsl4/Ck6Rp3hsos4caIDzzbd7yvWjkhUzrTg1cZ2rl6+QFiKfT8jOYgtN
         8FUQ==
X-Gm-Message-State: AOAM533TnrGH2dNCleY9cEEMrOPiCM7N58V8B4+25t8l2byxz2JH/FfV
        1Pra4gU4krN8ch8lzE1QEU8D5JlfXpc=
X-Google-Smtp-Source: ABdhPJzFrYLjp/hZx+7E3e3xwCUJAe7hPxEKce1PV4/Z7F4WwFYBE5WO6QJK0BiowSmrZ1cik/l2iA==
X-Received: by 2002:a62:ea05:0:b029:27a:6fc6:af83 with SMTP id t5-20020a62ea050000b029027a6fc6af83mr1192740pfh.24.1619492418682;
        Mon, 26 Apr 2021 20:00:18 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1ad0])
        by smtp.gmail.com with ESMTPSA id a27sm893714pfl.64.2021.04.26.20.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 20:00:18 -0700 (PDT)
Date:   Mon, 26 Apr 2021 20:00:16 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 12/16] libbpf: Change the order of data and
 text relocations.
Message-ID: <20210427030016.54l2azit7mn2t4ji@ast-mbp.dhcp.thefacebook.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-13-alexei.starovoitov@gmail.com>
 <CAEf4BzZofcwskPQXRpV4ZEiVbrzg296t+fSpezFxDLF3ueQBWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZofcwskPQXRpV4ZEiVbrzg296t+fSpezFxDLF3ueQBWg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 10:29:09AM -0700, Andrii Nakryiko wrote:
> On Thu, Apr 22, 2021 at 5:27 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > In order to be able to generate loader program in the later
> > patches change the order of data and text relocations.
> > Also improve the test to include data relos.
> >
> > If the kernel supports "FD array" the map_fd relocations can be processed
> > before text relos since generated loader program won't need to manually
> > patch ld_imm64 insns with map_fd.
> > But ksym and kfunc relocations can only be processed after all calls
> > are relocated, since loader program will consist of a sequence
> > of calls to bpf_btf_find_by_name_kind() followed by patching of btf_id
> > and btf_obj_fd into corresponding ld_imm64 insns. The locations of those
> > ld_imm64 insns are specified in relocations.
> > Hence process all data relocations (maps, ksym, kfunc) together after call relos.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >  tools/lib/bpf/libbpf.c                        | 86 +++++++++++++++----
> >  .../selftests/bpf/progs/test_subprogs.c       | 13 +++
> >  2 files changed, 80 insertions(+), 19 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 17cfc5b66111..c73a85b97ca5 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -6379,11 +6379,15 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
> >                         insn[0].imm = ext->ksym.kernel_btf_id;
> >                         break;
> >                 case RELO_SUBPROG_ADDR:
> > -                       insn[0].src_reg = BPF_PSEUDO_FUNC;
> > -                       /* will be handled as a follow up pass */
> > +                       if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
> > +                               pr_warn("prog '%s': relo #%d: bad insn\n",
> > +                                       prog->name, i);
> > +                               return -EINVAL;
> > +                       }
> 
> given SUBPROG_ADDR is now handled similarly to RELO_CALL in a
> different place, I'd probably drop this error check and just combine
> RELO_SUBPROG_ADDR and RELO_CALL cases with just a /* handled already
> */ comment.

I prefer to keep them separate. I've hit this pr_warn couple times
while messing with relos and it saved my time.
I bet it will save time to the next developer too.

> > +                       /* handled already */
> >                         break;
> >                 case RELO_CALL:
> > -                       /* will be handled as a follow up pass */
> > +                       /* handled already */
> >                         break;
> >                 default:
> >                         pr_warn("prog '%s': relo #%d: bad relo type %d\n",
> > @@ -6552,6 +6556,31 @@ static struct reloc_desc *find_prog_insn_relo(const struct bpf_program *prog, si
> >                        sizeof(*prog->reloc_desc), cmp_relo_by_insn_idx);
> >  }
> >
> > +static int append_subprog_relos(struct bpf_program *main_prog, struct bpf_program *subprog)
> > +{
> > +       int new_cnt = main_prog->nr_reloc + subprog->nr_reloc;
> > +       struct reloc_desc *relos;
> > +       size_t off = subprog->sub_insn_off;
> > +       int i;
> > +
> > +       if (main_prog == subprog)
> > +               return 0;
> > +       relos = libbpf_reallocarray(main_prog->reloc_desc, new_cnt, sizeof(*relos));
> > +       if (!relos)
> > +               return -ENOMEM;
> > +       memcpy(relos + main_prog->nr_reloc, subprog->reloc_desc,
> > +              sizeof(*relos) * subprog->nr_reloc);
> > +
> > +       for (i = main_prog->nr_reloc; i < new_cnt; i++)
> > +               relos[i].insn_idx += off;
> 
> nit: off is used only here, so there is little point in having it as a
> separate var, inline?

sure.

> > +       /* After insn_idx adjustment the 'relos' array is still sorted
> > +        * by insn_idx and doesn't break bsearch.
> > +        */
> > +       main_prog->reloc_desc = relos;
> > +       main_prog->nr_reloc = new_cnt;
> > +       return 0;
> > +}
> > +
> >  static int
> >  bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
> >                        struct bpf_program *prog)
> > @@ -6560,18 +6589,32 @@ bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
> >         struct bpf_program *subprog;
> >         struct bpf_insn *insns, *insn;
> >         struct reloc_desc *relo;
> > -       int err;
> > +       int err, i;
> >
> >         err = reloc_prog_func_and_line_info(obj, main_prog, prog);
> >         if (err)
> >                 return err;
> >
> > +       for (i = 0; i < prog->nr_reloc; i++) {
> > +               relo = &prog->reloc_desc[i];
> > +               insn = &main_prog->insns[prog->sub_insn_off + relo->insn_idx];
> > +
> > +               if (relo->type == RELO_SUBPROG_ADDR)
> > +                       /* mark the insn, so it becomes insn_is_pseudo_func() */
> > +                       insn[0].src_reg = BPF_PSEUDO_FUNC;
> > +       }
> > +
> 
> This will do the same work over and over each time we append a subprog
> to main_prog. This should logically follow append_subprog_relos(), but
> you wanted to do it for main_prog with the same code, right?

It cannot follow append_subprog_relos.
It has to be done before the loop below.
Otherwise !insn_is_pseudo_func() won't catch it and all ld_imm64 insns
will be considered which will make the loop below more complex and slower.
The find_prog_insn_relo() will be called a lot more times.
!relo condition would be treated different ld_imm64 vs call insn, etc.

> How about instead doing this before we start appending subprogs to
> main_progs? I.e., do it explicitly in bpf_object__relocate() before
> you start code relocation loop.

Not sure I follow.
Do another loop:
 for (i = 0; i < obj->nr_programs; i++)
    for (i = 0; i < prog->nr_reloc; i++)
      if (relo->type == RELO_SUBPROG_ADDR)
      ?
That's an option too.
I can do that if you prefer.
It felt cleaner to do this mark here right before the loop below that needs it.

> >         for (insn_idx = 0; insn_idx < prog->sec_insn_cnt; insn_idx++) {
> >                 insn = &main_prog->insns[prog->sub_insn_off + insn_idx];
> >                 if (!insn_is_subprog_call(insn) && !insn_is_pseudo_func(insn))
> >                         continue;
> >
> >                 relo = find_prog_insn_relo(prog, insn_idx);
> > +               if (relo && relo->type == RELO_EXTERN_FUNC)
> > +                       /* kfunc relocations will be handled later
> > +                        * in bpf_object__relocate_data()
> > +                        */
> > +                       continue;
> >                 if (relo && relo->type != RELO_CALL && relo->type != RELO_SUBPROG_ADDR) {
> >                         pr_warn("prog '%s': unexpected relo for insn #%zu, type %d\n",
> >                                 prog->name, insn_idx, relo->type);
> 
> [...]

-- 
