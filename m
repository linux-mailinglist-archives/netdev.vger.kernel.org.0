Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC769178855
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 03:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387523AbgCDCcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 21:32:36 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:46083 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387406AbgCDCcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 21:32:36 -0500
Received: by mail-il1-f193.google.com with SMTP id e8so480175ilc.13
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 18:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=n6mkcIQ2CwC1xTtJxH74NN6vQdrLEAX1li3E8fEudI8=;
        b=M5O7QedO8LmdTilKXhgDjj6pJDYijzuilBu5xyes4ICn+hClPJbwMCqeC/K5g1bE2g
         egpjdAJsAJmqcxtp4gn85lwUEg+JAOGc94aItnA3aqKydSvbr6rdf4OOqrfi7+KA5TI3
         F0k1koSGJkFlWVrglQhyYi1JSodyDP31qeDsw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=n6mkcIQ2CwC1xTtJxH74NN6vQdrLEAX1li3E8fEudI8=;
        b=SmlDdH3xj2hvBGhTvVu5Nv5yVvJXRx3dn5T7NkOo8dSO7tCVfJ40T0bMyDd4o7SKoP
         +J2MRsY+3stSQrAl0IZDXBc+n70d2Q8xPNt1CuAyHq6sntH3I5jfhYAQ7SQj96EZPYsB
         16qwQVTvNtJm+J6e9PCzmfE6rtHu7bczP+hAwfBh1O5OfHI6P+W+CAH6agn7IULqPvbq
         PJeKwX6b5PwW2vKMKwXmeBg2DBr8XdnB6Kz1ALRMjAzR8hnBITVYs+2AUI/eekIEWX0N
         zvk0k2/0gmq9MRAaLXeOrYJet6nUYXWybwh4j0uNefP1R7pL5LF5Awg+eOrusrxE8krg
         60Cg==
X-Gm-Message-State: ANhLgQ1VM5hfvR8TcugLMt6gjua/U8yH91Cxzl9vT6QP1GPOEUT2ySpN
        g80wuq5MxqXpEhS6U5PygJ5y8xMAMbsfnjme2x4wj3YGXHa4oA==
X-Google-Smtp-Source: ADFU+vtZz9bK0eR23Fqfg2Flo7dTRJq/q3oOn/yBVOdWo5FSor2dKOCN3ztfEmpM0Yd68erGscs4Sdi+qrx0Fsa208s=
X-Received: by 2002:a05:6e02:4c2:: with SMTP id f2mr687631ils.126.1583289154825;
 Tue, 03 Mar 2020 18:32:34 -0800 (PST)
MIME-Version: 1.0
References: <20200303005035.13814-1-luke.r.nels@gmail.com> <20200303005035.13814-3-luke.r.nels@gmail.com>
 <CAJ+HfNjgwVnxnyCTk5j+JCpxz+zmeEBYbj=_SueR750aAuoz=A@mail.gmail.com>
In-Reply-To: <CAJ+HfNjgwVnxnyCTk5j+JCpxz+zmeEBYbj=_SueR750aAuoz=A@mail.gmail.com>
From:   Luke Nelson <lukenels@cs.washington.edu>
Date:   Tue, 3 Mar 2020 18:32:24 -0800
Message-ID: <CADasFoBODSbgHHXU+iA-32=oKNs6n0Ff_UDU3063uiyGjx1xXg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/4] riscv, bpf: add RV32G eBPF JIT
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
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

Hi Bj=C3=B6rn,

Thanks again for the comments, responses below:

On Mon, Mar 2, 2020 at 11:48 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> Which are the tests that fail to JIT, and is that due to div/mod +
> xadd?

Yes, all of the cases that fail to JIT are because of unsupported
div/mod or xadd. I'll make that clear in next revision.

