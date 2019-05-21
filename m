Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946BF2519C
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 16:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbfEUOMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 10:12:25 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39054 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfEUOMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 10:12:25 -0400
Received: by mail-qt1-f195.google.com with SMTP id y42so20637948qtk.6;
        Tue, 21 May 2019 07:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rVA8ZXa5QV70YbDkp9YT649xx7f+jYEVyeJZQPdGZGI=;
        b=KNYz8G8G4wqF9SLMz5UEP4uBbsSM4rUp4hWf01LMjBMjO2XIE07a1flfbw9ui96ly8
         58EKW9x2wtdWP9Jf0OPZc8As/B2RAQbV16WAysvvHzT/hYgDAeEXFS6gD1PHiu2mYfr9
         NP6/my/3g03VULmDbVry/uyE6MT6RpMM9t9zzXsnvR05KUXKzg7yuSC0QJQmPiRmBer9
         JNcPgwCmd8lAHCAk8Fy+7E57SpB3Bp2mPBL46WB0IZjE4L5EUR15uFM7S525EtWCcuOW
         2lgE14Ns+nQPOAQqiA1O9jf2LO/Jnv2QAgLnp/eKdZMo1QrqboWuj+C25IsYp/th3bWh
         mU3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rVA8ZXa5QV70YbDkp9YT649xx7f+jYEVyeJZQPdGZGI=;
        b=NRW0S4B9VVihy9yBhzlY9geLMzjrRxYINLxQDsOkDsMWVOePwFzXqmAUcTP0zjuNue
         JakY40kFI053e+Dlo85CNMVhvcnI5VNgZs7uZelt1cRBV1FFP46ezwJJH8PcHJEsvk5Y
         LVmHafgx8Wagj1yJY8hggCxS3xaJk0Cm1bO420pAmgpX7j7DAVQYd6NwuwAUqHHDiQbH
         tmiMqbXIoiJqGPFFukx0kg75wqkWMRDUAu2iFAcf6MeHh6H9YwVU7kJoDxQIgiV006Iy
         3HW4l9FCYpT978krDJ+rWhqZD73XAYo/5JUjcaVz4X5JaYla3rvsyG1OdccVzmpCkUxT
         YQNQ==
X-Gm-Message-State: APjAAAU2zswgd46uDgHeNpheHbA6A5fZHuQpUtBVBpB6dT1/uWS3z3Sy
        7r/VZfflTmG/d36cRWyigxG8Pb+Im62e29ySekQ1Oq1SFJ0=
X-Google-Smtp-Source: APXvYqwHkfhO09nfqXTpuVxldFIRdO0RMLVbZeU5cizeLi02ooz5wI8k00zFMkwUb/epZfzKv3dSc4oCnb7Il6LCIF0=
X-Received: by 2002:a0c:8931:: with SMTP id 46mr39016420qvp.3.1558447944471;
 Tue, 21 May 2019 07:12:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190521134622.18358-1-bjorn.topel@gmail.com> <49999b2d-f025-894a-be61-a52d13b24678@iogearbox.net>
In-Reply-To: <49999b2d-f025-894a-be61-a52d13b24678@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 21 May 2019 16:12:12 +0200
Message-ID: <CAJ+HfNifkxKz8df7gLBuqWA6+t6awrrRK6oW6m1nAYETJD+Vfg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf, riscv: clear target register high 32-bits for
 and/or/xor on ALU32
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        bpf <bpf@vger.kernel.org>, Jiong Wang <jiong.wang@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 May 2019 at 16:02, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 05/21/2019 03:46 PM, Bj=C3=B6rn T=C3=B6pel wrote:
> > When using 32-bit subregisters (ALU32), the RISC-V JIT would not clear
> > the high 32-bits of the target register and therefore generate
> > incorrect code.
> >
> > E.g., in the following code:
> >
> >   $ cat test.c
> >   unsigned int f(unsigned long long a,
> >              unsigned int b)
> >   {
> >       return (unsigned int)a & b;
> >   }
> >
> >   $ clang-9 -target bpf -O2 -emit-llvm -S test.c -o - | \
> >       llc-9 -mattr=3D+alu32 -mcpu=3Dv3
> >       .text
> >       .file   "test.c"
> >       .globl  f
> >       .p2align        3
> >       .type   f,@function
> >   f:
> >       r0 =3D r1
> >       w0 &=3D w2
> >       exit
> >   .Lfunc_end0:
> >       .size   f, .Lfunc_end0-f
> >
> > The JIT would not clear the high 32-bits of r0 after the
> > and-operation, which in this case might give an incorrect return
> > value.
> >
> > After this patch, that is not the case, and the upper 32-bits are
> > cleared.
> >
> > Reported-by: Jiong Wang <jiong.wang@netronome.com>
> > Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
>
> Was this missed because test_verifier did not have test coverage?

Yup, and Jiong noted it.

> If so, could you follow-up with alu32 test cases for it, so other
> JITs can be tracked for these kind of issue as well. We should
> probably have one for every alu32 alu op to make sure it's not
> forgotten anywhere.
>

I'll hack a test_verifier test right away.

Thanks,
Bj=C3=B6rn


> Thanks,
> Daniel
