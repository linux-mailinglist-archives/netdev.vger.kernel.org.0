Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA2B30A0C
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfEaIRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:17:01 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35697 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfEaIRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 04:17:01 -0400
Received: by mail-qt1-f195.google.com with SMTP id d23so1154342qto.2;
        Fri, 31 May 2019 01:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zG49i3fFvaE3LptqoAqK8TJQLWdwVR/TrQVf7eDZNuQ=;
        b=KVxYFlKZmYMCR8k3PdItitufjGxL2weHvtHHNuZXE403k77bS0zWvd7VWj+ACSf93p
         pxkRJ/CyCa/Jfr6fhleMAoKFhfXFb/ENp7jq+t+niIGkMbrd5ixtFGB+mE2p8zAC58RO
         yJeVomclIfsYuVMW4cWD9V+e9v2wtjgEHK2i9FDultVcfzbCD5fY+BBeF67V5s8yimdo
         xpeDGXVbHhH/J/pjROkk4K7BeYdxGHx6MhpG2uWGzCaPe+xpB9NHnG99VxgIUZYdovqX
         k66awXZhb5cTu7otQ6Jx21gjNbuEkmn+U9zs8kH2YWFrVtKLU5fC2ELR4aPMBb/mnfEh
         W8Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zG49i3fFvaE3LptqoAqK8TJQLWdwVR/TrQVf7eDZNuQ=;
        b=WdYKqGbxhv3A3rEqK3p5jfGL4jl443PrOn3CqJvY9h+srb5xtnhIQqTF6DM4W5TBLB
         rFBvM4h9sLz/hYemuvk0hOY0tH3azZFu0kZF/WuWSiXnfSZYIad2vaWPYHhpeNsGT7hn
         jK2Svp7gyv8UP2qKnrANgnEKmkmVWrmxI7OuiuxCCNFZWKp1GrF1qkVKQufU86FmqXHV
         AcOB4KdJFQpKN+ge9C8ZkYNLNuEd0/lb5Xl+sR9PQxtxlGtUrodXbg45S6HvmUOtrsVc
         5Zr17ewcGk1JnRNDHfWLtA9sZW3TG7JQECZ7XDwSBZ/ZLmK0fEAVtD6ZvvRqapKjHl5a
         2Q7A==
X-Gm-Message-State: APjAAAWeW8EQ4TtCHe6VT22XkMLQET+m8jCXh9YHxirNG6zOYcZ8C0gV
        qFqw7mDgX4eWJC4e8mAKfq59LCdwSnHUDvBUC1M=
X-Google-Smtp-Source: APXvYqypiJYBUTpH4bwam0exPDV9u17o9bC+HcgbWkIpk1rkN2AfaQyFZtt5i6HZe5ZhCkqZFAl1OZlVJmiZ4r7OSjM=
X-Received: by 2002:ac8:4442:: with SMTP id m2mr8021337qtn.107.1559290619388;
 Fri, 31 May 2019 01:16:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190530222922.4269-1-luke.r.nels@gmail.com> <CAPhsuW4JXN65P4b_uXdJX12RZFU0HyuREZuwrm+tEQ0rq8-oRA@mail.gmail.com>
In-Reply-To: <CAPhsuW4JXN65P4b_uXdJX12RZFU0HyuREZuwrm+tEQ0rq8-oRA@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 31 May 2019 10:16:48 +0200
Message-ID: <CAJ+HfNi8ioZyMjbXGP=G3F_ZUmqO=CXMy6vzpL_rK6jn+hUpXw@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf, riscv: clear high 32 bits for ALU32 add/sub/neg/lsh/rsh/arsh
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>,
        linux-riscv@lists.infradead.org, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 May 2019 at 01:08, Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Thu, May 30, 2019 at 3:30 PM Luke Nelson <luke.r.nels@gmail.com> wrote=
:
> >
> > In BPF, 32-bit ALU operations should zero-extend their results into
> > the 64-bit registers.
> >
> > The current BPF JIT on RISC-V emits incorrect instructions that perform
> > sign extension only (e.g., addw, subw) on 32-bit add, sub, lsh, rsh,
> > arsh, and neg. This behavior diverges from the interpreter and JITs
> > for other architectures.
> >
> > This patch fixes the bugs by performing zero extension on the destinati=
on
> > register of 32-bit ALU operations.
> >
> > Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
> > Cc: Xi Wang <xi.wang@gmail.com>
> > Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>

Luke, thanks for fixing this! Nice work!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>

