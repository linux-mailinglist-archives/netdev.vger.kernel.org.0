Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08AD4654E0
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 19:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbhLASRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:17:06 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17196 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352303AbhLASP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:15:26 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B1HpWVp020616
        for <netdev@vger.kernel.org>; Wed, 1 Dec 2021 18:12:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=sVvsyo7AAlc0UWw89n2r8UtpaJwY/YgGsoESQ9uI/AI=;
 b=Mo52zWQT7OnLwKVgAHsVMevpDoX27mTjR4xDufq+MilCgo6q4eP1hs0pbKOmBNx2l1Wc
 QYwIfmJ2ogoHTmea9CXwwGwWpg1UI06T+HXkVk9R6I4akupmSR7AebqBEhxWMXcOxz1L
 IZNLSoJ+l8rWkqXdegXfsQ3u241NHd6H8svNjptsab0avMUjwmMc+rcC4pKPTkh9C3Hp
 nTWlpK9FIBYKku92huvxwPNhAuJQ6F219hsAICz1bBdU9UfbVQOuoWEyJPAUaKl1a7nY
 PR6WiIcg0xfu4CW9V1PWYsISslhJfdE6n5VIYuLlT8urQLTevMnDC7vV2nLJx1+K2mLR nQ== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpdtrgd2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 18:12:04 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B1I7qKi018570
        for <netdev@vger.kernel.org>; Wed, 1 Dec 2021 18:12:04 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 3cn3k2j7d7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 18:12:04 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B1IC2u711731210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Dec 2021 18:12:02 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8098AC6063;
        Wed,  1 Dec 2021 18:12:02 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AA69C6057;
        Wed,  1 Dec 2021 18:12:02 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Dec 2021 18:12:02 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 01 Dec 2021 10:12:01 -0800
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net 1/2] ibmvnic: drop bad optimization in
 reuse_rx_pools()
In-Reply-To: <20211201054836.3488211-1-sukadev@linux.ibm.com>
References: <20211201054836.3488211-1-sukadev@linux.ibm.com>
Message-ID: <39329fc0c91ff049a5e90123d81ec097@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ECBsEs_90tKCw8EYjoc3WzlPRGQMLcZ1
X-Proofpoint-GUID: ECBsEs_90tKCw8EYjoc3WzlPRGQMLcZ1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-12-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 mlxlogscore=999 clxscore=1015 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112010098
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-30 21:48, Sukadev Bhattiprolu wrote:
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
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 3cca51735421..6df92a872f0f 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -628,17 +628,9 @@ static bool reuse_rx_pools(struct ibmvnic_adapter 
> *adapter)
>  	old_buff_size = adapter->prev_rx_buf_sz;
>  	new_buff_size = adapter->cur_rx_buf_sz;
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
>  		return false;
> 
>  	return true;
