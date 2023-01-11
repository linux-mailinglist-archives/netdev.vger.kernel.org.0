Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EE36652CD
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbjAKEYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235672AbjAKEX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:23:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB1513DF7
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=U72xqlqZdFtENPRRx+9rCkghzEjYY0Lo68usGx26lnQ=; b=SZcAgEFK5V6x+xk6wG+iTbrW/C
        ZYV9UVKgyflsHxh8K95OvNqqX8XX16of+BuJRNQSLsjbYuYlPwdFtdzOogmClk+DmLkCLXgq2a0mN
        yGWIuZMyTg8ZAK/HidKMe0isCU0y0i7tDYG9KTgHsTkj4rCN58jEnCZxrxNkytz1wrIJsP9KPb338
        fzPOU0pmVzJhlmyljsRCab2kuspC/mZ7AmBdjvfZL5CgTZXbLempfP0zgHe2vTxte5X8bnKqlFnOI
        t80FAFzByJiqtw6mmdapM90Xb7S+Ey5tDnocdR+CvainRlHDYYgXMG/UOtWvH0VWFOvcQ05Aqr5m+
        H2o6FVmg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFScz-003nyA-C0; Wed, 11 Jan 2023 04:22:17 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v3 15/26] page_pool: Remove __page_pool_put_page()
Date:   Wed, 11 Jan 2023 04:22:03 +0000
Message-Id: <20230111042214.907030-16-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230111042214.907030-1-willy@infradead.org>
References: <20230111042214.907030-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This wrapper is no longer used.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 net/core/page_pool.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index b925a4dcb09b..c495e3a16e83 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -607,14 +607,6 @@ __page_pool_put_netmem(struct page_pool *pool, struct netmem *nmem,
 	return NULL;
 }
 
-static __always_inline struct page *
-__page_pool_put_page(struct page_pool *pool, struct page *page,
-		     unsigned int dma_sync_size, bool allow_direct)
-{
-	return netmem_page(__page_pool_put_netmem(pool, page_netmem(page),
-						dma_sync_size, allow_direct));
-}
-
 void page_pool_put_defragged_netmem(struct page_pool *pool, struct netmem *nmem,
 				  unsigned int dma_sync_size, bool allow_direct)
 {
-- 
2.35.1

