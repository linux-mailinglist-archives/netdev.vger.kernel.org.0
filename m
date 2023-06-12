Return-Path: <netdev+bounces-10046-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EC69E72BC7A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:30:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3861E1C20995
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4757219E72;
	Mon, 12 Jun 2023 09:24:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA6319E47
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:24:58 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE4D35BB
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:56 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f6e68cc738so29750695e9.1
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686561895; x=1689153895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SXzZMEQkDaBAvE+ZbovBT4hal5Pn3NRrTeiS658EjW4=;
        b=DcuBFu7i8zRSQw8hKkh2pX678LFY4uXhQRa0m1zoChLoD/0S5zPhOg/N/5fCRqhJYj
         Z/zKl/ZA0YUpKlj3nfmm8WK7dbqp8Lz1GnBwSjRkWnCXmulByIqXZmyk9SecLTKdlKEp
         7XqAqh8l0T6g6hWUOB56/w+7mdIuq30uxJryTPArpeMbN91hdnLaykpbwvvQbF3VlWr5
         jvy48WfJVMGchgt+8J6Gp6hkKaiYTL3TgU2oDk+hfhvv+QDEuUdfV1axYsnXyQAb2/ox
         iKo4fug4hayVecTmLj6RFSmpadhjLeynFjSieMx2ZlRUmPe9LmSJZ1bM+o0ZfZ4+FOxq
         cyUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561895; x=1689153895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SXzZMEQkDaBAvE+ZbovBT4hal5Pn3NRrTeiS658EjW4=;
        b=U/3wrlNlFmJJs5xm5oz2Ppo3gfDrXtxRNPXM6489AmafC/NwbzneSMTUoRHr8Baosq
         3w/dXepdVBe4Wiaxnp3bOtVbFKYgjhytzFSdh9CUjzWDQETxA915h5Kl8ZESqdeNJKHq
         LYDsWrHQZK0rSwMNZaLrMoAS18/awtInQ/E2DlBJZ1o6k4Ii6TflutibydAb+v/Po6dO
         8uHum3GFmS+20KNRol1EB7GX3K1sx0kXgX6y2LVUMF5znKKB2b8+GgfBuXUFjPkh+lsx
         PchYgPLskULutsKTCWT8huuPBX8bWc4kLj7SyhX4oj59W3CLyAIMQV9zUsn/33qZitVm
         RsKQ==
X-Gm-Message-State: AC+VfDx6XpbeRd46LunOk1vZKxPvZoLNAb9kfnHTelUwavAyxb576Mea
	NLdihEuV6Di4kCAlez0xAZJOfQ==
X-Google-Smtp-Source: ACHHUZ5UO/S8nDahmNKq8Vygdbss9quzKdAcp5DFednq7JQ+xTXMbpCVJCWEy9AyLcubMF3PwjgMDw==
X-Received: by 2002:a1c:7713:0:b0:3f6:784:9617 with SMTP id t19-20020a1c7713000000b003f607849617mr5402370wmi.11.1686561895166;
        Mon, 12 Jun 2023 02:24:55 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:a222:bbe9:c688:33ae])
        by smtp.gmail.com with ESMTPSA id p14-20020a7bcc8e000000b003f727764b10sm10892044wma.4.2023.06.12.02.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:24:54 -0700 (PDT)
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
Subject: [PATCH 20/26] dt-bindings: net: qcom,ethqos: add description for sa8775p
Date: Mon, 12 Jun 2023 11:23:49 +0200
Message-Id: <20230612092355.87937-21-brgl@bgdev.pl>
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

Add the compatible for the MAC controller on sa8775p platforms. This MAC
works with a single interrupt so add minItems to the interrupts property.
The fourth clock's name is different here so change it. Enable relevant
PHY properties.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 .../devicetree/bindings/net/qcom,ethqos.yaml       | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
index 60a38044fb19..b20847c275ce 100644
--- a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
@@ -20,6 +20,7 @@ properties:
   compatible:
     enum:
       - qcom,qcs404-ethqos
+      - qcom,sa8775p-ethqos
       - qcom,sc8280xp-ethqos
       - qcom,sm8150-ethqos
 
@@ -32,11 +33,13 @@ properties:
       - const: rgmii
 
   interrupts:
+    minItems: 1
     items:
       - description: Combined signal for various interrupt events
       - description: The interrupt that occurs when Rx exits the LPI state
 
   interrupt-names:
+    minItems: 1
     items:
       - const: macirq
       - const: eth_lpi
@@ -49,11 +52,20 @@ properties:
       - const: stmmaceth
       - const: pclk
       - const: ptp_ref
-      - const: rgmii
+      - enum:
+          - rgmii
+          - phyaux
 
   iommus:
     maxItems: 1
 
+  phys: true
+
+  phy-supply: true
+
+  phy-names:
+    const: serdes
+
 required:
   - compatible
   - clocks
-- 
2.39.2


