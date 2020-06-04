Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEC01EDC06
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 06:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgFDECg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 00:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbgFDECf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 00:02:35 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC9BC03E96D
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 21:02:34 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id d6so518324pjs.3
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 21:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dDMZ76EfQNqsSp5sb7mLI8JiO94mOeQpyrT6zdtd3HQ=;
        b=nmlYusCXDFiVqFXgxwlUm0gg3wIorQtKPNmSn8kUxXy2o8ATDLsqSlFD0o61OtpLts
         2zSeOvR5nnDD2//h685p30vwSekGc1q/jRAs6eegsS86q8t4Z7JAaLx7yfVY1EK9Xiau
         DCT2MBSjsLxms0BiWDCQF4Q6VgKuWrTFT33kU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dDMZ76EfQNqsSp5sb7mLI8JiO94mOeQpyrT6zdtd3HQ=;
        b=opyW0deTHWgnxInXOPsdoIymC1nyUxeQZpnMm/504Tuezwslpk3uHvE9uiOmtRzcyM
         shLdotr0hmcx7qb6ZXxkztDR9++spAHaByUJSEgnaxB3YhWrdcTejwHkseG4ZQblYYHB
         PEpDcQ5Qd+XMo8Xu+uunEarcFmfYzaVCN//9KIbM62hsGs6V3SxQFwN5okIdbWjxLUW8
         XqapIoXr3cnoJ8fKxCjMcjy2Af+HbrJLCMbSRvQlEJE0K5qg3jushb4nHhr3EMNuC2lN
         rot7/xFdOPgEMN29X0dL3w87j+nIAxFcGZLaRFRHxkPmF4DUqokxk2Z7tYnyzbEvs2c0
         Py7g==
X-Gm-Message-State: AOAM530xJYx3UqF2muuMHJn07bTqW7f9DOpvaMUaOsCLnk71ux9OFLSs
        aB/rJWvM4kBnmjfSAGbZh0lHpQ==
X-Google-Smtp-Source: ABdhPJxQ/Dd1yetZm6iahM4ViylSUD/mRnchtrTt1NIbGDNSI6TVF94FWNWMrr2lFeqPK0TXyTqNmA==
X-Received: by 2002:a17:902:b710:: with SMTP id d16mr2968382pls.28.1591243353758;
        Wed, 03 Jun 2020 21:02:33 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q6sm1193902pff.163.2020.06.03.21.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 21:02:32 -0700 (PDT)
Date:   Wed, 3 Jun 2020 21:02:31 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mm@kvack.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 09/10] treewide: Remove uninitialized_var() usage
Message-ID: <202006032048.E7B1D18A1@keescook>
References: <20200603233203.1695403-1-keescook@chromium.org>
 <20200603233203.1695403-10-keescook@chromium.org>
 <20200604033315.GA1131596@ubuntu-n2-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604033315.GA1131596@ubuntu-n2-xlarge-x86>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 08:33:15PM -0700, Nathan Chancellor wrote:
> On Wed, Jun 03, 2020 at 04:32:02PM -0700, Kees Cook wrote:
> > Using uninitialized_var() is dangerous as it papers over real bugs[1]
> > (or can in the future), and suppresses unrelated compiler warnings
> > (e.g. "unused variable"). If the compiler thinks it is uninitialized,
> > either simply initialize the variable or make compiler changes.
> > 
> > I preparation for removing[2] the[3] macro[4], remove all remaining
> > needless uses with the following script:
> > 
> > git grep '\buninitialized_var\b' | cut -d: -f1 | sort -u | \
> > 	xargs perl -pi -e \
> > 		's/\buninitialized_var\(([^\)]+)\)/\1/g;
> > 		 s:\s*/\* (GCC be quiet|to make compiler happy) \*/$::g;'
> > 
> > drivers/video/fbdev/riva/riva_hw.c was manually tweaked to avoid
> > pathological white-space.
> > 
> > No outstanding warnings were found building allmodconfig with GCC 9.3.0
> > for x86_64, i386, arm64, arm, powerpc, powerpc64le, s390x, mips, sparc64,
> > alpha, and m68k.
> > 
> > [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> > [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> > [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> > [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> <snip>
> 
> > diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
> > index a0f6813f4560..a71fa7204882 100644
> > --- a/arch/powerpc/kvm/book3s_pr.c
> > +++ b/arch/powerpc/kvm/book3s_pr.c
> > @@ -1829,7 +1829,7 @@ static int kvmppc_vcpu_run_pr(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
> >  {
> >  	int ret;
> >  #ifdef CONFIG_ALTIVEC
> > -	unsigned long uninitialized_var(vrsave);
> > +	unsigned long vrsave;
> >  #endif
> 
> This variable is actually unused:
> 
> ../arch/powerpc/kvm/book3s_pr.c:1832:16: warning: unused variable 'vrsave' [-Wunused-variable]
>         unsigned long vrsave;
>                       ^
> 1 warning generated.
> 
> It has been unused since commit 99dae3bad28d ("KVM: PPC: Load/save
> FP/VMX/VSX state directly to/from vcpu struct").
> 
> $ git grep vrsave 99dae3bad28d8fdd32b7bfdd5e2ec7bb2d4d019d arch/powerpc/kvm/book3s_pr.c
> 99dae3bad28d8fdd32b7bfdd5e2ec7bb2d4d019d:arch/powerpc/kvm/book3s_pr.c:  unsigned long uninitialized_var(vrsave);
> 
> I would nuke the whole '#ifdef' block.

Ah, thanks! I wonder why I don't have CONFIG_ALTIVEC in any of my ppc
builds. Hmmm.

-Kees

-- 
Kees Cook
