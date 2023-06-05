Return-Path: <netdev+bounces-8203-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ABE57231A3
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:43:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAF11281463
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66259261C2;
	Mon,  5 Jun 2023 20:43:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A7EBE59;
	Mon,  5 Jun 2023 20:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0414C433D2;
	Mon,  5 Jun 2023 20:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685997807;
	bh=We5qywEUXFBvYr91+f59TuYCdj8cINMwKn3eQvO6qKo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I7xvXQXLM0Tk+V+96RzBdr/UoRB92a3ftHnZrilLQZvr5w3AlNjzmN9wbeCqkkbCl
	 DDUm1W1zxfiZwe+gjXC6K0QMqz8d9USg05gKXvmHLfrAf+FqT+OTOcMK6aGFqzG1zb
	 E86H0paXXm7ihSYO0CbgPPXfw8rIsLX4qwzhB6/StpLTRz6eVNJy8R0u2bcXb5AObl
	 Ay16QdoRp1sSVGG9bP4FMnVsq9x+ifwOZH0isH9pe4CqYdVcIo5Tq1wLxq/sUlyaRg
	 pXJxzrOzrppU5klX4Kcg/mPHvek90M1w/P5hCMfIv1PTbM22Z3AvfuML6Ql3ohsT7Q
	 qhU+5loHIlZWg==
Date: Mon, 5 Jun 2023 23:42:56 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "rostedt@goodmis.org" <rostedt@goodmis.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"deller@gmx.de" <deller@gmx.de>,
	"mcgrof@kernel.org" <mcgrof@kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"nadav.amit@gmail.com" <nadav.amit@gmail.com>,
	"linux@armlinux.org.uk" <linux@armlinux.org.uk>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"tsbogend@alpha.franken.de" <tsbogend@alpha.franken.de>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>,
	"linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"christophe.leroy@csgroup.eu" <christophe.leroy@csgroup.eu>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
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
Subject: Re: [PATCH 12/13] x86/jitalloc: prepare to allocate exectuatble
 memory as ROX
Message-ID: <20230605204256.GA52412@kernel.org>
References: <20230601101257.530867-13-rppt@kernel.org>
 <0f50ac52a5280d924beeb131e6e4717b6ad9fdf7.camel@intel.com>
 <ZHjcr26YskTm+0EF@moria.home.lan>
 <a51c041b61e2916d2b91c990349aabc6cb9836aa.camel@intel.com>
 <ZHjljJfQjhVV/jNS@moria.home.lan>
 <68b8160454518387c53508717ba5ed5545ff0283.camel@intel.com>
 <50D768D7-15BF-43B8-A5FD-220B25595336@gmail.com>
 <20230604225244.65be9103@rorschach.local.home>
 <20230605081143.GA3460@kernel.org>
 <88a62f834688ed77d08c778e1e427014cf7d3c1b.camel@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <88a62f834688ed77d08c778e1e427014cf7d3c1b.camel@intel.com>

On Mon, Jun 05, 2023 at 04:10:21PM +0000, Edgecombe, Rick P wrote:
> On Mon, 2023-06-05 at 11:11 +0300, Mike Rapoport wrote:
> > On Sun, Jun 04, 2023 at 10:52:44PM -0400, Steven Rostedt wrote:
> > > On Thu, 1 Jun 2023 16:54:36 -0700
> > > Nadav Amit <nadav.amit@gmail.com> wrote:
> > > 
> > > > > The way text_poke() is used here, it is creating a new writable
> > > > > alias
> > > > > and flushing it for *each* write to the module (like for each
> > > > > write of
> > > > > an individual relocation, etc). I was just thinking it might
> > > > > warrant
> > > > > some batching or something.  
> > 
> > > > I am not advocating to do so, but if you want to have many
> > > > efficient
> > > > writes, perhaps you can just disable CR0.WP. Just saying that if
> > > > you
> > > > are about to write all over the memory, text_poke() does not
> > > > provide
> > > > too much security for the poking thread.
> > 
> > Heh, this is definitely and easier hack to implement :)
> 
> I don't know the details, but previously there was some strong dislike
> of CR0.WP toggling. And now there is also the problem of CET. Setting
> CR0.WP=0 will #GP if CR4.CET is 1 (as it currently is for kernel IBT).
> I guess you might get away with toggling them both in some controlled
> situation, but it might be a lot easier to hack up then to be made
> fully acceptable. It does sound much more efficient though.
 
I don't think we'd really want that, especially looking at 

		WARN_ONCE(bits_missing, "CR0 WP bit went missing!?\n");

at native_write_cr0().
 
> > > Batching does exist, which is what the text_poke_queue() thing
> > > does.
> > 
> > For module loading text_poke_queue() will still be much slower than a
> > bunch
> > of memset()s for no good reason because we don't need all the
> > complexity of
> > text_poke_bp_batch() for module initialization because we are sure we
> > are
> > not patching live code.
> > 
> > What we'd need here is a new batching mode that will create a
> > writable
> > alias mapping at the beginning of apply_relocate_*() and
> > module_finalize(),
> > then it will use memcpy() to that writable alias and will tear the
> > mapping
> > down in the end.
> 
> It's probably only a tiny bit faster than keeping a separate writable
> allocation and text_poking it in at the end.

Right, but it still will be faster than text_poking every relocation.
 
> > Another option is to teach alternatives to update a writable copy
> > rather
> > than do in place changes like Song suggested. My feeling is that it
> > will be
> > more intrusive change though.
> 
> You mean keeping a separate RW allocation and then text_poking() the
> whole thing in when you are done? That is what I was trying to say at
> the beginning of this thread. The other benefit is you don't make the
> intermediate loading states of the module, executable.
> 
> I tried this technique previously [0], and I thought it was not too
> bad. In most of the callers it looks similar to what you have in
> do_text_poke(). Sometimes less, sometimes more. It might need
> enlightening of some of the stuff currently using text_poke() during
> module loading, like jump labels. So that bit is more intrusive, yea.
> But it sounds so much cleaner and well controlled. Did you have a
> particular trouble spot in mind?

Nothing in particular, except the intrusive part. Except the changes in
modules.c we'd need to teach alternatives to deal with a writable copy.
 
> [0]
> https://lore.kernel.org/lkml/20201120202426.18009-5-rick.p.edgecombe@intel.com/

-- 
Sincerely yours,
Mike.

