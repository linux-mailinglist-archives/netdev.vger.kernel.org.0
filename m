Return-Path: <netdev+bounces-11585-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA035733A6D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:07:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6445E28188C
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FF991F92C;
	Fri, 16 Jun 2023 20:05:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367451ACDB;
	Fri, 16 Jun 2023 20:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A6EC433CB;
	Fri, 16 Jun 2023 20:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686945943;
	bh=WtL681uu0xgDuNDCtnoYcQSLjySma9uSe62fWHoJUhA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=f6jdPi0vbCVqLqgQDDmD+GO6OBfmTAAnNSnv31ejf0X579gkscpmfn1bTrsu+q2ra
	 40XK5tgjD4Pn3DEwgEMNXaNpAJoNV7jL4P4r8shZe9dBhyksUMC8rwkwFkvZkFVkCR
	 IGp3JmtLPxLnrzx47G+lStd1hKB4UgLYKewi3Ki/K5woVsZktBsRAZ2Di1MUFiXRWn
	 1YkJryPbn+hll4loxeYSz5PcOp11n7V/droF7ZpB0pqIuzSutJSGr0pq7VRjU9BgpD
	 r54x5CfpgaRK4fVGltSX9D3VAd0D4uJxrcV171/lcN7V+Y7pDOa0WYzp0o27UZTPXi
	 Y80FFy3waZkgA==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-4f6370ddd27so1591514e87.0;
        Fri, 16 Jun 2023 13:05:43 -0700 (PDT)
X-Gm-Message-State: AC+VfDxll20kBKAOmJdD0scrWKrC23RJCkpcNBQmT+5Y0lM5YvEt4xiF
	Yi07xqmhGlL0o1XKTyDs8ix+PLGFK2YzBE+q8Dw=
X-Google-Smtp-Source: ACHHUZ7v0OG7lj710Dpkky2x3Qwl+xOOMZ2WmKSKGrGJ24Aq4/yPm9YniFAuyGWs2DWPlG6NvD65kdAaVeIKyOd6PQ8=
X-Received: by 2002:a19:644e:0:b0:4e9:9e45:3470 with SMTP id
 b14-20020a19644e000000b004e99e453470mr2381818lfj.3.1686945941704; Fri, 16 Jun
 2023 13:05:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230616085038.4121892-1-rppt@kernel.org> <20230616085038.4121892-8-rppt@kernel.org>
In-Reply-To: <20230616085038.4121892-8-rppt@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 16 Jun 2023 13:05:29 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6BG2oVrGDOpCKyOEvU9fBOboYYhducv96KUBe276Mvng@mail.gmail.com>
Message-ID: <CAPhsuW6BG2oVrGDOpCKyOEvU9fBOboYYhducv96KUBe276Mvng@mail.gmail.com>
Subject: Re: [PATCH v2 07/12] arm64, execmem: extend execmem_params for
 generated code definitions
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	"David S. Miller" <davem@davemloft.net>, Dinh Nguyen <dinguyen@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Luis Chamberlain <mcgrof@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nadav Amit <nadav.amit@gmail.com>, "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Puranjay Mohan <puranjay12@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Russell King <linux@armlinux.org.uk>, 
	Steven Rostedt <rostedt@goodmis.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>, bpf@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-mm@kvack.org, linux-modules@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, 
	netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 16, 2023 at 1:52=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> From: "Mike Rapoport (IBM)" <rppt@kernel.org>
>
> The memory allocations for kprobes on arm64 can be placed anywhere in
> vmalloc address space and currently this is implemented with an override
> of alloc_insn_page() in arm64.
>
> Extend execmem_params with a range for generated code allocations and
> make kprobes on arm64 use this extension rather than override
> alloc_insn_page().
>
> Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
> ---
>  arch/arm64/kernel/module.c         |  9 +++++++++
>  arch/arm64/kernel/probes/kprobes.c |  7 -------
>  include/linux/execmem.h            | 11 +++++++++++
>  mm/execmem.c                       | 14 +++++++++++++-
>  4 files changed, 33 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
> index c3d999f3a3dd..52b09626bc0f 100644
> --- a/arch/arm64/kernel/module.c
> +++ b/arch/arm64/kernel/module.c
> @@ -30,6 +30,13 @@ static struct execmem_params execmem_params =3D {
>                         .alignment =3D MODULE_ALIGN,
>                 },
>         },
> +       .jit =3D {
> +               .text =3D {
> +                       .start =3D VMALLOC_START,
> +                       .end =3D VMALLOC_END,
> +                       .alignment =3D 1,
> +               },
> +       },
>  };

This is growing fast. :) We have 3 now: text, data, jit. And it will be
5 when we split data into rw data, ro data, ro after init data. I wonder
whether we should still do some type enum here. But we can revisit
this topic later.

Other than that

Acked-by: Song Liu <song@kernel.org>

