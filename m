Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D79C3148DC9
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 19:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389785AbgAXSaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 13:30:25 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:41956 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391373AbgAXSaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 13:30:25 -0500
Received: by mail-qv1-f65.google.com with SMTP id x1so1362338qvr.8;
        Fri, 24 Jan 2020 10:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ervQnwZycY6Q2nRsUrQ7vVbEW2Ctl4Ou06dvMPHCCVA=;
        b=CdLp+Ec/tELSg4qwiODit9/lLCFsXnMNWl+LT97cECWQw93f1++25233854SRqyKq9
         iQ6DGs3U1yrq5knIZ43swtTBAR5Lc6Fe+wJLVHXhAvCXjcBNoaZFdahH+HRuWizz5LKO
         B9XqgBwdKr3UGnM5LZnRQl5V5YFDs+T1kg7BNb3as2VvE8ihI4lKxCHQzhYVP0lDfNyt
         fpJpRjmPC/iAHqHgMKJJsddXUW0MpKGp3Y+KRfNtJSOPgo7V7TxAiWcO9tB/2SoS3DAQ
         gePV85JeEoiXPcvx/l9xwMTWC5B8KrN2ofaUp/Ec8oVKAO3YYXKE5+xVSbTJ3iMOKUi7
         8+Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ervQnwZycY6Q2nRsUrQ7vVbEW2Ctl4Ou06dvMPHCCVA=;
        b=k6q52ZLgzzVETUvaKQPDDDdUfBQULlXSCZDzcakf5qXD4wbtGIpElWfFjUjoIh/f3P
         X10NJha+CIw9DRmn42EnT8vRkXOL8igHTX5L+tkmpR0hcQQVfOVlHdglsyUKuZczZDwi
         DDPatn7MaefM8nm3fQkUQgkeAX01HmUbYk2VOSx9+iAYh+iEXLF/bsrcPxO0MMJMudQK
         U15u+q26w4XJOKtBVB1aXd6BCGcrYHQ0fEYarC3cmpOrZi6T2iXplFTPHOp/T/yDs1Bn
         sJuHHZLeynWYJ/mSXmOb2jUuZRBns58WdzBpX+2BPwRxOK4RaGeiTyUwwCJasUcvyoHv
         clVw==
X-Gm-Message-State: APjAAAWEvWrWhYooEgbZxlBDsi9vTr1/bRp+2p8Ty1r1P61PW9ihUgJ3
        SPp3DsMgKMJlS6qANsjm/rLORPkawP74Qq8esCk=
X-Google-Smtp-Source: APXvYqwRuHm2zYnkq8o6p67dvdfSFOnQndYK09v8dZMbX+Oa6/7gEGsyyUP+8NjWYXFL6C5pko7A70C0lrsAjBzBVeA=
X-Received: by 2002:ad4:54d3:: with SMTP id j19mr4119650qvx.247.1579890623644;
 Fri, 24 Jan 2020 10:30:23 -0800 (PST)
MIME-Version: 1.0
References: <20200124053837.2434679-1-andriin@fb.com> <20200124072054.2kr25erckbclkwgv@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200124072054.2kr25erckbclkwgv@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 24 Jan 2020 10:30:12 -0800
Message-ID: <CAEf4BzbM7s8JWM8bPq=JdFX-ujkbYUifD7hNUQOGSJpJ7x5NJw@mail.gmail.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] libbpf: improve handling of
 failed CO-RE relocations
