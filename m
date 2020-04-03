Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D47E419D24D
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 10:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389015AbgDCIew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 04:34:52 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:36952 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727144AbgDCIew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Apr 2020 04:34:52 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DB458F1D4A41C44B3DD2;
        Fri,  3 Apr 2020 16:34:46 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Fri, 3 Apr 2020
 16:34:36 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <pradeepc@codeaurora.org>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] ath11k: thermal: Fix build error without CONFIG_THERMAL
Date:   Fri, 3 Apr 2020 16:34:14 +0800
Message-ID: <20200403083414.31392-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/wireless/ath/ath11k/thermal.h:45:1:
 warning: no return statement in function returning non-void [-Wreturn-type]
drivers/net/wireless/ath/ath11k/core.c:416:28: error:
 passing argument 1 of ‘ath11k_thermal_unregister’ from incompatible pointer type [-Werror=incompatible-pointer-types]

Add missing return 0 in ath11k_thermal_set_throttling,
and fix ath11k_thermal_unregister param type.

Fixes: 2a63bbca06b2 ("ath11k: add thermal cooling device support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath11k/thermal.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/thermal.h b/drivers/net/wireless/ath/ath11k/thermal.h
index 459b8d49c184..f9af55f3682d 100644
--- a/drivers/net/wireless/ath/ath11k/thermal.h
+++ b/drivers/net/wireless/ath/ath11k/thermal.h
@@ -36,12 +36,13 @@ static inline int ath11k_thermal_register(struct ath11k_base *sc)
 	return 0;
 }
 
-static inline void ath11k_thermal_unregister(struct ath11k *ar)
+static inline void ath11k_thermal_unregister(struct ath11k_base *sc)
 {
 }
 
 static inline int ath11k_thermal_set_throttling(struct ath11k *ar, u32 throttle_state)
 {
+	return 0;
 }
 
 static inline void ath11k_thermal_event_temperature(struct ath11k *ar,
-- 
2.17.1


