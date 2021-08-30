Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEC13FB10C
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 08:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbhH3GLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 02:11:43 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:15229 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbhH3GLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 02:11:34 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Gyg075LPpz1DDx5;
        Mon, 30 Aug 2021 14:09:59 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 30 Aug 2021 14:10:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 30 Aug 2021 14:10:36 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 6/7] net: hnss3: use max() to simplify code
Date:   Mon, 30 Aug 2021 14:06:41 +0800
Message-ID: <1630303602-44870-7-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630303602-44870-1-git-send-email-huangguangbin2@huawei.com>
References: <1630303602-44870-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Replace the "? :" statement wich max() to simplify code.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index ab14beb65aaf..4b8d3b64f567 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -971,8 +971,7 @@ static u32 hns3_tx_spare_space(struct hns3_enet_ring *ring)
 	/* The free tx buffer is divided into two part, so pick the
 	 * larger one.
 	 */
-	return (ntc > (tx_spare->len - ntu) ? ntc :
-			(tx_spare->len - ntu)) - 1;
+	return max(ntc, tx_spare->len - ntu) - 1;
 }
 
 static void hns3_tx_spare_update(struct hns3_enet_ring *ring)
-- 
2.8.1

