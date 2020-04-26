Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EC31B8E68
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 11:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgDZJli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 05:41:38 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3302 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726122AbgDZJli (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 05:41:38 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0231D704CF33F966C3BC;
        Sun, 26 Apr 2020 17:41:37 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Sun, 26 Apr 2020
 17:41:27 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] brcmfmac: remove comparison to bool in brcmf_fws_attach()
Date:   Sun, 26 Apr 2020 17:40:53 +0800
Message-ID: <20200426094053.23132-1-yanaijie@huawei.com>
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

drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c:2359:6-40:
WARNING: Comparison to bool

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 8cc52935fd41..2b7837887c0b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -2356,7 +2356,7 @@ struct brcmf_fws_info *brcmf_fws_attach(struct brcmf_pub *drvr)
 	fws->drvr = drvr;
 	fws->fcmode = drvr->settings->fcmode;
 
-	if ((drvr->bus_if->always_use_fws_queue == false) &&
+	if (!drvr->bus_if->always_use_fws_queue &&
 	    (fws->fcmode == BRCMF_FWS_FCMODE_NONE)) {
 		fws->avoid_queueing = true;
 		brcmf_dbg(INFO, "FWS queueing will be avoided\n");
-- 
2.21.1

