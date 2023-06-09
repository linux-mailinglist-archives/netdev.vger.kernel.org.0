Return-Path: <netdev+bounces-9628-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7038372A0D4
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:02:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0A921C21149
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4FF81C743;
	Fri,  9 Jun 2023 17:02:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C221B904;
	Fri,  9 Jun 2023 17:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C774BC433A1;
	Fri,  9 Jun 2023 17:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686330151;
	bh=vxAb82+vAl+BH98Z/zX2UFkfYunrykLKznTO4Bf32/o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mi+1/ju1etiB6d0wiW4caAjQqZLe00FeV1NkWgT7OHTC7YXhbWrImPhkjcdfLthep
	 R4NctZPvMcT6YU1NN0hlAPJu7mKlMOhF8XW1w/JUcKEX6IymvTValQ7iJLgbthe+rr
	 JB0Y/WdslTbhCTkFmElAt6A2q9AjkZ65JlkLpT6RWSVvoxHuctv3jAm4tkLSY6DnGo
	 sjANix/3DDuGcfUiGq4bVWyWyi4Aib0wLcEVEjV2uGWiQih+ufGfWA3fM021KKgeWY
	 Dt91VQ5xBfF0lTdjr2IkoyUEOPUU+/xMsQaC1Ua+lm/Kg5AHwmxvY3mxjDI1kZZXq8
	 eusqU7U1U5lpg==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-4f644dffd71so2619959e87.1;
        Fri, 09 Jun 2023 10:02:31 -0700 (PDT)
X-Gm-Message-State: AC+VfDx+c0l4S1qiuEKAlyt/LCqcUkiHM3tSjSq0oVFlun3511lj+UTt
	ZK2TksPRMtOFMcLNOK/fpzzBuN4Bs/Joh/DUnuY=
X-Google-Smtp-Source: ACHHUZ4u3y79XyQLMHF4er59h6QhhYai8KonYYOOA8YDDos4NgFbnLZdqPfEIRGQCpyydTzD04kcj6u0lkxU6y+OWW4=
X-Received: by 2002:a2e:9891:0:b0:2b1:e5d8:d008 with SMTP id
 b17-20020a2e9891000000b002b1e5d8d008mr1338098ljj.37.1686330149805; Fri, 09
 Jun 2023 10:02:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601101257.530867-1-rppt@kernel.org> <ZHjDU/mxE+cugpLj@FVFF77S0Q05N.cambridge.arm.com>
 <ZHjgIH3aX9dCvVZc@moria.home.lan> <ZHm3zUUbwqlsZBBF@FVFF77S0Q05N>
 <20230605092040.GB3460@kernel.org> <ZH20XkD74prrdN4u@FVFF77S0Q05N>
 <CAPhsuW7ntn_HpVWdGK_hYVd3zsPEFToBNfmtt0m6K8SwfxJ66Q@mail.gmail.com> <20230608184116.GJ52412@kernel.org>
In-Reply-To: <20230608184116.GJ52412@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 9 Jun 2023 10:02:16 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5YYa6nQhO2=zor75XkdKpFysZD42DgDRkKZvQT6aMqcA@mail.gmail.com>
Message-ID: <CAPhsuW5YYa6nQhO2=zor75XkdKpFysZD42DgDRkKZvQT6aMqcA@mail.gmail.com>
Subject: Re: [PATCH 00/13] mm: jit/text allocator
To: Mike Rapoport <rppt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	"David S. Miller" <davem@davemloft.net>, Dinh Nguyen <dinguyen@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Russell King <linux@armlinux.org.uk>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Thomas Gleixner <tglx@linutronix.de>, 
	Will Deacon <will@kernel.org>, bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, linux-modules@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, 
	netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 8, 2023 at 11:41=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Tue, Jun 06, 2023 at 11:21:59AM -0700, Song Liu wrote:
