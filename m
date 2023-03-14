Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41AE26B8BD2
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 08:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjCNHSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 03:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjCNHSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 03:18:20 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D46664FC;
        Tue, 14 Mar 2023 00:18:18 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id a2so15624782plm.4;
        Tue, 14 Mar 2023 00:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678778298;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c46t0neyKWHP+SDAFWH/g72V/Nn1AVWpZoacRj8VyLk=;
        b=S9AG5DWg2XZsDj6Es8WNOGYTopXFo3VAhRsa+mVSSY7aikyWk81a2OqBGTAoyPFgyu
         uVSkd8JwegJs5MqHNfKT/d8TdpPjlx6OQRMEIjo+QZlppEnGZRJDX91OuPtVkMVO99CF
         yco0uZPL8mCTz9RAB5pnm/nIB5XrBaA3wo03zf5MOaSGbdpH5uYOOMjO3PjDvP/fmDl/
         xMwBnJR9CuNXV5cjhCqwFicz866yGKILl3iLTL0g5K3QFtJK2DHZqnyz6TJve3ZnUq9g
         TOUd/K54HU/ebv9PY82fNIom9wPQQn7eW9PTBohspDeTgn+yFJ3cyS9mC7O3rX4DGBpL
         q4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678778298;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c46t0neyKWHP+SDAFWH/g72V/Nn1AVWpZoacRj8VyLk=;
        b=dfbQhv7xjsj/9v8RDUoKm1BXPKhDrN4eN4WNyMfrNn/qS0pTmFpJT9Lq/ax5378vFD
         uG+0pYV5/ZxXdEUDzWaM4QIzpldt9CfhNrsuEOHYzg/S6Wet6l3OEgAJ15RDXpATp5GV
         TUq5NrMRoEjpyFZfNoIiZKTeQ4e1VqM1fQxcnSPdn8ub98+2eunYtstHjJw0HEHA9eaY
         vQYegpjvUB3cOjOHkW+rz1m6VbOIRfmd5nM0GHjHkg0P86CK7HPPDm1L6WZn26WLcR6y
         LmKzvtFTSlRX4Jk9kn6RcJoza0OO0YnyLmptmrF4zNg4lnMfR9wWft/nrD3oM8JJu3qi
         2ryw==
X-Gm-Message-State: AO0yUKUQoZfkZzbsLRyXqZdEdcOcSfwgRXK39C16JR3PuluKwT/c1el5
        8js+GjtjR4SwSPk97FsE4uk=
X-Google-Smtp-Source: AK7set/TwZv/+gdR3vizxWDK5px/eSNGwwzlyNPxX57Ktb8udmkDrlYHgYRuoNUS4MHfjXuXzOFuGQ==
X-Received: by 2002:a05:6a20:a88f:b0:d4:abe8:697d with SMTP id ca15-20020a056a20a88f00b000d4abe8697dmr4420286pzb.30.1678778298179;
        Tue, 14 Mar 2023 00:18:18 -0700 (PDT)
Received: from localhost ([2400:8902::f03c:93ff:fe27:642a])
        by smtp.gmail.com with ESMTPSA id c12-20020aa781cc000000b005dc70330d9bsm875550pfn.26.2023.03.14.00.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 00:18:17 -0700 (PDT)
Date:   Tue, 14 Mar 2023 07:18:11 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/7] mm/slob: remove CONFIG_SLOB
Message-ID: <ZBAfsx30uLNj4TJB@localhost>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <20230310103210.22372-2-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310103210.22372-2-vbabka@suse.cz>
X-Spam-Status: No, score=3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 11:32:03AM +0100, Vlastimil Babka wrote:
> Remove SLOB from Kconfig and Makefile. Everything under #ifdef
> CONFIG_SLOB, and mm/slob.c is now dead code.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  init/Kconfig               |  2 +-
>  kernel/configs/tiny.config |  1 -
>  mm/Kconfig                 | 22 ----------------------
>  mm/Makefile                |  1 -
>  4 files changed, 1 insertion(+), 25 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 1fb5f313d18f..72ac3f66bc27 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -973,7 +973,7 @@ config MEMCG
>  
>  config MEMCG_KMEM
>  	bool
> -	depends on MEMCG && !SLOB
> +	depends on MEMCG
>  	default y
>  
>  config BLK_CGROUP
> diff --git a/kernel/configs/tiny.config b/kernel/configs/tiny.config
> index c2f9c912df1c..144b2bd86b14 100644
> --- a/kernel/configs/tiny.config
> +++ b/kernel/configs/tiny.config
> @@ -7,6 +7,5 @@ CONFIG_KERNEL_XZ=y
>  # CONFIG_KERNEL_LZO is not set
>  # CONFIG_KERNEL_LZ4 is not set
>  # CONFIG_SLAB is not set
> -# CONFIG_SLOB_DEPRECATED is not set
>  CONFIG_SLUB=y
>  CONFIG_SLUB_TINY=y
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 4751031f3f05..669399ab693c 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -238,30 +238,8 @@ config SLUB
>  	   and has enhanced diagnostics. SLUB is the default choice for
>  	   a slab allocator.
>  
> -config SLOB_DEPRECATED
> -	depends on EXPERT
> -	bool "SLOB (Simple Allocator - DEPRECATED)"
> -	depends on !PREEMPT_RT
> -	help
> -	   Deprecated and scheduled for removal in a few cycles. SLUB
> -	   recommended as replacement. CONFIG_SLUB_TINY can be considered
> -	   on systems with 16MB or less RAM.
> -
> -	   If you need SLOB to stay, please contact linux-mm@kvack.org and
> -	   people listed in the SLAB ALLOCATOR section of MAINTAINERS file,
> -	   with your use case.
> -
> -	   SLOB replaces the stock allocator with a drastically simpler
> -	   allocator. SLOB is generally more space efficient but
> -	   does not perform as well on large systems.
> -
>  endchoice
>  
> -config SLOB
> -	bool
> -	default y
> -	depends on SLOB_DEPRECATED
> -
>  config SLUB_TINY
>  	bool "Configure SLUB for minimal memory footprint"
>  	depends on SLUB && EXPERT
> diff --git a/mm/Makefile b/mm/Makefile
> index 8e105e5b3e29..2d9c1e7f6085 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -81,7 +81,6 @@ obj-$(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP)	+= hugetlb_vmemmap.o
>  obj-$(CONFIG_NUMA) 	+= mempolicy.o
>  obj-$(CONFIG_SPARSEMEM)	+= sparse.o
>  obj-$(CONFIG_SPARSEMEM_VMEMMAP) += sparse-vmemmap.o
> -obj-$(CONFIG_SLOB) += slob.o
>  obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
>  obj-$(CONFIG_KSM) += ksm.o
>  obj-$(CONFIG_PAGE_POISONING) += page_poison.o

With what Mike pointed:
(removing 'mm/Makefile:KCOV_INSTRUMENT_slob.o := n')

Acked-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

> -- 
> 2.39.2
> 
