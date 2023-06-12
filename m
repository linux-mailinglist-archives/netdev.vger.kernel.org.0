Return-Path: <netdev+bounces-10028-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F96B72BC27
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:25:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 178162810EF
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A05611775A;
	Mon, 12 Jun 2023 09:24:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9514717738
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:24:31 +0000 (UTC)
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C27E41
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:29 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4f62b552751so4636427e87.3
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686561868; x=1689153868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Mia4wdvtEWv/Mc70nqXVtPO13y7zNqSpwQ13vNSfLE=;
        b=W7uLoIKXS7PAmiTERywWDbaMLHABZeojjIbT0BpPdVw/szDoWSLAhsDjiDhXxl4o0B
         N+mM9elzSP3JqtAq5iBMalhVzDLZAT3pgGrA4YH0qnHkzC5chXAFtZOuI8iB8RtRWpUk
         qOX25KL/ZPJsjCHVNrK5xFzMKBouPr39wPrNCJ/B1IYO0a5h4wx7RMpAIK3l/E/UnFKe
         dz6B6SoSKkxozrS8aYGNXN9zhyKDjdGgp5mZXmbuaHnXa5w2D/IMPaqTthkKHu/a1eea
         vPl6cgK054K85I0UCom0Hd9nIDiLDaTWrOXGQNcrNBsVHaU55BET5lMHbubFFmbZ6tzN
         s+SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561868; x=1689153868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Mia4wdvtEWv/Mc70nqXVtPO13y7zNqSpwQ13vNSfLE=;
        b=SRQtz64JymvuGW9kUA4GIPXh/3pTS7m/9gEdAB42QZ3+OEtlTvhEYWjxQiL+IEGR+1
         YyoryMtfyuTBBbvjOQV625O3UTI//y+FuSHuo846pqzpDWPaAVXlfhjptLBG441y12/e
         zO6h39Y/Lf7cRjZm/BCsSlbAE63UG1OgyIEBts+6dojv/9MoHmLv8AHWZrLiHZ2fziB/
         +l63yrP0JbY6barmLzXI6bRA+YtsRhvKiCvfgd9tmfWaaX9SEIAjLlLd8V4XLO4x9WS1
         6+72BkClnJAhp7GfRnyHJNDMoET08Heurk9wL9A7RONylW0HOZyHFZNRwAMOyjqpbaY4
         OiPw==
X-Gm-Message-State: AC+VfDxfmP5wj5kUEnhYTVAA9AS1pqH9T88wGwpQOvPfXsEqmjkYGGDs
	Q0oIXbP5N8a5fq4t8qyqxB6BGQ==
X-Google-Smtp-Source: ACHHUZ7sNkFi76jykx6ZssCKdKti/71IHMljosCZWSu5MIy1k9ySFhWKg0cfjewEgtofPNt8VsdKgQ==
X-Received: by 2002:ac2:464d:0:b0:4f4:c972:981f with SMTP id s13-20020ac2464d000000b004f4c972981fmr4212236lfo.54.1686561868039;
        Mon, 12 Jun 2023 02:24:28 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:a222:bbe9:c688:33ae])
        by smtp.gmail.com with ESMTPSA id p14-20020a7bcc8e000000b003f727764b10sm10892044wma.4.2023.06.12.02.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:24:27 -0700 (PDT)
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
Subject: [PATCH 02/26] dt-bindings: phy: describe the Qualcomm SGMII PHY
Date: Mon, 12 Jun 2023 11:23:31 +0200
Message-Id: <20230612092355.87937-3-brgl@bgdev.pl>
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

Describe the SGMII/SerDes PHY present on the sa8775p platforms.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 .../phy/qcom,sa8775p-dwmac-sgmii-phy.yaml     | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/qcom,sa8775p-dwmac-sgmii-phy.yaml

diff --git a/Documentation/devicetree/bindings/phy/qcom,sa8775p-dwmac-sgmii-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sa8775p-dwmac-sgmii-phy.yaml
new file mode 100644
index 000000000000..ba8d2bee1563
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/qcom,sa8775p-dwmac-sgmii-phy.yaml
@@ -0,0 +1,52 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/qcom,sa8775p-dwmac-sgmii-phy.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm SerDes/SGMII ethernet PHY controller
+
+maintainers:
+  - Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
+
+description:
+  The SerDes PHY sits between the MAC and the external PHY and provides
+  separate Rx Tx lines.
+
+properties:
+  compatible:
+    const: qcom,sa8775p-dwmac-sgmii-phy
+
+  reg:
+    items:
+      - description: serdes
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    const: sgmi_ref
+
+  "#phy-cells":
+    const: 0
+
+additionalProperties: false
+
+required:
+  - compatible
+  - reg
+  - "#phy-cells"
+  - clocks
+  - clock-names
+
+examples:
+  - |
+    #include <dt-bindings/clock/qcom,sa8775p-gcc.h>
+    serdes_phy: phy@8901000 {
+        compatible = "qcom,sa8775p-dwmac-sgmii-phy";
+        reg = <0x08901000 0xe10>;
+        clocks = <&gcc GCC_SGMI_CLKREF_EN>;
+        clock-names = "sgmi_ref";
+        #phy-cells = <0>;
+        status = "disabled";
+    };
-- 
2.39.2


