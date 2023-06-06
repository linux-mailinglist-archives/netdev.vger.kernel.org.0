Return-Path: <netdev+bounces-8406-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46854723F11
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:16:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B470F1C20D93
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D59C2A715;
	Tue,  6 Jun 2023 10:16:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDB42A6EA;
	Tue,  6 Jun 2023 10:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CCDC433EF;
	Tue,  6 Jun 2023 10:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686046599;
	bh=K3mQNwoT9j+uKtNH0+N5SGAruipqVMe0nyrOVYu8zmA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ex2boOSbFX9F8vILoj2ER6OMGqZieI/qXxa+Cl88F6P5WueebucHT8gXYMljU/UwF
	 W4Vwtw16CB66Ckf8CUcEwiMgsp0Rl7Zp+sWmc7WhCTWF54CsHU5is7Yegd2qZ+FcpB
	 7HYr90xDXGc4Q+jlXpM3iwKf1+z1TAE79jym8dBpk7/sIwryEOoaJwZE+mZ+/dgO9Q
	 jbUZZ/yVspF9cToZ4ExktC3lUSHmqXSahqJcQT5b1PfE/IsSC9GrwIVg8JzQsfRBlA
	 +FWytBECVY5td4H8LIUSl6ZWwnci/X0OdWg6sGet7yNw0Tt3OFZ9/6khP83arPzxeP
	 mpCOpEPlPas8A==
Date: Tue, 6 Jun 2023 13:16:08 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
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
Message-ID: <20230606101608.GC52412@kernel.org>
References: <20230601101257.530867-1-rppt@kernel.org>
 <ZHjDU/mxE+cugpLj@FVFF77S0Q05N.cambridge.arm.com>
 <ZHjgIH3aX9dCvVZc@moria.home.lan>
 <ZHm3zUUbwqlsZBBF@FVFF77S0Q05N>
 <20230605092040.GB3460@kernel.org>
 <ZH20XkD74prrdN4u@FVFF77S0Q05N>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH20XkD74prrdN4u@FVFF77S0Q05N>

On Mon, Jun 05, 2023 at 11:09:34AM +0100, Mark Rutland wrote:
> On Mon, Jun 05, 2023 at 12:20:40PM +0300, Mike Rapoport wrote:
> > On Fri, Jun 02, 2023 at 10:35:09AM +0100, Mark Rutland wrote:
> >
> > It sill can be achieved with a single jit_alloc_arch_params(), just by
> > adding enum jit_type parameter to jit_text_alloc().
> 
> That feels backwards to me; it centralizes a bunch of information about
> distinct users to be able to shove that into a static array, when the callsites
> can pass that information. 

The goal was not to shove everything into an array, but centralize
architecture requirements for code allocations. The callsites don't have
that information per se, they get it from the arch code, so having this
information in a single place per arch is better than spreading
MODULE_START, KPROBES_START etc all over.

I'd agree though that having types for jit_text_alloc is ugly and this
should be handled differently.
 
> What's *actually* common after separating out the ranges? Is it just the
> permissions?

On x86 everything, on arm64 apparently just the permissions.

I've started to summarize what are the restrictions for code placement for
modules, kprobes and bpf on different architectures, that's roughly what
I've got so far:

* x86 and s390 need everything within modules address space because of
PC-relative
* arm, arm64, loongarch, sparc64, riscv64, some of mips and
powerpc32 configurations require a dedicated modules address space; the
rest just use vmalloc address space
* all architectures that support kprobes except x86 and s390 don't use
relative jumps, so they don't care where kprobes insn_page will live
* not sure yet about BPF. Looks like on arm and arm64 it does not use
relative jumps, so it can be anywhere, didn't dig enough about the others.

> If we want this to be able to share allocations and so on, why can't we do this
> like a kmem_cache, and have the callsite pass a pointer to the allocator data?
> That would make it easy for callsites to share an allocator or use a distinct
> one.

This maybe something worth exploring.
 
> Thanks,
> Mark.

-- 
Sincerely yours,
Mike.

