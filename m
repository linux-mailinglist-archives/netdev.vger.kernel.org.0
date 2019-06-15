Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E558446F20
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 10:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbfFOI7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 04:59:22 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40355 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbfFOI7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 04:59:21 -0400
Received: by mail-lf1-f68.google.com with SMTP id a9so3286445lff.7
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 01:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a3kGynG5YiwLeR6W57Q7imyieiV7XTkn1PlZcplTobg=;
        b=tpZdmrYriiaM1DzA1cOCDf4do8zRTLeLzTWsEs6Lte33t1jX0Le9FLhUi3ZByC0xK0
         2g3xOz8tY06KNVWbJ8BJ3UEr+/GXLlNT+L0dSOvTRtzRo47Vt9R+/1UM6om2GU2ah+lu
         uUc95vbla/yv+ypDzUmoUmXA0S4mtmr3iGPkFLrA+uzfC74ITIcNf9UMLljjdEMNwdcn
         BlTfMOD0IfWNNbgsbmno3hOKVIQXQrn6esCdVMH3wFYPzidWGKzmTaDVsNeGASk0gruM
         D6XOqfychfcME8QpkPvr3nIrn424lzPQ9YRlE9TJAedT7WkN9pMLnvTkTGwXtXQWa4VG
         JQIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=a3kGynG5YiwLeR6W57Q7imyieiV7XTkn1PlZcplTobg=;
        b=f5SSjr6wfTBanfJprJwNTBV+HgdykHAbTEZiGM4f5UgYmyyVHrPRMQQLQhKSNBNkPC
         eO5Wo5HjNwvwyLtuFx6HIMc1IxOXRoTYbdZlbT+vQdi/nrs2L8wZUabKhkMFy0jABpvE
         A5sOQVqJtY/z4hokFsXQzZOEKvXoxeeGKvb5+tJM9ZjrcOOp2aybPYRfjghKfoojmyGl
         rPAel77uL7NM0570bPi6ftdyj1+Ssu2S12liJCwghBq5iUynhsVp//fwjTcSPikMxBNu
         lZumtVFoiByzk00/xqvnVa6F5g0/uS4LuDpaW4/UOhnR9dhwDanMqYnshnGcY3XfNGvL
         /t8Q==
X-Gm-Message-State: APjAAAU1iE4c78hdIIzFp8QW0Z2eZ309R85uI9AZEvMflWSsh3TrLEQI
        4ex+mN9uJmZs3fEfX75dY2l7BQ==
X-Google-Smtp-Source: APXvYqyPwOc3GgNu9iv5ZGMD9Lq9hmhay6U7LUyIHV3dcJU7/bPezh7uaNJ7FphiFb7nvqimfZIFlw==
X-Received: by 2002:a19:22d8:: with SMTP id i207mr46830837lfi.97.1560589159174;
        Sat, 15 Jun 2019 01:59:19 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id q2sm983147ljq.74.2019.06.15.01.59.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 15 Jun 2019 01:59:18 -0700 (PDT)
Date:   Sat, 15 Jun 2019 11:59:16 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>, toshiaki.makita1@gmail.com,
        grygorii.strashko@ti.com, mcroce@redhat.com
Subject: Re: [PATCH net-next v1 09/11] xdp: force mem allocator removal and
 periodic warning
Message-ID: <20190615085915.GA3771@khorivan>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
 <156045052757.29115.17148153291969774246.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <156045052757.29115.17148153291969774246.stgit@firesoul>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 08:28:47PM +0200, Jesper Dangaard Brouer wrote:
