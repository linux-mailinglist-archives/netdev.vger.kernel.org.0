Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 766BF60EB0
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 06:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfGFEOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 00:14:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33998 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfGFEOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 00:14:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x664Ekj7175822;
        Sat, 6 Jul 2019 04:14:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=wH+xU17a1v/hxfPw62XZIF7kg0S9Owmmk6Qyy7yhS48=;
 b=cZXTMyFqWCrcMnJndReMgsdnojBD9YmikZSU1HogQKy1DKMllXlQDbm3ejF9M7d2wsPM
 lktxiKPvDJ4WLsb8P8VptQ4MNTiaYa7XjLFxoy9MmcyZt0WxTxg/aAWseSdWNLughyNc
 Lw7CQghwLPnyxfu6lVYarzc3nLsxu8UO0TcoW/p3eZ6Mq8pCREZpGht1YcKNHqNZUu1z
 2c6R9doUwCJkuo9QppAjJcZznSV+MR4/CjPPc9dXXa1JN6Y6nlrq1FXDTgDMhYKwkVT7
 UJbo6uUuAndVvUBLTFDhQJyrIxNYZ8VA1QyVjkq12kppke3lrEYgDZQAbs/hyVE9zRzw YA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2tjk2t8378-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 Jul 2019 04:14:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x664CZBY060844;
        Sat, 6 Jul 2019 04:14:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tjjyjh3u7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 Jul 2019 04:14:45 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x664Eije024530;
        Sat, 6 Jul 2019 04:14:44 GMT
