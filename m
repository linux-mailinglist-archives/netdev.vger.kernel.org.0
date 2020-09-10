Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99ED264803
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 16:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730309AbgIJObi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 10:31:38 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42562 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731058AbgIJO2o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:28:44 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9B246581FA3E06A0396E;
        Thu, 10 Sep 2020 22:05:33 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 22:05:25 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <lee.jones@linaro.org>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] brcmsmac: main: Eliminate empty brcms_c_down_del_timer()
Date:   Thu, 10 Sep 2020 22:04:46 +0800
Message-ID: <20200910140446.1168049-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function does nothing so remove it. This addresses the following
coccicheck warning:

drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:5103:6-15:
Unneeded variable: "callbacks". Return "0" on line 5105

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index 21691581b532..763e0ec583d7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -5085,13 +5085,6 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	return 0;
 }
 
-static uint brcms_c_down_del_timer(struct brcms_c_info *wlc)
-{
-	uint callbacks = 0;
-
-	return callbacks;
-}
-
 static int brcms_b_bmac_down_prep(struct brcms_hardware *wlc_hw)
 {
 	bool dev_gone;
@@ -5201,8 +5194,6 @@ uint brcms_c_down(struct brcms_c_info *wlc)
 			callbacks++;
 		wlc->WDarmed = false;
 	}
-	/* cancel all other timers */
-	callbacks += brcms_c_down_del_timer(wlc);
 
 	wlc->pub->up = false;
 
-- 
2.25.4

