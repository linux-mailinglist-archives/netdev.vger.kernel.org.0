Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E54444FCA5
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 02:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhKOBFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 20:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhKOBFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 20:05:30 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE90C061746;
        Sun, 14 Nov 2021 17:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=WeNbxja0OhejTMEGDvLLe1l2htp0FefC5ZSLtaQqn7k=; b=rTtGvnWcoYQAbpCxgZ9GAvwrdF
        Y3b4R4VmrPAwcnoS77rmtFEwKWSOx9SKGc0qIJujmJI3tmUkSmWWmAbrWpkOjTYCQR4fCMl6+t7O0
        9AlgsOrfgSbcV7lu3l8AXyyjG4eWN9g3D/sd/cktW80QjqgS7YGvdK1NADxWfGz95psaw+Lieal9Q
        +vkW3F/C3oRslSuHP1lxHvjqGQvjxjkji5/OPOWvNIPE8KzXbJArOhkuEK3LFVAHyFAZ971T1zx03
        I0YHYlQIoIH2h4jef2OeSKHv+KCbOhLiSVtcRqgliGTbl2Hg5jhvx0C10/FYy5nNUEOIQSqJlItnP
        e3SdTghw==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmQOE-00ECQy-Of; Mon, 15 Nov 2021 01:02:30 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>, linux-mips@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Opdenacker <michael.opdenacker@bootlin.com>
Subject: [PATCH -net] net: ethernet: lantiq_etop: fix build errors/warnings
Date:   Sun, 14 Nov 2021 17:02:29 -0800
Message-Id: <20211115010229.15933-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build error and warnings reported by kernel test robot:

drivers/net/ethernet/lantiq_etop.c: In function 'ltq_etop_probe':
drivers/net/ethernet/lantiq_etop.c:673:15: error: implicit declaration of function 'device_property_read_u32' [-Werror=implicit-function-declaration]
     673 |         err = device_property_read_u32(&pdev->dev, "lantiq,tx-burst-length", &priv->tx_burst_len);

   drivers/net/ethernet/lantiq_etop.c: At top level:
   drivers/net/ethernet/lantiq_etop.c:730:1: warning: no previous prototype for 'init_ltq_etop' [-Wmissing-prototypes]
     730 | init_ltq_etop(void)

   drivers/net/ethernet/lantiq_etop.c: In function 'ltq_etop_hw_init':
   drivers/net/ethernet/lantiq_etop.c:276:25: warning: ignoring return value of 'request_irq' declared with attribute 'warn_unused_result' [-Wunused-result]
     276 |                         request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
   drivers/net/ethernet/lantiq_etop.c:284:25: warning: ignoring return value of 'request_irq' declared with attribute 'warn_unused_result' [-Wunused-result]
     284 |                         request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);


Fixes: 14d4e308e0aa ("net: lantiq: configure the burst length in ethernet drivers")
Fixes: dddb29e42770 ("net: lantiq_etop: remove deprecated IRQF_DISABLED")
Fixes: 504d4721ee8e ("MIPS: Lantiq: Add ethernet driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Link: lore.kernel.org/r/202111090621.yjr9xuVj-lkp@intel.com
To: netdev@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: John Crispin <john@phrozen.org>
Cc: linux-mips@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Michael Opdenacker <michael.opdenacker@bootlin.com>
---
 drivers/net/ethernet/lantiq_etop.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- linux-next-20211112.orig/drivers/net/ethernet/lantiq_etop.c
+++ linux-next-20211112/drivers/net/ethernet/lantiq_etop.c
@@ -25,6 +25,7 @@
 #include <linux/io.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
+#include <linux/property.h>
 
 #include <asm/checksum.h>
 
@@ -239,6 +240,7 @@ ltq_etop_hw_init(struct net_device *dev)
 {
 	struct ltq_etop_priv *priv = netdev_priv(dev);
 	int i;
+	int err;
 
 	ltq_pmu_enable(PMU_PPE);
 
@@ -273,7 +275,13 @@ ltq_etop_hw_init(struct net_device *dev)
 
 		if (IS_TX(i)) {
 			ltq_dma_alloc_tx(&ch->dma);
-			request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
+			err = request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
+			if (err) {
+				netdev_err(dev,
+					   "Unable to get Tx DMA IRQ %d\n",
+					   irq);
+				return err;
+			}
 		} else if (IS_RX(i)) {
 			ltq_dma_alloc_rx(&ch->dma);
 			for (ch->dma.desc = 0; ch->dma.desc < LTQ_DESC_NUM;
@@ -281,7 +289,13 @@ ltq_etop_hw_init(struct net_device *dev)
 				if (ltq_etop_alloc_skb(ch))
 					return -ENOMEM;
 			ch->dma.desc = 0;
-			request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);
+			err = request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);
+			if (err) {
+				netdev_err(dev,
+					   "Unable to get Rx DMA IRQ %d\n",
+					   irq);
+				return err;
+			}
 		}
 		ch->dma.irq = irq;
 	}
@@ -726,7 +740,7 @@ static struct platform_driver ltq_mii_dr
 	},
 };
 
-int __init
+static int __init
 init_ltq_etop(void)
 {
 	int ret = platform_driver_probe(&ltq_mii_driver, ltq_etop_probe);
