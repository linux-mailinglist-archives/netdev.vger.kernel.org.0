Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1472E710F
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 14:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgL2NuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 08:50:10 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9656 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgL2NuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 08:50:09 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D4wjw5hcMz15l4N;
        Tue, 29 Dec 2020 21:48:36 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 29 Dec 2020 21:49:15 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <dchickles@marvell.com>, <sburla@marvell.com>,
        <fmanlunas@marvell.com>, Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] cavium/liquidio: Use DEFINE_SPINLOCK() for spinlock
Date:   Tue, 29 Dec 2020 21:49:54 +0800
Message-ID: <20201229134954.23361-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

spinlock can be initialized automatically with DEFINE_SPINLOCK()
rather than explicitly calling spin_lock_init().

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/cavium/liquidio/octeon_device.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_device.c b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
index 387a57cbfb73..e159194d0aef 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
@@ -545,7 +545,7 @@ static atomic_t adapter_fw_states[MAX_OCTEON_DEVICES];
 
 static u32 octeon_device_count;
 /* locks device array (i.e. octeon_device[]) */
-static spinlock_t octeon_devices_lock;
+static DEFINE_SPINLOCK(octeon_devices_lock);
 
 static struct octeon_core_setup core_setup[MAX_OCTEON_DEVICES];
 
@@ -563,7 +563,6 @@ void octeon_init_device_list(int conf_type)
 	memset(octeon_device, 0, (sizeof(void *) * MAX_OCTEON_DEVICES));
 	for (i = 0; i <  MAX_OCTEON_DEVICES; i++)
 		oct_set_config_info(i, conf_type);
-	spin_lock_init(&octeon_devices_lock);
 }
 
 static void *__retrieve_octeon_config_info(struct octeon_device *oct,
-- 
2.22.0

