Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7E95F686
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 12:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfGDKWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 06:22:46 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42901 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727517AbfGDKWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 06:22:45 -0400
Received: by mail-lj1-f193.google.com with SMTP id t28so5604802lje.9
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 03:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9aV8RAyF3WE+/A/u8zETEkCw/LlkRBH85b7MZ/q1pOs=;
        b=u02J823Lxdq6ihfmTkZv8d7D5ZmTpW/syq9hD2vBBGmKOHe0tPVttf6oTKlu2Ru29G
         gEATZx1vgjMk7SOepF5WZkTj0ip46M5vvidcy5VnHpSGgp3Jquwd/qVQgwnae/6MCjPL
         z8UP/IpwKtDp7neeazYcxarnyXzMj6Wl3cnu6fm06qAm9pqj5UTX1j+d/H2p0mshYWJA
         4XM0HLlJPimkjG7c8LOAni1pYpM5UWiJTRb1q++9Nkrcm7vYU7/08c1Hsa3byudIoeKC
         /3ia3o1yCs8HVCVI94U6MtZDv1bwLbhK/Rs+gSGBPitsgu5jacBqGSoXm2UroBjmK8p7
         WEXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=9aV8RAyF3WE+/A/u8zETEkCw/LlkRBH85b7MZ/q1pOs=;
        b=j2YI47mK0IRt8DH+zqCXWa+dP5uCtRyq+/F6i0/G+pIwEPt3TmmuJCZG7amOp3yIb2
         GQb6pRZKHPTSNWBcXmD/t2bwJBRvVRXtX5q3ebmCQgGEBVMeUGhp5Xbk9RuBQLV2ccd9
         HcbjKbQsNIFeI3i7BQSQY6j4fkIMuHWTxpuK5NCIROwN/kQfJw0mFaW2Tz9e2Z2qkRGl
         DF0xSCrfXlC3T26HykC4h6BMN0ILFGPJN4k3bhvfb18hWItCDGAra0ZlEZ2Bzr+kjOZU
         KUNhMQptY4mZXpq2opvKqjEdm8IpaVB2tUt/xM5/uOloiNFxiE2SO/KukA6W99xlyd7X
         KOPQ==
X-Gm-Message-State: APjAAAWYKucm0YVYAoONU2T4hwQvZQqqVU3ybl4UxFn6Ru5kCzVk+iGS
        dwrzq4FTpV/A6Mv02GtfWKgazw==
X-Google-Smtp-Source: APXvYqwS14MaeDz6e6vLxfov4XA+PhSmLc0hYN/+A6wgREMAuVpo1Ng73MREI4tpQX4uhNV9rGgFBg==
X-Received: by 2002:a2e:93c8:: with SMTP id p8mr20216496ljh.6.1562235762794;
        Thu, 04 Jul 2019 03:22:42 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id x2sm792517lfg.12.2019.07.04.03.22.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Jul 2019 03:22:42 -0700 (PDT)
Date:   Thu, 4 Jul 2019 13:22:40 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH v6 net-next 1/5] xdp: allow same allocator usage
Message-ID: <20190704102239.GA3406@khorivan>
Mail-Followup-To: Jesper Dangaard Brouer <brouer@redhat.com>,
        grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
References: <20190703101903.8411-1-ivan.khoronzhuk@linaro.org>
 <20190703101903.8411-2-ivan.khoronzhuk@linaro.org>
 <20190703194013.02842e42@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190703194013.02842e42@carbon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 07:40:13PM +0200, Jesper Dangaard Brouer wrote:
