Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78D7317706C
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 08:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbgCCHul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 02:50:41 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35598 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727552AbgCCHuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 02:50:40 -0500
Received: by mail-qk1-f195.google.com with SMTP id 145so2518325qkl.2;
        Mon, 02 Mar 2020 23:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BhbULqBIdorw/yrEs1cpQIXkzYiAMwapHjsDli7SNmE=;
        b=C/AVVaOwRUMOQcM2QkfZkYxtY1XRUW6kdvKrulJevxuG6/m6BCkwSOmh1vkwJEattR
         K2cO/soZ0G4mS1yCz5uEbc8M6tRfZ8hDc/4UgnsLxewUBVG7PW1mtlJmH4yuqpWG2HFL
         0BOR7EE0z6q/Rn2e6tG3jiuBmPno7lfidiNSVBrakQFDxRCFkjk+vUYldkXeS6Wq7El7
         YtONSsi4xMbYIPuq9dTkIRO+aqy/6IJrFYDlKGUOzk2CK7AbniZJYRILqKFV5chwLdJC
         /UhsBX5zUY7GtsKdUX3dfz+Frx7mfxgW4Y5BCoUzACYteQqmkg+82P8OkYuBUbuCv/N5
         g2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BhbULqBIdorw/yrEs1cpQIXkzYiAMwapHjsDli7SNmE=;
        b=UlKeKfjl8/Hv0Q88eFqU9cN/p63zyRK1yl7npoPcRYJI0/vJOVsQd4MLAsK4Y5DquV
         A/DV4A1ZMknEa9+nbjvMfdxw7GfiOFbwNrPO2rlKmHLtkesnVbYzpb5Ckck7qTqx4FLF
         gulI2VCc5dU6nMeabfzOFu5NbU0inv38gdX7ORF6sIarh/D8nDFVZEC3Dd60MH3ggaKc
         2W9vA5RdxCUzrIZX5A7pheOouhRy6dH0rRY7dmfkcaMQsNZ1aJs9Od//aU+D8NGhOisc
         8IjhHBmuMmXU1DsYECLEwXi3nRjX1ipzYdNzE6hgPtriSWE8iZtjHi6Z/sS7/i+hOzWy
         zqsA==
X-Gm-Message-State: ANhLgQ3HrFGIS/A7cVgQOuonp6PjKAIOWF9v5OXJVcZdMyrJP9zetjfk
        qUdbSPooiv3RbH8XH+CrTg6VJnSlp9yERI6pM8c=
X-Google-Smtp-Source: ADFU+vvnqa4SHi+3vaAmK9vIruVCzKAjusAJShsWdCzHBDnIgJIuzP96vxeO5VLCbYsVUfv798aIL4vqMNwbrS/cGx4=
X-Received: by 2002:a37:8046:: with SMTP id b67mr2937683qkd.218.1583221839180;
 Mon, 02 Mar 2020 23:50:39 -0800 (PST)
MIME-Version: 1.0
References: <20200303005035.13814-1-luke.r.nels@gmail.com> <20200303005035.13814-2-luke.r.nels@gmail.com>
In-Reply-To: <20200303005035.13814-2-luke.r.nels@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 3 Mar 2020 08:50:28 +0100
Message-ID: <CAJ+HfNhSj9ycgh8Y44b_ZruW1A=+W_53fXnCDc488WXSESJ3dw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/4] riscv, bpf: move common riscv JIT code to header
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

On Tue, 3 Mar 2020 at 01:50, Luke Nelson <lukenels@cs.washington.edu> wrote=
:
>
> This patch factors out code that can be used by both the RV64 and RV32
> JITs to a common header.
>
> Rename rv_sb_insn/rv_uj_insn to rv_b_insn/rv_j_insn to match the RISC-V
> specification.
>

Thanks for clearing this up!

> Co-developed-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
> ---
> We could put more code into a shared .c file in the future (e.g.,
> build_body).  It seems to make sense right now to first factor
> common data structures and helper functions into a header.

Yes, I agree.

> ---
>  arch/riscv/net/bpf_jit.h      | 504 ++++++++++++++++++++++++++++++++++
>  arch/riscv/net/bpf_jit_comp.c | 443 +-----------------------------
>  2 files changed, 505 insertions(+), 442 deletions(-)
>  create mode 100644 arch/riscv/net/bpf_jit.h
>
> diff --git a/arch/riscv/net/bpf_jit.h b/arch/riscv/net/bpf_jit.h
> new file mode 100644
> index 000000000000..6f45f95bc4d0
> --- /dev/null
> +++ b/arch/riscv/net/bpf_jit.h
> @@ -0,0 +1,504 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Common functionality for RV32 and RV64 BPF JIT compilers
> + *
> + * Copyright (c) 2019 Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> + * Copyright (c) 2020 Luke Nelson <luke.r.nels@gmail.com>
> + * Copyright (c) 2020 Xi Wang <xi.wang@gmail.com>

I'm no lawyer, so this is more of a question; You've pulled out code
into a header, and renamed two functions. Does that warrant copyright
line additions? Should my line be removed?

> + */
> +
> +#ifndef _BPF_JIT_H
> +#define _BPF_JIT_H
> +
> +#include <linux/bpf.h>
> +#include <linux/filter.h>
> +#include <asm/cacheflush.h>
[...]
> +
> +static inline u32 rv_amoadd_w(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
> +{
> +    return rv_amo_insn(0, aq, rl, rs2, rs1, 2, rd, 0x2f);
> +}
> +
> +#if __riscv_xlen =3D=3D 64

Please remove this. If the inlined functions are not used, they're not
part of the binary. This adds complexity to the code, and without it
we can catch build errors early on!

> +
> +/* RV64-only instructions. */
> +
[...]
> +{
> +    return rv_amo_insn(0, aq, rl, rs2, rs1, 3, rd, 0x2f);
> +}
> +
> +#endif /* __riscv_xlen =3D=3D 64 */

...and this.

Thanks!
Bj=C3=B6rn
