Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D5E67E157
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 11:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjA0KRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 05:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbjA0KRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 05:17:06 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B57210273
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 02:16:53 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ud5so12399968ejc.4
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 02:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4tXAzYx6U2zYvFQaL0R9LDwvLsVYQ0QOtKqWLpi2ZpY=;
        b=taG/DcTLzWRqxJ67PXr4isASG3VtleUdmICNBQ5dB1fbIhAkjeAPCLn+pedlUYRyev
         /9S1EfpKEjergkzhAObSRpDaXifNzAc0T8m+T2Oq1JLTCHVW7q+72ux1tw5QyS3Sa1Dj
         2SwMPsCzm2m9dcz/2cewiYM7u963IUZ9GJLJOARXogBnRFibHfbUjmVwMcs/SyRq3CZV
         /2uBkkkSizbILaPWBNQtp6DukBX+gifschimBTyLeYF/iAn13U7k4rcDaL5T+Ce6wHkz
         R/9VMf0Bj78oDfA2NjI8MA+M2PhanmuYxQTd1R+JN9mCALbMw7XUWbBmRZIAHT2SqL0B
         iakg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4tXAzYx6U2zYvFQaL0R9LDwvLsVYQ0QOtKqWLpi2ZpY=;
        b=QPxEKMgjWW2x2LPh9MMVv4RaqYozwIrEERWdyuFf4KuPYKNLcvBfJN0pvNZzCk6elT
         4BSrzWaqHYjY/MS+D4xAbLCWaeKKHJbuAnyU2Kz+faKoMg0TUxqWH3RC0vkQ8Z54Sg3B
         zVgvN4gwExazNh0vasaonohdiep21GQCAGhLjesDzA/tT7zSKGqYIfKJQSp+Kxfz/ml6
         peCqSk2JcU3OAy2GgqpHkTkWbQu/9A8iAF3bjp4IE+xxFh7sJZ+I2KytVt7kWqA4ok6x
         tQ+rhUOHAKrO7ceC/Nm79QvlFfX6avg2IJetR3OnhL8m5D4CM5pWxB9Y6HBXUClX2Qkd
         nXnA==
X-Gm-Message-State: AFqh2koNmmGXQ8vucGkeDvL/VwgErJQu4xGTs/TUZsIGh5av+uTcQRtN
        R/k/nZy4kCISeHtYL7LleItulGtzsodkiu+b
X-Google-Smtp-Source: AMrXdXuf8yj5DMQWmDiZ3HjEhnlQNd5W99OizjfxqoE+pwicLOIdI76Ept81fwYgmd8WT3KUtWAZMQ==
X-Received: by 2002:a17:907:8999:b0:877:83ea:2bfc with SMTP id rr25-20020a170907899900b0087783ea2bfcmr31382892ejc.39.1674814612066;
        Fri, 27 Jan 2023 02:16:52 -0800 (PST)
Received: from localhost.localdomain ([2a02:85f:fc9d:e4b5:fb9c:6b1a:cf38:9393])
        by smtp.gmail.com with ESMTPSA id h16-20020a50ed90000000b0049ef04ad502sm2073718edr.40.2023.01.27.02.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 02:16:51 -0800 (PST)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org
Cc:     alexander.duyck@gmail.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] page_pool: add a comment explaining the fragment counter usage
Date:   Fri, 27 Jan 2023 12:16:27 +0200
Message-Id: <20230127101627.891614-1-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When reading the page_pool code the first impression is that keeping
two separate counters, one being the page refcnt and the other being
fragment pp_frag_count, is counter-intuitive.

However without that fragment counter we don't know when to reliably
destroy or sync the outstanding DMA mappings.  So let's add a comment
explaining this part.

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 include/net/page_pool.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 813c93499f20..115dbce6d431 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -277,6 +277,14 @@ void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
 				  unsigned int dma_sync_size,
 				  bool allow_direct);
 
+/* pp_frag_count is our number of outstanding DMA maps.  We can't rely on the
+ * page refcnt for that as we don't know who might be holding page references
+ * and we can't reliably destroy or sync DMA mappings of the fragments.
+ *
+ * When pp_frag_count reaches 0 we can either recycle the page, if the page
+ * refcnt is 1, or return it back to the memory allocator and destroy any
+ * mappings we have.
+ */
 static inline void page_pool_fragment_page(struct page *page, long nr)
 {
 	atomic_long_set(&page->pp_frag_count, nr);
-- 
2.38.1

