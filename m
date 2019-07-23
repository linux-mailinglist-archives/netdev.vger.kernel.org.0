Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3C671902
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 15:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389916AbfGWNSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 09:18:51 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40761 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729452AbfGWNSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 09:18:50 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so19433534pgj.7;
        Tue, 23 Jul 2019 06:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mGrUry5yVvS7MoLiPpSpAf48bCAzpftIlN4T3gevYyQ=;
        b=KA+s5PHvnmXv8ukQ6fEddY/y27w/X062erKiS+dcvMG6NTkk/HN7baRy6Vwl0i0PqO
         QAKj/UrxIyhYNbgONFRI88Ix7LRbMPVOrz4FrHGQfgrcu5pzJDnuie2TZuk5XFkR5h4B
         dq0T5emzhb2sx+pnmM5C0gGHiX5oQLc14/b5IIzSw/23JWp+MD0MHeNG67IscZeDLZV7
         nKg7bZnaUyhGjCv4aZ2w1dvcWoM3aS5v0McbNovuC9YJZsfoo7WX292IySkDCZV0Au/f
         itOwPyfrRNvYPeIgf12WGk2//XmXy3Ahe8EN77Fd3eRjGRG/hdhZrC/l6sWiozkBtUIy
         jGpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mGrUry5yVvS7MoLiPpSpAf48bCAzpftIlN4T3gevYyQ=;
        b=K9YWG4IM/zGgxVMN2CniIPQAfvHObv6b3hZfmiyxFIcqIcf9LIgn7A1JhdG0XYqWr6
         29cye48tFZOalkwPXSTjewzWrq0VSMf2fao5X8mwJsN5gGikovS8ex8EVppVIGlxXtLG
         wheZX+4Yb54E7ukgC1B8O01AioBMar50rwfFT3zgjJyFnwbJ1FQL+7g64cfAC8FLRG02
         kGXR2z0vUrFvwKJE2v1ok0x9JKWmra6jgnpxc6lfSJxZA1x/Y5J2vVp4AnNjUgMj9/HQ
         2u8euVzViqr8y9ezKstpFm5L6cprWaX6vTs2A0+oQ+RH492cim9+9IiqOXag6RYohIgV
         tmNw==
X-Gm-Message-State: APjAAAWubUuoTQz8hV5CY8qMlEBivlK/JaQTEiZfuKfZhVt9Azg0eKtA
        yt9JNRnXW7HnXs5QzAVca+Q=
X-Google-Smtp-Source: APXvYqy463zSTD+FF4e8zHz2xWSL9r4i5O28KcN1ZxIZmnJE3IyAoSEGsVqhcA9Y+kXl04P8HJUItw==
X-Received: by 2002:a17:90a:1b4c:: with SMTP id q70mr80056485pjq.69.1563887930136;
        Tue, 23 Jul 2019 06:18:50 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id y11sm47048285pfb.119.2019.07.23.06.18.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 06:18:49 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Steffen Klassert <klassert@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] net: 3com: 3c59x: Use dev_get_drvdata
Date:   Tue, 23 Jul 2019 21:18:44 +0800
Message-Id: <20190723131844.31878-1-hslester96@gmail.com>
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
 drivers/net/ethernet/3com/3c59x.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 147051404194..8f897828869f 100644
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
-- 
2.20.1

