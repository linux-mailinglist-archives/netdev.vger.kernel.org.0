Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3B926C9E0
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 21:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbgIPTeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 15:34:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36056 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbgIPTbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 15:31:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GJObHT022349;
        Wed, 16 Sep 2020 19:30:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Zi4KIsbSGtozSi0Vpv/S07eccak3oW8n1oDQsyU9fn8=;
 b=KPpTtv0+WFGmHMu202FqIcRPq/CZd0F+tnpzfqpjdb1crdBcr+4tZ1mDNZAqdow10Iqj
 502pmcPeGkGrIy1djPkqCe2WVDeXaVfV8cCnHZIUoT9ZLhWeQ0ZJyXE6faSX2jGiRWx9
 ryDpgXL7jrwMG7VGVrxHYepXhpnjKxyqPr+3418vepsEp8zaa7MBHjUv+FToAiTAjwVs
 TNQQeHNYP65qhB0ngQQzTrUiirjjZRj05bTbGiC7n+Cd+tnx8zSxJtzgMoxd+uNCLP+b
 xEFU0wrQVqdywaMnv/IpHOKb4NCWQtGASRdpKASLK+Ne/x+boBAMnXUlM712jv8LbKdd 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33j91dpr4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 19:30:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GJPUGF056658;
        Wed, 16 Sep 2020 19:28:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33h8893f2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 19:28:22 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08GJSMRX027971;
        Wed, 16 Sep 2020 19:28:22 GMT
Received: from [10.74.111.69] (/10.74.111.69)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 19:27:42 +0000
Subject: Re: [PATCH 1/1] net/rds: suppress page allocation failure error in
 recv buffer refill
To:     Manjunath Patil <manjunath.b.patil@oracle.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        aruna.ramakrishna@oracle.com, rama.nichanamatlu@oracle.com
References: <1600283326-30323-1-git-send-email-manjunath.b.patil@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <389b52c6-0d9a-7644-49f6-66eb7a45b3e6@oracle.com>
Date:   Wed, 16 Sep 2020 12:27:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1600283326-30323-1-git-send-email-manjunath.b.patil@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1011 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160137
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/20 12:08 PM, Manjunath Patil wrote:
> RDS/IB tries to refill the recv buffer in softirq context using
> GFP_NOWAIT flag. However alloc failure is handled by queueing a work to
> refill the recv buffer with GFP_KERNEL flag. This means failure to
> allocate with GFP_NOWAIT isn't fatal. Do not print the PAF warnings if
> softirq context fails to refill the recv buffer, instead print a one
> line warning once a day.
> 
> Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
> Reviewed-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
> ---
>   net/rds/ib_recv.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> index 694d411dc72f..38d2894f6bb2 100644
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c
> @@ -310,8 +310,8 @@ static int rds_ib_recv_refill_one(struct rds_connection *conn,
>   	struct rds_ib_connection *ic = conn->c_transport_data;
>   	struct ib_sge *sge;
>   	int ret = -ENOMEM;
> -	gfp_t slab_mask = GFP_NOWAIT;
> -	gfp_t page_mask = GFP_NOWAIT;
> +	gfp_t slab_mask = gfp;
> +	gfp_t page_mask = gfp;
>   
>   	if (gfp & __GFP_DIRECT_RECLAIM) {
>   		slab_mask = GFP_KERNEL;
> @@ -406,6 +406,16 @@ void rds_ib_recv_refill(struct rds_connection *conn, int prefill, gfp_t gfp)
>   		recv = &ic->i_recvs[pos];
>   		ret = rds_ib_recv_refill_one(conn, recv, gfp);
>   		if (ret) {
> +			static unsigned long warn_time;
Comment should start on next line.
> +			/* warn max once per day. This should be enough to
> +			 * warn users about low mem situation.
> +			 */
> +			if (printk_timed_ratelimit(&warn_time,
> +						   24 * 60 * 60 * 1000))
> +				pr_warn("RDS/IB: failed to refill recv buffer for <%pI6c,%pI6c,%d>, waking worker\n",
> +					&conn->c_laddr, &conn->c_faddr,
> +					conn->c_tos);
Didn't notice this before.
Why not just use "pr_warn_ratelimited()" ?
> +
>   			must_wake = true;
>   			break;
>   		}
> @@ -1020,7 +1030,7 @@ void rds_ib_recv_cqe_handler(struct rds_ib_connection *ic,
>   		rds_ib_stats_inc(s_ib_rx_ring_empty);
>   
>   	if (rds_ib_ring_low(&ic->i_recv_ring)) {
> -		rds_ib_recv_refill(conn, 0, GFP_NOWAIT);
> +		rds_ib_recv_refill(conn, 0, GFP_NOWAIT | __GFP_NOWARN);
>   		rds_ib_stats_inc(s_ib_rx_refill_from_cq);
>   	}
>   }
> 
