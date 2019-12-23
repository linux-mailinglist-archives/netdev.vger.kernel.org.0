Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECF351299AC
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 18:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfLWR6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 12:58:37 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41818 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfLWR6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 12:58:37 -0500
Received: by mail-qt1-f194.google.com with SMTP id k40so16022304qtk.8;
        Mon, 23 Dec 2019 09:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MOIJPLnYWO6xhwNtkPa9aUeQn2rPZqunfhFQTUewSq8=;
        b=V6p/o4m4SyafWDM+yhgE1T3q2Vs1LEhS94p3HAek0I7DtIHmfvqF71rmZz8hgQwWqf
         e9IMLM0fRAoeal838i9B8pVMTh1dMc1KOrpvE4WGHeDMTFbfgBEWvc63YLJwC5NWXGmQ
         CvfCjCH8xE2ytmwqmgY47oNJN7xY4KPUzWSe2ZJCsTSGRaY0JFu43W0MCeqoy+EkiK34
         Cv/c4WRBw3UTu5EMHy7Iy3EQyIlwaIByStI5y1obhDT29uwlInKK7sq4zwnFU8J5MlCn
         bWpGsb3v8aqTkwei6+l1mtJLlzjKUNCoyy4A10mJ8XrOi7TC8Cm+HpIyE5+rPifS0JyY
         cqWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MOIJPLnYWO6xhwNtkPa9aUeQn2rPZqunfhFQTUewSq8=;
        b=QSoxIFl+Ho+URzSEP1HnbCIMdioswVgQkAwbFMuvlkfxEBdQBfqvKnLIVos+oGa55M
         ajjbK1OZ/kNr9PGq0ByRWEZC+wullLEPqe67kFUtC0NpSA3fcz2kqVyIOzfq1C0R6AG7
         kawIgnjF4wixMg5Wmn6mdGFUuLS86oXCTOan09DyAWJyf8tkhHQUpiVEhkYc7KSj6KV0
         ibZiO8xvOZ3mL3ZV/IqVDqaMJ2xbUhxG0W4xVaJRP6y4cCmiohf1SnIJYKhyN0k95s6r
         rvChCH6neq/BZNpGQmJO0kHjnm71E2rYhYPVRCSe8VT8EgB48hZazAOhfV6KQtL9mw7s
         P+Pg==
X-Gm-Message-State: APjAAAUXZQ/nHJIQQvMbcUbCHxv/at6g3pguGjd1WpTILuMlhH0Wux2L
        a83Q+kfUyNeAFMYluJ/9ocdLOSZy3SxUlYW5g0MzZw==
X-Google-Smtp-Source: APXvYqxC8I8i03imTUMCnWH/ljIBn+G/veL9mAbYHXIQR0HbOaK+QQTFUTz8djDmdN0xU+Vq7kXkQrE2EwZOlZ+CLtY=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr23342586qtl.171.1577123915944;
 Mon, 23 Dec 2019 09:58:35 -0800 (PST)
MIME-Version: 1.0
References: <20191223061855.1601999-1-andriin@fb.com> <e70fde6d-77fd-6fa8-c6ce-23848dce4b22@fb.com>
In-Reply-To: <e70fde6d-77fd-6fa8-c6ce-23848dce4b22@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Dec 2019 09:58:24 -0800
Message-ID: <CAEf4Bzb4T0fxPGROLOFua9D5smjwqyGwkH7FqA58PBj=+1Dvew@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: support CO-RE relocations for
 LD/LDX/ST/STX instructions
To:     Yonghong Song <yhs@fb.com>
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

