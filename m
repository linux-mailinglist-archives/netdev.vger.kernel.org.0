Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86B9677CA9
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 14:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbjAWNij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 08:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbjAWNig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 08:38:36 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B5C14E83
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 05:38:31 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id mp20so30483893ejc.7
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 05:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AK+/wzvr19IkadKcShT9VhU2Wbb6mjo7zPwMi9XuUSc=;
        b=nOUDGDEoCFHwdDvtbNtP91LAZ1Vjbqx5L4W/oFL4lsEwsdgirSvgMemgaA+2aP8DRr
         0n/aF4rjdDEwJwGdCT2tmJYoNJElxtTTaIfjC6Jr+Up+0Ty294B8zRFOagBqLrvwmt83
         DvTVOvrrU9FXdYJZNH3blaD1oGtDp2qQwrznx2f8dcr6LFGoatDyi+S4lnBF5iVu4nwp
         /ckbqKxbn4ELWFD2wmPRc4faakVo0o1z225Pt9ntBHwO/+Fm4m32eG6VKAsSUVVHEkx9
         DdgQ0tPja+F4idUUtvZVqmeNG7LHqBnokB0jwxJ/Tf8Q+8OYPcUbKIMFUFTRS0h39imf
         nUPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AK+/wzvr19IkadKcShT9VhU2Wbb6mjo7zPwMi9XuUSc=;
        b=DGbuIK5jmJOccm004xC4yIB5YpRtikEBgQ9d/+vaf6shtv98WIuy0Rlgi4Tm/tCmjv
         MKQi3/DlmKer7ji+T/M2zdn3fSVEoG+P8f+6SvZTNZj/T7n1ivvNypbaeLbKFgSxj+ft
         zwKvNLLHtnVJXkEEZl8qCpI/TzbJF/d8cRzAr4CEU/hvWgf2DshGhOozsOnMcBgZhAsh
         JjRBhzvJ1hKoDDlAhpeU5VhHKWmD4KSYtY4K/jbDXttGo1cPzsKMmig/BeDCXWaHBE9H
         tiDPc0zLNSdt4z7lEI7/VeiQNcw7aDinwDNe+k2AKs87totxhbF5fEljn12XtBoRanqE
         6I3g==
X-Gm-Message-State: AFqh2kp+TvyFsEdHrL8H8Wqryaj1b3h9Wd1xYUbpgatBjON5Tl6/2On8
        RaKaJFeSmETi/NPFqNDHTSHmzA==
X-Google-Smtp-Source: AMrXdXsuCu/CpLRug9+eoQ9tuAnNu0+lxPYf7lVb2TpwPEvPc5j/TURtpfbkmGLKqbjxJsHxsQ5JNQ==
X-Received: by 2002:a17:907:a07b:b0:7c1:3f04:efa2 with SMTP id ia27-20020a170907a07b00b007c13f04efa2mr37544023ejc.29.1674481109546;
        Mon, 23 Jan 2023 05:38:29 -0800 (PST)
Received: from Lat-5310.dev.rtsoft.ru ([87.116.163.233])
        by smtp.gmail.com with ESMTPSA id s1-20020aa7cb01000000b00463b9d47e1fsm21502050edt.71.2023.01.23.05.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 05:38:29 -0800 (PST)
From:   Andrey Konovalov <andrey.konovalov@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Andrey Konovalov <andrey.konovalov@linaro.org>
Subject: [PATCH 2/2] net: stmmac: consider snps,rx-clk-runs-in-lpi DT parameter
Date:   Mon, 23 Jan 2023 16:37:47 +0300
Message-Id: <20230123133747.18896-3-andrey.konovalov@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230123133747.18896-1-andrey.konovalov@linaro.org>
References: <20230123133747.18896-1-andrey.konovalov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If snps,rx-clk-runs-in-lpi parameter is present in the device tree, the
driver configures the PHY not to stop RX_CLK after entering Rx LPI state.

Signed-off-by: Andrey Konovalov <andrey.konovalov@linaro.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 3 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 3 +++
 include/linux/stmmac.h                                | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

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
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index eb6d9cd8e93f..4dacda387fa4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -468,6 +468,9 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	plat->en_tx_lpi_clockgating =
 		of_property_read_bool(np, "snps,en-tx-lpi-clockgating");
 
+	plat->rx_clk_runs_in_lpi =
+		of_property_read_bool(np, "snps,rx-clk-runs-in-lpi");
+
 	/* Set the maxmtu to a default of JUMBO_LEN in case the
 	 * parameter is not present in the device tree.
 	 */
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

