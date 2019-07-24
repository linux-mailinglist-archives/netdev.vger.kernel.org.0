Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F02B5727ED
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 08:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfGXGGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 02:06:47 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43045 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGXGGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 02:06:46 -0400
Received: by mail-pl1-f196.google.com with SMTP id 4so14574395pld.10;
        Tue, 23 Jul 2019 23:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3nezsYKelUkWXu/WuGZ4bisaP+vEJX1eIGb2BGpr5fM=;
        b=KGSRuqNwdw3I5D6WthFGXLlumNPsFAdIb9aHb13ZA1o7zMKRfMt8T25tR2bR4KgOxN
         RWIFoK0UR6eel68uSKRYdtskX4E4J/kaPBAJlaGXQZoPBJgbthKSCx9/KQfanKt0qm/l
         JjrdPWSo3bveOsvv5V7CkEtJ5Ndr+1OqW+6yvWxD2zwBvkg+kfLpEuTqp41xzNBQnI26
         Ab41Bt6iIizdz32iX6MEUZFYzEKGQ23ESOFwaW1HTobW1gGRV/DSqCvSdczN2/iQiVNQ
         JMgVRHXTfTxIWVuqfK15xpODn7pbuhrHgPgSwtcNMsjNhV2HKAyFVg4aOcszcPMEL+KO
         EwyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3nezsYKelUkWXu/WuGZ4bisaP+vEJX1eIGb2BGpr5fM=;
        b=qi5K2p3e0z3NscwXRPtbhq9C8Uz39Q377Xys/7rVf4DP6Erumm27K3sJcfV0egtfzI
         2/+QN5dDzx4deXvzV4dbMnhJFmBq6VwAMbzqoFivcW3KW23lFGTbiD7oQCHt6Mkq5afO
         1Jeg5qn23e6+ctW1D+U0I4PYanYikbtl6W7Y/J10ujj+09P0mg17nnfLxiK0YM6ZtX19
         SVHzx8SYvC9pY4NPOeCXCmtexiSL/zknK3m5P89CnbZBKPA1dsgx77upi0qBZ1hPJNxr
         33l5Yr+ZijGMIN/ukCpFrxVkFX0xP5k/wL5KJ5xfOiHbMXFw0sJ42986YiUCtwE3OM//
         Cg/w==
X-Gm-Message-State: APjAAAXCgLV1jj3ytrGlqA5TtU4N27C044sYQpyBB9wh19pHVno3W50g
        CaWjE2ntQg134Xs8A4cLgek=
X-Google-Smtp-Source: APXvYqx3fYd3copU8UnUOGA9iWwp5fl7LA8+KIQrIpRsa/hnVcXh2VbFjrBdC6KRbdCg2antv58Pdg==
X-Received: by 2002:a17:902:2983:: with SMTP id h3mr84740917plb.45.1563948405996;
        Tue, 23 Jul 2019 23:06:45 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id z63sm11682896pfb.98.2019.07.23.23.06.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 23:06:45 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Guo-Fu Tseng <cooldavid@cooldavid.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next v2 8/8] net: jme: Use dev_get_drvdata
Date:   Wed, 24 Jul 2019 14:06:41 +0800
Message-Id: <20190724060641.24334-1-hslester96@gmail.com>
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

 drivers/net/ethernet/jme.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 0b668357db4d..6815bd18a477 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -3000,7 +3000,7 @@ jme_init_one(struct pci_dev *pdev,
 	netdev->max_mtu = MAX_ETHERNET_JUMBO_PACKET_SIZE - ETH_HLEN;
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
-	pci_set_drvdata(pdev, netdev);
+	dev_set_drvdata(&pdev->dev, netdev);
 
 	/*
 	 * init adapter info
@@ -3193,8 +3193,7 @@ jme_shutdown(struct pci_dev *pdev)
 static int
 jme_suspend(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev);
 	struct jme_adapter *jme = netdev_priv(netdev);
 
 	if (!netif_running(netdev))
@@ -3236,8 +3235,7 @@ jme_suspend(struct device *dev)
 static int
 jme_resume(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev);
 	struct jme_adapter *jme = netdev_priv(netdev);
 
 	if (!netif_running(netdev))
-- 
2.20.1

