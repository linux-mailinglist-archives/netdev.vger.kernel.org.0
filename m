Return-Path: <netdev+bounces-10040-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5293272BC54
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:28:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22B02280BE8
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA5A417742;
	Mon, 12 Jun 2023 09:24:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F79B19520
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:24:50 +0000 (UTC)
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A75030F4
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:48 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4f4b2bc1565so4676801e87.2
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686561886; x=1689153886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c3HXmWBI5xLrWbOkueODzJ5MVGSA4Kc5TK/lazRH0B0=;
        b=kzgUUkMC5jsWR5xW0+ANRcf2btdakfoFVSpYBSE9CikTfQlpt+AqLN7zdBbZJFtLme
         xv5/N8+XHKqeOLiYheLN/vH4zRYHi9T6pytx/a+feZ6Ar+vvWiN0Eku+dctJjFBED96f
         y6dlmLfFclU/1M8/Dkh0s6PVP4tPSxlThdgfNA1wtRmX3AYoPWL+galeUX+z96THhp9l
         eoKOC7/6cBKs8NL0f/gd6xfgLidEidiAmfGdioadvL+hjOWjmHTAkyP/TtqA63cg+m8E
         1Ro1pxSPqRZ/FZLWuM9+n+8mX+utAr5AZu5GwTebLop+/HDkLST5jFVWE05M/IewJtwh
         TSsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561886; x=1689153886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c3HXmWBI5xLrWbOkueODzJ5MVGSA4Kc5TK/lazRH0B0=;
        b=foi23SVC+JBM8CDkN3a3pgQQgp2PuKxc7aa1cNU/NV3kV+vwxsne+09Z/URJYflCbv
         iO5uFbf6NISknHB0iPQf2yXjVnjjkuA3zy99YkVdp5E7SWy0Dblk09vpJvecdfNAYOd5
         /r5z0F+BaP9V5CT0yRltMKC3BNVjXpPbRIa/MjQOJ/VnNO6O/4OQpyeMwz46KFqsDpsu
         /YqkHVYU0bubtCPFwAqgCqMa3xWqzPNHqTuMtwNB6lZBiURPvZB+SBM9zgCcc8GgEgK1
         +OjJmF4V20p9I87fP/0B+kZ2QkiNMB2sGNYKZr4uzM0FMh2s5y9e3kDG2bX82gABPwhm
         0CIg==
X-Gm-Message-State: AC+VfDzOx0jNMUkep16TUbkdBkPuEnjuC/BruzeM8exglGfA19RDnqg7
	0hxc/hLWEoVQb6VI7qjbMYwlrg==
X-Google-Smtp-Source: ACHHUZ5ccKjNrjHtWSXeFcXvi6pGIDd0bXqsgL6lZowErwFAW975a65dQyiL/g71vDQz5+NfmBtGXA==
X-Received: by 2002:a05:6512:615:b0:4f2:5d38:2c37 with SMTP id b21-20020a056512061500b004f25d382c37mr3795687lfe.15.1686561886665;
        Mon, 12 Jun 2023 02:24:46 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:a222:bbe9:c688:33ae])
        by smtp.gmail.com with ESMTPSA id p14-20020a7bcc8e000000b003f727764b10sm10892044wma.4.2023.06.12.02.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:24:46 -0700 (PDT)
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
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>
Cc: netdev@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-phy@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 14/26] net: stmmac: dwmac-qcom-ethqos: add optional phyaux clock
Date: Mon, 12 Jun 2023 11:23:43 +0200
Message-Id: <20230612092355.87937-15-brgl@bgdev.pl>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230612092355.87937-1-brgl@bgdev.pl>
References: <20230612092355.87937-1-brgl@bgdev.pl>
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

On sa8775p we don't use the RGMII clock but have an additional PHYAUX
clock so add support for it to the driver.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c   | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 252dca400071..2f6b9b419601 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -94,6 +94,7 @@ struct qcom_ethqos {
 
 	unsigned int rgmii_clk_rate;
 	struct clk *rgmii_clk;
+	struct clk *phyaux_clk;
 	struct phy *serdes_phy;
 	unsigned int speed;
 
@@ -604,6 +605,13 @@ static int ethqos_clks_config(void *priv, bool enabled)
 			return ret;
 		}
 
+		ret = clk_prepare_enable(ethqos->phyaux_clk);
+		if (ret) {
+			clk_disable_unprepare(ethqos->rgmii_clk);
+			dev_err(&ethqos->pdev->dev, "phyaux enable failed\n");
+			return ret;
+		}
+
 		/* Enable functional clock to prevent DMA reset to timeout due
 		 * to lacking PHY clock after the hardware block has been power
 		 * cycled. The actual configuration will be adjusted once
@@ -611,6 +619,7 @@ static int ethqos_clks_config(void *priv, bool enabled)
 		 */
 		ethqos_set_func_clk_en(ethqos);
 	} else {
+		clk_disable_unprepare(ethqos->phyaux_clk);
 		clk_disable_unprepare(ethqos->rgmii_clk);
 	}
 
@@ -669,6 +678,12 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 		goto out_config_dt;
 	}
 
+	ethqos->phyaux_clk = devm_clk_get_optional(dev, "phyaux");
+	if (IS_ERR(ethqos->phyaux_clk)) {
+		ret = PTR_ERR(ethqos->phyaux_clk);
+		goto out_config_dt;
+	}
+
 	ret = ethqos_clks_config(ethqos, true);
 	if (ret)
 		goto out_config_dt;
-- 
2.39.2


