Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005A0662D7D
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 18:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237420AbjAIRsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 12:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbjAIRqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 12:46:11 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7640E2C4
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 09:45:51 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id t5so4595421wrq.1
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 09:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WUcGV5fbtjxqFE0T6p3J3bmXfyuMT3kH12S7+49//HE=;
        b=6MwA8kcVFm4Dtxz03gS3O9kr+VDwecpPiUxj83LoGLmyZetVHS2kt0hKyJ1TDXFNlj
         2kjEjWgFJJViaRLqoNdNqwStVUl53rFwx5Gedn54jRycLv/8zwYqhfrhoylLJE8pictL
         SV/4JqCv4ZZ+SgsahBfgvhMo9oZN5NdjSa79NGncPRxtmP8Vr6ONPej3FuswYGYA6cur
         0x/3SMmalfMeJVsCrLfFPcTc96IeoTajsGnfwEKz/9H9UEmbp8qE8tCxMZmnfsZ5yotN
         JVHx/e7U2F6iIgfdRQIvruw56UAPLQcYl1iXAux1uUkqoWmW1akxEnL3sh4AU8Xg7+m9
         MOtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WUcGV5fbtjxqFE0T6p3J3bmXfyuMT3kH12S7+49//HE=;
        b=vWQCN8xjC5nyIY5G01eZWcTiGLI+F+ER3E3MKJ4efPOSB/Nxk0N2/MzMEX3oud+x9f
         PMdFRF7u4DaqCu6txNGE5y+XYiM+yoeNoFOad7XY6SpAxEnFBCwge5d0wgyi+7Pt10CP
         GcTZYGUtDy2vK3kAQ/v9MZL4Q98CMEQvkEcVaQsPpOwhacuhxUEUW6NRzyYi/Yka6wVN
         yahk8WTJ2ER9GTp202F5+kaLoHpEfsbrCyXASevFfMe5N6e4eFVX3RTWqverTM6C8SKM
         46Mt7k5kS/9seD1r8YZFdgs+DolXdKavE/V/YqaE6+zaY5mMvzwxbO+lR4XFrbNoxwUr
         LXVQ==
X-Gm-Message-State: AFqh2koRncANQFf3j+vR5rmkOjmFSq1DSYxdS+PDq/gZrUFihkElpGTl
        UW9yEiaNe8yg8NNvA8/ODlw8Iw==
X-Google-Smtp-Source: AMrXdXudM7bU6n2NQ6Zx2DujyRBImBGf6Invf+dwrnygEzLWbZcDXm1UZ8KC/h30e2Si+7WbZKPQ/w==
X-Received: by 2002:adf:f183:0:b0:255:96ed:950b with SMTP id h3-20020adff183000000b0025596ed950bmr39349795wro.60.1673286351007;
        Mon, 09 Jan 2023 09:45:51 -0800 (PST)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:c88:901e:c74c:8e80])
        by smtp.gmail.com with ESMTPSA id m1-20020a5d6241000000b002bbdaf21744sm6142902wrv.113.2023.01.09.09.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 09:45:50 -0800 (PST)
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
Subject: [PATCH 14/18] soc: qcom: rmphpd: add power domains for sa8775p
Date:   Mon,  9 Jan 2023 18:45:07 +0100
Message-Id: <20230109174511.1740856-15-brgl@bgdev.pl>
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

Add power domain description for sa8775p and a new compatible to match it.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/soc/qcom/rpmhpd.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/soc/qcom/rpmhpd.c b/drivers/soc/qcom/rpmhpd.c
index 4c2d2c296790..f20e2a49a669 100644
--- a/drivers/soc/qcom/rpmhpd.c
+++ b/drivers/soc/qcom/rpmhpd.c
@@ -187,6 +187,16 @@ static struct rpmhpd nsp = {
 	.res_name = "nsp.lvl",
 };
 
+static struct rpmhpd nsp0 = {
+	.pd = { .name = "nsp0", },
+	.res_name = "nsp0.lvl",
+};
+
+static struct rpmhpd nsp1 = {
+	.pd = { .name = "nsp1", },
+	.res_name = "nsp1.lvl",
+};
+
 static struct rpmhpd qphy = {
 	.pd = { .name = "qphy", },
 	.res_name = "qphy.lvl",
@@ -212,6 +222,29 @@ static const struct rpmhpd_desc sa8540p_desc = {
 	.num_pds = ARRAY_SIZE(sa8540p_rpmhpds),
 };
 
+/* SA8775P RPMH power domains */
+static struct rpmhpd *sa8775p_rpmhpds[] = {
+	[SA8775P_CX] = &cx,
+	[SA8775P_CX_AO] = &cx_ao,
+	[SA8775P_EBI] = &ebi,
+	[SA8775P_GFX] = &gfx,
+	[SA8775P_LCX] = &lcx,
+	[SA8775P_LMX] = &lmx,
+	[SA8775P_MMCX] = &mmcx,
+	[SA8775P_MMCX_AO] = &mmcx_ao,
+	[SA8775P_MXC] = &mxc,
+	[SA8775P_MXC_AO] = &mxc_ao,
+	[SA8775P_MX] = &mx,
+	[SA8775P_MX_AO] = &mx_ao,
+	[SA8775P_NSP0] = &nsp0,
+	[SA8775P_NSP1] = &nsp1,
+};
+
+static const struct rpmhpd_desc sa8775p_desc = {
+	.rpmhpds = sa8775p_rpmhpds,
+	.num_pds = ARRAY_SIZE(sa8775p_rpmhpds),
+};
+
 /* SDM670 RPMH powerdomains */
 static struct rpmhpd *sdm670_rpmhpds[] = {
 	[SDM670_CX] = &cx_w_mx_parent,
@@ -487,6 +520,7 @@ static const struct rpmhpd_desc sc8280xp_desc = {
 static const struct of_device_id rpmhpd_match_table[] = {
 	{ .compatible = "qcom,qdu1000-rpmhpd", .data = &qdu1000_desc },
 	{ .compatible = "qcom,sa8540p-rpmhpd", .data = &sa8540p_desc },
+	{ .compatible = "qcom,sa8775p-rpmhpd", .data = &sa8775p_desc },
 	{ .compatible = "qcom,sc7180-rpmhpd", .data = &sc7180_desc },
 	{ .compatible = "qcom,sc7280-rpmhpd", .data = &sc7280_desc },
 	{ .compatible = "qcom,sc8180x-rpmhpd", .data = &sc8180x_desc },
-- 
2.37.2

