Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F420A178A74
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 06:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgCDF7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 00:59:30 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38808 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgCDF7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 00:59:30 -0500
Received: by mail-qk1-f195.google.com with SMTP id j7so258477qkd.5;
        Tue, 03 Mar 2020 21:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1lsTGiKn6oHoT5mTkEzaNQeGDmYRHT45EUorz4TmpOc=;
        b=P+GFoCJAoKq3kAujQuBLX4vLpvGiToWarwyt3I7yMT0ETN7SZRei0g4q4AEM8fpOCK
         vof7NPoTFevjAaCDDf/SbV27a2geaTAmtKyojHhp4lYyDScNLf91yCnvp+3ImOQHEqYX
         RiIswSOTBHbTfmt+F89PSOXpZ+FGMDvCdwYMfWXCc25xkge9SqweZstLIYKfXEvfDgRn
         Wu/ouC4ASS4qkL3jX6YMT5JE5AEfVUW8BDNdjIWBAaefsUp6iSJfYrhQoJV1A1XfVw+a
         s2vctFbM/kZly5xFmfvV2sdYjgHZ2PBrxaCfSplrsUBGAJ0h7LhSWPAUxgp74GTevSTl
         u6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1lsTGiKn6oHoT5mTkEzaNQeGDmYRHT45EUorz4TmpOc=;
        b=KBrM+ubgPHVbIuIqkJHwxPq4bRXwra9K3KONXJZOPEV69KWXpdtk28al6BvmlcJYka
         sC0nKdy5ffWUJbjqxyugC03OyJo4DCYfxscvrSaZBam7YoW8netiuT4uPKGWTT8pz6fF
         ek0NMWOXQYWliJ2mmv0ezw/dQJHm/EQWDuVm4kBEtax+lv6MfjyM0HKOXZWS/KbloTHn
         NEretaif/6dD/htJVwv+G6X0i240pZleO1kKMfbP5pViuRXwUXlRNTrN5K2/c7cqyry8
         0+Ftt8b891T30cA3KYHJ4xJT04dNWtJAI9+ZsZhzDHZQn80laGmMxG3VZxCxl32gL0ou
         ERtA==
X-Gm-Message-State: ANhLgQ2oc6aqEmbPyyzb4bIW1pWh1ccK/dTHJLk5hxGcq3UMvZg+OCHZ
        kEoRXIBKVvPNgee1xaeglZk5RCcr8j1Bwj6lug8=
X-Google-Smtp-Source: ADFU+vvzFwXZwkUfPFvyenDYfCpLXs8aBxMU7CBoL9eL5+OpXsJ8GkHHPAIqTbsH0wSim2TF+aHnCH5ySY3UVRmJk2M=
X-Received: by 2002:a05:620a:a0d:: with SMTP id i13mr1467376qka.333.1583301568862;
 Tue, 03 Mar 2020 21:59:28 -0800 (PST)
MIME-Version: 1.0
References: <20200303005035.13814-1-luke.r.nels@gmail.com> <20200303005035.13814-3-luke.r.nels@gmail.com>
 <CAJ+HfNjgwVnxnyCTk5j+JCpxz+zmeEBYbj=_SueR750aAuoz=A@mail.gmail.com> <CADasFoBODSbgHHXU+iA-32=oKNs6n0Ff_UDU3063uiyGjx1xXg@mail.gmail.com>
