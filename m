Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99558465531
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 19:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238596AbhLASVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:21:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38968 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233861AbhLASVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:21:36 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B1Hmaik004550
        for <netdev@vger.kernel.org>; Wed, 1 Dec 2021 18:18:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gLRhlN5ububsZB5XmxuD27emsizUryfIit7KpGYBoaI=;
 b=KcHGbGU5RpNt+i5df0wgsFwGFf2xmRWV/mOzDCzreQO/xRolD/oIBPSJzNKkA4ssxQ8P
 lxiWoKh8KWUKkLKtb4Su/RKJTAMK/LbQCayIZ8Dx7JqEdhR0kj4xsgL168jeuu5JHDsG
 MHMgTtdAL/n8pqAB1f2GjuXYTQ8ENBp9dEksadIXCwjkB3HdFmD/n7FkocreNhQBGyyp
 XGiuVWXoKPIqVKNqNHm2X4l+mOg/yCgMLBuTlQtcYxVM2UN7mlXuz7gDhiWpxSBXyIIY
 OhwBkTI9Vw0EjkHeseBXYFd3BjZazbzpOwK4qiMOl/JAcRPXbcIwyRjD6id1o75hHzLT qA== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpdsa8jd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 18:18:15 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B1I7pXc018521
        for <netdev@vger.kernel.org>; Wed, 1 Dec 2021 18:18:14 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 3cn3k2jb1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 18:18:14 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B1IIDGm59703784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Dec 2021 18:18:13 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 687F513604F;
        Wed,  1 Dec 2021 18:18:13 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DBA6136055;
        Wed,  1 Dec 2021 18:18:12 +0000 (GMT)
Received: from [9.160.26.90] (unknown [9.160.26.90])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Dec 2021 18:18:12 +0000 (GMT)
Message-ID: <c0f78b99-29ce-5565-b0ae-d2e45fce07bd@linux.vnet.ibm.com>
Date:   Wed, 1 Dec 2021 10:18:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net 1/2] ibmvnic: drop bad optimization in
 reuse_rx_pools()
Content-Language: en-US
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>, netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
References: <20211201054836.3488211-1-sukadev@linux.ibm.com>
From:   Rick Lindsley <ricklind@linux.vnet.ibm.com>
In-Reply-To: <20211201054836.3488211-1-sukadev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dnOXxTr7oniIUHsyhM_zbjESmuq1ebJ-
X-Proofpoint-GUID: dnOXxTr7oniIUHsyhM_zbjESmuq1ebJ-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-12-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxlogscore=999
 phishscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112010098
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/21 21:48, Sukadev Bhattiprolu wrote:
> When trying to decide whether or not reuse existing rx/tx pools
> we tried to allow a range of values for the pool parameters rather
> than exact matches. This was intended to reuse the resources for
> instance when switching between two VIO servers with different
> default parameters.
> 
> But this optimization is incomplete and breaks when we try to
> change the number of queues for instance. The optimization needs
> to be updated, so drop it for now and simplify the code.
> 
> Fixes: 489de956e7a2 ("ibmvnic: Reuse rx pools when possible")
> Reported-by: Dany Madden <drt@linux.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

Reviewed-by: Rick Lindsley <ricklind@linux.ibm.com>

> ---
>   drivers/net/ethernet/ibm/ibmvnic.c | 14 +++-----------
>   1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 3cca51735421..6df92a872f0f 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -628,17 +628,9 @@ static bool reuse_rx_pools(struct ibmvnic_adapter *adapter)
>   	old_buff_size = adapter->prev_rx_buf_sz;
>   	new_buff_size = adapter->cur_rx_buf_sz;
>   
> -	/* Require buff size to be exactly same for now */
> -	if (old_buff_size != new_buff_size)
> -		return false;
> -
> -	if (old_num_pools == new_num_pools && old_pool_size == new_pool_size)
> -		return true;
> -
> -	if (old_num_pools < adapter->min_rx_queues ||
> -	    old_num_pools > adapter->max_rx_queues ||
> -	    old_pool_size < adapter->min_rx_add_entries_per_subcrq ||
> -	    old_pool_size > adapter->max_rx_add_entries_per_subcrq)
> +	if (old_buff_size != new_buff_size ||
> +	    old_num_pools != new_num_pools ||
> +	    old_pool_size != new_pool_size)
>   		return false;
>   
>   	return true;
> 

