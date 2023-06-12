Return-Path: <netdev+bounces-10039-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B39672BC4F
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:28:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 636EE281108
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E42EA18C38;
	Mon, 12 Jun 2023 09:24:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A73168C9
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:24:48 +0000 (UTC)
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE8A30D7
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:47 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4f658a17aa4so3797485e87.0
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686561885; x=1689153885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0jrHnz846sKSAurRWEc8dAdWpKHrp05uQC5lgmZ9ncs=;
        b=Wv5XrDDvy4LtM5L7MWCbVK9pWAo3LoUNOvZQEasGmTIxOi38BcIRca8Fde80aXxOwM
         aXfV6t3++WM8D2t43nXQPbThzdlcHTowM1+1hywltCEBkdLNk5WIBKbHdgnFrbTu6NN6
         G7hD3xTxSxdg2OJyJhkZKd/bIlY8HQYl9S3d+OKQOv7jN/dCgI9Jja2/dN9fpneUfi06
         MbuoGh0EvHikS8mSs/EC9zdBr5OUOZtHEXtCxm4XNW8D1WYAC2ZSXNjfDklDyA/HF1uk
         rv1AHJwKXY2AlZUFovyBCJwKKAz5+/DTFFMP1V3lPGCXMSQIXrZnHCpFQWA4YSRq5Alp
         0QbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561885; x=1689153885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0jrHnz846sKSAurRWEc8dAdWpKHrp05uQC5lgmZ9ncs=;
        b=H1/w8rps++JypmqrR2HuHxvHRd/MkRiWlKIub4+5WK6N8FHKrlIogWMepM/M/BInBr
         rqPpU44tiSoZcgJyR/HpwCSa65AImulU4WhXobHh7J/KrwLcUTEduqr1PQyz6iUBjLNw
         wL6j+BqyvVIVKnqvIwFOxrpBErEMs5fC/UWzpNAPrNu3vcdYBJ+0/4VPxsJBvX2SeT91
         YpM7LLj7nr8gZAlKtUqivg6Nafd6ufpx2dHAI1XI+ZpM1SHUwBjIljp2UMSjKhl8KB09
         SxoyOMBnW7/PFIyLk1riYWa2VFpBIiRLUY+i5mhYPpCmHefHgAgHjuFgZ2/55AalvdRq
         UPpQ==
X-Gm-Message-State: AC+VfDxyMlVwQr/yOSOrd2M6mBnlLe3w3NWw3ZJWQY63aPslr1IgFWAB
	MlfeDX7DdnRwkzezvF5XFsnIfQ==
X-Google-Smtp-Source: ACHHUZ6uIGRfB9PUuO1IdV3Ad+qQfGck8wohxMrNY4KVFcykXH7H2id2cyMCwfjwU4a96k2jo3xMxA==
X-Received: by 2002:a19:6706:0:b0:4f4:2b83:f4a3 with SMTP id b6-20020a196706000000b004f42b83f4a3mr3564114lfc.51.1686561885364;
        Mon, 12 Jun 2023 02:24:45 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:a222:bbe9:c688:33ae])
        by smtp.gmail.com with ESMTPSA id p14-20020a7bcc8e000000b003f727764b10sm10892044wma.4.2023.06.12.02.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:24:44 -0700 (PDT)
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
Subject: [PATCH 13/26] net: stmmac: dwmac-qcom-ethqos: make the rgmii clock optional
Date: Mon, 12 Jun 2023 11:23:42 +0200
Message-Id: <20230612092355.87937-14-brgl@bgdev.pl>
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
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

On sa8775p there's no RGMII clock so make it optional in the driver.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 3438b6229351..252dca400071 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -663,7 +663,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	ethqos->rgmii_config_loopback_en = data->rgmii_config_loopback_en;
 	ethqos->has_emac3 = data->has_emac3;
 
-	ethqos->rgmii_clk = devm_clk_get(dev, "rgmii");
+	ethqos->rgmii_clk = devm_clk_get_optional(dev, "rgmii");
 	if (IS_ERR(ethqos->rgmii_clk)) {
 		ret = PTR_ERR(ethqos->rgmii_clk);
 		goto out_config_dt;
-- 
2.39.2


