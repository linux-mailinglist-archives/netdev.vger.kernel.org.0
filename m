Return-Path: <netdev+bounces-9330-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 53AEF728764
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44D131C2085B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C141B1953B;
	Thu,  8 Jun 2023 18:41:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F987E3;
	Thu,  8 Jun 2023 18:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A486DC433D2;
	Thu,  8 Jun 2023 18:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686249710;
	bh=4a7fPJtZnT2G3XUHjxk53JytGZ7vtRhXAZPweGPLJ7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zf6igQH5RfRjPL1LLNRp2u8iNNy6O+kF/bGYFX3Nrh8fUdglTmP/qjkVHeDHFuQNr
	 jn2Uh6KySMX6f0GTo02MvlJp6Rv68cW/69I/MFZtSdKzOt0NBFweVHnVybdzHgWXfl
	 KvtLJ4ESmigmI/uc0oNYGCIO7NHmoF2IrKkybPAl+gdBXFQ0P23XDeYWK4z9h15oKv
	 ZKGiTpWdZVp/QxM4gHnWF1LN14ykgAc8/vUL3ndVfxx63Am/uu3wKbhKbUkF+Bi6Ox
	 4oM/zbXXCqLIwER2tnq6O7dDS4+mh/aE4qybCY5QC5PMes/KnyWH9l0FxBIq6F8Dg4
	 8wj5ZhMvd7MFQ==
Date: Thu, 8 Jun 2023 21:41:16 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Russell King <linux@armlinux.org.uk>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
	bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev, netdev@vger.kernel.org,
	sparclinux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 00/13] mm: jit/text allocator
Message-ID: <20230608184116.GJ52412@kernel.org>
References: <20230601101257.530867-1-rppt@kernel.org>
 <ZHjDU/mxE+cugpLj@FVFF77S0Q05N.cambridge.arm.com>
 <ZHjgIH3aX9dCvVZc@moria.home.lan>
 <ZHm3zUUbwqlsZBBF@FVFF77S0Q05N>
 <20230605092040.GB3460@kernel.org>
 <ZH20XkD74prrdN4u@FVFF77S0Q05N>
 <CAPhsuW7ntn_HpVWdGK_hYVd3zsPEFToBNfmtt0m6K8SwfxJ66Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW7ntn_HpVWdGK_hYVd3zsPEFToBNfmtt0m6K8SwfxJ66Q@mail.gmail.com>

On Tue, Jun 06, 2023 at 11:21:59AM -0700, Song Liu wrote:
> On Mon, Jun 5, 2023 at 3:09 AM Mark Rutland <mark.rutland@arm.com> wrote:
> 
> [...]
> 
> > > > > Can you give more detail on what parameters you need? If the only extra
> > > > > parameter is just "does this allocation need to live close to kernel
> > > > > text", that's not that big of a deal.
> > > >
> > > > My thinking was that we at least need the start + end for each caller. That
> > > > might be it, tbh.
> > >
> > > Do you mean that modules will have something like
> > >
> > >       jit_text_alloc(size, MODULES_START, MODULES_END);
> > >
> > > and kprobes will have
> > >
> > >       jit_text_alloc(size, KPROBES_START, KPROBES_END);
> > > ?
> >
> > Yes.
> 
> How about we start with two APIs:
>      jit_text_alloc(size);
>      jit_text_alloc_range(size, start, end);
> 
> AFAICT, arm64 is the only arch that requires the latter API. And TBH, I am
> not quite convinced it is needed.
 
Right now arm64 and riscv override bpf and kprobes allocations to use the
entire vmalloc address space, but having the ability to allocate generated
code outside of modules area may be useful for other architectures.

Still the start + end for the callers feels backwards to me because the
callers do not define the ranges, but rather the architectures, so we still
need a way for architectures to define how they want allocate memory for
the generated code.

> > > It sill can be achieved with a single jit_alloc_arch_params(), just by
> > > adding enum jit_type parameter to jit_text_alloc().
> >
> > That feels backwards to me; it centralizes a bunch of information about
> > distinct users to be able to shove that into a static array, when the callsites
> > can pass that information.
> 
> I think we only two type of users: module and everything else (ftrace, kprobe,
> bpf stuff). The key differences are:
> 
>   1. module uses text and data; while everything else only uses text.
>   2. module code is generated by the compiler, and thus has stronger
>   requirements in address ranges; everything else are generated via some
>   JIT or manual written assembly, so they are more flexible with address
>   ranges (in JIT, we can avoid using instructions that requires a specific
>   address range).
> 
> The next question is, can we have the two types of users share the same
> address ranges? If not, we can reserve the preferred range for modules,
> and let everything else use the other range. I don't see reasons to further
> separate users in the "everything else" group.
 
I agree that we can define only two types: modules and everything else and
let the architectures define if they need different ranges for these two
types, or want the same range for everything.

With only two types we can have two API calls for alloc, and a single
structure that defines the ranges etc from the architecture side rather
than spread all over.

Like something along these lines:

	struct execmem_range {
		unsigned long   start;
		unsigned long   end;
		unsigned long   fallback_start;
		unsigned long   fallback_end;
		pgprot_t        pgprot;
		unsigned int	alignment;
	};

	struct execmem_modules_range {
		enum execmem_module_flags flags;
		struct execmem_range text;
		struct execmem_range data;
	};

	struct execmem_jit_range {
		struct execmem_range text;
	};

	struct execmem_params {
		struct execmem_modules_range	modules;
		struct execmem_jit_range	jit;
	};

	struct execmem_params *execmem_arch_params(void);

	void *execmem_text_alloc(size_t size);
	void *execmem_data_alloc(size_t size);
	void execmem_free(void *ptr);

	void *jit_text_alloc(size_t size);
	void jit_free(void *ptr);

Modules or anything that must live close to the kernel image can use
execmem_*_alloc() and the callers that don't generally care about relative
addressing will use jit_text_alloc(), presuming that arch will restrict jit
range if necessary, like e.g. below for arm64 jit can be anywhere in
vmalloc and for x86 and s390 it will share the modules range. 


	struct execmem_params arm64_execmem = {
		.modules = {
			.flags = KASAN,
			.text = {
				.start = MODULES_VADDR,
				.end = MODULES_END,
				.pgprot = PAGE_KERNEL_ROX,
				.fallback_start = VMALLOC_START,
				.fallback_start = VMALLOC_END,
			},
		},
		.jit = {
			.text = {
				.start = VMALLOC_START,
				.end = VMALLOC_END,
				.pgprot = PAGE_KERNEL_ROX,
			},
		},
	};

	/* x86 and s390 */
	struct execmem_params cisc_execmem = {
		.modules = {
			.flags = KASAN,
			.text = {
				.start = MODULES_VADDR,
				.end = MODULES_END,
				.pgprot = PAGE_KERNEL_ROX,
			},
		},
		.jit_range = {},	/* impplies reusing .modules */
	};

	struct execmem_params default_execmem = {
		.modules = {
			.flags = KASAN,
			.text = {
				.start = VMALLOC_START,
				.end = VMALLOC_END,
				.pgprot = PAGE_KERNEL_EXEC,
			},
		},
	};

-- 
Sincerely yours,
Mike.

