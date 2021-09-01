Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73A63FD0B0
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 03:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241613AbhIAB1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 21:27:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58656 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234036AbhIAB1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 21:27:54 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18113KsB050537
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:26:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=ngkU0GoDONs1EGwDyWe8rD8a2HjxvBEMbKJi3NyZwFs=;
 b=C0FHTzZ5/TEJHYlEg7/QiMGUwZi8k3RefJuZGaSH/Tq4Zvnn2iurISlVHo9208g47eEr
 +JrRN5jqulI0vXd2FO7zG49nK+fKmOsQtmFlt7z+ynpKf9aO6ZMn5/jtymVqKKIBf0OU
 rIMbItLCJ90at5BPNdoKQjdDWTCnSFEM40jriTe5JfNwrJ7ZUPBtusHe031w7zAScAMV
 FrBJY5C6xSuDxXIjFXRHzShLr07W8T8HoYLsGha+WyquhryGwyUFhK5DSR1hcbc1wdbD
 84VozSTr/yGbuBSrzN46vjP7PwwWBjhXy9IvazeigQon0XkxkiUenWnc5DcfLxvxk60U dQ== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3asx59a0j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:26:58 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1811Bdew013008
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 01:26:56 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 3aqcscbccu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 01:26:56 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1811QtSU50463026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 01:26:55 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65FAF6E052;
        Wed,  1 Sep 2021 01:26:55 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 123A06E04E;
        Wed,  1 Sep 2021 01:26:54 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 01:26:54 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 31 Aug 2021 18:26:54 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        cforno12@linux.ibm.com, Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next 1/9] ibmvnic: Consolidate code in
 replenish_rx_pool()
In-Reply-To: <20210901000812.120968-2-sukadev@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
 <20210901000812.120968-2-sukadev@linux.ibm.com>
Message-ID: <81e15c4739a2ba9ddcc61d973c597433@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: k6_CcXLhB46-Tap913H82nzs17MQLc_V
X-Proofpoint-ORIG-GUID: k6_CcXLhB46-Tap913H82nzs17MQLc_V
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_10:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0 impostorscore=0
 clxscore=1011 mlxscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2109010005
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-31 17:08, Sukadev Bhattiprolu wrote:
> For better readability, consolidate related code in replenish_rx_pool()
> and add some comments.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index a775c69e4fd7..e8b1231be485 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -371,6 +371,8 @@ static void replenish_rx_pool(struct
> ibmvnic_adapter *adapter,
>  		}
> 
>  		index = pool->free_map[pool->next_free];
> +		pool->free_map[pool->next_free] = IBMVNIC_INVALID_MAP;
> +		pool->next_free = (pool->next_free + 1) % pool->size;
> 
>  		if (pool->rx_buff[index].skb)
>  			dev_err(dev, "Inconsistent free_map!\n");
> @@ -380,14 +382,15 @@ static void replenish_rx_pool(struct
> ibmvnic_adapter *adapter,
>  		dst = pool->long_term_buff.buff + offset;
>  		memset(dst, 0, pool->buff_size);
>  		dma_addr = pool->long_term_buff.addr + offset;
> -		pool->rx_buff[index].data = dst;
> 
> -		pool->free_map[pool->next_free] = IBMVNIC_INVALID_MAP;
> +		/* add the skb to an rx_buff in the pool */
> +		pool->rx_buff[index].data = dst;
>  		pool->rx_buff[index].dma = dma_addr;
>  		pool->rx_buff[index].skb = skb;
>  		pool->rx_buff[index].pool_index = pool->index;
>  		pool->rx_buff[index].size = pool->buff_size;
> 
> +		/* queue the rx_buff for the next send_subcrq_indirect */
>  		sub_crq = &ind_bufp->indir_arr[ind_bufp->index++];
>  		memset(sub_crq, 0, sizeof(*sub_crq));
>  		sub_crq->rx_add.first = IBMVNIC_CRQ_CMD;
> @@ -405,7 +408,8 @@ static void replenish_rx_pool(struct
> ibmvnic_adapter *adapter,
>  		shift = 8;
>  #endif
>  		sub_crq->rx_add.len = cpu_to_be32(pool->buff_size << shift);
> -		pool->next_free = (pool->next_free + 1) % pool->size;
> +
> +		/* if send_subcrq_indirect queue is full, flush to VIOS */
>  		if (ind_bufp->index == IBMVNIC_MAX_IND_DESCS ||
>  		    i == count - 1) {
>  			lpar_rc =
