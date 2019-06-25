Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA41154ED0
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 14:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfFYM22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 08:28:28 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37932 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfFYM22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 08:28:28 -0400
Received: by mail-lf1-f67.google.com with SMTP id b11so12516134lfa.5
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 05:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7KcaR6qhQv7yMSYzHtihP7lUwO4rlNVClqXsROuTHxM=;
        b=TF2VsDGDFZ2rbyYId7lPjkCrK9Bjj2aKfIPfPRJlPKuOuJmdy00yA4yVafwZqUB7ak
         vsbkO39xSM53bdzdE++rMMngPD3IJdRdTnNX2x/GRlIUZGiTvzuLJZPs28tVurtiaG+k
         PwtFaDOvXKvNiGc+8XDttn/FtZxqiXJtUyIhRF0HsvYAAAMsLKn3jVsO+6iFJesA9k4o
         2QZZQLZiJYf1ITWs9JfQ03rHQ4qZWh426cHJCxYv/TLY3Oq/VI9IfDY1me6GIN5Y+jte
         08iljIA0x/QahkQL0gJueyaNSdCFpjTxy9C7eRo+YCmDzmFhS2oh3loqxLYot7KGDptS
         ymRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7KcaR6qhQv7yMSYzHtihP7lUwO4rlNVClqXsROuTHxM=;
        b=CRZ7QxZ/092z/cc79Ryq4AS6HVCP4ajgpy/zbtE50xc8a/ELCL/Gf6iOjwq64s1bN+
         1RXewy7mjW8/izbIwWNT9lyEP/Xohe+9A670DEgpaR1xcNT+nIsjUTav8K5xRRuvrcP7
         7Qz9+YEtOT5ZoRj79zk5YXEzcFN3KHnIdDYhKVnUuNn4CQ5XtsWwLUeyN0HAaO0NGlCW
         aCTAOMat4Va1q8dLCiK2LCciWmf0m8cJkDtzjr3g+Bbf/Ak7UbVPjLpyOT+jolVA1kBr
         rhgNTImYQ1IOCgMIhlaRx+bsNUniDHld2wdrWwPahK5OoVnhu/vdZqmMrMlEwWlIaOt+
         kQzA==
X-Gm-Message-State: APjAAAU3M67R9EZ4AmuysZId9y1CtwziuLZzMcJ904O/3Ft4/CC3+++h
        +GcKxkeUCoOhEwgwn3pQkO+llw==
X-Google-Smtp-Source: APXvYqxy26PYHLxMx8kD5nP1dlfWYrxb5HVuQZvcc1CJKMiNCT9TP6PtBU0S8E8G7vt+rDdH71d4aQ==
X-Received: by 2002:ac2:5446:: with SMTP id d6mr16421554lfn.138.1561465705797;
        Tue, 25 Jun 2019 05:28:25 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id w15sm940324ljh.0.2019.06.25.05.28.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Jun 2019 05:28:25 -0700 (PDT)
Date:   Tue, 25 Jun 2019 15:28:23 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>, toshiaki.makita1@gmail.com,
        grygorii.strashko@ti.com, mcroce@redhat.com
Subject: Re: [PATCH net-next v2 08/12] xdp: tracking page_pool resources and
 safe removal
Message-ID: <20190625122822.GC6485@khorivan>
References: <156086304827.27760.11339786046465638081.stgit@firesoul>
 <156086314789.27760.6549333469314693352.stgit@firesoul>
 <20190625105013.GA6485@khorivan>
 <20190625132750.06939133@carbon>
 <20190625115107.GB6485@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190625115107.GB6485@khorivan>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 02:51:08PM +0300, Ivan Khoronzhuk wrote:
>On Tue, Jun 25, 2019 at 01:27:50PM +0200, Jesper Dangaard Brouer wrote:
>>On Tue, 25 Jun 2019 13:50:14 +0300
>>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>>
>>>Hi Jesper,
>>>
>>>Could you please clarify one question.
>>>
>>>On Tue, Jun 18, 2019 at 03:05:47PM +0200, Jesper Dangaard Brouer wrote:
>>>>This patch is needed before we can allow drivers to use page_pool for
>>>>DMA-mappings. Today with page_pool and XDP return API, it is possible to
>>>>remove the page_pool object (from rhashtable), while there are still
>>>>in-flight packet-pages. This is safely handled via RCU and failed lookups in
>>>>__xdp_return() fallback to call put_page(), when page_pool object is gone.
>>>>In-case page is still DMA mapped, this will result in page note getting
>>>>correctly DMA unmapped.
>>>>
>>>>To solve this, the page_pool is extended with tracking in-flight pages. And
>>>>XDP disconnect system queries page_pool and waits, via workqueue, for all
>>>>in-flight pages to be returned.
>>>>
>>>>To avoid killing performance when tracking in-flight pages, the implement
>>>>use two (unsigned) counters, that in placed on different cache-lines, and
>>>>can be used to deduct in-flight packets. This is done by mapping the
>>>>unsigned "sequence" counters onto signed Two's complement arithmetic
>>>>operations. This is e.g. used by kernel's time_after macros, described in
>>>>kernel commit 1ba3aab3033b and 5a581b367b5, and also explained in RFC1982.
>>>>
>>>>The trick is these two incrementing counters only need to be read and
>>>>compared, when checking if it's safe to free the page_pool structure. Which
>>>>will only happen when driver have disconnected RX/alloc side. Thus, on a
>>>>non-fast-path.
>>>>
>>>>It is chosen that page_pool tracking is also enabled for the non-DMA
>>>>use-case, as this can be used for statistics later.
>>>>
>>>>After this patch, using page_pool requires more strict resource "release",
>>>>e.g. via page_pool_release_page() that was introduced in this patchset, and
>>>>previous patches implement/fix this more strict requirement.
>>>>
>>>>Drivers no-longer call page_pool_destroy(). Drivers already call
>>>>xdp_rxq_info_unreg() which call xdp_rxq_info_unreg_mem_model(), which will
>>>>attempt to disconnect the mem id, and if attempt fails schedule the
>>>>disconnect for later via delayed workqueue.
>>>>
>>>>Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>>>Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>>>>---
>>>> drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    3 -
>>>> include/net/page_pool.h                           |   41 ++++++++++---
>>>> net/core/page_pool.c                              |   62 +++++++++++++++-----
>>>> net/core/xdp.c                                    |   65 +++++++++++++++++++--
>>>> 4 files changed, 136 insertions(+), 35 deletions(-)
>>>>
>>>>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>>>index 2f647be292b6..6c9d4d7defbc 100644
>>>>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>>>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>>>@@ -643,9 +643,6 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
>>>> 	}
>>>>
>>>> 	xdp_rxq_info_unreg(&rq->xdp_rxq);
>>>>-	if (rq->page_pool)
>>>>-		page_pool_destroy(rq->page_pool);
>>>>-
>>>> 	mlx5_wq_destroy(&rq->wq_ctrl);
>>>> }
>>>>
>>>>diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>>>>index 754d980700df..f09b3f1994e6 100644
>>>>--- a/include/net/page_pool.h
>>>>+++ b/include/net/page_pool.h
>>>>@@ -16,14 +16,16 @@
>>>>  * page_pool_alloc_pages() call.  Drivers should likely use
>>>>  * page_pool_dev_alloc_pages() replacing dev_alloc_pages().
>>>>  *
>>>>- * If page_pool handles DMA mapping (use page->private), then API user
>>>>- * is responsible for invoking page_pool_put_page() once.  In-case of
>>>>- * elevated refcnt, the DMA state is released, assuming other users of
>>>>- * the page will eventually call put_page().
>>>>+ * API keeps track of in-flight pages, in-order to let API user know
>>>>+ * when it is safe to dealloactor page_pool object.  Thus, API users
>>>>+ * must make sure to call page_pool_release_page() when a page is
>>>>+ * "leaving" the page_pool.  Or call page_pool_put_page() where
>>>>+ * appropiate.  For maintaining correct accounting.
>>>>  *
>>>>- * If no DMA mapping is done, then it can act as shim-layer that
>>>>- * fall-through to alloc_page.  As no state is kept on the page, the
>>>>- * regular put_page() call is sufficient.
>>>>+ * API user must only call page_pool_put_page() once on a page, as it
>>>>+ * will either recycle the page, or in case of elevated refcnt, it
>>>>+ * will release the DMA mapping and in-flight state accounting.  We
>>>>+ * hope to lift this requirement in the future.
>>>>  */
>>>> #ifndef _NET_PAGE_POOL_H
>>>> #define _NET_PAGE_POOL_H
>>>>@@ -66,9 +68,10 @@ struct page_pool_params {
>>>> };
>>>>
>>>> struct page_pool {
>>>>-	struct rcu_head rcu;
>>>> 	struct page_pool_params p;
>>>>
>>>>+        u32 pages_state_hold_cnt;
>>>>+
>>>> 	/*
>>>> 	 * Data structure for allocation side
>>>> 	 *
>>>>@@ -96,6 +99,8 @@ struct page_pool {
>>>> 	 * TODO: Implement bulk return pages into this structure.
>>>> 	 */
>>>> 	struct ptr_ring ring;
>>>>+
>>>>+	atomic_t pages_state_release_cnt;
>>>> };
>>>>
>>>> struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
>>>>@@ -109,8 +114,6 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
>>>>
>>>> struct page_pool *page_pool_create(const struct page_pool_params *params);
>>>>
>>>>-void page_pool_destroy(struct page_pool *pool);
>>>>-
>>>> void __page_pool_free(struct page_pool *pool);
>>>> static inline void page_pool_free(struct page_pool *pool)
>>>> {
>>>>@@ -143,6 +146,24 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>>>> 	__page_pool_put_page(pool, page, true);
>>>> }
>>>>
>>>>+/* API user MUST have disconnected alloc-side (not allowed to call
>>>>+ * page_pool_alloc_pages()) before calling this.  The free-side can
>>>>+ * still run concurrently, to handle in-flight packet-pages.
>>>>+ *
>>>>+ * A request to shutdown can fail (with false) if there are still
>>>>+ * in-flight packet-pages.
>>>>+ */
>>>>+bool __page_pool_request_shutdown(struct page_pool *pool);
>>>>+static inline bool page_pool_request_shutdown(struct page_pool *pool)
>>>>+{
>>>>+	/* When page_pool isn't compiled-in, net/core/xdp.c doesn't
>>>>+	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
>>>>+	 */
>>>>+#ifdef CONFIG_PAGE_POOL
>>>>+	return __page_pool_request_shutdown(pool);
>>>>+#endif
>>>>+}
>>>
>>>The free side can ran in softirq, that means fast cache recycle is accessed.
>>>And it increments not atomic pool->alloc.count.
>>>
>>>For instance While redirect, for remote interface, while .ndo_xdp_xmit the
>>>xdp_return_frame_rx_napi(xdpf) is called everywhere in error path ....
>^
>|
>
>>>
>>>In the same time, simultaneously, the work queue can try one more
>>>time to clear cash, calling __page_pool_request_shutdown()....
>>>
>>>Question, what prevents pool->alloc.count to be corrupted by race,
>>>causing to wrong array num and as result wrong page to be unmapped/put ....or
>>>even page leak. alloc.count usage is not protected,
>>>__page_pool_request_shutdown() is called not from same rx NAPI, even not from
>>>NAPI.
>>>
>>>Here, while alloc cache empty procedure in __page_pool_request_shutdown():
>>
>>You forgot to copy this comment, which explains:
>>
>>	/* Empty alloc cache, assume caller made sure this is
>>	 * no-longer in use, and page_pool_alloc_pages() cannot be
>>	 * call concurrently.
>>	 */
>No I didn't. I'm talking about recycle, not allocation.
>To be more specific about this:
>__page_pool_recycle_direct() while remote ndev .ndo_xdp_xmit
>
>About this:
>"
>/* API user MUST have disconnected alloc-side (not allowed to call
>* page_pool_alloc_pages()) before calling this.  The free-side can
>* still run concurrently, to handle in-flight packet-pages.
>"

For me it's important to know only if it means that alloc.count is
freed at first call of __mem_id_disconnect() while shutdown.
The workqueue for the rest is connected only with ring cache protected
by ring lock and not supposed that alloc.count can be changed while
workqueue tries to shutdonwn the pool.


-- 
Regards,
Ivan Khoronzhuk
