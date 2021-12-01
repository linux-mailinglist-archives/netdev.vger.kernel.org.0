Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E587F4654E3
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 19:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352135AbhLASRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:17:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12636 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239354AbhLASQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:16:34 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B1Glf5u018387
        for <netdev@vger.kernel.org>; Wed, 1 Dec 2021 18:13:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=wcU2JHvIgRj2vwouYU82qeTKkm53nYXLBUk5ZPSDHeg=;
 b=mkQTZdjuFQiLvTGmcD5rLfYlKX2RQum9cY2yJ777URs+kyckyPpQ7hCenXXWyO4NUfQZ
 Ou3Dd/TYl8wmC6GRNACvWHtPkQ+nzz11AdRCduriE20UjBvxACXhxIvlNX/u4tkKNaTp
 5bNJUpYob5OmLLB+ZFJiBf0f72ZLq0MNyd9fu0V/06d8XbxfbPhQ1833UCux7k1yucgY
 zFv7lb4nF76xK/VyqqhaZbMTMu7bMdww0UE4PHsaadVurm/nOUELE2NBJXsAw4H7O07E
 GpgEiUDWalq5+ie1mUZi6ze0q/YEfT+QVJSUNnHlFus3+x3gxcByuRg0U/H1kUDRW5tz jg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpcvqstpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 18:13:13 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B1I7K3p011828
        for <netdev@vger.kernel.org>; Wed, 1 Dec 2021 18:13:13 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 3cnne2c5mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 18:13:12 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B1IDBne27853150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Dec 2021 18:13:11 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3F3B28072;
        Wed,  1 Dec 2021 18:13:10 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B93742805C;
        Wed,  1 Dec 2021 18:13:10 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Dec 2021 18:13:10 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 01 Dec 2021 10:13:10 -0800
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net 2/2] ibmvnic: drop bad optimization in
 reuse_tx_pools()
In-Reply-To: <20211201054836.3488211-2-sukadev@linux.ibm.com>
References: <20211201054836.3488211-1-sukadev@linux.ibm.com>
 <20211201054836.3488211-2-sukadev@linux.ibm.com>
Message-ID: <9b4f0980933eaa345b5dc25a4c9f41ae@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: p7--9l1rPeHXgIFR5t6h_JAxY1KMiMmk
X-Proofpoint-ORIG-GUID: p7--9l1rPeHXgIFR5t6h_JAxY1KMiMmk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-12-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0 impostorscore=0
 adultscore=0 phishscore=0 mlxscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
> Fixes: bbd809305bc7 ("ibmvnic: Reuse tx pools when possible")
> Reported-by: Dany Madden <drt@linux.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 6df92a872f0f..0bb3911dd014 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -866,17 +866,9 @@ static bool reuse_tx_pools(struct ibmvnic_adapter 
> *adapter)
>  	old_mtu = adapter->prev_mtu;
>  	new_mtu = adapter->req_mtu;
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
>  		return false;
> 
>  	return true;