>
> > ---
> > The original patch is
> > https://lkml.org/lkml/2019/5/30/1370
> >
> > This version is rebased against the bpf tree.
> > ---
> >  arch/riscv/net/bpf_jit_comp.c | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> >
> > diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_com=
p.c
> > index e5c8d675bd6e..426d5c33ea90 100644
> > --- a/arch/riscv/net/bpf_jit_comp.c
> > +++ b/arch/riscv/net/bpf_jit_comp.c
> > @@ -751,10 +751,14 @@ static int emit_insn(const struct bpf_insn *insn,=
 struct rv_jit_context *ctx,
> >         case BPF_ALU | BPF_ADD | BPF_X:
> >         case BPF_ALU64 | BPF_ADD | BPF_X:
> >                 emit(is64 ? rv_add(rd, rd, rs) : rv_addw(rd, rd, rs), c=
tx);
> > +               if (!is64)
> > +                       emit_zext_32(rd, ctx);
> >                 break;
> >         case BPF_ALU | BPF_SUB | BPF_X:
> >         case BPF_ALU64 | BPF_SUB | BPF_X:
> >                 emit(is64 ? rv_sub(rd, rd, rs) : rv_subw(rd, rd, rs), c=
tx);
> > +               if (!is64)
> > +                       emit_zext_32(rd, ctx);
> >                 break;
> >         case BPF_ALU | BPF_AND | BPF_X:
> >         case BPF_ALU64 | BPF_AND | BPF_X:
> > @@ -795,14 +799,20 @@ static int emit_insn(const struct bpf_insn *insn,=
 struct rv_jit_context *ctx,
> >         case BPF_ALU | BPF_LSH | BPF_X:
> >         case BPF_ALU64 | BPF_LSH | BPF_X:
> >                 emit(is64 ? rv_sll(rd, rd, rs) : rv_sllw(rd, rd, rs), c=
tx);
> > +               if (!is64)
> > +                       emit_zext_32(rd, ctx);
> >                 break;
> >         case BPF_ALU | BPF_RSH | BPF_X:
> >         case BPF_ALU64 | BPF_RSH | BPF_X:
> >                 emit(is64 ? rv_srl(rd, rd, rs) : rv_srlw(rd, rd, rs), c=
tx);
> > +               if (!is64)
> > +                       emit_zext_32(rd, ctx);
> >                 break;
> >         case BPF_ALU | BPF_ARSH | BPF_X:
> >         case BPF_ALU64 | BPF_ARSH | BPF_X:
> >                 emit(is64 ? rv_sra(rd, rd, rs) : rv_sraw(rd, rd, rs), c=
tx);
> > +               if (!is64)
> > +                       emit_zext_32(rd, ctx);
> >                 break;
> >
> >         /* dst =3D -dst */
> > @@ -810,6 +820,8 @@ static int emit_insn(const struct bpf_insn *insn, s=
truct rv_jit_context *ctx,
> >         case BPF_ALU64 | BPF_NEG:
> >                 emit(is64 ? rv_sub(rd, RV_REG_ZERO, rd) :
> >                      rv_subw(rd, RV_REG_ZERO, rd), ctx);
> > +               if (!is64)
> > +                       emit_zext_32(rd, ctx);
> >                 break;
> >
> >         /* dst =3D BSWAP##imm(dst) */
> > @@ -964,14 +976,20 @@ static int emit_insn(const struct bpf_insn *insn,=
 struct rv_jit_context *ctx,
> >         case BPF_ALU | BPF_LSH | BPF_K:
> >         case BPF_ALU64 | BPF_LSH | BPF_K:
> >                 emit(is64 ? rv_slli(rd, rd, imm) : rv_slliw(rd, rd, imm=
), ctx);
> > +               if (!is64)
> > +                       emit_zext_32(rd, ctx);
> >                 break;
> >         case BPF_ALU | BPF_RSH | BPF_K:
> >         case BPF_ALU64 | BPF_RSH | BPF_K:
> >                 emit(is64 ? rv_srli(rd, rd, imm) : rv_srliw(rd, rd, imm=
), ctx);
> > +               if (!is64)
> > +                       emit_zext_32(rd, ctx);
> >                 break;
> >         case BPF_ALU | BPF_ARSH | BPF_K:
> >         case BPF_ALU64 | BPF_ARSH | BPF_K:
> >                 emit(is64 ? rv_srai(rd, rd, imm) : rv_sraiw(rd, rd, imm=
), ctx);
> > +               if (!is64)
> > +                       emit_zext_32(rd, ctx);
> >                 break;
> >
> >         /* JUMP off */
> > --
> > 2.19.1
> >
