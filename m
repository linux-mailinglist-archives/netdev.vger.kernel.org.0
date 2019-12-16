Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3FB3121F0B
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 00:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfLPXjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 18:39:05 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40245 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfLPXjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 18:39:05 -0500
Received: by mail-pg1-f196.google.com with SMTP id k25so4596074pgt.7
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 15:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vtiUF2R4nLFGpcZV5dE5COGpSCsCjWNrY8Qi0zrwNEM=;
        b=lQ7srfG4/S2tq8Qu3tHcbo9h1rJ/mKeY8ScCl99UHPGFHELe7tU0ORv3rb10vmkrnV
         yAoXHT1dD6wijopSb1YXFA3Fa6fVIZtuwEREELUbhXeRqDRM135mfjZyyfEN5L5LKFPN
         BdhNXC7vsTkfaFXPBNfnXqB8LsNY5pxiU6T9JjEx3ZCcdraQHaa9O+SKfA4B4Ysc38qy
         JUOcmkmwiP9VrvH74emeKc4GuZQe1DHhYSZ21a4fxSmNHRKGRE83lHeNKi7omIvaW3v6
         gS4Myb4zqOSN8r5qDw5n017KOLhGc0DwKG88Uv6SeKGXmy7NYUjfza2pRSXEQPoT43li
         De6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vtiUF2R4nLFGpcZV5dE5COGpSCsCjWNrY8Qi0zrwNEM=;
        b=SRlUtbWsAucQmBmfBQueox9PW9/l0/8MGQLh3NuYeQ1YoD12y9yfW31PzBIDYki+OJ
         VuUEYVvnEc+ZwWN/m2LG+5Gq7X/nKi8o0Qruf/N3porPswy9FSUBOlRSt+Q88huJ8rto
         botREq0ZyjtqjnQ8Y8F/uwCUOzmli8AsD+0ifSItTmIWqKUtRUhBi+vNQmkSWL44vojK
         r9G9ngoB6hhMvnUMMdSpQaK2txmbBf4YhNpECnEQ123MYq5aKUX5lhEU5klwXMQ1LwI5
         n4nQq2n/w9d7g/xfqXPKcM94yTjTjBS/lz/5l3n3iU+srUNVLnEtdGOLHPxKhjNlwNnn
         4VUw==
X-Gm-Message-State: APjAAAUBA6X3Xt3KLaW5vMM36ynarITjC5xQTG628/cRvf/pMyDVKJZf
        FzuM6CRRO3yLNykHd+zLyc0=
X-Google-Smtp-Source: APXvYqxAolM4qi5rVvf9yutpvGuMVkAswG7wqVP7mNYxjW3d+r+YpyPIhuD8/LbeaKGbuIU0z5Gg4Q==
X-Received: by 2002:a63:4f64:: with SMTP id p36mr22489142pgl.271.1576539544226;
        Mon, 16 Dec 2019 15:39:04 -0800 (PST)
Received: from ajayg.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id k12sm23105146pgm.65.2019.12.16.15.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 15:39:03 -0800 (PST)
From:   Ajay Gupta <ajaykuee@gmail.com>
X-Google-Original-From: Ajay Gupta <ajayg@nvidia.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, treding@nvidia.com,
        Ajay Gupta <ajayg@nvidia.com>
Subject: [PATCH v3 1/2] net: stmmac: dwc-qos: use generic device api
Date:   Sun, 15 Dec 2019 22:14:51 -0800
Message-Id: <20191216061452.6514-2-ajayg@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191216061452.6514-1-ajayg@nvidia.com>
References: <20191216061452.6514-1-ajayg@nvidia.com>
X-NVConfidentiality: public
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ajay Gupta <ajayg@nvidia.com>

Use generic device api so that driver can work both with DT
or ACPI based devices.

Signed-off-by: Ajay Gupta <ajayg@nvidia.com>
---
Change from v2->v3: None

 .../stmicro/stmmac/dwmac-dwc-qos-eth.c        | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index dd9967aeda22..f87306b3cdae 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -40,7 +40,7 @@ struct tegra_eqos {
 static int dwc_eth_dwmac_config_dt(struct platform_device *pdev,
 				   struct plat_stmmacenet_data *plat_dat)
 {
-	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
 	u32 burst_map = 0;
 	u32 bit_index = 0;
 	u32 a_index = 0;
@@ -52,9 +52,10 @@ static int dwc_eth_dwmac_config_dt(struct platform_device *pdev,
 			return -ENOMEM;
 	}
 
-	plat_dat->axi->axi_lpi_en = of_property_read_bool(np, "snps,en-lpi");
-	if (of_property_read_u32(np, "snps,write-requests",
-				 &plat_dat->axi->axi_wr_osr_lmt)) {
+	plat_dat->axi->axi_lpi_en = device_property_read_bool(dev,
+							      "snps,en-lpi");
+	if (device_property_read_u32(dev, "snps,write-requests",
+				     &plat_dat->axi->axi_wr_osr_lmt)) {
 		/**
 		 * Since the register has a reset value of 1, if property
 		 * is missing, default to 1.
@@ -68,8 +69,8 @@ static int dwc_eth_dwmac_config_dt(struct platform_device *pdev,
 		plat_dat->axi->axi_wr_osr_lmt--;
 	}
 
-	if (of_property_read_u32(np, "snps,read-requests",
-				 &plat_dat->axi->axi_rd_osr_lmt)) {
+	if (device_property_read_u32(dev, "snps,read-requests",
+				     &plat_dat->axi->axi_rd_osr_lmt)) {
 		/**
 		 * Since the register has a reset value of 1, if property
 		 * is missing, default to 1.
@@ -82,7 +83,7 @@ static int dwc_eth_dwmac_config_dt(struct platform_device *pdev,
 		 */
 		plat_dat->axi->axi_rd_osr_lmt--;
 	}
-	of_property_read_u32(np, "snps,burst-map", &burst_map);
+	device_property_read_u32(dev, "snps,burst-map", &burst_map);
 
 	/* converts burst-map bitmask to burst array */
 	for (bit_index = 0; bit_index < 7; bit_index++) {
@@ -421,7 +422,7 @@ static int dwc_eth_dwmac_probe(struct platform_device *pdev)
 	void *priv;
 	int ret;
 
-	data = of_device_get_match_data(&pdev->dev);
+	data = device_get_match_data(&pdev->dev);
 
 	memset(&stmmac_res, 0, sizeof(struct stmmac_resources));
 
@@ -478,7 +479,7 @@ static int dwc_eth_dwmac_remove(struct platform_device *pdev)
 	const struct dwc_eth_dwmac_data *data;
 	int err;
 
-	data = of_device_get_match_data(&pdev->dev);
+	data = device_get_match_data(&pdev->dev);
 
 	err = stmmac_dvr_remove(&pdev->dev);
 	if (err < 0)
-- 
2.17.1

