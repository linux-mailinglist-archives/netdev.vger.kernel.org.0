Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8DCC1520DA
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 20:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgBDTNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 14:13:30 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36328 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbgBDTNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 14:13:30 -0500
Received: by mail-qk1-f194.google.com with SMTP id w25so19138475qki.3;
        Tue, 04 Feb 2020 11:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bdX909F5cI382fCwL2BmbcR0X3LXro/I1upGDSYHuzo=;
        b=af9b04eiFve+KyP+LhZf60HCVL8lPPYPwQ3FEmqeZfugnYDSuPcWsvjoIrXPo6YCva
         Sc1FERU+4ZaaJsFfjiA+Ilwn0S5M+WFGlLJYvVeb3SEJ91x2vP63V+QrjbzKaZ7E0Lvs
         QYcF+eLurguVf0WwaTyU99Y9wxY/l/BcQhknatNYVhyeIGROiRm+pSTnMqL7puw8leTx
         YHFXfMcvNO7MNPf2hmS9+TQ1OLDH3/FYxrZWfKKNdej+Bjmyi3nYUvRsQrf5jf4/i9RI
         oHbybLHDDO4NXvJzLAlQulpZD6bxgLg2iOA6Rg9/FtpCBh34ZJ4fUOiUP+PAf/YXIMmn
         cVJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bdX909F5cI382fCwL2BmbcR0X3LXro/I1upGDSYHuzo=;
        b=ceqX/Ho2o3GpMXx6jY+g1mEVCxu6TtkGQXEPlpOTdu9A2UXQUbOhqcLp2JP+2ZPtYF
         uBs3hSjMrqPCbVpcVZ+yCJ3cjmNOLFnRv50j+8/mM3bXQuhC4RVS7RqVmZaKI8XT8qOJ
         IBZ6zPQHlLXAqWN0vjhJuOJiBzH8fBclSsCN/Dk1xF0E0Jv62opeJVBd5HVZviR7ZHvN
         Q62fQdYueKub0dQJC7+pAFQya8addXpaMRuQfNkj8+kA48DAnWl41eirBmIbXBEmnh9R
         Gm4DTCnhrnByd3xpfEkus+vLVzHrIfjAOjR1c4hUJlcep2YbaoKfEDrUlgXq9uy4god8
         sQrQ==
X-Gm-Message-State: APjAAAUnFo08sLklh9XQJ8y5zNX3+UTzUuERki4uwf2dehkCfYpe4W3u
        JNjMnjb2L3uUVjH83xGYDtb8q9SIPqvG1Fsfvpc=
X-Google-Smtp-Source: APXvYqzL2qBK84KG5kdgM/FLguBsVyHKuNA+SYxiM1gbwqv39K/jDfeV7q5nmkTTa6/okXiRZyHcbl5ya+Yw7DY8LmY=
X-Received: by 2002:a37:63c7:: with SMTP id x190mr30030638qkb.232.1580843609003;
 Tue, 04 Feb 2020 11:13:29 -0800 (PST)
MIME-Version: 1.0
References: <20200128021145.36774-1-palmerdabbelt@google.com> <20200128021145.36774-5-palmerdabbelt@google.com>
In-Reply-To: <20200128021145.36774-5-palmerdabbelt@google.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 4 Feb 2020 20:13:17 +0100
Message-ID: <CAJ+HfNjkacY-KStgGJMgvQh2=2OsMnH6Saij+nAPBqQrSJcNWw@mail.gmail.com>
Subject: Re: [PATCH 4/4] arm64: bpf: Elide some moves to a0 after calls
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, zlim.lnx@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Shuah Khan <shuah@kernel.org>, Netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jan 2020 at 03:15, Palmer Dabbelt <palmerdabbelt@google.com> wro=
te:
>
> On arm64, the BPF function ABI doesn't match the C function ABI.  Specifi=
cally,
> arm64 encodes calls as `a0 =3D f(a0, a1, ...)` while BPF encodes calls as
> `BPF_REG_0 =3D f(BPF_REG_1, BPF_REG_2, ...)`.  This discrepancy results i=
n
> function calls being encoded as a two operations sequence that first does=
 a C
> ABI calls and then moves the return register into the right place.  This
> results in one extra instruction for every function call.
>

It's a lot of extra work for one reg-to-reg move, but it always
annoyed me in the RISC-V JIT. :-) So, if it *can* be avoided, why not.

[...]
>
> +static int dead_register(const struct jit_ctx *ctx, int offset, int bpf_=
reg)

Given that a lot of archs (RISC-V, arm?, MIPS?) might benefit from
this, it would be nice if it could be made generic (it already is
pretty much), and moved to kernel/bpf.

> +{
> +       const struct bpf_prog *prog =3D ctx->prog;
> +       int i;
> +
> +       for (i =3D offset; i < prog->len; ++i) {
> +               const struct bpf_insn *insn =3D &prog->insnsi[i];
> +               const u8 code =3D insn->code;
> +               const u8 bpf_dst =3D insn->dst_reg;
> +               const u8 bpf_src =3D insn->src_reg;
> +               const int writes_dst =3D !((code & BPF_ST) || (code & BPF=
_STX)
> +                                        || (code & BPF_JMP32) || (code &=
 BPF_JMP));
> +               const int reads_dst  =3D !((code & BPF_LD));
> +               const int reads_src  =3D true;
> +
> +               /* Calls are a bit special in that they clobber a bunch o=
f regisers. */
> +               if ((code & (BPF_JMP | BPF_CALL)) || (code & (BPF_JMP | B=
PF_TAIL_CALL)))
> +                       if ((bpf_reg >=3D BPF_REG_0) && (bpf_reg <=3D BPF=
_REG_5))
> +                               return false;
> +
> +               /* Registers that are read before they're written are ali=
ve.
> +                * Most opcodes are of the form DST =3D DEST op SRC, but =
there
> +                * are some exceptions.*/
> +               if (bpf_src =3D=3D bpf_reg && reads_src)
> +                       return false;
> +
> +               if (bpf_dst =3D=3D bpf_reg && reads_dst)
> +                       return false;
> +
> +               if (bpf_dst =3D=3D bpf_reg && writes_dst)
> +                       return true;
> +
> +               /* Most BPF instructions are 8 bits long, but some ar 16 =
bits
> +                * long. */

A bunch of spelling errors above.


Cheers,
Bj=C3=B6rn
