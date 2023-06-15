Return-Path: <netdev+bounces-10958-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D74E4730CA4
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 03:37:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 114141C20DC6
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:37:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E16F4390;
	Thu, 15 Jun 2023 01:37:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47F5379
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 01:37:16 +0000 (UTC)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86AB2213B;
	Wed, 14 Jun 2023 18:37:15 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b51414b080so3614725ad.0;
        Wed, 14 Jun 2023 18:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686793035; x=1689385035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QAHlVwchDzCSDi1na7VwQaXHN8g/9M34Sxw9Isp1b08=;
        b=oGu9bdT7H53NknaJ26csiluUNwDuqz6mSKC8Kr7VAWmOjHpgeb0pf4toD1izTF2ckT
         rkC0qWhh+ue4yrfe86USqW+bqcUKeXZC9tbDAc3aDzelIt8YCMbGS9G8rg72z9KKN/+P
         00joOFhQxW2oZVZ/5wHmx/6QI7ICVA6/uXX8uRI4LTRTtL0cbMoVEyaGLRX2AG5EXK0Y
         Hsi+LBgxcrdi6c1awal6vX3Un3rW5YsV/t7/rZHWLmUnsbUM+L2TjO2963fvDeAybi90
         yANIT0f+8PUH/gQcD0pgM9Cvw2SO73kTcUnJmT2VC8ExDgeUlOOrFTHWiddilaWJrNNd
         xgRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686793035; x=1689385035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QAHlVwchDzCSDi1na7VwQaXHN8g/9M34Sxw9Isp1b08=;
        b=VgmmCcovxdom9aV7Zo4p7aI2YsZ8Epw8zVYqueCGy7vyyHd4hdi25TMMVFUv7w2uzr
         znHq2/+UA84O+N4Zla9kN/284j5dhHZLGkrMEQrrEGRnIpCqGPzNXGBoDmLerEGlrQkB
         e151HD15GVOmh7b/lllnOHLvMB44yL0fuk8/dsB82PAO94J6HqqN+Rdi07Ii+M+bLP8k
         jCHtn5iN+T+y+6Aqxcq40M6mpflXeQE/oyVNZU7Zdv9Y+obUTWM5y7RB7M8IQkzEhnh/
         yvh7ZvD3HicaypWOc6yOXe1r1c+D9fcUhi+CQ9uHb7IhwHV/kPcK1o10jzyMHi3WCWQB
         61Cg==
X-Gm-Message-State: AC+VfDx2Vzj1OXxAV4YZFGX76VmNtMtdLbP6jop/ydihBXwz74t5ohX1
	de8xjSqlELrseqRa+7w9hug=
X-Google-Smtp-Source: ACHHUZ7J5FXwwzIgavyXR+S8pLnBV6G6eqg/WJa43AvMrLm/QVByBUFsOk/MNSMJCiP5vjsuefATVA==
X-Received: by 2002:a17:902:d2c7:b0:1af:9c06:22e5 with SMTP id n7-20020a170902d2c700b001af9c0622e5mr15382955plc.69.1686793034899;
        Wed, 14 Jun 2023 18:37:14 -0700 (PDT)
Received: from localhost.localdomain ([38.145.203.66])
        by smtp.gmail.com with ESMTPSA id c1-20020a170902724100b001ab2b4105ddsm7375943pll.60.2023.06.14.18.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 18:37:13 -0700 (PDT)
From: Liang Chen <liangchen.linux@gmail.com>
To: hawk@kernel.org,
	ilias.apalodimas@linaro.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	Liang Chen <liangchen.linux@gmail.com>
Subject: [PATCH net-next] page pool: not return page to alloc cache during pool destruction
Date: Thu, 15 Jun 2023 09:36:45 +0800
Message-Id: <20230615013645.7297-1-liangchen.linux@gmail.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When destroying a page pool, the alloc cache and recycle ring are emptied.
If there are inflight pages, the retry process will periodically check the
recycle ring for recently returned pages, but not the alloc cache (alloc
cache is only emptied once). As a result, any pages returned to the alloc
cache after the page pool destruction will be stuck there and cause the
retry process to continuously look for inflight pages and report warnings.

To safeguard against this situation, any pages returning to the alloc cache
after pool destruction should be prevented.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 net/core/page_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index a3e12a61d456..76255313d349 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -595,7 +595,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
 			page_pool_dma_sync_for_device(pool, page,
 						      dma_sync_size);
 
-		if (allow_direct && in_softirq() &&
+		if (allow_direct && in_softirq() && !pool->destroy_cnt &&
 		    page_pool_recycle_in_cache(page, pool))
 			return NULL;
 
-- 
2.31.1


