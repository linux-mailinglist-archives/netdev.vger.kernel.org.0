Return-Path: <netdev+bounces-8209-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 092417231FC
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:13:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 739E21C20D6F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15CDD261FB;
	Mon,  5 Jun 2023 21:13:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A36024134
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 21:13:42 +0000 (UTC)
Received: from out-32.mta0.migadu.com (out-32.mta0.migadu.com [IPv6:2001:41d0:1004:224b::20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6025BFD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:13:40 -0700 (PDT)
Date: Mon, 5 Jun 2023 17:13:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685999618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oI/D2KsCHwim00FnKX8JEpI3trD4/Ay4oLN6y5jMs+w=;
	b=Ou0t5k0wdLvYQe4I1KiKwwoZvxsvVwlNJliRyeWssvJBsu1TjLT0R5xnAEF8ghzWl5EIl9
	wvjRxKwXo9+fHBI+ActLKXfymEdPx4wflBDdlUy8yktx25QJFLEuEOLWYXAN1GppOyjRcm
	hR70f2tpuOItMjMDbRE2yoaC4QllkuI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mike Rapoport <rppt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org,
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
	Russell King <linux@armlinux.org.uk>, Song Liu <song@kernel.org>,
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
Message-ID: <ZH5P+iKOnoqYjbPq@moria.home.lan>
References: <20230601101257.530867-1-rppt@kernel.org>
 <ZHjDU/mxE+cugpLj@FVFF77S0Q05N.cambridge.arm.com>
 <ZHjgIH3aX9dCvVZc@moria.home.lan>
 <ZHm3zUUbwqlsZBBF@FVFF77S0Q05N>
 <20230605092040.GB3460@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605092040.GB3460@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 12:20:40PM +0300, Mike Rapoport wrote:
> On Fri, Jun 02, 2023 at 10:35:09AM +0100, Mark Rutland wrote:
> > On Thu, Jun 01, 2023 at 02:14:56PM -0400, Kent Overstreet wrote:
> > > On Thu, Jun 01, 2023 at 05:12:03PM +0100, Mark Rutland wrote:
> > > > For a while I have wanted to give kprobes its own allocator so that it can work
> > > > even with CONFIG_MODULES=n, and so that it doesn't have to waste VA space in
> > > > the modules area.
> > > > 
> > > > Given that, I think these should have their own allocator functions that can be
> > > > provided independently, even if those happen to use common infrastructure.
> > > 
> > > How much memory can kprobes conceivably use? I think we also want to try
> > > to push back on combinatorial new allocators, if we can.
> > 
> > That depends on who's using it, and how (e.g. via BPF).
> > 
> > To be clear, I'm not necessarily asking for entirely different allocators, but
> > I do thinkg that we want wrappers that can at least pass distinct start+end
> > parameters to a common allocator, and for arm64's modules code I'd expect that
> > we'd keep the range falblack logic out of the common allcoator, and just call
> > it twice.
> > 
> > > > > Several architectures override module_alloc() because of various
> > > > > constraints where the executable memory can be located and this causes
> > > > > additional obstacles for improvements of code allocation.
> > > > > 
> > > > > This set splits code allocation from modules by introducing
> > > > > jit_text_alloc(), jit_data_alloc() and jit_free() APIs, replaces call
> > > > > sites of module_alloc() and module_memfree() with the new APIs and
> > > > > implements core text and related allocation in a central place.
> > > > > 
> > > > > Instead of architecture specific overrides for module_alloc(), the
> > > > > architectures that require non-default behaviour for text allocation must
> > > > > fill jit_alloc_params structure and implement jit_alloc_arch_params() that
> > > > > returns a pointer to that structure. If an architecture does not implement
> > > > > jit_alloc_arch_params(), the defaults compatible with the current
> > > > > modules::module_alloc() are used.
> > > > 
> > > > As above, I suspect that each of the callsites should probably be using common
> > > > infrastructure, but I don't think that a single jit_alloc_arch_params() makes
> > > > sense, since the parameters for each case may need to be distinct.
> > > 
> > > I don't see how that follows. The whole point of function parameters is
> > > that they may be different :)
> > 
> > What I mean is that jit_alloc_arch_params() tries to aggregate common
> > parameters, but they aren't actually common (e.g. the actual start+end range
> > for allocation).
> 
> jit_alloc_arch_params() tries to aggregate architecture constraints and
> requirements for allocations of executable memory and this exactly what
> the first 6 patches of this set do.
> 
> A while ago Thomas suggested to use a structure that parametrizes
> architecture constraints by the memory type used in modules [1] and Song
> implemented the infrastructure for it and x86 part [2].
> 
> I liked the idea of defining parameters in a single structure, but I
> thought that approaching the problem from the arch side rather than from
> modules perspective will be better starting point, hence these patches.
> 
> I don't see a fundamental reason why a single structure cannot describe
> what is needed for different code allocation cases, be it modules, kprobes
> or bpf. There is of course an assumption that the core allocations will be
> the same for all the users, and it seems to me that something like 
> 
> * allocate physical memory if allocator caches are empty
> * map it in vmalloc or modules address space
> * return memory from the allocator cache to the caller
> 
> will work for all usecases.
> 
> We might need separate caches for different cases on different
> architectures, and a way to specify what cache should be used in the
> allocator API, but that does not contradict a single structure for arch
> specific parameters, but only makes it more elaborate, e.g. something like
> 
> enum jit_type {
> 	JIT_MODULES_TEXT,
> 	JIT_MODULES_DATA,
> 	JIT_KPROBES,
> 	JIT_FTRACE,
> 	JIT_BPF,
> 	JIT_TYPE_MAX,
> };

Why would we actually need different enums for modules_text, kprobes,
ftrace and bpf? Why can't we treat all text allocations the same?

The reason we can't do that currently is because modules need to go in a
128Mb region on some archs, and without sub page allocation
bpf/kprobes/etc. burn a full page for each allocation. But we're doing
sub page allocation - right?

That leaves module data - which really needs to be split out into rw,
ro, ro_after_init - but I'm not sure we'd even want the same API for
those, they need fairly different page permissions handling.

