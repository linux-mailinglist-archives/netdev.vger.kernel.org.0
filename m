Return-Path: <netdev+bounces-10033-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66AB172BC3A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:26:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 380D52804CD
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6066F182C0;
	Mon, 12 Jun 2023 09:24:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55449182BD
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:24:39 +0000 (UTC)
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E027D19AF
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:37 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f619c2ba18so4495218e87.1
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686561876; x=1689153876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=olcveT5UP1VtPiAz7clK/JVsOLfG7BcQJiP17zTmSVg=;
        b=5L8AZQCENa6wk25Wk1x41BvLjZPoG7GaKW7WRgHBzPesHTu+JxqbkF4slD2rDK4+2a
         1MeffqJGHvG1Mxz2eOg0xmGDid0CWmHPp2RYxaiXDvuGxNiM6tMcLy8i+GoDCIo5SR6X
         aAwisPKSBZLSLwHuiroOnFmweOMUjutIYsUVNpCVuAWxEVLZ5TQjz8recM1V34U1oLh5
         i05JqSQiuiZiodJ2P141uneoMY9uf8Qpu2jau4D8v4dmqHKYo/vC+S7uysmfwNgzJWuO
         m/KfLrmuOcZnsTJJgPkluArQZGR6EJS/Pnymu9rNxuJpBTox48p4hro1Y6B5LKKCQsRo
         YJ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561876; x=1689153876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=olcveT5UP1VtPiAz7clK/JVsOLfG7BcQJiP17zTmSVg=;
        b=PC21eAFmNDotgWqQb+U2zzkMBkro+7qHNdT5zZWlWXngU/JQqrAqQtRflLv3E+Fpt3
         W3zWIMtfmenHNL4NUYOJ+nBaP6aZKttUyKdAuYJzmAuufAAIWerTsRmMxhXORQXMKqKS
         LY/44EE/zmhKgLigLCOcqZl60T8RVC8ZDksg0HXq9x66nJMHO074r/t0aSm7jiwuUPzv
         xqm5eUswToA5fj//M48f5yntN5bdXhmzfCW0+K84vtYgBR2LwDdwYr3GmgKKHd8op3ty
         epMLEkjbMcKPdCick/nWTcK4iKksenKpT/92vk7/nXIQLA3yW3XhxGpuGy2y6UTxnFSo
         Ma0A==
X-Gm-Message-State: AC+VfDw2p/rs7z+EcqQMUiNvsqv0pC7ZiBI3HuE5KT+eNLGslKEc75LH
	OPZKW3v4u8qHMybyaRW1as1zaA==
X-Google-Smtp-Source: ACHHUZ63Ie+qYkY7+DIb0ohPjU+I2zYtAsyLTkT1qM0Lelp1CrY/eE3emkya9+jlOwfhsFt6Lnqqpg==
X-Received: by 2002:ac2:5b1c:0:b0:4f3:af46:1941 with SMTP id v28-20020ac25b1c000000b004f3af461941mr3498469lfn.34.1686561876266;
        Mon, 12 Jun 2023 02:24:36 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:a222:bbe9:c688:33ae])
        by smtp.gmail.com with ESMTPSA id p14-20020a7bcc8e000000b003f727764b10sm10892044wma.4.2023.06.12.02.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:24:35 -0700 (PDT)
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
Subject: [PATCH 07/26] net: stmmac: dwmac-qcom-ethqos: tweak the order of local variables
Date: Mon, 12 Jun 2023 11:23:36 +0200
Message-Id: <20230612092355.87937-8-brgl@bgdev.pl>
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

Make sure we follow the reverse-xmas tree convention.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 16e856861558..28d2514a8795 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -594,9 +594,9 @@ static void ethqos_clks_disable(void *data)
 static int qcom_ethqos_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	const struct ethqos_emac_driver_data *data;
 	struct plat_stmmacenet_data *plat_dat;
 	struct stmmac_resources stmmac_res;
-	const struct ethqos_emac_driver_data *data;
 	struct qcom_ethqos *ethqos;
 	int ret;
 
-- 
2.39.2