> > On Mon, Jun 5, 2023 at 3:09=E2=80=AFAM Mark Rutland <mark.rutland@arm.c=
om> wrote:
> >
> > [...]
> >
> > > > > > Can you give more detail on what parameters you need? If the on=
ly extra
> > > > > > parameter is just "does this allocation need to live close to k=
ernel
> > > > > > text", that's not that big of a deal.
> > > > >
> > > > > My thinking was that we at least need the start + end for each ca=
ller. That
> > > > > might be it, tbh.
> > > >
> > > > Do you mean that modules will have something like
> > > >
> > > >       jit_text_alloc(size, MODULES_START, MODULES_END);
> > > >
> > > > and kprobes will have
> > > >
> > > >       jit_text_alloc(size, KPROBES_START, KPROBES_END);
> > > > ?
> > >
> > > Yes.
> >
> > How about we start with two APIs:
> >      jit_text_alloc(size);
> >      jit_text_alloc_range(size, start, end);
> >
> > AFAICT, arm64 is the only arch that requires the latter API. And TBH, I=
 am
> > not quite convinced it is needed.
>
> Right now arm64 and riscv override bpf and kprobes allocations to use the
> entire vmalloc address space, but having the ability to allocate generate=
d
> code outside of modules area may be useful for other architectures.
>
> Still the start + end for the callers feels backwards to me because the
> callers do not define the ranges, but rather the architectures, so we sti=
ll
> need a way for architectures to define how they want allocate memory for
> the generated code.

Yeah, this makes sense.

>
> > > > It sill can be achieved with a single jit_alloc_arch_params(), just=
 by
> > > > adding enum jit_type parameter to jit_text_alloc().
> > >
> > > That feels backwards to me; it centralizes a bunch of information abo=
ut
> > > distinct users to be able to shove that into a static array, when the=
 callsites
> > > can pass that information.
> >
> > I think we only two type of users: module and everything else (ftrace, =
kprobe,
> > bpf stuff). The key differences are:
> >
> >   1. module uses text and data; while everything else only uses text.
> >   2. module code is generated by the compiler, and thus has stronger
> >   requirements in address ranges; everything else are generated via som=
e
> >   JIT or manual written assembly, so they are more flexible with addres=
s
> >   ranges (in JIT, we can avoid using instructions that requires a speci=
fic
> >   address range).
> >
> > The next question is, can we have the two types of users share the same
> > address ranges? If not, we can reserve the preferred range for modules,
> > and let everything else use the other range. I don't see reasons to fur=
ther
> > separate users in the "everything else" group.
>
> I agree that we can define only two types: modules and everything else an=
d
> let the architectures define if they need different ranges for these two
> types, or want the same range for everything.
>
> With only two types we can have two API calls for alloc, and a single
> structure that defines the ranges etc from the architecture side rather
> than spread all over.
>
> Like something along these lines:
>
>         struct execmem_range {
>                 unsigned long   start;
>                 unsigned long   end;
>                 unsigned long   fallback_start;
>                 unsigned long   fallback_end;
>                 pgprot_t        pgprot;
>                 unsigned int    alignment;
>         };
>
>         struct execmem_modules_range {
>                 enum execmem_module_flags flags;
>                 struct execmem_range text;
>                 struct execmem_range data;
>         };
>
>         struct execmem_jit_range {
>                 struct execmem_range text;
>         };
>
>         struct execmem_params {
>                 struct execmem_modules_range    modules;
>                 struct execmem_jit_range        jit;
>         };
>
>         struct execmem_params *execmem_arch_params(void);
>
>         void *execmem_text_alloc(size_t size);
>         void *execmem_data_alloc(size_t size);
>         void execmem_free(void *ptr);

With the jit variation, maybe we can just call these
module_[text|data]_alloc()?

btw: Depending on the implementation of the allocator, we may also
need separate free()s for text and data.

>
>         void *jit_text_alloc(size_t size);
>         void jit_free(void *ptr);
>

[...]

How should we move ahead from here?

AFAICT, all these changes can be easily extended and refactored
in the future, so we don't have to make it perfect the first time.
OTOH, having the interface committed (either this set or my
module_alloc_type version) can unblock works in the binpack
allocator and the users side. Therefore, I think we can move
relatively fast here?

Thanks,
Song