>On Wed,  3 Jul 2019 13:18:59 +0300
>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> First of all, it is an absolute requirement that each RX-queue have
>> their own page_pool object/allocator. And this change is intendant
>> to handle special case, where a single RX-queue can receive packets
>> from two different net_devices.
>>
>> In order to protect against using same allocator for 2 different rx
>> queues, add queue_index to xdp_mem_allocator to catch the obvious
>> mistake where queue_index mismatch, as proposed by Jesper Dangaard
>> Brouer.
>>
>> Adding this on xdp allocator level allows drivers with such dependency
>> change the allocators w/o modifications.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>  include/net/xdp_priv.h |  2 ++
>>  net/core/xdp.c         | 55 ++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 57 insertions(+)
>>
>> diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
>> index 6a8cba6ea79a..9858a4057842 100644
>> --- a/include/net/xdp_priv.h
>> +++ b/include/net/xdp_priv.h
>> @@ -18,6 +18,8 @@ struct xdp_mem_allocator {
>>  	struct rcu_head rcu;
>>  	struct delayed_work defer_wq;
>>  	unsigned long defer_warn;
>> +	unsigned long refcnt;
>> +	u32 queue_index;
>>  };
>
>I don't like this approach, because I think we need to extend struct
>xdp_mem_allocator with a net_device pointer, for doing dev_hold(), to
>correctly handle lifetime issues. (As I tried to explain previously).
>This will be much harder after this change, which is why I proposed the
>other patch.
My concern comes not from zero also.
It's partly continuation of not answered questions from here:
https://lwn.net/ml/netdev/20190625122822.GC6485@khorivan/

"For me it's important to know only if it means that alloc.count is
freed at first call of __mem_id_disconnect() while shutdown.
The workqueue for the rest is connected only with ring cache protected
by ring lock and not supposed that alloc.count can be changed while
workqueue tries to shutdonwn the pool."

So patch you propose to leave works only because of luck, because fast
cache is cleared before workqueue is scheduled and no races between two
workqueues for fast cache later. I'm not really against this patch, but
I have to try smth better.

So, the patch is fine only because of specific of page_pool implementation.
I'm not sure that in future similar workqueue completion will be lucky for
another allocator (it easily can happen due to xdp frame can live longer
than an allocator). Similar problem can happen with other drivers having
same allocator, that can use zca (potentially can use smth similar),
af_xdp api allows to switch on it or some other allocators....

But not the essence. The concern about adding smth new to the allocator
later, like net device, can be solved with a little modification to the patch,
(despite here can be several more approaches) for instance, like this:
(by fact it's still the same, when mem_alloc instance per each register call
but with same void *allocator)


diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
index 6a8cba6ea79a..c7ad0f41e1b0 100644
--- a/include/net/xdp_priv.h
+++ b/include/net/xdp_priv.h
@@ -18,6 +18,8 @@ struct xdp_mem_allocator {
 	struct rcu_head rcu;
 	struct delayed_work defer_wq;
 	unsigned long defer_warn;
+	unsigned long *refcnt;
+	u32 queue_index;
 };
 
 #endif /* __LINUX_NET_XDP_PRIV_H__ */
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 829377cc83db..a44e3e4c8307 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -64,9 +64,37 @@ static const struct rhashtable_params mem_id_rht_params = {
 	.obj_cmpfn = xdp_mem_id_cmp,
 };
 