Received: from [10.191.23.11] (/10.191.23.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jul 2019 21:14:44 -0700
Subject: Re: [PATCH 1/2] forcedeth: add recv cache make nic work steadily
To:     netdev@vger.kernel.org, davem@davemloft.net, nan.1986san@gmail.com
References: <1562307568-21549-1-git-send-email-yanjun.zhu@oracle.com>
 <1562307568-21549-2-git-send-email-yanjun.zhu@oracle.com>
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
Message-ID: <fbc47f64-910e-f653-679a-f783b02c65ca@oracle.com>
Date:   Sat, 6 Jul 2019 12:14:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562307568-21549-2-git-send-email-yanjun.zhu@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907060053
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907060053
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Nan

He is interested this commit.

ÔÚ 2019/7/5 14:19, Zhu Yanjun Ð´µÀ:
> A recv cache is added. The size of recv cache is 1000Mb / skb_length.
> When the system memory is not enough, this recv cache can make nic work
> steadily.
> When nic is up, this recv cache and work queue are created. When nic
> is down, this recv cache will be destroyed and delayed workqueue is
> canceled.
> When nic is polled or rx interrupt is triggerred, rx handler will
> get a skb from recv cache. Then the state of recv cache is checked.
> If recv cache is not in filling up state, a work is queued to fill
> up recv cache.
> When skb size is changed, the old recv cache is destroyed and new recv
> cache is created.
> When the system memory is not enough, the allocation of skb failed.
> recv cache will continue allocate skb until the recv cache is filled up.
> When the system memory is not enough, this can make nic work steadily.
> Becase of recv cache, the performance of nic is enhanced.
>
> CC: Joe Jin <joe.jin@oracle.com>
> CC: Junxiao Bi <junxiao.bi@oracle.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
>   drivers/net/ethernet/nvidia/forcedeth.c | 100 +++++++++++++++++++++++++++++++-
>   1 file changed, 98 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
> index b327b29..a673005 100644
> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> @@ -674,6 +674,11 @@ struct nv_ethtool_stats {
>   	u64 tx_broadcast;
>   };
>   
> +/* 1000Mb is 125M bytes, 125 * 1024 * 1024 bytes
> + * The length of recv cache is 125M / skb_length
> + */
> +#define RECV_CACHE_LIST_LENGTH		(125 * 1024 * 1024 / np->rx_buf_sz)
> +
>   #define NV_DEV_STATISTICS_V3_COUNT (sizeof(struct nv_ethtool_stats)/sizeof(u64))
>   #define NV_DEV_STATISTICS_V2_COUNT (NV_DEV_STATISTICS_V3_COUNT - 3)
>   #define NV_DEV_STATISTICS_V1_COUNT (NV_DEV_STATISTICS_V2_COUNT - 6)
> @@ -844,8 +849,18 @@ struct fe_priv {
>   	char name_rx[IFNAMSIZ + 3];       /* -rx    */
>   	char name_tx[IFNAMSIZ + 3];       /* -tx    */
>   	char name_other[IFNAMSIZ + 6];    /* -other */
> +
> +	/* This is to schedule work */
> +	struct delayed_work     recv_cache_work;
> +	/* This list is to store skb queue for recv */
> +	struct sk_buff_head recv_list;
> +	unsigned long nv_recv_list_state;
>   };
>   
> +/* This is recv list state to fill up recv cache */
> +enum recv_list_state {
> +	RECV_LIST_ALLOCATE
> +};
>   /*
>    * Maximum number of loops until we assume that a bit in the irq mask
>    * is stuck. Overridable with module param.
> @@ -1804,7 +1819,11 @@ static int nv_alloc_rx(struct net_device *dev)
>   		less_rx = np->last_rx.orig;
>   
>   	while (np->put_rx.orig != less_rx) {
> -		struct sk_buff *skb = netdev_alloc_skb(dev, np->rx_buf_sz + NV_RX_ALLOC_PAD);
> +		struct sk_buff *skb = skb_dequeue(&np->recv_list);
> +
> +		if (!test_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state))
> +			schedule_delayed_work(&np->recv_cache_work, 0);
> +
>   		if (likely(skb)) {
>   			np->put_rx_ctx->skb = skb;
>   			np->put_rx_ctx->dma = dma_map_single(&np->pci_dev->dev,
> @@ -1845,7 +1864,11 @@ static int nv_alloc_rx_optimized(struct net_device *dev)
>   		less_rx = np->last_rx.ex;
>   
>   	while (np->put_rx.ex != less_rx) {
> -		struct sk_buff *skb = netdev_alloc_skb(dev, np->rx_buf_sz + NV_RX_ALLOC_PAD);
> +		struct sk_buff *skb = skb_dequeue(&np->recv_list);
> +
> +		if (!test_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state))
> +			schedule_delayed_work(&np->recv_cache_work, 0);
> +
>   		if (likely(skb)) {
>   			np->put_rx_ctx->skb = skb;
>   			np->put_rx_ctx->dma = dma_map_single(&np->pci_dev->dev,
> @@ -1957,6 +1980,40 @@ static void nv_init_tx(struct net_device *dev)
>   	}
>   }
>   
> +static void nv_init_recv_cache(struct net_device *dev)
> +{
> +	struct fe_priv *np = netdev_priv(dev);
> +
> +	skb_queue_head_init(&np->recv_list);
> +	while (skb_queue_len(&np->recv_list) < RECV_CACHE_LIST_LENGTH) {
> +		struct sk_buff *skb = netdev_alloc_skb(dev,
> +				 np->rx_buf_sz + NV_RX_ALLOC_PAD);
> +		/* skb is null. This indicates that memory is not
> +		 * enough.
> +		 */
> +		if (unlikely(!skb)) {
> +			ndelay(3);
> +			continue;
> +		}
> +
> +		skb_queue_tail(&np->recv_list, skb);
> +	}
> +}
> +
> +static void nv_destroy_recv_cache(struct net_device *dev)
> +{
> +	struct sk_buff *skb;
> +	struct fe_priv *np = netdev_priv(dev);
> +
> +	cancel_delayed_work_sync(&np->recv_cache_work);
> +	WARN_ON(delayed_work_pending(&np->recv_cache_work));
> +
> +	while ((skb = skb_dequeue(&np->recv_list)))
> +		kfree_skb(skb);
> +
> +	WARN_ON(skb_queue_len(&np->recv_list));
> +}
> +
>   static int nv_init_ring(struct net_device *dev)
>   {
>   	struct fe_priv *np = netdev_priv(dev);
> @@ -3047,6 +3104,8 @@ static int nv_change_mtu(struct net_device *dev, int new_mtu)
>   		nv_drain_rxtx(dev);
>   		/* reinit driver view of the rx queue */
>   		set_bufsize(dev);
> +		nv_destroy_recv_cache(dev);
> +		nv_init_recv_cache(dev);
>   		if (nv_init_ring(dev)) {
>   			if (!np->in_shutdown)
>   				mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
> @@ -4074,6 +4133,32 @@ static void nv_free_irq(struct net_device *dev)
>   	}
>   }
>   
> +static void nv_recv_cache_worker(struct work_struct *work)
> +{
> +	struct fe_priv *np = container_of(work, struct fe_priv,
> +					  recv_cache_work.work);
> +
> +	set_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state);
> +	while (skb_queue_len(&np->recv_list) < RECV_CACHE_LIST_LENGTH) {
> +		struct sk_buff *skb = netdev_alloc_skb(np->dev,
> +				np->rx_buf_sz + NV_RX_ALLOC_PAD);
> +		/* skb is null. This indicates that memory is not
> +		 * enough.
> +		 * When the system memory is not enough, the kernel
> +		 * will compact memory or drop caches. At that time,
> +		 * if memory allocation fails, it had better wait some
> +		 * time for memory.
> +		 */
> +		if (unlikely(!skb)) {
> +			ndelay(3);
> +			continue;
> +		}
> +
> +		skb_queue_tail(&np->recv_list, skb);
> +	}
> +	clear_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state);
> +}
> +
>   static void nv_do_nic_poll(struct timer_list *t)
>   {
>   	struct fe_priv *np = from_timer(np, t, nic_poll);
> @@ -4129,6 +4214,8 @@ static void nv_do_nic_poll(struct timer_list *t)
>   			nv_drain_rxtx(dev);
>   			/* reinit driver view of the rx queue */
>   			set_bufsize(dev);
> +			nv_destroy_recv_cache(dev);
> +			nv_init_recv_cache(dev);
>   			if (nv_init_ring(dev)) {
>   				if (!np->in_shutdown)
>   					mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
> @@ -4681,6 +4768,8 @@ static int nv_set_ringparam(struct net_device *dev, struct ethtool_ringparam* ri
>   	if (netif_running(dev)) {
>   		/* reinit driver view of the queues */
>   		set_bufsize(dev);
> +		nv_destroy_recv_cache(dev);
> +		nv_init_recv_cache(dev);
>   		if (nv_init_ring(dev)) {
>   			if (!np->in_shutdown)
>   				mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
> @@ -5402,6 +5491,10 @@ static int nv_open(struct net_device *dev)
>   
>   	/* initialize descriptor rings */
>   	set_bufsize(dev);
> +	nv_init_recv_cache(dev);
> +
> +	INIT_DELAYED_WORK(&np->recv_cache_work, nv_recv_cache_worker);
> +	clear_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state);
>   	oom = nv_init_ring(dev);
>   
>   	writel(0, base + NvRegLinkSpeed);
> @@ -5583,6 +5676,9 @@ static int nv_close(struct net_device *dev)
>   		nv_txrx_gate(dev, true);
>   	}
>   
> +	/* free all SKBs in recv cache */
> +	nv_destroy_recv_cache(dev);
> +
>   	/* FIXME: power down nic */
>   
>   	return 0;
