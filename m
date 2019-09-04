Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFC93A7CF5
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 09:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbfIDHo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 03:44:26 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6201 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbfIDHo0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 03:44:26 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D60405E7619FEC6AE1FE;
        Wed,  4 Sep 2019 15:44:20 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 15:44:13 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>
CC:     <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <zhongjiang@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ath10k: Use ARRAY_SIZE instead of dividing sizeof array with sizeof an element
Date:   Wed, 4 Sep 2019 15:41:18 +0800
Message-ID: <1567582878-18739-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the help of Coccinelle, ARRAY_SIZE can be replaced in ath10k_snoc_wlan_enable.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index b491361..49fc044 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -976,8 +976,7 @@ static int ath10k_snoc_wlan_enable(struct ath10k *ar,
 				  sizeof(struct ath10k_svc_pipe_cfg);
 	cfg.ce_svc_cfg = (struct ath10k_svc_pipe_cfg *)
 		&target_service_to_ce_map_wlan;
-	cfg.num_shadow_reg_cfg = sizeof(target_shadow_reg_cfg_map) /
-					sizeof(struct ath10k_shadow_reg_cfg);
+	cfg.num_shadow_reg_cfg = ARRAY_SIZE(target_shadow_reg_cfg_map);
 	cfg.shadow_reg_cfg = (struct ath10k_shadow_reg_cfg *)
 		&target_shadow_reg_cfg_map;
 
-- 
1.7.12.4

