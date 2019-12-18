Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E13124C69
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfLRQEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:04:24 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43166 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbfLRQEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:04:24 -0500
Received: by mail-lj1-f194.google.com with SMTP id a13so2730197ljm.10
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 08:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=lx2tYrxH76TzOflvrZdMYwmw6kPdiwBO2AoS02kSF8I=;
        b=z5wPjhUP09OUtbjMjcfRXuIHIwQ6JsCqdqDQrpkHeR2FGTJKRgTZuRVpd8Ejot/uzW
         WkIRJ1o23H1rHR8qrWtCj6uBitDImUrGPYpJ5mMWyp3EmJAhL7rYh6HpljzRDkNNAPx0
         LUjYdc/PK8ZbQZUps8imW7pyun+gW90XpZ53fBcBIDiOV27gBLz+BEehaTKZC5uM8Oqa
         ydjJOsIeBdrZtGFXR3Ff0Wal0p2P05zNibodcJL9uNUAN8pxDWcLGNcXSYNkE83Lm4vk
         MRxOsdbgin+Oe/MgK9nfd0EbUF6BgvQFFgBekQTNtwPB0Nh3TqyAfgcwxiXCuXBEgxgt
         8yAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=lx2tYrxH76TzOflvrZdMYwmw6kPdiwBO2AoS02kSF8I=;
        b=iBtOEkDZpGNvBh219OYUt9Sk2m+T6IORhhoRWYkt8BklVlf/iug5YKiwJmPTWFiBL2
         Ggt4b8gDv4imV4M7c3NKkvDRCE9qdMnBmQSw/Ah3TGwDMe2xDvluBQgg7CHr/tCtHWqb
         z4L1CqkVSRuAu91n0IaAaxvzz+Hx+G8q/ZOCH0UeWXiEKOuj/5X81KnApO/MKCF+JIM1
         s4+lOLYSjQTxkWzeO2gEn/LxPyu0aOtap0vCwAuhwE8wW1vDOxCplmLteJzlDtQkKSZo
         xYoKU/rzjGWfn0IRXp0Mrxypl8/TLf8fk+q2KUuIPXb719ELiA8HVRieQ0x1sbVKXNGX
         +VIw==
X-Gm-Message-State: APjAAAUo15jxZrXX4nlryA1cVlDJnMK2dHEDAzD2O6ZhTn3e/QHGQZZM
        L3b87Nbk2ZjMbGl3hfrNK1O87g==
X-Google-Smtp-Source: APXvYqwF7pecGZBZMkXKVp15IXhXZo2PGYpkUgZNZl53wUwEdzClRBwVejnpDULy6WyyjOVSSgygvA==
X-Received: by 2002:a2e:9284:: with SMTP id d4mr2361276ljh.226.1576685060830;
        Wed, 18 Dec 2019 08:04:20 -0800 (PST)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id j19sm1730231lfb.90.2019.12.18.08.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 08:04:19 -0800 (PST)
Received: by box.localdomain (Postfix, from userid 1000)
        id 5A04D1012CF; Wed, 18 Dec 2019 19:04:20 +0300 (+03)
Date:   Wed, 18 Dec 2019 19:04:20 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v11 04/25] mm: devmap: refactor 1-based refcounting for
 ZONE_DEVICE pages
Message-ID: <20191218160420.gyt4c45e6zsnxqv6@box>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
 <20191216222537.491123-5-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191216222537.491123-5-jhubbard@nvidia.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 02:25:16PM -0800, John Hubbard wrote:
> An upcoming patch changes and complicates the refcounting and
> especially the "put page" aspects of it. In order to keep
> everything clean, refactor the devmap page release routines:
> 
> * Rename put_devmap_managed_page() to page_is_devmap_managed(),
>   and limit the functionality to "read only": return a bool,
>   with no side effects.
> 
> * Add a new routine, put_devmap_managed_page(), to handle checking
>   what kind of page it is, and what kind of refcount handling it
>   requires.
> 
> * Rename __put_devmap_managed_page() to free_devmap_managed_page(),
>   and limit the functionality to unconditionally freeing a devmap
>   page.

What the reason to separate put_devmap_managed_page() from
free_devmap_managed_page() if free_devmap_managed_page() has exacly one
caller? Is it preparation for the next patches?

