Return-Path: <netdev+bounces-11872-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CFC6734FDD
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:25:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7209A1C20983
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16EC8C2E2;
	Mon, 19 Jun 2023 09:24:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B52EC2E1
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:24:19 +0000 (UTC)
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9A012D
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:24:17 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4f769c37d26so4012096e87.1
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1687166656; x=1689758656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jbBN5UFZLskttS3+DKY7OChoCqIyyvgczJBfknfqHmY=;
        b=IgJbKu3j5ZSezHMCdBUh//m5BjaQnLUFHhTknW4VBcn4lAblpPaHRZ1Fg8mgLyOnwn
         B+CUjCvyLvpZTDweOBWlV32HEMP4jI1kCm9h7YK3xegxh0EEACGXSVwNff1llgRxdbrO
         DXmjRfKbyzieziwyN+VOYogRFr1BFhc7IXDOvjFOMNWalXxL5tdQxfLlQc6VN1zWe85h
         zUwDsXJqzGRXIv+fzm2VK6cnQ1rwqwfZ3VUJGKX6h356mJJK9Z/gt1Nev934IASlL243
         +fI1CPxpdHmWdipONXkkVWGAGnIDLLbPts0scgNsx2l/mmywhnkmXNKXxF33lllu0wZw
         ul5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687166656; x=1689758656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jbBN5UFZLskttS3+DKY7OChoCqIyyvgczJBfknfqHmY=;
        b=Ds9oLb53phBxmguN7DPX6ux9JpoWYJ9zqEW/gE9Pr9MC3dUj8YCkFz0cK18YFnEJ/C
         BqidLMEVa4YGU3LZl9cOE+hGGbkIlYUVVw6Kv4jgubIePSnTSNL/RXU9eTlvzS4HzQgP
         j5e7H1GlzYIZnvQzX+YPA3J4MbFSn8NieKG0UDsd2jGrX6hznOIuZ+kY4v2JKGbE4BBH
         80MjRXCxRJLsPc3tIBb3o/7yxTvrAnXVwDwniP/MgRTu4wuUWuqp5om0z2oTrfrLKN3Z
         CZPXGbQJyTe3RFMhyrbjgngoXJoeBG5WIXlEblWVWA4SxlbAelPz41KS+EEPlA1yb5vM
         D7Ew==
X-Gm-Message-State: AC+VfDw6KQCoLYpuJsrpDnK6VvwuSt2eK1nyz2i6eaiPYlJ1KT9arbZy
	XIxqFI2dWfMpfViipxSfusIv5Q==
X-Google-Smtp-Source: ACHHUZ7a6sBSYCvvGZ0rLeDvJ+aAMJ8hN0pO8v2WRQzU9PMkjFcqPr5PjOXONwRoBWWY5Umkpk3jBg==
X-Received: by 2002:a19:5e16:0:b0:4f4:b28d:73eb with SMTP id s22-20020a195e16000000b004f4b28d73ebmr4567389lfb.12.1687166655767;
        Mon, 19 Jun 2023 02:24:15 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:d9e8:ddbf:7391:a0b0])
        by smtp.gmail.com with ESMTPSA id q9-20020a7bce89000000b003f7cb42fa20sm10045229wmj.42.2023.06.19.02.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 02:24:15 -0700 (PDT)
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
Subject: [RESEND PATCH v2 03/14] net: stmmac: dwmac-qcom-ethqos: tweak the order of local variables
Date: Mon, 19 Jun 2023 11:23:51 +0200
Message-Id: <20230619092402.195578-4-brgl@bgdev.pl>
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
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Make sure we follow the reverse-xmas tree convention.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
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


