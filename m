Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B11A1B142C
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgDTSQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:16:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:5644 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgDTSQ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 14:16:58 -0400
IronPort-SDR: dJd3xpE3/Wjee3E2dNVxhnv13PFFZrXx1Xp4htBYOVD4cB6U1Lt6XTUW7F/A4VAaFnOsCxKPa5
 NubYkWrAp6mQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 11:16:58 -0700
IronPort-SDR: n/CH/8iXeQ5TSqK7dGMDLDRhi/wIFz98onR2cDWTFxK31Iqajt6ancBaDEaaVUBoUKKwqlEtoD
 /90wCObBnu9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="255020754"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 20 Apr 2020 11:16:54 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 292D717F; Mon, 20 Apr 2020 21:16:53 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 2/2] net: bcmgenet: Drop useless OF code
Date:   Mon, 20 Apr 2020 21:16:52 +0300
Message-Id: <20200420181652.34620-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420181652.34620-1-andriy.shevchenko@linux.intel.com>
References: <20200420181652.34620-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is nothing which needs a set of OF headers, followed by redundant
OF node ID check. Drop them for good.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 9f2f0e6816568..ef275db018f73 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -23,11 +23,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/pm.h>
 #include <linux/clk.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
-#include <linux/of_net.h>
-#include <linux/of_platform.h>
 #include <net/arp.h>
 
 #include <linux/mii.h>
@@ -3417,8 +3412,6 @@ MODULE_DEVICE_TABLE(of, bcmgenet_match);
 static int bcmgenet_probe(struct platform_device *pdev)
 {
 	struct bcmgenet_platform_data *pd = pdev->dev.platform_data;
-	struct device_node *dn = pdev->dev.of_node;
-	const struct of_device_id *of_id = NULL;
 	const struct bcmgenet_plat_data *pdata;
 	struct bcmgenet_priv *priv;
 	struct net_device *dev;
@@ -3433,12 +3426,6 @@ static int bcmgenet_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	if (dn) {
-		of_id = of_match_node(bcmgenet_match, dn);
-		if (!of_id)
-			return -EINVAL;
-	}
-
 	priv = netdev_priv(dev);
 	priv->irq0 = platform_get_irq(pdev, 0);
 	if (priv->irq0 < 0) {
-- 
2.26.1

