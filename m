Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FDC46098F
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 21:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbhK1UEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 15:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbhK1UCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 15:02:23 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AFDC061748
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 11:59:07 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id k4so10339504plx.8
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 11:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zoPy0bNc75d6cHcoNsEU6L+DTZgg21PWLJZBbcTFrXs=;
        b=K+ZeLQZrUNVKHW7QCeETPl5kF2FjN9C6tMyt/GHbYE2/yqTIrwJROeG4Zz5HlxXrkJ
         971eCRHgYQzol8mOgsQhwYlRmzq/PNRUjKY/h1ieN69sE550oszS/s3qf6TLXdgNpJbr
         V5Dywtwdyy5BCOGGRD3TO5uuaLrtRToFrcKAUxeCTuskr230zhW0MA3qLCtvWy0RA6BT
         ma5lM78w/QctKOgHPRP+cptW08y5UebjXrtuaOh9qqnbqFKFhMdEz2E9/6kDa0veoBfJ
         WFYctabzk3OS6pOAEEHl4EHb3YE43ZE/DbYJjm6cenq5XKkQ7ggsnRpDdTKzWlnqZ5o/
         NUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zoPy0bNc75d6cHcoNsEU6L+DTZgg21PWLJZBbcTFrXs=;
        b=lrdqTX71Ruo/g971wJv3QiIx0w/VgLe9XGAW/4Dc3LoHsQ6E8OsdpOA31gkGC5/an7
         P2ckWzF2paMeNy0SgIPvC9o16J/3X8/DFQgdp2c7o+RBZFzdE+kJQ2FwTcIQj6wlsBgN
         h1ltbdypP+E3nTbXbvpOvVKQYquqBaBo5EI0m7TtFwfSeOKEGqrQBUtAh+IhJzk2uFFi
         xssur6GUsLalpYw92AmC2Mokck/poZSDS+RuDOjDR3/5J6G5JIPDBHokvLobflvXdDSE
         t8IqChMDEKR5IKxGKPpNcjumYiDhzD3kcNX05QZlurH4SpW0Xq+ju35Tu28+QBSSOXxw
         03oA==
X-Gm-Message-State: AOAM532CO8kLiWQu5a5MWzlu11EgFHYJZore95zEd14/Fo99tj9BDnH+
        8+AwrWP5G5+MiIpni/vugtNjqHFq6ucKtg==
X-Google-Smtp-Source: ABdhPJxxPMppxXwAq/Z17R2UIrKv6pz+yw3oxworu/K1NuQZb7XcqX5ffnf9zM/mmswA7P0pZ11bFg==
X-Received: by 2002:a17:903:2445:b0:142:830:ea8e with SMTP id l5-20020a170903244500b001420830ea8emr53674813pls.54.1638129546237;
        Sun, 28 Nov 2021 11:59:06 -0800 (PST)
Received: from localhost.localdomain ([2402:3a80:1bee:ad81:ba28:2980:118c:834f])
        by smtp.gmail.com with ESMTPSA id q9sm15359995pfj.114.2021.11.28.11.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 11:59:05 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     netdev@vger.kernel.org
Cc:     vkoul@kernel.org, bhupesh.sharma@linaro.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next] net: stmmac: Add platform level debug register dump feature
Date:   Mon, 29 Nov 2021 01:28:54 +0530
Message-Id: <20211128195854.257486-1-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dwmac-qcom-ethqos currently exposes a mechanism to dump rgmii registers
after the 'stmmac_dvr_probe()' returns. However with commit
5ec55823438e ("net: stmmac: add clocks management for gmac driver"),
we now let 'pm_runtime_put()' disable the clocks before returning from
'stmmac_dvr_probe()'.

This causes a crash when 'rgmii_dump()' register dumps are enabled,
as the clocks are already off.

Since other dwmac drivers (possible future users as well) might
require a similar register dump feature, introduce a platform level
callback to allow the same.

This fixes the crash noticed while enabling rgmii_dump() dumps in
dwmac-qcom-ethqos driver as well. It also allows future changes
to keep a invoking the register dump callback from the correct
place inside 'stmmac_dvr_probe()'.

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
Cc: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 7 ++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       | 3 +++
 include/linux/stmmac.h                                  | 1 +
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 8fea48e477e6..2ffa0a11eea5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -113,8 +113,10 @@ static void rgmii_updatel(struct qcom_ethqos *ethqos,
 	rgmii_writel(ethqos, temp, offset);
 }
 
-static void rgmii_dump(struct qcom_ethqos *ethqos)
+static void rgmii_dump(void *priv)
 {
+	struct qcom_ethqos *ethqos = priv;
+
 	dev_dbg(&ethqos->pdev->dev, "Rgmii register dump\n");
 	dev_dbg(&ethqos->pdev->dev, "RGMII_IO_MACRO_CONFIG: %x\n",
 		rgmii_readl(ethqos, RGMII_IO_MACRO_CONFIG));
@@ -519,6 +521,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 
 	plat_dat->bsp_priv = ethqos;
 	plat_dat->fix_mac_speed = ethqos_fix_mac_speed;
+	plat_dat->dump_debug_regs = rgmii_dump;
 	plat_dat->has_gmac4 = 1;
 	plat_dat->pmt = 1;
 	plat_dat->tso_en = of_property_read_bool(np, "snps,tso");
@@ -527,8 +530,6 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clk;
 
-	rgmii_dump(ethqos);
-
 	return ret;
 
 err_clk:
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 89a6c35e2546..cc1075c08996 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7211,6 +7211,9 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_init_fs(ndev);
 #endif
 
+	if (priv->plat->dump_debug_regs)
+		priv->plat->dump_debug_regs(priv->plat->bsp_priv);
+
 	/* Let pm_runtime_put() disable the clocks.
 	 * If CONFIG_PM is not enabled, the clocks will stay powered.
 	 */
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 89b8e208cd7b..24eea1b05ca2 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -233,6 +233,7 @@ struct plat_stmmacenet_data {
 	int (*clks_config)(void *priv, bool enabled);
 	int (*crosststamp)(ktime_t *device, struct system_counterval_t *system,
 			   void *ctx);
+	void (*dump_debug_regs)(void *priv);
 	void *bsp_priv;
 	struct clk *stmmac_clk;
 	struct clk *pclk;
-- 
2.31.1

