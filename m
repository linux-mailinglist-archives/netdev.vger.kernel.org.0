Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AB325B4C5
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 21:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIBTwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 15:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgIBTwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 15:52:40 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8293C061244;
        Wed,  2 Sep 2020 12:52:39 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id u6so476638ybf.1;
        Wed, 02 Sep 2020 12:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dj2750p0sregmEuLVCaZvkSO0triG/j2T/O2tveQBb4=;
        b=RNqNwe/JY0XD2dWhBtH4DbdLdSnVD3Y/0BoWaYlKCpU4eCHgKL0udLsS7Xd7smEKEo
         2rQ1EOY79rt1jZIn+opNTaiaYaa3UN+sx6+6Ql4KV4Cd5ccyfdkW+XW+REPnKyfp+/hp
         RxHOlDY4PdPTeZTJ1FTMRRNPKDuAnEgugbpat36O5NAYGfNlvPU9z1UcRbNEm24whUvg
         AdKTvq4QLgtw/ki/YvVENSoOnZkU7byIHO0RAhjc8YaS/lFDgndOiqEg2GSCl9MkGfbb
         1hQbt9PmKWkoW7uZ1nnO6ZHL8fUEM5cR6l/VErVgyI5nrEXUr1GbJrcm8sG/hveJqMRU
         gRnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dj2750p0sregmEuLVCaZvkSO0triG/j2T/O2tveQBb4=;
        b=oyFyuGqtHypWGCNcmFGtORbnKuAFCCIc/BKWF0BucWPS/ICkxnmeWhITAsKhqseJ79
         y9vIKt8z/TvMTnUhvnPJUoj8QFXZyd4YYAx8PXri9vcUyu4uYwNJHY1Udm2TH+Wqh5SB
         g+8wf5JCdekiqvnEYWKOUWHNG0WOYa9erkXykl0hr+IuoRjbuhQECxaJRxF/Mu0bGyv0
         fYKGfsVmNFpKec3huJAdgbHMbuSiGLI3/Q3RocJejx/vZqcP0NDbX/qIdhZ19uVQ9Pe5
         ZVip2q1si3S6pg2z8nHgBb5aYX2n41n1IMAjRrWlB2ci2s1OJIRU1vg1TlTMU851HFqX
         5OPw==
X-Gm-Message-State: AOAM530S/pzitPW+jNr43i3UpJf5+jKgvCoajUaTu3vD4Tf+olK6n7M7
        ef8oFCSJqjlpFHUf2eeAd7kMih7ScNdX8O1ezxc=
X-Google-Smtp-Source: ABdhPJyG9bdDNHuoH7ijeXAIwntXUrl4wIH74VOnsmc2WeOmei2DGuarWcLJuxCYmXjRO2vQs1oeko7OnGkWeiTaSTM=
X-Received: by 2002:a25:824a:: with SMTP id d10mr12629759ybn.260.1599076358917;
 Wed, 02 Sep 2020 12:52:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200901015003.2871861-1-andriin@fb.com> <20200901015003.2871861-5-andriin@fb.com>
 <20200902053628.bqqytnpebrum7heh@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200902053628.bqqytnpebrum7heh@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Sep 2020 12:52:27 -0700