>
> > Co-developed-by: Xi Wang <xi.wang@gmail.com>
> > Signed-off-by: Xi Wang <xi.wang@gmail.com>
> > Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
> > ---
> >  arch/riscv/Kconfig              |    2 +-
> >  arch/riscv/net/Makefile         |    7 +-
> >  arch/riscv/net/bpf_jit_comp32.c | 1466 +++++++++++++++++++++++++++++++
> >  3 files changed, 1473 insertions(+), 2 deletions(-)
> >  create mode 100644 arch/riscv/net/bpf_jit_comp32.c
> [...]
> > +
> > +static const s8 *rv32_bpf_get_reg64(const s8 *reg, const s8 *tmp,
> > +                    struct rv_jit_context *ctx)
>
> Really a nit, but you're using rv32 as prefix, and also as part of
> many of the functions (e.g. emit_rv32). Everything is this file is
> just for RV32, so maybe remove that implicit information from the
> function name? Just a thought! :-)

I got so used to reading these I never noticed how redundant they
were :) I'll change the next revision to remove all of the "rv32"s
in function names.

> > +    case BPF_LSH:
> > +        if (imm >=3D 32) {
> > +            emit(rv_slli(hi(rd), lo(rd), imm - 32), ctx);
> > +            emit(rv_addi(lo(rd), RV_REG_ZERO, 0), ctx);
> > +        } else if (imm =3D=3D 0) {
> > +            /* nop */
>
> Can we get rid of this, and just do if/else if?

imm =3D=3D 0 has been a tricky case for 32-bit JITs; see 6fa632e719ee
("bpf, x32: Fix bug with ALU64 {LSH, RSH, ARSH} BPF_K shift by 0").
We wanted to make the imm =3D=3D 0 case explicit and help future readers
see that this case is handled correctly here.

We could do the following if we really wanted to get rid of the
check:

if (imm >=3D 32) {
...
} else if (imm !=3D 0) {
...
}
/* Do nothing for imm =3D=3D 0. */

Though it's unclear if this is easier to read.

> > +    case BPF_ARSH:
> > +        if (is_12b_int(imm)) {
> > +            emit(rv_srai(lo(rd), lo(rd), imm), ctx);
> > +        } else {
> > +            emit_imm(RV_REG_T0, imm, ctx);
> > +            emit(rv_sra(lo(rd), lo(rd), RV_REG_T0), ctx);
> > +        }
> > +        break;
>
> Again nit; I like "early exit" code if possible. Instead of:
>
> if (bleh) {
>    foo();
> } else {
>    bar();
> }
>
> do:
>
> if (bleh) {
>    foo()
>    return/break;
> }
> bar();
>
> I find the latter easier to read -- but really a nit, and a matter of
> style. There are number of places where that could be applied in the
> file.

I like "early exit" code, too, and agree that it's easier to read
in general, especially when handling error conditions.

But here we wanted to make it explicit that both branches are
emitting equivalent instruction sequences (under different paths).
Structured control flow seems a better fit for this particular
context.

> At this point of the series, let's introduce the shared code .c-file
> containing implementation for bpf_int_jit_compile() (with build_body
> part of that)and bpf_jit_needs_zext(). That will make it easier to
> catch bugs in both JITs and to avoid code duplication! Also, when
> adding the stronger invariant suggested by Palmer [1], we only need to
> do it in one place.
>
> The pull out refactoring can be a separate commit.

I think the idea of deduplicating bpf_int_jit_compile is good and
will lead to more maintainable JITs. How does the following proposal
for v5 sound?

In patch 1 of this series:

- Factor structs and common helpers to bpf_jit.h (just like v4).

- Factor out bpf_int_jit_compile(), bpf_jit_needs_zext(), and
build_body() to a new file bpf_jit_core.c and tweak the code as in v4.

- Rename emit_insn() and build_{prologue,epilogue}() to bpf_jit_emit_insn()
and bpf_jit_build_{prologue,epilogue}, since these functions are
now extern rather than static.

- Rename bpf_jit_comp.c to bpf_jit_comp64.c to be more explicit
about its contents (as the next patch will add bpf_jit_comp32.c).

Then patch 2 can reuse the new header and won't need to define its
own bpf_int_jit_compile() etc.

Thanks!

Luke
