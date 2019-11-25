Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 355D410954B
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 22:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbfKYV4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 16:56:02 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34153 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfKYV4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 16:56:02 -0500
Received: by mail-pf1-f194.google.com with SMTP id n13so8060067pff.1
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 13:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nXWy+CNs2BYT5YZ0fLgkzFUSLD7ZdPj61CxlqOKpTC4=;
        b=fxFuCzXIp9lR6KUgL44shS7S77HPT307jwJsaTY2hsDuHzgZ8Hes5RHH5NJYnMWESa
         pv2ANI4RokOEXXyfs9w+9wsWtl2u397kxYsNEuvOpNQBtFu67cCjBBljtd6Jbimf4VaA
         0FKJ2e0E3WMjia95CPwrBgdey2tdqE1YIAzzT5HVNb3JCcDHROs67h9tHMfta2OrMNzu
         FeyczQgYt5DF71+n1n1LW9NZ4uSiAdLbydrEz1MPBiksTQzmhqWXAFlxh+bEjO3LUqAB
         pM+b23sHYdD6oGC73DXAgHimV20MlAcTslEEVz1SMVLyZwMSq4CKCYiq4meZHahk7hjx
         uC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nXWy+CNs2BYT5YZ0fLgkzFUSLD7ZdPj61CxlqOKpTC4=;
        b=Cpvqtz/qGxKBPANSHU3a5+eZsN64ZjQfe99tVW3fZ/F4mgtSYKowL+u8hsOI6Spmc2
         GlEH2ShWgy147JgD0tUirLV0Yi1OtEbGGcOe2m9NBLWykcZ2kmdSF18uvrQJFwnfg4Ac
         UVq2KTetKYlriHnV8xqUWk9ANqPMyzaCM0B+xQ+jSRUg1zQ3mKXVZqp7pQ/AkBJOhXix
         l9hxwhyuPgvwyH8DPafYppBun38uqR7F5CvqHbLu95bhCileNVmHQGJz8XB5KRC85VUM
         dACfjMu7iDagvNbnCQ7jPk2pBLJaiP8LGhoCle1Q0KB0T68hYm1DHjnSHyzvi/1gMQgz
         yoJQ==
X-Gm-Message-State: APjAAAW7sR7GyFfJHMsJwRBVK1IKBonPe7U7EV50EjOY4HfLJUiHF7dh
        PTps8oNWcNjCgLUKytwO6+k=
X-Google-Smtp-Source: APXvYqyXmHQp3vP5AYesI3ERzTxcWo4i1u7vDNoQBMNC6pxDuEhpRmDX0UNTrj7HI8BWI7aAjHepIg==
X-Received: by 2002:a63:c0a:: with SMTP id b10mr35830370pgl.168.1574718961187;
        Mon, 25 Nov 2019 13:56:01 -0800 (PST)
Received: from ajayg.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id y12sm366567pjy.0.2019.11.25.13.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 13:56:00 -0800 (PST)
From:   Ajay Gupta <ajaykuee@gmail.com>
X-Google-Original-From: Ajay Gupta <ajayg@nvidia.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, treding@nvidia.com,
        Ajay Gupta <ajayg@nvidia.com>
Subject: [PATCH 1/2] net: stmmac: dwc-qos: use generic device api
Date:   Mon, 25 Nov 2019 13:51:14 -0800
Message-Id: <20191125215115.12981-2-ajayg@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191125215115.12981-1-ajayg@nvidia.com>
References: <20191125215115.12981-1-ajayg@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ajay Gupta <ajayg@nvidia.com>

Use generic device api so that driver can work both with DT
or ACPI based devices.

Signed-off-by: Ajay Gupta <ajayg@nvidia.com>
---
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