To:     Martin Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 11:21 PM Martin Lau <kafai@fb.com> wrote:
>
> On Thu, Jan 23, 2020 at 09:38:37PM -0800, Andrii Nakryiko wrote:
> > Previously, if libbpf failed to resolve CO-RE relocation for some
> > instructions, it would either return error immediately, or, if
> > .relaxed_core_relocs option was set, would replace relocatable offset/imm part
> > of an instruction with a bogus value (-1). Neither approach is good, because
> > there are many possible scenarios where relocation is expected to fail (e.g.,
> > when some field knowingly can be missing on specific kernel versions). On the
> > other hand, replacing offset with invalid one can hide programmer errors, if
> > this relocation failue wasn't anticipated.
> >
> > This patch deprecates .relaxed_core_relocs option and changes the approach to
> > always replacing instruction, for which relocation failed, with invalid BPF
> > helper call instruction. For cases where this is expected, BPF program should
> > already ensure that that instruction is unreachable, in which case this
> > invalid instruction is going to be silently ignored. But if instruction wasn't
> > guarded, BPF program will be rejected at verification step with verifier log
> > pointing precisely to the place in assembly where the problem is.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 95 +++++++++++++++++++++++++-----------------
> >  tools/lib/bpf/libbpf.h |  6 ++-
> >  2 files changed, 61 insertions(+), 40 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index ae34b681ae82..39f1b7633a7c 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -345,7 +345,6 @@ struct bpf_object {
> >
> >       bool loaded;
> >       bool has_pseudo_calls;
> > -     bool relaxed_core_relocs;
> >
> >       /*
> >        * Information when doing elf related work. Only valid if fd
> > @@ -4238,25 +4237,38 @@ static int bpf_core_calc_field_relo(const struct bpf_program *prog,
> >   */
> >  static int bpf_core_reloc_insn(struct bpf_program *prog,
> >                              const struct bpf_field_reloc *relo,
> > +                            int relo_idx,
> >                              const struct bpf_core_spec *local_spec,
> >                              const struct bpf_core_spec *targ_spec)
> >  {
> > -     bool failed = false, validate = true;
> >       __u32 orig_val, new_val;
> >       struct bpf_insn *insn;
> > +     bool validate = true;
> >       int insn_idx, err;
> >       __u8 class;
> >
> >       if (relo->insn_off % sizeof(struct bpf_insn))
> >               return -EINVAL;
> >       insn_idx = relo->insn_off / sizeof(struct bpf_insn);
> > +     insn = &prog->insns[insn_idx];
> > +     class = BPF_CLASS(insn->code);
> >
> >       if (relo->kind == BPF_FIELD_EXISTS) {
> >               orig_val = 1; /* can't generate EXISTS relo w/o local field */
> >               new_val = targ_spec ? 1 : 0;
> >       } else if (!targ_spec) {
> > -             failed = true;
> > -             new_val = (__u32)-1;
> > +             pr_debug("prog '%s': relo #%d: substituting insn #%d w/ invalid insn\n",
> > +                      bpf_program__title(prog, false), relo_idx, insn_idx);
> > +             insn->code = BPF_JMP | BPF_CALL;
> > +             insn->dst_reg = 0;
> > +             insn->src_reg = 0;
> > +             insn->off = 0;
> > +             /* if this instruction is reachable (not a dead code),
> > +              * verifier will complain with the following message:
> > +              * invalid func unknown#195896080
> > +              */
> > +             insn->imm = 195896080; /* => 0xbad2310 => "bad relo" */
> Should this value become a binded contract in uapi/bpf.h so
> that the verifier can print a more meaningful name than "unknown#195896080"?
>

It feels a bit premature to fix this in kernel. It's one of many ways
we can do this, e.g., alternative would be using invalid opcode
altogether. It's not yet clear what's the best way to report this from
kernel. Maybe in the future verifier will have some better way to
pinpoint where and what problem there is in user's program through
some more structured approach than current free-form log.

So what I'm trying to say is that we should probably get a bit more
experience using these features first and understand what
kernel/userspace interface should be for reporting issues like this,
before setting anything in stone in verifier. For now, this
"unknown#195896080" should be a pretty unique search term :)

> > +             return 0;
> >       } else {
> >               err = bpf_core_calc_field_relo(prog, relo, local_spec,
> >                                              &orig_val, &validate);
