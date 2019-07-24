Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF87727DA
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 08:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfGXGGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 02:06:09 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37318 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGXGGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 02:06:09 -0400
Received: by mail-pg1-f196.google.com with SMTP id i70so9894896pgd.4;
        Tue, 23 Jul 2019 23:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pq4pval6Wp1QkS3biIpuGAltYsbeNivQszcRkiFp4zo=;
        b=JnNaBaNZHHAUYSzCoyjvfNsUKCd4vpHspe8dDhdFDWibnjkRLoigm5WGp5WnafoHEb
         AOA13KfCAEqGAtfykmW4Z7UPjBtd4zeqWU7mE4hOMoSz2LWdByShjnBG5QVkjzba1qiH
         f1op6rthGv4OHN7+K+CihZPsAp52IsdUNIGVrIN1ghrsY6k9mEuh3GRaMy6Li53KheWu
         y9FKlQ6V1XDW1i+7SiWSxdUvxRbeAOekfJ+hbSVLBh7C272Es89WlOM5WhHMByjRDD3x
         azXTLR3SVkBYa6+bwRez2mQ43xbcMlc4LQXTsjSiefrQXygmdwCcD1XKjHQHoD8Z/MFR
         YP0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pq4pval6Wp1QkS3biIpuGAltYsbeNivQszcRkiFp4zo=;
        b=U6HETgH5ODaLj3Yx6Ac1wILc/fo8V/y107WbqBWtwJVoOrIAT+6Q40QbEqtUVA8tQ9
         XFi4rvBYJSEkbQN0m2/Lq2tVFB2gYaA0pQHKbVJ3OU07VGMuuu5ie99EV23yTIzictCR
         rwpjOmVGdsEujvkGm38WM47aHptU7sM90tGsiBTCYotN6dgtpQSkPBne3iAc6A2np7CN
         HUsCdzJMQj+BBcrAf4OVWoUfAvvCmeiiA3rO4XQji9EuJYfFV6ZkBX26bMLrplPIEiAG
         lDUGqIRgGOZ0SHZgx80GO2oqEZu5Th9YF0Q5aCS2Od4LcOesoIcCsoz8u7ik9BC7STbk
         H1fA==
X-Gm-Message-State: APjAAAXhueBvK4L55r0jdelZq0vGBFfazEhf2CXTzXV79fALQvP3GosW
        YSt0M0Z2UKd/1uKIU74QDFI=
X-Google-Smtp-Source: APXvYqzPK2qW0gDNBtql5f3grFJl0Up4lkJVzQt+E+g9iPQkZQhnYpWFfECV2Vb+/VWYcMU689Hopw==
X-Received: by 2002:a17:90a:b394:: with SMTP id e20mr85180401pjr.76.1563948368000;
        Tue, 23 Jul 2019 23:06:08 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id s11sm43041629pgv.13.2019.07.23.23.06.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 23:06:07 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next v2 3/8] net: broadcom: Use dev_get_drvdata
Date:   Wed, 24 Jul 2019 14:06:02 +0800
Message-Id: <20190724060602.24061-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using to_pci_dev + pci_get_drvdata,
use dev_get_drvdata to make code simpler.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v2:
  - Change pci_set_drvdata to dev_set_drvdata
    to keep consistency.

 drivers/net/ethernet/broadcom/bnx2.c      | 8 +++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 +++-----
 drivers/net/ethernet/broadcom/tg3.c       | 8 +++-----
 3 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index dfdd14eadd57..da538a7bac14 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8586,7 +8586,7 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	bp = netdev_priv(dev);
 
-	pci_set_drvdata(pdev, dev);
+	dev_set_drvdata(&pdev->dev, dev);
 
 	/*
 	 * In-flight DMA from 1st kernel could continue going in kdump kernel.
@@ -8673,8 +8673,7 @@ bnx2_remove_one(struct pci_dev *pdev)
 static int
 bnx2_suspend(struct device *device)
 {
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(device);
 	struct bnx2 *bp = netdev_priv(dev);
 
 	if (netif_running(dev)) {
@@ -8693,8 +8692,7 @@ bnx2_suspend(struct device *device)
 static int
 bnx2_resume(struct device *device)
 {
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(device);
 	struct bnx2 *bp = netdev_priv(dev);
 
 	if (!netif_running(dev))
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7134d2c3eb1c..956015acd97f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10662,7 +10662,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->netdev_ops = &bnxt_netdev_ops;
 	dev->watchdog_timeo = BNXT_TX_TIMEOUT;
 	dev->ethtool_ops = &bnxt_ethtool_ops;
-	pci_set_drvdata(pdev, dev);
+	dev_set_drvdata(&pdev->dev, dev);
 
 	rc = bnxt_alloc_hwrm_resources(bp);
 	if (rc)
@@ -10920,8 +10920,7 @@ static void bnxt_shutdown(struct pci_dev *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int bnxt_suspend(struct device *device)
 {
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(device);
 	struct bnxt *bp = netdev_priv(dev);
 	int rc = 0;
 
@@ -10937,8 +10936,7 @@ static int bnxt_suspend(struct device *device)
 
 static int bnxt_resume(struct device *device)
 {
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(device);
 	struct bnxt *bp = netdev_priv(dev);
 	int rc = 0;
 
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 4c404d2213f9..282031dc89b3 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17918,7 +17918,7 @@ static int tg3_init_one(struct pci_dev *pdev,
 
 	tg3_init_coal(tp);
 
-	pci_set_drvdata(pdev, dev);
+	dev_set_drvdata(&pdev->dev, dev);
 
 	if (tg3_asic_rev(tp) == ASIC_REV_5719 ||
 	    tg3_asic_rev(tp) == ASIC_REV_5720 ||
@@ -18041,8 +18041,7 @@ static void tg3_remove_one(struct pci_dev *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int tg3_suspend(struct device *device)
 {
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(device);
 	struct tg3 *tp = netdev_priv(dev);
 	int err = 0;
 
@@ -18098,8 +18097,7 @@ static int tg3_suspend(struct device *device)
 
 static int tg3_resume(struct device *device)
 {
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(device);
 	struct tg3 *tp = netdev_priv(dev);
 	int err = 0;
 
-- 
2.20.1

