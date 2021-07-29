Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34A83DAC88
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 22:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhG2UMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 16:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhG2UMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 16:12:00 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3872CC061765;
        Thu, 29 Jul 2021 13:11:56 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so11323981pjd.0;
        Thu, 29 Jul 2021 13:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uFCBpDGM4hFIxc9yi8Eu0cialujSpGXKpLF4MnHX0N4=;
        b=o4j5NmYtOd2b6pXYrmg7YUJhk/ntJ1U45lCUKITehyjndOnUXczd6eaYzoajkza/Dq
         6JmJHdTr3dahediTrHJt7WkawEEXnmo7o0mHt1OMLJ7Icx1CsA9ssknXBPvw/KtA9KKs
         UZHUviyVuD4nVGIu72SAfEwiYGfF6qDKUUD4WXfIArHFFCbdE1p/bDYZlnZFF5mLYS+5
         P/Z6+xx2Rdx+bT/x7S4oGHAs6+FWAz5F79dFDwOY8J+CoqJL//mHSTFz8Xg/YZfxb6Qi
         5Ref+r7ObgYFgExWA9S24uP5m/MhSwEALIPKaDywkjZQtU5jtUmgIoKKMRtGdmQhLA8A
         kovA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uFCBpDGM4hFIxc9yi8Eu0cialujSpGXKpLF4MnHX0N4=;
        b=qtjmiGt2S/+DohxnezWRTXGAaLsw8hdN5bYwPHx0TJlKz3vcoBZT3x3TOw6J88DxhZ
         NqnnXROKOREJNPxGKGkkJW2/RFtJMHRkPl/savJ6O2bl9T7tmE0AP13bJtxMCr5QGyT2
         X6e85vdTP0LOKeIjlxwkvpzL3IqF95vlpcKd1T0TZ8n8p2U8/2QP4qf+aR/PP6nR6VJw
         02/rstuBQp50gnIhzCXMR6woQnGrEszYL76WdzdM5WTt6sd6pAT5bdSIvf2omxS2ZIpQ
         36pyHi4yfxF1L6z0zDtJ+yvyKgI7OtCZkksBchAz9puN+W1K6T0xCuL7gOWPVAlEyl5q
         lofg==
X-Gm-Message-State: AOAM53306utLtL4o08MMekmOfYnoreHA4z3B9sLNSBSOZHHan0Tg3nY/
        A8CJBKZzvaDUD1nV+dQkJPPHBPTSalj3+w==
X-Google-Smtp-Source: ABdhPJwEDY6ObvS9IMV5cadka+41K/yJUlnwQzWz9TVouPF536akBdpkO0DPS1yrDa4svM2C/vlRWQ==
X-Received: by 2002:a17:90b:34e:: with SMTP id fh14mr6956614pjb.100.1627589515588;
        Thu, 29 Jul 2021 13:11:55 -0700 (PDT)
Received: from archl-on1.. ([103.51.72.31])
        by smtp.gmail.com with ESMTPSA id i25sm4581407pfo.20.2021.07.29.13.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 13:11:55 -0700 (PDT)
From:   Anand Moon <linux.amoon@gmail.com>
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        devicetree@vger.kernel.org
Cc:     Anand Moon <linux.amoon@gmail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Emiliano Ingrassia <ingrassia@epigenesys.com>
Subject: [PATCHv1 3/3] net: stmmac: dwmac-meson8b: Add reset controller for ethernet phy
Date:   Fri, 30 Jul 2021 01:40:52 +0530
Message-Id: <20210729201100.3994-4-linux.amoon@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729201100.3994-1-linux.amoon@gmail.com>
References: <20210729201100.3994-1-linux.amoon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add reset controller for Ethernet phy reset on every boot for
Amlogic SoC.

Cc: Jerome Brunet <jbrunet@baylibre.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
---
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index c7a6588d9398..8b3b5e8c2a8a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -17,6 +17,7 @@
 #include <linux/of_net.h>
 #include <linux/mfd/syscon.h>
 #include <linux/platform_device.h>
+#include <linux/reset.h>
 #include <linux/stmmac.h>
 
 #include "stmmac_platform.h"
@@ -95,6 +96,7 @@ struct meson8b_dwmac {
 	u32				tx_delay_ns;
 	u32				rx_delay_ps;
 	struct clk			*timing_adj_clk;
+	struct reset_control		*eth_reset;
 };
 
 struct meson8b_dwmac_clk_configs {
@@ -384,6 +386,17 @@ static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 	meson8b_dwmac_mask_bits(dwmac, PRG_ETH0, PRG_ETH0_TX_AND_PHY_REF_CLK,
 				PRG_ETH0_TX_AND_PHY_REF_CLK);
 
+	/* Make sure the Ethernet PHY is properly reseted, as U-Boot may leave
+	 * it at deasserted state, and thus it may fail to reset EMAC.
+	 *
+	 * This assumes the driver has exclusive access to the EPHY reset.
+	 */
+	ret = reset_control_reset(dwmac->eth_reset);
+	if (ret) {
+		dev_err(dwmac->dev, "Cannot reset internal PHY\n");
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -465,6 +478,13 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 		goto err_remove_config_dt;
 	}
 
+	dwmac->eth_reset = devm_reset_control_get_exclusive(dwmac->dev, "ethreset");
+	if (IS_ERR_OR_NULL(dwmac->eth_reset)) {
+		dev_err(dwmac->dev, "Failed to get Ethernet reset\n");
+		ret = PTR_ERR(dwmac->eth_reset);
+		goto err_remove_config_dt;
+	}
+
 	ret = meson8b_init_rgmii_delays(dwmac);
 	if (ret)
 		goto err_remove_config_dt;
-- 
2.32.0

