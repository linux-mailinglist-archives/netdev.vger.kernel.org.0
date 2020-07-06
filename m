Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31052215661
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 13:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgGFL2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 07:28:04 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7375 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728764AbgGFL16 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 07:27:58 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 684E25AD4DF7AE0F84F7;
        Mon,  6 Jul 2020 19:27:55 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Mon, 6 Jul 2020 19:27:47 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 3/4] net: hns3: add a missing uninit debugfs when unload driver
Date:   Mon, 6 Jul 2020 19:26:01 +0800
Message-ID: <1594034762-6445-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594034762-6445-1-git-send-email-tanhuazhong@huawei.com>
References: <1594034762-6445-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When unloading driver, if flag HNS3_NIC_STATE_INITED has been
already cleared, the debugfs will not be uninitialized, so fix it.

Fixes: b2292360bb2a ("net: hns3: Add debugfs framework registration")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index b319a76..fe7d57ae 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4140,9 +4140,8 @@ static void hns3_client_uninit(struct hnae3_handle *handle, bool reset)
 
 	hns3_put_ring_config(priv);
 
-	hns3_dbg_uninit(handle);
-
 out_netdev_free:
+	hns3_dbg_uninit(handle);
 	free_netdev(netdev);
 }
 
-- 
2.7.4

