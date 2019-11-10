Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE87F684E
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 11:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfKJKLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 05:11:31 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:36361 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726604AbfKJKLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 05:11:30 -0500
Received: from [192.168.2.10] ([46.9.232.237])
        by smtp-cloud9.xs4all.net with ESMTPA
        id TkAciN9jLQBsYTkAfi1RpK; Sun, 10 Nov 2019 11:11:26 +0100
Subject: Re: [PATCH v2 04/18] media/v4l2-core: set pages dirty upon releasing
 DMA buffers
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
 <20191103211813.213227-5-jhubbard@nvidia.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4b2337f6-102d-ae9d-e690-4331d77660c4@xs4all.nl>
Date:   Sun, 10 Nov 2019 11:10:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191103211813.213227-5-jhubbard@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfAPpy2vpeOFs77rW2iUKK+bPb2VYuB427ajEzGyts3W1VRlRd8q2KZmpOE3DFif2hs9tSjpFG2MDGUxoUwQm+z0hf/YaqIsd4KJq73ThxOO7jqnMZVh0
 5s2Ci3kaB1equdumf2oCd5xzPIVouOW1/6UWWZgdj5tXsUmXU+r/YvhgWiD4A5B5WBtqZIjcpZHv6EKsqhHvOz6pIIbA7OldOWD2+iHEV3rVaUTKb6Lt3vRw
 SSXpeck8t+iVDTfehAnk4OCQknEuuW7biYsmpQFqR+21Z4qbrYGAJFWwZGcx5l1O9Nb+oL+1R7wh7rczhsKkATyoeyEbJh7U5bWdVqvWfIRcf2W7EU+qBTBa
 X7Uir4ix/M0Vc8kPKcpvtanUB7BwbBsdTwpfWZs6MGGivJgNeWJTOg0pJ8/lJLpxYEgYT1my4VIi7msLPk5NPAhRKjmUqSeBdgx8a5QxjgigbuB7AzOfHnKq
 ZzakHL1ulDMamAJ5G9YZZjwCB+lOMOUp5M3CZNRpUz5w7sRFxqShtLzNOamqMbdo1uYqNd0vcjOgiKZR8d9Ghp29rh44/i+M6byEp/mDuO8hkUsi6jHOl0Jc
 2AsL8S7dTnmRvpiwGny5VVVHzqw5VaucvjDIrC7g1GMNCVRVQGn6eqGLBi9r+KmU9xgLz4PEaJs8ezN37s2nqlRHMEUZEcp+0+DGahQQuCOB5ZtIgcZI4RLV
 GtvowA/PQOkGTxubmHrxAhc6A75jhab02NbtNvCE8y9gMwelrINTjlClQk3w4e+mbQFNkFV2ECg9betDwH8/aIdQ08eLbeJlRT9VV2RlzufdbZT8WYUKa3rQ
 XrzXyEWlNgLgdhKTXh0gLOMN1fnBuGnwvPLE+9dloH9gj5/ahIl1DJ1yC5bX8YaUgYefoKylCBFkllnRgj55soXCdEpByoyvoOtA9cLY+8HPuv8yFz30DCRl
 loaEV8FCCffWUFnYyblWEO9HjL7sGDOb3AgMAMj1WfnDClDQ3Ke+QmqrIUPJAob7r+3lZrpzd80clijb4adwOWHUw9h2hzLNp12Jtuxf7rCNBDN9d0d3xcJP
 CQUt8WSeOsrapke/lCNSISw8IUFdRqcP8SBDphkMHZ6Ufy4ivENOjdpqmPgmUlDt2yDks5tyJ8p+63Ohr5N9kCcaLw8ePN4eY8/i2Yefol6FpRFwDf50/E0y
 I/X+ZEgsPHX0dVwFtL9IEqmHiSQY81IjgKYkJL1PhteOJmC92UP+QNn6ZPsWLuZ/haHv+miyWHADTl/qLfH38B3y6M4Pmjva6VM7WmQ6DOw1MqUxuJT/v53v
 D98Je6z4yf0/L93nJ/iKmgOFto/kGOYI7cTtA+aiGH69QjtEjUslbWgWW5DA4lVL/fi/uIVNVbhElR2trAv8SoZoOAGF53v4D0PPvVLo+05K//bIQbQ=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/19 10:17 PM, John Hubbard wrote:
> After DMA is complete, and the device and CPU caches are synchronized,
> it's still required to mark the CPU pages as dirty, if the data was
> coming from the device. However, this driver was just issuing a
> bare put_page() call, without any set_page_dirty*() call.
> 
> Fix the problem, by calling set_page_dirty_lock() if the CPU pages
> were potentially receiving data from the device.
> 
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Looks good, thanks!

	Hans

> ---
>  drivers/media/v4l2-core/videobuf-dma-sg.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
> index 66a6c6c236a7..28262190c3ab 100644
> --- a/drivers/media/v4l2-core/videobuf-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
> @@ -349,8 +349,11 @@ int videobuf_dma_free(struct videobuf_dmabuf *dma)
>  	BUG_ON(dma->sglen);
>  
>  	if (dma->pages) {
> -		for (i = 0; i < dma->nr_pages; i++)
> +		for (i = 0; i < dma->nr_pages; i++) {
> +			if (dma->direction == DMA_FROM_DEVICE)
> +				set_page_dirty_lock(dma->pages[i]);
>  			put_page(dma->pages[i]);
> +		}
>  		kfree(dma->pages);
>  		dma->pages = NULL;
>  	}
> 

