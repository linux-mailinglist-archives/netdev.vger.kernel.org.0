Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACEA30BBB1
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 11:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhBBKEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 05:04:22 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:46032 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229542AbhBBKEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 05:04:06 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0UNfeGFu_1612260158;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UNfeGFu_1612260158)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 02 Feb 2021 18:02:51 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ioana.ciornei@nxp.com
Cc:     ruxandra.radulescu@nxp.com, davem@davemloft.net,
        linux@armlinux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] dpaa2-eth: Simplify the calculation of variables
Date:   Tue,  2 Feb 2021 18:02:37 +0800
Message-Id: <1612260157-128026-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:1651:36-38: WARNING
!A || A && B is equivalent to !A || B.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index fb0bcd1..93f84c9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1648,7 +1648,7 @@ void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv,
 	 * CG taildrop threshold, so it won't interfere with it; we also
 	 * want frames in non-PFC enabled traffic classes to be kept in check)
 	 */
-	td.enable = !tx_pause || (tx_pause && pfc);
+	td.enable = !tx_pause || pfc;
 	if (priv->rx_cgtd_enabled == td.enable)
 		return;
 
-- 
1.8.3.1

