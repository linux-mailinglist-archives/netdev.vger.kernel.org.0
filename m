Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D2F45455B
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 12:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236647AbhKQLIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 06:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbhKQLIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 06:08:51 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A23C061746
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 03:05:53 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 200so1947354pga.1
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 03:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uAoFzagV7gWXAixrMiTySrbSBzXa2SFBHBG+ypqEFjI=;
        b=kBoTNJL92pUfigY0UCb+uuH3lxTq0/UryseOdWAsdO+6uRoC4WBg9kCYHX+uQynEK8
         HSLeoxHQ1mU8ouZAVPP0ndHIzMiCJJ/p8kl8WSrBrF/vDFN9Vx/hduAkVzFJYicr3ojl
         XyAAx9AIpSMqU3osiFu9DhLqsz0ojKglsBjN01mXdyhsRL23BcukhatIjcVE2ZSMnMs0
         THwgh2XVAsPtHFodwCa8tAthOPMgg3Tctv0QHXmncZ+FwaMvj3n5tJanQortURL1nuEs
         3MFd5AeBLyTCXK7lJhG8GTQwgs/8ktfJAQqiXNCtWpO98vR8h9EQaWWdp7IoiBjS0YlP
         L4ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uAoFzagV7gWXAixrMiTySrbSBzXa2SFBHBG+ypqEFjI=;
        b=oNBFbPtpUJYLE3QdrzDM5FEgg+A7BFSqByOm6KVMisp4pf5t3KdT2HzEQZX7NMDT2x
         S95p5/vuj0Nf8jmTDhuzME9LyTOBlpGitq1HCMsv+RRCbZEDSXaQtB/yXFKTLgBHOiEG
         fKgUx+L+awWCgSK9dvY9barlkUkQ4Ezp6VdHRzD+VXkCI00/fZiXz6g4UkfZuQqDpREF
         ZwkLtXxKOOr6roRVsVkci7UAfSbCk6/0L1h+bguZwweDE7lrQSkLh5YTpVYjnCeXvNPn
         1UVyWNaWAhFAiVLVnAyeTujPtIvki3UfXh0eoWYR2rvLeJJJvZJ+L7WAUHPq8EQVopr3
         IraA==
X-Gm-Message-State: AOAM530ioSLRxH3kDjJE8dQMM3HyR2NeG8URi/AepS4szQmgIU8yME1N
        RWEYUsgR3Kyy7jSkYi2u6NgT9UIWlrMYgA==
X-Google-Smtp-Source: ABdhPJxlwNDhZaoL0pZXHiFAOaEf2U5hfBagTMYxieA1/2Vzl6q+2mKoWYonIDKXlk903PFtUWI9iw==
X-Received: by 2002:aa7:96b7:0:b0:49f:df90:e4ae with SMTP id g23-20020aa796b7000000b0049fdf90e4aemr47563610pfk.24.1637147152387;
        Wed, 17 Nov 2021 03:05:52 -0800 (PST)
Received: from localhost.localdomain.name ([122.161.53.25])
        by smtp.gmail.com with ESMTPSA id j1sm6339510pfu.47.2021.11.17.03.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 03:05:51 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     netdev@vger.kernel.org
Cc:     vkoul@kernel.org, bhupesh.sharma@linaro.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next] net: stmmac: dwmac-qcom-ethqos: add platform level clocks management
Date:   Wed, 17 Nov 2021 16:35:38 +0530
Message-Id: <20211117110538.204948-1-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split clocks settings from init callback into clks_config callback,
which could support platform level clock management.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 26 ++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 5c74b6279d69..8fea48e477e6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -447,6 +447,24 @@ static void ethqos_fix_mac_speed(void *priv, unsigned int speed)
 	ethqos_configure(ethqos);
 }
 
+static int ethqos_clks_config(void *priv, bool enabled)
+{
+	struct qcom_ethqos *ethqos = priv;
+	int ret = 0;
+
+	if (enabled) {
+		ret = clk_prepare_enable(ethqos->rgmii_clk);
+		if (ret) {
+			dev_err(&ethqos->pdev->dev, "rgmii_clk enable failed\n");
+			return ret;
+		}
+	} else {
+		clk_disable_unprepare(ethqos->rgmii_clk);
+	}
+
+	return ret;
+}
+
 static int qcom_ethqos_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -466,6 +484,8 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 		return PTR_ERR(plat_dat);
 	}
 
+	plat_dat->clks_config = ethqos_clks_config;
+
 	ethqos = devm_kzalloc(&pdev->dev, sizeof(*ethqos), GFP_KERNEL);
 	if (!ethqos) {
 		ret = -ENOMEM;
@@ -489,7 +509,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 		goto err_mem;
 	}
 
-	ret = clk_prepare_enable(ethqos->rgmii_clk);
+	ret = ethqos_clks_config(ethqos, true);
 	if (ret)
 		goto err_mem;
 
@@ -512,7 +532,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	return ret;
 
 err_clk:
-	clk_disable_unprepare(ethqos->rgmii_clk);
+	ethqos_clks_config(ethqos, false);
 
 err_mem:
 	stmmac_remove_config_dt(pdev, plat_dat);
@@ -530,7 +550,7 @@ static int qcom_ethqos_remove(struct platform_device *pdev)
 		return -ENODEV;
 
 	ret = stmmac_pltfr_remove(pdev);
-	clk_disable_unprepare(ethqos->rgmii_clk);
+	ethqos_clks_config(ethqos, false);
 
 	return ret;
 }
-- 
2.31.1

