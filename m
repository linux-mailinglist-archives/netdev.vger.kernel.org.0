Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C00E65F60D
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbjAEVqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235945AbjAEVq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:46:28 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593A4676DD
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=RB/DJOai+Xj2Jq/alSKJq8OklNQ6kO9rsGtnPI4eEMo=; b=ED1yBOrIT0OjB5ucAUzWiZcaQ6
        y11rP+SKiymZW8hxXR5mr6ahwWhzWGeh/LjNTDRLcn2jtWMw1KFa/NfDmNgpEhalGZ5cG1ZnDO+VS
        HsQKPPzX5sUN33Z4Ss+FuOX4ZDD60pu5LVK12bkmoskToy1NeNYH+dRe4d6TmQhSejDAOYHibU7b5
        Y3TFMJ4bT6bv9hDPD1qKlYJ2eBszNt69x08T6VzmcEv3rItwA/hbovbZbfwLi5FssutKanUERY9JQ
        xCW13UZwJp/Om0P3jItR+KgqDyw8OefRmd9CJzVBaxJbODBuLJNtr5pBazPdfiqcQpoyrSUnBQNaX
        nfBRV2HQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDY4I-00GWnn-M0; Thu, 05 Jan 2023 21:46:34 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 15/24] page_pool: Remove page_pool_defrag_page()
Date:   Thu,  5 Jan 2023 21:46:22 +0000
Message-Id: <20230105214631.3939268-16-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230105214631.3939268-1-willy@infradead.org>
References: <20230105214631.3939268-1-willy@infradead.org>
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

