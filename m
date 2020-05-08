Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067601CA560
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 09:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgEHHow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 03:44:52 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4350 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbgEHHov (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 03:44:51 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2B9E19B48087109A6A1F;
        Fri,  8 May 2020 15:44:47 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Fri, 8 May 2020
 15:44:37 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2] brcmfmac: remove Comparison to bool in brcmf_p2p_send_action_frame()
Date:   Fri, 8 May 2020 15:43:51 +0800
Message-ID: <20200508074351.19193-1-yanaijie@huawei.com>
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

drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:1785:5-8:
WARNING: Comparison to bool

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
---
 v2: Rebased on top of wireless-drivers-next and drop one already fixed line.

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index e32c24a2670d..8cde31675dfb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -1836,7 +1836,7 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 		dwell_overflow = brcmf_p2p_check_dwell_overflow(requested_dwell,
 								dwell_jiffies);
 	}
-	if (ack == false) {
+	if (!ack) {
 		bphy_err(drvr, "Failed to send Action Frame(retry %d)\n",
 			 tx_retry);
 		clear_bit(BRCMF_P2P_STATUS_GO_NEG_PHASE, &p2p->status);
-- 
2.21.1

