Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D36CAA7971
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 05:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbfIDDtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 23:49:32 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55796 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726770AbfIDDtb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 23:49:31 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3D56E88059C5BEA2F350;
        Wed,  4 Sep 2019 11:49:30 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 11:49:21 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <davem@davemloft.net>, <kvalo@codeaurora.org>, <pkshih@realtek.com>
CC:     <zhongjiang@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] ath10k: Drop unnecessary continue in ath10k_mac_update_vif_chan
Date:   Wed, 4 Sep 2019 11:46:24 +0800
Message-ID: <1567568784-9669-4-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1567568784-9669-1-git-send-email-zhongjiang@huawei.com>
References: <1567568784-9669-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Continue is not needed at the bottom of a loop. Hence just remove it.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 12dad65..91e4635 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7804,11 +7804,9 @@ static int ath10k_ampdu_action(struct ieee80211_hw *hw,
 			continue;
 
 		ret = ath10k_wmi_vdev_down(ar, arvif->vdev_id);
-		if (ret) {
+		if (ret)
 			ath10k_warn(ar, "failed to down vdev %d: %d\n",
 				    arvif->vdev_id, ret);
-			continue;
-		}
 	}
 
 	/* All relevant vdevs are downed and associated channel resources
-- 
1.7.12.4

