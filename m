Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C466E67D7D3
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 22:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbjAZVgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 16:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjAZVgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 16:36:12 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F8F5587
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 13:36:10 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id hw16so8680724ejc.10
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 13:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WUoBTYLOr108fyfxD4wyJMAOsefZoDsyGTAdmy/lBCE=;
        b=b2fcFkM1YxdUWa/ELImacpa70REr0lAWiptZA+OMDpGJeO4fIcgrSzGWnK475HSo9b
         BbAAwGKLhbQyycV2dC/mGs+6+WJ+GasIvz9snUSgLvKjC5iqARo3MBpOGbJtdiGKBbnH
         FzTtgOf1O8hpYl91GZINbTkw1Xobkym9DMqmrFEeLHWKk3dx9KiCrUzMbHY+xJFqteR6
         WHdTK3sdbnQ3R+jABiseBIHAiu/I0W7l/csoZnAme32DJigf6cLlv0PLxrJber6TfLgA
         ne56+sWfx0jOBPCYhTyJBltyyih0wEfWaUFDxfnQnNBxgXpknCLzPyzQg3yTVHBkeku6
         2e8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WUoBTYLOr108fyfxD4wyJMAOsefZoDsyGTAdmy/lBCE=;
        b=u8GG1bQp6aXVr2DN9gtyQSjWzRKMDJEAJ9Ssp5NtvGj2JnjKoQLu93bJHYkCXNXSQD
         QijQ9f0y/2axMCSR1cZy5L2Ic8vBawGmjcwtuLAT/dKg+4i2UYBhx5NWjvLLMR1GTa2z
         Pfnw7JThqpWATceSh9ZnaFUbUnTSWuV66Vyfp0WM5qlS2NCuFxL/sFU5OVcYkNa6ZEPn
         oTsOecMsd71XNWLGJqiQma2WaEtcm35hdiuq4mUwjQYHuq/QQIVQNCMQRXHn8KZFnBkU
         P3VnSHSw/TW81/dFLpv4aaXHOsrlzTH/vVCxCFmH/BUlFstobxaIF+Q33XK4Pid344oJ
         FznA==
X-Gm-Message-State: AFqh2krPE0IXoOWqwZYmCkv7t3OT0cm/nB8ZBtaw/MSE2RZUHelAj/G6
        bct1El/oiOKZb+m6ikuIDIR49A==
X-Google-Smtp-Source: AMrXdXuEM+4fnv0ZhybLPelstCQ+jeWMOqiAT1+pZYf980zA1g3Ur+9wz6z7+YC4nh7CjrWRqxMcrw==
X-Received: by 2002:a17:907:2106:b0:871:c2e4:2e94 with SMTP id qn6-20020a170907210600b00871c2e42e94mr37184416ejb.2.1674768969356;
        Thu, 26 Jan 2023 13:36:09 -0800 (PST)
Received: from Lat-5310.. ([87.116.162.186])
        by smtp.gmail.com with ESMTPSA id gy4-20020a170906f24400b0083ffb81f01esm1148486ejb.136.2023.01.26.13.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 13:36:09 -0800 (PST)
From:   Andrey Konovalov <andrey.konovalov@linaro.org>
To:     vkoul@kernel.org, bhupesh.sharma@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        andrew@lunn.ch, robh@kernel.org, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrey Konovalov <andrey.konovalov@linaro.org>
Subject: [PATCH 1/1] net: stmmac: do not stop RX_CLK in Rx LPI state for qcs404 SoC
Date:   Fri, 27 Jan 2023 00:35:39 +0300
Message-Id: <20230126213539.166298-2-andrey.konovalov@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126213539.166298-1-andrey.konovalov@linaro.org>
References: <20230126213539.166298-1-andrey.konovalov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently in phy_init_eee() the driver unconditionally configures the PHY
to stop RX_CLK after entering Rx LPI state. This causes an LPI interrupt
storm on my qcs404-base board.

Change the PHY initialization so that for "qcom,qcs404-ethqos" compatible
device RX_CLK continues to run even in Rx LPI state.

Signed-off-by: Andrey Konovalov <andrey.konovalov@linaro.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       | 3 ++-
 include/linux/stmmac.h                                  | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 835caa15d55f..732774645c1a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -560,6 +560,8 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	plat_dat->has_gmac4 = 1;
 	plat_dat->pmt = 1;
 	plat_dat->tso_en = of_property_read_bool(np, "snps,tso");
+	if (of_device_is_compatible(np, "qcom,qcs404-ethqos"))
+		plat_dat->rx_clk_runs_in_lpi = 1;
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b7e5af58ab75..1a5b8dab5e9b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1080,7 +1080,8 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 
 	stmmac_mac_set(priv, priv->ioaddr, true);
 	if (phy && priv->dma_cap.eee) {
-		priv->eee_active = phy_init_eee(phy, 1) >= 0;
+		priv->eee_active =
+			phy_init_eee(phy, !priv->plat->rx_clk_runs_in_lpi) >= 0;
 		priv->eee_enabled = stmmac_eee_init(priv);
 		priv->tx_lpi_enabled = priv->eee_enabled;
 		stmmac_set_eee_pls(priv, priv->hw, true);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 83ca2e8eb6b5..a152678b82b7 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -252,6 +252,7 @@ struct plat_stmmacenet_data {
 	int rss_en;
 	int mac_port_sel_speed;
 	bool en_tx_lpi_clockgating;
+	bool rx_clk_runs_in_lpi;
 	int has_xgmac;
 	bool vlan_fail_q_en;
 	u8 vlan_fail_q;
-- 
2.34.1

