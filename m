Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9A4EB71A
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 19:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbfJaShA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 14:37:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:53184 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbfJaSg7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 14:36:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 11:36:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,252,1569308400"; 
   d="scan'208";a="212547050"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by orsmga002.jf.intel.com with ESMTP; 31 Oct 2019 11:36:56 -0700
Date:   Thu, 31 Oct 2019 11:36:56 -0700
From:   Ira Weiny <ira.weiny@intel.com>
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
        "David S . Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
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
Subject: Re: [PATCH 03/19] goldish_pipe: rename local pin_user_pages() routine
Message-ID: <20191031183656.GD14771@iweiny-DESK2.sc.intel.com>
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
 <20191030224930.3990755-4-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030224930.3990755-4-jhubbard@nvidia.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 03:49:14PM -0700, John Hubbard wrote:
> 1. Avoid naming conflicts: rename local static function from
> "pin_user_pages()" to "pin_goldfish_pages()".
> 
> An upcoming patch will introduce a global pin_user_pages()
> function.
> 

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
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
> 2.23.0
> 
> 
