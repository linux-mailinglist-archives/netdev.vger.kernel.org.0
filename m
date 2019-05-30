Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8F6301CD
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfE3SVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:21:33 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35419 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfE3SUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:20:55 -0400
Received: by mail-lj1-f195.google.com with SMTP id h11so7043654ljb.2
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 11:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ksgNqXYuq7eYRSzBEvTxTsDgmGrsQMBHFwlmQvvNPkE=;
        b=GxvvJPDKMnF2Hc4YuIT4oM82YGKw8EcaMBLqKbLD6yc2xy1Jwtfbwfeyw6rJBMcxpP
         /8u5FHFV1Sy3qbcFK5Wmocu4voUWgTi5jFxXDOxc+ngyfsy4lqfvlE7oHUr+L6qZH+eX
         ueuXJk6RvJCOHnaTzXvc+TlemnLRktzO0mQfYVU9yC3NpOn2npdhCibuxqDZHEu55r80
         3ZvBQY3uUcxW/C9LniDNuWN/a3zoHFJ2gJI3hYCe/2Td//7W/9ecVrlJaVueUFNuH3iF
         nCFCRSOlgR596k+Vvo6qoZ/d/mlLBZ1dEtqBninfkrngveooWNd17Db8p+jox/7w0ASv
         o/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ksgNqXYuq7eYRSzBEvTxTsDgmGrsQMBHFwlmQvvNPkE=;
        b=XOyPr1umC4VLe1Ujvy9XRvCUK1pj8j7vrsbV4Vgkie6B47cnwIp4KL/SUFSIoP66zd
         oAdlOAYGlvP8v0cBwbzzd+Jwrl3U+bLRXYAaGNhFAdumLnc38WwpT81plV2veqb/xgDG
         MM2bKsCHnlqwtbWVrPzGR2gz54w2VCE0ndr/12OFdbJ63+Lv4LymcxHI+0eXx7OM1Ojg
         A9zJ3+6t1otcwu4zyf7x8dtzgn3/zxb7YW+0VaGQGLeAQZxGgbDRKLj7DOIind3plASf
         56rB8qr1ypbDD7uoMQtN/WQUg+vHC4JhqZo2C3aIfR1yF0Gb5Ht+sfd1pw87FZ6dUZbj
         LjjA==
X-Gm-Message-State: APjAAAXDfcO9SBlDVk+vHyG7BcgqZRQF7k8I5wMPxjr05iLtD7IKA8Xv
        eNgpvyfx6hUiaGXraI2MS0VtvA==
X-Google-Smtp-Source: APXvYqy7hb7ALHTHh96K5zrKV05mrOIrhkcfG5OPW6qXfaO6Jy/BSI/AMhpabp61GGx5Y2leoIFiTA==
X-Received: by 2002:a2e:88c7:: with SMTP id a7mr2713139ljk.118.1559240453797;
        Thu, 30 May 2019 11:20:53 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id v7sm388946lfe.11.2019.05.30.11.20.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 11:20:53 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v2 net-next 3/7] net: ethernet: ti: cpsw: use cpsw as drv data
Date:   Thu, 30 May 2019 21:20:35 +0300
Message-Id: <20190530182039.4945-4-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
References: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need to set ndev for drvdata when mainly cpsw reference is needed,
so correct this legacy decision.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
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

