Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6152A253469
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgHZQJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbgHZQI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:08:57 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50BBC061574;
        Wed, 26 Aug 2020 09:08:55 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id g6so1080196pjl.0;
        Wed, 26 Aug 2020 09:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MoHvmadsGuY4v+aAFE/hESek8nTGcOx9XgTS+CORF2Q=;
        b=iyqgL1UIutqJ3kxUcf2gk895U0y6p58B8bcQjUJEPL6q3+7z5tRtt1niBzqmDyKuRZ
         6c5nLPHKWxnO2hxjv9z93hSXrDy2AENZXUhG1KKZEd2GlMC7MMRxeP9A1YnXsNvZcrji
         JOcqk3NRPDR2OUzxPRXfm0By2bvVN/AFQOZ8ChIPp5ix+rJmlovMocmIvRbMqNySVxn5
         niJMyxZWxYDvEtFSh6QYefVWOcAHp5VNScW3TtnsXK0IQx3ghO2yeNBOCPv3zKRgTssw
         9RmjBfjp96chpTfyhi9vQWok7CP8ijOuRrD+VLuHJ6P1eAD0vkUEBECEKtNCK5cmSPa/
         EsRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MoHvmadsGuY4v+aAFE/hESek8nTGcOx9XgTS+CORF2Q=;
        b=hjhaV10xiLmvehZO+CtTVTY+Ez6MY7tNMRHUO2Rqlqjec7qVgqzUfKO2RIOBVlUUGS
         bD67v9dYdPM/AMe3X5n9JTWDOu5RbBvEdDoIYqbSCPSlNG43fDe8pyzNWzzsbyjSs5Bn
         xdJNrUQ+WfnuLagALGcsF74zO9ZN6+mysHlAqtI7VBktn6VzreTQndb3H39yBIML0ZWt
         878ch0b+mLMLs4f0vs4osWN2BDr8PKpYY9INWfCG1cAwuyifYwRbB7OJWXcisQbXfFKF
         44T7QFcyqJH+CQQfbC9rfLlCcKekgojoqSWZmGwD9yey24yrhVAaDenI3io8VS+J2p81
         ASrw==
X-Gm-Message-State: AOAM533QgRkUWNHcMjevUYXdFTqO13S5xpbFIlrnzFyNwQF6ywyJbblZ
        R1QaNLqX2v9jnP/JpGmLz5g=
X-Google-Smtp-Source: ABdhPJweDIoBQBvEisXUzLq5yU93eoDIx5UHkNS4Zxu6oI4JpHxlROVH62XqXscmneEWJ8G8CbuKPg==
X-Received: by 2002:a17:90a:a61:: with SMTP id o88mr6800820pjo.201.1598458135222;
        Wed, 26 Aug 2020 09:08:55 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:a814])
        by smtp.gmail.com with ESMTPSA id j35sm2732384pgi.91.2020.08.26.09.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 09:08:54 -0700 (PDT)
Date:   Wed, 26 Aug 2020 09:08:52 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH bpf-next] libbpf: fix compilation warnings for 64-bit
 printf args
