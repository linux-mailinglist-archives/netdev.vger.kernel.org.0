Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1031C382C
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 13:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgEDLdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 07:33:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56686 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728655AbgEDLdt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 07:33:49 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9C7ADFC07102EA98B7C6;
        Mon,  4 May 2020 19:33:46 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Mon, 4 May 2020
 19:33:37 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <tglx@linutronix.de>, <linux-wireless@vger.kernel.org>,
        <b43-dev@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] b43: remove Comparison of 0/1 to bool variable in phy_n.c
Date:   Mon, 4 May 2020 19:33:00 +0800
Message-ID: <20200504113300.40895-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/wireless/broadcom/b43/phy_n.c:5510:19-32: WARNING:
Comparison of 0/1 to bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/broadcom/b43/phy_n.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index d3c001fa8eb4..c33b4235839d 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -5507,7 +5507,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 			core = (cmd & 0x3000) >> 12;
 			type = (cmd & 0x0F00) >> 8;
 
-			if (phy6or5x && updated[core] == 0) {
+			if (phy6or5x && !updated[core]) {
 				b43_nphy_update_tx_cal_ladder(dev, core);
 				updated[core] = true;
 			}
-- 
2.21.1

