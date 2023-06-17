Return-Path: <netdev+bounces-11674-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E282733E8E
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:11:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54D62281911
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7053646AB;
	Sat, 17 Jun 2023 06:11:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BAD111C;
	Sat, 17 Jun 2023 06:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232F1C433C8;
	Sat, 17 Jun 2023 06:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686982263;
	bh=1X6Vc8+Xzykk7Z2p+5RPkPnfKk/mxTwRqvgQiLyFLcs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kpVRRR3/peLouH5K6845IoDymP4RzHQ5X18L/qapqW+HSOSVD4Jxe+dS8ZHi81pu/
	 6UGSL3ryafkglY404kB9NewuLJthdXrDKmiG1bUa/SbIGImcdFFTImcXA24Lrq1XBP
	 b8jHFLQ6gc3Wlj/T62OORePu3DpO0oegza9UGNNTomGmTdYPVnUkXHwlXXNP8xNb6O
	 mSUdao6gRKvwJRP5+ktwASUtigGyhHJfmUrvUL8UkoscW+emJo4VTKfMECcoxbnJ1O
	 71I0q0m7dm69SI0vCCHrQzATzQcgIJXdFUCmromH14CzN/7cF+UERF73BpE9q6ULNL
	 UyjIthY/V8Lsw==
Date: Sat, 17 Jun 2023 09:10:15 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mcgrof@kernel.org" <mcgrof@kernel.org>,
	"deller@gmx.de" <deller@gmx.de>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"nadav.amit@gmail.com" <nadav.amit@gmail.com>,
	"linux@armlinux.org.uk" <linux@armlinux.org.uk>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>,
	"puranjay12@gmail.com" <puranjay12@gmail.com>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"tsbogend@alpha.franken.de" <tsbogend@alpha.franken.de>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
	"christophe.leroy@csgroup.eu" <christophe.leroy@csgroup.eu>,
	"x86@kernel.org" <x86@kernel.org>,
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"will@kernel.org" <will@kernel.org>,
	"dinguyen@kernel.org" <dinguyen@kernel.org>,
	"naveen.n.rao@linux.ibm.com" <naveen.n.rao@linux.ibm.com>,
	"sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
	"linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"song@kernel.org" <song@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 04/12] mm/execmem, arch: convert remaining overrides
 of module_alloc to execmem
Message-ID: <20230617061015.GO52412@kernel.org>
References: <20230616085038.4121892-1-rppt@kernel.org>
 <20230616085038.4121892-5-rppt@kernel.org>
 <15f5dff8217b1a2e16697d40e48dee6dd1f9b2f3.camel@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15f5dff8217b1a2e16697d40e48dee6dd1f9b2f3.camel@intel.com>

On Fri, Jun 16, 2023 at 04:16:28PM +0000, Edgecombe, Rick P wrote:
> On Fri, 2023-06-16 at 11:50 +0300, Mike Rapoport wrote:
> > -void *module_alloc(unsigned long size)
> > -{
> > -       gfp_t gfp_mask = GFP_KERNEL;
> > -       void *p;
> > -
> > -       if (PAGE_ALIGN(size) > MODULES_LEN)
> > -               return NULL;
> > +static struct execmem_params execmem_params = {
> > +       .modules = {
> > +               .flags = EXECMEM_KASAN_SHADOW,
> > +               .text = {
> > +                       .alignment = MODULE_ALIGN,
> > +               },
> > +       },
> > +};
> 
> Did you consider making these execmem_params's ro_after_init? Not that
> it is security sensitive, but it's a nice hint to the reader that it is
> only modified at init. And I guess basically free sanitizing of buggy
> writes to it.

Makes sense.
 
> >  
> > -       p = __vmalloc_node_range(size, MODULE_ALIGN,
> > -                                MODULES_VADDR +
> > get_module_load_offset(),
> > -                                MODULES_END, gfp_mask, PAGE_KERNEL,
> > -                                VM_FLUSH_RESET_PERMS |
> > VM_DEFER_KMEMLEAK,
> > -                                NUMA_NO_NODE,
> > __builtin_return_address(0));
> > +struct execmem_params __init *execmem_arch_params(void)
> > +{
> > +       unsigned long start = MODULES_VADDR +
> > get_module_load_offset();
> 
> I think we can drop the mutex's in get_module_load_offset() now, since
> execmem_arch_params() should only be called once at init.

Right. Even more, the entire get_module_load_offset() can be folded into
execmem_arch_params() as 

	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && kaslr_enabled())
		module_load_offset =
			get_random_u32_inclusive(1, 1024) * PAGE_SIZE;

> >  
> > -       if (p && (kasan_alloc_module_shadow(p, size, gfp_mask) < 0))
> > {
> > -               vfree(p);
> > -               return NULL;
> > -       }
> > +       execmem_params.modules.text.start = start;
> > +       execmem_params.modules.text.end = MODULES_END;
> > +       execmem_params.modules.text.pgprot = PAGE_KERNEL;
> >  
> > -       return p;
> > +       return &execmem_params;
> >  }
> >  
> 

-- 
Sincerely yours,
Mike.

