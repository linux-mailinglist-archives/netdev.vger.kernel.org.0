Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACA01B8E63
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 11:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgDZJlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 05:41:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2907 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726200AbgDZJlS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 05:41:18 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1358B4089967D5603955;
        Sun, 26 Apr 2020 17:41:16 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Sun, 26 Apr 2020
 17:41:09 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <jirislaby@gmail.com>, <mickflemm@gmail.com>, <mcgrof@kernel.org>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] ath5k: remove conversion to bool in ath5k_ani_calibration()
Date:   Sun, 26 Apr 2020 17:40:37 +0800
Message-ID: <20200426094037.23048-1-yanaijie@huawei.com>
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

The '>' expression itself is bool, no need to convert it to bool again.
This fixes the following coccicheck warning:

drivers/net/wireless/ath/ath5k/ani.c:504:56-61: WARNING: conversion to
bool not needed here

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/ath/ath5k/ani.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index 0624333f5430..850c608b43a3 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -501,7 +501,7 @@ ath5k_ani_calibration(struct ath5k_hw *ah)
 
 	if (as->ofdm_errors > ofdm_high || as->cck_errors > cck_high) {
 		/* too many PHY errors - we have to raise immunity */
-		bool ofdm_flag = as->ofdm_errors > ofdm_high ? true : false;
+		bool ofdm_flag = as->ofdm_errors > ofdm_high;
 		ath5k_ani_raise_immunity(ah, as, ofdm_flag);
 		ath5k_ani_period_restart(as);
 
-- 
2.21.1

