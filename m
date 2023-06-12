Return-Path: <netdev+bounces-10041-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C957D72BC5D
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93A7328110A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9A121953E;
	Mon, 12 Jun 2023 09:24:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD30E19520
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:24:51 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D013584
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:49 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f6d38a140bso29757695e9.1
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686561888; x=1689153888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cjVXwVFp50u0PUxr/5pPlG4sgNjLclV10ezIygBZf1w=;
        b=2LxLhnK7e46mui8dhof9QAMYFAXj+RyNY51koDXFIyUq+oeAgfB5Yunm2wkRuj1JMn
         kZaCwUavQC6RW+LqMlWJwEmkbL8jYXkjd+0ANuO3gB4RfugPiO63GVGDem2oaXmUGXY6
         eAlLWzfGQJsrYyk6s/qe+xejpzIL2oEbCV4biO8JIzCtGSZlK2U1RNqppXvdTzoPFYj1
         3uySIa1BuTRWIipEsHrVcQc4yvQ9rYYM8rlnBgv7OYXKE2GKN9SYzVWyi+JBty3FKAs6
         AGFFcXEHyxxr14wTLOjNholiBRGWtf+J2xMsFuYww1sG2cHVlfE8DjukIKEYzRH+nuip
         3ZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561888; x=1689153888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cjVXwVFp50u0PUxr/5pPlG4sgNjLclV10ezIygBZf1w=;
        b=C+JA6pAUc1c5B5YHu3tyTdW8tQfwuG1ssR+uFDtTls7JR12Av46W9H8rxQFXht135r
         7DHDS/GK3Oqc4w0XP9DIGQUL+fRAyOqzMBe/LL38r01haXzNKdFonwxlyolDI4ZEeori
         qiKLIbXiDPEGyfokyuvfAOK0A/B1eEiTrcXYufJzyxI6m0Be2mCksLCS70pLTtpoyjod
         d2mFeYPEyaxDkJQlq99q33XanPS2noc7dMd6POBj3ZxKwT1baAvju4CIgyXfW4Z5tK01
         V8pziU3BfyXRWfwPJdfuwb/iMR8gW2J6i6Ewyu3zWMefPRYjah09PZ6A+KiCbtMVRJZn
         2IwQ==
X-Gm-Message-State: AC+VfDw9dam2ukxsO122RAFM5aGsA+QrBs5/PxZD6JJPcD9Pk1Itposc
	d3t5sZNsKYh7WGQLiNW3IiC/7A==
X-Google-Smtp-Source: ACHHUZ5VMYcwm8OhSaptz22TDIOQZKg2qtYe5RLNTkB2yZzQSZhIqFe5Wt+EaJyET4ed5soNUXNxKQ==
X-Received: by 2002:a05:600c:880f:b0:3f7:148b:c310 with SMTP id gy15-20020a05600c880f00b003f7148bc310mr8862440wmb.13.1686561888007;
        Mon, 12 Jun 2023 02:24:48 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:a222:bbe9:c688:33ae])
        by smtp.gmail.com with ESMTPSA id p14-20020a7bcc8e000000b003f727764b10sm10892044wma.4.2023.06.12.02.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:24:47 -0700 (PDT)
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
Subject: [PATCH 15/26] net: stmmac: dwmac-qcom-ethqos: add support for the optional phy-supply
Date: Mon, 12 Jun 2023 11:23:44 +0200
Message-Id: <20230612092355.87937-16-brgl@bgdev.pl>
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

On sa8775p-ride we need to enable the power supply for the external PHY.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 2f6b9b419601..21f329d2f7eb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -8,6 +8,7 @@
 #include <linux/phy.h>
 #include <linux/phy/phy.h>
 #include <linux/property.h>
+#include <linux/regulator/consumer.h>
 
 #include "stmmac.h"
 #include "stmmac_platform.h"
@@ -692,6 +693,10 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_config_dt;
 
+	ret = devm_regulator_get_enable_optional(dev, "phy");
+	if (ret < 0 && ret != -ENODEV)
+		goto out_config_dt;
+
 	ethqos->serdes_phy = devm_phy_optional_get(dev, "serdes");
 	if (IS_ERR(ethqos->serdes_phy)) {
 		ret = PTR_ERR(ethqos->serdes_phy);
-- 
2.39.2


