Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEF62C0F30
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387982AbgKWPp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:45:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:40042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732217AbgKWPp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 10:45:56 -0500
Received: from lore-desk.lan (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19CE82080A;
        Mon, 23 Nov 2020 15:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606146356;
        bh=L/JKXz2fU4vJmdQoWJr+NYk8h6atKe7wWp/ZahW7Zsc=;
        h=From:To:Cc:Subject:Date:From;
        b=DhsztxuevtTflGvwexXn0KXF9POPC02BT/xakQczCa8KiXWIKy/C+brpxzZOlVcdT
         v8Qgzqzx+ZVfKJgKsKR6WKl0R5renrjz9yHa4Ameo0SCE7CvOq+wCfOqwGH1E9NEi9
         wmkxprTJBKGKMRnFlz+3uAa/5SKKbCAXveF++3uA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, ilias.apalodimas@linaro.org
Subject: [PATCH v2 net-next] net: page_pool: Add page_pool_put_page_bulk() to page_pool.rst
Date:   Mon, 23 Nov 2020 16:45:46 +0100
Message-Id: <a6a5141b4d7b7b71fa7778b16b48f80095dd3233.1606146163.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce page_pool_put_page_bulk() entry into the API section of
page_pool.rst

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- addressed Ilias's comments
---
 Documentation/networking/page_pool.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
index 43088ddf95e4..a147591ce203 100644
--- a/Documentation/networking/page_pool.rst
+++ b/Documentation/networking/page_pool.rst
@@ -97,6 +97,14 @@ a page will cause no race conditions is enough.
 
 * page_pool_get_dma_dir(): Retrieve the stored DMA direction.
 
+* page_pool_put_page_bulk(): Tries to refill a number of pages into the
+  ptr_ring cache holding ptr_ring producer lock. If the ptr_ring is full,
+  page_pool_put_page_bulk() will release leftover pages to the page allocator.
+  page_pool_put_page_bulk() is suitable to be run inside the driver NAPI tx
+  completion loop for the XDP_REDIRECT use case.
+  Please note the caller must not use data area after running
+  page_pool_put_page_bulk(), as this function overwrites it.
+
 Coding examples
 ===============
 
-- 
2.28.0

