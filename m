Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F7F662D46
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 18:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237253AbjAIRqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 12:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236723AbjAIRpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 12:45:42 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6033AA92
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 09:45:39 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id z5so7948493wrt.6
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 09:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LM0HPgTNMyAJ8phPgkV2DF0qr0bcaChewWJHXJigj8w=;
        b=JZCgYUZa1yXcC8C6hPysGrbxaI7VhoW9Bpz3P7TdYuK685mdEW0J2n20NBJ3M3AEOP
         4WbaLFjQWulc/fe+rP/n3cXwdpQdGWbChJdkKyxE0spyR7HgLs4Eu6AAa5O93M9esS8R
         Zgu9182pxHD/W2VyFyDzcH7H0y63yatPmd3rleyHRryhViMjtnIeq2Ji7sWnsgkLTr8p
         8QLhd49ESHxblQXNg4pe4IRKbPo29D4oaJMyLVfYgRMzImBcdOIqWKP7EOZJu0zlLpXN
         kG5KfVYcx2sI0iEFEY8C0cJeNQgupzun1nmS35fZVsAd704zaWDxdQzfLS+Q7mXSWSZw
         6fWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LM0HPgTNMyAJ8phPgkV2DF0qr0bcaChewWJHXJigj8w=;
        b=VOAdFaHPTNtmvUMoZ8YzyWiQZc1SrIUZj8P48bw4hOewA3i9s+UTmfT0onmQ2ENB47
         /eOtO3T0ZUnQE5vsqSZU4hqlP+00J2XTorYDdfpBPKWws9u/nmVwv+C+tFAd7XjqyOZp
         7DX6S4BO1cfPSZCPvS6wrfss8GEvifuAGfh7KHUblnpoWRKAxBiRhXfelnFx3a9UtZJy
         FQCUcuSIXNK2CHFIPz6uPF38euaoNkEFbIGInZH2yydMl1Ki2NxEQBBWYxnZ4poKiQxa
         DGnB+J1SttuzCTRPXciTHFd0TdeE1ZOXL+MNCO/o4VtsgIZqBjMUBoJSQB8o8TM+gmbf
         GbTw==
X-Gm-Message-State: AFqh2kpq/TVl8jriIZHKjhtj6GrnAStEKk67/zmma4lxWiixAyl87mKW
        VXU8A7OlHba09OB0WzjZc3JFrw==
X-Google-Smtp-Source: AMrXdXvnNLr9rsquZ8+pOyWMbio+w1kxYWRci3GrXhKJp07+eCoFJEEDqvGDPQE9gP3PVEnhH09w+Q==
X-Received: by 2002:adf:e883:0:b0:2bb:6c50:a559 with SMTP id d3-20020adfe883000000b002bb6c50a559mr7241120wrm.38.1673286339135;
        Mon, 09 Jan 2023 09:45:39 -0800 (PST)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:c88:901e:c74c:8e80])
        by smtp.gmail.com with ESMTPSA id m1-20020a5d6241000000b002bbdaf21744sm6142902wrv.113.2023.01.09.09.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 09:45:38 -0800 (PST)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 05/18] clk: qcom: rpmh: add clocks for sa8775p
Date:   Mon,  9 Jan 2023 18:44:58 +0100
Message-Id: <20230109174511.1740856-6-brgl@bgdev.pl>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230109174511.1740856-1-brgl@bgdev.pl>
References: <20230109174511.1740856-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Extend the driver with a description of clocks for sa8775p platforms.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/clk/qcom/clk-rpmh.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/clk/qcom/clk-rpmh.c b/drivers/clk/qcom/clk-rpmh.c
index 586a810c682c..d5f7ec2edbbe 100644
--- a/drivers/clk/qcom/clk-rpmh.c
+++ b/drivers/clk/qcom/clk-rpmh.c
@@ -396,6 +396,22 @@ static const struct clk_rpmh_desc clk_rpmh_sdm845 = {
 	.num_clks = ARRAY_SIZE(sdm845_rpmh_clocks),
 };
 
+static struct clk_hw *sa8775p_rpmh_clocks[] = {
+	[RPMH_CXO_CLK]		= &clk_rpmh_bi_tcxo_div2.hw,
+	[RPMH_CXO_CLK_A]	= &clk_rpmh_bi_tcxo_div2_ao.hw,
+	[RPMH_LN_BB_CLK1]	= &clk_rpmh_ln_bb_clk1_a2.hw,
+	[RPMH_LN_BB_CLK2]	= &clk_rpmh_ln_bb_clk2_a2.hw,
+	[RPMH_LN_BB_CLK2_A]	= &clk_rpmh_ln_bb_clk2_a4_ao.hw,
+	[RPMH_IPA_CLK]		= &clk_rpmh_ipa.hw,
+	[RPMH_PKA_CLK]		= &clk_rpmh_pka.hw,
+	[RPMH_HWKM_CLK]		= &clk_rpmh_hwkm.hw,
+};
+
+static const struct clk_rpmh_desc clk_rpmh_sa8775p = {
+	.clks = sa8775p_rpmh_clocks,
+	.num_clks = ARRAY_SIZE(sa8775p_rpmh_clocks),
+};
+
 static struct clk_hw *sdm670_rpmh_clocks[] = {
 	[RPMH_CXO_CLK]		= &clk_rpmh_bi_tcxo_div2.hw,
 	[RPMH_CXO_CLK_A]	= &clk_rpmh_bi_tcxo_div2_ao.hw,
@@ -730,6 +746,7 @@ static int clk_rpmh_probe(struct platform_device *pdev)
 
 static const struct of_device_id clk_rpmh_match_table[] = {
 	{ .compatible = "qcom,qdu1000-rpmh-clk", .data = &clk_rpmh_qdu1000},
+	{ .compatible = "qcom,sa8775p-rpmh-clk", .data = &clk_rpmh_sa8775p},
 	{ .compatible = "qcom,sc7180-rpmh-clk", .data = &clk_rpmh_sc7180},
 	{ .compatible = "qcom,sc8180x-rpmh-clk", .data = &clk_rpmh_sc8180x},
 	{ .compatible = "qcom,sc8280xp-rpmh-clk", .data = &clk_rpmh_sc8280xp},
-- 
2.37.2

