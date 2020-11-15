Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D5C2B3817
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 19:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbgKOSw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 13:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbgKOSwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 13:52:46 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F06FC0617A6;
        Sun, 15 Nov 2020 10:52:46 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id me8so21309178ejb.10;
        Sun, 15 Nov 2020 10:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rc+TCBVBSzblNUplMn3xZa+XP9vRttWGmvwn+KB8j44=;
        b=uUb32eLXE6XnanpT4p5IX7r1Lb05tCLcen5yRrNhqscFezUpVnTWFrLiCHyvdZmUHt
         6bGRxFPscfGWqVPvM3OAzXKdkDHDs3yddu/n5F0dWOnKxhDIrRrEE/bg0GiwbQ8q3Gdl
         6HzvNy52D6UnuAqetO0hsmtE/cGxKKRk32SNt+pRF8RjpkM4e5Qv42YTlHvgUC44xopL
         GRwG2iUI90uzzV/AAGVQO/5flPh3HeE4dbjNbtKrUuL+z1bpmW87m7fYtNtTeTb5GSAr
         0aTw1BNGSX3tbZ4DhCPwTbRMdUv0WFUNzFPHcjKoK0KAP062iDAYmnv8HgiyZn/Nmq/X
         2o6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rc+TCBVBSzblNUplMn3xZa+XP9vRttWGmvwn+KB8j44=;
        b=hIuXrH5TtMgcUXIe25xusLkIQILFHMBMq1COTGFCc4/hwtzXR315QeThkY3BNrQMp9
         QGgKM7pUlDM0m9764yswRDIOrCdZDQ+pq9mYw+odJLOwNA4VLHHilUlP6/kNrpW2+O3/
         OzqN2QaOj1OqIOa7m8u4O1nw4fIPDGJrk2CyE3N2wQvflWAnJ1byQgyW+o8Ti0bIMl+W
         gCsAEs0BkU5yLqQaaTZR9nrU8DmaLx/RoDAbFKWd2jXgU00hdoAaO8bOyvKfmiYNTWpy
         U881A2szFhTGbciQmiEmuL0pyHYi3ZmosTwArVBcQSmRHmAyNEcwI88/eFwYJ7BUwo+I
         oTvQ==
X-Gm-Message-State: AOAM5303nXhGQrw5/PaJi8nFwf2H7Q8+9vpSKrmRiSs/6w2zSKDPV4Hn
        Tj6hNEmqlkuLMGRXt9uPXuo=
X-Google-Smtp-Source: ABdhPJzhqcc2lVkj8r/6+Dk8UZP7s9/hkAO2i/qZzvAvWn9FF0C+0jVOEu82IgdDAPCXeV3zwsn2ig==
X-Received: by 2002:a17:906:b292:: with SMTP id q18mr11146559ejz.93.1605466365268;
        Sun, 15 Nov 2020 10:52:45 -0800 (PST)
Received: from localhost.localdomain (p4fc3ea77.dip0.t-ipconnect.de. [79.195.234.119])
        by smtp.googlemail.com with ESMTPSA id i13sm9233520ejv.84.2020.11.15.10.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 10:52:44 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, khilman@baylibre.com,
        narmstrong@baylibre.com, jbrunet@baylibre.com, andrew@lunn.ch,
        f.fainelli@gmail.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v2 3/5] net: stmmac: dwmac-meson8b: use picoseconds for the RGMII RX delay
Date:   Sun, 15 Nov 2020 19:52:08 +0100
Message-Id: <20201115185210.573739-4-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
References: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amlogic Meson G12A, G12B and SM1 SoCs have a more advanced RGMII RX
delay register which allows picoseconds precision. Parse the new
"amlogic,rgmii-rx-delay-ps" property or fall back to the old
"amlogic,rx-delay-ns".

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   | 22 ++++++++++++-------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index e27e2e7a53fd..03fce678b9f5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -83,7 +83,7 @@ struct meson8b_dwmac {
 	phy_interface_t			phy_mode;
 	struct clk			*rgmii_tx_clk;
 	u32				tx_delay_ns;
-	u32				rx_delay_ns;
+	u32				rx_delay_ps;
 	struct clk			*timing_adj_clk;
 };
 
@@ -276,7 +276,7 @@ static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 	tx_dly_config = FIELD_PREP(PRG_ETH0_TXDLY_MASK,
 				   dwmac->tx_delay_ns >> 1);
 
-	if (dwmac->rx_delay_ns == 2)
+	if (dwmac->rx_delay_ps == 2000)
 		rx_dly_config = PRG_ETH0_ADJ_ENABLE | PRG_ETH0_ADJ_SETUP;
 	else
 		rx_dly_config = 0;
@@ -406,14 +406,20 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 				 &dwmac->tx_delay_ns))
 		dwmac->tx_delay_ns = 2;
 
-	/* use 0ns as fallback since this is what most boards actually use */
-	if (of_property_read_u32(pdev->dev.of_node, "amlogic,rx-delay-ns",
-				 &dwmac->rx_delay_ns))
-		dwmac->rx_delay_ns = 0;
+	/* RX delay defaults to 0ps since this is what many boards use */
+	if (of_property_read_u32(pdev->dev.of_node,
+				 "amlogic,rgmii-rx-delay-ps",
+				  &dwmac->rx_delay_ps)) {
+		if (!of_property_read_u32(pdev->dev.of_node,
+					  "amlogic,rx-delay-ns",
+					  &dwmac->rx_delay_ps))
+			/* convert ns to ps */
+			dwmac->rx_delay_ps *= 1000;
+	}
 
-	if (dwmac->rx_delay_ns != 0 && dwmac->rx_delay_ns != 2) {
+	if (dwmac->rx_delay_ps != 0 && dwmac->rx_delay_ps != 2000) {
 		dev_err(&pdev->dev,
-			"The only allowed RX delays values are: 0ns, 2ns");
+			"The only allowed RX delays values are: 0ps, 2000ps");
 		ret = -EINVAL;
 		goto err_remove_config_dt;
 	}
-- 
2.29.2

