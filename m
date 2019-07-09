Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE7963246
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 09:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfGIHjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 03:39:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45376 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfGIHjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 03:39:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x697XSRZ192283;
        Tue, 9 Jul 2019 07:38:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=5MlwOig06l4w3oUj/JBnWRkeZbdGCh0w6C/GQ+z0nss=;
 b=nbYN2t3Y63TqGktcs9RT/iApdqzD4k0e320Id2dZzfDUt3TSbpWjpsnNFL7PuSnptrxt
 Bjg9fQdTk34/dmd8uY5P9DRyrapRLD7TIAestgcGki6UVKQjrqPCBlfEN5c+/U+wZGsj
 rD8JRWzgQ94TpKWO6OpK/kd7pufaTdrxHdlWaE6ZZQxLGuaMESrQJ07rTvGNbDQLTHnK
 T7MLkRswtO94kbkQwmPAsdk3xm7JgjJDyhYw3LsmiBhBtvDv2WvL3ZD4oGYD4U3nqfQA
 dT2k34PFgI1P8aVkWuuWzGKPp4xjvMDsgHxViQp1ze75Ez+UJtF11CrFE1F3J9ozu0zs Qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2tjm9qjgn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 07:38:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x697X2Eh143719;
        Tue, 9 Jul 2019 07:36:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tmmh2t2c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 07:36:48 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x697alUn001921;
        Tue, 9 Jul 2019 07:36:47 GMT
