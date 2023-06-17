Return-Path: <netdev+bounces-11745-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C3B4734245
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 18:38:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAE661C20A96
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 16:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A84FFBA29;
	Sat, 17 Jun 2023 16:38:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E2E8F78;
	Sat, 17 Jun 2023 16:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962CAC433CC;
	Sat, 17 Jun 2023 16:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687019911;
	bh=wsV5PAOYMtSK534qTONYBGMJADMTf/thu6AVR5VKWFg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=q5TvC7wXcesBdrAtVwBAqlybicfQ3l31tWhe47gCHoheDPlgSrgt59SLSMZIhYDmm
	 jGSI/AbGdyvh5m2k3AnGCSYg1w5Ip7D6pqCyW2WpiRZOEAGiOwo2Hmd+1j6rAUprE/
	 b4HC/Njwt5Mk8bqvMnWE6kMHhKXtbhBU8/LPHAhQqUf6bNYjoID11JcNvnbHR/Wty1
	 Ci4aW7m3E0aYzqV5URi12B3tlQTJav9/V3UGVH6RUi6w1dQdJ06xsBzhXtuLm5kC4A
	 9lTOU3FN61E41TP3c36eHFu7PswdRbNKM83MrM077JEeujQ0StC2gBK9V8FMll8Kgo
	 IyVxt6UshhCrg==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-4f841b7a697so2303490e87.3;
        Sat, 17 Jun 2023 09:38:31 -0700 (PDT)
X-Gm-Message-State: AC+VfDzAKM11ayayk1YGXRKJGqccm1KymiYuK6icL39q047Ur3K0n+i4
	CvKqQ4Dlr2qxqdJHLsshBAmx/groT4nmUV5dJW4=
X-Google-Smtp-Source: ACHHUZ7/x1kYUhYXMtUENPjhDtD48HKOo5oy2K5VqpfigImzwjTDz7CrLzlDpzPNd4SA2zOD7D4teoP7FVQzMuuaU40=
X-Received: by 2002:ac2:5bd1:0:b0:4eb:42b7:8c18 with SMTP id
 u17-20020ac25bd1000000b004eb42b78c18mr3005243lfn.53.1687019909491; Sat, 17
 Jun 2023 09:38:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230616085038.4121892-1-rppt@kernel.org> <20230616085038.4121892-8-rppt@kernel.org>
 <CAPhsuW6BG2oVrGDOpCKyOEvU9fBOboYYhducv96KUBe276Mvng@mail.gmail.com>
 <20230617065759.GT52412@kernel.org> <ZI3TGhJ2y5SBWmnA@moria.home.lan>
In-Reply-To: <ZI3TGhJ2y5SBWmnA@moria.home.lan>
From: Song Liu <song@kernel.org>
Date: Sat, 17 Jun 2023 09:38:17 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4KDriCDfQ40MKKQ3AjyeRbEUJxjqoBLipe5AJMxY3U-w@mail.gmail.com>
Message-ID: <CAPhsuW4KDriCDfQ40MKKQ3AjyeRbEUJxjqoBLipe5AJMxY3U-w@mail.gmail.com>
Subject: Re: [PATCH v2 07/12] arm64, execmem: extend execmem_params for
 generated code definitions
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, "David S. Miller" <davem@davemloft.net>, 
	Dinh Nguyen <dinguyen@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, 
	Huacai Chen <chenhuacai@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
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

On Sat, Jun 17, 2023 at 8:37=E2=80=AFAM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Sat, Jun 17, 2023 at 09:57:59AM +0300, Mike Rapoport wrote:
> > > This is growing fast. :) We have 3 now: text, data, jit. And it will =
be
> > > 5 when we split data into rw data, ro data, ro after init data. I won=
der
> > > whether we should still do some type enum here. But we can revisit
> > > this topic later.
> >
> > I don't think we'd need 5. Four at most :)
> >
> > I don't know yet what would be the best way to differentiate RW and RO
> > data, but ro_after_init surely won't need a new type. It either will be
> > allocated as RW and then the caller will have to set it RO after
> > initialization is done, or it will be allocated as RO and the caller wi=
ll
> > have to do something like text_poke to update it.
>
> Perhaps ro_after_init could use the same allocation interface and share
> pages with ro pages - if we just added a refcount for "this page
> currently needs to be rw, module is still loading?"

If we don't relax rules with read only, we will have to separate rw, ro,
and ro_after_init. But we can still have page sharing:

Two modules can put rw data on the same page.
With text poke (ro data poke to be accurate), two modules can put
ro data on the same page.

> text_poke() approach wouldn't be workable, you'd have to audit and fix
> all module init code in the entire kernel.

Agreed. For this reason, each module has to have its own page(s) for
ro_after_init data.

To eventually remove VM_FLUSH_RESET_PERMS, we want
ro_after_init data to share the same allocation interface.

Thanks,
Song

