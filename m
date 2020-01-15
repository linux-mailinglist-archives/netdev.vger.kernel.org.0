Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F50413CF74
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 22:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbgAOVxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 16:53:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:33794 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729516AbgAOVxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 16:53:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FLd4Tc060892;
        Wed, 15 Jan 2020 21:53:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=JSBaP9Tpyn/7z+t3DGmSMpMpboGWjDG7QjTppOxxi7A=;
 b=EB5ruYjw//7+59vA+JKRp3niGwDTICqxuwWDaO91t/yeLGm7ZTv0IenUktjil74pNwUc
 VfnS5S70UwXEIubOJqfHNgiTveanhv72nfTJfCaMpixDUi2Ac5jpgmoSzvXQ+4aWR+Nn
 gzHS7egxnNedaL0nS4VBsELVbgaS0cVeio18joyQS8e72+r1VadJw2b2ztKBh0X6Vw9t
 IhRYt8+6hT0igOFGwY0oL6S+NwCgpOUc1iyazzGkVVvMN8p6/STBb9vadPjf13qslWJX
 yh4qMRd8ncedGLI/4d5iFJ4tIE8Dy1Lv+2DQ6VKFxHDfh9RTzH8afrKp85mZwZ9bKSew gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xf73ypyj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 21:53:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FLd8wW140881;
        Wed, 15 Jan 2020 21:51:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xj1ar8x9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 21:51:26 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00FLpOmn026265;
        Wed, 15 Jan 2020 21:51:24 GMT
Received: from [10.209.227.41] (/10.209.227.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 13:51:24 -0800
Subject: Re: [PATCH mlx5-next 09/10] net/rds: Handle ODP mr
 registration/unregistration
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20200115124340.79108-1-leon@kernel.org>
 <20200115124340.79108-10-leon@kernel.org>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <3c479d8a-f98a-a4c9-bd85-6332e919bf35@oracle.com>
Date:   Wed, 15 Jan 2020 13:51:23 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200115124340.79108-10-leon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150163
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/20 4:43 AM, Leon Romanovsky wrote:
> From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> 
> On-Demand-Paging MRs are registered using ib_reg_user_mr and
> unregistered with ib_dereg_mr.
> 
> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---

Have already reviewed this patchset on internal list. Couple of
minor nits below o.w patch looks good to me.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

[...]

> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index c8c1e3ae8d84..5a02b313ec50 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -37,8 +37,15 @@
> 
>   #include "rds_single_path.h"
>   #include "ib_mr.h"
> +#include "rds.h"
> 
>   struct workqueue_struct *rds_ib_mr_wq;
> +struct rds_ib_dereg_odp_mr {
> +	struct work_struct work;
> +	struct ib_mr *mr;
> +};
> +
> +static void rds_ib_odp_mr_worker(struct work_struct *work);
> 
>   static struct rds_ib_device *rds_ib_get_device(__be32 ipaddr)
>   {
> @@ -213,6 +220,8 @@ void rds_ib_sync_mr(void *trans_private, int direction)
>   	struct rds_ib_mr *ibmr = trans_private;
>   	struct rds_ib_device *rds_ibdev = ibmr->device;
> 
> +	if (ibmr->odp)
> +		return;
Add a new line here.
>   	switch (direction) {
>   	case DMA_FROM_DEVICE:
>   		ib_dma_sync_sg_for_cpu(rds_ibdev->dev, ibmr->sg,

[...]

> diff --git a/net/rds/rdma.c b/net/rds/rdma.c
> index eb23c38ce2b3..3c6afdda709b 100644
> --- a/net/rds/rdma.c
> +++ b/net/rds/rdma.c
> @@ -177,13 +177,14 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
>   			  struct rds_conn_path *cp)
>   {
>   	struct rds_mr *mr = NULL, *found;
> +	struct scatterlist *sg = NULL;
>   	unsigned int nr_pages;
>   	struct page **pages = NULL;
> -	struct scatterlist *sg;
>   	void *trans_private;
>   	unsigned long flags;
>   	rds_rdma_cookie_t cookie;
> -	unsigned int nents;
> +	unsigned int nents = 0;
> +	int need_odp = 0;
>   	long i;
>   	int ret;
> 
> @@ -196,6 +197,20 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
>   		ret = -EOPNOTSUPP;
>   		goto out;
>   	}
New line pls

