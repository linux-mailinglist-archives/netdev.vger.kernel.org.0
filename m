Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C7763E31E
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiK3WI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiK3WIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:11 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05E983254
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ZJ5hBzYhZmqX7EWE+UyUU89Wo31DpmEICSokzO+fPkY=; b=n8RFCcCMXl5iM1uUVA6zf1zyks
        PyjgurKWyEzmOKEuRkha9iZg+AkoVAgEaV2bs0NRWEBUoRWl/UJFAj6U8BAWGw/+IQhCW6BEUl4El
        diuNbQlG5FXcLmez1LuOhq52VbvGsihFf45CxJ48Qv1n7BcdG13dprT3dn9tqLazYgMuOxQ8fBnPs
        WpHJzZs5YpwsrepKxGNQA8okq7zQIAvQq4WITEQzrLsyUDHFDXut97myVtF6xS1F1rp7HxdL0IlQp
        Pj3dnG93vIgZJ8mdvNlnM0jCEF/jVasWzxqvCcC5OquwtEsJbAyAYuyFV8gMLggCgHn/Ni8vqZvsk
        cRBAMgqA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFN-00FLVi-SC; Wed, 30 Nov 2022 22:08:05 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 15/24] page_pool: Remove page_pool_defrag_page()
Date:   Wed, 30 Nov 2022 22:07:54 +0000
Message-Id: <20221130220803.3657490-16-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221130220803.3657490-1-willy@infradead.org>
References: <20221130220803.3657490-1-willy@infradead.org>
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
index b34d1695698a..c89a13393a23 100644
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

