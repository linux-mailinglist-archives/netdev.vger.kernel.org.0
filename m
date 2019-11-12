Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A04E5F9AF7
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfKLUnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:43:41 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45831 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbfKLUnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 15:43:41 -0500
Received: by mail-qt1-f195.google.com with SMTP id 30so21297252qtz.12
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 12:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kGcjnenI+EnnAHWMcItB24mxm55INky4C94Ykv4geg4=;
        b=Ia/Hl3Z1HOGYiq6KoluUd9uZCGKzwQBgBr5JQ7I5KyZEUZP07fiLx9egiGiglXV9yp
         zwduhp53vyEcd290QPaERf3wZ21mOf61BVNQbg6GVzWjLkWaYtjFFrAZ/kB/sX/TsV0O
         Cqh6vZK9nd1Vig8r0syQpzeADiWtdjhU8C1qoZqr93PSItmh35/j4piNjOHcIgDaKDz3
         2BaPDGhVa8atEOsvR55GHtOxdcr+RnZlO25xW0gJoiJutB0sYZDed0fX6gxPxoxhf5Zl
         1FXBtMQo3iHNaStug4eqwxrgV4Z4sqg89JFN5ijz+6oI5UdbjHNjva//V05ajuQKORqi
         pELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kGcjnenI+EnnAHWMcItB24mxm55INky4C94Ykv4geg4=;
        b=JrOflDgNM/elPkRgiRxH/Sff1FgzbHqyhaJlI3XmQrm6wmK1TA5kbJDMmw9auUxM+d
         a+lNKk+A2ESlmC+tMMG5OTweK4kpH2pBG0lW1o7KgA5qdxjMjiINWyVheM/cHF6z/ChG
         UaiNOB/CkEOYMCSTctAnm/MZrmebs/MK1wFRWT57OHCFBYNvxAQwSFeeiR2sZpWlzCC/
         xjhGV1VhEOAR31p/Ro1n3rbJD3HKaHUBJp3tEx5a5dzHbXitxd+A3CiFW41P+uAO8gyi
         kxlFYD4U6bZu1JpAIRNfgWcX3Ml8R5le4iUV7YQWFAKTGEYPVBW8vCvQzZwtivO+iy6T
         w32g==
X-Gm-Message-State: APjAAAWFx3ygG5Xy9ahzmSBwPmK+diT50vJFX85zo/bH6QX1maS37G9o
        XdyFIu9quZzZZ6Un/5aELnOQYA==
X-Google-Smtp-Source: APXvYqyV99P4cYBxqwR0yk0Vl7NSO/G/hGYwr7orI5pSazTDzznvIwLj5yKe4F2N3m9e7NI6fV/HBQ==
X-Received: by 2002:ac8:1ba5:: with SMTP id z34mr33733259qtj.162.1573591419675;
        Tue, 12 Nov 2019 12:43:39 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id u22sm10020470qtb.59.2019.11.12.12.43.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 12:43:39 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iUd0k-00046s-Fb; Tue, 12 Nov 2019 16:43:38 -0400
Date:   Tue, 12 Nov 2019 16:43:38 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
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
        Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
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
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 08/23] vfio, mm: fix get_user_pages_remote() and
 FOLL_LONGTERM
Message-ID: <20191112204338.GE5584@ziepe.ca>
References: <20191112000700.3455038-1-jhubbard@nvidia.com>
 <20191112000700.3455038-9-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112000700.3455038-9-jhubbard@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 04:06:45PM -0800, John Hubbard wrote:
> As it says in the updated comment in gup.c: current FOLL_LONGTERM
> behavior is incompatible with FAULT_FLAG_ALLOW_RETRY because of the
> FS DAX check requirement on vmas.
> 
> However, the corresponding restriction in get_user_pages_remote() was
> slightly stricter than is actually required: it forbade all
> FOLL_LONGTERM callers, but we can actually allow FOLL_LONGTERM callers
> that do not set the "locked" arg.
> 
> Update the code and comments accordingly, and update the VFIO caller
> to take advantage of this, fixing a bug as a result: the VFIO caller
> is logically a FOLL_LONGTERM user.
> 
> Thanks to Jason Gunthorpe for pointing out a clean way to fix this.
> 
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Jerome Glisse <jglisse@redhat.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 30 +++++++++++++-----------------
>  mm/gup.c                        | 13 ++++++++-----
>  2 files changed, 21 insertions(+), 22 deletions(-)

This matches what I thought, but I think DanW should check it too, and
the vfio users should test..

> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index d864277ea16f..017689b7c32b 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -348,24 +348,20 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>  		flags |= FOLL_WRITE;
>  
>  	down_read(&mm->mmap_sem);
> -	if (mm == current->mm) {
> -		ret = get_user_pages(vaddr, 1, flags | FOLL_LONGTERM, page,
> -				     vmas);
> -	} else {
> -		ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags, page,
> -					    vmas, NULL);
> -		/*
> -		 * The lifetime of a vaddr_get_pfn() page pin is
> -		 * userspace-controlled. In the fs-dax case this could
> -		 * lead to indefinite stalls in filesystem operations.
> -		 * Disallow attempts to pin fs-dax pages via this
> -		 * interface.
> -		 */
> -		if (ret > 0 && vma_is_fsdax(vmas[0])) {
> -			ret = -EOPNOTSUPP;
> -			put_page(page[0]);
> -		}
> +	ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTERM,
> +				    page, vmas, NULL);
> +	/*
> +	 * The lifetime of a vaddr_get_pfn() page pin is
> +	 * userspace-controlled. In the fs-dax case this could
> +	 * lead to indefinite stalls in filesystem operations.
> +	 * Disallow attempts to pin fs-dax pages via this
> +	 * interface.
> +	 */
> +	if (ret > 0 && vma_is_fsdax(vmas[0])) {
> +		ret = -EOPNOTSUPP;
> +		put_page(page[0]);
>  	}

AFAIK this chunk is redundant now as it is some hack to emulate
FOLL_LONGTERM? So vmas can be deleted too.

Also unclear why this function has this:

        up_read(&mm->mmap_sem);

        if (ret == 1) {
                *pfn = page_to_pfn(page[0]);
                return 0;
        }

        down_read(&mm->mmap_sem);

Jason
