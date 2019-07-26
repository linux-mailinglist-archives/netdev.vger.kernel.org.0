Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 141A976B46
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 16:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfGZOP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 10:15:59 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2780 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727119AbfGZOP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 10:15:59 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9E5277926D7979379D45;
        Fri, 26 Jul 2019 22:15:54 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 26 Jul 2019
 22:15:47 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <arend.vanspriel@broadcom.com>,
        <franky.lin@broadcom.com>, <hante.meuleman@broadcom.com>,
        <chi-hsien.lin@cypress.com>, <wright.feng@cypress.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] brcmsmac: remove three set but not used variables
Date:   Fri, 26 Jul 2019 22:15:35 +0800
Message-ID: <20190726141535.33212-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c: In function 'brcms_c_set_gmode':
drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:5257:7: warning: variable 'preamble_restrict' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:5256:6: warning: variable 'preamble' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:5251:7: warning: variable 'shortslot_restrict' set but not used [-Wunused-but-set-variable]

They are never used so can be removed.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index 7d4e8f5..080e829 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -5248,15 +5248,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 	/* Default to 54g Auto */
 	/* Advertise and use shortslot (-1/0/1 Auto/Off/On) */
 	s8 shortslot = BRCMS_SHORTSLOT_AUTO;
-	bool shortslot_restrict = false; /* Restrict association to stations
-					  * that support shortslot
-					  */
 	bool ofdm_basic = false;	/* Make 6, 12, and 24 basic rates */
-	/* Advertise and use short preambles (-1/0/1 Auto/Off/On) */
-	int preamble = BRCMS_PLCP_LONG;
-	bool preamble_restrict = false;	/* Restrict association to stations
-					 * that support short preambles
-					 */
 	struct brcms_band *band;
 
 	/* if N-support is enabled, allow Gmode set as long as requested
@@ -5297,16 +5289,11 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 
 	case GMODE_ONLY:
 		ofdm_basic = true;
-		preamble = BRCMS_PLCP_SHORT;
-		preamble_restrict = true;
 		break;
 
 	case GMODE_PERFORMANCE:
 		shortslot = BRCMS_SHORTSLOT_ON;
-		shortslot_restrict = true;
 		ofdm_basic = true;
-		preamble = BRCMS_PLCP_SHORT;
-		preamble_restrict = true;
 		break;
 
 	default:
-- 
2.7.4