Message-ID: <20200826160852.e4hnkyvg2kzrtzjj@ast-mbp.dhcp.thefacebook.com>
References: <20200826030922.2591203-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826030922.2591203-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 08:09:21PM -0700, Andrii Nakryiko wrote:
> Add __pu64 and __ps64 (sort of like "printf u64 and s64") for libbpf-internal
> use only in printf-like situations to avoid compilation warnings due to
> %lld/%llu mismatch with a __u64/__s64 due to some architecture defining the
> latter as either `long` or `long long`. Use that on all %lld/%llu cases in
> libbpf.c.
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Fixes: eacaaed784e2 ("libbpf: Implement enum value-based CO-RE relocations")
> Fixes: 50e09460d9f8 ("libbpf: Skip well-known ELF sections when iterating ELF")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c          | 15 ++++++++-------
>  tools/lib/bpf/libbpf_internal.h | 11 +++++++++++
>  2 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 2e2523d8bb6d..211eb0d9020c 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1529,12 +1529,12 @@ static int set_kcfg_value_num(struct extern_desc *ext, void *ext_val,
>  {
>  	if (ext->kcfg.type != KCFG_INT && ext->kcfg.type != KCFG_CHAR) {
>  		pr_warn("extern (kcfg) %s=%llu should be integer\n",
> -			ext->name, (unsigned long long)value);
> +			ext->name, (__pu64)value);
>  		return -EINVAL;
>  	}
>  	if (!is_kcfg_value_in_range(ext, value)) {
>  		pr_warn("extern (kcfg) %s=%llu value doesn't fit in %d bytes\n",
> -			ext->name, (unsigned long long)value, ext->kcfg.sz);
> +			ext->name, (__pu64)value, ext->kcfg.sz);
>  		return -ERANGE;
>  	}
>  	switch (ext->kcfg.sz) {
> @@ -2823,7 +2823,8 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
>  			obj->efile.bss = data;
>  			obj->efile.bss_shndx = idx;
>  		} else {
> -			pr_info("elf: skipping section(%d) %s (size %zu)\n", idx, name, sh.sh_size);
> +			pr_info("elf: skipping section(%d) %s (size %zu)\n", idx, name,
> +				(size_t)sh.sh_size);
>  		}
>  	}
>  
> @@ -5244,7 +5245,7 @@ static int bpf_core_patch_insn(struct bpf_program *prog,
>  		if (res->validate && imm != orig_val) {
>  			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LDIMM64) value: got %llu, exp %u -> %u\n",
>  				bpf_program__title(prog, false), relo_idx,
> -				insn_idx, imm, orig_val, new_val);
> +				insn_idx, (__pu64)imm, orig_val, new_val);
>  			return -EINVAL;
>  		}
>  
> @@ -5252,7 +5253,7 @@ static int bpf_core_patch_insn(struct bpf_program *prog,
>  		insn[1].imm = 0; /* currently only 32-bit values are supported */
>  		pr_debug("prog '%s': relo #%d: patched insn #%d (LDIMM64) imm64 %llu -> %u\n",
>  			 bpf_program__title(prog, false), relo_idx, insn_idx,
> -			 imm, new_val);
> +			 (__pu64)imm, new_val);
>  		break;
>  	}
>  	default:
> @@ -7782,8 +7783,8 @@ static int bpf_object__collect_st_ops_relos(struct bpf_object *obj,
>  		st_ops = map->st_ops;
>  		pr_debug("struct_ops reloc %s: for %lld value %lld shdr_idx %u rel.r_offset %zu map->sec_offset %zu name %d (\'%s\')\n",
>  			 map->name,
> -			 (long long)(rel.r_info >> 32),
> -			 (long long)sym.st_value,
> +			 (__ps64)(rel.r_info >> 32),
> +			 (__ps64)sym.st_value,
>  			 shdr_idx, (size_t)rel.r_offset,
>  			 map->sec_offset, sym.st_name, name);
>  
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index 4d1c366fca2c..7ad3c4b9917c 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -69,6 +69,17 @@ extern void libbpf_print(enum libbpf_print_level level,
>  			 const char *format, ...)
>  	__attribute__((format(printf, 2, 3)));
>  
> +/* These types are for casting 64-bit arguments of printf-like functions to
> + * avoid compiler warnings on various architectures that define size_t, __u64,
> + * uint64_t, etc as either unsigned long or unsigned long long (similarly for
> + * signed variants). Use these typedefs only for these purposes. Alternative
> + * is PRIu64 (and similar) macros, requiring stitching printf format strings
> + * which are extremely ugly and should be avoided in libbpf code base. With
> + * arguments casted to __pu64/__ps64, always use %llu/%lld in format string.
> + */
> +typedef unsigned long long __pu64;
> +typedef long long __ps64;

I think these extra typedefs will cause confusion. Original approach
of open coding type casts to long long and unsigned long long is imo cleaner.
