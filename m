Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4602B2BB8CA
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgKTWTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:19:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgKTWTn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 17:19:43 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 678E42240C;
        Fri, 20 Nov 2020 22:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605910782;
        bh=Di7Cz04BB/E+yUiou1mut0FsoFRKNagyabopREDRbHk=;
        h=From:To:Cc:Subject:Date:From;
        b=hcZRtCRPa+obmfBhQF125uRJya0h5Q6QRoMw+gHSNFlDsoSbUQARWHJfW5vuuPB2V
         BTNNHJONiwnNYDXZKgN3p6z7plyY2hIgk3MplKwk6RDPxD8f1e8VtZyNXvASRxAioG
         MB4iPTyq4c++Lkhqx3ix++BOBCqafX6NouqGtuj4=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, ilias.apalodimas@linaro.org
Subject: [PATCH net-next] net: page_pool: Add page_pool_put_page_bulk() to page_pool.rst
Date:   Fri, 20 Nov 2020 23:19:34 +0100
Message-Id: <937ccc89a82302a06744bcb6d253f0e95651caa2.1605910519.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce page_pool_put_page_bulk() entry into the API section of
page_pool.rst

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 Documentation/networking/page_pool.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
index 43088ddf95e4..e848f5b995b8 100644
--- a/Documentation/networking/page_pool.rst
+++ b/Documentation/networking/page_pool.rst
@@ -97,6 +97,14 @@ a page will cause no race conditions is enough.
 
 * page_pool_get_dma_dir(): Retrieve the stored DMA direction.
 
+* page_pool_put_page_bulk(): It tries to refill a bulk of count pages into the
+  ptr_ring cache holding ptr_ring producer lock. If the ptr_ring is full,
+  page_pool_put_page_bulk() will release leftover pages to the page allocator.
+  page_pool_put_page_bulk() is suitable to be run inside the driver NAPI tx
+  completion loop for the XDP_REDIRECT use case.
+  Please consider the caller must not use data area after running
+  page_pool_put_page_bulk(), as this function overwrites it.
+
 Coding examples
 ===============
 
-- 
2.28.0