+static struct xdp_mem_allocator *xdp_allocator_find(void *allocator)
+{
+	struct xdp_mem_allocator *xae, *xa = NULL;
+	struct rhashtable_iter iter;
+
+	if (!allocator)
+		return xa;
+
+	rhashtable_walk_enter(mem_id_ht, &iter);
+	do {
+		rhashtable_walk_start(&iter);
+
+		while ((xae = rhashtable_walk_next(&iter)) && !IS_ERR(xae)) {
+			if (xae->allocator == allocator) {
+				xa = xae;
+				break;
+			}
+		}
+
+		rhashtable_walk_stop(&iter);
+
+	} while (xae == ERR_PTR(-EAGAIN));
+	rhashtable_walk_exit(&iter);
+
+	return xa;
+}
+
 static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
 {
 	struct xdp_mem_allocator *xa;
+	void *allocator;
 
 	xa = container_of(rcu, struct xdp_mem_allocator, rcu);
 
@@ -74,15 +102,27 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
 	if (xa->mem.type == MEM_TYPE_PAGE_POOL)
 		page_pool_free(xa->page_pool);
 
-	/* Allow this ID to be reused */
-	ida_simple_remove(&mem_id_pool, xa->mem.id);
+	kfree(xa->refcnt);
+	allocator = xa->allocator;
+	while (xa) {
+		xa = xdp_allocator_find(allocator);
+		if (!xa)
+			break;
+
+		mutex_lock(&mem_id_lock);
+		rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params);
+		mutex_unlock(&mem_id_lock);
 
-	/* Poison memory */
-	xa->mem.id = 0xFFFF;
-	xa->mem.type = 0xF0F0;
-	xa->allocator = (void *)0xDEAD9001;
+		/* Allow this ID to be reused */
+		ida_simple_remove(&mem_id_pool, xa->mem.id);
 
-	kfree(xa);
+		/* Poison memory */
+		xa->mem.id = 0xFFFF;
+		xa->mem.type = 0xF0F0;
+		xa->allocator = (void *)0xDEAD9001;
+
+		kfree(xa);
+	}
 }
 
 static bool __mem_id_disconnect(int id, bool force)
@@ -98,6 +138,18 @@ static bool __mem_id_disconnect(int id, bool force)
 		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
 		return true;
 	}
+
+	/* to avoid calling hash lookup twice, decrement refcnt here till it
+	 * reaches zero, then it can be called from workqueue afterwards.
+	 */
+	if (*xa->refcnt)
+		(*xa->refcnt)--;
+
+	if (*xa->refcnt) {
+		mutex_unlock(&mem_id_lock);
+		return true;
+	}
+
 	xa->disconnect_cnt++;
 
 	/* Detects in-flight packet-pages for page_pool */
@@ -106,8 +158,7 @@ static bool __mem_id_disconnect(int id, bool force)
 
 	trace_mem_disconnect(xa, safe_to_remove, force);
 
-	if ((safe_to_remove || force) &&
-	    !rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
+	if (safe_to_remove || force)
 		call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);
 
 	mutex_unlock(&mem_id_lock);
@@ -316,6 +367,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 			       enum xdp_mem_type type, void *allocator)
 {
 	struct xdp_mem_allocator *xdp_alloc;
+	unsigned long *refcnt = NULL;
 	gfp_t gfp = GFP_KERNEL;
 	int id, errno, ret;
 	void *ptr;
@@ -347,6 +399,19 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 		}
 	}
 
+	mutex_lock(&mem_id_lock);
+	xdp_alloc = xdp_allocator_find(allocator);
+	if (xdp_alloc) {
+		/* One allocator per queue is supposed only */
+		if (xdp_alloc->queue_index != xdp_rxq->queue_index) {
+			mutex_unlock(&mem_id_lock);
+			return -EINVAL;
+		}
+
+		refcnt = xdp_alloc->refcnt;
+	}
+	mutex_unlock(&mem_id_lock);
+
 	xdp_alloc = kzalloc(sizeof(*xdp_alloc), gfp);
 	if (!xdp_alloc)
 		return -ENOMEM;
@@ -360,6 +425,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 	xdp_rxq->mem.id = id;
 	xdp_alloc->mem  = xdp_rxq->mem;
 	xdp_alloc->allocator = allocator;
+	xdp_alloc->queue_index = xdp_rxq->queue_index;
 
 	/* Insert allocator into ID lookup table */
 	ptr = rhashtable_insert_slow(mem_id_ht, &id, &xdp_alloc->node);
@@ -370,6 +436,16 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 		goto err;
 	}
 
+	if (!refcnt) {
+		refcnt = kzalloc(sizeof(*xdp_alloc->refcnt), gfp);
+		if (!refcnt) {
+			errno = -ENOMEM;
+			goto err;
+		}
+	}
+
+	(*refcnt)++;
+	xdp_alloc->refcnt = refcnt;
 	mutex_unlock(&mem_id_lock);
 
 	trace_mem_connect(xdp_alloc, xdp_rxq);



