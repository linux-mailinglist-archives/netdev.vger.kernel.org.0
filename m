Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28E6A44AA4
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbfFMS2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:28:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36082 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727179AbfFMS2L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 14:28:11 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 497E55D60F;
        Thu, 13 Jun 2019 18:28:11 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-44.brq.redhat.com [10.40.200.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D826254213;
        Thu, 13 Jun 2019 18:28:07 +0000 (UTC)
Received: from [192.168.5.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 084EE31256FCA;
        Thu, 13 Jun 2019 20:28:07 +0200 (CEST)
Subject: [PATCH net-next v1 01/11] net: page_pool: add helper function to
 retrieve dma addresses
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     toshiaki.makita1@gmail.com, grygorii.strashko@ti.com,
        ivan.khoronzhuk@linaro.org, mcroce@redhat.com
Date:   Thu, 13 Jun 2019 20:28:07 +0200
Message-ID: <156045048696.29115.1338915143858015398.stgit@firesoul>
In-Reply-To: <156045046024.29115.11802895015973488428.stgit@firesoul>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 13 Jun 2019 18:28:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

On a previous patch dma addr was stored in 'struct page'.
Use that to retrieve DMA addresses used by network drivers

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/page_pool.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 694d055e01ef..b885d86cb7a1 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -132,6 +132,11 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 	__page_pool_put_page(pool, page, true);
 }
 
+static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
+{
+	return page->dma_addr;
+}
+
 static inline bool is_page_pool_compiled_in(void)
 {
 #ifdef CONFIG_PAGE_POOL

