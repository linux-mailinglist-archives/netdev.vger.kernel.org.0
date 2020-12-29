Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CFF2E7124
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 14:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgL2NxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 08:53:10 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9948 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgL2NxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 08:53:07 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4D4wnZ32Bfzhysl;
        Tue, 29 Dec 2020 21:51:46 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 29 Dec 2020 21:52:14 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <dchickles@marvell.com>, <sburla@marvell.com>,
        <fmanlunas@marvell.com>, Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] liquidio: Use kzalloc for allocating only one thing
Date:   Tue, 29 Dec 2020 21:52:54 +0800
Message-ID: <20201229135254.24032-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kzalloc rather than kcalloc(1,...)

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

- kcalloc(1,
+ kzalloc(
          ...)
// </smpl>

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/cavium/liquidio/lio_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
index 9ef172976b35..e90e3f87ee34 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
@@ -1168,7 +1168,7 @@ int octeon_setup_interrupt(struct octeon_device *oct, u32 num_ioqs)
 			oct->flags |= LIO_FLAG_MSI_ENABLED;
 
 		/* allocate storage for the names assigned to the irq */
-		oct->irq_name_storage = kcalloc(1, INTRNAMSIZ, GFP_KERNEL);
+		oct->irq_name_storage = kzalloc(INTRNAMSIZ, GFP_KERNEL);
 		if (!oct->irq_name_storage)
 			return -ENOMEM;
 
-- 
2.22.0

