Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E256BA22C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 23:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjCNWPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 18:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjCNWO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 18:14:29 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868D93B0F8;
        Tue, 14 Mar 2023 15:13:54 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q16so15702298wrw.2;
        Tue, 14 Mar 2023 15:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678831966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qrgGQA2tyR+reLrtZ5whteGjP4sWvnWfOZPTVunlkec=;
        b=dootni8CEgUsi8N+v99TYqgtssTXuvVp/SJIRgJDBFOVvoKGidWBw5oOLU/rK6wUYZ
         cBx4OYl7vRuuganKp+xfQJnhf9PvhzTSn8oqx+UwcFdyCrztDVJrGJ0BoRA61QY8n9dB
         bXtvntpsQFVfiKpejt/sGKe1X6no2rXrbdem1rvGl/XHFUtjsWOwrpmvjDfAgkESqqOP
         vPVGUCUMFdm8SPYFo+vC36K2c8rg80rhwuO7T0kmx3c3sTAYmhbzwD7QW75zmHiYXKda
         J2kdWKdWYyMBKkKuiGaS2WSjV4fjOtcq3NuLxGVaGGfoL4cZqZVpDYgM2dKFjLbFo5l9
         xkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678831966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qrgGQA2tyR+reLrtZ5whteGjP4sWvnWfOZPTVunlkec=;
        b=xtRgx2vqdK18atgVeEVtIUtFif7Uj2hF+4+5VeLZf8xSyheIP7OvgCOY+/woeNN8TF
         qmXPHGjosyXMOQRh2wVNsP50sEz93Cv9lhaqKvB0wacxd936L72F8dm48lpW7Ddce8/u
         P2BwvyIUKo6mZC3pmT6+vLPmtZxRXgK3Kr2CuTp6W17i4bca6ktvXOFAmr5mNow/GEZV
         hDPpVMwcvpeammTVGB2WGiWfiBjrAez/Hjjubil3uoiG1/lV/sbIdiR70mJgyAIGB4Kr
         SiBFx2C8sL3eI+d/fATcE9MJBzHheSsoadlUHeItSQrgtfjK5TJH5t7pW0T4jHDc7Wmy
         dpVw==
X-Gm-Message-State: AO0yUKW6HlZIK5XE8FLZ+in97KtVj+yZY/ZKSNi+X6gDHLJdkoaz7rEQ
        pW3FL7tN68mvAnHDp99HrwQ=
X-Google-Smtp-Source: AK7set/Oe1mK8ERAeym3Py4UdCVU7k6qkgj+mP/p9KCj/wwe0GCzObLYhzO768PXTzSuipVfAJ9mgw==
X-Received: by 2002:a5d:4002:0:b0:2ce:a0c2:d9ed with SMTP id n2-20020a5d4002000000b002cea0c2d9edmr363419wrp.32.1678831966299;
        Tue, 14 Mar 2023 15:12:46 -0700 (PDT)
Received: from localhost (host86-146-209-214.range86-146.btcentralplus.com. [86.146.209.214])
        by smtp.gmail.com with ESMTPSA id u7-20020a5d4687000000b002c5544b3a69sm3010241wrq.89.2023.03.14.15.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 15:12:45 -0700 (PDT)
Date:   Tue, 14 Mar 2023 22:12:44 +0000
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 3/7] mm, page_flags: remove PG_slob_free
Message-ID: <eae5fe2b-aa09-47be-a039-6f518bc4d678@lucifer.local>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <20230310103210.22372-4-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310103210.22372-4-vbabka@suse.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 11:32:05AM +0100, Vlastimil Babka wrote:
> With SLOB removed we no longer need the PG_slob_free alias for
> PG_private. Also update tools/mm/page-types.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/page-flags.h | 4 ----
>  tools/mm/page-types.c      | 6 +-----
>  2 files changed, 1 insertion(+), 9 deletions(-)
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index a7e3a3405520..2bdc41cb0594 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -174,9 +174,6 @@ enum pageflags {
>  	/* Remapped by swiotlb-xen. */
>  	PG_xen_remapped = PG_owner_priv_1,
>
> -	/* SLOB */
> -	PG_slob_free = PG_private,
> -
>  #ifdef CONFIG_MEMORY_FAILURE
>  	/*
>  	 * Compound pages. Stored in first tail page's flags.
> @@ -483,7 +480,6 @@ PAGEFLAG(Active, active, PF_HEAD) __CLEARPAGEFLAG(Active, active, PF_HEAD)
>  PAGEFLAG(Workingset, workingset, PF_HEAD)
>  	TESTCLEARFLAG(Workingset, workingset, PF_HEAD)
>  __PAGEFLAG(Slab, slab, PF_NO_TAIL)
> -__PAGEFLAG(SlobFree, slob_free, PF_NO_TAIL)
>  PAGEFLAG(Checked, checked, PF_NO_COMPOUND)	   /* Used by some filesystems */
>
>  /* Xen */
> diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
> index 381dcc00cb62..8d5595b6c59f 100644
> --- a/tools/mm/page-types.c
> +++ b/tools/mm/page-types.c
> @@ -85,7 +85,6 @@
>   */
>  #define KPF_ANON_EXCLUSIVE	47
>  #define KPF_READAHEAD		48
> -#define KPF_SLOB_FREE		49
>  #define KPF_SLUB_FROZEN		50
>  #define KPF_SLUB_DEBUG		51
>  #define KPF_FILE		61
> @@ -141,7 +140,6 @@ static const char * const page_flag_names[] = {
>
>  	[KPF_ANON_EXCLUSIVE]	= "d:anon_exclusive",
>  	[KPF_READAHEAD]		= "I:readahead",
> -	[KPF_SLOB_FREE]		= "P:slob_free",
>  	[KPF_SLUB_FROZEN]	= "A:slub_frozen",
>  	[KPF_SLUB_DEBUG]	= "E:slub_debug",
>
> @@ -478,10 +476,8 @@ static uint64_t expand_overloaded_flags(uint64_t flags, uint64_t pme)
>  	if ((flags & BIT(ANON)) && (flags & BIT(MAPPEDTODISK)))
>  		flags ^= BIT(MAPPEDTODISK) | BIT(ANON_EXCLUSIVE);
>
> -	/* SLOB/SLUB overload several page flags */
> +	/* SLUB overloads several page flags */
>  	if (flags & BIT(SLAB)) {
> -		if (flags & BIT(PRIVATE))
> -			flags ^= BIT(PRIVATE) | BIT(SLOB_FREE);
>  		if (flags & BIT(ACTIVE))
>  			flags ^= BIT(ACTIVE) | BIT(SLUB_FROZEN);
>  		if (flags & BIT(ERROR))
> --
> 2.39.2
>

Looks good to me too,

Acked-by: Lorenzo Stoakes <lstoakes@gmail.com>
