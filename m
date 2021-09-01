Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3463FD0BA
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 03:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241629AbhIABbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 21:31:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234036AbhIABbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 21:31:13 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 181142NR008167
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:30:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=jBFBAKPDebc0CBQdkmJxh0Mwre6cVH6rRR6VXpnTucI=;
 b=DEhOx/Inbx14wKlKNdX7R9wI4++FS/br7GMvupuKnnA0QS8ADVXK+ejl/tQdfA4LkFL2
 2Fzn2y6Mjp05Xe4TqAdbREtHqGSmafIv/qlQbxKmmRScYjvYHYJ/8iEanuO+wt6Bhssy
 qgQMPLwyJyN+1N1OlSygxhCk503UzMemBSPgLlaIIVkb3k02j8r6BkvjZCiqKRUHf8R6
 gYRRHYgoAe2P41PyFdtvde52AOnhgerdQ/rghh6iOM+kTUcp+fSugbUDiNOk7hwE8Uv3
 sZ7ROfqv0LZBf7lyed5J31Kq+Z65V2NWut6uV7O4V4El6wvaA569nvJwXs3CyUhjFg0c jA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3asyfd8k6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:30:17 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1811Shkt018917
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 01:30:16 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02dal.us.ibm.com with ESMTP id 3aqcsdkm1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 01:30:16 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1811UEQI25297236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 01:30:14 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA2B27807F;
        Wed,  1 Sep 2021 01:30:14 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69B467805F;
        Wed,  1 Sep 2021 01:30:14 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 01:30:14 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 31 Aug 2021 18:30:14 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        cforno12@linux.ibm.com, Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next 4/9] ibmvnic: Use/rename local vars in
 init_tx_pools
In-Reply-To: <20210901000812.120968-5-sukadev@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
 <20210901000812.120968-5-sukadev@linux.ibm.com>
Message-ID: <c79c0aed675aa2997866f4fe519fe561@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: h3_Q3P3ZTcITc0kHTPgvlMUSMmmGvHkJ
X-Proofpoint-ORIG-GUID: h3_Q3P3ZTcITc0kHTPgvlMUSMmmGvHkJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_10:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2109010005
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-31 17:08, Sukadev Bhattiprolu wrote:
> Use/rename local variables in init_tx_pools() for consistency with
> init_rx_pools() and for readability. Also add some comments
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index a611bd3f2539..4c6739b250df 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -777,31 +777,31 @@ static void release_tx_pools(struct
> ibmvnic_adapter *adapter)
> 
>  static int init_one_tx_pool(struct net_device *netdev,
>  			    struct ibmvnic_tx_pool *tx_pool,
> -			    int num_entries, int buf_size)
> +			    int pool_size, int buf_size)
>  {
>  	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
>  	int i;
> 
> -	tx_pool->tx_buff = kcalloc(num_entries,
> +	tx_pool->tx_buff = kcalloc(pool_size,
>  				   sizeof(struct ibmvnic_tx_buff),
>  				   GFP_KERNEL);
>  	if (!tx_pool->tx_buff)
>  		return -1;
> 
>  	if (alloc_long_term_buff(adapter, &tx_pool->long_term_buff,
> -				 num_entries * buf_size))
> +				 pool_size * buf_size))
>  		return -1;
> 
> -	tx_pool->free_map = kcalloc(num_entries, sizeof(int), GFP_KERNEL);
> +	tx_pool->free_map = kcalloc(pool_size, sizeof(int), GFP_KERNEL);
>  	if (!tx_pool->free_map)
>  		return -1;
> 
> -	for (i = 0; i < num_entries; i++)
> +	for (i = 0; i < pool_size; i++)
>  		tx_pool->free_map[i] = i;
> 
>  	tx_pool->consumer_index = 0;
>  	tx_pool->producer_index = 0;
> -	tx_pool->num_buffers = num_entries;
> +	tx_pool->num_buffers = pool_size;
>  	tx_pool->buf_size = buf_size;
> 
>  	return 0;
> @@ -811,17 +811,20 @@ static int init_tx_pools(struct net_device 
> *netdev)
>  {
>  	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
>  	struct device *dev = &adapter->vdev->dev;
> -	int tx_subcrqs;
> +	int num_pools;
> +	u64 pool_size;		/* # of buffers in pool */
>  	u64 buff_size;
>  	int i, rc;
> 
> -	tx_subcrqs = adapter->num_active_tx_scrqs;
> -	adapter->tx_pool = kcalloc(tx_subcrqs,
> +	pool_size = adapter->req_tx_entries_per_subcrq;
> +	num_pools = adapter->num_active_tx_scrqs;
> +
> +	adapter->tx_pool = kcalloc(num_pools,
>  				   sizeof(struct ibmvnic_tx_pool), GFP_KERNEL);
>  	if (!adapter->tx_pool)
>  		return -1;
> 
> -	adapter->tso_pool = kcalloc(tx_subcrqs,
> +	adapter->tso_pool = kcalloc(num_pools,
>  				    sizeof(struct ibmvnic_tx_pool), GFP_KERNEL);
>  	/* To simplify release_tx_pools() ensure that ->tx_pool and
>  	 * ->tso_pool are either both NULL or both non-NULL.
> @@ -835,9 +838,9 @@ static int init_tx_pools(struct net_device *netdev)
>  	/* Set num_active_tx_pools early. If we fail below after partial
>  	 * allocation, release_tx_pools() will know how many to look for.
>  	 */
> -	adapter->num_active_tx_pools = tx_subcrqs;
> +	adapter->num_active_tx_pools = num_pools;
> 
> -	for (i = 0; i < tx_subcrqs; i++) {
> +	for (i = 0; i < num_pools; i++) {
>  		buff_size = adapter->req_mtu + VLAN_HLEN;
>  		buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
> 
> @@ -845,8 +848,7 @@ static int init_tx_pools(struct net_device *netdev)
>  			i, adapter->req_tx_entries_per_subcrq, buff_size);
> 
>  		rc = init_one_tx_pool(netdev, &adapter->tx_pool[i],
> -				      adapter->req_tx_entries_per_subcrq,
> -				      buff_size);
> +				      pool_size, buff_size);
>  		if (rc) {
>  			release_tx_pools(adapter);
>  			return rc;
