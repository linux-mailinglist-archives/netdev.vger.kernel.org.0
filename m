Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E322A44B696
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 23:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343573AbhKIW2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 17:28:55 -0500
Received: from mx4.wp.pl ([212.77.101.11]:15730 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237259AbhKIW1C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 17:27:02 -0500
Received: (wp-smtpd smtp.wp.pl 3499 invoked from network); 9 Nov 2021 23:24:12 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1636496652; bh=YAuwhktEqpk2WxIRwbfHGA/QwjMzTLJ3Jr/sbfk2x8s=;
          h=From:To:Cc:Subject;
          b=yCGuyRJ8UwABh5ilHCgr4IlZr1sqbuqk5eObJzERzoPq/M3ZDOYNl7BCsgQ64ThPm
           /WoDDQ9yjEw0otTF2sZbcYAmFc7mvZPhKNH/AvQ8U2dmKqu8YEmyA6gpuXMr2i6DG1
           nSBZkwpB9ooIgy7ndZi6ceyGEm6OrhThxl7Wjbhg=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <davem@davemloft.net>; 9 Nov 2021 23:24:12 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     davem@davemloft.net, kuba@kernel.org, olek2@wp.pl, arnd@arndb.de,
        jgg@ziepe.ca, rdunlap@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>
Subject: [PATCH net] net: ethernet: lantiq_etop: Fix compilation error
Date:   Tue,  9 Nov 2021 23:23:54 +0100
Message-Id: <20211109222354.3688-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 03f7aef98eb9ae46a4ae67944484d81f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [sWME]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes the error detected when compiling the driver.

Fixes: 14d4e308e0aa ("net: lantiq: configure the burst length in ethernet drivers")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_etop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 2258e3f19161..6433c909c6b2 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -262,7 +262,7 @@ ltq_etop_hw_init(struct net_device *dev)
 	/* enable crc generation */
 	ltq_etop_w32(PPE32_CGEN, LQ_PPE32_ENET_MAC_CFG);
 
-	ltq_dma_init_port(DMA_PORT_ETOP, priv->tx_burst_len, rx_burst_len);
+	ltq_dma_init_port(DMA_PORT_ETOP, priv->tx_burst_len, priv->rx_burst_len);
 
 	for (i = 0; i < MAX_DMA_CHAN; i++) {
 		int irq = LTQ_DMA_CH0_INT + i;
-- 
2.30.2

