Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9D96BA222
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 23:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjCNWO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 18:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbjCNWOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 18:14:10 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4263323DB5;
        Tue, 14 Mar 2023 15:13:19 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so11182837wmq.1;
        Tue, 14 Mar 2023 15:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678831913;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SekFEmAeK9leXCVtEJ/5RiO3jcSsl6NVfTaRrfrZ9J0=;
        b=oPNWwBITue+0q+Gxhr58U1kNBLFxTO1MPp56f9Y+lN6aB40OfQA+HcognUG0yf4pmn
         e2gFvCzgqkNE6DheOGDTX0/va4sOjqSyisTfHD+971zqRBaQclJWHRyep4Ubzuh3yQXD
         PoP/JZglgDGJzPNLExl32duTvYBCrew7Gy6GazTQgjn56B9PfHWeIh2JJ6dNHCx6nStX
         SyYgktXbqCSlyFfVei4/hSS3w2rWnzrT0enOosoLz03a8OsbGSrYqpYavBHJzPR94Xoi
         zC+uHX4ceP0QL57R6SRib0pqx13y0moaj+EMNnhezYvMliREdD7Kc1djkgAfXkvd3NRf
         EGJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678831913;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SekFEmAeK9leXCVtEJ/5RiO3jcSsl6NVfTaRrfrZ9J0=;
        b=pB1AeW4XclKCcyVMETIxLjwzBsLzrd9k+trKqGwCjBSj22EBQWUDYPBZwYddj1aqx3
         TvME97nbSGdD1UYtw++oZ2aXN5uVfQUd0zNihHRyotLQHruDGoq032i7lZcefzd++4NX
         krMz9NaOGoReb4S+DAYtvkvIfieWfDkiR+ukJaouDz/2vLVPDi3geHna+U3zvd40YCnQ
         Txcn2icHFx8nzga30XbCOpbRxFfKAa5TC20LaSvA2u03TcTdKvptMkK3PvPUK62oT0oh
         P6yI5Yn6WU9NE4YAIg5wKpe97Eqa+Y/vloPTF3o3ZQXQa4XpDujBeJgAukNZXNgd5IKZ
         mXJg==
X-Gm-Message-State: AO0yUKUyhE204/LlrAWjuzWXfeTzE6hyZd8FtgAaFiMY2zlu8J/ddJke
        C+1JDyQkWWemevUOIDB1djM=
X-Google-Smtp-Source: AK7set867EXlhkXXBMVZCE2npmcXP0xJU5GRhkg31e64K452iGc8VYDPMj8kt4wPWuhgptenPGsmDA==
X-Received: by 2002:a05:600c:1c95:b0:3e2:1ef0:f585 with SMTP id k21-20020a05600c1c9500b003e21ef0f585mr16262253wms.2.1678831913150;
        Tue, 14 Mar 2023 15:11:53 -0700 (PDT)
Received: from localhost (host86-146-209-214.range86-146.btcentralplus.com. [86.146.209.214])
        by smtp.gmail.com with ESMTPSA id l8-20020a05600c4f0800b003db01178b62sm4438120wmq.40.2023.03.14.15.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 15:11:52 -0700 (PDT)
Date:   Tue, 14 Mar 2023 22:11:51 +0000
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
Subject: Re: [PATCH 1/7] mm/slob: remove CONFIG_SLOB
Message-ID: <4e936740-1f1c-4dd2-968b-b781ee2bfc6a@lucifer.local>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <20230310103210.22372-2-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310103210.22372-2-vbabka@suse.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
> --
> 2.39.2
>

Looks good to me too,

Acked-by: Lorenzo Stoakes <lstoakes@gmail.com>
