Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFAE41727
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 23:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407739AbfFKVtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 17:49:12 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40277 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407170AbfFKVtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 17:49:11 -0400
Received: by mail-lf1-f65.google.com with SMTP id a9so10452573lff.7
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 14:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=i6GhLaflHxtAwL6Ad6Dr/C5ELNhP+vqOwXCPihJeLM8=;
        b=mF/ELEtx8NPOPG3GZNMj3xXssQs8CPSw6r9xXfmVWR6vI50hpVCFF8E++nxCQxBQty
         w1mqcgctM/qAYXwueTcmLS9XTrg9obZ0X9Z327VRyQK40aEuuqUysUhpRYW8PawxNHNy
         fzt9hcqJPCgMwkqup/JcNPCQt5Kq9clL6C7j6HhdRs+oH8OV2VgTQBC5eTjbGd/WN/tq
         vjw2gTYLwvqmwZDH6qYhRzUcNvSHLV7aRINd+jsgUmp2DSI0V6XgOwjNKJ+rdsrTc/jQ
         kLHDaBT3/z1E41YMfT7XPfdK57pKtlKK/9UsVkmWZgW0DRN9UIY4dQf5zKQv93moT2ZT
         vAfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=i6GhLaflHxtAwL6Ad6Dr/C5ELNhP+vqOwXCPihJeLM8=;
        b=YSyVX6iRFl/mv8iOlCNpBcP0MX3r1TydIGSZnOtjy25118eyH4lrqu8fofmURGRo9z
         hIREzaxa5SykaFGgzm9BiGrG+duEEW8I27Z6mkdSrf74PHV1KU7U0Xq1kB4sL6JA5HT4
         UpV/fJmYDIpayMwtvp1i5hcKShqC4YX37RtPL9T6TUgNB0uxP433ip2pMPO05+EZKH0Q
         tSnpEGEZU2Z/8ihm1y6QwIN6X0Orlmbopfo2DaqRYs7RR61tHfYkuhlZL2kfVAhqqkb6
         4RRBtkFtH4C9GLPqbHySa0CI4F6PogWOk+u0uMZUz8R1MlrNRWwQJCXmWSJIkjT/VH5G
         A48Q==
X-Gm-Message-State: APjAAAVbE2BxtiqUVgMgjgylCQmrgwTgxe9lRx9ykvPQidEVQaNl4dUz
        ZReTmH2hyLTR75IpIZ85ZqpKUw==
X-Google-Smtp-Source: APXvYqw+qg4jwlO0JzvRQuQMV9ByejZJE+uZatTs0aps96wZ6LLBeiY1URuP4dn41RtClXDZDIa/dw==
X-Received: by 2002:ac2:514b:: with SMTP id q11mr5226108lfd.33.1560289748726;
        Tue, 11 Jun 2019 14:49:08 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id e26sm2787342ljl.33.2019.06.11.14.49.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 14:49:08 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, davem@davemloft.net
Cc:     linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH net-next] net: ethernet: ti: cpsw: use cpsw as drv data
Date:   Wed, 12 Jun 2019 00:49:03 +0300
Message-Id: <20190611214903.32146-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need to set ndev for drvdata when mainly cpsw reference is needed,
so correct this legacy decision.

Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---

Based on net-next/master

 drivers/net/ethernet/ti/cpsw.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 6d3f1f3f90cb..3430503e1053 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2265,8 +2265,7 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 
 static void cpsw_remove_dt(struct platform_device *pdev)
 {
-	struct net_device *ndev = platform_get_drvdata(pdev);
-	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
+	struct cpsw_common *cpsw = platform_get_drvdata(pdev);
 	struct cpsw_platform_data *data = &cpsw->data;
 	struct device_node *node = pdev->dev.of_node;
 	struct device_node *slave_node;
@@ -2477,7 +2476,7 @@ static int cpsw_probe(struct platform_device *pdev)
 		goto clean_cpts;
 	}
 
-	platform_set_drvdata(pdev, ndev);
+	platform_set_drvdata(pdev, cpsw);
 	priv = netdev_priv(ndev);
 	priv->cpsw = cpsw;
 	priv->ndev = ndev;
@@ -2570,9 +2569,8 @@ static int cpsw_probe(struct platform_device *pdev)
 
 static int cpsw_remove(struct platform_device *pdev)
 {
-	struct net_device *ndev = platform_get_drvdata(pdev);
-	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
-	int ret;
+	struct cpsw_common *cpsw = platform_get_drvdata(pdev);
+	int i, ret;
 
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0) {
@@ -2580,9 +2578,9 @@ static int cpsw_remove(struct platform_device *pdev)
 		return ret;
 	}
 
-	if (cpsw->data.dual_emac)
-		unregister_netdev(cpsw->slaves[1].ndev);
-	unregister_netdev(ndev);
+	for (i = 0; i < cpsw->data.slaves; i++)
+		if (cpsw->slaves[i].ndev)
+			unregister_netdev(cpsw->slaves[i].ndev);
 
 	cpts_release(cpsw->cpts);
 	cpdma_ctlr_destroy(cpsw->dma);
-- 
2.17.1

