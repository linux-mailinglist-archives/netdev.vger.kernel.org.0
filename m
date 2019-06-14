Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F9645F4D
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbfFNNsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:48:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53850 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbfFNNsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 09:48:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hVPCPj1LrefwU2xq/k4nx8MUt6z5g1ttpdf31GA4t7s=; b=R7oVdWdv/mZN0cFwPPhtVK4TMx
        UB/wqQzgkHyYoVXTIUGR/8fAw8BWFMkxfhjvQA8cZVsEfByOCf1n/fgHZGG1Ku2HbnOU7wlpCu6md
        kV7iFak0CwzMgcwf+1ko540TzfJZ7m8NhyKeNAafjIR+Eh02tznZJ/tUqmN1GKHmPpnm8D9T4ipEj
        VhsgOFo98A7OHLvTQLaE2S3jC8uxQMExeLN7wqYne/Oa8lDjeUuhj+sBM6/IpP/HI6hcndIgYuq/y
        Z6v4feaEGjGdbjf71aj7myD5cdjMs8C9wTELFpbzveIUWDepgbQiHeWiGh6p6pC5gwcbLSKzfWexb
        co9by/hQ==;
Received: from 213-225-9-13.nat.highway.a1.net ([213.225.9.13] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbmYz-0005e1-FO; Fri, 14 Jun 2019 13:48:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Intel Linux Wireless <linuxwifi@intel.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/16] mm: rename alloc_pages_exact_nid to alloc_pages_exact_node
Date:   Fri, 14 Jun 2019 15:47:23 +0200
Message-Id: <20190614134726.3827-14-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614134726.3827-1-hch@lst.de>
References: <20190614134726.3827-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fits in with the naming scheme used by alloc_pages_node.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/gfp.h | 2 +-
 mm/page_alloc.c     | 4 ++--
 mm/page_ext.c       | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index fb07b503dc45..4274ea6bc72b 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -532,7 +532,7 @@ extern unsigned long get_zeroed_page(gfp_t gfp_mask);
 
 void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
 void free_pages_exact(void *virt, size_t size);
-void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
+void * __meminit alloc_pages_exact_node(int nid, size_t size, gfp_t gfp_mask);
 
 #define __get_free_page(gfp_mask) \
 		__get_free_pages((gfp_mask), 0)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d66bc8abe0af..dd2fed66b656 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4888,7 +4888,7 @@ void *alloc_pages_exact(size_t size, gfp_t gfp_mask)
 EXPORT_SYMBOL(alloc_pages_exact);
 
 /**
- * alloc_pages_exact_nid - allocate an exact number of physically-contiguous
+ * alloc_pages_exact_node - allocate an exact number of physically-contiguous
  *			   pages on a node.
  * @nid: the preferred node ID where memory should be allocated
  * @size: the number of bytes to allocate
@@ -4899,7 +4899,7 @@ EXPORT_SYMBOL(alloc_pages_exact);
  *
  * Return: pointer to the allocated area or %NULL in case of error.
  */
-void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask)
+void * __meminit alloc_pages_exact_node(int nid, size_t size, gfp_t gfp_mask)
 {
 	unsigned int order = get_order(size);
 	struct page *p;
diff --git a/mm/page_ext.c b/mm/page_ext.c
index d8f1aca4ad43..bca6bb316714 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -215,7 +215,7 @@ static void *__meminit alloc_page_ext(size_t size, int nid)
 	gfp_t flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN;
 	void *addr = NULL;
 
-	addr = alloc_pages_exact_nid(nid, size, flags);
+	addr = alloc_pages_exact_node(nid, size, flags);
 	if (addr) {
 		kmemleak_alloc(addr, size, 1, flags);
 		return addr;
-- 
2.20.1

