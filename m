Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B922E727DE
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 08:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfGXGGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 02:06:15 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34531 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGXGGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 02:06:15 -0400
Received: by mail-pl1-f195.google.com with SMTP id i2so21580879plt.1;
        Tue, 23 Jul 2019 23:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=guFxv22S4JOArjEKN9Dxhy2TAljfranssf7R2KMuN5E=;
        b=ZTKmSpvvsEXCKpAARDgWNlQPMnESR+iob7CQxD1+ohydGxdFzikNctwCkFA2oVR7tl
         vhWkS87ZiFhQzjGAF6sIlX4Vvp74szDJbXg14WXjKIT8jdu5cXZaVfPFKD7KsG1jWtib
         E+YPjwVfnEDnPfRFPQngmzIEIJgm/+2pJxRfNI6VCeGXZPnjVo1xozXyxqzC1gYeTviK
         kRg1eKPKxK7VYfjBHtZIfyKWfQADzb2Uwn1esGUrWaBHyhLqehZ43IEW+ohqKhUegEcn
         jklne6LVA08suiBLtsqrFvUCwV+Ox9XtdBwZd1E1/OQtdTqKfav+6pRBV59ECgmrXaYR
         ctQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=guFxv22S4JOArjEKN9Dxhy2TAljfranssf7R2KMuN5E=;
        b=jmkYqsKZkwvamJzICVBFxmdmpSbmvVQ/S1mpDC0AVvZODi3iSRe3x5kwPc9l5025es
         GJeGSBr4CBUJs3ZTxlOvRR0SnoGI/zEbj376jAW5b4ssnHmh1SMHulfxxpuXLNcuvZee
         1fN2zNBozth2teP5YK36EnWbyn4URSWSRGT95XsxbuGI9j8dmmtHy4W3KCs3GAEVw2i1
         kGhepsZ/T/Ki6Wn/1ipfHcie9N1CeOqvaIcyC7LghSWO6LvmhEKjiUNxZfiwCf+c91C0
         fT7lZUch3eNDYj1y079zM4TzHlmNXBKALKdOaluhyLbkBgXnXWlQL4oRF+Vg/W8YPmVZ
         TLhg==
X-Gm-Message-State: APjAAAVoa4zvpmOsmpCPawoYqmSabbydmURU2At4KN1FToDNZfRO7E8u
        9+uUDluvkqRnEAT4uGqr3rM=
X-Google-Smtp-Source: APXvYqy/1q7UpsiiVNicCAmywrdgkmPJes/B8K5Uqe0sjcw3wKWzW8+klY0U35P3+v9l1Eh16zs62w==
X-Received: by 2002:a17:902:110b:: with SMTP id d11mr87862606pla.213.1563948374625;
        Tue, 23 Jul 2019 23:06:14 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id a3sm46434953pfo.49.2019.07.23.23.06.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 23:06:14 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next v2 4/8] e1000e: Use dev_get_drvdata where possible
Date:   Wed, 24 Jul 2019 14:06:09 +0800
Message-Id: <20190724060609.24116-1-hslester96@gmail.com>
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

 drivers/net/ethernet/intel/e1000e/netdev.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index e4baa13b3cda..ad203a2a64c4 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6297,7 +6297,7 @@ static void e1000e_flush_lpic(struct pci_dev *pdev)
 
 static int e1000e_pm_freeze(struct device *dev)
 {
-	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
+	struct net_device *netdev = dev_get_drvdata(dev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
 	netif_device_detach(netdev);
@@ -6630,7 +6630,7 @@ static int __e1000_resume(struct pci_dev *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int e1000e_pm_thaw(struct device *dev)
 {
-	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
+	struct net_device *netdev = dev_get_drvdata(dev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
 	e1000e_set_interrupt_capability(adapter);
@@ -6679,8 +6679,7 @@ static int e1000e_pm_resume(struct device *dev)
 
 static int e1000e_pm_runtime_idle(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	u16 eee_lp;
 
@@ -7105,7 +7104,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->irq = pdev->irq;
 
-	pci_set_drvdata(pdev, netdev);
+	dev_set_drvdata(&pdev->dev, netdev);
 	adapter = netdev_priv(netdev);
 	hw = &adapter->hw;
 	adapter->netdev = netdev;
-- 
2.20.1