>If bugs exists or are introduced later e.g. by drivers misusing the API,
>then we want to warn about the issue, such that developer notice. This patch
>will generate a bit of noise in form of periodic pr_warn every 30 seconds.
>
>It is not nice to have this stall warning running forever. Thus, this patch
>will (after 120 attempts) force disconnect the mem id (from the rhashtable)
>and free the page_pool object. This will cause fallback to the put_page() as
>before, which only potentially leak DMA-mappings, if objects are really
>stuck for this long. In that unlikely case, a WARN_ONCE should show us the
>call stack.
>
>Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>---
> net/core/page_pool.c |   18 +++++++++++++++++-
> net/core/xdp.c       |   37 +++++++++++++++++++++++++++++++------
> 2 files changed, 48 insertions(+), 7 deletions(-)
>
>diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>index 8679e24fd665..42c3b0a5a259 100644
>--- a/net/core/page_pool.c
>+++ b/net/core/page_pool.c
>@@ -330,11 +330,27 @@ static void __page_pool_empty_ring(struct page_pool *pool)
> 	}
> }
>
>+static void __warn_in_flight(struct page_pool *pool)
>+{
>+	u32 release_cnt = atomic_read(&pool->pages_state_release_cnt);
>+	u32 hold_cnt = READ_ONCE(pool->pages_state_hold_cnt);
>+	s32 distance;
>+
>+	distance = _distance(hold_cnt, release_cnt);
>+
>+	/* Drivers should fix this, but only problematic when DMA is used */
>+	WARN(1, "Still in-flight pages:%d hold:%u released:%u",
>+	     distance, hold_cnt, release_cnt);
>+}
>+
> void __page_pool_free(struct page_pool *pool)
> {
> 	WARN(pool->alloc.count, "API usage violation");
> 	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
>-	WARN(!__page_pool_safe_to_destroy(pool), "still in-flight pages");
>+
>+	/* Can happen due to forced shutdown */
>+	if (!__page_pool_safe_to_destroy(pool))
>+		__warn_in_flight(pool);
>
> 	ptr_ring_cleanup(&pool->ring, NULL);
> 	kfree(pool);
>diff --git a/net/core/xdp.c b/net/core/xdp.c
>index 2b7bad227030..53bce4fa776a 100644
>--- a/net/core/xdp.c
>+++ b/net/core/xdp.c
>@@ -39,6 +39,9 @@ struct xdp_mem_allocator {
> 	struct rhash_head node;
> 	struct rcu_head rcu;
> 	struct delayed_work defer_wq;
>+	unsigned long defer_start;
>+	unsigned long defer_warn;
>+	int disconnect_cnt;
> };
>
> static u32 xdp_mem_id_hashfn(const void *data, u32 len, u32 seed)
>@@ -95,7 +98,7 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
> 	kfree(xa);
> }
>
>-bool __mem_id_disconnect(int id)
>+bool __mem_id_disconnect(int id, bool force)
> {
> 	struct xdp_mem_allocator *xa;
> 	bool safe_to_remove = true;
>@@ -108,29 +111,47 @@ bool __mem_id_disconnect(int id)
> 		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
> 		return true;
> 	}
>+	xa->disconnect_cnt++;
>
> 	/* Detects in-flight packet-pages for page_pool */
> 	if (xa->mem.type == MEM_TYPE_PAGE_POOL)
> 		safe_to_remove = page_pool_request_shutdown(xa->page_pool);
>
>-	if (safe_to_remove &&
>+	/* TODO: Tracepoint will be added here in next-patch */
>+
>+	if ((safe_to_remove || force) &&
> 	    !rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
> 		call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);
>
> 	mutex_unlock(&mem_id_lock);
>-	return safe_to_remove;
>+	return (safe_to_remove|force);
> }
>
> #define DEFER_TIME (msecs_to_jiffies(1000))
>+#define DEFER_WARN_INTERVAL (30 * HZ)
>+#define DEFER_MAX_RETRIES 120
>
> static void mem_id_disconnect_defer_retry(struct work_struct *wq)
> {
> 	struct delayed_work *dwq = to_delayed_work(wq);
> 	struct xdp_mem_allocator *xa = container_of(dwq, typeof(*xa), defer_wq);
>+	bool force = false;
>+
>+	if (xa->disconnect_cnt > DEFER_MAX_RETRIES)
>+		force = true;
>
>-	if (__mem_id_disconnect(xa->mem.id))
>+	if (__mem_id_disconnect(xa->mem.id, force))
> 		return;
>
>+	/* Periodic warning */
>+	if (time_after_eq(jiffies, xa->defer_warn)) {
>+		int sec = (s32)((u32)jiffies - (u32)xa->defer_start) / HZ;
>+
>+		pr_warn("%s() stalled mem.id=%u shutdown %d attempts %d sec\n",
>+			__func__, xa->mem.id, xa->disconnect_cnt, sec);
>+		xa->defer_warn = jiffies + DEFER_WARN_INTERVAL;
>+	}
>+
> 	/* Still not ready to be disconnected, retry later */
> 	schedule_delayed_work(&xa->defer_wq, DEFER_TIME);
> }
>@@ -153,7 +174,7 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
> 	if (id == 0)
> 		return;
>
>-	if (__mem_id_disconnect(id))
>+	if (__mem_id_disconnect(id, false))
> 		return;
>
> 	/* Could not disconnect, defer new disconnect attempt to later */
>@@ -164,6 +185,8 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
> 		mutex_unlock(&mem_id_lock);
> 		return;
> 	}
>+	xa->defer_start = jiffies;
>+	xa->defer_warn  = jiffies + DEFER_WARN_INTERVAL;
>
> 	INIT_DELAYED_WORK(&xa->defer_wq, mem_id_disconnect_defer_retry);
> 	mutex_unlock(&mem_id_lock);
>@@ -388,10 +411,12 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
> 		/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
> 		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> 		page = virt_to_head_page(data);
>-		if (xa) {
>+		if (likely(xa)) {
> 			napi_direct &= !xdp_return_frame_no_direct();
> 			page_pool_put_page(xa->page_pool, page, napi_direct);
Interesting if it's synced with device "unregistration".
I mean page dma unmap is bind to device that doesn't exist anymore but pages
from pool of the device are in flight, so pool is not destroyed but what about
device?. smth like device unreq todo list. Just to be sure, is it synched?

> 		} else {
>+			/* Hopefully stack show who to blame for late return */
>+			WARN_ONCE(1, "page_pool gone mem.id=%d", mem->id);
> 			put_page(page);
> 		}
> 		rcu_read_unlock();
>

-- 
Regards,
Ivan Khoronzhuk
