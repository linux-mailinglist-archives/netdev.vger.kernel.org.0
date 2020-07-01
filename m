Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0132A211565
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 23:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgGAVux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 17:50:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47582 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726109AbgGAVux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 17:50:53 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 061LXVfi186861
        for <netdev@vger.kernel.org>; Wed, 1 Jul 2020 17:50:53 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3212asrhjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 17:50:52 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 061LoNRV012484
        for <netdev@vger.kernel.org>; Wed, 1 Jul 2020 21:50:52 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 31wwr94ast-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 21:50:52 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 061LopBJ30867834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jul 2020 21:50:51 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62AEC112064;
        Wed,  1 Jul 2020 21:50:51 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2453A112061;
        Wed,  1 Jul 2020 21:50:51 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.125.189])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Jul 2020 21:50:51 +0000 (GMT)
Subject: Re: [PATCH] ibmvnic: store RX and TX subCRQ handle array in
 ibmvnic_adapter struct
To:     Cristobal Forno <cforno12@linux.ibm.com>, netdev@vger.kernel.org
References: <20200701212553.70956-1-cforno12@linux.ibm.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <d2ac4a60-9375-df80-4f00-7eae72c72291@linux.ibm.com>
Date:   Wed, 1 Jul 2020 16:50:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200701212553.70956-1-cforno12@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-01_15:2020-07-01,2020-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 cotscore=-2147483648
 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 phishscore=0
 mlxlogscore=987 suspectscore=2 lowpriorityscore=0 mlxscore=0 adultscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007010149
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/20 4:25 PM, Cristobal Forno wrote:
> Currently the driver reads RX and TX subCRQ handle array directly from
> a DMA-mapped buffer address when it needs to make a H_SEND_SUBCRQ
> hcall. This patch stores that information in the ibmvnic_sub_crq_queue
> structure instead of reading from the buffer received at login.
>   

Hi, thank you for the submission. I think it would be better, however, 
if each subCRQ structure had a member denoting its respective handle 
rather than a pointer to the handle array. This would allow us to 
discard the login_rsp buffer later when it is no longer needed.

Tom

> Signed-off-by: Cristobal Forno <cforno12@linux.ibm.com>
> ---
>   drivers/net/ethernet/ibm/ibmvnic.c | 27 ++++++++++++++++++++-------
>   drivers/net/ethernet/ibm/ibmvnic.h |  1 +
>   2 files changed, 21 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 0fd7eae25fe9..ca0d88aab6da 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -305,6 +305,7 @@ static void deactivate_rx_pools(struct ibmvnic_adapter *adapter)
>   static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
>   			      struct ibmvnic_rx_pool *pool)
>   {
> +	u64 *handle_array = adapter->rx_scrq[pool->index]->handle_array;
>   	int count = pool->size - atomic_read(&pool->available);
>   	struct device *dev = &adapter->vdev->dev;
>   	int buffers_added = 0;
> @@ -314,7 +315,6 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
>   	unsigned int offset;
>   	dma_addr_t dma_addr;
>   	unsigned char *dst;
> -	u64 *handle_array;
>   	int shift = 0;
>   	int index;
>   	int i;
> @@ -322,10 +322,6 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
>   	if (!pool->active)
>   		return;
>   
> -	handle_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
> -				      be32_to_cpu(adapter->login_rsp_buf->
> -				      off_rxadd_subcrqs));
> -
>   	for (i = 0; i < count; ++i) {
>   		skb = alloc_skb(pool->buff_size, GFP_ATOMIC);
>   		if (!skb) {
> @@ -1553,8 +1549,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
>   
>   	tx_scrq = adapter->tx_scrq[queue_num];
>   	txq = netdev_get_tx_queue(netdev, skb_get_queue_mapping(skb));
> -	handle_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
> -		be32_to_cpu(adapter->login_rsp_buf->off_txsubm_subcrqs));
> +	handle_array = tx_scrq->handle_array;
>   
>   	index = tx_pool->free_map[tx_pool->consumer_index];
>   
> @@ -4292,6 +4287,8 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
>   	struct net_device *netdev = adapter->netdev;
>   	struct ibmvnic_login_rsp_buffer *login_rsp = adapter->login_rsp_buf;
>   	struct ibmvnic_login_buffer *login = adapter->login_buf;
> +	int num_tx_pools;
> +	int num_rx_pools;
>   	int i;
>   
>   	dma_unmap_single(dev, adapter->login_buf_token, adapter->login_buf_sz,
> @@ -4326,6 +4323,22 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
>   		ibmvnic_remove(adapter->vdev);
>   		return -EIO;
>   	}
> +
> +	num_tx_pools = be32_to_cpu(adapter->login_rsp_buf->num_txsubm_subcrqs);
> +	num_rx_pools = be32_to_cpu(adapter->login_rsp_buf->num_rxadd_subcrqs);
> +
> +	for (i = 0; i < num_tx_pools; i++)
> +		adapter->tx_scrq[i]->handle_array =
> +			(u64 *)((u8 *)(adapter->login_rsp_buf) +
> +				be32_to_cpu(adapter->login_rsp_buf->
> +					    off_txsubm_subcrqs));
> +
> +	for (i = 0; i < num_rx_pools; i++)
> +		adapter->rx_scrq[i]->handle_array =
> +			(u64 *)((u8 *)(adapter->login_rsp_buf) +
> +				be32_to_cpu(adapter->login_rsp_buf->
> +					    off_rxadd_subcrqs));
> +
>   	release_login_buffer(adapter);
>   	complete(&adapter->init_done);
>   
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
> index f8416e1d4cf0..e51c72d1e357 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.h
> +++ b/drivers/net/ethernet/ibm/ibmvnic.h
> @@ -875,6 +875,7 @@ struct ibmvnic_sub_crq_queue {
>   	struct ibmvnic_adapter *adapter;
>   	atomic_t used;
>   	char name[32];
> +	u64 *handle_array;
>   };
>   
>   struct ibmvnic_long_term_buff {
