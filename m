Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50909455F4B
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 16:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhKRPZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 10:25:01 -0500
Received: from foss.arm.com ([217.140.110.172]:42138 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231574AbhKRPZA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 10:25:00 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DA69D6E;
        Thu, 18 Nov 2021 07:22:00 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 76CBE3F766;
        Thu, 18 Nov 2021 07:21:57 -0800 (PST)
Date:   Thu, 18 Nov 2021 15:21:55 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Jisheng Zhang <jszhang3@mail.ustc.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Tong Tiangen <tongtiangen@huawei.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 09/12] riscv: extable: add `type` and `data` fields
Message-ID: <20211118152155.GB9977@lakrids.cambridge.arm.com>
References: <20211118192130.48b8f04c@xhacker>
 <20211118192605.57e06d6b@xhacker>
 <20211118193332.79799a9c@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118193332.79799a9c@xhacker>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 07:42:49PM +0800, Jisheng Zhang wrote:
> On Thu, 18 Nov 2021 19:26:05 +0800 Jisheng Zhang wrote:
> 
> > From: Jisheng Zhang <jszhang@kernel.org>
> > 
> > This is a riscv port of commit d6e2cc564775("arm64: extable: add `type`
> > and `data` fields").
> > 
> > We will add specialized handlers for fixups, the `type` field is for
> > fixup handler type, the `data` field is used to pass specific data to
> > each handler, for example register numbers.
> > 
> > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>

> > diff --git a/scripts/sorttable.c b/scripts/sorttable.c
> > index 0c031e47a419..5b5472b543f5 100644
> > --- a/scripts/sorttable.c
> > +++ b/scripts/sorttable.c
> > @@ -376,9 +376,11 @@ static int do_file(char const *const fname, void *addr)
> >  	case EM_PARISC:
> >  	case EM_PPC:
> >  	case EM_PPC64:
> > -	case EM_RISCV:
> >  		custom_sort = sort_relative_table;
> >  		break;
> > +	case EM_RISCV:
> > +		custom_sort = arm64_sort_relative_table;
> 
> Hi Mark, Thomas,
> 
> x86 and arm64 version of sort_relative_table routine are the same, I want to
> unify them, and then use the common function for riscv, but I'm not sure
> which name is better. Could you please suggest?

I sent a patch last week which unifies them as
sort_relative_table_with_data():

  https://lore.kernel.org/linux-arm-kernel/20211108114220.32796-1-mark.rutland@arm.com/

Thomas, are you happy with that patch?

With your ack it could go via the riscv tree for v5.17 as a preparatory
cleanup in this series.

Maybe we could get it in as a cleanup for v5.16-rc{2,3} ?

Thanks,
Mark.
