Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150EA5A436B
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 08:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiH2GyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 02:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiH2GyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 02:54:08 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D1446D89
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 23:54:01 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id w13so6888039pgq.7
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 23:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edgeble-ai.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=u6R40n8MPoARVm3Mtks2apAeDMP4MZtDTuXM3b5bDPA=;
        b=eWHaczqLrzgoEHImGmPZ94RG4Z6HNHjYySRyrtbvt+VMSj9GgY04Dxl3peOnUMbERM
         T0wxrzo2EvmsBZmntKsbHO/63kZHcX4rpqsUn9G8neYsYGMct3J3ZO3lp6v5WspmCJFV
         iD6CVqTySLQKsoHLzKglTu1dJKce/Jf7/baFS/3t+o1l3siQjN3AjG+dPZAaOfHGwS9V
         E+Zxmy57ACr0LBFW1d2+WUw+CX0eo2CMWE3avHdyWM1+bPrqGX9PDJR/IxYGS3ZlsOY6
         3NgVEEtXpguVkaN4/e8aii685vpB/rr5zZdaGprhqMQU/Z2n3gS81+htckrizvEXgTsa
         4jpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=u6R40n8MPoARVm3Mtks2apAeDMP4MZtDTuXM3b5bDPA=;
        b=X7K5W4i//jVgk+lZufab4Nf+EKOLyAIQ7ngc9k+YnLu0VftFfI/tnuf1oMS4FQo90x
         yqHwVlUlcPMH+kCehzv29+agx69xj6ysHKj36cxNW38ciN0uiQd2BbuqrOpjW1ylZOMg
         wS6g+P6vzrPZ9SdbWrVPVusWAlwGag9qV/IE4yfWuQngNkSlITajdkX7hyn/ePJO7GOG
         hhOVYNFUrg9JiEty/GNK8zAKpeeJnaNYEMfh2mI+DN+N0CWIleQHsW3j/dnBIN66D7LD
         5F2hxwCEpbF8o2wzvvjUI5K/fIqOw/Izr0xuiUeelWw/ugDZbIYmwiirw74k/43U4SE8
         E4Zw==
X-Gm-Message-State: ACgBeo0xh2aqXW04d5REb/HofHwt1pjbZDgq/kiAZWSOjr5ZJ+N2l1TV
        k2SNl+XZHvW1hYxOt3GorOSdZQ==
X-Google-Smtp-Source: AA6agR50cryByjgHlJMx73H+k8NWoxtPwbincNgW2C4keQjTpRA+15aCO/PZwkF3DzqNIeBhukYV9g==
X-Received: by 2002:a63:d00a:0:b0:42a:3d80:10a with SMTP id z10-20020a63d00a000000b0042a3d80010amr12459203pgf.288.1661756040268;
        Sun, 28 Aug 2022 23:54:00 -0700 (PDT)
Received: from archl-hc1b.. ([103.51.72.9])
        by smtp.gmail.com with ESMTPSA id k3-20020aa79d03000000b00537d4a3aec9sm5687314pfp.104.2022.08.28.23.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 23:54:00 -0700 (PDT)
From:   Anand Moon <anand@edgeble.ai>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Sugar Zhang <sugar.zhang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>,
        Jagan Teki <jagan@edgeble.ai>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: ethernet: stmicro: stmmac: dwmac-rk: Add rv1126 support
Date:   Mon, 29 Aug 2022 06:50:42 +0000
Message-Id: <20220829065044.1736-2-anand@edgeble.ai>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829065044.1736-1-anand@edgeble.ai>
References: <20220829065044.1736-1-anand@edgeble.ai>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rockchip RV1126 has GMAC 10/100/1000M ethernet controller
via RGMII and RMII interfaces are configured via M0 and M1 pinmux.

This patch adds rv1126 support by adding delay lines of M0 and M1
simultaneously.

Signed-off-by: Sugar Zhang <sugar.zhang@rock-chips.com>
Signed-off-by: David Wu <david.wu@rock-chips.com>
Signed-off-by: Anand Moon <anand@edgeble.ai>
Signed-off-by: Jagan Teki <jagan@edgeble.ai>
---
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 125 ++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index c469abc91fa1..93be3efb5fff 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1153,6 +1153,130 @@ static const struct rk_gmac_ops rv1108_ops = {
 	.set_rmii_speed = rv1108_set_rmii_speed,
 };
 
