Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D156736C9B9
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 18:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237497AbhD0Qse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 12:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237147AbhD0Qsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 12:48:31 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C02C061756;
        Tue, 27 Apr 2021 09:47:47 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id y2so68068872ybq.13;
        Tue, 27 Apr 2021 09:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ETQT6lTAq70f0FB6uQPtu9Igo0Ar8bHMDLmR+eEFm7Y=;
        b=ueH3RppL4qFWbHTh5hG8EecMFINQKMooJXgFDDK0ZmVEFO6vr0Cxrxlgio5T8tvCR0
         jXw2Lxpcbtq+SZj9Cjm47UagqljS/qqtBdQ16RR6YViFI6lk99JSrhkYyBpvugfvt0Xi
         3qH7BVh/v1mo+XzJGWm2oUMPKgNoeIcZRgBoejYc9VcerbOs8SA7uuULGa3VaxrwnLxJ
         UTfho0HXv+GROc8rwlWYZ0AwoNW0gN4E76uIfG6alwO9TvwBRoxK1Vqpvh6NjbZWWDKN
         2RP8+5aq6sbHvb2kkyZUA8JA1iZ6kmfxy39SEVXR6aqKe69XvyJMg62vbc4n5oIWpy+u
         /8Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ETQT6lTAq70f0FB6uQPtu9Igo0Ar8bHMDLmR+eEFm7Y=;
        b=MM7EA4oSYPwoFoeONqv/ax5/YtssXWFe+xJuMdl/+HltBUjHw9WrqMdAIztD5K3uvF
         QKP0SjcgG5EX75KbiYW5P0XT3hpnP0PARK7rg+LNfJ9PHG3fEdy6+ffjgIP1myXnz847
         QNLdBL+gBR7SMVtm+eV6EQNQIwmzOR5vNSMDv/P0ZjSRZrcxx05Xz+0nWj1eRnMb40Zc
         ys/C0rQLlmoLgPEPX8siIbNfTm7qwb9kUmEiOLOGkp1YlHhqZUyzSN1fUYZOtdVTEZRg
         bATbFS9TedcQ7BrFykAxXiGPQzbQlOrzqUmGk8kseVjSqwZBbPi5LUHtAHuDNMB/lS9F
         wt3w==
X-Gm-Message-State: AOAM532do81SUWAyvTopZASoGvyuZmwxCrp0hoOay6bRW//aHp9epGct
        jOz/wMLg/7mYbVnAz8NpFEALjspbR0UDkLGP4dg=
X-Google-Smtp-Source: ABdhPJx1oCpbHV4bPAtF5RERGPMrrFNrsJNU5fWXq7Uuhj9iUENFDPfK4OjcjzILmnD8x4NjDFPq9NoW8ChkBvuqbhI=
X-Received: by 2002:a25:7507:: with SMTP id q7mr13428956ybc.27.1619542066787;
 Tue, 27 Apr 2021 09:47:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-13-alexei.starovoitov@gmail.com> <CAEf4BzZofcwskPQXRpV4ZEiVbrzg296t+fSpezFxDLF3ueQBWg@mail.gmail.com>
 <20210427030016.54l2azit7mn2t4ji@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210427030016.54l2azit7mn2t4ji@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Apr 2021 09:47:35 -0700
Message-ID: <CAEf4BzZCHatwKGwXNVy3XPx9D2YgnTKa6NUCm3Y90T_oxhAQ7g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 12/16] libbpf: Change the order of data and
 text relocations.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 8:00 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Apr 26, 2021 at 10:29:09AM -0700, Andrii Nakryiko wrote:
> > On Thu, Apr 22, 2021 at 5:27 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > In order to be able to generate loader program in the later
> > > patches change the order of data and text relocations.
> > > Also improve the test to include data relos.
> > >
> > > If the kernel supports "FD array" the map_fd relocations can be processed
> > > before text relos since generated loader program won't need to manually
> > > patch ld_imm64 insns with map_fd.
> > > But ksym and kfunc relocations can only be processed after all calls
> > > are relocated, since loader program will consist of a sequence
> > > of calls to bpf_btf_find_by_name_kind() followed by patching of btf_id
> > > and btf_obj_fd into corresponding ld_imm64 insns. The locations of those
> > > ld_imm64 insns are specified in relocations.
> > > Hence process all data relocations (maps, ksym, kfunc) together after call relos.
> > >
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > ---
> > >  tools/lib/bpf/libbpf.c                        | 86 +++++++++++++++----
> > >  .../selftests/bpf/progs/test_subprogs.c       | 13 +++
> > >  2 files changed, 80 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 17cfc5b66111..c73a85b97ca5 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -6379,11 +6379,15 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
> > >                         insn[0].imm = ext->ksym.kernel_btf_id;
> > >                         break;
> > >                 case RELO_SUBPROG_ADDR:
> > > -                       insn[0].src_reg = BPF_PSEUDO_FUNC;
> > > -                       /* will be handled as a follow up pass */
> > > +                       if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
> > > +                               pr_warn("prog '%s': relo #%d: bad insn\n",
> > > +                                       prog->name, i);
> > > +                               return -EINVAL;
> > > +                       }
> >
> > given SUBPROG_ADDR is now handled similarly to RELO_CALL in a
> > different place, I'd probably drop this error check and just combine
> > RELO_SUBPROG_ADDR and RELO_CALL cases with just a /* handled already
> > */ comment.
>
> I prefer to keep them separate. I've hit this pr_warn couple times
> while messing with relos and it saved my time.
> I bet it will save time to the next developer too.

