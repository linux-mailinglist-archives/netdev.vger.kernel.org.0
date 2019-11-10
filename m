Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5A2FF6859
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 11:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfKJKLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 05:11:54 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:36361 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726653AbfKJKLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 05:11:53 -0500
Received: from [192.168.2.10] ([46.9.232.237])
        by smtp-cloud9.xs4all.net with ESMTPA
        id TkCAiNAD3QBsYTkCDi1SAO; Sun, 10 Nov 2019 11:11:50 +0100
Subject: Re: [PATCH v2 13/18] media/v4l2-core: pin_longterm_pages (FOLL_PIN)
 and put_user_page() conversion
To:     John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
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
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-14-jhubbard@nvidia.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6d21391e-01c4-0605-0d0d-15f574cc3ed4@xs4all.nl>
Date:   Sun, 10 Nov 2019 11:11:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191103211813.213227-14-jhubbard@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFSTukyJqfxV4HrGGQ0j5/iKKr13OkEzy05WqAOfOSWrg/qEYKz7zmsSLuZTQBp28yCz+dvkf6VRv+kw027uNzPdnpP1TG1MNl/DxEey7uZK5/xalM5y
 5mek2ggN11NHCI9OB51pAxH9HazB5AMpcNYWMTjkyDZlvUJtbfWW4ZUZq85nxiyCH9Wkwv75NaxcyvTMitOA+o4+U5rJjg8sA8gvfV9NbRRVFg3M6alu0IKv
 kyfdjDFwuG4F6JKpbt9v3E049Xx0YF8ppWdgVnIjGfusfyNaLb+90K4NGhzfPU11L+2UeV4HzuHSmBSjFWbsZNO99HRrZoUYxfZil98flfM0I4Tl92e2ZZ6T
 oLNGV585kbb26i0UwqgRbX0qClJpOQIX8JPemeIZHsAISH4A6EIzai79YkaAZrrdJDqsHcU/g5pBk7M+m8f1h0UhG93G+VP07un/zdrM5krNUgUcOHqWl6c8
 yg5UitZLkuZJeoj3AZIHtptGajhOljPiqFe3qrME7yIGvxpfurp6646fJOQdrdhgQ99ZW5ZVLjxCYcB39QCEQQpm6CL4XMXAsAilPNdyDqQvU26KgyC+BY4C
 EfgFzK7XJbQ28t/ACJ7DTyyH14NWDMPJXEZyBEirCE+SenjaNpo1ArEbqixnm5RCT+dULYmvp/soWFNQsgosWPukS+PH1BUonrmmMVLsT7pZ55bv6EkNWDl4
 9ypHPyVuYZBeyd/QB3263NKtG9W94IRv7gkIMIXqe+gaZqosCCZGLoQ/R3NrX+UELfTllPBXIEjGQ6GcqW4vDLnC6e5LObzBu95S05AVd/j5Z489creqnOqz
 al1X+EBLb7SCFjH5bT0l7XPwxsPFls2nYnNC2VvjaojW5EGzj+P9FMGrDMXQYA5CwZYMR9jVieofsVzZROWuyWgzGX0IWmVMrVJ+O9Cd6w+r38l2u6VzMDO3
 vrKP72jlsDujiCNkz8SZOuEiycTOpqK7FnQXWC0vHy8ZQ5kE+5U3ZOrlf3bE5a7YMuwWWgEf1wyekRKSE5FPwRln1aFBkEu6RfHldiY5r6mScJHM0Hmz3L1G
 jmpevDng1F0dM0khzD8Rn/xNHOQmjygIoT2XjmtiT+xp1E4E+mkPp1qzmYUhF73no8Ws5q3/bDKWOdGuUrZQjRZdQtb3gNeBRaDBFMdPnfgT4QkU99ovX9La
 0JO93Bw0hzkTQPZYGAQEEyZ5mT+kT8y0hQD80773+KE9/qHPFnhe80tvkU1RdNM3L33ptC7eREOqMAmdRO6tk0ZlucAIUVw5MRfKAm2acO9sl5to+l22CFB1
 ACY3IoeSiNIkXxalh1O2DqvLWJh0AapBIq9krEjBZouKIfbQ+FRgwsFcvPJZJS2eW70SQX+omUmZZ5xpSWDV1lpAjnprcaVW+xX7OhGfCCj2gQOCd9Q=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/19 10:18 PM, John Hubbard wrote:
> 1. Change v4l2 from get_user_pages(FOLL_LONGTERM), to
> pin_longterm_pages(), which sets both FOLL_LONGTERM and FOLL_PIN.
> 
> 2. Because all FOLL_PIN-acquired pages must be released via
> put_user_page(), also convert the put_page() call over to
> put_user_pages_dirty_lock().
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Looks good, thanks!

	Hans


> ---
>  drivers/media/v4l2-core/videobuf-dma-sg.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
> index 28262190c3ab..9b9c5b37bf59 100644
> --- a/drivers/media/v4l2-core/videobuf-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
> @@ -183,12 +183,12 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
>  	dprintk(1, "init user [0x%lx+0x%lx => %d pages]\n",
>  		data, size, dma->nr_pages);
>  
> -	err = get_user_pages(data & PAGE_MASK, dma->nr_pages,
> -			     flags | FOLL_LONGTERM, dma->pages, NULL);
> +	err = pin_longterm_pages(data & PAGE_MASK, dma->nr_pages,
> +				 flags, dma->pages, NULL);
>  
>  	if (err != dma->nr_pages) {
>  		dma->nr_pages = (err >= 0) ? err : 0;
> -		dprintk(1, "get_user_pages: err=%d [%d]\n", err,
> +		dprintk(1, "pin_longterm_pages: err=%d [%d]\n", err,
>  			dma->nr_pages);
>  		return err < 0 ? err : -EINVAL;
>  	}
> @@ -349,11 +349,8 @@ int videobuf_dma_free(struct videobuf_dmabuf *dma)
>  	BUG_ON(dma->sglen);
>  
>  	if (dma->pages) {
> -		for (i = 0; i < dma->nr_pages; i++) {
> -			if (dma->direction == DMA_FROM_DEVICE)
> -				set_page_dirty_lock(dma->pages[i]);
> -			put_page(dma->pages[i]);
> -		}
> +		put_user_pages_dirty_lock(dma->pages, dma->nr_pages,
> +					  dma->direction == DMA_FROM_DEVICE);
>  		kfree(dma->pages);
>  		dma->pages = NULL;
>  	}
> 

