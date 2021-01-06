Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886612EBEFD
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbhAFNo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727250AbhAFNoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:44:54 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493F7C061359;
        Wed,  6 Jan 2021 05:44:14 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id g185so2679513wmf.3;
        Wed, 06 Jan 2021 05:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FTb+k2pRqhgJlqYGQ9koQKDY3V9IU7jTeMtH7IVE2Bk=;
        b=n2TlifdC0IdbJLoIs4dTjj0jRQ4cbC30Lz+YEpD5BRktRZBozXm0LR77dT7ETmJKo3
         qgrqFWVsLJwrt3JFkUX95BKbMMhhZpY8sopzP4ioWUN7FdQ/vhTHgyBeihI9Li2zVcZO
         zeSojbY7pDoiMFsAN347TmT6jMwT74EaN4O2VZq9pmJjUOPfkShdmijvoh1F/YwbjNQE
         LHggTy8bCIrOpaS+p7lBByPYcTRnNRkLdIE5vlJ+LEpq2WG+a2vBRvmofNrlVbS9B001
         sXMRrJlKsFUqd84ZAjcEpyaGx+Tq/uTokFpZiGQ/5/QkcsvJeixcCFpG9x4Ny7xGkD9r
         EPQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FTb+k2pRqhgJlqYGQ9koQKDY3V9IU7jTeMtH7IVE2Bk=;
        b=iEzQ9xMfQsJ5vhEtodMjLEa9R7sCI1n3QA2Ms5dcK0D6JAH3a3CSbwp9ZyfuwSaJkZ
         AfKOLs7D0NaqKEisdR2IgwhsBuoVyXDMqVxagW/m22mSSFqeyCT7xJXyudoEE1slELt3
         tZvdUJCGzXZ2fnFl8ux0rxQkfKZzn8O5RmUdbsCHtNxN0wMiyeOqZaHPh2IXSql46UHs
         L5RDgMjf7OH50HwMBd8nOSml7Gu47feQcuUfkxXzuuDKON636RDVCSG0dzjBLSnmaHer
         ArZj9CmlRGOPFXABZY+H3aygHb7Mq1sORXKOEZFhGRygSd6dOI/e5NtsyGpW92g+lXDR
         WOgQ==
X-Gm-Message-State: AOAM533OLS9/wVM5/03tihxOhjDM0q2FyVzKA3U5Rf1T6zBy8VI+ezsB
        YGRI+fqqns3kP4x9PhwEf3I=
X-Google-Smtp-Source: ABdhPJwsoNEaPfjZGRdpC54PCzOi6QGvWRIaR6aeXW2oARQpd1ka443VCGJkklLWft9gGAxSNQ9+1A==
X-Received: by 2002:a1c:3d55:: with SMTP id k82mr3683525wma.57.1609940653005;
        Wed, 06 Jan 2021 05:44:13 -0800 (PST)
Received: from localhost.localdomain (p200300f13711ec00428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3711:ec00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id f14sm3085351wme.14.2021.01.06.05.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 05:44:12 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, jianxin.pan@amlogic.com,
        narmstrong@baylibre.com, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jbrunet@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v4 3/5] net: stmmac: dwmac-meson8b: use picoseconds for the RGMII RX delay
Date:   Wed,  6 Jan 2021 14:42:49 +0100
Message-Id: <20210106134251.45264-4-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210106134251.45264-1-martin.blumenstingl@googlemail.com>
References: <20210106134251.45264-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amlogic Meson G12A, G12B and SM1 SoCs have a more advanced RGMII RX
delay register which allows picoseconds precision. Parse the new
"rx-internal-delay-ps" property or fall back to the value from the old
"amlogic,rx-delay-ns" property.

No upstream DTB uses the old "amlogic,rx-delay-ns" property (yet).
Only include minimalistic logic to fall back to the old property,
without any special validation (for example if the old and new
property are given at the same time).

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 5f500141567d..d2be3a7bd8fd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -82,7 +82,7 @@ struct meson8b_dwmac {
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
@@ -406,14 +406,19 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 				 &dwmac->tx_delay_ns))
 		dwmac->tx_delay_ns = 2;
 
-	/* use 0ns as fallback since this is what most boards actually use */
-	if (of_property_read_u32(pdev->dev.of_node, "amlogic,rx-delay-ns",
-				 &dwmac->rx_delay_ns))
-		dwmac->rx_delay_ns = 0;
+	/* RX delay defaults to 0ps since this is what many boards use */
+	if (of_property_read_u32(pdev->dev.of_node, "rx-internal-delay-ps",
+				 &dwmac->rx_delay_ps)) {
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
2.30.0

