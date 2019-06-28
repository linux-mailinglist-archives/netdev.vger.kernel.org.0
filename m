Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71A95988D
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 12:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfF1Kjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 06:39:45 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54810 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfF1Kjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 06:39:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id g135so8608907wme.4
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 03:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z2LIGKls7zdQKVPI0zcAfuwyrWIatXu4izZ3CIRS768=;
        b=ThtdY1gMwIWKDilrAXPEQGalbzSd02mtPgySi4oQdsY/HA7cZZ1MBNrqy6R2qwBveU
         qSte4MffImE1J7k6TAtUfisiGZ2wsc+b909DlluOgBmjl7d/YFLhMZvS6vMZ/N3GuerU
         f2Vpt7NBrIx86p6AoQqMzqSh4sLKzBAiAdNNcYdG8kry0fT03dltvba3mZ08xr5B+she
         t8v9b8+EIuvdTd+v5sVkgFGWoEzqfNupG8eL+TsUNY/G79TOOczmxt3nPN1khe+ljRLE
         UjmuTgzLu7almDIeAhVX3wWUxKZPPaP7bucyVyTfWJS6HTzn5ks9XKY8Xc5gor4nri/U
         +F+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Z2LIGKls7zdQKVPI0zcAfuwyrWIatXu4izZ3CIRS768=;
        b=JrItgC7x5bHVTQtwqHr4Anv7QpwltmzVf3uK6r9MStnpUm2UHaXuDLgzkzD/R2fwk1
         6uMAFGSCwJOiRWK6I/S763KOsj0jWaK1uQTebfEBl0zUPbY1OoeqtO8TbrgJ2aXKDUrh
         K6HARr8Jbb3/SWqp8gw1vrAkAkedF1q1jtHF3o9QMGJNE52uxjEx1PzLstPjOMt2Wuta
         xlhE4X3Xi7GZIwUVMAO3fI8mfyx/GCmjiF45TJ/dSzlnS7hBX57paDzYk6xpaguyJoon
         2zks5kDmSigEuFZUZjBgyaWBm3pqENL41iwmZPhQS4OpSMXgDw2zYaTnCX7Dq2rEA2Kq
         ymwA==
X-Gm-Message-State: APjAAAXFdThNYLaMHxF8lcpJAtdUR2nsmkj4Fh1+1EFJsxLhVNjXQZ23
        VtkXY18dJxXZNmJAVMN5F+UvaJz4170=
X-Google-Smtp-Source: APXvYqxo44vp7uSFY/E/c4zAYnMLU+K8e7IYRfqrcJO3RbEDxzC1SAPle2zm3VWk9tlY9dgUOWFzOw==
X-Received: by 2002:a1c:99ca:: with SMTP id b193mr6645469wme.31.1561718381500;
        Fri, 28 Jun 2019 03:39:41 -0700 (PDT)
Received: from apalos.lan (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id r5sm3397742wrg.10.2019.06.28.03.39.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 28 Jun 2019 03:39:40 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org
Cc:     ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, maciejromanfijalkowski@gmail.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH 2/3, net-next] net: page_pool: add helper function for retrieving dma direction
Date:   Fri, 28 Jun 2019 13:39:14 +0300
Message-Id: <1561718355-13919-3-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561718355-13919-1-git-send-email-ilias.apalodimas@linaro.org>
References: <1561718355-13919-1-git-send-email-ilias.apalodimas@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the dma direction is stored in page pool params, offer an API
helper for driver that choose not to keep track of it locally

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 include/net/page_pool.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index f07c518ef8a5..ee9c871d2043 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -112,6 +112,15 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
 	return page_pool_alloc_pages(pool, gfp);
 }
 
+/* get the stored dma direction. A driver might decide to treat this locally and
+ * avoid the extra cache line from page_pool to determine the direction
+ */
+static
+inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
+{
+	return pool->p.dma_dir;
+}
+
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 
 void __page_pool_free(struct page_pool *pool);
-- 
2.20.1

