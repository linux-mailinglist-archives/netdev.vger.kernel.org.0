Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B15E54DF9
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 13:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbfFYLvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 07:51:14 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46448 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbfFYLvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 07:51:14 -0400
Received: by mail-lf1-f66.google.com with SMTP id z15so12363984lfh.13
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 04:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vHAHwPoMogHk1D7n51CXyT+HQJSygY3Shq8DGHtaPhQ=;
        b=B2Bvz/zcsDaEuOgw8Bv8/emq2WPu41qxkJP576J8ZVo5V/s3DJiqnIwaVwx5Hxn0D5
         k9yKGvF9Vc+c3cO6YA+gRp46EurwjHkG2NcATRBqEAey0Zll306b45pQRQx9l425cN2X
         UgbjQYH8NpOo5Zg8eIuYNvbcaponzrXcTIc1V+5I49T2yy+npFDO+W2OufTWOBd5XVUk
         PAp6TddNWciJ/NoPGql1r3ip2eWwXY/C4HTHvR74fB4sg0mxSGmuWaIrMW4ASyvW7D0y
         IeK6+/qwVvMpp7hJOUG/lBWl0XlX4sUuDzhPBO2o9rBdY9Z4vXyQyUxcbXGOhSyxdFp9
         TWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vHAHwPoMogHk1D7n51CXyT+HQJSygY3Shq8DGHtaPhQ=;
        b=iyRi/glxLJe9uxcJojPeftpCXOXAMdUpNwrC9rXZxdZJKUzQxrx98Koj5TBX658nNS
         m2JpSLudddClov4PZmEsjaidT3PtKfIpPdxh+UxH6l5/Dy7dweDZZCl33qxIi3iuCB14
         PIVK8X27h2sx5gT7J4ryHFmX92if2pCtejFEbKXhgTYmtqOXCbRmugx5JVpkbe67km2w
         B8M/mNst+H6PjKwTCdOxzwfqvSFF4Bij6+sFcuoQiEe1takQQeLS+ZEcdeiO1BkUWyTS
         7Di3EsbEu6RCnn6EWOIexPrq9kL0BPIOg3CxusFYfG6xTBy8VBnQAIbMT+XyJfqVxBGJ
         szfg==
X-Gm-Message-State: APjAAAVppKgqQO+LY8SS73SvDCrbiq8DmJLpOGgq9P9M/arayNSFkQlN
        0ialF8SRs/RAZR4qiWPK7HOHBQ==
X-Google-Smtp-Source: APXvYqyhHbkgwIEpWSB1mZuP0JhvzavVBEXtOLDeex29uIkyI/A4GGWMT5wpwKt0GCVQFuW44p6d2Q==
X-Received: by 2002:a19:c14f:: with SMTP id r76mr32410317lff.70.1561463470886;
        Tue, 25 Jun 2019 04:51:10 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id u18sm681329lfe.65.2019.06.25.04.51.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Jun 2019 04:51:10 -0700 (PDT)
Date:   Tue, 25 Jun 2019 14:51:08 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>, toshiaki.makita1@gmail.com,
        grygorii.strashko@ti.com, mcroce@redhat.com
Subject: Re: [PATCH net-next v2 08/12] xdp: tracking page_pool resources and
 safe removal
Message-ID: <20190625115107.GB6485@khorivan>
References: <156086304827.27760.11339786046465638081.stgit@firesoul>
 <156086314789.27760.6549333469314693352.stgit@firesoul>
 <20190625105013.GA6485@khorivan>
 <20190625132750.06939133@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190625132750.06939133@carbon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 01:27:50PM +0200, Jesper Dangaard Brouer wrote:
