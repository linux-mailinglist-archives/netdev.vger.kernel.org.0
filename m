Return-Path: <netdev+bounces-11877-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F025F734FFC
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC477280E9C
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 495E3D306;
	Mon, 19 Jun 2023 09:24:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AA9D2EB
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:24:25 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F0E1A3
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:24:23 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f90a7325f6so18490315e9.3
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1687166661; x=1689758661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4LJNYlud7nrLWcLjYZWRISbOkEhmJfj+HftG3WBZPio=;
        b=2YWmvGNdY7ru1EdR1H+tJupPph00OxidGvPR+8zGqIzhb6ZwLiheQRuCTZGv3/7mM9
         yqeQTqxwpq9+25SGL54iVb2Uyq6F2aRzLsRB4SDOI995SICNij6NzKILZR56dNLRmb7B
         BwCETmHOkph/PtUHZPXspkfeXb8aS1TgsRK1Z6AYXzGOHAR9miXnGOWFHfevL03Th3qu
         Ojk8CdC1XLiBd2Vtw/5qdpc59mEE7NC2QcLoaap8lM3jyQXSBcnS5O7RYB/HtLMmGalK
         vT72R+clvy786hV3uqZlkALdNFUQP4lW45oDGD5vDMC67Ub+aAYzfXAhzKpFQEQwK0WG
         0KnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687166661; x=1689758661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4LJNYlud7nrLWcLjYZWRISbOkEhmJfj+HftG3WBZPio=;
        b=Zw3Do6bczK8NKD6L3LgH54As7PnqkoEbClAHZ2mU8Stuy8La5gvewWL/dhrEUIKvVc
         iCoroBQqdqHyfQSq5pLfS9xA1GREmF5uc1jPPBaQ0iIh4n6ipOd3RdJcRaXosJQPSQQ+
         IeXqnQIwS/NvO5hM+HJS+ZOtIQd17Ml2Xyzs40i4St7k9BQm7F4F2nHS0Xcxgeyb8SlA
         uZFSHHPlFU2rnUuUgH7XvBU6CdEIxrB3UHKKSy9vjqB7gSpFmfvU3d3yHKwNxdYTM1Av
         uViEDBq/TRz+VJisG2l3it0BbEyXC9vnPy8kQerm1UfugZpW3oRAE6Cb99gGdcioAkSl
         ursQ==
X-Gm-Message-State: AC+VfDy20xzW1/vipveyRMd+DpTVtAovKojOr5QfSuWpOuKSKs2Pcvr4
	xHfZU7OHdLHxg57+YJSs58DqEg==
X-Google-Smtp-Source: ACHHUZ72UV4Ac/uWZjGcoOozYdQtjCYg5zJ4Jm8xHVhmuQ7f9B9muVAN5ZMB2o/BigOBoxF3JIRpbg==
X-Received: by 2002:a05:600c:220b:b0:3f9:b10a:b310 with SMTP id z11-20020a05600c220b00b003f9b10ab310mr2287957wml.26.1687166661642;
        Mon, 19 Jun 2023 02:24:21 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:d9e8:ddbf:7391:a0b0])
        by smtp.gmail.com with ESMTPSA id q9-20020a7bce89000000b003f7cb42fa20sm10045229wmj.42.2023.06.19.02.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 02:24:21 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
To: Vinod Koul <vkoul@kernel.org>,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Andrew Halaney <ahalaney@redhat.com>
Cc: netdev@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [RESEND PATCH v2 08/14] net: stmmac: dwmac-qcom-ethqos: add support for the optional serdes phy
Date: Mon, 19 Jun 2023 11:23:56 +0200
Message-Id: <20230619092402.195578-9-brgl@bgdev.pl>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230619092402.195578-1-brgl@bgdev.pl>
References: <20230619092402.195578-1-brgl@bgdev.pl>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

On sa8775p platforms, there's a SGMII SerDes PHY between the MAC and
external PHY that we need to enable and configure.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index ec3bbd199501..042733b5e80b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -6,6 +6,7 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/phy.h>
+#include <linux/phy/phy.h>
 #include <linux/property.h>
 
 #include "stmmac.h"
@@ -93,6 +94,7 @@ struct qcom_ethqos {
 
 	unsigned int rgmii_clk_rate;
 	struct clk *rgmii_clk;
+	struct phy *serdes_phy;
 	unsigned int speed;
 
 	const struct ethqos_emac_por *por;
@@ -565,6 +567,30 @@ static void ethqos_fix_mac_speed(void *priv, unsigned int speed)
 	ethqos_configure(ethqos);
 }
 
+static int qcom_ethqos_serdes_powerup(struct net_device *ndev, void *priv)
+{
+	struct qcom_ethqos *ethqos = priv;
+	int ret;
+
+	ret = phy_init(ethqos->serdes_phy);
+	if (ret)
+		return ret;
+
+	ret = phy_power_on(ethqos->serdes_phy);
+	if (ret)
+		return ret;
+
+	return phy_set_speed(ethqos->serdes_phy, ethqos->speed);
+}
+
+static void qcom_ethqos_serdes_powerdown(struct net_device *ndev, void *priv)
+{
+	struct qcom_ethqos *ethqos = priv;
+
+	phy_power_off(ethqos->serdes_phy);
+	phy_exit(ethqos->serdes_phy);
+}
+
 static int ethqos_clks_config(void *priv, bool enabled)
 {
 	struct qcom_ethqos *ethqos = priv;
@@ -650,6 +676,12 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_config_dt;
 
+	ethqos->serdes_phy = devm_phy_optional_get(dev, "serdes");
+	if (IS_ERR(ethqos->serdes_phy)) {
+		ret = PTR_ERR(ethqos->serdes_phy);
+		goto out_config_dt;
+	}
+
 	ethqos->speed = SPEED_1000;
 	ethqos_update_rgmii_clk(ethqos, SPEED_1000);
 	ethqos_set_func_clk_en(ethqos);
@@ -665,6 +697,11 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	if (of_device_is_compatible(np, "qcom,qcs404-ethqos"))
 		plat_dat->rx_clk_runs_in_lpi = 1;
 
+	if (ethqos->serdes_phy) {
+		plat_dat->serdes_powerup = qcom_ethqos_serdes_powerup;
+		plat_dat->serdes_powerdown  = qcom_ethqos_serdes_powerdown;
+	}
+
 	ret = stmmac_dvr_probe(dev, plat_dat, &stmmac_res);
 	if (ret)
 		goto out_config_dt;
-- 
2.39.2