hmm.. ok, not critical to me

>
> > > +                       /* handled already */
> > >                         break;
> > >                 case RELO_CALL:
> > > -                       /* will be handled as a follow up pass */
> > > +                       /* handled already */
> > >                         break;
> > >                 default:
> > >                         pr_warn("prog '%s': relo #%d: bad relo type %d\n",
> > > @@ -6552,6 +6556,31 @@ static struct reloc_desc *find_prog_insn_relo(const struct bpf_program *prog, si
> > >                        sizeof(*prog->reloc_desc), cmp_relo_by_insn_idx);
> > >  }
> > >
> > > +static int append_subprog_relos(struct bpf_program *main_prog, struct bpf_program *subprog)
> > > +{
> > > +       int new_cnt = main_prog->nr_reloc + subprog->nr_reloc;
> > > +       struct reloc_desc *relos;
> > > +       size_t off = subprog->sub_insn_off;
> > > +       int i;
> > > +
> > > +       if (main_prog == subprog)
> > > +               return 0;
> > > +       relos = libbpf_reallocarray(main_prog->reloc_desc, new_cnt, sizeof(*relos));
> > > +       if (!relos)
> > > +               return -ENOMEM;
> > > +       memcpy(relos + main_prog->nr_reloc, subprog->reloc_desc,
> > > +              sizeof(*relos) * subprog->nr_reloc);
> > > +
> > > +       for (i = main_prog->nr_reloc; i < new_cnt; i++)
> > > +               relos[i].insn_idx += off;
> >
> > nit: off is used only here, so there is little point in having it as a
> > separate var, inline?
>
> sure.
>
> > > +       /* After insn_idx adjustment the 'relos' array is still sorted
> > > +        * by insn_idx and doesn't break bsearch.
> > > +        */
> > > +       main_prog->reloc_desc = relos;
> > > +       main_prog->nr_reloc = new_cnt;
> > > +       return 0;
> > > +}
> > > +
> > >  static int
> > >  bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
> > >                        struct bpf_program *prog)
> > > @@ -6560,18 +6589,32 @@ bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
> > >         struct bpf_program *subprog;
> > >         struct bpf_insn *insns, *insn;
> > >         struct reloc_desc *relo;
> > > -       int err;
> > > +       int err, i;
> > >
> > >         err = reloc_prog_func_and_line_info(obj, main_prog, prog);
> > >         if (err)
> > >                 return err;
> > >
> > > +       for (i = 0; i < prog->nr_reloc; i++) {
> > > +               relo = &prog->reloc_desc[i];
> > > +               insn = &main_prog->insns[prog->sub_insn_off + relo->insn_idx];
> > > +
> > > +               if (relo->type == RELO_SUBPROG_ADDR)
> > > +                       /* mark the insn, so it becomes insn_is_pseudo_func() */
> > > +                       insn[0].src_reg = BPF_PSEUDO_FUNC;
> > > +       }
> > > +
> >
> > This will do the same work over and over each time we append a subprog
> > to main_prog. This should logically follow append_subprog_relos(), but
> > you wanted to do it for main_prog with the same code, right?
>
> It cannot follow append_subprog_relos.
> It has to be done before the loop below.
> Otherwise !insn_is_pseudo_func() won't catch it and all ld_imm64 insns
> will be considered which will make the loop below more complex and slower.
> The find_prog_insn_relo() will be called a lot more times.
> !relo condition would be treated different ld_imm64 vs call insn, etc.

if you process main_prog->insns first all the calls to subprogs would
be updated, then it recursively would do this right before a new
subprog is added (initial call is bpf_object__reloc_code(obj, prog,
prog) where prog is entry-point program). But either way I'm not
suggesting doing this and splitting this logic into two places.

>
> > How about instead doing this before we start appending subprogs to
> > main_progs? I.e., do it explicitly in bpf_object__relocate() before
> > you start code relocation loop.
>
> Not sure I follow.
> Do another loop:
>  for (i = 0; i < obj->nr_programs; i++)
>     for (i = 0; i < prog->nr_reloc; i++)
>       if (relo->type == RELO_SUBPROG_ADDR)
>       ?
> That's an option too.
> I can do that if you prefer.
> It felt cleaner to do this mark here right before the loop below that needs it.

Yes, I'm proposing to do another loop in bpf_object__relocate() before
we start adding subprogs to main_progs. The reason is that
bpf_object__reloc_code() is called recursively many times for the same
main_prog, so doing that here is O(N^2) in the number of total
instructions in main_prog. It processes the same (already processed)
instructions many times unnecessarily. It's wasteful and unclean.

>
> > >         for (insn_idx = 0; insn_idx < prog->sec_insn_cnt; insn_idx++) {
> > >                 insn = &main_prog->insns[prog->sub_insn_off + insn_idx];
> > >                 if (!insn_is_subprog_call(insn) && !insn_is_pseudo_func(insn))
> > >                         continue;
> > >
> > >                 relo = find_prog_insn_relo(prog, insn_idx);
> > > +               if (relo && relo->type == RELO_EXTERN_FUNC)
> > > +                       /* kfunc relocations will be handled later
> > > +                        * in bpf_object__relocate_data()
> > > +                        */
> > > +                       continue;
> > >                 if (relo && relo->type != RELO_CALL && relo->type != RELO_SUBPROG_ADDR) {
> > >                         pr_warn("prog '%s': unexpected relo for insn #%zu, type %d\n",
> > >                                 prog->name, insn_idx, relo->type);
> >
> > [...]
>
> --