>On Tue, 25 Jun 2019 13:50:14 +0300
>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> Hi Jesper,
>>
>> Could you please clarify one question.
>>
>> On Tue, Jun 18, 2019 at 03:05:47PM +0200, Jesper Dangaard Brouer wrote:
>> >This patch is needed before we can allow drivers to use page_pool for
>> >DMA-mappings. Today with page_pool and XDP return API, it is possible to
>> >remove the page_pool object (from rhashtable), while there are still
>> >in-flight packet-pages. This is safely handled via RCU and failed lookups in
>> >__xdp_return() fallback to call put_page(), when page_pool object is gone.
>> >In-case page is still DMA mapped, this will result in page note getting
>> >correctly DMA unmapped.
>> >
>> >To solve this, the page_pool is extended with tracking in-flight pages. And
>> >XDP disconnect system queries page_pool and waits, via workqueue, for all
>> >in-flight pages to be returned.
>> >
>> >To avoid killing performance when tracking in-flight pages, the implement
>> >use two (unsigned) counters, that in placed on different cache-lines, and
>> >can be used to deduct in-flight packets. This is done by mapping the
>> >unsigned "sequence" counters onto signed Two's complement arithmetic
>> >operations. This is e.g. used by kernel's time_after macros, described in
>> >kernel commit 1ba3aab3033b and 5a581b367b5, and also explained in RFC1982.
>> >
>> >The trick is these two incrementing counters only need to be read and
>> >compared, when checking if it's safe to free the page_pool structure. Which
>> >will only happen when driver have disconnected RX/alloc side. Thus, on a
>> >non-fast-path.
>> >
>> >It is chosen that page_pool tracking is also enabled for the non-DMA
>> >use-case, as this can be used for statistics later.
>> >
>> >After this patch, using page_pool requires more strict resource "release",
>> >e.g. via page_pool_release_page() that was introduced in this patchset, and
>> >previous patches implement/fix this more strict requirement.
>> >
>> >Drivers no-longer call page_pool_destroy(). Drivers already call
>> >xdp_rxq_info_unreg() which call xdp_rxq_info_unreg_mem_model(), which will
>> >attempt to disconnect the mem id, and if attempt fails schedule the
>> >disconnect for later via delayed workqueue.
>> >
>> >Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> >Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>> >---
>> > drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    3 -
>> > include/net/page_pool.h                           |   41 ++++++++++---
>> > net/core/page_pool.c                              |   62 +++++++++++++++-----
>> > net/core/xdp.c                                    |   65 +++++++++++++++++++--
>> > 4 files changed, 136 insertions(+), 35 deletions(-)
>> >
>> >diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> >index 2f647be292b6..6c9d4d7defbc 100644
>> >--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> >+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> >@@ -643,9 +643,6 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
>> > 	}
>> >
>> > 	xdp_rxq_info_unreg(&rq->xdp_rxq);
>> >-	if (rq->page_pool)
>> >-		page_pool_destroy(rq->page_pool);
>> >-
>> > 	mlx5_wq_destroy(&rq->wq_ctrl);
>> > }
>> >
>> >diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>> >index 754d980700df..f09b3f1994e6 100644
>> >--- a/include/net/page_pool.h
>> >+++ b/include/net/page_pool.h
>> >@@ -16,14 +16,16 @@
>> >  * page_pool_alloc_pages() call.  Drivers should likely use
>> >  * page_pool_dev_alloc_pages() replacing dev_alloc_pages().
>> >  *
>> >- * If page_pool handles DMA mapping (use page->private), then API user
>> >- * is responsible for invoking page_pool_put_page() once.  In-case of
>> >- * elevated refcnt, the DMA state is released, assuming other users of
>> >- * the page will eventually call put_page().
>> >+ * API keeps track of in-flight pages, in-order to let API user know
>> >+ * when it is safe to dealloactor page_pool object.  Thus, API users
>> >+ * must make sure to call page_pool_release_page() when a page is
>> >+ * "leaving" the page_pool.  Or call page_pool_put_page() where
>> >+ * appropiate.  For maintaining correct accounting.
>> >  *
>> >- * If no DMA mapping is done, then it can act as shim-layer that
>> >- * fall-through to alloc_page.  As no state is kept on the page, the
>> >- * regular put_page() call is sufficient.
>> >+ * API user must only call page_pool_put_page() once on a page, as it
>> >+ * will either recycle the page, or in case of elevated refcnt, it
>> >+ * will release the DMA mapping and in-flight state accounting.  We
>> >+ * hope to lift this requirement in the future.
>> >  */
>> > #ifndef _NET_PAGE_POOL_H
>> > #define _NET_PAGE_POOL_H
>> >@@ -66,9 +68,10 @@ struct page_pool_params {
>> > };
>> >
>> > struct page_pool {
>> >-	struct rcu_head rcu;
>> > 	struct page_pool_params p;
>> >
>> >+        u32 pages_state_hold_cnt;
>> >+
>> > 	/*
>> > 	 * Data structure for allocation side
>> > 	 *
>> >@@ -96,6 +99,8 @@ struct page_pool {
>> > 	 * TODO: Implement bulk return pages into this structure.
>> > 	 */
>> > 	struct ptr_ring ring;
>> >+
>> >+	atomic_t pages_state_release_cnt;
>> > };
>> >
>> > struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
>> >@@ -109,8 +114,6 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
>> >
>> > struct page_pool *page_pool_create(const struct page_pool_params *params);
>> >
>> >-void page_pool_destroy(struct page_pool *pool);
>> >-
>> > void __page_pool_free(struct page_pool *pool);
>> > static inline void page_pool_free(struct page_pool *pool)
>> > {
>> >@@ -143,6 +146,24 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>> > 	__page_pool_put_page(pool, page, true);
>> > }
>> >
>> >+/* API user MUST have disconnected alloc-side (not allowed to call
>> >+ * page_pool_alloc_pages()) before calling this.  The free-side can
>> >+ * still run concurrently, to handle in-flight packet-pages.
>> >+ *
>> >+ * A request to shutdown can fail (with false) if there are still
>> >+ * in-flight packet-pages.
>> >+ */
>> >+bool __page_pool_request_shutdown(struct page_pool *pool);
>> >+static inline bool page_pool_request_shutdown(struct page_pool *pool)
>> >+{
>> >+	/* When page_pool isn't compiled-in, net/core/xdp.c doesn't
>> >+	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
>> >+	 */
>> >+#ifdef CONFIG_PAGE_POOL
>> >+	return __page_pool_request_shutdown(pool);
>> >+#endif
>> >+}
>>
>> The free side can ran in softirq, that means fast cache recycle is accessed.
>> And it increments not atomic pool->alloc.count.
>>
>> For instance While redirect, for remote interface, while .ndo_xdp_xmit the
>> xdp_return_frame_rx_napi(xdpf) is called everywhere in error path ....
^
|

