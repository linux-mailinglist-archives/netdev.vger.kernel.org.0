Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06AE03F304E
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241345AbhHTP4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241319AbhHTP4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 11:56:36 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB95C061757
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 08:55:58 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id x4so9587330pgh.1
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 08:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DfMkWVrhrXjOa4WT8fjUg2g99cfma/KNVtPegOy6YVA=;
        b=Tn/7uDGMiPjXxAM3ovBYEVyLtygFwlSJAWHrob1PWt4oz/x2Imgk0GhPN2Q3ecFemj
         9aGJEzabYG/yp6A5N5Z9cTlvPVLlh/yP6oNypqN5vG8oOziU+OSzJRTu7fqXk/NgneL3
         +EIYwoyeYH2hiFo8BxwiCpYmqjeLAOAaaL9bA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DfMkWVrhrXjOa4WT8fjUg2g99cfma/KNVtPegOy6YVA=;
        b=L4m0m4us8iq87hrSHM3f1lvZPsCggyLnHQwL+7LnAXzo6lJIPXEMYig6+m1181cPOT
         DemE/BAVdbEuLVJZrRFoswO7hyO1VyQxzBB+26zz7aF1W7Qa4vBe5jk/4T52OOe7GLq9
         e95UCsUG0qv01IpBN9CbqXMUxizMZ0WndxDcqSJKDRMVK346RgWL1Jp4hvwvsSNWP/GY
         lkF4miI91nCDi9X5aYA3qZXTeYtVAYwNYahrAIqOI4M7IsuMfs1Ky0kw0M6y8/dNIQvk
         YPViHpwEKk98AxJzTk5fTX17RFeZ1RWs2CSP1+5MHjG7qyJ6WIhgC6NY+T+9Avjys35a
         wF2w==
X-Gm-Message-State: AOAM532H+IJJVzXWgc1H/wBG+OsZknMs6IcmVMzI/TCdxXb6sclMo1eF
        WBJ38EXCPPhxPbWRg0aDdm9PlQ==
X-Google-Smtp-Source: ABdhPJxNmkkLS0IYvcJdUty1efO3ATpriVc4oMEh5d9+VW4AFW/Rt8LdZFCR+Kj2vvrc2GQCiXZJ9w==
X-Received: by 2002:a63:4d24:: with SMTP id a36mr6002323pgb.37.1629474957688;
        Fri, 20 Aug 2021 08:55:57 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o10sm6412690pjg.34.2021.08.20.08.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 08:55:57 -0700 (PDT)
Date:   Fri, 20 Aug 2021 08:55:56 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sudeep Holla <sudeep.holla@arm.com>,
        linuxppc-dev@lists.ozlabs.org, kernel test robot <lkp@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 57/63] powerpc/signal32: Use struct_group() to zero
 spe regs
Message-ID: <202108200851.8AF09CDB71@keescook>
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-58-keescook@chromium.org>
 <877dggeesw.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dggeesw.fsf@mpe.ellerman.id.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 05:49:35PM +1000, Michael Ellerman wrote:
> Kees Cook <keescook@chromium.org> writes:
> > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > field bounds checking for memset(), avoid intentionally writing across
> > neighboring fields.
> >
> > Add a struct_group() for the spe registers so that memset() can correctly reason
> > about the size:
> >
> >    In function 'fortify_memset_chk',
> >        inlined from 'restore_user_regs.part.0' at arch/powerpc/kernel/signal_32.c:539:3:
> >>> include/linux/fortify-string.h:195:4: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
> >      195 |    __write_overflow_field();
> >          |    ^~~~~~~~~~~~~~~~~~~~~~~~
> >
> > Cc: Michael Ellerman <mpe@ellerman.id.au>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> > Cc: Sudeep Holla <sudeep.holla@arm.com>
> > Cc: linuxppc-dev@lists.ozlabs.org
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  arch/powerpc/include/asm/processor.h | 6 ++++--
> >  arch/powerpc/kernel/signal_32.c      | 6 +++---
> >  2 files changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
> > index f348e564f7dd..05dc567cb9a8 100644
> > --- a/arch/powerpc/include/asm/processor.h
> > +++ b/arch/powerpc/include/asm/processor.h
> > @@ -191,8 +191,10 @@ struct thread_struct {
> >  	int		used_vsr;	/* set if process has used VSX */
> >  #endif /* CONFIG_VSX */
> >  #ifdef CONFIG_SPE
> > -	unsigned long	evr[32];	/* upper 32-bits of SPE regs */
> > -	u64		acc;		/* Accumulator */
> > +	struct_group(spe,
> > +		unsigned long	evr[32];	/* upper 32-bits of SPE regs */
> > +		u64		acc;		/* Accumulator */
> > +	);
> >  	unsigned long	spefscr;	/* SPE & eFP status */
> >  	unsigned long	spefscr_last;	/* SPEFSCR value on last prctl
> >  					   call or trap return */
> > diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
> > index 0608581967f0..77b86caf5c51 100644
> > --- a/arch/powerpc/kernel/signal_32.c
> > +++ b/arch/powerpc/kernel/signal_32.c
> > @@ -532,11 +532,11 @@ static long restore_user_regs(struct pt_regs *regs,
> >  	regs_set_return_msr(regs, regs->msr & ~MSR_SPE);
> >  	if (msr & MSR_SPE) {
> >  		/* restore spe registers from the stack */
> > -		unsafe_copy_from_user(current->thread.evr, &sr->mc_vregs,
> > -				      ELF_NEVRREG * sizeof(u32), failed);
> > +		unsafe_copy_from_user(&current->thread.spe, &sr->mc_vregs,
> > +				      sizeof(current->thread.spe), failed);
> 
> This makes me nervous, because the ABI is that we copy ELF_NEVRREG *
> sizeof(u32) bytes, not whatever sizeof(current->thread.spe) happens to
> be.
> 
> ie. if we use sizeof an inadvertent change to the fields in
> thread_struct could change how many bytes we copy out to userspace,
> which would be an ABI break.
> 
> And that's not that hard to do, because it's not at all obvious that the
> size and layout of fields in thread_struct affects the user ABI.
> 
> At the same time we don't want to copy the right number of bytes but
> the wrong content, so from that point of view using sizeof is good :)
> 
> The way we handle it in ptrace is to have BUILD_BUG_ON()s to verify that
> things match up, so maybe we should do that here too.
> 
> ie. add:
> 
> 	BUILD_BUG_ON(sizeof(current->thread.spe) == ELF_NEVRREG * sizeof(u32));
> 
> Not sure if you are happy doing that as part of this patch. I can always
> do it later if not.

Sounds good to me; I did that in a few other cases in the series where
the relationships between things seemed tenuous. :) I'll add this (as
!=) in v3.

Thanks!

-- 
Kees Cook
