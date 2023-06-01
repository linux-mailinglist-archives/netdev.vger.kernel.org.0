Return-Path: <netdev+bounces-7219-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FDDC71F17B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:15:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DE121C20A38
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 015674824B;
	Thu,  1 Jun 2023 18:15:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82B748242
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 18:15:06 +0000 (UTC)
Received: from out-56.mta1.migadu.com (out-56.mta1.migadu.com [95.215.58.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB1A1A1
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 11:15:04 -0700 (PDT)
Date: Thu, 1 Jun 2023 14:14:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685643302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZJB8Y+qWnzDFm68SRo4Caqik2FMGAG+Lwf+CLh2n8l8=;
	b=heVebVByNmhUMsJ2WAULJ9HLAPC6refckfCUJY0WXx4hRhZsbaomDSDugjYWaWQ6LEkWdP
	Jvcs9tQIzXZc+0yCsv5NbHMBQcwZQ1wXx/fNbx6WxFVHuREaPuDV58w3hONj9KdJXnaniY
	jN/vCOKQCwHm3op0QMHWhM09SJgJWkM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
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
Message-ID: <ZHjgIH3aX9dCvVZc@moria.home.lan>
References: <20230601101257.530867-1-rppt@kernel.org>
 <ZHjDU/mxE+cugpLj@FVFF77S0Q05N.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHjDU/mxE+cugpLj@FVFF77S0Q05N.cambridge.arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 05:12:03PM +0100, Mark Rutland wrote:
> For a while I have wanted to give kprobes its own allocator so that it can work
> even with CONFIG_MODULES=n, and so that it doesn't have to waste VA space in
> the modules area.
> 
> Given that, I think these should have their own allocator functions that can be
> provided independently, even if those happen to use common infrastructure.

How much memory can kprobes conceivably use? I think we also want to try
to push back on combinatorial new allocators, if we can.

> > Several architectures override module_alloc() because of various
> > constraints where the executable memory can be located and this causes
> > additional obstacles for improvements of code allocation.
> > 
> > This set splits code allocation from modules by introducing
> > jit_text_alloc(), jit_data_alloc() and jit_free() APIs, replaces call
> > sites of module_alloc() and module_memfree() with the new APIs and
> > implements core text and related allocation in a central place.
> > 
> > Instead of architecture specific overrides for module_alloc(), the
> > architectures that require non-default behaviour for text allocation must
> > fill jit_alloc_params structure and implement jit_alloc_arch_params() that
> > returns a pointer to that structure. If an architecture does not implement
> > jit_alloc_arch_params(), the defaults compatible with the current
> > modules::module_alloc() are used.
> 
> As above, I suspect that each of the callsites should probably be using common
> infrastructure, but I don't think that a single jit_alloc_arch_params() makes
> sense, since the parameters for each case may need to be distinct.

I don't see how that follows. The whole point of function parameters is
that they may be different :)

Can you give more detail on what parameters you need? If the only extra
parameter is just "does this allocation need to live close to kernel
text", that's not that big of a deal.