On Sun, Dec 22, 2019 at 11:48 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/22/19 10:18 PM, Andrii Nakryiko wrote:
> > Clang patch [0] enables emitting relocatable generic ALU/ALU64 instructions
> > (i.e, shifts and arithmetic operations), as well as generic load/store
> > instructions. The former ones are already supported by libbpf as is. This
> > patch adds further support for load/store instructions. Relocatable field
> > offset is encoded in BPF instruction's 16-bit offset section and are adjusted
> > by libbpf based on target kernel BTF.
> >
> > These Clang changes and corresponding libbpf changes allow for more succinct
> > generated BPF code by encoding relocatable field reads as a single
> > LD/ST/LDX/STX instruction. It also enables relocatable access to BPF context.
> > Previously, if context struct (e.g., __sk_buff) was accessed with CO-RE
> > relocations (e.g., due to preserve_access_index attribute), it would be
> > rejected by BPF verifier due to modified context pointer dereference. With
> > Clang patch, such context accesses are both relocatable and have a fixed
> > offset from the point of view of BPF verifier.
> >
> >    [0] https://reviews.llvm.org/D71790
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   tools/lib/bpf/libbpf.c | 32 +++++++++++++++++++++++++++++---
> >   1 file changed, 29 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 9576a90c5a1c..2dbc2204a02c 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -18,6 +18,7 @@
> >   #include <stdarg.h>
> >   #include <libgen.h>
> >   #include <inttypes.h>
> > +#include <limits.h>
> >   #include <string.h>
> >   #include <unistd.h>
> >   #include <endian.h>
> > @@ -3810,11 +3811,13 @@ static int bpf_core_reloc_insn(struct bpf_program *prog,
> >       insn = &prog->insns[insn_idx];
> >       class = BPF_CLASS(insn->code);
> >
> > -     if (class == BPF_ALU || class == BPF_ALU64) {
> > +     switch (class) {
> > +     case BPF_ALU:
> > +     case BPF_ALU64:
> >               if (BPF_SRC(insn->code) != BPF_K)
> >                       return -EINVAL;
> >               if (!failed && validate && insn->imm != orig_val) {
> > -                     pr_warn("prog '%s': unexpected insn #%d value: got %u, exp %u -> %u\n",
> > +                     pr_warn("prog '%s': unexpected insn #%d (ALU/ALU64) value: got %u, exp %u -> %u\n",
> >                               bpf_program__title(prog, false), insn_idx,
> >                               insn->imm, orig_val, new_val);
> >                       return -EINVAL;
> > @@ -3824,7 +3827,30 @@ static int bpf_core_reloc_insn(struct bpf_program *prog,
> >               pr_debug("prog '%s': patched insn #%d (ALU/ALU64)%s imm %u -> %u\n",
> >                        bpf_program__title(prog, false), insn_idx,
> >                        failed ? " w/ failed reloc" : "", orig_val, new_val);
> > -     } else {
> > +             break;
> > +     case BPF_LD:
>
> Maybe we should remove BPF_LD here? BPF_LD is used for ld_imm64, ld_abs
> and ld_ind, where the insn->off = 0 and not really used.

Sure, I can drop BPF_LD case. Will send v2 soon.

> > +     case BPF_LDX:
> > +     case BPF_ST:
> > +     case BPF_STX: > +               if (!failed && validate && insn->off != orig_val) {
> > +                     pr_warn("prog '%s': unexpected insn #%d (LD/LDX/ST/STX) value: got %u, exp %u -> %u\n",
> > +                             bpf_program__title(prog, false), insn_idx,
> > +                             insn->off, orig_val, new_val);
> > +                     return -EINVAL;
> > +             }
> > +             if (new_val > SHRT_MAX) {
> > +                     pr_warn("prog '%s': insn #%d (LD/LDX/ST/STX) value too big: %u\n",
> > +                             bpf_program__title(prog, false), insn_idx,
> > +                             new_val);
> > +                     return -ERANGE;
> > +             }
> > +             orig_val = insn->off;
> > +             insn->off = new_val;
> > +             pr_debug("prog '%s': patched insn #%d (LD/LDX/ST/STX)%s off %u -> %u\n",
> > +                      bpf_program__title(prog, false), insn_idx,
> > +                      failed ? " w/ failed reloc" : "", orig_val, new_val);
> > +             break;
> > +     default:
> >               pr_warn("prog '%s': trying to relocate unrecognized insn #%d, code:%x, src:%x, dst:%x, off:%x, imm:%x\n",
> >                       bpf_program__title(prog, false),
> >                       insn_idx, insn->code, insn->src_reg, insn->dst_reg,
> >