>>
>> In the same time, simultaneously, the work queue can try one more
>> time to clear cash, calling __page_pool_request_shutdown()....
>>
>> Question, what prevents pool->alloc.count to be corrupted by race,
>> causing to wrong array num and as result wrong page to be unmapped/put ....or
>> even page leak. alloc.count usage is not protected,
>> __page_pool_request_shutdown() is called not from same rx NAPI, even not from
>> NAPI.
>>
>> Here, while alloc cache empty procedure in __page_pool_request_shutdown():
>
>You forgot to copy this comment, which explains:
>
>	/* Empty alloc cache, assume caller made sure this is
>	 * no-longer in use, and page_pool_alloc_pages() cannot be
>	 * call concurrently.
>	 */
No I didn't. I'm talking about recycle, not allocation.
To be more specific about this:
__page_pool_recycle_direct() while remote ndev .ndo_xdp_xmit

About this:
"
/* API user MUST have disconnected alloc-side (not allowed to call
 * page_pool_alloc_pages()) before calling this.  The free-side can
 * still run concurrently, to handle in-flight packet-pages.
"

>
>> while (pool->alloc.count) {
>> 	page = pool->alloc.cache[--pool->alloc.count];
>> 	__page_pool_return_page(pool, page);
>> }
>>
>> For me seems all works fine, but I can't find what have I missed?
>
>You have missed that, it is the drivers responsibility to "disconnect"
>the xdp_rxq_info before calling shutdown.  Which means that it is not
>allowed to be used for RX, while the driver is shutting down a
>RX-queue.  For drivers this is very natural, else other things will
>break.
>
>
>> ...
>>
>> Same question about how xdp frame should be returned for drivers running
>> tx napi exclusively, it can be still softirq but another CPU? What API
>> should be used to return xdp frame.
>
>You have to use the normal xdp_return_frame() which doesn't do "direct"
>return.

Oh, yes, sorry
	/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
	xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
	page = virt_to_head_page(data);
	if (likely(xa)) {
		napi_direct &= !xdp_return_frame_no_direct();
		page_pool_put_page(xa->page_pool, page, napi_direct);

just masked napi_direct on 1, but forgot it's zero from scratch......

>
>-- 
>Best regards,
>  Jesper Dangaard Brouer
>  MSc.CS, Principal Kernel Engineer at Red Hat
>  LinkedIn: http://www.linkedin.com/in/brouer

-- 
Regards,
Ivan Khoronzhuk
