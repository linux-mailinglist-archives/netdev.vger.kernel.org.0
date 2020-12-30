Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677222E76A2
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 07:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgL3GmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 01:42:12 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:55151 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726214AbgL3GmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 01:42:11 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UKCfW9Q_1609310482;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UKCfW9Q_1609310482)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 30 Dec 2020 14:41:28 +0800
From:   YANG LI <abaci-bugfix@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        YANG LI <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] liquidio: fix: warning: %u in format string (no. 3) requires 'unsigned int' but the argument type is 'signed int'.
Date:   Wed, 30 Dec 2020 14:41:20 +0800
Message-Id: <1609310480-80777-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For safety, modify '%u' to '%d' to keep the type consistent.

Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci <abaci@linux.alibaba.com>
---
 drivers/net/ethernet/cavium/liquidio/lio_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
index 37d0641..07846f9 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
@@ -1109,12 +1109,12 @@ int octeon_setup_interrupt(struct octeon_device *oct, u32 num_ioqs)
 		for (i = 0 ; i < num_ioq_vectors ; i++) {
 			if (OCTEON_CN23XX_PF(oct))
 				snprintf(&queue_irq_names[IRQ_NAME_OFF(i)],
-					 INTRNAMSIZ, "LiquidIO%u-pf%u-rxtx-%u",
+					 INTRNAMSIZ, "LiquidIO%u-pf%u-rxtx-%d",
 					 oct->octeon_id, oct->pf_num, i);
 
 			if (OCTEON_CN23XX_VF(oct))
 				snprintf(&queue_irq_names[IRQ_NAME_OFF(i)],
-					 INTRNAMSIZ, "LiquidIO%u-vf%u-rxtx-%u",
+					 INTRNAMSIZ, "LiquidIO%u-vf%u-rxtx-%d",
 					 oct->octeon_id, oct->vf_num, i);
 
 			irqret = request_irq(msix_entries[i].vector,
-- 
1.8.3.1

