Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEC02100504
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 13:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfKRMB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 07:01:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:37310 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726518AbfKRMBZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 07:01:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8ECD9AFF6;
        Mon, 18 Nov 2019 12:01:20 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id CAC881E4AFE; Mon, 18 Nov 2019 10:47:37 +0100 (CET)
Date:   Mon, 18 Nov 2019 10:47:37 +0100
From:   Jan Kara <jack@suse.cz>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
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
Subject: Re: [PATCH v5 06/24] goldish_pipe: rename local pin_user_pages()
 routine
Message-ID: <20191118094737.GD17319@quack2.suse.cz>
References: <20191115055340.1825745-1-jhubbard@nvidia.com>
 <20191115055340.1825745-7-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191115055340.1825745-7-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 14-11-19 21:53:22, John Hubbard wrote:
> 1. Avoid naming conflicts: rename local static function from
> "pin_user_pages()" to "pin_goldfish_pages()".
> 
> An upcoming patch will introduce a global pin_user_pages()
> function.
> 
> Reviewed-by: Jérôme Glisse <jglisse@redhat.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/platform/goldfish/goldfish_pipe.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/goldfish/goldfish_pipe.c
> index cef0133aa47a..7ed2a21a0bac 100644
> --- a/drivers/platform/goldfish/goldfish_pipe.c
> +++ b/drivers/platform/goldfish/goldfish_pipe.c
> @@ -257,12 +257,12 @@ static int goldfish_pipe_error_convert(int status)
>  	}
>  }
>  
> -static int pin_user_pages(unsigned long first_page,
> -			  unsigned long last_page,
> -			  unsigned int last_page_size,
> -			  int is_write,
> -			  struct page *pages[MAX_BUFFERS_PER_COMMAND],
> -			  unsigned int *iter_last_page_size)
> +static int pin_goldfish_pages(unsigned long first_page,
> +			      unsigned long last_page,
> +			      unsigned int last_page_size,
> +			      int is_write,
> +			      struct page *pages[MAX_BUFFERS_PER_COMMAND],
> +			      unsigned int *iter_last_page_size)
>  {
>  	int ret;
>  	int requested_pages = ((last_page - first_page) >> PAGE_SHIFT) + 1;
> @@ -354,9 +354,9 @@ static int transfer_max_buffers(struct goldfish_pipe *pipe,
>  	if (mutex_lock_interruptible(&pipe->lock))
>  		return -ERESTARTSYS;
>  
> -	pages_count = pin_user_pages(first_page, last_page,
> -				     last_page_size, is_write,
> -				     pipe->pages, &iter_last_page_size);
> +	pages_count = pin_goldfish_pages(first_page, last_page,
> +					 last_page_size, is_write,
> +					 pipe->pages, &iter_last_page_size);
>  	if (pages_count < 0) {
>  		mutex_unlock(&pipe->lock);
>  		return pages_count;
> -- 
> 2.24.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
