Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E0A49BFBE
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 00:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbiAYXv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 18:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiAYXv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 18:51:27 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D49FC06161C;
        Tue, 25 Jan 2022 15:51:26 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id z5so6986270plg.8;
        Tue, 25 Jan 2022 15:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=++5iX4mvdzpdgf8jzEfgSE8X/Ff/aR2LGCChym4KTt8=;
        b=WOlWdF8X2wmxR6au/jzbHGZJndG/0nrtx/pWqr4WcHAbVKXVqxleXWN717gtr3VMKE
         O0FZF7zYCDypRd5ocKiFcb9YajgDlxF+VU+BrGKyMiZNLV5xo5igo6XvaVQll8WItWcP
         l06YKo31dXV/DK3ADf602vsHf28Z2+ccdtgM9YzAuDxytSR1YThBUXcDYwu5SCxTyplS
         bbdBaY0AhTHE9YoSi2ZlKLKSr9zp1jODe2TsoeydIC8clvR7Jo3lQXL/O7jRteni22Kq
         WiTUhobhvY6OvTP+Pfi72+FOtV3jjRHpiDanFcl20g3lsqMmDIvyd9s4MS+B+a/lRUuH
         naag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=++5iX4mvdzpdgf8jzEfgSE8X/Ff/aR2LGCChym4KTt8=;
        b=v/FEZOk2DImRMEdXMa73tufA0FAbxSx50wfmOmGBafUNcjg+HWLWLhzJf3TTRikhYk
         /Iewzj/1C1tXyb11Zrb4sC3DelOclvjRWz4RnZIa+2kNC7IQtkdBeWY+W+7Bsz6VFndo
         HZALIte11d0yPj3QupUYxlkRhbvQRHYACfZRuj3PRXLTRU9ep+6gb5IjoXbKu/XPUYN6
         93uxNwvTPqCG14hudhvGLYlbgpApycxZzwrfV2B6BOC+KwdlvSO5ZzCnTXPw/ibctAGI
         4cgeJjHotAsfcSvVUfaDXZ79F4BO9vis69leJ/Cxgxo0nM4HEqUG7zn9EhTMZ93fDs15
         MrGw==
X-Gm-Message-State: AOAM530Ygxe4A5zx9pExU0IdMGlusMtPn7J6IO5pCa1U8Tl/QCZ0UeeX
        ahM0VWWEve2rf183+UOgnfc=
X-Google-Smtp-Source: ABdhPJyTga5l60A6u9EfrDF0sogmd/aZSDOXMZlBWPM+IQXHemEs4zZ1GSdCwQyHwRxFTvPT38+wMA==
X-Received: by 2002:a17:902:ea0d:b0:14b:4c26:f42f with SMTP id s13-20020a170902ea0d00b0014b4c26f42fmr11076437plg.125.1643154685721;
        Tue, 25 Jan 2022 15:51:25 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id nv13sm1436998pjb.18.2022.01.25.15.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 15:51:24 -0800 (PST)
Date:   Wed, 26 Jan 2022 05:19:36 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     sdf@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next] bpf: fix register_btf_kfunc_id_set for
 !CONFIG_DEBUG_INFO_BTF
Message-ID: <20220125234936.qal3xzsigkpauofj@apollo.legion>
References: <20220125003845.2857801-1-sdf@google.com>
 <20220125021008.lo6k6lmpleoli73r@apollo.legion>
 <YfAqa0iVZ8IHiUtH@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfAqa0iVZ8IHiUtH@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 10:20:51PM IST, sdf@google.com wrote:
