Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1001FEA70
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 04:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfKPDns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 22:43:48 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6681 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727290AbfKPDnr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 22:43:47 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EB98DC47404AEEF3A289;
        Sat, 16 Nov 2019 11:43:44 +0800 (CST)
Received: from localhost.localdomain (10.90.53.225) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Sat, 16 Nov 2019 11:43:39 +0800
From:   Chen Wandun <chenwandun@huawei.com>
To:     <davem@davemloft.net>, <joabreu@synopsys.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <chenwandun@huawei.com>
Subject: [PATCH] net: stmmac: remove variable 'ret' set but not used
Date:   Sat, 16 Nov 2019 11:50:46 +0800
Message-ID: <1573876246-139122-1-git-send-email-chenwandun@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/stmicro/stmmac/stmmac_main.c: In function stmmac_rx_buf1_len:
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3460:6: warning: variable ret set but not used [-Wunused-but-set-variable]

Signed-off-by: Chen Wandun <chenwandun@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 39b4efd..7003a30 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3457,7 +3457,7 @@ static unsigned int stmmac_rx_buf1_len(struct stmmac_priv *priv,
 				       struct dma_desc *p,
 				       int status, unsigned int len)
 {
-	int ret, coe = priv->hw->rx_csum;
+	int coe = priv->hw->rx_csum;
 	unsigned int plen = 0, hlen = 0;
 
 	/* Not first descriptor, buffer is always zero */
@@ -3465,7 +3465,7 @@ static unsigned int stmmac_rx_buf1_len(struct stmmac_priv *priv,
 		return 0;
 
 	/* First descriptor, get split header length */
-	ret = stmmac_get_rx_header_len(priv, p, &hlen);
+	stmmac_get_rx_header_len(priv, p, &hlen);
 	if (priv->sph && hlen) {
 		priv->xstats.rx_split_hdr_pkt_n++;
 		return hlen;
-- 
2.7.4

