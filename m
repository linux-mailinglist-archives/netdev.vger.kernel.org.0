Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418F6230672
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgG1JVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:21:24 -0400
Received: from mail-eopbgr80045.outbound.protection.outlook.com ([40.107.8.45]:43983
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728122AbgG1JVY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:21:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBOmXMI0xqElwj/oavyA/+sqRI0zdcEPGBic7qsEAadSkoSaDanYrmXuSZsmRlKZ/7geZZfEXSJ7wjALLbD34nWkiVnbPRRR/oZR3oPTxNyLJTfveDKpdpMc53SMCXLMVWhbdoyr8+d5TJUZI94O6fOuZVvq0ySif4g8mTQ5RhkbqJ+4NJiwSqgFbwbwYLvzQ4d4QmoKMIwWma2XAyfCDC7ub0f+PcPmN+N1e30BtYIQSihOMkR6Uvhiqt1uXPwlNAnBIaKDzHl83ecBkTFNN3sH0HiUtLyXQUkQ22xpT43dC2BB5m8cS9fGH9b4Fw0jciICwoes1BTyc9HKYmTXPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6gl0q48uVcVMUveS0WVhaiJSug911ta3QwQfUF8MO4=;
 b=GH9HAYo6d86ljfpgozVWQzX6Z3N9B/3xWk8jxsYLl09glvme3Zn/avdfP/5gOpIwKjx/bjVN2MThAq4BfTzZe3t0m6KIr2m1062PMtDq1VKZVSgPHmwTa2NT7lTvHdwjcZ4gcb9lqrUuxQuAe9YOtHjZpMAOXQci119o1P+duH06PKy4t2YuKxyf5ZC6+z824RDRfvshTzEa+vdYnD2OwXNlev920JnzzhZs6dIdnDfnmnhoCmUXIHijYNay76N6mIoLrnZ20R7lVlqLH5WMe3o62C0geQvgpX0q1busBkiylpfUtOHdf/Aw5fFESwy64bT7Tmqp8CL9uBE4SnivQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6gl0q48uVcVMUveS0WVhaiJSug911ta3QwQfUF8MO4=;
 b=aZUoML7jCEjLfWoQt78DHc0JwavFK3bvAUJWnsH3dtOClVjO7OpMOoJIXHm1255pwpIbjLiKgRxi8Sk91LKnpE8XJJdPIPOdFY5vcsHR2UGYn8kOHTIiJeoLSepZuvAbTqGXbopxotPVRddM28NH787lFL33aTOJQze1CfWEZLs=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB6056.eurprd05.prod.outlook.com (2603:10a6:20b:a9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 09:21:18 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71%3]) with mapi id 15.20.3239.016; Tue, 28 Jul 2020
 09:21:18 +0000
Subject: Re: [PATCH bpf-next v4 05/14] xsk: move queue_id, dev and need_wakeup
 to buffer pool
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
References: <1595307848-20719-1-git-send-email-magnus.karlsson@intel.com>
 <1595307848-20719-6-git-send-email-magnus.karlsson@intel.com>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <08bf5d26-fa21-10b5-d768-01ca9a1ebcbb@mellanox.com>