> On 01/25, Kumar Kartikeya Dwivedi wrote:
> > On Tue, Jan 25, 2022 at 06:08:45AM IST, Stanislav Fomichev wrote:
> > > Commit dee872e124e8 ("bpf: Populate kfunc BTF ID sets in struct btf")
> > > breaks loading of some modules when CONFIG_DEBUG_INFO_BTF is not set.
> > > register_btf_kfunc_id_set returns -ENOENT to the callers when
> > > there is no module btf. Let's return 0 (success) instead to let
> > > those modules work in !CONFIG_DEBUG_INFO_BTF cases.
> > >
> > > Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > Fixes: dee872e124e8 ("bpf: Populate kfunc BTF ID sets in struct btf")
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
>
> > Thanks for the fix.
>
> > >  kernel/bpf/btf.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > index 57f5fd5af2f9..24205c2d4f7e 100644
> > > --- a/kernel/bpf/btf.c
> > > +++ b/kernel/bpf/btf.c
> > > @@ -6741,7 +6741,7 @@ int register_btf_kfunc_id_set(enum bpf_prog_type
> > prog_type,
> > >
> > >  	btf = btf_get_module_btf(kset->owner);
> > >  	if (IS_ERR_OR_NULL(btf))
> > > -		return btf ? PTR_ERR(btf) : -ENOENT;
> > > +		return btf ? PTR_ERR(btf) : 0;
>
> > I think it should still be an error when CONFIG_DEBUG_INFO_BTF is enabled.
>
> > How about doing it differently:
>
> > Make register_btf_kfunc_id_set, btf_kfunc_id_set_contains, and functions
> > only
> > called by them all dependent upon CONFIG_DEBUG_INFO_BTF. Then code picks
> > the
> > static inline definition from the header and it works fine with 'return
> > 0' and
> > 'return false'.
>
> > In case CONFIG_DEBUG_INFO_BTF is enabled, but
> > CONFIG_DEBUG_INFO_BTF_MODULES is
> > disabled, we can do the error upgrade but inside btf_get_module_btf.
>
> > I.e. extend the comment it has to say that when it returns NULL, it
> > means there
> > is no BTF (hence nothing to do), but it never returns NULL when
> > DEBUF_INFO_BTF*
> > is enabled, but upgrades the btf == NULL to a PTR_ERR(-ENOENT), because
> > the btf
> > should be there when the options are enabled.
>
> > e.g. If CONFIG_DEBUG_INFO_BTF=y but CONFIG_DEBUG_INFO_BTF_MODULES=n, it
> > can
> > return NULL for owner == <some module ptr>, but not for owner == NULL
> > (vmlinux),
> > because CONFIG_DEBUG_INFO_BTF is set. If both are disabled, it can
> > return NULL
> > for both. If both are set, it will never return NULL.
>
> > Then the caller can just special case NULL depending on their usage.
>
> > And your current diff remains same combined with the above changes.
>
> > WDYT? Does this look correct or did I miss something important?
>
> I initially started with this approach, adding ifdef
> CONFIG_DEBUG_INFO_BTF/CONFIG_DEBUG_INFO_BTF_MODULES, but it quickly
> became a bit ugly :-( I can retry if you prefer, but how about, instead,
> we handle it explicitly this way in the caller?
>
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 24205c2d4f7e..e66f60b288d0 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -6740,8 +6740,19 @@ int register_btf_kfunc_id_set(enum bpf_prog_type
> prog_type,
>  	int ret;
>
>  	btf = btf_get_module_btf(kset->owner);
> -	if (IS_ERR_OR_NULL(btf))
> -		return btf ? PTR_ERR(btf) : 0;
> +	if (!btf) {
> +		if (!kset->owner && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
> +			pr_err("missing vmlinux BTF\n");
> +			return -ENOENT;
> +		}
> +		if (kset->owner && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES)) {
> +			pr_err("missing module BTF\n");
> +			return -ENOENT;
> +		}
> +		return 0;
> +	}
> +	if (IS_ERR(btf))
> +		return PTR_ERR(btf);
>
>  	hook = bpf_prog_type_to_kfunc_hook(prog_type);
>  	ret = btf_populate_kfunc_set(btf, hook, kset);
>
> Basically, treat as error the cases we care about:
> - non-module && CONFIG_DEBUG_INFO_BTF -> ENOENT
> - module && CONFIG_DEBUG_INFO_BTF_MODULES -> ENOENT
>
> Also give the user some hint on what went wrong; insmod gave me "Unknown
> symbol in module, or unknown parameter (see dmesg)" for ENOENT (and
> dmesg was empty).

Alright, LGTM. Also maybe we can say "missing vmlinux BTF, cannot register
kfuncs" instead.

--
Kartikeya
