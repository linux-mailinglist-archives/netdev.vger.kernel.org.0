Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D060949AA7E
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1325973AbiAYDjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1312564AbiAYCn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 21:43:26 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35263C0C0931;
        Mon, 24 Jan 2022 18:11:51 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so1166219pjb.1;
        Mon, 24 Jan 2022 18:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EFQ1k4ZN7I/Ow+USrJmwsW8neyTYenvykXnDvbnQobg=;
        b=aOYnawrQ8d0OuySce9SpzDe4pBWPfVW7hA/9huUix+JIT/+igjhw1pvpbk73ozC3X7
         0kr+Vt07t+S9PMp3HaAcqbrVdZzaO1sQHgodeVNThu45lsN0+L3YKmPT/pOcEcSjKy0K
         tRQBeEO2e7pF4iVCziL8y2UJHNaZYqTbgjKeflk45xS69pDjPh6hWatcXoYQwM3HlhVL
         0MOHs6qd4BYeXfmYZG54g4EnG/Iv4FvubfIsWYlISP+BQkslNy1vvrkRy9Qb8JdxYUeI
         ghvCEMYTjEN67oDNAhvVvRRAGP03zya/N+s8vOu4sq/j04SUT2bLfJ8upcLO00yUlyum
         V+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EFQ1k4ZN7I/Ow+USrJmwsW8neyTYenvykXnDvbnQobg=;
        b=UVnxlSIx+TWe31b0vO913kfxOzrsLXhhd26NqqhbdqiR7ghBb8B7/gTwpXJu09oNAp
         J+c8WKpBqSValKs0HgkZ8fnCdtIag2KKVetBiyrZA979YCRQ4yHCpPqCxPoQI3jrdXI8
         D5+mUzBTUhkGtwgHwAvhcDmn0CQSWhkDrjHp3KntxkJdb2UWyFzkmSWFUj+JN50jb6v8
         SdeS7LWOOVUOp5qXvJTD6kCdLEn85pog/15lhXehgbNTa+YK98ZVCgC1kRS7ixk7y6Jv
         yoWJ/WJhQoLZL4SkwvFiYkmlCGT5CxdN3O56QR1ihDnsapwXEQoOezY6ycp5AJOQ7A20
         2lGQ==
X-Gm-Message-State: AOAM532Mkl9A2eTy2SuTWOIJDm6qEP5Zsns11KDLHOC+xYwz+oh+IWAp
        ElQg5U996x9nSKw3fa/4Vws=
X-Google-Smtp-Source: ABdhPJz9yMsMLj9CwgG9CpkEMXhz8OyqSH+s/38VzqPIMl3vu4Bp8tp+yw2e68T/45pARSWm51F/cg==
X-Received: by 2002:a17:90b:1d04:: with SMTP id on4mr1221707pjb.26.1643076710558;
        Mon, 24 Jan 2022 18:11:50 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id d12sm6587504pgk.29.2022.01.24.18.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 18:11:50 -0800 (PST)
Date:   Tue, 25 Jan 2022 07:40:08 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next] bpf: fix register_btf_kfunc_id_set for
 !CONFIG_DEBUG_INFO_BTF
Message-ID: <20220125021008.lo6k6lmpleoli73r@apollo.legion>
References: <20220125003845.2857801-1-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125003845.2857801-1-sdf@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 06:08:45AM IST, Stanislav Fomichev wrote:
> Commit dee872e124e8 ("bpf: Populate kfunc BTF ID sets in struct btf")
> breaks loading of some modules when CONFIG_DEBUG_INFO_BTF is not set.
> register_btf_kfunc_id_set returns -ENOENT to the callers when
> there is no module btf. Let's return 0 (success) instead to let
> those modules work in !CONFIG_DEBUG_INFO_BTF cases.
>
> Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Fixes: dee872e124e8 ("bpf: Populate kfunc BTF ID sets in struct btf")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Thanks for the fix.

>  kernel/bpf/btf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 57f5fd5af2f9..24205c2d4f7e 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -6741,7 +6741,7 @@ int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
>
>  	btf = btf_get_module_btf(kset->owner);
>  	if (IS_ERR_OR_NULL(btf))
> -		return btf ? PTR_ERR(btf) : -ENOENT;
> +		return btf ? PTR_ERR(btf) : 0;

I think it should still be an error when CONFIG_DEBUG_INFO_BTF is enabled.

How about doing it differently:

Make register_btf_kfunc_id_set, btf_kfunc_id_set_contains, and functions only
called by them all dependent upon CONFIG_DEBUG_INFO_BTF. Then code picks the
static inline definition from the header and it works fine with 'return 0' and
'return false'.

In case CONFIG_DEBUG_INFO_BTF is enabled, but CONFIG_DEBUG_INFO_BTF_MODULES is
disabled, we can do the error upgrade but inside btf_get_module_btf.

I.e. extend the comment it has to say that when it returns NULL, it means there
is no BTF (hence nothing to do), but it never returns NULL when DEBUF_INFO_BTF*
is enabled, but upgrades the btf == NULL to a PTR_ERR(-ENOENT), because the btf
should be there when the options are enabled.

e.g. If CONFIG_DEBUG_INFO_BTF=y but CONFIG_DEBUG_INFO_BTF_MODULES=n, it can
return NULL for owner == <some module ptr>, but not for owner == NULL (vmlinux),
because CONFIG_DEBUG_INFO_BTF is set. If both are disabled, it can return NULL
for both. If both are set, it will never return NULL.

Then the caller can just special case NULL depending on their usage.

And your current diff remains same combined with the above changes.

WDYT? Does this look correct or did I miss something important?

PS: While we are at it, maybe also add a NULL check for btf and return false
from btf_kfunc_id_set_contains, even though on current inspection it doesn't
seem to be a problem, since all users use find_kfunc_desc_btf which handles that
case.

>
>  	hook = bpf_prog_type_to_kfunc_hook(prog_type);
>  	ret = btf_populate_kfunc_set(btf, hook, kset);
> --
> 2.35.0.rc0.227.g00780c9af4-goog
>

--
Kartikeya
