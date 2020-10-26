Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE172991B1
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 17:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1784676AbgJZQCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 12:02:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35832 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1773897AbgJZQBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 12:01:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QG0RiS143985;
        Mon, 26 Oct 2020 16:01:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=puZm8te2B4YUXTyJ+yl+MFZs9tJFgCp00txrAgjUTd8=;
 b=srkrKcxd0TjuqXDo4tCrkWwipxah5XrMtCOqExR6Sbwke60m+ZNE/d2owiP1dq72ckY+
 41u5K7b0JhJxQm4RChV7MJSSy+AxIb/GkBOItJjXLwllSRl8kAq4prJWUdBXZkg1IUW5
 SCkbeeXPbboMDISRH5LLEW49vu8eLv5oGC64AViH2mbD2JZfiEgTxE/7nLjtZw5elNnR
 wn4sGVvzwLBDb12E2K4Hw4hRt8hsWv8MQRgVMY+yfoPDe/lq/tnYrjNWgGibrxSEv9gD
 aYU/eRL15HRufvKGRxS7gMNEKpyiu0Qv7DyLL+kUKHys36gyZTRt/O2aVPdSrcJnkgSC wA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm3u1de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 16:01:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QG0FsQ154600;
        Mon, 26 Oct 2020 16:01:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 34cx1pp5gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 16:01:26 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09QG1PHM161397;
        Mon, 26 Oct 2020 16:01:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34cx1pp5g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 16:01:25 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QG1NSx023332;
        Mon, 26 Oct 2020 16:01:24 GMT
Received: from [10.74.104.229] (/10.74.104.229)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 09:01:23 -0700
Subject: Re: [PATCH] RDMA: Add rdma_connect_locked()
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        Doug Ledford <dledford@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, Sagi Grimberg <sagi@grimberg.me>
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Leon Romanovsky <leonro@nvidia.com>
References: <0-v1-75e124dbad74+b05-rdma_connect_locking_jgg@nvidia.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <ed68ad93-602e-c617-87e4-a713856478a0@oracle.com>
Date:   Mon, 26 Oct 2020 09:01:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <0-v1-75e124dbad74+b05-rdma_connect_locking_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1011 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/20 7:25 AM, Jason Gunthorpe wrote:
> There are two flows for handling RDMA_CM_EVENT_ROUTE_RESOLVED, either the
> handler triggers a completion and another thread does rdma_connect() or
> the handler directly calls rdma_connect().
> 
> In all cases rdma_connect() needs to hold the handler_mutex, but when
> handler's are invoked this is already held by the core code. This causes
> ULPs using the 2nd method to deadlock.
> 
> Provide a rdma_connect_locked() and have all ULPs call it from their
> handlers.
> 
> Reported-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> Fixes: 2a7cec538169 ("RDMA/cma: Fix locking for the RDMA_CM_CONNECT state"
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---

[....]

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 06603dd1c8aa38..b36b60668b1da9 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -956,9 +956,10 @@ int rds_ib_cm_initiate_connect(struct rdma_cm_id *cm_id, bool isv6)
>   	rds_ib_cm_fill_conn_param(conn, &conn_param, &dp,
>   				  conn->c_proposed_version,
>   				  UINT_MAX, UINT_MAX, isv6);
> -	ret = rdma_connect(cm_id, &conn_param);
> +	ret = rdma_connect_locked(cm_id, &conn_param);
>   	if (ret)
> -		rds_ib_conn_error(conn, "rdma_connect failed (%d)\n", ret);
> +		rds_ib_conn_error(conn, "rdma_connect_locked failed (%d)\n",
> +				  ret);
>   
>   out:
>   	/* Beware - returning non-zero tells the rdma_cm to destroy
> 
For RDS part,
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
