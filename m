Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 778C21A4441
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 11:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgDJJJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 05:09:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12639 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725897AbgDJJJy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 05:09:54 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 58F9DD4A46EC7164605F;
        Fri, 10 Apr 2020 17:09:53 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Fri, 10 Apr 2020
 17:09:44 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <eduardoabinader@gmail.com>,
        <christophe.jaillet@wanadoo.fr>, <yanaijie@huawei.com>,
        <austindh.kim@gmail.com>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] brcmsmac: make brcms_c_set_mac() void
Date:   Fri, 10 Apr 2020 17:08:17 +0800
Message-ID: <20200410090817.26883-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:3773:5-8:
Unneeded variable: "err". Return "0" on line 3781

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index 7f2c15c799d2..d88f8d456b94 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -3768,17 +3768,14 @@ static void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
  * Write this BSS config's MAC address to core.
  * Updates RXE match engine.
  */
-static int brcms_c_set_mac(struct brcms_bss_cfg *bsscfg)
+static void brcms_c_set_mac(struct brcms_bss_cfg *bsscfg)
 {
-	int err = 0;
 	struct brcms_c_info *wlc = bsscfg->wlc;
 
 	/* enter the MAC addr into the RXE match registers */
 	brcms_c_set_addrmatch(wlc, RCM_MAC_OFFSET, wlc->pub->cur_etheraddr);
 
 	brcms_c_ampdu_macaddr_upd(wlc);
-
-	return err;
 }
 
 /* Write the BSS config's BSSID address to core (set_bssid in d11procs.tcl).
-- 
2.17.2

