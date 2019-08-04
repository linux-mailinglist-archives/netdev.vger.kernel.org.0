Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8AF80F5B
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 01:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfHDX3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 19:29:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55174 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfHDX3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 19:29:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x74NNpc9062157;
        Sun, 4 Aug 2019 23:28:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc : subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Xv/Xmfe6YA+uiUXCTMOrvz+2cmMCgKpadUjchsyGSqE=;
 b=Q8jHS5LyGioVRXkw2sEGxpCJ0g6RThcXNJNhQ+zIt1yN9QAbG9oidwXBknqGefI/Gzo9
 By4AgfVTCnBhziiCIa41vp2Km7uJGUaiXbbnEbFOGJu/tindREq8cqQoMC9pE39KJmFC
 pbJGax0NRp2J6BU7Wqa2MYOikJcTOlvo6BuaJMMnG/rkz+mFpRP2aBj29SOQtqfHNiyp
 Oiqh3Pja48Hg208XzAKVGnWgaY0bM8E6Jd5XgoYoeEDXsXo8GsiLTw4ZRpe3pTL5xLes
 aQ1Owfq77tOFIMZ2lazrtAcx+SAXXLqcnJIeXpem2RoPun+jIzPsLiAZSgR10i43pZcT 6Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2u527pc4c4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 04 Aug 2019 23:28:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x74NRrau079768;
        Sun, 4 Aug 2019 23:28:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2u50abah84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 04 Aug 2019 23:28:16 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x74NSFYX079993;
        Sun, 4 Aug 2019 23:28:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2u50abah81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 04 Aug 2019 23:28:15 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x74NSAcc031730;
        Sun, 4 Aug 2019 23:28:10 GMT
Received: from mbp2018.cdmnet.org (/82.27.120.181)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 04 Aug 2019 16:28:10 -0700
Cc:     calum.mackay@oracle.com, Christoph Hellwig <hch@infradead.org>,
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
        xen-devel@lists.xenproject.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>
Subject: Re: [PATCH 31/34] nfs: convert put_page() to put_user_page*()
To:     John Hubbard <jhubbard@nvidia.com>, john.hubbard@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802022005.5117-32-jhubbard@nvidia.com>
 <1738cb1e-15d8-0bbe-5362-341664f6efc8@oracle.com>
 <db136399-ed87-56ea-bd6e-e5d29b145eda@nvidia.com>
From:   Calum Mackay <calum.mackay@oracle.com>
Organization: Oracle
Message-ID: <03a81556-98a7-7edb-5989-b799ec99a072@oracle.com>
Date:   Mon, 5 Aug 2019 00:28:01 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:70.0)
 Gecko/20100101 Thunderbird/70.0a1
MIME-Version: 1.0
In-Reply-To: <db136399-ed87-56ea-bd6e-e5d29b145eda@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9339 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908040274
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/08/2019 2:41 am, John Hubbard wrote:
> On 8/2/19 6:27 PM, Calum Mackay wrote:
>> On 02/08/2019 3:20 am, john.hubbard@gmail.com wrote:
> ...
>> Since it's static, and only called twice, might it be better to change its two callers [nfs_direct_{read,write}_schedule_iovec()] to call put_user_pages() directly, and remove nfs_direct_release_pages() entirely?
>>
>> thanks,
>> calum.
>>
>>
>>>      void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinfo,
>>>
>   
> Hi Calum,
> 
> Absolutely! Is it OK to add your reviewed-by, with the following incremental
> patch made to this one?

Thanks John; looks good.

Reviewed-by: Calum Mackay <calum.mackay@oracle.com>

> 
> diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
> index b00b89dda3c5..c0c1b9f2c069 100644
> --- a/fs/nfs/direct.c
> +++ b/fs/nfs/direct.c
> @@ -276,11 +276,6 @@ ssize_t nfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>          return nfs_file_direct_write(iocb, iter);
>   }
>   
> -static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
> -{
> -       put_user_pages(pages, npages);
> -}
> -
>   void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinfo,
>                                struct nfs_direct_req *dreq)
>   {
> @@ -510,7 +505,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
>                          pos += req_len;
>                          dreq->bytes_left -= req_len;
>                  }
> -               nfs_direct_release_pages(pagevec, npages);
> +               put_user_pages(pagevec, npages);
>                  kvfree(pagevec);
>                  if (result < 0)
>                          break;
> @@ -933,7 +928,7 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
>                          pos += req_len;
>                          dreq->bytes_left -= req_len;
>                  }
> -               nfs_direct_release_pages(pagevec, npages);
> +               put_user_pages(pagevec, npages);
>                  kvfree(pagevec);
>                  if (result < 0)
>                          break;
> 
> 
> 
> thanks,
> 
