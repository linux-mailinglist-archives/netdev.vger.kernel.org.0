Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53EE66BA11
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjAPJRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjAPJQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:16:58 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725523C34
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:16:55 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id q8so7691149wmo.5
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uZcDGdNDu8uBNNlcnVM3dW50Ek5FZ0cyrrNZsgY+fPo=;
        b=tiBdYNutIDqslGItdc45uVHMVAntLS/gLDRiamJFHULUDBgNQE9nPaVohFLqvigUy9
         7McONPL/1jEcUYDgNfe9l9Cm9vnaZeO+zYFtyIPp4uBBDy9kH+l9z6AYr8xgTFvfML4/
         Na2znx1Msywlu3lN1SSt4fF4xsXvB7MIy3Yp7h+kne7UybXBJOT8SZOLOLdnyV2g7mxg
         4epo6Qyvqg3a74U2PQYRj5cS+Ci4G5Eh8tkFxoS9epWjk4YrAGOgSyZPIyZ5MoJBy3XF
         491akUDHbx0qMEl1cfXTLp6HLPLWEXQNFzDp+RTU39f0Em6p5aOWIUqs0DsofEiH26cA
         zqzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uZcDGdNDu8uBNNlcnVM3dW50Ek5FZ0cyrrNZsgY+fPo=;
        b=2OSCobBKpY3A6+A8kci74sPzSMS81wRKIs0jViejxoUOj/Kx/3V9GmhWJegLqd1p5F
         zVaHhEBUDpZfPA/H4E/nEZtwweEudhtKzR9r/9Vf5Z9yf6izEvCwjrMdP4+qxLMLFo/H
         mIiEO9WlosOTv6zr59mY4V2oJLYwjdb/G+/AnK8y687GSE/ARdzLBbyYC28jQz5Hvyns
         mv6eKPlMUg4Tvj8CI4Cn1DqAiljq79RtRQEXYOSoFaS1VtFhfRUcQBmrvRjEw4fxHIAT
         2gLrdb+xH0ISZc9e7tyt2BcKFbP2F4h+a1szCELrXOyG+dMgyjVId1zI+Ib29YUl+/Zv
         UWNA==
X-Gm-Message-State: AFqh2koO86FTEqIR0bQTi4Vj6KgVgSb4iLOD5sgdQs1YyxIrU2N+sQDK
        IXwxkRYiVcTrgEyfxlrx0JxKWuZZy1bH5Nxy
X-Google-Smtp-Source: AMrXdXuCRbQg8NS8SJ1exUq8lAx/EQMg8yYbu3RqREsEePTCo6eu0cvE+Pv0cEA/0u11FEGbaltV6Q==
X-Received: by 2002:a05:600c:358f:b0:3d1:cdf7:debf with SMTP id p15-20020a05600c358f00b003d1cdf7debfmr68091704wmq.26.1673860615046;
        Mon, 16 Jan 2023 01:16:55 -0800 (PST)
Received: from localhost.localdomain (82-65-169-74.subs.proxad.net. [82.65.169.74])
        by smtp.googlemail.com with ESMTPSA id h19-20020a05600c351300b003d9a86a13bfsm35923491wmq.28.2023.01.16.01.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 01:16:54 -0800 (PST)
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] dt-bindings: net: add amlogic gxl mdio multiplexer
Date:   Mon, 16 Jan 2023 10:16:35 +0100
Message-Id: <20230116091637.272923-2-jbrunet@baylibre.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116091637.272923-1-jbrunet@baylibre.com>
References: <20230116091637.272923-1-jbrunet@baylibre.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for the MDIO bus multiplexer found on the Amlogic GXL
SoC family

Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
---
 .../bindings/net/amlogic,gxl-mdio-mux.yaml    | 64 +++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/amlogic,gxl-mdio-mux.yaml

diff --git a/Documentation/devicetree/bindings/net/amlogic,gxl-mdio-mux.yaml b/Documentation/devicetree/bindings/net/amlogic,gxl-mdio-mux.yaml
new file mode 100644
index 000000000000..d21bce695fa9
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/amlogic,gxl-mdio-mux.yaml
@@ -0,0 +1,64 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/amlogic,gxl-mdio-mux.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Amlogic GXL MDIO bus multiplexer
+
+maintainers:
+  - Jerome Brunet <jbrunet@baylibre.com>
+
+description:
+  This is a special case of a MDIO bus multiplexer. It allows to choose between
+  the internal mdio bus leading to the embedded 10/100 PHY or the external
+  MDIO bus on the Amlogic GXL SoC family.
+
+allOf:
+  - $ref: mdio-mux.yaml#
+
+properties:
+  compatible:
+    const: amlogic,gxl-mdio-mux
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: ref
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    eth_phy_mux: mdio@558 {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      compatible = "amlogic,gxl-mdio-mux";
+      clocks = <&refclk>;
+      clock-names = "ref";
+      reg = <0x558 0xc>;
+      mdio-parent-bus = <&mdio0>;
+
+      external_mdio: mdio@0 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        reg = <0x0>;
+      };
+
+      internal_mdio: mdio@1 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        reg = <0x1>;
+      };
+    };
-- 
2.39.0