Date:   Tue, 28 Jul 2020 12:21:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1595307848-20719-6-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4P190CA0010.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::20) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.57.1.235] (159.224.90.213) by AM4P190CA0010.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 09:21:17 +0000
X-Originating-IP: [159.224.90.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7317f742-84f4-42f1-4574-08d832d7958c
X-MS-TrafficTypeDiagnostic: AM6PR05MB6056:
X-Microsoft-Antispam-PRVS: <AM6PR05MB60569B54A3D0962F99C467F8D1730@AM6PR05MB6056.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mk3sTjiL6Ln56P2Bu+yRxwV8USA1k/4/wOjI+1dnPMRW1PjqSO6X7EdjJtsxZTP/o3jvdI0AaU6CbSldaQGBwKcAXyjFXcPDAEV5R/wjER/fsH1wMUGEBgeMhn/8a0e2XLGu29K5WekFjm0/3s9Pglj2bvevolxGLsczBxZ40jvtWnLVv92uiM3/XeW3378Rtk637YK55WXvywek7XmT9OuPPa1LCPMU2MEJtarW92ae3fhSz4qgpfs2cSWqfaMTGJxcGPmYofE5nksO0fRoc7dM0JlXNddm/+p7/qB4iWGbZB1jf61mj8py5RpPdiHsiuK3xe0aHddOzatZEGfjHTZJ0UYZfmDXz4lL/H3gTTvPuHNI85aw8axNY3zk1J5t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(4326008)(52116002)(6916009)(86362001)(30864003)(83380400001)(5660300002)(66556008)(55236004)(16526019)(66476007)(6486002)(316002)(956004)(2616005)(2906002)(31686004)(16576012)(186003)(7416002)(26005)(8936002)(478600001)(8676002)(36756003)(31696002)(66946007)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xmaS8NU+F/kogATAuXzFY4JZNuQLqC2x+sxw5R9iAYreA66nEJerGgbFQ1J9E8tktajHYtJAHNgEsHwQUdvQqJWuUvgSNWLMMlWaIDJYQOO2mJMr9PMYhgKbzjHFHqc1wGgR6lSun6eX+DVKbahfY12A/ZqsafmTjHzIwlJN6IY9iQpQAU0vLSvjn9sorfxxR1etPR+wdEOtkYpWUmj1/x4qv8Vn3v88pTLqTKigNg8beSqaFsh8XeDrQn8EUYwfvqnaKc8BnMib4jwtuAoyOHQ4+vIy1OxfUACafkj4EyQ3pTI5dtzb5gVfd7kAXSVwsWUI0FQFsKKIhz/rdAUwwdQi6M6sCJs1NXVbNB7KVX38/At/4E6R/715gSNCcOCvNUE1/nwM10TjUODWwOO9NwDMqmmmstQZQ+tSG7fTAqvKVGB8UA3+N9fj1PY7PNh0fu9fjQXAzvWFVxLzdOQmRTOlad3KztXYHZECr21JabOnwi8n+d/qC3pZxh3ES9re
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7317f742-84f4-42f1-4574-08d832d7958c
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:21:18.2140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Hg/JukO0n4t8dYMkQzsjm3etkeMsqWp3QvCDACK7vINYUTL7KKeyhzO5elUv52sua3/pEQ7WIk6wJ1Y0u8V0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6056
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-21 08:03, Magnus Karlsson wrote:
> Move queue_id, dev, and need_wakeup from the umem to the
> buffer pool. This so that we in a later commit can share the umem
> between multiple HW queues. There is one buffer pool per dev and
> queue id, so these variables should belong to the buffer pool, not
> the umem. Need_wakeup is also something that is set on a per napi
> level, so there is usually one per device and queue id. So move
> this to the buffer pool too.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>   include/net/xdp_sock.h      |  3 ---
>   include/net/xsk_buff_pool.h |  4 ++++
>   net/xdp/xdp_umem.c          | 19 +------------------
>   net/xdp/xdp_umem.h          |  4 ----
>   net/xdp/xsk.c               | 40 +++++++++++++++-------------------------
>   net/xdp/xsk_buff_pool.c     | 39 ++++++++++++++++++++++-----------------
>   net/xdp/xsk_diag.c          |  4 ++--
>   7 files changed, 44 insertions(+), 69 deletions(-)
> 
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index 2a284e1..b052f1c 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -26,11 +26,8 @@ struct xdp_umem {
>   	refcount_t users;
>   	struct page **pgs;
>   	u32 npgs;
> -	u16 queue_id;
> -	u8 need_wakeup;
>   	u8 flags;
>   	int id;
> -	struct net_device *dev;
>   	bool zc;
>   	spinlock_t xsk_tx_list_lock;
>   	struct list_head xsk_tx_list;
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index 380d9ae..2d94890 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -43,11 +43,15 @@ struct xsk_buff_pool {
>   	u32 headroom;
>   	u32 chunk_size;
>   	u32 frame_len;
> +	u16 queue_id;
> +	u8 cached_need_wakeup;
> +	bool uses_need_wakeup;
>   	bool dma_need_sync;
>   	bool unaligned;
>   	struct xdp_umem *umem;
>   	void *addrs;
>   	struct device *dev;
> +	struct net_device *netdev;
>   	refcount_t users;
>   	struct work_struct work;
>   	struct xdp_buff_xsk *free_heads[];
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 7d86a63..b1699d0 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -63,26 +63,9 @@ static void xdp_umem_unaccount_pages(struct xdp_umem *umem)
>   	}
>   }
>   
> -void xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
> -			 u16 queue_id)
> -{
> -	umem->dev = dev;
> -	umem->queue_id = queue_id;
> -
> -	dev_hold(dev);
> -}
> -
> -void xdp_umem_clear_dev(struct xdp_umem *umem)
> -{
> -	dev_put(umem->dev);
> -	umem->dev = NULL;
> -	umem->zc = false;
> -}
> -
>   static void xdp_umem_release(struct xdp_umem *umem)
>   {
> -	xdp_umem_clear_dev(umem);
> -
> +	umem->zc = false;
>   	ida_simple_remove(&umem_ida, umem->id);
>   
>   	xdp_umem_unpin_pages(umem);
> diff --git a/net/xdp/xdp_umem.h b/net/xdp/xdp_umem.h
> index 93e96be..67bf3f3 100644
> --- a/net/xdp/xdp_umem.h
> +++ b/net/xdp/xdp_umem.h
> @@ -8,10 +8,6 @@
>   
>   #include <net/xdp_sock_drv.h>
>   
> -void xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
> -			 u16 queue_id);
> -void xdp_umem_clear_dev(struct xdp_umem *umem);
> -bool xdp_umem_validate_queues(struct xdp_umem *umem);
>   void xdp_get_umem(struct xdp_umem *umem);
>   void xdp_put_umem(struct xdp_umem *umem);
>   void xdp_add_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs);
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index ee04887..624d0fc 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -41,67 +41,61 @@ bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
>   
>   void xsk_set_rx_need_wakeup(struct xsk_buff_pool *pool)
>   {
> -	struct xdp_umem *umem = pool->umem;
> -
> -	if (umem->need_wakeup & XDP_WAKEUP_RX)
> +	if (pool->cached_need_wakeup & XDP_WAKEUP_RX)
>   		return;
>   
>   	pool->fq->ring->flags |= XDP_RING_NEED_WAKEUP;
> -	umem->need_wakeup |= XDP_WAKEUP_RX;
> +	pool->cached_need_wakeup |= XDP_WAKEUP_RX;
>   }
>   EXPORT_SYMBOL(xsk_set_rx_need_wakeup);
>   
>   void xsk_set_tx_need_wakeup(struct xsk_buff_pool *pool)
>   {
> -	struct xdp_umem *umem = pool->umem;
>   	struct xdp_sock *xs;
>   
> -	if (umem->need_wakeup & XDP_WAKEUP_TX)
> +	if (pool->cached_need_wakeup & XDP_WAKEUP_TX)
>   		return;
>   
>   	rcu_read_lock();
> -	list_for_each_entry_rcu(xs, &umem->xsk_tx_list, list) {
> +	list_for_each_entry_rcu(xs, &xs->umem->xsk_tx_list, list) {

I know this is going to be fixed in the next patch, but it breaks 
bisectability: this patch is broken because xs is not assigned. I don't 
think this change is actually needed here, it doesn't belong to this 
patch, and you can convert it to &pool->xsk_tx_list in one step in the 
next patch.

>   		xs->tx->ring->flags |= XDP_RING_NEED_WAKEUP;
>   	}
>   	rcu_read_unlock();
>   
> -	umem->need_wakeup |= XDP_WAKEUP_TX;
> +	pool->cached_need_wakeup |= XDP_WAKEUP_TX;
>   }
>   EXPORT_SYMBOL(xsk_set_tx_need_wakeup);
>   
>   void xsk_clear_rx_need_wakeup(struct xsk_buff_pool *pool)
>   {
> -	struct xdp_umem *umem = pool->umem;
> -
> -	if (!(umem->need_wakeup & XDP_WAKEUP_RX))
> +	if (!(pool->cached_need_wakeup & XDP_WAKEUP_RX))
>   		return;
>   
>   	pool->fq->ring->flags &= ~XDP_RING_NEED_WAKEUP;
> -	umem->need_wakeup &= ~XDP_WAKEUP_RX;
> +	pool->cached_need_wakeup &= ~XDP_WAKEUP_RX;
>   }
>   EXPORT_SYMBOL(xsk_clear_rx_need_wakeup);
>   
>   void xsk_clear_tx_need_wakeup(struct xsk_buff_pool *pool)
>   {
> -	struct xdp_umem *umem = pool->umem;
>   	struct xdp_sock *xs;
>   
> -	if (!(umem->need_wakeup & XDP_WAKEUP_TX))
> +	if (!(pool->cached_need_wakeup & XDP_WAKEUP_TX))
>   		return;
>   
>   	rcu_read_lock();
> -	list_for_each_entry_rcu(xs, &umem->xsk_tx_list, list) {
> +	list_for_each_entry_rcu(xs, &xs->umem->xsk_tx_list, list) {

Same here.

>   		xs->tx->ring->flags &= ~XDP_RING_NEED_WAKEUP;
>   	}
>   	rcu_read_unlock();
>   
> -	umem->need_wakeup &= ~XDP_WAKEUP_TX;
> +	pool->cached_need_wakeup &= ~XDP_WAKEUP_TX;
>   }
>   EXPORT_SYMBOL(xsk_clear_tx_need_wakeup);
>   
>   bool xsk_uses_need_wakeup(struct xsk_buff_pool *pool)
>   {
> -	return pool->umem->flags & XDP_UMEM_USES_NEED_WAKEUP;
> +	return pool->uses_need_wakeup;
>   }
>   EXPORT_SYMBOL(xsk_uses_need_wakeup);
>   
> @@ -478,16 +472,16 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
>   	__poll_t mask = datagram_poll(file, sock, wait);
>   	struct sock *sk = sock->sk;
>   	struct xdp_sock *xs = xdp_sk(sk);
> -	struct xdp_umem *umem;
> +	struct xsk_buff_pool *pool;
>   
>   	if (unlikely(!xsk_is_bound(xs)))
>   		return mask;
>   
> -	umem = xs->umem;
> +	pool = xs->pool;
>   
> -	if (umem->need_wakeup) {
> +	if (pool->cached_need_wakeup) {
>   		if (xs->zc)
> -			xsk_wakeup(xs, umem->need_wakeup);
> +			xsk_wakeup(xs, pool->cached_need_wakeup);
>   		else
>   			/* Poll needs to drive Tx also in copy mode */
>   			__xsk_sendmsg(sk);
> @@ -731,11 +725,9 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   		goto out_unlock;
>   	} else {
>   		/* This xsk has its own umem. */
> -		xdp_umem_assign_dev(xs->umem, dev, qid);
>   		xs->pool = xp_create_and_assign_umem(xs, xs->umem);
>   		if (!xs->pool) {
>   			err = -ENOMEM;
> -			xdp_umem_clear_dev(xs->umem);
>   			goto out_unlock;
>   		}
>   
> @@ -743,7 +735,6 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   		if (err) {
>   			xp_destroy(xs->pool);
>   			xs->pool = NULL;
> -			xdp_umem_clear_dev(xs->umem);
>   			goto out_unlock;
>   		}
>   	}
> @@ -1089,7 +1080,6 @@ static int xsk_notifier(struct notifier_block *this,
>   
>   				/* Clear device references. */
>   				xp_clear_dev(xs->pool);
> -				xdp_umem_clear_dev(xs->umem);
>   			}
>   			mutex_unlock(&xs->mutex);
>   		}
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 36287d2..436648a 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -95,10 +95,9 @@ void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
>   }
>   EXPORT_SYMBOL(xp_set_rxq_info);
>   
> -int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
> +int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
>   		  u16 queue_id, u16 flags)
>   {
> -	struct xdp_umem *umem = pool->umem;
>   	bool force_zc, force_copy;
>   	struct netdev_bpf bpf;
>   	int err = 0;
> @@ -111,27 +110,30 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
>   	if (force_zc && force_copy)
>   		return -EINVAL;
>   
> -	if (xsk_get_pool_from_qid(dev, queue_id))
> +	if (xsk_get_pool_from_qid(netdev, queue_id))
>   		return -EBUSY;
>   
> -	err = xsk_reg_pool_at_qid(dev, pool, queue_id);
> +	err = xsk_reg_pool_at_qid(netdev, pool, queue_id);
>   	if (err)
>   		return err;
>   
>   	if (flags & XDP_USE_NEED_WAKEUP) {
> -		umem->flags |= XDP_UMEM_USES_NEED_WAKEUP;

XDP_UMEM_USES_NEED_WAKEUP definition should be removed, along with its 
remaining usage in xdp_umem_reg.

> +		pool->uses_need_wakeup = true;
>   		/* Tx needs to be explicitly woken up the first time.
>   		 * Also for supporting drivers that do not implement this
>   		 * feature. They will always have to call sendto().
>   		 */
> -		umem->need_wakeup = XDP_WAKEUP_TX;
> +		pool->cached_need_wakeup = XDP_WAKEUP_TX;
>   	}
>   
> +	dev_hold(netdev);
> +
>   	if (force_copy)
>   		/* For copy-mode, we are done. */
>   		return 0;
>   
> -	if (!dev->netdev_ops->ndo_bpf || !dev->netdev_ops->ndo_xsk_wakeup) {
> +	if (!netdev->netdev_ops->ndo_bpf ||
> +	    !netdev->netdev_ops->ndo_xsk_wakeup) {
>   		err = -EOPNOTSUPP;
>   		goto err_unreg_pool;
>   	}
> @@ -140,44 +142,47 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
>   	bpf.xsk.pool = pool;
>   	bpf.xsk.queue_id = queue_id;
>   
> -	err = dev->netdev_ops->ndo_bpf(dev, &bpf);
> +	err = netdev->netdev_ops->ndo_bpf(netdev, &bpf);
>   	if (err)
>   		goto err_unreg_pool;
>   
> -	umem->zc = true;
> +	pool->netdev = netdev;
> +	pool->queue_id = queue_id;
> +	pool->umem->zc = true;
>   	return 0;
>   
>   err_unreg_pool:
>   	if (!force_zc)
>   		err = 0; /* fallback to copy mode */
>   	if (err)
> -		xsk_clear_pool_at_qid(dev, queue_id);
> +		xsk_clear_pool_at_qid(netdev, queue_id);
>   	return err;
>   }
>   
>   void xp_clear_dev(struct xsk_buff_pool *pool)
>   {
> -	struct xdp_umem *umem = pool->umem;
>   	struct netdev_bpf bpf;
>   	int err;
>   
>   	ASSERT_RTNL();
>   
> -	if (!umem->dev)
> +	if (!pool->netdev)
>   		return;
>   
> -	if (umem->zc) {
> +	if (pool->umem->zc) {
>   		bpf.command = XDP_SETUP_XSK_POOL;
>   		bpf.xsk.pool = NULL;
> -		bpf.xsk.queue_id = umem->queue_id;
> +		bpf.xsk.queue_id = pool->queue_id;
>   
> -		err = umem->dev->netdev_ops->ndo_bpf(umem->dev, &bpf);
> +		err = pool->netdev->netdev_ops->ndo_bpf(pool->netdev, &bpf);
>   
>   		if (err)
> -			WARN(1, "failed to disable umem!\n");
> +			WARN(1, "Failed to disable zero-copy!\n");
>   	}
>   
> -	xsk_clear_pool_at_qid(umem->dev, umem->queue_id);
> +	xsk_clear_pool_at_qid(pool->netdev, pool->queue_id);
> +	dev_put(pool->netdev);
> +	pool->netdev = NULL;
>   }
>   
>   static void xp_release_deferred(struct work_struct *work)
> diff --git a/net/xdp/xsk_diag.c b/net/xdp/xsk_diag.c
> index 52675ea..5bd8ea9 100644
> --- a/net/xdp/xsk_diag.c
> +++ b/net/xdp/xsk_diag.c
> @@ -59,8 +59,8 @@ static int xsk_diag_put_umem(const struct xdp_sock *xs, struct sk_buff *nlskb)
>   	du.num_pages = umem->npgs;
>   	du.chunk_size = umem->chunk_size;
>   	du.headroom = umem->headroom;
> -	du.ifindex = umem->dev ? umem->dev->ifindex : 0;
> -	du.queue_id = umem->queue_id;
> +	du.ifindex = pool->netdev ? pool->netdev->ifindex : 0;
> +	du.queue_id = pool->queue_id;
>   	du.flags = 0;
>   	if (umem->zc)
>   		du.flags |= XDP_DU_F_ZEROCOPY;
> 

