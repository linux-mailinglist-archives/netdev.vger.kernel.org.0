Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900B1507E72
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 03:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358773AbiDTBuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 21:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348404AbiDTBuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 21:50:14 -0400
Received: from mail.meizu.com (edge07.meizu.com [112.91.151.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991DD3298F;
        Tue, 19 Apr 2022 18:47:28 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail11.meizu.com
 (172.16.1.15) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 20 Apr
 2022 09:47:15 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Wed, 20 Apr
 2022 09:47:13 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     Veerasenareddy Burru <vburru@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     Haowen Bai <baihaowen@meizu.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] octeon_ep: Remove unnecessary cast
Date:   Wed, 20 Apr 2022 09:47:11 +0800
Message-ID: <1650419232-7982-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

./drivers/net/ethernet/marvell/octeon_ep/octep_rx.c:161:18-40: WARNING:
casting value returned by memory allocation function to (struct
octep_rx_buffer *) is useless.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
index 945947ec7723..96768823cced 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
@@ -158,8 +158,7 @@ static int octep_setup_oq(struct octep_device *oct, int q_no)
 		goto desc_dma_alloc_err;
 	}
 
-	oq->buff_info = (struct octep_rx_buffer *)
-			vzalloc(oq->max_count * OCTEP_OQ_RECVBUF_SIZE);
+	oq->buff_info = vzalloc(oq->max_count * OCTEP_OQ_RECVBUF_SIZE);
 	if (unlikely(!oq->buff_info)) {
 		dev_err(&oct->pdev->dev,
 			"Failed to allocate buffer info for OQ-%d\n", q_no);
-- 
2.7.4

