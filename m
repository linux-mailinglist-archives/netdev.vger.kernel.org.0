Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2776C2E22BE
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 00:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgLWXbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 18:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728058AbgLWXbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 18:31:23 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43209C061285;
        Wed, 23 Dec 2020 15:30:43 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id d26so658878wrb.12;
        Wed, 23 Dec 2020 15:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f2WQaMRGYRvLKx65rkROdWii2KWvF+WGltfYLQ57NGQ=;
        b=QSv1e9WF7GSxZt9mnrrAvF7gQn3O0JKgqiTyPv/zAOaudfr8twgASyQjxnm0ZEOlPL
         7X+j5zelIV+zAMHombxgdIx0cz+h4y3A9EeYMbtycKHaFkfQEWd99CR6IqIcE+mxB4vI
         OzZ2pI9oYClu6SH+Q8Dfnzd1i8ChTqh5LatufaWDJOtXM5D6ZKuPaUW4v8X7GpvViIvh
         qPQtSLmTwT47sVlp9UT3Q6cT6Z9CdHPfY+mxFHzlMNWtW764oS0Sy0veHZb22TsUcV3F
         NjwjFYMUJO5j1cqZvE0JEemd5nnTNcOSBpoNKy5l4/hW7ixfwUCOAojUdMvA8Au05S5f
         Rb5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f2WQaMRGYRvLKx65rkROdWii2KWvF+WGltfYLQ57NGQ=;
        b=UcSbVU5qr3FLHyhJuMEyeCs5R7typnLRHbXheSnHzMakX3dQcoqTtt9aWKvGFR5zwU
         o7mo4/ta44lwm92yyPJ7neqUNY2f6uwA00oUru515X6H7smsezDwVrN3lDNH42mQ6VaA
         4cdwJvktmMoJqU8TLA2YTlgGBGGxWzSQZ3KysX73N2J9saoyMg/6i6G7vYJtRBZzwfeb
         1mvxagVoDcXU6h+VP7o+NG3c63A3XcDUr2jrrM/k5UElv5pwnyzJXtNyPwlsVE52C/kD
         IOL+lpUzPW9xt286mZR5n4NZR+v1SUM3+CBxsLofDCGY1rRIWkus18sQUtNQj0U/clSe
         5Gvg==
X-Gm-Message-State: AOAM531wJRxwspuVHIWRNcqdWfAOzzQqnYCukUUr3JOaJ3+EH1GdR5mY
        Mdo4XxmDKFiimeBjWJMfjwCLeCTif1Q=
X-Google-Smtp-Source: ABdhPJyXg+0G0zvWfJSELdbAeiB/10K8VeSYCmqu14DVPFBA1rwpwToeCJYVfALVDCMCXE16BXIQSA==
X-Received: by 2002:adf:82c5:: with SMTP id 63mr31797641wrc.38.1608766241992;
        Wed, 23 Dec 2020 15:30:41 -0800 (PST)
Received: from localhost.localdomain (p200300f1371a0900428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:371a:900:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id l16sm37926657wrx.5.2020.12.23.15.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 15:30:41 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, jianxin.pan@amlogic.com,
        narmstrong@baylibre.com, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jbrunet@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 4/5] net: stmmac: dwmac-meson8b: move RGMII delays into a separate function
Date:   Thu, 24 Dec 2020 00:29:04 +0100
Message-Id: <20201223232905.2958651-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223232905.2958651-1-martin.blumenstingl@googlemail.com>
References: <20201223232905.2958651-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newer SoCs starting with the Amlogic Meson G12A have more a precise
RGMII RX delay configuration register. This means more complexity in the
code. Extract the existing RGMII delay configuration code into a
separate function to make it easier to read/understand even when adding
more logic in the future.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index d2be3a7bd8fd..4937432ac70d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -268,7 +268,7 @@ static int meson8b_devm_clk_prepare_enable(struct meson8b_dwmac *dwmac,
 	return 0;
 }
 
-static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
+static int meson8b_init_rgmii_delays(struct meson8b_dwmac *dwmac)
 {
 	u32 tx_dly_config, rx_dly_config, delay_config;
 	int ret;
@@ -323,6 +323,13 @@ static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 				PRG_ETH0_ADJ_DELAY | PRG_ETH0_ADJ_SKEW,
 				delay_config);
 
+	return 0;
+}
+
+static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
+{
+	int ret;
+
 	if (phy_interface_mode_is_rgmii(dwmac->phy_mode)) {
 		/* only relevant for RMII mode -> disable in RGMII mode */
 		meson8b_dwmac_mask_bits(dwmac, PRG_ETH0,
@@ -430,6 +437,10 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 		goto err_remove_config_dt;
 	}
 
+	ret = meson8b_init_rgmii_delays(dwmac);
+	if (ret)
+		goto err_remove_config_dt;
+
 	ret = meson8b_init_rgmii_tx_clk(dwmac);
 	if (ret)
 		goto err_remove_config_dt;
-- 
2.29.2

