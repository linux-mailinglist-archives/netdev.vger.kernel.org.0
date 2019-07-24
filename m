Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21C57727CF
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 08:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfGXGFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 02:05:38 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38518 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfGXGFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 02:05:38 -0400
Received: by mail-pg1-f194.google.com with SMTP id f5so11813364pgu.5;
        Tue, 23 Jul 2019 23:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Twevo6sVaaVI2A1vSf1Wr6zgrYSK1ESB5x0Su/v7Gzs=;
        b=L4IffpNCaLWQdp6NduS2I/CeGI/8IxEc5bIcVNd1Ufqu7dpzl86yM2GAT3AbQJxflM
         rbTxLMTqmhZQV3jYc3oQVXwZqZJyfRKad0g/Wyk1i+yED2FVHAQVhQD4gao4l7Eo+hjt
         yeh/rtik6XxgZ5jCIo7xM8Ju/E5lkGubDrba2+4Jm+QqiK+7/7YXxYD+qbhyy+jraUBW
         cu7V4dsU5A4FbjaNSP03G4+J7ExNxbG65iV6uaDBQZt1dawxPs4xeVYGhQZPrRofUAjm
         LY2MllpTrYhLU5z5IantJpDlfD2TuQ80NFw/B+aUiO1iHhQZlrQ1awkiMRHiw4ZQEAR0
         REYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Twevo6sVaaVI2A1vSf1Wr6zgrYSK1ESB5x0Su/v7Gzs=;
        b=UL/Up+OV9UekcLqzBXDD9dj4aUf7TmdOEf1ZviWgFIH1Fy3O78tQaeLv4+0LjlKTho
         QWlKrWLJX+9yTEQNplhSUR4RCmiEE59G6Tk7rTjF6S9r1MqELNvTHsbcS3dVtUUwwToA
         bd3rf4zXR450Ogetmwy/iXDTQPyoh8h5euLJLt1yKvjkCUZP9/K6wv+cgY3UtR1a/g3g
         qNUHlYpuVAnLxjYYUYoml5MBiCc4tgR6wBXH1O4KMpzU4+/+2LDzjaNle3yDRufUfP4X
         DZ5bQcTI3IzlOjCmuduno6asVptJXn2kk3fWOwyV3YFImwbCTYE7r1TVIGN4WC3CBvm5
         8bXA==
X-Gm-Message-State: APjAAAXs6tc46JgbGr8zylXj+1WSeGA3glMRJTnzSkj3rbvBMhsX2bgR
        8mWn2ExqQ4hl8TFhH+VGzrM=
X-Google-Smtp-Source: APXvYqx6NzMVRq9UDmtL8rB3rGw5UcM+b/nhEFGqoT+WC2z1naHBnw9aS+KksTy6cfzk3x8qe8O2Fw==
X-Received: by 2002:a63:b904:: with SMTP id z4mr78435659pge.388.1563948337113;
        Tue, 23 Jul 2019 23:05:37 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id i7sm35722269pjk.24.2019.07.23.23.05.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 23:05:36 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Steffen Klassert <klassert@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next v2 1/8] net: 3com: 3c59x: Use dev_get_drvdata
Date:   Wed, 24 Jul 2019 14:05:32 +0800
Message-Id: <20190724060532.23953-1-hslester96@gmail.com>
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

 drivers/net/ethernet/3com/3c59x.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 147051404194..a0960c05833d 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -847,8 +847,7 @@ static void poll_vortex(struct net_device *dev)
 
 static int vortex_suspend(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct net_device *ndev = pci_get_drvdata(pdev);
+	struct net_device *ndev = dev_get_drvdata(dev);
 
 	if (!ndev || !netif_running(ndev))
 		return 0;
@@ -861,8 +860,7 @@ static int vortex_suspend(struct device *dev)
 
 static int vortex_resume(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct net_device *ndev = pci_get_drvdata(pdev);
+	struct net_device *ndev = dev_get_drvdata(dev);
 	int err;
 
 	if (!ndev || !netif_running(ndev))
@@ -1222,7 +1220,7 @@ static int vortex_probe1(struct device *gendev, void __iomem *ioaddr, int irq,
 	/* if we are a PCI driver, we store info in pdev->driver_data
 	 * instead of a module list */
 	if (pdev)
-		pci_set_drvdata(pdev, dev);
+		dev_set_drvdata(&pdev->dev, dev);
 	if (edev)
 		eisa_set_drvdata(edev, dev);
 
-- 
2.20.1

