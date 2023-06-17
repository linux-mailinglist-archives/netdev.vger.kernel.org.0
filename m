Return-Path: <netdev+bounces-11749-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED1367343A5
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 22:37:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0325D1C20A85
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 20:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A34047F4;
	Sat, 17 Jun 2023 20:37:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9873AECF
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 20:37:41 +0000 (UTC)
Received: from out-37.mta1.migadu.com (out-37.mta1.migadu.com [95.215.58.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1221736;
	Sat, 17 Jun 2023 13:37:37 -0700 (PDT)
Date: Sat, 17 Jun 2023 16:37:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687034256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q0VmYCbqCGEwwRm9p2gHyBMkJehgKoo9YX+I+uEXlwI=;
	b=dfNjewHVuYudVnc8TKpcch6UyyxsC62EekInr+KCF+/d5W19oLEbYgWNkxwMPmu6LU+6YJ
	DDxDUAUrcbSRUp/oMghsBWa2J9HukZTCZ/JGCQrtkNxjPDHNM3pSHNKVBsHXTHpr3HEdfU
	c38+ELnaz0YDpRbuK0hGGk55HYtUVFk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Song Liu <song@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nadav Amit <nadav.amit@gmail.com>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Puranjay Mohan <puranjay12@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
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
Subject: Re: [PATCH v2 07/12] arm64, execmem: extend execmem_params for
 generated code definitions
Message-ID: <ZI4Zifzfi/5qBNMw@moria.home.lan>
References: <20230616085038.4121892-1-rppt@kernel.org>
 <20230616085038.4121892-8-rppt@kernel.org>
 <CAPhsuW6BG2oVrGDOpCKyOEvU9fBOboYYhducv96KUBe276Mvng@mail.gmail.com>
 <20230617065759.GT52412@kernel.org>
 <ZI3TGhJ2y5SBWmnA@moria.home.lan>
 <CAPhsuW4KDriCDfQ40MKKQ3AjyeRbEUJxjqoBLipe5AJMxY3U-w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW4KDriCDfQ40MKKQ3AjyeRbEUJxjqoBLipe5AJMxY3U-w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 17, 2023 at 09:38:17AM -0700, Song Liu wrote:
> On Sat, Jun 17, 2023 at 8:37 AM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Sat, Jun 17, 2023 at 09:57:59AM +0300, Mike Rapoport wrote:
> > > > This is growing fast. :) We have 3 now: text, data, jit. And it will be
> > > > 5 when we split data into rw data, ro data, ro after init data. I wonder
> > > > whether we should still do some type enum here. But we can revisit
> > > > this topic later.
> > >
> > > I don't think we'd need 5. Four at most :)
> > >
> > > I don't know yet what would be the best way to differentiate RW and RO
> > > data, but ro_after_init surely won't need a new type. It either will be
> > > allocated as RW and then the caller will have to set it RO after
> > > initialization is done, or it will be allocated as RO and the caller will
> > > have to do something like text_poke to update it.
> >
> > Perhaps ro_after_init could use the same allocation interface and share
> > pages with ro pages - if we just added a refcount for "this page
> > currently needs to be rw, module is still loading?"
> 
> If we don't relax rules with read only, we will have to separate rw, ro,
> and ro_after_init. But we can still have page sharing:
> 
> Two modules can put rw data on the same page.
> With text poke (ro data poke to be accurate), two modules can put
> ro data on the same page.
> 
> > text_poke() approach wouldn't be workable, you'd have to audit and fix
> > all module init code in the entire kernel.
> 
> Agreed. For this reason, each module has to have its own page(s) for
> ro_after_init data.

Relaxing page permissions to allow for page sharing could also be a
config option. For archs with 64k pages it seems worthwhile.

