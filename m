Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E177D465532
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 19:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbhLASVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:21:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20690 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238751AbhLASVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:21:41 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B1HmUQF004317
        for <netdev@vger.kernel.org>; Wed, 1 Dec 2021 18:18:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/VHy8/Rf9yENVKrYvdEcGXQOJZow5ZxmvedoYglbDhA=;
 b=b6AlwNdONoWxmLNgvCB6f2qOQjLbF7eNbu8OOk1VwNkZsYEI9URXbbBVOY58PmBNJi94
 cWS4dh0Em+zeUYYCGWeu+JvBIRoYv0L5s6lulihaLrv/4PYtuhR33CthhjeQqjANE5rF
 5ESotTMkmtskVM8neTgp3ct37fDgEvubDImBLv0jUSr/3ba7XLUDGIKpZxQk+xv2kJC3
 gQt/53xoW9UWpk1Ng6SJotHDdbMwFH2yz4EVSKnpdqJKDpy0dwTPD68tt50cSOxA7jWI
 +lAkcDiHeevkR27uHYx/LeGS7l1/HlXwvZ9Pzj5ATmgdgoP8SPvOfwjl5HPB8xeYPgXz 2w== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpdsa8jeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 18:18:20 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B1I7p0G018525
        for <netdev@vger.kernel.org>; Wed, 1 Dec 2021 18:18:19 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03wdc.us.ibm.com with ESMTP id 3cn3k2jb2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 18:18:19 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B1III3N33161718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Dec 2021 18:18:18 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36FD913604F;
        Wed,  1 Dec 2021 18:18:18 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65626136063;
        Wed,  1 Dec 2021 18:18:17 +0000 (GMT)
Received: from [9.160.26.90] (unknown [9.160.26.90])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Dec 2021 18:18:17 +0000 (GMT)
Message-ID: <49f778db-0aee-f401-456d-3112045aaeaa@linux.vnet.ibm.com>
Date:   Wed, 1 Dec 2021 10:18:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net 2/2] ibmvnic: drop bad optimization in
 reuse_tx_pools()
Content-Language: en-US
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>, netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
References: <20211201054836.3488211-1-sukadev@linux.ibm.com>
 <20211201054836.3488211-2-sukadev@linux.ibm.com>
From:   Rick Lindsley <ricklind@linux.vnet.ibm.com>
In-Reply-To: <20211201054836.3488211-2-sukadev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6Ca4ekkosqywK_wtkySLPxTeV8zKazrR
X-Proofpoint-GUID: 6Ca4ekkosqywK_wtkySLPxTeV8zKazrR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-12-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
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
> Fixes: bbd809305bc7 ("ibmvnic: Reuse tx pools when possible")
> Reported-by: Dany Madden <drt@linux.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

Reviewed-by: Rick Lindsley <ricklind@linux.ibm.com>

> ---
>   drivers/net/ethernet/ibm/ibmvnic.c | 14 +++-----------
>   1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 6df92a872f0f..0bb3911dd014 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -866,17 +866,9 @@ static bool reuse_tx_pools(struct ibmvnic_adapter *adapter)
>   	old_mtu = adapter->prev_mtu;
>   	new_mtu = adapter->req_mtu;
>   
> -	/* Require MTU to be exactly same to reuse pools for now */
> -	if (old_mtu != new_mtu)
> -		return false;
> -
> -	if (old_num_pools == new_num_pools && old_pool_size == new_pool_size)
> -		return true;
> -
> -	if (old_num_pools < adapter->min_tx_queues ||
> -	    old_num_pools > adapter->max_tx_queues ||
> -	    old_pool_size < adapter->min_tx_entries_per_subcrq ||
> -	    old_pool_size > adapter->max_tx_entries_per_subcrq)
> +	if (old_mtu != new_mtu ||
> +	    old_num_pools != new_num_pools ||
> +	    old_pool_size != new_pool_size)
>   		return false;
>   
>   	return true;
> 

