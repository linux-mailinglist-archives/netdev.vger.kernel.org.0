Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F9B687366
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 03:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbjBBCoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 21:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBBCob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 21:44:31 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BE1721EC;
        Wed,  1 Feb 2023 18:44:30 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id j5so603359pjn.5;
        Wed, 01 Feb 2023 18:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ad7E4zcuCwEi9YDNkpi3oiEZWDkrHWJs+CbfdiDfUzI=;
        b=lF3niGhhw+bH+a870i/N7AtwCmvAEjiZSDjkO+ROIg1rZ5aodkZkd+V4lNPUX2WRYZ
         tuS7+CCgMlwcDrJxSQjV4s5iM6m5m58mBxAouAE7TbCp6DjVjEMjheWAdw3KJMWKWEEc
         TnlBqDsQxCk/jMVc9W+Bn4WhGAMRdYus4h+TW+LLrA+IVqBefJJ5OcQM8JtZs6p1qYjv
         6eFGdFcj2OmrWzSWPqULA/n0lalPd7xMNNCgKbia7pD6SjHh/spwpTL+EGOy9wWXeWcr
         ypkBikJ9TVzsQD8hlUNk1VK1EYJ56UKACUKuUOrnthZeol2UG5iGUrSDH6UECtRDQDB1
         p4jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ad7E4zcuCwEi9YDNkpi3oiEZWDkrHWJs+CbfdiDfUzI=;
        b=Z8876Sd0lxX1hymKzvPRNu3QeksHh/XOGo/XUv18+NewrkRaJFyMtHuA8HC1jfKe8+
         lzF8gcA0VWI15WGC1Y3oqRKDPDtAM9lba6jesqVyyT/Oggx+4bK/ZcZ8S9OBSIhvrZOQ
         DGVF3meiCgN+DTapx7H1R3kK6SMfPyLiTwZsW5xMmyyy+dAPMVMgoaJZg6cqhKuI0Tgi
         VkDWaeg7pGTu38NDH9i0ScID+2NL5YRDE/iGc/dkMfu761m2Y7X+6atfD7zpssGqJec1
         +/UqgVgPkhXQ5YTkgJPlFQ8ydfhv7k+EhzOAJEXha+lqvforgVHkCW7FOqw6sJan9LM0
         VuBw==
X-Gm-Message-State: AO0yUKXcjHDwRYN/cKbAUv+FeCubm5E0434UDGoiLsRCElrzmvFEX5RZ
        oovYL6UPyFaqBT3qUCpq68w=
X-Google-Smtp-Source: AK7set8s31zsPm0jFTIRf8DCQ+cbum/g32/fLwUPY7PuK8v3ADCDXfGOv91eYWM+G0PYQP4jKz8HYw==
X-Received: by 2002:a17:903:234f:b0:196:11ae:95f6 with SMTP id c15-20020a170903234f00b0019611ae95f6mr6767890plh.21.1675305870251;
        Wed, 01 Feb 2023 18:44:30 -0800 (PST)
Received: from localhost.localdomain ([2001:470:f2c0:1000::53])
        by smtp.gmail.com with ESMTPSA id x4-20020a170902ea8400b00194c90ca320sm12479213plb.204.2023.02.01.18.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 18:44:29 -0800 (PST)
From:   Qingfang DENG <dqfext@gmail.com>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: page_pool: use in_softirq() instead
Date:   Thu,  2 Feb 2023 10:44:17 +0800
Message-Id: <20230202024417.4477-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qingfang DENG <qingfang.deng@siflower.com.cn>

We use BH context only for synchronization, so we don't care if it's
actually serving softirq or not.

As a side node, in case of threaded NAPI, in_serving_softirq() will
return false because it's in process context with BH off, making
page_pool_recycle_in_cache() unreachable.

Signed-off-by: Qingfang DENG <qingfang.deng@siflower.com.cn>
Fixes: 7886244736a4 ("net: page_pool: Add bulk support for ptr_ring")
Fixes: ff7d6b27f894 ("page_pool: refurbish version of page_pool code")
---
 include/net/page_pool.h | 4 ++--
 net/core/page_pool.c    | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 813c93499f20..34bf531ffc8d 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -386,7 +386,7 @@ static inline void page_pool_nid_changed(struct page_pool *pool, int new_nid)
 static inline void page_pool_ring_lock(struct page_pool *pool)
 	__acquires(&pool->ring.producer_lock)
 {
-	if (in_serving_softirq())
+	if (in_softirq())
 		spin_lock(&pool->ring.producer_lock);
 	else
 		spin_lock_bh(&pool->ring.producer_lock);
@@ -395,7 +395,7 @@ static inline void page_pool_ring_lock(struct page_pool *pool)
 static inline void page_pool_ring_unlock(struct page_pool *pool)
 	__releases(&pool->ring.producer_lock)
 {
-	if (in_serving_softirq())
+	if (in_softirq())
 		spin_unlock(&pool->ring.producer_lock);
 	else
 		spin_unlock_bh(&pool->ring.producer_lock);
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9b203d8660e4..193c18799865 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -511,8 +511,8 @@ static void page_pool_return_page(struct page_pool *pool, struct page *page)
 static bool page_pool_recycle_in_ring(struct page_pool *pool, struct page *page)
 {
 	int ret;
-	/* BH protection not needed if current is serving softirq */
-	if (in_serving_softirq())
+	/* BH protection not needed if current is softirq */
+	if (in_softirq())
 		ret = ptr_ring_produce(&pool->ring, page);
 	else
 		ret = ptr_ring_produce_bh(&pool->ring, page);
@@ -570,7 +570,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
 			page_pool_dma_sync_for_device(pool, page,
 						      dma_sync_size);
 
-		if (allow_direct && in_serving_softirq() &&
+		if (allow_direct && in_softirq() &&
 		    page_pool_recycle_in_cache(page, pool))
 			return NULL;
 
-- 
2.34.1

