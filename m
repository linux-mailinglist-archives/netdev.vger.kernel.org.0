Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2EC1D1D7B
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390175AbgEMS3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733310AbgEMS3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 14:29:44 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D31CC061A0C;
        Wed, 13 May 2020 11:29:44 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x10so166636plr.4;
        Wed, 13 May 2020 11:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IllZ9mGMgJpQp5GMigNHhpCQxEKCzjnd2cJjWKYQDwY=;
        b=ij5nlNUkhu9MK9IJF6dVC50Z6cGEL2uSgaFoHS3aDpp/QeF3qBd9wHAduhctvK/22B
         bnwPkCUKjBzgk1L3G6762qEqrCbshZBXyoDAG4KyTiKHoGtX46vpEcbN21Q1TQMzdX2k
         59jrvx9t90nFylm5jlBxSbGbn+blZlLLZBFxKwebWBKDy3q43NTXDPY8IsgXY/r1pAbz
         n5XmBqhZz5FcUwAe+zry1VPkXPD1USKdV7yHoTAvB4ppHLWhREz44dZbLTLuqeB3LJiP
         ZdQ5TyHu88x8EMFAR2BIZ+8dz7GDiGf2mJoGfEzPXVkK72najYRJL/Hu9k8z529Ts3jy
         UNfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IllZ9mGMgJpQp5GMigNHhpCQxEKCzjnd2cJjWKYQDwY=;
        b=ZE4C/xJe59ra+TqPnli88cxS9mDQnoL3xFySEKtfeewKNj6QuehmrDsao00d40fIXa
         4iS7nfkkFLKW3p/MVhZ1R6JwI6poSRer3KSHzJivkv96SreS2kCfrzDtoN30pnwRxOVt
         xkUMcttRvB0tpBFapklMAWJ0V23HhHt4iFbZJGUeiztXCvYxUuDCn7VH66osNFEtIINS
         QNg5BRFM0L5GmXWps7AbboezWFMCv8gKNx49LIDuo1tWV6IXor1so+wMCCuEntlG7EhK
         qc+nU7ZFkEt8gLlbJ5Gim/FOfvyMezIpu1tM91pcitW5n0WehAY45kEnBns7Xm1+B41F
         FScg==
X-Gm-Message-State: AGi0PuY8t2am/rKCOyx/GBQyyeMjtOt6glZOshjCDKfCexYE/X7ksr83
        8/Ll8Mx7zmbrZlye8U0ZNKo=
X-Google-Smtp-Source: APiQypLTDEl6WIfDjqWWEoU07QvS4nfQiFcxGa+OtuEs6nY232pGEFA0s/GbXp8qDQkNfvR3YpbBfw==
X-Received: by 2002:a17:90a:d711:: with SMTP id y17mr36225092pju.11.1589394584016;
        Wed, 13 May 2020 11:29:44 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:ba8f])
        by smtp.gmail.com with ESMTPSA id m18sm16240207pjl.14.2020.05.13.11.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 11:29:43 -0700 (PDT)
Date:   Wed, 13 May 2020 11:29:40 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 7/9] bpf: Compile the BTF id whitelist data in vmlinux
Message-ID: <20200513182940.gil7v5vkthhwck3t@ast-mbp.dhcp.thefacebook.com>
References: <20200506132946.2164578-1-jolsa@kernel.org>
 <20200506132946.2164578-8-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506132946.2164578-8-jolsa@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 03:29:44PM +0200, Jiri Olsa wrote:
> Squeezing in the BTF id whitelist data into vmlinux object
> with BTF section compiled in, with following steps:
> 
>   - generate whitelist data with bpfwl
>     $ bpfwl .tmp_vmlinux.btf kernel/bpf/helpers-whitelist > ${whitelist}.c
> 
>   - compile whitelist.c
>     $ gcc -c -o ${whitelist}.o ${whitelist}.c
> 
>   - keep only the whitelist data in ${whitelist}.o using objcopy
> 
>   - link .tmp_vmlinux.btf and ${whitelist}.o into $btf_vmlinux_bin_o}
>     $ ld -r -o ${btf_vmlinux_bin_o} .tmp_vmlinux.btf ${whitelist}.o
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  Makefile                |  3 ++-
>  scripts/link-vmlinux.sh | 20 +++++++++++++++-----
>  2 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index b0537af523dc..3bb995245592 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -437,6 +437,7 @@ OBJSIZE		= $(CROSS_COMPILE)size
>  STRIP		= $(CROSS_COMPILE)strip
>  endif
>  PAHOLE		= pahole
> +BPFWL		= $(srctree)/tools/bpf/bpfwl/bpfwl
>  LEX		= flex
>  YACC		= bison
>  AWK		= awk
> @@ -493,7 +494,7 @@ GCC_PLUGINS_CFLAGS :=
>  CLANG_FLAGS :=
>  
>  export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC
> -export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE READELF PAHOLE LEX YACC AWK INSTALLKERNEL
> +export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE READELF PAHOLE BPFWL LEX YACC AWK INSTALLKERNEL
>  export PERL PYTHON PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
>  export KBUILD_HOSTCXXFLAGS KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS LDFLAGS_MODULE
>  
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index d09ab4afbda4..dee91c6bf450 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -130,16 +130,26 @@ gen_btf()
>  	info "BTF" ${2}
>  	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
>  
> -	# Create ${2} which contains just .BTF section but no symbols. Add
> +	# Create object which contains just .BTF section but no symbols. Add
>  	# SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all
>  	# deletes all symbols including __start_BTF and __stop_BTF, which will
>  	# be redefined in the linker script. Add 2>/dev/null to suppress GNU
>  	# objcopy warnings: "empty loadable segment detected at ..."
>  	${OBJCOPY} --only-section=.BTF --set-section-flags .BTF=alloc,readonly \
> -		--strip-all ${1} ${2} 2>/dev/null
> -	# Change e_type to ET_REL so that it can be used to link final vmlinux.
> -	# Unlike GNU ld, lld does not allow an ET_EXEC input.
> -	printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16 status=none
> +		--strip-all ${1} 2>/dev/null
> +
> +	# Create object that contains just .BTF_whitelist_* sections generated
> +	# by bpfwl. Same as BTF section, BTF_whitelist_* data will be part of
> +	# the vmlinux image, hence SHF_ALLOC.
> +	whitelist=.btf.vmlinux.whitelist
> +
> +	${BPFWL} ${1} kernel/bpf/helpers-whitelist > ${whitelist}.c
> +	${CC} -c -o ${whitelist}.o ${whitelist}.c
> +	${OBJCOPY} --only-section=.BTF_whitelist* --set-section-flags .BTF=alloc,readonly \
> +                --strip-all ${whitelist}.o 2>/dev/null
> +
> +	# Link BTF and BTF_whitelist objects together
> +	${LD} -r -o ${2} ${1} ${whitelist}.o

Thank you for working on it!
Looks great to me overall. In the next rev please drop RFC tag.

My only concern is this extra linking step. How many extra seconds does it add?

Also in patch 3:
+               func = func__find(str);
+               if (func)
+                       func->id = id;
which means that if somebody mistyped the name or that kernel function
got renamed there will be no warnings or errors.
I think it needs to fail the build instead.

If additional linking step takes another 20 seconds it could be a reason
to move the search to run-time.
We already have that with struct bpf_func_proto->btf_id[].
Whitelist could be something similar.
I think this mechanism will be reused for unstable helpers and other
func->btf_id mappings, so 'bpfwl' name would change eventually.
It's not white list specific. It generates a mapping of names to btf_ids.
Doing it at build time vs run-time is a trade off and it doesn't have
an obvious answer.
