Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3180423E21
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 19:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392755AbfETRPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 13:15:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41510 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388626AbfETRPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 13:15:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KH9cXP062262;
        Mon, 20 May 2019 17:14:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=kGU75vAibIXS1zkcp74MuQ55umzfkXnaT6ysiYcIWMk=;
 b=I0RRRHd+1g8GL4KPfCdRrDxz59tfbuH/oDLkWIgQr0NZ1F00YR/77yMcN/12j9banMW4
 v+LMfShYn2BCVr1sQZDrNudC54I0HQvCiw/5+R+CVUbZoz/Su1zhvATLOFRUsO5dmGBt
 nlS7XiOYfr8C77y7Hls6Y+oZB1cvDOeWDohAKDnBZ0bHQK9jMhOM12YL0GrGMcukK7wv
 gW8hK/ulhrn1VPAe0R1QvXcrn8sz+abGD/09rJLcqEFxLdE03Elav2u2Is5Si6TAQxqP
 0lBbyK24+nCZIgMuU0ZHBgwMEkVkVEesFSpxGzfRvLToIQW5I2rLB9cDIX+9GI+0bEBG wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2sjapq898x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 17:14:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KHDco8035252;
        Mon, 20 May 2019 17:14:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2sks1hygaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 17:14:46 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KHEiUA005356;
        Mon, 20 May 2019 17:14:45 GMT
Received: from [10.209.243.127] (/10.209.243.127)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 17:14:44 +0000
Subject: Re: [PATCH rdma-next 01/15] rds: Don't check return value from
 destroy CQ
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Glenn Streiff <gstreiff@neteffect.com>,
        Steve Wise <swise@opengridcomputing.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20190520065433.8734-1-leon@kernel.org>
 <20190520065433.8734-2-leon@kernel.org>
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <9db089b4-d088-9b2a-c6ce-350e11fb5460@oracle.com>
Date:   Mon, 20 May 2019 10:17:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520065433.8734-2-leon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9262 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200109
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9262 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/2019 11:54 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> There is no value in checking ib_destroy_cq() result and skipping
> to clear struct ic fields. This connection needs to be reinitialized
> anyway.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>   net/rds/ib_cm.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 66c6eb56072b..5a42ebb892cd 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -611,11 +611,11 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
>   qp_out:
>   	rdma_destroy_qp(ic->i_cm_id);
>   recv_cq_out:
> -	if (!ib_destroy_cq(ic->i_recv_cq))
> -		ic->i_recv_cq = NULL;
> +	ib_destroy_cq(ic->i_recv_cq);
> +	ic->i_recv_cq = NULL;
>   send_cq_out:
> -	if (!ib_destroy_cq(ic->i_send_cq))
> -		ic->i_send_cq = NULL;
> +	ib_destroy_cq(ic->i_send_cq);
> +	ic->i_send_cq = NULL;
This was done to ensure, you still don't get ISR delivering
the CQEs while we are in shutdown path. Your patch
is fine though since you don't change that behavior.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>


