Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B592C3D81FE
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbhG0Vnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhG0Vnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:43:52 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F2DC061757;
        Tue, 27 Jul 2021 14:43:51 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id k65so372447yba.13;
        Tue, 27 Jul 2021 14:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6u6wypJQeJmb/YfTyzmyqM0UJtBE0z6heRiSyMm9WoU=;
        b=ZwLmxb1TgizpkLWoUujWJlH4yHyMAxPpF7B1gyLjsnAFVyvUuGAl/582R6EQnGqPOQ
         VJYtZ96O+yh4aOftf1fjI0N6eZvizFHokQl/4bkWhB+9rqRhsyGGmpv9G+814ldsINAj
         pyThT4+/GMqmDiOvzi4dFzQIx4EgR8ivUE3Mslc/vublLkMoY06AzGHLtFtp+OpfHEdj
         oVCENJjFGcvOyn5yhHLqjMZF/Ki76bjYjNuy2tR7d871OX0zrCuRjGdkzoTxOUV5fnPa
         +yTGMKCUtkW7tMrZqa5fM9Hxv267csgf/A1SsTF7O/y+Y4YEnKBOBy2fMZcrqzjybtbn
         QKAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6u6wypJQeJmb/YfTyzmyqM0UJtBE0z6heRiSyMm9WoU=;
        b=LM2m3zSBD9SMeY2IGMeapGx2RY+eAYw7JniIflNFA+BhloYPEaZXrtQXDOCSARviid
         y9HOOOYWn/wBUkMm2418fmxF8vSaNGYn/Hv4bzfKIB0Tat1I5Tpb+OtZzLHpXTRTMNfm
         5R7aCYzHq0V2oUAQeaqKHe+S3Ymj8sw+4b7u+IXJwYhnOs9IesTPpOxK4tEIzyCeisZ6
         bPbkqzaaBRBVPnbWBiI7t1NactpHh6qoQRHBxEasOwsFizHhiXvKgFR5DSnwJhpzSeJ+
         f+LRQkwDJiNJCm0eUnMB3vmWJqxuPTz+BhxKKbK9I6gJWte28JluUd7/Gw5CBgfxiYme
         MXhQ==
X-Gm-Message-State: AOAM532hMqMiNhPUjksmsIsZW6lk1eYsivBDsYyyEAGJe9VTmBXLnZf1
        FJ42p7mLY4qdFogPrknPKYYdbqv6mVfahqD7eh8=
X-Google-Smtp-Source: ABdhPJz2rkdMm/N4pD3+cl4Wyi4GGBdI0Z2R9PTOr2miyLr3QrjV5+sF/QXS2PdyG9pr1d9ANZ+DmXR8OPMsHNQSAJs=
X-Received: by 2002:a25:cdc7:: with SMTP id d190mr32876992ybf.425.1627422230617;
 Tue, 27 Jul 2021 14:43:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210727141119.19812-1-pavo.banicevic@sartura.hr>
 <20210727141119.19812-2-pavo.banicevic@sartura.hr> <CAKwvOdkwwXV9rN6bzRs_+hbq5thHNSbEtqwOZ7340a79=NqjSg@mail.gmail.com>
In-Reply-To: <CAKwvOdkwwXV9rN6bzRs_+hbq5thHNSbEtqwOZ7340a79=NqjSg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Jul 2021 14:43:39 -0700
Message-ID: <CAEf4Bza2zZK2m4fmDUXKoURxMmUcfr8gvLR9wxF1vFPBmc2gHA@mail.gmail.com>
Subject: Re: [PATCH 1/3] arm: include: asm: swab: mask rev16 instruction for clang
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Pavo Banicevic <pavo.banicevic@sartura.hr>,
        Arnd Bergmann <arnd@linaro.org>, linux@armlinux.org.uk,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        matt.redfearn@mips.com, Ingo Molnar <mingo@kernel.org>,
        dvlasenk@redhat.com, Juraj Vijtiuk <juraj.vijtiuk@sartura.hr>,
        robert.marko@sartura.hr, Luka Perkov <luka.perkov@sartura.hr>,
        Jakov Petrina <jakov.petrina@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 10:53 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Tue, Jul 27, 2021 at 7:12 AM Pavo Banicevic
> <pavo.banicevic@sartura.hr> wrote:
> >
> > From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> >
> > The samples/bpf with clang -emit-llvm reuses linux headers to build
> > bpf samples, and this w/a only for samples (samples/bpf/Makefile
> > CLANG-bpf).
> >
> > It allows to build samples/bpf for arm bpf using clang.
> > In another way clang -emit-llvm generates errors like:
> >
> > CLANG-bpf  samples/bpf/tc_l2_redirect_kern.o
> > <inline asm>:1:2: error: invalid register/token name
> > rev16 r3, r0
> >
> > This decision is arguable, probably there is another way, but
> > it doesn't have impact on samples/bpf, so it's easier just ignore
> > it for clang, at least for now.
>
> NACK
>
> The way to fix these is to sort out the header includes, not turning
> off arbitrary things that are used by the actual kernel build for 32b
> ARM.

Would it be too horrible to just get rid of `clang -emit-llvm` and use
vmlinux.h (we don't need to do CO-RE, btw, just generate vmlinux.h
from the matching kernel)? Kumar has already started moving in that
direction in his recent patch set ([0]). Would that get rid of all
these issues?

  [0] https://patchwork.kernel.org/project/netdevbpf/list/?series=519281&state=*


>
> >
> > Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> > ---
> >  arch/arm/include/asm/swab.h | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/arm/include/asm/swab.h b/arch/arm/include/asm/swab.h
> > index c6051823048b..a9fd9cd33d5e 100644
> > --- a/arch/arm/include/asm/swab.h
> > +++ b/arch/arm/include/asm/swab.h
> > @@ -25,8 +25,11 @@ static inline __attribute_const__ __u32 __arch_swahb32(__u32 x)
> >         __asm__ ("rev16 %0, %1" : "=r" (x) : "r" (x));
> >         return x;
> >  }
> > +
> > +#ifndef __clang__
> >  #define __arch_swahb32 __arch_swahb32
> >  #define __arch_swab16(x) ((__u16)__arch_swahb32(x))
> > +#endif
> >
> >  static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
> >  {
> > --
> > 2.32.0
> >
>
>
> --
> Thanks,
> ~Nick Desaulniers
