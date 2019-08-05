Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B38280FA6
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 02:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfHEA24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 20:28:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35932 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbfHEA2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 20:28:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750PN8L099080;
        Mon, 5 Aug 2019 00:27:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc : subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=csR1CFI12mg4Wfl/I1DmedWmi55eZjSHDbam/aE57Lg=;
 b=UxnSselyJSkDrlgtrJqirrqIgp3f8N92FZdRzvuEzRyV0BK1GmSaf9C8PKnong3YQqHb
 MCpznjeWe33FH9kWSVMHzf3ueNmMrgta/dHNshxU+ezcH/SlcYl3T1BbtssK9RamgmgB
 uxHaAwYQYSv2zhs8xcIQpAvtnAqvLsICBKD/Oi73oWTTrzZCg0llYMmo1CN1xJK1/n6p
 FN3jH23l0bDAY+8rbi5+pi71wYYr59UK7ki0dfZmNagJqJGpCz4Dhc49Z+1r5jDxqopk
 IUz6WPSid5pJVTZGy3yYzlDcCEYZUIldAG3FEELFmfGykxTqdKwI/FpOYaMM05PGsiiD Lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u527pc6va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Aug 2019 00:27:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750Mxa2125660;
        Mon, 5 Aug 2019 00:27:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2u5232s8j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Aug 2019 00:27:22 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x750RLrL130645;
        Mon, 5 Aug 2019 00:27:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2u5232s8hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Aug 2019 00:27:21 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x750R78g009479;
        Mon, 5 Aug 2019 00:27:08 GMT
Received: from mbp2018.cdmnet.org (/82.27.120.181)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 04 Aug 2019 17:27:07 -0700
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org,
        devel@driverdev.osuosl.org, devel@lists.orangefs.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        sparclinux@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>
Subject: Re: [PATCH v2 31/34] fs/nfs: convert put_page() to put_user_page*()
To:     john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>
References: <20190804224915.28669-1-jhubbard@nvidia.com>
 <20190804224915.28669-32-jhubbard@nvidia.com>
From:   Calum Mackay <calum.mackay@oracle.com>
Organization: Oracle
Message-ID: <cf978e10-facc-ba5b-d7e4-d7fc2c3f7ebc@oracle.com>
Date:   Mon, 5 Aug 2019 01:26:59 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:70.0)
 Gecko/20100101 Thunderbird/70.0a1
MIME-Version: 1.0
In-Reply-To: <20190804224915.28669-32-jhubbard@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9339 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908050001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/08/2019 11:49 pm, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> For pages that were retained via get_user_pages*(), release those pages
> via the new put_user_page*() routines, instead of via put_page() or
> release_pages().
> 
> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
> ("mm: introduce put_user_page*(), placeholder versions").
> 
> Cc: Calum Mackay <calum.mackay@oracle.com>
> Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
> Cc: Anna Schumaker <anna.schumaker@netapp.com>
> Cc: linux-nfs@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>   fs/nfs/direct.c | 11 ++---------
>   1 file changed, 2 insertions(+), 9 deletions(-)

Reviewed-by: Calum Mackay <calum.mackay@oracle.com>


> diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
> index 0cb442406168..c0c1b9f2c069 100644
> --- a/fs/nfs/direct.c
> +++ b/fs/nfs/direct.c
> @@ -276,13 +276,6 @@ ssize_t nfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>   	return nfs_file_direct_write(iocb, iter);
>   }
>   
> -static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
> -{
> -	unsigned int i;
> -	for (i = 0; i < npages; i++)
> -		put_page(pages[i]);
> -}
> -
>   void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinfo,
>   			      struct nfs_direct_req *dreq)
>   {
> @@ -512,7 +505,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
>   			pos += req_len;
>   			dreq->bytes_left -= req_len;
>   		}
> -		nfs_direct_release_pages(pagevec, npages);
> +		put_user_pages(pagevec, npages);
>   		kvfree(pagevec);
>   		if (result < 0)
>   			break;
> @@ -935,7 +928,7 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
>   			pos += req_len;
>   			dreq->bytes_left -= req_len;
>   		}
> -		nfs_direct_release_pages(pagevec, npages);
> +		put_user_pages(pagevec, npages);
>   		kvfree(pagevec);
>   		if (result < 0)
>   			break;
> 
