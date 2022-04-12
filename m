Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D444FDBA1
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349417AbiDLKFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378007AbiDLJ7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 05:59:32 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01083201A9;
        Tue, 12 Apr 2022 02:05:21 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c12so940875plr.6;
        Tue, 12 Apr 2022 02:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j7ppuC3URMizB5XFqgyAtRw7E3pD1kAwpnxOQKvDpfM=;
        b=Yp+hzfoFrODCzPRTOYkDNU0hM9THaMgdSejic6PlcnWGIiVhEjLDUHNffu8OhGkTi8
         X/F+BMKJ6l2kkbvOJMkgRizhld2bwAiQbbRNVcMWkhBaNKfUQfW0lHiD2eYv4L8Ti8vL
         lAswnosa+5CuRlBovLf2xb4Ixpm1CVXbIWZ0nn9qjQC9ZbpMPyzKsXIMVw6O/RiydDAh
         r9KbAQCLRm/KrIHXhR+3aefO8fHZYgQQIS0WeWdCRMywn7iHZEnWtNCpkbyB0vhCnH2V
         m4773Dnzs439V0GI0Ul7iXMjxktIR+bWpLWIirUz0AqYMMcnI63VXyJVrglxXH7bnlad
         WEoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j7ppuC3URMizB5XFqgyAtRw7E3pD1kAwpnxOQKvDpfM=;
        b=ea8GUwgJTjYFzWB68+bWZiyI5rsBRu6AGLFaQFu0Dz7hsCvnoIl331znqwfKDmi344
         PL0Pib+VzwMDvXEU3gZtH8Ez1garRSXI3zC/dhLpiqviupKlFOzy5JvCfPixttGzLqa7
         KYO6sDeKsmUuLBOOuyV7IzfSWyKvpoC9UK7MPeONoPwO1ggMLIOulEWnETc3qaLtlqef
         W2TWtgZzH7sYezWviXcarpn8YMdVmviqD/cPktCr1+GGLocPyJEo/NxBwpWiyJbHpXPS
         nDw4h+yyeTj8NUUE7itO1LZ0TVpNCOCUdP8T1iqoexPoxS4+8znMDGSZAT4LPu6jaMlT
         01mA==
X-Gm-Message-State: AOAM5328nsxbuHGE0HUirHegQ/iJ1qM3iGgYBeRN1hfP3Kdzr97/cnOK
        DOP2F0O5KuOZPcLbxFTl8x8=
X-Google-Smtp-Source: ABdhPJzJ/XGTHvvcT9TYVA+nunyEBCeRUmpbJy1yEQsPfvse+ugyB7veRg3wsWRs9nu3VvVvs8CCtQ==
X-Received: by 2002:a17:90a:5407:b0:1bf:43ce:f11b with SMTP id z7-20020a17090a540700b001bf43cef11bmr3837133pjh.31.1649754320558;
        Tue, 12 Apr 2022 02:05:20 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id nh11-20020a17090b364b00b001cb65949c66sm2184364pjb.37.2022.04.12.02.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 02:05:20 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, vladimir.oltean@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: ethernet: ti: am65-cpsw-nuss: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Tue, 12 Apr 2022 09:05:15 +0000
Message-Id: <20220412090515.2533397-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Using pm_runtime_resume_and_get is more appropriate
for simplifing code

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 33 ++++++++----------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index d2747e9db286..b7ebd741f284 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -173,11 +173,9 @@ static int am65_cpsw_nuss_ndo_slave_add_vid(struct net_device *ndev,
 	if (!netif_running(ndev) || !vid)
 		return 0;
 
-	ret = pm_runtime_get_sync(common->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(common->dev);
+	ret = pm_runtime_resume_and_get(common->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	port_mask = BIT(port->port_id) | ALE_PORT_HOST;
 	if (!vid)
@@ -203,11 +201,9 @@ static int am65_cpsw_nuss_ndo_slave_kill_vid(struct net_device *ndev,
 	if (!netif_running(ndev) || !vid)
 		return 0;
 
-	ret = pm_runtime_get_sync(common->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(common->dev);
+	ret = pm_runtime_resume_and_get(common->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	dev_info(common->dev, "Removing vlan %d from vlan filter\n", vid);
 	ret = cpsw_ale_del_vlan(common->ale, vid,
@@ -557,11 +553,9 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
 	int ret, i;
 
-	ret = pm_runtime_get_sync(common->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(common->dev);
+	ret = pm_runtime_resume_and_get(common->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	/* Notify the stack of the actual queue counts. */
 	ret = netif_set_real_num_tx_queues(ndev, common->tx_ch_num);
@@ -1214,11 +1208,9 @@ static int am65_cpsw_nuss_ndo_slave_set_mac_address(struct net_device *ndev,
 	if (ret < 0)
 		return ret;
 
-	ret = pm_runtime_get_sync(common->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(common->dev);
+	ret = pm_runtime_resume_and_get(common->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	cpsw_ale_del_ucast(common->ale, ndev->dev_addr,
 			   HOST_PORT_NUM, 0, 0);
@@ -2692,9 +2684,8 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	common->bus_freq = clk_get_rate(clk);
 
 	pm_runtime_enable(dev);
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
-		pm_runtime_put_noidle(dev);
 		pm_runtime_disable(dev);
 		return ret;
 	}
@@ -2789,11 +2780,9 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 
 	common = dev_get_drvdata(dev);
 
-	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpsw_unregister_devlink(common);
-- 
2.25.1

