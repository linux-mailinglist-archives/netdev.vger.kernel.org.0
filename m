Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B849662D55
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 18:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237336AbjAIRrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 12:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237337AbjAIRqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 12:46:03 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81083AB26
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 09:45:44 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id j16-20020a05600c1c1000b003d9ef8c274bso3245818wms.0
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 09:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RwVG2zKJ/ATnKV1RRIAAcFC3q+IIg4nUTLy7Tj+MQpo=;
        b=jRcoui9r2/TGb5E06Pt08Dc+Uc1+mBd6LO0MBj+k26OeFa3jjK0cIDHD8/8XsoPAqI
         3LP+MQD2XnrLYwYhvGUc8UynxOBJ+dHP/ud8CJzu4gORQbmMFWFF6QYKwC7A+YNmHN75
         Nfo+oaYvI9qCW1HtIi6tTF+cKfl9cPksZLNLFu5JIvjQtfUZiLsPFTk0ZTFwn2pTXVJq
         MYNGJslfzjz73lu0a2hRti5ckCpuYlA47/QI/w5l6c1A2ERT0lJt1gtHv5LJbUdCcDGk
         w/l2gRaAINL0s1Ml9gkebFIXoQOqm94NEl41Rk0FGJd2fs+bWpbkCXtsiDMINvG9+WGL
         7Bfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RwVG2zKJ/ATnKV1RRIAAcFC3q+IIg4nUTLy7Tj+MQpo=;
        b=IBITwfU5pP26Q5MoeMhwOFrPv8fQB87J4riOPEiB2UPs2xa3P/NfAcQvCZCABAGcHw
         8XreCxtrdiNY67GhmFqT5lWicV1UbR8j3nONZQh2Y1usk2NwN1IjUNYTYZOlYyxUOVio
         jN4cUgft4l356HNXj5EAfTP7gFHTpwuBwP/kt+yi0p011EriqEn6vVoYJwUKqf2XVA1C
         47rBDOPVdCj32RaIEYSKHyXCHDQk3ZMfIB1S7Sv6iBMei+Gv94ib00C47tgrb7I8Yz3W
         O/EGpWDq2rQKqhyXerpaDKyP626QoRQIKtE0nFkl/MJ1EW4QRIyaEh1dRHyyPPA5GJlj
         DeAQ==
X-Gm-Message-State: AFqh2kqK2En6DVEBxBDcKtSdUNg6RGUyGfryaagtb1qnPxoV9T2K1uqF
        SBaTzOOCku8KKNhR/reBWv2XyQ==
X-Google-Smtp-Source: AMrXdXsd7xg1OeqEz9aF8XERiC/uKepz+bzckxBY0KixGFQPabm7W0wOVPMTz5D1vkIcHHcNUj0TnA==
X-Received: by 2002:a05:600c:4e90:b0:3cf:894f:964b with SMTP id f16-20020a05600c4e9000b003cf894f964bmr48650187wmq.16.1673286343174;
        Mon, 09 Jan 2023 09:45:43 -0800 (PST)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:c88:901e:c74c:8e80])
        by smtp.gmail.com with ESMTPSA id m1-20020a5d6241000000b002bbdaf21744sm6142902wrv.113.2023.01.09.09.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 09:45:42 -0800 (PST)
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
Subject: [PATCH 08/18] arm64: defconfig: enable the interconnect driver for Qualcomm SA8775P
Date:   Mon,  9 Jan 2023 18:45:01 +0100
Message-Id: <20230109174511.1740856-9-brgl@bgdev.pl>
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

Enable the Qualcomm SA8775P interconnect driver for arm64 builds. It's
required to be built-in for QUPv3 to work early which in turn is needed
for the console.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 1cb586125c46..d5c938adbd2d 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1332,6 +1332,7 @@ CONFIG_INTERCONNECT_QCOM_MSM8916=m
 CONFIG_INTERCONNECT_QCOM_MSM8996=m
 CONFIG_INTERCONNECT_QCOM_OSM_L3=m
 CONFIG_INTERCONNECT_QCOM_QCS404=m
+CONFIG_INTERCONNECT_QCOM_SA8775P=y
 CONFIG_INTERCONNECT_QCOM_SC7180=y
 CONFIG_INTERCONNECT_QCOM_SC7280=y
 CONFIG_INTERCONNECT_QCOM_SC8180X=y
-- 
2.37.2