Message-ID: <CAEf4BzYkpJWUqeNJfVpyC1Cf5ThHXkpxV-yrgY0XfAmEie6tKg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 04/14] libbpf: make RELO_CALL work for
 multi-prog sections and sub-program calls
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 10:36 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Aug 31, 2020 at 06:49:53PM -0700, Andrii Nakryiko wrote:
> > +
> > +static int
> > +bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
> > +                    struct bpf_program *prog)
> > +{
> > +     size_t sub_insn_idx, insn_idx, new_cnt;
> > +     struct bpf_program *subprog;
> > +     struct bpf_insn *insns, *insn;
> > +     struct reloc_desc *relo;
> > +     int err;
> > +
> > +     err = reloc_prog_func_and_line_info(obj, main_prog, prog);
> > +     if (err)
> > +             return err;
> > +
> > +     for (insn_idx = 0; insn_idx < prog->sec_insn_cnt; insn_idx++) {
> > +             insn = &main_prog->insns[prog->sub_insn_off + insn_idx];
> > +             if (!insn_is_subprog_call(insn))
> > +                     continue;
> > +
> > +             relo = find_prog_insn_relo(prog, insn_idx);
> > +             if (relo && relo->type != RELO_CALL) {
> > +                     pr_warn("prog '%s': unexpected relo for insn #%zu, type %d\n",
> > +                             prog->name, insn_idx, relo->type);
> > +                     return -LIBBPF_ERRNO__RELOC;
> > +             }
> > +             if (relo) {
> > +                     /* sub-program instruction index is a combination of
> > +                      * an offset of a symbol pointed to by relocation and
> > +                      * call instruction's imm field; for global functions,
> > +                      * call always has imm = -1, but for static functions
> > +                      * relocation is against STT_SECTION and insn->imm
> > +                      * points to a start of a static function
> > +                      */
> > +                     sub_insn_idx = relo->sym_off / BPF_INSN_SZ + insn->imm + 1;
> > +             } else {
> > +                     /* if subprogram call is to a static function within
> > +                      * the same ELF section, there won't be any relocation
> > +                      * emitted, but it also means there is no additional
> > +                      * offset necessary, insns->imm is relative to
> > +                      * instruction's original position within the section
> > +                      */
>
> Great two comments. Thanks.
>
> > +                     sub_insn_idx = prog->sec_insn_off + insn_idx + insn->imm + 1;
> > +             }
> > +
> > +             /* we enforce that sub-programs should be in .text section */
> > +             subprog = find_prog_by_sec_insn(obj, obj->efile.text_shndx, sub_insn_idx);
> > +             if (!subprog) {
> > +                     pr_warn("prog '%s': no .text section found yet sub-program call exists\n",
> > +                             prog->name);
> > +                     return -LIBBPF_ERRNO__RELOC;
> > +             }
> > +
> > +             /* if subprogram hasn't been used in current main program,
> > +              * relocate it and append at the end of main program code
> > +              */
>
> This one is quite confusing.
> "hasn't been used" isn't right.
> This subprog was used, but wasn't appeneded yet. That's what sub_insn_off is tracking.

"hasn't been used *yet*" would be more precise, meaning: up until the
current instruction there were no calls to that subprogram.

> Also "relocate and append it" is not right either.
> It's "append and start relocating".

Right, order of actions is wrong, I'll fix the wording.

> Probably shouldn't call it 'main' and 'subprog'.
> It equally applies to 'subprog' and 'another subprog'.

Yes, you are right, I'll update comments to be less confusing.

>
> > +             if (subprog->sub_insn_off == 0) {
> > +                     subprog->sub_insn_off = main_prog->insns_cnt;
> > +
> > +                     new_cnt = main_prog->insns_cnt + subprog->insns_cnt;
> > +                     insns = libbpf_reallocarray(main_prog->insns, new_cnt, sizeof(*insns));
> > +                     if (!insns) {
> > +                             pr_warn("prog '%s': failed to realloc prog code\n", main_prog->name);
> > +                             return -ENOMEM;
> > +                     }
> > +                     main_prog->insns = insns;
> > +                     main_prog->insns_cnt = new_cnt;
> > +
> > +                     memcpy(main_prog->insns + subprog->sub_insn_off, subprog->insns,
> > +                            subprog->insns_cnt * sizeof(*insns));
> > +
> > +                     pr_debug("prog '%s': added %zu insns from sub-prog '%s'\n",
> > +                              main_prog->name, subprog->insns_cnt, subprog->name);
> > +
> > +                     err = bpf_object__reloc_code(obj, main_prog, subprog);
> > +                     if (err)
> > +                             return err;
> > +             }
> > +
> > +             /* main_prog->insns memory could have been re-allocated, so
> > +              * calculate pointer again
> > +              */
> > +             insn = &main_prog->insns[prog->sub_insn_off + insn_idx];
> > +             /* calculate correct instruction position within main prog */
>
> may be: "calculate position within the prog being relocated?"

no-no, in this case it's an instruction index within the main
(entry-point) BPF program with all the used subprograms appended. So
even if we have subprog1 calling another subprog2, all the instruction
indices are calculated within the main BPF program's "system of
coordinates", because each main BPF program can have a different
subset of functions appended and subprogs might be in a different
order and at different positions.

>
> > +             insn->imm = subprog->sub_insn_off - (prog->sub_insn_off + insn_idx) - 1;
>
> I think the algorithm is sound.
> Could you add a better description of it?
> May be some small diagram to illustrate how it recursively relocates?
> That it starts with main, walks some number of insn, when it sees pseudo_call to
> not yet appended subprog, it adds it to the end and recursively starts relocating it.
> That subprog can have relos too. If they're pointing to not yet appended subprog it will be
> added again and that 2nd subprog will start relocating while the main and 1st subprog
> will be pending.

Ok, I'll try to give some better overview in the comments.

> The algorithm didn't have to be recursive, but I guess it's fine to keep this way.
> It's simple enough. I haven't thought through how it can look without recursion.
> Probably a bunch of book keeping of things to relocate would have been necessary.

It's a graph traversing problem to figure out which subprograms need
to be appended. I did it DFS style because it's a bit simpler that way
(there is no separate pass for detecting used subprogs and then
relocating all of them), plus libbpf already relies on recursion (at
least for CO-RE), so I didn't feel bad about it. It's possible to do
it with BFS, though, by maintaining a queue of to-be-processed
subprogs, mark and append them. Then as a second pass relocate calls.
But as you said, it's simple enough on a high-level, that I'd stick to
what I have. I'll improve the comments, though.