>
>
>>  #endif /* __LINUX_NET_XDP_PRIV_H__ */
>> diff --git a/net/core/xdp.c b/net/core/xdp.c
>> index 829377cc83db..4f0ddbb3717a 100644
>> --- a/net/core/xdp.c
>> +++ b/net/core/xdp.c
>> @@ -98,6 +98,18 @@ static bool __mem_id_disconnect(int id, bool force)
>>  		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
>>  		return true;
>>  	}
>> +
>> +	/* to avoid calling hash lookup twice, decrement refcnt here till it
>> +	 * reaches zero, then it can be called from workqueue afterwards.
>> +	 */
>> +	if (xa->refcnt)
>> +		xa->refcnt--;
>> +
>> +	if (xa->refcnt) {
>> +		mutex_unlock(&mem_id_lock);
>> +		return true;
>> +	}
>> +
>>  	xa->disconnect_cnt++;
>>
>>  	/* Detects in-flight packet-pages for page_pool */
>> @@ -312,6 +324,33 @@ static bool __is_supported_mem_type(enum xdp_mem_type type)
>>  	return true;
>>  }
>>
>> +static struct xdp_mem_allocator *xdp_allocator_find(void *allocator)
>> +{
>> +	struct xdp_mem_allocator *xae, *xa = NULL;
>> +	struct rhashtable_iter iter;
>> +
>> +	if (!allocator)
>> +		return xa;
>> +
>> +	rhashtable_walk_enter(mem_id_ht, &iter);
>> +	do {
>> +		rhashtable_walk_start(&iter);
>> +
>> +		while ((xae = rhashtable_walk_next(&iter)) && !IS_ERR(xae)) {
>> +			if (xae->allocator == allocator) {
>> +				xa = xae;
>> +				break;
>> +			}
>> +		}
>> +
>> +		rhashtable_walk_stop(&iter);
>> +
>> +	} while (xae == ERR_PTR(-EAGAIN));
>> +	rhashtable_walk_exit(&iter);
>> +
>> +	return xa;
>> +}
>> +
>>  int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>>  			       enum xdp_mem_type type, void *allocator)
>>  {
>> @@ -347,6 +386,20 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>>  		}
>>  	}
>>
>> +	mutex_lock(&mem_id_lock);
>> +	xdp_alloc = xdp_allocator_find(allocator);
>> +	if (xdp_alloc) {
>> +		/* One allocator per queue is supposed only */
>> +		if (xdp_alloc->queue_index != xdp_rxq->queue_index)
>> +			return -EINVAL;
>> +
>> +		xdp_rxq->mem.id = xdp_alloc->mem.id;
>> +		xdp_alloc->refcnt++;
>> +		mutex_unlock(&mem_id_lock);
>> +		return 0;
>> +	}
>> +	mutex_unlock(&mem_id_lock);
>> +
>>  	xdp_alloc = kzalloc(sizeof(*xdp_alloc), gfp);
>>  	if (!xdp_alloc)
>>  		return -ENOMEM;
>> @@ -360,6 +413,8 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>>  	xdp_rxq->mem.id = id;
>>  	xdp_alloc->mem  = xdp_rxq->mem;
>>  	xdp_alloc->allocator = allocator;
>> +	xdp_alloc->refcnt = 1;
>> +	xdp_alloc->queue_index = xdp_rxq->queue_index;
>>
>>  	/* Insert allocator into ID lookup table */
>>  	ptr = rhashtable_insert_slow(mem_id_ht, &id, &xdp_alloc->node);
>
>
>
>-- 
>Best regards,
>  Jesper Dangaard Brouer
>  MSc.CS, Principal Kernel Engineer at Red Hat
>  LinkedIn: http://www.linkedin.com/in/brouer

-- 
Regards,
Ivan Khoronzhuk