Received: from [10.182.69.170] (/10.182.69.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 00:36:47 -0700
Subject: Re: [PATCH 1/2] forcedeth: add recv cache make nic work steadily
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <1562307568-21549-1-git-send-email-yanjun.zhu@oracle.com>
 <1562307568-21549-2-git-send-email-yanjun.zhu@oracle.com>
 <20190708135257.18200316@cakuba.netronome.com>
From:   Yanjun Zhu <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <9506e4a2-a51b-795d-a01d-a21f112c0597@oracle.com>
Date:   Tue, 9 Jul 2019 15:38:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708135257.18200316@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9312 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907090091
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9312 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907090091
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/9 4:52, Jakub Kicinski wrote:
> On Fri,  5 Jul 2019 02:19:27 -0400, Zhu Yanjun wrote:
>> A recv cache is added. The size of recv cache is 1000Mb / skb_length.
>> When the system memory is not enough, this recv cache can make nic work
>> steadily.
>> When nic is up, this recv cache and work queue are created. When nic
>> is down, this recv cache will be destroyed and delayed workqueue is
>> canceled.
>> When nic is polled or rx interrupt is triggerred, rx handler will
>> get a skb from recv cache. Then the state of recv cache is checked.
>> If recv cache is not in filling up state, a work is queued to fill
>> up recv cache.
>> When skb size is changed, the old recv cache is destroyed and new recv
>> cache is created.
>> When the system memory is not enough, the allocation of skb failed.
>> recv cache will continue allocate skb until the recv cache is filled up.
>> When the system memory is not enough, this can make nic work steadily.
>> Becase of recv cache, the performance of nic is enhanced.
>>
>> CC: Joe Jin <joe.jin@oracle.com>
>> CC: Junxiao Bi <junxiao.bi@oracle.com>
>> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> Could you tell us a little more about the use case and the system
> condition?

When the host run for long time, there are a lot of memory fragments in 
hosts.

In this condition, this patch can help us a lot.

>
>> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
>> index b327b29..a673005 100644
>> --- a/drivers/net/ethernet/nvidia/forcedeth.c
>> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
>> @@ -674,6 +674,11 @@ struct nv_ethtool_stats {
>>   	u64 tx_broadcast;
>>   };
>>   
>> +/* 1000Mb is 125M bytes, 125 * 1024 * 1024 bytes
>> + * The length of recv cache is 125M / skb_length
>> + */
>> +#define RECV_CACHE_LIST_LENGTH		(125 * 1024 * 1024 / np->rx_buf_sz)
>> +
>>   #define NV_DEV_STATISTICS_V3_COUNT (sizeof(struct nv_ethtool_stats)/sizeof(u64))
>>   #define NV_DEV_STATISTICS_V2_COUNT (NV_DEV_STATISTICS_V3_COUNT - 3)
>>   #define NV_DEV_STATISTICS_V1_COUNT (NV_DEV_STATISTICS_V2_COUNT - 6)
>> @@ -844,8 +849,18 @@ struct fe_priv {
>>   	char name_rx[IFNAMSIZ + 3];       /* -rx    */
>>   	char name_tx[IFNAMSIZ + 3];       /* -tx    */
>>   	char name_other[IFNAMSIZ + 6];    /* -other */
>> +
>> +	/* This is to schedule work */
>> +	struct delayed_work     recv_cache_work;
>> +	/* This list is to store skb queue for recv */
>> +	struct sk_buff_head recv_list;
>> +	unsigned long nv_recv_list_state;
>>   };
>>   
>> +/* This is recv list state to fill up recv cache */
>> +enum recv_list_state {
>> +	RECV_LIST_ALLOCATE
>> +};
>>   /*
>>    * Maximum number of loops until we assume that a bit in the irq mask
>>    * is stuck. Overridable with module param.
>> @@ -1804,7 +1819,11 @@ static int nv_alloc_rx(struct net_device *dev)
>>   		less_rx = np->last_rx.orig;
>>   
>>   	while (np->put_rx.orig != less_rx) {
>> -		struct sk_buff *skb = netdev_alloc_skb(dev, np->rx_buf_sz + NV_RX_ALLOC_PAD);
>> +		struct sk_buff *skb = skb_dequeue(&np->recv_list);
>> +
>> +		if (!test_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state))
>> +			schedule_delayed_work(&np->recv_cache_work, 0);
> Interesting, this seems to be coming up in multiple places recently..
>
> Could you explain why you have your own RECV_LIST_ALLOCATE bit here?
> Workqueue implementation itself uses an atomic bit to avoid scheduling
> work mutliple times:

This can avoid function call overhead to optimize the recv process.

Thanks

Zhu Yanjun

>
> bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
> 			   struct delayed_work *dwork, unsigned long delay)
> {
> 	struct work_struct *work = &dwork->work;
> 	bool ret = false;
> 	unsigned long flags;
>
> 	/* read the comment in __queue_work() */
> 	local_irq_save(flags);
>
> 	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
> 		__queue_delayed_work(cpu, wq, dwork, delay);
> 		ret = true;
> 	}
>
> 	local_irq_restore(flags);
> 	return ret;
> }
> EXPORT_SYMBOL(queue_delayed_work_on);
>
>>   		if (likely(skb)) {
>>   			np->put_rx_ctx->skb = skb;
>>   			np->put_rx_ctx->dma = dma_map_single(&np->pci_dev->dev,
>> @@ -1845,7 +1864,11 @@ static int nv_alloc_rx_optimized(struct net_device *dev)
>>   		less_rx = np->last_rx.ex;
>>   
>>   	while (np->put_rx.ex != less_rx) {
>> -		struct sk_buff *skb = netdev_alloc_skb(dev, np->rx_buf_sz + NV_RX_ALLOC_PAD);
>> +		struct sk_buff *skb = skb_dequeue(&np->recv_list);
>> +
>> +		if (!test_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state))
>> +			schedule_delayed_work(&np->recv_cache_work, 0);
> It seems a little heavy to schedule this work on every packet, would it
> make sense to add this in nv_napi_poll() instead?
>
>>   		if (likely(skb)) {
>>   			np->put_rx_ctx->skb = skb;
>>   			np->put_rx_ctx->dma = dma_map_single(&np->pci_dev->dev,
>> @@ -1957,6 +1980,40 @@ static void nv_init_tx(struct net_device *dev)
>>   	}
>>   }
>>   
>> +static void nv_init_recv_cache(struct net_device *dev)
>> +{
>> +	struct fe_priv *np = netdev_priv(dev);
>> +
>> +	skb_queue_head_init(&np->recv_list);
>> +	while (skb_queue_len(&np->recv_list) < RECV_CACHE_LIST_LENGTH) {
>> +		struct sk_buff *skb = netdev_alloc_skb(dev,
>> +				 np->rx_buf_sz + NV_RX_ALLOC_PAD);
>> +		/* skb is null. This indicates that memory is not
>> +		 * enough.
>> +		 */
>> +		if (unlikely(!skb)) {
>> +			ndelay(3);
>> +			continue;
> Does this path ever hit?  Seems like doing an ndelay() and retrying
> allocation is not the best idea for non-preempt kernel.
>
> Also perhaps you should consider using __netdev_alloc_skb() and passing
> GFP_KERNEL, that way the system has a chance to go into memory reclaim
> (I presume this function can sleep).
>
>> +		}
>> +
>> +		skb_queue_tail(&np->recv_list, skb);
>> +	}
>> +}
>> +
>> +static void nv_destroy_recv_cache(struct net_device *dev)
>> +{
>> +	struct sk_buff *skb;
>> +	struct fe_priv *np = netdev_priv(dev);
>> +
>> +	cancel_delayed_work_sync(&np->recv_cache_work);
>> +	WARN_ON(delayed_work_pending(&np->recv_cache_work));
>> +
>> +	while ((skb = skb_dequeue(&np->recv_list)))
>> +		kfree_skb(skb);
> skb_queue_purge()
>
>> +	WARN_ON(skb_queue_len(&np->recv_list));
>> +}
>> +
>>   static int nv_init_ring(struct net_device *dev)
>>   {
>>   	struct fe_priv *np = netdev_priv(dev);
>> @@ -3047,6 +3104,8 @@ static int nv_change_mtu(struct net_device *dev, int new_mtu)
>>   		nv_drain_rxtx(dev);
>>   		/* reinit driver view of the rx queue */
>>   		set_bufsize(dev);
>> +		nv_destroy_recv_cache(dev);
>> +		nv_init_recv_cache(dev);
>>   		if (nv_init_ring(dev)) {
>>   			if (!np->in_shutdown)
>>   				mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
>> @@ -4074,6 +4133,32 @@ static void nv_free_irq(struct net_device *dev)
>>   	}
>>   }
>>   
>> +static void nv_recv_cache_worker(struct work_struct *work)
>> +{
>> +	struct fe_priv *np = container_of(work, struct fe_priv,
>> +					  recv_cache_work.work);
>> +
>> +	set_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state);
>> +	while (skb_queue_len(&np->recv_list) < RECV_CACHE_LIST_LENGTH) {
>> +		struct sk_buff *skb = netdev_alloc_skb(np->dev,
>> +				np->rx_buf_sz + NV_RX_ALLOC_PAD);
>> +		/* skb is null. This indicates that memory is not
>> +		 * enough.
>> +		 * When the system memory is not enough, the kernel
>> +		 * will compact memory or drop caches. At that time,
>> +		 * if memory allocation fails, it had better wait some
>> +		 * time for memory.
>> +		 */
>> +		if (unlikely(!skb)) {
>> +			ndelay(3);
>> +			continue;
> Same comments as for the init function.
>
>> +		}
>> +
>> +		skb_queue_tail(&np->recv_list, skb);
>> +	}
>> +	clear_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state);
>> +}
>> +
>>   static void nv_do_nic_poll(struct timer_list *t)
>>   {
>>   	struct fe_priv *np = from_timer(np, t, nic_poll);
>> @@ -4129,6 +4214,8 @@ static void nv_do_nic_poll(struct timer_list *t)
>>   			nv_drain_rxtx(dev);
>>   			/* reinit driver view of the rx queue */
>>   			set_bufsize(dev);
>> +			nv_destroy_recv_cache(dev);
>> +			nv_init_recv_cache(dev);
>>   			if (nv_init_ring(dev)) {
>>   				if (!np->in_shutdown)
>>   					mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