+#define RV1126_GRF_GMAC_CON0		0X0070
+#define RV1126_GRF_GMAC_CON1		0X0074
+#define RV1126_GRF_GMAC_CON2		0X0078
+
+/* RV1126_GRF_GMAC_CON0 */
+#define RV1126_GMAC_PHY_INTF_SEL_RGMII	\
+		(GRF_BIT(4) | GRF_CLR_BIT(5) | GRF_CLR_BIT(6))
+#define RV1126_GMAC_PHY_INTF_SEL_RMII	\
+		(GRF_CLR_BIT(4) | GRF_CLR_BIT(5) | GRF_BIT(6))
+#define RV1126_GMAC_FLOW_CTRL			GRF_BIT(7)
+#define RV1126_GMAC_FLOW_CTRL_CLR		GRF_CLR_BIT(7)
+#define RV1126_GMAC_M0_RXCLK_DLY_ENABLE		GRF_BIT(1)
+#define RV1126_GMAC_M0_RXCLK_DLY_DISABLE	GRF_CLR_BIT(1)
+#define RV1126_GMAC_M0_TXCLK_DLY_ENABLE		GRF_BIT(0)
+#define RV1126_GMAC_M0_TXCLK_DLY_DISABLE	GRF_CLR_BIT(0)
+#define RV1126_GMAC_M1_RXCLK_DLY_ENABLE		GRF_BIT(3)
+#define RV1126_GMAC_M1_RXCLK_DLY_DISABLE	GRF_CLR_BIT(3)
+#define RV1126_GMAC_M1_TXCLK_DLY_ENABLE		GRF_BIT(2)
+#define RV1126_GMAC_M1_TXCLK_DLY_DISABLE	GRF_CLR_BIT(2)
+
+/* RV1126_GRF_GMAC_CON1 */
+#define RV1126_GMAC_M0_CLK_RX_DL_CFG(val)	HIWORD_UPDATE(val, 0x7F, 8)
+#define RV1126_GMAC_M0_CLK_TX_DL_CFG(val)	HIWORD_UPDATE(val, 0x7F, 0)
+/* RV1126_GRF_GMAC_CON2 */
+#define RV1126_GMAC_M1_CLK_RX_DL_CFG(val)	HIWORD_UPDATE(val, 0x7F, 8)
+#define RV1126_GMAC_M1_CLK_TX_DL_CFG(val)	HIWORD_UPDATE(val, 0x7F, 0)
+
+static void rv1126_set_to_rgmii(struct rk_priv_data *bsp_priv,
+				int tx_delay, int rx_delay)
+{
+	struct device *dev = &bsp_priv->pdev->dev;
+
+	if (IS_ERR(bsp_priv->grf)) {
+		dev_err(dev, "Missing rockchip,grf property\n");
+		return;
+	}
+
+	regmap_write(bsp_priv->grf, RV1126_GRF_GMAC_CON0,
+		     RV1126_GMAC_PHY_INTF_SEL_RGMII |
+		     RV1126_GMAC_M0_RXCLK_DLY_ENABLE |
+		     RV1126_GMAC_M0_TXCLK_DLY_ENABLE |
+		     RV1126_GMAC_M1_RXCLK_DLY_ENABLE |
+		     RV1126_GMAC_M1_TXCLK_DLY_ENABLE);
+
+	regmap_write(bsp_priv->grf, RV1126_GRF_GMAC_CON1,
+		     RV1126_GMAC_M0_CLK_RX_DL_CFG(rx_delay) |
+		     RV1126_GMAC_M0_CLK_TX_DL_CFG(tx_delay));
+
+	regmap_write(bsp_priv->grf, RV1126_GRF_GMAC_CON2,
+		     RV1126_GMAC_M1_CLK_RX_DL_CFG(rx_delay) |
+		     RV1126_GMAC_M1_CLK_TX_DL_CFG(tx_delay));
+}
+
+static void rv1126_set_to_rmii(struct rk_priv_data *bsp_priv)
+{
+	struct device *dev = &bsp_priv->pdev->dev;
+
+	if (IS_ERR(bsp_priv->grf)) {
+		dev_err(dev, "%s: Missing rockchip,grf property\n", __func__);
+		return;
+	}
+
+	regmap_write(bsp_priv->grf, RV1126_GRF_GMAC_CON0,
+		     RV1126_GMAC_PHY_INTF_SEL_RMII);
+}
+
+static void rv1126_set_rgmii_speed(struct rk_priv_data *bsp_priv, int speed)
+{
+	struct device *dev = &bsp_priv->pdev->dev;
+	unsigned long rate;
+	int ret;
+
+	switch (speed) {
+	case 10:
+		rate = 2500000;
+		break;
+	case 100:
+		rate = 25000000;
+		break;
+	case 1000:
+		rate = 125000000;
+		break;
+	default:
+		dev_err(dev, "unknown speed value for RGMII speed=%d", speed);
+		return;
+	}
+
+	ret = clk_set_rate(bsp_priv->clk_mac_speed, rate);
+	if (ret)
+		dev_err(dev, "%s: set clk_mac_speed rate %ld failed %d\n",
+			__func__, rate, ret);
+}
+
+static void rv1126_set_rmii_speed(struct rk_priv_data *bsp_priv, int speed)
+{
+	struct device *dev = &bsp_priv->pdev->dev;
+	unsigned long rate;
+	int ret;
+
+	switch (speed) {
+	case 10:
+		rate = 2500000;
+		break;
+	case 100:
+		rate = 25000000;
+		break;
+	default:
+		dev_err(dev, "unknown speed value for RGMII speed=%d", speed);
+		return;
+	}
+
+	ret = clk_set_rate(bsp_priv->clk_mac_speed, rate);
+	if (ret)
+		dev_err(dev, "%s: set clk_mac_speed rate %ld failed %d\n",
+			__func__, rate, ret);
+}
+
+static const struct rk_gmac_ops rv1126_ops = {
+	.set_to_rgmii = rv1126_set_to_rgmii,
+	.set_to_rmii = rv1126_set_to_rmii,
+	.set_rgmii_speed = rv1126_set_rgmii_speed,
+	.set_rmii_speed = rv1126_set_rmii_speed,
+};
+
 #define RK_GRF_MACPHY_CON0		0xb00
 #define RK_GRF_MACPHY_CON1		0xb04
 #define RK_GRF_MACPHY_CON2		0xb08
@@ -1681,6 +1805,7 @@ static const struct of_device_id rk_gmac_dwmac_match[] = {
 	{ .compatible = "rockchip,rk3399-gmac", .data = &rk3399_ops },
 	{ .compatible = "rockchip,rk3568-gmac", .data = &rk3568_ops },
 	{ .compatible = "rockchip,rv1108-gmac", .data = &rv1108_ops },
+	{ .compatible = "rockchip,rv1126-gmac", .data = &rv1126_ops },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, rk_gmac_dwmac_match);
-- 
2.37.2