> This is originally based on a separate patch by Ira Weiny, which
> applied to an early version of the put_user_page() experiments.
> Since then, Jérôme Glisse suggested the refactoring described above.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Suggested-by: Jérôme Glisse <jglisse@redhat.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  include/linux/mm.h | 17 +++++++++++++----
>  mm/memremap.c      | 16 ++--------------
>  mm/swap.c          | 24 ++++++++++++++++++++++++
>  3 files changed, 39 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c97ea3b694e6..77a4df06c8a7 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -952,9 +952,10 @@ static inline bool is_zone_device_page(const struct page *page)
>  #endif
>  
>  #ifdef CONFIG_DEV_PAGEMAP_OPS
> -void __put_devmap_managed_page(struct page *page);
> +void free_devmap_managed_page(struct page *page);
>  DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
> -static inline bool put_devmap_managed_page(struct page *page)
> +
> +static inline bool page_is_devmap_managed(struct page *page)
>  {
>  	if (!static_branch_unlikely(&devmap_managed_key))
>  		return false;
> @@ -963,7 +964,6 @@ static inline bool put_devmap_managed_page(struct page *page)
>  	switch (page->pgmap->type) {
>  	case MEMORY_DEVICE_PRIVATE:
>  	case MEMORY_DEVICE_FS_DAX:
> -		__put_devmap_managed_page(page);
>  		return true;
>  	default:
>  		break;
> @@ -971,7 +971,14 @@ static inline bool put_devmap_managed_page(struct page *page)
>  	return false;
>  }
>  
> +bool put_devmap_managed_page(struct page *page);
> +
>  #else /* CONFIG_DEV_PAGEMAP_OPS */
> +static inline bool page_is_devmap_managed(struct page *page)
> +{
> +	return false;
> +}
> +
>  static inline bool put_devmap_managed_page(struct page *page)
>  {
>  	return false;
> @@ -1028,8 +1035,10 @@ static inline void put_page(struct page *page)
>  	 * need to inform the device driver through callback. See
>  	 * include/linux/memremap.h and HMM for details.
>  	 */
> -	if (put_devmap_managed_page(page))
> +	if (page_is_devmap_managed(page)) {
> +		put_devmap_managed_page(page);

put_devmap_managed_page() has yet another page_is_devmap_managed() check
inside. It looks strange.

>  		return;
> +	}
>  
>  	if (put_page_testzero(page))
>  		__put_page(page);
> diff --git a/mm/memremap.c b/mm/memremap.c
> index e899fa876a62..2ba773859031 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -411,20 +411,8 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
>  EXPORT_SYMBOL_GPL(get_dev_pagemap);
>  
>  #ifdef CONFIG_DEV_PAGEMAP_OPS
> -void __put_devmap_managed_page(struct page *page)
> +void free_devmap_managed_page(struct page *page)
>  {
> -	int count = page_ref_dec_return(page);
> -
> -	/* still busy */
> -	if (count > 1)
> -		return;
> -
> -	/* only triggered by the dev_pagemap shutdown path */
> -	if (count == 0) {
> -		__put_page(page);
> -		return;
> -	}
> -
>  	/* notify page idle for dax */
>  	if (!is_device_private_page(page)) {
>  		wake_up_var(&page->_refcount);
> @@ -461,5 +449,5 @@ void __put_devmap_managed_page(struct page *page)
>  	page->mapping = NULL;
>  	page->pgmap->ops->page_free(page);
>  }
> -EXPORT_SYMBOL(__put_devmap_managed_page);
> +EXPORT_SYMBOL(free_devmap_managed_page);
>  #endif /* CONFIG_DEV_PAGEMAP_OPS */
> diff --git a/mm/swap.c b/mm/swap.c
> index 5341ae93861f..49f7c2eea0ba 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -1102,3 +1102,27 @@ void __init swap_setup(void)
>  	 * _really_ don't want to cluster much more
>  	 */
>  }
> +
> +#ifdef CONFIG_DEV_PAGEMAP_OPS
> +bool put_devmap_managed_page(struct page *page)
> +{
> +	bool is_devmap = page_is_devmap_managed(page);
> +
> +	if (is_devmap) {

Reversing the condition would save you an indentation level.

> +		int count = page_ref_dec_return(page);
> +
> +		/*
> +		 * devmap page refcounts are 1-based, rather than 0-based: if
> +		 * refcount is 1, then the page is free and the refcount is
> +		 * stable because nobody holds a reference on the page.
> +		 */
> +		if (count == 1)
> +			free_devmap_managed_page(page);
> +		else if (!count)
> +			__put_page(page);
> +	}
> +
> +	return is_devmap;
> +}
> +EXPORT_SYMBOL(put_devmap_managed_page);
> +#endif
> -- 
> 2.24.1
> 
> 

-- 
 Kirill A. Shutemov
