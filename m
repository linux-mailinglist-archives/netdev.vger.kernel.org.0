Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8791C383A
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 13:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgEDLec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 07:34:32 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56308 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726756AbgEDLec (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 07:34:32 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D845BA2CDDE5F054BD5C;
        Mon,  4 May 2020 19:34:30 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Mon, 4 May 2020
 19:34:24 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] brcmfmac: remove Comparison to bool in brcmf_p2p_send_action_frame()
Date:   Mon, 4 May 2020 19:33:46 +0800
Message-ID: <20200504113346.41342-1-yanaijie@huawei.com>
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

drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:1781:9-12:
WARNING: Comparison to bool
drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:1785:5-8:
WARNING: Comparison to bool

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 1f5deea5a288..16b193d13a2f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -1777,12 +1777,11 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 	}
 
 	tx_retry = 0;
-	while (!p2p->block_gon_req_tx &&
-	       (ack == false) && (tx_retry < P2P_AF_TX_MAX_RETRY)) {
+	while (!p2p->block_gon_req_tx && !ack && (tx_retry < P2P_AF_TX_MAX_RETRY)) {
 		ack = !brcmf_p2p_tx_action_frame(p2p, af_params);
 		tx_retry++;
 	}
-	if (ack == false) {
+	if (!ack) {
 		bphy_err(drvr, "Failed to send Action Frame(retry %d)\n",
 			 tx_retry);
 		clear_bit(BRCMF_P2P_STATUS_GO_NEG_PHASE, &p2p->status);
-- 
2.21.1

