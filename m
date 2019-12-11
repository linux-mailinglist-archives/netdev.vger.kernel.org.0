Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C723111C188
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 01:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfLLAfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 19:35:40 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36247 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbfLLAfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 19:35:39 -0500
Received: by mail-pf1-f194.google.com with SMTP id x184so164074pfb.3
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 16:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TEMGRg8FsK2SMemRqg/13VOxOlZeIqwdC8BPqxYwPHk=;
        b=txFe3Klwo+NRdD+4HJzFBXo2ZcDuj8U0yM7YD//9hChspl6FNZwXGeXxcGLo3j6bep
         h6TmHOlT0IvUeDlKRPe9G0VyRtEFZvdu25fLisgwurpUuX+Fo78tKwxPnZEeL/j5pKbg
         BnyQOKh7AYcOGBMdgO50P5KdpvedEeAfG4Lz1NlLDeAB3MTnlcdJQSoytBXEqX6la9P3
         A2lI5JmfzDI3tY1jYvfIpmk0elQAzNlSZfAlo8JNFKAW20GbCzoFgrY8ktM9oZq7wk6l
         w8fK5707gOCAdudCVSOhHfcib3ffNUbL6bJZj+QT3gnr4THUdpjSducj4+CTZZU19beR
         unYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TEMGRg8FsK2SMemRqg/13VOxOlZeIqwdC8BPqxYwPHk=;
        b=WpsteBE/5M6hdhvIpgkPaT7t89nlMZrTw54HWdUBLF+mDw/XYhNJtiFYZID70ZA48l
         +7WmiKG+TIPTCrF/YE0YcZQurSioQ6w8WZK37/FmBTeJg6fCYLBTM9UOaYVr0NtB3/25
         u2q8S7qhl/EDa8WX7ggtcwrrudJjZNqXQIgE9gSUVdtJxgk6ezCXewMPfDBhU3Ty7EGf
         R87IjMG0qQ56Dw92cnPIQh6zFcoSkF1Tp68r3i52+5Cp6hnhOf78TYhEYeo0h4d3TTdo
         0y6aYRIkn9NB2qNJbuDTpdQZFoBeFlVWNdBen+57EMMrjxkpY65q4mEk2xvtNhJTCTLj
         398g==
X-Gm-Message-State: APjAAAVo2xGXQlW6wJGKMHXrL87bXL/sHI8BGnQjuBUHstI8BAAQtngF
        E41/AhJMyMdncY1OO/v0YSksr9WH
X-Google-Smtp-Source: APXvYqy2yeGxonwsNjLkBlX7u6s6aIgaWOLEaMRFVAFkzlr4Jv47NYfAfEaH9HLGr/1KQWM8jX7EoA==
X-Received: by 2002:a63:1a1c:: with SMTP id a28mr7644568pga.374.1576110938572;
        Wed, 11 Dec 2019 16:35:38 -0800 (PST)
Received: from ajayg.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id 11sm3023984pfj.130.2019.12.11.16.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 16:35:38 -0800 (PST)
From:   Ajay Gupta <ajaykuee@gmail.com>
X-Google-Original-From: Ajay Gupta <ajayg@nvidia.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, treding@nvidia.com,
        Ajay Gupta <ajayg@nvidia.com>
Subject: [PATCH v2 1/2] net: stmmac: dwc-qos: use generic device api
Date:   Tue, 10 Dec 2019 23:11:24 -0800
Message-Id: <20191211071125.15610-2-ajayg@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211071125.15610-1-ajayg@nvidia.com>
References: <20191211071125.15610-1-ajayg@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ajay Gupta <ajayg@nvidia.com>

Use generic device api so that driver can work both with DT
or ACPI based devices.

Signed-off-by: Ajay Gupta <ajayg@nvidia.com>
---
Change from v1->v2: Rebased.

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

