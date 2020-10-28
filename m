Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC79B29D30D
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgJ1Vjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbgJ1VjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:39:22 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3420AC0613CF;
        Wed, 28 Oct 2020 14:39:22 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 133so526181pfx.11;
        Wed, 28 Oct 2020 14:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZiMASukYVoE0kgKw+YgZ0gSNXM/yi/Ajkhcho3m/4b4=;
        b=ZrFkjw61/lM/NZxmVVDYl7Nb0B8gjjb/Yo9gSZlNlQYIbJhBjUgXPIaFBlCsnhsTtq
         vVgM1Q9Zpw4a1uQCya5QKM8GhgtptugScRq563jCGImuebJGTFCoMTrgMxCZ/+abweZM
         d/4nsCSQ97xaxSDCxKWfFavVHgpRnxysYaQ0EgUK1sZiBWFIK7+MS15MKBjUGIjMpIdX
         oQWhXNcjc60To/A30mBEJVfVSV1TUrHwytf6ZlR1OEKIymfcObPUKfyzFjgp+uW6bR7g
         7qT/K9Yn5+hEe+par2iArOofUJj2mXvJiMFM9h8+v7W9tmsEaTXh2EXxGLxyHH6SZhP3
         9/MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZiMASukYVoE0kgKw+YgZ0gSNXM/yi/Ajkhcho3m/4b4=;
        b=sb+xpY9u1EdMsySpM136b/T0D6X8k1uS44qaMaxD8FALiHIfVMs05TziC/XkoIxDmt
         o7QzonRzZy2f1WTZAVVLWTeIvr7cXs82M6eqNtjalRFBiYmY2/bchSfEMFAPiacMld1+
         tTNR5yHPXBt5NRyhLLzsQG6AUtyEFpcJVirR+NnOnU3ENYc0mRiY+uTtoMmIHDHaFe4R
         bVu8QCvn/i05d9DW+OlySyP/WagPA//HdyNaoyRPFK6MnZ9QOo0EUe4Amjr3pBkULMqJ
         H8BqLIqXYZBmdxyWr/K52qJZM9NGs5KcLD0XI4ckiZqhm9MSj5rdZ5jJkFqECmGBEpA5
         ZJtQ==
X-Gm-Message-State: AOAM530JT0t7Qx571wonTTGsIf8bEzPhEDFuL2GxYOj3VMOkv+lXjQZo
        iV4S0Dta6JXX4DRqaLnlmAY=
X-Google-Smtp-Source: ABdhPJx+/5NAcZguIVKdlG2lweqIkHIfZXBdnl5vRIeXYI89zsnQHqvQg5XGjrA/II5db5RhSHV+sg==
X-Received: by 2002:a63:f502:: with SMTP id w2mr1197043pgh.186.1603921161712;
        Wed, 28 Oct 2020 14:39:21 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::4:1c8])
        by smtp.gmail.com with ESMTPSA id z20sm526757pfk.199.2020.10.28.14.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 14:39:20 -0700 (PDT)
Date:   Wed, 28 Oct 2020 14:39:03 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, arnd@arndb.de,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 1/2] bpf: don't rely on GCC __attribute__((optimize))
 to disable GCSE
Message-ID: <20201028213903.fvdjydadqt6tx765@ast-mbp.dhcp.thefacebook.com>
References: <20201028171506.15682-1-ardb@kernel.org>
 <20201028171506.15682-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028171506.15682-2-ardb@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 06:15:05PM +0100, Ard Biesheuvel wrote:
> Commit 3193c0836 ("bpf: Disable GCC -fgcse optimization for
> ___bpf_prog_run()") introduced a __no_fgcse macro that expands to a
> function scope __attribute__((optimize("-fno-gcse"))), to disable a
> GCC specific optimization that was causing trouble on x86 builds, and
> was not expected to have any positive effect in the first place.
> 
> However, as the GCC manual documents, __attribute__((optimize))
> is not for production use, and results in all other optimization
> options to be forgotten for the function in question. This can
> cause all kinds of trouble, but in one particular reported case,
> it causes -fno-asynchronous-unwind-tables to be disregarded,
> resulting in .eh_frame info to be emitted for the function.
> 
> This reverts commit 3193c0836, and instead, it disables the -fgcse
> optimization for the entire source file, but only when building for
> X86 using GCC with CONFIG_BPF_JIT_ALWAYS_ON disabled. Note that the
> original commit states that CONFIG_RETPOLINE=n triggers the issue,
> whereas CONFIG_RETPOLINE=y performs better without the optimization,
> so it is kept disabled in both cases.
> 
> Fixes: 3193c0836 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> Link: https://lore.kernel.org/lkml/CAMuHMdUg0WJHEcq6to0-eODpXPOywLot6UD2=GFHpzoj_hCoBQ@mail.gmail.com/
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  include/linux/compiler-gcc.h   | 2 --
>  include/linux/compiler_types.h | 4 ----
>  kernel/bpf/Makefile            | 6 +++++-
>  kernel/bpf/core.c              | 2 +-
>  4 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index d1e3c6896b71..5deb37024574 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -175,5 +175,3 @@
>  #else
>  #define __diag_GCC_8(s)
>  #endif
> -
> -#define __no_fgcse __attribute__((optimize("-fno-gcse")))

See my reply in the other thread.
I prefer
-#define __no_fgcse __attribute__((optimize("-fno-gcse")))
+#define __no_fgcse __attribute__((optimize("-fno-gcse,-fno-omit-frame-pointer")))

Potentially with -fno-asynchronous-unwind-tables.

__attribute__((optimize("")) is not as broken as you're claiming to be.
It has quirky gcc internal logic, but it's still widely used
in many software projects.
