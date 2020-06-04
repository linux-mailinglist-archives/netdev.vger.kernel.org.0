Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154EB1EDBAD
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 05:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgFDDdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 23:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgFDDdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 23:33:21 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EDFC03E96D;
        Wed,  3 Jun 2020 20:33:19 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id 25so2927725oiy.13;
        Wed, 03 Jun 2020 20:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8Faii11PvSo51bdsAemmq3+A0d7oNRL4/GLZ67cBSMg=;
        b=An50kzaFvA39pC4h/8bP4oIWOqTSG046GlYB5+emgXeZszQTtbXKqSjDjHWmw8n8um
         VXpLlrq83m2ZAS8J26v56FTDUjfbdw4fWaYAjEK9Ox20DjsyL1kabqtQvJ0qaNA6AN6x
         WQHzqT/rIk17+lobg6a1Qz4niujZV9KifIFoGU6CnMcUxFKQqfbbxVvC4XVpIL5SSTtt
         6xGwnGkCkYTcRnL3OaIoBi5ReA1N/8hWVCv9k4QJ2ieUjD5HXDXWHDv6XZ9+0M+W+p2j
         GHjogeet/zLPYDJFnvbD/NGsLeEzoRiqyu6IiidyEX/Bv9x5fa84lURyrkrcSmOp3voL
         uKqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8Faii11PvSo51bdsAemmq3+A0d7oNRL4/GLZ67cBSMg=;
        b=cn5EHlwGGW1f0zzJWjK8IWiC7Lmx1BXuDjrrN0yry05CPX4ek3L8XW0g6ab1ocQBEx
         0zjQyciDKeOlbMZPq/+zIW7fuW7Sq33+ysMevEPLRuaN6BUxzgCTBjkAjTdCNSSzuWb+
         nkyGJBgAG7gZ6oCEUF38dqhSlYINOADbPtFqlCdfuBdf7bbFX6nJJcV2MFvYFYGTCsXC
         qxYJ3ow6VrLBeYuXk7erXVqJD2W8TjhPF+niUS/qPy7d8TYP6djnPBB42v9kDeW2efdZ
         +gAfZwEjYjERAfA/EiKWjMVXKOqTIGHpXwJ0V/VWHNKAQXfEsTpipuN8zULdnwIqmxPC
         BT5w==
X-Gm-Message-State: AOAM531Rbdbx0Ogow2ZEFqMSf/nWIypRlEeTYf54IlA/P8H+rHX8ZbbW
        jvTkTs6lxpcmTiAfCXTjhOs=
X-Google-Smtp-Source: ABdhPJwnzfVVb4uCTFG1lxg30QZrwlILRC7pC1WmnFYGEgON5rzpjMpDI7aYXPTUb98IobrtcgZC+g==
X-Received: by 2002:aca:b707:: with SMTP id h7mr1938490oif.174.1591241599191;
        Wed, 03 Jun 2020 20:33:19 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:4111:8b00::3])
        by smtp.gmail.com with ESMTPSA id n60sm327816otn.75.2020.06.03.20.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 20:33:17 -0700 (PDT)
Date:   Wed, 3 Jun 2020 20:33:15 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Kees Cook <keescook@chromium.org>
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
Message-ID: <20200604033315.GA1131596@ubuntu-n2-xlarge-x86>
References: <20200603233203.1695403-1-keescook@chromium.org>
 <20200603233203.1695403-10-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603233203.1695403-10-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 04:32:02PM -0700, Kees Cook wrote:
> Using uninitialized_var() is dangerous as it papers over real bugs[1]
> (or can in the future), and suppresses unrelated compiler warnings
> (e.g. "unused variable"). If the compiler thinks it is uninitialized,
> either simply initialize the variable or make compiler changes.
> 
> I preparation for removing[2] the[3] macro[4], remove all remaining
> needless uses with the following script:
> 
> git grep '\buninitialized_var\b' | cut -d: -f1 | sort -u | \
> 	xargs perl -pi -e \
> 		's/\buninitialized_var\(([^\)]+)\)/\1/g;
> 		 s:\s*/\* (GCC be quiet|to make compiler happy) \*/$::g;'
> 
> drivers/video/fbdev/riva/riva_hw.c was manually tweaked to avoid
> pathological white-space.
> 
> No outstanding warnings were found building allmodconfig with GCC 9.3.0
> for x86_64, i386, arm64, arm, powerpc, powerpc64le, s390x, mips, sparc64,
> alpha, and m68k.
> 
> [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

<snip>

> diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
> index a0f6813f4560..a71fa7204882 100644
> --- a/arch/powerpc/kvm/book3s_pr.c
> +++ b/arch/powerpc/kvm/book3s_pr.c
> @@ -1829,7 +1829,7 @@ static int kvmppc_vcpu_run_pr(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
>  {
>  	int ret;
>  #ifdef CONFIG_ALTIVEC
> -	unsigned long uninitialized_var(vrsave);
> +	unsigned long vrsave;
>  #endif

This variable is actually unused:

../arch/powerpc/kvm/book3s_pr.c:1832:16: warning: unused variable 'vrsave' [-Wunused-variable]
        unsigned long vrsave;
                      ^
1 warning generated.

It has been unused since commit 99dae3bad28d ("KVM: PPC: Load/save
FP/VMX/VSX state directly to/from vcpu struct").

$ git grep vrsave 99dae3bad28d8fdd32b7bfdd5e2ec7bb2d4d019d arch/powerpc/kvm/book3s_pr.c
99dae3bad28d8fdd32b7bfdd5e2ec7bb2d4d019d:arch/powerpc/kvm/book3s_pr.c:  unsigned long uninitialized_var(vrsave);

I would nuke the whole '#ifdef' block.

Cheers,
Nathan