In-Reply-To: <CADasFoBODSbgHHXU+iA-32=oKNs6n0Ff_UDU3063uiyGjx1xXg@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 4 Mar 2020 06:59:17 +0100
Message-ID: <CAJ+HfNhOp_Rbcqer0K=mZ8h+uswYSv4hSa3wCTdjjxH26HUTCw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/4] riscv, bpf: add RV32G eBPF JIT
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Luke Nelson <luke.r.nels@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Xi Wang <xi.wang@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Mar 2020 at 03:32, Luke Nelson <lukenels@cs.washington.edu> wrote=
:
>
[...]
>
> > > +    case BPF_LSH:
> > > +        if (imm >=3D 32) {
> > > +            emit(rv_slli(hi(rd), lo(rd), imm - 32), ctx);
> > > +            emit(rv_addi(lo(rd), RV_REG_ZERO, 0), ctx);
> > > +        } else if (imm =3D=3D 0) {
> > > +            /* nop */
> >
> > Can we get rid of this, and just do if/else if?
>
> imm =3D=3D 0 has been a tricky case for 32-bit JITs; see 6fa632e719ee
> ("bpf, x32: Fix bug with ALU64 {LSH, RSH, ARSH} BPF_K shift by 0").
> We wanted to make the imm =3D=3D 0 case explicit and help future readers
> see that this case is handled correctly here.
>
> We could do the following if we really wanted to get rid of the
> check:
>
> if (imm >=3D 32) {
> ...
> } else if (imm !=3D 0) {
> ...
> }
> /* Do nothing for imm =3D=3D 0. */
>
> Though it's unclear if this is easier to read.
>

Thanks for clearing that up. *I* prefer the latter, but that's really
up to you! Keep the current one, if you prefer that! :-)

> > > +    case BPF_ARSH:
> > > +        if (is_12b_int(imm)) {
> > > +            emit(rv_srai(lo(rd), lo(rd), imm), ctx);
> > > +        } else {
> > > +            emit_imm(RV_REG_T0, imm, ctx);
> > > +            emit(rv_sra(lo(rd), lo(rd), RV_REG_T0), ctx);
> > > +        }
> > > +        break;
> >
> > Again nit; I like "early exit" code if possible. Instead of:
> >
> > if (bleh) {
> >    foo();
> > } else {
> >    bar();
> > }
> >
> > do:
> >
> > if (bleh) {
> >    foo()
> >    return/break;
> > }
> > bar();
> >
> > I find the latter easier to read -- but really a nit, and a matter of
> > style. There are number of places where that could be applied in the
> > file.
>
> I like "early exit" code, too, and agree that it's easier to read
> in general, especially when handling error conditions.
>
> But here we wanted to make it explicit that both branches are
> emitting equivalent instruction sequences (under different paths).
> Structured control flow seems a better fit for this particular
> context.
>

Ok!

> > At this point of the series, let's introduce the shared code .c-file
> > containing implementation for bpf_int_jit_compile() (with build_body
> > part of that)and bpf_jit_needs_zext(). That will make it easier to
> > catch bugs in both JITs and to avoid code duplication! Also, when
> > adding the stronger invariant suggested by Palmer [1], we only need to
> > do it in one place.
> >
> > The pull out refactoring can be a separate commit.
>
> I think the idea of deduplicating bpf_int_jit_compile is good and
> will lead to more maintainable JITs. How does the following proposal
> for v5 sound?
>
> In patch 1 of this series:
>
> - Factor structs and common helpers to bpf_jit.h (just like v4).
>
> - Factor out bpf_int_jit_compile(), bpf_jit_needs_zext(), and
> build_body() to a new file bpf_jit_core.c and tweak the code as in v4.
>
> - Rename emit_insn() and build_{prologue,epilogue}() to bpf_jit_emit_insn=
()
> and bpf_jit_build_{prologue,epilogue}, since these functions are
> now extern rather than static.
>
> - Rename bpf_jit_comp.c to bpf_jit_comp64.c to be more explicit
> about its contents (as the next patch will add bpf_jit_comp32.c).
>
> Then patch 2 can reuse the new header and won't need to define its
> own bpf_int_jit_compile() etc.
>

I like that, but keep the first patch as a refactoring patch only, and
then in a *new* patch 2 you add the rv32 specific code (sltu and
pseudo instructions + the xlen preprocessor check + copyright-things
;-)).  Patch 3 will be the old patch 2. Wdyt?

Thanks for working on this!
Bj=C3=B6rn

> Thanks!
>
> Luke
