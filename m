Return-Path: <netdev+bounces-11672-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33DCA733E7C
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 07:53:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5CA328191C
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 05:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DE7E1C36;
	Sat, 17 Jun 2023 05:53:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD75B1C16;
	Sat, 17 Jun 2023 05:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24536C433C8;
	Sat, 17 Jun 2023 05:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686981222;
	bh=TluszqxdgR0a0IwbMuuhT/6JAXY40kPgAznuGjSXri0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lpj2dpfi9Ji3xzZ2kbgOQVYp/ZmysDx8WqNHlHmdTvMZEZsbjfL4hE6m7SXkjz4Zo
	 Mkq0iog3xkwtSwK3WOjB9XwUu05VRpcB0eogiPxG2WXCBK0aumyezzFkPPpZnGtjc7
	 5x++BGdF8JI0RHFvISKKMXQLn7exxg6GH1B4T2YCX3C0Zr0t9A89VOCr3b7IhrP+qG
	 ZzJIZ0zukBYcwghAr54w2jBQdBKljd+YnNYrk8GHhTFw3utqrXxsX2NC3voAWygO8q
	 svafETOLy9nPtmeHj06Y/0ZWzWAt+idrvmT6go/EJzAEpVusozQOwG5k1TndPIMv23
	 z+o01h8acz8Lg==
Date: Sat, 17 Jun 2023 08:52:56 +0300
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
Subject: Re: [PATCH v2 01/12] nios2: define virtual address space for modules
Message-ID: <20230617055256.GM52412@kernel.org>
References: <20230616085038.4121892-1-rppt@kernel.org>
 <20230616085038.4121892-2-rppt@kernel.org>
 <6f9e9c385096bd965e53c49065848953398f5b8e.camel@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6f9e9c385096bd965e53c49065848953398f5b8e.camel@intel.com>

On Fri, Jun 16, 2023 at 04:00:19PM +0000, Edgecombe, Rick P wrote:
> On Fri, 2023-06-16 at 11:50 +0300, Mike Rapoport wrote:
> >  void *module_alloc(unsigned long size)
> >  {
> > -       if (size == 0)
> > -               return NULL;
> > -       return kmalloc(size, GFP_KERNEL);
> > -}
> > -
> > -/* Free memory returned from module_alloc */
> > -void module_memfree(void *module_region)
> > -{
> > -       kfree(module_region);
> > +       return __vmalloc_node_range(size, 1, MODULES_VADDR,
> > MODULES_END,
> > +                                   GFP_KERNEL, PAGE_KERNEL_EXEC,
> > +                                   VM_FLUSH_RESET_PERMS,
> > NUMA_NO_NODE,
> > +                                   __builtin_return_address(0));
> >  }
> >  
> >  int apply_relocate_add(Elf32_Shdr *sechdrs, const char *s
> 
> I wonder if the (size == 0) check is really needed, but
> __vmalloc_node_range() will WARN on this case where the old code won't.

module_alloc() should not be called with zero size, so a warning there
would be appropriate.
Besides, no other module_alloc() had this check.

-- 
Sincerely yours,
Mike.

